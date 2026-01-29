# 博客图片资源说明

## 新下载的背景图片

### 抽象风格背景
- `abstract-bg-01.jpg` - 现代抽象风格背景
- `abstract-bg-02.jpg` - 几何抽象背景  
- `abstract-bg-03.jpg` - 简约抽象背景

### 自然风格背景
- `nature-bg-04.jpg` - 山脉风景背景
- `nature-bg-05.jpg` - 森林风景背景
- `nature-bg-06.jpg` - 瀑布风景背景

## 如何替换背景图片

在博客文章的YAML头部，修改`header-img`字段来使用不同的背景图片：

```yaml
---
layout: post
title: 文章标题
description: 文章描述
header-img: img/abstract-bg-01.jpg  # 替换为想要的背景图片
catalog: true
tags:
- 标签1
- 标签2
---
```

## 可用的背景图片选项

- `img/post-bg-coffee.jpeg` - 咖啡主题背景（原默认）
- `img/abstract-bg-01.jpg` - 现代抽象风格
- `img/abstract-bg-02.jpg` - 几何抽象风格
- `img/abstract-bg-03.jpg` - 简约抽象风格
- `img/nature-bg-04.jpg` - 山脉风景
- `img/nature-bg-05.jpg` - 森林风景
- `img/nature-bg-06.jpg` - 瀑布风景

## 页面背景图片替换

对于页面文件（如about.html、tags.html等），同样可以修改header-img字段来更换背景。