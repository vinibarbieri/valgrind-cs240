# CS 240 Valgrind Environment

A Linux environment with `gcc` and `valgrind` that runs on any OS (macOS, Windows, Linux) through Docker.

## Quick start

1. **Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)** (only once). You don't need to open it, the script does that for you.
2. **Copy 2 files into the folder with your `.c` files:**
   - macOS / Linux: `linux_mac.sh` and `Dockerfile`
   - Windows: `windows.bat` and `Dockerfile`
3. **Open a terminal in that folder and run the script:**

   macOS / Linux:
   ```bash
   bash linux_mac.sh
   ```

   Windows (Command Prompt; in PowerShell use `.\windows.bat`):
   ```bat
   windows.bat
   ```

You are now inside Linux. The prompt changes to:
```
[cs240-linux] /code $
```
The folder where the script is shows up here as `/code`. Type `ls` to see your files.

> The first run takes 1-3 minutes to build the environment. After that it starts in seconds.

Want to try it first? This repo already has `problem1.c`, an example with a memory leak. Run the script right here.

## Compile and run your C code

Inside Linux:

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

## Exit Linux

Type:

```bash
exit
```

The container is removed automatically when you exit. Your files are **not** deleted: they live in your folder on your computer.

## Troubleshooting

**"Docker is not installed"**
Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and restart your terminal.

**"Docker did not start"**
Open Docker Desktop yourself and wait until it says *Engine running*. The first time, it may ask you to accept terms or sign in (you can skip signing in). Then run the script again.

**Windows: Docker Desktop complains about WSL**
Open PowerShell as administrator, run `wsl --install`, restart your computer and open Docker Desktop again.

**Windows: "Virtualization support not detected"**
Virtualization is disabled in your BIOS. Search for how to enable "Intel VT-x" or "AMD-V" on your computer model.

**I don't see my files with `ls`**
The script shares the folder it is in. Make sure your `.c` files are in the same folder as the script. Files you add while Linux is running show up right away.

**"Dockerfile not found"**
Copy the `Dockerfile` into the same folder as the script.

**"Permission denied" when running `./linux_mac.sh`**
Run it with `bash linux_mac.sh` instead.

## Files in this repo

- `linux_mac.sh`: launcher script for macOS/Linux
- `windows.bat`: launcher script for Windows (`cmd`)
- `Dockerfile`: defines the Linux environment
- `problem1.c`: example program with a memory leak
