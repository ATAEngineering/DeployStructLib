#include "VectorCalcs.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define DEBUG 0

double VectorLength(double v[3])
{
	double ret=0;
	int i;

	for(i=0;i<3;i++){
		ret += v[i]*v[i];
	}

	return sqrt(ret);

}

void cA(double* C, double c, double* A, int n)
{

    double* pA=A;
    double* pC=C;
	int i;
    for(i=0;i<n*n;i++,pA++,pC++){
        *pC=c*(*pA);
    }
}

void cAinline(double c, double* A, int n)
{

    double* pA=A;
	int i;
    for(i=0;i<n*n;i++,pA++){
        *pA=c*(*pA);
    }

}

void Av(double* v2, double* A, double* v, int n, int m)
{
  int i,j;
  for(i=0;i<m;i++){
    v2[i] = 0.0;
    for(j=0;j<n;j++){
      v2[i] += A[n*i + j] * v[j];
    }
  }
}

void ATv(double* v2, double* A, double* v, int n, int m)
{
  int i,j;
  for (i=0;i<m;i++){
    v2[i] = 0.0;
    for(j=0;j<n;j++){
      v2[i] += A[3*j+i] * v[j];
    }
  }
}


void AB(double* C, double* A, double* B, int n)
{
#if DEBUG
    printf("at AB\n");
#endif

    double* pA=A;
    double* pB=B;
    double* pC=C;
	int i,j,k;
	for(i=0;i<n;i++){
		for(j=0;j<n;j++,pC++){
        	    pA=&A[n*i];
	            pB=&B[j];
        	    *pC=0.0;
	            for (k = 0; k < n; k++,pA++,pB+=n) {
        	        *pC += (*pA)*(*pB);
#if DEBUG
	                printf("%e+=%e*%e\n",*pC,*pA,*pB);
#endif
		    }
#if DEBUG
        	    printf("A[%d][%d]=%e\n",i,j,A[i*n+j]);
		    printf("B[%d][%d]=%e\n",i,j,B[i*n+j]);
	            printf("C[%d][%d]=%e\n",i,j,C[i*n+j]);
#endif
		}
	}
}

void ATB(double* C, double* A, double* B, int n)
{
#if DEBUG
    printf("at ATB\n");
#endif
    double* pA=A;
    double* pB=B;
    double* pC=C;
	int i,j,k;
	for(i=0;i<n;i++){
		for(j=0;j<n;j++,pC++){
            pA=&A[i];
            pB=&B[j];
            *pC=0.0;
            for (k = 0; k < n; k++,pA+=n,pB+=n) {
                *pC += (*pA)*(*pB);
#if DEBUG
                printf("%e+=%e*%e\n",*pC,*pA,*pB);
#endif
            }
#if DEBUG
            printf("A[%d][%d]=%e\n",i,j,A[i*n+j]);
            printf("B[%d][%d]=%e\n",i,j,B[i*n+j]);
            printf("C[%d][%d]=%e\n",i,j,C[i*n+j]);
#endif
		}
	}
}

void BTAB(double* C, double* A, double* B, int n)
{
	double* D;

	D = newMat(n);
	AB(D, A, B, n);
	ATB(C, B, D, n);
	deleteMat(D);
}


void cBTAB(double* C, double c, double* A, double* B, int n)
{
	BTAB(C, A, B, n);
	cAinline(c, C, n);
}

double* newMat(int n)
{
    double* A = (double*)malloc(n*n*sizeof(double*));
	return A;
}

void deleteMat(double* A)
{
    free(A);
}
