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
    jmp procuraFusaoNos


saidaErro:

    popq %rbp
    movq $60, %rax
    movq $0, %rdi
    syscall

procuraFusaoNos:

    // Loop para varredura da Heap
    movq topoInicialHeap, %rax
loop:

    movq %rax, %rbx             # rbx: end. do bloco de Mem antigo
    movq 0(%rax), %rcx          # rcx: dirty_antigo
    movq 8(%rax), %rdx          # rdx: size_antigo

    addq $16, %rdx              # rdx: meta-dados + size
    addq %rdx, %rax             # efetuou o pulo para o próximo "bloco de memória"; rax: end. do bloco de Mem atual

    cmpq topoAtualHeap, %rax
    jge final

    movq 0(%rbx), %r10          # r10: dirty_antigo
    movq 0(%rax), %r11          # r11: dirty_atual

    addq %r10, %r11
    cmpq $0, %r11               # r11: dirty_antigo + dirty_atual
    je fusaoNos 

    jmp loop


fusaoNos:

    movq 8(%rbx), %rcx          # rcx: size_antigo
    movq 8(%rax), %rdx          # rdx: size_atual
    addq %rcx, %rdx             # rdx: size_antigo + size_atual
    addq $16, %rdx              # rdx: rdx + cabeçalho do bloco fundido
    movq %rdx, 8(%rbx)          # atualiza valor de size

    jmp procuraFusaoNos


final:

    popq %rbp
    movq $60, %rax
    movq $1, %rdi
    syscall