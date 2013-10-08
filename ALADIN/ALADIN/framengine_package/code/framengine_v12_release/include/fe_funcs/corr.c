#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <memory.h>
#include <mex.h>

/*----------------------------------------------------------------------------*/
static double xcorr(
  const double *x,
  const double *y,
  const int    vlen)
{int    i   = vlen;
 double sum1 = 0.0;
 double sum2 = 0.0;
 double sum3 = 0.0;
 /**/
 while((i-=3) >= 0)
  {sum1 += x[0]*y[0];
   sum2 += x[1]*y[1];
   sum3 += x[2]*y[2];
   x += 3;
   y += 3;
  }
 sum1 += sum2+sum3;
 if((i+=3))
  {do
    {sum1 += (*x++)*(*y++);
    } while(--i>0);
  }
 return(sum1);
}


/*----------------------------------------------------------------------------*/
void mexFunction(int nargout,mxArray *ptrout[],int nargin,const mxArray *ptrin[])
{int    vlen,nvec,ncorr;
 double *x,*y,*c,*z;
 /**/
 /* Check for proper number of arguments */
 if((nargin!=3) || (nargout>1))
  {mexErrMsgTxt("Bad number of arguments, check help function.\n");
   return;
  } 
 /* Check vector length and nr. of vectors */
 if((vlen=mxGetM(ptrin[0])) != mxGetM(ptrin[1]))
  {mexErrMsgTxt("Both input vectors have to have the same length.\n");
   return;
  }
 if(((nvec=mxGetN(ptrin[0]))!=mxGetN(ptrin[1])) && (mxGetN(ptrin[1])!=1))
  {mexErrMsgTxt("Both input matrices must contain an equal number of vectors\n");
   return;
  }
 /* allocate memory for destination matrix */
 ncorr = mxGetM(ptrin[2])*mxGetN(ptrin[2]);
 ptrout[0] = mxCreateDoubleMatrix(ncorr,nvec,mxREAL);
 x = mxGetPr(ptrin[0]);
 y = mxGetPr(ptrin[1]);
 c = mxGetPr(ptrin[2]);
 z = mxGetPr(ptrout[0]);
 while(--nvec >= 0)
  {int i;
   for(i=0;i<ncorr;++i)
    {int j = c[i];
     *z++ = (j>=0) ? xcorr(x,y+j,vlen-j) : xcorr(x-j,y,vlen+j);
    }
   x += vlen;
   if(mxGetN(ptrin[1]) != 1)
     y += vlen;
  }
}
