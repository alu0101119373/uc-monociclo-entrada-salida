# Programa para pruebas
LOAD 1 R1
LOAD 2 R2
ADD R1 R2 R3
LOAD 3 R4
SUB R3 R4 R0
SKNZ		# En caso de que no se active el flag de Z, se salta a la siguiente instruccion
ADD R3 R3 R3
ADD R3 R0 R3
