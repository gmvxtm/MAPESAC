USE [master]
GO
/****** Object:  Database [MAPESAC]    Script Date: 16/10/2021 09:58:18 ******/
CREATE DATABASE [MAPESAC]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MAPESAC', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MAPESAC.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MAPESAC_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MAPESAC_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MAPESAC] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MAPESAC].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MAPESAC] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MAPESAC] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MAPESAC] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MAPESAC] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MAPESAC] SET ARITHABORT OFF 
GO
ALTER DATABASE [MAPESAC] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MAPESAC] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MAPESAC] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MAPESAC] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MAPESAC] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MAPESAC] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MAPESAC] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MAPESAC] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MAPESAC] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MAPESAC] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MAPESAC] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MAPESAC] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MAPESAC] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MAPESAC] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MAPESAC] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MAPESAC] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MAPESAC] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MAPESAC] SET RECOVERY FULL 
GO
ALTER DATABASE [MAPESAC] SET  MULTI_USER 
GO
ALTER DATABASE [MAPESAC] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MAPESAC] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MAPESAC] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MAPESAC] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MAPESAC] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'MAPESAC', N'ON'
GO
ALTER DATABASE [MAPESAC] SET QUERY_STORE = OFF
GO
USE [MAPESAC]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetCodeOrder]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_GetCodeOrder] ()  
	RETURNS CHAR(13)  
AS  
BEGIN  
	DECLARE	@VResult	CHAR(13);
	DECLARE	@CDate		DATETIME	=	GETDATE()
	SELECT	@VResult	=	CONCAT(	RIGHT(YEAR(@CDate),4)
									,RIGHT(CONCAT('00',CAST(MONTH(@CDate)  AS VARCHAR(2))),2)
									,'-'
									,RIGHT(CONCAT('000000',CAST(COUNT(1)+1  AS VARCHAR(6))),6))
	FROM	dbo.[Order]	O
	WHERE	YEAR(O.DateOrder)	=	YEAR(@CDate)
	AND		MONTH(O.DateOrder)	=	MONTH(@CDate)

	RETURN	@VResult;
END;  
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetCodeSubOrder]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_GetCodeSubOrder] (
	@ParamILocationOrder	AS	CHAR(5)
)  
	RETURNS VARCHAR(25)  
AS  
BEGIN  
	DECLARE	@VResult	VARCHAR(25);
	DECLARE	@CDate		DATETIME	=	GETDATE();
	DECLARE	@CLocationOrderPrefix	VARCHAR(10);
	DECLARE	@CIdLocationCorte		CHAR(5)	=	'00202';
	DECLARE	@CIdLocationCostura		CHAR(5)	=	'00203';
	DECLARE	@CIdLocationLavanderia	CHAR(5)	=	'00204';
	DECLARE	@CIdLocationAcabados	CHAR(5)	=	'00205';
	
	SET	@CLocationOrderPrefix	=
	(	CASE	@ParamILocationOrder
			WHEN	@CIdLocationCorte		THEN	'CORT'
			WHEN	@CIdLocationCostura		THEN	'COST'
			WHEN	@CIdLocationLavanderia	THEN	'LAVA'
			WHEN	@CIdLocationAcabados	THEN	'ACAB'
			ELSE	'OTRO'
		END)

	SELECT	@VResult	=	CONCAT(	@CLocationOrderPrefix
									,RIGHT(YEAR(@CDate),4)
									,RIGHT(CONCAT('00',CAST(MONTH(@CDate)  AS VARCHAR(2))),2)
									,'-'
									,RIGHT(CONCAT('000000',CAST(COUNT(1)+1  AS VARCHAR(6))),6))
	FROM	dbo.[SubOrderFlow]	SOF
	INNER JOIN dbo.[ProductSubProcess]	PSP
		ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
	WHERE	YEAR(SOF.DateSubOrder)	=	YEAR(@CDate)
		AND	MONTH(SOF.DateSubOrder)	=	MONTH(@CDate)
		AND	PSP.LocationOrder	=	@ParamILocationOrder

	RETURN	@VResult;
