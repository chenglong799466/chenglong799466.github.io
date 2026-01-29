# chenglong的博客 🚀

[![GitHub Pages](https://img.shields.io/badge/GitHub-Pages-brightgreen)](https://chenglong799466.github.io/)
[![Jekyll](https://img.shields.io/badge/Jekyll-4.3-red)](https://jekyllrb.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

基于Jekyll的静态博客网站，托管于GitHub Pages。一个简洁、优雅、功能完善的个人技术博客。

## 📖 项目简介

这是一个个人技术博客，使用Jekyll静态网站生成器构建，包含技术文章、学习笔记等内容。博客采用响应式设计，支持移动端访问，集成了标签云、文章目录、评论系统等功能。

## ✨ 主要特性

- 📱 **响应式设计** - 完美适配PC、平板、手机等各种设备
- 🏷️ **标签系统** - 支持文章标签分类和标签云展示
- 📑 **文章目录** - 自动生成文章目录，支持平滑滚动定位
- 💬 **评论系统** - 集成Gitalk和Disqus两种评论系统
- 🔍 **代码高亮** - 使用Rouge实现代码语法高亮
- 📄 **分页功能** - 首页文章列表支持分页浏览
- 🎨 **多种背景** - 提供多种背景图片选择
- 📊 **统计分析** - 集成Google Analytics和百度统计
- 🚀 **PWA支持** - 支持渐进式Web应用，可离线访问

## 🚀 快速开始

### 环境要求

- Ruby >= 2.5
- Jekyll >= 4.0
- Bundler

### 本地预览

```bash
# 1. 克隆项目
git clone https://github.com/chenglong799466/chenglong799466.github.io.git
cd chenglong799466.github.io

# 2. 安装依赖
bundle install

# 3. 启动本地服务器
bundle exec jekyll serve

# 4. 访问 http://localhost:4000 查看网站
```

### 配置说明

编辑 `_config.yml` 文件，修改以下配置：

```yaml
# 网站基本信息
title: 你的博客名称
SEOTitle: SEO标题
description: 网站描述
keyword: 关键词

# 个人信息
email: your-email@example.com
github_username: your-github-username

# 评论系统配置
gitalk:
  enable: true
  clientID: your-client-id
  clientSecret: your-client-secret
```

## 📁 项目结构详解

### 根目录文件

```
chenglong799466.github.io/
├── index.html                    # 首页 - 展示博客文章列表（分页）
├── tags.html                     # 标签页 - 展示标签云和按标签分组的文章
├── about.html                    # 关于页 - 个人介绍、技术栈、联系方式
├── backgrounds-preview.html      # 背景预览页 - 展示所有可用的背景图片
├── 404.html                      # 404错误页 - 页面不存在时显示
├── _config.yml                   # Jekyll配置文件 - 网站全局配置
├── Gemfile                       # Ruby依赖管理文件
├── sw.js                         # Service Worker - PWA离线缓存
└── README.md                     # 项目说明文档
```

### 核心目录

#### `_includes/` - 页面组件（可复用的HTML片段）

```
_includes/
├── head.html      # HTML头部 - meta标签、CSS引入、PWA配置
├── nav.html       # 导航栏 - 顶部导航菜单，支持移动端折叠
└── footer.html    # 页脚 - 社交链接、版权信息、JS库加载
```

**作用说明：**
- `head.html`: 定义页面元数据、SEO配置、引入CSS样式
- `nav.html`: 实现响应式导航栏，自动从页面生成菜单项
- `footer.html`: 加载JavaScript库、初始化各种功能模块

#### `_layouts/` - 页面布局模板

```
_layouts/
├── default.html   # 默认布局 - 最基础的页面结构
├── page.html      # 页面布局 - 用于静态页面（如about、tags）
├── post.html      # 文章布局 - 用于博客文章，包含目录、标签等
└── keynote.html   # 演示布局 - 用于嵌入演示文稿
```

**布局继承关系：**
```
default.html (基础布局)
    ├── page.html (页面布局)
    └── post.html (文章布局)
        └── keynote.html (演示布局)
```

#### `_posts/` - 博客文章

```
_posts/
├── 2024-01-11-文章标题.md
├── 2024-01-12-另一篇文章.md
└── ...
```

**文章命名规则：** `YYYY-MM-DD-标题.md`

**文章Front Matter示例：**
```yaml
---
layout: post                          # 使用post布局
title: "文章标题"                      # 文章标题
subtitle: "副标题"                     # 副标题（可选）
date: 2024-01-11 12:00:00            # 发布日期
author: "作者名"                       # 作者（可选）
header-img: "img/post-bg-coffee.jpeg" # 头部背景图
catalog: true                         # 是否显示目录
tags:                                 # 文章标签
    - Kubernetes
    - DevOps
---
```

#### `css/` - 样式文件

```
css/
├── bootstrap.min.css    # Bootstrap框架CSS
├── hux-blog.min.css     # 博客主题自定义样式
└── syntax.css           # 代码高亮样式（Pygments GitHub风格）
```

#### `js/` - JavaScript文件

```
js/
├── jquery.min.js        # jQuery库
├── bootstrap.min.js     # Bootstrap框架JS
├── hux-blog.min.js      # 博客主题自定义JS
├── jquery.tagcloud.js   # 标签云插件
└── jquery.nav.js        # 单页导航插件（文章目录）
```

#### `img/` - 图片资源

```
img/
├── post-bg-*.jpg        # 文章背景图片
├── abstract-bg-*.jpg    # 抽象风格背景
├── nature-bg-*.jpg      # 自然风景背景
├── favicon.ico          # 网站图标
└── apple-touch-icon.png # iOS主屏幕图标
```

#### `pwa/` - PWA配置

```
pwa/
└── manifest.json        # Web应用清单 - 定义PWA名称、图标等
```

## ✍️ 撰写文章

### 1. 创建文章文件

在 `_posts/` 目录下创建Markdown文件：

```bash
# 文件名格式：YYYY-MM-DD-标题.md
touch _posts/2024-01-11-kubernetes-入门指南.md
```

### 2. 编写Front Matter

在文章开头添加YAML格式的元信息：

```yaml
---
layout: post
title: "Kubernetes入门指南"
subtitle: "从零开始学习K8s"
date: 2024-01-11 10:00:00
author: "chenglong"
header-img: "img/post-bg-coffee.jpeg"
catalog: true
tags:
    - Kubernetes
    - 容器化
    - DevOps
---
```

### 3. 编写文章内容

使用Markdown语法编写文章：

```markdown
## 什么是Kubernetes

Kubernetes（K8s）是一个开源的容器编排平台...

### 核心概念

- **Pod**: 最小部署单元
- **Service**: 服务发现和负载均衡
- **Deployment**: 应用部署管理

### 代码示例

\`\`\`yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
\`\`\`
```

### 4. 本地预览

```bash
bundle exec jekyll serve
# 访问 http://localhost:4000 查看效果
```

## 🎨 自定义配置

### 更换背景图片

1. 访问 `/backgrounds-preview.html` 查看所有可用背景
2. 在文章Front Matter中修改 `header-img` 字段：

```yaml
header-img: "img/abstract-bg-01.jpg"  # 使用抽象风格背景
```

### 添加社交链接

在 `_config.yml` 中配置社交媒体账号：

```yaml
# 社交媒体
github_username: your-github
twitter_username: your-twitter
zhihu_username: your-zhihu
weibo_username: your-weibo
linkedin_username: your-linkedin
```

配置后会自动在页脚显示对应的社交媒体图标链接。

### 配置评论系统

#### Gitalk（推荐）

```yaml
gitalk:
  enable: true
  clientID: your-github-app-client-id
  clientSecret: your-github-app-client-secret
  repo: your-repo-name
  owner: your-github-username
  admin: your-github-username
```

#### Disqus

```yaml
disqus:
  enable: true
  username: your-disqus-shortname
```

### 配置统计分析

```yaml
# Google Analytics
ga_track_id: 'UA-XXXXXXXXX-X'
ga_domain: 'your-domain.com'

# 百度统计
ba_track_id: 'your-baidu-track-id'
```

## 📊 页面功能说明

### 首页 (index.html)
- 展示最新的博客文章列表
- 每篇文章显示标题、副标题、摘要、发布信息
- 支持分页浏览（上一页/下一页）
- 文章摘要自动截取前200个字符

### 标签页 (tags.html)
- **标签云**：以云状形式展示所有标签，大小根据文章数量决定
- **标签列表**：按标签分组显示所有文章
- **快速定位**：点击标签云中的标签可快速跳转到对应文章列表

### 关于页 (about.html)
- 个人介绍和技术背景
- 技术栈展示
- 专注领域说明
- 联系方式和社交链接
- 友情链接
- 集成评论系统

### 背景预览页 (backgrounds-preview.html)
- 网格布局展示所有可用背景图片
- 每个背景显示预览图、名称、描述
- 提供代码示例，方便复制使用
- 响应式设计，自适应各种屏幕

### 404页面 (404.html)
- 友好的错误提示
- 全屏显示效果
- 自动被GitHub Pages使用

## 🔧 高级功能

### 文章目录

在文章Front Matter中设置 `catalog: true` 即可启用侧边栏目录：

```yaml
---
catalog: true  # 启用文章目录
---
```

目录功能：
- 自动提取文章中的h1-h6标题
- 点击目录项平滑滚动到对应位置
- 支持折叠/展开切换

### PWA离线访问

博客支持PWA（渐进式Web应用），可以：
- 添加到主屏幕
- 离线访问已缓存的页面
- 更快的加载速度

配置Service Worker：
```yaml
# _config.yml
service-worker: true
```

### 代码高亮

使用Rouge实现代码语法高亮，支持多种编程语言：

\`\`\`python
def hello_world():
    print("Hello, World!")
\`\`\`

\`\`\`javascript
function helloWorld() {
    console.log("Hello, World!");
}
\`\`\`

## 🚀 部署

### GitHub Pages自动部署

1. 推送代码到GitHub仓库
2. 在仓库设置中启用GitHub Pages
3. 选择分支（通常是main或master）
4. 等待几分钟，访问 `https://your-username.github.io`

### 自定义域名

1. 在仓库根目录创建 `CNAME` 文件
2. 写入你的域名：`blog.example.com`
3. 在域名DNS设置中添加CNAME记录指向 `your-username.github.io`

## 📝 文件作用速查表

| 文件/目录 | 作用 | 是否必需 |
|----------|------|---------|
| `_config.yml` | Jekyll全局配置 | ✅ 必需 |
| `index.html` | 首页文章列表 | ✅ 必需 |
| `_includes/` | 可复用的HTML组件 | ✅ 必需 |
| `_layouts/` | 页面布局模板 | ✅ 必需 |
| `_posts/` | 博客文章目录 | ✅ 必需 |
| `css/` | 样式文件 | ✅ 必需 |
| `js/` | JavaScript文件 | ✅ 必需 |
| `img/` | 图片资源 | ✅ 必需 |
| `tags.html` | 标签页面 | ⭕ 可选 |
| `about.html` | 关于页面 | ⭕ 可选 |
| `backgrounds-preview.html` | 背景预览页 | ⭕ 可选 |
| `404.html` | 404错误页 | ⭕ 可选 |
| `sw.js` | Service Worker | ⭕ 可选 |
| `pwa/` | PWA配置 | ⭕ 可选 |

## 🛠️ 技术栈

- **静态网站生成器**: Jekyll 4.3
- **前端框架**: Bootstrap 3
- **JavaScript库**: jQuery
- **代码高亮**: Rouge (Pygments GitHub风格)
- **评论系统**: Gitalk / Disqus
- **统计分析**: Google Analytics / 百度统计
- **图标字体**: Font Awesome
- **PWA**: Service Worker
- **托管平台**: GitHub Pages

## 📚 参考资源

- [Jekyll官方文档](https://jekyllrb.com/)
- [GitHub Pages文档](https://pages.github.com/)
- [Liquid模板语言](https://shopify.github.io/liquid/)
- [Markdown语法](https://www.markdownguide.org/)
- [Bootstrap文档](https://getbootstrap.com/)

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 💬 联系方式

- **Email**: chenglong799466@gmail.com
- **GitHub**: [@chenglong799466](https://github.com/chenglong799466)
- **博客**: [https://chenglong799466.github.io](https://chenglong799466.github.io)

---

⭐ 如果这个项目对你有帮助，欢迎点个Star！