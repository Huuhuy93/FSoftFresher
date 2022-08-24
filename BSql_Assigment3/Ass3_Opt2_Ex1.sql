CREATE DATABASE Ass3_Opt2
go
USE Ass3_Opt2
go

CREATE TABLE SANPHAM (
	MaSP char(10) not null unique,
	TenSP nvarchar(30) not null,
	DonGia float not null,
	CONSTRAINT pk_SanPham PRIMARY KEY(MaSP),
)
go

CREATE TABLE KHACHHANG (
	MaKH char(10) not null unique,
	TenKH nvarchar(30) not null,
	PhoneNo char(12),
	GhiChu varchar(100),
	CONSTRAINT pk_KhachHang PRIMARY KEY(MaKH),
)
go

CREATE TABLE DONHANG (
	MaDH char(10) not null unique,
	NgayDH date not null,
	SoLuong int not null,
	MaSP char(10) not null,
	MaKH char(10) not null,
	CONSTRAINT pk_DonHang PRIMARY KEY(MaDH),
	CONSTRAINT fk_SanPham FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP),
	CONSTRAINT fk_KhachHang FOREIGN KEY(MaKH) REFERENCES KHACHHANG(MaKH)
)
go

INSERT INTO SANPHAM VALUES ('SP01', 'May say', 150000), ('SP02', 'Usb', 120000), ('SP03', 'Sac du phong', 100000), ('SP04', 'Tai nghe', 300000)

INSERT INTO KHACHHANG VALUES ('KH01', 'Nguyen Van A', '0902323222', 'Khach VIP'), ('KH02', 'Le Van B', '0902321322', 'Khach Tiem Nang'),
							 ('KH03', 'Tran Thi Thao', '0983526652', 'Khach VIP')

INSERT INTO DONHANG VALUES ('DH01', '2021/11/10', 2, 'SP02', 'KH01'), ('DH02', '2020/10/20', 3, 'SP03', 'KH02'), ('DH03', '2021/07/21', 5, 'SP04', 'KH01')

--2. Create an order slip VIEW which has the same number of lines as the Don_Hang, with the following information: Ten_KH, Ngay_DH, Ten_SP, So_Luong, Thanh_Tien

CREATE VIEW DON_HANG_CHI_TIET AS
SELECT kh.TenKH, sp.TenSP, dh.NgayDH, dh.SoLuong, (sp.DonGia * dh.SoLuong) as Tong_tien FROM KHACHHANG AS kh
INNER JOIN DONHANG AS dh ON kh.MaKH = dh.MaKH
INNER JOIN SANPHAM AS sp ON dh.MaSP = sp.MaSP

SELECT * FROM DON_HANG_CHI_TIET
