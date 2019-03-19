

ppt_files="./ppts/*"
index_file="./index.html"
template_list="./assets/temp/template_list.temp"
template_html="./assets/temp/template.temp"
slide_dir="slides"

function find_files () {
    local target_dirpath="${1}/*"
    for target_filepath in ${target_dirpath}; do
        if [ -f "${target_filepath}" ] ; then
            local FILE_NAME="${target_filepath##*/}"
            local FILE_WITH_FOLDER_NAME="${target_filepath#*ppts/}"
            local FOLDER_NAME="${1##*/}"
            mkdir -p "./${slide_dir}/${FILE_WITH_FOLDER_NAME%/*}"
            sed -e "s/#{PLACEMENT_NAME}/${FOLDER_NAME}\/${FILE_NAME%.*}/g" "${template_html}" > "./${slide_dir}/${FILE_WITH_FOLDER_NAME%.*}.html"
            echo "            <a href=\"./${slide_dir}/${FILE_WITH_FOLDER_NAME%.*}.html\">  ${FILE_NAME%.*}  </a>" >> "${index_file}"
            echo "      > ${FILE_NAME%.*}"
        fi
    done
}

echo "Start ..."

cp $template_list $index_file

for filepath in $ppt_files; do
    if [ -d "$filepath" ] ; then
        echo "            <h2>${filepath##*/}</h2>" >> ./index.html
        echo "Group : ${filepath##*/}"
        find_files "${filepath}"
    fi
done

cat <<EOS >> $index_file
        </div>
    </div>
</body>
</html>
EOS

echo "Finished"

