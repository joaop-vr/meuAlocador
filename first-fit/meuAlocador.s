.section .data
    enderecoMemoria: .quad 0
    topoInicialHeap: .quad 0
    topoAtualHeap: .quad 0
    gerenciamento:  .asciz "################"   # String para área de gerenciamento
    livre: .asciz "-"
    ocupado: .asciz "+"
    vazio: .asciz "<vazio>"
    quebraLinha: .quad 10  # Código ASCII para a quebra de linha (\n)

.section .text

.globl iniciaAlocador
iniciaAlocador:

    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax          # Coloca o número da chamada do sistema (brk) em rax
    movq $0, %rdi           # Coloca o novo limite em rdi
    syscall                 # Faz a chamada de sistema

    movq %rax, topoInicialHeap
    movq %rax, topoAtualHeap

    popq %rbp
    ret


.globl finalizaAlocador
finalizaAlocador:

    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax                  # Coloca o número da chamada do sistema (brk) em rax
    movq $topoInicialHeap, %rdi     # Coloca o novo limite em rdi
    syscall                         # Faz a chamada de sistema

    popq %rbp
    ret


.globl alocaMem

alocaMem:

    pushq %rbp 
    movq %rsp, %rbp

    subq $8, %rsp
    movq %rdi, -8(%rbp)             # valor passado como parâmetro

    // Loop para o firt-fit
    movq topoInicialHeap, %rax
    

loopAloca:
    cmpq topoAtualHeap, %rax
    jge alocaBloco

    movq -8(%rbp), %rcx         # rcx: qntd de bytes que queremos alocar
    movq 8(%rax), %rbx          # avança para pegar o size_atual (rbx: size_atual)

    cmpq %rbx, %rcx             # verifica se qntd de bytes para alocarmos <= size_atual
    jle verificaDirty           # se a condição a cima foi verdade, verificamos se o bloco está livre

continuaOLoop:
    addq $16, %rbx              # rbx: meta-dados + bytesAlocados
    addq %rbx, %rax             # efetuou o pulo
    jmp loopAloca


verificaDirty:
    movq 0(%rax), %rcx          # rcx: Dirty do bloco de Mem
    movq $0, %rdx
    cmpq %rcx, %rdx
    je gerenciaBloco
    jmp continuaOLoop


/************************************************
* Verifica se eh possivel repartir o bloco em 2,
* se sim então repartimos
* senão alocamos sem repartição
*************************************************/
gerenciaBloco:
    movq 8(%rax), %rbx          # rbx: size_atual
    movq -8(%rbp), %rcx         # rcx: qntd de bytes que queremos alocar

    movq %rbx, %rdx             
    subq %rcx, %rdx             # rdx: diferença entre size_atual e qntd de bytes para alocarmos

    // Caso em que size_atual == qntd de bytes para alocarmos
    cmpq $0, %rdx
    je alocaBloco

    // Caso em que (size_atual - qntd bytes para alocarmos) <= 16
    cmpq $16, %rdx
    jl alocaBloco

    // Caso em que (size_atual - qntd bytes para alocarmos) > 16
    cmpq $16, %rdx
    jg reparteBloco


alocaBloco:

    // Alocando meta-dados
    addq $16, %rax              # adiciona 16 para alocar o dirty e o size
    movq %rax, enderecoMemoria

    /***********************************************
    * Verifica se ultrapassamos o topo da heap,
    * se sim devemos atualizá-lo
    * caso contrário "pulamos" para a rotina "final"
    *************************************************/
    cmpq topoAtualHeap, %rax
    jg atualizaTopo

