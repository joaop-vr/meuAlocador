.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl alocaMem

alocaMem:

    pushq %rbp 
    movq %rsp, %rbp

    subq $24, %rsp
    movq topoInicialHeap, -8(%rbp)
    movq topoAtualHeap, -16(%rbp)
    movq %rdi, -24(%rbp)

    // Loop para o firt-fit
    movq topoInicialHeap, %rax
    movq -24(%rbp), %rcx              # rcx: qntd de bytes que queremos alocar

loop:
    cmpq topoAtualHeap, %rax
    jge alocaBloco

    movq 8(%rax), %rbx          # avança para pegar o size_atual (rbx: size_atual)

    cmpq %rbx, %rcx             # verifica se qntd de bytes para alocarmos <= size_atual
    jle verificaDirty           # se a condição a cima foi verdade, verificamos se o bloco está livre

continuaOLoop:
    addq $16, %rbx              # rbx: meta-dados + bytesAlocados
    addq %rbx, %rax             # efetuou o pulo
    jmp loop


verificaDirty:
    movq 0(%rax), %rcx          # rcx: Dirty do bloco de Mem
    movq $0, %rdx
    cmpq %rcx, %rdx
    je gerenciaBloco
    jmp continuaOLoop


/************************************************
* Verifica se eh possivel repartir o bloco em 2,
* se sim então repartimos
* senão alocamos sem repartição
*************************************************/
gerenciaBloco:
    movq 8(%rax), %rbx          # rbx: size_atual
    movq -24(%rbp), %rcx        # rcx: qntd de bytes que queremos alocar

    movq %rbx, %rdx             
    subq %rcx, %rdx             # rdx: diferença entre size_atual e qntd de bytes para alocarmos

    // Caso em que size_atual == qntd de bytes para alocarmos
    cmpq $0, %rdx
    je alocaBloco

    // Caso em que (size_atual - qntd bytes para alocarmos) <= 16
    cmpq $16, %rdx
    jl alocaBloco

    // Caso em que (size_atual - qntd bytes para alocarmos) > 16
    cmpq $16, %rdx
    jg reparteBloco


alocaBloco:

    // Alocando meta-dados
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size                  

    /***********************************************
    * O endereço do topoAtualHeap está no rax, 
    * pq vai automatico dps da syscall pro brk.
    * Ent, usei o rax como referencia para guardar 
    * o bit dirty e o size na heap
    *************************************************/
    movq $1, -16(%rax)          # dirty
    movq -24(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Alocando os "size" bytes
    // (lembrar que o endereço do topo da heap já esta no rax)
    movq -24(%rbp), %rcx        # rcx: numero de bytes que quereos alocar
    addq %rcx, %rax
    
    /***********************************************
    * Verifica se ultrapassamos o topo da heap,
    * se sim devemos atualizá-lo
    * caso contrário "pulamos" para a rotina "final"
    *************************************************/
    cmpq topoAtualHeap, %rax
    jg atualizaTopo

    jmp final

atualizaTopo:

    movq %rax, topoAtualHeap
    movq $12, %rax              # syscall para atualizar o brk
    movq topoAtualHeap, %rdi    # atualiza o brk
    syscall

    jmp final


/***********************************************
* Rotina encarregada de repartir (dividir) o bloco 
* livre de memória, a fim de evitar disperdício de bytes
*************************************************/
reparteBloco:

    // Alocando meta-dados do 1o bloco
    addq $16, %rax                               

    // Atribui os meta-dados
    movq $1, -16(%rax)          # dirty
    movq -24(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Aloca os "size" bytes
    // (lembrar que o endereço do topo da heap já esta no rax)
    movq -24(%rbp), %rcx        # rcx: numero de bytes que quereos alocar
    addq %rcx, %rax

    // Aloca meta-dados do 2o bloco
    addq $16, %rax                   

    // Atribui os meta-dados
    movq $0, -16(%rax)          # dirty
    subq $16, %rdx              # lembrar que rdx: (size_atual - bytes para alocarmos) 
    movq %rdx, -8(%rax)         # size: rdx - 16 bytes 

    jmp final


final:

    popq %rbp
    movq $60, %rax
    syscall
