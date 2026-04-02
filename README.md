# CS 240 Valgrind Environment

This project provides a simple Docker-based Linux environment for compiling C programs and checking memory leaks with Valgrind.

## What is included

The container image installs:

- `gcc`
- `valgrind`

The working directory inside the container is `/code`, which is mapped to your current local project folder.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running

## Files in this repo

- `linux_mac.sh`: launcher script for macOS/Linux
- `windows.bat`: launcher script for Windows (`cmd`)
- `Dockerfile`: defines the Linux environment

## Start the environment

Open a terminal in this folder, then use the command for your OS.

### macOS / Linux

```bash
chmod +x linux_mac.sh
./linux_mac.sh
```

### Windows (Command Prompt)

```bat
windows.bat
```

After the script finishes, you will be inside a Linux shell in the container.

## Compile and run your C code

Inside the container:

```bash
gcc -g myprog.c -o myprog
./myprog
```

Why `-g`?

- It adds debug symbols so Valgrind can show file names and line numbers (much easier to fix leaks).

## Run Valgrind to check memory leaks

```bash
valgrind --leak-check=full ./myprog
```

Recommended first check:

- Look at `definitely lost` in `LEAK SUMMARY`.
- Goal: `definitely lost: 0 bytes`.

## Where to place your code

Put your `.c` files in this project folder (or subfolders).  
The scripts mount your current local directory into `/code` in the container, so files are shared automatically.

## Exit the container

Type:

```bash
exit
```

The container is started with `--rm`, so it is removed automatically when you exit.