+++
Description = "Custom domainなGitHub PagesのSSL化にKloudsecを使ってみた."
Tags = ["GitHub Pages"]
date = "2016-03-11T16:30:07+09:00"
draft = true
title = "Kloundsec for SSL with Custom Domain on GitHub Pages"
slug = "kloudsec-for-ssl-with-custom-domain-on-gh-pages"
+++

Custom domainなGitHub PagesのSSL化にKloudsecを使ってみた.

<!--more-->

{{% image "/20160311/eyecatch.png" %}}

1. [Kloudsec]({{% relref "#kloudsec" %}})
2. [Integration]({{% relref "#integration" %}})
3. [See Also]({{% relref "#see-also" %}})

# Kloudsec

KloudsecはdomainをKloudsecのCDNのIPに向けるだけで、サイトの問題点の分析と修正をしてくれるサービス.

[以前]({{% relref "post/use-ssl-with-custom-domain-on-gh-pages.md" %}})
にCloudFlareでCustom domainなGitHub PagesのSSL対応をする記事を書いたが、
CloudFlareを使おうとすると DNS server (Name server) をCloudFlareのDNS serverに切り替えないといけなく、
これが結構負担になった.

Kloudsec for GitHub Pagesを使用すると、既存のDNS serverのままで、
DNS recordを変更するだけでCustom domainなGitHub PagesのSSL対応ができる.


# Integration


# See Also

- [Kloudsec](https://kloudsec.com/)
- [Kloudsec for GitHub Pages](https://kloudsec.com/github-pages/new)
