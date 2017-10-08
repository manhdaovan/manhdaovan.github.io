---
layout: post
title: Kỹ thuật sửa lỗi Reed - Solomon
date: 2017-09-24 00:00:00
summary: Tìm hiểu kỹ thuật sửa lỗi Reed - Solomon thông qua ví dụ, với sự tham gia của Ưng Hoàng Phúc, Ngọc Trinh :v
categories: math basic
---

Đây là bài viết thuộc chủ đề nghiên cứu của nhóm ruby [hardcore](https://github.com/ruby-vietnam/hardcore-rule)

---

### Background
Là người  dùng cuối, chúng ta đã quá quen thuộc với việc click vào nút download A,
quét một mã vạch B hay mua một cái đĩa CD C, thì chúng ta đều nhận được một kết quả thích hợp và đầy đủ dữ liệu.
Hầu như tải về là cài đặt được, quét mã qr là hiện ra thông tin được, mua đĩa CD về là nghe được, vân vân...
Nhưng hậu trường đằng sau của những sự tưởng như bình thường đó không hề bình thường chút nào, vì mọi thứ trên đời đều có khả năng phát sinh lỗi.
Và làm sao có thể hạn chế tối đã những lỗi này, thậm chí ưu việt hơn là phát hiện ra lỗi và tự sửa nó, là một vấn đề rất khó.

Reed-solomon là một kỹ thuật trong [rất nhiều kỹ thuật](https://en.wikipedia.org/wiki/Forward_error_correction#List_of_error-correcting_codes) nhằm đảm bảo toàn vẹn dữ liệu.
Nó cho phép phát hiện và sửa lỗi, được ứng dụng rất rộng rãi, từ những sản phẩm rất bình dân mà bạn thấy hằng ngày như đĩa CD, DVD,
cao cấp hơn tí có mã QR, hay các công nghệ phức tạp như DSL, WiMAX, RAID 6, thậm chí cả [công nghệ vũ trụ](http://antoanthongtin.vn/Detail.aspx?NewsID=05a52da7-ee6a-4578-8792-1d3b471c18f9&CatID=43b7448c-0f7e-4558-a39f-1d209751aad2)...

Tưởng tượng một chút là ta mua cái đĩa về, mở lên thấy Ưng Hoàng Phúc hát mà thỉnh thoảng lại thấy giọng của Ngọc Trinh thì hay nhỉ :D

### Tư tưởng chung

Cứ tưởng tượng thế này cho dễ. Trong 1 đoàn quân gửi đi đánh nhau, rất có thể có những người lính biến chất dọc đường.
Làm sao để phát hiện và khôi phục lòng trung thành của những người lính này, thì bạn phải cài cắm người mà bạn tin vào trong đoàn quân đó,
để chúng giám sát và báo lại cho bạn nếu có việc trên.
Xịn hơn nữa, người được cài cắm có thể tự động khuyên nhủ mấy anh lính hư kia, đưa đoàn quân trở lại sự trung thành nhất, ko còn tạp chất.

Tư tưởng của kỹ thuật Reed-Solomon cũng vậy. Khi bạn gửi một số bit trên đường truyền (=gửi quân đi đánh),
rất có thể có những bit bị sai lệch vì nhiễu trên kênh truyền (=lính biến chất),
bạn sẽ phải đưa thêm những bit giám sát (=cài cắm người mà bạn tin) vào số bit trên, và truyền tải đi.

Chi tiết sẽ được trình bày phía dưới.

### Các khái niệm kỹ thuật






...
1. Tư tưởng chung
2. ‎Các khái niệm cụ thể
3. ‎Áp dụng vào ví dụ
4. Mở rộng
5. ‎Một vài suy nghĩ cá nhân





