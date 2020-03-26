# Programa para comprobar el correcto funcionamiento de la entrada-salida,
# el timer y el gestor de interrupciones en la CPU.
# Este programa se encargara de controlar los botones de incremento y decremento del timer.
#####################################

# Datos iniciales
LOAD 5 R13 # Valor inicial del timer
LOAD 5 R14
LOAD 1 R15
LOAD 5 R5  # Valor minimo valido para la velocidad del timer
LOAD 25 R6 # Valor maximo valido para la velocidad del timer

# Bucle para control de los botones
while:
    # Actualizamos las entradas
    ADD R2 R0 R1
    ADD R3 R4 R0
    
    IN 2 R2
    IN 3 R4

    # Comprobamos los botones de incremento y decremento
    if1:
        LOAD 1 R9 # Registro auxiliar para comprobaciones
        BNE R1 R9 if2
        BNE R1 R0 if2
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
            BEQ R13 R5 end_if2_if
            SUB R13 R14 R13
        end_if2_if:
    endif:

    # Mandamos el tiempo de pulso al timer
    OUT 3 R13
    J while