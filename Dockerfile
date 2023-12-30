FROM ubuntu:20.04 AS build

RUN apt-get update

RUN apt-get install -y nasm binutils

#COPY hello.asm /app/
#
#RUN nasm -f elf -o /app/hello.o /app/hello.asm
#RUN ld -m elf_i386 -s -o /app/hello /app/hello.o
#
#FROM alphine:latest
#
#COPY --from=build /app/hello/ /app/
#
#CMD ["/app/hello"]
