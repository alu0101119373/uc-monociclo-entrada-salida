# Programa para comprobar el correcto funcionamiento de la entrada-salida,
# el timer y el gestor de interrupciones en la CPU.
# Este programa se encargara de controlar los botones de incremento y decremento del timer.
#####################################

# Datos iniciales
LOAD 50 R13 # Valor inicial del timer
LOAD 50 R14 # Valor de suma/resta para el timer
LOAD 50 R5  # Valor minimo valido para la velocidad del timer
LOAD 250 R6 # Valor maximo valido para la velocidad del timer

# Carga inicial al timer
OUTI 50 3

# Valores iniciales
LOAD 0 R1
LOAD 0 R3
LOAD 0 R7 # Registro que indica el tipo de recorrido

# Bucle para control de los botones
while:
    
    # Cargamos los valores del pulsador
    IN 2 R2 # incremento
    IN 3 R4 # decremento
    IN 0 R8 # tipo de recorrido

    # Comprobamos los botones de incremento y decremento
    if0:
        LOAD 1 R9
        BNE R8 R0 if1
        BNE R11 R9 if1
            LOAD 3 R9
            if0_if1:
                BNE R7 R9 else_if0_if1
                LOAD 0 R7
                J endif
            else_if0_if1:
                LOAD 1 R9
                ADD R7 R9 R7
                J endif
    if1:
        LOAD 1 R9 # Registro auxiliar para comprobaciones
        BNE R1 R9 if2
        BNE R2 R0 if2
        if1_if: # Comprobamos el valor maximo
            BEQ R13 R6 end_if1_if
            ADD R13 R14 R13
        end_if1_if:
        J endif
    if2:
        LOAD 1 R9
        BNE R3 R9 endif
        BNE R4 R0 endif
        if2_if: # Comprobamos el valor minimo
            BEQ R13 R5 endif
            SUB R13 R14 R13
    endif:

    # Mandamos el tiempo de pulso al timer
    OUT 3 R13

    # Actualizamos las entradas
    ADD R2 R0 R1
    ADD R0 R4 R3
    ADD R8 R0 R11

    J while