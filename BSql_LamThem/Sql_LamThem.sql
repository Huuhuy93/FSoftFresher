CREATE DATABASE Sql_Lam_Them
go
USE Sql_Lam_Them
go

CREATE TABLE DMSANPHAM (
	MaDM char(10) not null UNIQUE,
	TenDanhMuc nvarchar(30) not null,
	MoTa varchar(50),
	CONSTRAINT pk_DmSanPham PRIMARY KEY(MaDM),
)
go

CREATE TABLE THANHTOAN (
	MaTT char(10) not null UNIQUE,
	PhuongThucTT nvarchar(20) not null,
	CONSTRAINT pk_ThanhToan PRIMARY KEY(MaTT),
)
go

CREATE TABLE KHACHHANG (
	MaKH char(10) not null UNIQUE,
	TenKH nvarchar(30) not null,
	Email nvarchar(30) not null,
	SoDT char(15),
	DiaChi nvarchar(50)
	CONSTRAINT pk_KhachHang PRIMARY KEY(MaKH),
)
go

CREATE TABLE SANPHAM (
	MaSP char(10) not null UNIQUE,
	TenSP nvarchar(30) not null,
	XuatXu nvarchar(30) not null,
	GiaTien float,
	SoLuong int,
	MaDM char(10) not null,
	CONSTRAINT pk_SanPham PRIMARY KEY(MaSP),
	CONSTRAINT fk_DanhMuc FOREIGN KEY(MaDM) REFERENCES DMSANPHAM(MaDM)
	ON DELETE CASCADE
)
go

CREATE TABLE CHITIETDONHANG (
	MaDH char(10) not null,
	MaSP char(10) not null,
	SoLuong int not null,
	TongTien float,
	CONSTRAINT pk_ChiTietDH PRIMARY KEY(MaDH, MaSP),
	CONSTRAINT fk_donhang_CHITIET FOREIGN KEY(MaDH) REFERENCES DONHANG(MaDH),
	CONSTRAINT fk_sanpham_CHITIET FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP)
	ON DELETE CASCADE
)
go

CREATE TABLE DONHANG (
	MaDH char(10) not null unique,
	MaKH char(10) not null,
	MaTT char(10) not null,
	NgayDat Date not null,
	CONSTRAINT pk_DonHang PRIMARY KEY(MaDH),
	CONSTRAINT fk_KhachHang FOREIGN KEY(MaKH) REFERENCES KHACHHANG(MaKH),
	CONSTRAINT fk_ThanhToan FOREIGN KEY(MaTT) REFERENCES THANHTOAN(MaTT)
	ON DELETE CASCADE
)
go



--Câu 1: Liệt kê thông tin toàn bộ Sản phẩm

SELECT * FROM SANPHAM

--Câu 2: Xóa toàn bộ khách hàng có DiaChi là 'Lang Son'.

DELETE FROM KHACHHANG WHERE DiaChi = 'Lang Son'

--Câu 3: Cập nhật giá trị của trường XuatXu trong bảng SanPham thành 'Viet Nam' đối với trường XuatXu có giá trị là 'VN'.

UPDATE SANPHAM SET XuatXu = 'Viet Nam' WHERE XuatXu = 'VN'

--Câu 4: Liệt kê thông tin những sản phẩm có SoLuong lớn hơn 50 thuộc danh mục là 'Thoi trang nu' và những Sản phẩm có SoLuong lớn hơn 100
--thuộc danh mục là 'Thoi trang nam'.

SELECT * FROM SANPHAM INNER JOIN DMSANPHAM
ON SANPHAM.MaDM = DMSANPHAM.MaDM
WHERE SANPHAM.SoLuong > 50 AND DMSANPHAM.TenDanhMuc = 'Thoi Trang Nu'
OR SANPHAM.SoLuong > 100 AND DMSANPHAM.TenDanhMuc = 'Thoi Trang Nam'

--Câu 5: Liệt kê những khách hàng có tên bắt đầu là ký tự 'A' và có độ dài là 5 ký tự.

--Câu 6: Liệt kê toàn bộ Sản phẩm, sắp xếp giảm dần theo TenSP và tăng dần theo SoLuong.

