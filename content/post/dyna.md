+++
Description = "Introduction of Dyna."
Tags = ["Common Lisp", "Library", "Dyna", "AWS"]
date = "2015-07-08T22:22:11+09:00"
title = "Introducton of Dyna"
draft = true
+++


自作LibraryのDynaを紹介.

<!--more-->

What Dyna is.
---

Dynaは__DynamoDB baseのORM__だ.
Common LispでORMといえば[Integral](https://github.com/fukamachi/integral)で、
CLOS baseの柔軟性の良さはみんな味わっていると思うが、
DynaはそのIntegralにinspireされて作ったもので、ほぼ同様のAPIを提供している.


What DynamoDB is.
---

なぜDynamoDBのORMを作ろうと思ったかの前に、DynamoDBの特徴を紹介しようと思う.

[Amazon DynamoDB（初心者向け 超速マスター編）JAWSUG大阪](http://www.slideshare.net/shimy_net/amazon-dynamodb-23315068)

- NoSQL
- KVS
- スキーマレス
- Full Managed
- CloudWatch
- IOPSをぽちぽちっと変更できる.
- データベース容量は自動で拡張.
- SSD
- Multi Availability Zoneにreplicateされる.
- DynamoDB Localでローカル環境作成できる.
- Local Secondary Index
- AWS SDK (Android, Java, Python, JavaScript, .NET, PHP, iOS, Ruby)
- Elastic MapReduceやRedshiftとの統合.
- 無料枠有り.

ざっくり書くとこんな感じなのだが、詳しくは[Amazon DynamoDB](http://aws.amazon.com/jp/dynamodb/)を参照.

ポイントは__スケールが簡単__で__SSD__.

Why DynamoDB.
---

一見便利そうなDynamoDBですが、大きな問題があって、__Common LispにSDKが無い__.
HTTP APIがあって、そこで全て操作できるんですが、ちょっと使ってみるには[Signing Process](http://docs.aws.amazon.com/general/latest/gr/signature-version-4.html)も
[JSON Data Format](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DataFormat.html)も面倒い.

たとえば[Query](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Query.html)してみたいとすると、

```
POST / HTTP/1.1
Host: dynamodb.<region>.<domain>;
X-Amz-Date: <Date>
Authorization: AWS4-HMAC-SHA256 Credential=<Credential>, SignedHeaders=content-length;content-type;host;user-agent;x-amz-content-sha256;x-amz-date;x-amz-target, Signature=<Signature>
User-Agent: <UserAgentString>
x-amz-content-sha256: <PayloadHash>
Content-Type: application/x-amz-json-1.0
Content-Length: <PayloadSizeBytes>     
Connection: Keep-Alive X-Amz-Target: DynamoDB_20120810.Query 

{
  "TableName": "Reply",
  "IndexName": "PostedBy-Index",
  "Limit": 3,
  "ConsistentRead": true,
  "ProjectionExpression": "Id, PostedBy, ReplyDateTime",
  "KeyConditionExpression": "Id = :v1 AND PostedBy BETWEEN :v2a AND :v2b",
  "ExpressionAttributeValues": {
    ":v1": {"S": "Amazon DynamoDB#DynamoDB Thread 1"},
    ":v2a": {"S": "User A"},
    ":v2b": {"S": "User C"}
  },
  "ReturnConsumedCapacity": "TOTAL"
}
```

をrequestして、Responseとして

```
HTTP/1.1 200 OK
x-amzn-RequestId: <RequestId> 
x-amz-crc32: <Checksum>
Content-Type: application/x-amz-json-1.0
Content-Length: <PayloadSizeBytes>
Date: <Date>
{
  "ConsumedCapacity": {
    "CapacityUnits": 1,
    "TableName": "Reply"
  },
  "Count": 2,
  "Items": [
    {
      "ReplyDateTime": {"S": "2015-02-18T20:27:36.165Z"},
      "PostedBy": {"S": "User A"},
      "Id": {"S": "Amazon DynamoDB#DynamoDB Thread 1"}
    },
    {
      "ReplyDateTime": {"S": "2015-02-25T20:27:36.165Z"},
      "PostedBy": {"S": "User B"},
      "Id": {"S": "Amazon DynamoDB#DynamoDB Thread 1"}
    }
  ],
  "ScannedCount": 2
}
```

みたいなのが返ってくる. これでは気軽に試そうとは思わない.
この上、Local Secondary Index張ってるからQueryできるとか、これだとScanでFilter使ってとか考えなきゃまともに使えない.
以前、Common LispはまだAWSを使い倒すLibraryがそろって無いって言ったのもあって、無いなら自分でそろえて行くかと.

だから作った.
