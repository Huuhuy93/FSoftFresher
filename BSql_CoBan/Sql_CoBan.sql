CREATE DATABASE Sql_Co_Ban
go
USE Sql_Co_Ban
go

CREATE TABLE LOAISP (
	Ma_Loai_SP char(10) not null unique,
	Ten_Loai_SP nvarchar(50) not null,
	CONSTRAINT pk_LoaiSP PRIMARY KEY(Ma_Loai_SP),
)
go

CREATE TABLE SANPHAM(
	Ma_SP char(10) not null unique,
	Ten_SP nvarchar(50) not null,
	Gia_Ban float,
	Ma_Loai_SP char(10) not null,
	CONSTRAINT pk_SanPham PRIMARY KEY(Ma_SP),
	CONSTRAINT fk_LoaiSP FOREIGN KEY(Ma_Loai_SP) REFERENCES LOAISP(Ma_Loai_SP)
)
go

CREATE TABLE NHANVIEN (
	Ma_NV char(10) not null unique,
	Ho_Ten_NV nvarchar(50) not null,
	Gioi_Tinh char(10) not null,
	Que_Quan nvarchar(30),
	Tuoi int not null,
	CONSTRAINT pk_NhanVien PRIMARY KEY(Ma_NV),
)
go

CREATE TABLE BANHANG(
	Ma_NV char(10) not null,
	Ma_SP char(10) not null,
	CONSTRAINT pk_BanHang PRIMARY KEY(Ma_NV, Ma_SP),
	So_Luong_Da_Ban int not null,
	CONSTRAINT fk_sanpham_BANHANG FOREIGN KEY(Ma_SP) REFERENCES SANPHAM(Ma_SP),
	CONSTRAINT fk_nhanvien_BANHANG FOREIGN KEY(Ma_NV) REFERENCES NHANVIEN(Ma_NV)
	ON DELETE CASCADE
)
go


--Thêm 1 nhân viên có MãNV là 'NV01', Tên là Nguyễn Chí Phèo, Nam, Quê ở Quảng Trị, 18 tuổi
INSERT INTO NHANVIEN VALUES ('NV01', 'Nguyễn Chí Phèo', 'Nam', 'Quảng Trị', 18), ('NV02', 'Nguyễn Văn A', 'Nam', 'Quảng Nam', 20),
							('NV03', 'Lê Văn Tám', 'Nữ', 'Huế', 28), ('NV04', 'Nguyễn Thị Thảo', 'Nữ', 'Đà Nẵng', 25)
INSERT INTO NHANVIEN VALUES ('NV05', 'Lê Thị Tâm', 'Nữ', 'Kon Tum', 26), ('NV06', 'Lê Bích Ngọc', 'Nữ', 'Bình Định', 26),
							('NV07', 'Trần Thị Hoa', 'Nữ', 'Gia Lai', 26)
INSERT INTO NHANVIEN(Ma_NV, Ho_Ten_NV, Gioi_Tinh, Tuoi) VALUES ('NV08', 'Lê Ngọc Hoa', 'Nữ', 26)

INSERT INTO LOAISP VALUES ('TYPE001', 'Mỹ phẩm'), ('TYPE002', 'Hóa chất'), ('TYPE003', 'Thực phẩm'), ('TYPE004', 'Gia dụng')

INSERT INTO SANPHAM VALUES ('SP001', 'Olay', 200000, 'TYPE001'), ('SP002', 'Bột giặt OMO', 15000, 'TYPE002'), ('SP003', 'Ponds', 300000, 'TYPE001'),
						   ('SP004', 'Ps', 18000, 'TYPE003'), ('SP005', 'Lương khô', 10000, 'TYPE003'), ('SP006', 'Máy sấy tóc Kendo', 150000, 'TYPE004')
INSERT INTO SANPHAM(Ma_SP,Ten_SP , Ma_Loai_SP) VALUES ('SP007', 'Nồi cơm điện', 'TYPE004')

INSERT INTO BANHANG VALUES ('NV01', 'SP003', 7), ('NV01', 'SP001', 5), ('NV02', 'SP002', 4), ('NV03', 'SP005', 2), ('NV03', 'SP006', 6),
						   ('NV05', 'SP002', 6), ('NV06', 'SP005', 50), ('NV06', 'SP001', 3)

--2. Xóa những nhân viên nữ quê ở Kon Tum

DELETE FROM dbo.NHANVIEN WHERE Gioi_Tinh = 'Nữ' AND Que_Quan = 'Kon Tum'


--3. Tăng giá bán lên gấp đôi cho những sản phẩm có mã loại sản phẩm là 'Type001'

UPDATE SANPHAM SET Gia_Ban = Gia_Ban * 2 WHERE Ma_Loai_SP = 'TYPE001'

--4. Hãy liệt kê thông tin toàn bộ nhân viên trong công ty

SELECT * FROM NHANVIEN

--5. Hãy liệt kê toàn bộ thông tin của nhân viên từ 23 tuổi trở lên và có quê quán ở Bình Định

SELECT * FROM NHANVIEN WHERE Tuoi > 23 AND Que_Quan = 'Bình Định'

--6. Hãy liệt kê Mã sản phẩm của những sản phẩm đã từng được bán

SELECT BANHANG.Ma_SP FROM BANHANG WHERE So_Luong_Da_Ban > 0 GROUP BY Ma_SP

