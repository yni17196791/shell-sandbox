#!/bin/bash

find . -name "*.ht*" | while read i ; do sed -rne "s/.*<h1>(.*)<\/h1>/title = \"\1\"/p" -rne 's/.*<meta.*name.*description.*content=(.*)>/description = \1/p' "$i" | sed -n -e '1!G;h;$p' | sed -e '1 r/dev/stdin' frontmatter.txt | cat >"${i%.*}".md ; done
