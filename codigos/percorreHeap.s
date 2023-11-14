.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl percorreHeap

percorreHeap:

    // Loop para varredura da Heap
    movq topoInicialHeap, %rax
enquanto:
    cmpq topoAtualHeap, %rax
    jge final
    movq 8(%rax), %rbx          # avança para pegar o size (rbx: size)
    addq $16, %rbx              # rbx: meta-dados + bytesAlocados
    addq %rbx, %rax             # efetuou o pulo para o próximo "bloco de memória""
    jmp enquanto


final:
    popq %rbp
    movq $60, %rax
    syscall
