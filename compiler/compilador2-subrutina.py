#!/usr/bin/env python3

import assembler as ass
import sys
from os import path

MAX_PROGRAM_SIZE = 1024
SUBRUTINES = [0,1,2,3,4]

if len(sys.argv) > 5:
    print("ERROR! The compiler only takes four parameters!")
    exit()

subrutine = int(sys.argv[1])
inFile = sys.argv[2]
outFile = sys.argv[3]

if not subrutine in SUBRUTINES:
    print("ERROR! Subrutine must be from 1 to 4")
    exit()

if not path.exists(inFile):
    print("ERROR! File does not exist!")
    exit()

print()

print("Quitting spaces...")

inFile = ass.cleaningFile(inFile)

print("Removing comments...")

inFile = ass.processComments(inFile)

print("Processing complex instructions...")

inFile = ass.processComplexInstructions(inFile)

print("Processing tags...")

fill = subrutine != 0

if int(subrutine) == 0:
    desp = int(sys.argv[4])
    subrutine = desp
elif int(subrutine) == 1:
    subrutine = 824
elif int(subrutine) == 2:
    subrutine = 874
elif int(subrutine) == 3:
    subrutine = 924
elif int(subrutine) == 4:
    subrutine = 974
else:
    print("ERROR! Subrutine not valid!")
    exit()

inFile = ass.processTags(inFile, subrutine)

print("Starting compilation process...\n")

# Leemos el fichero
cont = 0
oFile = open(outFile, "w")
with open(inFile) as iFile:
    for index, line in enumerate(iFile):
        fline = line.strip()
        # Procesamos la instruccion
        if len(fline) != 0:
            print("Processing instruction {:3}: {:15}, ".format(str(index+1).zfill(3), fline), end=" ")
            instruction = ass.divideInstruction(fline)
            instruction = ass.process(instruction)
            binary = instruction.toBinary()
            oFile.write(ass.formatBinaryInstruction(binary) + '\n')
            cont += 1
            print(binary)

print("\nTotal processed instructions: {}".format(cont))

if fill:
    if cont < 50:
        for i in range(cont+1, 51):
            oFile.write("0000_0000_0000_0000\n")
            cont += 1

print("\t(from line {} to line {})\n".format(subrutine, subrutine+cont-1))

oFile.close()

print("DONE!")