END;  
GO
/****** Object:  Table [dbo].[BuySupply]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BuySupply](
	[IdBuySupply] [uniqueidentifier] NOT NULL,
	[IdSuppliersBySupply] [uniqueidentifier] NULL,
	[UnitPrice] [numeric](9, 2) NULL,
	[Quantity] [numeric](9, 2) NULL,
	[TotalPrice] [numeric](9, 2) NULL,
	[DateBuySupply] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[IdCustomer] [uniqueidentifier] NOT NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NOT NULL,
	[DocumentNumber] [varchar](20) NOT NULL,
	[PhoneNumber] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[IdDistrict] [int] NULL,
	[RecordStatus] [char](1) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[IdCustomer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[IdDepartment] [int] NOT NULL,
	[Department] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDepartment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[District]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[District](
	[IdDistrict] [int] NOT NULL,
	[District] [varchar](50) NULL,
	[IdProvince] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDistrict] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MasterTable]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterTable](
	[IdMasterTable] [char](5) NOT NULL,
	[IdMasterTableParent] [char](5) NULL,
	[Name] [varchar](100) NULL,
	[Order] [int] NULL,
	[Value] [varchar](max) NULL,
	[AdditionalOne] [varchar](100) NULL,
	[AdditionalTwo] [varchar](100) NULL,
	[AdditionalThree] [varchar](100) NULL,
	[RecordStatus] [char](1) NULL,
 CONSTRAINT [PK_MasterTable] PRIMARY KEY CLUSTERED 
(
	[IdMasterTable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[IdMenu] [char](5) NOT NULL,
	[IdMenuParent] [char](5) NULL,
	[MenuName] [varchar](100) NOT NULL,
	[UrlName] [varchar](100) NULL,
	[RecordStatus] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuProfile]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuProfile](
	[IdMenuProfile] [uniqueidentifier] NOT NULL,
	[IdMenu] [char](5) NOT NULL,
	[IdProfile] [char](5) NOT NULL,
	[RecordStatus] [char](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[IdOrder] [uniqueidentifier] NOT NULL,
	[DateOrder] [date] NOT NULL,
	[CodeOrder] [varchar](50) NOT NULL,
	[Total] [numeric](9, 2) NOT NULL,
	[StatusOrder] [char](5) NULL,
	[LocationOrder] [char](5) NULL,
	[IdCustomer] [uniqueidentifier] NOT NULL,
	[RecordStatus] [char](1) NULL,
	[BusinessNumber] [varchar](11) NULL,
	[BusinessName] [varchar](200) NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[IdOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[IdOrderDetail] [uniqueidentifier] NOT NULL,
	[IdOrder] [uniqueidentifier] NOT NULL,
	[IdProduct] [uniqueidentifier] NOT NULL,
	[Description] [varchar](3000) NULL,
	[Quantity] [decimal](18, 4) NULL,
	[RecordStatus] [char](1) NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[IdOrderDetail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderFlow]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderFlow](
	[IdOrderFlow] [uniqueidentifier] NOT NULL,
	[IdOrder] [uniqueidentifier] NOT NULL,
	[NroOrder] [int] NULL,
	[LocationOrder] [char](5) NULL,
	[Answer] [char](5) NULL,
	[DateOrderFlow] [datetime] NOT NULL,
	[FlagInProcess] [bit] NULL,
	[FlagActive] [bit] NULL,
 CONSTRAINT [PK_OrderFlow] PRIMARY KEY CLUSTERED 
(
	[IdOrderFlow] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderStatus]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderStatus](
	[IdOrderStatus] [uniqueidentifier] NOT NULL,
	[IdOrder] [uniqueidentifier] NOT NULL,
	[Location] [char](5) NULL,
	[Status] [char](5) NOT NULL,
	[DateOrderStatus] [datetime] NOT NULL,
 CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[IdOrderStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[IdProduct] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[PathFile] [varchar](max) NULL,
	[RecordStatus] [char](1) NULL,
	[PriceUnit] [numeric](18, 4) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[IdProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductSubProcess]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductSubProcess](
	[IdProductSubProcess] [uniqueidentifier] NOT NULL,
	[IdProduct] [uniqueidentifier] NOT NULL,
	[LocationOrder] [char](5) NOT NULL,
	[Description] [varchar](200) NULL,
	[OrderSubProcess] [int] NULL,
 CONSTRAINT [PK_ProductSubProcess] PRIMARY KEY CLUSTERED 
(
	[IdProductSubProcess] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Province]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Province](
	[IdProvince] [int] NOT NULL,
	[Province] [varchar](50) NULL,
	[IdDepartment] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdProvince] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubOrderFlow]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubOrderFlow](
	[IdSubOrderFlow] [uniqueidentifier] NOT NULL,
	[IdProductSubProcess] [uniqueidentifier] NOT NULL,
	[IdOrderFlow] [uniqueidentifier] NOT NULL,
	[StatusSubOrderMT] [char](5) NULL,
	[CodeSubOrder] [varchar](25) NULL,
	[DateSubOrder] [date] NULL,
	[DateEndSubOrder] [date] NULL,
	[QuantityDecrease] [numeric](9, 2) NULL,
 CONSTRAINT [PK_SubOrderFlow] PRIMARY KEY CLUSTERED 
(
	[IdSubOrderFlow] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[IdSupplier] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NULL,
	[Phone] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[RecordStatus] [char](1) NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[IdSupplier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SuppliersBySupply]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SuppliersBySupply](
	[IdSuppliersBySupply] [uniqueidentifier] NOT NULL,
	[IdSupplier] [uniqueidentifier] NOT NULL,
	[IdSupply] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SuppliersBySupplie] PRIMARY KEY CLUSTERED 
(
	[IdSuppliersBySupply] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SuppliesByProduct]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SuppliesByProduct](
	[IdSuppliesByProduct] [uniqueidentifier] NOT NULL,
	[IdSupply] [uniqueidentifier] NOT NULL,
	[IdProduct] [uniqueidentifier] NOT NULL,
	[MTLocation] [char](5) NULL,
	[Quantity] [numeric](9, 2) NOT NULL,
	[MTMeasureUnit] [char](5) NULL,
 CONSTRAINT [PK_SuppliesByProduct] PRIMARY KEY CLUSTERED 
(
	[IdSuppliesByProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supply]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supply](
	[IdSupply] [uniqueidentifier] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[RecordStatus] [char](1) NULL,
	[Stock] [numeric](9, 2) NULL,
	[MeasureUnit] [char](5) NULL,
	[MinimumStock] [numeric](9, 2) NULL,
	[DateUpdate] [date] NULL,
	[CodeSupply] [char](4) NULL,
	[PriceUnit] [numeric](18, 4) NULL,
 CONSTRAINT [PK_Supplie] PRIMARY KEY CLUSTERED 
(
	[IdSupply] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[IdUser] [uniqueidentifier] NOT NULL,
	[Username] [varchar](100) NOT NULL,
	[Password] [varchar](max) NOT NULL,
	[RecordStatus] [char](1) NULL,
	[IdProfile] [char](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[BuySupply] ([IdBuySupply], [IdSuppliersBySupply], [UnitPrice], [Quantity], [TotalPrice], [DateBuySupply]) VALUES (N'580f3ba0-d51e-442b-adb2-079e7e9fa2e2', N'd95791c0-6e45-4638-9ca4-c169a67ab56b', CAST(60.50 AS Numeric(9, 2)), CAST(50.00 AS Numeric(9, 2)), CAST(3025.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date))
INSERT [dbo].[BuySupply] ([IdBuySupply], [IdSuppliersBySupply], [UnitPrice], [Quantity], [TotalPrice], [DateBuySupply]) VALUES (N'2e7936ec-d8b9-4b90-b30b-a9eefa33f06f', N'1668e4a0-1aec-4a81-867a-0fca46222971', CAST(1.00 AS Numeric(9, 2)), CAST(100.00 AS Numeric(9, 2)), CAST(100.00 AS Numeric(9, 2)), CAST(N'2021-10-07' AS Date))
INSERT [dbo].[BuySupply] ([IdBuySupply], [IdSuppliersBySupply], [UnitPrice], [Quantity], [TotalPrice], [DateBuySupply]) VALUES (N'e08cb672-5380-41bf-b258-e392f9587942', N'da21df1a-dd54-4dd5-83d0-4e1cea489920', CAST(1.00 AS Numeric(9, 2)), CAST(100.00 AS Numeric(9, 2)), CAST(100.00 AS Numeric(9, 2)), CAST(N'2021-10-07' AS Date))
INSERT [dbo].[BuySupply] ([IdBuySupply], [IdSuppliersBySupply], [UnitPrice], [Quantity], [TotalPrice], [DateBuySupply]) VALUES (N'227361ea-137b-4e9f-80a1-b67062ff717b', NULL, CAST(1.00 AS Numeric(9, 2)), CAST(11000.00 AS Numeric(9, 2)), CAST(11000.00 AS Numeric(9, 2)), CAST(N'2021-10-07' AS Date))
INSERT [dbo].[BuySupply] ([IdBuySupply], [IdSuppliersBySupply], [UnitPrice], [Quantity], [TotalPrice], [DateBuySupply]) VALUES (N'd53ea031-968a-4a91-8860-6fee4374b4e7', NULL, CAST(1.00 AS Numeric(9, 2)), CAST(1000.00 AS Numeric(9, 2)), CAST(1000.00 AS Numeric(9, 2)), CAST(N'2021-10-07' AS Date))
GO
INSERT [dbo].[Customer] ([IdCustomer], [FirstName], [LastName], [DocumentNumber], [PhoneNumber], [Email], [IdDistrict], [RecordStatus]) VALUES (N'8eba8d99-0d1e-4677-9cb4-0b89ccf9426c', N'no', N'ape', N'4545454', N'54544545', N'gasdadsa@gmail.com', 1, N'A')
GO
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (1, N'AMAZONAS')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (2, N'ANCASH')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (3, N'APURIMAC')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (4, N'AREQUIPA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (5, N'AYACUCHO')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (6, N'CAJAMARCA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (7, N'CALLAO')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (8, N'CUSCO')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (9, N'HUANCAVELICA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (10, N'HUANUCO')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (11, N'ICA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (12, N'JUNIN')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (13, N'LA LIBERTAD')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (14, N'LAMBAYEQUE')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (15, N'LIMA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (16, N'LORETO')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (17, N'MADRE DE DIOS')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (18, N'MOQUEGUA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (19, N'PASCO')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (20, N'PIURA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (21, N'PUNO')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (22, N'SAN MARTIN')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (23, N'TACNA')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (24, N'TUMBES')
INSERT [dbo].[Department] ([IdDepartment], [Department]) VALUES (25, N'UCAYALI')
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1, N'CHACHAPOYAS', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (2, N'ASUNCION', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (3, N'BALSAS', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (4, N'CHETO', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (5, N'CHILIQUIN', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (6, N'CHUQUIBAMBA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (7, N'GRANADA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (8, N'HUANCAS', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (9, N'LA JALCA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (10, N'LEIMEBAMBA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (11, N'LEVANTO', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (12, N'MAGDALENA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (13, N'MARISCAL CASTILLA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (14, N'MOLINOPAMPA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (15, N'MONTEVIDEO', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (16, N'OLLEROS', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (17, N'QUINJALCA', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (18, N'SAN FRANCISCO DE DAGUAS', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (19, N'SAN ISIDRO DE MAINO', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (20, N'SOLOCO', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (21, N'SONCHE', 1)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (22, N'LA PECA', 2)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (23, N'ARAMANGO', 2)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (24, N'COPALLIN', 2)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (25, N'EL PARCO', 2)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (26, N'IMAZA', 2)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (27, N'JUMBILLA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (28, N'CHISQUILLA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (29, N'CHURUJA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (30, N'COROSHA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (31, N'CUISPES', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (32, N'FLORIDA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (33, N'JAZAN', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (34, N'RECTA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (35, N'SAN CARLOS', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (36, N'SHIPASBAMBA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (37, N'VALERA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (38, N'YAMBRASBAMBA', 3)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (39, N'NIEVA', 4)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (40, N'EL CENEPA', 4)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (41, N'RIO SANTIAGO', 4)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (42, N'LAMUD', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (43, N'CAMPORREDONDO', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (44, N'COCABAMBA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (45, N'COLCAMAR', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (46, N'CONILA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (47, N'INGUILPATA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (48, N'LONGUITA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (49, N'LONYA CHICO', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (50, N'LUYA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (51, N'LUYA VIEJO', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (52, N'MARIA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (53, N'OCALLI', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (54, N'OCUMAL', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (55, N'PISUQUIA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (56, N'PROVIDENCIA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (57, N'SAN CRISTOBAL', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (58, N'SAN FRANCISCO DEL YESO', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (59, N'SAN JERONIMO', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (60, N'SAN JUAN DE LOPECANCHA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (61, N'SANTA CATALINA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (62, N'SANTO TOMAS', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (63, N'TINGO', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (64, N'TRITA', 5)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (65, N'SAN NICOLAS', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (66, N'CHIRIMOTO', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (67, N'COCHAMAL', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (68, N'HUAMBO', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (69, N'LIMABAMBA', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (70, N'LONGAR', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (71, N'MARISCAL BENAVIDES', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (72, N'MILPUC', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (73, N'OMIA', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (74, N'SANTA ROSA', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (75, N'TOTORA', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (76, N'VISTA ALEGRE', 6)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (77, N'BAGUA GRANDE', 7)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (78, N'CAJARURO', 7)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (79, N'CUMBA', 7)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (80, N'EL MILAGRO', 7)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (81, N'JAMALCA', 7)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (82, N'LONYA GRANDE', 7)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (83, N'YAMON', 7)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (84, N'HUARAZ', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (85, N'COCHABAMBA', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (86, N'COLCABAMBA', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (87, N'HUANCHAY', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (88, N'INDEPENDENCIA', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (89, N'JANGAS', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (90, N'LA LIBERTAD', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (91, N'OLLEROS', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (92, N'PAMPAS', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (93, N'PARIACOTO', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (94, N'PIRA', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (95, N'TARICA', 8)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (96, N'AIJA', 9)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (97, N'CORIS', 9)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (98, N'HUACLLAN', 9)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (99, N'LA MERCED', 9)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (100, N'SUCCHA', 9)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (101, N'LLAMELLIN', 10)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (102, N'ACZO', 10)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (103, N'CHACCHO', 10)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (104, N'CHINGAS', 10)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (105, N'MIRGAS', 10)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (106, N'SAN JUAN DE RONTOY', 10)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (107, N'CHACAS', 11)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (108, N'ACOCHACA', 11)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (109, N'CHIQUIAN', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (110, N'ABELARDO PARDO LEZAMETA', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (111, N'ANTONIO RAYMONDI', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (112, N'AQUIA', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (113, N'CAJACAY', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (114, N'CANIS', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (115, N'COLQUIOC', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (116, N'HUALLANCA', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (117, N'HUASTA', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (118, N'HUAYLLACAYAN', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (119, N'LA PRIMAVERA', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (120, N'MANGAS', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (121, N'PACLLON', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (122, N'SAN MIGUEL DE CORPANQUI', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (123, N'TICLLOS', 12)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (124, N'CARHUAZ', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (125, N'ACOPAMPA', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (126, N'AMASHCA', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (127, N'ANTA', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (128, N'ATAQUERO', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (129, N'MARCARA', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (130, N'PARIAHUANCA', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (131, N'SAN MIGUEL DE ACO', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (132, N'SHILLA', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (133, N'TINCO', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (134, N'YUNGAR', 13)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (135, N'SAN LUIS', 14)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (136, N'SAN NICOLAS', 14)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (137, N'YAUYA', 14)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (138, N'CASMA', 15)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (139, N'BUENA VISTA ALTA', 15)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (140, N'COMANDANTE NOEL', 15)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (141, N'YAUTAN', 15)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (142, N'CORONGO', 16)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (143, N'ACO', 16)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (144, N'BAMBAS', 16)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (145, N'CUSCA', 16)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (146, N'LA PAMPA', 16)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (147, N'YANAC', 16)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (148, N'YUPAN', 16)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (149, N'HUARI', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (150, N'ANRA', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (151, N'CAJAY', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (152, N'CHAVIN DE HUANTAR', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (153, N'HUACACHI', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (154, N'HUACCHIS', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (155, N'HUACHIS', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (156, N'HUANTAR', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (157, N'MASIN', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (158, N'PAUCAS', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (159, N'PONTO', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (160, N'RAHUAPAMPA', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (161, N'RAPAYAN', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (162, N'SAN MARCOS', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (163, N'SAN PEDRO DE CHANA', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (164, N'UCO', 17)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (165, N'HUARMEY', 18)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (166, N'COCHAPETI', 18)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (167, N'CULEBRAS', 18)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (168, N'HUAYAN', 18)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (169, N'MALVAS', 18)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (170, N'CARAZ', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (171, N'HUALLANCA', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (172, N'HUATA', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (173, N'HUAYLAS', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (174, N'MATO', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (175, N'PAMPAROMAS', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (176, N'PUEBLO LIBRE', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (177, N'SANTA CRUZ', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (178, N'SANTO TORIBIO', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (179, N'YURACMARCA', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (180, N'PISCOBAMBA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (181, N'CASCA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (182, N'ELEAZAR GUZMAN BARRON', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (183, N'FIDEL OLIVAS ESCUDERO', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (184, N'LLAMA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (185, N'LLUMPA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (186, N'LUCMA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (187, N'MUSGA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (188, N'OCROS', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (189, N'ACAS', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (190, N'CAJAMARQUILLA', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (191, N'CARHUAPAMPA', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (192, N'COCHAS', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (193, N'CONGAS', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (194, N'LLIPA', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (195, N'SAN CRISTOBAL DE RAJAN', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (196, N'SAN PEDRO', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (197, N'SANTIAGO DE CHILCAS', 21)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (198, N'CABANA', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (199, N'BOLOGNESI', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (200, N'CONCHUCOS', 22)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (201, N'HUACASCHUQUE', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (202, N'HUANDOVAL', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (203, N'LACABAMBA', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (204, N'LLAPO', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (205, N'PALLASCA', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (206, N'PAMPAS', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (207, N'SANTA ROSA', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (208, N'TAUCA', 22)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (209, N'POMABAMBA', 23)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (210, N'HUAYLLAN', 23)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (211, N'PAROBAMBA', 23)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (212, N'QUINUABAMBA', 23)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (213, N'RECUAY', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (214, N'CATAC', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (215, N'COTAPARACO', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (216, N'HUAYLLAPAMPA', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (217, N'LLACLLIN', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (218, N'MARCA', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (219, N'PAMPAS CHICO', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (220, N'PARARIN', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (221, N'TAPACOCHA', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (222, N'TICAPAMPA', 24)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (223, N'CHIMBOTE', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (224, N'CACERES DEL PERU', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (225, N'COISHCO', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (226, N'MACATE', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (227, N'MORO', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (228, N'NEPE&Ntilde;A', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (229, N'SAMANCO', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (230, N'SANTA', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (231, N'NUEVO CHIMBOTE', 25)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (232, N'SIHUAS', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (233, N'ACOBAMBA', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (234, N'ALFONSO UGARTE', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (235, N'CASHAPAMPA', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (236, N'CHINGALPO', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (237, N'HUAYLLABAMBA', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (238, N'QUICHES', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (239, N'RAGASH', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (240, N'SAN JUAN', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (241, N'SICSIBAMBA', 26)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (242, N'YUNGAY', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (243, N'CASCAPARA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (244, N'MANCOS', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (245, N'MATACOTO', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (246, N'QUILLO', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (247, N'RANRAHIRCA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (248, N'SHUPLUY', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (249, N'YANAMA', 27)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (250, N'ABANCAY', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (251, N'CHACOCHE', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (252, N'CIRCA', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (253, N'CURAHUASI', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (254, N'HUANIPACA', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (255, N'LAMBRAMA', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (256, N'PICHIRHUA', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (257, N'SAN PEDRO DE CACHORA', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (258, N'TAMBURCO', 28)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (259, N'ANDAHUAYLAS', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (260, N'ANDARAPA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (261, N'CHIARA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (262, N'HUANCARAMA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (263, N'HUANCARAY', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (264, N'HUAYANA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (265, N'KISHUARA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (266, N'PACOBAMBA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (267, N'PACUCHA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (268, N'PAMPACHIRI', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (269, N'POMACOCHA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (270, N'SAN ANTONIO DE CACHI', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (271, N'SAN JERONIMO', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (272, N'SAN MIGUEL DE CHACCRAMPA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (273, N'SANTA MARIA DE CHICMO', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (274, N'TALAVERA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (275, N'TUMAY HUARACA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (276, N'TURPO', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (277, N'KAQUIABAMBA', 29)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (278, N'ANTABAMBA', 30)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (279, N'EL ORO', 30)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (280, N'HUAQUIRCA', 30)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (281, N'JUAN ESPINOZA MEDRANO', 30)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (282, N'OROPESA', 30)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (283, N'PACHACONAS', 30)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (284, N'SABAINO', 30)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (285, N'CHALHUANCA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (286, N'CAPAYA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (287, N'CARAYBAMBA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (288, N'CHAPIMARCA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (289, N'COLCABAMBA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (290, N'COTARUSE', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (291, N'HUAYLLO', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (292, N'JUSTO APU SAHUARAURA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (293, N'LUCRE', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (294, N'POCOHUANCA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (295, N'SAN JUAN DE CHAC&Ntilde;A', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (296, N'SA&Ntilde;AYCA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (297, N'SORAYA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (298, N'TAPAIRIHUA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (299, N'TINTAY', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (300, N'TORAYA', 31)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (301, N'YANACA', 31)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (302, N'TAMBOBAMBA', 32)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (303, N'COTABAMBAS', 32)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (304, N'COYLLURQUI', 32)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (305, N'HAQUIRA', 32)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (306, N'MARA', 32)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (307, N'CHALLHUAHUACHO', 32)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (308, N'CHINCHEROS', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (309, N'ANCO-HUALLO', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (310, N'COCHARCAS', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (311, N'HUACCANA', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (312, N'OCOBAMBA', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (313, N'ONGOY', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (314, N'URANMARCA', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (315, N'RANRACANCHA', 33)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (316, N'CHUQUIBAMBILLA', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (317, N'CURPAHUASI', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (318, N'GAMARRA', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (319, N'HUAYLLATI', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (320, N'MAMARA', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (321, N'MICAELA BASTIDAS', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (322, N'PATAYPAMPA', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (323, N'PROGRESO', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (324, N'SAN ANTONIO', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (325, N'SANTA ROSA', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (326, N'TURPAY', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (327, N'VILCABAMBA', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (328, N'VIRUNDO', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (329, N'CURASCO', 34)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (330, N'AREQUIPA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (331, N'ALTO SELVA ALEGRE', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (332, N'CAYMA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (333, N'CERRO COLORADO', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (334, N'CHARACATO', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (335, N'CHIGUATA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (336, N'JACOBO HUNTER', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (337, N'LA JOYA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (338, N'MARIANO MELGAR', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (339, N'MIRAFLORES', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (340, N'MOLLEBAYA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (341, N'PAUCARPATA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (342, N'POCSI', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (343, N'POLOBAYA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (344, N'QUEQUE&Ntilde;A', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (345, N'SABANDIA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (346, N'SACHACA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (347, N'SAN JUAN DE SIGUAS', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (348, N'SAN JUAN DE TARUCANI', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (349, N'SANTA ISABEL DE SIGUAS', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (350, N'SANTA RITA DE SIGUAS', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (351, N'SOCABAYA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (352, N'TIABAYA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (353, N'UCHUMAYO', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (354, N'VITOR', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (355, N'YANAHUARA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (356, N'YARABAMBA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (357, N'YURA', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (358, N'JOSE LUIS BUSTAMANTE Y RIVERO', 35)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (359, N'CAMANA', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (360, N'JOSE MARIA QUIMPER', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (361, N'MARIANO NICOLAS VALCARCEL', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (362, N'MARISCAL CACERES', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (363, N'NICOLAS DE PIEROLA', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (364, N'OCO&Ntilde;A', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (365, N'QUILCA', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (366, N'SAMUEL PASTOR', 36)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (367, N'CARAVELI', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (368, N'ACARI', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (369, N'ATICO', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (370, N'ATIQUIPA', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (371, N'BELLA UNION', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (372, N'CAHUACHO', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (373, N'CHALA', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (374, N'CHAPARRA', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (375, N'HUANUHUANU', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (376, N'JAQUI', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (377, N'LOMAS', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (378, N'QUICACHA', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (379, N'YAUCA', 37)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (380, N'APLAO', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (381, N'ANDAGUA', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (382, N'AYO', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (383, N'CHACHAS', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (384, N'CHILCAYMARCA', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (385, N'CHOCO', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (386, N'HUANCARQUI', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (387, N'MACHAGUAY', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (388, N'ORCOPAMPA', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (389, N'PAMPACOLCA', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (390, N'TIPAN', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (391, N'U&Ntilde;ON', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (392, N'URACA', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (393, N'VIRACO', 38)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (394, N'CHIVAY', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (395, N'ACHOMA', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (396, N'CABANACONDE', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (397, N'CALLALLI', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (398, N'CAYLLOMA', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (399, N'COPORAQUE', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (400, N'HUAMBO', 39)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (401, N'HUANCA', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (402, N'ICHUPAMPA', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (403, N'LARI', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (404, N'LLUTA', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (405, N'MACA', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (406, N'MADRIGAL', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (407, N'SAN ANTONIO DE CHUCA', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (408, N'SIBAYO', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (409, N'TAPAY', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (410, N'TISCO', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (411, N'TUTI', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (412, N'YANQUE', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (413, N'MAJES', 39)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (414, N'CHUQUIBAMBA', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (415, N'ANDARAY', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (416, N'CAYARANI', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (417, N'CHICHAS', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (418, N'IRAY', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (419, N'RIO GRANDE', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (420, N'SALAMANCA', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (421, N'YANAQUIHUA', 40)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (422, N'MOLLENDO', 41)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (423, N'COCACHACRA', 41)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (424, N'DEAN VALDIVIA', 41)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (425, N'ISLAY', 41)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (426, N'MEJIA', 41)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (427, N'PUNTA DE BOMBON', 41)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (428, N'COTAHUASI', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (429, N'ALCA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (430, N'CHARCANA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (431, N'HUAYNACOTAS', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (432, N'PAMPAMARCA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (433, N'PUYCA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (434, N'QUECHUALLA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (435, N'SAYLA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (436, N'TAURIA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (437, N'TOMEPAMPA', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (438, N'TORO', 42)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (439, N'AYACUCHO', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (440, N'ACOCRO', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (441, N'ACOS VINCHOS', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (442, N'CARMEN ALTO', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (443, N'CHIARA', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (444, N'OCROS', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (445, N'PACAYCASA', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (446, N'QUINUA', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (447, N'SAN JOSE DE TICLLAS', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (448, N'SAN JUAN BAUTISTA', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (449, N'SANTIAGO DE PISCHA', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (450, N'SOCOS', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (451, N'TAMBILLO', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (452, N'VINCHOS', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (453, N'JESUS NAZARENO', 43)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (454, N'CANGALLO', 44)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (455, N'CHUSCHI', 44)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (456, N'LOS MOROCHUCOS', 44)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (457, N'MARIA PARADO DE BELLIDO', 44)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (458, N'PARAS', 44)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (459, N'TOTOS', 44)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (460, N'SANCOS', 45)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (461, N'CARAPO', 45)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (462, N'SACSAMARCA', 45)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (463, N'SANTIAGO DE LUCANAMARCA', 45)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (464, N'HUANTA', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (465, N'AYAHUANCO', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (466, N'HUAMANGUILLA', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (467, N'IGUAIN', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (468, N'LURICOCHA', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (469, N'SANTILLANA', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (470, N'SIVIA', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (471, N'LLOCHEGUA', 46)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (472, N'SAN MIGUEL', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (473, N'ANCO', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (474, N'AYNA', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (475, N'CHILCAS', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (476, N'CHUNGUI', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (477, N'LUIS CARRANZA', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (478, N'SANTA ROSA', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (479, N'TAMBO', 47)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (480, N'PUQUIO', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (481, N'AUCARA', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (482, N'CABANA', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (483, N'CARMEN SALCEDO', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (484, N'CHAVI&Ntilde;A', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (485, N'CHIPAO', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (486, N'HUAC-HUAS', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (487, N'LARAMATE', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (488, N'LEONCIO PRADO', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (489, N'LLAUTA', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (490, N'LUCANAS', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (491, N'OCA&Ntilde;A', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (492, N'OTOCA', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (493, N'SAISA', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (494, N'SAN CRISTOBAL', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (495, N'SAN JUAN', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (496, N'SAN PEDRO', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (497, N'SAN PEDRO DE PALCO', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (498, N'SANCOS', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (499, N'SANTA ANA DE HUAYCAHUACHO', 48)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (500, N'SANTA LUCIA', 48)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (501, N'CORACORA', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (502, N'CHUMPI', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (503, N'CORONEL CASTA&Ntilde;EDA', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (504, N'PACAPAUSA', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (505, N'PULLO', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (506, N'PUYUSCA', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (507, N'SAN FRANCISCO DE RAVACAYCO', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (508, N'UPAHUACHO', 49)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (509, N'PAUSA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (510, N'COLTA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (511, N'CORCULLA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (512, N'LAMPA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (513, N'MARCABAMBA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (514, N'OYOLO', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (515, N'PARARCA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (516, N'SAN JAVIER DE ALPABAMBA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (517, N'SAN JOSE DE USHUA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (518, N'SARA SARA', 50)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (519, N'QUEROBAMBA', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (520, N'BELEN', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (521, N'CHALCOS', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (522, N'CHILCAYOC', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (523, N'HUACA&Ntilde;A', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (524, N'MORCOLLA', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (525, N'PAICO', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (526, N'SAN PEDRO DE LARCAY', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (527, N'SAN SALVADOR DE QUIJE', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (528, N'SANTIAGO DE PAUCARAY', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (529, N'SORAS', 51)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (530, N'HUANCAPI', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (531, N'ALCAMENCA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (532, N'APONGO', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (533, N'ASQUIPATA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (534, N'CANARIA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (535, N'CAYARA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (536, N'COLCA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (537, N'HUAMANQUIQUIA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (538, N'HUANCARAYLLA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (539, N'HUAYA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (540, N'SARHUA', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (541, N'VILCANCHOS', 52)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (542, N'VILCAS HUAMAN', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (543, N'ACCOMARCA', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (544, N'CARHUANCA', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (545, N'CONCEPCION', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (546, N'HUAMBALPA', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (547, N'INDEPENDENCIA', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (548, N'SAURAMA', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (549, N'VISCHONGO', 53)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (550, N'CAJAMARCA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (551, N'CAJAMARCA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (552, N'ASUNCION', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (553, N'CHETILLA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (554, N'COSPAN', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (555, N'ENCA&Ntilde;ADA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (556, N'JESUS', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (557, N'LLACANORA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (558, N'LOS BA&Ntilde;OS DEL INCA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (559, N'MAGDALENA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (560, N'MATARA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (561, N'NAMORA', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (562, N'SAN JUAN', 54)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (563, N'CAJABAMBA', 55)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (564, N'CACHACHI', 55)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (565, N'CONDEBAMBA', 55)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (566, N'SITACOCHA', 55)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (567, N'CELENDIN', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (568, N'CHUMUCH', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (569, N'CORTEGANA', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (570, N'HUASMIN', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (571, N'JORGE CHAVEZ', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (572, N'JOSE GALVEZ', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (573, N'MIGUEL IGLESIAS', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (574, N'OXAMARCA', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (575, N'SOROCHUCO', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (576, N'SUCRE', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (577, N'UTCO', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (578, N'LA LIBERTAD DE PALLAN', 56)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (579, N'CHOTA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (580, N'ANGUIA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (581, N'CHADIN', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (582, N'CHIGUIRIP', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (583, N'CHIMBAN', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (584, N'CHOROPAMPA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (585, N'COCHABAMBA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (586, N'CONCHAN', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (587, N'HUAMBOS', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (588, N'LAJAS', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (589, N'LLAMA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (590, N'MIRACOSTA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (591, N'PACCHA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (592, N'PION', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (593, N'QUEROCOTO', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (594, N'SAN JUAN DE LICUPIS', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (595, N'TACABAMBA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (596, N'TOCMOCHE', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (597, N'CHALAMARCA', 57)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (598, N'CONTUMAZA', 58)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (599, N'CHILETE', 58)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (600, N'CUPISNIQUE', 58)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (601, N'GUZMANGO', 58)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (602, N'SAN BENITO', 58)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (603, N'SANTA CRUZ DE TOLED', 58)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (604, N'TANTARICA', 58)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (605, N'YONAN', 58)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (606, N'CUTERVO', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (607, N'CALLAYUC', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (608, N'CHOROS', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (609, N'CUJILLO', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (610, N'LA RAMADA', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (611, N'PIMPINGOS', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (612, N'QUEROCOTILLO', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (613, N'SAN ANDRES DE CUTERVO', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (614, N'SAN JUAN DE CUTERVO', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (615, N'SAN LUIS DE LUCMA', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (616, N'SANTA CRUZ', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (617, N'SANTO DOMINGO DE LA CAPILLA', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (618, N'SANTO TOMAS', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (619, N'SOCOTA', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (620, N'TORIBIO CASANOVA', 59)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (621, N'BAMBAMARCA', 60)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (622, N'CHUGUR', 60)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (623, N'HUALGAYOC', 60)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (624, N'JAEN', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (625, N'BELLAVISTA', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (626, N'CHONTALI', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (627, N'COLASAY', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (628, N'HUABAL', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (629, N'LAS PIRIAS', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (630, N'POMAHUACA', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (631, N'PUCARA', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (632, N'SALLIQUE', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (633, N'SAN FELIPE', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (634, N'SAN JOSE DEL ALTO', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (635, N'SANTA ROSA', 61)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (636, N'SAN IGNACIO', 62)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (637, N'CHIRINOS', 62)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (638, N'HUARANGO', 62)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (639, N'LA COIPA', 62)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (640, N'NAMBALLE', 62)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (641, N'SAN JOSE DE LOURDES', 62)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (642, N'TABACONAS', 62)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (643, N'PEDRO GALVEZ', 63)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (644, N'CHANCAY', 63)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (645, N'EDUARDO VILLANUEVA', 63)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (646, N'GREGORIO PITA', 63)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (647, N'ICHOCAN', 63)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (648, N'JOSE MANUEL QUIROZ', 63)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (649, N'JOSE SABOGAL', 63)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (650, N'SAN MIGUEL', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (651, N'SAN MIGUEL', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (652, N'BOLIVAR', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (653, N'CALQUIS', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (654, N'CATILLUC', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (655, N'EL PRADO', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (656, N'LA FLORIDA', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (657, N'LLAPA', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (658, N'NANCHOC', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (659, N'NIEPOS', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (660, N'SAN GREGORIO', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (661, N'SAN SILVESTRE DE COCHAN', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (662, N'TONGOD', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (663, N'UNION AGUA BLANCA', 64)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (664, N'SAN PABLO', 65)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (665, N'SAN BERNARDINO', 65)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (666, N'SAN LUIS', 65)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (667, N'TUMBADEN', 65)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (668, N'SANTA CRUZ', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (669, N'ANDABAMBA', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (670, N'CATACHE', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (671, N'CHANCAYBA&Ntilde;OS', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (672, N'LA ESPERANZA', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (673, N'NINABAMBA', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (674, N'PULAN', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (675, N'SAUCEPAMPA', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (676, N'SEXI', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (677, N'UTICYACU', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (678, N'YAUYUCAN', 66)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (679, N'CALLAO', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (680, N'BELLAVISTA', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (681, N'CARMEN DE LA LEGUA REYNOSO', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (682, N'LA PERLA', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (683, N'LA PUNTA', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (684, N'VENTANILLA', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (685, N'CUSCO', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (686, N'CCORCA', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (687, N'POROY', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (688, N'SAN JERONIMO', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (689, N'SAN SEBASTIAN', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (690, N'SANTIAGO', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (691, N'SAYLLA', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (692, N'WANCHAQ', 67)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (693, N'ACOMAYO', 68)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (694, N'ACOPIA', 68)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (695, N'ACOS', 68)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (696, N'MOSOC LLACTA', 68)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (697, N'POMACANCHI', 68)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (698, N'RONDOCAN', 68)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (699, N'SANGARARA', 68)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (700, N'ANTA', 69)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (701, N'ANCAHUASI', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (702, N'CACHIMAYO', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (703, N'CHINCHAYPUJIO', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (704, N'HUAROCONDO', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (705, N'LIMATAMBO', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (706, N'MOLLEPATA', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (707, N'PUCYURA', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (708, N'ZURITE', 69)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (709, N'CALCA', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (710, N'COYA', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (711, N'LAMAY', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (712, N'LARES', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (713, N'PISAC', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (714, N'SAN SALVADOR', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (715, N'TARAY', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (716, N'YANATILE', 70)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (717, N'YANAOCA', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (718, N'CHECCA', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (719, N'KUNTURKANKI', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (720, N'LANGUI', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (721, N'LAYO', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (722, N'PAMPAMARCA', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (723, N'QUEHUE', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (724, N'TUPAC AMARU', 71)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (725, N'SICUANI', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (726, N'CHECACUPE', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (727, N'COMBAPATA', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (728, N'MARANGANI', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (729, N'PITUMARCA', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (730, N'SAN PABLO', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (731, N'SAN PEDRO', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (732, N'TINTA', 72)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (733, N'SANTO TOMAS', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (734, N'CAPACMARCA', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (735, N'CHAMACA', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (736, N'COLQUEMARCA', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (737, N'LIVITACA', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (738, N'LLUSCO', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (739, N'QUI&Ntilde;OTA', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (740, N'VELILLE', 73)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (741, N'ESPINAR', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (742, N'CONDOROMA', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (743, N'COPORAQUE', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (744, N'OCORURO', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (745, N'PALLPATA', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (746, N'PICHIGUA', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (747, N'SUYCKUTAMBO', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (748, N'ALTO PICHIGUA', 74)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (749, N'SANTA ANA', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (750, N'ECHARATE', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (751, N'HUAYOPATA', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (752, N'MARANURA', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (753, N'OCOBAMBA', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (754, N'QUELLOUNO', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (755, N'KIMBIRI', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (756, N'SANTA TERESA', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (757, N'VILCABAMBA', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (758, N'PICHARI', 75)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (759, N'PARURO', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (760, N'ACCHA', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (761, N'CCAPI', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (762, N'COLCHA', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (763, N'HUANOQUITE', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (764, N'OMACHA', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (765, N'PACCARITAMBO', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (766, N'PILLPINTO', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (767, N'YAURISQUE', 76)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (768, N'PAUCARTAMBO', 77)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (769, N'CAICAY', 77)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (770, N'CHALLABAMBA', 77)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (771, N'COLQUEPATA', 77)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (772, N'HUANCARANI', 77)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (773, N'KOS&Ntilde;IPATA', 77)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (774, N'URCOS', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (775, N'ANDAHUAYLILLAS', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (776, N'CAMANTI', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (777, N'CCARHUAYO', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (778, N'CCATCA', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (779, N'CUSIPATA', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (780, N'HUARO', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (781, N'LUCRE', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (782, N'MARCAPATA', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (783, N'OCONGATE', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (784, N'OROPESA', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (785, N'QUIQUIJANA', 78)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (786, N'URUBAMBA', 79)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (787, N'CHINCHERO', 79)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (788, N'HUAYLLABAMBA', 79)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (789, N'MACHUPICCHU', 79)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (790, N'MARAS', 79)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (791, N'OLLANTAYTAMBO', 79)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (792, N'YUCAY', 79)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (793, N'HUANCAVELICA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (794, N'ACOBAMBILLA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (795, N'ACORIA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (796, N'CONAYCA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (797, N'CUENCA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (798, N'HUACHOCOLPA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (799, N'HUAYLLAHUARA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (800, N'IZCUCHACA', 80)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (801, N'LARIA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (802, N'MANTA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (803, N'MARISCAL CACERES', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (804, N'MOYA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (805, N'NUEVO OCCORO', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (806, N'PALCA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (807, N'PILCHACA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (808, N'VILCA', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (809, N'YAULI', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (810, N'ASCENSION', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (811, N'HUANDO', 80)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (812, N'ACOBAMBA', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (813, N'ANDABAMBA', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (814, N'ANTA', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (815, N'CAJA', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (816, N'MARCAS', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (817, N'PAUCARA', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (818, N'POMACOCHA', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (819, N'ROSARIO', 81)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (820, N'LIRCAY', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (821, N'ANCHONGA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (822, N'CALLANMARCA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (823, N'CCOCHACCASA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (824, N'CHINCHO', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (825, N'CONGALLA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (826, N'HUANCA-HUANCA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (827, N'HUAYLLAY GRANDE', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (828, N'JULCAMARCA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (829, N'SAN ANTONIO DE ANTAPARCO', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (830, N'SANTO TOMAS DE PATA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (831, N'SECCLLA', 82)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (832, N'CASTROVIRREYNA', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (833, N'ARMA', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (834, N'AURAHUA', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (835, N'CAPILLAS', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (836, N'CHUPAMARCA', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (837, N'COCAS', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (838, N'HUACHOS', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (839, N'HUAMATAMBO', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (840, N'MOLLEPAMPA', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (841, N'SAN JUAN', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (842, N'SANTA ANA', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (843, N'TANTARA', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (844, N'TICRAPO', 83)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (845, N'CHURCAMPA', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (846, N'ANCO', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (847, N'CHINCHIHUASI', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (848, N'EL CARMEN', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (849, N'LA MERCED', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (850, N'LOCROJA', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (851, N'PAUCARBAMBA', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (852, N'SAN MIGUEL DE MAYOCC', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (853, N'SAN PEDRO DE CORIS', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (854, N'PACHAMARCA', 84)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (855, N'HUAYTARA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (856, N'AYAVI', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (857, N'CORDOVA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (858, N'HUAYACUNDO ARMA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (859, N'LARAMARCA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (860, N'OCOYO', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (861, N'PILPICHACA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (862, N'QUERCO', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (863, N'QUITO-ARMA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (864, N'SAN ANTONIO DE CUSICANCHA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (865, N'SAN FRANCISCO DE SANGAYAICO', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (866, N'SAN ISIDRO', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (867, N'SANTIAGO DE CHOCORVOS', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (868, N'SANTIAGO DE QUIRAHUARA', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (869, N'SANTO DOMINGO DE CAPILLAS', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (870, N'TAMBO', 85)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (871, N'PAMPAS', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (872, N'ACOSTAMBO', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (873, N'ACRAQUIA', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (874, N'AHUAYCHA', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (875, N'COLCABAMBA', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (876, N'DANIEL HERNANDEZ', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (877, N'HUACHOCOLPA', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (878, N'HUARIBAMBA', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (879, N'&Ntilde;AHUIMPUQUIO', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (880, N'PAZOS', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (881, N'QUISHUAR', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (882, N'SALCABAMBA', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (883, N'SALCAHUASI', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (884, N'SAN MARCOS DE ROCCHAC', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (885, N'SURCUBAMBA', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (886, N'TINTAY PUNCU', 86)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (887, N'HUANUCO', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (888, N'AMARILIS', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (889, N'CHINCHAO', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (890, N'CHURUBAMBA', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (891, N'MARGOS', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (892, N'QUISQUI', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (893, N'SAN FRANCISCO DE CAYRAN', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (894, N'SAN PEDRO DE CHAULAN', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (895, N'SANTA MARIA DEL VALLE', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (896, N'YARUMAYO', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (897, N'PILLCO MARCA', 87)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (898, N'AMBO', 88)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (899, N'CAYNA', 88)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (900, N'COLPAS', 88)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (901, N'CONCHAMARCA', 88)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (902, N'HUACAR', 88)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (903, N'SAN FRANCISCO', 88)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (904, N'SAN RAFAEL', 88)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (905, N'TOMAY KICHWA', 88)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (906, N'LA UNION', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (907, N'CHUQUIS', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (908, N'MARIAS', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (909, N'PACHAS', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (910, N'QUIVILLA', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (911, N'RIPAN', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (912, N'SHUNQUI', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (913, N'SILLAPATA', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (914, N'YANAS', 89)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (915, N'HUACAYBAMBA', 90)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (916, N'CANCHABAMBA', 90)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (917, N'COCHABAMBA', 90)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (918, N'PINRA', 90)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (919, N'LLATA', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (920, N'ARANCAY', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (921, N'CHAVIN DE PARIARCA', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (922, N'JACAS GRANDE', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (923, N'JIRCAN', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (924, N'MIRAFLORES', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (925, N'MONZON', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (926, N'PUNCHAO', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (927, N'PU&Ntilde;OS', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (928, N'SINGA', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (929, N'TANTAMAYO', 91)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (930, N'RUPA-RUPA', 92)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (931, N'DANIEL ALOMIA ROBLES', 92)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (932, N'HERMILIO VALDIZAN', 92)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (933, N'JOSE CRESPO Y CASTILLO', 92)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (934, N'LUYANDO', 92)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (935, N'MARIANO DAMASO BERAUN', 92)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (936, N'HUACRACHUCO', 93)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (937, N'CHOLON', 93)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (938, N'SAN BUENAVENTURA', 93)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (939, N'PANAO', 94)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (940, N'CHAGLLA', 94)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (941, N'MOLINO', 94)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (942, N'UMARI', 94)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (943, N'PUERTO INCA', 95)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (944, N'CODO DEL POZUZO', 95)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (945, N'HONORIA', 95)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (946, N'TOURNAVISTA', 95)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (947, N'YUYAPICHIS', 95)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (948, N'JESUS', 96)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (949, N'BA&Ntilde;OS', 96)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (950, N'JIVIA', 96)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (951, N'QUEROPALCA', 96)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (952, N'RONDOS', 96)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (953, N'SAN FRANCISCO DE ASIS', 96)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (954, N'SAN MIGUEL DE CAURI', 96)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (955, N'CHAVINILLO', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (956, N'CAHUAC', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (957, N'CHACABAMBA', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (958, N'APARICIO POMARES', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (959, N'JACAS CHICO', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (960, N'OBAS', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (961, N'PAMPAMARCA', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (962, N'CHORAS', 97)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (963, N'ICA', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (964, N'LA TINGUI&Ntilde;A', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (965, N'LOS AQUIJES', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (966, N'OCUCAJE', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (967, N'PACHACUTEC', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (968, N'PARCONA', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (969, N'PUEBLO NUEVO', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (970, N'SALAS', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (971, N'SAN JOSE DE LOS MOLINOS', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (972, N'SAN JUAN BAUTISTA', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (973, N'SANTIAGO', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (974, N'SUBTANJALLA', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (975, N'TATE', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (976, N'YAUCA DEL ROSARIO', 98)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (977, N'CHINCHA ALTA', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (978, N'ALTO LARAN', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (979, N'CHAVIN', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (980, N'CHINCHA BAJA', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (981, N'EL CARMEN', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (982, N'GROCIO PRADO', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (983, N'PUEBLO NUEVO', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (984, N'SAN JUAN DE YANAC', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (985, N'SAN PEDRO DE HUACARPANA', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (986, N'SUNAMPE', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (987, N'TAMBO DE MORA', 99)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (988, N'NAZCA', 100)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (989, N'CHANGUILLO', 100)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (990, N'EL INGENIO', 100)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (991, N'MARCONA', 100)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (992, N'VISTA ALEGRE', 100)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (993, N'PALPA', 101)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (994, N'LLIPATA', 101)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (995, N'RIO GRANDE', 101)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (996, N'SANTA CRUZ', 101)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (997, N'TIBILLO', 101)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (998, N'PISCO', 102)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (999, N'HUANCANO', 102)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1000, N'HUMAY', 102)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1001, N'INDEPENDENCIA', 102)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1002, N'PARACAS', 102)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1003, N'SAN ANDRES', 102)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1004, N'SAN CLEMENTE', 102)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1005, N'TUPAC AMARU INCA', 102)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1006, N'HUANCAYO', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1007, N'CARHUACALLANGA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1008, N'CHACAPAMPA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1009, N'CHICCHE', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1010, N'CHILCA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1011, N'CHONGOS ALTO', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1012, N'CHUPURO', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1013, N'COLCA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1014, N'CULLHUAS', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1015, N'EL TAMBO', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1016, N'HUACRAPUQUIO', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1017, N'HUALHUAS', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1018, N'HUANCAN', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1019, N'HUASICANCHA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1020, N'HUAYUCACHI', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1021, N'INGENIO', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1022, N'PARIAHUANCA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1023, N'PILCOMAYO', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1024, N'PUCARA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1025, N'QUICHUAY', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1026, N'QUILCAS', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1027, N'SAN AGUSTIN', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1028, N'SAN JERONIMO DE TUNAN', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1029, N'SA&Ntilde;O', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1030, N'SAPALLANGA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1031, N'SICAYA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1032, N'SANTO DOMINGO DE ACOBAMBA', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1033, N'VIQUES', 103)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1034, N'CONCEPCION', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1035, N'ACO', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1036, N'ANDAMARCA', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1037, N'CHAMBARA', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1038, N'COCHAS', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1039, N'COMAS', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1040, N'HEROINAS TOLEDO', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1041, N'MANZANARES', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1042, N'MARISCAL CASTILLA', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1043, N'MATAHUASI', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1044, N'MITO', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1045, N'NUEVE DE JULIO', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1046, N'ORCOTUNA', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1047, N'SAN JOSE DE QUERO', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1048, N'SANTA ROSA DE OCOPA', 104)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1049, N'CHANCHAMAYO', 105)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1050, N'PERENE', 105)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1051, N'PICHANAQUI', 105)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1052, N'SAN LUIS DE SHUARO', 105)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1053, N'SAN RAMON', 105)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1054, N'VITOC', 105)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1055, N'JAUJA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1056, N'ACOLLA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1057, N'APATA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1058, N'ATAURA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1059, N'CANCHAYLLO', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1060, N'CURICACA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1061, N'EL MANTARO', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1062, N'HUAMALI', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1063, N'HUARIPAMPA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1064, N'HUERTAS', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1065, N'JANJAILLO', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1066, N'JULCAN', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1067, N'LEONOR ORDO&Ntilde;EZ', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1068, N'LLOCLLAPAMPA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1069, N'MARCO', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1070, N'MASMA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1071, N'MASMA CHICCHE', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1072, N'MOLINOS', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1073, N'MONOBAMBA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1074, N'MUQUI', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1075, N'MUQUIYAUYO', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1076, N'PACA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1077, N'PACCHA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1078, N'PANCAN', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1079, N'PARCO', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1080, N'POMACANCHA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1081, N'RICRAN', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1082, N'SAN LORENZO', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1083, N'SAN PEDRO DE CHUNAN', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1084, N'SAUSA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1085, N'SINCOS', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1086, N'TUNAN MARCA', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1087, N'YAULI', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1088, N'YAUYOS', 106)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1089, N'JUNIN', 107)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1090, N'CARHUAMAYO', 107)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1091, N'ONDORES', 107)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1092, N'ULCUMAYO', 107)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1093, N'SATIPO', 108)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1094, N'COVIRIALI', 108)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1095, N'LLAYLLA', 108)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1096, N'MAZAMARI', 108)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1097, N'PAMPA HERMOSA', 108)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1098, N'PANGOA', 108)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1099, N'RIO NEGRO', 108)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1100, N'RIO TAMBO', 108)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1101, N'TARMA', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1102, N'ACOBAMBA', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1103, N'HUARICOLCA', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1104, N'HUASAHUASI', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1105, N'LA UNION', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1106, N'PALCA', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1107, N'PALCAMAYO', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1108, N'SAN PEDRO DE CAJAS', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1109, N'TAPO', 109)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1110, N'LA OROYA', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1111, N'CHACAPALPA', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1112, N'HUAY-HUAY', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1113, N'MARCAPOMACOCHA', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1114, N'MOROCOCHA', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1115, N'PACCHA', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1116, N'SANTA BARBARA DE CARHUACAYAN', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1117, N'SANTA ROSA DE SACCO', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1118, N'SUITUCANCHA', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1119, N'YAULI', 110)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1120, N'CHUPACA', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1121, N'AHUAC', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1122, N'CHONGOS BAJO', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1123, N'HUACHAC', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1124, N'HUAMANCACA CHICO', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1125, N'SAN JUAN DE ISCOS', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1126, N'SAN JUAN DE JARPA', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1127, N'TRES DE DICIEMBRE', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1128, N'YANACANCHA', 111)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1129, N'TRUJILLO', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1130, N'EL PORVENIR', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1131, N'FLORENCIA DE MORA', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1132, N'HUANCHACO', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1133, N'LA ESPERANZA', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1134, N'LAREDO', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1135, N'MOCHE', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1136, N'POROTO', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1137, N'SALAVERRY', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1138, N'SIMBAL', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1139, N'VICTOR LARCO HERRERA', 112)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1140, N'ASCOPE', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1141, N'CHICAMA', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1142, N'CHOCOPE', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1143, N'MAGDALENA DE CAO', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1144, N'PAIJAN', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1145, N'RAZURI', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1146, N'SANTIAGO DE CAO', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1147, N'CASA GRANDE', 113)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1148, N'BOLIVAR', 114)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1149, N'BAMBAMARCA', 114)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1150, N'CONDORMARCA', 114)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1151, N'LONGOTEA', 114)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1152, N'UCHUMARCA', 114)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1153, N'UCUNCHA', 114)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1154, N'CHEPEN', 115)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1155, N'PACANGA', 115)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1156, N'PUEBLO NUEVO', 115)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1157, N'JULCAN', 116)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1158, N'CALAMARCA', 116)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1159, N'CARABAMBA', 116)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1160, N'HUASO', 116)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1161, N'OTUZCO', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1162, N'AGALLPAMPA', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1163, N'CHARAT', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1164, N'HUARANCHAL', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1165, N'LA CUESTA', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1166, N'MACHE', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1167, N'PARANDAY', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1168, N'SALPO', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1169, N'SINSICAP', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1170, N'USQUIL', 117)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1171, N'SAN PEDRO DE LLOC', 118)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1172, N'GUADALUPE', 118)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1173, N'JEQUETEPEQUE', 118)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1174, N'PACASMAYO', 118)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1175, N'SAN JOSE', 118)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1176, N'TAYABAMBA', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1177, N'BULDIBUYO', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1178, N'CHILLIA', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1179, N'HUANCASPATA', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1180, N'HUAYLILLAS', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1181, N'HUAYO', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1182, N'ONGON', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1183, N'PARCOY', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1184, N'PATAZ', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1185, N'PIAS', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1186, N'SANTIAGO DE CHALLAS', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1187, N'TAURIJA', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1188, N'URPAY', 119)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1189, N'HUAMACHUCO', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1190, N'CHUGAY', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1191, N'COCHORCO', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1192, N'CURGOS', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1193, N'MARCABAL', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1194, N'SANAGORAN', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1195, N'SARIN', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1196, N'SARTIMBAMBA', 120)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1197, N'SANTIAGO DE CHUCO', 121)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1198, N'ANGASMARCA', 121)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1199, N'CACHICADAN', 121)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1200, N'MOLLEBAMBA', 121)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1201, N'MOLLEPATA', 121)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1202, N'QUIRUVILCA', 121)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1203, N'SANTA CRUZ DE CHUCA', 121)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1204, N'SITABAMBA', 121)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1205, N'GRAN CHIMU', 122)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1206, N'CASCAS', 122)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1207, N'LUCMA', 122)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1208, N'MARMOT', 122)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1209, N'SAYAPULLO', 122)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1210, N'VIRU', 123)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1211, N'CHAO', 123)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1212, N'GUADALUPITO', 123)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1213, N'CHICLAYO', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1214, N'CHONGOYAPE', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1215, N'ETEN', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1216, N'ETEN PUERTO', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1217, N'JOSE LEONARDO ORTIZ', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1218, N'LA VICTORIA', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1219, N'LAGUNAS', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1220, N'MONSEFU', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1221, N'NUEVA ARICA', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1222, N'OYOTUN', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1223, N'PICSI', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1224, N'PIMENTEL', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1225, N'REQUE', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1226, N'SANTA ROSA', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1227, N'SA&Ntilde;A', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1228, N'CAYALTI', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1229, N'PATAPO', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1230, N'POMALCA', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1231, N'PUCALA', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1232, N'TUMAN', 124)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1233, N'FERRE&Ntilde;AFE', 125)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1234, N'CA&Ntilde;ARIS', 125)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1235, N'INCAHUASI', 125)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1236, N'MANUEL ANTONIO MESONES MURO', 125)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1237, N'PITIPO', 125)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1238, N'PUEBLO NUEVO', 125)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1239, N'LAMBAYEQUE', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1240, N'CHOCHOPE', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1241, N'ILLIMO', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1242, N'JAYANCA', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1243, N'MOCHUMI', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1244, N'MORROPE', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1245, N'MOTUPE', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1246, N'OLMOS', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1247, N'PACORA', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1248, N'SALAS', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1249, N'SAN JOSE', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1250, N'TUCUME', 126)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1251, N'LIMA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1252, N'ANCON', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1253, N'ATE', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1254, N'BARRANCO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1255, N'BRE&Ntilde;A', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1256, N'CARABAYLLO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1257, N'CHACLACAYO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1258, N'CHORRILLOS', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1259, N'CIENEGUILLA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1260, N'COMAS', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1261, N'EL AGUSTINO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1262, N'INDEPENDENCIA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1263, N'JESUS MARIA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1264, N'LA MOLINA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1265, N'LA VICTORIA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1266, N'LINCE', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1267, N'LOS OLIVOS', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1268, N'LURIGANCHO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1269, N'LURIN', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1270, N'MAGDALENA DEL MAR', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1271, N'MAGDALENA VIEJA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1272, N'MIRAFLORES', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1273, N'PACHACAMAC', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1274, N'PUCUSANA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1275, N'PUENTE PIEDRA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1276, N'PUNTA HERMOSA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1277, N'PUNTA NEGRA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1278, N'RIMAC', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1279, N'SAN BARTOLO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1280, N'SAN BORJA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1281, N'SAN ISIDRO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1282, N'SAN JUAN DE LURIGANCHO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1283, N'SAN JUAN DE MIRAFLORES', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1284, N'SAN LUIS', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1285, N'SAN MARTIN DE PORRES', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1286, N'SAN MIGUEL', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1287, N'SANTA ANITA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1288, N'SANTA MARIA DEL MAR', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1289, N'SANTA ROSA', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1290, N'SANTIAGO DE SURCO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1291, N'SURQUILLO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1292, N'VILLA EL SALVADOR', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1293, N'VILLA MARIA DEL TRIUNFO', 127)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1294, N'BARRANCA', 128)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1295, N'PARAMONGA', 128)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1296, N'PATIVILCA', 128)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1297, N'SUPE', 128)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1298, N'SUPE PUERTO', 128)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1299, N'CAJATAMBO', 129)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1300, N'COPA', 129)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1301, N'GORGOR', 129)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1302, N'HUANCAPON', 129)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1303, N'MANAS', 129)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1304, N'CANTA', 130)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1305, N'ARAHUAY', 130)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1306, N'HUAMANTANGA', 130)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1307, N'HUAROS', 130)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1308, N'LACHAQUI', 130)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1309, N'SAN BUENAVENTURA', 130)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1310, N'SANTA ROSA DE QUIVES', 130)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1311, N'SAN VICENTE DE CA&Ntilde;ETE', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1312, N'ASIA', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1313, N'CALANGO', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1314, N'CERRO AZUL', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1315, N'CHILCA', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1316, N'COAYLLO', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1317, N'IMPERIAL', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1318, N'LUNAHUANA', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1319, N'MALA', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1320, N'NUEVO IMPERIAL', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1321, N'PACARAN', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1322, N'QUILMANA', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1323, N'SAN ANTONIO', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1324, N'SAN LUIS', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1325, N'SANTA CRUZ DE FLORES', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1326, N'ZU&Ntilde;IGA', 131)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1327, N'HUARAL', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1328, N'ATAVILLOS ALTO', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1329, N'ATAVILLOS BAJO', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1330, N'AUCALLAMA', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1331, N'CHANCAY', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1332, N'IHUARI', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1333, N'LAMPIAN', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1334, N'PACARAOS', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1335, N'SAN MIGUEL DE ACOS', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1336, N'SANTA CRUZ DE ANDAMARCA', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1337, N'SUMBILCA', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1338, N'VEINTISIETE DE NOVIEMBRE', 132)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1339, N'MATUCANA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1340, N'ANTIOQUIA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1341, N'CALLAHUANCA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1342, N'CARAMPOMA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1343, N'CHICLA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1344, N'CUENCA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1345, N'HUACHUPAMPA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1346, N'HUANZA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1347, N'HUAROCHIRI', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1348, N'LAHUAYTAMBO', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1349, N'LANGA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1350, N'LARAOS', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1351, N'MARIATANA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1352, N'RICARDO PALMA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1353, N'SAN ANDRES DE TUPICOCHA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1354, N'SAN ANTONIO', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1355, N'SAN BARTOLOME', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1356, N'SAN DAMIAN', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1357, N'SAN JUAN DE IRIS', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1358, N'SAN JUAN DE TANTARANCHE', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1359, N'SAN LORENZO DE QUINTI', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1360, N'SAN MATEO', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1361, N'SAN MATEO DE OTAO', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1362, N'SAN PEDRO DE CASTA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1363, N'SAN PEDRO DE HUANCAYRE', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1364, N'SANGALLAYA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1365, N'SANTA CRUZ DE COCACHACRA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1366, N'SANTA EULALIA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1367, N'SANTIAGO DE ANCHUCAYA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1368, N'SANTIAGO DE TUNA', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1369, N'SANTO DOMINGO DE LOS OLLEROS', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1370, N'SURCO', 133)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1371, N'HUACHO', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1372, N'AMBAR', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1373, N'CALETA DE CARQUIN', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1374, N'CHECRAS', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1375, N'HUALMAY', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1376, N'HUAURA', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1377, N'LEONCIO PRADO', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1378, N'PACCHO', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1379, N'SANTA LEONOR', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1380, N'SANTA MARIA', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1381, N'SAYAN', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1382, N'VEGUETA', 134)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1383, N'OYON', 135)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1384, N'ANDAJES', 135)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1385, N'CAUJUL', 135)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1386, N'COCHAMARCA', 135)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1387, N'NAVAN', 135)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1388, N'PACHANGARA', 135)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1389, N'YAUYOS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1390, N'ALIS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1391, N'AYAUCA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1392, N'AYAVIRI', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1393, N'AZANGARO', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1394, N'CACRA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1395, N'CARANIA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1396, N'CATAHUASI', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1397, N'CHOCOS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1398, N'COCHAS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1399, N'COLONIA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1400, N'HONGOS', 136)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1401, N'HUAMPARA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1402, N'HUANCAYA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1403, N'HUANGASCAR', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1404, N'HUANTAN', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1405, N'HUA&Ntilde;EC', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1406, N'LARAOS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1407, N'LINCHA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1408, N'MADEAN', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1409, N'MIRAFLORES', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1410, N'OMAS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1411, N'PUTINZA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1412, N'QUINCHES', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1413, N'QUINOCAY', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1414, N'SAN JOAQUIN', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1415, N'SAN PEDRO DE PILAS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1416, N'TANTA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1417, N'TAURIPAMPA', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1418, N'TOMAS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1419, N'TUPE', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1420, N'VI&Ntilde;AC', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1421, N'VITIS', 136)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1422, N'IQUITOS', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1423, N'ALTO NANAY', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1424, N'FERNANDO LORES', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1425, N'INDIANA', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1426, N'LAS AMAZONAS', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1427, N'MAZAN', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1428, N'NAPO', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1429, N'PUNCHANA', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1430, N'PUTUMAYO', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1431, N'TORRES CAUSANA', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1432, N'BELEN', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1433, N'SAN JUAN BAUTISTA', 137)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1434, N'YURIMAGUAS', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1435, N'BALSAPUERTO', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1436, N'BARRANCA', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1437, N'CAHUAPANAS', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1438, N'JEBEROS', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1439, N'LAGUNAS', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1440, N'MANSERICHE', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1441, N'MORONA', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1442, N'PASTAZA', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1443, N'SANTA CRUZ', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1444, N'TENIENTE CESAR LOPEZ ROJAS', 138)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1445, N'NAUTA', 139)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1446, N'PARINARI', 139)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1447, N'TIGRE', 139)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1448, N'TROMPETEROS', 139)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1449, N'URARINAS', 139)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1450, N'RAMON CASTILLA', 140)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1451, N'PEBAS', 140)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1452, N'YAVARI', 140)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1453, N'SAN PABLO', 140)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1454, N'REQUENA', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1455, N'ALTO TAPICHE', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1456, N'CAPELO', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1457, N'EMILIO SAN MARTIN', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1458, N'MAQUIA', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1459, N'PUINAHUA', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1460, N'SAQUENA', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1461, N'SOPLIN', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1462, N'TAPICHE', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1463, N'JENARO HERRERA', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1464, N'YAQUERANA', 141)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1465, N'CONTAMANA', 142)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1466, N'INAHUAYA', 142)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1467, N'PADRE MARQUEZ', 142)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1468, N'PAMPA HERMOSA', 142)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1469, N'SARAYACU', 142)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1470, N'VARGAS GUERRA', 142)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1471, N'TAMBOPATA', 143)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1472, N'INAMBARI', 143)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1473, N'LAS PIEDRAS', 143)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1474, N'LABERINTO', 143)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1475, N'MANU', 144)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1476, N'FITZCARRALD', 144)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1477, N'MADRE DE DIOS', 144)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1478, N'HUEPETUHE', 144)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1479, N'I&Ntilde;APARI', 145)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1480, N'IBERIA', 145)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1481, N'TAHUAMANU', 145)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1482, N'MOQUEGUA', 146)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1483, N'CARUMAS', 146)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1484, N'CUCHUMBAYA', 146)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1485, N'SAMEGUA', 146)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1486, N'SAN CRISTOBAL', 146)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1487, N'TORATA', 146)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1488, N'OMATE', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1489, N'CHOJATA', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1490, N'COALAQUE', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1491, N'ICHU&Ntilde;A', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1492, N'LA CAPILLA', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1493, N'LLOQUE', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1494, N'MATALAQUE', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1495, N'PUQUINA', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1496, N'QUINISTAQUILLAS', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1497, N'UBINAS', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1498, N'YUNGA', 147)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1499, N'ILO', 148)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1500, N'EL ALGARROBAL', 148)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1501, N'PACOCHA', 148)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1502, N'CHAUPIMARCA', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1503, N'HUACHON', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1504, N'HUARIACA', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1505, N'HUAYLLAY', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1506, N'NINACACA', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1507, N'PALLANCHACRA', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1508, N'PAUCARTAMBO', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1509, N'SAN FCO.DE ASIS DE YARUSYACAN', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1510, N'SIMON BOLIVAR', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1511, N'TICLACAYAN', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1512, N'TINYAHUARCO', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1513, N'VICCO', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1514, N'YANACANCHA', 149)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1515, N'YANAHUANCA', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1516, N'CHACAYAN', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1517, N'GOYLLARISQUIZGA', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1518, N'PAUCAR', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1519, N'SAN PEDRO DE PILLAO', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1520, N'SANTA ANA DE TUSI', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1521, N'TAPUC', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1522, N'VILCABAMBA', 150)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1523, N'OXAPAMPA', 151)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1524, N'CHONTABAMBA', 151)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1525, N'HUANCABAMBA', 151)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1526, N'PALCAZU', 151)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1527, N'POZUZO', 151)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1528, N'PUERTO BERMUDEZ', 151)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1529, N'VILLA RICA', 151)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1530, N'PIURA', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1531, N'CASTILLA', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1532, N'CATACAOS', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1533, N'CURA MORI', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1534, N'EL TALLAN', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1535, N'LA ARENA', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1536, N'LA UNION', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1537, N'LAS LOMAS', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1538, N'TAMBO GRANDE', 152)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1539, N'AYABACA', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1540, N'FRIAS', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1541, N'JILILI', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1542, N'LAGUNAS', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1543, N'MONTERO', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1544, N'PACAIPAMPA', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1545, N'PAIMAS', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1546, N'SAPILLICA', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1547, N'SICCHEZ', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1548, N'SUYO', 153)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1549, N'HUANCABAMBA', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1550, N'CANCHAQUE', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1551, N'EL CARMEN DE LA FRONTERA', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1552, N'HUARMACA', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1553, N'LALAQUIZ', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1554, N'SAN MIGUEL DE EL FAIQUE', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1555, N'SONDOR', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1556, N'SONDORILLO', 154)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1557, N'CHULUCANAS', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1558, N'BUENOS AIRES', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1559, N'CHALACO', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1560, N'LA MATANZA', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1561, N'MORROPON', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1562, N'SALITRAL', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1563, N'SAN JUAN DE BIGOTE', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1564, N'SANTA CATALINA DE MOSSA', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1565, N'SANTO DOMINGO', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1566, N'YAMANGO', 155)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1567, N'PAITA', 156)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1568, N'AMOTAPE', 156)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1569, N'ARENAL', 156)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1570, N'COLAN', 156)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1571, N'LA HUACA', 156)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1572, N'TAMARINDO', 156)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1573, N'VICHAYAL', 156)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1574, N'SULLANA', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1575, N'BELLAVISTA', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1576, N'IGNACIO ESCUDERO', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1577, N'LANCONES', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1578, N'MARCAVELICA', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1579, N'MIGUEL CHECA', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1580, N'QUERECOTILLO', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1581, N'SALITRAL', 157)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1582, N'PARI&Ntilde;AS', 158)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1583, N'EL ALTO', 158)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1584, N'LA BREA', 158)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1585, N'LOBITOS', 158)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1586, N'LOS ORGANOS', 158)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1587, N'MANCORA', 158)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1588, N'SECHURA', 159)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1589, N'BELLAVISTA DE LA UNION', 159)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1590, N'BERNAL', 159)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1591, N'CRISTO NOS VALGA', 159)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1592, N'VICE', 159)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1593, N'RINCONADA LLICUAR', 159)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1594, N'PUNO', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1595, N'ACORA', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1596, N'AMANTANI', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1597, N'ATUNCOLLA', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1598, N'CAPACHICA', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1599, N'CHUCUITO', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1600, N'COATA', 160)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1601, N'HUATA', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1602, N'MA&Ntilde;AZO', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1603, N'PAUCARCOLLA', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1604, N'PICHACANI', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1605, N'PLATERIA', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1606, N'SAN ANTONIO', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1607, N'TIQUILLACA', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1608, N'VILQUE', 160)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1609, N'AZANGARO', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1610, N'ACHAYA', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1611, N'ARAPA', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1612, N'ASILLO', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1613, N'CAMINACA', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1614, N'CHUPA', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1615, N'JOSE DOMINGO CHOQUEHUANCA', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1616, N'MU&Ntilde;ANI', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1617, N'POTONI', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1618, N'SAMAN', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1619, N'SAN ANTON', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1620, N'SAN JOSE', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1621, N'SAN JUAN DE SALINAS', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1622, N'SANTIAGO DE PUPUJA', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1623, N'TIRAPATA', 161)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1624, N'MACUSANI', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1625, N'AJOYANI', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1626, N'AYAPATA', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1627, N'COASA', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1628, N'CORANI', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1629, N'CRUCERO', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1630, N'ITUATA', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1631, N'OLLACHEA', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1632, N'SAN GABAN', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1633, N'USICAYOS', 162)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1634, N'JULI', 163)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1635, N'DESAGUADERO', 163)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1636, N'HUACULLANI', 163)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1637, N'KELLUYO', 163)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1638, N'PISACOMA', 163)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1639, N'POMATA', 163)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1640, N'ZEPITA', 163)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1641, N'ILAVE', 164)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1642, N'CAPAZO', 164)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1643, N'PILCUYO', 164)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1644, N'SANTA ROSA', 164)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1645, N'CONDURIRI', 164)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1646, N'HUANCANE', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1647, N'COJATA', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1648, N'HUATASANI', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1649, N'INCHUPALLA', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1650, N'PUSI', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1651, N'ROSASPATA', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1652, N'TARACO', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1653, N'VILQUE CHICO', 165)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1654, N'LAMPA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1655, N'CABANILLA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1656, N'CALAPUJA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1657, N'NICASIO', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1658, N'OCUVIRI', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1659, N'PALCA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1660, N'PARATIA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1661, N'PUCARA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1662, N'SANTA LUCIA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1663, N'VILAVILA', 166)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1664, N'AYAVIRI', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1665, N'ANTAUTA', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1666, N'CUPI', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1667, N'LLALLI', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1668, N'MACARI', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1669, N'NU&Ntilde;OA', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1670, N'ORURILLO', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1671, N'SANTA ROSA', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1672, N'UMACHIRI', 167)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1673, N'MOHO', 168)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1674, N'CONIMA', 168)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1675, N'HUAYRAPATA', 168)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1676, N'TILALI', 168)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1677, N'PUTINA', 169)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1678, N'ANANEA', 169)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1679, N'PEDRO VILCA APAZA', 169)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1680, N'QUILCAPUNCU', 169)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1681, N'SINA', 169)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1682, N'JULIACA', 170)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1683, N'CABANA', 170)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1684, N'CABANILLAS', 170)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1685, N'CARACOTO', 170)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1686, N'SANDIA', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1687, N'CUYOCUYO', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1688, N'LIMBANI', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1689, N'PATAMBUCO', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1690, N'PHARA', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1691, N'QUIACA', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1692, N'SAN JUAN DEL ORO', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1693, N'YANAHUAYA', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1694, N'ALTO INAMBARI', 171)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1695, N'YUNGUYO', 172)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1696, N'ANAPIA', 172)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1697, N'COPANI', 172)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1698, N'CUTURAPI', 172)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1699, N'OLLARAYA', 172)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1700, N'TINICACHI', 172)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1701, N'UNICACHI', 172)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1702, N'MOYOBAMBA', 173)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1703, N'CALZADA', 173)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1704, N'HABANA', 173)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1705, N'JEPELACIO', 173)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1706, N'SORITOR', 173)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1707, N'YANTALO', 173)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1708, N'BELLAVISTA', 174)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1709, N'ALTO BIAVO', 174)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1710, N'BAJO BIAVO', 174)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1711, N'HUALLAGA', 174)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1712, N'SAN PABLO', 174)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1713, N'SAN RAFAEL', 174)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1714, N'SAN JOSE DE SISA', 175)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1715, N'AGUA BLANCA', 175)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1716, N'SAN MARTIN', 175)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1717, N'SANTA ROSA', 175)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1718, N'SHATOJA', 175)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1719, N'SAPOSOA', 176)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1720, N'ALTO SAPOSOA', 176)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1721, N'EL ESLABON', 176)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1722, N'PISCOYACU', 176)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1723, N'SACANCHE', 176)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1724, N'TINGO DE SAPOSOA', 176)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1725, N'LAMAS', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1726, N'ALONSO DE ALVARADO', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1727, N'BARRANQUITA', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1728, N'CAYNARACHI', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1729, N'CU&Ntilde;UMBUQUI', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1730, N'PINTO RECODO', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1731, N'RUMISAPA', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1732, N'SAN ROQUE DE CUMBAZA', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1733, N'SHANAO', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1734, N'TABALOSOS', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1735, N'ZAPATERO', 177)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1736, N'JUANJUI', 178)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1737, N'CAMPANILLA', 178)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1738, N'HUICUNGO', 178)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1739, N'PACHIZA', 178)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1740, N'PAJARILLO', 178)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1741, N'PICOTA', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1742, N'BUENOS AIRES', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1743, N'CASPISAPA', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1744, N'PILLUANA', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1745, N'PUCACACA', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1746, N'SAN CRISTOBAL', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1747, N'SAN HILARION', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1748, N'SHAMBOYACU', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1749, N'TINGO DE PONASA', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1750, N'TRES UNIDOS', 179)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1751, N'RIOJA', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1752, N'AWAJUN', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1753, N'ELIAS SOPLIN VARGAS', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1754, N'NUEVA CAJAMARCA', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1755, N'PARDO MIGUEL', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1756, N'POSIC', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1757, N'SAN FERNANDO', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1758, N'YORONGOS', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1759, N'YURACYACU', 180)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1760, N'TARAPOTO', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1761, N'ALBERTO LEVEAU', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1762, N'CACATACHI', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1763, N'CHAZUTA', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1764, N'CHIPURANA', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1765, N'EL PORVENIR', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1766, N'HUIMBAYOC', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1767, N'JUAN GUERRA', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1768, N'LA BANDA DE SHILCAYO', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1769, N'MORALES', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1770, N'PAPAPLAYA', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1771, N'SAN ANTONIO', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1772, N'SAUCE', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1773, N'SHAPAJA', 181)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1774, N'TOCACHE', 182)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1775, N'NUEVO PROGRESO', 182)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1776, N'POLVORA', 182)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1777, N'SHUNTE', 182)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1778, N'UCHIZA', 182)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1779, N'TACNA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1780, N'ALTO DE LA ALIANZA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1781, N'CALANA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1782, N'CIUDAD NUEVA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1783, N'INCLAN', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1784, N'PACHIA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1785, N'PALCA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1786, N'POCOLLAY', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1787, N'SAMA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1788, N'CORONEL GREGORIO ALBARRACIN LANCHIPA', 183)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1789, N'CANDARAVE', 184)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1790, N'CAIRANI', 184)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1791, N'CAMILACA', 184)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1792, N'CURIBAYA', 184)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1793, N'HUANUARA', 184)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1794, N'QUILAHUANI', 184)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1795, N'LOCUMBA', 185)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1796, N'ILABAYA', 185)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1797, N'ITE', 185)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1798, N'TARATA', 186)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1799, N'CHUCATAMANI', 186)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1800, N'ESTIQUE', 186)
GO
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1801, N'ESTIQUE-PAMPA', 186)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1802, N'SITAJARA', 186)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1803, N'SUSAPAYA', 186)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1804, N'TARUCACHI', 186)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1805, N'TICACO', 186)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1806, N'TUMBES', 187)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1807, N'CORRALES', 187)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1808, N'LA CRUZ', 187)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1809, N'PAMPAS DE HOSPITAL', 187)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1810, N'SAN JACINTO', 187)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1811, N'SAN JUAN DE LA VIRGEN', 187)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1812, N'ZORRITOS', 188)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1813, N'CASITAS', 188)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1814, N'ZARUMILLA', 189)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1815, N'AGUAS VERDES', 189)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1816, N'MATAPALO', 189)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1817, N'PAPAYAL', 189)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1818, N'CALLERIA', 190)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1819, N'CAMPOVERDE', 190)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1820, N'IPARIA', 190)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1821, N'MASISEA', 190)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1822, N'YARINACOCHA', 190)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1823, N'NUEVA REQUENA', 190)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1824, N'RAYMONDI', 191)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1825, N'SEPAHUA', 191)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1826, N'TAHUANIA', 191)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1827, N'YURUA', 191)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1828, N'PADRE ABAD', 192)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1829, N'IRAZOLA', 192)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1830, N'CURIMANA', 192)
INSERT [dbo].[District] ([IdDistrict], [District], [IdProvince]) VALUES (1831, N'PURUS', 193)
GO
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00100', NULL, N'Estado Pedido', NULL, NULL, NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00101', N'00100', N'Pendiente', 1, N'Pendiente', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00102', N'00100', N'En Proceso', 2, N'En Proceso', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00103', N'00100', N'Terminado', 3, N'Terminado', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00104', N'00100', N'Creado', 4, N'Creado', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00200', NULL, N'Ubicacion', NULL, NULL, NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00201', N'00200', N'Encargado de Ventas', 1, N'Encargado de Ventas', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00202', N'00200', N'Area Corte', 2, N'Area Corte', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00203', N'00200', N'Area Costura', 3, N'Area Costura', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00204', N'00200', N'Area Lavanderia', 4, N'Area Lavanderia', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00205', N'00200', N'Area Acabados', 5, N'Area Acabados', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00206', N'00200', N'Area Despacho', 6, N'Para Recoger', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00207', N'00200', N'Entregado al Cliente', 7, N'Entregado al Cliente', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00300', NULL, N'Perfil', NULL, NULL, NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00301', N'00300', N'Encargado de Ventas', 1, N'Encargado de Ventas', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00302', N'00300', N'Encargado de Corte', 2, N'Encargado de Corte', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00303', N'00300', N'Encargado de Costura', 3, N'Encargado de Costura', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00304', N'00300', N'Encargado de Lavanderia', 4, N'Encargado de Lavanderia', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00305', N'00300', N'Encargado de Acabados', 5, N'Encargado de Acabados', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00306', N'00300', N'Encargado de Almacen', 6, N'Encargado de Almacen', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00307', N'00300', N'Encargado de Despacho', 7, N'Encargado de Despacho', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00308', N'00300', N'Administrador', 8, N'Administrador', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00400', NULL, N'Prioridades', NULL, NULL, NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00401', N'00400', N'Alta', 1, N'Alta', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00402', N'00400', N'Media', 2, N'Media', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00403', N'00400', N'Baja', 3, N'Baja', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00500', NULL, N'Unidad de Medida', NULL, NULL, NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00501', N'00500', N'Metros', 1, N'mtrs', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00502', N'00500', N'Unidad', 2, N'unidad', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00503', N'00500', N'Conos', 3, N'conos', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00504', N'00500', N'Planchas', 4, N'planchas', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00600', NULL, N'Respuesta', NULL, NULL, NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00601', N'00600', N'Pendiente', 1, N'Pendiente', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00602', N'00600', N'Aprobado', 2, N'Aprobado', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00603', N'00600', N'Rechazado', 3, N'Rechazado', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00604', N'00600', N'En Proceso', 4, N'En Proceso', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00605', N'00600', N'Culminado', 5, N'Culminado', NULL, NULL, NULL, N'A')
INSERT [dbo].[MasterTable] ([IdMasterTable], [IdMasterTableParent], [Name], [Order], [Value], [AdditionalOne], [AdditionalTwo], [AdditionalThree], [RecordStatus]) VALUES (N'00606', N'00600', N'Entregado', 6, N'Entregado', NULL, NULL, NULL, N'A')
GO
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME001', NULL, N'Area de Ventas', N'ventas', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME002', NULL, N'Area de Almacen', N'almacen', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME003', NULL, N'Area de Corte', N'corte', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME004', NULL, N'Area de Costura', N'costura', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME005', NULL, N'Area de Lavanderia', N'lavanderia', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME006', NULL, N'Area de Acabado', N'acabado', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME007', NULL, N'Area de Despacho', N'despacho', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME008', N'ME001', N'Gestion de Ventas', N'ventas', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME009', N'ME001', N'Reportes', N'reportesVentas', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME010', N'ME002', N'Inventario', N'almacen', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME011', N'ME002', N'Alerta de Insumos', N'almacen/alerta', N'A')
INSERT [dbo].[Menu] ([IdMenu], [IdMenuParent], [MenuName], [UrlName], [RecordStatus]) VALUES (N'ME012', N'ME002', N'Reportes', N'almacen', N'A')
GO
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'1c515671-b558-4f28-b836-642a309ee437', N'ME001', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'c7d60203-574d-4a51-8616-4eb0997f664c', N'ME002', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'c5eaed28-0e31-4f33-bc73-7dcca84b8460', N'ME003', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'f216c949-382e-42f8-ad89-ca91d7b502e1', N'ME004', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'2ba2a220-0fc8-4790-bc99-76182273e18f', N'ME005', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'255cc7ab-c0df-47a8-9044-b9d1586f294b', N'ME006', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'dfed879f-bb14-46d0-8bb4-317f242b8888', N'ME007', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'9ae159ca-5295-47b0-baff-060cca25b90c', N'ME008', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'a3431ce3-a236-4dac-8b89-053ba1a52b62', N'ME009', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'163a856d-54d6-4b47-aba0-bba15cfe7d78', N'ME010', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'2293d63d-a8dd-4f31-b197-81aeacec1ce8', N'ME011', N'00308', N'A')
INSERT [dbo].[MenuProfile] ([IdMenuProfile], [IdMenu], [IdProfile], [RecordStatus]) VALUES (N'1739f033-b3b1-4f0b-9aad-314e6cd76743', N'ME012', N'00308', N'A')
GO
INSERT [dbo].[Order] ([IdOrder], [DateOrder], [CodeOrder], [Total], [StatusOrder], [LocationOrder], [IdCustomer], [RecordStatus], [BusinessNumber], [BusinessName]) VALUES (N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', CAST(N'2021-10-16' AS Date), N'202110-000001', CAST(225.00 AS Numeric(9, 2)), N'00103', N'00207', N'8eba8d99-0d1e-4677-9cb4-0b89ccf9426c', N'A', NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'163f5998-c4b3-40d0-9c27-525a9bfd27dc', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'', CAST(4.0000 AS Decimal(18, 4)), N'A')
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'45870701-d57f-464d-90e8-a13b9c9abf5b', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'', CAST(3.0000 AS Decimal(18, 4)), N'A')
GO
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'1f83e7b0-bcfb-4df5-8677-548337708618', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', 7, N'00207', N'00606', CAST(N'2021-10-16T09:57:17.963' AS DateTime), 1, 1)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'e1fff941-1e2c-4623-9be7-71a1970d18b5', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', 4, N'00204', N'00604', CAST(N'2021-10-16T09:57:01.180' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'a0187570-2063-4102-ba32-bc186eec098e', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', 5, N'00205', N'00601', CAST(N'2021-10-16T09:57:08.173' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'49885aaa-3a72-433a-9270-db450c125994', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', 1, N'00201', N'00602', CAST(N'2021-10-16T09:49:31.330' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'24fc9c5d-5a3e-4695-b077-e971dd486171', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', 6, N'00206', N'00606', CAST(N'2021-10-16T09:57:17.963' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'd6af8cd2-f3df-4b2d-ac07-eaa593133395', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', 2, N'00202', N'00604', CAST(N'2021-10-16T09:56:13.280' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'5d5414e8-834f-424f-a3f2-f0033a72ae32', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', 3, N'00203', N'00601', CAST(N'2021-10-16T09:56:44.863' AS DateTime), 1, 0)
GO
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'6e8df32b-a45d-44fc-94b1-0531765739ee', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00206', N'00601', CAST(N'2021-10-16T09:57:08.173' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'c497ef04-212e-4b91-810e-1b7e2383c939', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00204', N'00604', CAST(N'2021-10-16T09:56:25.830' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'ffc08e6d-dbc4-412a-8621-26fbbcac702d', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00201', N'00602', CAST(N'2021-10-16T09:49:31.313' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'35aecff2-74be-4ba3-9a4e-2ee2b04863b0', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00201', N'00601', CAST(N'2021-10-16T09:49:18.773' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'cd67531f-4859-4922-afec-3bbfb0618bde', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00204', N'00604', CAST(N'2021-10-16T09:56:52.923' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'11866994-6350-4bf5-ab2a-407de34729fe', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00204', N'00604', CAST(N'2021-10-16T09:56:57.247' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'89dda33c-6252-46aa-b6b2-530d4fb01a4e', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00206', N'00606', CAST(N'2021-10-16T09:57:17.950' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'16bf727b-95d4-4805-9fee-722fbc22183c', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00202', N'00604', CAST(N'2021-10-16T09:52:40.857' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'98b79051-9365-42f9-af42-82b3dd5b7ca6', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00202', N'00604', CAST(N'2021-10-16T09:52:14.303' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'18dbecbb-489c-4201-921e-929917e5455b', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00204', N'00601', CAST(N'2021-10-16T09:56:44.863' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'3e8c09d4-a018-43b9-8127-94941502e4eb', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00204', N'00604', CAST(N'2021-10-16T09:56:29.480' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'b86534d3-99cc-46ae-b7d0-9d7c93710780', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00202', N'00604', CAST(N'2021-10-16T09:53:00.603' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'9d92352c-0d36-495a-91ff-a9208f9a8dbc', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00207', N'00606', CAST(N'2021-10-16T09:57:17.963' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'fbc6e4e6-7499-4370-abe3-b17b3f80ef2c', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00202', N'00604', CAST(N'2021-10-16T09:49:42.397' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'b06390ca-a25e-4730-a167-b8a51f66ba04', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00205', N'00601', CAST(N'2021-10-16T09:57:01.183' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'364e1285-fbc3-4f59-bfd7-ba9ce839f13c', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00204', N'00604', CAST(N'2021-10-16T09:56:20.843' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'fbe2ba0c-8b1e-481d-bbca-e1a1a8e2a99c', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00205', N'00604', CAST(N'2021-10-16T09:56:34.483' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'98221035-dba2-4c4f-a675-f843b4007bdb', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00202', N'00604', CAST(N'2021-10-16T09:54:56.480' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'eb4fc0ce-7930-43c1-a9ab-f8ae28ec03e5', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00202', N'00601', CAST(N'2021-10-16T09:49:31.330' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'd64b54f9-9bb4-4f57-9627-f9108c6ee938', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00203', N'00601', CAST(N'2021-10-16T09:56:40.863' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'3437323b-f9e9-4541-a652-ff5d3b987558', N'95c7982d-77fd-4abb-8ffa-8b4bba2c5413', N'00203', N'00604', CAST(N'2021-10-16T09:56:13.280' AS DateTime))
GO
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'Modelo Bolsillo Cruzado', N'../../../assets/media/Modelo_Bolsillo_Cruzado.jpeg', N'A', CAST(35.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'd361e525-deb5-4666-9dbd-1acb12a543af', N'Modelo Bolsillo Tipo Ojal', N'../../../assets/media/Modelo_Bolsillo_Tipo_Ojal.jpeg', N'A', CAST(30.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'Modelo Con Bolsillo Trasero', N'../../../assets/media/Modelo_Con_Bolsillo_Trasero.jpeg', N'A', CAST(40.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'Modelo RC Clasico', N'../../../assets/media/Modelo_RC_Clasico.jpeg', N'A', CAST(35.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'82451157-5164-4dfb-8652-581a66595a9b', N'Modelo Melissa Clasico', N'../../../assets/media/Modelo_Melissa_Clasico.jpeg', N'A', CAST(45.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'd18c3091-729f-48e1-940a-81c7f864afb2', N'Modelo Moteado Con Bolsillo Trasero', N'../../../assets/media/Modelo_Moteado_Con_Bolsillo_Trasero.jpeg', N'A', CAST(43.5000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'Modelo Presillas Cruzadas', N'../../../assets/media/Modelo_Presillas_Cruzadas.jpeg', N'A', CAST(35.8000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'Modelo Tobillero Rasgado', N'../../../assets/media/Modelo_Tobillero_Rasgado.jpeg', N'A', CAST(45.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'Modelo Pretina Ancha', N'../../../assets/media/Modelo_Pretina_Ancha.jpeg', N'A', CAST(25.9000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'Modelo Pretina Cortada', N'../../../assets/media/Modelo_Pretina_Cortada.jpeg', N'A', CAST(50.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'Modelo RC Sin Bolsillo', N'../../../assets/media/Modelo_RC_Sin_Bolsillo.jpeg', N'A', CAST(40.0000 AS Numeric(18, 4)))
INSERT [dbo].[Product] ([IdProduct], [Name], [PathFile], [RecordStatus], [PriceUnit]) VALUES (N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'Modelo Rasgado Con Pretina Cortada', N'../../../assets/media/Modelo_Rasgado_Con_Pretina_Cortada.jpeg', N'A', CAST(25.5000 AS Numeric(18, 4)))
GO
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'86eee1a7-cf27-4a5a-891a-03ff055d1cf8', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'4fae72be-ec60-438d-beab-065fff3b73ec', N'82451157-5164-4dfb-8652-581a66595a9b', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'797d8dc6-9886-4ef2-8f10-06d810e79740', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'880a1959-ae56-4e4c-baa6-0b2e211b2c42', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'240a3d6a-07c3-46b8-b342-100d3ddc9211', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'ce6e2d78-a301-4265-aa8b-112cd68e1c31', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'cd55112c-384d-4397-ab28-12036db29173', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'9bb661de-f3ac-4eba-b59f-12230c080e90', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'f5ae6337-0cc3-4962-a5d5-21ad02dcb802', N'82451157-5164-4dfb-8652-581a66595a9b', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'63f00ee9-562e-4db7-a094-282417c2bd16', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'87aefecd-6441-4846-a97d-2d5b0aeda515', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'6f61766f-b6ea-41e5-bb56-2e40df63c6bf', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'aca088d6-7e87-417c-93c2-2f527f062ae5', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'c8d0c9d9-29e7-4248-ae6b-32f694aad830', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'3617e1b5-a06b-46ea-9b40-345be80ea590', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'89587761-15d7-4a34-b472-38dd1087150b', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'edba6885-c870-4ff9-a48d-3bd902316b3c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'db53a292-d6b7-4ac5-95a3-3efc9cb3fbbe', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'6a79a442-5bfb-437f-80e1-43b0e7a3afb7', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'dc3f5c62-cadd-4bc4-bc79-479b302cbee6', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'3e296aab-e67e-4013-a2f1-4a52e05ba4cc', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'23c19450-0483-4b53-906c-4a92973f487d', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'58982f40-231e-4716-a667-4f7b6543a306', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'4136c263-1510-4831-ba54-4fced3c3af0a', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'3e1a49a2-ea78-4b80-9fbd-5235a3989b1a', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'ad4a7dd4-8806-467e-8c82-560409af2fcb', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'd54af14c-794e-45f0-9a21-56b9ad17e499', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'464fadeb-c017-410f-b97d-5703116e19f2', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'bfc14ecf-dd40-4e11-9da4-5bb9e2854f9c', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'6d518401-a9fd-4b35-9eca-5f2bd1eef569', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'bfcbcd7a-f7a5-4a5c-892c-60714d23b030', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'9577825b-1ada-452b-bd8a-608cef3c34ea', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'a191de8b-9c36-4c27-ba33-6e22ebd3b910', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'ece237cc-8190-4e5c-b320-6fb0391c299f', N'82451157-5164-4dfb-8652-581a66595a9b', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'196d3a92-4480-4536-bc01-724936b843fe', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'b879a966-59c8-46f2-8372-73a5dec0d82b', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'2c469a79-288c-4e2b-a46c-743386014fdc', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'a5a9792b-7c70-4e5c-b1c8-7884ee8bdeff', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'7a5479ce-7b15-4a09-aabc-7b6bbb2b10db', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'31d84ecb-13f6-4874-a77f-7c62ece82992', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'6c9407ca-d9e3-4d05-a07a-856b1c1ddfba', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'9792765d-2fec-4864-a834-857b93b3318f', N'82451157-5164-4dfb-8652-581a66595a9b', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'33777906-e056-45be-b036-861264618ca2', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'aceb6c58-3514-46ab-81d8-864da0f0602b', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'0f068c84-ebd6-48ce-bca3-8654494884a2', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'853311c8-0f5d-453e-947c-886faddbe30a', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'5035efe8-12fb-46e7-a95d-91da0e576797', N'82451157-5164-4dfb-8652-581a66595a9b', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'8a50afda-1121-4c81-b079-92091cc41548', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'0923d754-85f2-4b17-9a1f-9729783caa5e', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00203', N'Armado de la prenda', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'9c50df89-e2b3-46c2-b549-974ff9f294d1', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'2ed946e8-e385-4a5e-a36f-975d51d28baf', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'baf4f7c4-df8c-4b74-bf7a-9fa7485eecd5', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'c93484fd-45bc-45b5-9546-a38f42de0a91', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'30a4be3b-ff47-481b-9d83-b9a3ba7448f3', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'b025b6c6-f3f5-4906-8eb1-ba5b05558c1b', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00204', N'Lavado de prendas de color azul.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'6b9031a5-5f15-4b34-9d92-c463ecc71832', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'2b43078d-9a17-4e9a-abca-cca19122eaa3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00202', N'Corte de tela para elaboración de prenda', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'5e6d3b67-2219-43b6-b0c6-cdfbcdd783c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'16e3c8f9-a09c-46ed-aa91-cf0509beeef6', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'3984ed60-7e73-4e41-b753-d852ccb74fc1', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'd0cf7fca-8ce5-4004-8be0-dbbbb5480745', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'20939bfa-901f-4ce8-8f32-dd7d85388eb0', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00202', N'Corte de tela para elaboración de prenda.', 1)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'b53d7881-19e1-4ba5-82bc-e0d1e0832fb7', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', N'Acabados de la prenda.', 4)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'b9881bcf-c6fe-4ef0-82e8-e20c3d6ce4d7', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'26a03bf3-2687-4df8-82ca-e8d0ebf5a272', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'ce7449f7-baf0-4146-b6a1-eb0f6068ce71', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'5a81073b-3f1b-4c1a-9fe4-f0f62c2d4ce6', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'55b8d06d-f1ae-49c3-b731-f24bffdd3b15', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'998e011d-022a-4aeb-810e-f5ca176b7c12', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00203', N'Armado de la prenda.', 2)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'02452221-bb28-4ff5-9407-fc07355d358a', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00204', N'Lavado de prendas de color blanco.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'327914ef-12ee-4778-ad59-fce7b73ffb7b', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00204', N'Lavado de prendas de color negro.', 3)
INSERT [dbo].[ProductSubProcess] ([IdProductSubProcess], [IdProduct], [LocationOrder], [Description], [OrderSubProcess]) VALUES (N'eef0c80b-a9b6-4a60-976f-fdbc789d68fa', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00204', N'Lavado de prendas de color blanco.', 3)
GO
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (1, N'CHACHAPOYAS ', 1)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (2, N'BAGUA', 1)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (3, N'BONGARA', 1)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (4, N'CONDORCANQUI', 1)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (5, N'LUYA', 1)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (6, N'RODRIGUEZ DE MENDOZA', 1)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (7, N'UTCUBAMBA', 1)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (8, N'HUARAZ', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (9, N'AIJA', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (10, N'ANTONIO RAYMONDI', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (11, N'ASUNCION', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (12, N'BOLOGNESI', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (13, N'CARHUAZ', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (14, N'CARLOS FERMIN FITZCARRALD', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (15, N'CASMA', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (16, N'CORONGO', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (17, N'HUARI', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (18, N'HUARMEY', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (19, N'HUAYLAS', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (20, N'MARISCAL LUZURIAGA', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (21, N'OCROS', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (22, N'PALLASCA', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (23, N'POMABAMBA', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (24, N'RECUAY', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (25, N'SANTA', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (26, N'SIHUAS', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (27, N'YUNGAY', 2)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (28, N'ABANCAY', 3)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (29, N'ANDAHUAYLAS', 3)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (30, N'ANTABAMBA', 3)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (31, N'AYMARAES', 3)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (32, N'COTABAMBAS', 3)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (33, N'CHINCHEROS', 3)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (34, N'GRAU', 3)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (35, N'AREQUIPA', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (36, N'CAMANA', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (37, N'CARAVELI', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (38, N'CASTILLA', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (39, N'CAYLLOMA', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (40, N'CONDESUYOS', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (41, N'ISLAY', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (42, N'LA UNION', 4)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (43, N'HUAMANGA', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (44, N'CANGALLO', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (45, N'HUANCA SANCOS', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (46, N'HUANTA', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (47, N'LA MAR', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (48, N'LUCANAS', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (49, N'PARINACOCHAS', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (50, N'PAUCAR DEL SARA SARA', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (51, N'SUCRE', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (52, N'VICTOR FAJARDO', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (53, N'VILCAS HUAMAN', 5)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (54, N'CAJAMARCA', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (55, N'CAJABAMBA', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (56, N'CELENDIN', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (57, N'CHOTA ', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (58, N'CONTUMAZA', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (59, N'CUTERVO', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (60, N'HUALGAYOC', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (61, N'JAEN', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (62, N'SAN IGNACIO', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (63, N'SAN MARCOS', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (64, N'SAN PABLO', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (65, N'SANTA CRUZ', 6)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (66, N'CALLAO', 7)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (67, N'CUSCO', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (68, N'ACOMAYO', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (69, N'ANTA', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (70, N'CALCA', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (71, N'CANAS', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (72, N'CANCHIS', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (73, N'CHUMBIVILCAS', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (74, N'ESPINAR', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (75, N'LA CONVENCION', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (76, N'PARURO', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (77, N'PAUCARTAMBO', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (78, N'QUISPICANCHI', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (79, N'URUBAMBA', 8)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (80, N'HUANCAVELICA', 9)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (81, N'ACOBAMBA', 9)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (82, N'ANGARAES', 9)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (83, N'CASTROVIRREYNA', 9)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (84, N'CHURCAMPA', 9)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (85, N'HUAYTARA', 9)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (86, N'TAYACAJA', 9)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (87, N'HUANUCO', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (88, N'AMBO', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (89, N'DOS DE MAYO', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (90, N'HUACAYBAMBA', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (91, N'HUAMALIES', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (92, N'LEONCIO PRADO', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (93, N'MARA&Ntilde;ON', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (94, N'PACHITEA', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (95, N'PUERTO INCA', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (96, N'LAURICOCHA', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (97, N'YAROWILCA', 10)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (98, N'ICA', 11)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (99, N'CHINCHA', 11)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (100, N'NAZCA', 11)
GO
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (101, N'PALPA', 11)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (102, N'PISCO', 11)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (103, N'HUANCAYO', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (104, N'CONCEPCION', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (105, N'CHANCHAMAYO', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (106, N'JAUJA', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (107, N'JUNIN', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (108, N'SATIPO', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (109, N'TARMA', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (110, N'YAULI', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (111, N'CHUPACA', 12)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (112, N'TRUJILLO', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (113, N'ASCOPE', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (114, N'BOLIVAR', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (115, N'CHEPEN', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (116, N'JULCAN', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (117, N'OTUZCO', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (118, N'PACASMAYO', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (119, N'PATAZ', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (120, N'SANCHEZ CARRION', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (121, N'SANTIAGO DE CHUCO', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (122, N'GRAN CHIMU', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (123, N'VIRU', 13)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (124, N'CHICLAYO', 14)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (125, N'FERREÑAFE', 14)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (126, N'LAMBAYEQUE', 14)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (127, N'LIMA', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (128, N'BARRANCA', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (129, N'CAJATAMBO', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (130, N'CANTA', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (131, N'CAÑETE', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (132, N'HUARAL', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (133, N'HUAROCHIRI', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (134, N'HUAURA', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (135, N'OYON', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (136, N'YAUYOS', 15)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (137, N'MAYNAS', 16)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (138, N'ALTO AMAZONAS', 16)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (139, N'LORETO', 16)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (140, N'MARISCAL RAMON CASTILLA', 16)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (141, N'REQUENA', 16)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (142, N'UCAYALI', 16)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (143, N'TAMBOPATA', 17)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (144, N'MANU', 17)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (145, N'TAHUAMANU', 17)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (146, N'MARISCAL NIETO', 18)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (147, N'GENERAL SANCHEZ CERRO', 18)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (148, N'ILO', 18)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (149, N'PASCO', 19)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (150, N'DANIEL ALCIDES CARRION', 19)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (151, N'OXAPAMPA', 19)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (152, N'PIURA', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (153, N'AYABACA', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (154, N'HUANCABAMBA', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (155, N'MORROPON', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (156, N'PAITA', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (157, N'SULLANA', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (158, N'TALARA', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (159, N'SECHURA', 20)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (160, N'PUNO', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (161, N'AZANGARO', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (162, N'CARABAYA', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (163, N'CHUCUITO', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (164, N'EL COLLAO', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (165, N'HUANCANE', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (166, N'LAMPA', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (167, N'MELGAR', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (168, N'MOHO', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (169, N'SAN ANTONIO DE PUTINA', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (170, N'SAN ROMAN', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (171, N'SANDIA', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (172, N'YUNGUYO', 21)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (173, N'MOYOBAMBA', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (174, N'BELLAVISTA', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (175, N'EL DORADO', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (176, N'HUALLAGA', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (177, N'LAMAS', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (178, N'MARISCAL CACERES', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (179, N'PICOTA', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (180, N'RIOJA', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (181, N'SAN MARTIN', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (182, N'TOCACHE', 22)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (183, N'TACNA', 23)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (184, N'CANDARAVE', 23)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (185, N'JORGE BASADRE', 23)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (186, N'TARATA', 23)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (187, N'TUMBES', 24)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (188, N'CONTRALMIRANTE VILLAR', 24)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (189, N'ZARUMILLA', 24)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (190, N'CORONEL PORTILLO', 25)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (191, N'ATALAYA', 25)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (192, N'PADRE ABAD', 25)
INSERT [dbo].[Province] ([IdProvince], [Province], [IdDepartment]) VALUES (193, N'PURUS', 25)
GO
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'adc3eb22-d87a-46d8-b82a-18276bb5c823', N'0923d754-85f2-4b17-9a1f-9729783caa5e', N'5d5414e8-834f-424f-a3f2-f0033a72ae32', N'00103', N'COST202110-000002', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'1bb0b4dc-8c56-4906-9336-229d3e3462ff', N'2c469a79-288c-4e2b-a46c-743386014fdc', N'e1fff941-1e2c-4623-9be7-71a1970d18b5', N'00103', N'LAVA202110-000003', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'326d9622-df2e-446f-a4d3-2b26d2f15966', N'880a1959-ae56-4e4c-baa6-0b2e211b2c42', N'a0187570-2063-4102-ba32-bc186eec098e', N'00103', N'ACAB202110-000001', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'f4eaa662-e40a-4873-8190-49ad75b40a5f', N'cd55112c-384d-4397-ab28-12036db29173', N'e1fff941-1e2c-4623-9be7-71a1970d18b5', N'00103', N'LAVA202110-000001', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'eafbe266-d4a3-4112-8c16-5458381174ce', N'9c50df89-e2b3-46c2-b549-974ff9f294d1', N'5d5414e8-834f-424f-a3f2-f0033a72ae32', N'00103', N'COST202110-000001', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'6f19dbd2-accf-402b-bf1a-91c9eed4d454', N'2b43078d-9a17-4e9a-abca-cca19122eaa3', N'd6af8cd2-f3df-4b2d-ac07-eaa593133395', N'00103', N'CORT202110-000002', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'54fbcf24-3670-4e67-b73a-9776dcb389ad', N'edba6885-c870-4ff9-a48d-3bd902316b3c', N'e1fff941-1e2c-4623-9be7-71a1970d18b5', N'00103', N'LAVA202110-000005', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'6e5d023e-6b7b-49fd-88ef-a9977c434bef', N'86eee1a7-cf27-4a5a-891a-03ff055d1cf8', N'e1fff941-1e2c-4623-9be7-71a1970d18b5', N'00103', N'LAVA202110-000004', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'2981655d-aee3-4189-bc4a-acc142f2ed44', N'6c9407ca-d9e3-4d05-a07a-856b1c1ddfba', N'a0187570-2063-4102-ba32-bc186eec098e', N'00103', N'ACAB202110-000002', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'14701882-bc49-4f5b-9f14-bf1bebe91088', N'ce6e2d78-a301-4265-aa8b-112cd68e1c31', N'd6af8cd2-f3df-4b2d-ac07-eaa593133395', N'00103', N'CORT202110-000001', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'f8479f7f-fcde-4083-8663-cfb2e60e4e03', N'bfc14ecf-dd40-4e11-9da4-5bb9e2854f9c', N'e1fff941-1e2c-4623-9be7-71a1970d18b5', N'00103', N'LAVA202110-000002', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'0e1ff05a-fbd3-477a-bbc5-d67547e03672', N'5e6d3b67-2219-43b6-b0c6-cdfbcdd783c3', N'e1fff941-1e2c-4623-9be7-71a1970d18b5', N'00103', N'LAVA202110-000006', CAST(N'2021-10-16' AS Date), NULL, CAST(0.00 AS Numeric(9, 2)))
GO
INSERT [dbo].[Supplier] ([IdSupplier], [Name], [Phone], [Email], [RecordStatus]) VALUES (N'0744a216-27ee-4085-9269-529a29b4b8f3', N'Textiles Maguiña S.A.C.', N'965412365', N'contacto@texmag.com', N'A')
INSERT [dbo].[Supplier] ([IdSupplier], [Name], [Phone], [Email], [RecordStatus]) VALUES (N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'Juan Perez S.A.C.', N'987556236', N'ventas@juanperezsac.com', N'A')
GO
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'258b773f-86e4-435a-9d1f-04edeb05d579', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'28f68df7-2e90-406d-acf6-5a1c4575f5d5')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'c48a53f2-fb58-4572-bdb0-065a066e6727', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'5f70745e-f005-4f10-9a47-be4f1e6cab74')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'4e6386ce-2d1a-4257-a00f-0e4daeb40ec8', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'd6b9a453-ba62-443a-8fe1-955eb0332b44')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'1668e4a0-1aec-4a81-867a-0fca46222971', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'b55f0002-f577-41f0-8ce3-12c7c1e685f9', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'20ee7527-50ba-42cc-ab3f-d861834ad735')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'5979cd80-d178-4b39-b687-1539888f190d', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'd6a2364c-1384-4654-b2d2-d44cf35f8847')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'07690491-9bf1-4374-a129-159e306f4e32', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'66798a4e-58b1-493a-b8dd-6f9e5c569221')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'25437018-c629-41f1-865e-1835be916323', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'd020217c-7af7-496c-8183-7ed9739f39ad')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'e5ccbb0a-662d-44d3-b07a-1fcfd6d2658e', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'0bc333f7-af1c-40dc-921e-c69317385c80')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'4485f4f4-8605-4d3f-921a-201498c6a170', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'9f32064c-7fdd-4315-b866-b4b1d2f7b497')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'fbb38723-9721-42c8-8edf-26b09f5d3503', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'1eb2b87a-7b81-433d-93fb-d48a39b08ef9')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'c2f5ff4d-4335-45fd-b502-2ed40dbd8895', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'd3347ca7-7be3-4db1-864e-63e98c256996')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'26f25c50-c96b-4f0d-9def-30a226e33b97', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'9c3895a7-767c-4194-97d4-dde87a79fd57')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'8789160d-8f6e-4967-a8c8-33195d32d2eb', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'25498e8c-f454-4528-b443-63b2394f4cfc')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'b17a1eb6-5088-4083-adca-344e1cf3d277', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'0bc333f7-af1c-40dc-921e-c69317385c80')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'a914312f-e4aa-43b4-9b6d-38fbdca0f415', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'd6a2364c-1384-4654-b2d2-d44cf35f8847')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'ca6ce7b2-a33e-440b-a52e-40aaf89ab7f2', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'db8b635a-9715-495a-9267-c9db156af748')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'5f67d19d-cf55-44a6-afac-44ce46bdeb84', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'22ebf668-394d-49dc-80d8-a7fbd66d1e40')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'da21df1a-dd54-4dd5-83d0-4e1cea489920', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'2328e207-6e62-49d2-8fe7-4eb2646caace', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'601c2cfd-5620-4687-94db-96467fb806eb')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'b9d6d182-deb5-4329-bcfc-52a43a77306f', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'845ee202-e8f2-4596-b739-6dee56b467c3')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'9ee02679-6dbc-4964-9f17-5904ea2cfb62', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'580b0875-f477-4686-8736-08e807c737a2')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'75dceeea-173d-4e10-941c-5aa02a513906', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'1eb2b87a-7b81-433d-93fb-d48a39b08ef9')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'6a8ca380-9bad-4463-983c-5b0ffa8de477', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'9c3895a7-767c-4194-97d4-dde87a79fd57')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'884130e0-ba2a-4e1f-bb81-5bcec48fd00d', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'bfce6d28-f9d1-4711-99d1-f88c29435382')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'a6f60f02-ca52-4e2f-a449-6cf9db38cd49', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'9f32064c-7fdd-4315-b866-b4b1d2f7b497')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'3582d078-70ad-4707-9db9-70882f20b703', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'6b927984-817c-40d6-b754-f4bb0b839bd4')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'71dc4b37-3ed3-4c8f-a408-70e32057dae9', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'601c2cfd-5620-4687-94db-96467fb806eb')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'ad42b993-e22e-46ac-a27b-71d7c99c0ada', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'bfce6d28-f9d1-4711-99d1-f88c29435382')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'4874c2a4-a9b1-418b-a630-796f23004b46', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'930d02f3-6193-40a7-a26d-9bdb1702ca78')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'b0c6975d-8557-4d8c-ab5d-7e8d92ffb932', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'd848e787-625c-44f5-a6c6-93882ce82172')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'58feba31-c55b-4e58-bdf9-8085c4aff0f1', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'930d02f3-6193-40a7-a26d-9bdb1702ca78')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'85314116-4cc3-4084-96c3-81231443a4d1', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'6b927984-817c-40d6-b754-f4bb0b839bd4')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'4dc46790-4020-4204-90f5-81d2765f6273', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'752a88aa-91a8-4592-8ecc-88217ada2a86', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'40180ca4-5626-4033-826c-e444a0bebc58')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'3e0bda4a-3fc4-4081-a90d-892d19a6ebec', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'5f70745e-f005-4f10-9a47-be4f1e6cab74')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'f25cdfb7-beba-46df-b48c-8b8947c4c49b', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'e559a8b8-ecff-4e63-ae18-20a31ce9c423')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'71634556-be18-412f-90ee-9324417305b8', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'd59fd392-6773-4eda-aaed-c39ce6588ab9')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'207516af-5b84-4678-acdc-953a1136fd17', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'20ee7527-50ba-42cc-ab3f-d861834ad735')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'c7fe1b20-5cb2-469d-b991-a083e76921e3', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'ba187d8a-06f3-4890-995b-8ffdfe9ccff8')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'4be4f0ae-838a-4f5f-acb5-a54d6282e2fc', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'40180ca4-5626-4033-826c-e444a0bebc58')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'21d6bbbd-0623-4506-a603-a6808c8b4f0a', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'1097c7e7-6412-4388-94a5-b2168b9e0019', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'363f6293-7942-4af8-87f8-612cd079f4e4')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'3d114536-3d7b-49c1-974f-b93564581401', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'e3e04401-5dfe-49a5-9a50-bb2d2e16d127', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'6f472791-ceb5-4497-951b-1377cb3551a0')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'0f8406f7-90fa-45d2-907d-bfa81de526de', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'1b7f63cb-35a3-4959-b496-b89605c1a9be')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'd95791c0-6e45-4638-9ca4-c169a67ab56b', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'c68be214-6c7f-460b-8391-2f5408127068')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'9c42f05b-fe67-450f-86e1-d4755f4c7f83', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'1b7f63cb-35a3-4959-b496-b89605c1a9be')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'626a4b22-d435-46d9-a178-da44eb79d97f', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'fdf3f2bf-1bb4-4e04-92e9-d8bf21c4cc10')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'97973331-dd81-41c4-8326-dc0c4fa74d88', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'fdf3f2bf-1bb4-4e04-92e9-d8bf21c4cc10')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'ad7c9113-9481-46a7-aed0-ea753cb65229', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'fd57b3e5-a245-491f-bb9a-96921c063b17')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'8e312159-516f-4c66-a741-ee1d0a82278e', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'aecad797-345f-4ca7-bcea-f0996ba6c44d', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'2174aff5-e4b4-46b5-ac6b-41bc37d1d627')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'f9118296-41df-49de-b115-f4e4078321ae', N'e0e6f822-11c3-43d5-81df-d37866fc73b0', N'fd57b3e5-a245-491f-bb9a-96921c063b17')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'f8fa30d3-2fd6-47dc-bf14-f73baa892d79', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'd59fd392-6773-4eda-aaed-c39ce6588ab9')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'dc3a35fc-6c5b-423e-b28d-f9e4a52a9ba9', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'22ebf668-394d-49dc-80d8-a7fbd66d1e40')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'ba6e69d8-9efc-4ecf-96ab-fb4f5c224283', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'db8b635a-9715-495a-9267-c9db156af748')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'2e95790b-7f59-426e-a9f8-fb817091c97c', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3')
INSERT [dbo].[SuppliersBySupply] ([IdSuppliersBySupply], [IdSupplier], [IdSupply]) VALUES (N'dc06835d-21e8-4a73-bdbd-fe7ee993c2ea', N'0744a216-27ee-4085-9269-529a29b4b8f3', N'837ae6eb-05df-4997-aed1-428681ef566c')
GO
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'eb53dc47-8154-44ee-b70a-0c30411b7ced', N'db8b635a-9715-495a-9267-c9db156af748', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'aed055b7-960f-4f14-90ea-1421d16a8c5c', N'601c2cfd-5620-4687-94db-96467fb806eb', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7ca8d4cf-41b8-48e3-a181-151bb75263fa', N'837ae6eb-05df-4997-aed1-428681ef566c', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a9d6f240-4de6-4293-85cf-218ec25cb579', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00202', CAST(9.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6b3d269d-7798-4715-9c6c-2764fc0a9fd7', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00202', CAST(10.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'47235ea2-0ff6-40a4-aa9a-32b6658c6cbe', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6b2b674d-7cec-4f71-ab93-3569e4a44e9b', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'3ff78d48-ef2f-40be-a3fb-367890dab3b8', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(13.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'16a2d8c1-118e-42aa-a096-3f0b1ba78f4a', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'62caf682-1399-4a57-81a8-487968681225', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(15.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b299bc8e-4ace-43e9-9670-4a3dd63459d4', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(16.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6f79c714-cdcd-4c75-b603-4ebe3b222f75', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00203', CAST(17.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8eb55291-7f09-4444-b5d5-4f655a2592cd', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00203', CAST(18.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'35026f41-5210-4541-99ce-583dd67e0167', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9727ccdc-2dbe-4509-8bcb-5c825eb08f10', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(20.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9e67df06-006a-4cbb-b89c-5cd1a974da8d', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6e22f111-4323-40f2-9fde-671257af43f6', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(18.00 AS Numeric(9, 2)), N'00503')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6759dbc6-4e6e-4d0b-989b-67e5a09e28cc', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(17.00 AS Numeric(9, 2)), N'00504')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'31a7ff73-7fb1-4bed-8da4-6c90fdb0dde0', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(16.00 AS Numeric(9, 2)), N'00504')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'47bc3182-7401-4f0c-83e1-6cfdadb39663', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(15.50 AS Numeric(9, 2)), N'00503')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'464db854-60d9-44ce-a942-6e68279cb958', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'82451157-5164-4dfb-8652-581a66595a9b', N'00203', CAST(15.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7a7cc1f6-ede9-4de6-8b21-71f9db7c8e65', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(14.50 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6eaad5d2-0428-477b-8c51-7609c03640e9', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'61b9be08-68e1-47dc-9647-77697b9b3bd6', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(13.50 AS Numeric(9, 2)), N'00503')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6ee79978-7c3c-4bd6-b4b3-9da9d43164ad', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'82451157-5164-4dfb-8652-581a66595a9b', N'00203', CAST(13.00 AS Numeric(9, 2)), N'00504')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0260e34a-1309-49aa-b018-b514603b5f8d', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(12.50 AS Numeric(9, 2)), N'00504')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9fe344f0-6688-4195-94f6-b5c47d06f036', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00203', CAST(12.00 AS Numeric(9, 2)), N'00503')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'cc09c9c0-e832-4f44-ad87-cfec86452ad0', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(11.50 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a7a202f1-8526-42cf-a207-d0ddaffe991e', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9c37fdd8-1133-461a-85fe-d11173859a4f', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(10.50 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'4faf181c-281d-418e-b24f-d22ef6fc34b7', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(10.00 AS Numeric(9, 2)), N'00503')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6beb791a-870b-456b-b123-da681e610d67', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(9.50 AS Numeric(9, 2)), N'00504')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0224e0cc-c105-4ed4-b130-dbb01d2e0cba', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(9.00 AS Numeric(9, 2)), N'00504')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c735ae61-1ba0-42c2-acce-e41d1282a87c', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(8.50 AS Numeric(9, 2)), N'00503')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'53477100-18c0-4314-9006-e8ac624be30c', N'837ae6eb-05df-4997-aed1-428681ef566c', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'feeb5b1f-1c7b-4c88-9274-f5a969f79108', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00202', CAST(7.50 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'36df9541-f1b4-4c5d-bad5-f9a77be4202b', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(7.00 AS Numeric(9, 2)), N'00502')
GO
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'580b0875-f477-4686-8736-08e807c737a2', N'cinta santida celeste', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0001', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'placas c ', N'A', CAST(7696.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0002', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'6f472791-ceb5-4497-951b-1377cb3551a0', N'maquina de corte', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0003', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'e559a8b8-ecff-4e63-ae18-20a31ce9c423', N'placas a', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0004', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'c68be214-6c7f-460b-8391-2f5408127068', N'cinta scotch', N'A', CAST(6784.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0005', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'2174aff5-e4b4-46b5-ac6b-41bc37d1d627', N'hilo santido dorado', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0006', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'837ae6eb-05df-4997-aed1-428681ef566c', N'correas', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0007', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'botones a', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0008', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'28f68df7-2e90-406d-acf6-5a1c4575f5d5', N'botones b', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0009', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'363f6293-7942-4af8-87f8-612cd079f4e4', N'hang tag a', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0010', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'25498e8c-f454-4528-b443-63b2394f4cfc', N'hang tag c', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0011', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd3347ca7-7be3-4db1-864e-63e98c256996', N'tocuyo', N'A', CAST(7568.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0012', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'845ee202-e8f2-4596-b739-6dee56b467c3', N'tela jeans b', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0013', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'piedritas brillantes', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00504', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0014', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'maquina de placas', N'A', CAST(8680.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0015', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd020217c-7af7-496c-8183-7ed9739f39ad', N'hilo santido plateado', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0016', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'ba187d8a-06f3-4890-995b-8ffdfe9ccff8', N'cinta santida blanca', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0017', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd848e787-625c-44f5-a6c6-93882ce82172', N'etiquetas de bolsillo a', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0018', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'hilo crudo', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0019', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'601c2cfd-5620-4687-94db-96467fb806eb', N'tela jeans a', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0020', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'etiquetas de pretina a', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0021', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'etiquetas de pretina b', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0022', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'bolsas ', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0023', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'22ebf668-394d-49dc-80d8-a7fbd66d1e40', N'cola de rata blanco', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0024', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'9f32064c-7fdd-4315-b866-b4b1d2f7b497', N'placas b', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0025', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'remaches b', N'A', CAST(7824.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0026', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'botones c', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0027', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd59fd392-6773-4eda-aaed-c39ce6588ab9', N'hilo azul', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0028', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'0bc333f7-af1c-40dc-921e-c69317385c80', N'plancha transfer', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0029', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'db8b635a-9715-495a-9267-c9db156af748', N'cierres', N'A', CAST(9032.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0030', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'hilo negro', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0031', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'1eb2b87a-7b81-433d-93fb-d48a39b08ef9', N'etiquetas de bolsillo b', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0032', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'maquina de botones', N'A', CAST(7800.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0033', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'fdf3f2bf-1bb4-4e04-92e9-d8bf21c4cc10', N'remaches a', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0034', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'cinta santida fuxia', N'A', CAST(7952.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-16' AS Date), N'0035', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'9c3895a7-767c-4194-97d4-dde87a79fd57', N'hilos marron', N'A', CAST(23.00 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0036', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'40180ca4-5626-4033-826c-e444a0bebc58', N'hang tag b', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0037', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'maquina de remaches', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0038', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'cola de rata negro', N'A', CAST(10000.50 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0039', CAST(5.0000 AS Numeric(18, 4)))
GO
INSERT [dbo].[User] ([IdUser], [Username], [Password], [RecordStatus], [IdProfile]) VALUES (N'bc0bc688-d46e-4db2-ab4b-b2172ad526f3', N'admin', N'mO+Qpha+NQvkImJhOUfGbQ==', N'A', N'00308')
GO
ALTER TABLE [dbo].[Department] ADD  DEFAULT (NULL) FOR [Department]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT (NULL) FOR [District]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT (NULL) FOR [IdProvince]
GO
ALTER TABLE [dbo].[Province] ADD  DEFAULT (NULL) FOR [Province]
GO
ALTER TABLE [dbo].[Province] ADD  DEFAULT (NULL) FOR [IdDepartment]
GO
ALTER TABLE [dbo].[BuySupply]  WITH CHECK ADD  CONSTRAINT [FK_BuySupply_SuppliersBySupply] FOREIGN KEY([IdSuppliersBySupply])
REFERENCES [dbo].[SuppliersBySupply] ([IdSuppliersBySupply])
GO
ALTER TABLE [dbo].[BuySupply] CHECK CONSTRAINT [FK_BuySupply_SuppliersBySupply]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer] FOREIGN KEY([IdCustomer])
REFERENCES [dbo].[Customer] ([IdCustomer])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Customer]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY([IdOrder])
REFERENCES [dbo].[Order] ([IdOrder])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Order]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([IdProduct])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Product]
GO
ALTER TABLE [dbo].[OrderStatus]  WITH CHECK ADD  CONSTRAINT [FK_OrderStatus_Order] FOREIGN KEY([IdOrder])
REFERENCES [dbo].[Order] ([IdOrder])
GO
ALTER TABLE [dbo].[OrderStatus] CHECK CONSTRAINT [FK_OrderStatus_Order]
GO
ALTER TABLE [dbo].[ProductSubProcess]  WITH CHECK ADD  CONSTRAINT [FK_ProductSubProcess_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([IdProduct])
GO
ALTER TABLE [dbo].[ProductSubProcess] CHECK CONSTRAINT [FK_ProductSubProcess_Product]
GO
ALTER TABLE [dbo].[SubOrderFlow]  WITH CHECK ADD  CONSTRAINT [FK_SubOrderFlow_OrderFlow] FOREIGN KEY([IdOrderFlow])
REFERENCES [dbo].[OrderFlow] ([IdOrderFlow])
GO
ALTER TABLE [dbo].[SubOrderFlow] CHECK CONSTRAINT [FK_SubOrderFlow_OrderFlow]
GO
ALTER TABLE [dbo].[SubOrderFlow]  WITH CHECK ADD  CONSTRAINT [FK_SubOrderFlow_ProductSubProcess] FOREIGN KEY([IdProductSubProcess])
REFERENCES [dbo].[ProductSubProcess] ([IdProductSubProcess])
GO
ALTER TABLE [dbo].[SubOrderFlow] CHECK CONSTRAINT [FK_SubOrderFlow_ProductSubProcess]
GO
ALTER TABLE [dbo].[SuppliersBySupply]  WITH CHECK ADD  CONSTRAINT [FK_SuppliersBySupplie_Supplie] FOREIGN KEY([IdSupply])
REFERENCES [dbo].[Supply] ([IdSupply])
GO
ALTER TABLE [dbo].[SuppliersBySupply] CHECK CONSTRAINT [FK_SuppliersBySupplie_Supplie]
GO
ALTER TABLE [dbo].[SuppliersBySupply]  WITH CHECK ADD  CONSTRAINT [FK_SuppliersBySupplie_Supplier] FOREIGN KEY([IdSupplier])
REFERENCES [dbo].[Supplier] ([IdSupplier])
GO
ALTER TABLE [dbo].[SuppliersBySupply] CHECK CONSTRAINT [FK_SuppliersBySupplie_Supplier]
GO
ALTER TABLE [dbo].[SuppliesByProduct]  WITH CHECK ADD  CONSTRAINT [FK_SuppliesByProduct_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([IdProduct])
GO
ALTER TABLE [dbo].[SuppliesByProduct] CHECK CONSTRAINT [FK_SuppliesByProduct_Product]
GO
ALTER TABLE [dbo].[SuppliesByProduct]  WITH CHECK ADD  CONSTRAINT [FK_SuppliesByProduct_Supplie] FOREIGN KEY([IdSupply])
REFERENCES [dbo].[Supply] ([IdSupply])
GO
ALTER TABLE [dbo].[SuppliesByProduct] CHECK CONSTRAINT [FK_SuppliesByProduct_Supplie]
GO
/****** Object:  StoredProcedure [dbo].[Usp_Generate_OrderFlow]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================
--DESCRIPTION: Permite registrar el flujo de la orden.
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_Generate_OrderFlow] 
--=================================================
CREATE PROCEDURE	[dbo].[Usp_Generate_OrderFlow]
	@ParamIIdOrder		UNIQUEIDENTIFIER
AS
BEGIN
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
			,DateOrderFlow
			,FlagInProcess
			,FlagActive
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,1
			,'00201'
			,'00601'
			,SYSDATETIME()
			,1
			,1
		)

		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
			,DateOrderFlow
			,FlagInProcess
			,FlagActive
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,2
			,'00202'
			,'00601'
			,SYSDATETIME()
			,0
			,0
		)
		
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
			,DateOrderFlow
			,FlagInProcess
			,FlagActive
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,3
			,'00203'
			,'00601'
			,SYSDATETIME()
			,0
			,0
		)

		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
			,DateOrderFlow
			,FlagInProcess
			,FlagActive
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,4
			,'00204'
			,'00601'
			,SYSDATETIME()
			,0
			,0
		)
		
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
			,DateOrderFlow
			,FlagInProcess
			,FlagActive
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,5
			,'00205'
			,'00601'
			,SYSDATETIME()
			,0
			,0
		)
	
	
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
			,DateOrderFlow
			,FlagInProcess
			,FlagActive
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,6
			,'00206'
			,'00601'
			,SYSDATETIME()
			,0
			,0
		)

		
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
			,DateOrderFlow
			,FlagInProcess
			,FlagActive
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,7
			,'00207'
			,'00601'
			,SYSDATETIME()
			,0
			,0
		)
		
		INSERT INTO OrderStatus
		(	IdOrderStatus
			,IdOrder
			,Location
			,Status
			,DateOrderStatus
		)
		VALUES
		(	
			NEWID()
			,@ParamIIdOrder
			,'00201'
			,'00601'
			,SYSDATETIME()
		)

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Generate_SubOrderFlow]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================
--DESCRIPTION: Permite registrar el flujo de las subordenes de la orden en cada étapa del subproceso del producto.
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_Generate_SubOrderFlow] '8B433CFA-F926-4835-A08E-294EB29A698C'
--=================================================
CREATE PROCEDURE	[dbo].[Usp_Generate_SubOrderFlow]
	@ParamIIdOrder		UNIQUEIDENTIFIER
AS
BEGIN

	DECLARE	@CIdStatusCreatedMT	CHAR(5)	=	'00104';
	DECLARE	@CIdStatusPendingMT	CHAR(5)	=	'00101';
	DECLARE	@CIdCutAreaMT		CHAR(5)	=	'00202';
	DECLARE	@VIdProductSubProcess	UNIQUEIDENTIFIER, @VIdOrderFlow	UNIQUEIDENTIFIER;
	DECLARE	@VIdLocationOrderMT	CHAR(5);

	DECLARE	InsertCursor	CURSOR FOR
		SELECT	PSP.IdProductSubProcess
				,[OF].IdOrderFlow
				,PSP.LocationOrder
		FROM	ProductSubProcess	PSP
		INNER JOIN	OrderDetail	OD
			ON	OD.IdProduct	=	PSP.IdProduct
		INNER JOIN	Product	P
			ON	OD.IdProduct	=	P.IdProduct
		INNER JOIN	[Order]	O
			ON	OD.IdOrder	=	O.IdOrder
		INNER JOIN	OrderFlow	[OF]
			ON	O.IdOrder	=	[OF].IdOrder
			AND	[OF].LocationOrder	=	PSP.LocationOrder
		WHERE	O.IdOrder	=	@ParamIIdOrder

	OPEN InsertCursor
	FETCH NEXT FROM	InsertCursor	INTO	
		@VIdProductSubProcess
		,@VIdOrderFlow
		,@VIdLocationOrderMT
	WHILE	@@FETCH_STATUS = 0
	BEGIN
		
		INSERT INTO	SubOrderFlow
			(IdSubOrderFlow, IdProductSubProcess, IdOrderFlow, StatusSubOrderMT, CodeSubOrder, DateSubOrder)
		SELECT	NEWID()
				,@VIdProductSubProcess
				,@VIdOrderFlow
				,CASE	@VIdLocationOrderMT
					WHEN	@CIdCutAreaMT	THEN	@CIdStatusPendingMT
					ELSE	@CIdStatusCreatedMT
				END
				,[dbo].[FN_GetCodeSubOrder] (@VIdLocationOrderMT)
				,GETDATE();
		FETCH NEXT FROM	InsertCursor	INTO	
			@VIdProductSubProcess
			,@VIdOrderFlow
			,@VIdLocationOrderMT
	END
	CLOSE InsertCursor
	DEALLOCATE InsertCursor
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Get_OrderByCodeOrder]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para obtener Order y su estado a partir del CodeOrder
--Change:		-
--Example:		[dbo].[Usp_Get_OrderByCodeOrder]	'202109-000001'
--================================================= 
CREATE PROC [dbo].[Usp_Get_OrderByCodeOrder]
	@ParamICodeOrder	VARCHAR(50)
AS
BEGIN

	DECLARE	@CIdMasterTableParentLocation	CHAR(5)	=	'00200'

	SELECT	O.IdOrder
			,O.DateOrder
			,O.CodeOrder
			,O.[Total]
			,O.StatusOrder
			,O.IdCustomer
			,O.RecordStatus
			,ISNULL(O.BusinessNumber,'') BusinessNumber
			,ISNULL(O.BusinessName,'') BusinessName
			,O.LocationOrder
	FROM	[Order] O
	WHERE	O.CodeOrder	=	@ParamICodeOrder

	SELECT	MT.[Name]			AS	DescriptionStatus
			,[OF].FlagInProcess	AS	FlagStatus
			,[OF].NroOrder		AS	OrderStatus
			,MT.IdMasterTable
			,[OF].Answer
			,CASE [OF].FlagInProcess WHEN 1 THEN  FORMAT([OF].DateOrderFlow,'dd/MM/yyyy') 
			ELSE ''
			END AS	DateOrderFlowSTtring
	FROM	MasterTable	MT
	LEFT JOIN	OrderFlow	[OF]
		ON	MT.IdMasterTable	=	[OF].LocationOrder
	LEFT JOIN	[Order]	O
		ON	[OF].IdOrder	=	O.IdOrder
	WHERE	O.CodeOrder	=	@ParamICodeOrder
	ORDER BY [OF].NroOrder ASC


	SELECT	C.IdCustomer
			,FirstName
			,LastName
			,DocumentNumber
			,PhoneNumber
			,Email
			,C.IdDistrict 
			,D.District
			,D.IdProvince 
			,P.Province
			,DE.IdDepartment 
			,DE.Department
			,C.RecordStatus
	FROM Customer	C
	INNER JOIN	[Order] O
	ON C.IdCustomer	=	O.IdCustomer
	INNER JOIN District	D
	ON D.IdDistrict	=	C.IdDistrict
	INNER JOIN Province	P
	ON P.IdProvince	=	D.IdProvince
	INNER JOIN Department	DE
	ON P.IdDepartment	=	DE.IdDepartment
	WHERE	O.CodeOrder	=	@ParamICodeOrder

	SELECT	OD.IdOrderDetail
			,O.IdOrder
			,OD.IdProduct
			,P.[Name]	AS	[Description]
			,P.PriceUnit	AS	UnitPrice
			,P.PathFile		AS	PathImageProduct
			,OD.Quantity
			,round(P.PriceUnit * OD.Quantity,2)	AS	SubTotal
			,OD.RecordStatus
	FROM	OrderDetail	OD	
	INNER JOIN	[Order] O
		ON	OD.IdOrder	=	O.[IdOrder]
	INNER JOIN	[Product]	P
		ON	OD.IdProduct	=	P.IdProduct
	WHERE	O.CodeOrder	=	@ParamICodeOrder

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Get_OrderByIdOrder]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para obtener Order y su estado a partir del IdOrder
--Change:		-
--Example:		[dbo].[Usp_Get_OrderByIdOrder]	''
--================================================= 
CREATE PROC [dbo].[Usp_Get_OrderByIdOrder]
	@ParamIIdOrder	UNIQUEIDENTIFIER
AS
BEGIN
	
	SELECT	OD.IdOrderDetail
			,O.IdOrder
			,OD.IdProduct
			,P.[Name]	AS	[Description]
			,P.PriceUnit	AS	UnitPrice
			,P.PathFile		AS	PathImageProduct
			,OD.Quantity
			,ROUND(P.PriceUnit * OD.Quantity,2)	AS	SubTotal
			,OD.RecordStatus
	FROM	OrderDetail	OD	
	INNER JOIN	[Order] O
		ON	OD.IdOrder	=	O.[IdOrder]
	INNER JOIN	[Product]	P
		ON	OD.IdProduct	=	P.IdProduct
	WHERE	O.IdOrder	=	@ParamIIdOrder

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Ins_BuySupply]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para registrar el ingreso de insumos.
--Change:		-
--Example:		[dbo].[Usp_Ins_BuySupply]	
--================================================= 
CREATE PROC [dbo].[Usp_Ins_BuySupply]
	@ParamIIdSupply		UNIQUEIDENTIFIER
	,@ParamIIdSupplier	UNIQUEIDENTIFIER
	,@ParamIUnitPrice	NUMERIC(9,2)
	,@ParamIQuantity	NUMERIC(9,2)
	,@ParamITotalPrice	NUMERIC(9,2)
AS
BEGIN

	DECLARE	@VIdSupplierBySupply	UNIQUEIDENTIFIER;

	SELECT	@VIdSupplierBySupply	=	IdSuppliersBySupply
	FROM	SuppliersBySupply	SBS
	WHERE	SBS.IdSupply	=	@ParamIIdSupply
		AND	SBS.IdSupplier	=	@ParamIIdSupplier;

	INSERT INTO	BuySupply	(	IdBuySupply
								,IdSuppliersBySupply
								,UnitPrice
								,Quantity
								,TotalPrice
								,DateBuySupply
							)
	VALUES					(	NEWID()
								,@VIdSupplierBySupply
								,@ParamIUnitPrice
								,@ParamIQuantity
								,@ParamITotalPrice
								,GETDATE()
							);
	
	UPDATE	Supply
	SET	Stock	=	Stock + @ParamIQuantity
	WHERE	IdSupply	=	@ParamIIdSupply;

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_Order]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================
--Description:	SP para listar Order
--Change:		-
--Example:		[dbo].[Usp_List_Order]
--================================================= 
CREATE PROC [dbo].[Usp_List_Order]
AS
BEGIN

	SELECT	O.IdOrder
			,O.DateOrder
			,CodeOrder
			,C.[FirstName]
			,C.[LastName]
			,C.DocumentNumber
			,C.PhoneNumber
			,O.StatusOrder
	FROM	[Order] O
	INNER JOIN	Customer	C
	ON	C.IdCustomer	=	O.IdCustomer
	INNER JOIN MasterTable	M
	ON	M.IdMasterTable	=	O.StatusOrder



	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_OrderByLocation]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================
--Description:	SP para listar Order
--Change:		-
--Example:		[dbo].[Usp_List_OrderByLocation] '00206'
--================================================= 
CREATE PROC [dbo].[Usp_List_OrderByLocation]
@ParamILocationOrder	CHAR(5)
AS
BEGIN

	SELECT	O.IdOrder
			,O.DateOrder
			,CodeOrder
			,C.[FirstName]
			,C.[LastName]
			,C.DocumentNumber
			,C.PhoneNumber
			,C.Email
			,O.LocationOrder
			,M2.[Value]	AS	LocationOrderName
			,O.StatusOrder
			,M.[Value]	AS	StatusOrderName
			,FORMAT(O.DateOrder,'dd/MM/yyyy') DateOrderString
			,M3.[Value]	AS	AnswerName
			,M3.IdMasterTable	AS	Answer
	FROM	[Order] O
	INNER JOIN	Customer	C
	ON	C.IdCustomer	=	O.IdCustomer
	INNER JOIN MasterTable	M
	ON	M.IdMasterTable	=	O.StatusOrder
	INNER JOIN MasterTable	M2
	ON	M2.IdMasterTable	=	O.LocationOrder
	INNER JOIN OrderFlow	OFL
	ON	OFL.LocationOrder	=   @ParamILocationOrder
	AND	OFL.FlagInProcess	=1
	AND	OFL.IdOrder			=	O.IdOrder
	INNER JOIN MasterTable	M3
	ON	M3.IdMasterTable	=	Answer
--	WHERE O.LocationOrder	=	@ParamILocationOrder
	ORDER BY CodeOrder

	IF OBJECT_ID(N'tempdb..#TMP_QUANTITY') IS NOT NULL
	BEGIN
	DROP TABLE #TMP_QUANTITY
	END

	SELECT	IdMasterTable
			,[Name]
			,0	Quantity 
			,0 Selected
	INTO	#TMP_QUANTITY
	FROM	MasterTable
	WHERE	IdMasterTableParent	=	'00600'
	
	DECLARE @MasterRespuestas	CHAR(5)	='00600',
			@MPendiente			CHAR(5)	='00601',
			@MAprobado			CHAR(5)	='00602',
			@MRechazado			CHAR(5)	='00603',
			@MEnProceso			CHAR(5)	='00604',
			@MCulminado			CHAR(5)	='00605',
			@MEntregado			CHAR(5)	='00606'

	DECLARE @IPendiente	INT,
			@IAprobado	INT,
			@IRechazado	INT,
			@IEnProceso	INT,
			@ICulminado	INT,
			@IEntregado	INT


	SELECT	@IPendiente	=	COUNT(1)  
	FROM	OrderFlow
	WHERE	LocationOrder	=	@ParamILocationOrder
	AND		FlagInProcess	=	1
	AND		FlagActive		=	1
	AND		Answer			=	@MPendiente
	--AND		Answer			=	@MAprobado

	SELECT	@IAprobado	=	COUNT(1)  
	FROM	OrderFlow
	WHERE	LocationOrder	=	@ParamILocationOrder
	AND		FlagInProcess	=	1
	AND		Answer			=	@MAprobado

	SELECT	@IRechazado	=	COUNT(1)  
	FROM	OrderFlow
	WHERE	LocationOrder	=	@ParamILocationOrder
	AND		FlagInProcess	=	1
	AND		Answer			=	@MRechazado

	SELECT	@IEnProceso	=	COUNT(1)  
	FROM	OrderFlow
	WHERE	LocationOrder	=	@ParamILocationOrder
	AND		FlagInProcess	=	1
	AND		Answer			=	@MEnProceso

	SELECT	@ICulminado	=	COUNT(1)  
	FROM	OrderFlow
	WHERE	LocationOrder	=	@ParamILocationOrder
	AND		FlagInProcess	=	1
	AND		Answer			=	@MCulminado

	SELECT	@IEntregado	=	COUNT(1)  
	FROM	OrderFlow
	WHERE	LocationOrder	=	@ParamILocationOrder
	AND		FlagInProcess	=	1
	AND		Answer			=	@MEntregado

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@IPendiente
	WHERE	IdMasterTable	=	@MPendiente

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@IAprobado
	WHERE	IdMasterTable	=	@MAprobado

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@IRechazado
	WHERE	IdMasterTable	=	@MRechazado

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@IEnProceso
	WHERE	IdMasterTable	=	@MEnProceso

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@ICulminado
	WHERE	IdMasterTable	=	@MCulminado

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@IEntregado
	WHERE	IdMasterTable	=	@MEntregado
	

	INSERT INTO	#TMP_QUANTITY
	VALUES (0,'Total',0,0)

	UPDATE #TMP_QUANTITY
	SET Quantity =( 
				SELECT COUNT(1) FROM [Order] ORD
					INNER JOIN OrderFlow	OFL
					ON	OFL.LocationOrder	=   @ParamILocationOrder
					AND ORD.IdOrder	=	OFL.IdOrder
					AND	OFL.FlagInProcess	=1
				/*WHERE LocationOrder	=	@ParamILocationOrder */	)
	WHERE IdMasterTable = 0
	

	IF @ParamILocationOrder	=	'00201'
	BEGIN
		DELETE #TMP_QUANTITY
		WHERE IdMasterTable IN	(00604,00605,00606)		
	END
	ELSE IF @ParamILocationOrder	=	'00206'
	BEGIN
		DELETE #TMP_QUANTITY
		WHERE IdMasterTable IN	(00602,00603,00604,00605)		
	END

	SELECT * FROM #TMP_QUANTITY order by IdMasterTable asc
	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_Product]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para listar todos los productos que están activos en el sistema.
