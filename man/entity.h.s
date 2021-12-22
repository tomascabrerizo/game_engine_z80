;; entity definition (7 bytes)
;; 0 -> entity type
;; 1 -> position x
;; 2 -> position y
;; 3 -> velocity x
;; 4 -> color
;; 5 
;;  |-> 2 bytes ptr to the old vmem position
;; 6

;; entity types
E_TYPE_INVALID = 0x00
E_TYPE_STAR    = 0x01
E_TYPE_DEAD    = 0x7f

;; create array for entities 
ENTITY_SIZE = 7 ;; each entity use 7 bytes
MAX_ENTITIES = 40 
ENTITY_ARRAY_SIZE = ENTITY_SIZE * MAX_ENTITIES
