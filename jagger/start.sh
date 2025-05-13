#!/usr/bin/env bash

# reference: https://www.tkl.iis.u-tokyo.ac.jp/~ynaga/jagger

set -euxo pipefail

wget -q http://www.tkl.iis.u-tokyo.ac.jp/~ynaga/jagger/jagger-latest.tar.gz
tar zxvf jagger-latest.tar.gz
pushd jagger-2024-03-14 || exit 1

# 1) prepare a dictionary in the format compatible with mecab-jumandic (cf. mecab-jumandic-7.0-20130310.tar.gz)
wget -q https://github.com/shogo82148/mecab/releases/download/v0.996.11/mecab-jumandic-7.0-20130310.tar.gz
wget -q http://www.tkl.iis.u-tokyo.ac.jp/~ynaga/jagger/mecab-jumandic-7.0-20130310.patch
tar zxvf mecab-jumandic-7.0-20130310.tar.gz
patch -R -p0 <mecab-jumandic-7.0-20130310.patch # correct gabled text in AuxV.csv

# 2) Use the Kyoto University Web Document Leads Corpus (default)
git clone https://github.com/ku-nlp/KWDLC
./configure --prefix=/home/xatier

## 3) Train a model from the standard split, evaluate the resulting model, and then install
make model-benchmark && make install
popd
