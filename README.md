Implementação, em assembly, da função malloc seguindo a seguinte abordagem:

    - Divide-se a região da heap em duas partes: aquela que armazena informações gerenciais sobre cada bloco
    (livre ou ocupado, tamanho, etc.) e aquela que armazena o bloco (cujo início é o endereço retornado pelo procedimento alocaMem()).

    - A parte da heap que armazena as informações gerênciais é composta por 16 bytes: 8 para o indicador dirty (alocado/liberado) e
    8 para o tamanho de bytes do bloco

    - A funcionalidade das funções genéricas é a seguinte:

        -> void iniciaAlocador(): executa syscall brk para obter o endereço do topo corrente da heap e o armazena em uma
        variável global, topoInicialHeap.

        -> void finalizaAlocador(): executa syscall brk para restaurar o valor original da heap contido em topoInicialHeap.

        -> int liberaMem(void* bloco): indica que o bloco está livre.

        -> void* alocaMem(int num_bytes):
        1. Procura um bloco livre com tamanho maior ou igual à num_bytes.
        2. Se encontrar, indica que o bloco está ocupado e retorna o endereço inicial do bloco;
        3. Se não encontrar, abre espaço para um novo bloco usando a syscall brk, indica que o bloco está ocupado e
        retorna o endereço inicial do bloco.

    - Há duas versões do código em relação ao mecanismo de buscar o próximo bloco livre:
        1. First-Fit;
        2. Worst-Fit;

    - Além disso, implementou-se um procedimento que imprime um mapa da memória da região da heap. Cada byte da parte gerencial
    do nó deve ser impresso com o caractere "#". O caractere usado para a impressão dos bytes do bloco de cada nó depende se o
    bloco estiver livre ou ocupado. Se estiver livre, imprime o caractere -". Se estiver ocupado, imprime o caractere "+".
