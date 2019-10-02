#include "ModelicaUtilities.h"
#include "math.h"
#include "stdio.h"
#include "VectorCalcs.h"


#define BUFFSIZE 1024

void linspace(double a, double b, int n, double* ret)
{
  double jmp = (b-a)/(double)(n-1);
  for(int i=0;i<n;i++){
    ret[i] = a + i*jmp;
  }
}

double length(double* v)
{
  double ret = v[0]*v[0] + v[1]*v[1] + v[2]*v[2];
  return sqrt(ret);
}

void zeros(int m, int n, double* mat)
{
  for(int i=0;i<m;i++){
    for(int j=0;j<n;j++){
      mat[j*m+i] = 0.0;
    }
  }
}

void cross(double* vec1, double* vec2, double* ret)
{
  ret[0] = vec1[1] * vec2[2] - vec2[1] * vec1[2];
  ret[1] = vec1[0] * vec2[2] - vec2[0] * vec1[2];
  ret[2] = vec1[0] * vec2[1] - vec2[0] * vec1[1];
}

void axisRotation(double* T, int axis, double angle)
{
  zeros(3, 3, T);
  if (axis == 1){
    T[0] = 1;
    T[4] = cos(angle);
    T[5] = sin(angle);
    T[7] = -sin(angle);
    T[8] = cos(angle);
  }else if (axis == 2){
    T[0] = cos(angle);
    T[2] = -sin(angle);
    T[4] = 1;
    T[6] = sin(angle);
    T[8] = cos(angle);
  }else if (axis == 3){
    T[0] = cos(angle);
    T[1] = sin(angle);
    T[3] = -sin(angle);
    T[4] = cos(angle);
    T[8] = 1;
  }
}

void axesRotation(double* T, const int* sequence, const double* angles)
{
  double rot3[3*3];
  double rot2[3*3];
  double rot1[3*3];
  
  axisRotation(rot3, sequence[2], angles[2]);
  axisRotation(rot2, sequence[1], angles[1]);
  axisRotation(rot1, sequence[0], angles[0]);

  double tmp[3*3];
  AB(tmp, rot3, rot2, 3);
  AB(T, tmp, rot1, 3);
}


void CoonsPatch(const double* P1, const double* P2, const double* P3, const double* P4, double s, double t, int debug, double* pos)
{
  pos[0] = P1[0] * (1-s) * (1-t) + P2[0] * (1 - s) * t + P4[0] * s * (1 - t) + P3[0] * s * t;
  pos[1] = P1[1] * (1-s) * (1-t) + P2[1] * (1 - s) * t + P4[1] * s * (1 - t) + P3[1] * s * t;
  pos[2] = P1[2] * (1-s) * (1-t) + P2[2] * (1 - s) * t + P4[2] * s * (1 - t) + P3[2] * s * t;
  if(debug){
    char msg[BUFFSIZE];
    sprintf(msg, "pos = {%g,%g,%g}\n",pos[0],pos[1],pos[2]);
    ModelicaMessage(msg);
    sprintf(msg, "s=%g, t=%g\n", s, t);
    ModelicaMessage(msg);
  }
}

