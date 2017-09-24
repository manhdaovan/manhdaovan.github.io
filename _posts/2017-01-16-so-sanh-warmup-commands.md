---
layout: post
title: So sánh các câu lệnh warmup primary key vào buffer pool với engine InnoDB mysql
date: 2017-01-16 00:00:00
summary: Buffer pool(BF) của mysql quả thực có nhiều lợi ích, và việc warm up BP luôn là việc nên làm đầu tiên mỗi khi start/reload/create new mysql. Tuy nhiên, "touch" thế nào cho tối ưu nhất? Trong quá trình thực hiện benchmark cho [tool này](https://github.com/manhdaovan/mysql_warmup), người viết thấy có 1 số điều thú vị như dưới đây.
categories: tech mysql innodb mytool
---

#tech #mysql #vi

### Background

[Buffer pool(BF)](http://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_buffer_pool) của mysql quả thực có nhiều lợi ích, và việc warm up BP luôn là việc nên làm đầu tiên mỗi khi start/reload/create new mysql.

* Mysql version >= 5.6 đã hỗ trợ đơn giản hoá việc save/restore BF state bằng cấu hình, nên việc cần làm chỉ là cấu hình là xong.
* Và trong các case khác, như cấu hình 1 slave mới, hoặc mysql version < 5.6, thì phải thực hiện việc này một cách thủ công. Cơ chế chung của việc warmup là "touch" vào primary key và index của table đó.
* Tuy nhiên, "touch" thế nào cho tối ưu nhất? Trong quá trình thực hiện benchmark cho [tool này](https://github.com/manhdaovan/mysql_warmup), người viết thấy có 1 số điều thú vị như dưới đây.

### Testing

Việc testing theo các case khác nhau khá dài, và chủ yếu là người viết cực kỳ lười :v, nên các bạn vui lòng đọc tại [link này](https://github.com/manhdaovan/mysql_warmup/blob/master/CHANGE_SUM_TO_COUNT.md).

### TL;DR

Để warmup primary key của table, thì câu lệnh nào dưới đây là tối ưu trong trường hợp:

* Table chỉ có primary key.
* Table ngoài primary key ra còn có nhiều hơn hoặc bằng một index nữa

**Các câu lệnh thử nghiệm:**

* select count(*) from table_name
* select count(*) from table_name where non_index_column = 0 or non_index_column = '0'
* select sum(primary_key) from table_name ?

#### Kết quả:

**Table with only primary key:**

* `select count(*) from table_name where non_index_column = 0 or non_index_column = '0'` cho kết quả nhiều pages được load vào BF là nhiều nhất.
* `select count(*) from table_name` và `select sum(primary_key) from table_name` cho cùng 1 kết quả số pages được load, nhưng ít hơn câu trên.

**Table with primary key and other index(es):**

* `select count(*) from table_name`: **primary_key** will be loaded.
* `select sum(primary_key) from table_name`: **other_index** will be loaded, not primary key (so funny).
* `select count(*) from table_name where non_index_column = 0 or non_index_column = '0'`: **primary_key** sẽ đựơc load với số lượng lớn nhất.

### Kết luận:

* Nên manual bằng cách touch primary key theo cách đảm bảo là tất cả primary key sẽ được "sờ" tới, bằng cách add thêm điều kiện where cho non_index_column.
* Nên dùng **count(*)** thay cho **sum(primary_key)**






