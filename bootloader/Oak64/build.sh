#!/bin/bash

nasm src/boot/mbr.asm -o bin/mbr.sys
nasm src/oak64.asm -o bin/oak64.sys
