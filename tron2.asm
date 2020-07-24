	jmp main

; Variaveis da Moto ------------------

motoPos1 : var #1; variavel de posição da moto
static motoPos1, #610 ; posicao inical da cobra
motoPos2 : var #1; variavel de posição da moto
static motoPos2, #630 ; posicao inical da cobra

; Caracteres da cabeça da cobra--------

motoCaracter1 : var #1 
static motoCaracter1, #'>' ; cabeça inicial (indo para a direita)

motoCaracter2 : var #1 
static motoCaracter2, #'<' ; cabeça inicial (indo para a direita)

motoRastro1 : var #1 
static motoRastro1, #'-'
motoRastro2 : var #1 
static motoRastro2, #'-'

rastroCaracter_hor : var #1
rastroCaracter_ver : var #1
static rastroCaracter_hor, #'-'
static rastroCaracter_ver, #'|'

motoEsq : var #1
motoDir : var #1
motoCima : var #1
motoBaixo : var #1

static motoEsq, #'<' ; possibilidades para a cabeça
static motoDir, #'>'
static motoCima, #'^'
static motoBaixo, #'v'

; -------------------------------

; Variaveis de movimentação -----

randomSeed : var #1

Direcao1 : var #1
Static Direcao1, #2 ; indo para a direita inicialmente

Direcao2 : var #1
Static Direcao2, #4 ; indo para a direita inicialmente
; Variaveis de velocidade

valordelay : var #1
offsetdelay : var #1
decdelay : var #1

static decdelay, #1000
static valordelay, #1000000
static offsetdelay, #50

;Flags
flag : var #1
static flag, #0

tentativas : var #1
static tentativas, #0

;
; inicio do programa
;

checaMov:
		;breakp

		loadn r7, #tentativas
		loadn r6, #200
		loadi r7, r7
		cmp r6, r7
		jeq MovimentaFinal
	
		loadn r0, #rastro_map
		loadn r1, #'#'
		add r0, r0, r2
		loadi r7, r0
		cmp r7, r1
		jeq checaFinal

		loadn r0, #parede
		loadn r1, #'#'
		add r0, r0, r2
		loadi r7, r0
		cmp r7, r1
		jeq checaFinal

		loadn r0, #motoPos2
		storei r0, r2

		jmp MovimentaFinal
checaFinal:
		loadn r7, #flag
		loadn r0, #1
		storei r7, r0

		loadn r7, #tentativas
		loadi r6, r7
		loadn r0, #1
		add r6, r6, r0
		storei r7, r6
		jmp MudaDir2
main:
		call constroiCenario ; /contrconstroi cenario e tela de menu
		; Espera até o usuário apertar enter para começar o jogo
menu:
		loadn r2, #13 ; Caracter do enter
		loadn r0, #0
		loadn r3, #156895
loopmenu: 
		inc r0
		cmp r0, r3
		jeq menu
		inchar r1 ; Le teclado
		cmp r1,r2
		jeq iniciaJogo ; Se apertou enter, inicia o jogo.	
		jmp loopmenu   ; Se não, fica em loop	

iniciaJogo: ; --------------------- INICIO
		loadn r7, #randomSeed
		storei r7, r0

		call apagaMenu ; Apaga o menu do jogo
		call constroiCenario
	
		load r0,motoPos1       ; Carrega posição da moto
		load r1,motoCaracter1	; carrega caracter da cabeça
		outchar r1,r0			; desenha cabeça
		
		load r0,motoPos2       ; Carrega posição da moto
		load r1,motoCaracter2	; carrega caracter da cabeça
		outchar r1,r0			; desenha cabeça

movebixo: 						; loop para movimentação da cobra
		call MudaDir			; função que realiza movimentação da cobra (também checa colisões)
		load r1, valordelay
		
delay:	
	push r2
	push r1
	
	loadn r1, #30  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #900000	; b
   Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
		
	cmp r1,r0				; Delay, para controlar a velocidade da cobra
	jeq movebixo			; ao terminar o delay, retorna para movimentação da cobra	
	inc r0
	jmp delay
	jmp FIM
		
MudaDir: ; ------------------------------------------------------------- Inicia movimentação da cobra

		; Checa se alguma tecla de movimento foi pressionada
		inchar r0
		loadn r1,#'w' ; Tecla de cima
		cmp r1,r0
		jeq mudaDirCima1
		loadn r1,#'s'; Tecla de baixo
		cmp r1,r0
		jeq mudaDirBaixo1
		loadn r1,#'d' ; Tecla de direita
		cmp r1,r0
		jeq mudaDirDireita1
		loadn r1,#'a' ; Tecla de esquerda
		cmp r1,r0
		jeq mudaDirEsquerda1

