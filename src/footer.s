; File is mostly for defining unused interrupts

err_bus         equ $f1
err_addr        equ $f2
err_illegal     equ $f3
err_fpexception equ $f4
err_chk         equ $f5
err_trapv       equ $f6
err_privacy     equ $f7

err_unknown     equ $ff

; =======
; Errors
; =======
  ifnd E_BUSERR
E_BUSERR:
  move.w #err_bus,d6
  jmp panic
  endif

  ifnd E_ADDRERR
E_ADDRERR:
  move.w #err_addr,d6
  jmp panic
  endif

  ifnd E_ILLEGAL
E_ILLEGAL:
  move.w #err_illegal,d6
  jmp panic
  endif

  ifnd E_FPEXCEPT
E_FPEXCEPT:
  move.w #err_fpexception,d6
  jmp panic
  endif

  ifnd E_CHK
E_CHK:
  move.w #err_chk,d6
  jmp panic
  endif

  ifnd E_TRAPV
E_TRAPV:
  move.w #err_trapv,d6
  jmp panic
  endif

  ifnd E_PRIVACY
E_PRIVACY:
  move.w #err_trapv,d6
  jmp panic
  endif

; =======
; Traces
; =======
  ifnd TRACE
TRACE:
  endif
  ifnd EMU1010
EMU1010:
  endif
  ifnd EMU1111
EMU1111:
  endif

; =======
; Other interrupts
; =======
  ifnd INTSPUR
INTSPUR:
  endif
  ifnd INT1
INT1:
  endif
  ifnd INT2
INT2:
  endif
  ifnd INT3
INT3:
  endif
  ifnd HBLANK
HBLANK:
  endif
  ifnd INT5
INT5:
  endif
  ifnd VBLANK
VBLANK:
  endif
  ifnd INT7
INT7:
  endif

;generic
  ifnd EXGENERIC
EXGENERIC:
  endif

  rte

  ifnd START
START:
  jmp PROGEND
  endif

panic:
  move.w d6,$AAAA
  jmp panic
  dc.l $f7f7f7f7
