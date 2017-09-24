---
layout: post
title: Tổ hợp, chỉnh hợp và bài toán đếm cơ bản
date: 2017-03-22 00:00
summary: Một số bài toán về chỉnh hợp, tổ hợp cơ bản đã học hồi cấp 3 và áp dụng vào bài toán đếm
categories: math combination accordant
---

#math #combination #accordant #vi

### Background

Bạn có nhớ gì về hồi cấp 3 ko? Ý mình ko phải là hình ảnh em gái xinh nhất khối mặc áo trong và ngoài có mã màu lần lượt là #000 và #fff đi trong mưa, mà là ít kiến thức về tổ hợp, chỉnh hợp hồi lớp 12 cơ.

Nếu vững kiến thức này, gần thì bạn sẽ rất nhẹ nhàng làm những bài test nhỏ kiểu như trên codility, paiza. Xa thì có thể ăn chắc 1 trong vài bài test khi đi xin việc :v

### Tổ hợp và chỉnh hợp

* Tổ hợp: là cách chọn ra K phần tử từ N phần tử (1 <= K <= N), không quan tâm đến thứ tự. Ví dụ, "Các thầy hãy chọn cho tôi 10 giáo viên nữ để đi tiếp khách". Lúc này thì cứ chọn đủ 10 giáo viên là được, ko quan tâm ai trước ai sau, thì là 1 dạng của tổ hợp.
* Chỉnh hợp: Tương tự như trên, khác là có quan tâm đến thứ tự. Ví dụ, "Các thầy hãy chọn cho tôi 3 giáo viên để đảm nhiệm các vị trí Phó hiệu trưởng, Bí thư nhà trường và Cán bộ công đoàn". Lúc này ai vào vị trí nào thì đều có thứ tự rồi, và chỉ cần đổi thứ tự là sẽ có case khác nhau.
* Vậy, dễ dàng thấy rằng, **Số Chỉnh hợp** luôn nhiều hơn **Số Tổ hợp**
* Công thức **Số Chỉnh hợp** = $$\frac{N!}{\left( N-K \right)!}$$
* Công thức **Số Tổ hợp** = **Số Chỉnh hợp** / K! = $$\frac{N!}{\left( N-K \right)!K!}$$
* Tại sao? Các bạn không cần nhớ lại làm gì, mình sẽ trình bày luôn phía dưới. :v

### Số Chỉnh hợp = $$\frac{N!}{\left( N-K \right)!}$$

Quay lại bài toán chọn 10 giáo viên trong số 30 giáo viên để đi tiếp khách. Như vậy, N = 30 và K = 10. Cụ thể:

* Giáo viên thứ nhất có 30 cách chọn.
* Giáo viên thứ hai có 29 cách chọn.
* Giáo viên thứ ba có 28 cách chọn.
* ....
* Giáo viên thứ 10 có 21 cách chọn.

Số cách chọn là: `30 * 29 * ... * 21` .<br/>
Tổng quát thành: `N * (N-1) * ... * (N - K + 1)`.<br/>
Vậy **số chỉnh hợp** = `N * (N-1) * ... * (N - K + 1)`.

Nhân cả 2 vế với với một lượng `(N - K) * (N - K -1) * ... * 2 * 1`, hay chính là `(N - K)!`, thu được:

**số chỉnh hợp** * `(N - K)!` = `N * (N-1) * ... * (N - K + 1) * (N - K) * (N - K -1) * ... * 2 * 1`.

Mà vế phải chính là N!, nên chia cả 2 vế cho `(N - K)!`, thu:

**Số Chỉnh hợp** = $$\frac{N!}{\left( N-K \right)!}$$ (ĐPCM)

### Số Tổ hợp = Số Chỉnh hợp / K! = $$\frac{N!}{\left( N-K \right)!K!}$$

Nhớ lại là **tổ hợp** thì ko quan tâm đến thứ tự. Nghĩa là với bộ 3 số {1, 2, 3} thì ta có **số chỉnh hợp** là 3! / (3-3)! = 6 (quy ước 0! = 1)

Nhưng **số tổ hợp** thì chỉ là 1 mà thôi, vì ko quan tâm tới thứ tự mà, nên cho dù có bao nhiêu cách sắp xếp khác nhau thì cũng chỉ là một tổ hợp mà thôi.