SELECT * FROM SANPHAM ORDER BY SoLuong ASC, TenSP DESC

--Câu 7: Đếm các sản phẩm tương ứng theo từng khách hàng đã đặt hàng, chỉ đếm những Sản phẩm được khách hang đặt hàng trên 5 sản phẩm.

SELECT DONHANG.MaKH, SUM(CHITIETDONHANG.SoLuong) FROM CHITIETDONHANG
INNER JOIN DONHANG ON CHITIETDONHANG.MaDH = DONHANG.MaDH
GROUP BY DONHANG.MaKH HAVING SUM(CHITIETDONHANG.SoLuong) > 5

--Câu 8: Liệt kê tên của toàn bộ khách hàng (tên nào giống nhau thì chỉ liệt kê một lần).

SELECT DISTINCT KHACHHANG.TenKH FROM KHACHHANG 

--Câu 9: Liệt kê MaKH, TenKH, TenSP, SoLuong, NgayDat, GiaTien,TongTien (của tất cả các lần đặt hàng của khách hàng).

SELECT kh.MaKH, kh.TenKH, sp.TenSP, sp.GiaTien, dh.NgayDat, ct.SoLuong, ct.TongTien FROM CHITIETDONHANG as ct
INNER JOIN SANPHAM as sp ON ct.MaSP = sp.MaSP
INNER JOIN DONHANG as dh ON ct.MaDH = dh.MaDH
INNER JOIN KHACHHANG as kh ON dh.MaKH = kh.MaKH

--Câu 10: Liệt kê MaKH, TenKH, MaDH, TenSP, SoLuong, TongTien của tất cả các lần đặt hàng của khách hàng.

SELECT kh.MaKH, kh.TenKH, sp.TenSP, dh.MaDH, ct.SoLuong, ct.TongTien FROM CHITIETDONHANG as ct
INNER JOIN SANPHAM as sp ON ct.MaSP = sp.MaSP
INNER JOIN DONHANG as dh ON ct.MaDH = dh.MaDH
RIGHT JOIN KHACHHANG as kh ON dh.MaKH = kh.MaKH

--Câu 11: Liệt kê MaKH, TenKH của những khách hàng đã từng đặt hàng với thực hiện thanh toán qua 'Visa' hoặc đã thực hiện thanh toán qua 'JCB'.

SELECT kh.MaKH, kh.TenKH FROM DONHANG as dh
INNER JOIN KHACHHANG as kh ON dh.MaKH = kh.MaKH
INNER JOIN THANHTOAN as tt ON dh.MaTT = tt.MaTT
WHERE PhuongThucTT = 'Visa' OR PhuongThucTT = 'JCB'

--Câu 12: Liệt kê MaKH, TenKH của những khách hàng chưa từng mua bất kỳ sản phẩm nào.

SELECT kh.MaKH, kh.TenKH FROM KHACHHANG as kh WHERE kh.TenKH NOT IN
(SELECT kh.TenKH FROM CHITIETDONHANG as ct
INNER JOIN SANPHAM as sp ON ct.MaSP = sp.MaSP
INNER JOIN DONHANG as dh ON ct.MaDH = dh.MaDH
INNER JOIN KHACHHANG as kh ON dh.MaKH = kh.MaKH
GROUP BY kh.TenKH)


SELECT KHACHHANG.MaKH, KHACHHANG.TenKH, SANPHAM.TenSP, SANPHAM.GiaTien, THANHTOAN.PhuongThucTT, DONHANG.NgayDat, CHITIETDONHANG.TongTien FROM KHACHHANG INNER JOIN DONHANG ON DONHANG.MaKH = KHACHHANG.MaKH INNER JOIN CHITIETDONHANG ON CHITIETDONHANG.MaDH = DONHANG.MaDH INNER JOIN SANPHAM ON SANPHAM.MaSP = CHITIETDONHANG.MaSP INNER JOIN THANHTOAN ON THANHTOAN.MaTT = DONHANG.MaTT
 GROUP BY KHACHHANG.MaKH HAVING COUNT(KHACHHANG.MaKH) = 1










