#!/usr/bin/python3
import sys, os

try:
	proj_name = str(sys.argv[2])
	proj_path = str(sys.argv[1])
	
	with open("Makefile", "r") as f:
		cont = f.readlines()
	
	cont[0] = "PROJ = " + proj_name + "\n"
	cont[1] = "PROJPATH = " + proj_path + "\n"

	with open("Makefile", "w") as f:
		f.writelines(cont)
	
	os.system("make all prog clean")
		
except IndexError:
	print("arguments: <path> <project name>")
	


