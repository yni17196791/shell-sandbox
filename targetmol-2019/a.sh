#! /bin/bash
find . -name "*.ht*" | while read i ;

do

    echo "$i"

    # tableタグをcsvに
    # cat "$i" | grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' | sed 's/^[\ \t]*//g' | tr -d '\n' | sed 's/<\/TR[^>]*>/\n/Ig'  | sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' | sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' | sed 's/<\/T[DH][^>]*><T[DH][^>]*>/,/Ig' | sed -e 's/<[^>]*>//g' | sed -e 's/^[ ]*//g' > ${i%.*}.csv

    # パンくずリストをcsvに
    # crumbs=$(sed -ne '/<div class="m-crumbs"/,/<\/div>/p' "$i" | sed -e 's/<[^>]*>//g' | sed -e 's/^[ ]*//g' | tr -d '\n' | sed -e 's/\&nbsp;>/,/g' | sed '$ s/$/,/')

    # タイトル・カタログ番号を抜き出す
    title=$(sed -ne '/<div class="lbytitle">/,/<\/div>/p' "$i")

    # 詳細を抜き出す
    description=$(sed -ne '/<div class="lbydspt">/,/<\/div>/p' "$i")

    # リストを抜き出す
    list=$(sed -ne '/<ul style="list-style: disc">/,/<\/ul>/p' "$i")

    # text/javascriptを抜き出す
    script=$(sed -ne '/<script type="text\/javascript">/,/<\/script>/p' "$i")

    echo ${title} >> ${i%.*}.txt
    echo ${description} >> ${i%.*}.txt;
    echo ${list} >> ${i%.*}.txt;
    echo ${script} >> ${i%.*}.txt;

    echo "$i done"

done