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

print()

print("Quitting spaces...")

inFile = ass.cleaningFile(inFile)

print("Removing comments...")

inFile = ass.processComments(inFile)

print("Processing complex instructions...")

inFile = ass.processComplexInstructions(inFile)

print("Processing tags...")

inFile = ass.processTags(inFile)

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

print("\nTotal processed instructions: {}\n".format(cont))

if cont < 823:
    for i in range(cont+1, 825):
        oFile.write("0000_0000_0000_0000\n")

    if path.isfile("subrutina1.dat") and not outFile == "subrutina1.dat":
        with open("subrutina1.dat") as subFile:
            for line in subFile:
                oFile.write(line)
    else:
        for i in range(0, 50):
            oFile.write("0000_0000_0000_0000\n")

    if path.isfile("subrutina2.dat") and not outFile == "subrutina2.dat":
        with open("subrutina2.dat") as subFile:
            for line in subFile:
                oFile.write(line)
    else:
        for i in range(0, 50):
            oFile.write("0000_0000_0000_0000\n")

    if path.isfile("subrutina3.dat") and not outFile == "subrutina3.dat":
        with open("subrutina3.dat") as subFile:
            for line in subFile:
                oFile.write(line)
    else:
        for i in range(0, 50):
            oFile.write("0000_0000_0000_0000\n")

    if path.isfile("subrutina4.dat") and not outFile == "subrutina4.dat":
        with open("subrutina4.dat") as subFile:
            for line in subFile:
                oFile.write(line)
    else:
        for i in range(0, 50):
            oFile.write("0000_0000_0000_0000\n")

oFile.close()

print("DONE!")