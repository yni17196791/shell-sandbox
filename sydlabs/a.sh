#! /usr/bin/bash
find . -name "*.ht*" | while read i ;

do

# tableタグをcsvに
cat "$i" | grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' | sed 's/^[\ \t]*//g' | tr -d '\n' | sed 's/<\/TR[^>]*>/\n/Ig'  | sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' | sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' | sed 's/<\/T[DH][^>]*><T[DH][^>]*>/,/Ig' | sed -e 's/<[^>]*>//g' | sed -e 's/^[ ]*//g' > ${i%.*}.csv

# パンくずリストをcsvに
crumbs=$(sed -ne '/<div class="m-crumbs"/,/<\/div>/p' "$i" | sed -e 's/<[^>]*>//g' | sed -e 's/^[ ]*//g' | tr -d '\n' | sed -e 's/\&nbsp;>/,/g' | sed '$ s/$/,/')

# 詳細を抜き出す
# description=$(sed -ne '/<\!--bof Product description --/,/<\!--eof Product description -->/p' "$i" | sed -e 's/^[ ]*//g' | sed -e 's/<strong[^>]*>.*<\/strong[^>]*>//g' | tr -d '\n' | sed 's/<br[^>]*>/\n/Ig' | sed -e 's/<[^>]*>//g' | sed '/^$/d' | sed "1s/^/,<p>/" | sed "$ s/$/<p>/" | perl -pe 's/\n/<br>/g' | sed 's/\//＆#47;/g' | sed 's/\*/＆#42;/g' | sed 's/\+/＆#43;/g' | sed 's/\./＆#46;/g' | sed 's/\?/＆#63;/g' | sed 's/\[/＆#91;/g' | sed 's/\]/＆#93;/g' | sed 's/\^/＆#94;/g' | sed 's/\$/＆#36;/g' | sed 's/\-/＆#45;/g' )

cat ${i%.*}.csv | sed "s/^/${crumbs}/g" >> output.csv ;

done