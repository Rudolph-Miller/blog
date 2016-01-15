+++
Description = "Import Query Result to BigQuery"
Tags = ["Embulk", "BigQuery", "Kaizen Platform"]
date = "2016-01-15T18:45:16+09:00"
draft = false
slug = "import-query-result-to-bigquery"
title = "Import Query Result to BigQuery"
+++

特定DirectoryにあるSQL fileを実行して、結果をBigQueryに入れるScriptを書いた.

<!--more-->

1. [Background]({{< relref "#background" >}})
2. [Import Query Result to BigQuery]({{< relref "#import-query-result-to-bigquery" >}})
3. [See Also]({{< relref "#see-also" >}})


# Background

[Kaizen Platform](https://kaizenplatform.com/ja/)では[BigQuery](https://cloud.google.com/bigquery/?hl=ja)と[re:dash](http://redash.io/)を使ってProjectの__定量KPIの可視化__をしていて、定期的に振り返りの機会を設けている.

これを実施・運用する上で困ったのが、UserのPVなどをplotする際に社内のUserかどうかがBigQueryに格納しているDataだけでは判別がつかないことだった.  
(社内UserのIDリストを `user_id NOT IN (...)` に貼り付けるという__真心こもったOperation__が行われていた.)

Kaizen Platformでは数ヶ月に一度 `Kaizen Week` の名で、日頃のプロジェクトを一時停止して、積みタスクや、リファクタリング、新しいツールの試験・導入などの時間を確保しようという試みがあり、ちょうど今週がその `Kaizen Week` だったので、ここを改善しようと思った.

解決策としては2通り考えられる.
一つがLogにUserの属性を埋め込む方法、もう一つはBigQuery外部のDatabase (今回は社内のMySQL) からUserの属性を参照する方法だが、今回は二つ目の方法をとることにした.

外部DatabaseをBigQueryから参照する方法だが、Query Engineでうまい具合にJOINする方法 ([Presto](https://prestodb.io/)) と、外部DatabaseのDataをBigQueryにimportする方法が考えられた. 一つ目の方法はこれぐらい軽いことをやりるのにわざわさ導入するのはなって気がした (あくまで気がした) ので、外部DatabaseのDataをBigQueryにimportすることにした.

今回の場合、とりあえずUserのTableをうまい具合にBigQueryにimportするだけで良かったが、今後もカジュアルに外部DatabaseのDataをBigQueryにimportしたいという要望があったので、__特定の場所にSQL fileを配置するだけで、それらを実行した結果をBigQueryにimportできる__ようにした.


# Import Query Result to BigQuery

## How

始めはGoでScriptを書いていたが、ふとEmbulkが使えないかと思って調べてみると、

- MySQLのInput pluginとBigQueryのOutput pluginは当然ある.
- MySQLのInput pluginで任意のQueryが実行できる.
- Queryの実行結果に対応するSchemaからBigQueryのSchemaを生成できると良かったが (別でPlugin書けばできそう) 、今回はSQL fileと別に `.schema.json` でBigQueryのSchemaを用意することにする.
- Configulation fileのExtensionを `liquid` にすると[Liquid Template Engine](http://liquidmarkup.org/)が使用できる.
  - `env` によって外部から値を差し込むことが可能.

だったので、Scriptの中で特定の場所にあるSQL fileをとってきて、その情報で `env` を差し替えることにより、QueryそれぞれでConfigulation fileを作成する必要がなく、Embulkで上の目標が達成できそうだったので、Embulkを採用することにした.


## Do it

Embulkはinstall済みだとして、

```sh
$ embulk gem install embulk-input-mysql
$ embulk gem install embulk-output-bigquery
```

で、今回必要なPluginsをinstallする.

```yaml
in:
  type: mysql
  host: {{ env.mysql_host }}
  user: {{ env.mysql_user }}
  {% if env.mysql_password %}
    password: {{ env.mysql_password }}
  {% endif %}
  database:  {{ env.mysql_database }}
  query: {{ env.query }}
out:
  type: bigquery
  file_ext: csv
  auth_method: private_key
  service_account_email: {{ env.service_account_email }}
  p12_keyfile: {{ env.p12_keyfile }}
  path_prefix: /tmp/import_query_result_to_bq/
  file_ext: csv
  delete_from_local_when_job_end: 1
  project: your_project
  dataset: {{ env.dataset }}
  table: {{ env.table }}_%Y%m%d
  source_format: CSV
  formatter:
    type: csv
    header_line: false
  schema_file: {{ env.schema_file }}
  auto_create_table: 1
```

のように `Liquid Template Engine` を使用し `env` で設定可能な `config.yml.liquid` を用意し、

```sh
#!/bin/bash

QUERY_DIR=query
DATASET=tmp

export service_account_email=example@developer.gserviceaccount.com
export p12_keyfile=/path/to/p12_keyfile.p12

export mysql_host=localhost
export mysql_user=root
export mysql_password=password
export mysql_database=your_database
export dataset=$DATASET

for file in $QUERY_DIR/*.sql; do
  export query=`cat $file`
  filename=${file##*/}
  basename=${filename%.*}
  dir=$(cd $(dirname $file) && pwd)
  export table=$basename
  export schema_file=$dir/$basename.schema.json
  embulk run config.yml.liquid
done
```

のようなScriptを `import_query_result_to_bigquery` として用意し実行権限をつけ、 `QUERY_DIR` に設定したDirectoryに、

```sql
SELECT id FROM users WHENE is_admin = 1;
```

を `admin_users.sql` として、

```json
[
  { "name": "id", "type": "STRING" }
]
```

を `admin_users.schema.json` として配置し、

```sh
$ ./import_query_result_to_bigquery
```

を実行すると、 `admin_users.sql` のQueryの実行結果を `DATASET` で設定したBigQueryのDatasetにTable名 `admin_users_20160114` (PrefixはSQL file名で、Suffixは年月日) としてimportできる.


## Operation

### Query files

`*.sql` と `*.schema.json` は専用のGitHubのRepositioryを作成して、そこに集約し、Scriptの実行前に `QUERY_DIR` で指定したDirectoryに展開する.

これによって、新しくQueryを追加する際に、__GitHub上で完結__できる.


### Query in BigQuery

cronなどでDailyのJobとして実行するとして、Table名のSuffixとして `_%Y%m%d` がついているので、BigQuery上では `TABLE_DATE_RANGE` を使用して、

```
SELECT * FROM TABLE_DATE_RANGE(tmp.admin_users_, DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'), CURRENT_TIMESTAMP());
```

のようにすると、当日のTableを対象としてQueryを実行できる.


---

EmbulkのPlugin機構と `Liquid Template Engine` のおかげで簡単なScriptで業務が改善した.

---


# See Also

- [Embulk](https://github.com/embulk/embulk)
- [embulk-input-mysql](https://github.com/embulk/embulk-input-jdbc/tree/master/embulk-input-mysql)
- [embulk-output-bigquery](https://github.com/embulk/embulk-output-bigquery)
- [Liquid Template Engine](http://liquidmarkup.org/)
