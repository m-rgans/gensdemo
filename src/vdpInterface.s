
;; TODO:
;  Make a macro for dma dumps
;  Make a proper tile system


;VDP ports
vdpControl   equ $C00004
vdpData		 	 equ $C00000
vdpHVCounter equ $C00008

;Vdp mode registers
vdpRegM1 equ $8000
vdpRegM2 equ $8100
vdpRegM3 equ $8B00
vdpRegM4 equ $8C00

;Other registers
vdpRegPlaneATable equ $8200
vdpRegPlaneBTable equ $8400

vdpRegSprTable 		  equ $8500
vdpRegWindowTable   equ $8300
vdpRegHScrollTable  equ $8D00

vdpRegPlaneSize equ $9000
vdpRegWinXSplit equ $9100
vdpRegWinYSplit equ $9200

vdpRegIncrement equ $8F00

vdpRegBGColor    equ $8700
vdpRegHBlankRate equ $8A00

vdpDMALenLow   equ $9300
vdpDMALenHight equ $9400

vdpDMASrcLow   equ $9500
vdpDMASrcMid   equ $9600
vdpDMASrcHight equ $9700

vdpVramSize 		    equ 65536
vdpCramSize 		    equ 128
vdpVScrollRamSize   equ 80

;Macro to setup a write to vram
SetVRAMWrite: macro
	move.l  #($40000000)|((\1)&$3FFF)<<16|(\1)>>14,vdpControl
	endm

;Macro to setup a write to CRAM
SetCRAMWrite: macro
	move.l  #($C0000000)|((\1)&$3FFF)<<16|(\1)>>14,vdpControl
	endm

vdpInit:
	tst.w (vdpControl) ;clear garbage from status port

	lea vdpControl,a1
	lea VDPSETTINGS,a0

	moveq.l #24-1,d0   ; Setttings array size
	move.l  #$8000,d5  ; Set upper byte of d5 to a register

@vdpinitLoop:
	move.b (a0)+,d5			 ; Put data into lower byte of d5
	move.w d5,(a1)			 ; Send through data port
	add.w #$100,d5			 ; increment register number
	dbra d0,@vdpinitLoop ; Decrement and branch

	rts

; got this setup from the chibiakumas.com lib, credit to them
; todo: rewrite these,
; 1: Use our own setup
; 2: Use equates instead of just magic numbers
	even
vdpDefaultPlaneA equ $C000
VDPSETTINGS:
	DC.B $14 ; 0 mode register 1											---H-1M-
	DC.B $74 ; 1 mode register 2											-DVdP---
	DC.B $30 ; 2 name table base for scroll A (A=top 3 bits)				--AAA--- = $C000
	DC.B $3C ; 3 name table base for window (A=top 4 bits / 5 in H40 Mode)	--AAAAA- = $F000
	DC.B $07 ; 4 name table base for scroll B (A=top 3 bits)				-----AAA = $E000
	DC.B $6C ; 5 sprite attribute table base (A=top 7 bits / 6 in H40)		-AAAAAAA = $D800
	DC.B $00 ; 6 unused register											--------
	DC.B $0A ; 7 background color (P=Palette C=Color)						--PPCCCC
	DC.B $00 ; 8 unused register											--------
	DC.B $00 ; 9 unused register											--------
	DC.B $08 ;10 H interrupt register (L=Number of lines)					LLLLLLLL
	DC.B $00 ;11 mode register 3											----IVHL
	DC.B $81 ;12 mode register 4 (C bits both1 = H40 Cell)					C---SIIC
	DC.B $3F ;13 H scroll table base (A=Top 6 bits)							--AAAAAA = $FC00
	DC.B $00 ;14 unused register											--------
	DC.B $02 ;15 auto increment (After each Read/Write)						NNNNNNNN
	DC.B $01 ;16 scroll size (Horiz & Vert size of ScrollA & B)				--VV--HH = 64x32 tiles
	DC.B $00 ;17 window H position (D=Direction C=Cells)					D--CCCCC
	DC.B $00 ;18 window V position (D=Direction C=Cells)					D--CCCCC
	DC.B $FF ;19 DMA length count low										LLLLLLLL
	DC.B $FF ;20 DMA length count high										HHHHHHHH
	DC.B $00 ;21 DMA source address low										LLLLLLLL
	DC.B $00 ;22 DMA source address mid										MMMMMMMM
	DC.B $80 ;23 DMA source address high (C=CMD)							CCHHHHHH
	even
