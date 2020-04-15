# Subrutina izq-der

if1: # 1 0 0 0
    # IF R15 == 8
    LOAD 8 R10
    BNE R15 R10 if2
    LOAD 4 R15
    J endif

if2: # 0 1 0 0
    # IF R15 == 4
    LOAD 4 R10
    BNE R15 R10 if3
    LOAD 2 R15
    J endif

if3: # 0 0 1 0
    # IF R15 == 2
    LOAD 2 R10
    BNE R15 R10 if4
    LOAD 1 R15
    J endif

if4: # 0 0 0 1
    # IF R15 == 1
    LOAD 1 R10
    BNE R15 R10 if5
    LOAD 8 R15
    J endif
if5: # empezar en 1 0 0 0
    # IF R15 == 0
    BNE R15 R0 endif
    LOAD 8 R15
endif:

# Enviamos el resultado a los leds
OUT 0 R15
RETURN