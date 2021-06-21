; Typical first few lines in an Atari 2600 program ...
    processor 6502
    include "vcs.h"
    include "macro.h"

VERT_BLANK = #37
NTSC_LINES = #192
PAL_LINES = #242

LINE_COUNT = $80
FRAME_COUNT = $81
PLAYER_POS_X = $82
PLAYER_POX_Y = $83
P_SPRITE_ADD = $89
NEXT_P_SPRITE = $84
SPRITE_LOC = $85
PF0G = $84
PF1G = $85
PF2G = $86


    ORG $F000
    CLEAN_START
    
;prep sprite used to buffer sprite line into page zero ram ready for drawing cycle
;x = address if sprite
;y = index if sprite line
;a used to move sprite 	
prepSpite1
	
	lda x,y 
	sta NEXT_P_SPRITE


drawSprite1


	




StartOfFrame



; Start of new frame
; Start of vertical blank processing

        lda #0
        sta VBLANK
        lda #2
        sta VSYNC
		;stuff
        sta WSYNC
		;stuff
        sta WSYNC
		;stuff
        sta WSYNC               ; 3 scanlines of VSYNC signal
        lda #0
        sta VSYNC           


;------------------------------------------------

; 37 scanlines of vertical blank...

    

        ldx #0

VerticalBlank   sta WSYNC

; stuff can be done here no more than 70 machine cycles

        inx
        cpx #VERT_BLANK
        bne VerticalBlank

       ;------------------------------------------------

       ; Do 192 scanlines of color-changing (our picture)

                ldx #55
                stx COLUBK
                ldx #0                ; this counts our scanline number
                ;sta 60
                

Picture                      ; change background color (rainbow effect)
                ;lda #1
                
                stx LINE_COUNT
                
				ldx #0 
                stx WSYNC              ; wait till end of scanline
				; I can do stuff here but not much 22 cpu cycles


				;do this at the end  
                ldx LINE_COUNT
                inx
                cpx #PAL_LINES ;cycle counting
                bne Picture


;--------------------------------------------       ;------------------------------------------------

                lda #%01000010

                sta VBLANK          ; end of screen - enter blanking
 


   ; 30 scanlines of overscan...



                ldx #0

Overscan        sta WSYNC

                inx

                cpx #30

                bne Overscan









----

        jmp StartOfFrame ; return to begining of the frame
 
        ORG $FA00
        ;Created using Atari Dev Studio
;assembly format (bottom to top)

skullfwd:
	.byte %00000000 ;
	.byte %01010100 ;
	.byte %01111100 ;
	.byte %01101100 ;
	.byte %11101110 ;
	.byte %10010010 ;
	.byte %10010010 ;
	.byte %01111100 ;
Sprite2:
	.byte %00000000 ;
	.byte %01010100 ;
	.byte %01111100 ;
	.byte %01101100 ;
	.byte %11111110 ;
	.byte %10010010 ;
	.byte %10010010 ;
	.byte %01111100 ;
Sprite3:
	.byte %00000000 ;
	.byte %01010100 ;
	.byte %01111100 ;
	.byte %01101100 ;
	.byte %11111110 ;
	.byte %10010010 ;
	.byte %10010010 ;
	.byte %01111100 ;
Sprite4:
	.byte %00000000 ;
	.byte %01010000 ;
	.byte %01111011 ;
	.byte %01011000 ;
	.byte %11011100 ;
	.byte %10101100 ;
	.byte %10101111 ;
	.byte %01111000 ;
Sprite5:
	.byte %00000000 ;
	.byte %00101000 ;
	.byte %00111101 ;
	.byte %00101100 ;
	.byte %01101110 ;
	.byte %01010110 ;
	.byte %01010111 ;
	.byte %00111100 ;
Sprite6:
	.byte %00101000 ;
	.byte %00111101 ;
	.byte %00101100 ;
	.byte %01101110 ;
	.byte %01010110 ;
	.byte %01010111 ;
	.byte %00111100 ;
	.byte %00000000 ;
Sprite7:
	.byte %01111111 ;
	.byte %10001000 ;
	.byte %10010000 ;
	.byte %01101111 ;
	.byte %10010000 ;
	.byte %00010010 ;
	.byte %00010100 ;
	.byte %11101111 ;

    
    seg
    ORG $FFFA
    .word $F000
    .word $F000
    .word $F000
