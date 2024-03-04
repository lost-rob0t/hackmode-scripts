#!/bin/awk -f

# Read file1 into an array
NR == FNR {
	file1[++num_lines_file1] = $0
	next
}

{
	for (i = 1; i <= num_lines_file1; i++) {
		print file1[i] ":" $0
	}
}

