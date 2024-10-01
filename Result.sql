create database shopee;
use shopee;
drop database shopee

-- init table for user 
-- thông tin user bao gồm user , address , role , address

-- Bảng người dùng
CREATE TABLE [user] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    name NVARCHAR(100) NOT NULL,
    birthday DATE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20) NOT NULL UNIQUE,
    gender NVARCHAR(10)
);

-- Bảng địa chỉ 
create table address(
	id int primary key identity(1,1),
	user_id int,
	address nvarchar(100) not null,
	road nvarchar(100) not null,
	commune nvarchar(100) not null,
	district nvarchar(100) not null,
	city nvarchar(100) not null,
    country nvarchar(100) default 'Vietnam',  
	foreign key (user_id) references [user](id), --khoa ngoai link toi nguoi_dung
);

--Bảng Shop
CREATE TABLE shop (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    user_id INT,
    createAt DATETIME DEFAULT GETDATE(),
    address NVARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES [user](id)
);


--.Bảng vai trò 
create table role(
	id int primary key identity(1,1),
	authority nvarchar(20),
)

create table user_role(
	user_id int,
	role_id int,
	foreign key(user_id) references [user](id),
	foreign key (role_id) references role(id),
	primary key(user_id,role_id),
)

--.Bảng thông báo
create table notification (
    id INT PRIMARY KEY,  -- Khóa chính, cũng là khóa ngoại
    content NVARCHAR(255) NOT NULL,  -- Nội dung thông báo
    createAt DATE NOT NULL,  -- Ngày thông báo
	user_id int,
    FOREIGN KEY (user_id) REFERENCES [user](id)  -- Khóa ngoại liên kết với nguoi_dung
);

-- Thêm dữ liệu vào bảng vai_tro
INSERT INTO role (authority) VALUES (N'Admin');
INSERT INTO role (authority) VALUES (N'Guest');
INSERT INTO role (authority) VALUES (N'Seller');

-- Thêm dữ liệu vào bảng người dùng
INSERT INTO [user] (username, name, birthday, email, phone, gender)
VALUES 
(N'user1', N'Nguyen Van A', '1990-01-01', N'user1@example.com', N'0123456789', N'Nam'),
(N'user2', N'Le Thi B', '1985-05-15', N'user2@example.com', N'0987654321', N'Nữ'),
(N'user3', N'Tran Van C', '2000-07-20', N'user3@example.com', N'0112233445', N'Nam');

-- thêm dữ liệu vào bảng shop
INSERT INTO shop (name, user_id, createAt, address)
VALUES 
(N'Harkonen', 2, '2019-09-16', N'456 Hoang Hoa Tham,Ha Noi'),
(N'Atreides', 3, '2020-10-03', N'789 Le Duan, Hai Phong');

-- Thêm dữ liệu vào bảng thông báo
INSERT INTO notification (id , user_id, content, createAt)
VALUES
(1, 1, N'Chào mừng bạn đến với hệ thống!', '2024-09-14'),
(2, 2, N'Đã có cập nhật mới trên hệ thống.', '2024-09-15'),
(3, 3, N'Vui lòng kiểm tra email để xác nhận.', '2024-09-16');

-- Thêm dữ liệu vào bảng địa chỉ
INSERT INTO address (user_id, address, road, commune, district, city)
VALUES
(1, N'123 Pham Hung', N'Pham Hung', N'Commune 1', N'District 1', N'Hanoi'),
(2, N'456 Hoang Hoa Tham', N'Hoang Hoa Tham', N'Commune 2', N'District 2', N'Hanoi'),
(3, N'789 Le Duan', N'Le Duan', N'Commune 3', N'District 3', N'Hai Phong');

-- Thêm dữ liệu vào bảng vai_tro_nguoi_dung
INSERT INTO user_role (user_id, role_id)
VALUES
(1, 1),  -- user1 là Admin
(1, 2),  -- user1 cũng là Guest
(2, 2),  -- user2 là Guest
(2, 3),  -- user2 cũng là Seller
(3, 3);  -- user3 là Seller

-- init table for product 
-- thông tin product bao gồm category , product , product_gallery , comment

CREATE TABLE category (
    id INT constraint khoa2 primary key,
    name NVARCHAR(50) NOT NULL,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES category(id)
);

INSERT INTO category (id ,name, parent_id)
VALUES 
(1, N'Thời Trang', NULL),
(2, N'Điện tử', NULL),
(3, N'Sách', NULL),
(4, N'Phụ Kiện', 1),
(5, N'Tiện Ích', 2);

CREATE TABLE product (
    id INT constraint khoa3 primary key,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    quantity INT DEFAULT 0,
    category_id INT,
    createAt DATE,
    updateAt DATE,
    FOREIGN KEY (category_id) REFERENCES category(id)
)

