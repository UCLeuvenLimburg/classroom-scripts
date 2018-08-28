for dir in `find -mindepth 1 -maxdepth 1 -type d`; do (cd $dir; pwd; git remote add upstream https://github.com/fvogels/pvm1718-exercises.git); done