void Cloth_NatQuad_Init(int M,int N,double E,double G,double nu,double thickness,const double* P1,double* P2,const double* P3,const double* P4,const double* P1_loc,const double* ref_angles,const double* P1_start,const double* P2_start,const double* P3_start,const double* P4_start,int debug,double* Kq)
{

  double s[M + 1];
  double t[N + 1];
  double N1[3], N2[3], N3[3], N4[3];
  double V12[3];
  double V23[3];
  double V34[3];
  double V41[3];
  double V13[3];
  double V24[3];
  double P12[3];
  double P23[3];
  double P31[3];
  double P21[3];
  double P32[3];
  double P13[3];
  double L1;
  double L2;
  double L3;
  double Emat[3*3];
  double Te[3*3];
  double En[3*3];
  double Be[3*6];
  double Bq[3*3];
  double sa, A;
  double Qd[3*6] = {0, 0, -1, 0, 0, 1, 0, 1, 0, 0, -1, 0, -1, 0, 0, 1, 0, 0};
  double Td[6*6];
  double c1, s1, c2, s2, c3, s3;
  double nu1;
  double Kqtmp1[3*3];
  double Kqtmp2[6*6];
  double L[6];
  int ind[3];
  double tmp;
  
  zeros(3, 6, Be);
  zeros(3, 3, Bq);

  linspace(0.0, 1.0, M + 1, s);
  linspace(0.0, 1.0, N + 1, t);
  if(nu < 0.0){
    if(G < 0.0){
      ModelicaMessage("Either G or nu must be defined and > 0 in cloth properties, assuming a value of nu=0.3");
      nu1 = 0.3;
    }else{
      nu1 = E / 2.0 / G - 1.0;
    }
  }else{
    nu1 = nu;
  }
  //
  // Assumes N1[3]=N2[3]=N3[3]=0
  //   Can be generalized by projecting N1,N2,N3 onto a plane and fixing calculation of Te
  tmp = E / (1.0 - nu1*nu1);
  Emat[0] = tmp;
  Emat[1] = tmp * nu1;
  Emat[2] = 0.0;
  Emat[3] = tmp * nu1;
  Emat[4] = tmp;
  Emat[5] = 0.0;
  Emat[6] = 0.0;
  Emat[7] = 0.0;
  Emat[8] = tmp * (1.0 - nu1) / 2.0;
  // Loop over each element
  for(int j=0;j<N;j++){
    for(int i=0;i<M;i++){
      zeros(6, 6, Kqtmp2);
      CoonsPatch(P1, P2, P3, P4, s[i], t[j], 0, N1);
      CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j], 0, N2);
      CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j + 1], 0, N3);
      CoonsPatch(P1, P2, P3, P4, s[i], t[j + 1], 0, N4);
      for(int k=0;k<3;k++){
        V12[k] = N1[k] - N2[k];
        V23[k] = N2[k] - N3[k];
        V34[k] = N3[k] - N4[k];
        V41[k] = N4[k] - N1[k];
        V13[k] = N1[k] - N3[k];
        V24[k] = N2[k] - N4[k];
      }
      L[0] = length(V12);
      L[1] = length(V23);
      L[2] = length(V34);
      L[3] = length(V41);
      L[4] = length(V13);
      L[5] = length(V24);
      for(int index=1; index < 5; index++){
        if(index == 1){
          ind[0] = 5;
          ind[1] = 3;
          ind[2] = 0;
          P12[0] = V12[0];
          P12[1] = V12[1];
          P12[2] = V12[2];
          P23[0] = V24[0];
          P23[1] = V24[1];
          P23[2] = V24[2];
          P31[0] = V41[0];
          P31[1] = V41[1];
          P31[2] = V41[2];
        }else if(index == 2){
          ind[0] = 4;
          ind[1] = 2;
          ind[2] = 3;
          P12[0] = V41[0];
          P12[1] = V41[1];
          P12[2] = V41[2];
          P23[0] = V13[0];
          P23[1] = V13[1];
          P23[2] = V13[2];
          P31[0] = V34[0];
          P31[1] = V34[1];
          P31[2] = V34[2];
        }else if(index == 3){
          ind[0] = 5;
          ind[1] = 1;
          ind[2] = 2;
          P12[0] = V34[0];
          P12[1] = V34[1];
          P12[2] = V34[2];
          P23[0] = -V24[0];
          P23[1] = -V24[1];
          P23[2] = -V24[2];
          P31[0] = V23[0];
          P31[1] = V23[1];
          P31[2] = V23[2];
	}else if(index == 4){
          ind[0] = 4;
          ind[1] = 0;
          ind[2] = 1;
          P12[0] = V23[0];
          P12[1] = V23[1];
          P12[2] = V23[2];
          P23[0] = -V13[0];
          P23[1] = -V13[1];
          P23[2] = -V13[2];
          P31[0] = V12[0];
          P31[1] = V12[1];
          P31[2] = V12[2];
        }
        L1 = L[ind[0]];
        L2 = L[ind[1]];
        L3 = L[ind[2]];
        P21[0] = -P12[0];
        P21[1] = -P12[1];
        P21[2] = -P12[2];
        P32[0] = -P23[0];
        P32[1] = -P23[1];
        P32[2] = -P23[2];
        P13[0] = -P31[0];
        P13[1] = -P31[1];
        P13[2] = -P31[2];
        sa = (L1 + L2 + L3) / 2.0;
        A = sqrt(sa * (sa - L1) * (sa - L2) * (sa - L3));
        c1 = P32[0] / L1;
        s1 = P32[1] / L1;
        c2 = P13[0] / L2;
        s2 = P13[1] / L2;
        c3 = P21[0] / L3;
        s3 = P21[1] / L3;
        zeros(6, 6, Td);
	Td[0] = c3;
	Td[1] = s3;
	Td[6] = c2;
	Td[7] = s2;
	Td[14] = c1;
	Td[15] = s1;
	Td[20] = c3;
	Td[21] = s3;
	Td[28] = c2;
	Td[29] = s2;
	Td[34] = c1;
	Td[35] = s1;
	tmp = 0.25 / A / A;
	Te[0] = P31[1] * P21[1] * L1 * L1 * tmp;
	Te[1] = P12[1] * P32[1] * L2 * L2 * tmp;
	Te[2] = P23[1] * P13[1] * L3 * L3 * tmp;
	Te[3] = P31[0] * P21[0] * L1 * L1 * tmp;
	Te[4] = P12[0] * P32[0] * L2 * L2 * tmp;
	Te[5] = P23[0] * P13[0] * L3 * L3 * tmp;
	Te[6] = (P31[1] * P12[0] + P13[0] * P21[1]) * L1 * L1 * tmp;
        Te[7] = (P12[1] * P23[0] + P21[0] * P32[1]) * L2 * L2 * tmp;
	Te[8] = (P23[1] * P31[0] + P32[0] * P13[1]) * L3 * L3 * tmp;

        //En = transpose(Te) * Emat * Te;
	BTAB(En, Emat, Te, 3);

	Be[2] = -1.0 / L3;
	Be[4] = 1.0 / L2;
	Be[6] = -1.0 / L1;
	Be[11] = 1.0 / L3;
	Be[13] = -1.0 / L2;
	Be[17] = 1.0 / L1;

        //Bq = {{1 / L1, 0, 0}, {0, 1 / L2, 0}, {0, 0, 1 / L3}};
	Bq[0] = 1.0 / L1;
	Bq[4] = 1.0 / L2;
	Bq[8] = 1.0 / L3;

        //Kqtmp1[:, :] = A * thickness / 2 * transpose(Bq) * En * Bq;
	cBTAB(Kqtmp1, A * thickness / 2.0, En, Bq, 3);

        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
            Kqtmp2[6*ind[ii] + ind[jj]] += Kqtmp1[3*ii + jj];
          }
        }
      }
      for(int ii=0;ii<6;ii++){
        for(int jj=0;jj<6;jj++){
          Kq[6*10*N*i + 6*10*j + 10*ii + jj] = Kqtmp2[6*ii + jj];
        }
      }
      for(int ii=0;ii<6;ii++){
        Kq[6*10*N*i + 6*10*j + 10*ii + 6] = L[ii];
      }
      CoonsPatch(P1_start, P2_start, P3_start, P4_start, s[i], t[j], 0, N1);
      CoonsPatch(P1_start, P2_start, P3_start, P4_start, s[i + 1], t[j], 0, N2);
      CoonsPatch(P1_start, P2_start, P3_start, P4_start, s[i + 1], t[j + 1], 0, N3);
      CoonsPatch(P1_start, P2_start, P3_start, P4_start, s[i], t[j + 1], 0, N4);
      V12[0] = N1[0] - N2[0];
      V12[1] = N1[1] - N2[1];
      V12[2] = N1[2] - N2[2];
      V23[0] = N2[0] - N3[0];
      V23[1] = N2[1] - N3[1];
      V23[2] = N2[2] - N3[2];
      V34[0] = N3[0] - N4[0];
      V34[1] = N3[1] - N4[1];
      V34[2] = N3[2] - N4[2];
      V41[0] = N4[0] - N1[0];
      V41[1] = N4[1] - N1[1];
      V41[2] = N4[2] - N1[2];
      V13[0] = N1[0] - N3[0];
      V13[1] = N1[1] - N3[1];
      V13[2] = N1[2] - N3[2];
      V24[0] = N2[0] - N4[0];
      V24[1] = N2[1] - N4[1];
      V24[2] = N2[2] - N4[2];
      for(int ii=0;ii<3;ii++){
        Kq[6*10*N*i + 6*10*j + 10*ii + 7] = V12[ii];
        Kq[6*10*N*i + 6*10*j + 10*ii + 8] = V34[ii];
        Kq[6*10*N*i + 6*10*j + 10*ii + 9] = V13[ii];
      }
      for(int ii=0;ii<3;ii++){
        Kq[6*10*N*i + 6*10*j + 10*(ii+3) + 7] = V23[ii];
        Kq[6*10*N*i + 6*10*j + 10*(ii+3) + 8] = V41[ii];
        Kq[6*10*N*i + 6*10*j + 10*(ii+3) + 9] = V24[ii];
      }
      
      if(debug){
	char msg[BUFFSIZE];
	sprintf(msg, "\nM=%d, N=%d\nA=%g\nE=%g\nnu=%g\nthickness=%g\n",i,j,A,E,nu1,thickness);
        //print("\n");
        //print("M=" + String(i) + ", N=" + String(j));
        //print("A=" + String(A));
        //print("E=" + String(E));
        //print("nu=" + String(nu1));
        //print("thickness=" + String(thickness));
	ModelicaMessage(msg);
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
	    sprintf(msg, "En[%d,%d]=%g\n",ii,jj,En[3*ii+jj]);
	    ModelicaMessage(msg);
            //print("En[" + String(ii) + "," + String(jj) + "]=" + String(En[ii, jj]));
          }
        }
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
	    sprintf(msg, "Te[%d,%d]=%g\n",ii,jj,Te[3*ii+jj]);
	    ModelicaMessage(msg);
            //print("Te[" + String(ii) + "," + String(jj) + "]=" + String(Te[ii, jj]));
          }
        }
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
	    sprintf(msg, "Bq[%d,%d]=%g\n",ii,jj,Bq[3*ii+jj]);
	    ModelicaMessage(msg);
            //print("Bq[" + String(ii) + "," + String(jj) + "]=" + String(Bq[ii, jj]));
          }
        }
        for(int ii=0;ii<6;ii++){
          for(int jj=0;jj<6;jj++){
	    sprintf(msg, "Td[%d,%d]=%g\n",ii,jj,Td[6*ii+jj]);
	    ModelicaMessage(msg);
            //print("Td[" + String(ii) + "," + String(jj) + "]=" + String(Td[ii, jj]));
          }
        }
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
	    sprintf(msg, "Kq[%d,%d]=%g\n",ii,jj,Kq[6*10*N*i + 6*10*j + 10*ii + jj]);
	    ModelicaMessage(msg);
            //print("Kq[" + String(ii) + "," + String(jj) + "]=" + String(Kq[i, j, ii, jj]));
          }
        }
      }
    }
  }
}


