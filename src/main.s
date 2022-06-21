  include "header.s"
  include "vdpInterface.s"

START:

  ; - Load color pallette - - - -

  ;Point CRAM to pallette 0
  SetCRAMWrite $00

  ;Set loop counter for palletes
  move.w #8-1,d0

  ;Load address registers with ball and vdp data port
  lea PALLETTE_BALL,a1
  lea vdpData,a0

  ;Dump all 8 colors into CRAM
  @palletteLoop:
    move.l (a1)+,(a0)       ; Send data through data port
    dbra  d0,@palletteLoop  ; Next


  ;Go to start of vram where the character data is
  SetVRAMWrite $00

  ;Move 6 tiles (8 longwords each) into char memory
  move.w #(8*TILESET1Q)-$1,d0
  lea TILESET1START,a1 ;Set a1 to point to tileset data

  @characterLoop:
    move.l (a1)+,(a0)
    dbra  d0,@characterLoop

  SetVRAMWrite vdpDefaultPlaneA
    ;screen is 19 * 2 wide
    move.w #19,d0

  move.w #$5|$0000,d1
  move.w #$5|$0800,d2

  @verticallayoutlp:
    move.w  d1,(a0)
    move.w  d2,(a0)
    dbra d0,@verticallayoutlp

    ; Ball coords
    ballx: rs.w 1
    bally: rs.w 1

    ; Ball velocity
    ballvx: rs.w 1
    ballvy: rs.w 1

    ;Starting position for ball
    move.w #128+32,ballx
    move.w #128+32,bally

    ;Starting velocities
    move.w  #1,ballvx
    move.w  #1,ballvy

spr_2x2 equ %0101

    ;Quick and dirty method of writing a sprite into the vdp
    SetVRAMWrite $d800
    move.w ballx,(a0)
    move.w #spr_2x2<<8|0,(a0)
    move.w #$1,(a0)
    move.w bally,(a0)

    ;Enable interrupts
    ;todo: learn more about what this number actually means
    move.w  #$2300,sr

; Flag used to wait for vblank in main
vblankflag:    rs.b

mainlp:

  ;Wait for vertical blank
  move.w #0,vblankflag
  @waitlp:
    tst.w vblankflag
    beq @waitlp

screen_top_px equ 128
screen_bottom_px equ 351-16

screen_left_border equ 128
screen_right_border equ 447-16

  ;Check if the ball has hit the top
    cmpi.w #screen_top_px,bally
    bpl @notabove
    move.w #1,ballvy
    bra @notbelow

  ;Check if the ball has hit the bottom
    @notabove:
    cmpi.w #screen_bottom_px,bally
    bmi @notbelow
    move.w #-1,ballvy

    @notbelow:

  ;Check if the ball has hit the left border
    cmpi.w #screen_left_border,ballx
    bpl @notleft
    move.w #1,ballvx
    bra @notright

  ;Check if the ball has hit the right border
    @notleft:
    cmpi.w #screen_right_border,ballx
    bmi @notright
    move.w #-1,ballvx

    @notright:

  ;Apply velocity
    move.w ballvx,d0
    add.w  d0,ballx

    move.w ballvy,d0
    add.w d0,bally

    jmp mainlp

WriteBorder:

; Writes a filled 2 tile tall row into char memory
; d3 -> tile top left corner
; d5 -> row #
WriteFullCharRow:
  ;todo
  rts

; Writes a 4 tile section on either side
; d3 -> tile top left corner
; d5 -> row #
WriteCharBorder:
  ;todo
  rts

; Writes a tile into 4 spots with rotation
; d3 -> tile id of top left corner
; d2 -> Coords (x,y)
Write2x2Tile:
  ;setvram to appropriate address

  ;write 2 tiles
  ;jump ahead

  rts

VBLANK:
  ;preserve d0 contents
  move.w  d0,-(sp)

  add.w #1,d7

  SetVRAMWrite $d800
  move.w bally,(a0)
  move.w #spr_2x2<<8|0,(a0)
  move.w #$1,(a0)
  move.w ballx,(a0)

  ;Restore
  move.w  (sp)+,d0

  move.w #1,vblankflag
  rte

;------- Storage section ----------
  include "ball_pallette.s"
  include "tiles.s"

;==================================
  include "footer.s"
