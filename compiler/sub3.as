# Subrutina izq-der acc

if1: # 1 0 0 0
    # IF R15 == 8
    LOAD 8 R10
    BNE R15 R10 if2
    LOAD 12 R15
    J endif

if2: # 1 1 0 0
    # IF R15 == 12
    LOAD 12 R10
    BNE R15 R10 if3
    LOAD 14 R15
    J endif

if3: # 1 1 1 0
    # IF R15 == 14
    LOAD 14 R10
    BNE R15 R10 if4
    LOAD 15 R15
    J endif

if4: # 1 1 1 1
    # IF R15 == 15
    LOAD 15 R10
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
POP