.include "cpctelera.h.s"
.include "man/entity.h.s"

.globl man_entity_for_all
.globl man_entity_set4destruction

sys_physics_init:
    ;; TODO: implement physics init code  
    ret

sys_physics_update_one_entity: ;; update entity load in DE 
    ;; TODO: check if the star need to be destroy
    ld h, d
    ld l, e
    inc hl 
    ld a, (hl) ;; load position x in A
    inc hl 
    inc hl 
    add a, (hl) ;; add to A the velocity in x
    push af
    dec hl
    dec hl
    and a, #0x80 ;; test if a is negative
    jr z, update_x 
    call man_entity_set4destruction
    update_x:
    pop af
    ld (hl), a
    ret

sys_physics_update:
    ld hl, #sys_physics_update_one_entity
    call man_entity_for_all
    ret
