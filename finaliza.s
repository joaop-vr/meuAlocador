.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl _start
 # finaliza alocador
_start:

    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax          # Coloca o número da chamada do sistema (brk) em rax
    movq $0, %rdi           # Coloca o novo limite em rdi
    syscall                 # Faz a chamada de sistema


    movq %rax, topoInicialHeap

bla:

    movq topoInicialHeap, %rdi         # salvando o brk atual

teste:
    movq $12, %rax
    addq $3, %rdi               # alocando mais 3 bytes na heap
    syscall

finaliza:
    movq $12, %rax
    movq topoInicialHeap, %rdi  # voltando o topo da heap ao normal
    syscall
scrr1:
    popq %rbp
    movq $60, %rax
    syscall





