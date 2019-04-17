

md_files="./mds/*"
index_file="./mds/index.html"
template_list="./assets/temp/template_list.temp"
slide_dir="mds"

function urlencode {
  echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
}

function find_files () {
    local target_dirpath="${1}/*"
    for target_filepath in ${target_dirpath}; do
        if [ -f "${target_filepath}" ] ; then
            local FILE_NAME="${target_filepath##*/}"
            local FILE_WITH_FOLDER_NAME="${target_filepath#*mds/}"
            local FOLDER_NAME="${1##*/}"
            mkdir -p "./${slide_dir}/${FILE_WITH_FOLDER_NAME%/*}"
            local url="urlencode ${FILE_WITH_FOLDER_NAME%.*}"
            echo "        <p><a href=\"./${url}\">  ${FILE_NAME%.*}  </a></p>" >> "${index_file}"
            echo "      > ${FILE_NAME%.*}"
        fi
    done
}

echo "Start ..."

cp $template_list $index_file

for filepath in $md_files; do
    if [ -d "$filepath" ] ; then
        echo "        <h2>${filepath##*/}</h2>" >> ./index.html
        echo "" >> ./index.html
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