--Change:		-
--Example:		[dbo].[Usp_List_Product]
--================================================= 
CREATE PROC [dbo].[Usp_List_Product]
AS
BEGIN

	DECLARE	@CActiveStatus	CHAR(1)	=	'A';

	SELECT	IdProduct
			,[Name]
			,ISNULL(PathFile,'') PathFile
			,RecordStatus
			,ISNULL(PriceUnit,0) PriceUnit
			,0 Quantity
	FROM	Product
	WHERE	RecordStatus	=	@CActiveStatus
	ORDER BY [Name] ASC
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_SubOrderByLocation]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================
--DESCRIPTION: Permite obtener el listado de subordenes a partir del Location.
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_List_SubOrderByLocation] '00202'
--=================================================
CREATE PROCEDURE	[dbo].[Usp_List_SubOrderByLocation]
	@ParamIIdLocation	CHAR(5)
AS
BEGIN

	DECLARE	@CFlagTrue	BIT	=	1;
	DECLARE	@CIdStatusPendingMT	CHAR(5)	=	'00101';
	DECLARE	@CIdStatusCreateMT	CHAR(5)	=	'00104';
	DECLARE	@CLocationOrderVentas	CHAR(5)	=	'00201';

	SELECT DISTINCT	O.IdOrder
			,O.CodeOrder
			,SOF.IdSubOrderFlow
			,SOF.CodeSubOrder
			,cast(OD.Quantity as int)  Quantity
			,SOF.StatusSubOrderMT
			,MT.[Name] AS StatusSubOrderName
			,FORMAT(SOF.DateSubOrder,'dd/MM/yyyy') DateSubOrder			
			,ISNULL(FORMAT(SOF.DateEndSubOrder,'dd/MM/yyyy'),'') DateEndSubOrder	
			,PSP.IdProduct
			,CAST(ISNULL(SOF.QuantityDecrease,'0') AS INT)  AS Merma
			,OD.IdOrderDetail
	FROM	ProductSubProcess	PSP
	INNER JOIN	OrderDetail	OD
		ON	OD.IdProduct	=	PSP.IdProduct
	INNER JOIN	Product	P
		ON	OD.IdProduct	=	P.IdProduct
	INNER JOIN	[Order]	O
		ON	OD.IdOrder	=	O.IdOrder
	INNER JOIN	OrderFlow	[OF]
		ON	O.IdOrder	=	[OF].IdOrder
		AND	[OF].LocationOrder	=	PSP.LocationOrder
	INNER JOIN	SubOrderFlow	SOF
		ON	[OF].IdOrderFlow	=	SOF.IdOrderFlow
		AND	SOF.IdProductSubProcess	= PSP.IdProductSubProcess
	INNER JOIN	MasterTable	MT
		ON	SOF.StatusSubOrderMT	=	MT.IdMasterTable
	WHERE	PSP.LocationOrder	=	@ParamIIdLocation
			AND	SOF.StatusSubOrderMT	!=	@CIdStatusCreateMT
		--AND	[OF].FlagInProcess	=	@CFlagTrue
		AND O.LocationOrder != @CLocationOrderVentas
	ORDER BY O.CodeOrder, SOF.CodeSubOrder

		IF OBJECT_ID(N'tempdb..#TMP_QUANTITY') IS NOT NULL
	BEGIN
	DROP TABLE #TMP_QUANTITY
	END

	SELECT	IdMasterTable
			,[Name]
			,0	Quantity 
			,0 Selected
	INTO	#TMP_QUANTITY
	FROM	MasterTable
	WHERE	IdMasterTableParent	=	'00100'
	AND		IdMasterTable != @CIdStatusCreateMT
	
	DECLARE @MasterRespuestas	CHAR(5)	='00100',
			@MPendiente			CHAR(5)	='00101',
			@MEnProceso			CHAR(5)	='00102',
			@MTerminado			CHAR(5)	='00103'

	DECLARE @IPendiente	INT,
			@IEnProceso	INT,
			@ITerminado	INT


	SELECT	@IPendiente	=	COUNT(1)  
	FROM	SubOrderFlow SB
	INNER JOIN ProductSubProcess PS
	ON SB.IdProductSubProcess	=	PS.IdProductSubProcess	
	INNER JOIN	OrderFlow	[OFL]
	ON	SB.IdOrderFlow	=	[OFL].IdOrderFlow
	AND	OFL.FlagInProcess	=	@CFlagTrue
	WHERE	PS.LocationOrder	=	@ParamIIdLocation
	AND		SB.StatusSubOrderMT			=	@MPendiente
	

	SELECT	@IEnProceso	=	COUNT(1)  
	FROM	SubOrderFlow SB
	INNER JOIN ProductSubProcess PS
	ON SB.IdProductSubProcess	=	PS.IdProductSubProcess	
	WHERE	LocationOrder	=	@ParamIIdLocation
	AND		SB.StatusSubOrderMT			=	@MEnProceso

	SELECT	@ITerminado	=	COUNT(1)  
	FROM	SubOrderFlow SB
	INNER JOIN ProductSubProcess PS
	ON SB.IdProductSubProcess	=	PS.IdProductSubProcess	
	WHERE	LocationOrder	=	@ParamIIdLocation
	AND		SB.StatusSubOrderMT			=	@MTerminado



	UPDATE #TMP_QUANTITY
	SET	Quantity =	@IPendiente
	WHERE	IdMasterTable	=	@MPendiente

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@IEnProceso
	WHERE	IdMasterTable	=	@MEnProceso

	UPDATE #TMP_QUANTITY
	SET	Quantity =	@ITerminado
	WHERE	IdMasterTable	=	@MTerminado

	INSERT INTO	#TMP_QUANTITY
	VALUES (0,'Total',0,0)

	UPDATE #TMP_QUANTITY
	SET Quantity =	( 
						SELECT COUNT(1) 
						FROM SubOrderFlow SB 
						INNER JOIN ProductSubProcess PS
						ON SB.IdProductSubProcess	=	PS.IdProductSubProcess	
						INNER JOIN	OrderFlow	[OFL]
						ON	SB.IdOrderFlow	=	[OFL].IdOrderFlow
						AND	OFL.FlagInProcess	=	@CFlagTrue
						WHERE	PS.LocationOrder	=	@ParamIIdLocation	
					)
	WHERE IdMasterTable = 0
	
	SELECT * FROM #TMP_QUANTITY order by IdMasterTable asc
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_SuppliersByIdSupply]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para listar todos los proveedores por insumo.
--Change:		-
--Example:		[dbo].[Usp_List_SuppliersByIdSupply]	'580B0875-F477-4686-8736-08E807C737A2'
--================================================= 
CREATE PROC [dbo].[Usp_List_SuppliersByIdSupply]
	@ParamIIdSupply	VARCHAR(50)
