/*
V = spprod(W,H,I,J)
% selected entries from a full matrix product

for k=1:length(I),
  V(I(k),J(k)) = W(I(k),:)*H(:,J(k));
end
*/

#include <math.h>
#include <stdint.h>
#include <float.h>
#include "matrix.h"

void mexFunction(
  int           nlhs,
  mxArray       *plhs[],
  int           nrhs,
  const mxArray	*prhs[])
{double	      *pv;
 const double *pi,*pj,*pw,*ph;
 uintptr_t    N, Wrow, Wcol, Hcol;	/* should be mwSize, but Matlab switches signed between 32/64 platforms according to their dcumentation, and we can't have that */
 /* Check for proper number of arguments */
 if((nrhs!=4) || (nlhs!=1))
   mexErrMsgTxt("spprod requires four input arguments and one output argument: V=spprod(W,H,I,J).");
 /* get/check everything we need for matrix W */
  {const mxArray *W = prhs[0];
   Wrow = mxGetM(W);
   Wcol = mxGetN(W);
   pw   = mxGetPr(W);
  }
 /* get/check everything we need of matrix H */
  {const mxArray *H = prhs[1];
   if(mxGetM(H) != Wcol)
     mexErrMsgTxt("W and H must have a common dimension.");
   Hcol = mxGetN(H);
   ph = mxGetPr(H);
  }
 /* get/check everything we need of matrix I */
  {const mxArray *I = prhs[2];
   N = mxGetM(I)*mxGetN(I);
   pi = mxGetPr(I);
  }
 /* get/check everything we need of matrix J */
  {const mxArray *J = prhs[3];
   if(mxGetM(J)*mxGetN(J) != N)
     mexErrMsgTxt("I and J must have the same size.");
   pj = mxGetPr(J);
  }
 /* allocate result matrix */
  {mxArray *V = mxCreateDoubleMatrix(N,1,mxREAL);
   plhs[0] = V;
   pv = mxGetPr(V);
  }
 /* and now the actual work */
  {uintptr_t i;
   for(i=0;i<N;i++)
    {uintptr_t j;
     double sum;
     const double *pwi,*phj;
     if((j=((intptr_t)pi[i])-1) >= Wrow)
       mexErrMsgTxt("Index I[.] out of bounds.");
     pwi = pw + j;
     if((j=((intptr_t)pj[i])-1) >= Hcol)
       mexErrMsgTxt("Index J[.] out of bounds.");
     phj = ph + j*Wcol;
     sum = 0.0;
     for(j=0;j<Wcol;j++)
      {sum += pwi[0] * phj[j];
       pwi += Wrow;
      }
     pv[i] = sum;
    }
  }
}
