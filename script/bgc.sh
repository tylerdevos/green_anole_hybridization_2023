#!/bin/bash
bgc -a AIMs_bgc_p0in.txt -b AIMs_bgc_p1in.txt -h AIMs_bgc_admixedin.txt -M AIMs_bgc_map.txt -F /tmp/anolis -O 0 -x 100000 -n 0 -p 0 -q 1 -i 1 -N 1 -E 0.001 -m 1
mv /tmp/anolis*
