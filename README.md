To build the image do:

```
docker build -t calc:1.0 .
```

To run the image do:

```
docker run -t -d --name calc calc:1.0
```

For some reason it runs in a detached state. You can run your Linux image
from the command line in Docker. You also have to unminimize the image.

**TODO:**

- Run some assembly in the VM
- Command line
- Move "unminimize" into the Dockerfile
- Figure out how to run from local command line
- Do some simple arithmetic to relearn asm
- Syscalls
- Look up the syscalls in this linux distro
- Figure out read/write
- UI 
- Math
- Parse tree data strucuture
- int <-> binary
- Error
- Deal with error handling
