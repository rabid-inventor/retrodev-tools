; Typical first few lines in an Atari 2600 program ...
    processor 6502
    include "vcs.h"
    include "macro.h"

;Screen defines 
VERT_BLANK = #30   ; 37 - lines of processing currently 7
NTSC_LINES = #192
PAL_LINES = #242
OVERSCAN_LINES = #30

;memory locations 
displayLines = $80
PFShad0 = $81
PFShad1 = $82
PFShad2 = $83
PFShad3 = $84
PFShad4 = $85
PFShad5 = $86
line_counter =$87
spad_1  = $88

;;;;;;;;Software entry point;;;;;;;;;;
    ORG $F000
    CLEAN_START
    lda #15 
    sta spad_1
    lda #21
    sta line_counter ;stores number of lines per data line
Main
    jsr VerticalSync    ; Jump to SubRoutine VerticalSync
    jsr VerticalBlank   ; Jump to SubRoutine VerticalBlank
    jsr Kernel          ; Jump to SubRoutine Kernel
    jsr OverScan        ; Jump to SubRoutine OverScan
    jmp Main            ; JuMP to Main

VerticalSync
    lda #2      ; LoaD Accumulator with 2 so D1=1
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    
    sta VSYNC   ; Accumulator D1=1, turns on Vertical Sync signal
    lda spad_1    ; loading PF colour 
    sta COLUPF  ; store PF colour
    inc spad_1
    sta WSYNC   ; Wait for Sync - halts CPU until end of 1st scanline of VSYNC    


    ;sta WSYNC   ; wait until end of 2nd scanline of VSYNC
    
    ;dec line_counter
    lda #0      ; LoaD Accumulator with 0 so D1=0
    sta WSYNC   ; wait until end of 3rd scanline of VSYNC
    sta VSYNC   ; Accumulator D1=0, turns off Vertical Sync signal
    rts         ; ReTurn from Subroutine

VerticalBlank
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    inc PFShad0
    lda PFShad0
    sta COLUBK
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)  
    
    ldx #34         ; LoaD X with 37 - 3 of the above WSYNCs

    ldy #0

vbLoop
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
      ; Wait for SYNC (halts CPU until end of scanline)
    dex             ; DEcrement X by 1
    bne vbLoop      ; Branch if Not Equal to 0
    rts             ; ReTurn from Subroutine

Kernel:            
; turn on the display
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    lda #0          ; LoaD Accumulator with 0 so D1=0
    sta VBLANK      ; Accumulator D1=1, turns off Vertical Blank signal (image output on)
    sta WSYNC
; draw the screen        
    ldx #PAL_LINES        ; Load X with 192
    stx displayLines
;loadin initalPF
                  ;set background colour
    ;stx COLUBK      ; STore X into TIA's background color register
    ldx line_counter
    cpx #20
    bne KernelLoop
    ldx #20

KernelLoop:

    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    dex
    bpl drawPF2
    iny

    
drawPF2
    lda PFG0,y
    sta PF0
    lda PFG1,y
    sta PF1
    lda PFG2,y
    sta PF2
    nop
    nop
    lda PFG3,y
    sta PF0
    lda PFG4,y
    sta PF1
    lda PFG5,y
    sta PF2

Kendline
    cpx #0
    bpl Kendline2
    ldx line_counter
    cpx #20
    bpl Kendline2
    ldx #20 
    
Kendline2
    dec displayLines; DEcrement displaylines by 1
    bne KernelLoop  ; Branch if Not Equal to 0
    rts             ; ReTurn from Subroutine

OverScan:
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    lda #2      ; LoaD Accumulator with 2 so D1=1
    sta VBLANK  ; STore Accumulator to VBLANK, D1=1 turns image output off

    lda #0 
    sta PF0
    sta PF1
    sta PF2
    sta WSYNC
    
overcont

    ldx #26     ; LoaD X with 27
osLoop:
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    dex         ; DEcrement X by 1
    bne osLoop  ; Branch if Not Equal to 0
    rts         ; ReTurn from Subroutine


;;;;;;;;Sprites;;;;;;;;;;;;;;;;;

spritePFOutlines
    .byte %11111111
    .byte %00010000
    .byte %10000000
    .byte %00000000

PFsetup
    .byte 0,0,0,0,0,0
    .byte 1,3,3,3,3,2

PFG0
    .byte %11111111
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %11111111

PFG1
    .byte %11111111
    .byte %00000000
    .byte %11110000
    .byte %00110000
    .byte %00110000
    .byte %11110000
    .byte %11000000
    .byte %11000000
    .byte %11110000
    .byte %00000000
    .byte %11111111

PFG2
    .byte %11111111
    .byte %00000000
    .byte %00001111
    .byte %00001100
    .byte %00001100
    .byte %00001111
    .byte %00001100
    .byte %00001100
    .byte %00001111
    .byte %00000000
    .byte %11111111
PFG3
    .byte %11111111
    .byte %00000000
    .byte %11110000
    .byte %10010000
    .byte %10010000
    .byte %10010000
    .byte %10010000
    .byte %10010000
    .byte %11110000
    .byte %00000000
    .byte %11111111


PFG4
    .byte %11111111
    .byte %00000000
    .byte %00111100
    .byte %00100100
    .byte %00100100
    .byte %00100100
    .byte %00100100
    .byte %00100100
    .byte %00111100
    .byte %00000000
    .byte %11111111
PFG5
    .byte %11111111
    .byte %10000000
    .byte %10110110
    .byte %10110110
    .byte %10110110
    .byte %10110110
    .byte %10000000
    .byte %10110110
    .byte %10110110
    .byte %10000000
    .byte %11111111




;;;;;;;;;Reset vectors;;;;;;;;;;;;;
    seg
    ORG $FFFA
    .word $F000
    .word $F000
    .word $F000
