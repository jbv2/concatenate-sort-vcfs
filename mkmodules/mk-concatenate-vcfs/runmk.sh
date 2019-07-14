#!/bin/bash

find -L . \
        -type f \
        -name "*.simplified.vcf" \
| sed "s#.simplified.vcf#.simplified.concatenated.vcf#" \
| xargs mk $@
