USE [master]
GO
/****** Object:  Database [MAPESAC]    Script Date: 10/11/2021 2:06:40 ******/
CREATE DATABASE [MAPESAC]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MAPESAC', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQL\MSSQL\DATA\MAPESAC.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MAPESAC_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQL\MSSQL\DATA\MAPESAC_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [MAPESAC] SET COMPATIBILITY_LEVEL = 130
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
ALTER DATABASE [MAPESAC] SET  ENABLE_BROKER 
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
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [MAPESAC]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetCodeOrder]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  UserDefinedFunction [dbo].[FN_GetCodeSubOrder]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  Table [dbo].[BuySupply]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  Table [dbo].[Customer]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[District]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MasterTable]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  Table [dbo].[MenuProfile]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  Table [dbo].[Order]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderFlow]    Script Date: 10/11/2021 2:06:40 ******/
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
	[DateOrderFlow] [datetime] NULL,
	[DateEndOrderFlow] [datetime] NULL,
	[FlagInProcess] [bit] NULL,
	[FlagActive] [bit] NULL,
 CONSTRAINT [PK_OrderFlow] PRIMARY KEY CLUSTERED 
(
	[IdOrderFlow] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderStatus]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductSubProcess]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Province]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubOrderFlow]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubOrderFlowDetail]    Script Date: 10/11/2021 2:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubOrderFlowDetail](
	[IdSubOrderFlowDetail] [uniqueidentifier] NOT NULL,
	[IdSubOrderFlow] [uniqueidentifier] NOT NULL,
	[IdSupply] [uniqueidentifier] NOT NULL,
	[IdProduct] [uniqueidentifier] NOT NULL,
	[QuantityReturn] [numeric](9, 2) NULL,
	[MTLocation] [char](5) NULL,
 CONSTRAINT [PK_SubOrderFlowDetail] PRIMARY KEY CLUSTERED 
(
	[IdSubOrderFlowDetail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SuppliersBySupply]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SuppliesByProduct]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supply]    Script Date: 10/11/2021 2:06:40 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 10/11/2021 2:06:40 ******/
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
INSERT [dbo].[Customer] ([IdCustomer], [FirstName], [LastName], [DocumentNumber], [PhoneNumber], [Email], [IdDistrict], [RecordStatus]) VALUES (N'732928c3-6d91-4191-a704-73dfcd9c5c32', N'no', N'ape', N'454545', N'454545545', N'gasdads@gmail.com', 1, N'A')
INSERT [dbo].[Customer] ([IdCustomer], [FirstName], [LastName], [DocumentNumber], [PhoneNumber], [Email], [IdDistrict], [RecordStatus]) VALUES (N'45012b7d-63fe-4139-ae47-a4f889fd3160', N'qsas', N's', N'454545', N'55454555', N'asdasadsad@gmail.com', 1, N'A')
INSERT [dbo].[Customer] ([IdCustomer], [FirstName], [LastName], [DocumentNumber], [PhoneNumber], [Email], [IdDistrict], [RecordStatus]) VALUES (N'170b3395-f025-4d8f-9fd1-f6181e75c0ff', N'no', N'aa', N'454545', N'4545545', N'adasdsadasd@gmail.com', 1, N'A')
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
INSERT [dbo].[Order] ([IdOrder], [DateOrder], [CodeOrder], [Total], [StatusOrder], [LocationOrder], [IdCustomer], [RecordStatus], [BusinessNumber], [BusinessName]) VALUES (N'7b792845-858b-435f-a8b0-3a9e9053d7b6', CAST(N'2021-10-29' AS Date), N'202110-000003', CAST(3760.00 AS Numeric(9, 2)), N'00103', N'00207', N'45012b7d-63fe-4139-ae47-a4f889fd3160', N'A', NULL, NULL)
INSERT [dbo].[Order] ([IdOrder], [DateOrder], [CodeOrder], [Total], [StatusOrder], [LocationOrder], [IdCustomer], [RecordStatus], [BusinessNumber], [BusinessName]) VALUES (N'91513e43-3bd4-4a7d-a28f-40edada55cc1', CAST(N'2021-10-24' AS Date), N'202110-000001', CAST(1600.00 AS Numeric(9, 2)), N'00103', N'00207', N'732928c3-6d91-4191-a704-73dfcd9c5c32', N'A', NULL, NULL)
INSERT [dbo].[Order] ([IdOrder], [DateOrder], [CodeOrder], [Total], [StatusOrder], [LocationOrder], [IdCustomer], [RecordStatus], [BusinessNumber], [BusinessName]) VALUES (N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', CAST(N'2021-10-24' AS Date), N'202110-000002', CAST(1725.00 AS Numeric(9, 2)), N'00101', N'00201', N'170b3395-f025-4d8f-9fd1-f6181e75c0ff', N'A', NULL, NULL)
GO
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'687306d3-c78b-425f-b698-1302278272df', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', N'82451157-5164-4dfb-8652-581a66595a9b', N'', CAST(25.0000 AS Decimal(18, 4)), N'A')
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'93cb115e-1573-4bde-85da-27741cc7917b', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'', CAST(46.0000 AS Decimal(18, 4)), N'A')
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'a56f27c0-b45b-43be-ba58-4fe353f20464', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'', CAST(20.0000 AS Decimal(18, 4)), N'A')
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'd6448195-f6cc-4a8a-95a7-9e39e88265b3', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'', CAST(15.0000 AS Decimal(18, 4)), N'A')
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'190a37d0-29ad-4f09-a9b4-adec46d70f1c', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'', CAST(30.0000 AS Decimal(18, 4)), N'A')
INSERT [dbo].[OrderDetail] ([IdOrderDetail], [IdOrder], [IdProduct], [Description], [Quantity], [RecordStatus]) VALUES (N'33a29a97-75a3-44d8-bb50-eea88e0dc490', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'', CAST(68.0000 AS Decimal(18, 4)), N'A')
GO
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'abd1abe9-6722-456b-953f-0ef283e7d829', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', 3, N'00203', N'00604', CAST(N'2021-10-24T10:23:24.230' AS DateTime), CAST(N'2021-10-24T10:23:46.387' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'0501db00-5276-42e2-bc09-2081ca1922f2', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', 2, N'00202', N'00601', NULL, NULL, 0, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'46c1b5ab-1667-490d-a3b7-2770ebe71e81', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', 2, N'00202', N'00604', CAST(N'2021-10-24T10:23:10.873' AS DateTime), CAST(N'2021-10-24T10:23:24.230' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'beaec620-d2c1-4bb4-a311-2c4a1478237f', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', 5, N'00205', N'00601', NULL, NULL, 0, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'6d4d4777-bf0e-4b6c-817d-31359b53cdf6', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', 1, N'00201', N'00602', CAST(N'2021-10-29T02:35:10.170' AS DateTime), CAST(N'2021-10-29T02:35:28.110' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'6c6b0236-db46-4dfa-af00-39bffcc0dc8c', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', 5, N'00205', N'00604', CAST(N'2021-10-24T10:23:56.700' AS DateTime), CAST(N'2021-10-24T10:24:03.270' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'ff78add5-7d6b-400c-8a74-40564299b9e3', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', 3, N'00203', N'00601', CAST(N'2021-10-29T02:47:40.093' AS DateTime), CAST(N'2021-10-29T02:47:46.070' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'7b4cdff4-37a1-417c-b7d7-42aace613653', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', 7, N'00207', N'00601', NULL, NULL, 0, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'eb9ddec6-53a4-4944-8fc6-79a5fd19db21', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', 3, N'00203', N'00601', NULL, NULL, 0, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'86e548c6-1562-473a-86df-9421ed71440d', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', 5, N'00205', N'00601', CAST(N'2021-10-29T02:48:13.997' AS DateTime), CAST(N'2021-10-29T02:48:19.460' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'03d64382-0b11-46e6-8577-94d2200b6b84', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', 6, N'00206', N'00601', NULL, NULL, 0, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'521bb257-552d-4a59-b61e-a05040f1a28c', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', 6, N'00206', N'00606', CAST(N'2021-10-29T02:48:19.460' AS DateTime), CAST(N'2021-10-29T02:48:26.977' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'1b5b5ba5-6b31-4d3f-b269-a676b92d8381', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', 2, N'00202', N'00604', CAST(N'2021-10-29T02:35:28.110' AS DateTime), CAST(N'2021-10-29T02:35:52.140' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'75758d2a-6aea-4d30-8697-b21bc549bf07', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', 7, N'00207', N'00606', CAST(N'2021-10-24T10:24:23.270' AS DateTime), NULL, 1, 1)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'486ceaf7-6fba-4994-a8ae-b73c13341512', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', 1, N'00201', N'00601', CAST(N'2021-10-24T10:22:51.580' AS DateTime), NULL, 1, 1)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'fa786a59-0f9a-421a-b466-bacf40070608', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', 4, N'00204', N'00601', NULL, NULL, 0, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'00dc3f28-364a-40c9-b953-ddb1913b6aa0', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', 1, N'00201', N'00602', CAST(N'2021-10-24T10:23:00.800' AS DateTime), CAST(N'2021-10-24T10:23:10.873' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'409f53eb-4397-4481-955d-e67fe50f3fef', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', 7, N'00207', N'00606', CAST(N'2021-10-29T02:48:26.977' AS DateTime), NULL, 1, 1)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'b733ce14-94a4-4c28-9a72-e6bfd48b8b0c', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', 4, N'00204', N'00604', CAST(N'2021-10-24T10:23:46.387' AS DateTime), CAST(N'2021-10-24T10:23:56.700' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'51f675a0-db1e-43b0-8fc2-e9c92e97318b', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', 4, N'00204', N'00604', CAST(N'2021-10-29T02:47:46.070' AS DateTime), CAST(N'2021-10-29T02:48:13.997' AS DateTime), 1, 0)
INSERT [dbo].[OrderFlow] ([IdOrderFlow], [IdOrder], [NroOrder], [LocationOrder], [Answer], [DateOrderFlow], [DateEndOrderFlow], [FlagInProcess], [FlagActive]) VALUES (N'd260cd40-efb7-4876-93a0-ff5e84d2357d', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', 6, N'00206', N'00606', CAST(N'2021-10-24T10:24:03.270' AS DateTime), CAST(N'2021-10-24T10:24:23.270' AS DateTime), 1, 0)
GO
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'b9e7094f-64ec-4fe4-a44d-08c1a21d711e', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00202', N'00604', CAST(N'2021-10-29T02:35:45.143' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'bebb21ba-0d9c-43d2-a1b9-0e7faaf10bfd', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00202', N'00601', CAST(N'2021-10-29T02:35:28.110' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'da2e75f7-1d3f-40f1-88b7-1d174af33b3f', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00204', N'00601', CAST(N'2021-10-24T10:23:24.230' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'8f884948-5a9d-48a9-902a-2aba04a1394a', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00203', N'00604', CAST(N'2021-10-24T10:23:19.330' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'b4a88b1e-8ae9-46ce-91a7-3175593b421e', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00204', N'00601', CAST(N'2021-10-29T02:47:46.070' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'a558fe11-651d-4e55-95c9-396496a1fa9b', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00201', N'00602', CAST(N'2021-10-24T10:23:00.783' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'e804b6e1-2d45-4b66-83fe-39b2d1f43ad5', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00204', N'00604', CAST(N'2021-10-24T10:23:28.463' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'd1291838-e50b-43c6-9056-408b87f76b6b', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00204', N'00604', CAST(N'2021-10-29T02:48:00.413' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'8c09e730-8312-47a2-9905-43a0762d8ae7', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00207', N'00606', CAST(N'2021-10-24T10:24:03.270' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'0d814efd-3769-45ad-a17b-488a7a9195db', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00204', N'00604', CAST(N'2021-10-24T10:23:31.617' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'e693dacb-f560-4c44-86e1-52df91a93b1e', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00201', N'00602', CAST(N'2021-10-29T02:35:28.100' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'efc6acd6-2774-4e4d-9f53-560e1a0c478b', N'c4085304-c8a1-40eb-8112-d1d61ec0ed87', N'00201', N'00601', CAST(N'2021-10-24T10:22:51.580' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'0ca94073-9d09-49f5-bc2e-5bb639fa3da2', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00203', N'00601', CAST(N'2021-10-29T02:47:40.093' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'30c3015e-cd58-4eb3-81fb-783be0a4d5d0', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00204', N'00604', CAST(N'2021-10-29T02:45:46.880' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'8448c558-39b0-41ad-95d3-7c43c8a9f6d1', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00202', N'00601', CAST(N'2021-10-24T10:23:00.803' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'35a62e16-5e9e-4618-83be-7d1755ce9deb', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00204', N'00604', CAST(N'2021-10-24T10:23:41.347' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'b9247115-57af-4b98-991c-80196dc8ed7e', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00206', N'00606', CAST(N'2021-10-29T02:48:26.963' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'0ea52105-1185-40b5-ac75-816a532aa630', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00204', N'00604', CAST(N'2021-10-29T02:48:05.337' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'd43580c3-21af-484c-9a4a-8aaa5ce56669', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00204', N'00604', CAST(N'2021-10-24T10:23:38.250' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'63dc9f29-2efe-47ca-b6cf-8d2743ab5679', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00205', N'00601', CAST(N'2021-10-24T10:23:46.387' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'02cf97ac-57b7-4359-a7db-8fdc3dad54d4', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00202', N'00604', CAST(N'2021-10-24T10:23:07.563' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'55de3a3d-9930-4df8-8952-9e223135b95c', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00201', N'00601', CAST(N'2021-10-29T02:35:10.170' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'5c0f8258-1156-48da-b09d-adc769b0f885', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00205', N'00604', CAST(N'2021-10-29T02:47:31.740' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'a3265082-0338-4c78-befd-b0b20043071a', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00206', N'00606', CAST(N'2021-10-24T10:24:03.253' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'b9e7c688-502e-445a-affa-c4aedb69a706', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00204', N'00604', CAST(N'2021-10-29T02:45:55.270' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'15452849-2c01-4b05-ba90-c4df2c06f7a0', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00205', N'00601', CAST(N'2021-10-29T02:48:13.997' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'd2f41df8-2f7e-4420-8164-d1751782bc69', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00204', N'00604', CAST(N'2021-10-29T02:45:51.430' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'8a04afa3-4e96-4aa8-a3fc-dbdf8a6d50b8', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00203', N'00601', CAST(N'2021-10-24T10:23:10.877' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'66c39ede-76a0-496c-aa24-dd4102c9ddc2', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00203', N'00604', CAST(N'2021-10-29T02:35:52.140' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'a30cb82f-62d8-41cf-a5e2-ea13f45cd1e6', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00206', N'00601', CAST(N'2021-10-24T10:23:56.703' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'd6ed03a9-8853-4739-adf9-f4aa51667d8d', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00207', N'00606', CAST(N'2021-10-29T02:48:26.977' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'cdb082d1-a715-4c45-809f-f6daf12353cb', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00205', N'00604', CAST(N'2021-10-24T10:23:52.007' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'504e07d1-c6e9-4c64-8a96-fa5b52c65f15', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00204', N'00604', CAST(N'2021-10-24T10:23:34.967' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'd2ef9997-d345-4560-945b-fad121519599', N'7b792845-858b-435f-a8b0-3a9e9053d7b6', N'00206', N'00601', CAST(N'2021-10-29T02:48:19.460' AS DateTime))
INSERT [dbo].[OrderStatus] ([IdOrderStatus], [IdOrder], [Location], [Status], [DateOrderStatus]) VALUES (N'c271d004-9c4b-4b1d-adcd-fc5062e083ba', N'91513e43-3bd4-4a7d-a28f-40edada55cc1', N'00201', N'00601', CAST(N'2021-10-24T10:22:21.140' AS DateTime))
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
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'f695a5ab-0648-49c2-bc26-042085680d0e', N'9c50df89-e2b3-46c2-b549-974ff9f294d1', N'ff78add5-7d6b-400c-8a74-40564299b9e3', N'00103', N'COST202110-000005', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'a5a9792b-7c70-4e5c-b1c8-7884ee8bdeff', N'fa786a59-0f9a-421a-b466-bacf40070608', N'00104', N'LAVA202110-000011', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'cd55112c-384d-4397-ab28-12036db29173', N'51f675a0-db1e-43b0-8fc2-e9c92e97318b', N'00103', N'LAVA202110-000013', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'cd55112c-384d-4397-ab28-12036db29173', N'b733ce14-94a4-4c28-9a72-e6bfd48b8b0c', N'00103', N'LAVA202110-000004', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'522e8138-d318-4f19-8939-2dcfccbc4456', N'4fae72be-ec60-438d-beab-065fff3b73ec', N'fa786a59-0f9a-421a-b466-bacf40070608', N'00104', N'LAVA202110-000007', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'ce6e2d78-a301-4265-aa8b-112cd68e1c31', N'46c1b5ab-1667-490d-a3b7-2770ebe71e81', N'00103', N'CORT202110-000002', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'880a1959-ae56-4e4c-baa6-0b2e211b2c42', N'6c6b0236-db46-4dfa-af00-39bffcc0dc8c', N'00103', N'ACAB202110-000002', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'880a1959-ae56-4e4c-baa6-0b2e211b2c42', N'86e548c6-1562-473a-86df-9421ed71440d', N'00103', N'ACAB202110-000005', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'6c9407ca-d9e3-4d05-a07a-856b1c1ddfba', N'86e548c6-1562-473a-86df-9421ed71440d', N'00103', N'ACAB202110-000006', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'9c50df89-e2b3-46c2-b549-974ff9f294d1', N'abd1abe9-6722-456b-953f-0ef283e7d829', N'00103', N'COST202110-000002', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'a35e87cc-e468-4f84-80e4-560072774a4b', N'86eee1a7-cf27-4a5a-891a-03ff055d1cf8', N'b733ce14-94a4-4c28-9a72-e6bfd48b8b0c', N'00103', N'LAVA202110-000001', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'5e6d3b67-2219-43b6-b0c6-cdfbcdd783c3', N'b733ce14-94a4-4c28-9a72-e6bfd48b8b0c', N'00103', N'LAVA202110-000003', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'a8e902df-be37-4a14-9f99-606b61b2a645', N'f5ae6337-0cc3-4962-a5d5-21ad02dcb802', N'eb9ddec6-53a4-4944-8fc6-79a5fd19db21', N'00104', N'COST202110-000003', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'bfc14ecf-dd40-4e11-9da4-5bb9e2854f9c', N'b733ce14-94a4-4c28-9a72-e6bfd48b8b0c', N'00103', N'LAVA202110-000005', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'a2733255-bb66-4915-a9ed-639a2addcc95', N'0923d754-85f2-4b17-9a1f-9729783caa5e', N'abd1abe9-6722-456b-953f-0ef283e7d829', N'00103', N'COST202110-000001', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'853311c8-0f5d-453e-947c-886faddbe30a', N'beaec620-d2c1-4bb4-a311-2c4a1478237f', N'00104', N'ACAB202110-000004', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'd0cf7fca-8ce5-4004-8be0-dbbbb5480745', N'0501db00-5276-42e2-bc09-2081ca1922f2', N'00101', N'CORT202110-000004', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'edba6885-c870-4ff9-a48d-3bd902316b3c', N'b733ce14-94a4-4c28-9a72-e6bfd48b8b0c', N'00103', N'LAVA202110-000002', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'a7bc3851-6370-4fea-b735-818b3c99021a', N'86eee1a7-cf27-4a5a-891a-03ff055d1cf8', N'51f675a0-db1e-43b0-8fc2-e9c92e97318b', N'00103', N'LAVA202110-000016', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'b53d7881-19e1-4ba5-82bc-e0d1e0832fb7', N'beaec620-d2c1-4bb4-a311-2c4a1478237f', N'00104', N'ACAB202110-000003', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'b3a5421d-1215-478f-afc9-948f49126276', N'eef0c80b-a9b6-4a60-976f-fdbc789d68fa', N'fa786a59-0f9a-421a-b466-bacf40070608', N'00104', N'LAVA202110-000012', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'6c9407ca-d9e3-4d05-a07a-856b1c1ddfba', N'6c6b0236-db46-4dfa-af00-39bffcc0dc8c', N'00103', N'ACAB202110-000001', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'0923d754-85f2-4b17-9a1f-9729783caa5e', N'ff78add5-7d6b-400c-8a74-40564299b9e3', N'00103', N'COST202110-000006', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'2b43078d-9a17-4e9a-abca-cca19122eaa3', N'1b5b5ba5-6b31-4d3f-b269-a676b92d8381', N'00103', N'CORT202110-000006', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'998e011d-022a-4aeb-810e-f5ca176b7c12', N'eb9ddec6-53a4-4944-8fc6-79a5fd19db21', N'00104', N'COST202110-000004', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'5035efe8-12fb-46e7-a95d-91da0e576797', N'0501db00-5276-42e2-bc09-2081ca1922f2', N'00101', N'CORT202110-000003', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'09f37e50-5647-414e-81ae-abe12039bf83', N'edba6885-c870-4ff9-a48d-3bd902316b3c', N'51f675a0-db1e-43b0-8fc2-e9c92e97318b', N'00103', N'LAVA202110-000017', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'ece237cc-8190-4e5c-b320-6fb0391c299f', N'fa786a59-0f9a-421a-b466-bacf40070608', N'00104', N'LAVA202110-000008', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'bfc14ecf-dd40-4e11-9da4-5bb9e2854f9c', N'51f675a0-db1e-43b0-8fc2-e9c92e97318b', N'00103', N'LAVA202110-000014', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'2c469a79-288c-4e2b-a46c-743386014fdc', N'51f675a0-db1e-43b0-8fc2-e9c92e97318b', N'00103', N'LAVA202110-000015', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'ce6e2d78-a301-4265-aa8b-112cd68e1c31', N'1b5b5ba5-6b31-4d3f-b269-a676b92d8381', N'00103', N'CORT202110-000005', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'9792765d-2fec-4864-a834-857b93b3318f', N'fa786a59-0f9a-421a-b466-bacf40070608', N'00104', N'LAVA202110-000009', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'96003351-9d78-4acb-a79d-d701f0aac80e', N'5e6d3b67-2219-43b6-b0c6-cdfbcdd783c3', N'51f675a0-db1e-43b0-8fc2-e9c92e97318b', N'00103', N'LAVA202110-000018', CAST(N'2021-10-29' AS Date), CAST(N'2021-10-29' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'db53a292-d6b7-4ac5-95a3-3efc9cb3fbbe', N'fa786a59-0f9a-421a-b466-bacf40070608', N'00104', N'LAVA202110-000010', CAST(N'2021-10-24' AS Date), NULL, NULL)
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'2b43078d-9a17-4e9a-abca-cca19122eaa3', N'46c1b5ab-1667-490d-a3b7-2770ebe71e81', N'00103', N'CORT202110-000001', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
INSERT [dbo].[SubOrderFlow] ([IdSubOrderFlow], [IdProductSubProcess], [IdOrderFlow], [StatusSubOrderMT], [CodeSubOrder], [DateSubOrder], [DateEndSubOrder], [QuantityDecrease]) VALUES (N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'2c469a79-288c-4e2b-a46c-743386014fdc', N'b733ce14-94a4-4c28-9a72-e6bfd48b8b0c', N'00103', N'LAVA202110-000006', CAST(N'2021-10-24' AS Date), CAST(N'2021-10-24' AS Date), CAST(0.00 AS Numeric(9, 2)))
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'23801e19-fb0e-4089-8219-00090e423bfc', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'68636015-c4af-4ede-988f-00bd994e7e11', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'176aab6e-0ad3-44aa-a519-00efde27bd25', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'42bd3817-912c-4362-915e-00fb96b9b3cd', N'd1a4ab78-8483-4d59-8377-744d48bea8ba', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1783d81b-c930-4b5e-8f18-012244119001', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'98ae502a-2653-4298-9b82-01a5960eaa3e', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'60d528bf-1eb5-40cd-b334-01b072c2d3da', N'e9433b54-fd86-4491-8545-a0829b3a7f9f', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5234b8ca-b374-4adc-8c61-01e33e21d025', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e53d5a96-8e76-4c21-b325-0214e172cc90', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4b70b823-d03e-4523-99d2-02d91c19c9f9', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'd848e787-625c-44f5-a6c6-93882ce82172', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'24851b24-db70-40a4-ae47-02db50af826e', N'cd5d0119-c210-4dcd-8208-f1b7e45593d7', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4db1964a-1725-4931-ac3b-0363b509534e', N'a28c9408-c96e-4a4e-8cb5-cdf1ea119927', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(2.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'22b91a2b-cfa2-4466-b648-03ad433f52e6', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b90a5488-31f1-4987-93f5-03aebaedfeb2', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4e97c795-548e-4fcb-bb1d-03c98af3ced5', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9c5b6dac-9e79-432d-aa79-040f9d71428c', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'409eb0b2-b519-4d9d-bdc8-041571632bad', N'1a61806f-419e-468d-aced-59d7b54031ff', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'01d2356d-c923-4968-9a1f-045399a1dc8b', N'b3a5421d-1215-478f-afc9-948f49126276', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9eaebcd0-f469-484a-bbec-0476d420a076', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c5f83f6b-97fd-472d-bb07-05bcb2499406', N'b4cf17fa-9529-46fc-b5d4-ad1ead14f6f2', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f7895a03-753d-4197-a489-05f9fc1af748', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'664673d6-cd5b-47bd-a4fd-060064add9d4', N'6cd90efa-e2dd-4682-8e1d-aa8b2cc44fe6', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'57a01925-f48c-440e-a24c-070e9b7a02d8', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'df699ec1-760c-437b-b4ff-0719f9892fe7', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e5935a4a-e0d6-4a6b-b24d-0742fa7f6ea7', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cf91071b-6afa-4ce1-bc1d-075304584dda', N'09f37e50-5647-414e-81ae-abe12039bf83', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aad38347-9921-451e-b46b-07df94d2d322', N'b3a5421d-1215-478f-afc9-948f49126276', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5d23fe74-10b8-4aca-9b35-07e825735d4b', N'b3a5421d-1215-478f-afc9-948f49126276', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bf1b5e6a-b660-4981-b578-08d0db2ed06f', N'd0a3eb8a-e0ff-4210-920e-f18bfefd6543', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8978c05b-938f-4384-b423-08d4f9e9e535', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'c68be214-6c7f-460b-8391-2f5408127068', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dc8f16b0-0bcd-4a48-a977-08e8d3f8c560', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'27f47bb1-c5fa-4e4e-8612-09036f1c890f', N'a7fd91ec-71c8-4b67-90ec-fb0f9fb59c28', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'267e9e33-3481-48c6-85e0-0913d05b6638', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'907b8889-3c3d-49e0-a331-09303dc6af6a', N'a8825d15-24c8-4dd5-b8a8-cae87befd1b1', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3b5a1986-d2fd-4bfe-bb28-093673dd931b', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4f239ed2-f6dc-49bf-9507-098d470f65b8', N'e789f151-4fd8-4e96-9afb-cdd1ba15d866', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'51d8c01b-d06f-4608-b054-09e7cf92bf05', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'462c375d-5dd7-4ff1-91aa-09e88b9a64fb', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bf787e9e-161b-46b7-8e47-0a6cf1e6fe4a', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4d62e4b5-bb1b-42e6-9e2a-0bfd47abf96c', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8898c9fe-ebca-4f8b-a2ca-0c11c3a07a6d', N'1c589b8f-5cee-4ccf-8af1-194107587e9f', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'70632bae-6221-40e2-880d-0c6201d63d1f', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ebd353e1-f064-42ad-92d0-0ccedfce7eb8', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'990037dd-64c2-4958-921d-0da4564215aa', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'72f3153e-d75a-4b6c-9682-0de7df90767f', N'a45cf8ed-9a89-48eb-874d-1b609c86025b', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'45552769-e619-4a2d-90b8-0dea5161b412', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e7b93721-d4cd-40f5-97a6-0e01ab82c74b', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'91938146-b2f9-4f6d-ac2f-0e2674669345', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aafc96be-f1ca-40a5-b943-0e4de67002c8', N'8fce37b9-b8e8-47fe-98e8-13ea1e275e94', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cb87f633-b9e2-4a02-b6d0-0e60e386cfe4', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5f2172a9-9b5a-496f-bd4c-0e957969cc7d', N'b6390530-20ea-48a7-9c20-598c93288ff4', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2198b88d-08ed-4c32-9407-0e963d68b732', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b9022b01-0fd3-4ab4-8da5-0f6bf5b833ad', N'09f37e50-5647-414e-81ae-abe12039bf83', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ae15b24a-0725-4eab-9e80-0f9b6b156519', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dd20bbb6-97a6-469a-942d-101388e19b4d', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a912f0ef-f07c-4529-b99b-10293298248c', N'b3a5421d-1215-478f-afc9-948f49126276', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8b0f4a19-713d-49a4-bf96-106c10bcea75', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'030cd3e5-46b2-4156-a549-109db57dcf7f', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b907984a-352e-45af-8257-11965ba1cfc5', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'837ae6eb-05df-4997-aed1-428681ef566c', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'044af64a-b9ab-4640-89ee-1216bf2f2249', N'6b68e459-970f-4164-98b7-2d8c7d1d773d', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(5.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7c66a4cc-2dea-4aae-8369-12b4d7f7b0fb', N'd9851cd8-0fee-45da-accd-2cf8e6826ac9', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'93124047-7c82-4047-bde8-12ef057c45aa', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'37cc3e18-cd51-4179-800d-12fa3cfe2e73', N'6f628150-e039-48c9-b65d-e0746d66f326', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'baec0add-5861-474c-9230-1304e0ab0004', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'69333dad-70eb-4ce7-bfcc-13144162b244', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bb23f405-30bb-4dfa-a311-13a237fca2cc', N'256e9eb5-3ac5-4699-a979-8d5e5a5186f7', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'20cbbd44-e10e-46f5-9312-13c533d5cd3d', N'09f37e50-5647-414e-81ae-abe12039bf83', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fe004c31-5b9e-41f1-ba43-141adc4bdc47', N'c1e7620a-86af-46fd-817e-e702acaa6be9', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7caa1455-2b56-478b-8149-1425b4ece427', N'7f03a068-01fc-4ddd-9bf5-73f47906f2a5', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'23431964-52b1-4f7c-a62b-1524dca366d7', N'56d16c28-d70b-426d-afd9-5d541d354ec0', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd94f4a9a-b69c-45e9-be1e-1543dda4d3d0', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'31f45360-2ab0-4a7f-93e4-157afed3dc9b', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b25de497-4706-4a15-9db3-15a9a6c3d497', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'd848e787-625c-44f5-a6c6-93882ce82172', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7f2f5134-0f18-4a62-a55e-15ad38065930', N'53d5f9ef-f674-4811-ad96-ca6a218a0a8f', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4e3e8ffc-dbf3-47ba-9164-165fe393a944', N'cd2ef07a-e046-49c9-aa76-6842ae6ad28f', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'993c883a-f329-40ec-8801-17271464f4e9', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'73b9718f-8f9d-4690-bb50-176150007ed1', N'b3a5421d-1215-478f-afc9-948f49126276', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fec89f4e-f0e1-45c5-bc9d-176c71ddd0e4', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e7cf3476-6b09-4359-9db0-17a44950efcc', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'82d5de37-c308-4bb6-97c9-18084071d755', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'357f02c3-8dcb-447e-bf13-181fea45ae1c', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'55365485-652b-4a13-8960-186b83d6b3a1', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5a20a8b9-764d-4e16-ba50-1876be265ec1', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dd519f99-0711-4d56-af41-189a5a94f448', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'22dd6290-d996-460b-a260-18b49ba0a65c', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6b7b2e00-949c-4a43-ab07-18cd80edfcb8', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e315e380-49f6-461c-9171-18dd1daebffe', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd4139a68-4526-43c7-a889-18f37a4ddf4b', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'737f424e-b5b8-4fdc-ae00-1957009910b6', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1aebef4d-d5b9-4817-831a-1970d2fc3c22', N'a8825d15-24c8-4dd5-b8a8-cae87befd1b1', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'43c5f2a9-20af-4605-a360-199edb262bb9', N'1a61806f-419e-468d-aced-59d7b54031ff', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ebefd409-1411-4808-90c5-1a3606eacc88', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5cf81f49-0d67-4ac1-82f9-1a3a915699ac', N'8fce37b9-b8e8-47fe-98e8-13ea1e275e94', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd3470acb-1191-42a8-a4cd-1aa30a0ef441', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2b3b3490-6d39-40a7-8b39-1aeb2d4c4407', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cce76394-7f1d-4eac-ba70-1b19c2bf4742', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7b3b02ba-02aa-4a4d-ac68-1be1c6334c6e', N'c990165b-1298-49db-a494-312a2c09615e', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1d578906-4dcc-4625-9e90-1c2a149bbb27', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'837ae6eb-05df-4997-aed1-428681ef566c', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'42cbb672-8201-45ac-82e0-1c3729cfe789', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bb9d2802-8bc2-4cf4-b035-1c81ea8a4b9e', N'7e716999-2edb-4c89-baef-adc57787c0d1', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c7fbc5b2-c21a-4e52-b6c0-1cbae1e24ecb', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'93bdbe0d-a00a-4f8b-b89b-1d6a84dc5c76', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'db8b635a-9715-495a-9267-c9db156af748', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'08dcd545-4cf0-4911-a08d-1d7d2110de5c', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'69de4c4a-6bfb-4351-9f61-1dce5e483cd3', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b6e9f781-a00e-448e-9636-1de117b0c97c', N'09f37e50-5647-414e-81ae-abe12039bf83', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b75b7526-94f7-47a2-ac83-1df47749f894', N'c1e7620a-86af-46fd-817e-e702acaa6be9', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c74e26b8-e066-4d10-b6e5-1dfdbaea64a1', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fdaa62eb-40cb-47d2-9bf0-1e189302f0cf', N'f5840962-cea2-4252-99ba-5f1204b0dfcd', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'52b6c0c5-2689-45b0-b497-1e74b6084de7', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9395745a-b062-4896-80de-1eb3504cacb5', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'01580a0c-460f-49b4-b971-1eb5f5a82ac7', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3ad9fb3a-42a3-4420-b7fc-1ec680afa8c8', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'184bde64-2b1b-4839-b2a2-1ef0e24fb691', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'26571d3e-ce17-4b0d-b8a1-1efa8362b5e5', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'147107c7-42f6-49b6-8343-1f577340f6d7', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1ce0f03e-479e-4b89-87e0-1f6d3ea3b572', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'066ce31b-63ab-4ac2-a788-1f7a04763976', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c5f84a63-82c7-4ab8-9493-200dde4339cb', N'e5d3d3d4-49fc-40d2-9d06-fe1d0cc220a4', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'22e9e175-2ee5-43bf-9281-20625b435cfb', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b87c4fff-38d4-4f85-8991-2067d71d619a', N'6b68e459-970f-4164-98b7-2d8c7d1d773d', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'eacccef5-65c1-4591-a3fe-2074c6a07e4f', N'e5d3d3d4-49fc-40d2-9d06-fe1d0cc220a4', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd9cadef9-1356-4015-851f-20ce70312aa7', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'65275631-cf4d-4c56-ac88-20d4f15e593e', N'a7fd91ec-71c8-4b67-90ec-fb0f9fb59c28', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'68339724-4dff-485f-bccc-20f111a49363', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f6df9438-3b6b-4878-988d-20fc11255a28', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'38ce5786-8f93-4a00-b070-214ac64643a9', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1aee9907-74d3-43f9-a12b-214b6b31b06e', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd24b56f8-910e-4e1f-ad84-21a8617c30a7', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'837ae6eb-05df-4997-aed1-428681ef566c', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8290f8e4-bebd-4667-ae34-21b84d36c998', N'09f37e50-5647-414e-81ae-abe12039bf83', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9654a22e-07f4-4e0c-b304-2226178e83f8', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'713af783-69bd-4646-b3f9-2298ed761a94', N'b3a5421d-1215-478f-afc9-948f49126276', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'792d6507-8426-4524-af40-22b65f794559', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'636a7a21-380a-48b7-b5e3-22f65d40d344', N'7f03a068-01fc-4ddd-9bf5-73f47906f2a5', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'71dc6151-1813-44e0-bf36-23299081a074', N'56d16c28-d70b-426d-afd9-5d541d354ec0', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b02dbc65-14be-48fb-ba27-23ae8d415a05', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'28bfb023-b1c8-49c1-8578-240b0f97b054', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6dbbfc9f-f104-4419-8e9c-240ebc4c6b22', N'256e9eb5-3ac5-4699-a979-8d5e5a5186f7', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5df4b62e-cda7-4b1b-98c4-2474aa0e1f5e', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ff1b1e6b-795d-42c2-8c67-24d7af2083af', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'eacbebbc-5a59-429c-bbf7-25394ed42624', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9c1fbe6b-35ef-4599-a4e2-2560dcc8103e', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'32256ed7-44db-42cf-b015-25dd7a45acd3', N'd9851cd8-0fee-45da-accd-2cf8e6826ac9', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e981f227-0c87-47da-ba29-26af3e1b74cc', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'844b6bdf-9d8f-426b-8b30-274dbcf43e9f', N'a7fd91ec-71c8-4b67-90ec-fb0f9fb59c28', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'484d03d9-b699-43e7-9fae-2798fe2c1d00', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6ff17c98-f378-4c6b-bbab-27fcb03cfd49', N'7f03a068-01fc-4ddd-9bf5-73f47906f2a5', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4962cc67-23b4-4642-9b61-2828d42d77d0', N'1fa1d745-4917-47f0-9007-488efa25cf37', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'67b4b18f-1ab5-47d7-8285-287231b225ac', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9b2346e2-4f3c-4ad9-8c46-2881ca72457b', N'd0a3eb8a-e0ff-4210-920e-f18bfefd6543', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4eb8ddda-6d7e-45bc-9547-28be9fbb794a', N'6b68e459-970f-4164-98b7-2d8c7d1d773d', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0befe9b8-1f03-404d-aabe-28f8e7769eff', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1d8076b9-fc15-409f-b66d-299dd0de0b4e', N'7f03a068-01fc-4ddd-9bf5-73f47906f2a5', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'791542dd-010a-473f-8671-29bd8ba2bb56', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a8af1ba6-a0d5-45bc-b82c-29e3acbe9039', N'b3a5421d-1215-478f-afc9-948f49126276', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'916ee820-2908-4c52-aea5-2a03286bcc20', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e74a9fb0-599a-4386-b1e9-2a1a76bfbb40', N'd9851cd8-0fee-45da-accd-2cf8e6826ac9', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bbaa7e82-8aa8-464a-a7d9-2a96fcedf7b7', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'daa53307-7f7c-422d-884b-2ad5c9dfa84f', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b5a3d5ee-38a1-4f8c-b0ca-2af1a7e50ebe', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'39ef5319-0706-4b2d-8c4b-2b47d2618894', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9373371f-6907-42d3-bf6a-2bd2ba77f0e9', N'd9851cd8-0fee-45da-accd-2cf8e6826ac9', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'549beb73-ed17-4850-8fc2-2c20c7cf3b2c', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7b865514-66fd-4d09-a58c-2c36b0da16f6', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'221ebef0-a633-436b-a22f-2c49efb49e79', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2ebb7def-6fd8-496c-8f34-2cbefdb27826', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'05c74a47-ae40-4b96-b756-2cdcaa6e6b56', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b7265102-7b68-477f-af56-2ce86a52b225', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'36b0d6ce-1232-4289-a7f1-2d04af358faa', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7550711f-76f2-4921-ada3-2d42cb2d51f0', N'edd617e6-84e6-47d3-bb07-9ad9b5a12af9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40b48623-262d-4225-974b-2d6ce8498595', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'837ae6eb-05df-4997-aed1-428681ef566c', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'576e98af-b7ec-4cbd-9611-2d8b508e0f53', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7dc12a27-c8a0-46eb-8c50-2d8d423dcc38', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'42d851e4-11d9-4eae-8ba6-2d911aea9766', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a208fbd7-a5d6-4b95-be52-2df0cd8bd108', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'48cba1f8-b98b-4edd-a6f1-2dff1af5da54', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'32c4d6c8-dcb4-4710-bec8-2eaa062ff06f', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dfaf1384-8e44-4433-b013-2ec271175ba8', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'33dd9229-d1e2-4535-81c0-2fc96b7eec24', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'597c64a3-e247-4cb2-8029-30117c8b8d67', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ba69a939-3983-4cd0-b890-3019becea8b5', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5a519256-19c1-4a28-ae66-3086794e01b5', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c754a3aa-4713-464e-b351-311bed2b5942', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2d1fdbba-b4e1-4643-9900-3144c4eedce9', N'5c229e74-547d-4d82-8c72-24c42db2e0ad', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ea981b29-7fa2-447f-ba0e-314d8901db54', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd13eb139-6adb-4ffa-9b5f-3272e56020db', N'5c229e74-547d-4d82-8c72-24c42db2e0ad', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5b98814f-a224-4f7e-87cf-32bfa3d09bd8', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2c4c0a05-3194-4f54-949d-330c8b8d9f99', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8ea4a8a0-7ce7-48f2-bd6c-335e2773d5a5', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'211bbbe0-bc92-48c3-8d7c-339c502f3ab8', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd3a857ed-9fb4-472e-a133-33a3f57cb41a', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'67187d6a-9fab-4d17-af7f-340efd700edb', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'24a02102-8b5a-4995-8b13-3414637751c1', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'871c8475-2efc-4cae-b888-341fdf0e67f3', N'9b38b717-0bc2-4b1e-9416-e025a341bcfb', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4cb6c17c-5b67-4840-b9ac-342856390a79', N'c990165b-1298-49db-a494-312a2c09615e', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'482b4b81-d520-4ad7-a182-3438784d4cde', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'abd2613c-4550-4a0b-8b79-346a6154c0b3', N'7f03a068-01fc-4ddd-9bf5-73f47906f2a5', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a370f8d6-56a1-412e-ab7f-34812bb89a42', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e65b5ef9-8f26-4de8-a6b5-3512853a9fbd', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6ee8d095-a81e-43c8-b8e3-356a474a7378', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2c2d8572-8267-424e-8dc7-359b37055928', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6de1dea4-13d8-4d7d-900e-35b22f617cde', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8921dd66-247f-4290-9d85-35ca311e1c47', N'a28c9408-c96e-4a4e-8cb5-cdf1ea119927', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(4.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd270aa7e-6a85-4bdb-afaa-35d88e1a2748', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4a834b8d-2228-431a-9715-35e6da16dd8d', N'e5d3d3d4-49fc-40d2-9d06-fe1d0cc220a4', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'18122352-1f09-4f9f-a240-35e9fd853431', N'e789f151-4fd8-4e96-9afb-cdd1ba15d866', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(2.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8c573051-8bcb-476d-a0cd-3631efc9b6cd', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'58136242-b80c-49af-a6fb-363237009950', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e474a9c3-f686-4c62-b26b-363df67c6a07', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'41a6ed85-aa30-4d7d-b7c6-368ea42ffdd6', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5c112764-4f4f-4ac1-b650-36a2a279e18d', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b6aaf55f-e991-4964-8300-36afba73e85e', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'075d8ec1-7265-450b-a630-36f048a18354', N'56d16c28-d70b-426d-afd9-5d541d354ec0', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd7fae745-da15-4e0a-8dd2-375de50a001c', N'a8825d15-24c8-4dd5-b8a8-cae87befd1b1', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3956faa8-76ae-4ae7-aaf3-37817dbc4493', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd742e03c-9a34-452b-bae8-37aa5e657c1d', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'26de6aaf-c6fa-4ee8-85ec-37d675c066c1', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f7e2cd58-7ecb-4e4e-ba1e-392667ee0578', N'edd617e6-84e6-47d3-bb07-9ad9b5a12af9', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4cfec43f-fb7c-4779-9f6e-3932768a6357', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'564fd327-5b64-4d87-a595-39ac5eab2a3c', N'09d9a1c9-75a6-436b-bc87-42af1b1349e9', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'38ed64b9-5235-4525-aae6-39bc854371b2', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'159de175-f80d-457d-885a-3a1ab21f3613', N'330387a7-39e0-4384-b647-2ef553303251', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bc9163a8-4a60-4dd0-9433-3a41b0da0cea', N'32d359b3-9739-4c28-b2ec-69d20906c299', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0c6d775c-5ba8-4b2a-b604-3a627db05a2b', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8a9a53e3-e459-4bda-9f4c-3a898c33108d', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f74b5636-9626-48c3-929d-3ab673f15f6c', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'36a560f5-0fbf-431b-b7ac-3b3171f69a9a', N'1c589b8f-5cee-4ccf-8af1-194107587e9f', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'00220575-aaf0-489c-b231-3b84ca240b07', N'7e716999-2edb-4c89-baef-adc57787c0d1', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'32234eb7-5da5-4296-a37a-3bcef1d62fca', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'11499c7f-b5ab-4983-835b-3c1ebcb15716', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fe97ce25-2dd1-4914-a44c-3c59f1a6a051', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'911ae0a8-08db-4552-8dae-3c93951be6db', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dcfd4155-3c91-441f-a0b3-3cb015a39b83', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'15096bb5-df07-4e90-b766-3cd2b3cf362e', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cec26601-4d7a-459f-83bf-3d4a816416ca', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'35709ad7-1293-4e12-ad9f-3d5aff484da3', N'b3a5421d-1215-478f-afc9-948f49126276', N'837ae6eb-05df-4997-aed1-428681ef566c', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e6884e15-23d0-427f-9705-3e2548236abf', N'e405a55c-e3cf-4ed8-9bd1-67f73c66bbd3', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'287a2717-a534-4f41-916b-3e27644dd328', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd933fd1f-2155-41c5-8fcc-3ee25dcef9e7', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'86b06148-a7f6-4d31-a0bb-3ee2b5b01ad0', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5f1cc26e-08e9-4e14-aee2-3f5f5547122e', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5f16dc6e-c9f5-4d26-a4f1-3f89f5fc0cf6', N'e9433b54-fd86-4491-8545-a0829b3a7f9f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bd95b187-b9a8-4716-8e21-3f9ab8fbce8a', N'c6432d11-2115-4129-bc9b-7bb3caed6953', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ed17d44c-1888-4b73-a685-40ab81325738', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c2379d7b-4341-4640-bbfd-412f1e658440', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd1a6797c-62cf-4261-8cf5-4137941a2c64', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4c86b764-dcc0-4cac-8c09-4162afac46ec', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7d89816e-77da-4c89-9cb7-4178fc8586fc', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'80dcf1e9-8b6a-4bcd-a814-41a63c1fb950', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b146d924-3450-4fbf-a5c6-42281b3395bd', N'b3a5421d-1215-478f-afc9-948f49126276', N'd848e787-625c-44f5-a6c6-93882ce82172', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a634cec7-f571-4389-8800-427934917e97', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b9ef111f-60f0-48fd-af99-4289d3b022e8', N'1a61806f-419e-468d-aced-59d7b54031ff', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7dde5eac-c6f0-44ae-b7f1-4333a52f9fc2', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cefffb32-5882-4e94-8791-43d25b025cd3', N'5c19d791-3b39-403f-9387-2b2c4384732e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd3a05991-4d0b-4ad4-87ce-44707a7f3cf7', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b4e4febe-4838-4d6f-8b4d-44986ff15e16', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'db8b635a-9715-495a-9267-c9db156af748', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ec2574e6-33c2-4620-b870-44a0901f100e', N'f5840962-cea2-4252-99ba-5f1204b0dfcd', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'06516673-eff1-448b-86ae-44c4d17bc617', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'29fd14d0-9e6d-409a-a237-44e313f4906c', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fdb13422-af0d-4c06-baf7-4558e4cc170f', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ffd59973-5f55-4400-9a99-45ca31806bec', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9fe08278-3a53-413c-93eb-4624ae6ac82d', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd23a5438-b3ec-4232-a51a-464b677f9bff', N'09d9a1c9-75a6-436b-bc87-42af1b1349e9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'19cb036f-6cff-46b2-aa79-46884e66734d', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b00843bd-6aea-4680-9835-468a7e4a541f', N'e405a55c-e3cf-4ed8-9bd1-67f73c66bbd3', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'35841b9f-681c-4a14-a6c0-469f571ba907', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3521365c-18d2-4a81-815b-47f949df730c', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e44ab0a9-5ffe-4e53-8671-48442144184a', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'84ec5ad5-4456-481f-8d68-4941005e4ead', N'edd617e6-84e6-47d3-bb07-9ad9b5a12af9', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'820cf483-323e-4cb1-988d-4995edeef69d', N'd1a4ab78-8483-4d59-8377-744d48bea8ba', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'085f94cf-2a81-482a-b71c-49eb970daaa4', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8d2bc349-4eaa-4efd-8185-4a2803975006', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'da5d2f10-b86c-43db-b0a0-4a2894045c32', N'6f628150-e039-48c9-b65d-e0746d66f326', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7d860552-b5dd-468e-8e37-4a6b83387cbb', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7e71dfb5-5404-4efa-b758-4a7f928e1211', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'58429755-d527-488c-9400-4adceed0c9f1', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e8f5cc4d-3be5-41dd-b2fb-4ae3b8353d83', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd97d47fe-1d39-4262-adc2-4b7ae3d2918f', N'5c229e74-547d-4d82-8c72-24c42db2e0ad', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3d378a38-877e-4bf4-8fe5-4bbfa37e2cdd', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'c68be214-6c7f-460b-8391-2f5408127068', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0bc2145b-ff50-4f29-bcf6-4bce17e42757', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'09835760-5ee3-4332-9a87-4bf0288230d9', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'c68be214-6c7f-460b-8391-2f5408127068', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5fdd1550-6915-455b-8f4a-4c5d20107ab0', N'09f37e50-5647-414e-81ae-abe12039bf83', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd06e13b2-ab6b-4c96-93c1-4ca43d4b6b01', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3bc730a7-1b60-454d-a924-4cb1fe0c2f90', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'31fa2f44-b326-4d14-9275-4cbed970125b', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7ba7d14d-e32a-4a41-b7d8-4cc3a004df63', N'a5a02995-e8e3-4c73-9c8b-b7ae05f846c8', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'07afe8c6-7fe8-4b9c-8ad1-4d09bcaebff9', N'9ceb91bb-6046-422a-9c39-d8d758b9ed60', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'763df60e-e2eb-47e0-984c-4d1af0b085eb', N'5c19d791-3b39-403f-9387-2b2c4384732e', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fa2531cf-e835-48aa-9434-4d40a60f0370', N'd0a3eb8a-e0ff-4210-920e-f18bfefd6543', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd5da25db-0a3b-4459-b725-4d43557aa196', N'd0a3eb8a-e0ff-4210-920e-f18bfefd6543', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4ea0e0d8-bd43-49c4-b2ad-4dc410b11592', N'0c2efa14-3a4a-4345-97dc-1451cca95d9f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6c5e0001-ae1a-4038-8523-4df01d2acbef', N'f5840962-cea2-4252-99ba-5f1204b0dfcd', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c383bcfe-cb6f-40fa-b493-4e44c09d55c7', N'7bb31de2-e713-4dc1-a31a-d37b9b1213b8', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5a945ee7-60b8-439f-82f9-4ecff04e3298', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'837ae6eb-05df-4997-aed1-428681ef566c', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'926bf013-910e-492b-99a8-4f09f4536ef0', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'25d0d9ad-cbe5-4273-873d-4f449884a98c', N'330387a7-39e0-4384-b647-2ef553303251', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b61bdb6a-303b-444d-ba60-4f8cdd355588', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f7d6164f-2b40-4f49-b91f-4ff1c9ede3ac', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'06d8186a-9cf8-4f35-979c-502dc9553d1a', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0f472915-1c9d-45f9-bf8a-502e5033a67d', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd7c80c3b-23be-4ef5-9039-5040c8bae7cb', N'09f37e50-5647-414e-81ae-abe12039bf83', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8c98ddc5-017e-47db-a41b-50bed6ef7cef', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6b71db47-f83f-4bfd-89cf-50c47d35c3b8', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b037ab5c-e8f1-4038-80b2-513d76ae2fff', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c2a5b0ce-cc33-4a06-a99a-514fb53f885f', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9f0dc4f8-66f1-49fc-a4ca-51594a0d8931', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f72eed5e-e0e6-4053-8055-517b58c44c7d', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8e705b67-ba40-47bb-a9d9-52203dbe6264', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0ff865b2-1565-40de-9ac9-5238164c1556', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'52f17229-3e1e-4185-9a7f-523fb8d5f00a', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5348a406-7a3c-4422-aa92-52d59071f7a8', N'1fa1d745-4917-47f0-9007-488efa25cf37', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'34cb8278-1af5-4258-91e4-52df34784204', N'e789f151-4fd8-4e96-9afb-cdd1ba15d866', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c9edb531-a921-4956-9284-53be117f58d7', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a93eba3f-994e-4405-9e0e-546b7ece3aed', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'db8b635a-9715-495a-9267-c9db156af748', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2b739bee-001c-404f-8a50-547c80d883fe', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'c68be214-6c7f-460b-8391-2f5408127068', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f37ad7a6-662f-43c7-9bc3-54a676d93d28', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'297ac2c2-b36a-4422-84f1-54ba66f75267', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'43854e4d-9e75-4128-80ad-54ec7a0a92ea', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'85a1ef52-6a10-4438-978d-54fb873e3759', N'a5a02995-e8e3-4c73-9c8b-b7ae05f846c8', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'648486dd-4389-4adf-8b6b-552b46bed7d0', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'760bdb09-5cd2-4bda-a7f4-553b4ac37cd8', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3c1116dc-e9da-4898-8984-554df8d65c5a', N'b6390530-20ea-48a7-9c20-598c93288ff4', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5790ed12-f79e-4aa6-952a-5577b7f55e8b', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd896eb6e-4cfd-4750-af11-55aaec914994', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7d4535bc-c5fb-4d8b-a122-561d809b6376', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'75f3102f-01f7-4231-abd1-56a8580932ff', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd05367cb-fbad-47c4-b0ff-56dd845d5195', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b10fcd2c-5a5c-4d75-8de3-571a00644998', N'e9433b54-fd86-4491-8545-a0829b3a7f9f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2d1ca5e0-2a82-4ae7-9ead-572a2bc96dfb', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3ea13737-3800-4c0d-baa7-57699a9953fd', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'25d00795-ae57-4792-8fe1-57b352af19ed', N'cd2ef07a-e046-49c9-aa76-6842ae6ad28f', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e969a796-66d3-4815-bcb2-57fa5406f534', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b0c05cd5-338c-4c6d-85b3-5836fe996b2f', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'510ba754-4505-46b9-b1f8-586b0f4cd03e', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bfb0ffc4-f75d-4514-b8cd-5888870c2e18', N'b4cf17fa-9529-46fc-b5d4-ad1ead14f6f2', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bf1b3c8d-1158-4d95-896d-58aeb80b533f', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'c68be214-6c7f-460b-8391-2f5408127068', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3e313207-08b7-4684-8388-5929c4519b54', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'db8b635a-9715-495a-9267-c9db156af748', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9877cf43-eafd-4351-9fb1-592a05fa9585', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'020a1cb2-5e03-4952-a802-593d329f7251', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'97a0871a-8cb8-4b1a-b3fb-59854b9d9d83', N'cfd88362-9d8a-42a4-8b88-beb36598a381', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8ece6195-6dfc-4c2b-95f0-59e26482ab54', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3d47dd8e-8d7c-4c49-8a2f-5a0f712a8841', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3c242a16-dbd0-4296-b1d8-5a250bfa1b0b', N'32d359b3-9739-4c28-b2ec-69d20906c299', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a3f32713-9ba6-4b63-8008-5a349e9daf52', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4d79c357-7a23-4c26-be9b-5a977cc04505', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3c3016ab-277b-46c6-b5ec-5aadbf7f53ed', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e74ad88e-fced-4a9d-9f8d-5abcf9264118', N'e5d3d3d4-49fc-40d2-9d06-fe1d0cc220a4', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5743c9a3-377e-4880-ac13-5ac94b267d46', N'09f37e50-5647-414e-81ae-abe12039bf83', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'37c1cd7a-8d98-4c33-a335-5b2b87d956a8', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd7dcca7a-0465-4c06-9a91-5c02fa6de4d4', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3365a00a-2f88-44a0-9bab-5c344ebb13f2', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'22bc960b-d30f-4dd6-9474-5c4be30cc87f', N'330387a7-39e0-4384-b647-2ef553303251', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd030bd56-f617-4636-a763-5cd92101ad7c', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b94c9956-8e50-4305-9477-5d069181ccb2', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1158c90a-4fcb-4174-a190-5d06dc1edf68', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'837ae6eb-05df-4997-aed1-428681ef566c', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0d3c0585-d6ea-40af-a3bc-5d0d5152e4c9', N'09f37e50-5647-414e-81ae-abe12039bf83', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'07655021-f9e8-4da7-9d3c-5d2828bbe044', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'44b512ab-a0a5-44a4-aa37-5d530b29b9b1', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'478b8787-00ea-4dd5-b334-5e2d2ce7df4a', N'c8fdbb0f-6669-459c-b5b8-f2234d553a0b', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(1.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9786b963-c89b-459c-971e-5e541bd98a47', N'e9433b54-fd86-4491-8545-a0829b3a7f9f', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0ec00a7b-739f-4f4f-b2f3-5eaad8e4dccd', N'8fce37b9-b8e8-47fe-98e8-13ea1e275e94', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'230562b8-376c-4c45-a65e-5efabbacd8c5', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'472cab16-39ab-41ee-a4fb-5f956552dc77', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'77ae4871-1640-463b-91b2-6084af2a6129', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'73f64ea4-d626-4fab-b99c-60876024ec36', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'163755e9-2e1d-43fc-b0a2-6094a9db69e0', N'7bb31de2-e713-4dc1-a31a-d37b9b1213b8', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'19215107-a0f1-4dca-9873-60ceb014dc41', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'd848e787-625c-44f5-a6c6-93882ce82172', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'91459b2f-c258-43d0-abc8-60f8b7786d0a', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'da4974e0-83ea-4d41-95f1-6112989687ac', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'522b940e-6760-4320-8ada-612a7df3ba64', N'a5a02995-e8e3-4c73-9c8b-b7ae05f846c8', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4e846679-e506-40f3-a33e-6139aabb3239', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f5b5d291-4647-45ee-8b2c-622ed6e6edd0', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'129d140f-1a70-490d-ac05-624a5960d1c4', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9edb7da7-4c51-4b27-9794-62525f3c5a6e', N'a8825d15-24c8-4dd5-b8a8-cae87befd1b1', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ef15940a-1c79-44fa-be65-6260bd101782', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd4612074-5165-4f0d-b704-6294e91595f4', N'ad1ec698-a3ac-4f74-ba4d-cd91e94874a7', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dc6117a1-1d35-4ff8-9301-62a8ccc799b1', N'b6390530-20ea-48a7-9c20-598c93288ff4', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dc214e20-01b3-4fe6-9437-62dc1b173f4f', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ef98b360-2fee-4a4b-bd9c-62e35d856a2d', N'56d16c28-d70b-426d-afd9-5d541d354ec0', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(1.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'66dae60a-afdf-415d-9bce-6321a8ea5cfe', N'a28c9408-c96e-4a4e-8cb5-cdf1ea119927', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(3.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'933d4b59-3786-4bab-9d2f-6367eaf3e5d7', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a29b5b99-2440-4a19-83a6-63b41ab75dd5', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bf278ae4-7818-4af1-ada2-63ea7b9cbdc3', N'c1e7620a-86af-46fd-817e-e702acaa6be9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bdc1b6c9-3945-4799-b8c0-644e77ece361', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'67887795-b0cc-40dd-9719-6467e2cc5ba0', N'a8825d15-24c8-4dd5-b8a8-cae87befd1b1', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b13d2c5e-c946-4b88-8060-646df82c1be9', N'cd2ef07a-e046-49c9-aa76-6842ae6ad28f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c7a89028-ba47-49bd-892e-64a594299bad', N'cd2ef07a-e046-49c9-aa76-6842ae6ad28f', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9b006f88-87a4-404e-ac78-64d47d46091c', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a3f058af-b5a6-4b3f-9b8a-654484187a6c', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'543f8fa3-e253-43e2-8d21-6568dcb68102', N'6b68e459-970f-4164-98b7-2d8c7d1d773d', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'79789063-d7d7-428d-a67f-657da4f55b10', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8f5a720e-ac92-47d9-9ef4-65b253c56033', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd060713b-f824-4c97-8e7d-6669f10af758', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2c48f171-440b-4ead-95e4-666f4f788ae7', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40588055-f518-4422-8412-676b92e7bd84', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1b537c40-584c-4db8-a9c4-677d0cfe9911', N'a5a02995-e8e3-4c73-9c8b-b7ae05f846c8', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'98624dbf-6b1f-4f66-b7a0-67f8b39aff8a', N'1c589b8f-5cee-4ccf-8af1-194107587e9f', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'370e880a-2e71-4789-ac63-6800a9516d52', N'9b38b717-0bc2-4b1e-9416-e025a341bcfb', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1a66d557-b51d-486d-b833-680599f2865d', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'14a3ecd4-8a0c-4d8a-9774-68daee5c9b32', N'b3a5421d-1215-478f-afc9-948f49126276', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b726b8c2-5dd2-471e-b35c-692adda7adb7', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4b596317-3c9c-49c4-8821-693cac98fdc2', N'cfd88362-9d8a-42a4-8b88-beb36598a381', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e2126a22-f726-410c-8ca8-697137389fb0', N'b3a5421d-1215-478f-afc9-948f49126276', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a9800aac-9972-4ef3-ac5a-69fb452f1327', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd66ad002-7c62-4a05-a20c-6a8d6d0b9c1e', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'db8b635a-9715-495a-9267-c9db156af748', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'17854486-51c1-4bd2-b151-6af6db64b3b0', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8d41cbc4-4791-4e79-9b0a-6af811f627d1', N'c6432d11-2115-4129-bc9b-7bb3caed6953', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'184bbf07-c988-4a7b-b030-6b14ab2ad89c', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'd848e787-625c-44f5-a6c6-93882ce82172', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'297ef0de-5a41-4949-908f-6bbc04f5b7a4', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'c68be214-6c7f-460b-8391-2f5408127068', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a0f784a2-5151-49d8-841e-6bc1a6d4a08b', N'53d5f9ef-f674-4811-ad96-ca6a218a0a8f', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'13484f75-9a20-4f8a-8c05-6c089f814086', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ff13218d-8a0e-4072-a8b7-6c124d40b518', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'41939e47-59fb-4c6a-8658-6c16a35485b8', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'645f3556-1b8e-4b36-ba23-6c95903e3d71', N'034722e8-59d4-431c-86af-358345646362', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c8dba7ee-7d71-42f7-8fd5-6d71a4dece69', N'0c2efa14-3a4a-4345-97dc-1451cca95d9f', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b8cc86f3-c83f-4793-aaca-6d7c3688274a', N'09f37e50-5647-414e-81ae-abe12039bf83', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'068cbf42-86f9-462a-b173-6da928bc653c', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aff94f26-fa59-42d7-a673-6df9e61f439b', N'32d359b3-9739-4c28-b2ec-69d20906c299', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5fc76dec-5490-4993-9a27-6e23ec0976af', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'01373fff-caff-4bca-9f7f-6e83d44adde6', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7bc0de77-8e1b-423c-b8cf-6f2b877d7473', N'a28c9408-c96e-4a4e-8cb5-cdf1ea119927', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(4.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aac3f297-8851-468a-be62-6f8031064c66', N'32d359b3-9739-4c28-b2ec-69d20906c299', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c5c1253f-5cf4-4665-a1e0-6fae6db0524b', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b12e53d6-7b20-4744-93dd-6fde85af35a0', N'09d9a1c9-75a6-436b-bc87-42af1b1349e9', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd1752531-d98c-47fb-967a-701de25c7053', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5b45fc2c-6eb3-4641-939b-707c6b5afe94', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3c33bcad-7538-458d-8aa0-711f182d074e', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cb6de093-3d6a-4b26-adfd-7120b43ab1d4', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1f46e43c-c38c-4349-aedb-71227606d245', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'c68be214-6c7f-460b-8391-2f5408127068', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f3e314c6-337a-4e03-bcf7-7177e4a441df', N'09f37e50-5647-414e-81ae-abe12039bf83', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f05f279c-d2dc-4ed2-98ac-7187d1f7553f', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8b2d649e-88ee-4d25-a3cd-71ae4c6cd2e0', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'662de779-7b0b-4dbf-bf38-71c33c080aba', N'6cd90efa-e2dd-4682-8e1d-aa8b2cc44fe6', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd97415b9-301d-4f85-9921-72800906d7ad', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'd848e787-625c-44f5-a6c6-93882ce82172', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f6e2cfa5-6ede-4a3c-a6f0-732b4216b46a', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4d8d4483-9532-45c6-82bc-732e872740a4', N'b6390530-20ea-48a7-9c20-598c93288ff4', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1d0999f1-e720-49d8-8639-73ac04d71817', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'25d9d5fc-8e69-4dea-908d-73dc84d4ef64', N'9b38b717-0bc2-4b1e-9416-e025a341bcfb', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'17d1c28a-d8bb-4170-a194-746388717dd4', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'280df38d-f0b0-4506-b5fd-746e540f10c9', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'52be421d-d0ec-4bbe-be42-746f795475e5', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ea7d2852-2e54-4e10-adec-74bf35263c11', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd7a6483c-24a1-4300-8143-7565da1b7108', N'56d16c28-d70b-426d-afd9-5d541d354ec0', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'64902f9a-5eec-4a5f-8384-75e157ccc616', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5ea533a2-a1e0-45b3-a25c-769cd1cc4b11', N'b3a5421d-1215-478f-afc9-948f49126276', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'59f4915d-5c03-4341-ad5c-76debd8611b9', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'182ba943-672e-4330-b50b-770479815999', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'91d962c9-cce9-4770-b593-771d11b4db28', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7ebf2e3e-85c2-4d4a-b177-772172c0f49d', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c7aa86d0-7fd7-43f4-a4b7-774da3bfc2e8', N'09d9a1c9-75a6-436b-bc87-42af1b1349e9', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6b01f510-69f0-4b41-805e-77b8970eb7e8', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'486d51c8-bd6f-4fa8-9682-77d925a59ab0', N'd0a3eb8a-e0ff-4210-920e-f18bfefd6543', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40333de5-6fa1-4cbe-9965-77d9db51443b', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fa5a221e-9679-4a79-9caa-789d2d4d3148', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'd848e787-625c-44f5-a6c6-93882ce82172', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9f7f16e3-31e6-46ab-af1d-78ca9018f613', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f786ef5a-f687-4137-bc77-791b699bd4d4', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'77222dfb-acb3-4ada-9ce9-79423e39e5e3', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'83ae0de2-4729-41fc-9e41-794b2bc56478', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bfa9c655-2641-4c46-b322-79b105d48cd8', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9af7ef43-d808-47cd-b17e-7a1c1034e46c', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c35c4f5b-f962-4029-bff3-7a26287746a9', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5bdd4526-e856-49cb-9e82-7ad4566ddea8', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'03e74038-8d14-4657-b99e-7af9a7076c05', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bc670219-ce02-40c5-96f3-7b8fb0ab3f22', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'64aa4d5f-beac-43f1-ac74-7c3d4b55c84c', N'6f628150-e039-48c9-b65d-e0746d66f326', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9fbf9670-4352-4253-927c-7cc9205b0d61', N'324a9f1e-4485-415d-8d0f-4e8e8fc4baf9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'48aa5e60-4d26-4759-80cf-7dd46c02fb5f', N'a45cf8ed-9a89-48eb-874d-1b609c86025b', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'baac2192-2a2c-4eb1-80eb-7de89a0c02ac', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ba23d539-8dee-43cc-afcd-7e38e12e946f', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b711d9bd-752f-4586-8165-7e4ccb279f53', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'072ddd54-8104-45fe-b44c-7e51211a0be6', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd9451ed7-97fe-4623-b560-7e8eb4174c1e', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40accd74-95d7-4613-95ac-7ef1c5684047', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0aff243e-7e05-43d2-abf6-7ef5494fa244', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cbc7889f-2aa3-47e6-8825-7efee084bc71', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a732f00b-33d2-420b-9f0c-7fa3a11088cb', N'256e9eb5-3ac5-4699-a979-8d5e5a5186f7', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'075c7e02-6c3c-4781-b9b3-7fa67a9f38ed', N'53d5f9ef-f674-4811-ad96-ca6a218a0a8f', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'533ce049-0fec-47b1-9e6f-7fd9fcfe52a8', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'75fd29c5-06f6-432c-97b6-8028df03a768', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bc1fae67-0737-4e41-a013-80efe09ab6eb', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a113484f-db38-4918-822a-8125d3f79f1d', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f7170f78-fd0d-4df3-91ea-8146af0cde56', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'961a8741-c761-4120-91c7-817770680f33', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'd848e787-625c-44f5-a6c6-93882ce82172', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a41fe517-26f5-4308-9599-817d10cd20fa', N'b3a5421d-1215-478f-afc9-948f49126276', N'db8b635a-9715-495a-9267-c9db156af748', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bd4d9cc4-7ffe-453e-94c3-81b557b14eaf', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f529c411-aea8-4923-b25f-81b888700bdd', N'a28c9408-c96e-4a4e-8cb5-cdf1ea119927', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4c72cb8e-4f72-4c5e-94fa-81df8fef93ed', N'd9851cd8-0fee-45da-accd-2cf8e6826ac9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8f4e49c0-d608-49aa-9762-81e3d8037620', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dca66370-8524-4227-9a1d-81e9683051b1', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5444cf67-3e4a-4782-97c2-828d3da22682', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'837ae6eb-05df-4997-aed1-428681ef566c', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'760cd595-f74f-4a5d-b017-82b241fb03c1', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'efe5c55e-8e99-41ff-99e1-83f3070c19ae', N'8fce37b9-b8e8-47fe-98e8-13ea1e275e94', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1e430bff-141c-4d20-8406-848226ec5470', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4fe25414-6f07-43ab-b4e3-84ac82bddbb9', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'670ee211-5029-44c5-a93c-84b6685f0cc6', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'd848e787-625c-44f5-a6c6-93882ce82172', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'36652a8b-1be1-49fe-9b9a-84f97f400b1a', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'45a5114c-7bb7-4823-b6a9-84fd650391d5', N'034722e8-59d4-431c-86af-358345646362', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a1349fa8-e000-4076-a4ec-8515dfd57d6a', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bf56d3a2-bad1-4149-a087-85192aa61941', N'e789f151-4fd8-4e96-9afb-cdd1ba15d866', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'241e52e7-f5c8-493d-97f3-852977d15ffb', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'91c653dc-7c6a-410f-8318-856c7163139a', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'337e05bf-ec58-407e-bfcb-8578cfdb9a66', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'123d0c21-5fc0-4784-8dab-85a3770ebb32', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'faf3c8ed-522b-4e0f-980d-85ae888c7494', N'9b38b717-0bc2-4b1e-9416-e025a341bcfb', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4f098475-67c3-4847-aee7-86374e3ed7d2', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'edb43c60-2440-4e81-bcb5-8639ed287d95', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'20142d69-ea15-4d30-9504-867467c23346', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c62fcbb4-949e-4473-a093-86ab521b098b', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9279b862-1373-439f-8d86-86f178e5ef8d', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8c9a829d-f463-419a-88e7-870b90adf88f', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dc984cd9-c1c5-4780-a1f6-879878c3dcea', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'99e253db-0207-487d-8b1d-87cf11eeb8e9', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'05a7a437-e82d-4119-ad0f-889a5f4ebbe9', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f81d4288-ea08-48c5-a0e8-88ba2cbf0b9e', N'a7fd91ec-71c8-4b67-90ec-fb0f9fb59c28', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aaf1fee7-b4eb-4f4e-8be8-8924ed6350e6', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4176f93d-af00-4ac7-90e4-895c6f139264', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ebe7ec2b-3c89-4ac1-b5f8-897489a709f7', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c30ecd2c-9919-4b3e-b496-899d77f1b9de', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f0352d17-c8cc-404f-8ce8-89ae0df8bf1d', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'805d156c-85de-4833-949c-8a3a4b1445c3', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2df8bc52-da8c-464b-9572-8a4678ea111d', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'c68be214-6c7f-460b-8391-2f5408127068', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bb442200-3725-4fa5-8301-8a82a0690476', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'741df5ce-15d2-4c54-9e78-8b57bcc04d33', N'b3a5421d-1215-478f-afc9-948f49126276', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b61a7862-32d5-4c40-a01b-8b5b951685ed', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'726a5998-e018-4f29-bb5e-8c63099f7b06', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'72f8d0cb-e4a2-426e-ae40-8c70d811649c', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'631a3a59-3855-4843-8f2f-8cb2438ed436', N'1fa1d745-4917-47f0-9007-488efa25cf37', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'63ed2632-88c9-484d-9f1c-8cb788ca513b', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e6bb0709-c9a6-479d-bad8-8cd0957f73f0', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a3c12904-4d9d-4b82-bfd6-8d02a645c313', N'034722e8-59d4-431c-86af-358345646362', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b64c56d9-bfa3-40cf-ae87-8d60ad17b0b9', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ce441462-316d-4459-ad41-8d622785c6d1', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'983906b2-981a-4a63-bb12-8d6c24f0cbb3', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'800ec12c-d640-4e2f-afa5-8d7e13e48da0', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'858a5d91-83f4-4ed5-a9f4-8da204373705', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0b5ad78b-047a-4008-8907-8e1404c35c6a', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2ea19eb6-09ed-4156-b089-8e28cc9b8c69', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9579d973-6c2f-4352-a848-8e85c0f67444', N'cd2ef07a-e046-49c9-aa76-6842ae6ad28f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'478fa223-4fad-4409-afcb-8ea0f84d13d5', N'ad1ec698-a3ac-4f74-ba4d-cd91e94874a7', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aac751f0-45c1-4c67-8f67-8ec7b222075b', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'658af894-e81d-4d8c-a4b8-8ed443f4a8e7', N'7f03a068-01fc-4ddd-9bf5-73f47906f2a5', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aca3580a-a097-47ed-a1fa-8ee08d5a1446', N'c8fdbb0f-6669-459c-b5b8-f2234d553a0b', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3843daf4-3f37-4284-a0a9-8f188b7edd9a', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'69871ecc-959f-4591-bcb3-8f60a50249ed', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9a17da0c-a325-41c6-bc0a-8f90945e9ffb', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f09a3134-8c41-4dea-9b88-906aea0eb5e2', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4f5b64c3-bf5f-4eb5-9626-921a90313ecf', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8736e104-ded7-4f03-a4ed-9233d972d74b', N'edd617e6-84e6-47d3-bb07-9ad9b5a12af9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4e63517e-6ad4-4942-ad5e-9257e6fe871a', N'5c19d791-3b39-403f-9387-2b2c4384732e', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f19d9da5-31bb-4051-bafa-92b30e80735b', N'9ceb91bb-6046-422a-9c39-d8d758b9ed60', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'662218ff-3651-4ef2-8ab1-92d935f716ef', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4f3d1714-c9ec-4003-98ed-92e58fe2460d', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6f67553f-05d7-44b8-bbaa-92f137e5266e', N'330387a7-39e0-4384-b647-2ef553303251', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4923b594-2495-41cb-a113-92f87853bb86', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f32b78a4-5bbf-4a8a-8048-932626e83765', N'd0a3eb8a-e0ff-4210-920e-f18bfefd6543', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e42fb93d-a2fc-48bb-8619-943cf9c4d28a', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'46e6cfc0-14e3-4b02-8d8a-94404d60e4b9', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ca9fe14a-0879-4866-9e11-945c75feecee', N'1fa1d745-4917-47f0-9007-488efa25cf37', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e4096d17-ab46-4a80-92e8-94bd8034929d', N'c1e7620a-86af-46fd-817e-e702acaa6be9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'229861e4-cd0b-4d96-9622-94c34104e7c4', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f9c4c2af-7885-4d63-bbfa-95285cb53136', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6f742f81-bc4a-41ba-a89b-954901de71b1', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f24f0341-6834-4214-96c3-957e31b027e0', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40c97f4c-2bfe-4a23-94d5-95da4d3a4d65', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f31d4b82-955c-493a-8573-95e05255863f', N'a7fd91ec-71c8-4b67-90ec-fb0f9fb59c28', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8625eaec-379f-432f-b928-95ef80e77daa', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cfb49182-12ce-4872-bc42-95f29bb2700d', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0802b038-a712-4de4-a437-96121076866f', N'6b68e459-970f-4164-98b7-2d8c7d1d773d', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd3688a46-34c1-4b67-8c03-96356e385004', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'696740db-bee6-4cc9-888d-963b9c814539', N'1fa1d745-4917-47f0-9007-488efa25cf37', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8911d500-923f-4e9e-9425-970634d0258c', N'6cd90efa-e2dd-4682-8e1d-aa8b2cc44fe6', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd082c3ec-e0c9-4f90-9eea-974a0de68084', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f167cae1-e749-4748-b03e-978a78bb9474', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'33663f62-d1dd-4ff2-82f1-98726b81a30a', N'8fce37b9-b8e8-47fe-98e8-13ea1e275e94', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'25efaf5f-30c1-4268-abc5-988bb285f7ea', N'9ceb91bb-6046-422a-9c39-d8d758b9ed60', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ab5ef145-d362-4663-90f8-9895978aada2', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'286996dd-51dc-4486-acd5-9931e901d317', N'5c19d791-3b39-403f-9387-2b2c4384732e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ed339ad7-c54b-4764-8434-99ae9613c3b7', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8ef68cb1-f61a-49f9-9226-9afc891d2b91', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fdf43890-b053-4db8-84ac-9b06b65bfea4', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd6684af6-4a41-4f0a-a5fc-9bad78f2ec00', N'5c229e74-547d-4d82-8c72-24c42db2e0ad', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7799f09e-7b03-49f3-88eb-9bae4095a109', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'44e8f23e-caac-4227-bdc6-9bd620eea53e', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'106ef4ea-7107-4f49-bedc-9c2996c54d2c', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6cb73428-b882-4b01-90eb-9c97b2d8972a', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1fdc8666-0dca-4168-9226-9ca9a9583553', N'ad1ec698-a3ac-4f74-ba4d-cd91e94874a7', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'19377f7b-e2d3-4b06-9a4b-9cc226d0827f', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'd848e787-625c-44f5-a6c6-93882ce82172', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'474a6c98-d63b-4fa6-adf3-9cc9c942cdb3', N'324a9f1e-4485-415d-8d0f-4e8e8fc4baf9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7428ca66-6530-483a-9b76-9d0de2020f64', N'1cb24750-ed55-4f8b-be2b-13f79c7735b1', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'19c4cf4f-59c2-4625-9717-9d21cb87d237', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'168bbe49-9a05-4899-9ba6-9d3555100d87', N'53d5f9ef-f674-4811-ad96-ca6a218a0a8f', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'88244cc7-149e-4218-b4a9-9d4a8300b309', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9c2ede1b-491f-41cd-a869-9d94199c61a7', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'20826bea-7af8-4070-97f0-9dbf9c753425', N'6f628150-e039-48c9-b65d-e0746d66f326', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'224d34fb-3680-4725-983d-9dd395cf2c37', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c1ce09e8-3a5c-455d-abf5-9de020ca44c1', N'6f628150-e039-48c9-b65d-e0746d66f326', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd23763e3-4516-4660-a151-9e0fcd2d3eb0', N'6b68e459-970f-4164-98b7-2d8c7d1d773d', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8b1ede9b-8120-4ddb-b3c5-9e2f3f5a5944', N'0c2efa14-3a4a-4345-97dc-1451cca95d9f', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'17c1076e-fa49-4b55-8e53-9eb0a766fb87', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e0918047-09c1-4877-aa95-9f70cc4b6a5e', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'837ae6eb-05df-4997-aed1-428681ef566c', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6986a45c-0b8b-44be-9809-9fbd0ab0e043', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'c68be214-6c7f-460b-8391-2f5408127068', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'136fbf19-bb7d-4f0f-a00e-a00eceb30fc3', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b8a19da7-6a93-44f5-81d4-a01245c047c7', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'98c2e673-9940-4c00-9581-a03577f0021b', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'48a2de9e-6538-40f1-b9c5-a062abf3f76f', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f70883e4-7dfb-4fd8-906a-a07f3de70631', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bacd7737-9148-4af9-935d-a0eee5f81ab5', N'e789f151-4fd8-4e96-9afb-cdd1ba15d866', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1d6bd079-6459-494f-910c-a14ce7b7d520', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9efe8ba0-c4e4-4ff8-addb-a15f5257c073', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'd848e787-625c-44f5-a6c6-93882ce82172', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'92dedcbb-bd7c-47b1-a77c-a1b796bae296', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'90153f3b-7b1a-4a6d-9fc3-a1fd36949f94', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bca2c815-e332-4d9b-9dac-a27e7a2d0d81', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd3cfcd22-aea7-4d41-999a-a2addfc465f8', N'330387a7-39e0-4384-b647-2ef553303251', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9f493bf4-fa88-426b-87dd-a2ba6adcd2f1', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'eea821d8-e86f-420a-9f7c-a2c2737f5b85', N'c990165b-1298-49db-a494-312a2c09615e', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'64dbaeac-c101-485b-8768-a2dafe73a660', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'748eb1be-a301-47ff-9de2-a2e78406ee78', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6cad861d-8fdf-4a75-8f88-a2fdb7437acf', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a738a2c4-caa4-4d3b-99fe-a3920879e0f6', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b6edd41a-e0d6-486b-8661-a3c1e54182d3', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2a37f226-b4fc-49f5-b19f-a3c5b5271f35', N'e5d3d3d4-49fc-40d2-9d06-fe1d0cc220a4', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0877e935-dfdd-4732-bdc6-a3d5871892c1', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'932e9837-da7b-46f5-b0f5-a3e37ebce955', N'324a9f1e-4485-415d-8d0f-4e8e8fc4baf9', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd659e691-298d-4149-9516-a49059ae6ac7', N'e9433b54-fd86-4491-8545-a0829b3a7f9f', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'564b7b7c-0ad1-49b8-b7ff-a4d6bf6401f9', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5435abb6-8d30-4839-9783-a519b8bb267e', N'b3a5421d-1215-478f-afc9-948f49126276', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'51cb1324-6d52-4531-b95d-a52d5e018395', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ef7bc773-9aa8-4c5b-8b29-a5f10b2c27dd', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'837ae6eb-05df-4997-aed1-428681ef566c', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b3cc3242-7aa9-4b98-a583-a6c36546c721', N'1cb24750-ed55-4f8b-be2b-13f79c7735b1', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6b0d8c8b-8968-4f43-bd45-a7012041c736', N'cfd88362-9d8a-42a4-8b88-beb36598a381', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'360447aa-48ee-41a8-8bc9-a7b92e324446', N'1c589b8f-5cee-4ccf-8af1-194107587e9f', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bf791779-0802-4e68-992d-a81103708eb3', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'db8b635a-9715-495a-9267-c9db156af748', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd13e05bd-d29e-4c5d-baf2-a86b078cd816', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b753ae43-ff9a-4cd5-929b-a88af2a4f8f5', N'09f37e50-5647-414e-81ae-abe12039bf83', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd0cbf0dd-2ebc-4ac1-8ade-a8a3ea0d28d5', N'1a61806f-419e-468d-aced-59d7b54031ff', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ede20d12-6d4c-45b1-aa84-a8c6a1d24217', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'17a73bb3-3872-4cec-b8e6-a8e3edf41cbe', N'd1a4ab78-8483-4d59-8377-744d48bea8ba', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'991dd2e9-d4c3-4da2-80ef-a9244d82f142', N'e405a55c-e3cf-4ed8-9bd1-67f73c66bbd3', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e5a15b2f-bab6-49f3-b90d-a97cea927656', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'802ad066-64d6-4358-9c4d-a99ba3a5d750', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6be8fad2-2a13-4202-80a0-a9c9e67bc358', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'487873c7-90fb-4014-ab5c-a9f2ec61ef7e', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4410a1a4-1ad8-4f14-8121-aa3640b1bbf4', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5a4dac57-2ab9-4ee7-a5be-ab1c898be04e', N'7bb31de2-e713-4dc1-a31a-d37b9b1213b8', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'455dde8c-6d39-47e0-8d3d-abee216dde89', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3228e3a6-470d-4ed3-838d-ac36b734ebe2', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f85ef247-2491-42fb-bae8-ac7bb3a32351', N'56d16c28-d70b-426d-afd9-5d541d354ec0', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8a7ed623-d6cd-4ba0-8092-ac8d6363aa37', N'5c19d791-3b39-403f-9387-2b2c4384732e', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c7ed928b-f9a8-4a51-b71b-ad44f3270921', N'ad1ec698-a3ac-4f74-ba4d-cd91e94874a7', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8e7caad8-2f54-44d7-9015-adc6c57df40f', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7ca4be53-17c1-4c5c-9be4-ae6f8f793b15', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2d776cdf-b398-404b-85dc-aebde9449a11', N'a45cf8ed-9a89-48eb-874d-1b609c86025b', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'480084b9-0591-4157-8289-aee0367016e0', N'32d359b3-9739-4c28-b2ec-69d20906c299', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'53441f41-8bf9-4457-bb0e-af8d08b03947', N'c990165b-1298-49db-a494-312a2c09615e', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'28d04636-fb67-48a3-8fed-afac94151ebc', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2f737c0a-c465-4da3-83e6-b04197ece035', N'd1a4ab78-8483-4d59-8377-744d48bea8ba', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e226eb5f-a3e1-478c-97f9-b04a27a7ba24', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8826e90b-dbb9-44bd-8a51-b0a0c36f9e98', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd7556549-7a14-461c-af16-b0a50754e2a1', N'09f37e50-5647-414e-81ae-abe12039bf83', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4f4382d6-d57e-4763-9511-b0b79498f5df', N'c1e7620a-86af-46fd-817e-e702acaa6be9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e55d5671-b012-49bb-8e60-b0dc3a13e3a0', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd1acc907-5355-44f2-97ce-b13ef211838d', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'df6bc4f9-a0c9-4d13-8102-b1a5a27c5b60', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fb299dfd-d3f5-40bd-aabd-b1b4921b847e', N'09f37e50-5647-414e-81ae-abe12039bf83', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6b667151-3e7c-48a4-b857-b1efcda094fc', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fb4db946-60fa-408d-b944-b207a9998711', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5ddab9a3-9c58-4c22-bdce-b2159e775b69', N'b6390530-20ea-48a7-9c20-598c93288ff4', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ccdf37b2-bae7-436d-a3cb-b233a8e9b3bd', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd183f795-f6a1-43f9-a7f8-b23f21120c78', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'81fc9330-9f5e-4e21-9326-b2e09f81a173', N'cd5d0119-c210-4dcd-8208-f1b7e45593d7', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'82aeae39-8d03-4493-80e8-b303fb33f59e', N'b4cf17fa-9529-46fc-b5d4-ad1ead14f6f2', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'825d40f9-5cb0-47c9-9224-b3121e9b20a4', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c38785d5-6e15-4bba-be32-b321db470406', N'0c2efa14-3a4a-4345-97dc-1451cca95d9f', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8cacd199-03a3-428c-940f-b3f5aeff8af3', N'b3a5421d-1215-478f-afc9-948f49126276', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'43f26b58-48e6-473b-9382-b43217bd07a9', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9c16cde2-8a78-4c89-916a-b4610cb312a4', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0dd6d20b-17a4-4e91-82ac-b4757d5665ee', N'256e9eb5-3ac5-4699-a979-8d5e5a5186f7', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b6f08a69-1810-4d59-ae97-b518f27919d3', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'461bf19e-6475-4e0c-976d-b53119fa0755', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'24c8dee1-a8bc-4c3a-9434-b54b14c4ffad', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c462031b-a592-47f2-a0b1-b54ecbb655ba', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2a6191a2-5735-4af3-9fa1-b55b6d7661df', N'8fce37b9-b8e8-47fe-98e8-13ea1e275e94', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1909d19e-ec9f-4caf-b40c-b5c441780036', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'432c3f95-fc07-4782-8d4a-b5cc5718779b', N'a45cf8ed-9a89-48eb-874d-1b609c86025b', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c8dc3e0f-e05e-4056-9d62-b5e7004cf59a', N'09f37e50-5647-414e-81ae-abe12039bf83', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2d825398-33aa-4ee0-8799-b63d0619a0e2', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1f72efce-598c-410f-a6d2-b697b6962722', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6d6df0d6-7d13-4e8d-b247-b69bbd2e9860', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2c51d6c8-da18-46c5-82cb-b7039b55d800', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'db8b635a-9715-495a-9267-c9db156af748', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e012e885-aaf9-432e-9ce5-b7271dfd353d', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fe3cce91-5e84-4dd8-b8c7-b731d6bff091', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'54fa4fae-4609-487f-89ed-b7710bf2e4f5', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd9951b7b-adc9-46a2-92e5-b7ab09f53c36', N'1cb24750-ed55-4f8b-be2b-13f79c7735b1', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'37b1e2b2-4f57-44b7-85f5-b7b9c975b81c', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40175f3f-5bc5-41f7-a0bf-b8724ad872c5', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6f51b20f-d982-40e5-a551-b8789ecd41f9', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2f677165-0bff-4f0f-a532-b8d1a5aa7463', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b5e43ae8-e8f1-49a4-bda5-b9398f77dd12', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6c20e014-b985-4b50-8665-b95ccd01f555', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0ccc1449-22d5-4247-889e-b9929e7fec6f', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'01ba3474-43e7-4476-b66d-b9beac1990a7', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4bea0e2d-ff89-4173-980a-b9cbea61d8e8', N'09f37e50-5647-414e-81ae-abe12039bf83', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ccd2485a-f82c-4b98-8e4c-ba1b78d798d6', N'c1e7620a-86af-46fd-817e-e702acaa6be9', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1a1ec429-bd69-4cc8-954a-ba9bf99addff', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c75f6468-c101-4ee7-b33c-babc7266b39e', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'250b56fa-c175-4abe-8436-bb57b3438135', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'18342822-1136-4037-96ad-bb678bf5ce91', N'7e716999-2edb-4c89-baef-adc57787c0d1', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4194cc35-bf65-40da-8cca-bb879abe8e93', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'63b5bc8e-8637-47b6-8531-bb9d50c69c18', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5e1fe185-4225-4cd6-b4d2-bbfb5011ad60', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'92579e47-a36d-4101-9d65-bd55d72e87d8', N'e405a55c-e3cf-4ed8-9bd1-67f73c66bbd3', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8f9fcc34-6c8f-4220-8da4-bdea6bdd3c6d', N'1fa1d745-4917-47f0-9007-488efa25cf37', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'207a93b4-3c9b-4a84-ab13-bdfcf131c8f2', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b79eb71b-2e1c-4f4f-94a9-be5c7dcee583', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'087c1ad0-af40-465e-b845-bed25fc99ada', N'324a9f1e-4485-415d-8d0f-4e8e8fc4baf9', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd0bb9f3f-a51c-48d4-9c5d-bf1aad31fdd2', N'0c2efa14-3a4a-4345-97dc-1451cca95d9f', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'67138355-e56d-4968-a50b-bf81c7367431', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'220ac9dc-9fd5-4142-b237-bf81f9f95749', N'c990165b-1298-49db-a494-312a2c09615e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'22e40d1c-1011-4ba7-a4cd-c027f8b178b4', N'324a9f1e-4485-415d-8d0f-4e8e8fc4baf9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f422e615-9df8-45d6-a2ab-c044578c149c', N'09f37e50-5647-414e-81ae-abe12039bf83', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e7705e0e-f1cf-494b-b15b-c08d17791382', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5eb27e30-13ed-4491-9729-c0956d817bb2', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9191db1f-6cc2-4c9d-8f33-c0f9e522a4e0', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'db8b635a-9715-495a-9267-c9db156af748', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2e76ce7c-488d-46ce-bf57-c134e3b913b2', N'09d9a1c9-75a6-436b-bc87-42af1b1349e9', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'88c97f4f-ce7f-41ea-966c-c1b8fc84f047', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd6503037-14b3-4899-851d-c1eca54ba875', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0d59b3c8-65d1-43ce-ad07-c21a6d8b4df4', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fe95cb3f-9b60-4a6e-8a83-c22e3d96adb3', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40f65e14-b36b-4c6e-ac69-c23bd8315b51', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'204fab57-3382-43b6-8ccc-c2529fc42fb3', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'840dca97-8d59-4da9-bc7f-c283f968b088', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dfca6d6e-d4d4-4857-be71-c2b3dd124350', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'837ae6eb-05df-4997-aed1-428681ef566c', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ae1e968d-301b-47ca-8ad1-c2f6662e998d', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3ca77d3a-cf5c-4303-8395-c37d98db346d', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c0fe6afd-2119-44f2-a0d1-c395a73468a0', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'08de2f1f-32e8-4269-ba4d-c3a912c980a6', N'6cd90efa-e2dd-4682-8e1d-aa8b2cc44fe6', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'405d3220-d7ca-45f8-b621-c3c614f90bdb', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0a37900a-c6f2-4215-8575-c45859196fe0', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b38121ff-7e85-43c6-a269-c5093f019da1', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'13ce914c-4745-4c1c-ba62-c59f93db5f33', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'837ae6eb-05df-4997-aed1-428681ef566c', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1a7c16b4-af85-43ea-b2e4-c5c4f597e541', N'6cd90efa-e2dd-4682-8e1d-aa8b2cc44fe6', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f281956f-888d-4f4d-a17c-c5d8eaa49393', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f2af657b-0afd-4f3e-bf97-c65e287875c6', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'59f76654-4985-402a-847a-c6aea5aa72c1', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'eef9be02-bb2f-4796-a6e0-c7401975b37a', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'd848e787-625c-44f5-a6c6-93882ce82172', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0db2a77a-133a-4c24-a95d-c7b38dc694fe', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'92855751-37ff-4420-b742-c7db3faa0204', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1ae219a2-eed1-4684-8d91-c85c29764348', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2fc4c681-97f0-4a72-a33e-c883413a458d', N'a45cf8ed-9a89-48eb-874d-1b609c86025b', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b8283a6d-1485-4498-b8db-c8a187c80d3f', N'c6432d11-2115-4129-bc9b-7bb3caed6953', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8c5aad3a-6a62-4515-a55a-c8b0f18ead6c', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'af98a059-51e4-418f-ae9c-c919d5a2c46d', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f452bc30-8f16-42a3-a110-c97d8506b4c4', N'7bb31de2-e713-4dc1-a31a-d37b9b1213b8', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5d0f0659-788b-4868-8e30-c9f38bb7406a', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e4bf1a16-a993-43ae-b324-ca4dacbc636d', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c5c3769f-76db-4284-9274-cb42e99702f6', N'e9433b54-fd86-4491-8545-a0829b3a7f9f', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5c4db0bb-35ac-4664-88ea-cbc406f23c71', N'edd617e6-84e6-47d3-bb07-9ad9b5a12af9', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7b8c2e7d-445a-411e-9f25-cbd10ba1f25f', N'5c229e74-547d-4d82-8c72-24c42db2e0ad', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ac9fa446-a5de-4df6-b66d-cc78bef96f41', N'32d359b3-9739-4c28-b2ec-69d20906c299', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'450317fe-0030-46b5-9952-ccf1e60b50a4', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'735a005b-5696-4fc1-8fab-cd19e1e24460', N'ad1ec698-a3ac-4f74-ba4d-cd91e94874a7', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'df4ac731-3678-4ca1-8341-cd602e3db51f', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'de173c7e-ae54-4b64-92af-cd86fd12a5e0', N'cfd88362-9d8a-42a4-8b88-beb36598a381', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'50cd3687-af9e-4d74-97c7-cdaa5142924f', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ab9a6404-315b-4502-81c1-ce3259052daa', N'f5840962-cea2-4252-99ba-5f1204b0dfcd', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b8d997a9-f7e9-4fbf-957e-cf633d3f6378', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7787393c-0ba3-41c4-8ba6-cf82238aa413', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'63c0f761-9dbc-4825-9a9b-cf9dad84c498', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'be8591fb-5cec-4fb0-b24b-cff2bd83a8d9', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2a8e401a-72ad-4133-a758-d0983867003d', N'034722e8-59d4-431c-86af-358345646362', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0710d831-cf5d-49ca-a40c-d1880f4f6d31', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1ab06374-e360-4205-9080-d19a2a4d59ec', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b98087f9-ce2d-4169-83d9-d1ed5287fb1e', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'15cf0644-db2a-4ec5-96f1-d2ba2905f225', N'edd617e6-84e6-47d3-bb07-9ad9b5a12af9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c4010a16-049e-4c79-8815-d2ee018e3ebe', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'db8b635a-9715-495a-9267-c9db156af748', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6ececf67-cc0f-4829-964a-d3208a1b9a98', N'09f37e50-5647-414e-81ae-abe12039bf83', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9c10d441-9fd4-47a0-8b11-d39a76ea167e', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'47fab576-c1de-4d87-be24-d3c74e23c278', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5eb0f19e-3359-41f3-96af-d3f64f1d7094', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9f78ee34-81ad-4b28-85b6-d41a7c09c5cb', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'10233451-8baf-4128-a835-d4dcd0277be5', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'911c9bb8-4714-4d5d-bc38-d508a6dab0fc', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a8828fad-b178-4684-980c-d54f78472cd8', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd1273cd5-2f55-4fc0-bb9a-d5536e476407', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e1adb21a-5296-49af-ac79-d55a4183f877', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0810e1cd-079f-4af3-bc8c-d5c19cd33825', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'84cd62e1-f0ab-4ba6-ab25-d5c3d68fb247', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'144754f8-1ba4-4d2d-a282-d5d8d56dbccb', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b5d5ce40-fab8-405e-af3e-d669ff2f2e9d', N'a7eeab92-ba78-4f49-b39e-656f14d4d84b', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9d481323-8ff3-45cb-9266-d68b9666cb02', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'04ed77f9-1ac5-42e4-9c02-d6e2e3cc4f91', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'489fa4a2-b240-4b6e-a948-d7efc673ef83', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c3de5473-7a49-47f1-8c43-d7f12eac86a7', N'09f37e50-5647-414e-81ae-abe12039bf83', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'bb1d3a7e-13ec-4469-9b9b-d86a43e96aa7', N'5c19d791-3b39-403f-9387-2b2c4384732e', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'46c3a6c4-8d3c-428a-8a40-d8856d51c6ff', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f21cc731-04db-47e8-ac97-d8a17452d3e8', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f06c485d-b56b-4803-92ab-d9126626c6a0', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'835f4647-70f5-4802-9e61-d92a4cce5b7b', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'716b35c2-bd24-4f73-aa9a-d93e0cfebc4a', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'272365f8-f957-43b2-8331-d95db003a190', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b52b54c5-1cb7-452e-a679-d961e146e5cb', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7737a1c2-064d-4872-a4e1-daae36170b9e', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a67a3a3f-1edb-47f0-a99f-dab4c053204d', N'a5a02995-e8e3-4c73-9c8b-b7ae05f846c8', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'56be1a1b-04c0-4b9d-b912-db016b522cdf', N'9b38b717-0bc2-4b1e-9416-e025a341bcfb', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f84dcc63-6aea-4ad1-ba8a-dbaa1413a134', N'7bb31de2-e713-4dc1-a31a-d37b9b1213b8', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4228dfcb-c567-47af-9f8b-dbdb9fe47051', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2190e84c-11ac-4b50-9cc0-dbe52cd703a9', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8b878dc5-6fb4-4112-b479-ddc2eec12aee', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1401a172-7209-4cb9-98f2-dde6ec56adaf', N'cfd88362-9d8a-42a4-8b88-beb36598a381', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd8b85180-9a04-492d-9a8c-ddf01d7f3531', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'66c4e37e-c59f-4686-b889-de0f3bb9a12c', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dcecf8b5-0fa8-46da-bdda-de229c65c7fd', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'404702eb-7f47-4af6-b9bf-de3b160f2442', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3a863011-1726-496b-9bfb-dea6a2f9a4ba', N'bcaeb7a9-1779-4a2f-b568-10d0de5663e7', N'db8b635a-9715-495a-9267-c9db156af748', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5d307078-a44a-4090-b3c3-dedd5bffad7e', N'c8fdbb0f-6669-459c-b5b8-f2234d553a0b', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(2.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'857f7319-b769-456b-b28e-df1abfe1cea2', N'cd5d0119-c210-4dcd-8208-f1b7e45593d7', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cabcbdf7-186c-40a1-9bb6-df2491f07c48', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'309b5d0c-26f6-4e90-903d-df48c22d4002', N'b3a5421d-1215-478f-afc9-948f49126276', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'36ac22e1-3a64-4dcb-aa34-df7b4e98ab74', N'f5840962-cea2-4252-99ba-5f1204b0dfcd', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1afe0dd9-570f-4105-8785-dfa3bf0d4c72', N'9ceb91bb-6046-422a-9c39-d8d758b9ed60', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8fb0293c-432a-4a2a-8a1f-dfa414fe646e', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c409da62-eafb-4440-8e05-dfc9bcfaaa75', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'cf2e5c27-c82c-43c2-ad16-e017ae896213', N'6f628150-e039-48c9-b65d-e0746d66f326', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'392122a4-239e-40b8-88fc-e08f9bd94e38', N'c6432d11-2115-4129-bc9b-7bb3caed6953', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(2.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7c4841b3-197e-494d-8727-e0d658b72fcf', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a8bfd41c-d50d-4289-ab94-e1032a3a8366', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2ca25da2-747c-484d-b959-e12fce3c7a14', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3a7d35c5-b8ac-4872-b8bc-e13bb8a2070f', N'cd5d0119-c210-4dcd-8208-f1b7e45593d7', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0d831b01-4b02-4ca7-94a7-e195b10ce22f', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'312629c5-d274-4c40-b854-e1a183440d2c', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'036ebff6-ac40-4f52-bbb7-e25aeee3384b', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b5463055-57d5-4515-b730-e26125b311c3', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'468a74de-cda4-4273-8d94-e28eb9b2bd4c', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fb6c21a4-0d0b-4014-a246-e29333d24b03', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c5d84792-d925-4a1c-a974-e34c4aed6b56', N'5c229e74-547d-4d82-8c72-24c42db2e0ad', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'41cad07f-8bfd-4556-9e34-e373b2b818ea', N'324a9f1e-4485-415d-8d0f-4e8e8fc4baf9', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6281c601-9977-4779-a2bd-e3bde8a99605', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ebeae4d1-223e-4942-bba4-e3bf00b5b449', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'758a2beb-4547-4389-a52c-e405751a781c', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b3b168e4-b569-476e-b008-e409141de1f0', N'e5d3d3d4-49fc-40d2-9d06-fe1d0cc220a4', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0657064f-748e-49b8-9ad0-e4351d12e309', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f9f24fbb-4224-4291-ab43-e45f6ec660ea', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4c039c10-f235-4cc9-992d-e49737ab7a27', N'c6432d11-2115-4129-bc9b-7bb3caed6953', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'80b4e6b4-7b8e-4e3d-90a4-e4cc65b88f55', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'968a010a-36cb-4ce7-a89c-e4d468c1d272', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5496af68-1935-4d60-a418-e4df84e0519d', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9d8c923f-f9b6-4e6c-9f07-e583e3c949f3', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'02753305-5b82-4c81-8062-e598d683e441', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'baa78088-ba58-421f-a994-e599c76b6a1f', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'08a073be-a66a-40a5-b818-e626e39c11d7', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9d6cba16-5992-42bf-9f18-e63bec9384ad', N'c6432d11-2115-4129-bc9b-7bb3caed6953', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'72743064-803c-4d31-8b8f-e65f70ba3e7c', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'00c2a1ed-3550-410e-bf03-e68580756802', N'd1a4ab78-8483-4d59-8377-744d48bea8ba', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'207b3d36-989a-4356-939e-e6a2ca4aa843', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'af86ea28-2e63-460c-85e0-e6af1c2d3c54', N'cd2ef07a-e046-49c9-aa76-6842ae6ad28f', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b61c7b2f-af53-47cc-b793-e6c793bc18e7', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'84dcfca0-48bd-4ece-b25b-e6ce6a21c11e', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'ac06526d-43a3-4f9b-bfb7-e6d71ef82630', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5838de75-fd2f-455e-b8c2-e6e77f7d9f77', N'517c7e18-f8a3-4c2c-9b36-f5c622a64ceb', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'25198e5a-b906-4028-b27e-e7010bb29611', N'b3a5421d-1215-478f-afc9-948f49126276', N'c68be214-6c7f-460b-8391-2f5408127068', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'48085e70-3029-4960-af71-e718dba7ce2d', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'83bc3025-72b6-4fa8-bdce-e720a694a73c', N'b4cf17fa-9529-46fc-b5d4-ad1ead14f6f2', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'269bacdb-6e56-40cb-bb02-e72dd99b6d89', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'22525cf4-6cc2-46fd-b7ab-e74748f7e5f9', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'db8b635a-9715-495a-9267-c9db156af748', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fa15067b-fc2a-46ba-8868-e74c0a7fa1bf', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e3e51927-cf36-47aa-9036-e74f8d8ce83f', N'b93f5493-e51a-48bc-a6e1-615e4b369e3f', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'49f0e18e-a5a9-4c26-a11e-e7e70e87ab3c', N'c8fdbb0f-6669-459c-b5b8-f2234d553a0b', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(3.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1481f1c5-75ef-46a4-a5d6-e86bbd50b0b3', N'cd5d0119-c210-4dcd-8208-f1b7e45593d7', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e18b955a-d8fb-462d-bce1-e894fe081fdb', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'06f768bd-6f82-4208-9bfe-e8a3a2d9a6cd', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9b70abf7-bca3-48e0-9b33-e8fe5870e26e', N'a35e87cc-e468-4f84-80e4-560072774a4b', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4734c823-514e-4c52-b275-e923f6b8ca24', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd54c09cd-17d5-49c1-8e96-e955644cc71e', N'31f1766f-5296-4db6-81b1-a77c73c15b19', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0abac191-39c7-40d2-bd5c-ea058cddbd85', N'1c589b8f-5cee-4ccf-8af1-194107587e9f', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(2.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f2baa20f-a70e-4b0a-8e03-ea341d954db6', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6f151a94-d26c-4ce8-838c-ea67ce0ddc10', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'e14f72b8-e800-4d57-b1e5-eb1c6087df0b', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'550a1891-26de-47d7-919d-eb4e9afe1255', N'a28c9408-c96e-4a4e-8cb5-cdf1ea119927', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'2072d1fe-5a9e-4ace-973d-ebd3d8e4d7d3', N'c8fdbb0f-6669-459c-b5b8-f2234d553a0b', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(3.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3a06b0eb-4217-4356-b6b3-ebe02abd765b', N'b3a5421d-1215-478f-afc9-948f49126276', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f268dcad-479b-4483-a802-ebfe7c7f0cae', N'39dd0dc1-f32e-4c2c-9421-2f466d5adfc7', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'0701717a-43cf-49ec-932b-ecc72da0056b', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5d90c613-631c-4fb1-b115-ed371b1224bc', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'c68be214-6c7f-460b-8391-2f5408127068', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7dc308f6-58aa-4334-abe7-ed5b1e9bf0dc', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'c68be214-6c7f-460b-8391-2f5408127068', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7415b0cd-36f7-43aa-8417-ed805ae0665e', N'7c628278-d16b-4b5e-bc1d-20171cd81d9e', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'28c3029d-e0c9-46e6-9114-ed92445c4042', N'bb92b5a4-3822-4272-b13f-9f7d6f98ddc9', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'40ca13b9-cb9a-484a-93b9-ed954ef94b62', N'c990165b-1298-49db-a494-312a2c09615e', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7a5859c2-2017-4d21-86b9-edadef08bb17', N'c0122c50-49e0-4694-bb4f-f5b238e90d1b', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'666ba87b-1de0-44d1-8753-edc121256750', N'7e716999-2edb-4c89-baef-adc57787c0d1', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9e1d2d4a-04ca-480b-90ad-ee2a1d854477', N'f0f59c51-2b8f-4887-a1df-856c0d0d90f4', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'733ee6af-4c4e-47a7-9ba8-ee98e8832319', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1f9fca6e-93ba-4aa5-a69a-eec4d86b500a', N'f5840962-cea2-4252-99ba-5f1204b0dfcd', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'4bfb2813-de47-45b2-a203-ef2da7105b06', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fe8d8acc-10db-479e-8db3-efe8f8d05081', N'a9a8f11c-c5e2-490f-b579-79ffbe62425e', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b00b0567-fc65-4fb8-8e81-eff53ba2fd87', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dc6815bb-ef34-4eea-8d8b-f0b426c8311f', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'17fef6a3-7188-40f0-af30-f0f37cd2defe', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'82dedab1-e8fa-461d-9a0e-f10ed03c0e2c', N'522e8138-d318-4f19-8939-2dcfccbc4456', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b0fd8aab-dc79-4214-a6cf-f192e18a2bd4', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'77b8e64b-d57a-4545-9157-f2345315023a', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b3911312-7bce-41f4-b3f1-f26e4f24e6d8', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
GO
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7ab51be3-11da-4f8b-96df-f47eedc6bd1a', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'965c3f3e-7398-4f50-8e71-f49517b66f95', N'00d79558-9ba1-4087-a7d9-32f13d0fab66', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'da971a95-1970-409b-bad2-f4b3b101ab11', N'6204ceb5-b925-4266-8930-c2e48e93fb6f', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd0ce1870-5ecd-45c4-a4f0-f4d9af118af4', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c2a4d2e6-e7ea-4f2d-87b4-f4f4cddefa97', N'3b6f8612-0111-4bcc-b418-fff7a5ef151a', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6b514cbd-2543-415c-9a76-f55c3b3eecdf', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f75f8796-3766-4cf5-823f-f62ffaddeba4', N'494c0d3c-3c2f-4f5d-9637-8116ecd48521', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'33378b11-8cf9-4ac1-9445-f64c919ed3a4', N'75d114f0-bb08-4f19-a3a7-2eaa1efec580', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd17b8967-44e8-4c5f-9426-f6c94b95eed7', N'256e9eb5-3ac5-4699-a979-8d5e5a5186f7', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'26a7d885-c7a3-4658-a23f-f6df2c03180b', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'206a55a6-aba6-4089-a8e9-f6e431744fb5', N'c37b5208-12b5-4810-bcb9-987f8be8981b', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'47b0a8ff-e2d0-469b-bfb8-f7448b591fd6', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'04e70bb3-97fe-47ff-81ec-f7d34c669ba7', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5457464f-c838-42d7-aa14-f80d60c73312', N'd1a4ab78-8483-4d59-8377-744d48bea8ba', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1275a1d5-bf8a-4f01-aeeb-f85d9ad8db64', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'aaed9de6-5d38-4ebe-a91d-f8754ceeae83', N'a2733255-bb66-4915-a9ed-639a2addcc95', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'13509b5a-3209-4114-b6db-f8fe8d3fc92e', N'0c2efa14-3a4a-4345-97dc-1451cca95d9f', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5379fd4c-4b29-498d-9474-f916785d6d36', N'1cb24750-ed55-4f8b-be2b-13f79c7735b1', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f6f5a93d-9417-4d3d-afd3-f99783526c35', N'e405a55c-e3cf-4ed8-9bd1-67f73c66bbd3', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3816fbf1-7edc-4907-8305-f9a342bd0fec', N'1a61806f-419e-468d-aced-59d7b54031ff', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'36dacff7-e9bc-4fc5-9fd8-f9ffe05593c6', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'29423f22-b0a2-46c7-a4fc-fae78c8d6771', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a8919ee9-62a7-4555-9668-fb1068734f28', N'1cb24750-ed55-4f8b-be2b-13f79c7735b1', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f8f75d3a-65c6-4aed-8feb-fb3112778d2d', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'699806a1-b706-4231-83cb-fb68f02db414', N'32e76ece-5973-43b5-90cd-28907f5e3e5a', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'f52da5f3-7199-4f63-8173-fb6b0a22f79d', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'77c13d2d-ef3e-40cd-aa54-fb6c67f83b51', N'9ceb91bb-6046-422a-9c39-d8d758b9ed60', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'1c37fb6c-e427-4959-ac80-fbb1aad98ab4', N'6d25d66c-0b40-494b-b9c6-966e86d40434', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'3a2eb2e2-6f81-4acb-a2a8-fc1c9aaf449e', N'0196c526-8c9f-4ff9-8950-d34f242a3939', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7dda0452-4cdf-4484-ba32-fc2893542b86', N'f695a5ab-0648-49c2-bc26-042085680d0e', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'c3f63e45-e77f-4044-98af-fc3325eb57af', N'53d5f9ef-f674-4811-ad96-ca6a218a0a8f', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'dbc6111c-7511-4b6c-9819-fc47c93f3ff3', N'435cc65a-4ab0-48bb-b3d3-47e115416630', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8bed7fea-8d23-461f-8210-fcd825f84998', N'96003351-9d78-4acb-a79d-d701f0aac80e', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'd53ad818-cf3c-46a8-8948-fcf9d9e982af', N'cc9abb80-54b7-4f32-801f-d63906e11ee5', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6085d850-7fec-413e-88df-fd0f2574b39c', N'f5201a57-9b81-4b7e-bae4-a715f19f2644', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'fd4748ef-3bc6-435a-bac1-fd21110669e7', N'f4c0792c-cf13-40db-a1c0-5b62fc2845c7', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5350ef55-3d8c-44d0-bcd2-fd4ec51922e6', N'7e716999-2edb-4c89-baef-adc57787c0d1', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'7b64ab5e-cb7c-400b-beca-fd80093f2b19', N'a8e902df-be37-4a14-9f99-606b61b2a645', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'8e20ace9-2a67-4b38-8059-fd87e2f2a4d7', N'b3a5421d-1215-478f-afc9-948f49126276', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'b7dae2db-3de0-4566-886f-fded9159d371', N'a7bc3851-6370-4fea-b735-818b3c99021a', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9843dc1b-b90b-4fc4-979e-fe7160bc333f', N'06fdebb4-1ca8-4e37-bf98-b38f14f453c9', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'82451157-5164-4dfb-8652-581a66595a9b', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'902ec7ea-c763-4a3c-b20f-fe7d160d63e9', N'1cb24750-ed55-4f8b-be2b-13f79c7735b1', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'9d0319e4-1ee2-4eb4-81e2-ff2a1e9dc258', N'90cffd30-94c4-446a-82fa-b77d579b4e8d', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00203')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'a58d74ab-9d81-4508-aa8f-ff4b3a56145a', N'e560af1e-00b0-414a-aaae-4f5cbf92d690', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'65c0d8b8-f3c1-4e02-96e2-ff93da8b1f2a', N'b6390530-20ea-48a7-9c20-598c93288ff4', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', CAST(0.00 AS Numeric(9, 2)), N'00202')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'032a2a8e-7edf-4939-8106-ffbff0729ecf', N'b4cf17fa-9529-46fc-b5d4-ad1ead14f6f2', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'6d3cfab2-8eec-49e2-8ef8-ffd67a46c101', N'034722e8-59d4-431c-86af-358345646362', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
INSERT [dbo].[SubOrderFlowDetail] ([IdSubOrderFlowDetail], [IdSubOrderFlow], [IdSupply], [IdProduct], [QuantityReturn], [MTLocation]) VALUES (N'5968240d-cf23-4f91-9f86-fff29e907785', N'09f37e50-5647-414e-81ae-abe12039bf83', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', CAST(0.00 AS Numeric(9, 2)), N'00205')
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
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0670f8f6-dd4b-4794-896b-000927472573', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6faa952c-f37e-4289-816a-0355974f215e', N'40180ca4-5626-4033-826c-e444a0bebc58', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'418b4d8d-aa87-4d09-ac85-03a735e6c000', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b623f177-ac3f-46bd-b742-0a8728682482', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0bc5c6b7-3be7-401c-a56e-0b586afce9b5', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'1109aefc-87da-4b11-8228-0bbe60252022', N'837ae6eb-05df-4997-aed1-428681ef566c', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'febe2120-2d27-4208-8578-0bf3832a3846', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(15.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'eb53dc47-8154-44ee-b70a-0c30411b7ced', N'db8b635a-9715-495a-9267-c9db156af748', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b43ed235-9792-4c93-9109-0cf073e71513', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'684eac23-1921-4f9b-afa2-0f04a88e49c0', N'837ae6eb-05df-4997-aed1-428681ef566c', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'10b30d60-12ba-4a93-a0b7-0fcaed77760e', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'18b212ab-6218-4960-8b24-0ff9b286fd27', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00202', CAST(9.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c83737f7-18b6-43c6-9c60-10db0035c00e', N'c68be214-6c7f-460b-8391-2f5408127068', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'e7299d84-3629-42b2-b7ec-12cd673e2ef7', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'5f2ac8da-153f-483c-b949-12f6783606b4', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'91fc79e1-5e43-4d91-af29-14a6fa474286', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7ca8d4cf-41b8-48e3-a181-151bb75263fa', N'837ae6eb-05df-4997-aed1-428681ef566c', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'd64d27f6-03a0-463e-8c4e-1626931ce142', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'16c89495-6c11-4542-b6f6-163b070e365c', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6b2a8e27-1d51-4dee-bf63-1680ba818cef', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9d08156e-9378-4a7e-9f73-1866adcc843e', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'19403852-d5ae-4362-9bbc-1b1deb958807', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'bc0f74f5-d4f5-402d-a0f8-1c6996f6a5c0', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7d201533-aa2b-4512-9a57-1d46a97a0423', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(15.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'3172590e-3b52-4509-997e-1eafe6124224', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2dfab8df-24d1-4e79-9330-212f98ae56ac', N'601c2cfd-5620-4687-94db-96467fb806eb', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a9d6f240-4de6-4293-85cf-218ec25cb579', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00202', CAST(9.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'380d9edb-e648-4c87-a0dc-21b433ce1cdc', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'3b6ed647-1a42-43e0-b807-22cf1ab8bb70', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9826acd2-2bc0-4ace-b5f6-230f8908e506', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(15.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'013892e8-a651-4c44-8fcf-250c84b66c95', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7675266d-62aa-4416-b2c3-25d839245e81', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(15.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'fd95bcbc-f2fb-4efc-8c9c-26508a2d5224', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'd9b5da1d-3097-439c-b1f5-29225d4d4f84', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'39ae5056-97de-40ae-90e6-297d42a34674', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'82451157-5164-4dfb-8652-581a66595a9b', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'67c01d39-4e1a-47e8-b95e-29e39467c691', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'65bad4ca-477d-475c-86ec-2b9977413a52', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'602ae5bd-fef1-45f3-8af3-2cc1f51fbcd6', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8882c47c-327c-4677-81f3-2d24f737c4fb', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6bbd2f25-1e94-4ddc-8bdb-2d6d8593a0d5', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'82451157-5164-4dfb-8652-581a66595a9b', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ddbb2f5e-695a-458a-9455-2e1be40b01f2', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'84111db1-a5a0-43ec-8415-2f9e754e0b28', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c1c60988-e59c-4a7d-8dbf-30e3fa9b5707', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00202', CAST(9.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6dc38f1d-63b5-4667-b641-30fd7ae93838', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'92b31d52-ccc9-442d-8b2d-3138545a95f5', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'47235ea2-0ff6-40a4-aa9a-32b6658c6cbe', N'db8b635a-9715-495a-9267-c9db156af748', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c1221ca6-f6c3-47c1-98ff-32f83ed35616', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b1a108b4-8bb4-4967-8e0e-331623a36e7d', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'cd88bf54-80fd-4403-b39f-346299cecbde', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6b2b674d-7cec-4f71-ab93-3569e4a44e9b', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'db188cc9-359d-4482-85d8-35e404474386', N'601c2cfd-5620-4687-94db-96467fb806eb', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'4167813e-1f18-44d6-840e-374953d69ca1', N'c68be214-6c7f-460b-8391-2f5408127068', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'fa4b5afd-3287-4b9a-8b70-379f0f64050f', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ca88a55b-7999-4922-9e1f-3813074e4a9d', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6cdfeace-2e4b-48ee-9089-395cb0f29ab0', N'40180ca4-5626-4033-826c-e444a0bebc58', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'96974f17-9b9e-4701-99ae-3a188a5edcaf', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'55de5d6f-2f99-4bd3-9d21-3b894e800b5f', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'73b34374-1285-4302-a24c-3ba1330fbb6c', N'c68be214-6c7f-460b-8391-2f5408127068', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'58da5dea-ce4c-4218-843f-3c7cfd841a45', N'db8b635a-9715-495a-9267-c9db156af748', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0d9ac3c1-2ed8-40ad-88ba-3ca72a1270ac', N'd848e787-625c-44f5-a6c6-93882ce82172', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'526a7b1b-dab0-4043-a71b-3d27cbd55841', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'655c9990-8716-4bf4-a735-3d71483fe18a', N'c68be214-6c7f-460b-8391-2f5408127068', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8ebbb52d-d1fb-4393-8834-3e91d39bbf93', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'16a2d8c1-118e-42aa-a096-3f0b1ba78f4a', N'c68be214-6c7f-460b-8391-2f5408127068', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b3cba7ca-4c9c-4957-9279-401badead449', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'82451157-5164-4dfb-8652-581a66595a9b', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'e370e828-a6ea-4ecf-a9f4-44939f795bf2', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'caded7cf-40d0-4ad0-8540-449a44df72fb', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ff4dc369-7ba8-47e4-ac52-46bde102f042', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'e1847fd6-cf2b-4da5-91bc-4727e3cf7664', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'49b094b6-1cd9-4ce7-9c8d-47aca436f8c2', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'aba10e1d-fb1c-4af1-8dbf-48292896c748', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'62caf682-1399-4a57-81a8-487968681225', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(15.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'fa1b3fc4-ee0b-421c-b9ca-50632f874ba7', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'cad3a4b6-fe13-4fe9-8cf7-55dc4e43cd57', N'837ae6eb-05df-4997-aed1-428681ef566c', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'17183fe6-1ad7-4a0c-bf02-56010e452292', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'11810c2d-c781-4b63-b0d9-581b4c45c500', N'd848e787-625c-44f5-a6c6-93882ce82172', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'159b48a0-0343-4ea0-844f-585f3db8d19b', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'd0b98afc-8af1-4dff-9059-59a2f5a1747f', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'85a98c28-02ad-4923-ba88-5a3fcc7c76c6', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'f28b16af-bdcd-4f8f-9375-5b66563b66af', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7c7a855a-779a-46ca-bf28-5bcf01056306', N'c68be214-6c7f-460b-8391-2f5408127068', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a1cbc6b0-8df2-4249-bf3c-5c0d0d53d97a', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00202', CAST(9.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'3b1313bb-3b73-4c0e-b7a8-5c5b0b68c4e8', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'eb9a0601-8d85-45ab-87b1-5d781f4d0580', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a3d8e729-1578-4e51-b6ac-5d943488d134', N'db8b635a-9715-495a-9267-c9db156af748', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8529c185-8870-4cf9-8b3b-5ed241c8dd55', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'34645ea2-3f52-426f-8d74-618b4da5d757', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'f38a2558-fa38-4149-b251-618ed9fec4a0', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'db24fa9f-8185-48e7-930a-62160a42222f', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'20d766ca-6578-4322-949b-629a4f689c04', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2d5ae034-b013-4742-8a38-6341526ddbe7', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'1f9be1e4-d863-44be-b6c8-642032feeda9', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'd4062c03-9fb7-4fdd-bd11-64ddb57ca938', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(15.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'94b638f3-8eb6-4d5c-9075-665b78368134', N'db8b635a-9715-495a-9267-c9db156af748', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'69ff95b0-917b-43e1-8627-6878a12770d1', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9100ddd4-da52-408d-8aaf-69c7fc8671dc', N'837ae6eb-05df-4997-aed1-428681ef566c', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'3b83486f-e900-4b97-8bcb-6c71b17cdac9', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ec8b2305-ed8e-4150-91da-6d1491d36c73', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'5cbeb222-86db-43b1-9229-6e931708c6e7', N'40180ca4-5626-4033-826c-e444a0bebc58', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'495c5181-89fb-4129-8999-7137e35ea49d', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
GO
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a0e8f2ed-b2a0-424c-a4fc-73c58d3234b4', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'f9199f15-52db-485e-9823-73e206758029', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'd8e4ed42-a129-48d2-93f1-742aa07fc786', N'd848e787-625c-44f5-a6c6-93882ce82172', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9cebed0e-f93b-4c21-af99-7a11a715d2a5', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2accce4d-1e04-49cf-9974-7a5df092f29c', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a0dbf801-b4dc-4049-b512-7b349c646e25', N'c68be214-6c7f-460b-8391-2f5408127068', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c7ff33d5-371b-47b6-848f-7ba50e9f521d', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'eb9da7c0-6f9a-4073-9614-7d087de23530', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'4eb2906f-001b-4b42-a48e-7d2ea555f1f9', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8fc672f2-f14e-4d25-bee8-7ff67ee1cfb3', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ed242d0f-7460-431b-bf5e-81c8236e82d3', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9e1c5298-9a9f-486a-88b1-83979ae1a81e', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'bec3c544-d285-41b9-897e-845c6b7a2908', N'837ae6eb-05df-4997-aed1-428681ef566c', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'1e3fa314-aef4-4154-92c0-849300ceac33', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'1e6c715e-e7cd-4a70-a069-84e7a6564058', N'c68be214-6c7f-460b-8391-2f5408127068', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ae7c61af-11e6-4878-8ed5-854508207ae3', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'702bdfd9-1c8a-4bce-b5c5-85ee0a23cf3c', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'53507749-15a7-4098-b630-873c6330477a', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'e4d4e8a5-8798-4108-8937-8793c4adc183', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'f48e29f7-77bc-47a3-9d78-87d9af57f664', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'4f2dc659-85f0-449a-a33a-89301bcc2489', N'd848e787-625c-44f5-a6c6-93882ce82172', N'82451157-5164-4dfb-8652-581a66595a9b', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'21a7a251-6d6c-456c-9563-898b928186e8', N'c68be214-6c7f-460b-8391-2f5408127068', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'64da8328-96e3-4170-8ced-8ab5a0115e5c', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'82451157-5164-4dfb-8652-581a66595a9b', N'00202', CAST(9.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'afdc8496-431d-462a-b545-8d03b7f99ab1', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c047e93b-142d-4eeb-8109-8d22ab228bff', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'132ec2f7-37a4-4bc3-8b74-9141ab6f72c4', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6b875155-c13d-421a-b915-9471cd8454a3', N'db8b635a-9715-495a-9267-c9db156af748', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'09a18ad5-26df-4140-87e0-957c2a59860f', N'db8b635a-9715-495a-9267-c9db156af748', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'1fdb3a79-4d5e-4fd3-badc-957f8e21fc07', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'01fc4d6e-01bf-4f7a-bd39-96467bde43e2', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'80eb155c-62f9-4629-812b-9e4a202df860', N'837ae6eb-05df-4997-aed1-428681ef566c', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'5bfcd32b-72e5-408b-8baf-9eba0df2c1cc', N'db8b635a-9715-495a-9267-c9db156af748', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'235dfe22-06df-4fe6-9c23-a0f4e96c720c', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6474ffc5-6971-4271-a202-a13ab9600a8d', N'601c2cfd-5620-4687-94db-96467fb806eb', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'76475f83-0d42-4c33-a702-a19724da5c88', N'c68be214-6c7f-460b-8391-2f5408127068', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ad418820-2975-4a00-b3c8-a1ed6d8a1786', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b7a21b14-d64c-4eaa-81f2-a241f3491dee', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'66fa6fb0-1b67-4ac5-886c-a302c519af33', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a6bba3f8-63d3-4337-8a0c-a3c74ad1956d', N'40180ca4-5626-4033-826c-e444a0bebc58', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0ef6d163-2151-4090-95ec-a445488d7677', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'39fc2c52-9e20-4bdd-aa31-a4d16d08c80f', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'3f40bbf1-658b-40ff-b2ea-a56333847b48', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ac3e9182-a2a7-4af6-902f-a7733aa20dc3', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'd2391f56-e3db-488f-b276-a7bdbc85cc4c', N'd848e787-625c-44f5-a6c6-93882ce82172', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2ad307d4-c61a-4919-b805-a7d6ee4b333a', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2e1324bc-2712-4134-bfa6-a9371cbd81e9', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a3390e88-857b-443d-a737-ab516441ee1b', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'34edd13b-6199-421f-9e37-ab7f2745effc', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'bac12e02-40f5-43bd-8e1e-ab94c0e77450', N'db8b635a-9715-495a-9267-c9db156af748', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2fcdb791-d9dc-47cf-862c-b13385ea4354', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b561762b-7421-4f22-90e1-b186fa4878bf', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6a2fcc51-40fe-480a-8e37-b324bdfbbe08', N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'82451157-5164-4dfb-8652-581a66595a9b', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0153d3bd-44b3-478e-9793-b5a1b0930073', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2e267147-e0a0-4351-bce7-b6b2f7576744', N'db8b635a-9715-495a-9267-c9db156af748', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'f852338b-95eb-4e45-91eb-b7c374449eda', N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9ad57ab8-8c43-409b-9a83-ba5cc8db2367', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ce35d475-6523-4351-9802-bac393ece14e', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'f74705f4-2ee6-4613-a92f-bd877507ccc6', N'601c2cfd-5620-4687-94db-96467fb806eb', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7064c755-24f8-43c3-a85c-bd985f8cf1f6', N'601c2cfd-5620-4687-94db-96467fb806eb', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'67e1be1a-39df-4cdb-885c-bdfe82f87cc5', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9ffd8feb-3ace-4968-b572-bec947384add', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'657636a0-0d6e-4e6b-ba40-bfc6c6c3687e', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00202', CAST(9.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9b25247b-5944-4d07-8546-c05ce0252758', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b407a4a4-f21b-443f-94c9-c19c34885bc6', N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c59cabef-2fa9-469f-a55f-c1b5522be366', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6ef42ea6-4afc-4d95-915d-c3da328c6efc', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'23fbb707-e9b6-4103-8a26-c438edbf4527', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'53e1bcc1-9f02-4c66-a79f-c6ac8ec0b98d', N'd848e787-625c-44f5-a6c6-93882ce82172', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'99517d55-6a71-4070-b2fe-c6ecef3abf8b', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'496aedb1-33ec-4c15-b609-c72e368622a2', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'731d8f38-4c75-4fe0-a0be-c858ee12a8c9', N'837ae6eb-05df-4997-aed1-428681ef566c', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'395b3cf0-2492-42d3-912e-c8cbc5933796', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'38f55cb6-fad1-4135-a375-cbc75bbd8d9e', N'837ae6eb-05df-4997-aed1-428681ef566c', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'246812ed-60e1-4eb4-b1a2-cc19d513d61d', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'492c7026-8068-41cb-bb9b-cc2372bf99a5', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'fdef54b2-7dc1-420e-a474-cd670df13198', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'4601e1d3-0145-45da-951f-ce1ba4a42470', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'97f3f5af-715f-416a-a9ef-d051f0b4e566', N'40180ca4-5626-4033-826c-e444a0bebc58', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'db8ef804-183c-4249-aad0-d1caa6681265', N'601c2cfd-5620-4687-94db-96467fb806eb', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'44b6d09c-bfe2-428f-867c-d35ad6ab9a4b', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a9e806e3-3d09-45cd-8a24-d47d15f7fcbd', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8a40a310-c242-403d-bb12-d4e705a471c2', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'52cdf756-d4c7-45aa-a1dd-d4ff1f59b4da', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'420183e2-f767-4ce4-a68c-d6b309077d98', N'845ee202-e8f2-4596-b739-6dee56b467c3', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8c3f1b71-6de2-4770-84fd-d7e3e8fc1bab', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'cb3592a4-08d1-4aad-b040-da2c7ed5e23f', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'0f027fc4-5fa5-402e-8b60-db212421f4bc', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'684234cb-e2b7-4348-8af2-dca463e689c7', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'4d81ea53-e954-462b-b2dc-dcf363117064', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7d51e17a-2b98-4e4c-bc74-dd9814aaafe3', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'97d6662e-f728-4315-8a13-de580908ba80', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'21fffefc-183b-4bd1-8b55-de5bb87cd721', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'60d8870b-e560-4fc7-8896-df61cb67da89', N'25498e8c-f454-4528-b443-63b2394f4cfc', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'170254db-fe69-4b78-b1c7-e015378099ce', N'c68be214-6c7f-460b-8391-2f5408127068', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6f2a0479-44e8-45c7-8597-e01ddeab93f6', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'eba1503e-219d-4e84-a6bc-e0aafc886566', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c145f428-223e-45ae-ba2e-e22c9c42019e', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'41e1404d-e0f8-4dd7-a936-e26ef8f96e3b', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c84e3ccf-5ca3-4978-b9ad-e35f1c042a60', N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'a17aa157-5fd1-4339-b494-e59bf7432f72', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
GO
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'79731940-def0-4e04-9ca3-e7b48a8d4501', N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2f7b78b1-27ff-4d06-b054-e86f045d403a', N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'3754b17a-7c4f-4a9a-999a-871b700c5272', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'3c8eb643-782e-42b0-b75d-e905e4beebb3', N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'bafaf3c0-7ab9-4219-bf46-e9cf7765ae11', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'dd17ff95-4deb-4acd-bd02-eb3a9fe068c9', N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'e8380175-59be-4cdf-af06-d39f7caf4c43', N'00203', CAST(11.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'46a1d7d6-5932-4978-a631-ed9561d1b404', N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'c20ad36d-4bc4-418d-be6e-ee04fafc8d4f', N'db8b635a-9715-495a-9267-c9db156af748', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'8e7305f4-1427-4cb9-8f88-ee4265ed0444', N'837ae6eb-05df-4997-aed1-428681ef566c', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'b49c7f54-d746-4acc-9479-ee6c6994a7d6', N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'82451157-5164-4dfb-8652-581a66595a9b', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7a2c7560-c2aa-48c8-8425-ef7a078eb1ca', N'837ae6eb-05df-4997-aed1-428681ef566c', N'86e90a40-278b-41e7-8aff-b5ab5f36f3ab', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2317c7c4-fd22-45e4-8a84-f258e78f16ba', N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'996a412e-9def-4a24-9ad7-f2f8437a86f2', N'40180ca4-5626-4033-826c-e444a0bebc58', N'd361e525-deb5-4666-9dbd-1acb12a543af', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'6ddc7956-1d28-4763-b402-f3d4bd788da8', N'6f472791-ceb5-4497-951b-1377cb3551a0', N'f2f1260d-8b9a-4731-8df2-bfa4f697aaf6', N'00202', CAST(19.00 AS Numeric(9, 2)), N'00502')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'03e7d0cc-47b4-4193-8dfb-f45fa69cbf98', N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'4fecb6ff-0508-45c2-a2c2-84c2f51514f6', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'2988a1bc-a008-4b69-855a-f4a703bdc607', N'd3347ca7-7be3-4db1-864e-63e98c256996', N'76d5f7f6-2bd4-4718-9bef-2f21a381cb9f', N'00202', CAST(6.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'7073c030-18be-42ac-afbf-f50ee1b1827f', N'0bc333f7-af1c-40dc-921e-c69317385c80', N'd18c3091-729f-48e1-940a-81c7f864afb2', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'ffda036c-669d-45f8-9db7-f5797dcb0317', N'c68be214-6c7f-460b-8391-2f5408127068', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(14.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'090e5e2d-5b82-44a1-9f07-f8348dfefc7e', N'db8b635a-9715-495a-9267-c9db156af748', N'82451157-5164-4dfb-8652-581a66595a9b', N'00203', CAST(5.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'9fc9eab3-40f9-40f8-934f-f8897da8863f', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'4bd491ab-0800-4756-b6fa-fdba3bdbfb33', N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'1fa19b13-e1fe-4550-b611-0e37ce23b9cf', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'5d1219f2-54f3-4908-9375-fed3884abb9d', N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'e89a8a6e-8b96-4da7-b85a-570bd7d9850f', N'00205', CAST(8.00 AS Numeric(9, 2)), N'00501')
INSERT [dbo].[SuppliesByProduct] ([IdSuppliesByProduct], [IdSupply], [IdProduct], [MTLocation], [Quantity], [MTMeasureUnit]) VALUES (N'52185c64-3976-4b45-a8eb-fedbf735e5af', N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'abd7c103-7799-405a-bd90-9b0cffd6a82a', N'00205', CAST(12.00 AS Numeric(9, 2)), N'00501')
GO
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'580b0875-f477-4686-8736-08e807c737a2', N'cinta santida celeste', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0001', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'8e8bcb55-13c9-437b-819c-0a99b94f7fc1', N'placas c ', N'A', CAST(998383.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0002', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'6f472791-ceb5-4497-951b-1377cb3551a0', N'maquina de corte', N'A', CAST(997763.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0003', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'e559a8b8-ecff-4e63-ae18-20a31ce9c423', N'placas a', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0004', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'c68be214-6c7f-460b-8391-2f5408127068', N'cinta scotch', N'A', CAST(998231.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0005', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'2174aff5-e4b4-46b5-ac6b-41bc37d1d627', N'hilo santido dorado', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0006', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'837ae6eb-05df-4997-aed1-428681ef566c', N'correas', N'A', CAST(998383.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0007', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'4cad87ac-7560-4fb0-b8fe-58f014dd00a2', N'botones a', N'A', CAST(999087.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0008', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'28f68df7-2e90-406d-acf6-5a1c4575f5d5', N'botones b', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0009', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'363f6293-7942-4af8-87f8-612cd079f4e4', N'hang tag a', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0010', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'25498e8c-f454-4528-b443-63b2394f4cfc', N'hang tag c', N'A', CAST(999295.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0011', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd3347ca7-7be3-4db1-864e-63e98c256996', N'tocuyo', N'A', CAST(998027.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0012', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'845ee202-e8f2-4596-b739-6dee56b467c3', N'tela jeans b', N'A', CAST(999471.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0013', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'66798a4e-58b1-493a-b8dd-6f9e5c569221', N'piedritas brillantes', N'A', CAST(999295.00 AS Numeric(9, 2)), N'00504', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0014', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'15afde2a-eded-4d85-9f1d-753dccbbc7a1', N'maquina de placas', N'A', CAST(998155.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0015', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd020217c-7af7-496c-8183-7ed9739f39ad', N'hilo santido plateado', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0016', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'ba187d8a-06f3-4890-995b-8ffdfe9ccff8', N'cinta santida blanca', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0017', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd848e787-625c-44f5-a6c6-93882ce82172', N'etiquetas de bolsillo a', N'A', CAST(999559.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0018', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd6b9a453-ba62-443a-8fe1-955eb0332b44', N'hilo crudo', N'A', CAST(999559.00 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0019', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'601c2cfd-5620-4687-94db-96467fb806eb', N'tela jeans a', N'A', CAST(998555.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0020', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'fd57b3e5-a245-491f-bb9a-96921c063b17', N'etiquetas de pretina a', N'A', CAST(999163.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0021', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'930d02f3-6193-40a7-a26d-9bdb1702ca78', N'etiquetas de pretina b', N'A', CAST(999559.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0022', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'7681bd6f-1443-49a1-88a8-a59a3b7bf595', N'bolsas ', N'A', CAST(998383.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0023', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'22ebf668-394d-49dc-80d8-a7fbd66d1e40', N'cola de rata blanco', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0024', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'9f32064c-7fdd-4315-b866-b4b1d2f7b497', N'placas b', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0025', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'1b7f63cb-35a3-4959-b496-b89605c1a9be', N'remaches b', N'A', CAST(998383.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0026', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'5f70745e-f005-4f10-9a47-be4f1e6cab74', N'botones c', N'A', CAST(999295.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0027', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd59fd392-6773-4eda-aaed-c39ce6588ab9', N'hilo azul', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0028', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'0bc333f7-af1c-40dc-921e-c69317385c80', N'plancha transfer', N'A', CAST(999295.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0029', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'db8b635a-9715-495a-9267-c9db156af748', N'cierres', N'A', CAST(998723.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0030', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'd6a2364c-1384-4654-b2d2-d44cf35f8847', N'hilo negro', N'A', CAST(999163.00 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0031', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'1eb2b87a-7b81-433d-93fb-d48a39b08ef9', N'etiquetas de bolsillo b', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0032', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'20ee7527-50ba-42cc-ab3f-d861834ad735', N'maquina de botones', N'A', CAST(998383.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0033', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'fdf3f2bf-1bb4-4e04-92e9-d8bf21c4cc10', N'remaches a', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0034', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'91ecb8b8-7a39-4da2-a04a-dc53514c6ad3', N'cinta santida fuxia', N'A', CAST(999087.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0035', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'9c3895a7-767c-4194-97d4-dde87a79fd57', N'hilos marron', N'A', CAST(999999.00 AS Numeric(9, 2)), N'00503', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-02' AS Date), N'0036', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'40180ca4-5626-4033-826c-e444a0bebc58', N'hang tag b', N'A', CAST(999087.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0037', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'6b927984-817c-40d6-b754-f4bb0b839bd4', N'maquina de remaches', N'A', CAST(998383.00 AS Numeric(9, 2)), N'00502', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0038', CAST(5.0000 AS Numeric(18, 4)))
INSERT [dbo].[Supply] ([IdSupply], [Name], [RecordStatus], [Stock], [MeasureUnit], [MinimumStock], [DateUpdate], [CodeSupply], [PriceUnit]) VALUES (N'bfce6d28-f9d1-4711-99d1-f88c29435382', N'cola de rata negro', N'A', CAST(999295.00 AS Numeric(9, 2)), N'00501', CAST(25.00 AS Numeric(9, 2)), CAST(N'2021-10-29' AS Date), N'0039', CAST(5.0000 AS Numeric(18, 4)))
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
/****** Object:  StoredProcedure [dbo].[Usp_Generate_OrderFlow]    Script Date: 10/11/2021 2:06:40 ******/
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
			,0
			,0
		)
		
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
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
			,0
			,0
		)

		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
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
			,0
			,0
		)
		
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
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
			,0
			,0
		)
	
	
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
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
			,0
			,0
		)

		
		INSERT INTO OrderFlow
		(	IdOrderFlow
			,IdOrder
			,NroOrder
			,LocationOrder
			,Answer
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
/****** Object:  StoredProcedure [dbo].[Usp_Generate_SubOrderFlow]    Script Date: 10/11/2021 2:06:40 ******/
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
	DECLARE	@VIdProductSubProcess	UNIQUEIDENTIFIER, @VIdOrderFlow	UNIQUEIDENTIFIER, @VIdSubOrderFlow UNIQUEIDENTIFIER;
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
		
		SELECT	@VIdSubOrderFlow = NEWID();

		INSERT INTO	SubOrderFlow
			(IdSubOrderFlow, IdProductSubProcess, IdOrderFlow, StatusSubOrderMT, CodeSubOrder, DateSubOrder)
		SELECT	@VIdSubOrderFlow
				,@VIdProductSubProcess
				,@VIdOrderFlow
				,CASE	@VIdLocationOrderMT
					WHEN	@CIdCutAreaMT	THEN	@CIdStatusPendingMT
					ELSE	@CIdStatusCreatedMT
				END
				,[dbo].[FN_GetCodeSubOrder] (@VIdLocationOrderMT)
				,GETDATE();

		INSERT INTO SubOrderFlowDetail
			(IdSubOrderFlowDetail, IdSubOrderFlow, IdSupply, IdProduct, QuantityReturn,MTLocation)
		SELECT	NEWID()
				,@VIdSubOrderFlow
				,SBP.IdSupply
				,SBP.IdProduct
				,0
				,SBP.MTLocation
		FROM	ProductSubProcess	PSP
		INNER JOIN	SuppliesByProduct	SBP
			ON	PSP.IdProduct	=	SBP.IdProduct
		WHERE PSP.IdProductSubProcess	=	@VIdProductSubProcess;



		FETCH NEXT FROM	InsertCursor	INTO	
			@VIdProductSubProcess
			,@VIdOrderFlow
			,@VIdLocationOrderMT
	END
	CLOSE InsertCursor
	DEALLOCATE InsertCursor
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Get_OrderByCodeOrder]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Get_OrderByIdOrder]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Ins_BuySupply]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_List_Order]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_List_OrderByLocation]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_List_Product]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_List_SubOrderByLocation]    Script Date: 10/11/2021 2:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================
--DESCRIPTION: Permite obtener el listado de subordenes a partir del Location.
--CHANGE:	   -
--EXAMPLE:     EXEC [dbo].[Usp_List_SubOrderByLocation] '00204'
--=================================================
CREATE PROCEDURE	[dbo].[Usp_List_SubOrderByLocation]
	@ParamIIdLocation	CHAR(5)
AS
BEGIN

	DECLARE	@CFlagTrue				BIT		=	1;
	DECLARE	@CIdStatusPendingMT		CHAR(5)	=	'00101';
	DECLARE	@CIdStatusCreateMT		CHAR(5)	=	'00104';
	DECLARE	@CLocationOrderVentas	CHAR(5)	=	'00201';
	DECLARE	@CLocationCostura		CHAR(5)	=	'00203';
	DECLARE	@CLocationLavanderia	CHAR(5)	=	'00204';
	DECLARE	@CLocationAcabado		CHAR(5)	=	'00205';
	DECLARE	@CNumberThree			INT		=	3;

	IF @ParamIIdLocation = @CLocationLavanderia
	BEGIN
		SELECT	DISTINCT	O.IdOrder
				,O.CodeOrder
				,SOF.IdSubOrderFlow
				,SOF.CodeSubOrder
				,CASE	[OF].LocationOrder
					WHEN	@CLocationLavanderia	THEN	CAST(OD.Quantity AS INT) / @CNumberThree
					ELSE	CAST(OD.Quantity AS INT)
				END							AS	Quantity
				,CAST(OD.Quantity AS INT)	AS	QuantityTotal
				,SOF.StatusSubOrderMT
				,MT.[Name] AS StatusSubOrderName
				,FORMAT(SOF.DateSubOrder,'dd/MM/yyyy') DateSubOrder			
				,ISNULL(FORMAT(SOF.DateEndSubOrder,'dd/MM/yyyy'),'') DateEndSubOrder	
				,PSP.IdProduct
				,CAST(ISNULL(SOF.QuantityDecrease,'0') AS INT)  AS Merma
				,OD.IdOrderDetail
		INTO #TMP_QUANTITYLAVANDERIA
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

		IF OBJECT_ID(N'tempdb..#TMP_QUANTITYDIFFERENCELAVANDERIA') IS NOT NULL
		BEGIN
		DROP TABLE #TMP_QUANTITYDIFFERENCELAVANDERIA
		END

		SELECT	IdOrder
				,CodeOrder
				,IdProduct
				,MAX(CodeSubOrder)					AS	MaxCodeSubOrder
				,SUM(Quantity)						AS	QuantityBySubProcess
				,MAX(QuantityTotal) - SUM(Quantity)	AS	QuantityDifference
				,QuantityTotal
		INTO	#TMP_QUANTITYDIFFERENCELAVANDERIA
		FROM	#TMP_QUANTITYLAVANDERIA
		GROUP BY	IdOrder, CodeOrder, IdProduct, QuantityTotal;

		UPDATE	QL	
		SET	QL.Quantity	=	QL.Quantity + QDL.QuantityDifference
		FROM	#TMP_QUANTITYDIFFERENCELAVANDERIA	QDL
		INNER JOIN	#TMP_QUANTITYLAVANDERIA	QL
			ON	QDL.MaxCodeSubOrder	=	QL.CodeSubOrder;

		SELECT	TQL.IdOrder
				,TQL.CodeOrder
				,TQL.IdSubOrderFlow
				,TQL.CodeSubOrder
				,TQL.Quantity
				,TQL.StatusSubOrderMT
				,TQL.StatusSubOrderName
				,TQL.DateSubOrder
				,TQL.DateEndSubOrder
				,TQL.IdProduct
				,TQL.Merma
				,TQL.IdOrderDetail
		FROM	#TMP_QUANTITYLAVANDERIA TQL;
	END;	
	ELSE
	BEGIN
		SELECT	DISTINCT	O.IdOrder
				,O.CodeOrder
				,SOF.IdSubOrderFlow
				,SOF.CodeSubOrder
				,CAST(OD.Quantity AS INT)  Quantity
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
	END;

	IF OBJECT_ID(N'tempdb..#TMP_QUANTITYLAVANDERIA') IS NOT NULL
	BEGIN
	DROP TABLE #TMP_QUANTITYLAVANDERIA
	END

	SELECT	SP.IdSuppliesByProduct
			,SP.IdProduct
			,SU.IdSupply
			,SU.[Name] AS 'NameSupply'
			,ISNULL(SF.[QuantityReturn],0) QuantityReturn
			,SF.[IdSubOrderFlowDetail]
			,SF.[IdSubOrderFlow]
	FROM		SuppliesByProduct SP 
	INNER JOIN	Supply	SU
	ON SP.IdSupply	=	SU.IdSupply
	INNER JOIN [SubOrderFlowDetail] SF
	ON SF.IdSupply		=	SU.IdSupply
	AND SF.IdProduct	=	SP.IdProduct
	AND SF.MTLocation	=	SP.MTLocation
	WHERE	SP.MTLocation =@ParamIIdLocation
			

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

	IF @ParamIIdLocation in (@CLocationLavanderia,@CLocationAcabado,@CLocationCostura)
	BEGIN
		SELECT	@IPendiente	=	COUNT(1)  
		FROM	SubOrderFlow SB
		INNER JOIN ProductSubProcess PS
		ON SB.IdProductSubProcess	=	PS.IdProductSubProcess	
		INNER JOIN	OrderFlow	[OFL]
		ON	SB.IdOrderFlow	=	[OFL].IdOrderFlow
		--AND	OFL.FlagInProcess	=	@CFlagTrue
		WHERE	PS.LocationOrder	=	@ParamIIdLocation
		AND		SB.StatusSubOrderMT			=	@MPendiente		
	END 
	ELSE
	BEGIN
		SELECT	@IPendiente	=	COUNT(1)  
		FROM	SubOrderFlow SB
		INNER JOIN ProductSubProcess PS
		ON SB.IdProductSubProcess	=	PS.IdProductSubProcess	
		INNER JOIN	OrderFlow	[OFL]
		ON	SB.IdOrderFlow	=	[OFL].IdOrderFlow
		AND	OFL.FlagInProcess	=	@CFlagTrue
		WHERE	PS.LocationOrder	=	@ParamIIdLocation
		AND		SB.StatusSubOrderMT			=	@MPendiente	
	END

	

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
						AND	SB.StatusSubOrderMT	!=	@CIdStatusCreateMT
						--AND	OFL.FlagInProcess	=	@CFlagTrue
						WHERE	PS.LocationOrder	=	@ParamIIdLocation	
					)
	WHERE IdMasterTable = 0
	
	SELECT * FROM #TMP_QUANTITY order by IdMasterTable asc
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_SuppliersByIdSupply]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_List_Supplies]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_List_SuppliesByProduct]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_List_Ubi]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Login]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_MasterTable_List]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Mrg_Customer]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Mrg_Order]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Mrg_OrderDetail]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_GanttOrdersLastMonth]    Script Date: 10/11/2021 2:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	Reporte del flujo que han seguido las órdenes de los últimos 30 días. 
--Change:		-
--Example:		[dbo].[Usp_Rpt_GanttOrdersLastMonth]
--================================================= 
CREATE PROC [dbo].[Usp_Rpt_GanttOrdersLastMonth]
AS
BEGIN	

	SELECT	O.CodeOrder
			,OFL.LocationOrder
			,MT.[Name]				AS	NameLocation
			,OFL.DateOrderFlow		AS	DateInitOrderFlow
			,OFL.DateEndOrderFlow
	FROM	[Order]	O
	INNER JOIN	OrderFlow	OFL
		ON	O.IdOrder	=	OFL.IdOrder
	INNER JOIN	MasterTable	MT
		ON	OFL.LocationOrder	=	MT.IdMasterTable
	WHERE	DateOrderFlow IS NOT NULL
		AND	DATEDIFF(DAY, DateOrderFlow, GETDATE())	<=	30
	ORDER BY OFL.IdOrder, OFL.NroOrder;

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListOrderQuantity]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListOrderQuantityStatus]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListOrderQuantityStatusDelivery]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListProductQuantity]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListSuppliesDecreasedByMonth]    Script Date: 10/11/2021 2:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	Cantidad de insumos desperdiciados por mes
--Change:		-
--Example:		[dbo].[Usp_Rpt_ListSuppliesDecreasedByMonth]
--================================================= 
CREATE PROC [dbo].[Usp_Rpt_ListSuppliesDecreasedByMonth]
AS
BEGIN	

	SELECT		RIGHT(YEAR(DateOrder),4)+'-'+RIGHT(CONCAT('00',CAST(MONTH(DateOrder)  AS VARCHAR(2))),2) 
															AS	DateGroup
				,S.[Name]									AS	SupplyName
				,SUM(SBP.Quantity * SOF.QuantityDecrease)	AS	QuantityDecrease
	FROM		[Order]	O
	INNER JOIN	OrderFlow	[OF]
		ON	O.IdOrder	=	[OF].IdOrder
	INNER JOIN	SubOrderFlow	SOF
		ON	[OF].IdOrderFlow	=	SOF.IdOrderFlow
	INNER JOIN	OrderDetail	OD
		ON	O.IdOrder	=	OD.IdOrder
	INNER JOIN	Product	P
		ON	OD.IdProduct	=	P.IdProduct
	INNER JOIN	SuppliesByProduct	SBP
		ON	P.IdProduct	=	SBP.IdProduct
	INNER JOIN	ProductSubProcess	PSP
		ON	SOF.IdProductSubProcess	=	PSP.IdProductSubProcess
		AND	SBP.MTLocation	=	PSP.LocationOrder
	INNER JOIN	Supply	S
		ON	SBP.IdSupply	=	S.IdSupply
	WHERE	SOF.QuantityDecrease	>	0
	GROUP BY	RIGHT(YEAR(DateOrder),4)+'-'+RIGHT(CONCAT('00',CAST(MONTH(DateOrder)  AS VARCHAR(2))),2)
				,S.[Name]
	ORDER BY	QuantityDecrease DESC

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Rpt_ListSuppliesMostUsedByMonth]    Script Date: 10/11/2021 2:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	Cantidad de insumos más pedidos por mes
--Change:		-
--Example:		[dbo].[Usp_Rpt_ListSuppliesMostUsedByMonth]
--================================================= 
CREATE PROC [dbo].[Usp_Rpt_ListSuppliesMostUsedByMonth]
AS
BEGIN	

	SELECT	RIGHT(YEAR(DateOrder),4)+'-'+RIGHT(CONCAT('00',CAST(MONTH(DateOrder)  AS VARCHAR(2))),2) 
												AS	DateGroup
			,S.[Name]							AS	SupplyName
			,SUM(SBP.Quantity * OD.Quantity)	AS	QuantityUsed
	FROM	[Order]	O
	INNER JOIN	OrderDetail	OD
		ON	O.IdOrder	=	OD.IdOrder
	INNER JOIN	Product	P
		ON	OD.IdProduct	=	P.IdProduct
	INNER JOIN	SuppliesByProduct	SBP
		ON	P.IdProduct	=	SBP.IdProduct
	INNER JOIN	Supply	S
		ON	SBP.IdSupply	=	S.IdSupply
	GROUP BY	RIGHT(YEAR(DateOrder),4)+'-'+RIGHT(CONCAT('00',CAST(MONTH(DateOrder)  AS VARCHAR(2))),2)
				,S.[Name]
	ORDER BY	QuantityUsed DESC

END


GO
/****** Object:  StoredProcedure [dbo].[Usp_Upd_Decrease]    Script Date: 10/11/2021 2:06:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Usp_Upd_OrderFlow]    Script Date: 10/11/2021 2:06:40 ******/
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
			,DateEndOrderFlow	=	GETDATE()
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
/****** Object:  StoredProcedure [dbo].[Usp_Upd_SubOrderFlow]    Script Date: 10/11/2021 2:06:40 ******/
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
	SET		StatusSubOrderMT	=	@ParamIStatus,
			DateEndSubOrder		= CASE WHEN @ParamIStatus =@CIdMTStatusComplete THEN SYSDATETIME() ELSE NULL END
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
/****** Object:  StoredProcedure [dbo].[Usp_Upd_SubOrderFlowDetail]    Script Date: 10/11/2021 2:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para actualizar la cantidad  en las SubOrderFlowDetail.
--Change:		-
--Example:		[dbo].[Usp_Upd_SubOrderFlowDetail]	
--================================================= 
CREATE PROC [dbo].[Usp_Upd_SubOrderFlowDetail]
	@ParamIIdSubOrderFlowDetail		UNIQUEIDENTIFIER
	,@ParamIQuantityReturn			NUMERIC(9,2)
AS
BEGIN

	UPDATE	SubOrderFlowDetail
	SET	QuantityReturn	=	@ParamIQuantityReturn
	WHERE	IdSubOrderFlowDetail=@ParamIIdSubOrderFlowDetail;		

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_ValidateStockByQuantityProduct]    Script Date: 10/11/2021 2:06:40 ******/
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
