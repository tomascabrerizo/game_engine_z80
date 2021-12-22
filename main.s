.include "cpctelera.h.s"
.include "man/entity.h.s"

;; add a comment

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm
.globl cpct_memset_asm
.globl cpct_memcpy_asm

.globl man_entity_init
.globl man_entity_create
.globl man_entity_destroy

.globl sys_physics_update 

generate_star: ;; generate a default star
    call man_entity_create
    ld h, d
    ld l, e
    ld (hl), #E_TYPE_STAR
    inc hl
    ld (hl), #79
    inc hl
    ld (hl), #1 ;; TODO: set random y position
    inc hl
    ld (hl), #-1 ;; TODO: set random xvel
    inc hl
    ld (hl), #0xFF
    inc hl
    ld (hl), #0x00
    inc hl
    ld (hl), #0x00
    ret

_main::
    call cpct_disableFirmware_asm
    call man_entity_init
    ;; test the entity create function
    ld a, #0x05
entity_create_loop:
    dec a
    call generate_star
    jr nz, entity_create_loop
    
    call sys_physics_update 
loop:
   jr    loop
