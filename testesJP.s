.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl _start
 # finaliza alocador
_start:
    pushq %rbp 
    movq %rsp, %rbp
    subq $24, %rsp

    movq $12, %rax          # Coloca o número da chamada do sistema (brk) em rax
    movq $0, %rdi           # Coloca o novo limite em rdi
    syscall                 # Faz a chamada de sistema

    // Setando as variáveis globais
    movq %rax, topoInicialHeap
    movq %rax, topoAtualHeap


    movq $73, -40(%rbp)
    movq $50, -32(%rbp)
    movq $8, -24(%rbp)
    movq %rax, -16(%rbp)
    movq %rax, -8(%rbp)

    // Alocando meta-dados
    movq topoAtualHeap, %rax    # Rax : topoAtual
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size
    movq %rax, topoAtualHeap    # atualiza o topo da heap
    movq topoAtualHeap, %rbx    # rbx esta sendo utilizado apenas como param. de checagem

    // Atualiza topo Heap
    movq $12, %rax              
    movq topoAtualHeap, %rdi    
    syscall                     

    // Atribui meta-dados
    movq $1, -16(%rax)          # dirty
    movq -24(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Alocando os "syze" bytes (rax:: end. topoHeap)
    movq %rax, %rbx             # rbx esta sendo utilizado apenas como param. de checagem
    movq -24(%rbp), %rcx        # -24(%rbp): numero de bytes que quereos alocar
    addq %rcx, %rax               
    movq %rax, topoAtualHeap  

    // Atualiza topoHeap
    movq $12, %rax              # syscall para atualizar o brk
    movq topoAtualHeap, %rdi    # atualiza o brk
    syscall

    /***** CHECAGEM COMEÇO ***********/
    movq $12, %rax              # syscall para atualizar o brk
    movq $0, %rdi               # atualiza o brk
    syscall                     # atualiza brk

    movq $0, %r13               # resetando
    movq $0, %r14               # resetando
    movq -24(%rax), %r13        # r13: bit dirty    (era -16 mas alocamos 8bytes ent virou -24)
    movq -16(%rax), %r14        # r14: size         (era -8 mas alocamos 8bytes ent virou -16)
    /****** CHECAGEM FIM ****************/

linha0:

    movq $12, %rax              
    movq $0, %rdi               
    syscall 

    // Alocando meta-dados
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size
    movq %rax, topoAtualHeap    
    movq topoAtualHeap, %rbx    # rbx esta sendo utilizado apenas como param. de checagem

    // Atualiza topo Heap
    movq $12, %rax              
    movq topoAtualHeap, %rdi    
    syscall                     

    // Atribui meta-dados
    movq $0, -16(%rax)          # dirty
    movq -32(%rbp), %rcx
    movq %rcx, -8(%rax)         # size
    
    // Alocando os "syze" bytes (rax:: end. topoHeap)
    movq %rax, %rbx             # rbx esta sendo utilizado apenas como param. de checagem
    movq -32(%rbp), %rcx        # -32(%rbp): numero de bytes que quereos alocar
    addq %rcx, %rax               
    movq %rax, topoAtualHeap    # atualiza o topo da heap

    // Atualiza topoHeap
    movq $12, %rax              # syscall para atualizar o brk
    movq topoAtualHeap, %rdi    # atualiza o brk
    syscall

    /***** CHECAGEM COMEÇO ***********/
    movq $12, %rax              # syscall para atualizar o brk
    movq $0, %rdi               # atualiza o brk
    syscall                     # atualiza brk

    movq $0, %r13               # resetando
    movq $0, %r14               # resetando
    movq -66(%rax), %r13        # r13: bit dirty    
    movq -58(%rax), %r14        # r14: size         
    /****** CHECAGEM FIM ****************/    

linha1:

    movq $12, %rax              
    movq $0, %rdi               
    syscall 

    // Alocando meta-dados
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size
    movq %rax, topoAtualHeap    
    movq topoAtualHeap, %rbx    # rbx esta sendo utilizado apenas como param. de checagem

    // Atualiza topo Heap
    movq $12, %rax              
    movq topoAtualHeap, %rdi    
    syscall                     

    // Atribui meta-dados
    movq $0, -16(%rax)          # dirty
    movq -40(%rbp), %rcx
    movq %rcx, -8(%rax)         # size
    
    // Alocando os "syze" bytes (rax:: end. topoHeap)
    movq %rax, %rbx             # rbx esta sendo utilizado apenas como param. de checagem
    movq -40(%rbp), %rcx        # -32(%rbp): numero de bytes que quereos alocar
    addq %rcx, %rax               
    movq %rax, topoAtualHeap    # atualiza o topo da heap

    // Atualiza topoHeap
    movq $12, %rax              # syscall para atualizar o brk
    movq topoAtualHeap, %rdi    # atualiza o brk
    syscall

    /***** CHECAGEM COMEÇO ***********/
    movq $12, %rax              # syscall para atualizar o brk
    movq $0, %rdi               # atualiza o brk
    syscall                     # atualiza brk

    movq $0, %r13               # resetando
    movq $0, %r14               # resetando
    movq -89(%rax), %r13        # r13: bit dirty    
    movq -81(%rax), %r14        # r14: size         
    /****** CHECAGEM FIM ****************/    

linha2:

    /***** Loop para varredura da Heap *********
    movq topoInicialHeap, %rax
while:
    cmpq topoAtualHeap, %rax
    jge final

    movq $0, %r13
    movq $0, %r14
    movq 0(%rax), %r13
    movq 8(%rax), %r14

    movq 8(%rax), %rbx          # avança para pegar o size (rbx: size)
    addq $16, %rbx              # rbx: meta-dados + bytesAlocados
    movq %rbx, %r15
    addq %rbx, %rax             # efetuou o pulo
checagem:
    jmp while
    /*******************************************/

    /****** Loop para o first-fit **************/

    movq topoInicialHeap, %r8
    movq topoAtualHeap, %r9

    movq topoInicialHeap, %rax
heapNoCOmeco:
    movq $30, -48(%rbp)
    movq -48(%rbp), %rcx        # salva a qntd de bytes que queremos alocar
while:
    cmpq topoAtualHeap, %rax
    jge alocaBloco

    movq $0, %r13
    movq $0, %r14
    movq 0(%rax), %r13
    movq 8(%rax), %r14

    movq 8(%rax), %rbx          # avança para pegar o size_atual (rbx: size_atual)

    // Verifica se encontrou a qntd de bytes necessaria
    cmpq %rbx, %rcx             # verifica se qntd de bytes para alocarmos <= size_atual
    jle verificaDirty

continuaOLoop:
    addq $16, %rbx              # rbx: meta-dados + bytesAlocados
    movq %rbx, %r15
    addq %rbx, %rax             # efetuou o pulo
checagem:
    jmp while



verificaDirty:
entrouDirty:
    movq 0(%rax), %rcx
    movq $0, %rdx
    cmpq %rcx, %rdx
    je gerenciaBloco
    jmp continuaOLoop

    /**********************************************/


    // Verifica se eh possivel reparte o bloco em 2

gerenciaBloco:
    movq 8(%rax), %rbx          # rbx: size_atual
    movq -48(%rbp), %rcx        # rcx: qntd de bytes que queremos alocar

    movq %rbx, %rdx             
    subq %rcx, %rdx             # rdx: diferença entre size_atual e qntd de bytes para alocarmos

    movq $0, %r10

    // Caso que size_atual == qntd de bytes para alocarmos
    cmpq $0, %rdx
    je alocaBloco

    // Caso em que (size_atual - qntd bytes para alocarmos) <= 16
    cmpq $16, %rdx
    jl alocaBloco

    // Caso em que (size_atual - qntd bytes para alocarmos) > 16
    cmpq $16, %rdx
    jg reparteBloco

caso_0:
    movq $60, %r10
    jmp final

caso_1:
    movq $61, %r10
    jmp final

caso_2:
    movq $62, %r10
    jmp final


alocaBloco:

    movq $60, %r10
entrouAlocaBloco:

    // Alocando meta-dados
    movq %rax, %rbx             # meramente para debug
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size                  

    /***********************************************
    * O endereço do topoAtualHeap está no rax, 
    * pq vai automatico dps da syscall pro brk.
    * Ent, usei o rax como referencia para guardar 
    * o bit dirty e o size na heap
    *************************************************/
    movq $1, -16(%rax)          # dirty
    movq -48(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Alocando os "size" bytes
    // (lembrar que o endereço do topo da heap já esta no rax)
    movq -48(%rbp), %rcx        # -40(%rbp): numero de bytes que quereos alocar
    addq %rcx, %rax

    movq $0, %r13               # resetando
    movq $0, %r14               # resetando
    movq -66(%rax), %r13        # r13: bit dirty    
    movq -58(%rax), %r14        # r14: size

    
    // Verifica se estamos mexendo com o topo da heap
    cmpq topoAtualHeap, %rax
    jg atualizaTopo

naoMexemosComOTopo:

    movq $12, %rax
    movq $0, %rdi
    syscall

    jmp final

atualizaTopo:
mexemosComOTopo:
    movq %rax, topoAtualHeap
    movq $12, %rax              # syscall para atualizar o brk
    movq topoAtualHeap, %rdi    # atualiza o brk
    syscall

    movq $12, %rax
    movq $0, %rdi
    syscall

    jmp final

reparteBloco:
entrouReparte:
    movq $61, %r10

    /***********************
    se a diferença entre qntds de bytes for maior que 16, ent eh possivel dividir o bloco em 2, logo:
        aloca o primeiro bloco;
        fazo cabeçalho do segundo sendo o dirty=(0), o size=(a dif de qnt de bytes - 16 bytes);

    se a diferença for menor ou igual a 16 ent nao fazemos nada;
    ***************************/

    // Alocando meta-dados
    movq %rax, %rbx             # meramente para debug
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size                  

    /***********************************************
    * O endereço do topoAtualHeap está no rax, 
    * pq vai automatico dps da syscall pro brk.
    * Ent, usei o rax como referencia para guardar 
    * o bit dirty e o size na heap
    *************************************************/
    movq $1, -16(%rax)          # dirty
    movq -48(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Alocando os "size" bytes
    // (lembrar que o endereço do topo da heap já esta no rax)
    movq -48(%rbp), %rcx        # -48(%rbp): numero de bytes que quereos alocar
    addq %rcx, %rax

    movq $0, %r13               # resetando
    movq $0, %r14               # resetando
    movq -46(%rax), %r13        # r13: bit dirty    
    movq -38(%rax), %r14        # r14: size

    movq topoInicialHeap, %r8
    movq topoAtualHeap, %r9
antesDeAlocarBlocoExtra:
    /******* Aloca o bloco extra *********/

    // Alocando meta-dados
    movq %rax, %rbx             # meramente para debug
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size                  

    // Atribui os meta-dados
    movq $0, -16(%rax)          # dirty

    subq $16, %rdx              # lembrar que rdx: (size_atual - bytes para alocarmos) 
    movq %rdx, -8(%rax)         # size: rdx - 16 bytes (do cabeçalho do bloco extra)

    movq $0, %r13               # resetando
    movq $0, %r14               # resetando
    movq -16(%rax), %r13        # r13: bit dirty    
    movq -8(%rax), %r14        # r14: size

    movq $12, %rax
    movq $0, %rdi
    syscall

    /*********************************************/

    movq topoInicialHeap, %r8
    movq topoAtualHeap, %r9
final:
antFineal:
    popq %rbp
    movq $60, %rax
    syscall
