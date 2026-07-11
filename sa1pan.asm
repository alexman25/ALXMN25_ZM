.gba
.thumb

.open "sa1.gba", "sa1c.gba", 0x08000000

.org 0x0803E51C
.area 0x0E, 0x00
    ldr r0, [pc, #4]
    bx  r0
    nop
    nop
    .word CameraAheadHook + 1
    nop
.endarea

.org 0x08800000
CameraAheadHook:
    mov  r1, r8
    ldr  r0, [r1, #0]
    asr  r0, r0, #8
    ldrh r1, [r4, #12]
    add  r0, r0, r1
    sub  r0, #120
    mov  r3, r0

    .align 4
    ldr  r1, [pc, #0]
    b    StatePointerLoaded
    .word 0x0203FFF0

StatePointerLoaded:
    ldrb r0, [r1, #2]
    cmp  r0, #0xA5
    bne  InitializeOffset

    mov   r0, #0
    ldrsh r0, [r1, r0]

    mov  r1, r8
    ldr  r1, [r1, #16]
    lsl  r1, r1, #31
    cmp  r1, #0
    beq  EaseRight

EaseLeft:
    ; Pan toward -60
    sub  r0, #2 ; Pan speed
    mov  r1, #60 ; Lookahead
    neg  r1, r1
    cmp  r0, r1
    bge  SaveOffset
    mov  r0, r1
    b    SaveOffset

EaseRight:
    ; Pan toward 60
    add  r0, #2 ; Pan speed
    mov  r1, #60 ; Lookahead
    cmp  r0, r1
    ble  SaveOffset
    mov  r0, r1
    b    SaveOffset

InitializeOffset:
    mov  r0, r8
    ldr  r0, [r0, #16]
    lsl  r0, r0, #31
    cmp  r0, #0
    beq  InitializeRight

InitializeLeft:
    mov  r0, #60 ; Lookahead
    neg  r0, r0
    b    SaveOffsetAndMarker

InitializeRight:
    mov  r0, #60 ; Lookahead

SaveOffsetAndMarker:
    .align 4
    ldr  r1, [pc, #0]
    b    MarkerPointerLoaded
    .word 0x0203FFF0

MarkerPointerLoaded:
    mov  r2, #0xA5
    strb r2, [r1, #2]
    ldrh r2, [r4, #38]
    b    StoreOffsetWithPointer

SaveOffset:
    .align 4
    ldr  r1, [pc, #0]
    b    StoreOffsetWithPointer
    .word 0x0203FFF0

StoreOffsetWithPointer:
    strh r0, [r1, #0]

    add  r0, r3, r0
    strh r0, [r4, #8]

    .align 4
    ldr  r1, [pc, #0]
    bx   r1
    .word 0x0803E52B

.close
