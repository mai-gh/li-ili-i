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
    date > posts/${TITLE}.txt
    echo "<h2>$TITLE</h2>" >> posts/${TITLE}.txt
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
    sh publish.sh
    ;;

  *)
    cmd_help
    ;;
esac
  
  

