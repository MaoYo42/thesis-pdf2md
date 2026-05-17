# thesis-pdf2md

Local PDF-to-Markdown conversion toolkit built on `marker-pdf`.

## Quick Start

```bash
scripts/pdf2md.sh setup
scripts/pdf2md.sh doctor
scripts/pdf2md.sh single "/abs/path/paper.pdf" "./output"
```

## Commands

- `scripts/pdf2md.sh setup [--python <python_bin>] [--recreate]`
- `scripts/pdf2md.sh single <pdf_path> [output_dir]`
- `scripts/pdf2md.sh batch <pdf_dir> [output_dir]`
- `scripts/pdf2md.sh fast single|batch <marker_options...>`
- `scripts/pdf2md.sh doctor`

## Backward-Compatible Wrappers

- `scripts/setup_marker.sh`
- `scripts/marker_convert.sh`
- `scripts/marker_fast.sh`

## Notes

- Optional network acceleration is loaded from `scripts/network_accelerate.sh`.
- Keep `PIP_TRUSTED_HOST` empty unless you explicitly need to bypass mirror cert issues.
