#!/bin/bash

find -L . \
        -type f \
        -name "*.simplified.concatenated.vcf" \
| sed "s#.simplified.concatenated.vcf#.simplified.concatenated.vcf.bgz#" \
| xargs mk $@