AS
BEGIN

	DECLARE	@CstatusActive	CHAR(1)	=	'A';

	SELECT	S.IdSupplier
			,S.[Name]
			,S.Phone
			,S.Email
	FROM	Supplier	S
	INNER JOIN	SuppliersBySupply	SBS
		ON	S.IdSupplier	=	SBS.IdSupplier
	WHERE	SBS.IdSupply	=	@ParamIIdSupply
		AND	S.RecordStatus	=	@CStatusActive;
	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_Supplies]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para listar todos los insumos que están activos en el sistema.
--Change:		-
--Example:		[dbo].[Usp_List_Supplies]
--================================================= 
CREATE PROC [dbo].[Usp_List_Supplies]
AS
BEGIN

	DECLARE	@CActiveStatus	CHAR(1)	=	'A';

	SELECT	IdSupply
			,CodeSupply
			,S.[Name]
			,Stock
			,MT.[Name]	AS	 MeasureUnit
			,MinimumStock
			,FORMAT(DateUpdate, 'dd/MM/yyyy')	AS	DateUpdate
			,CASE	WHEN MinimumStock <= Stock THEN	0
					ELSE 1 
			  END AS	IndicateAlert
			,PriceUnit
	FROM	Supply	S
	INNER JOIN	MasterTable	MT
		ON	S.MeasureUnit	=	MT.IdMasterTable
	WHERE	S.RecordStatus	=	@CActiveStatus
	ORDER BY S.[Name] ASC

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_SuppliesByProduct]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para listar todos los insumos por producto a partir del IdProduct.
--Change:		-
--Example:		[dbo].[Usp_List_SuppliesByProduct]
--================================================= 
CREATE PROC [dbo].[Usp_List_SuppliesByProduct]
	@ParamIIdProduct	VARCHAR(50)