delay2:
		push r1
		push r2
		loadn r1, #0
		loadn r2, #50000

loop_delay:
		cmp r1,r2
		jeq fim_loop
		dec r2
	
fim_loop:
		pop r2
		pop r1

MudaDir2:

		load r7, randomSeed
		loadn r2, #7
		mul r7, r2, r7
		loadn r2, #2
		add r7, r7, r2
		loadn r2, #156895
		mod r7, r7, r2
		loadn r2, #randomSeed
		storei r2, r7

		loadn r2, #10 
		mod r0, r7, r2
		
		loadn r1,#0 ; Tecla de cima
		cmp r1,r0
		jeq mudaDirCima2
		loadn r1,#1; Tecla de baixo
		cmp r1,r0
		jeq mudaDirBaixo2
		loadn r1,#2 ; Tecla de direita
		cmp r1,r0
		jeq mudaDirDireita2
		loadn r1,#3 ; Tecla de esquerda
		cmp r1,r0
		jeq mudaDirEsquerda2
	
checaFlag:
		loadn r7, #flag	
		loadi r7, r7
		loadn r6, #1
		cmp r6, r7
		jeq Movimenta2

		jmp Movimenta
		
; Atualiza direção de movimento da moto 1
mudaDirCima1:
			 load r2, Direcao1			; Carrega direção atual
			 loadn r3,#3				; Carrega direção que não poderia mudar o movimento
			 cmp r2,r3					; Compara se são iguais
			 jeq MudaDir2				; Se sim, não altera direção
			 load r1,motoCima			; Se não, carrega caracter de cabeça para cima
			 store motoCaracter1, r1	; atualiza caracter da cabeça com o carregado acima
			 load r1, rastroCaracter_ver			; Se não, carrega caracter de cabeça para cima
			 store motoRastro1, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#1				; carrega 1 em r0
			 store Direcao1,r0			; atualiza direção como 1 (cima)
			 jmp MudaDir2
mudaDirDireita1: 						; O mesmo para as outras direções		
			 load r2, Direcao1
			 loadn r3,#4
			 cmp r2,r3
			 jeq MudaDir2
			 load r1,motoDir
			 store motoCaracter1, r1
			 load r1, rastroCaracter_hor			; Se não, carrega caracter de cabeça para cima
			 store motoRastro1, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#2 
			 store Direcao1,r0
			 jmp MudaDir2
mudaDirBaixo1: 
			 load r2, Direcao1
			 loadn r3,#1
			 cmp r2,r3
			 jeq MudaDir2
			 load r1,motoBaixo
			 store motoCaracter1, r1 
			 load r1, rastroCaracter_ver			; Se não, carrega caracter de cabeça para cima
			 store motoRastro1, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#3
			 store Direcao1,r0
			 jmp MudaDir2
mudaDirEsquerda1: 
			 load r2, Direcao1
			 loadn r3,#2
			 cmp r2,r3
			 jeq MudaDir2
			 load r1,motoEsq
			 store motoCaracter1, r1 
			 load r1, rastroCaracter_hor			; Se não, carrega caracter de cabeça para cima
			 store motoRastro1, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#4
			 store Direcao1,r0
			 jmp MudaDir2

; Atualiza direção de movimento da moto 2
mudaDirCima2: 
			 load r2, Direcao2			; Carrega direção atual
			 loadn r3,#3				; Carrega direção que não poderia mudar o movimento
			 cmp r2,r3					; Compara se são iguais
			 jeq checaFlag
			 load r1,motoCima			; Se não, carrega caracter de cabeça para cima
			 store motoCaracter2, r1	; atualiza caracter da cabeça com o carregado acima
			 load r1, rastroCaracter_ver			; Se não, carrega caracter de cabeça para cima
			 store motoRastro2, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#1				; carrega 1 em r0
			 store Direcao2,r0			; atualiza direção como 1 (cima)
			 jmp checaFlag
mudaDirDireita2: 						; O mesmo para as outras direções		
			 load r2, Direcao2
			 loadn r3,#4
			 cmp r2,r3
			 jeq checaFlag
			 load r1,motoDir
			 store motoCaracter2, r1
			 load r1, rastroCaracter_hor			; Se não, carrega caracter de cabeça para cima
			 store motoRastro2, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#2 
			 store Direcao2,r0
			 jmp checaFlag
mudaDirBaixo2: 
			 load r2, Direcao2
			 loadn r3,#1
			 cmp r2,r3
			 jeq checaFlag
			 load r1,motoBaixo
			 store motoCaracter2, r1 
			 load r1, rastroCaracter_ver			; Se não, carrega caracter de cabeça para cima
			 store motoRastro2, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#3
			 store Direcao2,r0
			 jmp checaFlag