void Cloth_MassLoc_Flat_Init(int M,int N,double* P1_start,double* P2_start,double* P3_start,double* P4_start,int M_act,int isEdge,int isEdgeB,int debug,double* A)
{
  double s[M+1];
  double t[N+1];
  int Mm;
  double B[(M + 1)*(N + 1)*3];
  double tmp[3];
  //
  linspace(0, 1, M + 1, s);
  linspace(0, 1, N + 1, t);

  // Find approximate locations
  //  for j in 1:N + 1 loop
  //  for i in 1:M + 1 loop
  for(int j=0;j<N+1;j++){
    for(int i=0;i<M+1;i++){
	CoonsPatch(P1_start, P2_start, P3_start, P4_start, s[i], t[j], 0, tmp);
	for(int ii=0;ii<3;ii++){
	  B[i*(N+1)*3 + j*3 + ii] = tmp[ii];
	}
      
        if (debug){
	  char msg[BUFFSIZE];
	  sprintf(msg, "B[%d,%d]={%g,%g,%g}\n",i,j,B[i*(N+1)*3 + j*3 + 0],B[i*(N+1)*3 + j*3 + 1],B[i*(N+1)*3 + j*3 + 2]);
//print("B[" + String(i - 1) + "," + String(j) + "]={" + String(B[i - 1, j, 1]) + "," + String(B[i - 1, j, 2]) + "," + String(B[i - 1, j, 3]) + "}" + "\n");
	  ModelicaMessage(msg);
	}
     
    }
  }
  //  for j in 1:N + 1 loop
  for(int j=0;j<N+1;j++){
    if (isEdge){
      if (!isEdgeB){
	for(int ii=0;ii<3;ii++){
	  A[j*3 + ii] = B[j*3 + ii];
        }
      }else{
	for(int ii=0;ii<3;ii++){
          A[j*3 + ii] = B[M*(N+1)*3 + j*3 + ii];
        }
      }}else{
      for(int i=1;i<M;i++){
	for(int ii=0;ii<3;ii++){
          A[(i-1)*(N+1)*3+ 3*j + ii] = B[i*(N+1)*3 + 3*j + ii];
        }
      }
    }
  }
  //
  if (debug){
    char msg[BUFFSIZE];
    //for i in 1:M_act loop
    for(int i=0;i<M_act;i++){
      //for j in 1:N + 1 loop
      for(int j=0;j<N+1;j++){
	sprintf(msg, "A[%d,%d]={%g,%g,%g}\n",i,j,A[i*(N+1)*3+j*3],A[i*(N+1)*3+j*3+1],A[i*(N+1)*3+j*3+2]);
	ModelicaMessage(msg);
        //print("A[" + String(i) + "," + String(j) + "]={" + String(A[i, j, 1]) + "," + String(A[i, j, 2]) + "," + String(A[i, j, 3]) + "}" + "\n");
      }
    }
  }
}