AS
BEGIN

	SELECT	S.IdSupply
			,S.[Name]
			,SP.Quantity
			,MT.[Name]		AS	MeasureUnit
	FROM	Supply	S
	INNER JOIN	SuppliesByProduct	SP
		ON	S.IdSupply	=	SP.IdSupply
	INNER JOIN	Product	P
		ON	SP.IdProduct	=	P.IdProduct
	INNER JOIN	MasterTable	MT
		ON	MT.IdMasterTable	=	S.MeasureUnit
	WHERE	P.IdProduct	=	@ParamIIdProduct;

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_Ubi]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para listar tablas ubigeo
--Change:		-
--Example:		[dbo].[Usp_List_Ubi]
--================================================= 
CREATE PROC [dbo].[Usp_List_Ubi]
AS
BEGIN

	SELECT	IdDepartment,
			Department 
	FROM	Department

	SELECT	IdProvince,
			Province,
			IdDepartment 
	FROM	Province

	SELECT	IdDistrict,
			District,
			IdProvince
	FROM	District

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Login]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para validar el acceso del usuario al sistema.
--Change:		-
--Example:		[dbo].[Usp_Login] 'admin', 'mO+Qpha+NQvkImJhOUfGbQ=='
--================================================= 
CREATE PROC [dbo].[Usp_Login]
	@ParamIUsername		VARCHAR(100)
	,@ParamIPassword	VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @IdProfile char(5)

	SELECT	@IdProfile	= IdProfile
	FROM	[User]
	WHERE	Username	=	@ParamIUsername
		AND	[Password]	=	@ParamIPassword

	SELECT	IdUser
			,Username
			,[Password]
			,US.RecordStatus
			,IdProfile
			,MT.[Name] AS ProfileName
	FROM	[User] US
	INNER JOIN MasterTable MT
	ON US.IdProfile	= MT.IdMasterTable
	WHERE	Username	=	@ParamIUsername
		AND	[Password]	=	@ParamIPassword

	
	SELECT	mp.IdMenuProfile,
			mp.IdMenu,
			mp.IdProfile,
			me.MenuName,
			mp.RecordStatus,
			me.UrlName,
			ISNULL(me.IdMenuParent,'')	IdMenuParent
	FROM	MenuProfile mp
	INNER JOIN	Menu me
	ON	mp.IdMenu = me.IdMenu
	WHERE	mp.IdProfile = @IdProfile
	AND me.RecordStatus='A'

