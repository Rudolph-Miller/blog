git clean -f
git pull
git checkout gh-pages
git clean -f
git rebase origin master
sh build.sh
cd public
git add . -f
git commit -m "Update $(date +%s). [ci skip]"
git push origin gh-pages
