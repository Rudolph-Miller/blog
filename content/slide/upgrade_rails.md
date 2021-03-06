+++
Description = "Ruby on Railsを3.2から4.2にUpgradeする話."
Tags = ["Ruby on Rails"]
date = "2015-10-16T12:01:40+09:00"
draft = false
Title = "Upgrade Ruby on Rails"
slug = "upgrade_ruby_on_rails"
unpublic = true
+++

name: inverse
layout: true
class: center, middle, inverse
---

# Kaizen Week #1

---

# @Rudolph-Miller

---

# 3.2 to 4.2

---

# Upgrade Ruby on Rails

---

layout: false
.left-column[
手順
===
]

.right-column[
1. リリースノート.
  - リリースノートで変更を頭に入れておく.
2. Gemのupgrade.
  - RailsのUpgrade.
  - 依存解決.
3. 作業.
  - 壊れたところを直す.
4. 2 -> 3を繰り返す.
  - RailsのVersionは徐々にあげる.
  - 3.2 -> 4.0 -> 4.1 -> 4.2
]

---

## リリースノートはNew Railsの説明書

- [Ruby on Rails 4.0 リリースノート](http://railsguides.jp/4_0_release_notes.html)
- [Ruby on Rails 4.1 リリースノート](http://railsguides.jp/4_1_release_notes.html)
- [Ruby on Rails 4.2 リリースノート](http://railsguides.jp/4_2_release_notes.html)

---

template: inverse

# 説明書は読まないタイプ.

---

.left-column[
# 作業
]

.right-column[
1. Railsのupdate.
2. `bundle upgate rails`
  - 依存解決に失敗したら頑張る.
  - `bundle update`
3. `bundle exec rake rails:update`
  - config fileのupdate.
4. `bundle exec rake spec`
  - 起動するまで頑張る.
  - 起動してからも頑張る.
]

---
template: inverse

# 障害

---


.left-column[
## API変更
]

.right-column[
- scopeの書き方.
  - 心を無にして対応.
- relationの定義のincludeがdeprecated.
  - 心を無にして(ry.
- joinsしてそのtableの条件を使用する時はreferencesを明示する.
  - 心を(ry.
]

---

.left-column[
## Gem
]

.right-column[
- メンテ停止したGem達.
- 別Versionでの動作が保証されていないpatchが多数.
]

---

.left-column[
## ActiveRecord
]

.right-column[
### 失われた`bind_values`

- ActiveRecordをUpgrade.
  - 4.0 -> 4.1
  - 4.1 -> 4.2
- existsがbroken.
  - とはいえ相関subqueryのPerformanceは.
  - `INNER JOIN`で書き直すか.
- subqueryがbroken.
]

---
template: inverse

# 結果

---

background-image: url(/images/20151016/to_be_continued.jpg)
