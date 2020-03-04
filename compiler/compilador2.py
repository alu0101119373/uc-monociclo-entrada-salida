#!/usr/bin/env python3

import assembler as ass
import sys
from os import path

MAX_PROGRAM_SIZE = 1024

if len(sys.argv) != 3:
    print("ERROR! The compiler only takes two parameters!")
    exit()

inFile = sys.argv[1]
outFile = sys.argv[2]

if not path.exists(inFile):
    print("ERROR! File does not exist!")
    exit()

# Leemos el fichero
with open(inFile) as iFile:
    oFile = open(outFile, "w")
    for line in iFile:
        fline = line.strip()
        print("Processing instruction: {:15}, ".format(fline), end=" ")
        # Procesamos la instruccion
        if len(fline) != 0:
            instruction = ass.divideInstruction(fline)
            if ass.isComplex(instruction):
                context = ass.ComplexContext()
                # Valoramos el tipo de instruccion que es
                context.setInstruction(ass.analyzeComplexInstruction(instruction))
                binary = context.toBinary(instruction)
                for index, ins in enumerate(binary):
                    oFile.write(ass.formatBinaryInstruction(ins) + '\n')
                    print("{:16}".format(ins), end="")
                    if index < len(binary) - 1:
                        print(",", end=" ")
                    else:
                        print()
            else:
                instruction = ass.process(instruction)
                binary = instruction.toBinary()
                oFile.write(ass.formatBinaryInstruction(binary) + '\n')
                print(binary)
    
    print("DONE!")