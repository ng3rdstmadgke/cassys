# cassys (カシス)

Cloud Attach Storage System

# 使い方

## 64bit用のOSイメージを作成する場合

```bash
# 設定ファイルをコピー
cp image-job/cassys/ansible/host_vars/sample.yml image-job/cassys/ansible/host_vars/arm64.yml

# 設定ファイルの編集
vim image-job/cassys/ansible/host_vars/arm64.yml

# イメージ生成
./bin/build.sh arm64

# 出来上がったイメージ
ls .build/output-arm-image/arm64_cassys.img.xz
```

## 32bit用のOSイメージを作成する場合

```bash
# 設定ファイルをコピー
cp image-job/cassys/ansible/host_vars/sample.yml image-job/cassys/ansible/host_vars/armhf.yml

# 設定ファイルの編集
vim image-job/cassys/ansible/host_vars/arm64.yml

# イメージ生成
./bin/build.sh armhf

# 完成したイメージ
ls .build/output-arm-image/armhf_cassys.img.xz
```