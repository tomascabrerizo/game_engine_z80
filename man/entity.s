.include "cpctelera.h.s"
.include "man/entity.h.s"

.globl cpct_disableFirmware_asm
.globl cpct_memset_asm
.globl cpct_memcpy_asm

entities:
    .ds ENTITY_ARRAY_SIZE 
aditional_zero:
    .db #0x00 ;; aditional zero byte at the end of the entity array
next_free_entity:
    .dw #0x0000
entity_count:
    .db #0x00

man_entity_init:
    ;; set all entities to invalid
    ld de, #entities
    ld a, #E_TYPE_INVALID
    ld bc, #ENTITY_ARRAY_SIZE 
    call cpct_memset_asm
    ;; set next_free_entity to the first entity
    ld hl, #entities 
    ld (next_free_entity), hl
    ret

man_entity_create: ;; this function return the new entity ptr in DE 
    push af
    ;; increment entity count
    ld a, (#entity_count)
    inc a
    ld (#entity_count), a
    ld hl, (next_free_entity)
    ;; save in bc the new entity position
    ld d, h
    ld e, l
    ;; calculate and set the next free entity
    ld a, l
    add a, #ENTITY_SIZE
    ld l, a
    ld a, h
    adc a, #0x00
    ld h, a
    ld (next_free_entity), hl
    pop af
    ret

man_entity_destroy: ;; should have in DE the entity ptr to be destory
    push af
    ;; decrement entity count
    ld a, (#entity_count)
    dec a
    ld (#entity_count), a
    ;; calculate the last entity position
    ld hl, (#next_free_entity) ;; load the last entity in HL
    ld a, l
    sub a, #ENTITY_SIZE
    ld l, a
    ld a, h
    sbc a, #0x00
    ld h, a
    push de ;; save the entity position
    push hl ;; save the last entity position
    ;; copy the last entity in the destroy one
    ld bc, #ENTITY_SIZE 
    call cpct_memcpy_asm
    pop hl ;; recover the last entity position
    pop de ;; recover the entity position
    ;; invalid the last entity
    ld (hl), #E_TYPE_INVALID
    ;; set next free entity
    ld (#next_free_entity), hl
    pop af
    ret

call_fnc_ptr: ;; call function ptr in HL destroys BC 
    push hl ;; save the function pointer
    ld bc, #.+5
    push bc;; set return address
    jp (hl)
    pop hl ;; recover the function pointer
    ret

man_entity_for_all: ;; loop all valid entities and call the function saved in HL
    ld de, #entities
    ;; check if the entity is valid
    start_entity_loop:
    ld a, (de)
    or a, #E_TYPE_INVALID
    jr z, end_entity_loop 
    ;; call the specific system function
    call call_fnc_ptr
    ;; increment to the next entity
    ld a, e
    add a, #ENTITY_SIZE
    ld e, a
    ld a, d
    adc a, #0x00
    ld d, a
    jr start_entity_loop
    end_entity_loop:
    ret

man_entity_set4destruction: ;; set de entity in DE to be destroy
    ld a, (de)
    or a, #E_TYPE_DEAD
    ld (de), a
    ret

man_entity_update:
    ld de, #entities
    ;; check if the entity is valid
    entity_loop:
    ld a, (de)
    or a, #E_TYPE_INVALID
    jr z, #entity_update_end 
    and a, #E_TYPE_DEAD
    jr z, entity_not_dead
    call man_entity_destroy
    jr entity_loop
    entity_not_dead:
    ;; increment to the next entity
    ld a, e
    add a, #ENTITY_SIZE
    ld e, a
    ld a, d
    adc a, #0x00
    ld d, a
    jr #entity_loop
    entity_update_end:
    ret

man_entity_free_space: ;; return A with the amount of space
    ld a, (#entity_count)
    ld b, a
    ld a, #MAX_ENTITIES
    sub a, b ;; the z bit is set if there is no space
    ret
