#!/usr/bin/env python3

import assembler
import sys

MAX_PROGRAM_SIZE = 1024

if len(sys.argv) != 3:
    print("ERROR! The compiler only takes two parameters!")
    exit()

inputFileName = sys.argv[1]
outputFileName = sys.argv[2]

rf = open(inputFileName, "r")
wf = open(outputFileName, "w")

data = rf.read()

instructions = [ x for x in data.split('\n') if not x == '' ]

cont = 0
for instruction in instructions:
    # Takes all the parts from the instruction
    part = instruction.split()
    
    opcode = part[0]
    rest = part[1:]

    binaryInstruction = assembler.PARSER[opcode]

    for d in rest:
        if not d.isdigit():
            binaryInstruction += assembler.REGISTER[d]
        else:
            binaryInstruction += assembler.inmTo8bit(int(d))

    binaryInstruction = assembler.formatBinaryInstruction(binaryInstruction)

    print(binaryInstruction)
    wf.write(binaryInstruction + "\n")

    cont += 1

if cont < MAX_PROGRAM_SIZE:
    while cont < MAX_PROGRAM_SIZE:
        wf.write("0000_0000_0000_0000\n")
        cont += 1
elif cont > MAX_PROGRAM_SIZE:
    print("WARNING! The program file exceeds the maximun words indicated!")