Tổng quát lên, **số tổ hợp = số chỉnh hợp / số cách sắp xếp khác nhau của K phần tử**.

Mà **số cách sắp xếp khác nhau của K phần tử** chính bằng **số hoán vị của K**, hay K!, nên:

**Số Tổ hợp** = **Số Chỉnh hợp** / K!.

Thay Số Chỉnh hợp = $$\frac{N!}{\left( N-K \right)!}$$ thu:

Số Tổ hợp = $$\frac{N!}{\left( N-K \right)!K!}$$ (ĐPCM)

### Áp dụng cho bài toán đếm số tương tự

* Một số được cho là tương tự số ban đầu nếu số đó được tạo bởi các chữ số giống với các chữ số của số đã cho và ko xét nếu 0 ở đầu. Ví dụ 113 có 3 số tương tự là 113, 131, 311. Nhưng 100 chỉ có 1 số tương tự là 100 thôi, vì nếu 001 hay 010 thì ko hợp lệ.
* Vậy có cách nào tổng quát để tính số lượng số tương tự của 1 số cho trước không?
* Trước hết hãy cùng xem xét một bài toán có tên [Bookkeeper Rule](http://web.mit.edu/neboat/Public/6.042/counting3.pdf) dưới đây.

#### [Bookkeeper Rule](http://web.mit.edu/neboat/Public/6.042/counting3.pdf)

Là công thức tính số cách sắp xếp các chữ cái trong từ `bookkeeper` theo các cách khác nhau. Ví dụ ta sẽ có `bokokeeper`, `bkookeeper` ...

Công thức được viết thành:<br/>
Số cách xếp = $$\frac{10!}{1!2!2!3!1!1!}$$ = 302400 cách xếp.

Các con số trên lấy ở đâu ra?
* 10 = độ dài của xâu bookkeeper
* 1, 2, 2, 3, 1, 1 lần lượt là số lần xuất hiện của `b, o, k, e, p, r` trong xâu `bookkeeper`.

Như vậy, nếu áp dụng Bookkeeper rule cho bài toán số tương tự, ta phải xét thêm trường hợp số 0 đứng đầu.
Do **cứ có số 0 đứng đầu thì số tạo thành là ko hợp lệ**, nên **mọi cách sắp xếp của các chữ số còn lại trong trường hợp có số 0 ở đầu là không hợp lệ**.

Vậy đơn giản là chỉ cần lấy **tổng các số tương tự** trừ đi **tổng số cách mà có 0 đứng đầu** là sẽ thu được kết quả đúng.

Và cũng có thể áp dụng Bookkeeper rule cho **các chữ số còn lại trong trường hợp có số 0 ở đầu** để thu được số các số mà bắt đầu bằng 0.

Vậy có thể viết thành công thức tổng quát như sau:

```
numbers_start_with_0 = if(original_number.contains(0)) bookkeeper(original_number.remove_one(0)) else 0
simillar_numbers = bookkeeper(original_number) - numbers_start_with_0
```

Mình có viết một đoạn code bằng Ruby minh hoạ cho công thức trên như sau:

```
# Calculate number of Similar Numbers
# 112 has 112, 121, 211 (3 similar numbers)
# 100 has 100 (1 similar number)
# Given integer a (1 <= a <= 2^32)
# Calculate number of similar numbers of a

def permute(n)
  return 1 if n == 0
  (1..n).reduce(:*)
end

# BookKeeper Rule
# http://web.mit.edu/neboat/Public/6.042/counting3.pdf
#
# group_digits has format:
# {digit1 => number_digits1, digit2 => number_digits2}
def bookkeeper(group_digits)
  number_digits       = 0
  denominator_permute = 1
  group_digits.each do |_, n_digits|
    number_digits       += n_digits
    denominator_permute *= permute(n_digits)
  end
  permute(number_digits) / denominator_permute
end

def solution(a)
  digits       = a.to_s.split('')
  group_digits = Hash.new(0).tap { |h| digits.each { |d| h[d.to_i] += 1 } }
  total_cases  = bookkeeper(group_digits)

  # Remove all similar numbers that start with 0
  # Means: If similar number start with 0,
  # all other similar numbers that is created by other digits will be invalid
  unless group_digits[0] == 0
    group_digits[0] = group_digits[0] - 1
    total_cases     -= bookkeeper(group_digits)
  end

  total_cases
end
```

Make #cấp3 great again!


