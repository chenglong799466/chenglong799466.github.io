# chenglong的博客

基于Jekyll的静态博客网站，托管于GitHub Pages。

## 项目简介

这是一个个人技术博客，使用Jekyll静态网站生成器构建，包含技术文章、学习笔记等内容。

## 快速开始

### 本地预览
```bash
# 安装Jekyll（如果尚未安装）
gem install jekyll bundler

# 启动本地服务器
bundle exec jekyll serve

# 访问 http://localhost:4000 查看网站
```

### 项目结构
```
├── _config.yml          # Jekyll配置文件
├── _includes/           # 页面组件
├── _layouts/           # 页面布局
├── _posts/             # 博客文章
├── css/                # 样式文件
├── js/                 # JavaScript文件
├── img/                # 图片资源
└── index.html          # 首页
```

### 撰写文章

在 `_posts/` 目录下创建Markdown文件，文件名格式：`YYYY-MM-DD-标题.md`

文章头部包含元信息：
```yaml
---
layout:     post
title:      文章标题
subtitle:   副标题
date:       2024-01-11
author:     chenglong
header-img: img/post-bg.jpg
catalog:    true
tags:
    - 标签1
    - 标签2
---
```

## 部署

项目通过GitHub Pages自动部署，推送到master分支即可。

## 技术栈

- Jekyll 4.3
- Bootstrap
- Rouge代码高亮
- GitHub Pages

## 许可证

MIT License