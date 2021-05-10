; Typical first few lines in an Atari 2600 program ...
    processor 6502
    include "vcs.h"
    include "macro.h"


NTSC_LINES = #192
PAL_LINES = #242


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
                
                stx 60
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


    
    seg
    ORG $FFFE
    .word $F000
