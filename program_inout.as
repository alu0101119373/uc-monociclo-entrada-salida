# Programa para comprobar el correcto funcionamiento de la entrada-salida
# en la CPU.
# Se intentará encender los bordes de todos los displays de 7 segmentos
ADD R0 R0 R0
IN 0 R1
IN 1 R2
ADD R1 R2 R3
OUT 0 R3