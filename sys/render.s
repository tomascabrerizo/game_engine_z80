.include "cpctelera.h.s"
.include "man/entity.h.s"

.globl cpct_getScreenPtr_asm 
.globl man_entity_for_all

sys_render_init:
    ;; TODO: implement render init code  
    ret

;; TODO: make this routine smaller
sys_render_update_one_entity: ;; update entity load in DE 
    push de ;; save entity address
    ex de, hl
    inc hl
    ld c, (hl) ;; load in C, x position
    inc hl
    ld b, (hl) ;; load in B, y position
    inc hl
    inc hl
    ld a, (hl) ;; load entity color in A
    push af ;; save entity color
    ;; clear the old vmem position 
    inc hl
    ld a, (hl)
    or a, #0x00 ;; check if the prev vmem is valid
    jr z, render_entity
    inc hl
    ld a, (hl)
    or a, #0x00 ;; check if the prev vmem is valid
    jr z, render_entity
    ;; the vmem is valid clear it
    ld e, (hl)
    dec hl
    ld d, (hl)
    ld a, #0x00
    ld (de), a
    render_entity: ;; render entitie
    ld de, #0xc000
    call cpct_getScreenPtr_asm
    pop af
    ld (hl), a 
    pop de
    push de
    ld a, #0x5
    add a, e
    ld e, a
    ld a, d
    adc a, #0x00
    ld d, a
    ;; save low prev vmem ptr
    ld a, l
    ld (de), a
    ;; save high prev vmem ptr
    inc de
    ld a, h
    ld (de), a
    pop de
    ret

sys_render_update:
    ld hl, #sys_render_update_one_entity
    call man_entity_for_all
    ret
