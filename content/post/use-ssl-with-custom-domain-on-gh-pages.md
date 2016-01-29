+++
Description = "Custom domainなGitHub PagesをSSL対応する."
Tags = ["GitHub Pages"]
date = "2016-01-28T15:56:50+09:00"
draft = true
title = "Use SSL with Custom Domain on GitHub Pages"
slug = "use-ssl-with-custom-domain-on-gh-pages"
+++

Custom domainなGitHub PagesをSSL対応する.

<!--more-->

1. [SSL on GitHub Pages]({{< relref "#ssl-on-github-pages" >}})
2. [CloudFlare]({{< relref "#cloudflare" >}})
3. [See Also]({{< relref "#see-also" >}})


# SSL on GitHub Pages

*blog.rudolph-miller.com* はGitHub Pagesで配信しており、
ふとGitHub PagesはSSL対応しているのかと思い調べてみた.

defaultの *github.io* domainの場合はSSL対応しているが、
Custom domainを使用している場合は
証明書のdomainが異なるためGitHubの発行している証明書ではSSLが使えないようだった.

なにかやり方がないかと調べていると、
[CloudFlare](https://www.cloudflare.com/)のDNSを使えばCustom domainでもSSL対応できそうだったのでやってみた.


# CloudFlare

## About

CloudFlareはCDNやDNSをやってるUSの企業.
Freeプランがあり、基本無料で使える.


## Setting

Sign upからdomainの登録は迷わないと思うので割愛.

今回した設定は `SSL`, `HSTS`, `Subdomain`.
基本的にはCloudFlareの管理画面のDomain毎のOverviewの上のMenuから入って設定する.

{{% image "20160129/menu.png" %}}


### SSL

SSLの設定は上のMenuの `Crypto`

{{% image "20160129/crypto.png" %}}

から行う.

{{% image "20160129/ssl.png" %}}

SSLの設定は `Off`, `Flexible`, `Full`, `Strict` と選べる.

- `Flexible`: ClientとCloudFlareの間は暗号化されたConnectionを使い、CloudFlareからServerは暗号化されてないConnectionを使う.
    - ServerにSSL証明書が必要ない.
    - 今回はこれを使用.
- `Full`: ClientとCloudFlare間もCloudFlareからServer間も暗号化されたConnectionを使う.
    - ServerにSSL証明書が必要.
- `Strict`: HTTPできたRequestをHTTPSにupgradeする.
    - Enterprise only.
    - ServerにSSL証明書が必要.

今回は `Flexible` を選択.


### HSTS

---

HSTSと言うのは `HTTP Strict Transport Security` の略で、
Web serverがWeb browserに対して、次回以降HTTPの代わりにHTTPSを使うように伝達する機能.

__次回以降__なので初回はHTTPでRequestし、その次からHTTPSを強制することができる.
(もちろん初回からHTTPSでRequestもできる.)

初回から強制するために、BrowserがHSTSの設定のpreloadを行う機能もある.
(CloadFlareでもpreloadを有効にすることが可能.)

---

HSTSの設定は `SSL` 同様に上のMenuの `Crypto`

{{% image "20160129/crypto.png" %}}

から行う.

{{% image "20160129/hsts.png" %}}


### Subdomain

Subdomainの設定は上のMenuの `DNS`

{{% image "20160129/dns.png" %}}

から行う.

今回はSubdomainが *blog.rudolph-miller.com* でGitHub PagesのDomainが *rudolph-miller.github.io* なので、

{{% image "20160129/dns_input.png" %}}

こんな感じに `CNAME` を登録し、

{{% image "20160129/dns_status.png" %}}

`Status` を

{{% image "20160129/not_penetrating.png" %}}

から

{{% image "20160129/penetrating.png" %}}

にClickで変更すると完了.

---

DNSの反映待ちはあったが、簡単にCustom domainなGitHub Pagesを簡単にSSL対応できた.


# See Also
