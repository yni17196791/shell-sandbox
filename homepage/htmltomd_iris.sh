#!/bin/bash

find . -name "*.ht*" | while read i ; do sed -rne "s/.*<h1>(.*)<\/h1>/title = \"\1\"/p" -rne 's/.*<meta.*name.*description.*content=(.*)>/description = \1/p' "$i" | sed -n -e '1!G;h;$p' | sed -e '1 r/dev/stdin' frontmatter.txt | cat >"${i%.*}".md ; done

find . -name "*.ht*" | while read i ; do sed -ne '/<article/,/<\/article>/p' "$i" | sed -e '/<header/,/<\/header>/d' | sed -e '/<aside/,/<\/aside>/d' | sed -e '/<footer/,/<\/footer>/d' | sed -re 's/<cite.*>//pg' | sed -n '/\S/p' | cat > "${i%.*}".txt & wait $! ; sed -rne "s/.*caption.*表(.*)<\/.*>/\ntitle=\"表\1\"\n/p" "$i" | cat > "${i%.*}".cite & wait $! ; sed -rne "s/.*csv2table.*\+'(.*)'\);/{{< csv src=\"\1\"  type=\"IRS-products\" >}}\n/p" "$i" | cat >> "${i%.*}".cite & wait $! ; sed -ne '/<article/,/<\/article>/p' "$i" | sed -rne 's/.*<cite>(.*)<\/cite>/\1\n/pg' | cat >> "${i%.*}".cite ; done

find . -name "*.ht*" | while read i ; do pandoc -f html -t markdown_strict "${i%.*}".txt -o "${i%.*}"._md ; done

find . -name "*.ht*" | while read i ; do sed -i.bak -re 's/<img(.*)\/>/{{< figure\1 >}}/g ; s/iris_biotech/iris-biotech/g ; s/https:\/\/bizcomjapan.co.jp\/img\///g ; s/alt=/title=/g ; s/width=/size=/g ; s/class="full"//g ; s/class="right"/float="right"/g ; s/class="left"/float="left"/g' "${i%.*}"._md ; done

find . -name "*.ht*" | while read i ; do cat "${i%.*}"._md >> "${i%.*}".md & wait $! ; cat "${i%.*}".cite >> "${i%.*}".md ; done

find "`pwd`" -type d | while read i ; do cp "$i"/index.md "$i".md ; done
