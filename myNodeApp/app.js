const express = require('express');
const app = express();
const port = 3000;

// 设置静态文件夹
app.use(express.static('public'));

// 路由，处理根路径
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/dex.html');
});

// 监听端口
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
