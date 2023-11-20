.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl inciaAlocador

inciaAlocador:

    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax          # Coloca o número da chamada do sistema (brk) em rax
    movq $0, %rdi           # Coloca o novo limite em rdi
    syscall                 # Faz a chamada de sistema

    movq %rax, topoInicialHeap

    popq %rbp
    ret
