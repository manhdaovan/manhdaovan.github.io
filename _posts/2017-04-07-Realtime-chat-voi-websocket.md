---
layout: post
title: Xây dựng ứng dụng chat sử dụng websocket có khó không?
date: 2017-04-07 00:00:00
summary: A-to-Z Xây dựng ứng dụng realtime chat sử dụng action cable rails 5
categories: realtime chatting rails actioncable
---

#tech #realtime #chatting #rails #actioncable #vi

Cảnh báo: Mục đích của bài viết hơi bị lườm rau gắp thịt với tiêu đề.

### Background

* Bạn là người chưa nổi tiếng tới mức có trên trên wikipedia, nhưng vẫn là idol trong một group nào đó, như [Ruby Vietnam](http://ruby.org.vn/) chẳng hạn, và nhận được hàng tá câu hỏi của newbie. Bạn rất muốn trả lời, nhưng lại không muốn share FB/email account?
* Bạn mới gặp một em gái kute dễ thương, muốn nói chuyện lắm mà lại sợ em ấy bắt gặp mình đi công tác ở Trần D** H**g, nên ko dám cho số điện thoại?
* Bạn đơn giản chỉ muốn sau cuộc nói chuyện thì mọi thứ liên quan đến cuộc nói chuyện đó đều về với mây?

[Anychat](https://anychat.4me.tips/) chính là dành cho bạn.

### Một số tính năng đặc sắc

* Do là tính năng chat ẩn danh, nên người khác không thể thấy bất cứ thông tin gì về profile của bạn, ngoại trừ **username**
* Vì thế, thay vì đọc cái nick **trAiX0mnGHeO** cho cô bạn gái mới quen chép lại, thì chỉ việc vào mục **Profile > Settings** rồi chìa cái QR code ra cho cô em quét cái bíp là xong.
* Thế khi offline mà có người khác nhắn tới thì có biết không? **Có** và **Không**. Có là khi ở **Profile > Settings** bạn nhập email của mình vào, và đồng ý nhận tin nhắn khi offline, thì chỉ và chỉ một tin nhắn đầu tiên của người khác sẽ được gửi tới email này. Tất nhiên **Không** cho trường hợp còn lại. Và email này chỉ có mình bạn mới thấy thôi, ngoài ra không ai có thể xem được cả.
* Nhắc lại một tiêu chí ở background là: Khi bạn thoát, hoặc tắt trình duyệt đi, thì mọi thứ liên quan đến cuộc nói chuyện đều bị xoá hết, bảo đảm chỉ có mình bạn và đối tác biết mà thôi.

### Stack sử dụng và các thông tin liên quan

* **Nginx**: Vai trò làm reverse proxy, forward request cho Puma bên dưới.
* **Puma**: Làm application server, hứng request nhận được từ nginx đưa vào app xử lý, trả kết quả về cho nginx.
* **Rails 5.0.2 with ActionCable**: Con tim của ứng dụng :v. ActionCable là module nơi có build-in websocket sẽ được sử dụng cho chức năng realtime chat. Mọi chức năng khác như login, check online/offline, gửi tin nhắn đầu tiên khi offline... do Rails app đảm nhiệm.
* **Redis**: Do websocket không có session, nên muốn dùng chung với cái gì đó với app thì phải đi qua storage thứ 3. Mình chọn redis một phần cũng vì default stack của ActionCable có dùng redis nữa.
* **MySQL**: Chỉ dùng để lưu username/password (hashed). Nếu bạn muốn tự cài đặt thành server của mình, và lượng user không lớn, thì nên dùng sqlite thay thế, đỡ tốn resource để chạy MySQL service.

### Kết luận

Đến giờ thì mới là câu trả lời cho câu hỏi ở tiêu đề. Theo mình là dễ và khó :v

* Dễ vì nếu chỉ làm theo tutorial và một service có chức năng đơn giản thì dễ.
* Khó là khi kể cả chưa nhắc tới quy mô, thì việc tích hợp với một số tính năng bên lề xoay quanh user đang tương tác là khó. Vì websocket ko có session, nên mọi thông tin nhặt được từ client bằng cookie mà thôi. Vì vậy mà việc expired session sẽ có khó khăn hơn khi không có tích hợp websocket vào cùng.

[manhdv@anychat](https://anychat.4me.tips/rooms/manhdv)

Sourcecode của [Anychat](https://anychat.4me.tips/) được public trên [Github](https://github.com/manhdaovan/anychat)

***All pull requests, issues, stars are welcome!***