END


GO
/****** Object:  StoredProcedure [dbo].[Usp_MasterTable_List]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_MasterTable_List]
@ParamIRecordStatus CHAR(1)
AS
BEGIN
	SELECT	IdMasterTable,
			IdMasterTableParent,
			[Name],
			[Order],
			[Value],
			AdditionalOne,
			AdditionalTwo,
			AdditionalThree,
			RecordStatus 
	FROM MasterTable
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Mrg_Customer]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--DESCRIPTION: Permite registrar los customer
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_Mrg_Customer] 
--=================================================
CREATE PROCEDURE	[dbo].[Usp_Mrg_Customer]
	@ParamIIdCustomer		UNIQUEIDENTIFIER
	,@ParamIFirstName		VARCHAR(100)
	,@ParamILastName		VARCHAR(100)
	,@ParamIDocumentNumber	VARCHAR(20)
	,@ParamIPhoneNumber		VARCHAR(20)	
	,@ParamIEmail			VARCHAR(100)
	,@ParamIIdDistrict		INT
	,@ParamIRecordStatus	CHAR(1)	
AS
BEGIN

	MERGE	[dbo].[Customer]	AS	TARGET
	USING(
		SELECT	@ParamIIdCustomer		
				,@ParamIFirstName
				,@ParamILastName		
				,@ParamIDocumentNumber		
				,@ParamIPhoneNumber
				,@ParamIEmail
				,@ParamIIdDistrict
				,@ParamIRecordStatus
		)	AS SOURCE	(
				IdCustomer
				,FirstName
				,LastName
				,DocumentNumber
				,PhoneNumber
				,Email
				,IdDistrict
				,RecordStatus
		)
	ON (TARGET.IdCustomer	=	SOURCE.IdCustomer)
	WHEN MATCHED THEN
		UPDATE SET		
			TARGET.FirstName	=	SOURCE.FirstName
			,TARGET.LastName		=	SOURCE.LastName
			,TARGET.DocumentNumber	=	SOURCE.DocumentNumber			
			,TARGET.PhoneNumber	=	SOURCE.PhoneNumber
			,TARGET.Email	=	SOURCE.Email
			,TARGET.IdDistrict	=	SOURCE.IdDistrict
			,TARGET.RecordStatus	=	SOURCE.RecordStatus
	WHEN NOT MATCHED THEN
		INSERT 
		(	IdCustomer
			,FirstName
			,LastName
			,DocumentNumber
			,PhoneNumber
			,Email
			,IdDistrict
			,RecordStatus
		)
		VALUES
		(	
			SOURCE.IdCustomer
			,SOURCE.FirstName
			,SOURCE.LastName
			,SOURCE.DocumentNumber
			,SOURCE.PhoneNumber
			,SOURCE.Email
			,SOURCE.IdDistrict
			,SOURCE.RecordStatus
		)
	
	OUTPUT
		inserted.IdCustomer;
	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Mrg_Order]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--DESCRIPTION: Permite registrar las cabeceras de las órdenes.
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_Mrg_Order] 
--=================================================
CREATE PROCEDURE	[dbo].[Usp_Mrg_Order]
	@ParamIIdOrder		UNIQUEIDENTIFIER
	,@ParamIDateOrder	DATETIME
	,@ParamITotal		NUMERIC(9,2)
	,@ParamIStatusOrder		CHAR(5)
	,@ParamILocationOrder		CHAR(5)
	,@ParamIIdCustomer	UNIQUEIDENTIFIER	
	,@ParamIBusinessNumber VARCHAR(11)
	,@ParamIBusinessName VARCHAR(200)
	,@ParamIRecordStatus	CHAR(1)	
AS
BEGIN

	MERGE	[dbo].[Order]	AS	TARGET
	USING(
		SELECT	@ParamIIdOrder		
				,@ParamIDateOrder
				,@ParamITotal		
				,@ParamIStatusOrder	
				,@ParamILocationOrder
				,@ParamIIdCustomer
				,@ParamIRecordStatus
				,@ParamIBusinessNumber
				,@ParamIBusinessName				
		)	AS SOURCE	(
				IdOrder
				,DateOrder
				,Total
				,StatusOrder
				,LocationOrder
				,IdCustomer
				,RecordStatus
				,BusinessNumber
				,BusinessName
		)
	ON (TARGET.IdOrder	=	SOURCE.IdOrder)
	WHEN MATCHED THEN
		UPDATE SET		
			TARGET.DateOrder		=	SOURCE.DateOrder
			,TARGET.Total			=	SOURCE.Total
			,TARGET.StatusOrder		=	SOURCE.StatusOrder
			,TARGET.LocationOrder	=	SOURCE.LocationOrder			
			,TARGET.IdCustomer		=	SOURCE.IdCustomer
			,TARGET.BusinessNumber	=	SOURCE.BusinessNumber
			,TARGET.BusinessName	=	SOURCE.BusinessName
			,TARGET.RecordStatus	=	SOURCE.RecordStatus
	WHEN NOT MATCHED THEN
		INSERT 
		(	IdOrder
			,DateOrder
			,CodeOrder
			,Total
			,StatusOrder
			,LocationOrder
			,IdCustomer
			,RecordStatus
			,BusinessName
			,BusinessNumber
		)
		VALUES
		(	
			SOURCE.IdOrder
			,SOURCE.DateOrder
			,[dbo].[FN_GetCodeOrder]()
			,SOURCE.Total
			,SOURCE.StatusOrder
			,SOURCE.LocationOrder
			,SOURCE.IdCustomer
			,SOURCE.RecordStatus
			,SOURCE.BusinessName
			,SOURCE.BusinessNumber
		)
		

		--INSERT INTO OrderStatus
		--VALUES (NEWID(),SOURCE.IdOrder,'00201','00101'
	OUTPUT
		inserted.IdOrder;


	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Mrg_OrderDetail]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--DESCRIPTION: Permite registrar el detalle de las órdenes.
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_Mrg_OrderDetail] 
--=================================================
CREATE PROCEDURE	[dbo].[Usp_Mrg_OrderDetail]
	@ParamIIdOrderDetail	UNIQUEIDENTIFIER
	,@ParamIIdOrder			UNIQUEIDENTIFIER
	,@ParamIIdProduct		UNIQUEIDENTIFIER
	,@ParamIDescription		VARCHAR(3000)
	,@ParamIQuantity		DECIMAL(18,4)
	,@ParamIRecordStatus	CHAR(1)
AS
BEGIN

	MERGE	[dbo].[OrderDetail]	AS	TARGET
	USING(
		SELECT	@ParamIIdOrderDetail
				,@ParamIIdOrder		
				,@ParamIIdProduct	
				,@ParamIDescription	
				,@ParamIQuantity	
				,@ParamIRecordStatus
		)	AS SOURCE	(
				IdOrderDetail
				,IdOrder
				,IdProduct
				,[Description]
				,Quantity
				,RecordStatus
		)
	ON (TARGET.IdOrderDetail	=	SOURCE.IdOrderDetail)
	WHEN MATCHED THEN
		UPDATE SET		
			TARGET.IdOrder			=	SOURCE.IdOrder
			,TARGET.IdProduct		=	SOURCE.IdProduct
			,TARGET.[Description]	=	SOURCE.[Description]
			,TARGET.Quantity		=	SOURCE.Quantity
			,TARGET.RecordStatus	=	SOURCE.RecordStatus
	WHEN NOT MATCHED THEN
		INSERT 
		(	IdOrderDetail
			,IdOrder
			,IdProduct
			,[Description]
			,Quantity
			,RecordStatus
		)
		VALUES
		(	
			SOURCE.IdOrderDetail
			,SOURCE.IdOrder
			,SOURCE.IdProduct
			,SOURCE.[Description]
			,SOURCE.Quantity
			,SOURCE.RecordStatus
		)
	
	OUTPUT
		inserted.IdOrderDetail;
	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListOrderQuantity]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	Cantidad de pedido por mes 
--Change:		-
--Example:		[dbo].[Usp_Rpt_ListOrderQuantity]
--================================================= 
CREATE PROC [dbo].[Usp_Rpt_ListOrderQuantity]
AS
BEGIN	

	SELECT		RIGHT(year(DateOrder),4)+'-'+RIGHT(CONCAT('00',CAST(month(DateOrder)  AS VARCHAR(2))),2) DateGroup
				,COUNT(1)  Quantity 
	FROM		[Order]
	GROUP BY	RIGHT(year(DateOrder),4)+'-'+RIGHT(CONCAT('00',CAST(month(DateOrder)  AS VARCHAR(2))),2)


END


GO
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListOrderQuantityStatus]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	Cantidad de pedido por mes aprobados y rechazados
--Change:		-
--Example:		[dbo].[Usp_Rpt_ListOrderQuantityStatus]
--================================================= 
CREATE PROC [dbo].[Usp_Rpt_ListOrderQuantityStatus]
AS
BEGIN	

	IF OBJECT_ID(N'tempdb..#TMP_QUANTITY') IS NOT NULL
	BEGIN
	DROP TABLE #TMP_QUANTITY
	END

	CREATE TABLE #TMP_QUANTITY
	(		
		[Status] VARCHAR(10) NOT NULL,
		Quantity INT NULL
	)

	INSERT INTO #TMP_QUANTITY
	SELECT	'Aprobado' [Status]
			,0	Quantity 
	
	INSERT INTO #TMP_QUANTITY
	SELECT	'Rechazado' [Status]
			,0	Quantity 
	
	UPDATE #TMP_QUANTITY
	SET Quantity=	(
						SELECT	COUNT(1)  
						FROM	[OrderStatus] 
						WHERE	[Location]		=	'00201' 
								AND	[Status]	=	'00602'
					)
	WHERE [Status]	=	'Aprobado'

	UPDATE #TMP_QUANTITY
	SET Quantity=	(
						SELECT	COUNT(1)  
						FROM	[OrderStatus] 
						WHERE	[Location]		=	'00201' 
								AND	[Status]	=	'00603'
					)
	WHERE [Status]	=	'Rechazado'

	SELECT	[Status] 
			,Quantity
	FROM	#TMP_QUANTITY

END		    



GO
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListOrderQuantityStatusDelivery]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	Cantidad de pedido por pendientes y entregados
--Change:		-
--Example:		[dbo].[Usp_Rpt_ListOrderQuantityStatusDelivery]
--================================================= 
CREATE PROC [dbo].[Usp_Rpt_ListOrderQuantityStatusDelivery]
AS
BEGIN	

	IF OBJECT_ID(N'tempdb..#TMP_QUANTITY') IS NOT NULL
	BEGIN
	DROP TABLE #TMP_QUANTITY
	END

	CREATE TABLE #TMP_QUANTITY
	(		
		[Status] VARCHAR(10) NOT NULL,
		Quantity INT NULL
	)

	INSERT INTO #TMP_QUANTITY
	SELECT	'Pendientes' [Status]
			,0	Quantity 
	
	INSERT INTO #TMP_QUANTITY
	SELECT	'Entregados' [Status]
			,0	Quantity 
	
	UPDATE #TMP_QUANTITY
	SET Quantity=	(
						SELECT	COUNT(1)  
						FROM	OrderFlow 
						WHERE	LocationOrder	=	'00206' 
								AND		Answer	=	'00601'
								AND		FlagActive		=	1
					)
	WHERE [Status]	=	'Pendientes'

	UPDATE #TMP_QUANTITY
	SET Quantity=	(
						SELECT	COUNT(1)  
						FROM	OrderFlow 
						WHERE	LocationOrder	=	'00206' 
								AND		Answer	=	'00606'
								AND		FlagInProcess		=	1
					)
	WHERE [Status]	=	'Entregados'

	SELECT	[Status] 
			,Quantity
	FROM	#TMP_QUANTITY

END		    



GO
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListProductQuantity]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	Cantidad de productos vendidos por modelo
--Change:		-
--Example:		[dbo].[Usp_Rpt_ListProductQuantity]
--================================================= 
CREATE PROC [dbo].[Usp_Rpt_ListProductQuantity]
AS
BEGIN
	
	SELECT	OD.IdProduct
			,P.[Name]
			,SUM(Quantity) Quantity
	FROM	OrderDetail OD
	INNER JOIN	Product P
	ON P.IdProduct	=	OD.IdProduct
	GROUP BY OD.IdProduct,P.[Name]
	ORDER BY Quantity 


END


GO
/****** Object:  StoredProcedure [dbo].[Usp_Upd_Decrease]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para actualizar la merma que se producen en las SubOrder.
--Change:		-
--Example:		[dbo].[Usp_Upd_Decrease]	
--================================================= 
CREATE PROC [dbo].[Usp_Upd_Decrease]
	@ParamIIdOrderDetail		UNIQUEIDENTIFIER
	,@ParamICodeSubOrder		VARCHAR(25)
	,@ParamIQuantityDecrease	NUMERIC(9,2)
AS
BEGIN

	UPDATE	OrderDetail
	SET	Quantity	=	Quantity	-	@ParamIQuantityDecrease
	WHERE	IdOrderDetail	=	@ParamIIdOrderDetail;
	
	UPDATE	SubOrderFlow
	SET	QuantityDecrease	=	@ParamIQuantityDecrease
	WHERE	CodeSubOrder	=	@ParamICodeSubOrder;

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Upd_OrderFlow]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para actualizar el flujo de la orden a partir del IdOrder, LocationOrder y del Answer
--Change:		-
--Example:		[dbo].[Usp_Upd_OrderFlow]	'698D0C51-C86C-4B0B-B2FE-78103EAB3403', '00203', '00602'
--================================================= 
CREATE PROC [dbo].[Usp_Upd_OrderFlow]
	@ParamIIdOrder			VARCHAR(50)
	,@ParamILocationOrder	CHAR(5)
	,@ParamIAnswer			CHAR(5)
AS
BEGIN

	DECLARE	@CFlagTrue					BIT	=	1;
	DECLARE	@CFlagFalse					BIT	=	0;
	DECLARE	@CLastLocation				CHAR(5)	=	'00207';
	DECLARE	@CStatusOrderInProcess		CHAR(5)	=	'00102';
	DECLARE	@CStatusOrderCompleted		CHAR(5)	=	'00103';

	DECLARE	@VLocationOrderFlowActive	CHAR(5);
	
	SELECT	@VLocationOrderFlowActive	=	[OF].LocationOrder
	FROM	OrderFlow	[OF]
	WHERE	[OF].IdOrder	=	@ParamIIdOrder
		AND	[OF].FlagActive	=	@CFlagTrue;

	IF(@VLocationOrderFlowActive	=	@ParamILocationOrder)
	BEGIN
		--Como se trata del mismo Proceso solo actualiza el estado del proceso
		UPDATE	OrderFlow
		SET	Answer	=	@ParamIAnswer
		WHERE	IdOrder	=	@ParamIIdOrder
			AND	LocationOrder	=	@ParamILocationOrder;
	END
	ELSE
	BEGIN
		--Como se trata de otro proceso dentro del flujo, realiza lo siguiente
		--Inactiva el vigente
		UPDATE	OrderFlow
		SET	FlagActive	=	@CFlagFalse
			,DateOrderFlow	=	GETDATE()
		WHERE	IdOrder	=	@ParamIIdOrder
			AND	FlagActive	=	@CFlagTrue;
		--Actualiza el que proceso al que está ingresando
		UPDATE	OrderFlow
		SET	Answer	=	@ParamIAnswer
			,FlagInProcess	=	@CFlagTrue
			,FlagActive	=	@CFlagTrue
			,DateOrderFlow	=	GETDATE()
		WHERE	IdOrder	=	@ParamIIdOrder
			AND	LocationOrder	=	@ParamILocationOrder;
		--Se actualiza el LocationOrder en la tabla Order
		IF(@ParamILocationOrder	=	@CLastLocation)
		BEGIN
			UPDATE	[Order]
			SET	LocationOrder	=	@ParamILocationOrder
				,StatusOrder	=	@CStatusOrderCompleted
			WHERE	IdOrder	=	@ParamIIdOrder;
		END
		ELSE
		BEGIN
			UPDATE	[Order]
			SET	LocationOrder	=	@ParamILocationOrder
				,StatusOrder	=	@CStatusOrderInProcess
			WHERE	IdOrder	=	@ParamIIdOrder;
		END
	END

	--Se registra el paso del proceso de la orden en la tabla OrderStatus
	INSERT INTO	OrderStatus	(	IdOrderStatus
								,IdOrder
								,[Location]
								,[Status]
								,DateOrderStatus)
	VALUES	(	NEWID()
				,@ParamIIdOrder
				,@ParamILocationOrder
				,@ParamIAnswer
				,GETDATE());

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Upd_SubOrderFlow]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para actualizar el flujo de las subordenes a partir del CodeSubOrder
--Change:		-
--Example:		[dbo].[Usp_Upd_SubOrderFlow]	'LAVA202109-000001', '00103'
--================================================= 
CREATE PROC [dbo].[Usp_Upd_SubOrderFlow]
	@ParamICodeSubOrder		VARCHAR(25)
	,@ParamIStatus			CHAR(5)
AS
BEGIN

	DECLARE	@VQuantityStatus		INT	=	0;
	DECLARE @VIdOrder				UNIQUEIDENTIFIER;
	DECLARE @VIdOrderFlow			UNIQUEIDENTIFIER;
	DECLARE @VIdProduct				UNIQUEIDENTIFIER;
	DECLARE @VStatusSubOrderFlow	CHAR(5);
	DECLARE @VLocationOrder			CHAR(5);
	DECLARE @VLocationOrderNext		CHAR(5);
	DECLARE @VOrderNext				INT;
	DECLARE @VOrder					INT;
	DECLARE @VOrderSubProcess		INT;
	DECLARE	@VCodeSubOrderNext		VARCHAR(25)	=	NULL;
	DECLARE @VIdOrderFlowNext		UNIQUEIDENTIFIER;

	DECLARE @VQuantitySubOrders		INT;
	DECLARE @CNumberOne						INT	=	1;
	DECLARE @CIdMTStatusComplete			CHAR(5)	=	'00103';
	DECLARE @CIdMTStatusPending				CHAR(5)	=	'00101';
	DECLARE @CIdMTStatusOrderFlowPending	CHAR(5)	=	'00601';
	DECLARE @CIdMTStatusOrderFlowInProcess	CHAR(5)	=	'00604';
	DECLARE @CIdMTStatusOrderFlowComplete	CHAR(5)	=	'00605';
	DECLARE @CAreaLaundry					CHAR(5)	=	'00204';

	UPDATE	[SubOrderFlow]
	SET	StatusSubOrderMT	=	@ParamIStatus
	WHERE	CodeSubOrder	=	@ParamICodeSubOrder;

	SELECT	@VIdOrderFlow		=	SOF.IdOrderFlow
			,@VLocationOrder	=	PSP.LocationOrder
			,@VOrderSubProcess	=	PSP.OrderSubProcess
			,@VIdProduct		=	PSP.IdProduct
			,@VIdOrder			=	OFL.IdOrder
			,@VOrder			=	PSP.OrderSubProcess
	FROM	SubOrderFlow	SOF
	INNER JOIN	ProductSubProcess	PSP
		ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
	INNER JOIN OrderFlow	OFL 
		ON	 OFL.IdOrderFlow	=	SOF.IdOrderFlow
	WHERE	SOF.CodeSubOrder	=	@ParamICodeSubOrder;

	SELECT	@VQuantityStatus	=	COUNT(DISTINCT(SOF.StatusSubOrderMT))
	FROM	SubOrderFlow	SOF
	WHERE	SOF.IdOrderFlow	=	@VIdOrderFlow

	SELECT	@VOrderNext = NroOrder	+	1
	FROM	OrderFlow
	WHERE	IdOrderFlow	=	@VIdOrderFlow

	SELECT	@VIdOrderFlowNext = IdOrderFlow
	FROM	OrderFlow
	WHERE	IdOrder	=	@VIdOrder
		AND	NroOrder	=	@VOrderNext

	IF	@VQuantityStatus	=	@CNumberOne
	BEGIN
		SELECT	@VStatusSubOrderFlow	=	SOF.StatusSubOrderMT
		FROM	SubOrderFlow	SOF
		WHERE	SOF.CodeSubOrder	=	@ParamICodeSubOrder

		SELECT	@VLocationOrderNext	=	LocationOrder
		FROM	OrderFlow
		WHERE	IdOrder		=	@VIdOrder
			AND	NroOrder	=	@VOrderNext
		
		IF	@VLocationOrderNext	= NULL
			SET @VLocationOrderNext	=	@VLocationOrder

		/*Obteniendo el SubOrder siguiente para pasarlo de estado CREADO a PENDIENTE*/
		SELECT	@VCodeSubOrderNext	=	SOF.CodeSubOrder
		FROM	SubOrderFlow	SOF
		INNER JOIN	ProductSubProcess	PSP
			ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
		WHERE	PSP.OrderSubProcess	=	@VOrderSubProcess + 1
			AND	PSP.IdProduct		=	@VIdProduct
			AND	SOF.IdOrderFlow		IN (	SELECT	 IdOrderFlow
											FROM	OrderFlow
											WHERE	IdOrder	=	@VIdOrder
												AND	NroOrder	=	@VOrderNext
										)
			
		IF	@VCodeSubOrderNext IS NOT NULL
		BEGIN
			UPDATE	SubOrderFlow
			SET		StatusSubOrderMT	=	@CIdMTStatusPending
			WHERE	CodeSubOrder		IN	(
								SELECT SOF.CodeSubOrder
								FROM	SubOrderFlow	SOF
								INNER JOIN	ProductSubProcess	PSP
									ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
								WHERE	PSP.OrderSubProcess	=	@VOrderSubProcess + 1
									AND	PSP.IdProduct		=	@VIdProduct
									AND	SOF.IdOrderFlow		IN (	SELECT	 IdOrderFlow
																	FROM	OrderFlow
																	WHERE	IdOrder	=	@VIdOrder
																		AND	NroOrder	=	@VOrderNext
										)
									)
		END

		IF	@VStatusSubOrderFlow	=	@CIdMTStatusComplete
		BEGIN
			EXEC [dbo].[Usp_Upd_OrderFlow]	@VIdOrder, @VLocationOrderNext, @CIdMTStatusOrderFlowPending;
		END
	END
	ELSE
	BEGIN
		
		/*Obteniendo el SubOrder siguiente para pasarlo de estado CREADO a PENDIENTE*/
		SELECT	TOP 1 @VCodeSubOrderNext	=	SOF.CodeSubOrder
		FROM	SubOrderFlow	SOF
		INNER JOIN	ProductSubProcess	PSP
			ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
		WHERE	PSP.OrderSubProcess	=	@VOrderSubProcess + 1
			AND	PSP.IdProduct		=	@VIdProduct
			AND	SOF.IdOrderFlow		IN (	SELECT	 IdOrderFlow
											FROM	OrderFlow
											WHERE	IdOrder	=	@VIdOrder
												AND	NroOrder	=	@VOrderNext
										)
		
			SELECT	@VQuantitySubOrders=COUNT(1) 
			FROM	SubOrderFlow	SOF
			INNER JOIN	ProductSubProcess	PSP
				ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
			WHERE	PSP.OrderSubProcess	=	@VOrder
				AND	PSP.IdProduct		=	@VIdProduct
				AND	SOF.StatusSubOrderMT	= @CIdMTStatusPending

				
		--TODO DE ESA AREA PASO , SI ES LAVANDERIA
			SELECT @VLocationOrder,@CAreaLaundry
			IF @VCodeSubOrderNext IS NOT NULL
			BEGIN
				IF	@VLocationOrder = @CAreaLaundry 
				BEGIN 
					IF @VQuantitySubOrders = 0 
					BEGIN 
						UPDATE	SubOrderFlow
						SET		StatusSubOrderMT	=	@CIdMTStatusPending
						WHERE	CodeSubOrder		IN	(
											SELECT SOF.CodeSubOrder
											FROM	SubOrderFlow	SOF
											INNER JOIN	ProductSubProcess	PSP
												ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
											WHERE	PSP.OrderSubProcess	=	@VOrderSubProcess + 1
												AND	PSP.IdProduct		=	@VIdProduct
												AND	SOF.IdOrderFlow		IN (	SELECT	 IdOrderFlow
																				FROM	OrderFlow
																				WHERE	IdOrder	=	@VIdOrder
																					AND	NroOrder	=	@VOrderNext
													)
												)						
					END
				END
				ELSE
				BEGIN					
					UPDATE	SubOrderFlow
					SET		StatusSubOrderMT	=	@CIdMTStatusPending
					WHERE	CodeSubOrder		IN	(
										SELECT SOF.CodeSubOrder
										FROM	SubOrderFlow	SOF
										INNER JOIN	ProductSubProcess	PSP
											ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
										WHERE	PSP.OrderSubProcess	=	@VOrderSubProcess + 1
											AND	PSP.IdProduct		=	@VIdProduct
											AND	SOF.IdOrderFlow		IN (	SELECT	 IdOrderFlow
																			FROM	OrderFlow
																			WHERE	IdOrder	=	@VIdOrder
																				AND	NroOrder	=	@VOrderNext
												)
											)					
				END
			END				
				

		EXEC [dbo].[Usp_Upd_OrderFlow]	@VIdOrder, @VLocationOrder, @CIdMTStatusOrderFlowInProcess;
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_ValidateStockByQuantityProduct]    Script Date: 16/10/2021 09:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================
--DESCRIPTION: Valida el stock de insumos para la elaboración de un producto.
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_ValidateStockByQuantityProduct] [{"IdProduct": "1FA19B13-E1FE-4550-B611-0E37CE23B9CF", "Quantity": 50}, {"IdProduct": "76d5f7f6-2bd4-4718-9bef-2f21a381cb9f", "Quantity": 25}]
--=================================================
CREATE PROCEDURE	[dbo].[Usp_ValidateStockByQuantityProduct]
	@ParamIProductJson	VARCHAR(MAX)