void Cloth_Mass_Init(double* P1,double* P2,double* P3,double* P4,int M,int N,double density,int M_act,int debug,int isEdge,int isEdgeB,double* A)
{
  double s[M + 1];
  double t[N + 1];
  double tmp1[3];
  double tmp2[3];
  double tmp3[3];
  double pos1[3];
  double pos2[3];
  double pos3[3];
  double pos4[3];
  double mass;
  double B[(M + 1)*(N + 1)];

  linspace(0.0, 1.0, M + 1, s);
  linspace(0.0, 1.0, N + 1, t);

  // Initialize B to zero
  zeros(N+1,M+1,B);
  //
  for(int j=0;j<N;j++){
    for(int i=0;i<M;i++){
      CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j + 1], 0, pos1);
      CoonsPatch(P1, P2, P3, P4, s[i], t[j], 0, pos2);
      tmp1[0] = pos1[0] - pos2[0];
      tmp1[1] = pos1[1] - pos2[1];
      tmp1[2] = pos1[2] - pos2[2];
      CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j], 0, pos3);
      CoonsPatch(P1, P2, P3, P4, s[i], t[j + 1], 0, pos4);
      tmp2[0] = pos3[0] - pos4[0];
      tmp2[1] = pos3[1] - pos4[1];
      tmp2[2] = pos3[2] - pos4[2];
      cross(tmp1, tmp2, tmp3);
      mass = 0.125 * density * length(tmp3);
      B[i*(N+1) + j] += mass;
      B[i*(N+1) + (j+1)] += mass;
      B[(i+1)*(N+1) + j] += mass;
      B[(i+1)*(N+1) + (j+1)] += mass;
    }
  }
  for(int j=0;j<N+1;j++){
    if(!isEdge){
      for(int i=1;i<M_act+1;i++){
        A[(i-1)*(N+1) + j] = B[i*(N+1)+j];
      }
    }else{
      if(!isEdgeB){
        A[j] = B[j];
    }else{
        A[j] = B[(N+1)*M + j];
      }
    }
  }
  //
  // Debug
  if(debug){
    char msg[BUFFSIZE];
    for(int j=0;j<N+1;j++){
      for(int i=0;i<M+1;i++){
	sprintf(msg, "B[%d,%d]=%g\n", i, j, B[i*(N+1)+j]);
	ModelicaMessage(msg);
	//print("B[" + String(i) + "," + String(j) + "]=" + String(B[i, j]) + "\n");
      }
      for(int i=0;i<M_act;i++){
	sprintf(msg, "M_act=%d,A[%d,%d]=%g\n", M_act, i, j, A[i*(N+1)+j]);
	ModelicaMessage(msg);
        //print("M_act=" + String(M_act) + ", A[" + String(i) + "," + String(j) + "]=" + String(A[i, j]) + "\n");
      }
    }
  }
}


