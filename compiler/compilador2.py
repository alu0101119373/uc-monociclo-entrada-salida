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
    for line in iFile:
        fline = line.strip()
        # Procesamos la instruccion
        if len(fline) != 0:
            instruction = ass.process(fline)
            print(instruction)
    
    print("DONE!")