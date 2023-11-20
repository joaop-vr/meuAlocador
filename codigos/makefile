GCC=gcc
AS=gcc
LD=ld
LFLAG=-g
EXEC=executavel

all: $(EXEC)

$(EXEC): $(EXEC).o meuAlocador.o
	$(GCC) -fPIE $(EXEC).o meuAlocador.o -o $(EXEC)

$(EXEC).o: teste.c
	$(GCC) -fPIE -c teste.c -o $(EXEC).o

meuAlocador.o: meuAlocador.s meuAlocador.h
	$(GCC) -c meuAlocador.s -o meuAlocador.o

clean:
	rm -f *.o

purge: clean
	rm -f $(EXEC)
