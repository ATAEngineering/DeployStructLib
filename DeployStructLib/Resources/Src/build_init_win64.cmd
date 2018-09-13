
set INCDIR=%OPENMODELICAHOME%/include/omc/c
set PATH=%OPENMODELICAHOME%\tools\msys\mingw64\bin;%PATH%

gcc -c cloth_init.c -m64 -O0 -g -I%INCDIR%
gcc -c VectorCalcs.c -m64 -O2
ar rs libcloth_init.a cloth_init.o VectorCalcs.o
rm cloth_init.o VectorCalcs.o
mv libcloth_init.a ..\Library\win64\