AS
BEGIN

	DECLARE	@ParamIListProducts	TABLE	(IdProduct	UNIQUEIDENTIFIER, Quantity	INT);
	DECLARE	@CFlagTrue	BIT	=	1;
	DECLARE	@CFlagFalse	BIT	=	0;
	DECLARE	@VIdSupply	UNIQUEIDENTIFIER; 
	DECLARE	@VNecessaryQuantity	NUMERIC(18,4);
	DECLARE	@VStock	NUMERIC(9,2);
	DECLARE	@VFlagValidate	BIT	=	@CFlagTrue;

	INSERT INTO @ParamIListProducts
	SELECT	IdProduct
			,Quantity
	FROM	OPENJSON(@ParamIProductJson)  
	WITH	(	IdProduct	UNIQUEIDENTIFIER
				,Quantity	INT
			)

	DECLARE	SuppliesCursor	CURSOR FOR
		SELECT	S.IdSupply
				,SUM(SBP.Quantity * LP.Quantity)	AS	NecessaryQuantity
				,S.Stock
		FROM	@ParamIListProducts	LP
		INNER JOIN	SuppliesByProduct	SBP
			ON	LP.IdProduct	=	SBP.IdProduct
		INNER JOIN	Supply	S
			ON	SBP.IdSupply	=	S.IdSupply
		GROUP BY	S.IdSupply, S.Stock
				
	OPEN SuppliesCursor
	FETCH NEXT FROM	SuppliesCursor	INTO	
		@VIdSupply
		,@VNecessaryQuantity
		,@VStock
	WHILE	@@FETCH_STATUS = 0
	BEGIN
		
		IF	@VNecessaryQuantity	>	@VStock
		BEGIN
			SET @VFlagValidate	=	@CFlagFalse;
			BREAK;
		END
		
		FETCH NEXT FROM	SuppliesCursor	INTO	
			@VIdSupply
			,@VNecessaryQuantity
			,@VStock
	END
	CLOSE SuppliesCursor
	
	IF	@VFlagValidate	=	@CFlagTrue
	BEGIN
		OPEN SuppliesCursor
		FETCH NEXT FROM	SuppliesCursor	INTO	
			@VIdSupply
			,@VNecessaryQuantity
			,@VStock
		WHILE	@@FETCH_STATUS = 0
		BEGIN
		
			UPDATE	Supply
			SET	Stock	=	Stock - @VNecessaryQuantity
				,DateUpdate	=	GETDATE()
			WHERE	IdSupply	=	@VIdSupply;

			FETCH NEXT FROM	SuppliesCursor	INTO	
			@VIdSupply
			,@VNecessaryQuantity
			,@VStock
		END
		CLOSE SuppliesCursor
	END

	DEALLOCATE SuppliesCursor;

	SELECT @VFlagValidate	AS	Validate;
	IF	@VFlagValidate	=	@CFlagTrue
	BEGIN
		SELECT	S.[Name]
				,S.Stock
				,MT.[Name]	AS	MeasureUnit
				,S.MinimumStock
		FROM	@ParamIListProducts	LP
		INNER JOIN	SuppliesByProduct	SBP
			ON	LP.IdProduct	=	SBP.IdProduct
		INNER JOIN	Supply	S
			ON	SBP.IdSupply	=	S.IdSupply
		INNER JOIN	MasterTable	MT
			ON	S.MeasureUnit	=	MT.IdMasterTable
		WHERE	S.Stock	<=	S.MinimumStock
	END
	ELSE
	BEGIN
		SELECT	''	AS	[Name]
				,0	AS	Stock
				,''	AS	MeasureUnit
				,0	AS	MinimumStock
	END

END
GO
USE [master]
GO
ALTER DATABASE [MAPESAC] SET  READ_WRITE 
GO