--7. Hãy liệt kê những nhân viên có họ là Nguyễn

SELECT * FROM NHANVIEN 
WHERE Ho_Ten_NV LIKE  'Nguyễn%'

--8. Hãy liệt kê những nhân viên có tên là Hoa

SELECT * FROM NHANVIEN WHERE Ho_Ten_NV LIKE '%Hoa%'

--9. Hãy liệt kê những sản phẩm có tên bao gồm 12 ký tự

SELECT SANPHAM.Ten_SP FROM SANPHAM WHERE LEN(Ten_SP) = 12

--10. Hãy liệt kê những sản phẩm thuộc loại 'Mỹ phẩm'

SELECT SANPHAM.Ten_SP FROM SANPHAM WHERE Ma_Loai_SP = 'TYPE001'

--11. Hãy liệt kê những sản phẩm có giá bán dưới 20.000 hoặc chưa từng được bán lần nào

SELECT SANPHAM.Ten_SP FROM SANPHAM
WHERE SANPHAM.Gia_Ban < 20000 OR SANPHAM.Ma_SP NOT IN (SELECT BANHANG.Ma_SP FROM BANHANG)

--12. Hãy liệt kê những nhưng viên chưa từng bán được sản phẩm nào và những nhân viên chỉ mới bán được sản phẩm Bột giặt OMO

SELECT NHANVIEN.Ho_Ten_NV FROM NHANVIEN
WHERE NHANVIEN.Ma_NV NOT IN (SELECT BANHANG.Ma_NV FROM BANHANG)
OR NHANVIEN.Ma_NV IN (SELECT BANHANG.Ma_NV FROM BANHANG WHERE Ma_SP = 'SP002')

--13. Hãy liệt kê mã nhân viên của những nhân viên có quê ở Gia Lai và chưa từng bán được sản phẩm nào

SELECT NHANVIEN.Ho_Ten_NV FROM NHANVIEN
WHERE NHANVIEN.Ma_NV NOT IN (SELECT BANHANG.Ma_NV FROM BANHANG)
AND NHANVIEN.Que_Quan = 'Gia Lai' 

--14. Hãy liệt kê MaSP, TênSP, Mã Loại SP, Giá Bán, Tên Loại SP của tất cả những sản phẩm đã có niêm yết giá bán

SELECT SANPHAM.Ma_SP, SANPHAM.Ten_SP, SANPHAM.Ma_Loai_SP, SANPHAM.Gia_Ban, LOAISP.Ten_Loai_SP FROM SANPHAM
INNER JOIN LOAISP ON SANPHAM.Ma_Loai_SP = LOAISP.Ma_Loai_SP
WHERE Gia_Ban > 0

--15. Hãy liệt kê MãNV, Họ tên NV, Giới Tính, Quê Quán của nhân viên và mã sản phẩm, tên sản phẩm, loại sản phẩm, tên loại sản phẩm, 
--số lượng đã bán của tất cả các những nhân viên đã từng bán được hàng.

SELECT nv.Ma_NV, nv.Ho_Ten_NV, nv.Gioi_Tinh, nv.Que_Quan, sp.Ma_SP, sp.Ten_SP, lsp.Ten_Loai_SP, bh.So_Luong_Da_Ban FROM SANPHAM as sp
INNER JOIN LOAISP as lsp ON sp.Ma_Loai_SP = lsp.Ma_Loai_SP
INNER JOIN BANHANG as bh ON sp.Ma_SP = bh.Ma_SP
INNER JOIN NHANVIEN as nv ON bh.Ma_NV = nv.Ma_NV

--16. Hãy liệt kê Mã Loại SP, Tên loại SP của những loại sản phẩm đã từng được bán

SELECT lsp.Ma_Loai_SP, lsp.Ten_Loai_SP FROM LOAISP as lsp
INNER JOIN SANPHAM as sp ON lsp.Ma_Loai_SP = sp.Ma_Loai_SP
INNER JOIN BANHANG as bh ON sp.Ma_SP = bh.Ma_SP
GROUP BY lsp.Ma_Loai_SP, lsp.Ten_Loai_SP

--17. Hãy liệt kê tên (họ + tên) của những nhân viên trong công ty (nếu có tên trùng nhau thì chỉ hiển thị tên đó 1 lần)

SELECT DISTINCT  Ho_Ten_NV from NHANVIEN 

--18. Hãy liệt kê MaNV, TênNV, Quê Quán của tất cả nhân viên, nếu bạn nào chưa có quê quán thì mục quê quán sẽ hiển thị là 'Cõi trên xuống'

SELECT Ma_NV, Ho_Ten_NV ,  
 Case when Que_Quan is null then 'Coi tren xuong' when Que_Quan != '' then Que_Quan else 'Other' end 
 from NHANVIEN

--19. Hãy liệt kê 5 nhân viên có tuổi đời cao nhất trong công ty

SELECT TOP(5) NHANVIEN.Tuoi, NHANVIEN.Ho_Ten_NV FROM NHANVIEN ORDER BY Tuoi DESC

--20. Hãy liệt kê những nhân viên có tuổi đời từ 25 đến 35 tuổi
SELECT * FROM NHANVIEN WHERE Tuoi BETWEEN 25 AND 35