.include "cpctelera.h.s"
.include "man/entity.h.s"

.globl man_entity_for_all

sys_physics_init:
    ;; TODO: implement physics init code  
    ret

sys_physics_update_one_entity: ;; update entity load in DE 
    ;; TODO: implement update one entity
    ret

sys_physics_update:
    ld hl, #sys_physics_update_one_entity
    call man_entity_for_all
    ret
