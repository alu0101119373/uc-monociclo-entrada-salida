# Subrutina parpadeo

if1: # 1 1 1 1
    # IF R15 == 15
    LOAD 15 R10
    BNE R15 R10 if2
    LOAD 0 R15
    J endif

if2: # 0 0 0 0
    # IF R15 == 0
    BNE R15 R0 endif
    LOAD 15 R15
    J endif
endif:

# Enviamos el resultado a los leds
OUT 0 R15
RETURN