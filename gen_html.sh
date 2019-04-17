

md_files="./mds/*"
index_file="./mds/index.html"
template_list="./assets/temp/template_list.temp"
slide_dir="mds"

function urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

function urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    $2= '%b' "${url_encoded//%/\\x}"
}

function find_files () {
    local target_dirpath="${1}/*"
    for target_filepath in ${target_dirpath}; do
        if [ -f "${target_filepath}" ] ; then
            local FILE_NAME="${target_filepath##*/}"
            local FILE_WITH_FOLDER_NAME="${target_filepath#*mds/}"
            local FOLDER_NAME="${1##*/}"
            mkdir -p "./${slide_dir}/${FILE_WITH_FOLDER_NAME%/*}"
            local url=$(urlencode "${FILE_WITH_FOLDER_NAME%.*}")
            echo "        <p><a href=\"./${url}\">  ${FILE_NAME%.*}  </a></p>" >> "${index_file}"
            echo "      > ${FILE_NAME%.*}"
        fi
    done
}

echo "Start ..."

mkdir -p "${index_file%/*}"
cp $template_list $index_file

for filepath in $md_files; do
    if [ -d "$filepath" ] ; then
        echo "        <h2>${filepath##*/}</h2>" >> $index_file
        echo "" >> $index_file
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

