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
    movq $1, -16(%rax)          # dirty
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

    // Loop para varredura da Heap
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


final:
    popq %rbp
    movq $60, %rax
    syscall
