.PHONY: setup redeploy doctor single batch

setup:
	scripts/pdf2md.sh setup

redeploy:
	scripts/pdf2md.sh setup --recreate

doctor:
	scripts/pdf2md.sh doctor

single:
	@if [ -z "$(PDF)" ]; then echo "Usage: make single PDF=/abs/path/file.pdf OUT=./output"; exit 1; fi
	scripts/pdf2md.sh single "$(PDF)" "$(or $(OUT),./output)"

batch:
	@if [ -z "$(DIR)" ]; then echo "Usage: make batch DIR=./papers OUT=./output"; exit 1; fi
	scripts/pdf2md.sh batch "$(DIR)" "$(or $(OUT),./output)"
