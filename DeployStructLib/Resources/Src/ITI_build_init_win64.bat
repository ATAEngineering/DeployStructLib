@ECHO OFF

REM Build SimulationX specific ITI_cloth_init.dll using TDM-GCC-64 under Windows platform

REM Copy ModelicaExternalC.dll and ModelicaUtilities.h manually to Src directory
REM Setup TDM-GCC-64 environment by mingwvars.bat

gcc -c cloth_init.c -m64 -O2 -I..\Include
gcc -c VectorCalcs.c -m64 -O2
gcc -m64 -o ITI_cloth_init.dll .\cloth_init.o .\VectorCalcs.o -shared -L . -l"ModelicaExternalC"
DEL cloth_init.o VectorCalcs.o
MOVE ITI_cloth_init.dll ..\Library\win64\ >nul 2>&1
