# thesis-pdf2md

**PDF → Markdown 高精度转换工具包**，基于 [marker-pdf](https://github.com/datalab-to/marker) 构建。专为学术论文、技术文档的中文/英文 PDF 设计，GPU 加速，LaTeX 公式保留最佳。

## 特性

- 🔬 **学术级精度** — 对 LaTeX 公式、表格、多栏布局保留度领先
- ⚡ **GPU 加速** — 100 页 PDF 可在 H100 上 1 分钟内处理完成
- 🌏 **中文友好** — 完美支持中英文混合文档
- 🔄 **批量转换** — 支持单文件/目录批量
- 🛡️ **离线运行** — 模型权重本地加载，无需 API

## 快速开始

```bash
# 首次部署
scripts/pdf2md.sh setup

# 健康检查
scripts/pdf2md.sh doctor

# 单文件转换
scripts/pdf2md.sh single "/path/to/paper.pdf" "./output"

# 批量转换目录
scripts/pdf2md.sh batch "./papers" "./output"
```

## 命令参考

| 命令 | 说明 |
|------|------|
| `setup [--python <bin>] [--recreate]` | 首次部署/重建虚拟环境 |
| `doctor` | 健康检查 |
| `single <pdf_path> [output_dir]` | 单文件转换 |
| `batch <pdf_dir> [output_dir]` | 批量转换目录 |
| `fast single|batch <marker_options>` | 高级参数透传 |

### Make 快捷方式

```bash
make setup          # 部署
make doctor         # 健康检查
make single PDF=/path/file.pdf OUT=./output   # 单文件
make batch DIR=./papers OUT=./output          # 批量
```

## 环境要求

- Python 3.9+
- macOS / Linux
- GPU 可选（自动检测 CUDA/MPS）
- 首次运行自动下载模型权重（~2GB）

## 高级用法

```bash
# 禁用 OCR（纯文本 PDF 加速）
scripts/pdf2md.sh fast single "./paper.pdf" --disable_ocr

# 指定输出格式
scripts/pdf2md.sh fast single "./paper.pdf" --output_format markdown

# 跳过已存在的文件（批量模式默认开启）
scripts/pdf2md.sh batch "./papers" "./output" --skip_existing
```

## 项目结构

```
thesis-pdf2md/
├── scripts/
│   ├── pdf2md.sh          # 主入口
│   ├── setup_marker.sh    # 兼容旧版入口
│   ├── marker_convert.sh  # 转换包装
│   ├── marker_fast.sh     # 快速模式
│   ├── network_accelerate.sh  # 镜像加速
│   └── lib.sh             # 公共函数库
├── MARKER_SETUP.md        # 详细部署文档
├── Makefile               # 快捷命令
└── README.md
```

## 致谢

基于 [marker-pdf](https://github.com/datalab-to/marker) (GPL-3.0) — 高效的深度学习 PDF 解析管线。
