#!/bin/#!/usr/bin/env bash

## ENVIRONMENTE VARIABLES REQUIRED
#format is: export VARNAME="value"
export INDEX_PATH="test/data/*.gz"
export OUTPUT_FILE="test/data/12g.simplified.concatenated.vcf"

# borrar resultados de prueba anterior
rm -fr test/results/

# Crear un test/results vacío
mkdir -p test/results
bash runmk.sh && mv test/data/*.simplified.concatenated.vcf test/results/ \
 && echo "module test successful"
