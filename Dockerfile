FROM ubuntu:20.04 AS build

RUN apt-get update

RUN apt-get install -y nasm binutils

COPY calc.asm /app/

RUN nasm -f elf -o /app/calc.o /app/calc.asm
RUN ld -m elf_i386 -s -o /app/calc /app/calc.o

#FROM alpine:latest

#COPY --from=build /app/intprint /app/

CMD ["/app/calc"]
