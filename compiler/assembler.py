#!/usr/bin/env python3

import re
import os

PARSER = {
    "ADD" : '0010',
    "SUB" : '0011',
    "AND" : '0100',
    "OR"  : '0101',
    "NOT" : '0001',
    "SELF": '0000',
    "NFOP": '0110',
    "NSOP": '0111',
    "J"   : '110000',
    "JZ"  : '110001',
    "JNZ" : '110010',
    "JN"  : '110011',
    "LINK": '110100',
    "RETURN" : '110101',
    "SKZ"  : '110110',
    "SKNZ" : '110111',
    "FREE" : '111000',
    "LOAD": '1000',
    "IN"  : '1001',
    "OUT" : '1010'
}

UNIQUE = ["LINK", "RETURN", "SKZ", "SKNZ", "FREE"]

COMPLEX = ["BEQ", "BNE", "BGT", "BGE", "BLT", "BLE"]

REGISTER = {
    "R0": "0000",
    "R1": "0001",
    "R2": "0010",
    "R3": "0011",
    "R4": "0100",
    "R5": "0101",
    "R6": "0110",
    "R7": "0111",
    "R8": "1000",
    "R9": "1001",
    "R10": "1010",
    "R11": "1011",
    "R12": "1100",
    "R13": "1101",
    "R14": "1110",
    "R15": "1111"
}

regexTag = r"^[A-Za-z]\w*:[ ]*$"

def getFileName (path):
    return os.path.split(path)[1]

def cleaningFile (filename):
    resultFile = "/tmp/{}.clean".format(getFileName(filename))
    with open(filename) as ifile:
        with open(resultFile, 'w') as ofile:
            for line in ifile:
                fline = line.strip()
                if fline != "":
                    ofile.write(fline + '\n')
    return resultFile

def processComments (filename):
    resultFile = "/tmp/{}.noc".format(getFileName(filename))
    with open(filename) as ifile:
        with open(resultFile, 'w') as ofile:
            for line in ifile:
                if line[0] != '#':
                    index = 0
                    try:
                        index = line.index('#')
                    except ValueError:
                        pass
                    if index != 0:
                        ofile.write(line[:index] + '\n')
                    else:
                        ofile.write(line)
            ofile.write('\n')
    return resultFile

def processComplexInstructions (filename):
    resultFile = "/tmp/{}.nci".format(getFileName(filename))
    with open(filename) as ifile:
        with open(resultFile, 'w') as ofile:
            for line in ifile:
                if re.search(regexTag, line) == None and line.strip() != "":
                    context = ComplexContext()
                    parts = divideInstruction(line)
                    if isComplex(parts):
                        context.setInstruction(analyzeComplexInstruction(parts))
                        nativeInstructions = context.getNativeInstructions(parts)
                        for ins in nativeInstructions:
                            ofile.write(ins.__str__() + '\n')
                    else:
                        ofile.write(line)
                else:
                    ofile.write(line)
    return resultFile

def processTags (filename):
    resultFile = "/tmp/{}.tags".format(getFileName(filename))
    tags = readTags(filename)
    with open(filename) as ifile:
        with open(resultFile, 'w') as ofile:
            for line in ifile:
                if line.strip() != "":
                    if re.search(regexTag, line) == None:
                        wline = []
                        splitting = [ word.strip() for word in line.split() if line.strip() != "" ]
                        for word in splitting:
                            if word in tags:
                                wline.append(str(tags[word]))
                            else:
                                wline.append(word)
                        wline = (' ').join(wline)
                        ofile.write(wline + '\n')
    return resultFile


def readTags (filename):
    dic = {}
    with open(filename) as file:
        cont = 0
        for index, line in enumerate(file):
            if re.search(regexTag, line) != None:
                cont += 1
                key = line.strip()[:line.index(':')]
                dic[key] = index - cont + 1
    return dic

def formatBinaryInstruction(bInstruction):
    result = ""
    if len(bInstruction) == 16:
        result = bInstruction[:4] + "_" + bInstruction[4:8] + "_" + bInstruction[8:12] + "_" + bInstruction[12:16]
    else:
        print("ERROR!")
    return result

def inmToBit (bit, inmediate, inout = False):
    val = "{:b}".format(int(inmediate)).zfill(bit)

    if inout and int(inmediate) >= 0 and int(inmediate) < 4:
        # ERROR: Si el numero no esta en el rango de 0-3 deberia dar error
        val = val[6:] + val[:6]

    return val

def divideInstruction (instruction):
    return [ word.strip() for word in instruction.split() if len(word.strip()) != 0 ]

def isComplex (instruction):
    return instruction[0] in COMPLEX

def analyzeComplexInstruction (instruction):
    instance = ""

    if instruction[0] == "BEQ":
        instance = BEQ()
    elif instruction[0] == "BNE":
        instance = BNE()
    elif instruction[0] == "BLT":
        instance = BLT()
    elif instruction[0] == "BLE":
        instance = BLE()
    elif instruction[0] == "BGT":
        instance = BGT()
    elif instruction[0] == "BGE":
        instance = BGE()

    return instance

