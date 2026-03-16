// 1. 引入核心模块 
const fs = require('fs');           // 文件读写（读取JSON文件）
const express = require('express')  // Web服务框架（快速搭建HTTP服务）
const { networkInterfaces } = require('os');  // 获取系统网络接口（本地IP）

// 2. 工具函数1：获取格式化的当前时间（日志用）
function getCurrentTime() {
  const now = new Date();
  const hours = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();
  return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

// 3. 工具函数2：获取本地局域网IPv4地址（非回环地址）
function getLocalIp() {
  const interfaces = networkInterfaces();  // 获取所有网络接口（有线/无线/虚拟机）
  for (const interfaceName in interfaces) {
    const networkInterface = interfaces[interfaceName];
    for (const { address, family, internal } of networkInterface) {
	  // 筛选：IPv4 + 非内部地址（排除127.0.0.1）	
      if (family === 'IPv4' && !internal) {
        return address;  // 返回第一个匹配的局域网IP（如192.168.1.100）
      }
    }
  }
  return null;
}
// 4. 全局配置：本地IP + 端口
const ip = getLocalIp();
const port = 3000;

const app = express()
// 中间件1：解析JSON格式的请求体（鸿蒙应用POST请求常用）
app.use(express.json())
// 中间件2：解析URL编码的请求体（兼容表单提交）
app.use(express.urlencoded({ extended: false }))
// 中间件3：静态资源托管（暴露public目录，鸿蒙应用可访问图片/静态文件）
app.use('/static', express.static('public'))

// GET /data/:file 接口：读取data/[file].json并返回
app.get('/data/:file', (req, res) => {
  console.log('[' + getCurrentTime() + '] GET /data/' + req.params.file);
  // 拼接JSON文件路径（如请求/data/product → 读取data/product.json）
  var path = 'data/' + req.params.file + '.json'
  
  // 异步读取JSON文件
  fs.readFile(path, function (error, data) {
    if (error) {
      console.log('fail to read file: ' + path)
    } else {
	  // 读取成功：设置跨域头 + 替换IP + 返回JSON	
      res.setHeader("Access-Control-Allow-Origin", "*");  // 允许所有域名跨域（调试用）
      res.setHeader("Access-Control-Allow-Methods", "PUT,POST,GET,DELETE,OPTIONS");  // 允许的请求方法
      res.setHeader("Content-Type", "application/json;charset=utf-8");    // 返回JSON格式，UTF-8编码（解决中文乱码）
	  // 核心替换：将JSON中的//127.0.0.1:3000/替换为//本地IP:3000/（鸿蒙模拟器/真机可访问）
      res.end(data.toString().replace(/\/\/127\.0\.0\.1:3000\//g, `//${ip}:${port}/`));
    }
  });
})

app.listen(3000, () => {
  console.log(`server running at http://${ip}:${port}`)
})
