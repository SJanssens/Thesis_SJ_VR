#include "mex.h"
#include "matrix.h"
#include <math.h>
#include <string.h>
#include "pthread.h"
#include <stdint.h>

#define NUM_THREADS 16

struct thread_data
{
	mwIndex start;
	mwIndex finish;
	mwSize R;
	mwIndex* V_ir;
	mwIndex* V_jc;
	double* V_pr;
	double* H_pr;
	double* WT_pr;
	double* result;
	double b;
};

mxArray* transpose(const mxArray* input);
void *do_the_work(void *t_arg);

void mexFunction(int nlhs, mxArray** plhs, int nrhs, const mxArray** prhs)
{
	/*
	 * prhs[0] = V: a sparse matrix of dimension MxN
	 * prhs[1] = W: a full matrix of dimension MxR
	 * prhs[2] = H: a full matrix of dimension RxN
	 * prhs[3] = b: a scalar
	 */
	const mxArray* V = prhs[0];
	if(!mxIsSparse(V)) mexErrMsgTxt("V-matrix should be sparse!");
	const mxArray* W = prhs[1];
	if(mxIsSparse(W)) mexErrMsgTxt("W-matrix should be full!");
	mxArray* WT = transpose(W);
	const mxArray* H = prhs[2];
	if(mxIsSparse(H)) mexErrMsgTxt("H-matrix should be full!");
	double b=0;
	if(nrhs>=4) b=mxGetScalar(prhs[3]);
	double* V_pr = mxGetPr(V);
	mwIndex* V_ir = mxGetIr(V);
	mwIndex* V_jc = mxGetJc(V);
	double* WT_pr = mxGetPr(WT);
	double* H_pr = mxGetPr(H);
	mwSize N = mxGetN(V);
	mwSize R = mxGetN(W);

	nlhs = 1;
	plhs[0] = mxCreateDoubleMatrix(R,N,mxREAL);
	double* result = mxGetPr(plhs[0]);
	for(uintptr_t k=0;k<N*R;k++) result[k]=0;

	uintptr_t i=0;
	uintptr_t num_threads = NUM_THREADS;
	uintptr_t nt = (uintptr_t) N/NUM_THREADS;
	while(nt==0) 
	{
		num_threads--;
		nt = (uintptr_t) N/num_threads;
	}
	pthread_t threads[num_threads];
	pthread_attr_t attr;
	int rc=0;
	void *status;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_JOINABLE);

	struct thread_data arguments[num_threads];
	for(i=0;i<num_threads;i++)
	{
		arguments[i].start = i*nt;
		arguments[i].finish = (i<num_threads-1)?((i+1)*nt):(N);
		arguments[i].R = R;
		arguments[i].V_ir = V_ir;
		arguments[i].V_jc = V_jc;
		arguments[i].V_pr = V_pr;
		arguments[i].H_pr = H_pr;
		arguments[i].WT_pr = WT_pr;
		arguments[i].result = result;
		arguments[i].b = b;
		/*do_the_work((void*) &arguments[i]);*/
		rc=pthread_create(&threads[i],&attr,do_the_work,(void*) &arguments[i]);
		if(rc)
		{
			printf("ERROR: return code from pthread_create() is %d\n",rc);
			exit(-1);
		}
	}
	pthread_attr_destroy(&attr);
	for(i=0;i<num_threads;i++)
	{
		rc = pthread_join(threads[i],&status);
		if(rc)
		{
			printf("ERROR: return code from pthread_join() is %d\n", rc);
			exit(-1);
		}
	}

	mxDestroyArray(WT);
}

void *do_the_work(void *t_arg)
{
	struct thread_data* in = (struct thread_data*) t_arg;
	uintptr_t i=0,k=0;

	double *pt1 = &(in->H_pr[in->start*in->R]);
	double *pt2 = &(in->result[in->start*in->R]);
	for(i=in->start;i<in->finish;i++,pt1+=in->R,pt2+=in->R)
	{
		for(k=in->V_jc[i];k<in->V_jc[i+1];k++)
		{
			double *pt3 = &(in->WT_pr[in->R*in->V_ir[k]]);
			double temp=0;
			for(uintptr_t l=0;l<in->R;l++) temp+=pt3[l]*pt1[l];
			for(uintptr_t l=0;l<in->R;l++) pt2[l]+=pt3[l]*in->V_pr[k]/temp;
		}
		for(uintptr_t l=0; l<in->R; l++) pt2[l]=(pt2[l]-in->b)*pt1[l];
	}
	pthread_exit(NULL);
}

mxArray* transpose(const mxArray* input)
{
	/*
	 * Apparently, this is the fastest way of transposing 
	 * this sparse matrix
	 */
	mxArray *rhs[1],*lhs[1];
	rhs[0] = input;
	mexCallMATLAB(1,lhs,1,rhs,"transpose");
	return lhs[0];
}
