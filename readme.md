# liʻiliʻi

### a minimalist microbloging framework based around git and plain text files

Take a look: https://mai-gh.github.io/li-ili-i/


## Setup

```
mkdir blog
cd blog
git init
git submodule add git@github.com:mai-gh/li-ili-i.git ./li-ili-i
cp li-ili-i/template.html .
vim template.html
ln -sv li-ili-i/{blog.sh,build.js,package.json} .
npm install
echo node_modules > .gitignore
echo package-lock.json >> .gitignore
git commit -a  -m init

< create new repo on github >

git remote add origin git@github.com:XXXXXX/YYYYYY.git
git branch -M main
git push -u origin main

mkdir posts
./blog.sh new my-first-post
./blog.sh publish
```

## Maintenance

to clone with submodule:
`git clone --recursive git@github.com:mai-gh/blog.git`

to get submodule if already cloned:
`git submodule update --init --recursive`

if source for li-ili-i has update, you can update your submode reference with
`git submodule update --remote && git add li-ili-i && git commit -m "update li-ili-i reference"`
