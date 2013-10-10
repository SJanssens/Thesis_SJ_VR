#include "mex.h"
#include <math.h>
#include <stdint.h>
#include <float.h>
#include "matrix.h"
#include "pthread.h"

#define NUM_THREADS 16

struct thread_data
{
	uintptr_t start;
	uintptr_t finish;
	uintptr_t M;
	uintptr_t N;
	uintptr_t R;
	double *a;
	double *b;
	double* result;
};

void *do_the_work1(void *t_arg);
void *do_the_work2(void *t_arg);

void mexFunction(int nlhs, mxArray** plhs, int nrhs, const mxArray** prhs)
{
	/*
	 * prhs[0] = a
	 * prhs[1] = b
	 */

	double *a_pr = mxGetPr(prhs[0]);
	uintptr_t R = mxGetM(prhs[0]);
	uintptr_t M = mxGetN(prhs[0]);
	double *b_pr = mxGetPr(prhs[1]);
	uintptr_t N = mxGetN(prhs[1]);
	if(mxGetM(prhs[1])!=R) mexErrMsgTxt("Dimension mismatch!");

	uintptr_t i=0;
	uintptr_t num_threads = NUM_THREADS;
	uintptr_t nt = 0;
	if(M>=N)
	{
		/*split up a_pr*/
		nt = (uintptr_t) M/NUM_THREADS;
		while(nt==0) 
		{
			num_threads--;
			nt = (uintptr_t) M/num_threads;
		}
	}
	else
	{
		/*split up b_pr*/
		nt = (uintptr_t) N/NUM_THREADS;
		while(nt==0) 
		{
			num_threads--;
			nt = (uintptr_t) N/num_threads;
		}
	}

	pthread_t threads[num_threads];
	pthread_attr_t attr;
	int rc=0;
	void *status;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_JOINABLE);

	plhs[0]=mxCreateDoubleMatrix(N,M,mxREAL);
	double* result = mxGetPr(plhs[0]);

	struct thread_data arguments[num_threads];
	for(i=0;i<num_threads;i++)
	{
		arguments[i].start = i*nt;
		arguments[i].a = a_pr;
		arguments[i].b = b_pr;
		arguments[i].M = M;
		arguments[i].N = N;
		arguments[i].R = R;
		arguments[i].result = result;
		if(M>=N)
		{
			arguments[i].finish = (i<num_threads-1)?((i+1)*nt):(M);
			/*do_the_work1((void*) &arguments[i]);*/
			rc=pthread_create(&threads[i],&attr,do_the_work1,(void*) &arguments[i]);
		}
		else
		{
			arguments[i].finish = (i<num_threads-1)?((i+1)*nt):(N);
			/*do_the_work2((void*) &arguments[i]);*/
			rc=pthread_create(&threads[i],&attr,do_the_work2,(void*) &arguments[i]);
		}
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
}

void *do_the_work1(void *t_arg)
{
	/*a is split up*/
	struct thread_data *in = (struct thread_data*) t_arg;
	int i=0,j=0,k=0;
	uintptr_t start = in->start;
	uintptr_t finish = in->finish;
	uintptr_t M = in->M;
	uintptr_t N = in->N;
	uintptr_t R = in->R;
	double *result = in->result;
	double *a = in->a;
	double *b = in->b;

	double *p3=&(result[start*N]);
	double *p1=&(a[start*R]);
	for(j=start;j<finish;j++,p1+=R)
	{
		double *p2=b;
		for(i=0;i<N;i++,p3++)
		{
			double *p4=p1;
			*p3=0;
			for(k=0;k<R;k++,p2++,p4++)
			{
				*p3+=(*p2-*p4)*(*p2-*p4);
			}
		}
	}
	pthread_exit(NULL);
}

void *do_the_work2(void *t_arg)
{
	/*b is split up*/
	struct thread_data *in = (struct thread_data*) t_arg;
	int i=0,j=0,k=0;
	uintptr_t start = in->start;
	uintptr_t finish = in->finish;
	uintptr_t M = in->M;
	uintptr_t N = in->N;
	uintptr_t R = in->R;
	double *result = in->result;
	double *a = in->a;
	double *b = in->b;

	double *p1=a;
	double *p4=&(result[start]);
	for(j=0;j<M;j++,p1+=R,p4+=N)
	{
		double *p5=p4;
		double *p3=&(b[start*R]);
		for(i=start;i<finish;i++,p5++)
		{
			double *p2=p1;
			(*p5)=0;
			for(k=0;k<R;k++,p3++,p2++)
			{
				(*p5)+=(*p3-*p2)*(*p3-*p2);
			}
		}
		/*p5=p4;*/
	}

	pthread_exit(NULL);
}
