#!/bin/bash

find -L . \
	-type f \
	-name "*.simplified.vcf.gz" \
	! -name "concatenated.vcf" \
	-exec dirname {} \; \
| sort -u \
| sed "s#\$#/concatenated.vcf#" \
| xargs mk $@
