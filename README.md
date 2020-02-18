# otolithr
[![Travis build status](https://travis-ci.org/kikirinrin/otolithr.svg?branch=master)](https://travis-ci.org/kikirinrin/otolithr)
[![codecov](https://codecov.io/gh/kikirinrin/otolithr/branch/master/graph/badge.svg)](https://codecov.io/gh/kikirinrin/otolithr)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

![example](https://gist.github.com/akikirinrin/1949f96742cbd8ba4396cf57657888d0#file-example-png)

## 目的
成長解析の手順を属人化させないためのパッケージです

## 現時点での機能
`.hdr`ファイルを直接読み込んでデータフレームを作ります。それだけです。

## 使い方

### インストール
以下をRのコンソールに打ち込んでください
```
# install.packages("devtools")   # If package 'devtools' is not installed to your machine
devtools::install_github("akikirinrin/otolithr")
library(otolithr)
```
### 使ってみる
```
path <- "YOUR_PATH_TO_HDR_FILES"                  # .hdr ファイルが入ったNASのフォルダなど
dat  <- hdr2df_in_dir(path, species = "maiwashi") # 現時点ではマイワシのみに対応
plot(dat)                                         # 日齢--耳石径をプロットします
```
