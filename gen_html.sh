echo "hoge"

files="./ppts/*"
fileary=()
dirary=()

for filepath in $files; do
    if [ -f $filepath ] ; then
        fileary+=("$filepath")
    elif [ -d $filepath ] ; then
        dirary+=("$filepath")
    fi
done

for FILE_PATH in ${fileary[@]}; do
    FILE_NAME=${FILE_PATH##*/}
    sed -e "s/#{PLACEMENT_NAME}/${FILE_NAME%.*}/g" ./template.html > ./slides/${FILE_NAME%.*}.html
done

for i in ${dirary[@]}; do
    echo $i
done