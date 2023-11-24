#ifndef _MEUALOCADOR_
#define _MEUALOCADOR_

/************************************
 * Executa syscall brk para obter o endereço do topo
 * corrente da heap e o armazena em uma
 * variável global, topoInicialHeap.
 ************************************/
void iniciaAlocador();

/************************************
 * Executa syscall brk para restaurar o valor
 * original da heap contido em topoInicialHeap.
**************************************/
void finalizaAlocador();

/************************************
 * Indica que o bloco está livre.
*************************************/
int liberaMem(void* bloco);

/*************************************
 * 1. Procura um bloco livre com tamanho maior ou igual à num_bytes.
 * 2. Se encontrar, indica que o bloco está ocupado e retorna o endereço inicial do bloco;
 * 3. Se não encontrar, abre espaço para um novo bloco, indica que o bloco está
 * ocupado e retorna o endereço inicial do bloco.
**************************************/
void* alocaMem(int num_bytes);

/***************************************
 * Imprime um mapa da memória da região da heap.
 * '#': byte da parte gerencial do nó
 * '-': se o bloco estiver livre ou ocupado
 * '+': Se estiver ocupado
****************************************/
void imprimeMapa();


#endif