git clean -f
git fetch origin gh-pages
git reset --hard FETCH_HEAD
git checkout gh-pages
git merge origin/master --ff --no-edit
hugo
mv public/* ./
cp -rf public/* ./
git add -A
git add highlight-lisp
git commit -m "Update $(date +%s). [ci skip]"
git push origin gh-pages
git checkout master
