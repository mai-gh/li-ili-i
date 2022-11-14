const { JSDOM } = require('jsdom');
const { readdir, readFile, writeFile } = require("fs").promises;

const buildPostElement = (doc, postObj) => {
  const postTextNode = JSDOM.fragment(postObj.content);
  const postContainer = doc.createElement("div");
  const titleDiv = doc.createElement("div");
  const titleLink = doc.createElement("a");
  titleLink.href = `#${postObj.baseName}`;
  const h2 = doc.createElement("h2");
  h2.appendChild(doc.createTextNode(postObj.title));
  titleLink.appendChild(h2);
  titleDiv.appendChild(titleLink);
  dateFormatOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false, timeZoneName: "short" };
  titleDiv.appendChild(doc.createTextNode(postObj.date.toLocaleDateString('en-US', dateFormatOptions)));
  postContainer.classList.add("individualPost");
  postContainer.id = postObj.baseName;
  postContainer.appendChild(titleDiv);
  postContainer.appendChild(postTextNode);
  return postContainer;
}

const getPosts = async (path) => {
  const posts = [];
  const fileList = await readdir(path);
  for (const fileName of fileList) {
    const baseName = fileName.split(".txt")[0];
    const rawContent = await readFile(`${path}/${fileName}`, 'utf8');
    const lines = rawContent.split('\n');
    lines.splice(0,2);
    const content = lines.join('\n');
    const [title, timeStamp] = rawContent.split('\n', 2);
    posts.push({baseName, content, title, date: new Date(timeStamp)})
  }
  return posts.sort( (x, y) => y.date - x.date);
}

const buildBlogHTML = async () => {
  const template = await readFile('./template.html', 'utf8',);
  const dom = new JSDOM(template);
  const postsListDiv = dom.window.document.getElementById('postsList');
  const postsListArr = await getPosts('./posts');
  for (const post of postsListArr) {
    postsListDiv.appendChild(buildPostElement(dom.window.document, post));
  }
  await writeFile('./index.html', dom.serialize());
}

console.log('Rebuilding index.html ...')
buildBlogHTML();
