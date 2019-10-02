/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

void Cloth_NatQuad_Init(int M,int N,double E,double G,double nu,double thickness,const double* P1,const double* P2,const double* P3,const double* P4,const double* P1_loc,const double* ref_angles,const double* P1_start,const double* P2_start,const double* P3_start,const double* P4_start,int debug,double* Kq);

void Cloth_MassLoc_Flat_Init(int M,int N,double* P1_start,double* P2_start,double* P3_start,double* P4_start,int M_act,int isEdge,int isEdgeB,int debug,double* A);

void Cloth_Mass_Init(double* P1,double* P2,double* P3,double* P4,int M,int N,double density,int M_act,int debug,int isEdge,int isEdgeB,double* A);

void Cloth_MassLoc_zFold_Init(int M, int N, double* P1_start, double* P2_start, double* P3_start, double* P4_start, double L, int folds, int isEdge, int isEdgeB, int dir_pos, int debug, double* A);

void Cloth_NatTri_Init(int M, int N, double E, double G, double nu, double thickness, int index, const double* P1, const double* P2, const double* P3, const double* P4, const double* P1_loc, const double* ref_angles, const int* axes_sequence, int debug, double* Kq);

