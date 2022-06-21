;-------------------------------
;	Header file for the genesis;
;	Sets up jump vectors and booting
;-------------------------------

STACKORG equ $FFE000
RAMORG equ $FF0000

;------
; STATIC SYSTEM MEMORY
;------
; Start reserving at start of memory
	rsset RAMORG
JOYPAD0:	 rs.b	1
JOYPAD0OLD:  rs.b	1

;16 entries, 4 words per entry, 2 bytes per word
SPR_SIZE equ 8
sprtableSize  equ 16*4*2
SprCount:	 rs.w 1
SPRTABLE:  rs.w sprtableSize

; Start user ram at next index
USERRAM:		 rs.b	0

;------
; Vectors
;------
	dc.l STACKORG
	dc.l BOOT

	dc.l E_BUSERR, E_ADDRERR, E_ILLEGAL, E_FPEXCEPT, E_CHK, E_TRAPV, E_PRIVACY
	dc.l TRACE
	dc.l EMU1010
	dc.l EMU1111

	ds.l 4,EXGENERIC
	ds.l 8,EXGENERIC

	dc.l INTSPUR

	dc.l INT1
	dc.l INT2
	dc.l INT3
	dc.l HBLANK
	dc.l INT5
	dc.l VBLANK
	dc.l INT7

	ds.l 16,EXGENERIC
	ds.l 16,EXGENERIC

;===================
; Cartridge Header
;===================

	dc.b "SEGA GENESIS    "
	dc.b "(C)---- "
	dc.b "2022 JAN"
	dc.b "TESTING PROGRAM                                 " ;cart name
	dc.b "testing program                                 " ;intl name

	dc.b "GM AA-00000-00"
	dc.w $00 ;CHECKSUM
	dc.b "J               " ;hardware

	dc.l $00000000 ;rom start
	dc.l $003FFFFF ;rom end

	dc.l $00FF0000,$00FFFFFF ;ram start/end

	dc.b "            " ;backup ram info
	dc.b "            " ;modem info

	dc.b "                                        " ;comment
	dc.b "JUE             " ;regions

;======
; Console Startup
;======

BOOT:
	; Init VDP
	move.b ($a10001),d0

	;Check for tmss
	andi.b #$0f,d0
	beq    SKIPTMSS
	move.l #'SEGA',($A14000)
SKIPTMSS:
	jsr vdpInit
	jmp START

PROGEND:
	;Change bg color to denote program end
	move.w vdpRegBGColor|06,vdpControl
  jmp PROGEND
	dc.w $0000
