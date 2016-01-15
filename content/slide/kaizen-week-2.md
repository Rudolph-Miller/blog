+++
Description = "Kaizen Week #2"
Tags = ["Kaizen Week"]
date = "2016-01-15T15:03:17+09:00"
draft = false
slug = "kaizen-week-2"
title = "kaizen week 2"
unpublic = true
+++

name: inverse
layout: true
class: center, middle, inverse
---

# Kaizen Week #2

---

# @Rudolph-Miller

---

layout: false
class: middle

.left-column[
# List
]

--

.right-column[
## Make Editor Textarea of Editor resizable
]

--

.right-column[
## Script to import results of any SQL files to BigQuery
]

---

template: inverse

# Make Editor Textarea of Editor resizable

---

background-image: url(/images/20160115/resizable_textarea.gif)

---

template: inverse

# Script to import results of any SQL files to BigQuery

---

class: middle, center

## Background: [次元テーブル管理の要件](https://kaizen.qiita.com/YuKawabe/items/45f9c12b1c2865195fa4#1-2)

---

.left-column[
# Tools
]

--

.right-column[
* Go
]

---

.left-column[
# Tools
]

.right-column[
* ~~Go~~
]

--

.right-column[
* Embulk
]

--

.right-column[
* embulk-input-mysql
]

--

.right-column[
* embul-output-bigquery
]

--

.right-column[
* Liquid Template Engine
]

--

.right-column[
* Shell script
]

---

`config.yml.liquid`

```liquid
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
  project: kaizen-analytics
  dataset: {{ env.dataset }}
  table: {{ env.table }}_%Y%m%d
  source_format: CSV
  formatter:
    type: csv
    header_line: false
  schema_file: {{ env.schema_file }}
  auto_create_table: 1
```

---

`import_query_result_to_bq`

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

---

class: middle

`@query/not_admin_users.sql`

```sql
SELECT id FROM users WHERE email NOT LIKE '%kaizenplatform%';
```

`@query/not_admin_users.schema.json`

```json
[
 {"name": "id", "type": "integer"}
]
```

---

class: middle

```sh
$ ./import_query_result_to_bq
```

---

```sh
2016-01-15 12:07:15.267 +0900: Embulk v0.7.10
2016-01-15 12:07:17.987 +0900 [INFO] (transaction): Loaded plugin embulk-input-mysql (0.6.2)
2016-01-15 12:07:18.061 +0900 [INFO] (transaction): Loaded plugin embulk-output-bigquery (0.1.11)
2016-01-15 12:07:18.121 +0900 [INFO] (transaction): Fetch size is 10000. Using server-side prepared statement.
2016-01-15 12:07:20.034 +0900 [INFO] (transaction): {done:  0 / 1, running: 0}
2016-01-15 12:07:20.187 +0900 [INFO] (task-0000): Writing file [/tmp/import_query_result_to_bq/.000.00.csv]
2016-01-15 12:07:20.244 +0900 [INFO] (task-0000): Fetch size is 10000. Using server-side prepared statement.
2016-01-15 12:07:20.257 +0900 [INFO] (task-0000): SQL: SELECT id FROM users WHERE email NOT LIKE '%kaizenplatform%';
2016-01-15 12:07:20.269 +0900 [INFO] (task-0000): > 0.01 seconds
2016-01-15 12:07:20.297 +0900 [INFO] (task-0000): Fetched 500 rows.
2016-01-15 12:07:20.303 +0900 [INFO] (task-0000): Fetched 1,000 rows.
2016-01-15 12:07:20.328 +0900 [INFO] (task-0000): Fetched 2,000 rows.
2016-01-15 12:07:20.369 +0900 [INFO] (task-0000): Job preparing... project:kaizen-analytics dataset:tmp table:_20160115
2016-01-15 12:07:20.410 +0900 [INFO] (task-0000): table:[_20160115] will be create if not exists
2016-01-15 12:07:20.439 +0900 [INFO] (task-0000): Upload start [/tmp/import_query_result_to_bq/.000.00.csv]
2016-01-15 12:07:28.980 +0900 [INFO] (task-0000): Upload completed [/tmp/import_query_result_to_bq/.000.00.csv]
```

---

```sh
2016-01-15 12:07:28.985 +0900 [INFO] (task-0000): Job executed. job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] file:[/tmp/import_query_result_to_bq/.000.00.csv]
2016-01-15 12:07:29.158 +0900 [INFO] (task-0000): Checking job status... job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] elapsed_time:173ms status:[PENDING]
2016-01-15 12:07:39.339 +0900 [INFO] (task-0000): Checking job status... job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] elapsed_time:10354ms status:[PENDING]
2016-01-15 12:07:49.523 +0900 [INFO] (task-0000): Checking job status... job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] elapsed_time:20538ms status:[PENDING]
2016-01-15 12:07:59.704 +0900 [INFO] (task-0000): Checking job status... job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] elapsed_time:30719ms status:[PENDING]
2016-01-15 12:08:09.887 +0900 [INFO] (task-0000): Checking job status... job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] elapsed_time:40902ms status:[RUNNING]
2016-01-15 12:08:20.117 +0900 [INFO] (task-0000): Checking job status... job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] elapsed_time:51132ms status:[RUNNING]
2016-01-15 12:08:30.295 +0900 [INFO] (task-0000): Job statistics [{"inputFileBytes":"20837","inputFiles":"1","outputBytes":"29144","outputRows":"3643"}]
2016-01-15 12:08:30.295 +0900 [INFO] (task-0000): Job completed successfully. job id:[job_jv3ahl8c1h-g38h1jTnOGKIrUIc] elapsed_time:61310ms status:[SUCCESS]
2016-01-15 12:08:30.296 +0900 [INFO] (task-0000): Delete local file [/tmp/import_query_result_to_bq/.000.00.csv]
2016-01-15 12:08:30.296 +0900 [INFO] (transaction): {done:  1 / 1, running: 0}
2016-01-15 12:08:30.304 +0900 [INFO] (main): Committed.
2016-01-15 12:08:30.304 +0900 [INFO] (main): Next config diff: {"in":{},"out":{}}
```

---

background-image: url(/images/20160115/not_admin_users_table_info.png)

---

class: middle

```sql
AND user_id NOT IN ( 1490 rows )
```

--

↓

```sql
INNER JOIN tmp.not_admin_users_20160114 not_admin_users ON not_admin_users.id = user_id
```

---

background-image: url(/images/20160115/logo.jpg)
