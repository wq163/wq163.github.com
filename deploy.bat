export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
set LANG=zh_CN.UTF-8
set LC_ALL=zh_CN.UTF-8

echo ------------generate-------------\n\n
rake generate
echo " "
echo ------------deploy---------------\n\n
rake deploy
echo " "
echo ------------push source----------\n\n
echo " "
git add .
git commit -m "new post"
git push origin source

