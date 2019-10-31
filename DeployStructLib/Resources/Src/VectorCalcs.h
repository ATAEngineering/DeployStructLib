/*
Licensed by ATA Engineering, Inc. under the BSD 3-Clause License

COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

double VectorLength(double v[3]);
void cA(double* C, double c, double* A, int n);
void cAinline(double c, double* A, int n);
void Av(double* v2, double* A, double* v, int n, int m);
void ATv(double* v2, double* A, double* v, int n, int m);
void AB(double* C, double* A, double* B, int n);
void ATB(double* C, double* A, double* B, int n);
void BTAB(double* C, double* A, double* B, int n);
void cBTAB(double* C, double c, double* A, double* B, int n);
double* newMat(int n);
void deleteMat(double* A);
