function find_files () {
    target_dirpath="${1}/*"
    for filepath in $target_dirpath; do
        if [ -f $filepath ] ; then
            FILE_NAME="${filepath##*/}"
            FILE_WITH_FOLDER_NAME="${filepath#*ppts/}"
            mkdir -p "./slides/${FILE_WITH_FOLDER_NAME%/*}"
            sed -e "s/#{PLACEMENT_NAME}/${FILE_NAME%.*}/g" $template_html > ./slides/${FILE_WITH_FOLDER_NAME%.*}.html
            echo "            <a href=\"./slides/${FILE_WITH_FOLDER_NAME%.*}.html\">  ${FILE_NAME%.*}  </a>" >> ./index.html
            echo "      > ${FILE_NAME%.*}"
        fi
    done
}

echo "Start ..."

files="./ppts/*"

topfile="./index.html"
template_list="./assets/temp/template_list.temp"
template_html="./assets/temp/template.temp"

cp $template_list $topfile

for filepath in $files; do
    if [ -d $filepath ] ; then
        echo "            <h2>  ${filepath##*/}  </h2>" >> ./index.html
        echo "Group : ${filepath##*/}"
        find_files $filepath
    fi
done

# for FILE_PATH in ${fileary[@]}; do
#     FILE_NAME=${FILE_PATH##*/}
#     sed -e "s/#{PLACEMENT_NAME}/${FILE_NAME%.*}/g" ./template.html > ./slides/${FILE_NAME%.*}.html
# done
            
cat <<EOS >> $topfile
        </div>
    </div>
</body>
</html>
EOS

echo "Finished"