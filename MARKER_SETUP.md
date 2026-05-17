# thesis-pdf2md 使用与部署

## 项目入口

- 主入口：`scripts/pdf2md.sh`
- 兼容入口：`scripts/setup_marker.sh`、`scripts/marker_convert.sh`、`scripts/marker_fast.sh`

## 首次部署

```bash
cd "/Users/maoyo/Documents/thesis-pdf2md"
scripts/pdf2md.sh setup
```

## 重新部署（重建虚拟环境）

```bash
scripts/pdf2md.sh setup --recreate
```

或：

```bash
make redeploy
```

## 健康检查

```bash
scripts/pdf2md.sh doctor
```

## 转换命令

单文件转 Markdown（默认输出到 `./output`）：

```bash
scripts/pdf2md.sh single "/absolute/path/to/paper.pdf" "./output"
```

批量转换目录（默认 `--skip_existing`）：

```bash
scripts/pdf2md.sh batch "./papers" "./output"
```

高级参数透传（直接透传给 marker）：

```bash
scripts/pdf2md.sh fast single "./papers/paper1.pdf" --output_format markdown --output_dir "./output" --disable_ocr
scripts/pdf2md.sh fast batch "./papers" --output_format markdown --output_dir "./output" --skip_existing
```

## 网络加速（可选）

默认自动加载 `scripts/network_accelerate.sh`，会设置镜像并尝试探测代理可用性。

如需自定义，先导出环境变量：

```bash
export PROXY_URL="http://127.0.0.1:1082"
export PROXY_TEST_URL="https://huggingface.co"
export HF_ENDPOINT="https://hf-mirror.com"
export PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
```

仅当你确定有证书问题时，才设置：

```bash
export PIP_TRUSTED_HOST="pypi.tuna.tsinghua.edu.cn"
```

## 说明

- 首次实际转换会下载模型权重，耗时显著更长。
- 对可选中文本 PDF，可尝试 `--disable_ocr` 以加速。
