GCC=gcc
AS=as
EXEC=avalia

all: $(EXEC)

$(EXEC): $(EXEC).o meuAlocador.o
	$(GCC) -no-pie $(EXEC).o meuAlocador.o -o $(EXEC)

$(EXEC).o: avalia.c
	$(GCC) -c avalia.c -o $(EXEC).o

meuAlocador.o: meuAlocador.s meuAlocador.h
	$(AS) meuAlocador.s -o meuAlocador.o

clean:
	rm -f *.o

purge: clean
	rm -f $(EXEC)
