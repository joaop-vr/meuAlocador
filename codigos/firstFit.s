.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl firstFit

firstFit:

    pushq %rbp
    movq %rsp, %rbp

    /****** Loop para o first-fit **************/
    movq topoInicialHeap, %rax
    movq -40(%rbp), %rcx        # salva a qntd de bytes que queremos alocar

while:
    cmpq topoAtualHeap, %rax
    jge final

    movq 8(%rax), %rbx          # avança para pegar o size_atual (rbx: size_atual)

    // Verifica se encontrou a qntd de bytes necessaria
    cmpq %rbx, %rcx             # verifica se qntd de bytes para alocarmos <= size_atual
    jle verificaDirty           # jump para a rotina que verifica se está alocado ou não

continuaOLoop:
    addq $16, %rbx              # rbx: meta-dados + bytesAlocados
    addq %rbx, %rax             # efetuou o pulo
    jmp while

verificaDirty:
    movq $0, %rdx
    movq 0(%rax), %rcx
    cmpq %rcx, %rdx
    je final                # ecnontrou o first-fit
    jmp continuaOLoop           # não encontrou, volta a percorrer a Heap

final:
    
    // Chamar a funcao que aloca blocos 

    popq %rbp
    ret
