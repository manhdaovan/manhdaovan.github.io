---
layout: post
title: Thực hiện benchmark (BM) MySQL InnoDB Buffer Pool(BP) trước và sau khi được warmup
date: 2017-03-02 00:00:00
summary: Mình thực hiện BM này cho chính [tool mình viết](https://github.com/manhdaovan/mysql_warmup), cũng là 1 tool đơn giản thôi, tiện thể đem kết quả lên khoe với mọi người luôn.
categories: mysql innodb bufferpool tool
---

#tech #mysql #innodb #bufferpool #mytool #vi

### Background

Với những database có lượng read lớn thì tầm quan trọng của việc warmup BP đã được nhắc tới nhiều. Nhưng nó có hiệu quả tới mức như thế nào? Mình đã thực hiện 1 BM đơn giản, với một table cũng đơn giản để cho thấy sự khác biệt trước và sau khi warmup.

### Môi trường:

```
$mysql --version
mysql  Ver 14.14 Distrib 5.7.14, for osx10.11 (x86_64) using  EditLine wrapper
```

CoreI5 @2.6GHz, DDR3 8GB@1600MHz, SSD

### Chuẩn bị:

* **Một MySQL instance KHÔNG CẤU HÌNH LOAD BP khi startup:**

```
mysql> show variables like '%buffer_pool%';
+-------------------------------------+----------------+
| Variable_name                       | Value          |
+-------------------------------------+----------------+
| innodb_buffer_pool_chunk_size       | 268435456      |
| innodb_buffer_pool_dump_at_shutdown | OFF            |
| innodb_buffer_pool_dump_now         | OFF            |
| innodb_buffer_pool_dump_pct         | 25             |
| innodb_buffer_pool_filename         | ib_buffer_pool |
| innodb_buffer_pool_instances        | 1              |
| innodb_buffer_pool_load_abort       | OFF            |
| innodb_buffer_pool_load_at_startup  | OFF            |
| innodb_buffer_pool_load_now         | OFF            |
| innodb_buffer_pool_size             | 268435456      |
+-------------------------------------+----------------+
10 rows in set (0.00 sec)
```

* **Một table với structure đơn giản như sau:**

```
mysql> desc test_data;
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| id          | int(11)      | NO   | PRI | NULL    | auto_increment |
| random_str  | varchar(255) | YES  | MUL | NULL    |                |
| random_str2 | varchar(255) | YES  |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+
3 rows in set (0.00 sec)
```


* **Với 10triệu records:**

```
mysql> select count(*) from test_data;
+----------+
| count(*) |
+----------+
| 10000000 |
+----------+
1 row in set (8.38 sec)
```

* **Một file SQL chứa 20k câu query để thực hiện BM, có format:**

```
select * from test_data where random_str = "unique_string_value";
```

Với `unique_string_value` lần lượt là các giá trị lấy ra từ `random_str` của table trên.

### Kịch bản BM

* **Step0: Khởi động MySQL với option chỉ định KHÔNG LOAD, KHÔNG DUMP BP, và init BP size là 256MB:**

```
$mysql.server start --innodb_buffer_pool_load_at_startup=0 --innodb_buffer_pool_dump_at_shutdown=0 --innodb_buffer_pool_chunk_size=256M --innodb_buffer_pool_size=256M
```

* **Step1: Chạy BM command khi không dùng tool [mysql-warmup](https://github.com/manhdaovan/mysql_warmup)**

```
$mysqlslap --create-schema=warmup_benchmark --delimiter=";" --query=benchmark_query_20000_rows.sql --concurrency=1 --iterations=1 -uroot -p
Enter password:
Benchmark
    Average number of seconds to run all queries: 7.562 seconds
    Minimum number of seconds to run all queries: 7.562 seconds
    Maximum number of seconds to run all queries: 7.562 seconds
    Number of clients running queries: 1
    Average number of queries per client: 20001
```

Ý nghĩa câu lệnh trên là: Mô phỏng 1 client, thực hiện 20k queries, mỗi query là 1 câu select theo value của column random_str (column này đã được index).<br/>
Giả sử câu lệnh BM chuyển thành: Mô phỏng 20k clients, query cùng 1 nội dung, thì BM ko có ý nghĩa.

* **Step2: Chạy cùng câu lệnh như trên ngay sau đó, để thấy sự khác biệt khi BP được hit thay vì hit vào disk:**
```
$mysqlslap --create-schema=warmup_benchmark --delimiter=";" --query=benchmark_query_20000_rows.sql --concurrency=1 --iterations=1 -uroot -p
Enter password:
Benchmark
    Average number of seconds to run all queries: 1.740 seconds
    Minimum number of seconds to run all queries: 1.740 seconds
    Maximum number of seconds to run all queries: 1.740 seconds
    Number of clients running queries: 1
    Average number of queries per client: 20001
```

* **Step 3: Tắt mysql, Khởi động lại máy (cho chắc, tránh MySQL rơi vào sleep mode), sau đó khởi động MySQL service lên như Step0.**

* **Step4: Chạy mysql-warmup tool:**

```
$mysql-warmup -uroot -dwarmup_benchmark

Input the mysql password:
my_mysql_root_password
2017-02-24 15:33:07 +0900: --- >>>>>>> START WARMUP FOR DB: warmup_benchmark <<<<<<
2017-02-24 15:33:07 +0900: --- START WARMUP FOR TABLE:   `warmup_benchmark`.`test_data`
2017-02-24 15:33:29 +0900: --- SUCCESS WARMUP FOR TABLE: `warmup_benchmark`.`test_data`

2017-02-24 15:33:29 +0900: --- +++++++ SUCCESS WARMUP FOR DB: warmup_benchmark +++++++
```

* **Step5: Chạy lại câu lệnh BM như Step1:**

```
$mysqlslap --create-schema=warmup_benchmark --delimiter=";" --query=benchmark_query_20000_rows.sql --concurrency=1 --iterations=1 -uroot -p
Enter password:
Benchmark
    Average number of seconds to run all queries: 2.132 seconds
    Minimum number of seconds to run all queries: 2.132 seconds
    Maximum number of seconds to run all queries: 2.132 seconds
    Number of clients running queries: 1
    Average number of queries per client: 20001
```

* **Step6: Chạy lại câu lệnh như trên một lần nữa, xem có sự khác biệt nào không:**

```
$mysqlslap --create-schema=warmup_benchmark --delimiter=";" --query=benchmark_query_20000_rows.sql --concurrency=1 --iterations=1 -uroot -p
Enter password:
Benchmark
    Average number of seconds to run all queries: 1.886 seconds
    Minimum number of seconds to run all queries: 1.886 seconds
    Maximum number of seconds to run all queries: 1.886 seconds
    Number of clients running queries: 1
    Average number of queries per client: 20001
```

### Kết luận:
* Nhìn vào kết quả ở Step1 và Step5: 7.562 seconds vs 2.132 seconds cho những request đầu tiên. Không tệ lắm nhỉ.

#### P/S: Câu hỏi dành cho bạn đọc:

* Tại sao kết quả ở Step2(1.740 seconds) lại nhanh hơn ở Step5(2.132 seconds) ?
* Tại sao kết quả ở Step6(1.886 seconds) lại nhanh hơn ở Step5(2.132 seconds), nhưng lại chậm hơn ở Step2(1.740 seconds)?

Bạn có thể đọc [bản tiếng Anh ở đây](https://github.com/manhdaovan/mysql_warmup/blob/master/BENCHMARK.md)
