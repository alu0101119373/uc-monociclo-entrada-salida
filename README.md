# PRÁCTICA 2: Diseño de una CPU monociclo

## Objetivo

El objetivo de esta práctica es desarrollar una CPU básica monociclo, e implementarse mejoras a la misma. En concreto, esta CPU posee las siguientes características:

- Tiene una palabra de 16 bits (2 Bytes).
- Es capaz de trabajar con un máximo de 64 microinstrucciones, de las cuales 16 son instrucciones de salto, 4 son instrucciones de carga inmediata y 8 son instrucciones de la ALU.

- Posee una memoria de programa con un máximo de 1024 instrucciones. Esto implica que el programa que se desee ejecutar debe tener un máximo de 1024 instrucciones.
- El camino de datos de esta CPU es el siguiente:

![Camino de datos de la CPU monociclo base](./img/cdCPUBase.png)

## Mejoras

Por ahora no se ha realizado ninguna mejora de esta CPU.

## Compilación

Para compilar el proyecto, se debe situar la terminal en la raíz del mismo y ejecutar el siguiente comando:

```bash

	iverilog -c datafiles.txt -o cpu.out cpu_tb.v cpu.v

```

El fichero `datafiles.txt` contiene una lista de los ficheros `.v` necesarios para la correcta compilación del programa.

Este comando compilará el proyecto y generará el fichero `cpu.out`. Para poder ejecutar el fichero y ver el resultado con GTKWave, hacemos uso del comando `vvp cpu.out`. Esto generará el fichero `cpu_tb.vcd` el cual podemos utilizar para ver la ejecución de la CPU en GTKWave con el comando `gtkwave cpu_tb.vcd`.

Para poner a prueba esta CPU monociclo, **el programa debe ser escrito en el fichero progfile.dat**, en binario y siguiendo el formato de palabra indicado.

## Formato de palabra

Como se ha mencionado antes, esta CPU es capaz de trabajar con un máximo de 64 instrucciones. El formato para cada instrucción es el siguiente:

- Instrucciones para salto:

![Palabra para instrucción de salto](./img/palSalto.png)

- Instrucciones para carga inmediata

![Palabra para instrucción de carga](./img/palLoad.png)

- Instrucciones para operaciones aritmético-lógica.

![Palabra para instrucción de la ALU](./img/palALU.png)

## Microinstrucciones implementadas

Las instrucciones implementadas actualmente se representan en la siguiente tabla:

### Instrucciones de carga
| MICROINSTRUCCIÓN | OPCODE | DESCRIPCIÓN                               |
| :--------------: | :----: | :---------------------------------------- |
| **LOAD**         | 1000   | Carga un determinado valor en un registro |
| **??**           | 1001   | ??                                        |
| **??**           | 1010   | ??                                        |
| **??**           | 1011   | ??                                        |

### Instrucciones de salto
| MICROINSTRUCCIÓN | OPCODE | DESCRIPCIÓN                              |
| :--------------: | :----: | :--------------------------------------- |
| **J**            | 110000 | Salto incondicional                      |
| **JZ**           | 110001 | Salto si el flag de 0 está activo        |
| **JNZ**          | 110010 | Salto si el flag de 0 **no** está activo |
| **??**           | 110011 | ??                                       |
| **??**           | 110100 | ??                                       |
| **??**           | 110101 | ??                                       |
| **??**           | 110110 | ??                                       |
| **??**           | 110111 | ??                                       |
| **??**           | 111000 | ??                                       |
| **??**           | 111001 | ??                                       |
| **??**           | 111010 | ??                                       |
| **??**           | 111011 | ??                                       |
| **??**           | 111100 | ??                                       |
| **??**           | 111101 | ??                                       |
| **??**           | 111110 | ??                                       |
| **??**           | 111111 | ??                                       |

### Instrucciones aritmético-lógicas
| MICROINSTRUCCIÓN | OPCODE | DESCRIPCIÓN                               |
| :--------------: | :----: | :---------------------------------------- |
| **ADD**          | 0010   | Suma                                      |
| **SUB**          | 0011   | Resta                                     |
| **AND**          | 0100   | Operación AND entre los bits              |
| **OR**           | 0101   | Operación OR entre los bits               |
| **NOT**          | 0001   | Niega los bits del valor introducido      |
| **SELF**         | 0000   | Devuelve el mismo valor que el de entrada |
| **NFOP**         | 0110   | Niega el primer operando                  |
| **NSOP**         | 0111   | Niega el segundo operando                 |

Como se puede observar, el repertorio de instrucciones de salto y de carga inmediata puede ser ampliado.
