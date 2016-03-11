+++
Description = "Kloudsecを使って3 stepsでCustom domainなGitHub PagesのSSL対応をする."
Tags = ["GitHub Pages"]
date = "2016-03-11T16:30:07+09:00"
draft = true
title = "Kloundsec for SSL with Custom Domain on GitHub Pages"
slug = "kloudsec-for-ssl-with-custom-domain-on-gh-pages"
+++

Kloudsecを使って3 stepsでCustom domainなGitHub PagesのSSL対応をする.

<!--more-->

{{% image "/20160311/eyecatch.png" %}}

1. [Kloudsec]({{% relref "#kloudsec" %}})
2. [3 steps Integration]({{% relref "#3-steps-integration" %}})
3. [See Also]({{% relref "#see-also" %}})

# Kloudsec

KloudsecはDomainをKloudsecのCDNのIPに向けるだけで、サイトの問題点の分析と修正をしてくれるサービス.

[以前]({{% relref "post/use-ssl-with-custom-domain-on-gh-pages.md" %}})
にCloudFlareでCustom domainなGitHub PagesのSSL対応をする記事を書いたが、
CloudFlareを使おうとすると DNS server (Name server) をCloudFlareのDNS serverに切り替えないといけなく、
これが結構負担になった.

Kloudsec for GitHub Pagesを使用すると、既存のDNS serverのままで、
DNS recordを変更するだけでCustom domainなGitHub PagesのSSL対応ができる.


# 3 steps Integration

GitHub PageのKloudsecへの登録は __3 steps__ で完了する.


## Register a Kloudsec account

{{% image "/20160311/register_account.png" %}}

EmailとPasswordを入力.


## Configure your Github Page

{{% image "/20160311/configure_github_page.png" %}}

登録するGitHub PageのRepositoryのURLと登録するCustom domainを入力.
登録するRepositioryに `CNAME` fileを追加.
([Quick start: Setting up a custom domain](https://help.github.com/articles/quick-start-setting-up-a-custom-domain/))


## Configure your DNS settings

{{% image "/20160311/configure_dns.png" %}}

最後に表示されている設定を使用しているDNS serverに登録する.
FormのInput要素をClickするとClipboardにcopyされる.

※Record 2の登録の際はSubdomainに注意. ↑の画像の場合、登録するSubdomainは `kloudsecurity****.gh-pages` となる.

最後に **I'm done! Bring me to my dashboard.** をClickすれば完了.

これだけでCDNの接続は完了.

すこし待つと

{{% image "/20160311/ssl_certificate_ready.png" %}}

の様なEmailが届きSSLの設定も完了.

# See Also

- [Kloudsec](https://kloudsec.com/)
- [Kloudsec for GitHub Pages](https://kloudsec.com/github-pages/new)
