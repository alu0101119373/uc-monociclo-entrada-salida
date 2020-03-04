#!/usr/bin/env python3

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
    "LOAD": '1000'
}

COMPLEX = ["BEQ", "BNE", "BGT", "BGE", "BLT", "BLE"]

REGISTER = {
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

def formatBinaryInstruction(instruction):
    result = ""
    if len(instruction) == 16:
        result = instruction[:4] + "_" + instruction[4:8] + "_" + instruction[8:12] + "_" + instruction[12:16]
    else:
        print("ERROR!")
    return result

def inmTo8bit (inmediate):
    return "{:b}".format(inmediate).zfill(8)

def toBinary (data):
    if data in REGISTER:
        return REGISTER[data]
    elif data.isdigit():
        return inmTo8bit(int(data))
    else:
        return "{} is not a valid data".format(data)

def process (line):
    instruction = line.split()
    if instruction[0] in PARSER:
        opcode = PARSER[instruction[0]]
        if opcode[:2] == "10":
            if len(instruction) != 3:
                print("ERROR! Inmediate instruction has too many arguments (expected 2, got {})".format(len(instruction) - 1))
                exit()
            return InmediateInstruction(instruction[0], instruction[1], instruction[2])
        elif opcode[:2] == "11":
            if len(instruction) != 2:
                print("ERROR! Jump instruction has too many arguments (expected 1, got {}".format(len(instruction) - 1))
                exit()
            return JumpInstruction(instruction[0], instruction[1])
        elif opcode[0] == "0":
            if len(instruction) != 4:
                print("ERROR! ALU operation instruction has too many arguments (expected 3, got {}".format(len(instruction) - 1))
                exit()
            return AluInstruction(instruction[0], instruction[1], instruction[2], instruction[3])
        else:
            print("ERROR! Unknown error. That's pretty bad :(")
            exit()
    elif instruction[0] in COMPLEX:
        opcode = instruction[0]
        
    else:
        print("ERROR! Instruction not recognized")

class Instruction:
    """Almacena la información básica de cualquier instrucción"""

    def __init__(self, opcode):
        self.opcode = opcode

class JumpInstruction (Instruction):
    """Instrucciones de salto"""

    def __init__(self, opcode, dir):
        super().__init__(opcode)
        self.dir = dir

    def __str__(self):
        return "{} {}".format(self.opcode, self.dir)

class InmediateInstruction (Instruction):
    def __init__ (self, opcode, inm, dest):
        super().__init__(opcode)
        self.inm = inm
        self.dest = dest

    def __str__(self):
        return "{} {} {}".format(self.opcode, self.inm, self.dest)

class AluInstruction (Instruction):
    def __init__ (self, opcode, r1, r2, rd):
        super().__init__(opcode)
        self.r1 = r1
        self.r2 = r2
        self.rd = rd

    def __str__ (self):
        return "{} {} {} {}".format(self.opcode, self.r1, self.r2, self.rd)

# Complex Instructions
class ComplexInstruction:
    def __init__(self, opcode):
        self.opcode = opcode

class ConditionalInstruction (ComplexInstruction):
    def __init__(self, opcode, r1, r2, dir):
        super().__init__(opcode)
        self.r1 = r1
        self.r2 = r2
        self.dir = dir

class BEQ (ConditionalInstruction):
    def __init__ (self, opcode, r1, r2, dir):
        super().__init__(opcode, r1, r2, dir)

    def getNativeInstructions (self):
        resta = AluInstruction("SUB", self.r1, self.r2, "R15")
        salto = JumpInstruction("JZ", self.dir)
        return [resta, salto]

class BNE (ConditionalInstruction):
    def __init__ (self, opcode, r1, r2, dir):
        super().__init__(opcode, r1, r2, dir)

    def getNativeInstructions (self):
        resta = AluInstruction("SUB", self.r1, self.r2, "R15")
        salto = JumpInstruction("JNZ", self.dir)
        return [resta, salto]

class BLT (ConditionalInstruction):
    def __init__ (self, opcode, r1, r2, dir):
        super().__init__(opcode, r1, r2, dir)

    def getNativeInstructions (self):
        resta = AluInstruction("SUB", self.r1, self.r2, "R15")
        salto = JumpInstruction("JN", self.dir)
        return [resta, salto]

class BLE (ConditionalInstruction):
    def __init__ (self, opcode, r1, r2, dir):
        super().__init__(opcode, r1, r2, dir)

    def getNativeInstructions (self):
        resta = AluInstruction("SUB", self.r1, self.r2, "R15")
        salto1 = JumpInstruction("JN", self.dir)
        salto2 = JumpInstruction("JZ", self.dir)
        return [resta, salto1, salto2]

class BGT (ConditionalInstruction):
    def __init__ (self, opcode, r1, r2, dir):
        super().__init__(opcode, r1, r2, dir)

    def getNativeInstructions (self):
        resta = AluInstruction("SUB", self.r2, self.r1, "R15")
        salto = JumpInstruction("JN", self.dir)
        return [resta, salto]

class BGE (ConditionalInstruction):
    def __init__ (self, opcode, r1, r2, dir):
        super().__init__(opcode, r1, r2, dir)

    def getNativeInstructions (self):
        resta = AluInstruction("SUB", self.r2, self.r1, "R15")
        salto1 = JumpInstruction("JN", self.dir)
        salto2 = JumpInstruction("JZ", self.dir)
        return [resta, salto1, salto2]