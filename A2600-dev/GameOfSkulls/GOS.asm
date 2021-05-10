; Typical first few lines in an Atari 2600 program ...
    processor 6502
    include "vcs.h"
    include "macro.h"

    ORG $F000
    CLEAN_START
    VERTICAL_SYNC
    
    


    ORG $FFFE
    .word $F000
