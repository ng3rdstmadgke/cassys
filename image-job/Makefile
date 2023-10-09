# Makefileの関数一覧: https://tex2e.github.io/blog/makefile/functions

# MakefileのSyntax
# $<
#   特殊変数。ターゲットの依存リストの最初のアイテムを示す
# $@
#   特殊変数。現在のターゲットを示す
# .PHONY: パッケージ名
#   ファイルやディレクトリといった物理的存在を持たない疑似ターゲット。
#   `make パッケージ名` のように実行することで、ターゲット名と同名のファイルが存在していても、ターゲットの内容を実行する

.PHONY: build-arm64
.PHONY: build-armhf
.PHONY: clean-arm64
.PHONY: clean-armhf

# arm64 用のイメージをビルド
build-arm64: /build/output-arm-image/arm64_cassys.img.xz

/build/output-arm-image/arm64_cassys.img.xz: /build/output-arm-image/arm64_cache_02.img /image-job/cassys/packer-arm64.pkr.hcl /image-job/cassys/ansible/*
	/packer.sh build -var 'host=arm64' /image-job/cassys/packer-arm64.pkr.hcl

/build/output-arm-image/arm64_cache_02.img: /build/output-arm-image/arm64_cache_01.img /image-job/cache_02/packer-arm64.pkr.hcl
	/packer.sh build /image-job/cache_02/packer-arm64.pkr.hcl

/build/output-arm-image/arm64_cache_01.img: /image-job/cache_01/packer-arm64.pkr.hcl
	/packer.sh build /image-job/cache_01/packer-arm64.pkr.hcl


# armhf 用のイメージをビルド
build-armhf: /build/output-arm-image/armhf_cassys.img.xz

/build/output-arm-image/armhf_cassys.img.xz: /build/output-arm-image/armhf_cache_02.img /image-job/cassys/packer-armhf.pkr.hcl /image-job/cassys/ansible/*
	/packer.sh build -var 'host=armhf' /image-job/cassys/packer-armhf.pkr.hcl

/build/output-arm-image/armhf_cache_02.img: /build/output-arm-image/armhf_cache_01.img /image-job/cache_02/packer-armhf.pkr.hcl
	/packer.sh build /image-job/cache_02/packer-armhf.pkr.hcl

/build/output-arm-image/armhf_cache_01.img: /image-job/cache_01/packer-armhf.pkr.hcl
	/packer.sh build /image-job/cache_01/packer-armhf.pkr.hcl


# お片付け
clean-arm64:
	rm -rf /build/output-arm-image/arm64_*

clean-armhf:
	rm -rf /build/output-arm-image/armhf_*