

md_files="./mds/*"
index_file="./mds/index.html"
template_list="./assets/temp/template_list.temp"
slide_dir="mds"

function _encode() {
    local _length="${#1}"
    for (( _offset = 0 ; _offset < _length ; _offset++ )); do
        _print_offset="${1:_offset:1}"
        case "${_print_offset}" in
            [a-zA-Z0-9.~_-]) printf "${_print_offset}" ;;
            ' ') printf + ;;
            *) printf '%%%X' "'${_print_offset}" ;;
        esac
    done
}

function find_files () {
    local target_dirpath="${1}/*"
    for target_filepath in ${target_dirpath}; do
        if [ -f "${target_filepath}" ] ; then
            local FILE_NAME="${target_filepath##*/}"
            local FILE_WITH_FOLDER_NAME="${target_filepath#*mds/}"
            local FOLDER_NAME="${1##*/}"
            mkdir -p "./${slide_dir}/${FILE_WITH_FOLDER_NAME%/*}"
            local url="_encode ${FILE_WITH_FOLDER_NAME%.*}"
            echo "        <p><a href=\"./${url}\">  ${FILE_NAME%.*}  </a></p>" >> "${index_file}"
            echo "      > ${FILE_NAME%.*}"
        fi
    done
}

echo "Start ..."

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

