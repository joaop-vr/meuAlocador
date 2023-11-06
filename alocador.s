.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0

.section .text
.globl _start

_start:

    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax          # Coloca o número da chamada do sistema (brk) em rax
    movq $0, %rdi           # Coloca o novo limite em rdi
    syscall                 # Faz a chamada de sistema


    movq %rax, topoInicialHeap

bla:

    movq topoInicialHeap, %rdi         # salvando o brk atual

scrr1:
    popq %rbp
    movq $60, %rax
    syscall





