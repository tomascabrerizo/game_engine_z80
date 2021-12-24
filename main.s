.include "cpctelera.h.s"
.include "man/entity.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm
.globl cpct_waitVSYNC_asm
.globl cpct_memset_asm
.globl cpct_memcpy_asm

.globl man_entity_init
.globl man_entity_update

.globl sys_physics_init
.globl sys_physics_update 

.globl sys_generator_update

.globl sys_render_init
.globl sys_render_update 

_main::
    call cpct_disableFirmware_asm
    call man_entity_init
loop:
    call sys_physics_update 
    call sys_generator_update
    call sys_render_update

    call man_entity_update
    call cpct_waitVSYNC_asm
    jr    loop
