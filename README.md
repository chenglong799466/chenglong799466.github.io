# ChengLong's Blog

> 基于 Jekyll 的极简高级风个人技术博客，专注于大模型技术研究与应用

## 📖 项目简介

这是一个采用极简设计风格的个人技术博客，使用 Jekyll 静态网站生成器构建，部署在 GitHub Pages 上。博客专注于大模型技术、云原生、Kubernetes、Go 语言等技术领域的研究与分享。

## ✨ 设计特点

### 视觉设计
- **极简风格**：简约大气，符合程序员个人博客的专业调性
- **科技感轻量**：拒绝冗余元素，留白合理
- **配色方案**：
  - 主色调：`#165DFF` (低饱和蓝色)
  - 背景色：`#FFFFFF` (纯白)
  - 辅助色：`#F5F7FA` (浅灰)
  - 文字色：`#333333` / `#666666` (深灰/浅灰)

### 布局结构
- **顶部导航栏**：固定顶部，包含 Logo 和主导航菜单
- **左侧边栏**：文章分类、标签云、近期更新
- **主内容区**：文章列表或详情内容
- **底部页脚**：版权信息、GitHub 链接等

### 排版规范
- **字体**：Inter / Noto Sans SC (思源黑体)
- **字号层级**：H1: 32px, H2: 24px, H3: 20px, H4: 18px, 正文: 16px
- **行高**：1.7-1.8
- **圆角**：8px (卡片)、4px (按钮/标签)

## 📁 项目结构

```
.
├── _config.yml          # Jekyll 配置文件
├── _layouts/            # 页面布局模板
│   ├── default.html     # 默认布局（三栏结构）
│   ├── post.html        # 文章详情页布局
│   └── page.html        # 普通页面布局
├── _posts/              # 博客文章（Markdown 格式）
├── pages/               # 独立页面
│   ├── about.html       # 关于我
│   ├── tags.html        # 标签页
│   └── archive.html     # 归档页
├── css/                 # 样式文件
├── js/                  # JavaScript 文件
├── img/                 # 图片资源
├── index.html           # 首页
├── 404.html             # 404 错误页
└── README.md            # 项目说明
```

## 🚀 快速开始

### 本地运行

1. **安装 Jekyll**
```bash
gem install jekyll bundler
```

2. **克隆项目**
```bash
git clone https://github.com/chenglong799466/chenglong799466.github.io.git
cd chenglong799466.github.io
```

3. **安装依赖**
```bash
bundle install
```

4. **启动本地服务器**
```bash
jekyll serve
```

5. **访问博客**
打开浏览器访问 `http://localhost:4000`

### 发布文章

1. 在 `_posts` 目录下创建新文件，文件名格式：`YYYY-MM-DD-title.md`

2. 添加 Front Matter：
```yaml
---
layout: post
title: "文章标题"
subtitle: "文章副标题（可选）"
date: 2024-01-01
author: "作者名"
tags: [标签1, 标签2]
---

文章内容...
```

3. 提交并推送到 GitHub

## 🎨 自定义配置

### 修改网站信息
编辑 `_config.yml` 文件

### 修改配色
在 `_layouts/default.html` 中的 CSS 变量部分修改

## 📄 页面说明

- **首页**：展示最新文章列表
- **文章详情页**：文章内容、标签、导航
- **标签页**：标签云和分类文章列表
- **归档页**：按年份时间线展示
- **关于页**：个人简介和联系方式

## 🛠️ 技术栈

- Jekyll
- Liquid
- 原生 CSS
- GitHub Pages

## 📱 响应式设计

- 桌面端：≥1024px - 三栏布局
- 平板端：768px-1023px - 两栏布局
- 移动端：<768px - 单栏布局

## 📝 许可证

MIT License

---

**Built with ❤️ using Jekyll**
