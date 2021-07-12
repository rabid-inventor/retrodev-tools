; Typical first few lines in an Atari 2600 program ...
    processor 6502
    include "vcs.h"
    include "macro.h"

;Screen defines 
VERT_BLANK = #30   ; 37 - lines of processing currently 7
NTSC_LINES = #192
PAL_LINES = #242
OVERSCAN_LINES = #30

;RAM usage (no more than 128 - stack)
LINE_COUNT = $80
FRAME_COUNT = $81
PLAYER_POS_X = $82
PLAYER_POS_Y = $83
PLAYER_POS_TUNE = $84
P_SPRITE_ADD = $85
NEXT_P_SPRITE = $86
SPRITE_LOC = $87
PF0G = $88
PF1G = $89
PF2G = $90
SPRITE1LINE = $91


    ORG $F000
    CLEAN_START
    
;prep sprite used to buffer sprite line into page zero ram ready for drawing cycle
;y = address if sprite
;x = index if sprite line
;a used to move sprite 	
prepSpite1	
	cpx #0
	beq Picture1 
	lda Sprite2,x
	sta NEXT_P_SPRITE
	sta GRP0	
	dex
	stx SPRITE1LINE
	jmp Picture1


drawSprite1
	inx
	cpx PLAYER_POS_X
	bpl drawSprite1
	sta RESP0
	jmp Sprit1rtn

drawSprite2
	sta RESP1
	jmp Sprit1rtn


StartOfFrame
; Start of new frame
; Start of vertical blank processing

        lda #0
        sta VBLANK
        lda #2
        sta VSYNC
		;setting player y pos

		ldx PLAYER_POS_Y
		inx
		stx PLAYER_POS_Y
		ldx #3
		stx PLAYER_POS_X
		stx COLUP0
        sta WSYNC; follow sets player X possition 
xpos		
		ldx #0
xposloop				
		;jmp drawSprite1
		;jmp xposloop
        	
		;stuff
        sta WSYNC
		ldx PLAYER_POS_TUNE		
	    stx HMP0 ;preload player fine tune possition 
		;stuff
		stx HMOVE
        sta WSYNC           ; 3 scanlines of VSYNC signal
		   
		lda #0
        sta VSYNC           


;------------------------------------------------

; 37 scanlines of vertical blank...

    

        
		


		sta WSYNC ;set sprite 1 possition
		ldx #0
		jmp drawSprite1
Sprit1rtn 

		sta WSYNC		
		sta WSYNC
		sta WSYNC
		sta WSYNC
		ldx #0
VerticalBlank		
		sta WSYNC

; stuff can be done here no more than 70 machine cycles
		
        inx
        cpx #VERT_BLANK
        bne VerticalBlank

       ;------------------------------------------------

       ; Do 192 scanlines of color-changing (our picture)

        ldx #12
        stx COLUBK
        ldx #0                ; this counts our scanline number
                
                
;------------------screen update routunes (tight timing)-----------------
Picture                     
                
			
		stx LINE_COUNT		
		lda #0
		sta GRP0 
		sta WSYNC              ; wait till end of scanline
		; I can do stuff here but not much 22 cpu cycles
		;check if line has sprite or next sprite
		;ldy Sprite2 ; load address od sprite
		ldx SPRITE1LINE ;3
		jmp prepSpite1  ;3
Picture1		
		ldx LINE_COUNT		
		cpx PLAYER_POS_Y
		bne PictureEOL
		lda #8
		sta SPRITE1LINE
	
		jmp PictureEOL


				;do this at the end  
PictureEOL      
		ldx LINE_COUNT
		inx
		cpx #PAL_LINES ;cycle counting
		bne Picture


;--------------------------------------------       
;--------------------------------------------

			lda #%01000010

			sta VBLANK          ; end of screen - enter blanking
 


   ; 30 scanlines of overscan...



                ldx #0

Overscan        
				sta WSYNC

                inx

                cpx #OVERSCAN_LINES

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