CREATE TABLE gallery (
    id INT constraint khoa4 primary key,
    product_id INT,
    href NVARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE comment (
    id INT constraint khoa5 primary key,
    product_id INT,
    user_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    content NVARCHAR(MAX),
    createAt DATE,
    FOREIGN KEY (user_id) REFERENCES product(id),
    FOREIGN KEY (user_id) REFERENCES [user](id)
);

CREATE TABLE variant(
	id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT,
	type NVARCHAR(100),
	size NVARCHAR(100),
	color NVARCHAR(100),
	combo NVARCHAR(100),
	FOREIGN KEY (product_id) REFERENCES product(id)
);

INSERT INTO product (id, name, description, price, quantity, category_id, createAt, updateAt)
VALUES 
(1,  N'Áo Thun Nam', N'Áo thun chất liệu cotton', 199000, 50, 1, '2024-09-12', '2024-09-12'),
(2,  N'Laptop Dell', N'Laptop cấu hình cao', 20000000, 20, 2, '2024-09-12', '2024-09-12'),
(3,  N'Sách Lập Trình', N'Sách hướng dẫn dạy lập trình', 150000, 100, 3, '2024-09-12', '2024-09-12');

INSERT INTO variant(product_id,type,size,color,combo)
VALUES (1, N'Áo thun', N'L', N'Đỏ', N'Combo 1'),
       (2, N'Quần jeans', N'M', N'Xanh', N'Combo 2'),
       (3, N'Áo khoác', N'XL', N'Đen', N'Combo 3') 

INSERT INTO gallery (id, product_id, href)
VALUES 
(1, 1, N'https://example.com/ao-thun.jpg'),
(2, 2, N'https://example.com/laptop.jpg'),
(3, 3, N'https://example.com/sach.jpg');

INSERT INTO comment (id, product_id, user_id, rating, content, createAt)
VALUES 
(1, 1, 1, 5, N'Sản phẩm rất tốt', '2024-09-12'),
(2, 2, 2, 4, N'Laptop dùng ổn', '2024-09-12'),
(3, 3, 3, 3, N'Sách hay nhưng nội dung khó hiểu', '2024-09-12');

-- init table for cart + payment
-- thông tin product bao gồm 

/*
Users: Lưu trữ thông tin người dùng.

Sellers: Lưu trữ thông tin người bán.
Categories: Phân loại, mô tả các sản phẩm trên sàn.
Products: Lưu trữ thông tin về sản phẩm.
Cart: Lưu thông tin về giỏ hàng, sản phẩm trong giỏ hàng của từng người dùng.
Orders: Lưu trữ thông tin đơn hàng, thanh toán khi người dùng thực hiện thanh toán.
OrderItems: Lưu chi tiết sản phẩm trong từng đơn hàng.
Payments: Lưu trữ thông tin về các khoản thanh toán của người dùng.
OrderShippingUpdates: lưu chi tiết về từng cập nhật trạng thái vận chuyển.
	
PaymentMethod: các phương thức thanh toán.
PaymentStatus: các trạng thái thanh toán.
OrderStatus: các trạng thái của đơn hàng.
OrderShippingStatus: các trạng thái vận chuyển của đơn hàng.

*/

create table cart (
	id int primary key,
	user_id int not null REFERENCES [user](id),
	product_id int not null foreign key references product(id),
	price decimal(20,0) not null,                               -- Giá của sản phẩm
	createAt DATETIME not null,                                -- Ngày sản phẩm được thêm vào giỏ
);

-- Thêm dữ liệu vào bảng cart
INSERT INTO cart (id, user_id, product_id, price, createAt)
VALUES 
(1, 1, 1, 199000, GETDATE()),  
(2, 2, 2, 20000000, GETDATE()),
(3, 3, 3, 150000, GETDATE());  


create table [order] (
    id int primary key,
    cart_id int not null foreign key references cart(id),
    createAt DATETIME not null,
    totalAmount decimal(20,0) not null,
    shipping_address nvarchar(1000),
    order_status varchar(20) not null check (order_status in ('Pending','Processing','Completed','Cancelled')) , 
    payment_method varchar(20) not null check (payment_method in ('Credit card','ShopeePay','Cash On Delivery')) , 
    shipping_status varchar(20) not null check (shipping_status in ('Pending','Shipped','In Transit','Out For Delivery','Cancelled','Delivered','Returned')) 
);

-- Thêm dữ liệu vào bảng order
INSERT INTO [order] (id, cart_id, createAt, totalAmount, shipping_address, order_status, payment_method, shipping_status)
VALUES 
(1, 1, GETDATE(), 199000, N'456 Hoang Hoa Tham, Hanoi', 'Pending', 'Credit card', 'Pending'),  
(2, 2, GETDATE(), 20000000, N'789 Le Duan, Hai Phong', 'Processing', 'ShopeePay', 'Shipped'),   
(3, 3, GETDATE(), 150000, N'123 Pham Hung, Hanoi', 'Completed', 'Cash On Delivery', 'Delivered'); 


/*     SHIPPINGSTATUS:
       1. Pending -- đang chờ xác nhận
       2. Shipped -- đã được gửi đi
       3. In Transit -- đang trên đường vận chuyển
       4. Out for Delivery -- đang trên đường giao đến bạn, chú ý điện thoại
       5. Delivered -- đã được giao
       6. Returned -- đơn hàng đã được trả lại từ khách hàng
       7. Cancelled -- đơn hàng đã bị hủy bỏ trước khi hoàn tất việc vận chuyển
	   =========================================================================
	   ORDERSTATUS:
	   1. Pending -- Đơn hàng đang được xử lý (có thể là lúc chờ shop xác nhận đơn).
	   2. Processing -- Đơn hàng đang trong quá trình vận chuyển.
	   3. Completed -- Đơn hàng đã đến tay người nhận.
	   4. Cancelled -- Đơn hàng bị hủy (thanh toán xong bị hủy, chưa hoàn tất thanh toán -> hủy, đã nhận hàng nhưng hủy)
*/

create table payment (
    id int primary key,
    order_id int not null foreign key references [order](id),
    payment_date DATETIME Null,
    payment_amount decimal(20,0) not null,
    payment_method varchar(20) not null check (payment_method in ('Credit card','ShopeePay','Cash On Delivery')), 
	payment_status varchar(20) not null check (payment_status in ('Pending','Completed','Refunded','Cancelled')) 
);

/*
	PaymentStatus:
	1. Pending: khách chưa thanh toán (do chọn phương thức COD) hoặc trạng thái chờ shop xác nhận hoàn lại tiền do hủy đơn .
	2. Completed: Đã hoàn tất việc thanh toán.
	3. Refunded: Thanh toán rồi nhưng hủy đơn -> khách được hoàn lại tiền.
	4. Cancel: Khách hủy đơn trước khi thanh toán COD. 
*/

-- Thêm dữ liệu vào bảng payment
INSERT INTO payment (id, order_id, payment_date, payment_amount, payment_method, payment_status)
VALUES 
(1, 1, GETDATE(), 199000, 'Credit card', 'Completed'),    
(2, 2, GETDATE(), 20000000, 'ShopeePay', 'Pending'),       
(3, 3, GETDATE(), 150000, 'Cash On Delivery', 'Cancelled'); 


create table shipping (
    id int primary key,
    order_id int not null foreign key references [order](id),
    shipping_status varchar(20) not null check (shipping_status in ('Pending','Shipped','In Transit','Out For Delivery','Cancelled','Delivered','Returned')), 
    updateAt DATETIME,
    content nvarchar(1000)
);

-- Thêm dữ liệu vào bảng shipping
INSERT INTO shipping (id, order_id, shipping_status, updateAt, content)
VALUES 
(1, 1, 'Pending', GETDATE(), N'Chờ xác nhận giao hàng'), 
(2, 2, 'Shipped', GETDATE(), N'Đã được gửi đi'),          
(3, 3, 'Delivered', GETDATE(), N'Đã giao thành công');    


/*
 PaymentStatus:
	   1. Pending: khách chưa thanh toán (do chọn phương thức COD) hoặc trạng thái chờ shop xác nhận hoàn lại tiền do hủy đơn .
	   2. Completed: Đã hoàn tất việc thanh toán.
	   3. Refunded: Thanh toán rồi nhưng hủy đơn -> khách được hoàn lại tiền.
	   4. Cancel: Khách hủy đơn trước khi thanh toán COD. 
	   =========================================================================
 SHIPPINGSTATUS:
       1. Pending -- đang chờ xác nhận
       2. Shipped -- đã được gửi đi
       3. In Transit -- đang trên đường vận chuyển
       4. Out for Delivery -- đang trên đường giao đến bạn, chú ý điện thoại
       5. Delivered -- đã được giao
       6. Returned -- đơn hàng đã được trả lại từ khách hàng
       7. Cancelled -- đơn hàng đã bị hủy bỏ trước khi hoàn tất việc vận chuyển
	   =========================================================================
ORDERSTATUS:
	   1. Pending -- Đơn hàng đang được xử lý (có thể là lúc chờ shop xác nhận đơn).
	   2. Processing -- Đơn hàng đang trong quá trình vận chuyển.
	   3. Completed -- Đơn hàng đã đến tay người nhận.
	   4. Cancelled -- Đơn hàng bị hủy (thanh toán xong bị hủy, chưa hoàn tất thanh toán -> hủy, đã nhận hàng nhưng hủy)
	   =========================================================================
PAYMENTMETHODS:
	   Credit card, ShopeePay, Cash On Delivery
*/

/*
1. thanh toán qua shopeepay đang chờ phía shop xác nhận đơn và vận chuyển
2. thanh toán qua thẻ và shop đã bàn giao cho vận chuyển, đang trên đường vận chuyển
3. ...............shopeepay, tình trạng đơn là đã hoàn thành, tình trạng vận chuyển là đã được giao thành công
4. ............... thanh toán khi nhận hàng ..............................................
5. ................ tình trạng đơn là đã bị hủy sau khi thanh toán bằng shopeepay, tình trạng vận chuyển là đã hủy, phần payment là refunded (shop hoàn lại $)
*/


select * from address;
select * from cart;
select * from category;
select * from comment;
select * from gallery;
select * from notification;
select * from [order];
select * from payment;
select * from product;
select * from role;
select * from shipping;
select * from shop;
select * from [user];
select * from user_role;
select * from variant;