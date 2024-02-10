# Makefileの関数一覧: https://tex2e.github.io/blog/makefile/functions

# MakefileのSyntax
# $<
#   特殊変数。ターゲットの依存リストの最初のアイテムを示す
# $@
#   特殊変数。現在のターゲットを示す
# .PHONY: パッケージ名
#   ファイルやディレクトリといった物理的存在を持たない疑似ターゲット。
#   `make パッケージ名` のように実行することで、ターゲット名と同名のファイルが存在していても、ターゲットの内容を実行する

ARCH :=

.PHONY: validate-arch
validate-arch:
ifndef ARCH
	$(error ARCH is undefined)
else ifneq ($(filter $(ARCH), arm64 armhf),$(ARCH))
	$(error ARCH must is arm64 or armhf)
endif

.PHONY: build-arm64
build-arm64: /build/output-arm-image/arm64_cassys.img.xz ## arm64 用のイメージをビルド

/build/output-arm-image/arm64_cassys.img.xz: /build/output-arm-image/arm64_cache_02.img /image-job/cassys/packer-arm64.pkr.hcl /image-job/cassys/ansible/*
	/packer.sh build -var 'host=arm64' /image-job/cassys/packer-arm64.pkr.hcl

/build/output-arm-image/arm64_cache_02.img: /build/output-arm-image/arm64_cache_01.img /image-job/cache_02/packer-arm64.pkr.hcl
	/packer.sh build /image-job/cache_02/packer-arm64.pkr.hcl

/build/output-arm-image/arm64_cache_01.img: /image-job/cache_01/packer-arm64.pkr.hcl
	/packer.sh build /image-job/cache_01/packer-arm64.pkr.hcl



.PHONY: build-armhf
build-armhf: /build/output-arm-image/armhf_cassys.img.xz  ## armhf 用のイメージをビルド

/build/output-arm-image/armhf_cassys.img.xz: /build/output-arm-image/armhf_cache_02.img /image-job/cassys/packer-armhf.pkr.hcl /image-job/cassys/ansible/*
	/packer.sh build -var 'host=armhf' /image-job/cassys/packer-armhf.pkr.hcl

/build/output-arm-image/armhf_cache_02.img: /build/output-arm-image/armhf_cache_01.img /image-job/cache_02/packer-armhf.pkr.hcl
	/packer.sh build /image-job/cache_02/packer-armhf.pkr.hcl

/build/output-arm-image/armhf_cache_01.img: /image-job/cache_01/packer-armhf.pkr.hcl
	/packer.sh build /image-job/cache_01/packer-armhf.pkr.hcl



.PHONY: clean
clean: validate-arch ## お片付け
	rm -rf /build/output-arm-image/$(ARCH)_*

.PHONY: test
test:
	echo $(filter $(ARCH), arm64 armhf)

.PHONY: help
.DEFAULT_GOAL := help
help: ## HELP表示
	@grep --no-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'