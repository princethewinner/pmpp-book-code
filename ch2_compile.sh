#!/bin/bash

gcc ch2/vecadd.c
nvcc ch2/vecadd.cu -o cuout.out
