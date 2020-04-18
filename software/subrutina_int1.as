# Subrutina de la interrupcion 1

# IF R7 == 0: izquierda a derecha
# IF R7 == 1: derecha a izquierda
# IF R7 == 2: izquierda a derecha acc
# IF R7 == 3: parpadeo

if0:
    BNE R7 R0 if1
    LINK 50
    J endif
if1:
    LOAD 1 R10
    BNE R7 R10 if2
    LINK 73
    J endif
if2:
    LOAD 2 R10
    BNE R7 R10 if3
    LINK 96
    J endif
if3:
    LOAD 3 R10
    BNE R7 R10 endif
    LINK 119
endif:
FREE