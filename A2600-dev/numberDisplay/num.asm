; Typical first few lines in an Atari 2600 program ...
    processor 6502
    include "vcs.h"
    include "macro.h"

;Display Generation Constants 
VERT_BLANK = #30   ; 37 - lines of processing currently 7
NTSC_LINES = #192
PAL_LINES = #242
OVERSCAN_LINES = #30

;Software Constants
LINES_PER_PIXEL = 21

;memory locations 
displayLines = $80
PFColour = $81
lineCounter =$87
scratchPad1  = $88

;;;;;;;;Software entry point;;;;;;;;;;
    ORG $F000
    CLEAN_START         ; clears memory ect.
    
    lda #LINES_PER_PIXEL
    

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
    lda scratchPad1     ; loading PF colour 
    sta COLUPF          ; store PF colour
    inc scratchPad1
    sta WSYNC   ; Wait for Sync - halts CPU until end of 1st scanline of VSYNC    

    
    lda #0      ; LoaD Accumulator with 0 so D1=0
    sta WSYNC   ; wait until end of 3rd scanline of VSYNC
    sta VSYNC   ; Accumulator D1=0, turns off Vertical Sync signal
    rts         ; ReTurn from Subroutine

VerticalBlank
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)  
    
    ldx #34         ; LoaD X with 37 - 3 of the above WSYNCs
    ldy #0

vbLoop
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    dex             ; DEcrement X by 1
    bne vbLoop      ; Branch if Not Equal to 0
    rts             ; ReTurn from Subroutine

Kernel:            
    ; turn on the display
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    lda #0          ; LoaD Accumulator with 0 so D1=0
    sta VBLANK      ; Accumulator D1=1, turns off Vertical Blank signal (image output on)
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    ldx #PAL_LINES          ; Load X with 192 lines of the PAL display
    stx displayLines        ; stores current line if kernel for later recall

    ldx #LINES_PER_PIXEL         ; load X reg with value of lines per pixel

KernelLoop:
    
    sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
    
    ;Begining of visible lines 
    dex                 ;decrement lines per pixel
    bpl drawPF2         ;skip next instruction id more lines need to be drawn
    iny                 ;move y index to next PF pixel
    ldx #20             ;reset pixel line count 

    
drawPF2
    ;draw first half of the PF can be done any time before visable drawing  
    lda PFG0,y
    sta PF0
    lda PFG1,y
    sta PF1
    lda PFG2,y
    sta PF2

    ;6 cycles to play with 
    nop             ;spare time to cycle past Drawing PF
    nop             ;spare time to cycle past Drawing PF 
    nop             ;spare time to cycle past Drawing PF

    
    
    ;draw first half of the PF can be done imendiatly are PF0 has been drawn to display 
    lda PFG3,y
    sta PF0
    lda PFG4,y
    sta PF1
    lda PFG5,y
    sta PF2

KernelEndOfLine
    dec displayLines; DEcrement displaylines by 1
    bne KernelLoop  ; Branch if Not Equal to 0
    rts             ; ReTurn from Subroutine

OverScan:

    ;here I have used two lines of the opverscan just to clear the PF regs before the next frame 
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    lda #2      ; LoaD Accumulator with 2 so D1=1
    sta VBLANK  ; STore Accumulator to VBLANK, D1=1 turns image output off

    ;clear PF registers
    lda #0 
    sta PF0
    sta PF1
    sta PF2
    sta WSYNC
    
overcont

    ldx #27     ; LoaD X with 29 - 2 from the 2 borrowed scanlines
osLoop:
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    dex         ; DEcrement X by 1
    bne osLoop  ; Branch if Not Equal to 0
    rts         ; ReTurn from Subroutine


;;;;;;;;Sprites;;;;;;;;;;;;;;;;;
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
