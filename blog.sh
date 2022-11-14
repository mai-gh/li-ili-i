#!/bin/bash


# switch to the blog directory if not already there
cd `realpath $0 | awk 'BEGIN{FS=OFS="/"}{NF--; print}'`


CMD=$1

TITLE=$2

function cmd_help {
  echo "must provide a command, choices are:"
  echo 'new $TITLE'
  echo 'edit $TITLE'
  echo 'list'
  echo 'publish'
  exit 1
}


case $CMD in

  new)
    if [ x$TITLE == 'x' ]; then
      echo must provide a title as the final arguement
      exit 1
    fi
     
    if [ -f posts/${TITLE}.txt ]; then
      echo "FILE EXISTS, use \`edit\' cmd"
      exit 1
    fi
    echo "$TITLE" > posts/${TITLE}.txt
    date >> posts/${TITLE}.txt
    vim +set\ tw=80 +set\ spell +set\ syntax=html posts/${TITLE}.txt
    node build.js 
    ;;

  edit)
    if [ x$TITLE == 'x' ]; then
      echo must provide a title as the final arguement
      exit 1
    fi

    if [ ! -f posts/${TITLE}.txt ]; then
      echo "FILE DOES NOT EXIST, use \`new\' cmd"
      exit 1
    fi
    vim +set\ tw=80 +set\ spell +set\ syntax=html posts/${TITLE}.txt
    node build.js
    ;;

  list)
    find posts -type f -iname "*.txt" -printf "%TY-%Tm-%Td_%TH:%TM:%TS %f\n" | sed 's/\.txt$//'
    ;;

  publish)
    git add .
    git commit -m 'auto-commit'
    git push
    git checkout main || { echo 'failed to switch to main'; exit 1; } # make sure you are on main! if not, bail!
    git branch -D gh-pages # delete the local gh-pages branch (if it exists)
    git push origin --delete gh-pages # delete the remote gh-pages branch
    node build.js # build index.html
    git checkout -b gh-pages # create new local branch gh-pages & switch to it
    sed -i 's@^\(dist\)@#\1@' .gitignore # stop ignoring files we want to publish, then add them
    sed -i 's@^\(index\.html\)@#\1@' .gitignore
    mkdir dist
    mv index.html dist/index.html
    git add dist/index.html
    git commit -m "automated commit"
    git subtree push --prefix dist origin gh-pages # push the dist folder as the root of the gh-pages branch
    git checkout main # switch back to main
    git branch -D gh-pages # delete the local gh-pages branch
    git reset --hard # reset all files back to main
    ;;

  *)
    cmd_help
    ;;
esac
  
  

