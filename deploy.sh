git clean -f
git fetch origin gh-pages
git reset --hard FETCH_HEAD
git rebase master
hugo
cd public
git add . -f
git commit -m "Update $(date +%s). [ci skip]"
git push origin gh-pages
git checkout master
