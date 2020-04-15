# Subrutina de la interrupcion 1

# IF R7 == 0: izquierda a derecha
# IF R7 == 1: derecha a izquierda
# IF R7 == 2: izquierda a derecha acc
# IF R7 == 3: parpadeo

if0:
    BNE R7 R0 if1
    