#!/usr/bin/env python3

from os import scandir, getcwd
from os.path import abspath
import re

def ls(ruta = getcwd()):
    return [abspath(arch.path) for arch in scandir(ruta) if arch.is_file()]

def is_dat_file (file):
    regex = r"[\w_-]+\.dat$"
    result = re.search(regex, file)
    return result != None

def process_dat_file (file):
    with open(file, 'r') as ifile:
        with open(file.replace('.', '_t.', 1), 'w') as ofile:
            for line in ifile:
                pline = line.replace('_', '')
                ofile.write(pline)

filelist = ls('/home/xavyan/Escritorio/cpu-e-s/bin')
for file in filelist:
    if is_dat_file(file):
        print("Processing {} file...".format(file))
        process_dat_file(file)
        print("File {} successfully processed".format(file))