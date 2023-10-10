# cassys (カシス)

Cloud Attach Storage System

S3をバックエンドにもつファイルサーバー機能を有した RaspberryPi OS を生成するコマンドラインツールです。

# 使い方

## 64bit用のOSイメージを作成する場合

```bash
# 設定ファイルをコピー
cp setting/sample.yml setting/my-setting.yml

# 設定ファイルの編集
vim setting/my-setting.yml

# イメージ生成
./bin/build.sh arm64 setting/my-setting.yml

# 出来上がったイメージ
ls .build/output-arm-image/arm64_cassys.img.xz
```

## 32bit用のOSイメージを作成する場合

```bash
# 設定ファイルをコピー
cp setting/sample.yml setting/my-setting.yml

# 設定ファイルの編集
vim setting/my-setting.yml

# イメージ生成
./bin/build.sh armhf 

# 完成したイメージ
ls .build/output-arm-image/armhf_cassys.img.xz
```