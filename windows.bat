@echo off
echo Building the CS 240 environment...
docker build -q -t cs240-env .

echo ---------------------------------------------------
echo Environment ready! You are now inside Linux.
echo Compile your code using 'gcc -g' and run 'valgrind'.
echo To exit and return to your machine, type 'exit'.
echo ---------------------------------------------------

REM The -v flag mirrors the local directory into the container
docker run --rm -it -v "%cd%":/code cs240-env