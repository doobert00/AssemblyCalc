# AssemblyCalc
We've written a calculator using 32-bit x86 assembly code. Development is simplist on a Linux
machine (or VM) using the NASM assembler and GDB debugging tool.

## Remark
*As of now the program calc.asm only saves stdin to stack*

## Running
If you have an x86 machine (and trust my code) you can run with:
```
nasm -f elf -o <file>.o -o <file>.arm 
```
```
ld -m elf_i386 -o <file> <file>.o
```
```
./<file>
```

## Running in Docker
To build the image do:

```
docker build -t calc:1.0 .
```

To run the image do:

```
docker run -it -d --name calc calc:1.0
```
