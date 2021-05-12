; Typical first few lines in an Atari 2600 program ...
    processor 6502
    include "vcs.h"
    include "macro.h"


NTSC_LINES = #192
PAL_LINES = #242

LINE_COUNT = $80
FRAME_COUNT = $81

    ORG $F000
    CLEAN_START
    

StartOfFrame



; Start of new frame
; Start of vertical blank processing

        lda #0
        sta VBLANK
        lda #2
        sta VSYNC
        sta WSYNC
        sta WSYNC
        sta WSYNC               ; 3 scanlines of VSYNC signal
        lda #0
        sta VSYNC           


;------------------------------------------------

; 37 scanlines of vertical blank...

    

        ldx #0

VerticalBlank   sta WSYNC

        inx

        cpx #37

        bne VerticalBlank

       ;------------------------------------------------

       ; Do 192 scanlines of color-changing (our picture)

                ldx #45
                stx COLUBK
                ldx #0                ; this counts our scanline number
                sta 60
                
                nop
                

Picture                      ; change background color (rainbow effect)
                ;lda #1
                
                stx LINE_COUNT
                sta RESP0
                sta RESP1
                ldx #$AA
                stx GRP0
                stx GRP1
                sta WSYNC              ; wait till end of scanline


                ldx 60
                inx
                
                cpx PAL_LINES

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
