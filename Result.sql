create database Online_store ;
go
use Online_store;

-- Bảng người dùng
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    name NVARCHAR(100) NOT NULL,
    birthday DATE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20) NOT NULL UNIQUE,
    gender NVARCHAR(10)
);

-- Bảng địa chỉ
CREATE TABLE address (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    address NVARCHAR(100) NOT NULL,
    road NVARCHAR(100) NOT NULL,
    commune NVARCHAR(100) NOT NULL,
    district NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    country NVARCHAR(100) DEFAULT N'Vietnam',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Bảng shop
CREATE TABLE shop (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    user_id INT NOT NULL,
    createAt DATETIME DEFAULT GETDATE(),
    address NVARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Bảng vai trò
CREATE TABLE role (
    id INT IDENTITY(1,1) PRIMARY KEY,
    authority NVARCHAR(20)
);

-- Bảng user_role
CREATE TABLE user_role (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES role(id),
    PRIMARY KEY(user_id, role_id)
);

-- Bảng thông báo
CREATE TABLE notification (
    id INT IDENTITY(1,1) PRIMARY KEY,
    content NVARCHAR(255) NOT NULL,
    createAt DATE NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Thêm dữ liệu vào bảng role
INSERT INTO role (authority) VALUES (N'Admin');
INSERT INTO role (authority) VALUES (N'Guest');
INSERT INTO role (authority) VALUES (N'Seller');

-- Bảng category
CREATE TABLE category (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES category(id) -- Self-referencing foreign key
);

-- Bảng product
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), -- Giá phải >= 0
    quantity INT DEFAULT 0 CHECK (quantity >= 0),     -- Số lượng >= 0
    category_id INT NOT NULL,
    createAt DATE,
    updateAt DATE,
    FOREIGN KEY (category_id) REFERENCES category(id)
);

-- Bảng gallery
CREATE TABLE gallery (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    href NVARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng comment
CREATE TABLE comment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5), -- Giới hạn đánh giá từ 1 đến 5
    content NVARCHAR(MAX),
    createAt DATE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Bảng variant
CREATE TABLE variant (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    type NVARCHAR(100),
    size NVARCHAR(100),
    color NVARCHAR(100),
    combo NVARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng cart
CREATE TABLE cart (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0), -- Số lượng > 0
    price DECIMAL(20,0) NOT NULL CHECK (price >= 0), -- Giá >= 0
    createAt DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng order
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    seller_id INT NOT NULL,
    orderDate DATETIME NOT NULL,
    totalAmount DECIMAL(20,0) NOT NULL CHECK (totalAmount >= 0), -- Tổng tiền >= 0
    shipping_address NVARCHAR(1000),
    order_status NVARCHAR(20) NOT NULL CHECK (order_status IN (N'Pending', N'Processing', N'Completed', N'Cancelled')),
    payment_method NVARCHAR(20) NOT NULL CHECK (payment_method IN (N'Credit card', N'ShopeePay', N'Cash On Delivery')),
    shipping_status NVARCHAR(20) NOT NULL CHECK (shipping_status IN (N'Pending', N'Shipped', N'In Transit', N'Delivered')),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (seller_id) REFERENCES shop(id)
);

-- Bảng order_items
CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    price DECIMAL(20,0) NOT NULL CHECK (price >= 0),
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng payment
CREATE TABLE payment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    payment_status NVARCHAR(20) NOT NULL CHECK (payment_status IN (N'Pending', N'Paid', N'Refunded')),
    payment_method NVARCHAR(20) NOT NULL CHECK (payment_method IN (N'Credit card', N'ShopeePay', N'Cash On Delivery')),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Bảng shipping
CREATE TABLE shipping (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_status NVARCHAR(20) NOT NULL CHECK (shipping_status IN (N'Pending', N'Shipped', N'In Transit', N'Delivered')),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);


-- Thêm dữ liệu cho bảng users
INSERT INTO users (username, name, birthday, email, phone, gender) 
VALUES 
(N'quangnt', N'Nguyễn Tiến Quang', '1990-05-15', N'quangnt@gmail.com', N'0901234567', N'Nam'),
(N'huonglt', N'Lê Thị Hương', '1992-08-22', N'huonglt@yahoo.com', N'0902233445', N'Nữ'),
(N'hungnv', N'Nguyễn Văn Hùng', '1985-12-01', N'hungnv@outlook.com', N'0987654321', N'Nam');

-- Thêm dữ liệu cho bảng address
INSERT INTO address (user_id, address, road, commune, district, city) 
VALUES 
(1, N'123 Lý Thái Tổ', N'Lý Thái Tổ', N'Phường 1', N'Quận 10', N'TP Hồ Chí Minh'),
(2, N'456 Phan Đình Phùng', N'Phan Đình Phùng', N'Phường 15', N'Quận Phú Nhuận', N'TP Hồ Chí Minh'),
(3, N'789 Trần Hưng Đạo', N'Trần Hưng Đạo', N'Phường 6', N'Quận 5', N'TP Hồ Chí Minh');

-- Thêm dữ liệu cho bảng shop
INSERT INTO shop (name, user_id, address)
VALUES 
(N'Cửa Hàng Quang', 1, N'123 Lý Thái Tổ, Quận 10, TP Hồ Chí Minh'),
(N'Shop Hương', 2, N'456 Phan Đình Phùng, Quận Phú Nhuận, TP Hồ Chí Minh'),
(N'Tạp Hóa Hùng', 3, N'789 Trần Hưng Đạo, Quận 5, TP Hồ Chí Minh');

-- Thêm dữ liệu cho bảng role
INSERT INTO role (authority) VALUES 
(N'Admin'),
(N'Guest'),
(N'Seller');

-- Thêm dữ liệu cho bảng user_role
INSERT INTO user_role (user_id, role_id) 
VALUES 
(1, 1), -- Quang là Admin
(2, 2), -- Hương là Guest
(3, 3); -- Hùng là Seller

-- Thêm dữ liệu cho bảng category
INSERT INTO category (name, parent_id) 
VALUES 
(N'Điện Thoại', NULL), 
(N'Thời Trang', NULL), 
(N'Thời Trang Nam', 2), 
(N'Thời Trang Nữ', 2);

-- Thêm dữ liệu cho bảng products
INSERT INTO products (name, description, price, quantity, category_id, createAt) 
VALUES 
(N'Iphone 14', N'Diện thoại thông minh Apple iPhone 14', 20000000, 10, 1, GETDATE()),
(N'Áo Sơ Mi Nam', N'Áo sơ mi trắng tay dài cho nam', 350000, 50, 3, GETDATE()),
(N'Váy Đầm Nữ', N'Váy đầm xòe cho nữ', 500000, 30, 4, GETDATE());

-- Thêm dữ liệu cho bảng gallery
INSERT INTO gallery (product_id, href) 
VALUES 
(1, N'/images/iphone14.jpg'),
(2, N'/images/aosominam.jpg'),
(3, N'/images/vaydannu.jpg');

-- Thêm dữ liệu cho bảng comment
INSERT INTO comment (product_id, user_id, rating, content, createAt) 
VALUES 
(1, 1, 5, N'Điện thoại rất tốt, đáng mua!', GETDATE()),
(2, 2, 4, N'Áo sơ mi đẹp nhưng hơi đắt', GETDATE()),
(3, 3, 5, N'Váy đẹp, chất lượng tuyệt vời', GETDATE());

-- Thêm dữ liệu cho bảng variant
INSERT INTO variant (product_id, type, size, color, combo) 
VALUES 
(1, N'Loại Pro', N'128GB', N'Xanh Dương', N'Kèm tai nghe'),
(2, N'Áo', N'L', N'Tráng', NULL),
(3, N'Váy', N'M', N'Hồng', N'Kèm dây lưng');

-- Thêm dữ liệu cho bảng cart
INSERT INTO cart (user_id, product_id, quantity, price, createAt) 
VALUES 
(1, 1, 1, 20000000, GETDATE()),
(2, 2, 2, 700000, GETDATE()),
(3, 3, 1, 500000, GETDATE());

-- Thêm dữ liệu cho bảng orders
INSERT INTO orders (user_id, seller_id, orderDate, totalAmount, shipping_address, order_status, payment_method, shipping_status) 
VALUES 
(1, 1, GETDATE(), 20000000, N'123 Lý Thái Tổ, Quận 10, TP Hồ Chí Minh', N'Pending', N'ShopeePay', N'Pending'),
(2, 2, GETDATE(), 700000, N'456 Phan Đình Phùng, Quận Phú Nhuận, TP Hồ Chí Minh', N'Completed', N'Cash On Delivery', N'Delivered'),
(3, 3, GETDATE(), 500000, N'789 Trần Hưng Đạo, Quận 5, TP Hồ Chí Minh', N'Processing', N'Credit card', N'In Transit');

-- Thêm dữ liệu cho bảng order_items
INSERT INTO order_items (order_id, product_id, price, quantity) 
VALUES 
(1, 1, 20000000, 1),
(2, 2, 350000, 2),
(3, 3, 500000, 1);

-- Thêm dữ liệu cho bảng payment
INSERT INTO payment (user_id, order_id, payment_status, payment_method) 
VALUES 
(1, 1, N'Pending', N'ShopeePay'),
(2, 2, N'Paid', N'Cash On Delivery'),
(3, 3, N'Paid', N'Credit card');

-- Thêm dữ liệu cho bảng shipping
INSERT INTO shipping (order_id, shipping_status) 
VALUES 
(1, N'Pending'),
(2, N'Delivered'),
(3, N'In Transit');


--XEM NOI DUNG CAC BANG
SELECT * FROM users;
SELECT * FROM address;
SELECT * FROM shop;
SELECT * FROM role;
SELECT * FROM user_role;
SELECT * FROM notification;
SELECT * FROM category;
SELECT * FROM products;
SELECT * FROM gallery;
SELECT * FROM comment;
SELECT * FROM variant;
SELECT * FROM cart;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payment;
SELECT * FROM shipping;

