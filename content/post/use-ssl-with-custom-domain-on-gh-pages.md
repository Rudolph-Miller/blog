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

blog.rudolph-miller.com はGitHub Pagesで配信しており、
ふとGitHub PagesはSSL対応しているのかと思い調べてみた.

defaultの *github.io* domainの場合はSSL対応しているが、
Custom domainを使用している場合は
証明書のdomainが異なるためGitHubの発行している証明書ではSSLが使えないようだった.

なにかやり方がないかと調べていると、
CloudFlareというDNSサービスを使えばSSL対応できそうだったのでやってみた.


# SSL on GitHub Pages

# CloudFlare

# See Also
