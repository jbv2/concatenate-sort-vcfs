#!/bin/bash

find -L . \
        -type f \
        -name "*.vcf.gz" \
| sed "s#.vcf.gz#.simplified.vcf#" \
| xargs mk $@
