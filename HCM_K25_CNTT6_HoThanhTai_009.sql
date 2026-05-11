CREATE DATABASE hackathon;
USE hackathon;
-- câu 1
CREATE TABLE Passengers(
	passenger_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE Airlines(
	airline_id VARCHAR(5) PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Flights(
	flight_id VARCHAR(5) PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL UNIQUE,
    airline_id VARCHAR(5) NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    available_seats INT NOT NULL,
    
    CONSTRAINT FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);

CREATE TABLE Bookings(
	booking_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id VARCHAR(5) NOT NULL,
    flight_id VARCHAR(5) NOT NULL,
    status VARCHAR(20) CHECK (status IN('Booked','Boarded','Cancelled')) NOT NULL,
    booking_date DATE NOT NULL,
    
    CONSTRAINT FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    CONSTRAINT FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
-- câu 2
INSERT INTO Passengers VALUES
('P01','Trần Văn Bình','binh.tv@gamil.com','0981111111'),
('P02','Lê Thị Hoa','hoa.lt@gmail.com','0982222222'),
('P03','Nguyễn Trọng Tuấn','tuan.nt@gmail.com','0983333333'),
('P04','Hoàng Minh Châu','chau.hm@gmail.com','0984444444'),
('P05','Đinh Kiều Oanh','oanh.dk@gmail.com','0985555555');

INSERT INTO Airlines VALUES
('A01','Vietnam Airlines'),
('A02','VietJet Air'),
('A03','Bamboo Airways'),
('A04','Pacific Airlines');

INSERT INTO Flights VALUES 
('F01','HN-HCM','A01',2500000.00,50),
('F02','HN-DN','A01',1500000.00,30),
('F03','HCM-DN','A02',1200000.00,40),
('F04','HN-PQ','A03',3000000.00,20),
('F05','HCM-DL','A04',1000000.00,15);

INSERT INTO Bookings VALUES
(1,'P01','F01','Booked','2025-10-01'),
(2,'P02','F03','Boarded','2025-10-02'),
(3,'P01','F02','Boarded','2025-10-03'),
(4,'P04','F05','Cancelled','2025-10-04'),
(5,'P05','F01','Booked','2025-10-05');
-- 3)tăng available_seats thêm 10 ghế  ticket_price lên 5%
UPDATE Flights
SET available_seats = available_seats + 10, ticket_price = ticket_price * 1.05
WHERE route_name = 'HN_PQ';
-- 4) cập nhật số điện thoại khách có passenger_id là 'P03' thành '0999999999'
UPDATE Passengers
SET phone = '0999999999'
WHERE passenger_id = 'P03';
-- 5) xóa các bảng ghi đặt vé trong bảng Bookings có trạng thái là 'Cancelled' và được đặt trước ngày '2025-10-03'
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Bookings
WHERE status = 'Cancelled' AND booking_date < '2025-10-03';
SET SQL_SAFE_UPDATES = 1;
-- truy vấn dữ liệu cơ bản
-- 6) liệt kê các chuyến bay gồm flight_id,route_name,ticket_price có giá  từ 1200000 đến 2500000 và available_seats > 0
SELECT flight_id,route_name,ticket_price
FROM Flights
WHERE ticket_price BETWEEN 1200000 AND 2500000 AND available_seats > 0;
-- 7) lấy ttin full_name,email của những hành khách có họ là Trần
SELECT full_name,email
FROM Passengers 
WHERE full_name LIKE 'Trần%';
-- 8) hiển thị danh sách đặt vé gồm booking_id,passenger_id,booking_date sắp xếp theo Booking_date DESC(giảm dần)
SELECT booking_id,passenger_id,booking_date
FROM Bookings
WHERE status = 'Booked'
ORDER BY Booking_date DESC;
-- 9) lấy 3 chuyển bay có ticket_price đắt nhất trong hệ thống
SELECT flight_id,route_name,ticket_price
FROM Flights
ORDER BY ticket_price DESC
LIMIT 3;
-- 10) hiển thị danh sách route_name ,available_seats từ bảng Flights bỏ hai chuyến đầu tiên lấy hai chuyến tiếp theo 
SELECT route_name,available_seats
FROM Flights
LIMIT 2 OFFSET 2;
-- câu 11) 
SELECT b.booking_id,p.full_name,f.route_name,b.booking_date
FROM Bookings b
INNER JOIN Flights f ON b.flight_id = f.flight_id
INNER JOIN Passengers p ON p.passenger_id = b.passenger_id
WHERE status = 'Booked';
-- 12
SELECT a.airline_name, f.route_name
FROM Flights f
LEFT JOIN Airlines a ON f.airline_id = a.airline_id;
-- 13
SELECT status ,COUNT(status) AS 'total_booking'
FROM Bookings
GROUP BY status;
-- câu 14)
-- câu 16)
SELECT full_name,phone
FROM  Passengers
WHERE passenger_id IN (SELECT passenger_id 
FROM Bookings
WHERE flight_id = 'F01' AND status IN('Booked','Boarded')
);
-- câu 15)
SELECT f1.flight_id,f1.route_name,f1.ticket_price
FROM Flights f1
WHERE f1.ticket_price < (SELECT AVG (f.ticket_price) FROM Flights f1);