void Cloth_MassLoc_zFold_Init(int M, int N, double* P1_start, double* P2_start, double* P3_start, double* P4_start, double L, int folds, int isEdge, int isEdgeB, int dir_pos, int debug, double* A)
{
  double s[M + 1] ;
  double t[N + 1];
  int Mm;
  double B[(M+1)* (N+1)* 3];
  double tmp[3];
  double zOffset;
  double startDistance[3];
  double openLength;
  double alpha;
  double amp; //amplitude of triangle wave
  double p = (double)M/(double)folds; //period of triangle wave
  double triWave; //value of triangle wave

  linspace(0, 1, M+1, s);
  linspace(0, 1, N+1, t);

  startDistance[0] = ((P4_start[0] + P3_start[0])/2)-((P1_start[0] + P2_start[0])/2);
  startDistance[1] = ((P4_start[1] + P3_start[1])/2)-((P1_start[1] + P2_start[1])/2);
  startDistance[2] = ((P4_start[2] + P3_start[2])/2)-((P1_start[2] + P2_start[2])/2);

  // Calculate amplitude of triangle wave
  openLength = sqrt(pow(startDistance[0],2) + pow(startDistance[1],2) + pow(startDistance[2],2));
  alpha = acos((openLength/(2.0*folds))/(L/M));
  zOffset = (openLength/(2*folds))*tan(alpha);
  amp = zOffset / 2;
  char msg[BUFFSIZE];

  if (debug){
    sprintf(msg, "M=%d, N=%d, L=%g, folds=%d, isEdge=%d, isEdgeB=%d\n", M,N,L,folds,isEdge, isEdgeB);
    ModelicaMessage(msg);
    //sprintf(msg, "amp=%g, zOffset=%g, openLength=%g, alpha=%g\n", amp, zOffset, openLength, alpha);
    sprintf(msg, "amp=%g\n", amp);
    ModelicaMessage(msg);
  }
  // Find approximate locations
  //for j in 1:N + 1 loop
  for(int j=0;j<N+1;j++){
  //for i in 1:M + 1 loop
    for(int i=0;i<M+1;i++){
      triWave = (4*amp/p)*(fabs((i%(int)p)-(p/2)) - (p/4)) - amp;
      CoonsPatch(P1_start, P2_start, P3_start, P4_start, s[i], t[j], debug, tmp);
      //for ii in 1:2 loop
      for(int ii=0;ii<2;ii++){
        B[(N+1)*3*i + 3*j + ii] = tmp[ii];
      }
      if (!dir_pos){
	B[(N+1)*3*i + 3*j + 2] = tmp[2] + triWave;
      }else{
	B[(N+1)*3*i + 3*j + 2] = tmp[2] - triWave;
      }
      if (debug){
	sprintf(msg, "B[%d,%d]={%g,%g,%g}\n",i,j, B[(N+1)*3*i + 3*j + 0], B[(N+1)*3*i + 3*j + 1], B[(N+1)*3*i + 3*j + 2]);
	ModelicaMessage(msg);
      }
    }
  }
  //for j in 1:N + 1 loop
  for(int j=0;j<N+1;j++){
    if (isEdge != 0){
      if (isEdgeB == 0){
        //for ii in 1:3 loop
	for(int ii=0;ii<3;ii++){
          A[3*j + ii] = B[3*j + ii];
        }
      }else{
        //for ii in 1:3 loop
	for(int ii=0;ii<3;ii++){
          A[3*j + ii] = B[M*(N+1)*3 + 3*j + ii];
	  if (debug){
            sprintf(msg, "A[%d,%d]=%g\n",j,ii, A[3*j + ii + 0]);
            ModelicaMessage(msg);
	  }
        }
      }
    }else{
      //for i in 2:M loop
      for(int i=1;i<M;i++){
        //for ii in 1:3 loop
	for(int ii=0;ii<3;ii++){
          A[(N+1)*3*(i-1) + 3*j + ii] = B[(N+1)*3*i + 3*j + ii];
        }
      }
    }
  }
  //
/*
  if debug then
    for i in 1:M_act loop
      for j in 1:N + 1 loop
        print("A[" + String(i) + "," + String(j) + "]={" + String(A[i, j, 1]) + "," + String(A[i, j, 2]) + "," + String(A[i, j, 3]) + "}" + "\n");
      end for;
    end for;
  end if;
*/

}


