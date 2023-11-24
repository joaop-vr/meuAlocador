#include <stdio.h>
#include "meuAlocador.h"

int main (long int argc, char** argv) {
  void *a,*b,*c,*d,*e;
  printf ("\n");

  iniciaAlocador(); 
  imprimeMapaHeap();
  // 0) estado inicial

  a=(void *) alocaMem(100);
  imprimeMapaHeap();
  printf ("\n");
  b=(void *) alocaMem(130);
  imprimeMapaHeap();
  printf ("\n");
  c=(void *) alocaMem(120);
  imprimeMapaHeap();
  printf ("\n");
  d=(void *) alocaMem(110);
  imprimeMapaHeap();
  printf ("\n");
  // 1) Espero ver quatro segmentos ocupados
  printf("@@@@@@@@@@@@@@@@@@@@@@@@@\n");

  liberaMem(b);
  imprimeMapaHeap();
  printf ("\n");
  liberaMem(d);
  imprimeMapaHeap();
  printf ("\n");
  // 2) Espero ver quatro segmentos alternando
  //    ocupados e livres
  printf("@@@@@@@@@@@@@@@@@@@@@@@@@\n");

  b=(void *) alocaMem(50);
  imprimeMapaHeap();
  printf ("\n");
  d=(void *) alocaMem(90);
  imprimeMapaHeap();
  printf ("\n");
  e=(void *) alocaMem(40);
  imprimeMapaHeap();
  printf ("\n");
  // 3) Deduzam
  printf("@@@@@@@@@@@@@@@@@@@@@@@@@\n");
	
  liberaMem(c);
  imprimeMapaHeap(); 
  printf ("\n");
  liberaMem(a);
  imprimeMapaHeap();
  printf ("\n");
  liberaMem(b);
  imprimeMapaHeap();
  printf ("\n");
  liberaMem(d);
  imprimeMapaHeap();
  printf ("\n");
  liberaMem(e);
  imprimeMapaHeap();
   // 4) volta ao estado inicial
   printf("@@@@@@@@@@@@@@@@@@@@@@@@@\n");

  finalizaAlocador();
}