def process (instruction):
    if instruction[0] in PARSER:
        opcode = PARSER[instruction[0]]
        if opcode[:2] == "10":
            if len(instruction) != 3:
                print("ERROR! Inmediate instruction has too many arguments (expected 2, got {})".format(len(instruction) - 1))
                exit()
            return InmediateInstruction(instruction[0], instruction[1], instruction[2])
        elif opcode[:2] == "11":
            if len(instruction) != 2 and not instruction[0] in UNIQUE:
                print("ERROR! Jump instruction has too many arguments (expected 1, got {}".format(len(instruction) - 1))
                exit()
            if instruction[0] in UNIQUE:
                return JumpInstruction(instruction[0], "0")
            else:
                return JumpInstruction(instruction[0], instruction[1])
        elif opcode[0] == "0":
            if len(instruction) != 4:
                print("ERROR! ALU operation instruction has too many arguments (expected 3, got {}".format(len(instruction) - 1))
                exit()
            return AluInstruction(instruction[0], instruction[1], instruction[2], instruction[3])
        else:
            print("ERROR! Unknown error. That's pretty bad :(")
            exit()        
    else:
        print("ERROR! Instruction not recognized")

# CLASES Y JERARQUIA DEL PATRON STRATEGY

class Instruction:
    """Almacena la información básica de cualquier instrucción"""

    def __init__(self, opcode):
        self.opcode = opcode

    def __str__ (self):
        return self.opcode

    def toBinary (self):
        pass

class JumpInstruction (Instruction):
    """Instrucciones de salto"""

    def __init__(self, opcode, dir):
        super().__init__(opcode)
        self.dir = dir

    def __str__(self):
        return "{} {}".format(self.opcode, self.dir)

    def toBinary (self):
        return PARSER[self.opcode] + inmToBit(10, self.dir)

class InmediateInstruction (Instruction):
    def __init__ (self, opcode, inm, dest):
        super().__init__(opcode)
        self.inm = inm
        self.dest = dest

    def __str__(self):
        return "{} {} {}".format(self.opcode, self.inm, self.dest)
    
    def toBinary (self):
        inout = (self.opcode == "IN" or self.opcode == "OUT")
        return PARSER[self.opcode] + inmToBit(8, self.inm, inout) + REGISTER[self.dest]

class AluInstruction (Instruction):
    def __init__ (self, opcode, r1, r2, rd):
        super().__init__(opcode)
        self.r1 = r1
        self.r2 = r2
        self.rd = rd

    def __str__ (self):
        return "{} {} {} {}".format(self.opcode, self.r1, self.r2, self.rd)

    def toBinary (self):
        return PARSER[self.opcode] + REGISTER[self.r1] + REGISTER[self.r2] + REGISTER[self.rd]

# Complex Instructions
class ComplexContext:

    def __init__ (self):
        self.cInstruction = ComplexInstruction()

    def setInstruction (self, instructionClass):
        self.cInstruction = instructionClass

    def toBinary (self, instruction):
        return self.cInstruction.toBinary(instruction)

    def getNativeInstructions (self, instruction):
        if type(instruction) == list:
            return self.cInstruction.getNativeInstructions(instruction)

class ComplexInstruction:
    def __init__(self):
        pass

    def toBinary (self, instruction):
        nativeInstructions = self.getNativeInstructions(instruction)
        binNativeInstructions = []
        for ins in nativeInstructions:
            binNativeInstructions.append(ins.toBinary())
        return binNativeInstructions

    def getNativeInstructions (self, instruction):
        return instruction

class BEQ (ComplexInstruction):
    def getNativeInstructions (self, instruction):
        resta = AluInstruction("SUB", instruction[1], instruction[2], "R0")
        salto = JumpInstruction("JZ", instruction[3])
        return [resta, salto]

class BNE (ComplexInstruction):
    def getNativeInstructions (self, instruction):
        resta = AluInstruction("SUB", instruction[1], instruction[2], "R0")
        salto = JumpInstruction("JNZ", instruction[3])
        return [resta, salto]

class BLT (ComplexInstruction):
    def getNativeInstructions (self, instruction):
        resta = AluInstruction("SUB", instruction[1], instruction[2], "R0")
        salto = JumpInstruction("JN", instruction[3])
        return [resta, salto]

class BLE (ComplexInstruction):
    def getNativeInstructions (self, instruction):
        resta = AluInstruction("SUB", instruction[1], instruction[2], "R0")
        salto1 = JumpInstruction("JN", instruction[3])
        salto2 = JumpInstruction("JZ", instruction[3])
        return [resta, salto1, salto2]

class BGT (ComplexInstruction):
    def getNativeInstructions (self, instruction):
        resta = AluInstruction("SUB", instruction[2], instruction[1], "R0")
        salto = JumpInstruction("JN", instruction[3])
        return [resta, salto]

class BGE (ComplexInstruction):
    def getNativeInstructions (self, instruction):
        resta = AluInstruction("SUB", instruction[2], instruction[1], "R0")
        salto1 = JumpInstruction("JN", instruction[3])
        salto2 = JumpInstruction("JZ", instruction[3])
        return [resta, salto1, salto2]