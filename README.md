# 个人博客

这是一个基于 Jekyll 构建的个人博客，托管在 GitHub Pages 上。

## 🎨 特点

- ✨ 全新的简洁现代设计
- 📱 完全响应式布局，支持移动端
- 🏷️ 标签系统，方便文章分类
- 📄 分页功能，优化浏览体验
- 🎯 简洁的代码结构，易于维护

## 📁 项目结构

```
.
├── _layouts/           # 布局模板
│   ├── default.html   # 基础布局（包含头部、导航、底部）
│   ├── post.html      # 文章页面布局
│   └── page.html      # 静态页面布局
├── _posts/            # 博客文章（Markdown格式）
├── pages/             # 静态页面
│   ├── tags.html     # 标签页
│   └── about.html    # 关于页
├── _config.yml        # Jekyll 配置文件
├── index.html         # 首页（文章列表）
├── 404.html           # 404错误页
└── img/               # 图片资源
```

## 📝 写作指南

### 创建新文章

1. 在 `_posts` 目录下创建新文件
2. 文件命名格式：`YYYY-MM-DD-标题.md`
3. 文件开头添加 Front Matter：

```yaml
---
layout: post
title: "文章标题"
subtitle: "文章副标题（可选）"
date: 2024-01-01
author: "作者名（可选）"
tags:
  - 标签1
  - 标签2
---

文章内容...
```

### Front Matter 字段说明

- `layout`: 布局模板，文章使用 `post`
- `title`: 文章标题（必需）
- `subtitle`: 文章副标题（可选）
- `date`: 发布日期（必需）
- `author`: 作者名（可选）
- `tags`: 标签列表（可选）

## 🚀 本地开发

### 安装依赖

```bash
# 安装 Ruby 和 Bundler
gem install bundler

# 安装 Jekyll 和依赖
bundle install
```

### 本地运行

```bash
# 启动本地服务器
bundle exec jekyll serve

# 访问 http://localhost:4000
```

### 构建静态文件

```bash
bundle exec jekyll build
```

## 🌐 部署

### GitHub Pages 部署

1. 将代码推送到 GitHub 仓库
2. 在仓库设置中启用 GitHub Pages
3. 选择 `main` 分支作为源
4. 访问 `https://用户名.github.io`

### 提交更新

```bash
git add .
git commit -m "更新博客内容"
git push origin main
```

## 🎨 自定义

### 修改网站信息

编辑 `_config.yml` 文件：

```yaml
title: 你的博客名称
description: 博客描述
email: 你的邮箱
url: "https://你的域名"
```

### 修改样式

所有样式都内嵌在各个 HTML 文件的 `<style>` 标签中，可以直接修改：

- `_layouts/default.html` - 全局样式（头部、导航、底部）
- `_layouts/post.html` - 文章页面样式
- `index.html` - 首页样式
- `tags.html` - 标签页样式

### 修改颜色主题

主要颜色变量：

- 主色调：`#0066cc`（蓝色）
- 背景色：`#f5f5f5`（浅灰）
- 文字色：`#333`（深灰）
- 次要文字：`#666`（中灰）

## 📄 页面说明

### 首页 (index.html)

- 展示最新的博客文章列表
- 支持分页（每页10篇）
- 显示文章标题、副标题、日期、标签
- 卡片式设计，悬停效果

### 标签页 (tags.html)

- 标签云展示所有标签
- 按标签分组显示文章
- 点击标签可跳转到对应分组

### 关于页 (about.html)

- 个人介绍
- 技术栈展示
- 联系方式

### 文章页 (post.html)

- 文章标题和元信息
- 文章内容（支持Markdown）
- 文章标签
- 上一篇/下一篇导航

## 🔧 技术栈

- **Jekyll**: 静态网站生成器
- **Liquid**: 模板语言
- **Markdown**: 文章编写格式
- **HTML/CSS**: 页面结构和样式
- **GitHub Pages**: 托管平台

## 📚 参考资源

- [Jekyll 官方文档](https://jekyllrb.com/)
- [Liquid 模板语言](https://shopify.github.io/liquid/)
- [Markdown 语法](https://www.markdownguide.org/)
- [GitHub Pages 文档](https://docs.github.com/en/pages)

## 📝 更新日志

### 2026-01-29

- 🎉 全新设计的博客系统
- ✨ 简洁现代的界面
- 📱 完全响应式布局
- 🏷️ 优化的标签系统
- 📄 改进的分页功能

## 📧 联系方式

- Email: chenglong799466@gmail.com
- GitHub: [chenglong799466](https://github.com/chenglong799466)

## 📄 许可证

MIT License

---

**享受写作，分享知识！** ✍️