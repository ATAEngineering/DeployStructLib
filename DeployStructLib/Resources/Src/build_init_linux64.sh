
export INCDIR=/opt/openmodelica/include/omc/c
export PATH=$INCDIR:$PATH

gcc -c cloth_init.c -m64 -O0 -g -I$INCDIR -std=c99
gcc -c VectorCalcs.c -m64 -O2
ar rs libcloth_init.a cloth_init.o VectorCalcs.o
rm cloth_init.o VectorCalcs.o
mv libcloth_init.a ../Library/linux64/
