SSL証明書の有効期限を日本時間で確認するツールです。

## 必要なもの

* Perl
* OpenSSL
* DateTimeモジュール

## セットアップ

Cartonを利用する場合

	carton install

## 実行

	carton exec ./server-cert-valid-checker.pl DOMAIN_NAME

