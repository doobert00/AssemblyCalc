FROM ubuntu:20.04 AS build

RUN apt-get update

RUN apt-get install -y nasm binutils

COPY intprint.asm /app/

RUN nasm -f elf -o /app/intprint.o /app/intprint.asm
RUN ld -m elf_i386 -s -o /app/intprint /app/intprint.o

FROM alpine:latest

COPY --from=build /app/intprint /app/

CMD ["/app/intprint"]
