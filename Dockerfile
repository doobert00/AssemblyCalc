FROM ubuntu:20.04 AS build

RUN apt-get update

RUN apt-get install -y nasm binutils

COPY input.asm /app/

RUN nasm -f elf -o /app/input.o /app/input.asm
RUN ld -m elf_i386 -s -o /app/input /app/input.o

#FROM alpine:latest

#COPY --from=build /app/intprint /app/

CMD ["/app/input"]
