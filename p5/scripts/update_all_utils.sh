#!/bin/bash

cp 0x00-PRNG/p5_0x00_PRNG/utils.pde .

find ./0x* -name utils.pde -exec cp utils.pde {} \;

rm utils.pde
