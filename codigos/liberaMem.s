.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl liberaMem


liberaMem:

    pushq %rbp 
    movq %rsp, %rbp

    // rax receberá o endereço passado como parametro pelo usuario
    movq %rdi, %rax

    // Caso em que o end. está abaixo do limite inf. da Heap ou é igual a ele
    cmpq topoInicialHeap, %rax
    jle saidaErro

    // Caso em que o end. está acima do limite sup. da Heap ou igual a ele
    cmpq topoAtualHeap, %rax
    jge saidaErro

    // Verifica se -16(%rax) corresponde ao cabeçalho do bloco
    movq $0, %rcx
    movq $1, %rdx

    // Bit dirty == 0
    cmpq %rcx, -16(%rax)
    je podeDarFree

    // Bit dirty == 1
    cmpq %rdx, -16(%rax)
    je podeDarFree

    /* Caso em que -16(%rax) não caiu no cabeçalho de um bloco,
    portanto end. inválido para free */
    jmp saidaErro


podeDarFree:

    movq $0, -16(%rax)

    popq %rbp
    movq $60, %rax
    movq $1, %rdi
    syscall


saidaErro:

    popq %rbp
    movq $60, %rax
    movq $0, %rdi
    syscall
