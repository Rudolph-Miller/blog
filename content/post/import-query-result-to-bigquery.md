+++
Description = "Import Query Result to BigQuery"
Tags = ["Embulk", "BigQuery"]
date = "2016-01-14T10:56:46+09:00"
draft = true
title = "Import Query Result to BigQuery"
slug = "import-query-result-to-bigquery"
+++

特定DirectoryにあるSQL fileを実行して、結果をBigQueryに入れるScriptを書いた.

<!--more-->

1. [Import Query Result to BigQuery]({{< relref "#import-query-result-to-bigquery" >}})
2. [See Also]({{< relref "#see-also" >}})


# Import Query Result to BigQuery

## Why


## Example

```yaml
n:
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
  service_account_email: example@developer.gserviceaccount.com
  p12_keyfile: /path/to/p12_keyfile.p12
  path_prefix: /tmp/embulk/query_result_to_bigquery/
  file_ext: csv
  delete_from_local_when_job_end: 1
  project: your-project-name
  dataset: {{ env.dataset }}
  table: {{ env.table }}_%Y%m%d
  source_format: CSV
  formatter:
    type: csv
    header_line: false
  schema_file: {{ env.schema_file }}
  auto_create_table: 1
```

のように `Liquid Template Engine` を使用して、 `env` で設定可能な `config.yml.liquid` を用意し、

```ruby
require 'open3'

QUERY_DIR = 'query'
DATASET = 'tmp'

def exec(cmd)
  puts cmd
  Open3.popen3(cmd) do |i, o, e, w|
    i.close
    o.each do |line| puts line end
    e.each do |line| puts line end
  end
end

ENV['mysql_host'] = 'localhost'
ENV['mysql_user'] = 'root'
ENV['mysql_password'] = 'password'
ENV['mysql_database'] = 'your_database'
ENV['dataset'] = DATASET

Dir.glob("#{QUERY_DIR}/*.sql").each do |file|
  basename = File.basename(file, ".sql")
  schema_file = file.sub(/\.sql$/, '.schema.json')

  puts "Basename: #{basename}"
  ENV['table'] = basename
  ENV['query'] = File.read(file)
  ENV['schema_file'] = File.expand_path(schema_file)
  exec 'embulk run config.yml.liquid'
end
```

のようなScriptを `import_query_result_to_bigquery.rb` として用意し、 `QUERY_DIR` に設定したDirectoryに、

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
ruby import_query_result_to_bigquery
```

を実行すると、 `DATASET` で設定したBigQueryのDatasetに `admin_users_20160114` (Suffixは日毎で変化) として、MySQLのDataがloadされる.

## Operation

### Query files

`*.sql` と `*.schema.json` は専用のGitHubのRepositioryを作成して、そこに集約し、実行時に `QUERY_DIR` で指定したDirectoryに展開する.

これによって、新しくQueryを追加する際に、__GitHub上で完結__できる.

### Query in BigQuery

cronなどでDailyのJobとして実行するとして、Table名のSuffixとして `_%Y%m%d` がついているので、BigQuery上では `TABLE_DATE_RANGE` を使用して、

```
SELECT * from TABLE_DATE_RANGE(admin_users, DATE_ADD(CURRENT_TIMESTAMP(), -1, 'DAY'), CURRENT_TIMESTAMP());
```

のようにすると、当日のTableを対象としてQueryを実行できる.


# See Also

- [embulk-output-bigquery](https://github.com/embulk/embulk-output-bigquery)
- [embulk-input-mysql](https://github.com/embulk/embulk-input-jdbc/tree/master/embulk-input-mysql)
