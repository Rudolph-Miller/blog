git clean -f
git fetch origin gh-pages
git reset --hard FETCH_HEAD
git checkout gh-pages
git merge origin/master --ff --no-edit --no-commit
rm -rf 2015 2016 page post slide categories tags
HUGO_ENV=production hugo
mv public/* ./
cp -rf public/* ./
rm -rf highlight-lisp/.git
optipng -i 1 images/**/*.png
git add -A
git commit -m "Update $(date +%s). [ci skip]"
git push origin gh-pages
git checkout master
