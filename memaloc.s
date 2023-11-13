.section .data
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0 # MUITO NECESSÁRIA

.section .text
.globl _start
 # finaliza alocador
_start:
    pushq %rbp 
    movq %rsp, %rbp
    subq $16, %rsp

    movq topoInicialHeap, %rax
    movq %rax, -8(%rbp) # salva onde começa a heap
inicial:
    movq topoAtualHeap, %rax
    movq %rax, -16(%rbp) # salva onde está o topo da heap
atual:
# caso o tamanho da heap seja 0, não há comparações a serem feitas
    cmpq %rax, -8(%rbp)
    je whileSituacao1
    jmp whileSituacao2

whileSituacao1:
comeco_while: 
    movq 16(%rbp), %rax # pega o tamanho da heap, 16rbp é parâmetro
    addq $16, %rax # adiciona 16 para alocar o dirty e o size
    addq %rax, -16(%rbp) # atualiza o topo da heap
    movq $12, %rax # syscall para atualizar o brk
    movq  -16(%rbp), %rdi # atualiza o brk
    syscall # atualiza brk
meio_while:    
    movq -8(%rbp), %rbx # coloca o endereço da inicial heap em rbx
linha1:
    # movq $1, (%rbx) # ajeitar o bit de dirty pra um na heap
linha2:    
    addq $8, %rbx # pula o dirty
linha3:   
     movq 16(%rbp), %rax # pega o tamanho da heap, 16rbp é parâmetro
linha4:    
    # movq %rax, (%rbx) # coloca o tamanho da heap no size
linha5:
    jmp final

whileSituacao2:

final:
    popq %rbp
    movq $60, %rax
    syscall