mudaDirEsquerda2: 
			 load r2, Direcao2
			 loadn r3,#2
			 cmp r2,r3
			 jeq checaFlag
			 load r1,motoEsq
			 store motoCaracter2, r1 
			 load r1, rastroCaracter_hor			; Se não, carrega caracter de cabeça para cima
			 store motoRastro2, r1	; atualiza caracter da cabeça com o carregado acima
			 loadn r0,#4
			 store Direcao2,r0
			 jmp checaFlag

; Continua movimentação da cobra
Movimenta:
	
		load r0, Direcao1		; Verifica qual a direção demovimento, para calcular a nova posição da cabeça
		loadn r3, #motoPos1
		load r4, motoPos1
		loadn r1, #1; 
		cmp r1,r0
		jeq moveCima1			; Cima
		loadn r1,#3;
		cmp r1,r0
		jeq moveBaixo1			; Baixo
		loadn r1,#2 ; 
		cmp r1,r0
		jeq moveDireita1		; Esquerda
		loadn r1,#4 ;
		cmp r1,r0
		jeq moveEsquerda1		; Direita
		
Movimenta2:

		;Zera a flag
		loadn r6, #flag
		loadn r7, #0
		storei r6, r7

		load r0, Direcao2		; Verifica qual a direção demovimento, para calcular a nova posição da cabeça
		loadn r3, #motoPos2
		load r5, motoPos2
		loadn r1, #1; 
		cmp r1,r0
		jeq moveCima2			; Cima
		loadn r1,#3;
		cmp r1,r0
		jeq moveBaixo2			; Baixo
		loadn r1,#2 ; 
		cmp r1,r0
		jeq moveDireita2		; Esquerda
		loadn r1,#4 ;
		cmp r1,r0
		jeq moveEsquerda2		; Direita
		
		;jmp checaMov

moveCima1:						; Movimenta cabeça para cima
		loadn r0,#40
		loadi r5, r3
		
		sub r2,r5,r0

		storei r3, r2
		
		jmp Movimenta2
		
moveDireita1:					; Movimenta cabeça para a direita
		loadn r0,#1
		loadi r5, r3
		
		add r2,r5,r0

		storei r3, r2
		
		jmp Movimenta2
		
moveBaixo1:						; Movimenta cabeça para baixo
		loadn r0,#40
		loadi r5, r3
		
		add r2,r5,r0
		storei r3, r2
		
		jmp Movimenta2
		
moveEsquerda1:					; Movimenta cabeça para a esquerda
		loadn r0,#1
		loadi r5, r3
		
		sub r2,r5,r0

		storei r3, r2
		
		jmp Movimenta2
		
moveCima2:						; Movimenta cabeça para cima
		loadn r0,#40
		loadi r5, r3
		
		sub r2,r5,r0

		jmp checaMov
		
moveDireita2:					; Movimenta cabeça para a direita
		loadn r0,#1
		loadi r5, r3
		
		add r2,r5,r0

		jmp checaMov
		
moveBaixo2:						; Movimenta cabeça para baixo
		loadn r0,#40
		loadi r5, r3
		
		add r2,r5,r0
		
		jmp checaMov
		
moveEsquerda2:					; Movimenta cabeça para a esquerda
		loadn r0,#1
		loadi r5, r3
		
		sub r2,r5,r0

		jmp checaMov

MovimentaFinal:				   	

		; Zera tentativas
		loadn r7, #tentativas
		loadn r6, #0
		storei r7, r6

;;;;;;;;;;;;;;;;;; rastro ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		load r6, motoRastro1
		loadn r7, #2304
		add r6, r6, r7
		outchar r6,r4	   ; Desenhando caracter de rastro
		load r6, motoRastro2
		loadn r7, #3072
		add r6, r6, r7
		outchar r6, r5

		loadn r6, #'#'
		loadn r3, #rastro_map
		
		add r3, r4, r3
		storei r3, r6
		
		loadn r3, #rastro_map
		
		add r3, r5, r3
		storei r3, r6

;;;;;;;;;;;;;;;;;;;;;; motos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		load r4, motoCaracter1
		load r3, motoPos1
	
		loadn r7, #2304
		add r4, r4, r7
		outchar r4,r3	   ; Desenhando caracter de cabeça na nova posição calculada	

		load r4, motoCaracter2
		load r3, motoPos2
		

		loadn r7, #3072
		add r4, r4, r7
		outchar r4,r3	   ; Desenhando caracter de cabeça na nova posição calculada	

		call Colisao	   ; função que checa colisao com as paredes com o corpo e com a comida	

