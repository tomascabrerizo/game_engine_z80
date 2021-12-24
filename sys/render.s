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
    inc hl
    ;; clear the old vmem position 
    ld a, (hl)
    or a, #0x00 ;; check if the prev vmem is valid
    inc hl
    jr nz, clear_prev_vmem
    ld a, (hl)
    or a, #0x00 ;; check if the prev vmem is valid
    jr z, render_entity
    ;; the vmem is valid clear it
    clear_prev_vmem:
    ld d, (hl)
    dec hl
    ld e, (hl)
    ld a, #0x00
    ld (de), a
    ;; render entity 
    render_entity:
    pop de
    push de
    ld a, (de)
    and a, #E_TYPE_DEAD
    jp nz, render_one_entity_end
    ld de, #CPCT_VMEM_START_ASM
    call cpct_getScreenPtr_asm
    ;; render vmem position with entity color
    pop de
    push de
    inc de
    inc de
    inc de
    inc de
    ld a, (de)
    ld (hl), a
    ;; save low prev vmem ptr
    ;; save high prev vmem ptr
    pop de
    push de
    inc de
    inc de
    inc de
    inc de
    inc de
    ld a, l
    ld (de), a
    inc de
    ld a, h
    ld (de), a
    render_one_entity_end:
    pop de
    ret

sys_render_update:
    ld hl, #sys_render_update_one_entity
    call man_entity_for_all
    ret
