.include "cpctelera.h.s"
.include "man/entity.h.s"

.globl man_entity_for_all

sys_physics_init:
    ;; TODO: implement physics init code  
    ret

sys_physics_update_one_entity: ;; update entity load in DE 
    ld h, d
    ld l, e
    inc hl 
    ld a, (hl) ;; load position x in A
    inc hl 
    inc hl 
    add a, (hl) ;; add to A the velocity in x
    dec hl 
    dec hl 
    ld (hl), a
    ret

sys_physics_update:
    ld hl, #sys_physics_update_one_entity
    call man_entity_for_all
    ret
