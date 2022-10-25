const { JSDOM } = require('jsdom');
const { readdir, readFile, writeFile } = require("fs").promises;

const buildPostElement = (doc, inputText) => {
  const postTextNode = JSDOM.fragment(inputText);
  const postContainer = doc.createElement("div");
  postContainer.classList.add("individualPost")
  postContainer.appendChild(postTextNode);
  return postContainer;
}

const getPosts = async (path) => {
  const posts = [];
  const fileList = await readdir(path);
  for (const fileName of fileList) {
    const fileContents = await readFile(`${path}/${fileName}`, 'utf8');
    posts.push({date: new Date(fileContents.split('\n', 1)[0]), content: fileContents})
  }
  return posts.sort( (x, y) => y.date - x.date);
}

const buildBlogHTML = async () => {
  const template = await readFile('./template.html', 'utf8',);
  const dom = new JSDOM(template);
  const postsListDiv = dom.window.document.getElementById('postsList');
  const postsListArr = await getPosts('./posts');
  for (const post of postsListArr) {
    postsListDiv.appendChild(buildPostElement(dom.window.document, post.content));
  }
  await writeFile('./index.html', dom.serialize());
}


console.log('Rebuilding index.html ...')
buildBlogHTML();
