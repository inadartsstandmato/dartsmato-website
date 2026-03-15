#!/bin/bash
#
# MATO ホームページ デプロイスクリプト
# 使い方: ターミナルで ./deploy.sh を実行するだけ！
#

set -e

# スクリプトのあるディレクトリに移動
cd "$(dirname "$0")"

echo ""
echo "========================================="
echo "  MATO ホームページ デプロイ"
echo "========================================="
echo ""

# 変更があるか確認
if git diff --quiet && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  echo "変更はありません。デプロイ不要です。"
  exit 0
fi

# 変更内容を表示
echo "【変更されたファイル】"
git status --short
echo ""

# 確認プロンプト
read -p "この内容でデプロイしますか？ (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "キャンセルしました。"
  exit 0
fi

# コミットメッセージを自動生成
timestamp=$(date "+%Y/%m/%d %H:%M")
message="Update: ${timestamp}"

# ステージング・コミット・プッシュ
git add -A
git commit -m "$message"
git push origin main

echo ""
echo "========================================="
echo "  デプロイ完了！"
echo "  GitHub Pages に数分で反映されます。"
echo "========================================="
echo ""
