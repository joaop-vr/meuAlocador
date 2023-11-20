#include <stdio.h>
#include "meuAlocador.h"

int main (long int argc, char** argv) {
  void *a, *b;

  printf("\n");

  iniciaAlocador();               // Impressão esperada
  imprimeMapaHeap();                  // <vazio>

  a = (void *) alocaMem(10);
  imprimeMapaHeap();                  // ################**********
  b = (void *) alocaMem(4);
  imprimeMapaHeap();                  // ################**********##############****
  liberaMem(a);
  imprimeMapaHeap();              // ################----------##############****
  liberaMem(b);                   // ################----------------------------
                                  // ou
                                  // <vazio>
  finalizaAlocador();
}