void Cloth_NatTri_Init(int M, int N, double E, double G, double nu, double thickness, int index, const double* P1, const double* P2, const double* P3, const double* P4, const double* P1_loc, const double* ref_angles, const int* axes_sequence, int debug, double* Kq)
{
  double s[M+1];// = linspace(0, 1, M + 1);
  double t[N+1];// = linspace(0, 1, N + 1);
  double N1[3], N2[3], N3[3];
  double P12[3];
  double P23[3];
  double P31[3];
  double P21[3];
  double P32[3];
  double P13[3];
  double L1;
  double L2;
  double L3;
  double Emat[3*3];
  double Te[3*3];
  double En[3*3];
  double Be[3*6];
  double Bq[3*3];
  double sa,A;
  double Qd[3*6]={0,0,-1,0,0,1, 0,1,0,0,-1,0, -1,0,0,1,0,0};
  double Td[6*6];
  double c1,s1,c2,s2,c3,s3;
  double nu1;

  linspace(0, 1, M+1, s);
  linspace(0, 1, N+1, t);

  double Kqtmp1[3*3];
  double tmp;
  double L[3];

  //Temporary variables for calculating rotations
  double rot1[3];
  double rot2[3];
  double rot3[3];
  double T[3*3];

  int coonsDebug = 0;//Debug CoonsPatch?

  zeros(3, 6, Be);
  zeros(3, 3, Bq);

  if (nu < 0.0){
    if (G < 0.0){
      //print("Either G or nu must be defined and > 0 in cloth properties, assuming a value of nu=0.3");
      nu1 = 0.3;
    }else{
      nu1 = E/2/G -1.0;
    }
  }else{
//    assert(G < 0.0, "Only one of G or nu can be defined in cloth properties, using the value for G");
    nu1 = nu;
  }
      
  //
  //FIXME-- assert?
  //assert(index > 0 and index < 5, "Invalid index (index="+String(index)+"provided for Cloth_NatTri_Initializer");
  //
  // Assumes N1[3]=N2[3]=N3[3]=0
  //   Can be generalized by projecting N1,N2,N3 onto a plane and fixing calculation of Te
  //Emat = E / (1 - pow(nu1,2)) * {{1, nu1, 0}, {nu1, 1, 0}, {0, 0, (1 - nu1) / 2}};
  Emat[0] = E / (1 - nu1*nu1);
  Emat[1] = (E / (1 - pow(nu1,2)))*nu1;
  Emat[2] = 0;
  Emat[3] = (E / (1 - pow(nu1,2)))*nu1;
  Emat[4] = E / (1 - pow(nu1,2));
  Emat[5] = 0;
  Emat[6] = 0;
  Emat[7] = 0;
  Emat[8] = ((1-nu1)/2)*(E / (1 - pow(nu1,2)));
  // Loop over each element
  //for j in 1:N loop
  for(int j=0;j<N;j++){
    //for i in 1:M loop
    for(int i=0;i<M;i++){
      switch(index){
      case 1:
        CoonsPatch(P1, P2, P3, P4, s[i], t[j], coonsDebug, N1);
        CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j], coonsDebug, N2);
        CoonsPatch(P1, P2, P3, P4, s[i], t[j + 1], coonsDebug, N3);
	break;
      case 2:
        CoonsPatch(P1, P2, P3, P4, s[i], t[j + 1], coonsDebug, N1);
        CoonsPatch(P1, P2, P3, P4, s[i], t[j], coonsDebug, N2);
        CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j + 1], coonsDebug, N3);
	break;
      case 3:
        CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j + 1], coonsDebug, N1);
        CoonsPatch(P1, P2, P3, P4, s[i], t[j + 1], coonsDebug, N2);
        CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j], coonsDebug, N3);
	break;
      case 4:
        CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j], coonsDebug, N1);
        CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j + 1], coonsDebug, N2);
        CoonsPatch(P1, P2, P3, P4, s[i], t[j], coonsDebug, N3);
	break;
      }
      P12[0] = N1[0] - N2[0];
      P12[1] = N1[1] - N2[1];
      P12[2] = N1[2] - N2[2];

      P23[0] = N2[0] - N3[0];
      P23[1] = N2[1] - N3[1];
      P23[2] = N2[2] - N3[2];

      P31[0] = N3[0] - N1[0];
      P31[1] = N3[1] - N1[1];
      P31[2] = N3[2] - N1[2];
      
      P21[0] = -P12[0];
      P21[1] = -P12[1];
      P21[2] = -P12[2];
      P32[0] = -P23[0];
      P32[1] = -P23[1];
      P32[2] = -P23[2];
      P13[0] = -P31[0];
      P13[1] = -P31[1];
      P13[2] = -P31[2];
      L1 = length(P23);
      L2 = length(P31);
      L3 = length(P12);
      L[0] = L1;
      L[1] = L2;
      L[2] = L3;
      sa = (L1 + L2 + L3) / 2.0;
      A  = sqrt(sa*(sa-L1)*(sa-L2)*(sa-L3));
      c1 = P32[0]/L1;
      s1 = P32[1]/L1;
      c2 = P13[0]/L2;
      s2 = P13[1]/L2;
      c3 = P21[0]/L3;
      s3 = P21[1]/L3;
      zeros(6, 6, Td);
      Td[0] = c3;
      Td[1] = s3;
      Td[6] = c2;
      Td[7] = s2;
      Td[14] = c1;
      Td[15] = s1;
      Td[20] = c3;
      Td[21] = s3;
      Td[28] = c2;
      Td[29] = s2;
      Td[34] = c1;
      Td[35] = s1;

      tmp = 0.25 / A / A;
      Te[0] = P31[1] * P21[1] * L1 * L1 * tmp;
      Te[1] = P12[1] * P32[1] * L2 * L2 * tmp;
      Te[2] = P23[1] * P13[1] * L3 * L3 * tmp;
      Te[3] = P31[0] * P21[0] * L1 * L1 * tmp;
      Te[4] = P12[0] * P32[0] * L2 * L2 * tmp;
      Te[5] = P23[0] * P13[0] * L3 * L3 * tmp;
      Te[6] = (P31[1] * P12[0] + P13[0] * P21[1]) * L1 * L1 * tmp;
      Te[7] = (P12[1] * P23[0] + P21[0] * P32[1]) * L2 * L2 * tmp;
      Te[8] = (P23[1] * P31[0] + P32[0] * P13[1]) * L3 * L3 * tmp;
      BTAB(En, Emat, Te, 3);
      
      Be[2] = -1.0 / L3;
      Be[4] = 1.0 / L2;
      Be[6] = -1.0 / L1;
      Be[11] = 1.0 / L3;
      Be[13] = -1.0 / L2;
      Be[17] = 1.0 / L1;
       //Be = {{0, 0, -1 / L1, 0, 0, 1 / L1}, {0, 1 / L2, 0, 0, -1 / L2, 0}, {-1 / L3, 0, 0, 1 / L3, 0, 0}};
      Bq[0] = 1.0 / L1;
      Bq[4] = 1.0 / L2;
      Bq[8] = 1.0 / L3;
      cBTAB(Kqtmp1, A * thickness, En, Bq, 3);

      axesRotation(T, axes_sequence, ref_angles);
      Av(rot1, T, P12, 3, 3);
      Av(rot2, T, P23, 3, 3);
      Av(rot3, T, P31, 3, 3);

      for(int ii=0;ii<3;ii++){
	for(int jj=0;jj<3;jj++){
	  Kq[N*i*3*7 + 3*j*7 + 7*ii + jj] = Kqtmp1[3*ii + jj];
	}
	Kq[N*i*3*7 + 3*j*7 + 7*ii + 3] = L[ii];
	Kq[N*i*3*7 + 3*j*7 + 7*ii + 4] = P1_loc[ii] + rot1[ii];
	Kq[N*i*3*7 + 3*j*7 + 7*ii + 5] = P1_loc[ii] + rot2[ii];
	Kq[N*i*3*7 + 3*j*7 + 7*ii + 6] = P1_loc[ii] + rot3[ii];
      }
   
      if(debug){
	char msg[BUFFSIZE];
	sprintf(msg, "\nM=%d, N=%d\nA=%g\nE=%g\nnu=%g\nthickness=%g\nindex=%d",i,j,A,E,nu1,thickness,index);
	ModelicaMessage(msg);
	for(int ii=0;ii<3;ii++){
	  sprintf(msg, "rot1[%d]=%g\n",ii,rot1[ii]);
	  ModelicaMessage(msg);
	  sprintf(msg, "rot2[%d]=%g\n",ii,rot2[ii]);
	  ModelicaMessage(msg);
	  sprintf(msg, "rot3[%d]=%g\n",ii,rot3[ii]);
	  ModelicaMessage(msg);
	  /*
	  sprintf(msg, "N1[%d]=%g\n",ii,N1[ii]);
	  ModelicaMessage(msg);
	  sprintf(msg, "N2[%d]=%g\n",ii,N2[ii]);
	  ModelicaMessage(msg);
	  sprintf(msg, "N3[%d]=%g\n",ii,N3[ii]);
	  ModelicaMessage(msg);
	  */
	}
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
	    sprintf(msg, "En[%d,%d]=%g\n",ii,jj,En[3*ii+jj]);
	    ModelicaMessage(msg);
          }
        }
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
	    sprintf(msg, "Te[%d,%d]=%g\n",ii,jj,Te[3*ii+jj]);
	    ModelicaMessage(msg);
          }
        }
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<3;jj++){
	    sprintf(msg, "Bq[%d,%d]=%g\n",ii,jj,Bq[3*ii+jj]);
	    ModelicaMessage(msg);
          }
        }
        for(int ii=0;ii<6;ii++){
          for(int jj=0;jj<6;jj++){
	    sprintf(msg, "Td[%d,%d]=%g\n",ii,jj,Td[6*ii+jj]);
	    ModelicaMessage(msg);
          }
        }
        for(int ii=0;ii<3;ii++){
          for(int jj=0;jj<7;jj++){
	    sprintf(msg, "Kq[%d,%d]=%g\n",ii,jj,Kq[3*7*N*i + 3*7*j + 7*ii + jj]);
	    ModelicaMessage(msg);
          }
        }
      }
    } 
  }
} 


