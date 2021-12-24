.include "cpctelera.h.s"
.include "man/entity.h.s"

.globl cpct_memcpy_asm
.globl cpct_getRandom_mxor_u8_asm

.globl man_entity_create
.globl man_entity_free_space

default_gen_entity:
    .db E_TYPE_STAR ;; type
    .db 79 ;; pos x
    .db 1 ;; pos y
    .db -1 ;; velx
    .db #0xF0 ;; color
    .dw #0x0000


generate_new_star: ;; generate a default star
    call man_entity_create
    ld hl, #default_gen_entity
    ld bc, #ENTITY_SIZE
    push de
    call cpct_memcpy_asm 
    ;; get random number in l
    call cpct_getRandom_mxor_u8_asm 
    pop de
    ;; randomize position y
    inc de
    inc de
    ld a, l
    and a, #0x7f
    ld (de), a
    push de
    ;; get random number in l
    call cpct_getRandom_mxor_u8_asm 
    pop de
    ;; randomize x velocity 
    inc de
    ld a, l
    and a, #0x03
    sub a, #0x04
    ld (de), a
    ret

sys_generator_update:
    call man_entity_free_space
    jr z, generator_update_end
    call generate_new_star
    generator_update_end:
    ret
