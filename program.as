# Programa para pruebas
# Este programa crea un bucle for y va acumulando los valores hasta
# llegar a 10
#
# Equivalencia:
# int acc = 0;
# for (int i = 1; i < 10; i++) {
# 	acc = acc + 1;
# }
# acc = acc + 0;
#
# Variables globales
LOAD 10 R15	# 10

LOAD 1 R14	# inm para acumular

LOAD 0 R2	# acc

LOAD 1 R1	# i
for:
	BGE R1 R15 finfor
	ADD R2 R14 R2
	J for
finfor:
	ADD R2 R0 R0

