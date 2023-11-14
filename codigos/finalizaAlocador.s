.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl finalizaAlocador

finalizaAlocador:

    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax                  # Coloca o número da chamada do sistema (brk) em rax
    movq $topoInicialHeap, %rdi     # Coloca o novo limite em rdi
    syscall                         # Faz a chamada de sistema

    popq %rbp
    ret
