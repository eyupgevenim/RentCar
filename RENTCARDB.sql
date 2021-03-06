USE [master]
GO
/****** Object:  Database [RENTCARDB]    Script Date: 30.07.2018 01:27:26 ******/
CREATE DATABASE [RENTCARDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RENTCARDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\RENTCARDB.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'RENTCARDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\RENTCARDB_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [RENTCARDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RENTCARDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RENTCARDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RENTCARDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RENTCARDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RENTCARDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RENTCARDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [RENTCARDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RENTCARDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RENTCARDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RENTCARDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RENTCARDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RENTCARDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RENTCARDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RENTCARDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RENTCARDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RENTCARDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RENTCARDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RENTCARDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RENTCARDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RENTCARDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RENTCARDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RENTCARDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RENTCARDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RENTCARDB] SET RECOVERY FULL 
GO
ALTER DATABASE [RENTCARDB] SET  MULTI_USER 
GO
ALTER DATABASE [RENTCARDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RENTCARDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RENTCARDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RENTCARDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [RENTCARDB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'RENTCARDB', N'ON'
GO
ALTER DATABASE [RENTCARDB] SET QUERY_STORE = OFF
GO
USE [RENTCARDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [RENTCARDB]
GO
/****** Object:  UserDefinedFunction [dbo].[BookingRemainingTime]    Script Date: 30.07.2018 01:27:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Araç id ye göre aracın kalan rezervasyon süresi(dk)>
-- =============================================
CREATE FUNCTION [dbo].[BookingRemainingTime] 
(
	@VahicleId int
)
RETURNS int
AS
BEGIN
	
	DECLARE 
		@result int=0
	   ,@EndDate datetime =''

	   SET @EndDate=(SELECT TOP 1 EndDate FROM BookingVehicles WHERE VehicleId=@VahicleId and EndDate > GETDATE() and IsCancel=0)
		IF ISNULL(@EndDate,'') IS NOT NULL
		BEGIN
			SET @result= DATEDIFF(MINUTE,GETDATE(), @EndDate)
		END

	RETURN @result

END
GO
/****** Object:  Table [dbo].[BookingVehicles]    Script Date: 30.07.2018 01:27:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingVehicles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VehicleId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Duration] [float] NOT NULL,
	[Price] [float] NOT NULL,
	[UserId] [int] NOT NULL,
	[IsCancel] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[StateId] [int] NOT NULL,
 CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](20) NOT NULL,
	[LastName] [varchar](20) NOT NULL,
	[Caption] [varchar](50) NOT NULL,
	[IdentityNumber] [varchar](11) NOT NULL,
	[Birthdate] [date] NOT NULL,
	[Gender] [int] NOT NULL,
	[TaxNumber] [varchar](10) NOT NULL,
	[TaxOffice] [varchar](100) NOT NULL,
	[Mobile] [varchar](10) NOT NULL,
	[HomePhone] [varchar](10) NULL,
	[OfficePhone] [varchar](10) NULL,
	[CityId] [int] NOT NULL,
	[Address] [varchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[States]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[States](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](20) NOT NULL,
	[FirstName] [varchar](20) NOT NULL,
	[LastName] [varchar](20) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Salt] [varchar](50) NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleBrands]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleBrands](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_VehicleBrands] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleModels]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleModels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[VehicleBrandId] [int] NOT NULL,
 CONSTRAINT [PK_VehicleModels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vehicles]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ModelYear] [int] NOT NULL,
	[Plate] [varchar](10) NOT NULL,
	[ChassisNo] [varchar](17) NOT NULL,
	[Color] [int] NOT NULL,
	[VehicleModelId] [int] NOT NULL,
	[VehicleTypeId] [int] NOT NULL,
	[CurrencyValue] [float] NOT NULL,
	[Currency] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Vehicles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleTypes]    Script Date: 30.07.2018 01:27:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_VehicleTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BookingVehicles] ON 

INSERT [dbo].[BookingVehicles] ([Id], [VehicleId], [CustomerId], [StartDate], [EndDate], [Duration], [Price], [UserId], [IsCancel]) VALUES (1, 1, 2, CAST(N'2018-07-29T10:20:00.000' AS DateTime), CAST(N'2018-08-01T12:00:00.000' AS DateTime), 3.0694444444444446, 245.55555555555557, 1, 0)
SET IDENTITY_INSERT [dbo].[BookingVehicles] OFF
SET IDENTITY_INSERT [dbo].[Cities] ON 

INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (1, N'SEYHAN', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (2, N'CEYHAN', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (3, N'FEKE', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (4, N'KARAİSALI', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (5, N'KARATAŞ', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (6, N'KOZAN', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (7, N'POZANTI', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (8, N'SAİMBEYLİ', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (9, N'TUFANBEYLİ', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (10, N'YUMURTALIK', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (11, N'YÜREĞİR', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (12, N'ALADAĞ', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (13, N'İMAMOĞLU', 1)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (14, N'ADIYAMAN MERKEZ', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (15, N'BESNİ', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (16, N'ÇELİKHAN', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (17, N'GERGER', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (18, N'GÖLBAŞI', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (19, N'KAHTA', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (20, N'SAMSAT', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (21, N'SİNCİK', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (22, N'TUT', 2)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (23, N'AFYONMERKEZ', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (24, N'BOLVADİN', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (25, N'ÇAY', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (26, N'DAZKIRI', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (27, N'DİNAR', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (28, N'EMİRDAĞ', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (29, N'İHSANİYE', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (30, N'SANDIKLI', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (31, N'SİNANPAŞA', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (32, N'SULDANDAĞI', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (33, N'ŞUHUT', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (34, N'BAŞMAKÇI', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (35, N'BAYAT', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (36, N'İŞCEHİSAR', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (37, N'ÇOBANLAR', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (38, N'EVCİLER', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (39, N'HOCALAR', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (40, N'KIZILÖREN', 3)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (41, N'AKSARAY MERKEZ', 68)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (42, N'ORTAKÖY', 68)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (43, N'AĞAÇÖREN', 68)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (44, N'GÜZELYURT', 68)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (45, N'SARIYAHŞİ', 68)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (46, N'ESKİL', 68)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (47, N'GÜLAĞAÇ', 68)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (48, N'AMASYA MERKEZ', 5)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (49, N'GÖYNÜÇEK', 5)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (50, N'GÜMÜŞHACIKÖYÜ', 5)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (51, N'MERZİFON', 5)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (52, N'SULUOVA', 5)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (53, N'TAŞOVA', 5)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (54, N'HAMAMÖZÜ', 5)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (55, N'ALTINDAĞ', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (56, N'AYAS', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (57, N'BALA', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (58, N'BEYPAZARI', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (59, N'ÇAMLIDERE', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (60, N'ÇANKAYA', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (61, N'ÇUBUK', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (62, N'ELMADAĞ', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (63, N'GÜDÜL', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (64, N'HAYMANA', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (65, N'KALECİK', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (66, N'KIZILCAHAMAM', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (67, N'NALLIHAN', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (68, N'POLATLI', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (69, N'ŞEREFLİKOÇHİSAR', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (70, N'YENİMAHALLE', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (71, N'GÖLBAŞI', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (72, N'KEÇİÖREN', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (73, N'MAMAK', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (74, N'SİNCAN', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (75, N'KAZAN', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (76, N'AKYURT', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (77, N'ETİMESGUT', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (78, N'EVREN', 6)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (79, N'ANSEKİ', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (80, N'ALANYA', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (81, N'ANTALYA MERKEZİ', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (82, N'ELMALI', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (83, N'FİNİKE', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (84, N'GAZİPAŞA', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (85, N'GÜNDOĞMUŞ', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (86, N'KAŞ', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (87, N'KORKUTELİ', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (88, N'KUMLUCA', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (89, N'MANAVGAT', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (90, N'SERİK', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (91, N'DEMRE', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (92, N'İBRADI', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (93, N'KEMER', 7)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (94, N'ARDAHAN MERKEZ', 75)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (95, N'GÖLE', 75)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (96, N'ÇILDIR', 75)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (97, N'HANAK', 75)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (98, N'POSOF', 75)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (99, N'DAMAL', 75)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (100, N'ARDANUÇ', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (101, N'ARHAVİ', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (102, N'ARTVİN MERKEZ', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (103, N'BORÇKA', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (104, N'HOPA', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (105, N'ŞAVŞAT', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (106, N'YUSUFELİ', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (107, N'MURGUL', 8)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (108, N'AYDIN MERKEZ', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (109, N'BOZDOĞAN', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (110, N'ÇİNE', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (111, N'GERMENCİK', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (112, N'KARACASU', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (113, N'KOÇARLI', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (114, N'KUŞADASI', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (115, N'KUYUCAK', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (116, N'NAZİLLİ', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (117, N'SÖKE', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (118, N'SULTANHİSAR', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (119, N'YENİPAZAR', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (120, N'BUHARKENT', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (121, N'İNCİRLİOVA', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (122, N'KARPUZLU', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (123, N'KÖŞK', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (124, N'DİDİM', 9)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (125, N'AĞRI MERKEZ', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (126, N'DİYADİN', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (127, N'DOĞUBEYAZIT', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (128, N'ELEŞKİRT', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (129, N'HAMUR', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (130, N'PATNOS', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (131, N'TAŞLIÇAY', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (132, N'TUTAK', 4)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (133, N'AYVALIK', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (134, N'BALIKESİR MERKEZ', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (135, N'BALYA', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (136, N'BANDIRMA', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (137, N'BİGADİÇ', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (138, N'BURHANİYE', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (139, N'DURSUNBEY', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (140, N'EDREMİT', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (141, N'ERDEK', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (142, N'GÖNEN', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (143, N'HAVRAN', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (144, N'İVRİNDİ', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (145, N'KEPSUT', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (146, N'MANYAS', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (147, N'SAVAŞTEPE', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (148, N'SINDIRGI', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (149, N'SUSURLUK', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (150, N'MARMARA', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (151, N'GÖMEÇ', 10)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (152, N'BARTIN MERKEZ', 74)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (153, N'KURUCAŞİLE', 74)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (154, N'ULUS', 74)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (155, N'AMASRA', 74)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (156, N'BATMAN MERKEZ', 72)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (157, N'BEŞİRİ', 72)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (158, N'GERCÜŞ', 72)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (159, N'KOZLUK', 72)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (160, N'SASON', 72)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (161, N'HASANKEYF', 72)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (162, N'BAYBURT MERKEZ', 69)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (163, N'AYDINTEPE', 69)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (164, N'DEMİRÖZÜ', 69)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (165, N'BOLU MERKEZ', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (166, N'GEREDE', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (167, N'GÖYNÜK', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (168, N'KIBRISCIK', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (169, N'MENGEN', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (170, N'MUDURNU', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (171, N'SEBEN', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (172, N'DÖRTDİVAN', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (173, N'YENİÇAĞA', 14)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (174, N'AĞLASUN', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (175, N'BUCAK', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (176, N'BURDUR MERKEZ', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (177, N'GÖLHİSAR', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (178, N'TEFENNİ', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (179, N'YEŞİLOVA', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (180, N'KARAMANLI', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (181, N'KEMER', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (182, N'ALTINYAYLA', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (183, N'ÇAVDIR', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (184, N'ÇELTİKÇİ', 15)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (185, N'GEMLİK', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (186, N'İNEGÖL', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (187, N'İZNİK', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (188, N'KARACABEY', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (189, N'KELES', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (190, N'MUDANYA', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (191, N'MUSTAFA K. PAŞA', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (192, N'ORHANELİ', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (193, N'ORHANGAZİ', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (194, N'YENİŞEHİR', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (195, N'BÜYÜK ORHAN', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (196, N'HARMANCIK', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (197, N'NÜLİFER', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (198, N'OSMAN GAZİ', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (199, N'YILDIRIM', 16)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (200, N'GÜRSU', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (201, N'KESTEL', 16)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (202, N'BİLECİK MERKEZ', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (203, N'BOZÜYÜK', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (204, N'GÖLPAZARI', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (205, N'OSMANELİ', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (206, N'PAZARYERİ', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (207, N'SÖĞÜT', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (208, N'YENİPAZAR', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (209, N'İNHİSAR', 11)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (210, N'BİNGÖL MERKEZ', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (211, N'GENÇ', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (212, N'KARLIOVA', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (213, N'KİGI', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (214, N'SOLHAN', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (215, N'ADAKLI', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (216, N'YAYLADERE', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (217, N'YEDİSU', 12)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (218, N'ADNameVAZ', 13)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (219, N'AHLAT', 13)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (220, N'BİTLİS MERKEZ', 13)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (221, N'HİZAN', 13)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (222, N'MUTKİ', 13)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (223, N'TATVAN', 13)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (224, N'GÜROYMAK', 13)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (225, N'DENİZLİ MERKEZ', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (226, N'ACIPAYAM', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (227, N'BULDAN', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (228, N'ÇAL', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (229, N'ÇAMELİ', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (230, N'ÇARDAK', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (231, N'ÇİVRİL', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (232, N'GÜNEY', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (233, N'KALE', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (234, N'SARAYKÖY', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (235, N'TAVAS', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (236, N'BABADAĞ', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (237, N'BEKİLLİ', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (238, N'HONAZ', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (239, N'SERİNHİSAR', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (240, N'AKKÖY', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (241, N'BAKLAN', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (242, N'BEYAĞAÇ', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (243, N'BOZKURT', 20)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (244, N'DÜZCE MERKEZ', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (245, N'AKÇAKOCA', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (246, N'YIĞILCA', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (247, N'CUMAYERİ', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (248, N'GÖLYAKA', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (249, N'ÇİLİMLİ', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (250, N'GÜMÜŞOVA', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (251, N'KAYNAŞLI', 81)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (252, N'DİYARBAKIR MERKEZ', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (253, N'BİSMİL', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (254, N'ÇERMİK', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (255, N'ÇINAR', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (256, N'ÇÜNGÜŞ', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (257, N'DİCLE', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (258, N'ERGANİ', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (259, N'HANİ', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (260, N'HAZRO', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (261, N'KULP', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (262, N'LİCE', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (263, N'SİLVAN', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (264, N'EĞİL', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (265, N'KOCAKÖY', 21)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (266, N'EDİRNE MERKEZ', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (267, N'ENEZ', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (268, N'HAVSA', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (269, N'İPSALA', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (270, N'KEŞAN', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (271, N'LALAPAŞA', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (272, N'MERİÇ', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (273, N'UZUNKÖPRÜ', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (274, N'SÜLOĞLU', 22)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (275, N'ELAZIĞ MERKEZ', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (276, N'AĞIN', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (277, N'BASKİL', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (278, N'KARAKOÇAN', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (279, N'KEBAN', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (280, N'MADEN', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (281, N'PALU', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (282, N'SİVRİCE', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (283, N'ARICAK', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (284, N'KOVANCILAR', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (285, N'ALACAKAYA', 23)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (286, N'ERZURUM MERKEZ', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (287, N'PALANDÖKEN', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (288, N'AŞKALE', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (289, N'ÇAT', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (290, N'HINIS', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (291, N'HORASAN', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (292, N'OLTU', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (293, N'İSPİR', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (294, N'KARAYAZI', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (295, N'NARMAN', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (296, N'OLUR', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (297, N'PASİNLER', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (298, N'ŞENKAYA', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (299, N'TEKMAN', 25)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (300, N'TORTUM', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (301, N'KARAÇOBAN', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (302, N'UZUNDERE', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (303, N'PAZARYOLU', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (304, N'ILICA', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (305, N'KÖPRÜKÖY', 25)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (306, N'ÇAYIRLI', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (307, N'ERZİNCAN MERKEZ', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (308, N'İLİÇ', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (309, N'KEMAH', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (310, N'KEMALİYE', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (311, N'REFAHİYE', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (312, N'TERCAN', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (313, N'OTLUKBELİ', 24)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (314, N'ESKİŞEHİR MERKEZ', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (315, N'ÇİFTELER', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (316, N'MAHMUDİYE', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (317, N'MİHALIÇLIK', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (318, N'SARICAKAYA', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (319, N'SEYİTGAZİ', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (320, N'SİVRİHİSAR', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (321, N'ALPU', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (322, N'BEYLİKOVA', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (323, N'İNÖNÜ', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (324, N'GÜNYÜZÜ', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (325, N'HAN', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (326, N'MİHALGAZİ', 26)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (327, N'ARABAN', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (328, N'İSLAHİYE', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (329, N'NİZİP', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (330, N'OĞUZELİ', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (331, N'YAVUZELİ', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (332, N'ŞAHİNBEY', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (333, N'ŞEHİT KAMİL', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (334, N'KARKAMIŞ', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (335, N'NURDAĞI', 27)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (336, N'GÜMÜŞHANE MERKEZ', 29)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (337, N'KELKİT', 29)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (338, N'ŞİRAN', 29)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (339, N'TORUL', 29)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (340, N'KÖSE', 29)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (341, N'KÜRTÜN', 29)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (342, N'ALUCRA', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (343, N'BULANCAK', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (344, N'DERELİ', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (345, N'ESPİYE', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (346, N'EYNESİL', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (347, N'GİRESUN MERKEZ', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (348, N'GÖRELE', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (349, N'KEŞAP', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (350, N'ŞEBİNKARAHİSAR', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (351, N'TİREBOLU', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (352, N'PİPAZİZ', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (353, N'YAĞLIDERE', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (354, N'ÇAMOLUK', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (355, N'ÇANAKÇI', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (356, N'DOĞANKENT', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (357, N'GÜCE', 28)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (358, N'HAKKARİ MERKEZ', 30)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (359, N'ÇUKURCA', 30)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (360, N'ŞEMDİNLİ', 30)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (361, N'YÜKSEKOVA', 30)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (362, N'ALTINÖZÜ', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (363, N'DÖRTYOL', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (364, N'HATAY MERKEZ', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (365, N'HASSA', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (366, N'İSKENDERUN', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (367, N'KIRIKHAN', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (368, N'REYHANLI', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (369, N'SAMANDAĞ', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (370, N'YAYLADAĞ', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (371, N'ERZİN', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (372, N'BELEN', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (373, N'KUMLU', 31)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (374, N'ISPARTA MERKEZ', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (375, N'ATABEY', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (376, N'KEÇİBORLU', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (377, N'EĞİRDİR', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (378, N'GELENDOST', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (379, N'SİNİRKENT', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (380, N'ULUBORLU', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (381, N'YALVAÇ', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (382, N'AKSU', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (383, N'GÖNEN', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (384, N'YENİŞAR BADEMLİ', 32)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (385, N'IĞDIR MERKEZ', 76)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (386, N'ARALIK', 76)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (387, N'TUZLUCA', 76)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (388, N'KARAKOYUNLU', 76)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (389, N'AFŞİN', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (390, N'ANDIRIN', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (391, N'ELBİSTAN', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (392, N'GÖKSUN', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (393, N'KAHRAMANMARAŞ MERKEZ', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (394, N'PAZARCIK', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (395, N'TÜRKOĞLU', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (396, N'ÇAĞLAYANCERİT', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (397, N'EKİNÖZÜ', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (398, N'NURHAK', 46)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (399, N'EFLANİ', 78)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (400, N'ESKİPAZAR', 78)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (401, N'KARABÜK MERKEZ', 78)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (402, N'OVACIK', 78)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (403, N'SAFRANBOLU', 78)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (404, N'YENİCE', 78)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (405, N'ERMENEK', 70)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (406, N'KARAMAN MERKEZ', 70)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (407, N'AYRANCI', 70)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (408, N'KAZIMKARABEKİR', 70)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (409, N'BAŞYAYLA', 70)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (410, N'SARIVELİLER', 70)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (411, N'KARS MERKEZ', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (412, N'ARPAÇAY', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (413, N'DİGOR', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (414, N'KAĞIZMAN', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (415, N'SARIKAMIŞ', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (416, N'SELİM', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (417, N'SUSUZ', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (418, N'AKYAKA', 36)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (419, N'ABANA', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (420, N'KASTAMONU MERKEZ', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (421, N'ARAÇ', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (422, N'AZDAVAY', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (423, N'BOZKURT', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (424, N'CİDE', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (425, N'ÇATALZEYTİN', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (426, N'DADAY', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (427, N'DEVREKANİ', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (428, N'İNEBOLU', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (429, N'KÜRE', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (430, N'TAŞKÖPRÜ', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (431, N'TOSYA', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (432, N'İHSANGAZİ', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (433, N'PINARBAŞI', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (434, N'ŞENPAZAR', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (435, N'AĞLI', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (436, N'DOĞANYURT', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (437, N'HANÖNÜ', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (438, N'SEYDİLER', 37)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (439, N'BÜNYAN', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (440, N'DEVELİ', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (441, N'FELAHİYE', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (442, N'İNCESU', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (443, N'PINARBAŞI', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (444, N'SARIOĞLAN', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (445, N'SARIZ', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (446, N'TOMARZA', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (447, N'YAHYALI', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (448, N'YEŞİLHİSAR', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (449, N'AKKIŞLA', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (450, N'TALAS', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (451, N'KOCASİNAN', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (452, N'MELİKGAZİ', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (453, N'HACILAR', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (454, N'ÖZVATAN', 38)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (455, N'DERİCE', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (456, N'KESKİN', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (457, N'KIRIKKALE MERKEZ', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (458, N'SALAK YURT', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (459, N'BAHŞİLİ', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (460, N'BALIŞEYH', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (461, N'ÇELEBİ', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (462, N'KARAKEÇİLİ', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (463, N'YAHŞİHAN', 71)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (464, N'KIRKKLARELİ MERKEZ', 39)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (465, N'BABAESKİ', 39)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (466, N'DEMİRKÖY', 39)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (467, N'KOFÇAY', 39)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (468, N'LÜLEBURGAZ', 39)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (469, N'VİZE', 39)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (470, N'KIRŞEHİR MERKEZ', 40)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (471, N'ÇİÇEKDAĞI', 40)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (472, N'KAMAN', 40)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (473, N'MUCUR', 40)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (474, N'AKPINAR', 40)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (475, N'AKÇAKENT', 40)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (476, N'BOZTEPE', 40)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (477, N'KOCAELİ MERKEZ', 41)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (478, N'GEBZE', 41)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (479, N'GÖLCÜK', 41)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (480, N'KANDIRA', 41)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (481, N'KARAMÜRSEL', 41)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (482, N'KÖRFEZ', 41)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (483, N'DERİNCE', 41)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (484, N'KONYA MERKEZ', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (485, N'AKŞEHİR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (486, N'BEYŞEHİR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (487, N'BOZKIR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (488, N'CİHANBEYLİ', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (489, N'ÇUMRA', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (490, N'DOĞANHİSAR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (491, N'EREĞLİ', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (492, N'HADİM', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (493, N'ILGIN', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (494, N'KADINHANI', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (495, N'KARAPINAR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (496, N'KULU', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (497, N'SARAYÖNÜ', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (498, N'SEYDİŞEHİR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (499, N'YUNAK', 42)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (500, N'AKÖREN', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (501, N'ALTINEKİN', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (502, N'DEREBUCAK', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (503, N'HÜYÜK', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (504, N'KARATAY', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (505, N'MERAM', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (506, N'SELÇUKLU', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (507, N'TAŞKENT', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (508, N'AHIRLI', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (509, N'ÇELTİK', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (510, N'DERBENT', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (511, N'EMİRGAZİ', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (512, N'GÜNEYSINIR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (513, N'HALKAPINAR', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (514, N'TUZLUKÇU', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (515, N'YALIHÜYÜK', 42)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (516, N'KÜTAHYA  MERKEZ', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (517, N'ALTINTAŞ', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (518, N'DOMANİÇ', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (519, N'EMET', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (520, N'GEDİZ', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (521, N'SİMAV', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (522, N'TAVŞANLI', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (523, N'ASLANAPA', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (524, N'DUMLUPINAR', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (525, N'HİSARCIK', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (526, N'ŞAPHANE', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (527, N'ÇAVDARHİSAR', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (528, N'PAZARLAR', 43)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (529, N'KİLİS MERKEZ', 79)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (530, N'ELBEYLİ', 79)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (531, N'MUSABEYLİ', 79)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (532, N'POLATELİ', 79)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (533, N'MALATYA MERKEZ', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (534, N'AKÇADAĞ', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (535, N'ARAPGİR', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (536, N'ARGUVAN', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (537, N'DARENDE', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (538, N'DOĞANŞEHİR', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (539, N'HEKİMHAN', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (540, N'PÜTÜRGE', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (541, N'YEŞİLYURT', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (542, N'BATTALGAZİ', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (543, N'DOĞANYOL', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (544, N'KALE', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (545, N'KULUNCAK', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (546, N'YAZIHAN', 44)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (547, N'AKHİSAR', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (548, N'ALAŞEHİR', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (549, N'DEMİRCİ', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (550, N'GÖRDES', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (551, N'KIRKAĞAÇ', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (552, N'KULA', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (553, N'MANİSA MERKEZ', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (554, N'SALİHLİ', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (555, N'SARIGÖL', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (556, N'SARUHANLI', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (557, N'SELENDİ', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (558, N'SOMA', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (559, N'TURGUTLU', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (560, N'AHMETLİ', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (561, N'GÖLMARMARA', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (562, N'KÖPRÜBAŞI', 45)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (563, N'DERİK', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (564, N'KIZILTEPE', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (565, N'MARDİN MERKEZ', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (566, N'MAZIDAĞI', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (567, N'MİDYAT', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (568, N'NUSAYBİN', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (569, N'ÖMERLİ', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (570, N'SAVUR', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (571, N'YEŞİLLİ', 47)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (572, N'MERSİN MERKEZ', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (573, N'ANAMUR', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (574, N'ERDEMLİ', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (575, N'GÜLNAR', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (576, N'MUT', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (577, N'SİLİFKE', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (578, N'TARSUS', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (579, N'AYDINCIK', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (580, N'BOZYAZI', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (581, N'ÇAMLIYAYLA', 33)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (582, N'BODRUM', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (583, N'DATÇA', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (584, N'FETHİYE', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (585, N'KÖYCEĞİZ', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (586, N'MARMARİS', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (587, N'MİLAS', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (588, N'MUĞLA MERKEZ', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (589, N'ULA', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (590, N'YATAĞAN', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (591, N'DALAMAN', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (592, N'KAVAKLI DERE', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (593, N'ORTACA', 48)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (594, N'BULANIK', 49)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (595, N'MALAZGİRT', 49)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (596, N'MUŞ MERKEZ', 49)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (597, N'VARTO', 49)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (598, N'HASKÖY', 49)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (599, N'KORKUT', 49)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (600, N'NEVŞEHİR MERKEZ', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (601, N'AVANOS', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (602, N'DERİNKUYU', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (603, N'GÜLŞEHİR', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (604, N'HACIBEKTAŞ', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (605, N'KOZAKLI', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (606, N'ÜRGÜP', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (607, N'ACIGÖL', 50)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (608, N'NİĞDE MERKEZ', 51)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (609, N'BOR', 51)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (610, N'ÇAMARDI', 51)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (611, N'ULUKIŞLA', 51)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (612, N'ALTUNHİSAR', 51)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (613, N'ÇİFTLİK', 51)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (614, N'AKKUŞ', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (615, N'AYBASTI', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (616, N'FATSA', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (617, N'GÖLKÖY', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (618, N'KORGAN', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (619, N'KUMRU', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (620, N'MESUDİYE', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (621, N'ORDU MERKEZ', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (622, N'PERŞEMBE', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (623, N'ULUBEY', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (624, N'ÜNYE', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (625, N'GÜLYALI', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (626, N'GÜRGENTEPE', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (627, N'ÇAMAŞ', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (628, N'ÇATALPINAR', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (629, N'ÇAYBAŞI', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (630, N'İKİZCE', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (631, N'KABADÜZ', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (632, N'KABATAŞ', 52)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (633, N'BAHÇE', 80)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (634, N'KADİRLİ', 80)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (635, N'OSMANİYE MERKEZ', 80)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (636, N'DÜZİÇİ', 80)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (637, N'HASANBEYLİ', 80)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (638, N'SUMBAŞ', 80)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (639, N'TOPRAKKALE', 80)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (640, N'RİZE MERKEZ', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (641, N'ARDEŞEN', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (642, N'ÇAMLIHEMŞİN', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (643, N'ÇAYELİ', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (644, N'FINDIKLI', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (645, N'İKİZDERE', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (646, N'KALKANDERE', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (647, N'PAZAR', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (648, N'GÜNEYSU', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (649, N'DEREPAZARI', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (650, N'HEMŞİN', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (651, N'İYİDERE', 53)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (652, N'AKYAZI', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (653, N'GEYVE', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (654, N'HENDEK', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (655, N'KARASU', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (656, N'KAYNARCA', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (657, N'SAKARYA MERKEZ', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (658, N'PAMUKOVA', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (659, N'TARAKLI', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (660, N'FERİZLİ', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (661, N'KARAPÜRÇEK', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (662, N'SÖĞÜTLÜ', 54)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (663, N'ALAÇAM', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (664, N'BAFRA', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (665, N'ÇARŞAMBA', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (666, N'HAVZA', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (667, N'KAVAK', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (668, N'LADİK', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (669, N'SAMSUN MERKEZ', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (670, N'TERME', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (671, N'VEZİRKÖPRÜ', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (672, N'ASARCIK', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (673, N'ONDOKUZMAYIS', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (674, N'SALIPAZARI', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (675, N'TEKKEKÖY', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (676, N'AYVACIK', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (677, N'YAKAKENT', 55)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (678, N'AYANCIK', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (679, N'BOYABAT', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (680, N'SİNOP MERKEZ', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (681, N'DURAĞAN', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (682, N'ERGELEK', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (683, N'GERZE', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (684, N'TÜRKELİ', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (685, N'DİKMEN', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (686, N'SARAYDÜZÜ', 57)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (687, N'DİVRİĞİ', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (688, N'GEMEREK', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (689, N'GÜRÜN', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (690, N'HAFİK', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (691, N'İMRANLI', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (692, N'KANGAL', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (693, N'KOYUL HİSAR', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (694, N'SİVAS MERKEZ', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (695, N'SU ŞEHRİ', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (696, N'ŞARKIŞLA', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (697, N'YILDIZELİ', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (698, N'ZARA', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (699, N'AKINCILAR', 58)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (700, N'ALTINYAYLA', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (701, N'DOĞANŞAR', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (702, N'GÜLOVA', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (703, N'ULAŞ', 58)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (704, N'BAYKAN', 56)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (705, N'ERUH', 56)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (706, N'KURTALAN', 56)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (707, N'PERVARİ', 56)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (708, N'SİİRT MERKEZ', 56)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (709, N'ŞİRVARİ', 56)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (710, N'AYDINLAR', 56)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (711, N'TEKİRDAĞ MERKEZ', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (712, N'ÇERKEZKÖY', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (713, N'ÇORLU', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (714, N'HAYRABOLU', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (715, N'MALKARA', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (716, N'MURATLI', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (717, N'SARAY', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (718, N'ŞARKÖY', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (719, N'MARAMARAEREĞLİSİ', 59)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (720, N'ALMUS', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (721, N'ARTOVA', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (722, N'TOKAT MERKEZ', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (723, N'ERBAA', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (724, N'NİKSAR', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (725, N'REŞADİYE', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (726, N'TURHAL', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (727, N'ZİLE', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (728, N'PAZAR', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (729, N'YEŞİLYURT', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (730, N'BAŞÇİFTLİK', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (731, N'SULUSARAY', 60)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (732, N'TRABZON MERKEZ', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (733, N'AKÇAABAT', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (734, N'ARAKLI', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (735, N'ARŞİN', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (736, N'ÇAYKARA', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (737, N'MAÇKA', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (738, N'OF', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (739, N'SÜRMENE', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (740, N'TONYA', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (741, N'VAKFIKEBİR', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (742, N'YOMRA', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (743, N'BEŞİKDÜZÜ', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (744, N'ŞALPAZARI', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (745, N'ÇARŞIBAŞI', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (746, N'DERNEKPAZARI', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (747, N'DÜZKÖY', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (748, N'HAYRAT', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (749, N'KÖPRÜBAŞI', 61)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (750, N'TUNCELİ MERKEZ', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (751, N'ÇEMİŞGEZEK', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (752, N'HOZAT', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (753, N'MAZGİRT', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (754, N'NAZİMİYE', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (755, N'OVACIK', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (756, N'PERTEK', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (757, N'PÜLÜMÜR', 62)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (758, N'BANAZ', 64)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (759, N'EŞME', 64)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (760, N'KARAHALLI', 64)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (761, N'SİVASLI', 64)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (762, N'ULUBEY', 64)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (763, N'UŞAK MERKEZ', 64)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (764, N'BAŞKALE', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (765, N'VAN MERKEZ', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (766, N'EDREMİT', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (767, N'ÇATAK', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (768, N'ERCİŞ', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (769, N'GEVAŞ', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (770, N'GÜRPINAR', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (771, N'MURADİYE', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (772, N'ÖZALP', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (773, N'BAHÇESARAY', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (774, N'ÇALDIRAN', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (775, N'SARAY', 65)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (776, N'YALOVA MERKEZ', 77)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (777, N'ALTINOVA', 77)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (778, N'ARMUTLU', 77)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (779, N'ÇINARCIK', 77)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (780, N'ÇİFTLİKKÖY', 77)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (781, N'TERMAL', 77)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (782, N'AKDAĞMADENİ', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (783, N'BOĞAZLIYAN', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (784, N'YOZGAT MERKEZ', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (785, N'ÇAYIRALAN', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (786, N'ÇEKEREK', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (787, N'SARIKAYA', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (788, N'SORGUN', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (789, N'ŞEFAATLI', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (790, N'YERKÖY', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (791, N'KADIŞEHRİ', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (792, N'SARAYKENT', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (793, N'YENİFAKILI', 66)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (794, N'ÇAYCUMA', 67)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (795, N'DEVREK', 67)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (796, N'ZONGULDAK MERKEZ', 67)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (797, N'EREĞLİ', 67)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (798, N'ALAPLI', 67)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (799, N'GÖKÇEBEY', 67)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (800, N'ÇANAKKALE MERKEZ', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (801, N'AYVACIK', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (802, N'BAYRAMİÇ', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (803, N'BİGA', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (804, N'BOZCAADA', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (805, N'ÇAN', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (806, N'ECEABAT', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (807, N'EZİNE', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (808, N'LAPSEKİ', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (809, N'YENİCE', 17)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (810, N'ÇANKIRI MERKEZ', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (811, N'ÇERKEŞ', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (812, N'ELDİVAN', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (813, N'ILGAZ', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (814, N'KURŞUNLU', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (815, N'ORTA', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (816, N'ŞABANÖZÜ', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (817, N'YAPRAKLI', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (818, N'ATKARACALAR', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (819, N'KIZILIRMAK', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (820, N'BAYRAMÖREN', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (821, N'KORGUN', 18)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (822, N'ALACA', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (823, N'BAYAT', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (824, N'ÇORUM MERKEZ', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (825, N'İKSİPLİ', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (826, N'KARGI', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (827, N'MECİTÖZÜ', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (828, N'ORTAKÖY', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (829, N'OSMANCIK', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (830, N'SUNGURLU', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (831, N'DODURGA', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (832, N'LAÇİN', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (833, N'OĞUZLAR', 19)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (834, N'ADALAR', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (835, N'BAKIRKÖY', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (836, N'BEŞİKTAŞ', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (837, N'BEYKOZ', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (838, N'BEYOĞLU', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (839, N'ÇATALCA', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (840, N'EMİNÖNÜ', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (841, N'EYÜP', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (842, N'FATİH', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (843, N'GAZİOSMANPAŞA', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (844, N'KADIKÖY', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (845, N'KARTAL', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (846, N'SARIYER', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (847, N'SİLİVRİ', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (848, N'ŞİLE', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (849, N'ŞİŞLİ', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (850, N'ÜSKÜDAR', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (851, N'ZEYTİNBURNU', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (852, N'BÜYÜKÇEKMECE', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (853, N'KAĞITHANE', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (854, N'KÜÇÜKÇEKMECE', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (855, N'PENDİK', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (856, N'ÜMRANİYE', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (857, N'BAYRAMPAŞA', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (858, N'AVCILAR', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (859, N'BAĞCILAR', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (860, N'BAHÇELİEVLER', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (861, N'GÜNGÖREN', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (862, N'MALTEPE', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (863, N'SULTANBEYLİ', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (864, N'TUZLA', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (865, N'ESENLER', 34)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (866, N'ALİAĞA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (867, N'BAYINDIR', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (868, N'BERGAMA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (869, N'BORNOVA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (870, N'ÇEŞME', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (871, N'DİKİLİ', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (872, N'FOÇA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (873, N'KARABURUN', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (874, N'KARŞIYAKA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (875, N'KEMALPAŞA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (876, N'KINIK', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (877, N'KİRAZ', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (878, N'MENEMEN', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (879, N'ÖDEMİŞ', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (880, N'SEFERİHİSAR', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (881, N'SELÇUK', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (882, N'TİRE', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (883, N'TORBALI', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (884, N'URLA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (885, N'BEYDAĞ', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (886, N'BUCA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (887, N'KONAK', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (888, N'MENDERES', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (889, N'BALÇOVA', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (890, N'ÇİGLİ', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (891, N'GAZİEMİR', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (892, N'NARLIDERE', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (893, N'GÜZELBAHÇE', 35)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (894, N'ŞANLIURFA MERKEZ', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (895, N'AKÇAKALE', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (896, N'BİRECİK', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (897, N'BOZOVA', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (898, N'CEYLANPINAR', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (899, N'HALFETİ', 63)
GO
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (900, N'HİLVAN', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (901, N'SİVEREK', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (902, N'SURUÇ', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (903, N'VİRANŞEHİR', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (904, N'HARRAN', 63)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (905, N'BEYTÜŞŞEBAP', 73)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (906, N'ŞIRNAK MERKEZ', 73)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (907, N'CİZRE', 73)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (908, N'İDİL', 73)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (909, N'SİLOPİ', 73)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (910, N'ULUDERE', 73)
INSERT [dbo].[Cities] ([Id], [Name], [StateId]) VALUES (911, N'GÜÇLÜKONAK', 73)
SET IDENTITY_INSERT [dbo].[Cities] OFF
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [Caption], [IdentityNumber], [Birthdate], [Gender], [TaxNumber], [TaxOffice], [Mobile], [HomePhone], [OfficePhone], [CityId], [Address], [IsActive]) VALUES (1, N'Test Müşteri', N'Test Soyad', N'Unvan', N'12345678910', CAST(N'1990-01-01' AS Date), 1, N'9874563210', N'Test Vergi Dairesi', N'5554443322', N'1112223344', NULL, 14, N'Test adres', 0)
INSERT [dbo].[Customers] ([Id], [FirstName], [LastName], [Caption], [IdentityNumber], [Birthdate], [Gender], [TaxNumber], [TaxOffice], [Mobile], [HomePhone], [OfficePhone], [CityId], [Address], [IsActive]) VALUES (2, N'Test Müşteri', N'Test Soyad', N'Mühendis', N'12345678910', CAST(N'1990-01-01' AS Date), 1, N'9874563210', N'Test Vergi Dairesi', N'5554443322', N'1112223344', NULL, 14, N'Test adres', 1)
SET IDENTITY_INSERT [dbo].[Customers] OFF
SET IDENTITY_INSERT [dbo].[States] ON 

INSERT [dbo].[States] ([Id], [Name]) VALUES (1, N'ADANA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (2, N'ADIYAMAN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (3, N'AFYON')
INSERT [dbo].[States] ([Id], [Name]) VALUES (4, N'AĞRI')
INSERT [dbo].[States] ([Id], [Name]) VALUES (5, N'AMASYA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (6, N'ANKARA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (7, N'ANTALYA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (8, N'ARTVİN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (9, N'AYDIN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (10, N'BALIKESİR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (11, N'BİLECİK')
INSERT [dbo].[States] ([Id], [Name]) VALUES (12, N'BİNGÖL')
INSERT [dbo].[States] ([Id], [Name]) VALUES (13, N'BİTLİS')
INSERT [dbo].[States] ([Id], [Name]) VALUES (14, N'BOLU')
INSERT [dbo].[States] ([Id], [Name]) VALUES (15, N'BURDUR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (16, N'BURSA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (17, N'ÇANAKKALE')
INSERT [dbo].[States] ([Id], [Name]) VALUES (18, N'ÇANKIRI')
INSERT [dbo].[States] ([Id], [Name]) VALUES (19, N'ÇORUM')
INSERT [dbo].[States] ([Id], [Name]) VALUES (20, N'DENİZLİ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (21, N'DİYARBAKIR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (22, N'EDİRNE')
INSERT [dbo].[States] ([Id], [Name]) VALUES (23, N'ELAZIĞ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (24, N'ERZİNCAN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (25, N'ERZURUM')
INSERT [dbo].[States] ([Id], [Name]) VALUES (26, N'ESKİŞEHİR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (27, N'GAZİANTEP')
INSERT [dbo].[States] ([Id], [Name]) VALUES (28, N'GİRESUN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (29, N'GÜMÜŞHANE')
INSERT [dbo].[States] ([Id], [Name]) VALUES (30, N'HAKKARİ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (31, N'HATAY')
INSERT [dbo].[States] ([Id], [Name]) VALUES (32, N'ISPARTA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (33, N'İÇEL')
INSERT [dbo].[States] ([Id], [Name]) VALUES (34, N'İSTANBUL')
INSERT [dbo].[States] ([Id], [Name]) VALUES (35, N'İZMİR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (36, N'KARS')
INSERT [dbo].[States] ([Id], [Name]) VALUES (37, N'KASTAMONU')
INSERT [dbo].[States] ([Id], [Name]) VALUES (38, N'KAYSERİ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (39, N'KIRKLARELİ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (40, N'KIRŞEHİR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (41, N'KOCAELİ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (42, N'KONYA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (43, N'KÜTAHYA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (44, N'MALATYA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (45, N'MANİSA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (46, N'KAHRAMANMARAŞ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (47, N'MARDİN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (48, N'MUĞLA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (49, N'MUŞ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (50, N'NEVŞEHİR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (51, N'NİĞDE')
INSERT [dbo].[States] ([Id], [Name]) VALUES (52, N'ORDU')
INSERT [dbo].[States] ([Id], [Name]) VALUES (53, N'RİZE')
INSERT [dbo].[States] ([Id], [Name]) VALUES (54, N'SAKARYA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (55, N'SAMSUN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (56, N'SİİRT')
INSERT [dbo].[States] ([Id], [Name]) VALUES (57, N'SİNOP')
INSERT [dbo].[States] ([Id], [Name]) VALUES (58, N'SİVAS')
INSERT [dbo].[States] ([Id], [Name]) VALUES (59, N'TEKİRDAĞ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (60, N'TOKAT')
INSERT [dbo].[States] ([Id], [Name]) VALUES (61, N'TRABZON')
INSERT [dbo].[States] ([Id], [Name]) VALUES (62, N'TUNCELİ')
INSERT [dbo].[States] ([Id], [Name]) VALUES (63, N'ŞANLIURFA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (64, N'UŞAK')
INSERT [dbo].[States] ([Id], [Name]) VALUES (65, N'VAN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (66, N'YOZGAT')
INSERT [dbo].[States] ([Id], [Name]) VALUES (67, N'ZONGULDAK')
INSERT [dbo].[States] ([Id], [Name]) VALUES (68, N'AKSARAY')
INSERT [dbo].[States] ([Id], [Name]) VALUES (69, N'BAYBURT')
INSERT [dbo].[States] ([Id], [Name]) VALUES (70, N'KARAMAN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (71, N'KIRIKKALE')
INSERT [dbo].[States] ([Id], [Name]) VALUES (72, N'BATMAN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (73, N'ŞIRNAK')
INSERT [dbo].[States] ([Id], [Name]) VALUES (74, N'BARTIN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (75, N'ARDAHAN')
INSERT [dbo].[States] ([Id], [Name]) VALUES (76, N'IĞDIR')
INSERT [dbo].[States] ([Id], [Name]) VALUES (77, N'YALOVA')
INSERT [dbo].[States] ([Id], [Name]) VALUES (78, N'KARABÜK')
INSERT [dbo].[States] ([Id], [Name]) VALUES (79, N'KİLİS')
INSERT [dbo].[States] ([Id], [Name]) VALUES (80, N'OSMANİYE')
INSERT [dbo].[States] ([Id], [Name]) VALUES (81, N'DÜZCE')
SET IDENTITY_INSERT [dbo].[States] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [UserName], [FirstName], [LastName], [Email], [Password], [Salt], [IsActive]) VALUES (1, N'eyup', N'Eyüp', N'Gevenim', N'eyupgevenim@gmail.com', N'QdueApqsKPd1Gh5Hb3ulNcnID5OThjiSUC9y80SjPqY=', N'u33ZXuHz6sEI37H0f98J3A==', 1)
INSERT [dbo].[Users] ([Id], [UserName], [FirstName], [LastName], [Email], [Password], [Salt], [IsActive]) VALUES (2, N'test', N'Test Name', N'Test Surname', N'test@test.com', N'OsOMi6hsV3Wv83GzGzjTkUfBLYfk6PoZtFgLkh3pB0Y=', N'ePIswSfg5DH5nIGGxGVPcg==', 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
SET IDENTITY_INSERT [dbo].[VehicleBrands] ON 

INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (1, N'FERRARI')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (2, N'CADILLAC ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (3, N'ISUZU')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (4, N'ROVER ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (5, N'HONDA ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (6, N'LAND ROVER')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (7, N'JEEP')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (8, N'SUBARU ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (9, N'VOLVO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (10, N'SSANGYONG')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (11, N'PLYMOUTH')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (12, N'SUZUKI')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (13, N'UNIVERSAL')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (14, N'Marka')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (15, N'RANGE ROVER')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (16, N'FARGO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (17, N'SAAB')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (18, N'WILLMENT')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (19, N'vectra')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (20, N'MITSUBISHI ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (21, N'DODGE/FARGO/DESOTO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (22, N'TATA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (23, N'GAZ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (24, N'HYUNDAI ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (25, N'RENAULT ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (26, N'MOSKOVIC')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (27, N'DODGE')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (28, N'FIAT')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (29, N'KIA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (30, N'NISSAN')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (31, N'GMC')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (32, N'SPECTRA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (33, N'JEEP UNIVERSAL')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (34, N'SEAT ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (35, N'FIAT/TOFAŞ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (36, N'VOLKSWAGEN ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (37, N'KASKO DEĞER LİSTESİ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (38, N'AUSTIN')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (39, N'OLDSMOBİLE ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (40, N'PROTON')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (41, N'SHELBY')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (42, N'BMW')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (43, N'VAZ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (44, N'MERCEDES')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (45, N'JAVELİN ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (46, N'DE TOMASO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (47, N'CITROEN')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (48, N'CHEVROLET')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (49, N'LOTUS')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (50, N'LANCIA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (51, N'WILLYS')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (52, N'PORSCHE')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (53, N'LINCOLN ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (54, N'TOYOTA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (55, N'BUICK')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (56, N'MAZDA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (57, N'ROLLS ROYCE ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (58, N'DESOTO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (59, N'JAGUAR ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (60, N'INTER ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (61, N'MASERATI')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (62, N'MERCURY ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (63, N'OPEL')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (64, N'POLONEZ FSO ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (65, N'TRIUMPH ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (66, N'DAIHATSU')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (67, N'MG')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (68, N'SKODA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (69, N'AMC-EAGLE ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (70, N'LAMBORGHINI')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (71, N'CHRYSLER/JEEP')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (72, N'CHRYSLER')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (73, N'MERCURY/FORD ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (74, N'RAMBLER')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (75, N'ARO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (76, N'AUDI')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (77, N'INTER SUCUT')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (78, N'ANADOL')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (79, N'AMC')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (80, N'INTERNATIONAL')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (81, N'WRANGLER')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (82, N'DAEWOO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (83, N'CHECKER')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (84, N'WILLYS/JEEP')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (85, N'OCAK 2018')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (86, N'LADA')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (87, N'ALFA ROMEO')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (88, N'FORD')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (89, N'PONTIAC ')
INSERT [dbo].[VehicleBrands] ([Id], [Name]) VALUES (90, N'PEUGEOT')
SET IDENTITY_INSERT [dbo].[VehicleBrands] OFF
SET IDENTITY_INSERT [dbo].[VehicleModels] ON 

INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1, N'164 3.0 V6 ', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2, N'164 2.5 TURBO', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3, N'164 2.5 SUPER V6 TB', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4, N'164 2.0 SUPER V6 TB', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (5, N'164 2.0 TS', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (6, N'166 2.4 JTD', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (7, N'166 3.0 SPORTRONIC', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (8, N'156 2.0', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (9, N'156 2.4 JTD', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (10, N'2600 SPIDER', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (11, N'SPIDER 2.0 TS 16V', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (12, N'VELAOCIA 1.6', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (13, N'2000 (1598)', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (14, N'SPIDER (2600)', 87)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (15, N'4 WHEEL DRIVE STW (4235)', 69)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (16, N'STC 16 (1567)', 78)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (17, N'4 KAPILI (1300)', 78)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (18, N'JEEP (4235)', 75)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (19, N'100 2.0', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (20, N'100 2.3', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (21, N'100 2.6', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (22, N'100 CD (1986)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (23, N'100 CD (2119)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (24, N'80 2600', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (25, N'80 CX 1598', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (26, N'80 CL DIESEL (1600)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (27, N'80 CC TD 1.6', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (28, N'80 (1984)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (29, N'80 AVANT (1984)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (30, N'80 GL (1994)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (31, N'80 C (1998) DIZEL', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (32, N'100 (1998)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (33, N'100 (1984)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (34, N'100 2.0 E', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (35, N'100 SE (1980)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (36, N'100 TURBO 2.2', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (37, N'100 (2200) LPG', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (38, N'100 C 4 KAPI (1588)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (39, N'100 QUATRO 2.8', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (40, N'100 AVANT QUATTRO SW (2.3)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (41, N'100 2.5 TDI', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (42, N'200 TURBO (2129)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (43, N'200 TURBO (2200)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (44, N'200 TURBO (2220)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (45, N'C4 100 (2598)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (46, N'A4 2.6', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (47, N'A4 2.8 QUATTRO', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (48, N'A4 3.0 QUATTRO TIPTRONIC', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (49, N'A6 AVANT 2.5 DIZEL', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (50, N'A6 2.5 TDI', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (51, N'A6 2.8 V6 QUATT.OTM.', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (52, N'A6 2.8 AUT AMB.', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (53, N'A6 2.8 QUATTRO OTM', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (54, N'A6 4.2 QUATTRO', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (55, N'A8 4.2 QUATTRO', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (56, N'QUATTRO (4172)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (57, N'V8 (3500)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (58, N'V8 (4200)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (59, N'90 QUATTRO (1990)', 76)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (60, N'MINI 1000 (1370)', 38)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (61, N'328i CABRIO', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (62, N'328iA COUPE', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (63, N'328iA 4 KAPI', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (64, N'328i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (65, N'328i/4 E46', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (66, N'328iA/4 E46', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (67, N'850 Ci', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (68, N'850 CiA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (69, N'850i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (70, N'850iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (71, N'840 CI', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (72, N'840 CIA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (73, N'635 CSI', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (74, N'633 CSI', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (75, N'630 CSI', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (76, N'735 IAL', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (77, N'735 IL', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (78, N'735', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (79, N'735i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (80, N'728iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (81, N'728i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (82, N'728', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (83, N'730i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (84, N'735iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (85, N'735 TA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (86, N'732iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (87, N'732i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (88, N'732', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (89, N'730', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (90, N'740iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (91, N'730iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (92, N'745i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (93, N'750 ILA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (94, N'750 IL', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (95, N'760 LI', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (96, N'750 IA ALPINA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (97, N'750 IA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (98, N'750 I', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (99, N'750 IE', 42)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (100, N'740 IL', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (101, N'740i AL', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (102, N'730d', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (103, N'740d', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (104, N'M5 (4941)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (105, N'M5 (3800)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (106, N'M5 (3535)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (107, N'M5 (2998)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (108, N'M3 COUPE', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (109, N'M3 ', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (110, N'540 IA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (111, N'535i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (112, N'535iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (113, N'524 d', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (114, N'524 td', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (115, N'524 tdA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (116, N'523 iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (117, N'316', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (118, N'315', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (119, N'316iA COMPACT', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (120, N'316i/4', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (121, N'318 i/4', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (122, N'318i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (123, N'318 iS/4', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (124, N'318 iS', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (125, N'1502 (2001)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (126, N'2002 (2000)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (127, N'2002 (1598)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (128, N'325 IA/2 CAB.', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (129, N'323i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (130, N'323i CABRIO', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (131, N'323 (E30) 2485', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (132, N'325i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (133, N'325i/4', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (134, N'325iX', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (135, N'325i HARTGE', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (136, N'325 E', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (137, N'330 CI/2', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (138, N'324 D', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (139, N'324 TD', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (140, N'325 TDA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (141, N'320 iA/4', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (142, N'320iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (143, N'320i 2', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (144, N'320i ', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (145, N'320i/4 ', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (146, N'320i STW', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (147, N'320', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (149, N'528i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (150, N'528iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (151, N'525i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (152, N'525iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (153, N'525', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (154, N'525 D', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (155, N'501 (1800)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (156, N'325i CABRIO', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (157, N'325 CABRIO', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (158, N'325i COUPE', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (159, N'520', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (160, N'520i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (161, N'520iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (162, N'520i OV', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (163, N'530iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (164, N'530i', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (165, N'530D', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (166, N'30 CSL 2 DOOR COUPE (2998)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (167, N'30 CSL (2985)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (168, N'Z3 2.8 COUPE', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (169, N'Z3 M 3.2', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (170, N'2800 CS (2798)', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (171, N'X5 4.4iA', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (172, N'BINEK (WILDCAT) (7000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (173, N'SPECIAL (2000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (174, N'GSX STAGE I (7300)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (175, N'SUPER 2001', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (176, N'SUPER (4389)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (177, N'TENEZZUH 2500', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (178, N'TENEZZUH (5724)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (179, N'BINEK (4128)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (180, N'WILD CAT (7468)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (181, N'4 KAPILI (3822)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (182, N'4 KAPILI (4001)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (183, N'4 KAPILI (4315) (SPECIAL)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (184, N'SPECIAL (3875)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (185, N'SPECIAL (5300)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (186, N'EIGHT (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (187, N'ELECTRA PARK (5031)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (188, N'ELECTRA LIMITED SEDAN (4200)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (189, N'ELECTRA LIMITED (4200)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (190, N'ELECTRA (4500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (191, N'ELECTRA 225 (5724)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (192, N'LIMITED (5200)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (193, N'LIMITED (5724)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (194, N'ELECTRA LIMITED (5733)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (195, N'LIMITED (2001)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (196, N'LIMITED (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (197, N'ELECTRA (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (198, N'LIMITED (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (199, N'LIMITED (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (200, N'ELECTRA (2000)', 55)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (201, N'LIMITED (2800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (202, N'LIMITED (3000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (203, N'ELECTRA (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (204, N'ELECTRA (3001)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (205, N'ELECTRA (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (206, N'225 ELECTRA (7468)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (207, N'LIMITED (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (208, N'ELECTRA (3000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (209, N'STW (5733)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (210, N'ROADMASTER (5700)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (211, N'ROADMASTER (5200)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (212, N'ROADMASTER (7468)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (213, N'ROADMASTER (4996)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (214, N'ROADMASTER (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (215, N'CENTURION (4200)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (216, N'CENTURION (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (217, N'CENTURION (3998)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (218, N'CENTURY (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (219, N'CENTURY (1700)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (220, N'CENTURY (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (221, N'CENTURY (2800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (222, N'CENTURY (3000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (223, N'CENTURY (3100)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (224, N'CENTURY (3300)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (225, N'CENTURY (3340)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (226, N'CENTURY (3785)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (228, N'REGAL GRAND SPORT (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (229, N'21 OPTIMA', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (230, N'CONCORDE ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (231, N'21 GTD 2088', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (232, N'21 GTD NEVADA ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (233, N'21 GTS NEVADA (1721)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (234, N'21 TX   NEVADA (1721)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (235, N'BROADWAY 1.4i RN ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (236, N'BROADWAY 1.4 RL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (237, N'9 GTC', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (238, N'9 GTE ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (239, N'9 GTE BROADWAY ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (240, N'9 SPRING', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (241, N'9 SPRING-L422', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (242, N'L 423', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (243, N'B 373 (1.4)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (244, N'SAFRANE IXE DIZEL 2.2', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (245, N'SAFRANE 3.0 INTIAL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (246, N'SAFRANE 3.0 V6', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (247, N'SAFRANE 3.0 V6 BVA', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (248, N'SAFRANE BVA (2946)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (249, N'SAFRANE RXE (2963)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (250, N'TIPO 1.6 SX', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (251, N'TEMPRA 2.0 İ.E. 16V', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (252, N'TEMPRA 2.0 İ.E. ', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (253, N'TEMPRA 1929 DIZEL', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (254, N'TEMPRA 1.6 SXA', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (255, N'SCUDO 2.0 JTD', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (256, N'DOBLO CARGO 1.9 JTD SX', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (257, N'DOBLO CARGO 1.9 D SX', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (258, N'DOBLO CARGO 1.9 D ', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (259, N'MURAT 131 DOĞAN (1600)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (260, N'MURAT 131 DOĞAN L (1600)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (261, N'DOĞAN 1.6', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (262, N'DOĞAN (1598)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (263, N'DOĞAN L', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (264, N'DOĞAN S.', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (265, N'DOĞAN SLX i.e.', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (266, N'DOĞAN SLX', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (267, N'ŞAHİN 1898 DIZEL', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (268, N'ŞAHİN (1600)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (269, N'ŞAHİN 1.6 İ.E.', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (270, N'SERCE', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (271, N'MURAT 124', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (272, N'MURAT 131 ', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (273, N'MURAT 131 KARTAL SLX', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (274, N'MURAT 131 KARTAL 5 VITES (1600)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (275, N'MURAT 131 KARTAL (1600)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (276, N'MURAT 131 STW (1817)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (277, N'KARTAL DIZEL (1817)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (278, N'KARTAL LPG', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (279, N'KARTAL (1815)', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (280, N'KARTAL S ', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (281, N'PALIO 1.6 HB AC', 35)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (282, N'MONDEO GHIA 5 KAPI ( 1988 )', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (283, N'MONDEO 2.0 GHIA', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (284, N'MONDEO 2.0 ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (285, N'MONDEO 2.0 GLX HATCBACK', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (286, N'MONDEO GLX SEDAN', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (287, N'MONDEO GLX 5K 1998', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (288, N'MONDEO GLX AUTO (1998)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (289, N'MONDEO 4K SEDAN 2.5', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (290, N'MONDEO (2554)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (291, N'MONDEO 2.5 V6', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (292, N'MONDEO 2.5 V6 GHIA SEDAN', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (293, N'MONDEO GHIA 5K (2544)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (294, N'MAKSI LX 2.5 DIESEL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (295, N'MAKSI L 2.5 DIESEL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (296, N'LCX KISA SASI 8 KISILIK', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (297, N'TORINO (4950)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (298, N'SEDAN (4200)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (299, N'SEDAN (4000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (300, N'2D (4600)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (301, N'TAURUS 2.9', 88)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (302, N'TAURUS (2986)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (303, N'TAURUS 3.0', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (304, N'TAURUS 3.0 OV', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (305, N'TAURUS 3.8', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (306, N'GRANADA (2800)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (307, N'GRANADA (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (308, N'GRANADA (2200)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (309, N'GRANADA (2000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (310, N'GRANADA GXL (2581)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (311, N'GRANADA GXL (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (312, N'GRANADA (2551)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (313, N'GRANADA (2500)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (314, N'GRANADA (3000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (315, N'GRANADA (3300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (316, N'GRANADA (1881)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (317, N'GRANADA (1800)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (318, N'GRANADA (1699)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (319, N'GRANADA (1600)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (320, N'GRANADA (1595)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (321, N'GRANADA L20 (1993)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (322, N'GRANADA L (1998)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (323, N'GRANADA 2.5 DL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (324, N'GXL 500 (1597)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (325, N'CONSUL (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (326, N'CONSUL L (2000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (327, N'CONSUL (1998)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (328, N'CONSUL (1987)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (329, N'CONSUL (1700)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (330, N'CONSUL (1699)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (331, N'26 M (2600)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (332, N'17 M (1700)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (333, N'20 M (1881)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (334, N'20 M (1700)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (335, N'20 M (2000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (336, N'20 M XL (2000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (337, N'20 M (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (338, N'20 MYL 2300S', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (339, N'AC (6965)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (340, N'THUNDERBIRD COUPE (5496)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (341, N'THUNDERBIRD SPOR SEDAN (5000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (342, N'THUNDERBIRD CONVERTIBLE (6392)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (343, N'THUNDERBIRD (2001)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (344, N'THUNDERBIRD (3528)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (345, N'THUNDERBIRD (3800)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (346, N'THUNDERBIRD (3900)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (347, N'THUNDERBIRD (5000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (348, N'THUNDERBIRD (5114)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (349, N'THUNDERBIRD (5400)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (350, N'THUNDERBIRD (5469)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (351, N'THUNDERBIRD (6200)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (352, N'THUNDERBIRD (6384)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (353, N'THUNDERBIRD (6383)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (354, N'THUNDERBIRD (6392)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (355, N'THUNDERBIRD (6500)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (356, N'THUNDERBIRD (4785)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (357, N'THUNDERBIRD (4600)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (358, N'STANDART (4300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (359, N'BINEK (4785)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (360, N'ESCORT 1.8 CLX HB', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (361, N'ESCORT 1.8 CLX SEDAN', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (362, N'ESCORT 1.8 GHIA HB', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (363, N'ESCORT 1.8 GHIA SEDAN', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (364, N'ESCORT (1991)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (365, N'ESCORT (1993)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (366, N'ESCORT (1798)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (367, N'ESCORT 1.3 CL ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (368, N'MAVERICK (2000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (369, N'MAVERICK (2785)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (370, N'MAVERICK 4x4 (4200)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (371, N'MUSTANG (1998)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (372, N'MUSTANG (2001)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (373, N'MUSTANG (2301)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (374, N'MUSTANG (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (375, N'MUSTANG (2400)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (376, N'MUSTANG (2500)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (377, N'MUSTANG (2600)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (378, N'MUSTANG (5766)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (379, N'MUSTANG (6342)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (380, N'MUSTANG (6387)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (381, N'MUSTANG FASTBACK (6499)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (382, N'MUSTANG (7010)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (383, N'MUSTANG (7033)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (384, N'MUSTANG (5000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (385, N'MUSTANG (4900)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (386, N'MUSTANG (4949)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (387, N'MUSTANG (4700)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (388, N'MUSTANG (4725)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (389, N'MUSTANG (4500)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (390, N'MUSTANG 3.8', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (391, N'MUSTANG COUPE 3.8', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (392, N'MUSTANG (3000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (393, N'MUSTANG (3280)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (394, N'MUSTANG (3298)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (395, N'MUSTANG (4952)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (396, N'MUSTANG (4942)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (397, N'MACH 1 (5700)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (398, N'MUSTANG MACH 1 (4942)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (399, N'MUSTANG MACH 1 (2800)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (400, N'MUSTANG GT 4.6', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (401, N'MUSTANG COBRA 4.6 CONVERT', 88)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (402, N'MUSTANG COBRA 4.6', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (403, N'MUSTANG GT CABRIO 5.0', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (404, N'MUSTANG GT COUPE 4.6i V8', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (405, N'MUSTANG GT 4.6 CONVERTIBLE', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (406, N'GT COUPE 4.6i V8', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (407, N'GT 500 CONVERTIBLE', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (408, N'LINCOLN CONTINENTAL 2000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (409, N'LINCOLN CONTINENTAL 2591', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (410, N'LTD (4325)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (411, N'LTD (2500)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (412, N'LTD (1598)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (413, N'LTD (6300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (414, N'LTD 6.9', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (415, N'MUSTANG 1698', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (416, N'MUSTANG 1663', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (417, N'SPORT 3200', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (418, N'SPORT MUSTANG 2368', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (419, N'SPORT MUSTANG 2597', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (420, N'GALAXI (1397)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (421, N'GALAXI 500 2.0', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (422, N'GALAXI (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (423, N'GALAXY (2295)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (424, N'GALAXY (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (425, N'GALAXY 2.0 DIZEL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (426, N'GALAXY (1898) DIZEL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (427, N'EXPEDITION EDDIE BAUER', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (428, N'EXPEDITION 5.4', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (429, N'EXPLORER EDDIE BAUER (3958)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (430, N'EXPLORER EDDIE BAUER (4601)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (431, N'EXPLORER (4996)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (432, N'EXPLORER 5.0 ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (433, N'EXPLORER 5.0 LTD ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (434, N'EXPLORER 5.7 ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (435, N'EXPLORER 4x4 JEEP (3850)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (436, N'EXPLORER XLT 4.0i', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (437, N'EXPLORER 4.0 XLT  V6', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (438, N'EXPLORER 4.0 LTD ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (439, N'EXPLORER 4.0 ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (440, N'EXPLORER LTD (3996)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (441, N'EXPLORER LTD V8 4x4 (3996)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (442, N'EXPLORER XLT EXPEDITION STW (4601) ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (443, N'EXPLORER XLT (4601) ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (444, N'BRONCO RANGER XLT (4600) 4X4', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (445, N'SOVEREING 4.0', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (446, N'SOVEREING 3938', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (447, N'SOVEREING (4235)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (448, N'XJ6 3.6', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (449, N'XJ6 (3520)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (450, N'XJ6 3442', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (451, N'XJ6 3.4', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (452, N'XJS V12 COUPE (6000)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (453, N'XJS V12 COUPE (4250)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (454, N'XJ 5.3', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (455, N'XJS CABRIOLET 4.0', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (456, N'XJS CABRIO (5345)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (457, N'XJS 5.3', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (458, N'XJ 4.0', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (459, N'XJ 3565', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (460, N'XJ 4.2 (42X)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (461, N'XJ 4.2', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (462, N'XJ 4.2 SOVEREIGN ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (463, N'XJR 4.0 SUPERCHARGE', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (464, N'XJR 4.2 ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (465, N'TENEZZÜH  3001', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (466, N'E TYPE 3781', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (467, N'X TYPE COUPE (4235 cc)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (468, N'REGAL GRAND SPORT (3100)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (469, N'REGAL (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (470, N'REGAL (2600)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (471, N'REGAL (2800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (472, N'REGAL (3001)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (473, N'REGAL (3200)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (474, N'REGAL (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (475, N'REGAL (3600)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (476, N'REGAL (4093)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (477, N'REGAL CUSTOM LIMITED (3100)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (478, N'REGAL  (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (479, N'REGAL  (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (480, N'REGAL  (3850)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (481, N'REGAL  2 KAPILI (3850)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (482, N'REGAL  (4400)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (483, N'REGAL  (4500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (484, N'REGAL  (4998)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (485, N'REGAL  (5800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (486, N'REGAL  (5700)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (487, N'REGAL  (5728)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (488, N'GRAND SPORT (6596)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (489, N'GRAND SPORT (6595)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (490, N'RIVIERA (2001) ', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (491, N'RIVIERA  LPG ''li (3185) ', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (492, N'RIVIERA  (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (493, N'RIVIERA  (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (494, N'RIVIERA  (3998)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (495, N'RIVIERA  (7000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (496, N'RIVIERA  (7468)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (497, N'SKYLARK  CUSTOM (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (498, N'SKYLARK (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (499, N'SKYLARK (3000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (500, N'SKYLARK SR (5000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (501, N'SKYLARK (5700)', 55)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (502, N'SKYLARK (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (503, N'SKYLARK (3767)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (504, N'SKYLARK (3700)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (505, N'SKYLARK (2400)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (506, N'SKYLARK (2471)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (507, N'SKYLARK (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (508, N'SKYLARK (2300)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (509, N'SKYLARK (2001)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (510, N'SKYLARK (1760)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (511, N'SKYLARK (1585)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (512, N'SKYLARK (2800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (513, N'SKYLARK (2835)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (514, N'SKYLARK (2985)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (515, N'SKYLARK (4093)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (516, N'SKYLARK (4942)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (517, N'SKYHAWK (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (518, N'APOLLO (4097)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (519, N'APOLLO (4093)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (520, N'APOLLO (4100)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (521, N'APOLLO (4120)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (522, N'APOLLO (3791)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (523, N'APOLLO (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (524, N'APOLLO (4300)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (525, N'APOLLO (4500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (526, N'APOLLO (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (527, N'APOLLO (3200)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (528, N'APOLLO (3001)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (529, N'APOLLO (2367)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (530, N'APOLLO (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (531, N'APOLLO (2498)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (532, N'APOLLO (2000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (533, N'APOLLO (1630)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (534, N'PARK AVENUE (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (535, N'PARK AVENUE (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (536, N'PARK AVENUE (3498)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (537, N'PARK AVENUE (3000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (538, N'ELECTRA PARK AVENUE (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (539, N'PARK AVENUE (5724) (FILIP MASTER)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (540, N'PARK AVENUE LPG.LI (5033)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (541, N'PARK AVENUE (1600)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (542, N'PARK AVENUE (2000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (543, N'PARK AVENUE (2110)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (544, N'PARK AVENUE (2495)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (545, N'LE SABRE LTD  (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (546, N'LE SABRE (3800)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (547, N'LE SABRE (2500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (548, N'LE SABRE CUSTOM (2501)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (549, N'LE SABRE (5700)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (550, N'LE SABRE LTD  (5700)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (551, N'SABRE LIMITED  (5700)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (552, N'LE SABRE (5000)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (553, N'LE SABRE (3500)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (554, N'CUSTOM LE SABRE (3999)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (555, N'LE SABRE (4565)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (556, N'LE SABRE (1600)', 55)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (557, N'HUSUSI OTO (4000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (558, N'YOLCU (4000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (559, N'TENEZZUH (4000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (560, N'SEDAN (3580)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (561, N'OTOMOBIL (4500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (562, N'TENTELI (6382)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (563, N'BROUGHAM (3500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (564, N'FLEETWOOD BROUGHAM (2930)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (565, N'FLEETWOOD BROUGHAM (3500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (566, N'FLEETWOOD BROUGHAM (5733)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (567, N'FLEETWOOD BROUGHAM 4.6', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (568, N'BROUGHAM (5735)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (569, N'BROUGHAM (5733)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (570, N'BROUGHAM (5400)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (571, N'BROUGHAM (5100)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (572, N'BROUGHAM (5033)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (573, N'ESCALADE 5.7', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (574, N'ESCALADE 6.0', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (575, N'DEVILLE DTS 4.6', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (576, N'DEVILLE CONCOURS (4600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (577, N'DEVILLE CONCOURS (4892)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (578, N'DEVILLE D.ELEGANCE (4600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (579, N'DEVILLE D.ELEGANCE (5000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (580, N'DEVILLE 70 LIMUZIN (4600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (581, N'DEVILLE 4.5', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (582, N'DEVILLE (5700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (583, N'DEVILLE (6000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (584, N'DEVILLE CONVERTIBLE (7700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (585, N'SEDAN DEVILLE (7700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (586, N'DEVILLE FLEETWOOD (7700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (587, N'FLEETWOOD (4800)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (588, N'DEVILLE FLEETWOOD (7735)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (589, N'FLEETWOOD (4260)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (590, N'DEVILLE CONVERTIBLE  (3800)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (591, N'DEVILLE CONVERTIBLE  (4000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (592, N'COUPE (5700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (593, N'COUPE DEVILLE (5500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (594, N'COUPE DEVILLE (3500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (595, N'DEVILLE COUPE (6400)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (596, N'COUPE DEVILLE (7700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (597, N'SEVILLE STS (4893)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (598, N'SEVILLE STS (4600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (599, N'SEVILLE STS NORDSTAR (4600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (600, N'STS (4600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (601, N'SEVILLE TOURING (4600)', 2)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (602, N'SEVILLE (4600) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (603, N'SEVILLE (4500) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (604, N'SEVILLE (4893) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (605, N'SEVILLE (4900) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (606, N'SEVILLE TOURING SEDAN (3000) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (607, N'SEVILLE (3598) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (608, N'SEVILLE (4100) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (609, N'SEVILLE (4000) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (610, N'SEVILLE (5000) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (611, N'SEVILLE COLUIAL (4500) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (612, N'SEVILLE (4467) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (613, N'SEVILLE (5660) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (614, N'SEVILLE (5700) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (615, N'SERIES 62 (5972) (SEVILLE)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (616, N'FLEETWOOD BROUGHAM (6000) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (617, N'FLEETWOOD BROUGHAM (5700) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (618, N'FLEETWOOD (4893) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (619, N'SIXTY SPECIAL (4893) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (620, N'FLEETWOOD (6036) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (621, N'FLEETWOOD (5700) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (622, N'FLEETWOOD (5500) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (623, N'FLEETWOOD (4500) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (624, N'FLEETWOOD (4467) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (625, N'FLEETWOOD (4832) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (626, N'FLEETWOOD (4983) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (627, N'FLEETWOOD (5033) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (628, N'FLEETWOOD (8194) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (629, N'FLEETWOOD (1982) ', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (630, N'FLEETWOOD ELEGANCE (2300)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (631, N'FLEETWOOD ELEGANCE (4100)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (632, N'ELEGANCE (4100)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (634, N'FLEETWOOD (4098)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (635, N'FLEETWOOD (4100)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (636, N'FLEETWOOD (4000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (637, N'FLEETWOOD (3000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (638, N'ELEGANCE (5033)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (639, N'ELEGANTE (4996)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (640, N'ELEGANTE (4100)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (641, N'SEDAN DEVILLE (6499)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (642, N'SEDAN DEVILLE OV (4000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (643, N'SEDAN DEVILLE (5687)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (644, N'SEDAN DEVILLE (4900)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (645, N'DEVILLE (4900)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (646, N'DEVILLE (4893)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (647, N'DEVILLE SEDAN (4890)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (648, N'BRONCO (2115)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (649, N'BRONCO XLT (5800)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (650, N'BRONCO 5.0', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (651, N'BRONCO XLT (4917)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (652, N'BRONCO 4.9', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (653, N'BRONCO 4.0', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (654, N'BRONCO (U 151 DT. VAGONNER) 3595', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (655, N'BRONCO 5.8 XLT', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (656, N'BRONCO 5.8', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (657, N'EXCURSION (6600)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (658, N'ECONOLINE VAN (5400)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (659, N'ECONOLINE 150 (5000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (660, N'AEROSTAR 4.0 OV', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (661, N'AEROSTAR 3.0 ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (662, N'58 EC CUSTOM 2300', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (663, N'CROWN VICTORIA ( 5000 )', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (664, N'CUSTOMLINE 2800', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (665, N'FAIRMOND 2300', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (666, N'FAIRLANE (1580)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (667, N'FAIRLANE 2600', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (668, N'FAIRLANE (2782)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (669, N'FAIRLANE 2.8', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (670, N'FAIRLANE 3400', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (671, N'FAIRLANE 500 (4200)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (672, N'FAIRLANE (4785)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (673, N'FAIRLANE (3000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (674, N'FAIRLANE 500 (2230)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (675, N'FAIRLANE (4457)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (676, N'2 KAPI BINEK (4700)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (677, N'FESTIVA GL 1.3', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (678, N'TRANSIT (2500) ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (679, N'TRANSIT (2496) ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (680, N'CJ6 (3850)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (681, N'CJ6 (4000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (682, N'CJ6 (4300)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (683, N'CJ3 (1700)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (684, N'CJ3 (3875)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (685, N'2304', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (686, N'4WD (2450)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (687, N'2477', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (688, N'2501', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (689, N'SPOR ARAZI TAŞITI (1200)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (690, N'1397', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (691, N'1600', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (692, N'ARAZİ 1885', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (693, N'ARAZİ 1600', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (694, N'JEEP (4000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (695, N'ARAZİ TAŞITI 3430', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (696, N'ARAZİ TAŞITI 2500', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (697, N'ARAZİ TAŞITI 2501', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (698, N'ARAZİ TAŞITI JEEP 2501', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (699, N'2 KAPILI (2501)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (700, N'ARAZİ TAŞITI - JEEP (2000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (701, N'ARAZİ TAŞITI 2300', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (702, N'ARAZİ TAŞITI 2250', 84)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (703, N'ARAZİ TAŞITI 2200', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (704, N'ARAZİ TAŞITI 2000', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (705, N'ARAZİ TAŞITI 1800', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (706, N'ARAZİ TAŞITI TENEZZÜH 2196', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (707, N'4WHEELDRIVE (SYR.TNT.SAC.KSL) (2400)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (708, N'2 KAPILI 2501', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (709, N'BİNEK (2500)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (710, N'BİNEK (2596)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (711, N'BJ9 4x4 2200', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (712, N'UNIVERSAL JEEP CJ-5 1889', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (713, N'UNIVERSAL(2485) DIZEL', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (714, N'UNIVERSAL(2496) DIZEL', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (715, N'UNIVERSAL (2501) ', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (716, N'CJ 5 A. VITESLI (2500) ', 13)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (717, N'TENTELİ (2300)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (718, N'TENTELİ (2500)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (719, N'HARIKAN (2500)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (720, N'C4 ARAZI TASITI ROMORKLU', 51)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (721, N'STW (3500)', 7)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (722, N'2 KAPILI (4200)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (723, N'XM 3.0', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (724, N'XM TURBO CT', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (725, N'CX 25 TRD', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (726, N'BX 15 TGE', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (727, N'XANTIA (1900)', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (728, N'CX 2400 PALLAS', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (729, N'DS 23', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (730, N'D SUPER 5 (2000)', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (731, N'TRACTION AVANT (1597)', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (732, N'TENEZZUH (1800)', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (733, N'SAXO 1.6i VSK BVA', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (734, N'XSARA 2.0 SX HDI', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (735, N'BERLINGO MULTISPACE 1.9D', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (736, N'BERLINGO FG 800 1.9D', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (737, N'BERLINGO 1.9D', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (738, N'EVASION 2.0i', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (739, N'C5 3.0i BVA', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (740, N'C5 HDI (2179)', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (741, N'COBRA CONVERTIBLE (4500)', 47)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (742, N'NUBIRA CDX 2.0', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (743, N'NUBIRA CDX 2.0 OTM.', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (744, N'ESPERO 2.0', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (745, N'MUSSO 602 L 2.9D OV', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (746, N'MUSSO 602 EL (2874) DIZEL', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (747, N'MUSSO 2.9 TDI A/T', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (748, N'MUSSO 3.2 4x4', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (749, N'MUSSO 230 S (2299) DIZEL', 10)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (750, N'REXTON (3200)', 10)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (751, N'KORANDO 290 SR (2984)', 10)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (752, N'LEGANZA 2.0 CDX 4D', 82)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (753, N'F80L 2000 ', 66)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (754, N'ROCKY 4WD 2765 ', 66)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (755, N'ROCKY (1900)', 66)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (756, N'FEROZA EL II  1590 ', 66)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (757, N'APPLAUSE 1.6', 66)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (758, N'SUPER SALON (1998)', 66)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (759, N'PANTERA 5766', 46)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (760, N'BINEK (2500)', 58)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (761, N'RAM BR 1500 4X4 (5733)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (762, N'RAM BR 1500 4WD (5200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (763, N'RAM SLT 3500 (5900)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (764, N'SLT 3500 (5900)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (765, N'RAM 2500 5.9', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (766, N'RAM 2500 5.9 TD', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (767, N'RAM 1500 4X4 5900', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (768, N'RAM ARAZI TAŞITI 5.9', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (769, N'DODGE RAM PICK UP 5.9', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (770, N'RAM VAN 2500 3682', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (771, N'RAM VAN 5.2', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (772, N'RAM 250 (5210)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (773, N'RAM 5.2', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (774, N'CIFT SIRA MINDERLI KAMYONET 4x4 (3682)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (775, N'LANCER (1600)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (776, N'YOLCU (2001)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (777, N'M37 KAMYONET (1500)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (778, N'BINEK (KINSWAY) (3800)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (779, N'CHARGER (5700)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (780, N'CHARGER (5400)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (781, N'CHARGER (5200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (782, N'CHARGER (4500)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (783, N'CHARGER (3700)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (784, N'CHARGER (3000)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (785, N'D 300 (5210)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (786, N'DIPLOMAT ( 5210 )', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (787, N'DURANGO 5.9', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (788, N'DURANGO 5.8', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (789, N'DURANGO 5.4', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (790, N'DURANGO 4.7', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (791, N'DURANGO (4368)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (792, N'DART SWINGER (1998)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (793, N'DART (1398)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (794, N'DART (2001)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (795, N'DART (1600)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (796, N'DART (1800)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (797, N'DART (1850)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (798, N'DART (3682)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (799, N'DART (5200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (800, N'340 DART (5200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (801, N'ASPEN (5200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (802, N'STEYŞIN (3683)', 27)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (803, N'STEALTH COUPE (3000)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (804, N'STANDART (3852)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (805, N'STANDART (3862)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (806, N'CARAVAN SE (3000)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (807, N'CARAVAN 3.0 ', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (808, N'CARAVAN 3.3 ', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (809, N'GRAND CARAVAN SE (3300)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (810, N'GRAND CARAVAN ES (3300)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (811, N'GRAND CARAVAN 3.3', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (812, N'GRAND CARAVAN (3515)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (813, N'GRAND CARAVAN LE (3900)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (814, N'GRAND CARAVAN LE (3778)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (815, N'CAHELLENGER (5898)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (816, N'CAHELLENGER (5200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (817, N'CAHELLENGER (3865)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (818, N'CAHELLENGER (3500)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (819, N'CAHELLENGER (2500)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (820, N'CAHELLENGER (6200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (821, N'CAHELLENGER A/T (6200)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (822, N'CHALLENGER (7210)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (823, N'CORONET (5210)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (824, N'CORONET (3687)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (825, N'CORONET (2500)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (826, N'CORONET (2498)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (827, N'CORONET (1592)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (828, N'CORONET (2400)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (829, N'KINSWAY (2001)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (830, N'INTREPID (3500)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (831, N'INTREPID ES (3500)', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (832, N'D 100', 27)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (833, N'PW 250 SUPER', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (834, N'PW 250 ', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (835, N'4x4 ARAZI KAMYONET (3682)', 16)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (836, N'PW 150 ', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (837, N'W 100', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (838, N'W 100 S', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (839, N'XLV W 100 S', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (840, N'XLW 100', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (841, N'W 200 ', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (842, N'POWERWAGON KAMYONET (2500)', 21)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (843, N'246 GT (2418)', 1)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (844, N'MONDIAL (3405)', 1)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (845, N'350 GTE (2953)', 1)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (846, N'360 MODENA F1', 1)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (847, N'348 TB (3505)', 1)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (848, N'F355 (4680)', 1)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (849, N'308 GTS (2927)', 1)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (850, N'MULTIPLA 1.6 LX', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (851, N'BRAVO 2.0 IE HGT', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (852, N'SIENA 1.4 EL', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (853, N'PALIO 1.4 EL', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (854, N'UNO SX ', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (855, N'BARCHETTA 1.8', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (856, N'COUPE 2.0V TURBO', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (857, N'PUNTO 1.9D', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (858, N'UNO SX LPG', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (859, N'MAREA SX WEEKEND ( 1910 )', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (860, N'MAREA 2.0 HLX', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (861, N'MAREA 1.9 JTD ELX', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (862, N'MAREA 2.4 JTD ', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (863, N'CROMA 2.0 16V', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (864, N'TIPO 2.0 16V İ.E.', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (865, N'TIPO 2.0 16V ', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (866, N'TIPO 1.6 DGT', 28)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (867, N'VENTURA 5735', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (868, N'VENTURA 2.6', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (869, N'VENTURA 2.5', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (870, N'VENTURA 2153', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (871, N'VENTURA 2.3', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (872, N'VENTURA 1998', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (873, N'VENTURA 1650', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (874, N'LAURENTIAN 3760', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (875, N'GTO (6555)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (876, N'GTO (3528)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (877, N'LEMANS 5801', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (878, N'LEMANS 5773', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (879, N'LEMANS 4500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (880, N'LEMANS (4093)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (881, N'LEMANS 4000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (882, N'LEMANS 3800', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (883, N'LEMANS 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (884, N'LEMANS 3500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (885, N'LEMANS 3200', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (886, N'LEMANS 3000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (887, N'CONVERTIBLE LEMANS SPORT 350 (5700)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (888, N'GRAND LEMANS (5700)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (889, N'GRAND LEMANS (4800)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (890, N'GRAND LEMANS 3000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (891, N'GRAND LEMANS 2300 4 KAPI ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (892, N'GRAND LEMANS 1735 4 KAPI ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (893, N'LEMANS 2620', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (894, N'GRAND LEMANS 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (895, N'GRAND LEMANS 3498', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (896, N'FIREBIRD CONVERTIBLE 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (897, N'FIREBIRD FORMULA 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (898, N'FIREBIRD 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (899, N'FIREBIRD TRANSAM 5733', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (900, N'FIREBIRD TRANSAM 4.0', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (901, N'FIREBIRD TRANCERA 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (902, N'FIREBIRD FORMULA 3350', 89)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (903, N'SEDAN DE DEVILLE (7700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (904, N'SEDAN DEVILLE (4100)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (905, N'SEDAN DEVILLE (4500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (906, N'SEDAN DEVILLE (3500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (907, N'SEDAN (4500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (908, N'DEVILLE (3800)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (909, N'DEVILLE (4000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (910, N'DEVILLE (4093)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (912, N'DEVILLE (5000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (913, N'DEVILLE LIMUZIN (5200)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (914, N'ELDORADO (3704)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (915, N'ELDORADO (4562)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (916, N'ELDORADO (4565)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (917, N'ELDORADO (4600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (918, N'ELDORADO TOURING C (4565)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (919, N'ELDORADO BIARIZ (4893)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (920, N'ELDORADO (4900)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (921, N'ELDORADO (5000)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (922, N'ELDORADO (5500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (923, N'ELDORADO (5700)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (924, N'ELDORADO (5737)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (925, N'ELDORADO (6600)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (926, N'ELDORADO (7025)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (927, N'ELDORADO (7200)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (928, N'ELDORADO (8200)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (929, N'ELDORADO (8199)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (930, N'ELDORADO CABRIO (8198)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (931, N'ELDORADO CONVERTIBLE (5200)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (932, N'ELDORADO USTU ACILIR KAPANIR (4500)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (933, N'CONVERTIBLE 2495', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (934, N'BIARRITZ (2001)', 2)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (935, N'STEYJIN (1600)', 83)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (936, N'STEYJIN (4033)', 83)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (937, N'2 KAPILI (3800)', 83)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (938, N'2 KAPILI (5000)', 83)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (939, N'VENTURE 3.4', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (940, N'CHECKER (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (941, N'SPOR (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (942, N'ACIK KASA KAMYONET (2000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (943, N'KAMYONET (3208)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (944, N'K.KASA KAMYONET K14 ARAZİ (3978)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (945, N'APACHE ACIK KASA KAMYONET (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (946, N'APACHE KAMYONET (1800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (947, N'APACHE KAMYONET (1958)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (948, N'PIKAP (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (949, N'PICK UP (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (950, N'TENEZZUH (4250)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (951, N'DELUX (1595)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (952, N'DELUX (1598)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (953, N'DELUX (1790)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (954, N'DELUX (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (955, N'DELUX (3762)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (956, N'DELUX (3767)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (957, N'DELUX (3787)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (958, N'DELUX (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (959, N'DELUX (3859)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (960, N'DELUX (5074)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (961, N'DELUX (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (962, N'DELUX (1900)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (963, N'DELUX (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (964, N'ST (1500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (965, N'LUMINA (3100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (966, N'LUMINA (3400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (967, N'LUMINA (3800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (968, N'LUMINA (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (969, N'BISCAYNE (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (970, N'BISCAYNE (3800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (971, N'BISCAYNE (3300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (972, N'BISCAYNE (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (973, N'BISCAYNE (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (974, N'BISCAYNE (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (975, N'BISCAYNE (2598)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (976, N'BISCAYNE (2481)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (977, N'BISCAYNE (2100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (978, N'BISCAYNE (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (979, N'BISCAYNE STW (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (980, N'CUSTOM DELUX (1995)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (981, N'CUSTOM DELUX (3751)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (982, N'CUSTOM DELEVELO (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (983, N'CUSTOM DELUX (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (984, N'CUSTOM DELUX 10 (6200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (985, N'CUSTOM DELUX (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (986, N'CUSTOM DELUX 10 (5750)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (987, N'CUSTOM DELUX 10 (5000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (988, N'CUSTOM DELUX 10 (1868)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (989, N'CUSTOM DELUX (2972)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (990, N'NOVA CONCOURS (4096)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (991, N'NOVA CONCOURS (4093)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (992, N'NOVA CONCOURS (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (993, N'CONCOURS (5000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (994, N'CONCOURS (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (995, N'CONCOURS (3762)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (996, N'CONCOURS (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (997, N'CONCOURS (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (998, N'NOVA CONCOURS (3475)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (999, N'NOVA CONCOURS (6100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1000, N'NOVA CONCOURS (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1001, N'NOVA CONCOURS (5500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1002, N'NOVA CONCOURS (5100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1003, N'CONCOURS (3000)', 48)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1004, N'NOVA CONCOURS (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1005, N'NOVA CONCOURS (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1006, N'NOVA CONCOURS (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1007, N'NOVA CONCOURS (1900)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1008, N'NOVA CONCOURS (1800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1009, N'NOVA CONCOURS (1600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1010, N'NOVA CUSTOM (2000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1011, N'NOVA CUSTOM (2297)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1012, N'NOVA CUSTOM (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1013, N'NOVA CUSTOM (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1014, N'NOVA CUSTOM (3800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1015, N'NOVA CUSTOM (4100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1016, N'NOVA CUSTOM (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1017, N'NOVA CUSTOM (5850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1018, N'NOVA CUSTOM (5200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1019, N'NOVA (1600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1020, N'NOVA (1300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1021, N'NOVA (1998)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1022, N'NOVA (2000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1023, N'NOVA (2100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1024, N'NOVA (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1025, N'NOVA (2400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1026, N'NOVA (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1027, N'NOVA (2499)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1028, N'NOVA (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1029, N'NOVA (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1030, N'NOVA (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1031, N'NOVA (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1032, N'NOVA (3400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1033, N'NOVA (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1034, N'NOVA (4293)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1035, N'NOVA (4200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1036, N'NOVA (4093)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1037, N'NOVA (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1038, N'NOVA (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1039, N'NOVA (3800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1040, N'NOVA (4785)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1041, N'NOVA (5200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1042, N'NOVA (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1043, N'NOVA (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1045, N'IMPALA SS (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1046, N'IMPALA (4998)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1047, N'IMPALA (4783)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1048, N'IMPALA (4800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1049, N'IMPALA (4638)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1050, N'IMPALA (4640)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1051, N'IMPALA SS (2000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1052, N'IMPALA SS (4700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1053, N'IMPALA (4600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1054, N'IMPALA (4500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1055, N'IMPALA (3700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1056, N'IMPALA (3750)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1057, N'IMPALA (3767)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1058, N'IMPALA (3768)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1059, N'IMPALA (3769)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1060, N'IMPALA (3770)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1061, N'IMPALA (3770) USTU ACIK SPOR', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1062, N'IMPALA (3000) USTU ACIK ', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1063, N'IMPALA (3791)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1064, N'IMPALA (3800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1065, N'IMPALA (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1066, N'IMPALA (3860)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1067, N'IMPALA (3875)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1068, N'IMPALA (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1069, N'IMPALA (3600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1070, N'IMPALA (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1071, N'IMPALA (2900)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1072, N'IMPALA (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1073, N'IMPALA (5000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1074, N'IMPALA (4050)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1075, N'IMPALA (4093)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1076, N'IMPALA (4300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1077, N'IMPALA (4230)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1078, N'IMPALA (4200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1079, N'IMPALA (4155)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1080, N'IMPALA (4183)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1081, N'TERRANO II TD 5DR A/T', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1082, N'TERRANO II TD 4x4 SE 5 KAPI OV', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1083, N'TERRANO II TD 2.4 4x4 SE 5 KAPI', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1084, N'TERRANO MT', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1085, N'TERRANO SE 2.7 DZ 5DR HATCBACK', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1086, N'TERRANO TD 2.7', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1087, N'TERRANO 2.7 D', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1088, N'TERRANO II TDI ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1089, N'TERRANO II 2.7 ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1090, N'INFINITI I30 OV', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1091, N'INFINITI I30', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1092, N'INFINITI QX4 4x4 (3275)', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1093, N'INFINITI Q45', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1094, N'PRIMERA 2.0 SE SEDAN', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1095, N'PRIMERA 2.0 SE ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1096, N'PRIMERA 1998 ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1097, N'PRIMERA SLX D 2174 ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1098, N'PRIMERA 2.2 DIZEL ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1099, N'PATHFINDER AT 4X4 WD', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1100, N'PATHFINDER SE AT 3.3', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1101, N'PATHFINDER 3.3 4X4', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1102, N'PATHFINDER JEEP 2.4', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1103, N'PATROL SLG 4.2', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1104, N'PATROL STATION WAGON 4.2', 30)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1105, N'PATROL 4.2 DIZEL', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1106, N'PATROL 3.0 TDI AT', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1107, N'PATROL 4.5 GL', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1108, N'PATROL 4X4 2826', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1109, N'PATROL JEEP 3957', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1110, N'PATROL STATION WAGON D 3.3 ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1111, N'PATROL S.T. HIGH ROFF', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1112, N'PATROL GR 4.2 4169 LPG''Lİ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1113, N'PATROL GR 4X4 2800', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1114, N'PATROL GL 2900', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1115, N'PATROL 2.8', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1116, N'PATROL 2.8 TDI', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1117, N'PATROL STATION WAGON 2.8', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1118, N'PATROL HARDTOP 2.81', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1119, N'PATROL DIESEL 3.3', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1120, N'PATROL STATION 4x4 3200', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1121, N'CAPRICE (5738)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1122, N'CAPRICE 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1123, N'CAPRICE STAR (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1124, N'CORVETTE (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1125, N'CORVETTE COUPE 5.4', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1126, N'CORVETTE COUPE (5727)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1127, N'CORVETTE 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1128, N'CORVETTE COUPE 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1129, N'CORVETTE (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1130, N'CORVETTE CONVERTIBLE 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1131, N'CORVETTE CONVERTIBLE (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1132, N'STRINGRAY CORVETTE 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1133, N'CORVETTE COUPE (6000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1134, N'CORVETTE 6.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1135, N'CORVETTE (7443)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1136, N'CORVETTE 4.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1137, N'CORVETTE (4638)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1138, N'CORVETTE (4339)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1139, N'CORVETTE 4.2', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1140, N'CORVETTE CONVERTIBLE (5360)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1141, N'CORVETTE CABRIO (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1142, N'SUBURBAN SCOTSDALE 4.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1143, N'SUBURBAN 4.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1144, N'SUBURBAN 4.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1145, N'SUBURBAN 4.8', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1146, N'SUBURBAN 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1147, N'SUBURBAN 2500 LT 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1148, N'SUBURBAN 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1149, N'SUBURBAN 5.2', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1150, N'SUBURBAN COSTUM LUX (5298)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1151, N'SUBURBAN CARRYALL 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1152, N'SUBURBAN 2500 SLT 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1153, N'SUBURBAN 6.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1154, N'SUBURBAN (6200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1155, N'SUBURBAN (7400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1156, N'SUBURBAN 1500 (3100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1157, N'SUBURBAN BINEK (4093)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1158, N'ARAZİ TAŞITI STW 4.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1159, N'CAMARO 7.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1160, N'CAMARO (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1161, N'CAMARO 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1162, N'CAMARO Z28 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1163, N'CAMARO Z28 CABRIO 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1164, N'CAMARO Z28 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1165, N'CAMARO Z28 4.8', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1166, N'CAMARO Z28 (3791)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1167, N'CAMARO 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1168, N'CAMARO SPORT (4998)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1169, N'CAMARO CABRIOLET (3350)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1170, N'CAMARO CABRIOLET (3400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1171, N'CAMARO RS SS (5360)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1172, N'CAMARO (3704)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1173, N'CAMARO (3794)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1174, N'CAMARO 4.8', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1175, N'CAMARO (3791)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1176, N'CAMARO 3.8', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1177, N'CAMARO 3.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1178, N'CAMARO 3.4', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1179, N'CAMARO (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1180, N'CAMARO 3.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1181, N'CAMARO 2.8', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1182, N'CAMARO 2.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1183, N'CAMARO 2.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1184, N'CAMARO 1.9', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1185, N'TRANS SPORT 3.4', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1186, N'TAHOE BLAZER SPORT 4WD 5.2', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1187, N'TAHOE 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1188, N'TAHOE 5.3', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1189, N'TAHOE (5298)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1190, N'TAHOE (5200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1191, N'TAHOE 4.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1192, N'TAHOE 4495', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1193, N'TAHOE (3700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1194, N'BLAZER 4.2', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1195, N'BLAZER 4.3', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1196, N'BLAZER S10 ', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1197, N'BLAZER 4.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1198, N'K  BLAZER 1500 5733', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1199, N'K 5 BLAZER 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1200, N'K 5 BLAZER 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1201, N'BLAZER KS 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1202, N'K 5 BLAZER 1500 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1203, N'KS BLAZER ARAZI TASITI 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1204, N'BLAZER K 5 JEEP SILVERADO 5.7', 48)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1205, N'PICK UP SILVERADO 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1206, N'BLAZER K 5 SILVERADO (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1207, N'BLAZER SILVERADO (5734)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1208, N'BLAZER 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1209, N'BLAZER 4x4 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1210, N'BLAZER LT 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1211, N'BLAZER 6.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1212, N'BLAZER 4x4 D 6.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1213, N'BLAZER 5.2', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1214, N'BLAZER (4970)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1215, N'BLAZER SPORT 4WD (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1216, N'BLAZER 4x4 (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1217, N'BLAZER (1845)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1218, N'SILVERADO (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1219, N'K-5 SILVERADO 2500', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1220, N'SILVERADO ES BLAZER (5250)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1221, N'KAMYONET SILVERADO (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1222, N'SILVERADO 1500 S 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1223, N'KAMYONET SILVERADO (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1224, N'KAMYONET SILVERADO (5300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1225, N'BLAZER C14 (4600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1226, N'CHEVELLE MALIBU (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1227, N'CHEVELLE MALIBU (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1228, N'MALIBU CHEVELLE SS (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1229, N'MALIBU CHEVELLE SS (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1230, N'MALIBU (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1231, N'MALIBU (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1232, N'MALIBU (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1233, N'MALIBU 2.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1234, N'MALIBU (2001)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1235, N'MALIBU (2180)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1236, N'MALIBU (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1237, N'MALIBU (2850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1238, N'MALIBU (2890)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1239, N'MALIBU (2960)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1240, N'MALIBU 3.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1241, N'MALIBU SEDAN (3100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1242, N'MALIBU SEDAN LS (3100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1243, N'MALIBU LS SEDAN (3135)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1244, N'MALIBU (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1245, N'MALIBU (3295)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1246, N'MALIBU V6 (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1247, N'MALIBU 3.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1248, N'MALIBU CLASSIC 3.5', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1249, N'MALIBU 3780', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1250, N'MALIBU (4080)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1251, N'MALIBU (4093)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1252, N'MALIBU (3798)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1253, N'MALIBU (3800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1254, N'MALIBU CLASSIC (3798)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1255, N'MALIBU CLASSIC (4093)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1256, N'MALIBU 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1257, N'MALIBU CL 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1258, N'MALIBU CLASSIC 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1259, N'MALIBU (5250)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1260, N'MALIBU 5.4', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1261, N'MALIBU 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1262, N'MONTE CARLO (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1263, N'MONTE CARLO Z 3.4', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1264, N'MONTE CARLO (3135)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1265, N'MONTE CARLO (5001)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1266, N'MONTE CARLO (5002)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1267, N'MONTE CARLO 4.2', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1268, N'ASTROVAN 4.3', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1269, N'ASTROVAN LT AWD 4.3', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1270, N'IMPERIAL (3300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1271, N'GMC S-15 JIMMY 4600', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1272, N'BERETTA (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1273, N'REANOMOBIL (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1274, N'STANDART A-2 1.6', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1275, N'BEAVUVILLE KAMYONET (3859)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1276, N'BİNEK (2500)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1277, N'GRAND VAGONER (5200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1278, N'GRAND CHEROKEE ORVIS (5200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1279, N'SEBRING 2.7 ', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1280, N'SARATOGA (2500)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1281, N'STRATUS (2500)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1282, N'EAGLE (USA)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1283, N'EAGLE TALON (1997)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1284, N'LHS 3.5', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1285, N'LE BARON CX (3000)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1286, N'LE BARON SARTOGALE (2972)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1287, N'LE BARON LX CABRIOLEZ (2497)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1288, N'LE BARON GTC (2960)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1289, N'IMPERIAL (5210)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1290, N'VISION (3498)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1291, N'VISION (3523)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1292, N'NEON SPORT (1998)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1293, N'NEWYORKER (7040)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1294, N'NEWYORKER (2572)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1295, N'NEWYORKER 3.8', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1296, N'NEWYORKER (3301)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1297, N'ARAZİ TAŞITI (2250)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1298, N'110-70 ARAZİ TAŞITI 2495 LA', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1299, N'110-70 ARAZİ TAŞITI', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1300, N'110-70 PICK UP DIZEL ', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1301, N'ARAZİ TAŞITI 3900', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1302, N'STATION WAGON 3500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1303, N'ARAZİ 3470', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1304, N'ARAZİ 3532', 6)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1305, N'ARAZİ TAŞITI (3500)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1306, N'ARAZİ TAŞITI (3947)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1307, N'ARAZİ TAŞITI SW 2000', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1308, N'ARAZİ TAŞITI SW 3528', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1309, N'RANGE ROVER 4200 SC', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1310, N'RANGE ROVER 3900', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1311, N'RANGE ROVER 3525', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1312, N'109 2A 2498', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1313, N'2.5 D SE', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1314, N'2256', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1315, N'JEEP 1998', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1316, N'STATION WAGON ARAZİ TAŞITI (1898)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1317, N'STATION WAGON (2001)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1318, N'ARAZI TAŞITI (2000)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1319, N'JEEP (2300)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1320, N'ARAZİ TAŞITI 1600', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1321, N'ARAZİ TAŞITI JEEP 3950', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1322, N'FREELANDER 1.8 L', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1323, N'FREELANDER 5DR (1796)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1324, N'CONTINENTAL OV 4800', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1325, N'CONTINENTAL OV 4600', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1326, N'CONTINENTAL 4900', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1327, N'CONTINENTAL 4600', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1328, N'CONTINENTAL (4500)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1329, N'CONTINENTAL 3780', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1330, N'CONTINENTAL 7000', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1331, N'CONTINENTAL (7044)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1332, N'CONTINENTAL 3500', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1333, N'CONTINENTAL (3200)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1334, N'CONTINENTAL 3000', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1335, N'CONTINENTAL 2900', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1336, N'IMPALA (4095)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1337, N'IMPALA (3682)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1338, N'IMPALA (5790)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1339, N'IMPALA (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1340, N'IMPALA (5702)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1341, N'IMPALA (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1342, N'IMPALA (4995)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1343, N'IMPALA (5948)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1344, N'IMPALA (3350)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1345, N'IMPALA (3300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1346, N'IMPALA (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1347, N'IMPALA (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1348, N'IMPALA (2350)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1349, N'IMPALA (2000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1350, N'IMPALA (2001)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1351, N'IMPALA (2200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1352, N'IMPALA (2700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1353, N'IMPALA (2795)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1354, N'IMPALA (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1355, N'IMPALA (2850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1356, N'IMPALA (2590)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1357, N'IMPALA (2501)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1358, N'IMPALA (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1359, N'IMPALA (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1360, N'IMPALA (2400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1361, N'IMPALA (2398)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1362, N'IMPALA (2100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1364, N'IMPALA (1980)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1365, N'IMPALA (1998)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1366, N'IMPALA (1997)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1367, N'IMPALA (1900)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1368, N'IMPALA (1788)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1369, N'IMPALA (1800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1370, N'IMPALA (1600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1371, N'IMPALA (1598)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1372, N'IMPALA (1530)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1373, N'IMPALA (1299)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1374, N'IMPALA CONVERTIBLE (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1375, N'IMPALA CONVERTIBLES (3400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1376, N'IMPALA CONVERTIBLES (4083)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1377, N'IMPALA (USTU ACILIR KAPANIR) (7000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1378, N'ST WAGON (3751)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1379, N'ST VVG (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1380, N'STWG (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1381, N'STWG (3700) DIZEL', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1382, N'ST WAGON (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1383, N'STW PANEL (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1384, N'STW LPG LI (2001)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1385, N'STATION (2000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1386, N'IMPERIAL 4DR (5500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1387, N'BELAIR (6900)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1388, N'BELAIR (5000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1389, N'BELAIR (4100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1390, N'BELAIR (4093)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1391, N'BELAIR (4095)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1392, N'BELAIR (3600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1393, N'BELAIR (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1394, N'BELAIR (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1395, N'BELAIR (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1396, N'BELAIR (2565)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1397, N'BINEK 2 KAPILI (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1398, N'2 KAPILI (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1399, N'2 KAPILI (3700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1400, N'BINEK (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1401, N'4 KAPILI (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1402, N'4 KAPILI (2550)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1403, N'4 KAPILI (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1404, N'4 KAPILI (3769)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1405, N'BINEK (1998)', 48)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1406, N'BINEK (2001)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1407, N'BINEK (2190)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1408, N'BINEK (2350)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1409, N'BINEK (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1410, N'BINEK (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1411, N'BINEK (3859)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1412, N'SEDAN (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1413, N'SEDAN (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1414, N'BELAIR (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1416, N'BELAIR (2592)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1417, N'DELUX BELAIR (2592)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1418, N'BELAIR (1988)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1419, N'BELAIR (1956)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1420, N'BELAIR (1299)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1421, N'BELAIR (1381)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1422, N'BELAIR (1500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1423, N'BELAIR (1587)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1424, N'BELAIR (1585)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1425, N'BELAIR (1600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1426, N'BELAIR (1699)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1427, N'BELAIR (1700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1428, N'BELAIR (1730)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1429, N'BELAIR (1800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1430, N'BELAIR (1750)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1431, N'BELAIR (4644)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1432, N'BELAIR (4564)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1433, N'BELAIR (4800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1434, N'BELAIR (5097)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1435, N'BELAIR (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1436, N'BELAIR (3850)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1437, N'BELAIR (3700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1438, N'BELAIR (3782)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1439, N'BELAIR (3768)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1440, N'BELAIR (3770)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1441, N'BELAIR (3860)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1442, N'BELAIR (3849)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1443, N'BELAIR (3800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1444, N'BELAIR (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1445, N'BELAIR 4 KAPI (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1446, N'BELAIR (2900)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1447, N'BELAIR (2998)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1448, N'BELAIR (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1449, N'BELAIR (2000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1450, N'BELAIR (2297)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1451, N'BELAIR (2288)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1452, N'BELAIR (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1453, N'BELAIR (2350)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1454, N'BELAIR (2400)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1455, N'BELAIR (3300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1456, N'BELAIR (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1457, N'BELAIR (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1458, N'BELAIR (4600)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1459, N'BELAIR (4300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1460, N'BELAIR (3950)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1461, N'BELAIR (3767)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1462, N'KAPILI BELAIR (3767)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1463, N'BELAIR STW (3772)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1465, N'BELAIR (3270)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1466, N'BELAIR (3459)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1468, N'C10 (3498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1469, N'C10 ARAZİ TAŞITI (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1470, N'C10 ARAZİ TAŞITI (4294)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1471, N'CELEBRITY (3100)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1472, N'VAN WITH STARCRAFT (4300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1473, N'CHEVELLE SS (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1474, N'CHEVELLA (3200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1475, N'CHEVROLET CHEVYVAN 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1476, N'CAPRICE CLASSIC 5.7', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1477, N'CAPRICE CLASSIC 5.2', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1478, N'CAPRICE CLASSIC 5.1', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1479, N'CAPRICE CLASSIC 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1480, N'CAPRICE CLASSIC (5001)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1481, N'CAPRICE COMBI CLASSIC 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1482, N'CAPRICE CLASSIC IMPERIAL 5.0', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1483, N'CAPRICE CLASSIC (4389)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1484, N'CAPRICE CLASSIC (4500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1485, N'CAPRICE CLASSIC (4700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1486, N'CAPRICE CLASSIC (3998)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1487, N'CAPRICE CLASSIC (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1488, N'CAPRICE CLASSIC (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1489, N'CAPRICE CLASSIC (3000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1490, N'CAPRICE CLASSIC (2995)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1491, N'CAPRICE CLASSIC (2980)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1492, N'CAPRICE CLASSIC (2500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1493, N'CAPRICE CLASSIC (2398)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1494, N'CAPRICE CLASSIC (2300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1495, N'CAPRICE CLASSIC (2200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1496, N'CAPRICE CLASSIC (2010)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1497, N'CAPRICE CLASSIC (1898)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1498, N'CAPRICE (2200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1499, N'CAPRICE (2498)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1500, N'CAPRICE (2670)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1501, N'CAPRICE (2800)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1502, N'CAPRICE CLASSIC (3791)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1503, N'CAPRICE (3791)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1504, N'CAPRICE (3500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1505, N'CAPRICE (3300)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1506, N'CAPRICE (4000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1507, N'CAPRICE (4500)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1508, N'CAPRICE (4300)', 48)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1509, N'CAPRICE (5000)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1510, N'CAPRICE (5200)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1511, N'CAPRICE (5733)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1512, N'CAPRICE (5700)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1513, N'CAPRICE (6554)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1514, N'CAPRICE (8554)', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1515, N'OMEGA 5.6', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1516, N'OMEGA 4300', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1517, N'OMEGA 4200', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1518, N'HARDTOP SEDAN 4500', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1519, N'BRAVADA 4.3 ', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1520, N'CUTLASS 5.7 ', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1521, N'CUTLASS CIERA S 3300', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1522, N'CUTLASS SALOON  7467', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1523, N'CUTLASS SALOON  4500', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1524, N'CUTLASS SALOON  4001', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1525, N'CUTLASS SALON  (3200)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1526, N'CUTLASS (3100)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1527, N'CUTLASS SALON  (5500)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1528, N'CUTLASS SALOON  5.7 ', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1529, N'STARLINE 5200', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1530, N'SILHOUETTE WAG (3200)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1531, N'SILHOUETTE WAG 3600', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1532, N'SUPREME 7457', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1533, N'CUTLASS 7264', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1534, N'TORONADA 7446', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1535, N'CUTLASS SUPREME 6500', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1536, N'CUTLASS 7450', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1537, N'CUTLASS 4500 SEDAN', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1538, N'CUTLASS SUPREME 2900', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1539, N'CUTLASS SUPREME 2693', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1540, N'CUTLASS F85 (5685)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1541, N'CUTLASS CRUISER (2800)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1542, N'CUTLASS 2600', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1543, N'CUTLASS 2501', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1544, N'CUTLASS 2000', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1545, N'CUTLASS 1.5', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1546, N'CUTLASS-HURST 4.0', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1547, N'CALAIS 4000', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1548, N'BİNEK 7600', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1549, N'BİNEK 5200', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1550, N'BINEK (5311)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1551, N'V88 (6500)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1552, N'BİNEK 88 4.3', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1553, N'BİNEK (4300)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1554, N'VOYAGER DIZEL (2501)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1555, N'VOYAGER 2.5 D', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1556, N'VOYAGER 2.5 TDI LE', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1557, N'VOYAGER GRAND DIZEL 2.5 ', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1558, N'VOYAGER 2.5 LE', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1559, N'VOYAGER 2.5 SE', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1560, N'GRAND VOYAGER LE AWD (3800)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1561, N'GRAND VOYAGER (3800)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1562, N'GRAND VOYAGER (3853)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1563, N'GRAND VOYAGER (3300)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1564, N'GRAND VOYAGER AWD (2776)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1565, N'GRAND VOYAGER 3.3 LE', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1566, N'VOYAGER 3.3 LX', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1567, N'VOYAGER 3.3 LE', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1568, N'VOYAGER 3.3 ', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1569, N'VOYAGER (2945)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1570, N'VOYAGER 2.5', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1571, N'VOYAGER SE 2.4', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1572, N'TOWN COUNTRY LXI (3800)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1573, N'TOWN COUNTRY (3800)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1574, N'TOWN COUNTRY (2200)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1575, N'CONCORDE 3.5', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1576, N'CONCORDE 3.1', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1577, N'CORDOBA (5898)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1578, N'300 M 3.5', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1579, N'300 M (3518)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1580, N'TORNEDA (2700)', 7)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1581, N'TORNEDA 110 83 (2700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1582, N'GRAND CHEROKEE LAREDO (5700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1583, N'GRAND CHEROKEE LAREDO (5200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1584, N'GRAND CHEROKEE LAREDO (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1585, N'GRAND CHEROKEE (4298)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1586, N'GRAND CHEROKEE (2499)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1587, N'JEEP CHEROKEE LIMITED (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1588, N'JEEP CHEROKEE LIMITED (3700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1589, N'CHEROKEE LIMITED (3700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1590, N'JEEP CHEROKEE LIMITED (3960)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1591, N'JEEP CHEROKEE TD (2100)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1592, N'JEEP CHEROKEE (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1593, N'JEEP CHEROKEE CLASSIC (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1594, N'CHEROKEE 4x4 CLASSIC (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1595, N'CHEROKEE (5698)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1596, N'CHEROKEE (5684)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1597, N'CHEROKEE (3500)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1598, N'CHEROKEE (3518)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1599, N'CHEROKEE (3910)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1600, N'CHEROKEE (3919)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1601, N'CHEROKEE (3300)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1602, N'CHEROKEE (2910)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1603, N'CHEROKEE (2766)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1604, N'CHEROKEE (2700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1605, N'CHEROKEE (2464)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1606, N'CHEROKEE (2501)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1607, N'CHEROKEE LIMITED 2.8 CRD', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1608, N'GRAND CHEROKEE (2429)', 71)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1609, N'LAREDO (3956)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1610, N'CHEROKEE LAREDO (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1611, N'CHEROKEE LAREDO (3998)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1612, N'CHEROKEE LAREDO (3700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1613, N'CHEROKEE LAREDO (3523)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1614, N'CHEROKEE LAREDO (3552)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1615, N'CHEROKEE COUNTRY (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1616, N'CHEROKEE SPORT (4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1617, N'CHEROKEE SPORT (5200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1618, N'GRAND CHEROKEE LTD.(4900)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1619, N'GRAND CHEROKEE LTD.(4400)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1620, N'GRAND CHEROKEE LIMITED (4400)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1621, N'GRAND CHEROKEE LTD.(4000)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1622, N'GRAND CHEROKEE LTD.(3840)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1623, N'GRAND CHEROKEE LTD.(3700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1624, N'GRAND CHEROKEE LTD (3596)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1625, N'GRAND CHEROKEE LIMITED (3494)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1626, N'GRAND CHEROKEE LTD.(3300)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1627, N'GRAND CHEROKEE LTD.(3200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1628, N'GRAND CHEROKEE LTD.3.1 TD', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1629, N'GRAND CHEROKEE LTD.3.1 TDI', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1630, N'GRAND CHEROKEE LTD. 3.0', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1631, N'GRAND CHEROKEE LIMITED 2.8 DIZEL', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1632, N'GRAND CHEROKEE (5900)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1633, N'GRAND CHEROKEE LTD. LX (5900)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1634, N'GRAND CHEROKEE LTD.(5900)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1635, N'GRAND CHEROKEE LIMITED 5.7', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1636, N'GRAND CHEROKEE LTD.(5500)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1637, N'GRAND CHEROKEE LTD.(5400)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1638, N'GRAND CHEROKEE LTD.(5200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1639, N'GRAND CHEROKEE LIMITED (5200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1640, N'GRAN WAGONEER (5200)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1641, N'GRAND CHEROKEE LTD.(5100)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1642, N'GRAND CHEROKEE LIM (4998)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1643, N'GRAND CHEROKEE LTD.(4700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1644, N'GRAND CHEROKEE LIMITED (4700)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1645, N'GRAND CHEROKEE 4.0', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1646, N'GRAND CHEROKEE CLASSIC (3958)', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1647, N'GRAND CHEROKEE ltd. 2.7 CRD', 71)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1648, N'VAGONER LTD (5200)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1649, N'VAGONER 4 WEEL DRIVER (1500)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1650, N'WRANGLER SAHARA (4000)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1651, N'WRANGLER TJ (3960)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1652, N'WRANGLER 4.0', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1653, N'WRANGLER LIMITED 4.0', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1654, N'WRANGLER (3994)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1655, N'WRANGLER LAREDO ST. (4235)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1656, N'WRANGLER (5100)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1657, N'WRANGLER (5200)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1658, N'WRANGLER (2464)', 72)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1659, N'JJL (2464)', 81)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1660, N'L 400 (WAGOONER) (2501)', 7)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1661, N'CJ8 (2199)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1662, N'CJ8 (2300)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1663, N'CJ8 (2500)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1664, N'CJ8 (2600)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1665, N'CJ8 (3950)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1666, N'CJ8 (3900)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1667, N'CJ8 (5700)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1668, N'CJ8 (4700)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1669, N'CJ8 (4200)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1670, N'CJ8 (4000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1671, N'CJ5 4WD (1500)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1672, N'CJ5 (1570)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1673, N'CJ5 (1600)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1674, N'CJ5 (1991)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1675, N'CJ5 (1996)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1676, N'CJ5 (1998)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1677, N'CJ5 (2195)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1678, N'CJ5 (2000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1679, N'CJ5 (2001)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1680, N'CJ5 (2200)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1681, N'CJ5 (2300) DIZEL', 33)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1682, N'CJ5 (2300)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1683, N'CJ5 (2400)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1684, N'CJ5 (2402)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1685, N'CJ5 (2496)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1686, N'CJ5 (2498)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1687, N'CJ5 (2500)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1688, N'CJ5 (2501)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1689, N'CJ5 (2596)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1690, N'CJ5 (2600)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1691, N'CJ5 (2700)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1692, N'CJ5 (3150)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1693, N'CJ5 (3000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1694, N'CJ5 (3001)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1695, N'CJ5 (3494)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1696, N'CJ5 (3500)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1697, N'CJ5 (3600)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1698, N'CJ5 (3601)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1699, N'CJ5 (3897)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1700, N'CJ5 (3800)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1701, N'CJ5 (3801)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1702, N'CJ5 (4000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1703, N'CJ5 (4200)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1704, N'CJ5 (4226)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1705, N'JEEP 2 KAPILI (4200)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1706, N'CJ5 (4400)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1707, N'CJ5 (5000)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1708, N'CJ7 (5850)', 84)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1709, N'CJ7 JEEP (1900)', 79)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1710, N'CJ6 (5200)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1711, N'CJ6 (1890)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1712, N'CJ6 (2001)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1713, N'CJ6 (2290)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1714, N'CJ6 (2300)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1715, N'CJ6 (2400)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1716, N'CJ6 (2501)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1717, N'CJ6 (2600)', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1718, N'190 DIZEL (1998)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1719, N'190 D (1983)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1720, N'190 D 1885', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1721, N'190 D 1598', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1722, N'190 E 2.6 AMG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1723, N'190 E 2.6', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1724, N'190 E 1.8', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1725, N'280 SL SPOR', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1726, N'280 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1727, N'280 SL CABRIO', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1728, N'280', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1729, N'280 CE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1730, N'280 SLC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1731, N'350 SLC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1732, N'350 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1733, N'350', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1734, N'350 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1735, N'350 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1736, N'380 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1737, N'350 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1738, N'380 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1739, N'380 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1740, N'380 SEC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1741, N'380 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1742, N'450 SLC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1743, N'500 SLC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1744, N'450 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1745, N'450 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1746, N'S 450 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1747, N'S 450 4 MATIC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1748, N'450 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1749, N'450 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1750, N'420 E', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1751, N'E 430 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1752, N'E 420 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1753, N'S 420', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1754, N'S 430', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1755, N'S 430 L', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1756, N'S 420 C', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1757, N'E 420 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1758, N'420 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1759, N'420 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1760, N'400 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1761, N'400 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1762, N'420 SEC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1763, N'300 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1764, N'300 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1765, N'300 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1766, N'300 SEL 6.3', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1767, N'500 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1768, N'500 SL CABRIO', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1769, N'SL 500 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1770, N'420 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1771, N'E 500 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1772, N'500 E', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1773, N'500 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1774, N'500 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1775, N'560 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1776, N'600 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1777, N'500 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1778, N'TAUNUS STATION 3000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1779, N'TAUNUS 2.0 GTS', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1780, N'TAUNUS 2.0 GLS', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1781, N'TAUNUS S (1996)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1782, N'TAUNUS 1.6 GT', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1783, N'TAUNUS 1.6 GL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1784, N'TAUNUS 1.6 ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1785, N'TAUNUS GXL (2168)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1786, N'GXL TAUNUS (2000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1787, N'TAUNUS 2.6 LPG''LI', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1788, N'TAUNUS (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1789, N'TAUNUS 2298', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1790, N'TAUNUS 2000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1791, N'TAUNUS 1998', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1792, N'TAUNUS (1954)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1793, N'TAUNUS 1700', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1794, N'TAUNUS 1600', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1795, N'TAUNUS VL COUPE 2000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1796, N'TENEZZÜH 5000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1797, N'SIERRA (1998)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1798, N'SIERRA (2000)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1799, N'SIERRA 2.0 GL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1800, N'SIERRA 2.0 GLS', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1801, N'SIERRA 2.3 DIZEL ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1802, N'SIERRA 2.3', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1803, N'SIERRA 2.3 GHIA', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1804, N'SIERRA 2.3 DL STW', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1805, N'SCORPIO 2000 GLX ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1806, N'SCORPIO (2985)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1807, N'SCORPIO 2.9', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1808, N'SCORPIO 2.8i', 88)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1809, N'SCORPIO 2.8 GL GHIA', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1810, N'SCORPIO TD (2496)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1811, N'SCORPIO 2.4i GL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1812, N'SCORPIO 2301', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1813, N'SCORPIO 2.3 GHIA', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1814, N'SCORPIO GHIA AUTO (2295)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1815, N'SCORPIO 2.0 GHIA AUTO', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1816, N'SCORPIO 2.0 GHIA', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1817, N'SCORPIO 2.0', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1818, N'SCORPIO GHIA NB (1996)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1819, N'SCORPIO (1998)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1820, N'SIERRA 2.0i GLS', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1822, N'SIERRA 2.0 GL KAT ', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1823, N'F 250 KAMYONET 5000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1824, N'F 250 KAMYONET 3498', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1825, N'F 100 KAMYONET 1862', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1826, N'F 100 KAMYONET 1350', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1827, N'COUNTRY SQUARE (4998)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1828, N'COUNTRY LTD STMG 2551', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1829, N'COUNTRY WAGON 2000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1830, N'SEDAN WAGON 2000', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1831, N'STW (2498)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1832, N'STW (2199)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1833, N'CAPRI 2.3', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1834, N'WINDSTAR 2900', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1835, N'WINDSTAR 3.8 GL', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1836, N'WINDSTAR (3791)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1837, N'WINDSTAR (3800)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1838, N'WINDSTAR 3.0 LXI', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1839, N'F 150 CIFT KABIN PICK UP (5400)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1840, N'RANGER 4x4 (2500)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1841, N'FALCON FUTURA (2300)', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1842, N'FOCUS 1.6i GHIA SW', 88)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1843, N'ARAZİ TAŞITI (2300)', 23)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1844, N'ARAZİ TAŞITI 69 A.M.(2450)', 23)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1845, N'VOLGA GAZ 2.4', 23)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1846, N'SAVANA 5.7', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1847, N'SAVANA CONVARSION VAN 5.7', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1848, N'CONVARSION VAN 5.7', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1849, N'JIMMY 5.7', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1850, N'6.2 AÇIK SAÇ KASALI ARAZİ TAŞITI ', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1851, N'JIMMY 6200 KAPALI KASA ', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1852, N'JIMMY 6.2 KAPALI KASA ', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1853, N'JIMMY 4.3', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1854, N'JIMMY SLT 4.3', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1855, N'JIMMY TYPOON ', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1856, N'YUKON ', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1857, N'YUKON 5.2', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1858, N'YUKON DENALI (5733)', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1859, N'YUKON 5.7', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1860, N'YUKON (5300)', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1861, N'YUKON (6500)', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1862, N'ENVOY 4.3', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1863, N'ENVOY SLT', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1864, N'SAFARI 4.3', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1865, N'SAFARI XT (4292)', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1866, N'SIERRA 4X4 (5700)', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1867, N'SIERRA 4X4 DBL (3500)', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1868, N'SIERRA 3.3', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1869, N'SIERRA 5.5 ÇİFT KABİN KAMYONET', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1870, N'1500 TOURIER ARAZİ TAŞITI 4966 ', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1871, N'SIERRA 1.5 SLE 5700', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1872, N'VANDURA 5.7', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1873, N'VAN 5.7', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1874, N'K-100 ARAZI 44 PICKUP', 31)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1875, N'CR-V 2.0 IES OTM', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1876, N'CR-V 2.0 ILS', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1877, N'LEGEND 3.5', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1878, N'LEGEND 3.2', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1879, N'SHUTTLE 2.2 IES', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1880, N'PASSPORT 3.2 LX', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1881, N'ACCORD 2.0 ILS', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1882, N'ACCORD 2.0 EX ', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1883, N'ACCORD 2.0 ', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1884, N'ACCORD 3.0', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1885, N'CD9 (2155)', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1886, N'PRELUDE (2152)', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1887, N'PRELUDE EX 2.0 16V', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1888, N'CIVIC 1.4 L', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1889, N'CIVIC 1.4 ', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1890, N'CIVIC 1.6 ', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1891, N'CIVIC (1590)', 5)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1892, N'ELANTRA 2.0 GLS', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1893, N'ELANTRA 2.0 GLS OV', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1894, N'ELANTRA 1.8 KLM', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1895, N'EXCELL LS SEDAN', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1896, N'ACCENT 1.3 LS ', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1897, N'ACCENT 1.3 LS SEDAN', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1898, N'ACCENT 1.5 GLS', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1899, N'CENTENNIAL 3000', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1900, N'SONATA 2.0 OV', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1901, N'SONATA 2.0 ', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1902, N'SONATA 2.0 GLS', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1903, N'SONATA 2.5 GLS', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1904, N'SONATA GLS V6 (2972)', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1905, N'GALLOPER 3.0', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1906, N'GRANDEUR XG 30', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1907, N'SANTA FE (2321)', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1908, N'TERRACAN JX 290 (2901) DIZEL', 24)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1909, N'DK 400 5235', 59)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1910, N'DK 400 4235', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1911, N'420', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1912, N'DS 420 LIMUZIN (4235)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1913, N'BINEK 3800', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1914, N'TENEZZÜH 3812', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1915, N'TENEZZUH (3001)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1916, N'DAIMLER 4.2', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1917, N'XJ6 4.0 ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1918, N'DAIMLER 6 LWB (5993)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1919, N'DAIMLER D6 LWB (5000)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1920, N'DAIMLER D6 (5993)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1921, N'DAIMLER 4.0 LWB', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1922, N'DAIMLER 4.0', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1923, N'DAIMLER 4.4', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1924, N'DAIMLER 3.6', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1925, N'DAIMLER DOUBLE SIX 3724', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1926, N'DAIMLER DOUBLE SIX (5343)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1927, N'DAIMLER 4235', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1928, N'DAIMLER 2919', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1929, N'DAIMLER (2918)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1930, N'DAIMLER 5000', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1931, N'BOXER 3600', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1932, N'XJ6 3.2 ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1933, N'XJ6 3.5 ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1934, N'XJ6 5.3', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1935, N'XJ6 5.0', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1936, N'XJ6 4.9', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1937, N'XJ6 4.2 L', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1938, N'XJ6 4.2', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1940, N'XJ6 SOVEREING 3.6', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1941, N'XJ6 SOVEREING 3.2', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1942, N'XJ6 SOVEREING 4.0', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1943, N'SOVEREING 3.6', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (1944, N'SOVEREING 3.8', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2004, N'', 42)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2008, N'SAFRANE 2.1 TD', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2009, N'SAFRANE 2.0 RXE', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2010, N'SAFRANE 2.0', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2011, N'SAFRANE V6 RXT', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2012, N'SAFRANE 2.5', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2013, N'SAFRANE 2.5 RXT', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2014, N'SAFRANE 2.2', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2015, N'SAFRANE (2165)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2016, N'LAGUNA 1.8 16V RXE', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2017, N'LAGUNA 2.0 PRIVILEGE', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2018, N'LAGUNA RXT 2.0', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2019, N'LAGUNA RXE 2.2 D 2188', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2020, N'LAGUNA 1.9 RXE TDI', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2021, N'LAGUNA RXE 2.0 S', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2022, N'LAGUNA RXE 2.0 ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2023, N'LAGUNA BVA (1998)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2024, N'LAGUNA 2.2 DT', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2025, N'LAGUNA 2.2', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2026, N'LAGUNA 3.0 INITIAL OV', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2027, N'LAGUNA 3.2 S', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2028, N'11 TXE 1.7', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2029, N'11 FLASH S 1400', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2030, N'11 GTS 1400', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2031, N'12 TSW (1397)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2032, N'12 STW', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2033, N'12 STW TOROS', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2034, N'12 STW TOROS 1339 5 VT', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2035, N'12 STW TOROS 1339 ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2036, N'R 1339 (12 TX TOROS 5 VT) 1397', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2037, N'12 TOROS', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2038, N'12 TS', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2039, N'12 TX', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2040, N'ESPACE RXT (3000)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2041, N'ESPACE 3.0 DCI', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2042, N'ESPACE (3000)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2043, N'ESPACE 2845', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2044, N'ESPACE V6 RXE 2849', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2045, N'ESPACE 2.2 DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2046, N'ESPACE 2200 DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2047, N'ESPACE 2.2 TD', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2048, N'ESPACE 2.1 TD', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2049, N'ESPACE 2.0 GDRT', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2050, N'ESPACE 2130 BENZİNLİ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2051, N'ESPACE 2088 DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2052, N'ESPACE 2063 DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2053, N'ESPACE 2053', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2054, N'ESPACE (2198)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2055, N'ESCAPE DIZEL (2068)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2056, N'ALPINA A 610 2975', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2057, N'STWG DODGE GÖRÜNÜMLÜ (4980)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2058, N'MEGANE 2.0e RXE', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2059, N'MEGANE 2.0   RXE', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2060, N'MEGANE 2.0   RXT ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2061, N'MEGANE 2.0e RXT ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2062, N'MEGANE RTE 1.9 TDI', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2063, N'MEGANE 1.9 TDI', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2064, N'MEGANE WAGON RTE 1.9 TDI', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2065, N'MEGANE 1.6 E RTA', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2066, N'MEGANE WAGON 1.6 DYNAMIQUE', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2067, N'MEGANE SCENIC 2.0', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2068, N'MEGANE SCENIC RXT 2.0', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2069, N'MEGANE SCENIC 1.9 D', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2070, N'KANGOO EXPRESS 1.9 D', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2071, N'KANGOO EXPRESS 1.9 DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2072, N'KANGOO EXPRESS 1.9 D RL', 25)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2073, N'KANGOO 1.9 D RN', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2074, N'KANGOO EXPRESS  1.9 D RN', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2075, N'KANGOO 1.9 D CONFORT', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2076, N'KANGOO 1.4 RNA ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2077, N'KANGOO 1.4 AC GP', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2078, N'KANGOO 1.4 ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2079, N'TWINGO (1239)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2080, N'CLIO 2.0 16V SPORT ', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2081, N'SCENIC RXT 1.6 16V BVA', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2082, N'VEL SATIS 3.0 DCI', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2083, N'VEL SATIS 3.5', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2084, N'SİLVER SHADOW (6742)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2085, N'SİLVER SHADOW (6748)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2086, N'SİLVER SPRIT ', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2087, N'SİLVER SPRIT 6750', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2088, N'SİLVER SHADOW 6300', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2089, N'SİLVER SHADOW (6750)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2090, N'SİLVER SHADOW 6745', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2091, N'SİLVER SHADOW 5400', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2092, N'SİLVER SHADOW 2001', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2093, N'CONICE / CORVICE (6750)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2094, N'CORNICHE (6750)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2095, N'CORNICHE (6250)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2096, N'CLOUD III (6230)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2097, N'CLOUD (4900)', 57)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2098, N'R42 4600', 32)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2099, N'PROBE 2000', 41)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2100, N'COBRA 6997', 41)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2101, N'9000 GRIFFIN 3.0 V6', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2102, N'9000 T 1.6', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2103, N'9000 CDE 2.0 S', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2104, N'9000 CSE 2.3', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2105, N'9000 CST 2.3', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2106, N'9000 CSI 2.0', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2107, N'9000 CSE 2.0 T ', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2108, N'9000 CSE/LPT 2.0 ', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2109, N'9000 CSET TURBO', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2110, N'9000 CSET', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2111, N'9000 3.0 V6', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2112, N'9-3 2.3 HB', 17)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2113, N'FAVORIT 135L', 68)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2114, N'FORMAN 135L', 68)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2115, N'FELICIA DIZEL (1896)', 68)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2116, N'FELICIA COMBI GLX 1.9D', 68)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2117, N'120 L', 68)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2118, N'MARUTI 796', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2119, N'SWIFT 1.6 GLX ', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2120, N'ALTO GL ', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2121, N'VITARA JLX 1590', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2122, N'VITARA 1.6 JLX', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2123, N'VITARA 2.0', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2124, N'VITARA V6 (1998)', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2125, N'GRAND VITARA 2.5 5K', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2126, N'GRAND VITARA 2.5 ', 12)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2127, N'TAVRIA 1.6', 22)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2128, N'TELCOLINE 4x4 (CIFT KABIN) (1948)', 22)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2129, N'4 RUNNER ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2130, N'CARINA 2.0 ST 191L BEMNKW', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2131, N'AVENSIS 2.0 SEDAN M/T', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2132, N'AVENSIS 2.0 SEDAN', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2133, N'AVENSIS 2.0', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2134, N'CARINA 2.0   ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2135, N'CARINA 2.0  E', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2136, N'CRESSIDA 2.0', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2137, N'COROLLA 1.3 XL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2138, N'COROLLA 1.3 XE', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2139, N'COROLLA 1.6 XEI', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2140, N'COROLLA 1.6 GLI', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2141, N'COROLLA 1.6 GL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2142, N'COROLLA DIZEL (1840)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2143, N'COROLLA 1.4 TERRA A/C', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2144, N'COROLLA VERSO 2.2 D-4D COMFORT', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2145, N'CORONA 2.0 GLI AT ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2146, N'CORONA 2.0 OTM. ABS 20C', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2147, N'CORONA 2.0 GL AC', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2148, N'CORONA 2.0 GL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2149, N'CORONA 2.0 GLI', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2150, N'CORONA XL SEDAN 2.0', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2151, N'CORONA 2.0 XL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2152, N'CORONA 2000', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2153, N'LEXUS GS 300', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2154, N'LEXUS LX 450', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2155, N'LEXUS LX 470', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2156, N'LS 400', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2157, N'LS 430', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2158, N'STATION WAGON (4500)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2159, N'LAND CRUISER D 4D (2982)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2160, N'LAND CRUISER PRADO', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2161, N'LAND CRUISER (4664)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2162, N'LAND CRUISER 100 (4664)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2163, N'LAND CRUISER 100 VX', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2164, N'LAND CRUISER 100 TD (4664)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2165, N'LAND CRUISER TD (4164)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2166, N'LAND CRUISER (4164) DIZEL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2167, N'LAND CRUISER 4156', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2168, N'LAND CRUISER 80 (3956)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2169, N'LAND CRUISER MRU (4664)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2170, N'LAND CRUISER 4500', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2225, N'PATROL 4 WD 3500', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2226, N'PATROL 3224', 30)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2227, N'PATROL 4 WD HARDTOP 3456', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2228, N'PATROL TR160 (3957)', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2229, N'HDRT K 160 HARDTOP 4996', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2230, N'PICK UP 4X4 D/CAB', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2231, N'PICK UP 4X4 GD32  D/CAB SE', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2232, N'PICK UP 4X4 3153', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2233, N'PICK UP 4X4 3.2 SE', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2234, N'PICK UP 4X4 3.2 SKYSTAR', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2235, N'PICK UP 4X4 2488 ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2236, N'DATSUN 4 WD 3956', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2237, N'4 WD HARDTOP 2753', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2238, N'4 WD HARDTOP 2500', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2239, N'DATSUN 280L', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2240, N'DATSUN PATROL 3296', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2241, N'VANETTE CARGO ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2242, N'GRLS 30 (2600)', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2243, N'STWG 1998', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2244, N'QUEST XE 3.0', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2245, N'SERENA 2.3', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2246, N'3000 ZX (2940)', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2247, N'ALMERA 2.2 (DIZEL)', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2248, N'ADMIRAL 2800', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2249, N'ADMIRAL 1998', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2250, N'ASTRA GSI 2.0 16V', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2251, N'ASTRA 1.6 GLS 16V HB', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2252, N'ASTRA 1.6 HB', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2253, N'ASTRA 1.6 NB COMFORT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2254, N'ASTRA 1.7 TD', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2255, N'ASTRA KARAVAN 1.4', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2256, N'ASTRA 1.4', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2257, N'ASTRA 2.2 COUPE', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2258, N'ASTRA CABRIO C20', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2259, N'CORSA SW 1.2 HATCBACK', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2260, N'CORSA SWING 1.6 HB ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2261, N'CORSA 1.6 GSI', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2262, N'BİNEK 4 KAPILI RECORD 1700', 19)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2263, N'MONTEREY 3.1 INTERCOLLER ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2264, N'MONTEREY 3.1', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2265, N'MONTEREY 3.1 TD ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2266, N'MONZA 2500', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2267, N'FRONTERA 2.2 5 KAPI', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2268, N'FRONTERA 2.2', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2269, N'FRONTERA 2.3 DIZEL', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2270, N'FRONTERA 3.2', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2271, N'FRONTERA 3.2 AT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2272, N'VECTRA 2.2 GTS SE', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2273, N'VECTRA 2.0', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2274, N'VECTRA 2.0 CD AT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2275, N'VECTRA 2.0 CD', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2276, N'VECTRA 2.0 CD 16V', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2277, N'VECTRA NB B 2.0 DIZEL', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2278, N'VECTRA 2.0 DTI COMFORT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2279, N'VECTRA 2.0 DIZEL COMFORT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2280, N'VECTRA 2.0 CDX', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2281, N'VECTRA 2.0 CDX AT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2282, N'VECTRA 2.5 CDX', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2283, N'VECTRA 874 W3 GT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2284, N'VECTRA GLS 2.0', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2285, N'VECTRA GLS 2.0 NB', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2286, N'VECTRA 2.0 GLS 16V', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2287, N'VECTRA 2.0 GTS', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2288, N'VECTRA 1.8', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2289, N'VECTRA 1.8 GL', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2290, N'VECTRA 1.6 B', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2291, N'VECTRA AK 1.8 ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2292, N'VECTRA 2.0 GL', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2293, N'VECTRA 2.0i', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2294, N'VECTRA 2.0 GL(FA) OV ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2295, N'VECTRA 2.0 GT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2296, N'VECTRA 1.6i GL/AC', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2297, N'VECTRA 2.2 DTI', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2298, N'4B4 GL (VECTRA)', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2299, N'COMMODORE 2.5 S ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2300, N'COMMODORE 2000', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2301, N'COMMODORE 2300', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2302, N'OMEGA 2.6', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2303, N'OMEGA 2.6i', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2304, N'OMEGA NB 2.6 ELEGANCE ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2305, N'OMEGA KARAVAN 2.0i STW', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2306, N'OMEGA 2.0 ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2307, N'OMEGA 2.0 GLS ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2308, N'OMEGA 3.0i MV6', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2309, N'OMEGA CD X25XE XE ELEGANCE AT 2.5', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2310, N'OMEGA CD X25XE NB AT 2158', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2311, N'OMEGA X 3.0 XE ELEGANCE', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2312, N'OMEGA X 3.0 XE AT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2313, N'OMEGA 2.0 CD', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2314, N'OMEGA 2.0i CD 16V', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2315, N'OMEGA 2.5 TD', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2316, N'OMEGA 2.5', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2317, N'OMEGA 2.5 CD', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2318, N'OMEGA 2.5 CD/AT/LT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2319, N'OMEGA 2.5 AT SR', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2320, N'OMEGA (2497) DIZEL', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2321, N'OMEGA 3.2', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2322, N'OMEGA 2.0i AT SR', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2323, N'OMEGA AT CARAVAN', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2324, N'OMEGA 2935', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2325, N'OMEGA SW (2935)', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2326, N'OMEGA 2.5 4 KAPI', 63)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2327, N'OMEGA 2.4', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2328, N'OMEGA 2.3 DIZEL', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2330, N'RECORD 1697', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2331, N'MONZA 2500 E', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2333, N'MONZA (2500) ', 48)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2334, N'MONZA (1600) ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2335, N'KADETT 1397', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2336, N'KADETT 1700', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2337, N'ASCONA 2001', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2338, N'ASCONA 2000', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2339, N'ASCONA 1981', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2340, N'ASCONA B 1.9', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2341, N'ASCONA 1.9 S', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2342, N'ASCONA 1.6 S LS GL GLS ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2343, N'ASCONA DIZEL (1997)', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2344, N'RECORD 2.3 DIZEL GLS', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2345, N'RECORD CL 1879', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2346, N'RECORD 1700', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2347, N'RECORD (1800)', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2348, N'RECORD 1900', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2349, N'RECORD 2000 S', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2350, N'RECORD (1963)', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2351, N'RECORD 2000', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2352, N'RECORD 2000 E', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2353, N'RECORD 2200', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2354, N'KAPITAN 2000', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2355, N'CALIBRA TURBO 4X4 1996', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2356, N'COMMODORE CUPE 2.0', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2357, N'SINTRA 2.2', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2358, N'SENATOR A 2500', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2359, N'SENATOR 3000S (2969)', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2360, N'SENATOR 3.0i KAT', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2361, N'SENATOR 3.0i', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2362, N'SENATOR 3.6 iAL', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2363, N'SENATOR 3.0', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2364, N'SENATOR 2.8 ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2365, N'SENATOR 2.6 ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2366, N'SENATOR 2.0 ', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2367, N'OLYMPIA 1700', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2368, N'ZAFIRA (1698)', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2369, N'ZAFIRA 2.2 DTI', 63)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2370, N'STARFIRE (4500)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2371, N'DELTA 4300', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2372, N'DELTA 88 ROYALE (3786)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2373, N'DELTA (2650)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2374, N'OMEGA 2 KAPILI 5000', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2375, N'OMEGA 3500', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2376, N'OMEGA (2500)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2377, N'OMEGA 2001', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2378, N'OMEGA 2000', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2379, N'LAND CRUISER 80 A/T 4299', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2380, N'LAND CRUISER 80 VX 4477 A/T', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2381, N'LAND CRUISER 80 VX 4477', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2382, N'LAND CRUISER 80 VX AT (4367)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2383, N'LAND CRUISER 4477', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2384, N'LAND CRUISER 4WD (4477)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2385, N'LAND CRUISER 100 4664', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2386, N'LAND CRUISER 4664', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2387, N'JEEP LAND CRUISER (5200) DIZEL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2388, N'LAND CRUISER 4200 DIZEL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2389, N'LAND CRUISER 4200', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2390, N'LAND CRUISER 4300', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2391, N'LAND CRUISER 4164', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2392, N'LAND CRUISER 4146', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2393, N'LAND CRUISER STW 4x4 (4164)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2394, N'LAND CRUISER D 4164', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2395, N'LAND CRUISER 4764', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2396, N'LAND CRUISER 4000 ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2397, N'LAND CRUISER STW 4x4 (2800) DIZEL', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2398, N'J8 LAND CRUISER 4477 ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2399, N'LAND CRUISER BJ60 4x4 (2840)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2400, N'ARAZİ TAŞITI 5 KAPI STATION WAGON (2998)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2401, N'STATION WAGON (3400)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2402, N'STW 4X4 3959', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2403, N'FC OL GC KRS 3682', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2404, N'FJ80L 3956', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2405, N'FJ80 L GCKRS 3956', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2406, N'FJ80 STATION WAGON', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2407, N'JEEP 3956', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2408, N'LAND CRUISER 4.2 STATION WAGON ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2409, N'GX WD LPGLİ (LAND CRUISER) 3956', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2410, N'LAND CRUISER (3990)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2411, N'LAND CRUISER 3980', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2412, N'LAND CRUISER 3956', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2413, N'LAND CRUISER 3431', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2414, N'LAND CRUISER 3451', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2415, N'STATION WAGONER', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2416, N'LAND CRUISER 5000 ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2418, N'4X4 3.2', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2419, N'LAND CRUISER 2800', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2420, N'LAND CRUISER 3955', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2421, N'LAND CRUISER 3996', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2422, N'LAND CRUISER 3995', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2423, N'LAND CRUISER (1998)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2424, N'LAND CRUISER (2400)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2425, N'LAND CRUISER 2495', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2426, N'LAND CRUISER 4230', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2427, N'LAND CRUISER (3953)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2429, N'LAND CRUISER 4x4 (3798)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2430, N'LAND CRUISER 3798', 54)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2431, N'LAND CRUISER 3796', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2432, N'LAND CRUISER 3576', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2433, N'LAND CRUISER 3600', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2434, N'LAND CRUISER 2500', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2435, N'HIGHLANDER (2995)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2436, N'RA6 CRLICA 1998', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2437, N'CAMRY 1832', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2438, N'CAMRY A/T 2164', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2439, N'CAMRY 3.0', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2440, N'X TYPE 2.5 ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2441, N'TYPE (3001 cc)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2442, N'XK8 COUPE 4.0', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2443, N'XK 140 COUPE (3442)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2444, N'XKE (3800)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2445, N'S TYPE 4.0 V8', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2446, N'S TYPE 4.0 ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2447, N'S TYPE 3.0 ', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2448, N'E SERISI 1 (4235)', 59)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2449, N'4610 cc', 45)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2450, N'AMX401 (2001)', 45)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2451, N'TROPPER 2200 ARAZI TAŞITI', 3)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2452, N'TFS 69 HD', 3)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2453, N'TFS 54 H-20 CIFT KABIN K.NET 4x4', 3)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2454, N'GEMINI (1900) DIZEL', 3)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2455, N'C 330 E', 80)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2456, N'FC 330 D 4X4 ÇİFT SIRALI', 80)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2457, N'STATION VAGON (ARAZİ TAŞITI) (2500)', 80)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2458, N'D1100 KAMYONET ARAZI (2500)', 80)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2459, N'PICK UP IH100 (1900)', 80)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2460, N'BINEK (ARAZI TASITI) (1998)', 60)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2461, N'ARAZI TASITI (2499)', 77)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2462, N'CLARUS AT LS (2000)', 29)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2463, N'CARNIVAL 2.9 D', 29)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2464, N'JOICE 20 (1997)', 29)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2465, N'PRIDE (1323)', 29)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2466, N'NIVA 2121 (1569)', 86)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2467, N'NIVA (1690)', 86)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2468, N'SAMARA HATCHBACK (1497)', 86)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2469, N'SAMARA HATCHBACK 1.5', 86)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2470, N'TAVRIA 1102', 86)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2471, N'DIABLO VT (5700)', 70)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2472, N'K 2400 (KAPPA)', 50)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2473, N'THEMA 6V 2.0', 50)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2474, N'LYBRA SW 2.4 JTD', 50)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2475, N'DISCOVERY 2.5 TDI', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2476, N'DISCOVERY 2.5 TD5', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2477, N'DISCOVERY BİNEK 3528', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2478, N'DISCOVERY V8i', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2479, N'DISCOVERY V8i ESTATE', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2480, N'V8i DISCOVERY 3.5', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2481, N'JEEP (3947)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2482, N'JEEP (3490)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2483, N'SFI 3.9', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2484, N'VOGUE SFI 3.9', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2485, N'VOGUE EFI L SE', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2486, N'VOGUE SE 3947', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2487, N'VOGUE SE ', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2488, N'VOGUE (3900)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2489, N'HSE 4.6 VOGUE', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2490, N'VOGUE 4.6 ', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2491, N'RANGE ROVER VOGUE 4.6', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2492, N'HSE 4.6', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2493, N'RANGE ROVER 4.6 HSE ', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2494, N'RANGE ROVER 4.4 V8 HSE', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2495, N'RANGE ROVER 4.4 V8 VOGUE', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2496, N'RANGE ROVER 5.2 JEEP', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2497, N'RANGE ROVER 3.0 TD6', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2498, N'90 COUNTRY 4279', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2499, N'COUNTRY 4278', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2500, N'SLX COUNTRY LWB 4200', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2501, N'VOGUE EFI', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2502, N'VOGUE 3948', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2503, N'VOGUE 3487', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2504, N'VOGUE 3458', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2505, N'SE 4.0 ', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2506, N'SE 4.0 SALHAML', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2507, N'VOGUE V8', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2508, N'VOGUE 4.0', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2509, N'3.5 LT', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2510, N'2951', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2511, N'2501', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2512, N'3528', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2513, N'3532', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2514, N'3520', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2515, N'RANGE ROVER 4x4 (3532)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2516, N'VOGUE EFI (3600)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2517, N'VOGUE 3532', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2518, N'VOGUE 3528', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2519, N'JEEP (3498)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2520, N'VOGUE EFI (2510)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2521, N'JEEP 4X4 3900', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2522, N'ARAZİ TAŞITI 4200', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2523, N'ARAZİ TAŞITI 4000', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2524, N'ARAZİ TAŞITI 3900', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2525, N'4.0 TL1', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2526, N'RANGE ROVER 3.9 VS', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2527, N'RANGE ROVER 4x4 (3528)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2528, N'RANGE ROVER (3532)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2529, N'RANGE ROVER 4.4i ', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2530, N'ARAZİ TAŞITI 3532', 15)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2531, N'RANGE ROVER (ARAZİ TAŞITI) (3500) ', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2532, N'ARAZİ TAŞITI 3500 ', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2533, N'ARAZİ TAŞITI STATION 3528', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2534, N'ARAZİ TAŞITI BİNEK ROVER (2495)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2535, N'ARAZİ TAŞITI (2500)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2536, N'SHEER ROVER 3528', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2537, N'RANGE ARAZİ TAŞITI (4000)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2538, N'ARAZİ TAŞITI (3947)', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2539, N'STW 3489', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2540, N'90.135P', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2541, N'ARAZİ TAŞITI 3470 ', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2542, N'88 LHP 3499', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2543, N'88 WB 3499', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2544, N'WB 3499', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2545, N'88 3500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2546, N'88 3000', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2547, N'88 3286', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2548, N'BİNEK 3500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2549, N'BİNEK (2500)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2550, N'88 ARAZI TASITI (2286)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2551, N'88 WB 2250', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2552, N'88 WB 2200', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2553, N'88 WB 2500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2554, N'2200', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2555, N'2980 ARAZİ TAŞITI ', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2556, N'88 2495', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2557, N'WB JEEP ARAZİ TAŞITI 2500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2558, N'ARAZİ TAŞITI 2500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2559, N'4X4 ARAZİ TAŞITI 1409', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2560, N'4X4 ARAZİ TAŞITI BENZİNLİ 1.6', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2561, N'4X4 ARAZİ BENZİNLİ 2300', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2562, N'KAMYONET ARAZİ 2600', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2563, N'ARAZİ TAŞITI 2498', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2564, N'KAPALI KASA BİNEK JEEP 3000  ', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2565, N'WB JEEP 3000', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2566, N'88 2770', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2567, N'88 2500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2568, N'ARAZI TAŞITI 3 88 2286', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2569, N'88 2286', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2570, N'88 2200', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2571, N'88 WB (2250)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2572, N'130-135 PICK UP 4X4 3500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2573, N'130-135 PICK UP 4X4 3528', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2574, N'ÇİFT KABİNLİ PİCK UP 3528', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2575, N'110-135 SW', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2576, N'110-111 SW DIZEL 2495', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2577, N'110-111 P ÇİFT SIRA ARKA TENT.2495', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2578, N'DEFENDER 110.111 PICK UP DIZEL', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2579, N'DEFENDER 110 2496', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2580, N'DEFENDER 110 4X4 2500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2581, N'DEFENDER  4X4 2000', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2582, N'DEFENDER 2500', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2583, N'110 ARAZİ TAŞITI (2500)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2584, N'110 TENTELİ KAMYONETARAZİ TAŞITI (2495)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2585, N'110-83 ARAZİ TAŞITI (2580)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2586, N'110-83 2495', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2587, N'110-83 ARAZI TAŞITI (2485)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2588, N'110-83 (4393)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2589, N'ARAZİ TAŞITI 2478', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2590, N'ARAZİ TAŞITI (2500)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2592, N'ARAZİ TAŞITI 2497', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2593, N'ARAZİ BİNEK (2580)', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2658, N'FIREBIRD 3400', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2659, N'FIREBIRD (2260)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2660, N'FIREBIRD ESPRIT 1800', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2661, N'TRANSAM 6600', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2662, N'TRANSAM 6568', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2663, N'TRANSAM 2490', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2664, N'FORMULA 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2665, N'FORMULA 5.8', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2666, N'FORMULA 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2667, N'FIREBIRD 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2668, N'FIREBIRD 3500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2669, N'FORMULA 3.8', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2670, N'FORMULA (3528)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2671, N'FORMULA 455 (2200)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2672, N'FORMULA 350 (2500)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2673, N'FORMULA 3000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2674, N'FORMULA 2600', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2675, N'350 FORMULA FIREBIBBIT 2100', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2676, N'TRANSAM 5.0', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2677, N'350 FIREBIRD 5000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2678, N'TRANSAM 5.9', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2680, N'FIREBIRD 2399 2 KAPI SPOR', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2681, N'FIREBIRD 2300 2 KAPI SPOR', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2682, N'FIREBIRD TRANSAM 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2683, N'TRANSAM 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2684, N'TRANSAM 3500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2685, N'TRANSAM 3228', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2686, N'TRANSAM 4550', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2687, N'TRANSAM 4500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2688, N'TRANSAM 4000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2689, N'TRANSAM (5001)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2690, N'TRANSAM 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2691, N'TRANSAM 5.5', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2693, N'TRANSAM 7473', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2694, N'FIREBIRD ESPRIT 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2696, N'FIREBIRD TRANSAM 5.0', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2697, N'TRANSAM CONVERTIBLE 5700', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2698, N'FIREBIRD TRANSAM  5.7', 89)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2699, N'FORMULA 5200', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2700, N'TRANSAM 5.0 GTA ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2701, N'FIREBIRD 2.8 COUPE ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2702, N'FIREBIRD 4185', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2705, N'TRANSPORT 5.0', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2706, N'TRANSPORT SE 4.5', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2707, N'TRANSPORT SE 4.3', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2708, N'TRANSPORT GT 3.8', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2709, N'TRANSPORT (3800)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2710, N'TRANSPORT SE 3.6', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2711, N'TRANSPORT SE 3.2', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2712, N'TRANSPORT (3128)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2713, N'TRANSPORT 3.8 GT ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2714, N'TRANSPORT 3.8 ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2715, N'TRANSPORT (3791)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2716, N'TRANSPORT OV 3400', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2717, N'TRANSPORT 3400', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2718, N'PHOENIX 3000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2719, N'PHOENIX 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2720, N'PARISIENNE 3500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2721, N'PARISIENNE 3498', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2722, N'PARISIENNE 2500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2723, N'CATALINA SPOR 3528', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2724, N'CATALINA 5813 4 KAPI', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2725, N'CATALINA 4001', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2726, N'CATALINA 4500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2727, N'6000 STE 2800', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2728, N'6000 LE 2800', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2729, N'6000 (2900)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2730, N'SPOR 4000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2731, N'PARSICANE 1800', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2732, N'BİNEK 2800', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2733, N'TEMPEST 2700', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2734, N'TEMPEST (1920)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2735, N'928 (4664)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2736, N'928 S (4700)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2737, N'928 S (4664)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2738, N'928 S (4608)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2739, N'928 S COUPE (4700)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2740, N'911 2 DOOR 3600', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2741, N'356 CABRIOLET 1582', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2742, N'912 1585', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2743, N'911 TURBO 2498', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2744, N'911 CARRERA TURBO (3598)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2745, N'911 CARRERA 3557', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2746, N'911 CARRERA (3600)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2747, N'911 CARRERA 2 (3600)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2748, N'911 CARRERA 3387', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2749, N'911 CARRERA CABRIO (3587)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2750, N'911 2195', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2751, N'911 SC 3164', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2752, N'911 SC 3125', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2753, N'911 SC (3557)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2754, N'P 928 (4700)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2755, N'944 2.5', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2756, N'924 (1984)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2757, N'924 2470', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2758, N'924 TURBO 1984', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2759, N'928 4957', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2760, N'928 2.01', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2761, N'930 (3300)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2762, N'CARRERA S (3590)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2763, N'CARRERA 4S', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2764, N'911 TARGA (2700)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2765, N'911 TARGA (1991)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2766, N'BOXSTER (2687)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2767, N'SPOR (1582)', 52)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2768, N'PERSONA 1.8 SEDAN AT', 40)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2769, N'PERSONA 2.0 TD SEDAN', 40)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2770, N'PERSONA 2.0 TD HB', 40)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2771, N'TENEZZÜH 2499', 74)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2772, N'TENEZZUH (5700)', 74)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2773, N'JAVELIN 4.0 ', 74)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2774, N'MINI BROOKLAND', 4)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2775, N'820 Si', 4)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2776, N'820 Ti ', 4)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2777, N'827 Si ', 4)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2778, N'100 (2600)', 4)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2779, N'416 SI (1589)', 4)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2780, N'25 2.0 HB', 4)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2781, N'ALHAMRA TDI 1.9', 34)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2782, N'TOLEDO 1.9 TDI ', 34)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2783, N'IBIZA 2.0 GTI', 34)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2784, N'CORDOBA VARIO 1.9 TDI', 34)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2785, N'CORDOBA 1.6 SXE', 34)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2786, N'CORDOBA 1.6 AUT', 34)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2787, N'LEON SIGNO 1.6', 34)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2788, N'IMPREZA 2.0 GT TURBO', 8)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2789, N'LEGACY 1.8', 8)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2790, N'LEGACY 2.2', 8)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2791, N'LEGACY OUTBACK 2.5', 8)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2792, N'STATION 1.8 ALLROAD ', 8)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2793, N'JUSTY J 12 GL', 8)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2794, N'25 GTX (2165)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2795, N'5 FIVE 1100', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2796, N'R25 GTS (1998)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2797, N'R25 (1998)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2798, N'R25 GTD 2068', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2799, N'R25 (2829)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2800, N'R25 (2500)', 25)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2801, N'R25 (2200)', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2802, N'RENO 9 GTL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2803, N'FLASH S', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2804, N'RAINBOW 1.4', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2805, N'EUROPA 1.4', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2806, N'19 EUROPA 1.9 RNA DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2807, N'19 EUROPA 1.9 RN DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2808, N'19 EUROPA 1.9 RL DIZEL', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2809, N'21 MANAGER 2000', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2810, N'21 MANAGER 1700', 25)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2886, N'CONTINENTAL 2501', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2887, N'CONTINENTAL (2200)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2888, N'TOWN CAR CARTIER ', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2889, N'TOWN CAR ', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2890, N'TOWN CAR ULTIMATE 4.6', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2891, N'TOWN CAR 4.6 ', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2892, N'TOWN CAR LIMOUSINE 4.6 ', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2893, N'TOWN CAR CARTIER (5600)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2894, N'TOWN CAR LIMUSINE (5000) ', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2895, N'TOWN CAR 4942', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2896, N'TOWN CAR 5000', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2897, N'TOWN CAR SIGNATURE (4605)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2898, N'MARK IV (7536)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2899, N'MARK  V II (4942)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2900, N'MARK  V III', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2901, N'MARK III (7480)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2902, N'NAVIGATOR 5400', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2903, N'NAVIGATOR 5300', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2904, N'NAVIGATOR 5200', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2905, N'LINCOLN LS 3.0', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2906, N'LS (3000)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2907, N'LS (3900)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2908, N'LS (4000)', 53)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2909, N'ESPRIT (1800)', 49)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2910, N'3200 GT COUPE MAN ', 61)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2911, N'SPYDER (1996)', 61)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2912, N'QUATTROPORTE (3217) ', 61)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2913, N'4200 SPIDER (3217) ', 61)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2914, N'GHIBLI 2.8 AUTO', 61)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2915, N'BORA (4930)', 61)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2916, N'626 HB 2.0 ', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2917, N'626 SALON 1998', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2918, N'626 SEDAN 2000', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2919, N'626 GLX HATCBACK 2.0 DV', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2920, N'626 HB 2.0 16V (136)', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2921, N'626 SEDAN 2.0 16V (136)', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2922, N'626 GT (1984)', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2923, N'626 2.2i 12V 115 SEDAN ', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2924, N'626 1600', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2925, N'929 3.0', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2926, N'929 3.0 SENTIA', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2927, N'929 3.0 ROYAL', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2928, N'323 SEDAN 1.8 MT', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2929, N'323 SEDAN (1840)', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2930, N'323 FAMILIA 1.8 SEDAN', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2931, N'323 1.6 SEDAN', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2932, N'323 SEDAN (1598)', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2933, N'E 2200 OTOMOBIL (2477)', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2934, N'MX5 MIATA (1598)', 56)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2935, N'4 KAPI (1897)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2936, N'LIMOUSINE (2195)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2937, N'ROADSTAR 2500', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2938, N'180E (1800)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2939, N'180 D (1998)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2940, N'C 220 CDI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2941, N'C 180 ELEGANCE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2942, N'C 180 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2943, N'C 200 K ELEGANCE (1998)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2944, N'C 320 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2945, N'C 36 AMG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2946, N'C 36 AMG SPORT', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2947, N'190 SL 1998', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2948, N'BİNEK 2200', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2949, N'230 SL ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2950, N'E 55 AMG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2951, N'E 200 CABRIO ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2952, N'E 200 CDI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2953, N'E 200 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2954, N'200 E', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2955, N'200', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2956, N'200 LPG  ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2957, N'1998 CC LPG DÖN HUSUSİ OTO ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2958, N'200 T', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2959, N'E 240', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2960, N'240 D', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2961, N'240 TD', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2962, N'240', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2963, N'200 D', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2964, N'SE 300 TD', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2965, N'300 TURBO ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2966, N'SW 300 TD ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2967, N'300 TD STW', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2968, N'300 TD STV ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2969, N'300 TD ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2970, N'300 TDW ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2971, N'300 D TURBO', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2972, N'300 D MATIC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2973, N'300 D 4 MATIC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2974, N'300 D', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2975, N'300 D STW', 44)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2976, N'300', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2977, N'E 250 D', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2978, N'250', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2979, N'250 4 KAPILI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2980, N'250 CE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2981, N'230 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2982, N'250 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2983, N'250 D', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2984, N'250 TD ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2985, N'250 D TURBO', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2986, N'250/6', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2987, N'230', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2988, N'230 SW', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2989, N'230/4', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2990, N'230/6', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2991, N'230 C ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2992, N'230 CE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2993, N'220 E', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2994, N'E 220', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2995, N'E 220 COUPE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2996, N'220', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2997, N'4 KAPI (220.4)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2998, N'220S CABRIO', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (2999, N'220S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3000, N'220D', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3001, N'200D 2400', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3002, N'300 CE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3003, N'230 E', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3004, N'230 TE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3005, N'230 TE 4', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3006, N'E 230', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3007, N'E 230 ELEGANCE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3008, N'250 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3009, N'260 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3010, N'280 TE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3011, N'300 TE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3012, N'260 E', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3013, N'300 E ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3014, N'E 300 TD', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3015, N'E 320', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3016, N'E 280', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3017, N'280 E', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3018, N'280 SE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3019, N'280 SE CONVERTIBLE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3020, N'280 SE CABRIOLET ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3021, N'280 SEL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3022, N'260 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3023, N'280 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3024, N'300 S', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3025, N'190 E SPORTLINE (1998)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3026, N'190 E (1998)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3027, N'190 E (1997)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3028, N'190 E (1996)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3029, N'190 E (2427)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3030, N'190 E (2.3)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3031, N'190 E 2.3 16', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3033, N'190 E 2.0', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3034, N'190 (1998)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3035, N'190 1.9', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3036, N'190 D 1987', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3037, N'190 D 2.5', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3038, N'190 D (2000)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3039, N'190 DC 1998', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3040, N'190 D (1998)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3041, N'190 D 1997', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3042, N'190 DIZEL (1900)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3043, N'190 DIZEL (1897)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3124, N'560 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3125, N'560 SEC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3126, N'500 SEC', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3127, N'500 SEC COUPE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3128, N'SL 600', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3129, N'600 SL', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3130, N'CL 600', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3131, N'CL 500', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3132, N'CL 55 AMG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3133, N'600 LONG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3134, N'ML 400 CDI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3135, N'ML 55 AMG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3136, N'ML 430', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3137, N'ML 320 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3138, N'SL 320 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3139, N'S 320  CDI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3140, N'S 320 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3141, N'S 280 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3142, N'S 320 LONG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3143, N'C 200', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3144, N'C 200 LPG ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3145, N'C 200 ELEGANCE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3146, N'C 250 D', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3147, N'C 270 CDI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3148, N'C 280', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3149, N'S 500 C', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3150, N'S 400 CDI L', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3151, N'S 400 CDI ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3152, N'S 500 ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3153, N'S 500 L', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3154, N'S 600 L', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3155, N'S 600 LONG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3156, N'S 600', 44)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3157, N'S 350 TD', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3158, N'G 270 CDI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3159, N'G 400 CDI', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3160, N'G 320', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3161, N'G 300D CABRIO', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3162, N'G 290 DT ', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3163, N'280 GE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3164, N'230 GE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3165, N'CLK 200', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3166, N'CLK 230 KOMPRESSOR', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3167, N'CLK 430', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3168, N'CLK 55 AMG COUPE', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3169, N'CLK 55 AMG', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3170, N'230 A', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3171, N'230 GD', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3172, N'300 GD', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3173, N'ST WAGON (2798)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3174, N'UNIMOG 1300 L 4X4   (5765)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3175, N'UNIMOG    (2495)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3176, N'UNIMOG    (2500)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3177, N'UNIMOG    (3865)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3178, N'UNIMOG S (5000)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3179, N'UNIMOG (5675)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3180, N'UNIMOG S (5700)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3181, N'UNIMOG (5675) ÇİFT KABIN 4X4', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3182, N'CONVERTIBLE (4500)', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3183, N'BİNEK 3500', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3184, N'BİNEK (1958)', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3185, N'SABLE 3791', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3186, N'SABLE IL6 (3791)', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3187, N'2 KAPILI HUSUSİ OTO 2920', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3188, N'MOUNTAINER 5.0', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3189, N'MONTEREY 2640', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3190, N'MONTEREY  MERCURY (3200)', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3191, N'MARGU ISPILBED 5000', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3192, N'MARGU ISPILBED (3273)', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3193, N'VILLAGER GS 3000', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3194, N'COUGAR 3191', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3195, N'COUGAR 3500', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3196, N'COUGAR 3791', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3197, N'COUGAR 5700', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3198, N'MONTEGE (5700)', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3199, N'GRAND MARGUIS LS 4.6', 73)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3200, N'GRAND MARGUIS 4.6', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3201, N'GRAND MARGUIS GS 3797', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3202, N'GRAND MARGUIS GS 4.6', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3203, N'MARGUIS 3000', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3204, N'COMET 4900', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3205, N'COMET (2001)', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3206, N'MONARCH 2000', 62)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3207, N'MONARCH 3275', 73)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3208, N'BGT (1508)', 67)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3209, N'TDMK II MIDGET (1998)', 67)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3210, N'LANCER GLX ( 1595)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3211, N'CARISMA 1.8 GDI SEDAN', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3212, N'CARISMA 1.8 GDI HB', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3213, N'CARISMA (1870)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3214, N'CARISMA (1834)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3215, N'MONTERO LS', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3216, N'PAJERO CANVAS 2477 DIZEL', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3217, N'PAJERO (3200)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3218, N'PAJERO (3500)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3219, N'PAJERO SHR 3497', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3220, N'PAJERO 3.0', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3221, N'PAJERO MT 2555', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3222, N'PAJERO 2600 KAT 2.6 ', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3223, N'PAJERO 4G54 2555', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3224, N'PAJERO V12 VNDL 2588', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3225, N'V12 VNDL LPG''Lİ ARAZİ TAŞITI 2593 ', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3226, N'PAJERO 2550 V32 WNAL', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3227, N'PAJERO 2600 V32 WNAL', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3228, N'PAJERO 2600 SUPER SALOON ', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3229, N'PAJERO 2500', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3230, N'PAJERO 4200', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3231, N'PAJERO (2945)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3232, N'PAJERO 2.6i', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3233, N'PAJERO 2500 TD GL', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3234, N'PAJERO 2550', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3235, N'PAJERO 2555', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3236, N'PAJERO M/T (2477)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3237, N'PAJERO METAL TOP (2555)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3239, N'PAJERO 2659', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3240, N'PAJERO (2800)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3241, N'H-JEEP DIESEL 2500', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3242, N'GALANT GLX DIZEL 2.3', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3243, N'GALANT 1755', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3244, N'ECLIPSE SPYDER GS-T 2.0', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3245, N'ECLIPSE 1998', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3246, N'SPACE WAGON (2351)', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3247, N'GTO 3000', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3248, N'L300 LWB (2497) 9 KISILIK', 20)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3249, N'21412', 26)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3250, N'NISSAN BLUBIRD SSS MT', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3251, N'NISSAN BLUBIRD', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3252, N'SUNNY 1.6 EX ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3253, N'SUNNY 1.6 ', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3254, N'LAUREL ALTIMA FULL OV', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3255, N'LAUREL ALTIMA 2.0', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3256, N'LONG BED 4X4 2400', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3257, N'MAXIMA QX 2.0 SE LIMITED', 30)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3258, N'MAXIMA 2.0 SE MT', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3259, N'MAXIMA QX SE AT', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3260, N'MAXIMA 2960', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3261, N'TERRANO II 2.4 4x4 SE 3 KAPI HARDTOP', 30)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3338, N'BİNEK 3966', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3339, N'BİNEK 3996', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3340, N'BİNEK 2591', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3341, N'BİNEK 2490', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3342, N'SUPER 88 3200', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3343, N'2 KAPILI 1998', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3344, N'STWG (2600)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3345, N'98 (6400)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3346, N'BROUGHAM RECENCY  (3800)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3347, N'98 BROUGHAM RECENCY ', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3348, N'BROUGHAM (3000)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3349, N'98 REGENCY ELİTE ', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3350, N'NİNETY EIGHT 5000', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3351, N'NİNETY EIGHT LUX 5033', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3352, N'REGENCY 4800', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3353, N'98 REGENCY ELİTE (7450)', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3354, N'ROYAL LIMOUSINE 4500', 39)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3355, N'106 XN 1.1 5 KAPI', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3356, N'605 1998', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3357, N'605 SV 3.0 ', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3358, N'605 (2974) ', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3359, N'607 3.0 PACK', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3360, N'604 2.8', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3361, N'504 GR (1613)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3362, N'504 GL (2000)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3363, N'504 (1995)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3364, N'504 A 2498', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3365, N'504 2112', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3366, N'504 1.9', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3367, N'504 2.0 STW F11', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3368, N'504 1751', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3369, N'504 1981', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3370, N'504 1979', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3371, N'504 1971', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3372, N'504 1600', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3373, N'504 2.0', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3374, N'504 1881', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3375, N'504 1.8', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3376, N'505 GL STWG (1796)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3377, N'505 BREAK FAMILIA (1751)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3378, N'505 (1971)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3379, N'505 DİZEL 2300', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3380, N'505 TURBO DİZEL 2399', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3381, N'505 GTI 2500', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3382, N'505 GRF SALOON SW', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3383, N'505 SRD 1.6', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3384, N'STATION WAGON 2.5', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3385, N'405 SRI BVA (1905)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3386, N'406 COUPE 3.0', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3387, N'406 COUPE 2.9', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3388, N'406 HDI 2015', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3389, N'406 DIZEL (2178)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3390, N'406 SV 2.9', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3391, N'406 SV 3.0', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3392, N'406 SV 2.0i', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3393, N'406 SV 2.2', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3394, N'406 SV 2.2 HDI', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3395, N'405 GR 1.9 ', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3396, N'309 GRD 1905', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3397, N'306 XR 1761', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3398, N'205 GTI 1.9 ', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3399, N'205 1.9 GRD ', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3400, N'PARTNER 1.9 D', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3401, N'PARTNER PACK 1.9 D', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3402, N'206 XT 1.6', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3403, N'206 GTI (1998)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3404, N'807 (2231)', 90)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3405, N'SAVAY (3000)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3406, N'BELVEDERE (5300)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3407, N'BELVEDERE 3678', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3408, N'BELVEDERE (3000)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3409, N'BELVEDERE 2400', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3410, N'BELVEDERE 1600', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3411, N'BARRACUDA 3678', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3412, N'BARRACUDA (5000)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3413, N'CUDA (5579)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3414, N'BİNEK 3695', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3415, N'BİNEK 3678', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3416, N'TENEZZUH (3500)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3417, N'BİNEK 2300', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3418, N'STANDAR A-2 KAPI', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3419, N'SATELLİTE 3600', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3420, N'FURY III 3850 ', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3421, N'FURY III STW 3250 ', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3422, N'FURY 5000', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3423, N'VALIANT CUSTOM (3678)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3424, N'VALIANT 2500', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3425, N'VALIANT (4970)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3426, N'VOYAGER 3.3', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3427, N'VOYAGER 3.0', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3428, N'GRAND  VOYAGER 3.3', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3429, N'VOYAGER 3.5 LE ', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3430, N'VOYAGER VAN 1951', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3431, N'VOYAGER 3798', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3432, N'VOYAGER (3.3 SE)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3433, N'VOLARE 3350', 11)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3434, N'VOLARE 3250', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3435, N'VOLARE 3678', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3436, N'VOLARE 3678 SW', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3437, N'4 DR SEDAN 2300', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3438, N'HUSUSİ A23 1862', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3439, N'BİNEK 3600', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3440, N'BİNEK (4000)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3441, N'ACCLAİM 3000', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3442, N'ST.WAGEN (3000)', 11)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3443, N'1.6 SLE', 64)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3444, N'FİERO 4100', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3445, N'İKİ KAPILI OTOMOBIL (KUPE) (2500)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3446, N'BELVEDERE (5300)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3447, N'BELVEDERE 2500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3448, N'BELVEDERE 2400', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3449, N'2 KAPILI KATALINA ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3450, N'BİNEK 4600', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3451, N'İKİ KAPI 4400', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3452, N'CHIEF (3987)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3453, N'CHIFTAIN X 2001', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3454, N'BİNEK 2496', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3455, N'BİNEK 2700', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3456, N'BİNEK (3000)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3457, N'GRAND PRIX GT 3.8', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3458, N'GRAND PRIX 6370', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3459, N'GRAND PRIX 4270', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3460, N'GRAND PRIX 3786', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3461, N'GRAND PRIX 3230', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3462, N'GRANDAM 3.1', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3463, N'GRANDAM 3.3', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3464, N'GRANDAM 3.4', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3465, N'GRANDAM 5.7', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3466, N'GRANADA (2700)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3467, N'BONNEVİLLE 5700', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3468, N'BONNEVİLLE SSE 3.8', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3469, N'BWS (BONNEVİLLE) 3.8', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3470, N'BONNEVİLLE 3791', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3471, N'VENTURA SJ (5335)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3472, N'VENTURA SJ (4093)', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3473, N'VENTURA 3528 SJ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3474, N'VENTURA 3350 SJ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3475, N'VENTURA 3800 SJ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3476, N'VENTURA 2496 SJ', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3477, N'VENTURA S 3850', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3478, N'VENTURA 3000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3479, N'VENTURA 4.0', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3480, N'VENTURA 3.5', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3481, N'VENTURA 5500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3482, N'VENTURA 4500', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3483, N'VENTURA 4083', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3484, N'VENTURA 3200', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (3485, N'VENTURA SY 3000', 89)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4018, N'CAMRY 3.0 GX', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4019, N'CAMRY 3.0 GX A/T', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4020, N'CAMRY 3.0 ABS', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4021, N'CAMRY 3.0 LUMİERE', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4022, N'CAMRY 2.2 GL OTOMATIK', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4023, N'CAMRY 2.0 GLI', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4024, N'HILUX CIFT KABIN 4X4 2.8 D', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4025, N'HILUX CIFT KABIN 4X4 ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4026, N'HILUX CIFT KABIN K.NET 4X4', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4027, N'CIFT KABIN K.NET ARAZİ ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4028, N'KAMYONET (CIFT KABINLI) (2446)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4029, N'KAMYONET 4 KAPILI (2446)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4030, N'PICK UP 4x4 (2446)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4031, N'KAMYONET (CIFT KABINLI) HLOX4WD', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4032, N'KAMYONET 4x4 CIFT KABINLI KAMYONET ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4033, N'JEEP ARAZİ TAŞITI 2001', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4034, N'CROWN ROYAL (2800)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4035, N'SUPRA (2953) ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4036, N'SUPRA 3.0 ', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4037, N'SUPRA 3.0  TURBO KAT', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4038, N'PREVIA 2.4', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4039, N'HIGHLINDER (2995)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4040, N'SEQUOIA 4.7', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4041, N'MODEL F (1811)', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4042, N'LEXUS RX 300', 54)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4043, N'TR-6 1598', 65)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4044, N'SPIT FIRE MK 3 (1400)', 65)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4045, N'ARAZİ TAŞITI 2.5', 13)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4046, N'BİNEK 1500', 43)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4047, N'JETTA VR6 (2800)', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4048, N'JETTA GL (1585) DIZEL', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4049, N'NEWBEETLE CABRIO AUT (1984)', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4050, N'SHARAN 2800', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4051, N'SHARAN 1896', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4052, N'1600 KARMAN GHI 1300', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4053, N'1200 (1397)', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4054, N'1303 (1302)', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4055, N'POLO CLASSIC 1.9 TDI', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4056, N'POLO CLASSIC 1.6', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4057, N'POLO COMF 1.4', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4058, N'POLO 1.6 ', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4059, N'POLO 1.6 4 KAPI', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4060, N'GOLF CABRIOLET 1.6', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4061, N'GOLF 1.6 COMFORT', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4062, N'GOLF 1.9 TD', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4063, N'GOLF CL TD 1781', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4064, N'GOLF CL 1890', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4065, N'GOLF VR 2.8 ', 36)
GO
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4066, N'CORRADO VR6', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4067, N'1300', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4068, N'K 70 1700', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4069, N'PASSAT 2.5 D', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4070, N'PASSAT 1.9 TDI', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4071, N'PASSAT 1.9 TDI COMFORT', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4072, N'PASSAT 2.5 TDI', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4073, N'PASSAT 2771', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4074, N'PASSAT LIM 1.8T', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4075, N'PASSAT T.D. (1570)', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4076, N'PASSAT VARIANT 1.9', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4077, N'PASSAT 2.8 V6 4 MOTION', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4078, N'CADDY 1.9 DIZEL', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4079, N'CITYVAN 3K 1.9 TDI LWB S', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4080, N'S40 1.9 T4', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4081, N'S80 T6 2.0T', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4082, N'S80 T6', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4083, N'S80 T6 2.8 GEARTRONIC', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4084, N'S80 T6 GEARTRONIC (2922)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4085, N'S90 2922', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4086, N'S70 T 2.0', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4087, N'S70 T 2498', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4088, N'V70 T5 2.0', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4089, N'V40 2.0 LT', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4090, N'850 TURBO', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4091, N'850 GLT', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4092, N'164 (2900)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4093, N'240 GLE (2000)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4094, N'240 OTOMATIC (2316)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4095, N'244 DL', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4096, N'244 CLASSIC ', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4097, N'244 2.2', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4098, N'244 GL (2383)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4099, N'P 244 GL', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4100, N'244 2.0', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4101, N'244 2100', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4102, N'244 1986', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4103, N'245 DL', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4104, N'345 GLS 2.0', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4105, N'460 GLE 1.8', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4106, N'240 GLE ', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4107, N'760 GLE 2501', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4108, N'760 GLE TURBO INTERCOOLER', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4109, N'740 GLE 2000', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4110, N'740 GLE', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4111, N'740 GL', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4112, N'740 GL(2316)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4113, N'480 TURBO', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4114, N'960 2922', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4115, N'960 OV', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4116, N'940 TURBO 2500', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4117, N'940 (2000)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4118, N'940 GL (2383)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4119, N'940 GLE (2383)', 9)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4120, N'C3-3 ARAZI (1800) DIZEL', 18)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4121, N'', 37)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4122, N'', 85)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4123, N'Tip', 14)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4208, N'', 15)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4319, N'', 84)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4420, N'', 44)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (4694, N'', 26)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (5402, N'', 6)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (5538, N'', 36)
INSERT [dbo].[VehicleModels] ([Id], [Name], [VehicleBrandId]) VALUES (7011, N'', 59)
SET IDENTITY_INSERT [dbo].[VehicleModels] OFF
SET IDENTITY_INSERT [dbo].[Vehicles] ON 

INSERT [dbo].[Vehicles] ([Id], [ModelYear], [Plate], [ChassisNo], [Color], [VehicleModelId], [VehicleTypeId], [CurrencyValue], [Currency], [IsActive]) VALUES (1, 2000, N'01KLM56', N'12345678945612365', 5, 843, 1, 80, 1, 1)
INSERT [dbo].[Vehicles] ([Id], [ModelYear], [Plate], [ChassisNo], [Color], [VehicleModelId], [VehicleTypeId], [CurrencyValue], [Currency], [IsActive]) VALUES (2, 2000, N'34ABC22', N'12345678945612365', 5, 1890, 1, 120, 1, 1)
INSERT [dbo].[Vehicles] ([Id], [ModelYear], [Plate], [ChassisNo], [Color], [VehicleModelId], [VehicleTypeId], [CurrencyValue], [Currency], [IsActive]) VALUES (3, 2000, N'06EYP12', N'12345678945612365', 5, 4090, 1, 100, 1, 0)
SET IDENTITY_INSERT [dbo].[Vehicles] OFF
SET IDENTITY_INSERT [dbo].[VehicleTypes] ON 

INSERT [dbo].[VehicleTypes] ([Id], [Name]) VALUES (1, N'Sedan')
INSERT [dbo].[VehicleTypes] ([Id], [Name]) VALUES (2, N'Hatchback')
INSERT [dbo].[VehicleTypes] ([Id], [Name]) VALUES (3, N'Station wagon')
INSERT [dbo].[VehicleTypes] ([Id], [Name]) VALUES (4, N'Cabrio')
INSERT [dbo].[VehicleTypes] ([Id], [Name]) VALUES (5, N'Pick up')
INSERT [dbo].[VehicleTypes] ([Id], [Name]) VALUES (6, N'SUV')
INSERT [dbo].[VehicleTypes] ([Id], [Name]) VALUES (7, N'Jip')
SET IDENTITY_INSERT [dbo].[VehicleTypes] OFF
ALTER TABLE [dbo].[BookingVehicles] ADD  CONSTRAINT [DF_BookingVehicles_IsActive]  DEFAULT ((1)) FOR [IsCancel]
GO
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [DF_Customers_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Vehicles] ADD  CONSTRAINT [DF_Vehicles_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BookingVehicles]  WITH CHECK ADD  CONSTRAINT [FK_BookingVehicles_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[BookingVehicles] CHECK CONSTRAINT [FK_BookingVehicles_Customers]
GO
ALTER TABLE [dbo].[BookingVehicles]  WITH CHECK ADD  CONSTRAINT [FK_BookingVehicles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[BookingVehicles] CHECK CONSTRAINT [FK_BookingVehicles_Users]
GO
ALTER TABLE [dbo].[BookingVehicles]  WITH CHECK ADD  CONSTRAINT [FK_BookingVehicles_Vehicles] FOREIGN KEY([VehicleId])
REFERENCES [dbo].[Vehicles] ([Id])
GO
ALTER TABLE [dbo].[BookingVehicles] CHECK CONSTRAINT [FK_BookingVehicles_Vehicles]
GO
ALTER TABLE [dbo].[Cities]  WITH CHECK ADD  CONSTRAINT [FK_Cities_States] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([Id])
GO
ALTER TABLE [dbo].[Cities] CHECK CONSTRAINT [FK_Cities_States]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Cities] FOREIGN KEY([CityId])
REFERENCES [dbo].[Cities] ([Id])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Cities]
GO
ALTER TABLE [dbo].[VehicleModels]  WITH CHECK ADD  CONSTRAINT [FK_VehicleModels_VehicleBrands] FOREIGN KEY([VehicleBrandId])
REFERENCES [dbo].[VehicleBrands] ([Id])
GO
ALTER TABLE [dbo].[VehicleModels] CHECK CONSTRAINT [FK_VehicleModels_VehicleBrands]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [FK_Vehicles_VehicleModels] FOREIGN KEY([VehicleModelId])
REFERENCES [dbo].[VehicleModels] ([Id])
GO
ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [FK_Vehicles_VehicleModels]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [FK_Vehicles_VehicleTypes] FOREIGN KEY([VehicleTypeId])
REFERENCES [dbo].[VehicleTypes] ([Id])
GO
ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [FK_Vehicles_VehicleTypes]
GO
/****** Object:  StoredProcedure [dbo].[sp_BookingVehicleAddOrUpdate]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Araç rezervasyon ekleme veya güncelleme>
-- =============================================
CREATE PROCEDURE [dbo].[sp_BookingVehicleAddOrUpdate]
	 @Id int= NULL OUT
	,@VehicleId int
    ,@CustomerId int
    ,@StartDate datetime
    ,@EndDate datetime
    ,@Duration float
    ,@Price float
    ,@UserId int
    ,@IsCancel bit
AS
BEGIN
	
	IF ISNULL(@Id,0) = 0
	BEGIN

		INSERT INTO [dbo].[BookingVehicles]
           ([VehicleId]
           ,[CustomerId]
           ,[StartDate]
           ,[EndDate]
           ,[Duration]
           ,[Price]
           ,[UserId]
		   ,IsCancel)
		 VALUES
           (@VehicleId
           ,@CustomerId
           ,@StartDate
           ,@EndDate
           ,@Duration
           ,(select isnull(CurrencyValue,0)*@Duration From Vehicles where Id=@VehicleId)--@Price
           ,@UserId
		   ,0)

		   SET @Id=SCOPE_IDENTITY()
	END
	ELSE
	BEGIN

		UPDATE [dbo].[BookingVehicles]
		   SET [VehicleId] = @VehicleId
			  ,[CustomerId] = @CustomerId
			  ,[StartDate] = @StartDate
			  ,[EndDate] = @EndDate
			  ,[Duration] = @Duration
			  ,[Price] = @Price
			  ,[UserId] = @UserId
			  ,[IsCancel] = @IsCancel
		 WHERE Id=@Id
	END

END
GO
/****** Object:  StoredProcedure [dbo].[sp_BookingVehicleGetDetail]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Id ye göre araç rezervasyon detayı>
-- =============================================
CREATE PROCEDURE [dbo].[sp_BookingVehicleGetDetail]
	 @Id int
AS
BEGIN
	
	SELECT 
	   bv.[Id]
      ,bv.[VehicleId]
      ,bv.[CustomerId]
      ,bv.[StartDate]
      ,bv.[EndDate]
      ,bv.[Duration]
      ,bv.[Price]
      ,bv.[UserId]
      ,bv.[IsCancel]

      ,c.[FirstName]
      ,c.[LastName]
      ,c.[Caption]
      ,c.[IdentityNumber]
      ,c.[Birthdate]
      ,c.[Gender]
      ,c.[TaxNumber]
      ,c.[TaxOffice]
      ,c.[Mobile]
      ,c.[HomePhone]
      ,c.[OfficePhone]
      ,c.[CityId]
      ,c.[Address]
      ,c.[IsActive] [IsActiveCustomer]

	  ,u.[UserName]
      ,u.[FirstName] [uFirstName]
      ,u.[LastName] [uLastName]
      ,u.[Email] [uEmail]
      ,u.[IsActive] [IsActiveUser]

	  ,v.[ModelYear]
      ,v.[Plate]
      ,v.[ChassisNo]
      ,v.[Color]
      ,v.[VehicleModelId]
      ,v.[VehicleTypeId]
      ,v.[CurrencyValue]
      ,v.[Currency]
      ,v.[IsActive] [IsActiveVehicle]

	FROM [dbo].[BookingVehicles] bv
		inner join [dbo].[Customers] c on c.Id = bv.CustomerId
		inner join [dbo].[Users] u on u.Id = bv.UserId
		inner join [dbo].[Vehicles] v on v.Id = bv.VehicleId
	WHERE bv.Id=@Id

END
GO
/****** Object:  StoredProcedure [dbo].[sp_BookingVehicleGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Arama kriterine göre rezervasyon listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_BookingVehicleGetList]
	 @VehicleId int
AS
BEGIN
	
	SELECT 
	   bv.[Id]
      ,bv.[VehicleId]
      ,bv.[CustomerId]
      ,bv.[StartDate]
      ,bv.[EndDate]
      ,bv.[Duration]
      ,bv.[Price]
      ,bv.[UserId]
      ,bv.[IsCancel]

      ,c.[FirstName]
      ,c.[LastName]
      ,c.[Caption]
      ,c.[IdentityNumber]
      ,c.[Birthdate]
      ,c.[Gender]
      ,c.[TaxNumber]
      ,c.[TaxOffice]
      ,c.[Mobile]
      ,c.[HomePhone]
      ,c.[OfficePhone]
      ,c.[CityId]
      ,c.[Address]
      ,c.[IsActive] [IsActiveCustomer]

	  ,u.[UserName]
      ,u.[FirstName] [uFirstName]
      ,u.[LastName] [uLastName]
      ,u.[Email] [uEmail]
      ,u.[IsActive] [IsActiveUser]

	  ,v.[ModelYear]
      ,v.[Plate]
      ,v.[ChassisNo]
      ,v.[Color]
      ,v.[VehicleModelId]
      ,v.[VehicleTypeId]
      ,v.[CurrencyValue]
      ,v.[Currency]
      ,v.[IsActive] [IsActiveVehicle]

	FROM [dbo].[BookingVehicles] bv
		inner join [dbo].[Customers] c on c.Id = bv.CustomerId
		inner join [dbo].[Users] u on u.Id = bv.UserId
		inner join [dbo].[Vehicles] v on v.Id = bv.VehicleId
	WHERE (isnull(@VehicleId,0)=0 or bv.VehicleId=@VehicleId)
	Order by bv.EndDate desc

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CityGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<İl ait ilçe listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CityGetList]
	@StateId int
AS
BEGIN
	SELECT
	   [Id]
      ,[Name]
	  ,[StateId]
	FROM [dbo].[Cities]
	WHERE StateId=@StateId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerAddOrUpdate]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Müşteri ekleme veya güncelleme>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerAddOrUpdate]
	 @Id int= NULL OUT
	,@FirstName varchar(20)
    ,@LastName varchar(20)
    ,@Caption varchar(50)
    ,@IdentityNumber varchar(11)
    ,@Birthdate date
    ,@Gender int
    ,@TaxNumber varchar(10)
    ,@TaxOffice varchar(100)
    ,@Mobile varchar(10)
    ,@HomePhone varchar(10)
    ,@OfficePhone varchar(10)
    ,@CityId int
    ,@Address varchar(200)
    ,@IsActive bit=null
AS
BEGIN
	
	IF ISNULL(@Id,0) = 0
	BEGIN

		INSERT INTO [dbo].[Customers]
           ([FirstName]
           ,[LastName]
           ,[Caption]
           ,[IdentityNumber]
           ,[Birthdate]
           ,[Gender]
           ,[TaxNumber]
           ,[TaxOffice]
           ,[Mobile]
           ,[HomePhone]
           ,[OfficePhone]
           ,[CityId]
           ,[Address]
		   ,IsActive)
     VALUES
           (@FirstName
           ,@LastName
           ,@Caption
           ,@IdentityNumber
           ,@Birthdate
           ,@Gender
           ,@TaxNumber
           ,@TaxOffice
           ,@Mobile
           ,@HomePhone
           ,@OfficePhone
           ,@CityId
           ,@Address
		   ,1)

		   SET @Id=SCOPE_IDENTITY()
	END
	ELSE
	BEGIN

		UPDATE [dbo].[Customers]
		   SET [FirstName] = @FirstName
			  ,[LastName] = @LastName
			  ,[Caption] = @Caption
			  ,[IdentityNumber] = @IdentityNumber
			  ,[Birthdate] = @Birthdate
			  ,[Gender] = @Gender
			  ,[TaxNumber] = @TaxNumber
			  ,[TaxOffice] = @TaxOffice
			  ,[Mobile] = @Mobile
			  ,[HomePhone] = @HomePhone
			  ,[OfficePhone] = @OfficePhone
			  ,[CityId] = @CityId
			  ,[Address] = @Address
			  ,[IsActive] = @IsActive
		 WHERE Id=@Id
	END

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerGetDetail]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Id ye göre müşteri detayı>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerGetDetail]
	 @Id int
AS
BEGIN
	
	SELECT TOP 1
	   c.[Id]
      ,c.[FirstName]
      ,c.[LastName]
      ,c.[Caption]
      ,c.[IdentityNumber]
      ,c.[Birthdate]
      ,c.[Gender]
      ,c.[TaxNumber]
      ,c.[TaxOffice]
      ,c.[Mobile]
      ,c.[HomePhone]
      ,c.[OfficePhone]
      ,c.[CityId]
      ,c.[Address]
      ,c.[IsActive]

	  ,ct.Name [CityName]

	  ,s.Id [StateId]
	  ,s.Name [StateName]

  FROM [dbo].[Customers] c
	 inner join Cities ct on ct.Id=c.CityId
	 inner join States s on s.Id=ct.StateId
  WHERE c.Id=@Id

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CustomerGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Arama kriterine göre müşteri listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerGetList]
	 @FirstName varchar(20)=null
    ,@LastName varchar(20)=null
    ,@Caption varchar(50)=null
    ,@Mobile varchar(10)=null
    ,@HomePhone varchar(10)=null
    ,@OfficePhone varchar(10)=null
	,@Gender int=null
	,@IsActive bit=null
AS
BEGIN
	
	SELECT 
	   c.[Id]
      ,c.[FirstName]
      ,c.[LastName]
      ,c.[Caption]
      ,c.[IdentityNumber]
      ,c.[Birthdate]
      ,c.[Gender]
      ,c.[TaxNumber]
      ,c.[TaxOffice]
      ,c.[Mobile]
      ,c.[HomePhone]
      ,c.[OfficePhone]
      ,c.[CityId]
      ,c.[Address]
      ,c.[IsActive]

	  ,ct.Name [CityName]

	  ,s.Id [StateId]
	  ,s.Name [StateName]

  FROM [dbo].[Customers] c
	 inner join Cities ct on ct.Id=c.CityId
	 inner join States s on s.Id=ct.StateId
  WHERE (@FirstName is null or c.FirstName like '%'+@FirstName+'%')
	AND (@LastName is null or c.LastName like '%'+@LastName+'%')
	AND (@Caption is null or c.Caption like '%'+@Caption+'%')
	AND (@Mobile is null or c.Mobile like '%'+@Mobile+'%')
	AND (@HomePhone is null or c.HomePhone like '%'+@HomePhone+'%')
	AND (@OfficePhone is null or c.OfficePhone like '%'+@OfficePhone+'%')
	AND (isnull(@Gender,0)=0 or c.Gender=@Gender)
	AND (@IsActive is null or c.IsActive=@IsActive)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportBookingCount]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Hangi araçların daha çok reserve edildiğini raporlama>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ReportBookingCount]
AS
BEGIN
	
	WITH raport_CTE AS
	(SELECT 
       v.[Id]
	  ,SUM(bv.[Id]) as TotalBookingCount
	FROM [dbo].[Vehicles] v 
		left join [dbo].[BookingVehicles] bv on v.Id = bv.VehicleId
	GROUP BY v.Id
	)

	SELECT 
	   v.[Id]
      ,v.[ModelYear]
      ,v.[Plate]
      ,v.[ChassisNo]
      ,v.[Color]
      ,v.[VehicleModelId]
      ,v.[VehicleTypeId]
      ,v.[CurrencyValue]
      ,v.[Currency]
      ,v.[IsActive]

	  ,t.[Id] [TypeId]
      ,t.[Name] [TypeName]

	  ,m.[Id] [ModelId]
      ,m.[Name] [ModelName]

	  ,b.[Id] [BrandId]
      ,b.[Name] [BrandName]

	  ,isnull(r.TotalBookingCount,0) [TotalBookingCount]
	FROM raport_CTE r
	 inner join [dbo].[Vehicles] v on v.Id = r.Id
	 inner join VehicleTypes t on t.Id=v.VehicleTypeId
	 inner join VehicleModels m on m.Id=v.VehicleModelId
	 inner join VehicleBrands b on b.Id=m.VehicleBrandId
		

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportVehiclePrice]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Belirli Tarihler arasında kiralanan araçların listesi, toplam kiralama tutarları>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ReportVehiclePrice]
	 @StartDate datetime,
	 @EndDate datetime
AS
BEGIN
	
	WITH raport_CTE AS
	(SELECT 
       v.[Id]
	  ,SUM(bv.[Price]) as TotalPrice
	FROM [dbo].[BookingVehicles] bv
		inner join [dbo].[Vehicles] v on v.Id = bv.VehicleId
	WHERE 
	(@StartDate is null or (@StartDate <= bv.EndDate) )
	and
	(@EndDate is null or (@EndDate >= bv.StartDate))
	GROUP BY v.Id)

	SELECT 
	   v.[Id]
      ,v.[ModelYear]
      ,v.[Plate]
      ,v.[ChassisNo]
      ,v.[Color]
      ,v.[VehicleModelId]
      ,v.[VehicleTypeId]
      ,v.[CurrencyValue]
      ,v.[Currency]
      ,v.[IsActive]

	  ,t.[Id] [TypeId]
      ,t.[Name] [TypeName]

	  ,m.[Id] [ModelId]
      ,m.[Name] [ModelName]

	  ,b.[Id] [BrandId]
      ,b.[Name] [BrandName]

	  ,r.TotalPrice
	FROM raport_CTE r
	 inner join [dbo].[Vehicles] v on v.Id = r.Id
	 inner join VehicleTypes t on t.Id=v.VehicleTypeId
	 inner join VehicleModels m on m.Id=v.VehicleModelId
	 inner join VehicleBrands b on b.Id=m.VehicleBrandId
		

END
GO
/****** Object:  StoredProcedure [dbo].[sp_StateGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<İl listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_StateGetList]
AS
BEGIN
	SELECT
	   [Id]
      ,[Name]
	FROM [dbo].[States]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UserAddOrUpdate]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <25/07/2018>
-- Description:	<Kullanıcı ekleme veya güncelleme>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UserAddOrUpdate]
	 @Id int= NULL OUT
	,@UserName varchar(20)
    ,@FirstName varchar(20)
    ,@LastName varchar(20)
    ,@Email varchar(50)
    ,@Password varchar(50)
    ,@Salt varchar(50)
	,@IsActive bit
AS
BEGIN
	
	IF ISNULL(@Id,0) = 0
	BEGIN
		INSERT INTO [dbo].[Users]
           ([UserName]
           ,[FirstName]
           ,[LastName]
           ,[Email]
           ,[Password]
           ,[Salt]
		   ,[IsActive])
		 VALUES
           (@UserName
           ,@FirstName
           ,@LastName
           ,@Email
           ,@Password
           ,@Salt
		   ,1)

		   SET @Id=SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE [dbo].[Users]
		   SET [FirstName] = @FirstName
			  ,[LastName] = @LastName
			  ,[Email] = @Email
			  ,[IsActive]=@IsActive
		 WHERE Id=@Id
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UserGetDetail]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <25/07/2018>
-- Description:	<Kullanıcı Detayını çeker>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UserGetDetail]
	@Id int=NULL,
	@UserName varchar(20)=NULL,
	@Email varchar(50)=NULL
AS
BEGIN
	SELECT TOP 1
	   [Id]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
      ,[Email]
      ,[Password]
      ,[Salt]
	FROM [dbo].[Users]
	WHERE IsActive=1 
		AND (ISNULL(@Id,0)=0 OR Id=@Id)
		AND (@UserName IS NULL OR UserName=@UserName)
		AND (@Email IS NULL OR Email=@Email)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VehicleAddOrUpdate]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Araç ekleme veya güncelleme>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VehicleAddOrUpdate]
	 @Id int= NULL OUT
	,@ModelYear int
    ,@Plate varchar(10)
    ,@ChassisNo varchar(17)
    ,@Color int
    ,@VehicleModelId int
    ,@VehicleTypeId int
    ,@CurrencyValue float
    ,@Currency int
	,@IsActive bit
AS
BEGIN
	
	IF ISNULL(@Id,0) = 0
	BEGIN
		INSERT INTO [dbo].[Vehicles]
           ([ModelYear]
           ,[Plate]
           ,[ChassisNo]
           ,[Color]
           ,[VehicleModelId]
           ,[VehicleTypeId]
           ,[CurrencyValue]
           ,[Currency]
		   ,[IsActive])
		VALUES
           (@ModelYear
           ,@Plate
           ,@ChassisNo
           ,@Color
           ,@VehicleModelId
           ,@VehicleTypeId
           ,@CurrencyValue
           ,@Currency
		   ,1)

		   SET @Id=SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE [dbo].[Vehicles]
		   SET [ModelYear] = @ModelYear
			  ,[Plate] = @Plate
			  ,[ChassisNo] = @ChassisNo
			  ,[Color] = @Color
			  ,[VehicleModelId] = @VehicleModelId
			  ,[VehicleTypeId] = @VehicleTypeId
			  ,[CurrencyValue] = @CurrencyValue
			  ,[Currency] = @Currency
			  ,[IsActive] = @IsActive
		 WHERE Id=@Id
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VehicleBrandGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Araç marka listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VehicleBrandGetList]
AS
BEGIN
	SELECT
	   [Id]
      ,[Name]
	FROM [dbo].[VehicleBrands]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VehicleEligibilityGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Arama kriterine göre araç uygunluk listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VehicleEligibilityGetList]
	 @ModelYear int=null
    ,@Color int=null
    ,@ModelName varchar(50)=null
    ,@TypeName varchar(50)=null
    ,@BrandName varchar(50)=null
    ,@Currency int=null
AS
BEGIN
	
	WITH vehicles_CTE AS
	(SELECT 
	   v.[Id]
      ,v.[ModelYear]
      ,v.[Plate]
      ,v.[ChassisNo]
      ,v.[Color]
      ,v.[VehicleModelId]
      ,v.[VehicleTypeId]
      ,v.[CurrencyValue]
      ,v.[Currency]
      ,v.[IsActive]

      ,t.[Name] [TypeName]

      ,m.[Name] [ModelName]

	  ,b.Id [BrandId]
      ,b.[Name] [BrandName]

	  ,dbo.BookingRemainingTime(v.Id) as [BookingRemainingTime]

  FROM [dbo].[Vehicles] v
	inner join VehicleTypes t on t.Id=v.VehicleTypeId
	inner join VehicleModels m on m.Id=v.VehicleModelId
	inner join VehicleBrands b on b.Id=m.VehicleBrandId

  WHERE (isnull(@ModelYear,0)=0 or v.ModelYear=@ModelYear)
	and (isnull(@Color,0)=0 or v.Color=@Color)
	and (@ModelName is null or m.Name like '%'+@ModelName+'%')
	and (@TypeName is null or t.Name like '%'+@TypeName+'%')
	and (@BrandName is null or b.Name like '%'+@BrandName+'%')
	and (isnull(@Currency,0)=0 or v.Currency=@Currency)
	and v.IsActive=1)

	SELECT * FROM vehicles_CTE 

END
GO
/****** Object:  StoredProcedure [dbo].[sp_VehicleGetDetail]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Id ye göre araç detayı>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VehicleGetDetail]
	 @Id int
AS
BEGIN
	
	SELECT
	   v.[Id]
      ,v.[ModelYear]
      ,v.[Plate]
      ,v.[ChassisNo]
      ,v.[Color]
      ,v.[VehicleModelId]
      ,v.[VehicleTypeId]
      ,v.[CurrencyValue]
      ,v.[Currency]
      ,v.[IsActive]

	  ,t.[Id] [TypeId]
      ,t.[Name] [TypeName]

	  ,m.[Id] [ModelId]
      ,m.[Name] [ModelName]

	  ,b.[Id] [BrandId]
      ,b.[Name] [BrandName]

  FROM [dbo].[Vehicles] v
	inner join VehicleTypes t on t.Id=v.VehicleTypeId
	inner join VehicleModels m on m.Id=v.VehicleModelId
	inner join VehicleBrands b on b.Id=m.VehicleBrandId
  WHERE v.Id=@Id


END
GO
/****** Object:  StoredProcedure [dbo].[sp_VehicleGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Arama kritere göre araç litesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VehicleGetList]
	 @ModelYear int=null
    ,@Color int=null
    ,@VehicleModelId int=null
    ,@VehicleTypeId int=null
    ,@Currency int=null
	,@IsActive bit=null
AS
BEGIN
	
	SELECT 
	   v.[Id]
      ,v.[ModelYear]
      ,v.[Plate]
      ,v.[ChassisNo]
      ,v.[Color]
      ,v.[VehicleModelId]
      ,v.[VehicleTypeId]
      ,v.[CurrencyValue]
      ,v.[Currency]
      ,v.[IsActive]

	  ,t.[Id] [TypeId]
      ,t.[Name] [TypeName]

	  ,m.[Id] [ModelId]
      ,m.[Name] [ModelName]

	  ,b.[Id] [BrandId]
      ,b.[Name] [BrandName]

  FROM [dbo].[Vehicles] v
	inner join VehicleTypes t on t.Id=v.VehicleTypeId
	inner join VehicleModels m on m.Id=v.VehicleModelId
	inner join VehicleBrands b on b.Id=m.VehicleBrandId
  WHERE (isnull(@ModelYear,0)=0 or v.ModelYear=@ModelYear)
	and (isnull(@Color,0)=0 or v.Color=@Color)
	and (isnull(@VehicleModelId,0)=0 or v.VehicleModelId=@VehicleModelId)
	and (isnull(@VehicleTypeId,0)=0 or v.VehicleTypeId=@VehicleTypeId)
	and (isnull(@Currency,0)=0 or v.Currency=@Currency)
	and (@IsActive is null or v.IsActive=@IsActive)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_VehicleModelGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Markaya ait model listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VehicleModelGetList]
	@VehicleBrandId int
AS
BEGIN
	SELECT
	   [Id]
      ,[Name]
	  ,[VehicleBrandId]
	FROM [dbo].[VehicleModels]
	WHERE VehicleBrandId=@VehicleBrandId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VehicleTypeGetList]    Script Date: 30.07.2018 01:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Eyup Gevenim>
-- Create date: <28/07/2018>
-- Description:	<Araç tip listesi>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VehicleTypeGetList]
AS
BEGIN
	SELECT
	   [Id]
      ,[Name]
	FROM [dbo].[VehicleTypes]
END
GO
USE [master]
GO
ALTER DATABASE [RENTCARDB] SET  READ_WRITE 
GO
