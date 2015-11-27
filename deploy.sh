export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

rake generate
rake deploy
git add .
git commit -m "new post"
git push origin source
