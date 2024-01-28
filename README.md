# AssemblyCalc
We've written a calculator using 32-bit x86 assembly code. Development is simplist on a Linux
machine (or VM) using the NASM assembler and GDB debugging tool.

## Status
- Functionality for addition, multiplication, subtraction when the output is a single digit
- Funny (incorrect) behavior when output is a two digit number
- Parsing works: we get the correct result in all cases but cannot print a two digit number yet
- Improper equations (eg. non-math symbols and equations out of order) yield error.
- Avoiding division because number theorists will tell you that such things don't exist for integers...

## Running
If you have an x86 machine (and trust my code) you can run with:
```
nasm -f elf -o <file>.o <file>.asm 
```
```
ld -m elf_i386 -o <file> <file>.o
```
```
./<file>
```

## Running in Docker
The programs can also be run on Docker by changing the filenames on lines 9 and 10. To build the image do:

```
docker build -t calc:1.0 .
```

To run the image do:

```
docker run -it -d --name calc calc:1.0
```

## Resources
- The asm_training directory has some simple programs that were used for practice.
- [Here](https://www.youtube.com/playlist?list=PL2EF13wm-hWCoj6tUBGUmrkJmH1972dBB) is a nice youtube playlist for learning x86.
- [Here](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html) is x86 documentation.