return:
		rts
		
;----------------------------------------------------------------------------------------- FIM MOVIMENTA

Colisao:
		loadn r2,#'#'
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		load r0, motoPos1

		loadn r1,#parede	   ; Checa colisão com as paredes
		add r1,r1,r0
		loadi r3, r1
		cmp r2,r3
		jeq blueW

		loadn r1,#rastro_map	   ; Checa colisão com as paredes
		add r1,r1,r0
		loadi r3, r1
		cmp r2,r3
		jeq blueW
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		load r0, motoPos2

		loadn r1,#parede	   ; Checa colisão com as paredes
		add r1,r1,r0
		loadi r3, r1
		cmp r2,r3
		jeq redW

		loadn r1,#rastro_map	   ; Checa colisão com as paredes
		add r1,r1,r0
		loadi r3, r1
		cmp r2,r3
		jeq redW

		load r0, motoPos1
		load r1, motoPos2
		cmp r1, r0
		jeq emp

fimcolisao:
		rts

;--------------------------------------------- GAME OVER
;GameOver:
		
		;loadn r0, #gameover ; Caracter que constitui a parede
		;jmp ini_print	
redW:
		loadn r0, #red_win
		loadn r6, #2304
		jmp ini_print
blueW:
		loadn r0, #blue_win
		loadn r6, #3072
		jmp ini_print
emp:
		loadn r0, #draw
		loadn r6, #0
ini_print:
		;Constrзi parede superior
		loadn r1, #0
		loadn r2, #1200
		
		add r0,r0,r1
		
loop2:	cmp r1,r2
		jeq reinicia
		loadi r3,r0
		add r3, r3, r6
		outchar r3,r1
		inc r1
		inc r0
		jmp loop2
		
reinicia:
		; Reinicia variaveis
	
        loadn r0, #rastro_map  
        loadn r1, #1200
        loadn r2, #0
        loadn r3, #' '

looprastro:
        cmp r2, r1
        jeq reinicia2
        add r4, r2, r0
       	storei r4, r3
        inc r2
        jmp looprastro

reinicia2:

		loadn r1, #610
		store motoPos1, r1
		
		; Reinicia posição inicial da cobra para a direita
		load r0,motoDir
		store motoCaracter1, r0
		load r0,rastroCaracter_hor	
		store motoRastro1, r0
		loadn r0, #2
		store Direcao1, r0

		loadn r1, #630
		store motoPos2, r1
		
		; Reinicia posição inicial da cobra para a direita
		load r0,motoEsq
		store motoCaracter2, r0
		load r0,rastroCaracter_hor	
		store motoRastro2, r0
		loadn r0, #4
		store Direcao2, r0
		;-------------------------
		
		loadn r2, #13
		jmp menu
			 
apagaMenu: ; Apaga a região central da tela onde escreve game over e o menu inicial

		loadn r0, #575
		loadn r1, #586
		loadn r3, #40
		loadn r4, #80
		loadn r2, #' '
		
loopapagamenu:
		cmp r0,r1
		jeq fimapagamenu
		
		outchar r2,r0
		add r5,r0,r4
		outchar r2,r5
		add r5,r5,r3
		outchar r2,r5
		
		inc r0
		jmp loopapagamenu
		
fimapagamenu: rts ; ---------------------------------

constroiCenario:

		loadn r0, #parede ; Caracter que constitui a parede
		
		loadn r1, #0
		loadn r2, #1200
						; Um loop percorre todo o vetor que constitui o cenрrio inicial declarado como 'muro'
loop1:	cmp r1,r2
		jeq fimcenario
		loadi r3,r0
		outchar r3,r1
		inc r1
		inc r0
		jmp loop1
		
fimcenario: rts
		
FIM:		
		halt

;-------------------------------  CENARIO INICIAL


parede: string "############## TRON GAME ################                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      #########################################"

blue_win: string "#########################################                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##              BLUE WINS               ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ######################################### "

red_win: string "#########################################                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##               RED WINS               ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ######################################### "
rastro_map: string "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "
draw: string "#########################################                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                 DRAW                 ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ##                                      ######################################### "

rastro_map: string "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                "
"                                                                                                                                                                                                                                                                                                                                                                                                                                             /$$$$$$$$$$$$$                        |$$$$$$$$$$$$$$$$     /$$$$    /$$$   $$    | $$  | $$   $$$  /$$ $$ | $$$$  $$  | $$  | $$$$$$$  | $$  $$ | $$  $$$$  | $$  | $$ $$$   | $$  |$$ | $$  $$$  | $$  | $$  $$$  |  $$$$$/ | $$   $$  |/  |/   $$$  ____/ |_/     _                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "
