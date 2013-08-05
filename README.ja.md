# simple-ping-summary

fping と imagemagick を使った簡易 ping 監視システム

## 使い方

### 初期設定

以下のように `_run.sh` を作成。
```
cp {example.,_}run.sh
edit _run.sh
./_run.sh
```
`/path/to/_run.sh` を定期的に実行。

```
cp {example.,_}gen-summary.sh
edit _gen-summary.sh
./_gen-summary.sh
open _img/summary.html
```
必要に応じて `_img/summary.html` を変更する。

### 日常の使い方

`_img/summary.html` を開いてステータスを確認する。
