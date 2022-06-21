  include "header.s"
  include "vdpInterface.s"

START:

  clr.w d5

  SetCRAMWrite $00

  move.w #8-1,d0
  lea PALLETTE_BALL,a0 ;Start getting from testpallet data
  lea vdpData,a1

  @palLp:
    move.l (a0)+,(a1)
    dbra d0,@palLp

  SetVRAMWrite $00
  move.w #(8*6)-$1,d0
  lea EMPTYTILE,a0

  @charlp:
    move.l (a0)+,(a1)
    dbra d0,@charlp

  SetVRAMWrite $c000 ;go to plane a
  move.w #$5|$0000,(a1)
  move.w #$5|$0800,(a1) ;hflip

  SetVRAMWrite $c000+$40*$2
  move.w #$5|$1000,(a1) ;vflip
  move.w #$5|$1800,(a1) ;vhflip

  ;what the fuck is wrong
  ;For some reason, the vdp isn't responding at all.
  ;Forgot to activate an interrupt or something?
  lea BALLSPRITE,a0
  SetVRAMWrite $d800

  move.w (a0)+,(a1)
  move.w (a0)+,(a1)
  move.w (a0)+,(a1)
  move.w (a0)+,(a1)

  ;Enable vblank
  move.w #$2300,sr

  @mnlp:

  jmp @mnlp

  jmp PROGEND

VBLANK:
  move.l a1,-(sp) ;prevent a1 from getting clobbered
  move.l a2,-(sp)

SPRBUFFER: rs.b 8
  move.l BALLSPRITE,SPRBUFFER
  move.l BALLSPRITE+4,SPRBUFFER+4

  lea SPRBUFFER,a1

  move.w ballx,(a1)
  move.w bally,6(a1)

  lea vdpData,a2
  SetVRAMWrite $d800

  move.w (a1),(a2)
  move.w (a1),(a2)
  move.w (a1),(a2)
  move.w (a1),(a2)

  move.l (sp)+,a2
  move.l (sp)+,a1
  rte

ballx  dc.w $400
bally  dc.w $100

 include "ball_pallette.s"

EMPTYTILE:
  dc.l $00000000
  dc.l $00000000
  dc.l $00000000
  dc.l $00000000
  dc.l $00000000
  dc.l $00000000
  dc.l $00000000
  dc.l $00000000

BALLTILE:
	dc.l $00000777
	dc.l $00077777
	dc.l $00777777
	dc.l $07777777
	dc.l $07777777
	dc.l $77777777
	dc.l $77777777
	dc.l $77777777

	dc.l $77777777
	dc.l $77777777
	dc.l $77777777
	dc.l $07777777
	dc.l $07777777
	dc.l $00777777
	dc.l $00077777
	dc.l $00000777

	dc.l $77700000
	dc.l $77777000
	dc.l $77777700
	dc.l $77777770
	dc.l $77777770
	dc.l $77777777
	dc.l $77777777
	dc.l $77777777

	dc.l $77777777
	dc.l $77777777
	dc.l $77777777
	dc.l $77777770
	dc.l $77777770
	dc.l $77777700
	dc.l $77777000
	dc.l $77700000

BGTILE:
  dc.l $66666666
	dc.l $66666666
	dc.l $66600000
	dc.l $66060000
	dc.l $66006000
	dc.l $66000600
	dc.l $66000060
	dc.l $66000006

BALLSPRITE:
  dc.w $750
  dc.b $05
  dc.b $00
  dc.w $0000|$01 ;palette 0, block 0
  dc.w $80

  include "footer.s"
