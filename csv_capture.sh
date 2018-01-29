#!/bin/sh

# echo "csv_取り込み"

# $0	スクリプト名
# $1 ~ $9	引数、1番目の引数を$1、2番目の引数を$2でアクセスする
# $#	スクリプトに与えた引数の数
# $*	全部の引数をまとめて1つとして処理
# $@	全部の引数を個別として処理
# $?	直前実行したコマンドの終了値（0は成功、1は失敗）
# $$	このシェルスクリプトのプロセスID
# $!	最後に実行したバックグラウンドプロセスID

# 接続文字列とかを環境変数で登録
export PGHOST=localhost #HOSTIP
export PGPORT=9999      #PORT
export PGDATABASE=db    #DBNAME
export PGUSER=user      #USERNAME
export PGPASSWORD=pas   #PAS

# PostgreSQLのプロセス数をゲットする
PROC_COUNT=`ps -ax | grep postgres | grep -v grep | grep -c postgres`

# プロセスが無かったら諦める
if [ $PROC_COUNT -eq 0 ] ; then
  echo "1"
  exit 1
fi

# echo "# DB接続成功 #"
today=$(date "+%Y%m%d_%H%M%S")
r_sql=$1
r_val=$2

pg_res=`psql -c "${r_sql}"`
# echo "${pg_res}"  # SQL確認
# echo "${#pg_res}" # 文字の長さ確認

if echo "${pg_res}" | grep -q '0 rows' >/dev/null ; then # SQL結果が０件の場合にReturn
  echo "1"
  exit 1
else
  if echo "${pg_res}" | grep -q '^$' >/dev/null ; then # SQLが正しく動作しなかった場合にReturn
     echo "1"
     exit 1
  else
     psql -c "\copy (${r_sql}) TO '/var/samba/CSV/search_${today}_${r_val}.csv' WITH ( FORMAT csv , FORCE_QUOTE * , HEADER true ) ;"
     echo "0"
     exit 0
  fi
fi