voltaParaAlocacao:
    /***********************************************
    * O endereço do topoAtualHeap está no rax, 
    * pq vai automatico dps da syscall pro brk.
    * Ent, usei o rax como referencia para guardar 
    * o bit dirty e o size na heap
    *************************************************/
    movq $1, -16(%rax)          # dirty
    movq -8(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Alocando os "size" bytes
    // (lembrar que o endereço do topo da heap já esta no rax)
    movq -8(%rbp), %rcx        # rcx: numero de bytes que quereos alocar
    addq %rcx, %rax

    jmp finalAloca

atualizaTopo:
    pushq %rax
    movq -8(%rbp), %rcx         # rcx: qntd de bytes que queremos alocar
    addq %rax, %rcx
    movq %rcx, topoAtualHeap
    movq $12, %rax              # syscall para atualizar o brk
    movq topoAtualHeap, %rdi    # atualiza o brk
    syscall
    popq %rax

    jmp voltaParaAlocacao


/***********************************************
* Rotina encarregada de repartir (dividir) o bloco 
* livre de memória, a fim de evitar disperdício de bytes
*************************************************/
reparteBloco:

    // Alocando meta-dados do 1o bloco
    addq $16, %rax                    
    movq %rax, enderecoMemoria           

    // Atribui os meta-dados
    movq $1, -16(%rax)          # dirty
    movq -8(%rbp), %rcx
    movq %rcx, -8(%rax)         # size

    
    // Aloca os "size" bytes
    // (lembrar que o endereço do topo da heap já esta no rax)
    movq -8(%rbp), %rcx        # rcx: numero de bytes que quereos alocar
    addq %rcx, %rax

    // Aloca meta-dados do 2o bloco
    addq $16, %rax                   

    // Atribui os meta-dados
    movq $0, -16(%rax)          # dirty
    subq $16, %rdx              # lembrar que rdx: (size_atual - bytes para alocarmos) 
    movq %rdx, -8(%rax)         # size: rdx - 16 bytes 

    jmp finalAloca

finalAloca:

    movq topoInicialHeap, %rax
    movq enderecoMemoria, %rax
    addq $8, %rsp
    popq %rbp
    ret


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

    cmpq %rcx, -16(%rax)        # Bit dirty == 0
    je podeDarFree

    cmpq %rdx, -16(%rax)        # Bit dirty == 1
    je podeDarFree

    /* Caso em que -16(%rax) não caiu no cabeçalho de um bloco,
    portanto end. inválido para free */
    jmp saidaErro


podeDarFree:
    movq $0, -16(%rax)
    jmp procuraFusaoNos


saidaErro:
    popq %rbp
    movq $0, %rax
    ret

procuraFusaoNos:
    movq topoInicialHeap, %rax
loopFusao:
    movq %rax, %rbx             # rbx: end. do bloco de Mem antigo
    movq 0(%rax), %rcx          # rcx: dirty_antigo
    movq 8(%rax), %rdx          # rdx: size_antigo

    addq $16, %rdx              # rdx: meta-dados + size
    addq %rdx, %rax             # efetuou o pulo para o próximo "bloco de memória"; rax: end. do bloco de Mem atual

    cmpq topoAtualHeap, %rax
    jge finalLiberaMem

    movq 0(%rbx), %r10          # r10: dirty_antigo
    movq 0(%rax), %r11          # r11: dirty_atual

    addq %r10, %r11
    cmpq $0, %r11               # r11: dirty_antigo + dirty_atual
    je fusaoNos 

    jmp loopFusao


fusaoNos:
    movq 8(%rbx), %rcx          # rcx: size_antigo
    movq 8(%rax), %rdx          # rdx: size_atual
    addq %rcx, %rdx             # rdx: size_antigo + size_atual
    addq $16, %rdx              # rdx: rdx + cabeçalho do bloco fundido
    movq %rdx, 8(%rbx)          # atualiza valor de size

    jmp procuraFusaoNos

finalLiberaMem:
    popq %rbp
    movq $1, %rax
    ret


.globl imprimeMapaHeap
imprimeMapaHeap:

    pushq %rbp 
    movq %rsp, %rbp

    movq $1, %rdi  # File descriptor 1 (stdout)
    movq topoInicialHeap, %rbx
    movq topoAtualHeap, %rax
    cmpq %rbx, %rax
    je heapVazia

loopImprimir:
    cmpq topoAtualHeap, %rbx
    jge finalImprimir

    // Imprime os caracteres da área de gerenciamento
    movq $gerenciamento, %rsi
    movq $17, %rdx              # Tamanho da string (incluindo o caractere nulo)
    movq $1, %rax               # syscall para write

    // Salva os registradores que podem ser modificados pela syscall
    pushq %rdi
    pushq %rsi
    pushq %rdx
    syscall
    popq %rdx
    popq %rsi
    popq %rdi

    movq 8(%rbx), %rcx          # rcx: size

    cmpq $0, 0(%rbx)
    je blocoLivre

    movq $ocupado, %rsi
    jmp escreveCaracter

blocoLivre:
    movq $livre, %rsi

escreveCaracter:
    movq $2, %rdx              # Tamanho da string (1 caractere)
    movq $1, %rax              # syscall para write

    pushq %rcx
    syscall
    popq %rcx

    subq $1, %rcx
    cmpq $0, %rcx
    je continuarLoopImprimir
    jmp escreveCaracter

continuarLoopImprimir:
    movq 8(%rbx), %rcx          # rcx: size
    addq $16, %rcx
    addq %rcx, %rbx             # efetuou o pulo
    jmp loopImprimir

heapVazia:
    // Imprime uma quebra de linha
    movq $vazio, %rsi
    movq $8, %rdx               # Tamanho da string (incluindo o caractere nulo)
    movq $1, %rax               # syscall para write

    // Salva os registradores que podem ser modificados pela syscall
    pushq %rdi
    pushq %rsi
    pushq %rdx
    syscall
    popq %rdx
    popq %rsi
    popq %rdi

finalImprimir:
    # Imprime uma quebra de linha
    movq $quebraLinha, %rsi             # Código ASCII para a quebra de linha (\n)
    movq $1, %rdi              # File descriptor 1 (stdout)
    movq $2, %rdx              # Tamanho da string (1 caractere)
    movq $1, %rax              # syscall para write

    syscall
    
    popq %rbp
    ret

