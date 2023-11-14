.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl alocaMetaDados

alocaMetaDados:

    pushq %rbp 
    movq %rsp, %rbp
    subq $24, %rsp

    movq $12, %rax          # Coloca o número da chamada do sistema (brk) em rax
    movq $0, %rdi           # Coloca o novo limite em rdi
    syscall                 # Faz a chamada de sistema

    // Setando as variáveis globais
    movq %rax, topoInicialHeap
    movq %rax, topoAtualHeap

    movq $8, -24(%rbp)
    movq %rax, -16(%rbp)
    movq %rax, -8(%rbp)

    // Alocando meta-dados
    movq topoAtualHeap, %rax    # Rax : topoAtual
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size
    movq %rax, topoAtualHeap    # atualiza o topo da heap

    // Atualiza o topo da heap
    movq $12, %rax              
    movq topoAtualHeap, %rdi    
    syscall                     

    /***********************************************
    * O endereço do topoAtualHeap está no rax, 
    * pq vai automatico dps da syscall pro brk.
    * Ent, usei o rax como referencia para guardar 
    * o bit dirty e o size na heap
    *************************************************/
    movq $1, -16(%rax)          # dirty
    movq -24(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Alocando os "syze" bytes
    // (lembrar que o endereço do topo da heap já esta no rax)
    movq -24(%rbp), %rcx        # -24(%rbp): numero de bytes que quereos alocar
    addq %rcx, %rax               
    movq %rax, topoAtualHeap    # atualiza o topo da heap

    // Atualiza o topo da heap
    movq $12, %rax              
    movq topoAtualHeap, %rdi    
    syscall 

    popq %rbp
    ret
