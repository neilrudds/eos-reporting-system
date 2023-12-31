USE [master]
GO
/****** Object:  Database [ReportingSystemProd]    Script Date: 26/05/2020 18:26:56 ******/
CREATE DATABASE [ReportingSystemProd]
GO
ALTER DATABASE [ReportingSystemProd] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ReportingSystemProd].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ReportingSystemProd] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET ARITHABORT OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ReportingSystemProd] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [ReportingSystemProd] SET PARAMETERIZATION FORCED 
GO
ALTER DATABASE [ReportingSystemProd] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [ReportingSystemProd] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET  MULTI_USER 
GO
ALTER DATABASE [ReportingSystemProd] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ReportingSystemProd] SET ENCRYPTION ON
GO
ALTER DATABASE [ReportingSystemProd] SET QUERY_STORE = ON
GO
ALTER DATABASE [ReportingSystemProd] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [ReportingSystemProd]
GO
/****** Object:  DatabaseScopedCredential [CSV-Storage-Credentials]    Script Date: 26/05/2020 18:26:56 ******/
USE [ReportingSystemProd]
CREATE DATABASE SCOPED CREDENTIAL [CSV-Storage-Credentials] WITH IDENTITY = N'SHARED ACCESS SIGNATURE'
GO
/****** Object:  DatabaseScopedCredential [EdinaOperationsImport-Storage-Credentials]    Script Date: 26/05/2020 18:26:56 ******/
USE [ReportingSystemProd]
CREATE DATABASE SCOPED CREDENTIAL [EdinaOperationsImport-Storage-Credentials] WITH IDENTITY = N'SHARED ACCESS SIGNATURE'
GO
/****** Object:  DatabaseScopedCredential [https://genericstorage01.blob.core.windows.net/sqldbauditlogs]    Script Date: 26/05/2020 18:26:56 ******/
USE [ReportingSystemProd]
CREATE DATABASE SCOPED CREDENTIAL [https://genericstorage01.blob.core.windows.net/sqldbauditlogs] WITH IDENTITY = N'SHARED ACCESS SIGNATURE'
GO
/****** Object:  User [EdinaApp]    Script Date: 26/05/2020 18:26:56 ******/
CREATE USER [EdinaApp] FOR LOGIN [EdinaApp] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EdinaImportFunction]    Script Date: 26/05/2020 18:26:56 ******/
CREATE USER [EdinaImportFunction] FOR LOGIN [EdinaImportFunction] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EdinaOperationsBroker]    Script Date: 26/05/2020 18:26:56 ******/
CREATE USER [EdinaOperationsBroker] FOR LOGIN [EdinaOperationsBroker] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Geckoboard_Dataset]    Script Date: 26/05/2020 18:26:56 ******/
CREATE USER [Geckoboard_Dataset] FOR LOGIN [Geckoboard_Dataset] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [kevin_creategravity]    Script Date: 26/05/2020 18:26:56 ******/
CREATE USER [kevin_creategravity] FOR LOGIN [kevin_creategravity] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [EdinaApp]
GO
ALTER ROLE [db_owner] ADD MEMBER [EdinaImportFunction]
GO
ALTER ROLE [db_owner] ADD MEMBER [EdinaOperationsBroker]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Geckoboard_Dataset]
GO
ALTER ROLE [db_owner] ADD MEMBER [kevin_creategravity]
GO
/****** Object:  Schema [EnergyMeters]    Script Date: 26/05/2020 18:26:56 ******/
CREATE SCHEMA [EnergyMeters]
GO
/****** Object:  Schema [HangFire]    Script Date: 26/05/2020 18:26:56 ******/
CREATE SCHEMA [HangFire]
GO
/****** Object:  Schema [Staging]    Script Date: 26/05/2020 18:26:56 ******/
CREATE SCHEMA [Staging]
GO
/****** Object:  PartitionFunction [partFunct_GeneratorContent_TimeStamp]    Script Date: 26/05/2020 18:26:56 ******/
CREATE PARTITION FUNCTION [partFunct_GeneratorContent_TimeStamp](datetime) AS RANGE LEFT FOR VALUES (N'2011-09-01T00:00:00.000', N'2011-09-15T00:00:00.000', N'2011-10-01T00:00:00.000', N'2011-10-15T00:00:00.000', N'2011-11-01T00:00:00.000', N'2011-11-15T00:00:00.000', N'2011-12-01T00:00:00.000', N'2011-12-15T00:00:00.000', N'2012-01-01T00:00:00.000', N'2012-01-15T00:00:00.000', N'2012-02-01T00:00:00.000', N'2012-02-15T00:00:00.000', N'2012-03-01T00:00:00.000', N'2012-03-15T00:00:00.000', N'2012-04-01T00:00:00.000', N'2012-04-15T00:00:00.000', N'2012-05-01T00:00:00.000', N'2012-05-15T00:00:00.000', N'2012-06-01T00:00:00.000', N'2012-06-15T00:00:00.000', N'2012-07-01T00:00:00.000', N'2012-07-15T00:00:00.000', N'2012-08-01T00:00:00.000', N'2012-08-15T00:00:00.000', N'2012-09-01T00:00:00.000', N'2012-09-15T00:00:00.000', N'2012-10-01T00:00:00.000', N'2012-10-15T00:00:00.000', N'2012-11-01T00:00:00.000', N'2012-11-15T00:00:00.000', N'2012-12-01T00:00:00.000', N'2012-12-15T00:00:00.000', N'2013-01-01T00:00:00.000', N'2013-01-15T00:00:00.000', N'2013-02-01T00:00:00.000', N'2013-02-15T00:00:00.000', N'2013-03-01T00:00:00.000', N'2013-03-15T00:00:00.000', N'2013-04-01T00:00:00.000', N'2013-04-15T00:00:00.000', N'2013-05-01T00:00:00.000', N'2013-05-15T00:00:00.000', N'2013-06-01T00:00:00.000', N'2013-06-15T00:00:00.000', N'2013-07-01T00:00:00.000', N'2013-07-15T00:00:00.000', N'2013-08-01T00:00:00.000', N'2013-08-15T00:00:00.000', N'2013-09-01T00:00:00.000', N'2013-09-15T00:00:00.000', N'2013-10-01T00:00:00.000', N'2013-10-15T00:00:00.000', N'2013-11-01T00:00:00.000', N'2013-11-15T00:00:00.000', N'2013-12-01T00:00:00.000', N'2013-12-15T00:00:00.000', N'2014-01-01T00:00:00.000', N'2014-01-15T00:00:00.000', N'2014-02-01T00:00:00.000', N'2014-02-15T00:00:00.000', N'2014-03-01T00:00:00.000', N'2014-03-15T00:00:00.000', N'2014-04-01T00:00:00.000', N'2014-04-15T00:00:00.000', N'2014-05-01T00:00:00.000', N'2014-05-15T00:00:00.000', N'2014-06-01T00:00:00.000', N'2014-06-15T00:00:00.000', N'2014-07-01T00:00:00.000', N'2014-07-15T00:00:00.000', N'2014-08-01T00:00:00.000', N'2014-08-15T00:00:00.000', N'2014-09-01T00:00:00.000', N'2014-09-15T00:00:00.000', N'2014-10-01T00:00:00.000', N'2014-10-15T00:00:00.000', N'2014-11-01T00:00:00.000', N'2014-11-15T00:00:00.000', N'2014-12-01T00:00:00.000', N'2014-12-15T00:00:00.000', N'2015-01-01T00:00:00.000', N'2015-01-15T00:00:00.000', N'2015-02-01T00:00:00.000', N'2015-02-15T00:00:00.000', N'2015-03-01T00:00:00.000', N'2015-03-15T00:00:00.000', N'2015-04-01T00:00:00.000', N'2015-04-15T00:00:00.000', N'2015-05-01T00:00:00.000', N'2015-05-15T00:00:00.000', N'2015-06-01T00:00:00.000', N'2015-06-15T00:00:00.000', N'2015-07-01T00:00:00.000', N'2015-07-15T00:00:00.000', N'2015-08-01T00:00:00.000', N'2015-08-15T00:00:00.000', N'2015-09-01T00:00:00.000', N'2015-09-15T00:00:00.000', N'2015-10-01T00:00:00.000', N'2015-10-15T00:00:00.000', N'2015-11-01T00:00:00.000', N'2015-11-15T00:00:00.000', N'2015-12-01T00:00:00.000', N'2015-12-15T00:00:00.000', N'2016-01-01T00:00:00.000', N'2016-01-15T00:00:00.000', N'2016-02-01T00:00:00.000', N'2016-02-15T00:00:00.000', N'2016-03-01T00:00:00.000', N'2016-03-15T00:00:00.000', N'2016-04-01T00:00:00.000', N'2016-04-15T00:00:00.000', N'2016-05-01T00:00:00.000', N'2016-05-15T00:00:00.000', N'2016-06-01T00:00:00.000', N'2016-06-15T00:00:00.000', N'2016-07-01T00:00:00.000', N'2016-07-15T00:00:00.000', N'2016-08-01T00:00:00.000', N'2016-08-15T00:00:00.000', N'2016-09-01T00:00:00.000', N'2016-09-15T00:00:00.000', N'2016-10-01T00:00:00.000', N'2016-10-15T00:00:00.000', N'2016-11-01T00:00:00.000', N'2016-11-15T00:00:00.000', N'2016-12-01T00:00:00.000', N'2016-12-15T00:00:00.000', N'2017-01-01T00:00:00.000', N'2017-01-15T00:00:00.000', N'2017-02-01T00:00:00.000', N'2017-02-15T00:00:00.000', N'2017-03-01T00:00:00.000', N'2017-03-15T00:00:00.000', N'2017-04-01T00:00:00.000', N'2017-04-15T00:00:00.000', N'2017-05-01T00:00:00.000', N'2017-05-15T00:00:00.000', N'2017-06-01T00:00:00.000', N'2017-06-15T00:00:00.000', N'2017-07-01T00:00:00.000', N'2017-07-15T00:00:00.000', N'2017-08-01T00:00:00.000', N'2017-08-15T00:00:00.000', N'2017-09-01T00:00:00.000', N'2017-09-15T00:00:00.000', N'2017-10-01T00:00:00.000', N'2017-10-15T00:00:00.000', N'2017-11-01T00:00:00.000', N'2017-11-15T00:00:00.000', N'2017-12-01T00:00:00.000', N'2017-12-15T00:00:00.000', N'2018-01-01T00:00:00.000', N'2018-01-15T00:00:00.000', N'2018-02-01T00:00:00.000', N'2018-02-15T00:00:00.000', N'2018-03-01T00:00:00.000', N'2018-03-15T00:00:00.000', N'2018-04-01T00:00:00.000', N'2018-04-15T00:00:00.000', N'2018-05-01T00:00:00.000', N'2018-05-15T00:00:00.000', N'2018-06-01T00:00:00.000', N'2018-06-15T00:00:00.000', N'2018-07-01T00:00:00.000', N'2018-07-15T00:00:00.000', N'2018-08-01T00:00:00.000', N'2018-08-15T00:00:00.000', N'2018-09-01T00:00:00.000', N'2018-09-15T00:00:00.000', N'2018-10-01T00:00:00.000', N'2018-10-15T00:00:00.000', N'2018-11-01T00:00:00.000', N'2018-11-15T00:00:00.000', N'2018-12-01T00:00:00.000', N'2018-12-15T00:00:00.000', N'2019-01-01T00:00:00.000', N'2019-01-15T00:00:00.000', N'2019-02-01T00:00:00.000', N'2019-02-15T00:00:00.000', N'2019-03-01T00:00:00.000', N'2019-03-15T00:00:00.000', N'2019-04-01T00:00:00.000', N'2019-04-15T00:00:00.000', N'2019-05-01T00:00:00.000', N'2019-05-15T00:00:00.000', N'2019-06-01T00:00:00.000', N'2019-06-15T00:00:00.000', N'2019-07-01T00:00:00.000', N'2019-07-15T00:00:00.000', N'2019-08-01T00:00:00.000', N'2019-08-15T00:00:00.000', N'2019-09-01T00:00:00.000', N'2019-09-15T00:00:00.000', N'2019-10-01T00:00:00.000', N'2019-10-15T00:00:00.000', N'2019-11-01T00:00:00.000', N'2019-11-15T00:00:00.000', N'2019-12-01T00:00:00.000', N'2019-12-15T00:00:00.000', N'2020-01-01T00:00:00.000', N'2020-01-15T00:00:00.000', N'2020-02-01T00:00:00.000', N'2020-02-15T00:00:00.000', N'2020-03-01T00:00:00.000', N'2020-03-15T00:00:00.000', N'2020-04-01T00:00:00.000', N'2020-04-15T00:00:00.000', N'2020-05-01T00:00:00.000', N'2020-05-15T00:00:00.000', N'2020-06-01T00:00:00.000', N'2020-06-15T00:00:00.000', N'2020-07-01T00:00:00.000', N'2020-07-15T00:00:00.000', N'2020-08-01T00:00:00.000', N'2020-08-15T00:00:00.000', N'2020-09-01T00:00:00.000', N'2020-09-15T00:00:00.000', N'2020-10-01T00:00:00.000', N'2020-10-15T00:00:00.000', N'2020-11-01T00:00:00.000', N'2020-11-15T00:00:00.000', N'2020-12-01T00:00:00.000', N'2020-12-15T00:00:00.000')
GO
/****** Object:  PartitionFunction [partFunct_HL_Logs]    Script Date: 26/05/2020 18:26:56 ******/
CREATE PARTITION FUNCTION [partFunct_HL_Logs](datetime) AS RANGE LEFT FOR VALUES (N'2011-09-01T00:00:00.000', N'2011-10-01T00:00:00.000', N'2011-11-01T00:00:00.000', N'2011-12-01T00:00:00.000', N'2012-01-01T00:00:00.000', N'2012-02-01T00:00:00.000', N'2012-03-01T00:00:00.000', N'2012-04-01T00:00:00.000', N'2012-05-01T00:00:00.000', N'2012-06-01T00:00:00.000', N'2012-07-01T00:00:00.000', N'2012-08-01T00:00:00.000', N'2012-09-01T00:00:00.000', N'2012-10-01T00:00:00.000', N'2012-11-01T00:00:00.000', N'2012-12-01T00:00:00.000', N'2013-01-01T00:00:00.000', N'2013-02-01T00:00:00.000', N'2013-03-01T00:00:00.000', N'2013-04-01T00:00:00.000', N'2013-05-01T00:00:00.000', N'2013-06-01T00:00:00.000', N'2013-07-01T00:00:00.000', N'2013-08-01T00:00:00.000', N'2013-09-01T00:00:00.000', N'2013-10-01T00:00:00.000', N'2013-11-01T00:00:00.000', N'2013-12-01T00:00:00.000', N'2014-01-01T00:00:00.000', N'2014-02-01T00:00:00.000', N'2014-03-01T00:00:00.000', N'2014-04-01T00:00:00.000', N'2014-05-01T00:00:00.000', N'2014-06-01T00:00:00.000', N'2014-07-01T00:00:00.000', N'2014-08-01T00:00:00.000', N'2014-09-01T00:00:00.000', N'2014-10-01T00:00:00.000', N'2014-11-01T00:00:00.000', N'2014-12-01T00:00:00.000', N'2015-01-01T00:00:00.000', N'2015-02-01T00:00:00.000', N'2015-03-01T00:00:00.000', N'2015-04-01T00:00:00.000', N'2015-05-01T00:00:00.000', N'2015-06-01T00:00:00.000', N'2015-07-01T00:00:00.000', N'2015-08-01T00:00:00.000', N'2015-09-01T00:00:00.000', N'2015-10-01T00:00:00.000', N'2015-11-01T00:00:00.000', N'2015-12-01T00:00:00.000', N'2016-01-01T00:00:00.000', N'2016-02-01T00:00:00.000', N'2016-03-01T00:00:00.000', N'2016-04-01T00:00:00.000', N'2016-05-01T00:00:00.000', N'2016-06-01T00:00:00.000', N'2016-07-01T00:00:00.000', N'2016-08-01T00:00:00.000', N'2016-09-01T00:00:00.000', N'2016-10-01T00:00:00.000', N'2016-11-01T00:00:00.000', N'2016-12-01T00:00:00.000', N'2017-01-01T00:00:00.000', N'2017-02-01T00:00:00.000', N'2017-03-01T00:00:00.000', N'2017-04-01T00:00:00.000', N'2017-05-01T00:00:00.000', N'2017-06-01T00:00:00.000', N'2017-07-01T00:00:00.000', N'2017-08-01T00:00:00.000', N'2017-09-01T00:00:00.000', N'2017-10-01T00:00:00.000', N'2017-11-01T00:00:00.000', N'2017-12-01T00:00:00.000', N'2018-01-01T00:00:00.000', N'2018-02-01T00:00:00.000', N'2018-03-01T00:00:00.000', N'2018-03-15T00:00:00.000', N'2018-04-01T00:00:00.000', N'2018-04-15T00:00:00.000', N'2018-05-01T00:00:00.000', N'2018-05-15T00:00:00.000', N'2018-06-01T00:00:00.000', N'2018-06-15T00:00:00.000', N'2018-07-01T00:00:00.000', N'2018-07-15T00:00:00.000', N'2018-08-01T00:00:00.000', N'2018-08-15T00:00:00.000', N'2018-09-01T00:00:00.000', N'2018-09-15T00:00:00.000', N'2018-10-01T00:00:00.000', N'2018-10-15T00:00:00.000', N'2018-11-01T00:00:00.000', N'2018-11-15T00:00:00.000', N'2018-12-01T00:00:00.000', N'2018-12-15T00:00:00.000', N'2019-01-01T00:00:00.000', N'2019-01-15T00:00:00.000', N'2019-02-01T00:00:00.000', N'2019-02-15T00:00:00.000', N'2019-03-01T00:00:00.000', N'2019-03-15T00:00:00.000', N'2019-04-01T00:00:00.000', N'2019-04-15T00:00:00.000', N'2019-05-01T00:00:00.000', N'2019-05-15T00:00:00.000', N'2019-06-01T00:00:00.000', N'2019-06-15T00:00:00.000', N'2019-07-01T00:00:00.000', N'2019-07-15T00:00:00.000')
GO
/****** Object:  PartitionScheme [partScheme_GeneratorContent_TimeStamp]    Script Date: 26/05/2020 18:26:56 ******/
CREATE PARTITION SCHEME [partScheme_GeneratorContent_TimeStamp] AS PARTITION [partFunct_GeneratorContent_TimeStamp] TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY])
GO
/****** Object:  PartitionScheme [partScheme_HL_Logs]    Script Date: 26/05/2020 18:26:56 ******/
CREATE PARTITION SCHEME [partScheme_HL_Logs] AS PARTITION [partFunct_HL_Logs] TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY])
GO
/****** Object:  UserDefinedTableType [dbo].[integer_list_tbltype]    Script Date: 26/05/2020 18:26:56 ******/
CREATE TYPE [dbo].[integer_list_tbltype] AS TABLE(
	[n] [int] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[n] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [dbo].[string_list_tbltype]    Script Date: 26/05/2020 18:26:56 ******/
CREATE TYPE [dbo].[string_list_tbltype] AS TABLE(
	[s] [nchar](256) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[s] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateJsonInsertProcedure]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION
[dbo].[GenerateJsonInsertProcedure](@SchemaName sysname, @TableName sysname, @JsonColumns nvarchar(max), @IgnoredColumns nvarchar(max))
RETURNS NVARCHAR(MAX)
AS BEGIN
declare @JsonParam sysname = '@'+@TableName+'Json'
declare @JsonSchema nvarchar(max) = '';


with col_def(ColumnName, ColumnId, ColumnType, StringSize, Mode, IsJson) AS
(
	select 
		col.name as ColumnName,
		column_id ColumnId,
		typ.name as ColumnType,
		-- create type with size based on type name and size
		case typ.name
			when 'char' then '(' + cast(col.max_length as varchar(10))+ ')'
			when 'nchar' then '(' + cast(col.max_length as varchar(10))+ ')'
			when 'nvarchar' then (IIF(col.max_length=-1, '(MAX)', '(' + cast(col.max_length as varchar(10))+ ')'))
			when 'varbinary' then (IIF(col.max_length=-1, '(MAX)', '(' + cast(col.max_length as varchar(10))+ ')'))
			when 'varchar' then (IIF(col.max_length=-1, '(MAX)', '(' + cast(col.max_length as varchar(10))+ ')'))
			else ''
		end as StringSize,
		-- if column is not nullable, add Strict mode in JSON
		case 
			when col.is_nullable = 1 then '$.' else 'strict $.' 
		end Mode,
		CHARINDEX(col.name, @JsonColumns,0) as IsJson
	from sys.columns col
		join sys.types typ on
			col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
				LEFT JOIN dbo.syscomments SM ON col.default_object_id = SM.id  
	where object_id = object_id(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName))
	-- Do not insert identity, computed columns, hidden columns, rowguid columns, generated always columns 
	-- Skip columns that cannot be parsed by JSON, e.g. text, sql_variant, etc. 
	and col.is_identity = 0
	and col.is_computed = 0
	and col.is_hidden = 0
	and col.is_rowguidcol = 0
	and generated_always_type = 0
	and (sm.text IS NULL OR sm.text NOT LIKE '(NEXT VALUE FOR%')
	and LOWER(typ.name) NOT IN ('text', 'ntext', 'sql_variant', 'image','hierarchyid','geometry','geography')
	and col.name NOT IN (SELECT value FROM STRING_SPLIT(@IgnoredColumns, ','))
)
select @JsonSchema = @JsonSchema + '
			' + QUOTENAME(ColumnName) + ' ' + ColumnType + StringSize + 
			 ' N''' + Mode + '"' + STRING_ESCAPE(ColumnName, 'json') + '"''' +IIF(IsJson>0, ' AS JSON', '') + ',' 
from col_def
order by ColumnId

-- Generate list of column names ordered by columnid
declare @TableSchema nvarchar(max) = '';

with col_def(ColumnName, ColumnId, ColumnType, StringSize, Mode, IsJson) AS
(
    select 
        col.name as ColumnName,
        column_id ColumnId,
        typ.name as ColumnType,
		-- create type with size based on type name and size
		case typ.name
			when 'char' then '(' + cast(col.max_length as varchar(10))+ ')'
            when 'nchar' then '(' + cast(col.max_length as varchar(10))+ ')'
            when 'nvarchar' then (IIF(col.max_length=-1, '(MAX)', '(' + cast(col.max_length as varchar(10))+ ')'))
            when 'varbinary' then (IIF(col.max_length=-1, '(MAX)', '(' + cast(col.max_length as varchar(10))+ ')'))
            when 'varchar' then (IIF(col.max_length=-1, '(MAX)', '(' + cast(col.max_length as varchar(10))+ ')'))
			else ''
		end as StringSize,
		-- if column is not nullable, add Strict mode in JSON
        case 
            when col.is_nullable = 1 then '$.' else 'strict $.' 
        end Mode,
		CHARINDEX(col.name, @JsonColumns,0) as IsJson
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
				LEFT JOIN dbo.syscomments SM ON col.default_object_id = SM.id  
    where object_id = object_id(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName))
	-- Do not insert identity, computed columns, hidden columns, rowguid columns, generated always columns 
	-- Skip columns that cannot be parsed by JSON, e.g. text, sql_variant, etc. 
	and col.is_identity = 0
	and col.is_computed = 0
	and col.is_hidden = 0
	and col.is_rowguidcol = 0
	and generated_always_type = 0
	and (sm.text IS NULL OR sm.text NOT LIKE '(NEXT VALUE FOR%')
	and LOWER(typ.name) NOT IN ('text', 'ntext', 'sql_variant', 'image','hierarchyid','geometry','geography')
	and col.name NOT IN (SELECT value FROM STRING_SPLIT(@IgnoredColumns, ','))
)
select @TableSchema = @TableSchema + QUOTENAME(ColumnName) + ',' 
from col_def
order by ColumnId

SET @TableSchema = SUBSTRING(@TableSchema, 0, LEN(@TableSchema)) --> remove last comma

declare @Result nvarchar(max) = 
N'DROP PROCEDURE IF EXISTS ' + QUOTENAME( @SchemaName) + '.' + QUOTENAME(@TableName + 'InsertJson') + '
GO
CREATE PROCEDURE ' + QUOTENAME( @SchemaName) + '.' + QUOTENAME(@TableName + 'InsertJson') + '(@' + @TableName + ' NVARCHAR(MAX))
AS BEGIN

	INSERT INTO ' + @TableName + '(' + @TableSchema + ')
	SELECT ' + @TableSchema + '
	FROM OPENJSON(' + @JsonParam + ')
		WITH (' + @JsonSchema + ')
END'

RETURN REPLACE(@Result,',)',')')
END

GO
/****** Object:  UserDefinedFunction [dbo].[LGNullToSQLNull]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LGNullToSQLNull]
(-- Input Parameter
@inputString VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
--CHECK FOR THE LG NULL STRING
DECLARE @LGNullString VARCHAR(10)
SET @LGNullString = '---.---'

If CHARINDEX(@LGNullString,@inputString) > 0
BEGIN
	RETURN NULL
END
	RETURN @inputString
END 
GO
/****** Object:  UserDefinedFunction [dbo].[TryParseAsDecimal]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TryParseAsDecimal]
(
    @Value      NVARCHAR(4000)
    ,@Precision INT
    ,@Scale     INT
)

RETURNS BIT
AS
BEGIN

    IF(ISNUMERIC(@Value) =0) BEGIN
        RETURN CAST(0 AS BIT)
    END
    SELECT @Value = REPLACE(@Value,',','') --Removes the comma

    --This function validates only the first part eg '1234567.8901111111'
    --It validates only the values before the '.' ie '1234567.'
    DECLARE @Index          INT
    DECLARE @Part1Length    INT 
    DECLARE @Part1          VARCHAR(4000)   

    SELECT @Index = CHARINDEX('.', @Value, 0)
    IF (@Index>0) BEGIN
        --If decimal places, extract the left part only and cast it to avoid leading zeros (eg.'0000000001' => '1')
        SELECT @Part1 =LEFT(@Value, @Index-1);
        SELECT @Part1=SUBSTRING(@Part1, PATINDEX('%[^0]%', @Part1+'.'), LEN(@Part1));
        SELECT @Part1Length = LEN(@Part1);
    END
    ELSE BEGIN
        SELECT @Part1 =CAST(@Value AS DECIMAL);
        SELECT @Part1Length= LEN(@Part1)
    END 

    IF (@Part1Length > (@Precision-@Scale)) BEGIN
        RETURN CAST(0 AS BIT)
    END

    RETURN CAST(1 AS BIT)

END
GO
/****** Object:  UserDefinedFunction [dbo].[Varchar2float]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Varchar2float]
(-- Input Parameter
@inputString VARCHAR(50))
RETURNS FLOAT
AS
BEGIN
--Prepare the string for casting/conversion
SET @inputString = Replace(@inputString,'-','')

--Perform the conversion and return the result
RETURN Cast(@inputString AS FLOAT)
END 
GO
/****** Object:  Table [dbo].[EnergyMetersDirisA20File]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyMetersDirisA20File](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_EnergyMetersDirisA20File]    Script Date: 26/05/2020 18:26:56 ******/
CREATE CLUSTERED INDEX [ix_EnergyMetersDirisA20File] ON [dbo].[EnergyMetersDirisA20File]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersDirisA20File]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersDirisA20File](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[EnergyMetersDirisA20File] )
)
GO
/****** Object:  Table [Staging].[JsonEnergyMetersFileHistory]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[JsonEnergyMetersFileHistory](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_JsonEnergyMetersFileHistory]    Script Date: 26/05/2020 18:26:56 ******/
CREATE CLUSTERED INDEX [ix_JsonEnergyMetersFileHistory] ON [Staging].[JsonEnergyMetersFileHistory]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[JsonEnergyMetersFile]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[JsonEnergyMetersFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [Staging].[JsonEnergyMetersFileHistory] )
)
GO
/****** Object:  Table [dbo].[Staging.EnergyMetersLGE650File]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staging.EnergyMetersLGE650File](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_Staging.EnergyMetersLGE650File]    Script Date: 26/05/2020 18:26:56 ******/
CREATE CLUSTERED INDEX [ix_Staging.EnergyMetersLGE650File] ON [dbo].[Staging.EnergyMetersLGE650File]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersLGE650File]    Script Date: 26/05/2020 18:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersLGE650File](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[Staging.EnergyMetersLGE650File] )
)
GO
/****** Object:  Table [dbo].[Staging.GasMetersFile]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staging.GasMetersFile](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_Staging.GasMetersFile]    Script Date: 26/05/2020 18:26:57 ******/
CREATE CLUSTERED INDEX [ix_Staging.GasMetersFile] ON [dbo].[Staging.GasMetersFile]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GasMetersFile]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GasMetersFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[Staging.GasMetersFile] )
)
GO
/****** Object:  Table [dbo].[Staging.GeneratorFileHistory]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staging.GeneratorFileHistory](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_FileHistory]    Script Date: 26/05/2020 18:26:57 ******/
CREATE CLUSTERED INDEX [ix_FileHistory] ON [dbo].[Staging.GeneratorFileHistory]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GeneratorFile]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GeneratorFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[Staging.GeneratorFileHistory] )
)
GO
/****** Object:  Table [Staging].[EnergyMetersFileHistory]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersFileHistory](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_EnergyMetersFileHistory]    Script Date: 26/05/2020 18:26:57 ******/
CREATE CLUSTERED INDEX [ix_EnergyMetersFileHistory] ON [Staging].[EnergyMetersFileHistory]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersFile]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [Staging].[EnergyMetersFileHistory] )
)
GO
/****** Object:  Table [dbo].[AlarmNotifications]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlarmNotifications](
	[Id] [uniqueidentifier] NOT NULL,
	[Deleted] [bit] NULL,
	[UserId] [uniqueidentifier] NULL,
	[Alarm] [bit] NULL,
	[Warning] [bit] NULL,
	[Sensor] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BB_SMSLog]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BB_SMSLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[SMS_SendTime] [datetime] NOT NULL,
	[SMS_Recipient] [nvarchar](14) NOT NULL,
	[SMS_Content] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_BB_SMSLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Blackboxes]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blackboxes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BB_SerialNo] [nvarchar](9) NOT NULL,
	[BB_Model] [int] NULL,
	[BB_MobileNo] [nchar](11) NULL,
	[BB_MobileNetworkName] [int] NULL,
	[ST_LastPingTime] [datetime] NULL,
	[ST_Latitude] [nvarchar](20) NULL,
	[ST_Longitude] [nvarchar](20) NULL,
	[ST_LastStatusUpdateTime] [datetime] NULL,
	[ST_GSMSignalLevel] [int] NULL,
	[ST_BatteryChargeLevel] [int] NULL,
	[ST_PowerSupplyType] [int] NULL,
	[ST_TimeSinceLastResetSeconds] [int] NULL,
	[ST_ComapLinkPresent] [bit] NULL,
	[ST_SentSMSCount] [int] NULL,
	[ST_RestartsCount] [int] NULL,
	[ST_AlertActivations] [int] NULL,
	[CFG_State] [int] NULL,
	[CFG_ConnectedControllersCount] [int] NULL,
	[CFG_SiteName] [nvarchar](25) NULL,
	[CFG_GensetName01] [nvarchar](25) NULL,
	[CFG_GensetName02] [nvarchar](25) NULL,
	[CFG_GensetName03] [nvarchar](25) NULL,
	[CFG_GensetName04] [nvarchar](25) NULL,
	[CFG_GensetName05] [nvarchar](25) NULL,
	[CFG_GensetName06] [nvarchar](25) NULL,
	[CFG_GensetName07] [nvarchar](25) NULL,
	[CFG_GensetName08] [nvarchar](25) NULL,
	[CFG_GensetSN01] [nvarchar](8) NULL,
	[CFG_GensetSN02] [nvarchar](8) NULL,
	[CFG_GensetSN03] [nvarchar](8) NULL,
	[CFG_GensetSN04] [nvarchar](8) NULL,
	[CFG_GensetSN05] [nvarchar](8) NULL,
	[CFG_GensetSN06] [nvarchar](8) NULL,
	[CFG_GensetSN07] [nvarchar](8) NULL,
	[CFG_GensetSN08] [nvarchar](8) NULL,
	[CFG_FTPPrefix] [nvarchar](6) NULL,
	[CFG_PortNo] [int] NULL,
	[CFG_BaudRate] [nvarchar](10) NULL,
	[CFG_EthernetModuleEn] [bit] NULL,
	[CFG_FirstControllerAddr] [int] NULL,
	[CFG_HMAddr01] [int] NULL,
	[CFG_HMAddr02] [int] NULL,
	[CFG_HMAddr03] [int] NULL,
	[CFG_HMAddr04] [int] NULL,
	[CFG_HMAddr05] [int] NULL,
	[CFG_HMAddr06] [int] NULL,
	[CFG_HMAddr07] [int] NULL,
	[CFG_HMAddr08] [int] NULL,
	[CFG_SMAddr01] [int] NULL,
	[CFG_SMAddr02] [int] NULL,
	[CFG_SMAddr03] [int] NULL,
	[CFG_SMAddr04] [int] NULL,
	[CFG_SMAddr05] [int] NULL,
	[CFG_SMAddr06] [int] NULL,
	[CFG_SMAddr07] [int] NULL,
	[CFG_SMAddr08] [int] NULL,
	[CFG_GMAddr01] [int] NULL,
	[CFG_GMAddr02] [int] NULL,
	[CFG_GMAddr03] [int] NULL,
	[CFG_GMAddr04] [int] NULL,
	[CFG_CommsObjFilePath] [nvarchar](200) NULL,
	[CFG_CommsObjNameStr] [nvarchar](max) NULL,
	[CFG_CommsObjDimStr] [nvarchar](max) NULL,
	[CFG_CommsObjTypeStr] [nvarchar](max) NULL,
	[CFG_CommsObjLenStr] [nvarchar](max) NULL,
	[CFG_CommsObjDecStr] [nvarchar](max) NULL,
	[CFG_CommsObjOfsStr] [nvarchar](max) NULL,
	[CFG_CommsObjObjStr] [nvarchar](max) NULL,
	[CFG_HistoryColNameStr] [nvarchar](max) NULL,
	[CFG_HistoryColIDsStr] [nvarchar](max) NULL,
	[CFG_HistoryColTypeStr] [nvarchar](max) NULL,
	[CFG_DevMode] [bit] NULL,
	[CFG_AddOnCallNo01] [nchar](11) NULL,
	[CFG_AddOnCallNo02] [nchar](11) NULL,
	[CFG_AddOnCallNo03] [nchar](11) NULL,
	[CFG_AddOnCallNo04] [nchar](11) NULL,
	[CFG_AddOnCallNo05] [nchar](11) NULL,
	[CFG_GenStatEmail] [nvarchar](50) NULL,
	[CFG_AdminEmail] [nvarchar](50) NULL,
	[CFG_ModbusSlaveEn] [bit] NULL,
	[CFG_STORWarnEn] [bit] NULL,
	[CFG_RegDemand] [int] NULL,
	[CFG_RegCylTempAvg] [int] NULL,
	[CFG_RegCylTempMax] [int] NULL,
	[CFG_RegCylTempMin] [int] NULL,
	[CreationDate] [datetime] NULL,
	[CreatedBy] [nvarchar](30) NULL,
	[CFG_LG_E650_SN01] [nchar](8) NULL,
	[CFG_LG_E650_SN02] [nchar](8) NULL,
	[CFG_LG_E650_SN03] [nchar](8) NULL,
	[CFG_LG_E650_SN04] [nchar](8) NULL,
	[CFG_LG_PortNo] [int] NULL,
	[CFG_RegRSG40Gas_Instantaneous] [int] NULL,
	[CFG_RegRSG40Gas_Totalizer] [int] NULL,
	[CFG_DirAddr01] [int] NULL,
	[CFG_DirAddr02] [int] NULL,
	[CFG_DirAddr03] [int] NULL,
	[CFG_DirAddr04] [int] NULL,
	[CFG_Dir_A20_SN01] [nchar](12) NULL,
	[CFG_Dir_A20_SN02] [nchar](12) NULL,
	[CFG_Dir_A20_SN03] [nchar](12) NULL,
	[CFG_Dir_A20_SN04] [nchar](12) NULL,
	[CFG_RSG40_GasEn] [bit] NULL,
	[CFG_MaxRecordsPerFile] [int] NULL,
	[CFG_GensetName09] [nvarchar](25) NULL,
	[CFG_GensetName10] [nvarchar](25) NULL,
	[CFG_GensetName11] [nvarchar](25) NULL,
	[CFG_GensetName12] [nvarchar](25) NULL,
	[CFG_GensetSN09] [nvarchar](8) NULL,
	[CFG_GensetSN10] [nvarchar](8) NULL,
	[CFG_GensetSN11] [nvarchar](8) NULL,
	[CFG_GensetSN12] [nvarchar](8) NULL,
	[CFG_IPAddr01] [varchar](20) NULL,
	[CFG_IPAddr02] [varchar](20) NULL,
	[CFG_IPAddr03] [varchar](20) NULL,
	[CFG_IPAddr04] [varchar](20) NULL,
	[CFG_IPAddr05] [varchar](20) NULL,
	[CFG_IPAddr06] [varchar](20) NULL,
	[CFG_IPAddr07] [varchar](20) NULL,
	[CFG_IPAddr08] [varchar](20) NULL,
	[CFG_IPAddr09] [varchar](20) NULL,
	[CFG_IPAddr10] [varchar](20) NULL,
	[CFG_IPAddr11] [varchar](20) NULL,
	[CFG_IPAddr12] [varchar](20) NULL,
	[CFG_AccessCode] [nvarchar](24) NULL,
	[CFG_Password] [nvarchar](4) NULL,
	[CFG_UserId] [nvarchar](4) NULL,
	[CFG_iMainsSlaveId] [int] NULL,
	[CFG_iMainsSN] [nvarchar](8) NULL,
	[CFG_iMainsIPAddr] [varchar](20) NULL,
	[CFG_iMainsCommsObjNameStr] [nvarchar](max) NULL,
	[CFG_iMainsCommsObjDimStr] [nvarchar](max) NULL,
	[CFG_iMainsCommsObjTypeStr] [nvarchar](max) NULL,
	[CFG_iMainsCommsObjLenStr] [nvarchar](max) NULL,
	[CFG_iMainsCommsObjDecStr] [nvarchar](max) NULL,
	[CFG_iMainsCommsObjOfsStr] [nvarchar](max) NULL,
	[CFG_iMainsCommsObjObjStr] [nvarchar](max) NULL,
	[CFG_iMainsHistoryColNameStr] [nvarchar](max) NULL,
	[CFG_iMainsHistoryColIDsStr] [nvarchar](max) NULL,
	[CFG_iMainsHistoryColTypeStr] [nvarchar](max) NULL,
	[CFG_AltCommsObj_En] [bit] NULL,
	[CFG_AltCommsObjNameStr] [nvarchar](max) NULL,
	[CFG_AltCommsObjDimStr] [nvarchar](max) NULL,
	[CFG_AltCommsObjTypeStr] [nvarchar](max) NULL,
	[CFG_AltCommsObjLenStr] [nvarchar](max) NULL,
	[CFG_AltCommsObjDecStr] [nvarchar](max) NULL,
	[CFG_AltCommsObjOfsStr] [nvarchar](max) NULL,
	[CFG_AltCommsObjObjStr] [nvarchar](max) NULL,
	[CFG_AltHistoryColNameStr] [nvarchar](max) NULL,
	[CFG_AltHistoryColIDsStr] [nvarchar](max) NULL,
	[CFG_AltHistoryColTypeStr] [nvarchar](max) NULL,
	[Enabled] [bit] NULL,
 CONSTRAINT [PK_Blackboxes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Blackboxes_Status]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blackboxes_Status](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Blackbox] [int] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[ST_GSMSignalLevel] [int] NOT NULL,
	[ST_BatteryChargeLevel] [int] NOT NULL,
	[ST_PowerSupplyType] [int] NOT NULL,
	[ST_TimeSinceLastResetSeconds] [int] NOT NULL,
	[ST_ComapLinkPresent] [bit] NOT NULL,
	[ST_RestartsCount] [int] NOT NULL,
 CONSTRAINT [PK_Blackboxes_Status_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategorizedEvents]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategorizedEvents](
	[ID_Event] [int] NOT NULL,
	[ID_Category] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientPagePermissions]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientPagePermissions](
	[Id] [uniqueidentifier] NOT NULL,
	[ClientId] [uniqueidentifier] NULL,
	[ViewPage] [bit] NULL,
	[EditPage] [bit] NULL,
	[PageId] [uniqueidentifier] NULL,
 CONSTRAINT [PK__ClientPa__3214EC072E60F40A] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClientPages]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientPages](
	[Id] [uniqueidentifier] NOT NULL,
	[IsEnabled] [bit] NULL,
	[PageName] [nvarchar](255) NULL,
	[PageArea] [nvarchar](255) NULL,
 CONSTRAINT [PK__ClientPa__3214EC0710F3A71E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 26/05/2020 18:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[Id] [uniqueidentifier] NOT NULL,
	[Deleted] [bit] NULL,
	[Name] [nvarchar](255) NULL,
	[Active] [bit] NULL,
	[ContactEmail] [nvarchar](255) NULL,
	[ContactName] [nvarchar](255) NULL,
	[ContactPhone] [nvarchar](255) NULL,
	[PhotoUrl] [nvarchar](255) NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[County] [nvarchar](255) NULL,
	[Postcode] [nvarchar](255) NULL,
	[ContractPeriod] [int] NULL,
	[StartDate] [datetime] NULL,
	[DateCreated] [datetime] NULL,
	[DisplayReports] [bit] NULL,
	[CreateUsers] [bit] NULL,
	[Notifications] [bit] NULL,
	[ScheduleModule] [bit] NULL,
	[GenerateReports] [bit] NULL,
	[GeneratorControls] [bit] NULL,
	[ClientPhoto] [varbinary](max) NULL,
 CONSTRAINT [PK__Clients__3214EC07BC8CF92E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ColumnLabels]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ColumnLabels](
	[ColumnName] [nvarchar](50) NOT NULL,
	[ColumnLabel] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ColumnNames]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ColumnNames](
	[ColumnLabel] [nvarchar](50) NOT NULL,
	[HeaderId] [int] NOT NULL,
	[IsInstantaneousPlot] [bit] NULL,
	[IsCumulativePlot] [bit] NULL,
	[IsCommon] [bit] NULL,
	[ColumnUnits] [nvarchar](20) NULL,
	[ColumnHtmlColor] [nvarchar](20) NULL,
	[IsAvailableInReports] [bit] NULL,
 CONSTRAINT [PK_ColumnNames] PRIMARY KEY CLUSTERED 
(
	[HeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComAp_BinaryTypes]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComAp_BinaryTypes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ID_Blackbox] [int] NOT NULL,
	[Type] [nvarchar](15) NOT NULL,
	[Tooltip] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ComAp_BinaryTypes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComAp_BinaryTypes_Mapping]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComAp_BinaryTypes_Mapping](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ID_Blackbox] [int] NOT NULL,
	[ColumnName] [nvarchar](30) NOT NULL,
	[ID_BinaryType] [int] NOT NULL,
 CONSTRAINT [PK_ComAp_BinaryTypes_Mapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComAp_Headers]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComAp_Headers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[History_Header] [nvarchar](30) NOT NULL,
	[History_Description] [nvarchar](100) NOT NULL,
	[Fixed] [bit] NULL,
	[Required] [bit] NULL,
	[Type] [nvarchar](30) NULL,
	[IncludeInSchema] [bit] NULL,
	[ExtendedProcessed] [bit] NULL,
 CONSTRAINT [PK_ComAp_Headers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComAp_Wildcard]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComAp_Wildcard](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_Header] [int] NOT NULL,
	[CommsObj_Name] [nvarchar](50) NOT NULL,
	[CommsObj_Dim] [nvarchar](10) NULL,
	[CommsObj_Type] [nvarchar](10) NULL,
	[CommsObj_Len] [int] NULL,
	[CommsObj_Dec] [int] NULL,
	[CommsObj_Ofs] [int] NULL,
	[CommsObj_Obj] [int] NULL,
	[Approved] [bit] NULL,
 CONSTRAINT [PK_ComAp_Wildcard] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComAPOptions]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComAPOptions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [uniqueidentifier] NULL,
	[ColumnID] [int] NULL,
	[ColumnName] [nvarchar](255) NULL,
	[State] [int] NULL,
	[Hidden] [bit] NULL,
	[Visible] [bit] NULL,
	[UserID] [uniqueidentifier] NULL,
 CONSTRAINT [PK__ComAPOpt__3214EC273A1D8AC2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConfigEfficiency]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigEfficiency](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[GasVolumeColumnName] [nvarchar](30) NULL,
	[GasCalorificValue] [float] NULL,
	[IsGasVolumeCorrected] [bit] NULL,
 CONSTRAINT [PK_ConfigEfficiency] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConfigReport]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigReport](
	[IdLocation] [int] NOT NULL,
	[ShowEfficiency] [bit] NULL,
	[ShowUptime] [bit] NULL,
	[TrendChartArray] [nvarchar](max) NULL,
	[AvailabilityBasedOnUnitUnavailableFlag] [bit] NULL,
 CONSTRAINT [PK_ConfigReport] PRIMARY KEY CLUSTERED 
(
	[IdLocation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractInformation]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractInformation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ContractType] [nvarchar](50) NOT NULL,
	[ContractOutput] [int] NOT NULL,
	[ContractAvailability] [decimal](6, 4) NULL,
	[DutyCycle] [int] NOT NULL,
	[ContractLength] [int] NULL,
	[ContractStartDate] [date] NULL,
	[InitialRunHrs] [int] NULL,
	[InitialKwHours] [int] NULL,
	[ID_ContractType] [int] NULL,
 CONSTRAINT [PK_ContractInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractTypes]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Contract_Type] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_ContractTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataBaseLog]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataBaseLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Time_Stamp] [datetime] NOT NULL,
	[UserName] [nchar](256) NOT NULL,
	[UserAction] [ntext] NOT NULL,
 CONSTRAINT [PK_DataBaseLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnergyMeters_LG_E650]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyMeters_LG_E650](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Timestamp] [datetime] NULL,
	[Serial] [nvarchar](255) NULL,
	[F_F] [nvarchar](255) NULL,
	[0_9_1] [nvarchar](255) NULL,
	[0_9_2] [nvarchar](255) NULL,
	[1_2_0] [real] NULL,
	[2_2_0] [real] NULL,
	[3_2_0] [real] NULL,
	[4_2_0] [real] NULL,
	[1_6_0] [real] NULL,
	[2_6_0] [real] NULL,
	[3_6_0] [real] NULL,
	[4_6_0] [real] NULL,
	[1_8_1] [real] NULL,
	[2_8_1] [real] NULL,
	[3_8_1] [real] NULL,
	[4_8_1] [real] NULL,
	[0_4_2] [real] NULL,
	[32_7] [real] NULL,
	[52_7] [real] NULL,
	[72_7] [real] NULL,
	[1-1:32_36_0] [real] NULL,
	[1-1:52_36_0] [real] NULL,
	[1-1:72_36_0] [real] NULL,
	[1-1:32_32_0] [real] NULL,
	[1-1:52_32_0] [real] NULL,
	[1-1:72_32_0] [real] NULL,
	[16_7_0] [real] NULL,
	[36_7_0] [real] NULL,
	[56_7_0] [real] NULL,
	[1_8_0] [real] NULL,
	[IdLocation] [int] NULL,
	[UtcRecieved] [datetime] NULL,
	[UtcGenerated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnergyMeters_MakeModel]    Script Date: 26/05/2020 18:26:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyMeters_MakeModel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Make] [nvarchar](20) NOT NULL,
	[Model] [nvarchar](20) NOT NULL,
	[DataTableName] [nvarchar](50) NULL,
 CONSTRAINT [PK_EnergyMeters_MakeModel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnergyMeters_Mapping]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyMeters_Mapping](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[ID_Type] [int] NOT NULL,
	[Modbus_Addr] [int] NOT NULL,
 CONSTRAINT [PK_EnergyMeters_Mapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnergyMeters_Mapping_Serial]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyMeters_Mapping_Serial](
	[Serial] [nchar](12) NOT NULL,
	[ID_Location] [int] NULL,
	[ID_Type] [int] NULL,
	[ID_MakeModel] [int] NULL,
 CONSTRAINT [PK_EnergyMeters_Diris_A20_Mapping] PRIMARY KEY CLUSTERED 
(
	[Serial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnergyMeters_Types]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyMeters_Types](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Meter_Type] [nvarchar](30) NOT NULL,
	[Meter_Category] [int] NULL,
 CONSTRAINT [PK_EnergyMeters_Types] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnergyMeters_Types_Categories]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyMeters_Types_Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Category_Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EnergyMeters_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EngineTypes]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngineTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Make] [nvarchar](50) NOT NULL,
	[Model] [nvarchar](50) NOT NULL,
	[Cylinders] [int] NULL,
	[MaximumOutput] [int] NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_EngineTypes2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventCategory]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventCategory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EventCategory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exempts]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exempts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[IDDown] [int] NOT NULL,
	[IDUp] [int] NOT NULL,
	[DtDown] [datetime] NOT NULL,
	[DtUp] [datetime] NOT NULL,
	[TimeDifference] [int] NOT NULL,
	[IsExempt] [bit] NULL,
	[Reason] [nvarchar](200) NULL,
	[Details] [nvarchar](40) NULL,
	[OrigDtUp] [datetime] NULL,
	[NewDtUp] [datetime] NULL,
	[NewTimeDifference] [int] NULL,
	[Custom] [bit] NULL,
	[IsExcluded] [bit] NULL,
 CONSTRAINT [PK_Exempts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exempts_Trigger]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exempts_Trigger](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[IDDown] [int] NOT NULL,
	[IDUp] [int] NOT NULL,
	[DtDown] [datetime] NOT NULL,
	[DtUp] [datetime] NOT NULL,
	[TimeDifference] [int] NOT NULL,
	[IsExempt] [bit] NULL,
	[Reason] [nvarchar](200) NULL,
	[Details] [nvarchar](40) NULL,
	[OrigDtUp] [datetime] NULL,
	[NewDtUp] [datetime] NULL,
	[NewTimeDifference] [int] NULL,
	[Custom] [bit] NULL,
	[IsExcluded] [bit] NULL,
 CONSTRAINT [PK_Exempts_Trigger] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GasMeters_Mapping]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GasMeters_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[Modbus_Addr] [int] NOT NULL,
	[ID_Type] [int] NULL,
 CONSTRAINT [PK_GasMeters_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GasTypes]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GasTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Gas_Type] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GasTypes_Mapping]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GasTypes_Mapping](
	[ID_Location] [int] NOT NULL,
	[ID_GasType] [int] NOT NULL,
 CONSTRAINT [PK_GasTypes_Mapping] PRIMARY KEY CLUSTERED 
(
	[ID_Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneratorAlarms]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneratorAlarms](
	[Guid] [uniqueidentifier] NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcReceived] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Active] [bit] NULL,
	[Confirmed] [bit] NULL,
	[Type] [nvarchar](10) NULL,
	[UsersNotified] [bit] NULL,
 CONSTRAINT [PK__Generato__A2B5777CA3419A9C] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Generato__A2B5777D17C80F07] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneratorAvailability]    Script Date: 26/05/2020 18:26:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneratorAvailability](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[IdUnavailable] [int] NOT NULL,
	[IdAvailable] [int] NOT NULL,
	[DtUnavailable] [datetime] NOT NULL,
	[DtAvailable] [datetime] NOT NULL,
	[TimeDifference] [int] NOT NULL,
	[IsExempt] [bit] NULL,
	[Reason] [nvarchar](200) NULL,
	[Details] [nvarchar](40) NULL,
	[Exclude] [bit] NULL,
	[OrigDtUnavailable] [datetime] NULL,
	[OrigDtAvailable] [datetime] NULL,
	[NewTimeDifference] [int] NULL,
	[Custom] [bit] NULL,
 CONSTRAINT [PK_GeneratorAvailability] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneratorContent]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneratorContent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcRecieved] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[IdEvent] [int] NOT NULL,
	[Event] [nvarchar](128) NULL,
	[Extended] [nvarchar](4000) NULL,
	[_ShutdownProcessed] [bit] NULL,
	[_StartupProcessed] [bit] NULL,
	[_AvailabilityProcessed] [bit] NULL,
	[_UpdateProcessed] [bit] NULL,
	[RPM] [smallint] NULL,
	[Pwr] [smallint] NULL,
	[PF] [float] NULL,
	[Gfrq] [float] NULL,
	[Vg1] [smallint] NULL,
	[Vg2] [smallint] NULL,
	[Vg3] [smallint] NULL,
	[Vg12] [smallint] NULL,
	[Vg23] [smallint] NULL,
	[Vg31] [smallint] NULL,
	[Ig1] [smallint] NULL,
	[Ig2] [smallint] NULL,
	[Ig3] [smallint] NULL,
	[Mfrq] [float] NULL,
	[Vm1] [smallint] NULL,
	[Vm2] [smallint] NULL,
	[Vm3] [smallint] NULL,
	[Vm12] [smallint] NULL,
	[Vm23] [smallint] NULL,
	[Vm31] [smallint] NULL,
	[MPF] [float] NULL,
	[SRO] [float] NULL,
	[VRO] [float] NULL,
	[Mode] [char](3) NULL,
	[kWhour] [int] NULL,
	[Runhrs] [int] NULL,
	[ActPwr] [smallint] NULL,
	[ActDem] [smallint] NULL,
	[CylA1] [smallint] NULL,
	[CylA2] [smallint] NULL,
	[CylA3] [smallint] NULL,
	[CylA4] [smallint] NULL,
	[CylA5] [smallint] NULL,
	[CylA6] [smallint] NULL,
	[CylA7] [smallint] NULL,
	[CylA8] [smallint] NULL,
	[CylA9] [smallint] NULL,
	[CylA10] [smallint] NULL,
	[CylB1] [smallint] NULL,
	[CylB2] [smallint] NULL,
	[CylB3] [smallint] NULL,
	[CylB4] [smallint] NULL,
	[CylB5] [smallint] NULL,
	[CylB6] [smallint] NULL,
	[CylB7] [smallint] NULL,
	[CylB8] [smallint] NULL,
	[CylB9] [smallint] NULL,
	[CylB10] [smallint] NULL,
	[BIN] [nchar](16) NULL,
	[BOUT] [nchar](16) NULL,
	[MVS] [float] NULL,
	[ActPwrReq] [smallint] NULL,
	[Ubat] [float] NULL,
	[CPUT] [float] NULL,
	[TEMv] [float] NULL,
	[LChr] [char](1) NULL,
	[OilB4F] [float] NULL,
	[OilLev] [float] NULL,
	[OilT] [float] NULL,
	[CCPres] [float] NULL,
	[AirInT] [float] NULL,
	[RecAT] [float] NULL,
	[ThrPos] [float] NULL,
	[CH4] [float] NULL,
	[JWTin] [float] NULL,
	[JWTout] [float] NULL,
	[Numstr] [smallint] NULL,
	[BI1] [nchar](8) NULL,
	[BI2] [nchar](8) NULL,
	[BI3] [nchar](8) NULL,
	[BI4] [nchar](8) NULL,
	[BI5] [nchar](8) NULL,
	[BI6] [nchar](8) NULL,
	[BI7] [nchar](8) NULL,
	[BI8] [nchar](8) NULL,
	[BI9] [nchar](8) NULL,
	[BI10] [nchar](8) NULL,
	[BI11] [nchar](8) NULL,
	[BI12] [nchar](8) NULL,
	[BO1] [nchar](8) NULL,
	[BO2] [nchar](8) NULL,
	[BO3] [nchar](8) NULL,
	[BO4] [nchar](8) NULL,
	[BO5] [nchar](8) NULL,
	[Pmns] [smallint] NULL,
	[Qmns] [smallint] NULL,
	[ActPfi] [smallint] NULL,
	[MLChr] [char](1) NULL,
	[Amb] [float] NULL,
	[kVarho] [int] NULL,
	[GasP] [float] NULL,
	[LTHWfT] [float] NULL,
	[LTHWrT] [float] NULL,
	[GFlwRte] [float] NULL,
	[GFlwM3] [int] NULL,
	[H2S] [smallint] NULL,
	[NumUns] [smallint] NULL,
	[PwrDem] [smallint] NULL,
	[JWGKin] [float] NULL,
	[HWFlo] [float] NULL,
	[HWRtn] [float] NULL,
	[GasMet] [int] NULL,
	[IcOut] [smallint] NULL,
	[ImpLoad] [smallint] NULL,
	[Q] [float] NULL,
	[U] [float] NULL,
	[V] [float] NULL,
	[W] [float] NULL,
	[Grokwh] [int] NULL,
	[Auxkwh] [int] NULL,
	[TotRunPact] [int] NULL,
	[TotRunPnomAll] [int] NULL,
	[SumMWh] [int] NULL,
	[Generator] [nvarchar](255) NULL,
	[Reason] [nvarchar](255) NULL,
 CONSTRAINT [PK_GeneratorContent] PRIMARY KEY NONCLUSTERED 
(
	[TimeStamp] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [partScheme_GeneratorContent_TimeStamp]([TimeStamp])
) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_TimeStamp]    Script Date: 26/05/2020 18:27:00 ******/
CREATE CLUSTERED INDEX [IDX_GeneratorContent_TimeStamp] ON [dbo].[GeneratorContent]
(
	[TimeStamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneratorContentUpdates]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneratorContentUpdates](
	[IdLocation] [int] NOT NULL,
	[UtcRecieved] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TimeStamp] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneratorLogs]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneratorLogs](
	[Guid] [uniqueidentifier] NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcReceived] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Level] [nvarchar](50) NOT NULL,
	[Data_A] [nvarchar](500) NULL,
	[Data_B] [nvarchar](500) NULL,
 CONSTRAINT [PK__Generato__A2B5777CE025AABA] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Generato__A2B5777D5672C640] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneratorMeasurements]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneratorMeasurements](
	[Guid] [uniqueidentifier] NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcReceived] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[NominalOutput] [int] NOT NULL,
	[PowerOutput] [int] NOT NULL,
	[ActualPower] [int] NOT NULL,
	[ActualDemand] [int] NOT NULL,
	[RPM] [int] NOT NULL,
	[GenVolts1] [int] NOT NULL,
	[GenVolts2] [int] NOT NULL,
	[GenVolts3] [int] NOT NULL,
	[GenVolts12] [int] NOT NULL,
	[GenVolts23] [int] NOT NULL,
	[GenVolts31] [int] NOT NULL,
	[GenFreq] [float] NOT NULL,
	[GenCurr1] [int] NOT NULL,
	[GenCurr2] [int] NOT NULL,
	[GenCurr3] [int] NOT NULL,
	[GenPF] [float] NOT NULL,
	[GenLChar] [char](1) NOT NULL,
	[MainsVolts1] [int] NOT NULL,
	[MainsVolts2] [int] NOT NULL,
	[MainsVolts3] [int] NOT NULL,
	[MainsVolts12] [int] NOT NULL,
	[MainsVolts23] [int] NOT NULL,
	[MainsVolts31] [int] NOT NULL,
	[MainsFreq] [float] NOT NULL,
	[MainsPF] [float] NOT NULL,
	[MainsLChar] [char](1) NOT NULL,
	[BattVolt] [float] NOT NULL,
	[TotalRunHrs] [int] NOT NULL,
	[NumStarts] [int] NOT NULL,
	[TotalKwh] [int] NOT NULL,
	[ActiveAlarmCount] [tinyint] NOT NULL,
	[Engine] [tinyint] NOT NULL,
	[Breaker] [tinyint] NOT NULL,
	[Controller] [tinyint] NOT NULL,
	[BoutIndicator] [tinyint] NULL,
	[GCBStatus] [bit] NULL,
	[MCBStatus] [bit] NULL,
 CONSTRAINT [PK__Generato__A2B5777CB7FB0487] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Generato__A2B5777DFDCCD446] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GeneratorServiceIntervals]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeneratorServiceIntervals](
	[IdLocation] [int] NOT NULL,
	[IntervalHours] [int] NOT NULL,
 CONSTRAINT [PK_GeneratorServiceIntervals] PRIMARY KEY CLUSTERED 
(
	[IdLocation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GensetComments]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GensetComments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[CommentDate] [datetime] NOT NULL,
	[Comment] [nvarchar](512) NOT NULL,
	[Flag] [bit] NULL,
 CONSTRAINT [PK_GensetComments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GensetLocations]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GensetLocations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[Latitude] [numeric](18, 6) NOT NULL,
	[Longitude] [numeric](18, 6) NOT NULL,
	[Description] [nvarchar](300) NULL,
 CONSTRAINT [PK_GensetLocations1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HL_Events]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HL_Events](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[REASON] [nvarchar](18) NOT NULL,
	[Label] [nvarchar](50) NULL,
 CONSTRAINT [PK_HL_Events] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HL_Locations]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HL_Locations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GENSET_SN] [nvarchar](8) NOT NULL,
	[GENSETNAME] [nvarchar](25) NOT NULL,
	[SITENAME] [nvarchar](25) NOT NULL,
	[ID_ContractInformation] [int] NULL,
	[LASTUPDATE] [datetime] NULL,
	[BLACKBOX_SN] [nvarchar](9) NULL,
	[ID_SMS_Group] [int] NULL,
	[GensetEnabled] [bit] NULL,
	[ID_EngineType] [int] NULL,
	[PlantId] [uniqueidentifier] NULL,
	[ClientId] [uniqueidentifier] NULL,
	[IsMasterController] [bit] NULL,
	[SchedulerClientId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_HL_Locations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IdentityRoleAccess]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IdentityRoleAccess](
	[RoleId] [nvarchar](128) NOT NULL,
	[FilePageName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IdentityRoleFunctionAccess]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IdentityRoleFunctionAccess](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
	[FunctionId] [int] NOT NULL,
 CONSTRAINT [PK_Table_1_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IdentityRoleFunctions]    Script Date: 26/05/2020 18:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IdentityRoleFunctions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FunctionName] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_IdentityRoleFunctions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InteliMainsMeasurements]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InteliMainsMeasurements](
	[Guid] [uniqueidentifier] NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcReceived] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TotRunNominalAll] [int] NOT NULL,
	[TotRunNominal] [int] NOT NULL,
	[TotAvgNominal] [int] NOT NULL,
	[TotRunOutput] [int] NOT NULL,
	[TotRunPF] [float] NOT NULL,
	[TotRunLChar] [char](1) NOT NULL,
	[ActReserve] [int] NOT NULL,
	[ActReserveRel] [int] NOT NULL,
	[ActPwrReq] [int] NOT NULL,
	[BusVolts1] [int] NOT NULL,
	[BusVolts2] [int] NOT NULL,
	[BusVolts3] [int] NOT NULL,
	[BusVolts12] [int] NOT NULL,
	[BusVolts23] [int] NOT NULL,
	[BusVolts31] [int] NOT NULL,
	[BusFreq] [float] NOT NULL,
	[MainsImport] [int] NOT NULL,
	[MainsVolts1] [int] NOT NULL,
	[MainsVolts2] [int] NOT NULL,
	[MainsVolts3] [int] NOT NULL,
	[MainsVolts12] [int] NOT NULL,
	[MainsVolts23] [int] NOT NULL,
	[MainsVolts31] [int] NOT NULL,
	[MainsCurr1] [int] NOT NULL,
	[MainsCurr2] [int] NOT NULL,
	[MainsCurr3] [int] NOT NULL,
	[MainsFreq] [float] NOT NULL,
	[MainsPF] [float] NOT NULL,
	[MainsLChar] [char](1) NOT NULL,
	[BattVolt] [float] NOT NULL,
	[SumMwh] [int] NOT NULL,
	[MKwhE] [int] NOT NULL,
	[MKwhI] [int] NOT NULL,
	[PulseC1] [int] NOT NULL,
	[PulseC2] [int] NOT NULL,
	[ActiveAlarmCount] [tinyint] NOT NULL,
	[Breaker] [tinyint] NOT NULL,
	[Controller] [tinyint] NOT NULL,
	[BoutIndicator] [tinyint] NULL,
	[MCBStatus] [bit] NULL,
 CONSTRAINT [PK__InteliMa__A2B5777C8DF0C063] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__InteliMa__A2B5777D244D83E4] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoadTimes]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoadTimes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Location] [int] NOT NULL,
	[IDStart] [int] NOT NULL,
	[IDFullLoad] [int] NOT NULL,
	[DtStart] [datetime] NOT NULL,
	[DtFullLoad] [datetime] NOT NULL,
	[TimeDifference] [int] NOT NULL,
	[IsExempt] [bit] NULL,
	[Reason] [nvarchar](200) NULL,
	[Details] [nvarchar](40) NULL,
	[Exclude] [bit] NULL,
	[OrigDtStart] [datetime] NULL,
	[OrigDtFullLoad] [datetime] NULL,
	[NewTimeDifference] [int] NULL,
	[Custom] [bit] NULL,
 CONSTRAINT [PK_LoadTimes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogSystem]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogSystem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Time_Stamp] [datetime] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Action] [ntext] NOT NULL,
	[ActionPage] [nvarchar](150) NULL,
 CONSTRAINT [PK_LogSystem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogUser]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Time_Stamp] [datetime] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[UserAction] [ntext] NOT NULL,
 CONSTRAINT [PK_LogUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MQTTPublishCommands]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MQTTPublishCommands](
	[Id] [uniqueidentifier] NOT NULL,
	[Deleted] [bit] NULL,
	[CommandName] [nvarchar](255) NULL,
	[CommandData] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
 CONSTRAINT [PK__MQTTPubl__3214EC07B4383F52] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionRoles]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionRoles](
	[Id] [uniqueidentifier] NOT NULL,
	[IsEnabled] [bit] NULL,
	[RoleName] [nvarchar](255) NULL,
	[RoleDescription] [nvarchar](255) NULL,
	[ClientId] [uniqueidentifier] NULL,
	[Deleted] [bit] NULL,
 CONSTRAINT [PK__Permissi__3214EC070BB3E811] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlantGeneratorJoins]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlantGeneratorJoins](
	[GeneratorId] [int] NOT NULL,
	[PlantId] [uniqueidentifier] NOT NULL,
	[Deleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[GeneratorId] ASC,
	[PlantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Plants]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Plants](
	[Id] [uniqueidentifier] NOT NULL,
	[Deleted] [bit] NULL,
	[Name] [nvarchar](255) NULL,
	[Active] [bit] NULL,
	[ClientId] [uniqueidentifier] NULL,
 CONSTRAINT [PK__Plants__3214EC07ED057BD1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolePagePermissions]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePagePermissions](
	[Id] [uniqueidentifier] NOT NULL,
	[ViewPage] [bit] NULL,
	[EditPage] [bit] NULL,
	[PageId] [uniqueidentifier] NULL,
	[PermissionRoleId] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleUserJoins]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleUserJoins](
	[RoleId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Deleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RTCULogs]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RTCULogs](
	[Guid] [uniqueidentifier] NOT NULL,
	[IdBlackbox] [int] NOT NULL,
	[UtcReceived] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Level] [nvarchar](50) NOT NULL,
	[Data_A] [nvarchar](500) NULL,
	[Data_B] [nvarchar](500) NULL,
 CONSTRAINT [PK__RTCULog__A2B5777C999D1FEE] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__RTCULog__A2B5777DF84B230E] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RTCUReport]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RTCUReport](
	[Guid] [uniqueidentifier] NOT NULL,
	[IdBlackbox] [int] NOT NULL,
	[UtcReceived] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[BattCharge] [tinyint] NOT NULL,
	[SupplyType] [tinyint] NOT NULL,
	[ComApLink] [bit] NOT NULL,
	[BoardModel] [int] NOT NULL,
	[FirmVer] [int] NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppVer] [int] NOT NULL,
	[PrimaryMedia] [tinyint] NOT NULL,
	[SecondaryMedia] [tinyint] NULL,
	[GSMSignal] [int] NOT NULL,
	[LastReset] [int] NOT NULL,
	[Restarts] [int] NOT NULL,
 CONSTRAINT [PK__RTCURepo__A2B5777CFDB595ED] PRIMARY KEY CLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__RTCURepo__A2B5777DB059B7F7] UNIQUE NONCLUSTERED 
(
	[Guid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduledEvents]    Script Date: 26/05/2020 18:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduledEvents](
	[Id] [uniqueidentifier] NOT NULL,
	[Deleted] [bit] NULL,
	[PlantID] [uniqueidentifier] NULL,
	[Subject] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IsFullDay] [bit] NULL,
	[RecurrenceRule] [nvarchar](255) NULL,
	[RecurrenceException] [nvarchar](255) NULL,
	[Generator] [int] NULL,
	[MQTTCommand] [int] NULL,
	[CommandName] [nvarchar](255) NULL,
	[GeneratorName] [nvarchar](255) NULL,
	[UserCreatedBy] [nvarchar](255) NULL,
 CONSTRAINT [PK__Schedule__3214EC079FEA097D] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sms_Mapping]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sms_Mapping](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[SMS_Group] [nvarchar](50) NULL,
	[SMS_Recipient] [nvarchar](14) NULL,
 CONSTRAINT [PK__sms_Mapp__3213E83F679B76CF] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Update_Control]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Update_Control](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_Update_Control] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[updateProgress]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[updateProgress](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[updFunction] [varchar](255) NULL,
	[updPercentage] [float] NULL,
	[startValue] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPagePermissions]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPagePermissions](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[ViewPage] [bit] NULL,
	[EditPage] [bit] NULL,
	[PageId] [uniqueidentifier] NULL,
	[PermissionRoleId] [uniqueidentifier] NULL,
 CONSTRAINT [PK__UserPage__3214EC07E5342F4B] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[Id] [uniqueidentifier] NOT NULL,
	[IsEnabled] [bit] NULL,
	[RoleName] [nvarchar](255) NULL,
	[RoleDescription] [nvarchar](255) NULL,
 CONSTRAINT [PK__UserRole__3214EC0741AEF8A9] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [EnergyMeters].[DirisA20]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EnergyMeters].[DirisA20](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcRecieved] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[IdMeter] [int] NOT NULL,
	[Serial] [nchar](12) NOT NULL,
	[I-1] [float] NULL,
	[I-2] [float] NULL,
	[I-3] [float] NULL,
	[I-N] [float] NULL,
	[V1-2] [float] NULL,
	[V2-3] [float] NULL,
	[V3-1] [float] NULL,
	[V1-N] [float] NULL,
	[V2-N] [float] NULL,
	[V3-N] [float] NULL,
	[F] [float] NULL,
	[P] [float] NULL,
	[Q] [float] NULL,
	[S] [float] NULL,
	[PF] [float] NULL,
	[W] [float] NULL,
	[Wr] [float] NULL,
 CONSTRAINT [PK_DirisA20] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [EnergyMeters].[E650]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EnergyMeters].[E650](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcRecieved] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[Serial] [nchar](10) NOT NULL,
	[F_F] [nchar](10) NULL,
	[0_9_1] [nchar](10) NULL,
	[0_9_2] [nchar](10) NULL,
	[1_2_0] [float] NULL,
	[2_2_0] [float] NULL,
	[3_2_0] [float] NULL,
	[4_2_0] [float] NULL,
	[1_6_0] [float] NULL,
	[2_6_0] [float] NULL,
	[3_6_0] [float] NULL,
	[4_6_0] [float] NULL,
	[1_8_1] [float] NULL,
	[2_8_1] [float] NULL,
	[3_8_1] [float] NULL,
	[4_8_1] [float] NULL,
	[0_4_2] [float] NULL,
	[32_7] [float] NULL,
	[52_7] [float] NULL,
	[72_7] [float] NULL,
	[1-1:32_36_0] [float] NULL,
	[1-1:52_36_0] [float] NULL,
	[1-1:72_36_0] [float] NULL,
	[1-1:32_32_0] [float] NULL,
	[1-1:52_32_0] [float] NULL,
	[1-1:72_32_0] [float] NULL,
	[16_7_0] [float] NULL,
	[36_7_0] [float] NULL,
	[56_7_0] [float] NULL,
	[1_8_0] [float] NULL,
 CONSTRAINT [PK_E650] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [EnergyMeters].[Gas]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EnergyMeters].[Gas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcRecieved] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[IdMeter] [int] NOT NULL,
	[MassFlow] [float] NULL,
	[Totaliser] [float] NULL,
 CONSTRAINT [PK_Gas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [EnergyMeters].[Heat]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EnergyMeters].[Heat](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcRecieved] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[IdMeter] [int] NOT NULL,
	[Power] [float] NULL,
	[Energy] [float] NULL,
	[Flow] [float] NULL,
	[TempWarm] [float] NULL,
	[TempCold] [float] NULL,
 CONSTRAINT [PK_Heat] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [EnergyMeters].[Steam]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EnergyMeters].[Steam](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdLocation] [int] NOT NULL,
	[UtcRecieved] [datetime] NOT NULL,
	[UtcGenerated] [datetime] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[IdMeter] [int] NOT NULL,
	[Power] [float] NULL,
	[VolFlow] [float] NULL,
	[MassFlow] [float] NULL,
	[Temp] [float] NULL,
	[Pressure] [float] NULL,
	[Energy] [float] NULL,
 CONSTRAINT [PK_Steam] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersData]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersData](
	[FileID] [int] NULL,
	[TimeStamp] [datetime] NOT NULL,
	[Genset_SN] [nvarchar](50) NOT NULL,
	[Power_1] [float] NULL,
	[Energy_1] [float] NULL,
	[FlowVol_1] [float] NULL,
	[TempWarm_1] [float] NULL,
	[TempCold_1] [float] NULL,
	[Power_2] [float] NULL,
	[Energy_2] [float] NULL,
	[FlowVol_2] [float] NULL,
	[TempWarm_2] [float] NULL,
	[TempCold_2] [float] NULL,
	[Power_3] [float] NULL,
	[Energy_3] [float] NULL,
	[FlowVol_3] [float] NULL,
	[TempWarm_3] [float] NULL,
	[TempCold_3] [float] NULL,
	[Power_4] [float] NULL,
	[Energy_4] [float] NULL,
	[FlowVol_4] [float] NULL,
	[TempWarm_4] [float] NULL,
	[TempCold_4] [float] NULL,
	[Power_5] [float] NULL,
	[Energy_5] [float] NULL,
	[FlowVol_5] [float] NULL,
	[TempWarm_5] [float] NULL,
	[TempCold_5] [float] NULL,
	[Power_6] [float] NULL,
	[Energy_6] [float] NULL,
	[FlowVol_6] [float] NULL,
	[TempWarm_6] [float] NULL,
	[TempCold_6] [float] NULL,
	[Power_7] [float] NULL,
	[Energy_7] [float] NULL,
	[FlowVol_7] [float] NULL,
	[TempWarm_7] [float] NULL,
	[TempCold_7] [float] NULL,
	[Power_8] [float] NULL,
	[Energy_8] [float] NULL,
	[FlowVol_8] [float] NULL,
	[TempWarm_8] [float] NULL,
	[TempCold_8] [float] NULL,
	[Power_9] [float] NULL,
	[Energy_9] [float] NULL,
	[FlowVol_9] [float] NULL,
	[TempWarm_9] [float] NULL,
	[TempCold_9] [float] NULL,
	[Power_11] [float] NULL,
	[Energy_11] [float] NULL,
	[FlowVol_11] [float] NULL,
	[TempWarm_11] [float] NULL,
	[TempCold_11] [float] NULL,
	[Power_16] [float] NULL,
	[Energy_16] [float] NULL,
	[FlowVol_16] [float] NULL,
	[TempWarm_16] [float] NULL,
	[TempCold_16] [float] NULL,
	[TempCold_22019-2-6 16:28:46] [float] NULL,
	[17087211] [float] NULL,
	[0] [float] NULL,
	[02] [float] NULL,
	[03] [float] NULL,
	[04] [float] NULL,
	[05] [float] NULL,
	[TempCold_22019-2-7 0:4:18] [float] NULL,
	[2057_7] [float] NULL,
	[2684042] [float] NULL,
	[110_2916] [float] NULL,
	[87_96141] [float] NULL,
	[71_58262] [float] NULL,
	[TempCold_22019-2-8 0:2:14] [float] NULL,
	[2077_993] [float] NULL,
	[2732986] [float] NULL,
	[110_4607] [float] NULL,
	[87_47065] [float] NULL,
	[70_9541] [float] NULL,
	[TempCold_22019-2-9 0:12:50] [float] NULL,
	[2045_01] [float] NULL,
	[2781186] [float] NULL,
	[108_4586] [float] NULL,
	[87_55869] [float] NULL,
	[70_99989] [float] NULL,
	[TempCold_22019-2-10 0:4:23] [float] NULL,
	[2067_578] [float] NULL,
	[2814847] [float] NULL,
	[109_4485] [float] NULL,
	[87_48941] [float] NULL,
	[70_90396] [float] NULL,
	[TempCold_22019-2-11 0:3:17] [float] NULL,
	[2060_297] [float] NULL,
	[2862536] [float] NULL,
	[108_0702] [float] NULL,
	[87_62897] [float] NULL,
	[70_88906] [float] NULL,
	[TempCold_22019-2-12 0:7:22] [float] NULL,
	[2057_548] [float] NULL,
	[2911951] [float] NULL,
	[109_2518] [float] NULL,
	[87_39883] [float] NULL,
	[70_84998] [float] NULL,
	[TempCold_22019-2-13 0:2:3] [float] NULL,
	[2070_307] [float] NULL,
	[2960858] [float] NULL,
	[109_4533] [float] NULL,
	[87_43218] [float] NULL,
	[70_81679] [float] NULL,
	[TempCold_22019-2-14 0:13:0] [float] NULL,
	[2062_583] [float] NULL,
	[3008402] [float] NULL,
	[110_0552] [float] NULL,
	[87_71382] [float] NULL,
	[71_2532] [float] NULL,
	[TempCold_22019-2-15 0:10:26] [float] NULL,
	[2014_025] [float] NULL,
	[3057381] [float] NULL,
	[111_0778] [float] NULL,
	[87_40224] [float] NULL,
	[71_62209] [float] NULL,
	[TempCold_22019-2-16 0:5:53] [float] NULL,
	[2076_214] [float] NULL,
	[3105751] [float] NULL,
	[110_2596] [float] NULL,
	[87_88583] [float] NULL,
	[71_34669] [float] NULL,
	[TempCold_22019-2-17 0:12:4] [float] NULL,
	[1907_43] [float] NULL,
	[3152691] [float] NULL,
	[110_6672] [float] NULL,
	[87_71218] [float] NULL,
	[72_55775] [float] NULL,
	[TempCold_22019-2-18 0:1:33] [float] NULL,
	[2047_134] [float] NULL,
	[3174073] [float] NULL,
	[110_2579] [float] NULL,
	[86_49499] [float] NULL,
	[70_18666] [float] NULL,
	[TempCold_22019-2-19 0:8:35] [float] NULL,
	[2058_982] [float] NULL,
	[3221611] [float] NULL,
	[110_8726] [float] NULL,
	[87_34799] [float] NULL,
	[71_04743] [float] NULL,
	[TempCold_22019-2-20 0:6:21] [float] NULL,
	[3262868] [float] NULL,
	[69_42629] [float] NULL,
	[69_79886] [float] NULL,
	[TempCold_22019-2-21 0:7:27] [float] NULL,
	[1566_814] [float] NULL,
	[3307982] [float] NULL,
	[114_3857] [float] NULL,
	[88_33131] [float] NULL,
	[76_00147] [float] NULL,
	[TempCold_22019-2-22 0:9:33] [float] NULL,
	[3330556] [float] NULL,
	[59_14759] [float] NULL,
	[67_77369] [float] NULL,
	[TempCold_22019-2-23 0:6:30] [float] NULL,
	[1955_197] [float] NULL,
	[3365722] [float] NULL,
	[112_3173] [float] NULL,
	[86_79942] [float] NULL,
	[71_50666] [float] NULL,
	[TempCold_22019-2-24 0:14:28] [float] NULL,
	[1823_115] [float] NULL,
	[3413381] [float] NULL,
	[113_1776] [float] NULL,
	[87_48383] [float] NULL,
	[73_23744] [float] NULL,
	[TempCold_22019-2-25 0:3:45] [float] NULL,
	[3430334] [float] NULL,
	[64_93517] [float] NULL,
	[66_2] [float] NULL,
	[TempCold_22019-2-26 0:11:33] [float] NULL,
	[2052_642] [float] NULL,
	[3461556] [float] NULL,
	[112_9559] [float] NULL,
	[86_20796] [float] NULL,
	[70_24406] [float] NULL,
	[TempCold_22019-2-27 0:14:34] [float] NULL,
	[2045_51] [float] NULL,
	[3509185] [float] NULL,
	[110_0557] [float] NULL,
	[87_05278] [float] NULL,
	[70_74174] [float] NULL,
	[TempCold_22019-2-28 0:10:21] [float] NULL,
	[1810_213] [float] NULL,
	[3557455] [float] NULL,
	[113_3815] [float] NULL,
	[87_52624] [float] NULL,
	[73_49158] [float] NULL,
	[TempCold_22019-3-1 0:0:22] [float] NULL,
	[158_5652] [float] NULL,
	[3596870] [float] NULL,
	[111_8] [float] NULL,
	[73_39085] [float] NULL,
	[72_14241] [float] NULL,
	[TempCold_22019-3-2 0:2:25] [float] NULL,
	[254_5366] [float] NULL,
	[3623992] [float] NULL,
	[112_1396] [float] NULL,
	[75_52848] [float] NULL,
	[73_54979] [float] NULL,
	[TempCold_22019-3-3 0:8:21] [float] NULL,
	[287_1157] [float] NULL,
	[3666462] [float] NULL,
	[111_7622] [float] NULL,
	[76_83909] [float] NULL,
	[74_57945] [float] NULL,
	[TempCold_22019-3-4 0:1:55] [float] NULL,
	[1718_802] [float] NULL,
	[3710231] [float] NULL,
	[113_3795] [float] NULL,
	[87_83776] [float] NULL,
	[74_51674] [float] NULL,
	[TempCold_22019-3-5 0:11:40] [float] NULL,
	[2024_883] [float] NULL,
	[3757776] [float] NULL,
	[112_5289] [float] NULL,
	[86_56133] [float] NULL,
	[70_75968] [float] NULL,
	[TempCold_22019-3-6 0:0:27] [float] NULL,
	[2025_427] [float] NULL,
	[3805845] [float] NULL,
	[112_9569] [float] NULL,
	[86_70667] [float] NULL,
	[70_96371] [float] NULL,
	[TempCold_22019-3-7 0:5:33] [float] NULL,
	[1789_02] [float] NULL,
	[3848250] [float] NULL,
	[112_7391] [float] NULL,
	[87_19423] [float] NULL,
	[73_47102] [float] NULL,
	[TempCold_22019-3-8 0:10:55] [float] NULL,
	[1768_748] [float] NULL,
	[3889222] [float] NULL,
	[113_3878] [float] NULL,
	[87_54613] [float] NULL,
	[73_82736] [float] NULL,
	[TempCold_22019-3-9 0:0:3] [float] NULL,
	[1854_741] [float] NULL,
	[3936644] [float] NULL,
	[112_533] [float] NULL,
	[86_92751] [float] NULL,
	[72_44424] [float] NULL,
	[TempCold_22019-3-10 0:12:12] [float] NULL,
	[1819_378] [float] NULL,
	[3982684] [float] NULL,
	[113_3831] [float] NULL,
	[87_09112] [float] NULL,
	[72_98257] [float] NULL,
	[TempCold_22019-3-11 0:1:22] [float] NULL,
	[1836_951] [float] NULL,
	[4024484] [float] NULL,
	[113_5976] [float] NULL,
	[86_9382] [float] NULL,
	[72_72446] [float] NULL,
	[TempCold_22019-3-12 0:12:24] [float] NULL,
	[1706_135] [float] NULL,
	[4071559] [float] NULL,
	[114_2499] [float] NULL,
	[87_54217] [float] NULL,
	[74_40002] [float] NULL,
	[TempCold_22019-3-13 0:7:55] [float] NULL,
	[1801_945] [float] NULL,
	[4117190] [float] NULL,
	[113_5712] [float] NULL,
	[87_22498] [float] NULL,
	[73_28686] [float] NULL,
	[TempCold_22019-3-14 0:6:42] [float] NULL,
	[1445_783] [float] NULL,
	[4162603] [float] NULL,
	[112_5244] [float] NULL,
	[82_43022] [float] NULL,
	[71_10802] [float] NULL,
	[TempCold_22019-3-15 0:10:33] [float] NULL,
	[1105_29] [float] NULL,
	[4197888] [float] NULL,
	[112_3266] [float] NULL,
	[79_09822] [float] NULL,
	[72_60807] [float] NULL,
	[TempCold_22019-3-16 0:3:19] [float] NULL,
	[1454_298] [float] NULL,
	[4240879] [float] NULL,
	[113_59] [float] NULL,
	[84_87788] [float] NULL,
	[73_62154] [float] NULL,
	[TempCold_22019-3-17 0:13:32] [float] NULL,
	[1708_473] [float] NULL,
	[4284928] [float] NULL,
	[113_2041] [float] NULL,
	[87_42976] [float] NULL,
	[74_1546] [float] NULL,
	[TempCold_22019-3-18 0:5:25] [float] NULL,
	[1942_774] [float] NULL,
	[4322112] [float] NULL,
	[115_3811] [float] NULL,
	[86_91022] [float] NULL,
	[72_11381] [float] NULL,
	[TempCold_22019-3-19 0:6:27] [float] NULL,
	[1665_327] [float] NULL,
	[4369758] [float] NULL,
	[113_5977] [float] NULL,
	[87_76762] [float] NULL,
	[74_85957] [float] NULL,
	[TempCold_22019-3-20 0:7:30] [float] NULL,
	[1508_819] [float] NULL,
	[4412618] [float] NULL,
	[113_1686] [float] NULL,
	[84_68824] [float] NULL,
	[72_96448] [float] NULL,
	[TempCold_22019-3-21 0:5:45] [float] NULL,
	[1551_387] [float] NULL,
	[4447832] [float] NULL,
	[113_2102] [float] NULL,
	[87_71897] [float] NULL,
	[75_65615] [float] NULL,
	[TempCold_22019-3-22 0:2:4] [float] NULL,
	[263_0675] [float] NULL,
	[4486513] [float] NULL,
	[112_0143] [float] NULL,
	[75_35726] [float] NULL,
	[73_27601] [float] NULL,
	[TempCold_22019-3-23 0:8:30] [float] NULL,
	[1530_611] [float] NULL,
	[4527716] [float] NULL,
	[113_5472] [float] NULL,
	[87_80889] [float] NULL,
	[75_95461] [float] NULL,
	[TempCold_22019-3-24 0:8:35] [float] NULL,
	[1581_358] [float] NULL,
	[4570799] [float] NULL,
	[112_9896] [float] NULL,
	[88_36449] [float] NULL,
	[76_04283] [float] NULL,
	[TempCold_22019-3-25 0:5:7] [float] NULL,
	[1647_98] [float] NULL,
	[4609461] [float] NULL,
	[87_90279] [float] NULL,
	[75_1376] [float] NULL,
	[TempCold_22019-3-26 0:2:17] [float] NULL,
	[1708_675] [float] NULL,
	[4653811] [float] NULL,
	[111_2752] [float] NULL,
	[87_36366] [float] NULL,
	[73_67371] [float] NULL,
	[TempCold_22019-3-27 0:13:33] [float] NULL,
	[4694684] [float] NULL,
	[70_67641] [float] NULL,
	[70_8644] [float] NULL,
	[TempCold_22019-3-28 0:8:55] [float] NULL,
	[1483_715] [float] NULL,
	[4716541] [float] NULL,
	[115_1128] [float] NULL,
	[84_92065] [float] NULL,
	[73_58336] [float] NULL,
	[TempCold_22019-3-29 0:6:54] [float] NULL,
	[1784_343] [float] NULL,
	[4757247] [float] NULL,
	[113_0025] [float] NULL,
	[73_25913] [float] NULL,
	[73_34059] [float] NULL,
	[TempCold_22019-3-30 0:9:40] [float] NULL,
	[1605_558] [float] NULL,
	[4795686] [float] NULL,
	[112_1384] [float] NULL,
	[87_95676] [float] NULL,
	[75_354] [float] NULL,
	[TempCold_22019-3-31 0:11:24] [float] NULL,
	[1849_564] [float] NULL,
	[4838279] [float] NULL,
	[86_91333] [float] NULL,
	[72_57846] [float] NULL,
	[TempCold_22019-4-1 0:10:4] [float] NULL,
	[127_1135] [float] NULL,
	[4874682] [float] NULL,
	[111_9548] [float] NULL,
	[75_61684] [float] NULL,
	[74_61709] [float] NULL,
	[TempCold_22019-4-2 0:6:51] [float] NULL,
	[1673_709] [float] NULL,
	[4914787] [float] NULL,
	[114_0345] [float] NULL,
	[87_83068] [float] NULL,
	[74_91613] [float] NULL,
	[TempCold_22019-4-3 0:2:49] [float] NULL,
	[1768_844] [float] NULL,
	[4957600] [float] NULL,
	[111_5161] [float] NULL,
	[86_93687] [float] NULL,
	[72_9921] [float] NULL,
	[TempCold_22019-4-4 0:0:5] [float] NULL,
	[1854_379] [float] NULL,
	[5004404] [float] NULL,
	[114_5034] [float] NULL,
	[86_96008] [float] NULL,
	[72_72828] [float] NULL,
	[TempCold_22019-4-5 0:8:43] [float] NULL,
	[1952_684] [float] NULL,
	[5051630] [float] NULL,
	[86_68187] [float] NULL,
	[71_5723] [float] NULL,
	[TempCold_22019-4-6 0:1:34] [float] NULL,
	[1883_179] [float] NULL,
	[5099270] [float] NULL,
	[112_7998] [float] NULL,
	[86_98244] [float] NULL,
	[72_31617] [float] NULL,
	[TempCold_22019-4-7 0:10:14] [float] NULL,
	[466_6233] [float] NULL,
	[5144902] [float] NULL,
	[112_3237] [float] NULL,
	[78_22303] [float] NULL,
	[74_58449] [float] NULL,
	[TempCold_22019-4-8 0:3:30] [float] NULL,
	[709_5208] [float] NULL,
	[5179012] [float] NULL,
	[112_9988] [float] NULL,
	[76_42979] [float] NULL,
	[70_88352] [float] NULL,
	[TempCold_22019-4-9 0:14:54] [float] NULL,
	[1960_433] [float] NULL,
	[5209598] [float] NULL,
	[115_2765] [float] NULL,
	[86_88672] [float] NULL,
	[71_94943] [float] NULL,
	[TempCold_22019-4-10 0:2:27] [float] NULL,
	[125_4922] [float] NULL,
	[5249660] [float] NULL,
	[112_7785] [float] NULL,
	[73_04016] [float] NULL,
	[72_05831] [float] NULL,
	[TempCold_22019-4-11 0:9:38] [float] NULL,
	[1683_277] [float] NULL,
	[5293350] [float] NULL,
	[113_1663] [float] NULL,
	[87_70995] [float] NULL,
	[74_62902] [float] NULL,
	[TempCold_22019-4-12 0:11:1] [float] NULL,
	[1740_842] [float] NULL,
	[5337807] [float] NULL,
	[87_56578] [float] NULL,
	[74_07188] [float] NULL,
	[TempCold_22019-4-13 0:6:55] [float] NULL,
	[1829_377] [float] NULL,
	[5383091] [float] NULL,
	[87_25142] [float] NULL,
	[73_09555] [float] NULL,
	[TempCold_22019-4-14 0:2:11] [float] NULL,
	[2031_308] [float] NULL,
	[5427686] [float] NULL,
	[85_93168] [float] NULL,
	[70_15077] [float] NULL,
	[TempCold_22019-4-15 0:4:28] [float] NULL,
	[2062_562] [float] NULL,
	[5475847] [float] NULL,
	[113_1969] [float] NULL,
	[85_44619] [float] NULL,
	[69_45618] [float] NULL,
	[TempCold_22019-4-16 0:5:16] [float] NULL,
	[8_934839] [float] NULL,
	[5521755] [float] NULL,
	[24_36895] [float] NULL,
	[73_15582] [float] NULL,
	[72_84179] [float] NULL,
	[TempCold_22019-4-17 0:7:5] [float] NULL,
	[5560338] [float] NULL,
	[70_42645] [float] NULL,
	[70_35196] [float] NULL,
	[TempCold_22019-4-18 0:8:13] [float] NULL,
	[81_64824] [float] NULL,
	[5588550] [float] NULL,
	[112_4631] [float] NULL,
	[71_92283] [float] NULL,
	[71_25679] [float] NULL,
	[TempCold_22019-4-19 0:5:9] [float] NULL,
	[28_87284] [float] NULL,
	[5623297] [float] NULL,
	[112_5515] [float] NULL,
	[73_23965] [float] NULL,
	[73_01382] [float] NULL,
	[TempCold_22019-4-20 0:13:26] [float] NULL,
	[42_51058] [float] NULL,
	[5650412] [float] NULL,
	[112_2447] [float] NULL,
	[73_58698] [float] NULL,
	[73_25355] [float] NULL,
	[TempCold_22019-4-21 0:12:58] [float] NULL,
	[5677881] [float] NULL,
	[71_62534] [float] NULL,
	[71_57015] [float] NULL,
	[TempCold_22019-4-22 0:4:11] [float] NULL,
	[501_1666] [float] NULL,
	[5706413] [float] NULL,
	[112_7455] [float] NULL,
	[77_67286] [float] NULL,
	[73_74358] [float] NULL,
	[TempCold_22019-4-23 0:6:8] [float] NULL,
	[1534_719] [float] NULL,
	[5738512] [float] NULL,
	[113_1695] [float] NULL,
	[88_36417] [float] NULL,
	[76_4252] [float] NULL,
	[TempCold_22019-4-24 0:12:9] [float] NULL,
	[25_58603] [float] NULL,
	[5768590] [float] NULL,
	[112_5184] [float] NULL,
	[73_93379] [float] NULL,
	[73_72832] [float] NULL,
	[TempCold_22019-4-25 0:14:21] [float] NULL,
	[1914_808] [float] NULL,
	[5805121] [float] NULL,
	[113_1735] [float] NULL,
	[86_58838] [float] NULL,
	[71_72953] [float] NULL,
	[TempCold_22019-4-26 0:5:20] [float] NULL,
	[1641_608] [float] NULL,
	[5844608] [float] NULL,
	[112_95] [float] NULL,
	[84_38909] [float] NULL,
	[71_61982] [float] NULL,
	[TempCold_22019-4-27 0:8:27] [float] NULL,
	[5872586] [float] NULL,
	[47_52623] [float] NULL,
	[57_24617] [float] NULL,
	[TempCold_22019-4-28 0:10:3] [float] NULL,
	[32_56497] [float] NULL,
	[47_78898] [float] NULL,
	[TempCold_22019-4-29 0:11:39] [float] NULL,
	[35_40823] [float] NULL,
	[58_43938] [float] NULL,
	[TempCold_22019-4-30 0:13:15] [float] NULL,
	[28_72186] [float] NULL,
	[49_77465] [float] NULL,
	[TempCold_22019-5-1 0:14:51] [float] NULL,
	[23_36109] [float] NULL,
	[43_8595] [float] NULL,
	[TempCold_22019-5-2 0:1:26] [float] NULL,
	[17_03946] [float] NULL,
	[22_37719] [float] NULL,
	[TempCold_22019-5-3 0:3:8] [float] NULL,
	[30_74715] [float] NULL,
	[56_86543] [float] NULL,
	[TempCold_22019-5-4 0:4:38] [float] NULL,
	[33_33838] [float] NULL,
	[50_72824] [float] NULL,
	[TempCold_22019-5-5 0:6:14] [float] NULL,
	[31_77668] [float] NULL,
	[52_12378] [float] NULL,
	[TempCold_22019-5-6 0:7:56] [float] NULL,
	[32_12136] [float] NULL,
	[42_72958] [float] NULL,
	[TempCold_22019-5-7 0:9:26] [float] NULL,
	[61_77956] [float] NULL,
	[67_7645] [float] NULL,
	[TempCold_22019-5-8 0:11:2] [float] NULL,
	[67_43151] [float] NULL,
	[69_78483] [float] NULL,
	[TempCold_22019-5-9 0:12:38] [float] NULL,
	[35_03413] [float] NULL,
	[59_41832] [float] NULL,
	[TempCold_22019-5-10 0:14:14] [float] NULL,
	[31_982] [float] NULL,
	[40_71772] [float] NULL,
	[TempCold_22019-5-11 0:0:49] [float] NULL,
	[35_73746] [float] NULL,
	[60_92286] [float] NULL,
	[TempCold_22019-5-12 0:2:25] [float] NULL,
	[31_98] [float] NULL,
	[43_29552] [float] NULL,
	[TempCold_22019-5-13 0:4:4] [float] NULL,
	[40_25206] [float] NULL,
	[66_42941] [float] NULL,
	[TempCold_22019-5-14 0:5:37] [float] NULL,
	[32_48561] [float] NULL,
	[42_95538] [float] NULL,
	[TempCold_22019-5-15 0:7:13] [float] NULL,
	[32_21846] [float] NULL,
	[39_12138] [float] NULL,
	[TempCold_22019-5-16 0:8:49] [float] NULL,
	[32_5275] [float] NULL,
	[38_97102] [float] NULL,
	[TempCold_22019-5-17 0:10:25] [float] NULL,
	[32_71249] [float] NULL,
	[38_95732] [float] NULL,
	[TempCold_22019-5-18 0:12:1] [float] NULL,
	[33_33561] [float] NULL,
	[39_00078] [float] NULL,
	[TempCold_22019-5-19 0:13:37] [float] NULL,
	[37_31366] [float] NULL,
	[38_71992] [float] NULL,
	[TempCold_22019-5-20 0:0:15] [float] NULL,
	[37_68792] [float] NULL,
	[38_52394] [float] NULL,
	[TempCold_22019-5-21 0:1:48] [float] NULL,
	[33_01612] [float] NULL,
	[38_88602] [float] NULL,
	[TempCold_22019-5-22 0:3:24] [float] NULL,
	[31_73243] [float] NULL,
	[38_5387] [float] NULL,
	[TempCold_22019-5-23 0:5:0] [float] NULL,
	[31_94003] [float] NULL,
	[38_59406] [float] NULL,
	[TempCold_22019-5-24 0:6:36] [float] NULL,
	[31_20674] [float] NULL,
	[39_23558] [float] NULL,
	[TempCold_22019-5-25 0:11:10] [float] NULL,
	[32_67137] [float] NULL,
	[39_69203] [float] NULL,
	[TempCold_22019-5-26 0:12:43] [float] NULL,
	[32_07536] [float] NULL,
	[38_73442] [float] NULL,
	[TempCold_22019-5-27 0:14:19] [float] NULL,
	[31_12397] [float] NULL,
	[38_45964] [float] NULL,
	[TempCold_22019-5-28 0:0:54] [float] NULL,
	[32_65638] [float] NULL,
	[38_80177] [float] NULL,
	[TempCold_22019-5-29 0:2:30] [float] NULL,
	[34_93572] [float] NULL,
	[39_00089] [float] NULL,
	[TempCold_22019-5-30 0:4:6] [float] NULL,
	[37_79065] [float] NULL,
	[39_49863] [float] NULL,
	[TempCold_22019-5-31 0:5:42] [float] NULL,
	[37_61786] [float] NULL,
	[39_06717] [float] NULL,
	[TempCold_22019-6-1 0:7:18] [float] NULL,
	[34_53866] [float] NULL,
	[38_62265] [float] NULL,
	[TempCold_22019-6-2 0:8:54] [float] NULL,
	[33_06077] [float] NULL,
	[43_60205] [float] NULL,
	[TempCold_22019-6-3 0:10:30] [float] NULL,
	[32_16265] [float] NULL,
	[38_6638] [float] NULL,
	[TempCold_22019-6-4 0:12:6] [float] NULL,
	[32_56111] [float] NULL,
	[38_97008] [float] NULL,
	[TempCold_22019-6-5 0:13:45] [float] NULL,
	[33_36581] [float] NULL,
	[39_14808] [float] NULL,
	[TempCold_22019-6-6 0:0:17] [float] NULL,
	[32_91779] [float] NULL,
	[38_47248] [float] NULL,
	[TempCold_22019-6-7 0:1:53] [float] NULL,
	[35_1738] [float] NULL,
	[38_82719] [float] NULL,
	[TempCold_22019-6-8 0:3:29] [float] NULL,
	[37_63655] [float] NULL,
	[39_43808] [float] NULL,
	[TempCold_22019-6-9 0:5:5] [float] NULL,
	[34_67477] [float] NULL,
	[38_71801] [float] NULL,
	[TempCold_22019-6-10 0:6:41] [float] NULL,
	[34_85361] [float] NULL,
	[38_81253] [float] NULL,
	[TempCold_22019-6-11 0:8:17] [float] NULL,
	[30_9496] [float] NULL,
	[38_97735] [float] NULL,
	[TempCold_22019-6-12 0:0:54] [float] NULL,
	[5886034] [float] NULL,
	[68_381] [float] NULL,
	[68_70918] [float] NULL,
	[TempCold_22019-6-13 0:13:50] [float] NULL,
	[5899650] [float] NULL,
	[54_58152] [float] NULL,
	[69_60519] [float] NULL,
	[TempCold_22019-6-14 0:0:25] [float] NULL,
	[32_30256] [float] NULL,
	[38_49746] [float] NULL,
	[TempCold_22019-6-15 0:2:1] [float] NULL,
	[5899826] [float] NULL,
	[61_04115] [float] NULL,
	[74_85603] [float] NULL,
	[TempCold_22019-6-16 0:3:40] [float] NULL,
	[5900633] [float] NULL,
	[77_86224] [float] NULL,
	[81_31616] [float] NULL,
	[TempCold_22019-6-17 0:9:9] [float] NULL,
	[5902381] [float] NULL,
	[76_2394] [float] NULL,
	[78_81113] [float] NULL,
	[TempCold_22019-6-18 0:10:48] [float] NULL,
	[5903887] [float] NULL,
	[40_67659] [float] NULL,
	[60_63725] [float] NULL,
	[TempCold_22019-6-19 0:12:21] [float] NULL,
	[5904093] [float] NULL,
	[34_46929] [float] NULL,
	[53_06345] [float] NULL,
	[TempCold_22019-6-20 0:11:56] [float] NULL,
	[33_23507] [float] NULL,
	[TempCold_112019-6-20 0:13:28] [float] NULL,
	[170871D8] [float] NULL,
	[TempCold_162019-6-20 0:13:40] [float] NULL,
	[2361954] [float] NULL,
	[38_66228] [float] NULL,
	[40_71923] [float] NULL,
	[17087215] [float] NULL,
	[40_02182] [float] NULL,
	[3232042] [float] NULL,
	[49_17597] [float] NULL,
	[37_59869] [float] NULL,
	[TempCold_22019-6-21 0:13:31] [float] NULL,
	[37_23813] [float] NULL,
	[39_02689] [float] NULL,
	[TempCold_162019-6-21 0:14:38] [float] NULL,
	[TempCold_112019-6-21 0:0:3] [float] NULL,
	[3244780] [float] NULL,
	[0_5944312] [float] NULL,
	[43_55592] [float] NULL,
	[2361966] [float] NULL,
	[30_78612] [float] NULL,
	[43_9447] [float] NULL,
	[42_29161] [float] NULL,
	[42_27349] [float] NULL,
	[TempCold_22019-6-23 0:10:38] [float] NULL,
	[12121CA1] [float] NULL,
	[456_3095] [float] NULL,
	[2_131136e+07] [float] NULL,
	[55_81359] [float] NULL,
	[87_43734] [float] NULL,
	[80_21603] [float] NULL,
	[157_7278] [float] NULL,
	[2374419] [float] NULL,
	[56_51783] [float] NULL,
	[66_25295] [float] NULL,
	[63_81438] [float] NULL,
	[7_058012] [float] NULL,
	[597968_5] [float] NULL,
	[2_058798] [float] NULL,
	[44_20105] [float] NULL,
	[41_24091] [float] NULL,
	[TempCold_22019-8-30 0:27:53] [float] NULL,
	[170871F9] [float] NULL,
	[548_3462] [float] NULL,
	[1981859] [float] NULL,
	[42_94893] [float] NULL,
	[41_51076] [float] NULL,
	[31_44916] [float] NULL,
	[211_1398] [float] NULL,
	[1884215] [float] NULL,
	[53_61223] [float] NULL,
	[91_45667] [float] NULL,
	[87_97398] [float] NULL,
	[67_03968] [float] NULL,
	[372658_9] [float] NULL,
	[22_10901] [float] NULL,
	[39_23577] [float] NULL,
	[36_60695] [float] NULL,
	[TempCold_22020-1-9 0:29:13] [float] NULL,
	[18079151] [float] NULL,
	[671_6927] [float] NULL,
	[1988211] [float] NULL,
	[79_70302] [float] NULL,
	[34_07441] [float] NULL,
	[26_81777] [float] NULL,
	[219_3515] [float] NULL,
	[589348_2] [float] NULL,
	[34_04693] [float] NULL,
	[90_14674] [float] NULL,
	[84_45422] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersDirisA20Data]    Script Date: 26/05/2020 18:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersDirisA20Data](
	[FileID] [int] NULL,
	[Timestamp] [datetime] NOT NULL,
	[Serial] [nchar](12) NOT NULL,
	[I-1] [float] NULL,
	[I-2] [float] NULL,
	[I-3] [float] NULL,
	[I-N] [float] NULL,
	[V12] [float] NULL,
	[V23] [float] NULL,
	[V31] [float] NULL,
	[V1-N] [float] NULL,
	[V2-N] [float] NULL,
	[V3-N] [float] NULL,
	[F] [float] NULL,
	[P] [float] NULL,
	[Q] [float] NULL,
	[S] [float] NULL,
	[PF] [float] NULL,
	[W] [float] NULL,
	[Wr] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersDirisA20Metadata]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersDirisA20Metadata](
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersDirisA20Metadata_history]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersDirisA20Metadata_history](
	[FileID] [int] NOT NULL,
	[FieldName] [varchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersLGE650Data]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersLGE650Data](
	[FileID] [int] NULL,
	[Timestamp] [datetime] NOT NULL,
	[Serial] [nchar](10) NOT NULL,
	[F_F] [nchar](10) NULL,
	[0_9_1] [nchar](10) NULL,
	[0_9_2] [nchar](10) NULL,
	[1_2_0] [float] NULL,
	[2_2_0] [float] NULL,
	[3_2_0] [float] NULL,
	[4_2_0] [float] NULL,
	[1_6_0] [float] NULL,
	[2_6_0] [float] NULL,
	[3_6_0] [float] NULL,
	[4_6_0] [float] NULL,
	[1_8_1] [float] NULL,
	[2_8_1] [float] NULL,
	[3_8_1] [float] NULL,
	[4_8_1] [float] NULL,
	[0_4_2] [float] NULL,
	[32_7] [float] NULL,
	[52_7] [float] NULL,
	[72_7] [float] NULL,
	[1-1:32_36_0] [float] NULL,
	[1-1:52_36_0] [float] NULL,
	[1-1:72_36_0] [float] NULL,
	[1-1:32_32_0] [float] NULL,
	[1-1:52_32_0] [float] NULL,
	[1-1:72_32_0] [float] NULL,
	[16_7_0] [float] NULL,
	[36_7_0] [float] NULL,
	[56_7_0] [float] NULL,
	[1_8_0] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersLGE650Metadata]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersLGE650Metadata](
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersLGE650Metadata_history]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersLGE650Metadata_history](
	[FileID] [int] NOT NULL,
	[FieldName] [varchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersMetadata]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersMetadata](
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[EnergyMetersMetadata_history]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[EnergyMetersMetadata_history](
	[FileID] [int] NOT NULL,
	[FieldName] [varchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GasMetersData]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GasMetersData](
	[FileID] [int] NULL,
	[Genset_SN] [nvarchar](50) NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[MassFlow_1] [float] NULL,
	[Totaliser_1] [float] NULL,
	[MassFlow_2] [float] NULL,
	[Totaliser_2] [float] NULL,
	[MassFlow_3] [float] NULL,
	[Totaliser_3] [float] NULL,
	[MassFlow_4] [float] NULL,
	[Totaliser_4] [float] NULL,
	[MassFlow_5] [float] NULL,
	[Totaliser_5] [float] NULL,
	[MassFlow_6] [float] NULL,
	[Totaliser_6] [float] NULL,
	[MassFlow_7] [float] NULL,
	[Totaliser_7] [float] NULL,
	[MassFlow_8] [float] NULL,
	[Totaliser_8] [float] NULL,
	[MassFlow_9] [float] NULL,
	[Totaliser_9] [float] NULL,
	[MassFlow_10] [float] NULL,
	[Totaliser_10] [float] NULL,
	[MassFlow_11] [float] NULL,
	[Totaliser_11] [float] NULL,
	[MassFlow_12] [float] NULL,
	[Totaliser_12] [float] NULL,
	[MassFlow_13] [float] NULL,
	[Totaliser_13] [float] NULL,
	[MassFlow_14] [float] NULL,
	[Totaliser_14] [float] NULL,
	[MassFlow_15] [float] NULL,
	[Totaliser_15] [float] NULL,
	[MassFlow_16] [float] NULL,
	[Totaliser_16] [float] NULL,
	[MassFlow_17] [float] NULL,
	[Totaliser_17] [float] NULL,
	[MassFlow_18] [float] NULL,
	[Totaliser_18] [float] NULL,
	[MassFlow_19] [float] NULL,
	[Totaliser_19] [float] NULL,
	[MassFlow_20] [float] NULL,
	[Totaliser_20] [float] NULL,
	[MassFlow_21] [float] NULL,
	[Totaliser_21] [float] NULL,
	[MassFlow_22] [float] NULL,
	[Totaliser_22] [float] NULL,
	[MassFlow_23] [float] NULL,
	[Totaliser_23] [float] NULL,
	[MassFlow_24] [float] NULL,
	[Totaliser_24] [float] NULL,
	[MassFlow_25] [float] NULL,
	[Totaliser_25] [float] NULL,
	[MassFlow_26] [float] NULL,
	[Totaliser_26] [float] NULL,
	[MassFlow_27] [float] NULL,
	[Totaliser_27] [float] NULL,
	[MassFlow_28] [float] NULL,
	[Totaliser_28] [float] NULL,
	[MassFlow_29] [float] NULL,
	[Totaliser_29] [float] NULL,
	[MassFlow_30] [float] NULL,
	[Totaliser_30] [float] NULL,
	[MassFlow_31] [float] NULL,
	[Totaliser_31] [float] NULL,
	[MassFlow_32] [float] NULL,
	[Totaliser_32] [float] NULL,
	[Totaliser_42019-10-10 0:10:45] [float] NULL,
	[18079151] [float] NULL,
	[0] [float] NULL,
	[02] [float] NULL,
	[Totaliser_132019-10-10 0:8:15] [float] NULL,
	[1411AE7F] [float] NULL,
	[382_428] [float] NULL,
	[1_144928e+07] [float] NULL,
	[Totaliser_42019-10-11 0:8:27] [float] NULL,
	[Totaliser_132019-10-11 0:7:51] [float] NULL,
	[382_3868] [float] NULL,
	[1_14584e+07] [float] NULL,
	[Totaliser_42019-10-12 0:11:55] [float] NULL,
	[Totaliser_132019-10-12 0:4:54] [float] NULL,
	[292_8838] [float] NULL,
	[1_14671e+07] [float] NULL,
	[Totaliser_42019-10-13 0:6:24] [float] NULL,
	[Totaliser_132019-10-13 0:9:37] [float] NULL,
	[273_0792] [float] NULL,
	[1_147389e+07] [float] NULL,
	[Totaliser_132019-10-14 0:4:7] [float] NULL,
	[Totaliser_42019-10-14 0:7:13] [float] NULL,
	[381_552] [float] NULL,
	[1_148068e+07] [float] NULL,
	[Totaliser_42019-10-15 0:14:46] [float] NULL,
	[Totaliser_132019-10-15 0:3:56] [float] NULL,
	[380_3173] [float] NULL,
	[1_148983e+07] [float] NULL,
	[Totaliser_132019-10-16 0:1:18] [float] NULL,
	[Totaliser_42019-10-16 0:3:23] [float] NULL,
	[382_7957] [float] NULL,
	[1_149897e+07] [float] NULL,
	[Totaliser_132019-10-17 0:7:28] [float] NULL,
	[Totaliser_42019-10-17 0:1:29] [float] NULL,
	[381_3999] [float] NULL,
	[1_150815e+07] [float] NULL,
	[Totaliser_42019-10-18 0:8:11] [float] NULL,
	[Totaliser_132019-10-18 0:2:5] [float] NULL,
	[382_1609] [float] NULL,
	[1_151563e+07] [float] NULL,
	[Totaliser_132019-10-19 0:9:48] [float] NULL,
	[270_3223] [float] NULL,
	[1_152407e+07] [float] NULL,
	[Totaliser_42019-10-19 0:12:53] [float] NULL,
	[Totaliser_132019-10-20 0:13:29] [float] NULL,
	[Totaliser_42019-10-20 0:3:58] [float] NULL,
	[246_9117] [float] NULL,
	[1_153054e+07] [float] NULL,
	[Totaliser_42019-10-21 0:13:59] [float] NULL,
	[Totaliser_132019-10-21 0:7:7] [float] NULL,
	[384_3797] [float] NULL,
	[1_153782e+07] [float] NULL,
	[Totaliser_42019-10-22 0:10:32] [float] NULL,
	[Totaliser_132019-10-22 0:9:32] [float] NULL,
	[383_539] [float] NULL,
	[1_154698e+07] [float] NULL,
	[Totaliser_132019-10-23 0:12:1] [float] NULL,
	[Totaliser_42019-10-23 0:6:49] [float] NULL,
	[381_1327] [float] NULL,
	[1_155612e+07] [float] NULL,
	[Totaliser_132019-10-24 0:5:23] [float] NULL,
	[379_7714] [float] NULL,
	[1_156515e+07] [float] NULL,
	[Totaliser_42019-10-24 0:0:56] [float] NULL,
	[Totaliser_42019-10-25 0:8:44] [float] NULL,
	[Totaliser_132019-10-25 0:0:44] [float] NULL,
	[381_4229] [float] NULL,
	[1_157284e+07] [float] NULL,
	[Totaliser_42019-10-26 0:5:13] [float] NULL,
	[Totaliser_42019-10-27 0:2:8] [float] NULL,
	[Totaliser_132019-10-27 0:6:13] [float] NULL,
	[234_6803] [float] NULL,
	[Totaliser_132019-10-26 0:7:10] [float] NULL,
	[253_6873] [float] NULL,
	[1_158753e+07] [float] NULL,
	[1_158127e+07] [float] NULL,
	[Totaliser_42019-10-28 0:6:5] [float] NULL,
	[Totaliser_132019-10-28 0:0:54] [float] NULL,
	[239_9693] [float] NULL,
	[1_159367e+07] [float] NULL,
	[Totaliser_132019-10-29 0:13:12] [float] NULL,
	[Totaliser_42019-10-29 0:4:33] [float] NULL,
	[380_6057] [float] NULL,
	[1_160045e+07] [float] NULL,
	[Totaliser_42019-10-30 0:8:42] [float] NULL,
	[Totaliser_42019-10-31 0:11:8] [float] NULL,
	[Totaliser_42019-11-1 0:10:48] [float] NULL,
	[Totaliser_42019-11-2 0:10:6] [float] NULL,
	[Totaliser_42019-11-3 0:11:2] [float] NULL,
	[Totaliser_42019-11-4 0:14:14] [float] NULL,
	[Totaliser_42019-11-5 0:12:45] [float] NULL,
	[Totaliser_42019-11-6 0:10:47] [float] NULL,
	[Totaliser_42019-11-7 0:12:15] [float] NULL,
	[Totaliser_42019-11-8 0:8:48] [float] NULL,
	[Totaliser_42019-11-9 0:10:45] [float] NULL,
	[Totaliser_42019-11-10 0:10:51] [float] NULL,
	[Totaliser_42019-11-11 0:2:3] [float] NULL,
	[Totaliser_42019-11-12 0:4:30] [float] NULL,
	[Totaliser_132019-10-30 0:0:51] [float] NULL,
	[377_4927] [float] NULL,
	[1_160948e+07] [float] NULL,
	[Totaliser_42019-11-13 0:7:6] [float] NULL,
	[Totaliser_42019-11-14 0:8:3] [float] NULL,
	[Totaliser_42019-11-15 0:8:51] [float] NULL,
	[Totaliser_42019-11-16 0:8:2] [float] NULL,
	[Totaliser_42019-11-17 0:2:23] [float] NULL,
	[Totaliser_42019-11-18 0:5:38] [float] NULL,
	[Totaliser_42019-11-19 0:4:39] [float] NULL,
	[Totaliser_42019-11-20 0:0:45] [float] NULL,
	[Totaliser_22019-10-12 0:14:58] [float] NULL,
	[Totaliser_22019-10-10 0:6:4] [float] NULL,
	[Totaliser_22019-10-11 0:11:9] [float] NULL,
	[1991351] [float] NULL,
	[Totaliser_22019-11-13 0:10:15] [float] NULL,
	[140727E5] [float] NULL,
	[Totaliser_22019-11-11 0:7:2] [float] NULL,
	[Totaliser_22019-11-10 0:4:26] [float] NULL,
	[761_4258] [float] NULL,
	[772_4109] [float] NULL,
	[2541956] [float] NULL,
	[Totaliser_22019-11-12 0:9:38] [float] NULL,
	[Totaliser_22019-10-13 0:4:16] [float] NULL,
	[761_8502] [float] NULL,
	[2523496] [float] NULL,
	[2578847] [float] NULL,
	[771_3304] [float] NULL,
	[762_2378] [float] NULL,
	[Totaliser_22019-10-16 0:1:36] [float] NULL,
	[760_5721] [float] NULL,
	[Totaliser_22019-10-14 0:6:19] [float] NULL,
	[2560410] [float] NULL,
	[Totaliser_22019-10-15 0:11:39] [float] NULL,
	[2016950] [float] NULL,
	[2064410] [float] NULL,
	[Totaliser_22019-11-16 15:17:11] [float] NULL,
	[Totaliser_22019-10-17 0:4:11] [float] NULL,
	[770_1348] [float] NULL,
	[759_571] [float] NULL,
	[767_2017] [float] NULL,
	[2035220] [float] NULL,
	[2645781] [float] NULL,
	[755_4662] [float] NULL,
	[2082750] [float] NULL,
	[2046348] [float] NULL,
	[Totaliser_22019-11-18 0:4:54] [float] NULL,
	[767_1767] [float] NULL,
	[Totaliser_22019-11-19 0:7:26] [float] NULL,
	[Totaliser_22019-11-17 0:3:23] [float] NULL,
	[755_0767] [float] NULL,
	[Totaliser_22019-10-18 0:9:5] [float] NULL,
	[2689480] [float] NULL,
	[776_6933] [float] NULL,
	[767_7086] [float] NULL,
	[2652572] [float] NULL,
	[2101203] [float] NULL,
	[756_3918] [float] NULL,
	[2671092] [float] NULL,
	[Totaliser_42019-11-21 0:14:57] [float] NULL,
	[1998877] [float] NULL,
	[Totaliser_22019-10-21 0:5:21] [float] NULL,
	[Totaliser_22019-10-20 0:0:12] [float] NULL,
	[764_5911] [float] NULL,
	[2137924] [float] NULL,
	[766_5631] [float] NULL,
	[Totaliser_22019-11-20 0:10:0] [float] NULL,
	[771_8666] [float] NULL,
	[Totaliser_22019-10-19 0:10:55] [float] NULL,
	[2156369] [float] NULL,
	[Totaliser_22019-11-21 0:13:7] [float] NULL,
	[Totaliser_22019-10-24 0:6:30] [float] NULL,
	[2707812] [float] NULL,
	[766_2612] [float] NULL,
	[763_7784] [float] NULL,
	[760_0428] [float] NULL,
	[2119612] [float] NULL,
	[2211795] [float] NULL,
	[2726219] [float] NULL,
	[Totaliser_22019-10-26 0:1:22] [float] NULL,
	[Totaliser_22019-10-30 0:11:44] [float] NULL,
	[Totaliser_22019-10-27 0:3:31] [float] NULL,
	[757_3049] [float] NULL,
	[766_9713] [float] NULL,
	[Totaliser_22019-10-31 0:0:22] [float] NULL,
	[2321605] [float] NULL,
	[2248531] [float] NULL,
	[768_8582] [float] NULL,
	[Totaliser_22019-10-28 0:5:45] [float] NULL,
	[764_9604] [float] NULL,
	[Totaliser_22019-10-29 0:8:57] [float] NULL,
	[764_3217] [float] NULL,
	[2266931] [float] NULL,
	[762_9973] [float] NULL,
	[2303284] [float] NULL,
	[2285271] [float] NULL,
	[Totaliser_22019-11-5 0:9:5] [float] NULL,
	[2339792] [float] NULL,
	[Totaliser_22019-11-4 0:5:22] [float] NULL,
	[759_1327] [float] NULL,
	[2431708] [float] NULL,
	[Totaliser_22019-11-8 19:34:27] [float] NULL,
	[765_6076] [float] NULL,
	[761_9879] [float] NULL,
	[Totaliser_22019-10-22 0:0:31] [float] NULL,
	[2501658] [float] NULL,
	[2413293] [float] NULL,
	[775_5596] [float] NULL,
	[Totaliser_22019-10-25 0:10:1] [float] NULL,
	[2174763] [float] NULL,
	[Totaliser_22019-10-9 11:53:28] [float] NULL,
	[Totaliser_22019-11-3 15:3:2] [float] NULL,
	[766_881] [float] NULL,
	[759_4987] [float] NULL,
	[Totaliser_22019-11-9 0:1:19] [float] NULL,
	[2230267] [float] NULL,
	[2406380] [float] NULL,
	[766_7448] [float] NULL,
	[Totaliser_22019-10-23 0:4:18] [float] NULL,
	[2505064] [float] NULL,
	[762_059] [float] NULL,
	[2193249] [float] NULL,
	[Totaliser_42019-11-22 0:13:1] [float] NULL,
	[Totaliser_42019-11-23 0:12:58] [float] NULL,
	[Totaliser_42019-11-24 0:2:52] [float] NULL,
	[Totaliser_42019-11-25 0:2:56] [float] NULL,
	[Totaliser_42019-11-26 0:1:37] [float] NULL,
	[Totaliser_42019-11-27 0:5:31] [float] NULL,
	[Totaliser_42019-11-28 0:11:46] [float] NULL,
	[Totaliser_42019-11-29 0:13:59] [float] NULL,
	[Totaliser_42019-11-30 0:5:10] [float] NULL,
	[Totaliser_42019-12-1 0:2:5] [float] NULL,
	[Totaliser_42019-12-2 0:7:24] [float] NULL,
	[Totaliser_42019-12-3 0:3:46] [float] NULL,
	[Totaliser_42019-12-4 0:3:53] [float] NULL,
	[Totaliser_42019-12-5 0:9:47] [float] NULL,
	[Totaliser_42019-12-6 0:7:29] [float] NULL,
	[Totaliser_42019-12-7 0:3:27] [float] NULL,
	[Totaliser_42019-12-8 0:14:34] [float] NULL,
	[Totaliser_42019-12-9 0:5:32] [float] NULL,
	[Totaliser_42019-12-10 0:5:52] [float] NULL,
	[Totaliser_42019-12-11 0:4:8] [float] NULL,
	[Totaliser_42019-12-12 0:1:32] [float] NULL,
	[Totaliser_42019-12-13 0:13:48] [float] NULL,
	[Totaliser_42019-12-14 0:7:10] [float] NULL,
	[Totaliser_42019-12-15 0:9:52] [float] NULL,
	[Totaliser_42019-12-16 0:0:16] [float] NULL,
	[Totaliser_42019-12-17 0:3:47] [float] NULL,
	[Totaliser_42019-12-18 0:3:21] [float] NULL,
	[Totaliser_42019-12-19 0:11:10] [float] NULL,
	[Totaliser_42019-12-20 0:3:51] [float] NULL,
	[Totaliser_42019-12-21 0:3:44] [float] NULL,
	[Totaliser_42019-12-22 0:1:27] [float] NULL,
	[Totaliser_42019-12-23 0:7:31] [float] NULL,
	[Totaliser_42019-12-24 0:1:10] [float] NULL,
	[Totaliser_42019-12-25 0:0:42] [float] NULL,
	[Totaliser_42019-12-26 0:5:37] [float] NULL,
	[Totaliser_42019-12-27 0:12:13] [float] NULL,
	[Totaliser_42019-12-28 0:6:21] [float] NULL,
	[Totaliser_42019-12-29 0:6:7] [float] NULL,
	[Totaliser_42019-12-30 0:6:2] [float] NULL,
	[Totaliser_42020-1-1 0:11:27] [float] NULL,
	[Totaliser_42020-1-2 0:5:48] [float] NULL,
	[Totaliser_42020-1-3 0:3:45] [float] NULL,
	[Totaliser_42020-1-4 0:1:58] [float] NULL,
	[Totaliser_42020-1-5 0:12:44] [float] NULL,
	[Totaliser_42020-1-6 0:3:53] [float] NULL,
	[Totaliser_42020-1-7 0:5:6] [float] NULL,
	[Totaliser_42020-1-8 0:3:28] [float] NULL,
	[Totaliser_42020-1-9 0:14:20] [float] NULL,
	[Totaliser_42020-1-10 0:8:25] [float] NULL,
	[Totaliser_42020-1-11 0:11:28] [float] NULL,
	[Totaliser_42020-1-12 0:12:31] [float] NULL,
	[Totaliser_42020-1-13 0:0:27] [float] NULL,
	[Totaliser_42020-1-14 0:1:22] [float] NULL,
	[Totaliser_42020-1-15 0:13:48] [float] NULL,
	[Totaliser_42020-1-16 0:8:33] [float] NULL,
	[Totaliser_42020-1-17 0:2:10] [float] NULL,
	[Totaliser_42020-1-18 0:2:1] [float] NULL,
	[Totaliser_42020-1-19 0:8:33] [float] NULL,
	[Totaliser_42020-1-20 0:1:11] [float] NULL,
	[Totaliser_42020-1-21 0:9:54] [float] NULL,
	[Totaliser_42020-1-22 0:4:25] [float] NULL,
	[Totaliser_42020-1-23 0:1:33] [float] NULL,
	[Totaliser_42020-1-24 0:7:59] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GasMetersMetadata]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GasMetersMetadata](
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GasMetersMetadata_history]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GasMetersMetadata_history](
	[FileID] [int] NOT NULL,
	[FieldName] [varchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GeneratorData]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GeneratorData](
	[FileID] [int] NULL,
	[REASON] [nvarchar](50) NULL,
	[ItemDATE] [nvarchar](50) NULL,
	[ItemTIME] [nvarchar](50) NULL,
	[SITENAME] [nvarchar](50) NULL,
	[GENSETNAME] [nvarchar](50) NULL,
	[GENSET_SN] [nvarchar](50) NULL,
	[EVENT] [nvarchar](50) NULL,
	[RPM] [nvarchar](50) NULL,
	[Pwr] [nvarchar](50) NULL,
	[PF] [nvarchar](50) NULL,
	[Gfrq] [nvarchar](50) NULL,
	[Vg1] [nvarchar](50) NULL,
	[Vg2] [nvarchar](50) NULL,
	[Vg3] [nvarchar](50) NULL,
	[Vg12] [nvarchar](50) NULL,
	[Vg23] [nvarchar](50) NULL,
	[Vg31] [nvarchar](50) NULL,
	[Ig1] [nvarchar](50) NULL,
	[Ig2] [nvarchar](50) NULL,
	[Ig3] [nvarchar](50) NULL,
	[Mfrq] [nvarchar](50) NULL,
	[Vm1] [nvarchar](50) NULL,
	[Vm2] [nvarchar](50) NULL,
	[Vm3] [nvarchar](50) NULL,
	[Vm12] [nvarchar](50) NULL,
	[Vm23] [nvarchar](50) NULL,
	[Vm31] [nvarchar](50) NULL,
	[MPF] [nvarchar](50) NULL,
	[SRO] [nvarchar](50) NULL,
	[VRO] [nvarchar](50) NULL,
	[CPUT] [nvarchar](50) NULL,
	[Unknown] [nvarchar](50) NULL,
	[GasP] [nvarchar](50) NULL,
	[Mode] [nvarchar](50) NULL,
	[kWhour] [nvarchar](50) NULL,
	[Runhrs] [nvarchar](50) NULL,
	[Numstr] [nvarchar](50) NULL,
	[LTHWfT] [nvarchar](50) NULL,
	[OilB4F] [nvarchar](50) NULL,
	[OilLev] [nvarchar](50) NULL,
	[OilT] [nvarchar](50) NULL,
	[ThrPos] [nvarchar](50) NULL,
	[Unknown2] [nvarchar](50) NULL,
	[CCPres] [nvarchar](50) NULL,
	[AirInT] [nvarchar](50) NULL,
	[RecAT] [nvarchar](50) NULL,
	[Unknown3] [nvarchar](50) NULL,
	[ActPwr] [nvarchar](50) NULL,
	[ActDem] [nvarchar](50) NULL,
	[ActPfi] [nvarchar](50) NULL,
	[Unknown4] [nvarchar](50) NULL,
	[CylA1] [nvarchar](50) NULL,
	[CylA2] [nvarchar](50) NULL,
	[CylA3] [nvarchar](50) NULL,
	[CylA4] [nvarchar](50) NULL,
	[CylA5] [nvarchar](50) NULL,
	[CylA6] [nvarchar](50) NULL,
	[CylA7] [nvarchar](50) NULL,
	[CylA8] [nvarchar](50) NULL,
	[CylA9] [nvarchar](50) NULL,
	[CylA10] [nvarchar](50) NULL,
	[CylB1] [nvarchar](50) NULL,
	[CylB2] [nvarchar](50) NULL,
	[CylB3] [nvarchar](50) NULL,
	[CylB4] [nvarchar](50) NULL,
	[CylB5] [nvarchar](50) NULL,
	[CylB6] [nvarchar](50) NULL,
	[CylB7] [nvarchar](50) NULL,
	[CylB8] [nvarchar](50) NULL,
	[CylB9] [nvarchar](50) NULL,
	[CylB10] [nvarchar](50) NULL,
	[JWTin] [nvarchar](50) NULL,
	[JWTout] [nvarchar](50) NULL,
	[JWGKin] [nvarchar](50) NULL,
	[Unknown5] [nvarchar](50) NULL,
	[Unknown6] [nvarchar](50) NULL,
	[CH4] [nvarchar](50) NULL,
	[BIN] [nvarchar](50) NULL,
	[BI1] [nvarchar](50) NULL,
	[BI2] [nvarchar](50) NULL,
	[BI3] [nvarchar](50) NULL,
	[BI4] [nvarchar](50) NULL,
	[BI5] [nvarchar](50) NULL,
	[BI6] [nvarchar](50) NULL,
	[BI7] [nvarchar](50) NULL,
	[BI8] [nvarchar](50) NULL,
	[BI9] [nvarchar](50) NULL,
	[BI10] [nvarchar](50) NULL,
	[BI11] [nvarchar](50) NULL,
	[BI12] [nvarchar](50) NULL,
	[BOUT] [nvarchar](50) NULL,
	[BO1] [nvarchar](50) NULL,
	[BO2] [nvarchar](50) NULL,
	[BO3] [nvarchar](50) NULL,
	[Unknown7] [nvarchar](50) NULL,
	[TEMv] [nvarchar](50) NULL,
	[Pmns] [nvarchar](50) NULL,
	[MVS] [nvarchar](50) NULL,
	[Qmns] [nvarchar](50) NULL,
	[Ubat] [nvarchar](50) NULL,
	[Amb] [nvarchar](50) NULL,
	[Unknown8] [nvarchar](50) NULL,
	[ExDman] [nvarchar](50) NULL,
	[Unknown9] [nvarchar](50) NULL,
	[H2S] [nvarchar](50) NULL,
	[Unknown10] [nvarchar](50) NULL,
	[GrokWh] [nvarchar](50) NULL,
	[Unknown11] [nvarchar](50) NULL,
	[ExPlim] [nvarchar](50) NULL,
	[GFlwM3] [nvarchar](50) NULL,
	[LTHWrT] [nvarchar](50) NULL,
	[Unknown12] [nvarchar](50) NULL,
	[Hrsx1] [nvarchar](50) NULL,
	[Unknown13] [nvarchar](50) NULL,
	[Hrsx10] [nvarchar](50) NULL,
	[Unknown14] [nvarchar](50) NULL,
	[loadr] [nvarchar](50) NULL,
	[Unknown15] [nvarchar](50) NULL,
	[BO4] [nvarchar](50) NULL,
	[spare] [nvarchar](50) NULL,
	[spare2] [nvarchar](50) NULL,
	[Stsx1] [nvarchar](50) NULL,
	[PwrDem] [nvarchar](50) NULL,
	[ActPwrReq] [nvarchar](50) NULL,
	[ImpLoad] [nvarchar](50) NULL,
	[Unknown16] [nvarchar](50) NULL,
	[Unknown17] [nvarchar](50) NULL,
	[Unknown18] [nvarchar](50) NULL,
	[Unknown19] [nvarchar](50) NULL,
	[Unknown20] [nvarchar](50) NULL,
	[Unknown21] [nvarchar](50) NULL,
	[Unknown22] [nvarchar](50) NULL,
	[Unknown23] [nvarchar](50) NULL,
	[Unknown24] [nvarchar](50) NULL,
	[Unknown25] [nvarchar](50) NULL,
	[Unknown26] [nvarchar](50) NULL,
	[Unknown27] [nvarchar](50) NULL,
	[Unknown28] [nvarchar](50) NULL,
	[Unknown29] [nvarchar](50) NULL,
	[Unknown30] [nvarchar](50) NULL,
	[Unknown31] [nvarchar](50) NULL,
	[Unknown32] [nvarchar](50) NULL,
	[Unknown33] [nvarchar](50) NULL,
	[Unknown34] [nvarchar](50) NULL,
	[Unknown35] [nvarchar](50) NULL,
	[Unknown36] [nvarchar](50) NULL,
	[Unknown37] [nvarchar](50) NULL,
	[Unknown38] [nvarchar](50) NULL,
	[Unknown39] [nvarchar](50) NULL,
	[Unknown40] [nvarchar](50) NULL,
	[Unknown41] [nvarchar](50) NULL,
	[Unknown42] [nvarchar](50) NULL,
	[Unknown43] [nvarchar](50) NULL,
	[Unknown44] [nvarchar](50) NULL,
	[Unknown45] [nvarchar](50) NULL,
	[Unknown46] [nvarchar](50) NULL,
	[Unknown47] [nvarchar](50) NULL,
	[Unknown48] [nvarchar](50) NULL,
	[kVarho] [nvarchar](50) NULL,
	[LChr] [nvarchar](50) NULL,
	[HWFlo] [nvarchar](50) NULL,
	[HWRtn] [nvarchar](50) NULL,
	[DemandKW] [nvarchar](50) NULL,
	[ExhAtu] [nvarchar](50) NULL,
	[L1temp] [nvarchar](50) NULL,
	[L2temp] [nvarchar](50) NULL,
	[L3temp] [nvarchar](50) NULL,
	[HKft] [nvarchar](50) NULL,
	[HKrt] [nvarchar](50) NULL,
	[GFlwRte] [nvarchar](50) NULL,
	[BrgAt] [nvarchar](50) NULL,
	[BrgBt] [nvarchar](50) NULL,
	[NumUns] [nvarchar](50) NULL,
	[Q] [nvarchar](50) NULL,
	[GasMet] [nvarchar](50) NULL,
	[MLChr] [nvarchar](50) NULL,
	[IcOut] [nvarchar](50) NULL,
	[D+] [nvarchar](50) NULL,
	[U] [nvarchar](50) NULL,
	[V] [nvarchar](50) NULL,
	[W] [nvarchar](50) NULL,
	[HtMet] [nvarchar](50) NULL,
	[ChMet] [nvarchar](50) NULL,
	[BO5] [nvarchar](50) NULL,
	[TotRunPact] [nvarchar](50) NULL,
	[TotRunPnomAll] [nvarchar](50) NULL,
	[SumMWh] [nvarchar](50) NULL,
	[AuxKwh] [nvarchar](50) NULL,
	[Bfrq] [nvarchar](50) NULL,
	[Vb1] [nvarchar](50) NULL,
	[Vb2] [nvarchar](50) NULL,
	[Vb3] [nvarchar](50) NULL,
	[Vb12] [nvarchar](50) NULL,
	[Vb23] [nvarchar](50) NULL,
	[Vb31] [nvarchar](50) NULL,
	[Spare3] [nvarchar](50) NULL,
	[Spare4] [nvarchar](50) NULL,
	[MaxVec] [nvarchar](50) NULL,
	[WindingV] [nvarchar](50) NULL,
	[WindingU] [nvarchar](50) NULL,
	[LTHW] [nvarchar](50) NULL,
	[WindingW] [nvarchar](50) NULL,
	[Spare6] [nvarchar](50) NULL,
	[Spare7] [nvarchar](50) NULL,
	[Spare8] [nvarchar](50) NULL,
	[kVAHrs] [nvarchar](50) NULL,
	[spare5] [nvarchar](50) NULL,
	[Demand] [nvarchar](50) NULL,
	[GasFR] [nvarchar](50) NULL,
	[OilPres] [nvarchar](50) NULL,
	[GasInPres] [nvarchar](50) NULL,
	[IM3] [nvarchar](50) NULL,
	[GasFl] [nvarchar](50) NULL,
	[JW Inst Flow] [nvarchar](50) NULL,
	[Flow Temp T291] [nvarchar](50) NULL,
	[ICRtrnTemp X01] [nvarchar](50) NULL,
	[ICRtrnTempX02] [nvarchar](50) NULL,
	[LTW Flow Temp] [nvarchar](50) NULL,
	[Sts x10000] [nvarchar](50) NULL,
	[SHBO2] [nvarchar](50) NULL,
	[HWFl] [nvarchar](50) NULL,
	[VPIO BOUT1] [nvarchar](50) NULL,
	[TotDnT] [nvarchar](50) NULL,
	[Unknown49] [nvarchar](50) NULL,
	[Unknown50] [nvarchar](50) NULL,
	[EngRPM] [nvarchar](50) NULL,
	[ExhBTu] [nvarchar](50) NULL,
	[NkOut] [nvarchar](50) NULL,
	[Plimit] [nvarchar](50) NULL,
	[ICrout] [nvarchar](50) NULL,
	[JWrout] [nvarchar](50) NULL,
	[NetkW] [nvarchar](50) NULL,
	[Demand KW] [nvarchar](50) NULL,
	[Load Demand] [nvarchar](50) NULL,
	[Rtn Temp T289] [nvarchar](50) NULL,
	[Sts x1] [nvarchar](50) NULL,
	[BOUT-4] [nvarchar](50) NULL,
	[BOUT-5] [nvarchar](50) NULL,
	[OilP] [nvarchar](50) NULL,
	[GenBrgA] [nvarchar](50) NULL,
	[GenBrgB] [nvarchar](50) NULL,
	[HWRet] [nvarchar](50) NULL,
	[GK Outlet Temp] [nvarchar](50) NULL,
	[ExATu] [nvarchar](50) NULL,
	[SBI1] [nvarchar](50) NULL,
	[Spare9] [nvarchar](50) NULL,
	[Spare10] [nvarchar](50) NULL,
	[ExhAT] [nvarchar](50) NULL,
	[LTHWfT2] [nvarchar](50) NULL,
	[NKOutT] [nvarchar](50) NULL,
	[HK Rtrn T289] [nvarchar](50) NULL,
	[SteamP] [nvarchar](50) NULL,
	[PwrDem2] [nvarchar](50) NULL,
	[(] [nvarchar](50) NULL,
	[Pwr2] [nvarchar](50) NULL,
	[Ig12] [nvarchar](50) NULL,
	[Ig22] [nvarchar](50) NULL,
	[Ig32] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GeneratorLog]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GeneratorLog](
	[HL_Processed] [bit] NULL,
	[ItemDATE] [datetime] NULL,
	[ItemTIME] [nvarchar](12) NULL,
	[SITENAME] [nvarchar](25) NULL,
	[GENSETNAME] [nvarchar](25) NULL,
	[GENSET_SN] [nvarchar](8) NULL,
	[REASON] [nvarchar](18) NULL,
	[EVENT] [nvarchar](128) NULL,
	[RPM] [nvarchar](50) NULL,
	[Pwr] [nvarchar](50) NULL,
	[Gfrq] [nvarchar](50) NULL,
	[Vg1] [nvarchar](50) NULL,
	[Vg2] [nvarchar](50) NULL,
	[Vg3] [nvarchar](50) NULL,
	[Vg12] [nvarchar](50) NULL,
	[Vg23] [nvarchar](50) NULL,
	[Vg31] [nvarchar](50) NULL,
	[Ig1] [nvarchar](50) NULL,
	[Ig2] [nvarchar](50) NULL,
	[Ig3] [nvarchar](50) NULL,
	[BIN] [nvarchar](50) NULL,
	[BOUT] [nvarchar](50) NULL,
	[Mode] [nvarchar](50) NULL,
	[LTHWrT] [nvarchar](50) NULL,
	[LTHWfT] [nvarchar](50) NULL,
	[OilB4F] [nvarchar](50) NULL,
	[CCpres] [nvarchar](50) NULL,
	[OilLev] [nvarchar](50) NULL,
	[ActPfi] [nvarchar](50) NULL,
	[ActDem] [nvarchar](50) NULL,
	[CH4] [nvarchar](50) NULL,
	[OilT] [nvarchar](50) NULL,
	[AirInT] [nvarchar](50) NULL,
	[RecAT] [nvarchar](50) NULL,
	[JWTout] [nvarchar](50) NULL,
	[JWTin] [nvarchar](50) NULL,
	[JWGKin] [nvarchar](50) NULL,
	[CylA1] [nvarchar](50) NULL,
	[CylA2] [nvarchar](50) NULL,
	[CylA3] [nvarchar](50) NULL,
	[CylA4] [nvarchar](50) NULL,
	[CylA5] [nvarchar](50) NULL,
	[CylA6] [nvarchar](50) NULL,
	[CylA7] [nvarchar](50) NULL,
	[CylA8] [nvarchar](50) NULL,
	[CylB1] [nvarchar](50) NULL,
	[CylB2] [nvarchar](50) NULL,
	[CylB3] [nvarchar](50) NULL,
	[CylB4] [nvarchar](50) NULL,
	[CylB5] [nvarchar](50) NULL,
	[CylB6] [nvarchar](50) NULL,
	[CylB7] [nvarchar](50) NULL,
	[CylB8] [nvarchar](50) NULL,
	[kWhour] [nvarchar](50) NULL,
	[Runhrs] [nvarchar](50) NULL,
	[Numstr] [nvarchar](50) NULL,
	[NumUns] [nvarchar](50) NULL,
	[Q] [nvarchar](50) NULL,
	[LChr] [nvarchar](50) NULL,
	[Mfrq] [nvarchar](50) NULL,
	[Vm1] [nvarchar](50) NULL,
	[Vm2] [nvarchar](50) NULL,
	[Vm3] [nvarchar](50) NULL,
	[Vm12] [nvarchar](50) NULL,
	[Vm23] [nvarchar](50) NULL,
	[Vm31] [nvarchar](50) NULL,
	[Pmns] [nvarchar](50) NULL,
	[Qmns] [nvarchar](50) NULL,
	[MPF] [nvarchar](50) NULL,
	[MVS] [nvarchar](50) NULL,
	[SRO] [nvarchar](50) NULL,
	[VRO] [nvarchar](50) NULL,
	[UBat] [nvarchar](50) NULL,
	[CPUT] [nvarchar](50) NULL,
	[ActPwr] [nvarchar](50) NULL,
	[Amb] [nvarchar](50) NULL,
	[GasP] [nvarchar](50) NULL,
	[GasMet] [nvarchar](50) NULL,
	[PF] [nvarchar](50) NULL,
	[H2S] [nvarchar](50) NULL,
	[ThrPos] [nvarchar](50) NULL,
	[kVarho] [nvarchar](50) NULL,
	[BI1] [nvarchar](50) NULL,
	[BI2] [nvarchar](50) NULL,
	[BI3] [nvarchar](50) NULL,
	[BI4] [nvarchar](50) NULL,
	[BI5] [nvarchar](50) NULL,
	[BI6] [nvarchar](50) NULL,
	[BI7] [nvarchar](50) NULL,
	[BI8] [nvarchar](50) NULL,
	[BI9] [nvarchar](50) NULL,
	[BI10] [nvarchar](50) NULL,
	[BI11] [nvarchar](50) NULL,
	[BO1] [nvarchar](50) NULL,
	[BO2] [nvarchar](50) NULL,
	[BO3] [nvarchar](50) NULL,
	[CylA9] [nvarchar](50) NULL,
	[CylA10] [nvarchar](50) NULL,
	[CylB9] [nvarchar](50) NULL,
	[CylB10] [nvarchar](50) NULL,
	[BI12] [nvarchar](50) NULL,
	[TEMv] [nvarchar](50) NULL,
	[MLChr] [nvarchar](50) NULL,
	[GroKwh] [nvarchar](50) NULL,
	[BO4] [nvarchar](50) NULL,
	[IcOut] [nvarchar](50) NULL,
	[D+] [nvarchar](50) NULL,
	[U] [nvarchar](50) NULL,
	[V] [nvarchar](50) NULL,
	[W] [nvarchar](50) NULL,
	[GFlwRte] [nvarchar](50) NULL,
	[GFlwM3] [nvarchar](50) NULL,
	[Spare] [nvarchar](50) NULL,
	[HWFlo] [nvarchar](50) NULL,
	[HWRtn] [nvarchar](50) NULL,
	[HtMet] [nvarchar](50) NULL,
	[ChMet] [nvarchar](50) NULL,
	[BO5] [nvarchar](50) NULL,
	[TotRunPact] [nvarchar](50) NULL,
	[TotRunPnomAll] [nvarchar](50) NULL,
	[SumMWh] [nvarchar](50) NULL,
	[PwrDem] [nvarchar](50) NULL,
	[ActPwrReq] [nvarchar](50) NULL,
	[ImpLoad] [nvarchar](50) NULL,
	[AuxKwh] [nvarchar](50) NULL,
	[UpdateTime_Processed] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GeneratorMetadata]    Script Date: 26/05/2020 18:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GeneratorMetadata](
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Staging].[GeneratorMetadata_history]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Staging].[GeneratorMetadata_history](
	[FileID] [int] NOT NULL,
	[FieldName] [varchar](500) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_ID_Location]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idx_ID_Location] ON [dbo].[BB_SMSLog]
(
	[ID_Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_SMS_SendTime]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idx_SMS_SendTime] ON [dbo].[BB_SMSLog]
(
	[SMS_SendTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nci_wi_Blackboxes_840C5497C27D947BA98F79CA3D36066E]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_Blackboxes_840C5497C27D947BA98F79CA3D36066E] ON [dbo].[Blackboxes]
(
	[CFG_State] ASC
)
INCLUDE ( 	[BB_SerialNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idxDtDown]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idxDtDown] ON [dbo].[Exempts]
(
	[DtDown] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idxDtUp]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idxDtUp] ON [dbo].[Exempts]
(
	[DtUp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idxID_Location]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idxID_Location] ON [dbo].[Exempts]
(
	[ID_Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idxIDDown]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idxIDDown] ON [dbo].[Exempts]
(
	[IDDown] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nci_wi_Exempts_46FD29E7B8D32B87C8C08AA346E0E185]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_Exempts_46FD29E7B8D32B87C8C08AA346E0E185] ON [dbo].[Exempts]
(
	[ID_Location] ASC,
	[DtDown] ASC
)
INCLUDE ( 	[Details],
	[DtUp],
	[IDDown],
	[IDUp],
	[IsExcluded],
	[IsExempt],
	[Reason],
	[TimeDifference]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [nci_wi_Exempts_D1FC7626630EBBC6E5696BDE1910EAC1]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_Exempts_D1FC7626630EBBC6E5696BDE1910EAC1] ON [dbo].[Exempts]
(
	[DtDown] ASC
)
INCLUDE ( 	[DtUp],
	[ID_Location],
	[IDDown],
	[IDUp],
	[IsExempt],
	[TimeDifference]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nci_wi_GeneratorAlarms_A3505322AA36D26C722C40EB315B5388]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_GeneratorAlarms_A3505322AA36D26C722C40EB315B5388] ON [dbo].[GeneratorAlarms]
(
	[IdLocation] ASC,
	[Active] ASC
)
INCLUDE ( 	[Confirmed],
	[Name],
	[Type],
	[UsersNotified],
	[UtcGenerated],
	[UtcReceived]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_AvailabilityProcessed]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_AvailabilityProcessed] ON [dbo].[GeneratorContent]
(
	[_AvailabilityProcessed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_IdEvent]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_IdEvent] ON [dbo].[GeneratorContent]
(
	[IdEvent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_IdLocation]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_IdLocation] ON [dbo].[GeneratorContent]
(
	[IdLocation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_kWhour]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_kWhour] ON [dbo].[GeneratorContent]
(
	[kWhour] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_Runhrs]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_Runhrs] ON [dbo].[GeneratorContent]
(
	[Runhrs] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_ShutdownProcessed]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_ShutdownProcessed] ON [dbo].[GeneratorContent]
(
	[_ShutdownProcessed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_StartupProcessed]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_StartupProcessed] ON [dbo].[GeneratorContent]
(
	[_StartupProcessed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_GeneratorContent_UpdateProcessed]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_GeneratorContent_UpdateProcessed] ON [dbo].[GeneratorContent]
(
	[_UpdateProcessed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nci_wi_GeneratorLogs_B8B829F41F7E22652C54C24B92EF7A82]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_GeneratorLogs_B8B829F41F7E22652C54C24B92EF7A82] ON [dbo].[GeneratorLogs]
(
	[IdLocation] ASC,
	[Type] ASC
)
INCLUDE ( 	[Data_B],
	[UtcGenerated]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idxGensetname]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idxGensetname] ON [dbo].[HL_Locations]
(
	[GENSETNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [nci_wi_Gas_9DE2095074C809C7218136BA760DE760]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_Gas_9DE2095074C809C7218136BA760DE760] ON [EnergyMeters].[Gas]
(
	[IdLocation] ASC,
	[IdMeter] ASC,
	[TimeStamp] ASC
)
INCLUDE ( 	[MassFlow],
	[Totaliser],
	[UtcGenerated],
	[UtcRecieved]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_EnergyMeters_Heat_TimeStamp]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [IDX_EnergyMeters_Heat_TimeStamp] ON [EnergyMeters].[Heat]
(
	[TimeStamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [nci_wi_Steam_71B784B1F3C9282AB3F35F55876D0AFA]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_Steam_71B784B1F3C9282AB3F35F55876D0AFA] ON [EnergyMeters].[Steam]
(
	[IdLocation] ASC,
	[TimeStamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_HL_Processed]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idx_HL_Processed] ON [Staging].[GeneratorLog]
(
	[HL_Processed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_ItemDATE]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [idx_ItemDATE] ON [Staging].[GeneratorLog]
(
	[ItemDATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nci_wi_GeneratorLog_4AC36DDCF95E77E8E94D57DA24BFDA82]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_GeneratorLog_4AC36DDCF95E77E8E94D57DA24BFDA82] ON [Staging].[GeneratorLog]
(
	[HL_Processed] ASC,
	[UpdateTime_Processed] ASC,
	[GENSET_SN] ASC
)
INCLUDE ( 	[ItemDATE],
	[ItemTIME]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nci_wi_GeneratorMetadata_1F747488C52704D084A60DEA02820259]    Script Date: 26/05/2020 18:27:04 ******/
CREATE NONCLUSTERED INDEX [nci_wi_GeneratorMetadata_1F747488C52704D084A60DEA02820259] ON [Staging].[GeneratorMetadata]
(
	[FieldName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GeneratorAlarms] ADD  DEFAULT (newid()) FOR [Guid]
GO
ALTER TABLE [dbo].[GeneratorAlarms] ADD  CONSTRAINT [UserNotified_Default]  DEFAULT ((0)) FOR [UsersNotified]
GO
ALTER TABLE [dbo].[GeneratorLogs] ADD  DEFAULT (newid()) FOR [Guid]
GO
ALTER TABLE [dbo].[GeneratorMeasurements] ADD  DEFAULT (newid()) FOR [Guid]
GO
ALTER TABLE [dbo].[InteliMainsMeasurements] ADD  DEFAULT (newid()) FOR [Guid]
GO
ALTER TABLE [dbo].[RTCULogs] ADD  DEFAULT (newid()) FOR [Guid]
GO
ALTER TABLE [dbo].[RTCUReport] ADD  DEFAULT (newid()) FOR [Guid]
GO
ALTER TABLE [dbo].[Blackboxes_Status]  WITH CHECK ADD  CONSTRAINT [FK_Blackboxes_Status_Blackboxes1] FOREIGN KEY([ID_Blackbox])
REFERENCES [dbo].[Blackboxes] ([ID])
GO
ALTER TABLE [dbo].[Blackboxes_Status] CHECK CONSTRAINT [FK_Blackboxes_Status_Blackboxes1]
GO
ALTER TABLE [dbo].[RolePagePermissions]  WITH CHECK ADD  CONSTRAINT [FK908CA78DEA0B85B9] FOREIGN KEY([PermissionRoleId])
REFERENCES [dbo].[PermissionRoles] ([Id])
GO
ALTER TABLE [dbo].[RolePagePermissions] CHECK CONSTRAINT [FK908CA78DEA0B85B9]
GO
ALTER TABLE [dbo].[RolePagePermissions]  WITH CHECK ADD  CONSTRAINT [FKED403FBB437FBC61] FOREIGN KEY([PermissionRoleId])
REFERENCES [dbo].[PermissionRoles] ([Id])
GO
ALTER TABLE [dbo].[RolePagePermissions] CHECK CONSTRAINT [FKED403FBB437FBC61]
GO
ALTER TABLE [dbo].[UserPagePermissions]  WITH CHECK ADD  CONSTRAINT [FK569472B2437FBC61] FOREIGN KEY([PermissionRoleId])
REFERENCES [dbo].[PermissionRoles] ([Id])
GO
ALTER TABLE [dbo].[UserPagePermissions] CHECK CONSTRAINT [FK569472B2437FBC61]
GO
ALTER TABLE [dbo].[UserPagePermissions]  WITH NOCHECK ADD  CONSTRAINT [FKCEA99660EA0B85B9] FOREIGN KEY([PermissionRoleId])
REFERENCES [dbo].[PermissionRoles] ([Id])
GO
ALTER TABLE [dbo].[UserPagePermissions] CHECK CONSTRAINT [FKCEA99660EA0B85B9]
GO
/****** Object:  StoredProcedure [dbo].[ed_Availability_GetById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Availability_GetById]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
SET NOCOUNT ON;
	
	SELECT 
	Id,
	IdLocation,
	IdUnavailable,
	IdAvailable,
	DtUnavailable,
	DtAvailable,
	TimeDifference,
	IsExempt,
	'YesNo' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END,
	Reason,
	ISNULL(Exclude, 0) AS Exclude
	FROM GeneratorAvailability
	WHERE IdLocation = @location
	--AND (Exclude IS NULL OR Exclude = 0)
	AND DtUnavailable between @begin and @end
	order by DtUnavailable
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Availability_GetUpDownTimes]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <14/02/2012>
-- Description:	<Returns the Uptime and Downtime for a specific Exempt>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Availability_GetUpDownTimes] 
	-- Add the parameters for the stored procedure here
	@Id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DtUnavailable, DtAvailable
	FROM GeneratorAvailability
	WHERE Id=@Id
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Availability_Reset]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Rutherford
-- Create date: 21/02/2012
-- Description:	Resets Exempt Details to the Original
-- =============================================
CREATE PROCEDURE [dbo].[ed_Availability_Reset] 
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;
	
		DECLARE @ORIG DATETIME
		
		SELECT @ORIG=OrigDtAvailable --Assign Var
		FROM dbo.GeneratorAvailability
		WHERE Id=@Id
	
		IF @ORIG IS NOT NULL
			UPDATE dbo.GeneratorAvailability
			SET DtAvailable=OrigDtAvailable, TimeDifference=DATEDIFF(minute, DtUnavailable, DtAvailable)
			WHERE Id=@Id

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Availability_Update]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Rutherford
-- Create date: 14/02/2012
-- Description:	Update DTDOWN
-- =============================================
CREATE PROCEDURE [dbo].[ed_Availability_Update]
	-- Add the parameters for the stored procedure here
	@Id INT,
	@NEWDT DATETIME,
	@DIFF INT,
	@REASON NVARCHAR(18),
	@DTUPDOWN BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @DTUPDOWN=1
		UPDATE dbo.GeneratorAvailability
		SET DtUnavailable=@NEWDT, TimeDifference=@DIFF, Reason=@REASON
		WHERE Id=@Id
	ELSE
		UPDATE dbo.GeneratorAvailability --Store Original Value
		SET OrigDtAvailable=COALESCE(OrigDtAvailable, DtAvailable)
		WHERE Id=@Id
		UPDATE dbo.GeneratorAvailability --Now Update
		SET DtAvailable=@NEWDT, TimeDifference=@DIFF
		WHERE Id=@Id	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Availability_UpdateDetailsById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Rutherford
-- Create date: 14/02/2012
-- Description:	Writes a Description for Exempt of specific ID
-- =============================================
CREATE PROCEDURE [dbo].[ed_Availability_UpdateDetailsById]
	-- Add the parameters for the stored procedure here
	@Id INT,
	@DETAILS NVARCHAR(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE dbo.GeneratorAvailability
	SET Details=@DETAILS
	WHERE Id=@Id
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Availability_UpdateIsExcludedById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Availability_UpdateIsExcludedById]
	@IdAvailability AS INT,
	@Exclude AS BIT
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE GeneratorAvailability
	SET Exclude=@Exclude
	WHERE ID=@IdAvailability
	   
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Availability_UpdateIsExemptById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Availability_UpdateIsExemptById]
	@Id INT,
	@IsExempt BIT
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE dbo.GeneratorAvailability
    SET IsExempt=@IsExempt
    WHERE Id=@Id
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Blackbox_Add]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil A. Rutherford
-- Create date: 18-05-2015
-- Description:	Adds a new datalogger unit to the Blackbox table
-- =============================================
CREATE PROCEDURE [dbo].[ed_Blackbox_Add] 
	-- Add the parameters for the stored procedure here
	@BB_SerialNo nvarchar(9),
	@BB_Model int,
	@CFG_ConnectedControllersCount int,
	@CFG_SiteName nvarchar(25),
	@CFG_GensetName01 nvarchar(25),
	@CFG_GensetName02 nvarchar(25),
	@CFG_GensetName03 nvarchar(25),
	@CFG_GensetName04 nvarchar(25),
	@CFG_GensetName05 nvarchar(25),
	@CFG_GensetName06 nvarchar(25),
	@CFG_GensetName07 nvarchar(25),
	@CFG_GensetName08 nvarchar(25),
	@CFG_GensetSN01 nvarchar(8),
	@CFG_GensetSN02 nvarchar(8),
	@CFG_GensetSN03 nvarchar(8),
	@CFG_GensetSN04 nvarchar(8),
	@CFG_GensetSN05 nvarchar(8),
	@CFG_GensetSN06 nvarchar(8),
	@CFG_GensetSN07 nvarchar(8),
	@CFG_GensetSN08 nvarchar(8),
	@CFG_FTPPrefix nvarchar(5),
	@CFG_PortNo int,
	@CFG_BaudRate nvarchar(10),
	@CFG_EthernetModuleEn bit,
	@CFG_FirstControllerAddr int,
	@CFG_HMAddr01 int,
	@CFG_HMAddr02 int,
	@CFG_HMAddr03 int,
	@CFG_HMAddr04 int,
	@CFG_HMAddr05 int,
	@CFG_HMAddr06 int,
	@CFG_HMAddr07 int,
	@CFG_HMAddr08 int,
	@CFG_SMAddr01 int,
	@CFG_SMAddr02 int,
	@CFG_SMAddr03 int,
	@CFG_SMAddr04 int,
	@CFG_SMAddr05 int,
	@CFG_SMAddr06 int,
	@CFG_SMAddr07 int,
	@CFG_SMAddr08 int,
	@CFG_GMAddr01 int,
	@CFG_GMAddr02 int,
	@CFG_GMAddr03 int,
	@CFG_GMAddr04 int,
	@CFG_CommsObjFilePath nvarchar(200),
    @CFG_CommsObjNameStr nvarchar(max),
    @CFG_CommsObjDimStr nvarchar(max),
    @CFG_CommsObjTypeStr nvarchar(max),
    @CFG_CommsObjLenStr nvarchar(max),
    @CFG_CommsObjDecStr nvarchar(max),
    @CFG_CommsObjOfsStr nvarchar(max),
    @CFG_CommsObjObjStr nvarchar(max),
    @CFG_HistoryColNameStr nvarchar(max),
    @CFG_HistoryColIDsStr nvarchar(max),
    @CFG_HistoryColTypeStr nvarchar(max),
    @CFG_DevMode bit,
    @CFG_AddOnCallNo01 nchar(11),
    @CFG_AddOnCallNo02 nchar(11),
    @CFG_AddOnCallNo03 nchar(11),
    @CFG_AddOnCallNo04 nchar(11),
    @CFG_AddOnCallNo05 nchar(11),
    @CFG_GenStatEmail nvarchar(50),
    @CFG_AdminEmail nvarchar(50),
    @CFG_ModbusSlaveEn bit,
    @CFG_STORWarnEn bit,
    @CFG_RegDemand int,
    @CFG_RegCylTempAvg int,
    @CFG_RegCylTempMax int,
    @CFG_RegCylTempMin int,
    @CreatedBy nvarchar(30)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into Blackboxes (BB_SerialNo, BB_Model, CFG_State, CFG_ConnectedControllersCount, CFG_SiteName, CFG_GensetName01, CFG_GensetName02,
							CFG_GensetName03, CFG_GensetName04, CFG_GensetName05, CFG_GensetName06, CFG_GensetName07, CFG_GensetName08,
							CFG_GensetSN01, CFG_GensetSN02, CFG_GensetSN03, CFG_GensetSN04, CFG_GensetSN05, CFG_GensetSN06, CFG_GensetSN07,
							CFG_GensetSN08, CFG_FTPPrefix, CFG_PortNo, CFG_BaudRate, CFG_EthernetModuleEn, CFG_FirstControllerAddr, CFG_HMAddr01,
							CFG_HMAddr02, CFG_HMAddr03, CFG_HMAddr04, CFG_HMAddr05, CFG_HMAddr06, CFG_HMAddr07, CFG_HMAddr08, CFG_SMAddr01,
							CFG_SMAddr02, CFG_SMAddr03, CFG_SMAddr04, CFG_SMAddr05, CFG_SMAddr06, CFG_SMAddr07, CFG_SMAddr08, CFG_GMAddr01,
							CFG_GMAddr02, CFG_GMAddr03, CFG_GMAddr04, CFG_CommsObjFilePath, CFG_CommsObjNameStr, CFG_CommsObjDimStr, 
							CFG_CommsObjTypeStr, CFG_CommsObjLenStr, CFG_CommsObjDecStr, CFG_CommsObjOfsStr, CFG_CommsObjObjStr, CFG_HistoryColNameStr,
							CFG_HistoryColIDsStr, CFG_HistoryColTypeStr, CFG_DevMode, CFG_AddOnCallNo01, CFG_AddOnCallNo02, CFG_AddOnCallNo03, CFG_AddOnCallNo04, CFG_AddOnCallNo05,
							CFG_GenStatEmail, CFG_AdminEmail, CFG_ModbusSlaveEn, CFG_STORWarnEn, CFG_RegDemand, CFG_RegCylTempAvg, CFG_RegCylTempMax, CFG_RegCylTempMin, CreationDate, CreatedBy)
							
					values (@BB_SerialNo, @BB_Model, 1, @CFG_ConnectedControllersCount, @CFG_SiteName, @CFG_GensetName01, @CFG_GensetName02,
							@CFG_GensetName03, @CFG_GensetName04, @CFG_GensetName05, @CFG_GensetName06, @CFG_GensetName07, @CFG_GensetName08,
							@CFG_GensetSN01, @CFG_GensetSN02, @CFG_GensetSN03, @CFG_GensetSN04, @CFG_GensetSN05, @CFG_GensetSN06, @CFG_GensetSN07,
							@CFG_GensetSN08, @CFG_FTPPrefix, @CFG_PortNo, @CFG_BaudRate, @CFG_EthernetModuleEn, @CFG_FirstControllerAddr, @CFG_HMAddr01,
							@CFG_HMAddr02, @CFG_HMAddr03, @CFG_HMAddr04, @CFG_HMAddr05, @CFG_HMAddr06, @CFG_HMAddr07, @CFG_HMAddr08, @CFG_SMAddr01,
							@CFG_SMAddr02, @CFG_SMAddr03, @CFG_SMAddr04, @CFG_SMAddr05, @CFG_SMAddr06, @CFG_SMAddr07, @CFG_SMAddr08, @CFG_GMAddr01,
							@CFG_GMAddr02, @CFG_GMAddr03, @CFG_GMAddr04, @CFG_CommsObjFilePath, @CFG_CommsObjNameStr, @CFG_CommsObjDimStr, 
							@CFG_CommsObjTypeStr, @CFG_CommsObjLenStr, @CFG_CommsObjDecStr, @CFG_CommsObjOfsStr, @CFG_CommsObjObjStr, @CFG_HistoryColNameStr,
							@CFG_HistoryColIDsStr, @CFG_HistoryColTypeStr, @CFG_DevMode, @CFG_AddOnCallNo01, @CFG_AddOnCallNo02, @CFG_AddOnCallNo03, @CFG_AddOnCallNo04, @CFG_AddOnCallNo05,
							@CFG_GenStatEmail, @CFG_AdminEmail, @CFG_ModbusSlaveEn, @CFG_STORWarnEn, @CFG_RegDemand, @CFG_RegCylTempAvg, @CFG_RegCylTempMax, @CFG_RegCylTempMin, GETDATE(), @CreatedBy)
	
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Blackbox_Get]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: <Create Date,,>
-- Description:	Needs updating when new units rolled out.
-- =============================================
CREATE PROCEDURE [dbo].[ed_Blackbox_Get] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT BB_SerialNo, BB_Model, CFG_SiteName,ST_LastStatusUpdateTime, ST_GSMSignalLevel, ST_BatteryChargeLevel, ST_TimeSinceLastResetSeconds, ST_ComapLinkPresent,
			CreatedBy, CreationDate, CFG_HMAddr01, CFG_HMAddr02, CFG_HMAddr03, CFG_HMAddr04, CFG_HMAddr05, CFG_HMAddr06, CFG_HMAddr07, CFG_HMAddr08,
			CFG_SMAddr01, CFG_SMAddr02, CFG_SMAddr03, CFG_SMAddr04, CFG_GMAddr01, CFG_GMAddr02, CFG_PortNo, CFG_BaudRate, CFG_EthernetModuleEn, CFG_AdminEmail
			
	FROM Blackboxes
	WHERE Enabled <> 0
	ORDER BY CFG_SiteName
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Blackbox_Replace]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Blackbox_Replace]
	-- Add the parameters for the stored procedure here
	@BB_NewSerialNo nvarchar(9),
	@BB_OldSerialNo nvarchar(9),
	@BB_Model int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @BB_Model=2 -- default AX9 unit

    -- Create a new blackbox in the table
	IF LEN(@BB_OldSerialNo) = 9
	BEGIN
		IF LEN(@BB_NewSerialNo) = 9
		BEGIN
			IF EXISTS (SELECT * FROM Blackboxes WHERE BB_SerialNo=@BB_OldSerialNo)
				BEGIN
					print 'Old unit settings found.'

					IF NOT EXISTS (SELECT * FROM Blackboxes WHERE BB_SerialNo=@BB_NewSerialNo)
						BEGIN
							-- Copy Settings
							SELECT * INTO #temptable from Blackboxes WHERE BB_SerialNo=@BB_OldSerialNo

							-- Modify
							UPDATE #temptable SET BB_SerialNo=@BB_NewSerialNo,BB_Model=@BB_Model,
												  ST_LastStatusUpdateTime=NULL, ST_GSMSignalLevel=NULL,
												  ST_BatteryChargeLevel=NULL, ST_PowerSupplyType=NULL, ST_TimeSinceLastResetSeconds=NULL,
												  ST_ComapLinkPresent=NULL, ST_RestartsCount=NULL, CFG_MaxRecordsPerFile=NULL,
												  CreationDate=GETDATE(),
												  CreatedBy='SwapScript' WHERE BB_SerialNo=@BB_OldSerialNo

							ALTER TABLE #temptable
							DROP COLUMN ID

							SELECT * FROM #temptable

							--Insert the Blackbox serial
							print 'Creating new unit and copying settings..'

							INSERT Blackboxes
							SELECT * FROM #temptable
							WHERE BB_SerialNo=@BB_NewSerialNo
					
							print 'Unit created and settings copied.'

							--Update the HL_Locations Table
							print 'Updating associated sites..'

							UPDATE HL_Locations
							SET BLACKBOX_SN=@BB_NewSerialNo
							WHERE BLACKBOX_SN=@BB_OldSerialNo

							print 'Sites updated..'


							DROP TABLE #temptable;
							print 'Script complete without errors.'
						END
					ELSE
						BEGIN
							print 'Halt - New unit already exists.'
						END
				END
			ELSE
				BEGIN
					print 'Halt - Old unit settings not found.'
				END
		END
		ELSE
		BEGIN
			print 'Halt - New serial number is invalid!'
		END
	END
	ELSE
	BEGIN
		print 'Halt - Old serial number is invalid!'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[ed_CategorizedEvents_Add]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_CategorizedEvents_Add]
	-- Add the parameters for the stored procedure here
	@ID_EVENT		INT,
	@ID_CATEGORY	INT
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO CATEGORIZEDEVENTS(ID_EVENT, ID_CATEGORY) 
	VALUES (@ID_EVENT,@ID_CATEGORY)
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_CategorizedEvents_Delete]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_CategorizedEvents_Delete]
	-- Add the parameters for the stored procedure here
	@ID_EVENT		INT,
	@ID_CATEGORY	INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM CATEGORIZEDEVENTS 
	WHERE ID_EVENT=@ID_EVENT AND ID_CATEGORY=@ID_CATEGORY
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_ComapBinaryDefinition_Insert]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 10/03/2015
-- Description:	Inserts a new header map where the CommsObj_Name is unique
-- =============================================
CREATE PROCEDURE [dbo].[ed_ComapBinaryDefinition_Insert]
	@ID_Blackbox int,
	@Type nvarchar(15),
	@Tooltip nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	IF EXISTS (SELECT * FROM ComAp_BinaryTypes WHERE ID_Blackbox=@ID_Blackbox AND Type = @Type)
		UPDATE ComAp_BinaryTypes SET Tooltip=@Tooltip WHERE ID_Blackbox=@ID_Blackbox AND Type = @Type
	ELSE
		INSERT INTO ComAp_BinaryTypes (ID_Blackbox, Type, Tooltip) VALUES (@ID_Blackbox, @Type, @Tooltip)

END
GO
/****** Object:  StoredProcedure [dbo].[ed_ComapBinaryMap_Insert]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 10/03/2015
-- Description:	Inserts a new header map where the CommsObj_Name is unique
-- =============================================
CREATE PROCEDURE [dbo].[ed_ComapBinaryMap_Insert]
	@ID_Blackbox int,
	@ColumnName nvarchar(30),
	@BinaryType nvarchar(15)
AS
BEGIN
	declare @TypeID int
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	-- Does the BinaryType exist for this blackbox
	IF EXISTS (SELECT * FROM ComAp_BinaryTypes WHERE ID_Blackbox=@ID_Blackbox AND Type = @BinaryType)
		-- Yes, so map it
		SET @TypeID = (SELECT id FROM ComAp_BinaryTypes WHERE ID_Blackbox=@ID_Blackbox AND Type = @BinaryType)
		IF EXISTS (SELECT * FROM ComAp_BinaryTypes_Mapping WHERE ID_Blackbox=@ID_Blackbox AND ColumnName = @ColumnName)
			UPDATE ComAp_BinaryTypes_Mapping SET ID_BinaryType=@TypeID WHERE ID_Blackbox=@ID_Blackbox AND ColumnName = @ColumnName
		ELSE
			INSERT INTO ComAp_BinaryTypes_Mapping (ID_Blackbox, ColumnName, ID_BinaryType) VALUES (@ID_Blackbox, @ColumnName, @TypeID)

END
GO
/****** Object:  StoredProcedure [dbo].[ed_ComapHeaders_Get]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 17/01/2015
-- Description:	Get all records from the table
-- =============================================
CREATE PROCEDURE [dbo].[ed_ComapHeaders_Get] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [id]
      ,[History_Header]
      ,[History_Description]
      ,[Fixed]
      ,[Required]
  FROM [dbo].[ComAp_Headers]
  
END
GO
/****** Object:  StoredProcedure [dbo].[ed_ComapWildcard_Get]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 17/01/2015
-- Description:	Get all records from the table
-- =============================================
CREATE PROCEDURE [dbo].[ed_ComapWildcard_Get] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [id]
      ,[id_Header]
      ,[CommsObj_Name]
      ,[CommsObj_Dim]
      ,[CommsObj_Type]
      ,[CommsObj_Len]
      ,[CommsObj_Dec]
      ,[CommsObj_Ofs]
      ,[CommsObj_Obj]
      ,[Approved]
  FROM [dbo].[ComAp_Wildcard]
  
END
GO
/****** Object:  StoredProcedure [dbo].[ed_ComapWildcard_Insert]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 10/03/2015
-- Description:	Inserts a new header map where the CommsObj_Name is unique
-- =============================================
CREATE PROCEDURE [dbo].[ed_ComapWildcard_Insert]
	@id_Header int,
	@CommsObj_Name nvarchar(50),
	@CommsObj_Dim nvarchar(10),
    @CommsObj_Type nvarchar(10),
    @CommsObj_Len int,
    @CommsObj_Dec int,
    @CommsObj_Ofs int,
    @CommsObj_Obj int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
    INSERT INTO ComAp_Wildcard (id_Header, CommsObj_Name, CommsObj_Dim, CommsObj_Type, CommsObj_Len, CommsObj_Dec, CommsObj_Ofs, CommsObj_Obj)
    SELECT @id_Header, @CommsObj_Name, @CommsObj_Dim, @CommsObj_Type, @CommsObj_Len, @CommsObj_Dec, @CommsObj_Ofs, @CommsObj_Obj
    WHERE NOT EXISTS 
    (
		SELECT 1
        FROM ComAp_Wildcard 
        WHERE CommsObj_Name = @CommsObj_Name 
    );

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Contract_Edit]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Contract_Edit]
	@ID_LOCATION AS INT,
	@ContractType AS NVARCHAR(50),
	@ContractOutput AS INT,
	@ContractAvailability AS DECIMAL(6,4),
	@DutyCycle AS INT,
	@ConStDate AS Date,
	@ConLen AS INT,
	@InitialRunhrs AS INT,
	@InitialKwhrs AS INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ID_CONTRACTINFO INT

	SELECT @ID_CONTRACTINFO = ISNULL(ID_CONTRACTINFORMATION,0) FROM HL_LOCATIONS WHERE ID=@ID_LOCATION

	IF @ID_CONTRACTINFO = 0
	BEGIN
		--Dont exists yet, add and reference it to the generator
		INSERT INTO ContractInformation(ContractType,ContractOutput,ContractAvailability,DutyCycle,ContractStartDate,ContractLength,InitialRunHrs, InitialKwHours)
		VALUES (@ContractType,@ContractOutput,@ContractAvailability,@DutyCycle,@ConStDate,@ConLen,@InitialRunhrs,@InitialKwhrs)

		UPDATE HL_Locations 
		SET ID_ContractInformation=@@IDENTITY
		WHERE (ID=@ID_LOCATION)
	END
	ELSE
		UPDATE ContractInformation
		SET ContractType=@ContractType, 
			ContractOutput=@ContractOutput, 
			ContractAvailability=@ContractAvailability, 
			DutyCycle=@DutyCycle,
			ContractStartDate=@ConStDate,
			ContractLength=@ConLen,
			InitialRunHrs=@InitialRunhrs,
			InitialKwHours=@InitialKwhrs
		WHERE ID=@ID_CONTRACTINFO
	   
END
GO
/****** Object:  StoredProcedure [dbo].[ed_CreateTableFromCSString]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherfford
-- Create date: 04/10/2016
-- Description:	Create a table with varchar(100) columns from a character seperated string
-- =============================================
CREATE PROCEDURE [dbo].[ed_CreateTableFromCSString] 
	
	 @Input NVARCHAR(MAX),
     @Character CHAR(1),
	 @OutputTableName nvarchar(1000)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @StartIndex INT, @EndIndex INT, @Column NVARCHAR(100), @UnknownCounter INT, @SpareCounter INT, @CreateTableSQL VARCHAR(8000)
	SET @UnknownCounter = 0;
	SET @SpareCounter = 0;

	-- Statement starts
    SET @CreateTableSQL = 'CREATE TABLE ' + @OutputTableName + ' (';

	SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
		
	  -- Loop all seperated column names
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)

			SET @Column = SUBSTRING(@Input, @StartIndex, @EndIndex - 1)

			-- If we have unknown columns there may be several so append with index
			IF UPPER(@Column) LIKE '%UNKNOWN%'
			BEGIN
				SET @Column = @Column + CONVERT(VARCHAR,@UnknownCounter)
				SET @UnknownCounter = @UnknownCounter + 1
			END

			IF UPPER(@Column) LIKE '%SPARE%'
			BEGIN
				SET @Column = @Column + CONVERT(VARCHAR,@SpareCounter)
				SET @SpareCounter = @SpareCounter + 1
			END

			-- Check for empty column
			IF NULLIF(@Column, '') IS NULL
				print 'An empty column was ignored'
			ELSE
				BEGIN
					SET @CreateTableSQL = @CreateTableSQL + '[' + @Column + '] varchar(100), '
				END
			
			SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END

	  -- Remove the last comma & close off string
	  SET @CreateTableSQL = SUBSTRING(@CreateTableSQL, 0, LEN(@CreateTableSQL))
	  SET @CreateTableSQL = @CreateTableSQL + ')'

	  -- Create the table
	  print @createtablesql
	  exec (@CreateTableSQL)

END
GO
/****** Object:  StoredProcedure [dbo].[ed_EnergyMeters_GetColumnDifferenceByDays]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_EnergyMeters_GetColumnDifferenceByDays]
	-- Add the parameters for the stored procedure here
	@IdLocation int,
	@MeterId int,
	@Startdate datetime,
	@Enddate datetime
AS
BEGIN
	
	 SELECT MAX(Energy) - MIN(Energy) AS TotalEnergy, CONVERT(VARCHAR,TimeStamp,103) AS TIME_STAMP
	 FROM EnergyMeters.Heat 
	 WHERE IdMeter = @MeterId AND IdLocation = @IdLocation AND Energy IS NOT NULL
	 AND TimeStamp BETWEEN CONVERT(varchar, @Startdate, 110) AND CONVERT(varchar, @Enddate, 110) 
	 GROUP BY CONVERT(VARCHAR,Timestamp,111), CONVERT(VARCHAR,Timestamp,103) 
	 ORDER BY CONVERT(VARCHAR,Timestamp,111);

END
GO
/****** Object:  StoredProcedure [dbo].[ed_EnergyMeters_GetGasDifferenceByDays]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 28/07/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_EnergyMeters_GetGasDifferenceByDays]
	-- Add the parameters for the stored procedure here
	@IdLocation int,
	@MeterId int,
	@Startdate datetime,
	@Enddate datetime
AS
BEGIN

	SELECT MAX(Totaliser) - MIN(Totaliser) AS TotalVolume, CONVERT(VARCHAR,TimeStamp,103) AS TIME_STAMP
	FROM EnergyMeters.Gas 
	WHERE IdMeter = @MeterId AND IdLocation = @IdLocation AND Totaliser IS NOT NULL
	AND TimeStamp BETWEEN CONVERT(varchar, @Startdate, 110) AND CONVERT(varchar, @Enddate, 110) 
	GROUP BY CONVERT(VARCHAR,Timestamp,111), CONVERT(VARCHAR,Timestamp,103) 
	ORDER BY CONVERT(VARCHAR,Timestamp,111);
END
GO
/****** Object:  StoredProcedure [dbo].[ed_EnergyMeters_GetMapCountById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: <Create Date,,>
-- Description:	Returns the number of valid meter associations for a site
-- =============================================
CREATE PROCEDURE [dbo].[ed_EnergyMeters_GetMapCountById] 
	
	@ID_Location as integer,
	@ID_Type as integer,
	@Modbus_Addr as integer
	
AS
BEGIN
	
	SELECT COUNT(*) AS RecordCount FROM EnergyMeters_Mapping
	WHERE ID_Location = @ID_Location
	AND Modbus_Addr = @Modbus_Addr
	AND ID_Type <> @ID_Type
	AND @Modbus_Addr <> -1
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_EnergyMeters_UpdateMapping]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_EnergyMeters_UpdateMapping] 
	
	@ID_Location as integer,
	@ID_Type as integer,
	@Modbus_Addr as integer
	
AS
BEGIN
	
	UPDATE EnergyMeters_Mapping
	SET Modbus_Addr = @Modbus_Addr
	WHERE ID_Location = @ID_Location AND ID_Type = @ID_Type
	
	IF @@ROWCOUNT = 0
	INSERT INTO EnergyMeters_Mapping (ID_Location, ID_Type, Modbus_Addr)
	VALUES (@ID_Location, @ID_Type, @Modbus_Addr)
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_Get]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_Get]
	@begin datetime,
	@end datetime
AS
BEGIN
SET NOCOUNT ON;
	
	SELECT ID, ID_LOCATION, IDDOWN, IDUP, DTDOWN, DTUP, TIMEDIFFERENCE, ISEXEMPT,
		'YesNo' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END
	FROM EXEMPTS
	WHERE DTDOWN <= @END
	AND DTDOWN >= @BEGIN
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_GetById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_GetById]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
SET NOCOUNT ON;
	
	SELECT ID, ID_LOCATION, IDDOWN, IDUP, DTDOWN, DTUP, TIMEDIFFERENCE, ISEXEMPT, ISEXCLUDED,
		'YesNo' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END
	FROM EXEMPTS
	WHERE ID_LOCATION = @LOCATION
	AND DTDOWN <= @END
	AND DTUP >= @BEGIN
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_GetUpDownTimes]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <14/02/2012>
-- Description:	<Returns the Uptime and Downtime for a specific Exempt>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_GetUpDownTimes] 
	-- Add the parameters for the stored procedure here
	@ID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DTDOWN, DTUP
	FROM dbo.Exempts
	WHERE ID=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_GetWithReason]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 14/01/2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_GetWithReason]
	@begin datetime,
	@end datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @MyBegin datetime
	declare @MyEnd datetime
	
	set @MyBegin = @begin
	set @MyEnd = @end
	
	
		SELECT ID, (Select GENSETNAME from HL_Locations where id=ID_LOCATION) as Genset, ID_Location, IDDOWN, IDUP, DTDOWN, DTUP, TIMEDIFFERENCE, ISEXEMPT, IsExcluded, DETAILS,
			'YesNo' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END,
			'REASON' = CASE WHEN Reason IS NOT NULL THEN Reason ELSE ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM dbo.GeneratorContent, HL_EVENTS AS EV 
				 WHERE EV.ID = IdEvent 
				 AND TimeStamp BETWEEN DATEADD(hour,-12,EXEMPTS.DTDOWN) AND EXEMPTS.DTDOWN
				 AND IdEvent NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 AND IdEvent NOT IN (72,73) --Hardcoded, need a better solution here.
				 ORDER BY TimeStamp DESC),
			'UNKNOWN') END
		FROM EXEMPTS
		WHERE DtDown <= @MyEnd
		AND DtDown >= @MyBegin -- Was DTUP
		ORDER BY DtDown ASC
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_GetWithReasonAndGensetName]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 14/01/2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_GetWithReasonAndGensetName]
	@begin datetime,
	@end datetime,
	@IdLocation int
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @MyBegin datetime
	declare @MyEnd datetime
	
	set @MyBegin = @begin
	set @MyEnd = @end
	
	
		SELECT ID, (Select GENSETNAME from HL_Locations where id=ID_LOCATION) as Genset, IDDOWN, IDUP, DTDOWN, DTUP, TIMEDIFFERENCE, ISEXEMPT, DETAILS,
			'YesNo' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END,
			'REASON' = CASE WHEN Reason IS NOT NULL THEN Reason ELSE ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM dbo.GeneratorContent, HL_EVENTS AS EV 
				 WHERE EV.ID = IdEvent 
				 AND TimeStamp BETWEEN DATEADD(hour,-12,EXEMPTS.DTDOWN) AND EXEMPTS.DTDOWN
				 AND IdEvent NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 AND IdEvent NOT IN (72,73) --Hardcoded, need a better solution here.
				 ORDER BY TimeStamp DESC),
			'UNKNOWN') END
		FROM EXEMPTS
		WHERE DtDown <= @MyEnd
		AND DtDown >= @MyBegin -- Was DTUP
		AND ID_Location = @IdLocation
		AND (IsExcluded IS NULL OR IsExcluded = 0)
		ORDER BY DtDown ASC
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_GetWithReasonById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 14/01/2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_GetWithReasonById]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @MyLocation int
	declare @MyBegin datetime
	declare @MyEnd datetime
	
	set @MyLocation = @location
	set @MyBegin = @begin
	set @MyEnd = @end
	
	
		SELECT ID, ID_LOCATION, IDDOWN, IDUP, DTDOWN, DTUP, TIMEDIFFERENCE, ISEXEMPT, ISEXCLUDED, DETAILS,
			'YesNo' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END,
			'REASON' = CASE WHEN Reason IS NOT NULL THEN Reason ELSE ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM dbo.GeneratorContent, HL_EVENTS AS EV 
				 WHERE EV.ID = IdEvent 
				 AND ID_LOCATION = @MyLocation
				 AND TimeStamp BETWEEN DATEADD(hour,-12,EXEMPTS.DTDOWN) AND EXEMPTS.DTDOWN
				 AND IdEvent NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 AND IdEvent NOT IN (72,73) --Hardcoded, need a better solution here.
				 ORDER BY TimeStamp DESC),
			'UNKNOWN') END
		FROM EXEMPTS
		WHERE ID_LOCATION = @MyLocation
		AND DTDOWN <= @MyEnd
		AND DTUP >= @MyBegin
		ORDER BY DtDown ASC
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_Insert]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		neil-rutherford
-- Create date: 01/08/2012
-- Description:	Insert a manual downtime
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_Insert]
	@idlocation int,
	@dtdown datetime,
	@dtup datetime,
	@reason nvarchar(18)
	
AS
BEGIN
	SET NOCOUNT ON;
	
	insert into exempts(ID_Location, iddown, idup, dtdown, dtup, timedifference, Details, Custom)
	VALUES (@idlocation, 0, 0, @dtdown, @dtup, DATEDIFF(MINUTE, @dtdown, @dtup), @reason, 1)
	

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_Reset]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 21/02/2012
-- Description:	Resets Exempt Details to the Original
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_Reset] 
	@ID INT
AS
BEGIN
	SET NOCOUNT ON;
	
		DECLARE @ORIG DATETIME
		
		SELECT @ORIG=OrigDtUP --Assign Var
		FROM dbo.Exempts
		WHERE ID=@ID
	
		IF @ORIG IS NOT NULL
			UPDATE dbo.Exempts
			SET DtUp=OrigDtUp, TimeDifference=DATEDIFF(minute, DtDown, OrigDtUP)
			WHERE ID=@ID

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_Update]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 14/02/2012
-- Description:	Update DTDOWN
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_Update]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@NEWDT DATETIME,
	@DIFF INT,
	@REASON NVARCHAR(18),
	@DTUPDOWN BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @DTUPDOWN=1
		UPDATE dbo.Exempts
		SET DtDown=@NEWDT, TimeDifference=@DIFF, Reason=@REASON
		WHERE ID=@ID
	ELSE
		UPDATE dbo.Exempts --Store Original Value
		SET OrigDtUp=COALESCE(OrigDtUp, DtUp)
		WHERE ID=@ID
		
		UPDATE dbo.Exempts --Now Update
		SET DtUp=@NEWDT, TimeDifference=@DIFF
		WHERE ID=@ID	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_UpdateDetailsById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 14/02/2012
-- Description:	Writes a Description for Exempt of specific ID
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_UpdateDetailsById]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@DETAILS NVARCHAR(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE dbo.Exempts
	SET Details=@DETAILS
	WHERE ID=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_UpdateIsExcludedById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_UpdateIsExcludedById]
	@Id INT,
	@IsExcluded BIT
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE Exempts
    SET IsExcluded=@IsExcluded
    WHERE ID=@Id
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Exempts_UpdateIsExemptById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Exempts_UpdateIsExemptById]
	@ID INT,
	@ISEXEMPT BIT
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE Exempts
    SET IsExempt=@ISEXEMPT
    WHERE ID=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_Add]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil A. Rutherford
-- Create date: 18-05-2015
-- Description:	Adds a new datalogger unit to the Blackbox table
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_Add] 
	-- Add the parameters for the stored procedure here
	@GensetSN nvarchar(8),
	@GensetName nvarchar(25),
	@SiteName nvarchar(25),
	@BB_SerialNo nvarchar(9)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT HL_Locations (GENSET_SN, GENSETNAME, SITENAME, BLACKBOX_SN, LASTUPDATE)
	SELECT @GensetSN, @GensetName, @SiteName, @BB_SerialNo, GETDATE()
	WHERE NOT EXISTS (SELECT 1 FROM HL_Locations
						WHERE GENSET_SN = @GensetSN
	);

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetActualHoursRunById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 5/4/2012
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetActualHoursRunById]
	-- Add the parameters for the stored procedure here
	@ID_LOCATION	INT,
	@STARTDATE		DATETIME,
	@ENDDATE		DATETIME

AS
BEGIN
	SET NOCOUNT ON;
	
	/*
	SELECT MAX(CONVERT(FLOAT,ISNULL(RUNHO,RUNHRS))) - (SELECT MIN(CONVERT(FLOAT,ISNULL(RUNHO,RUNHRS))) 
	FROM REPORTINGSYSTEM.DBO.HL_LOGS 
	WHERE ID_LOCATION = @ID_LOCATION AND CONVERT(VARCHAR,TIME_STAMP,102) >= @STARTDATE ) AS ACTUALHOURSRUN 
	FROM REPORTINGSYSTEM.DBO.HL_LOGS 
	WHERE ID_LOCATION = @ID_LOCATION AND CONVERT(VARCHAR,TIME_STAMP,102) <= @ENDDATE */
	
	--Origional
	SELECT MAX(CONVERT(FLOAT,Runhrs)) - MIN(CONVERT(FLOAT,Runhrs)) AS Hrs 
	FROM dbo.HL_LOGS 
	WHERE CONVERT(VARCHAR,Time_Stamp,102) BETWEEN @STARTDATE AND @ENDDATE AND ID_LOCATION = @ID_LOCATION
	


  /*SELECT (SELECT TOP 1 CONVERT(FLOAT,ISNULL(Runhrs,Runho)) FROM [ReportingSystem].[dbo].[HL_Logs] WHERE ID_Location=@ID_LOCATION and Time_Stamp BETWEEN @STARTDATE AND @ENDDATE and Runhrs IS NOT NULL
  order by Time_Stamp desc) - (SELECT TOP 1 CONVERT(FLOAT,ISNULL(Runhrs,Runho)) FROM [ReportingSystem].[dbo].[HL_Logs]
  WHERE ID_Location=@ID_LOCATION and Time_Stamp BETWEEN @STARTDATE AND @ENDDATE and Runhrs IS NOT NULL
  order by Time_Stamp ASC) AS ACTUALHOURSRUN*/
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetActualkWhProducedById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ed_Genset_GetActualkWhProducedById] 
	@ID_LOCATION AS INT,
	@STARTDATE AS DATE,
	@ENDDATE AS DATE
AS
BEGIN
	SET NOCOUNT ON;

   	SELECT(MAX(CONVERT(FLOAT, LOGS.KWHOUR)) - MIN(CONVERT(FLOAT, LOGS.KWHOUR))) AS kWh FROM HL_LOCATIONS AS LOC INNER JOIN HL_LOGS AS LOGS ON LOC.ID = LOGS.ID_LOCATION WHERE CONVERT(VARCHAR, TIME_STAMP, 102) BETWEEN @STARTDATE AND @ENDDATE AND LOC.ID = @ID_LOCATION
END

GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnDifferenceByDays]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnDifferenceByDays]
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT MAX(CONVERT(FLOAT,['+ @Column_Name +'])) - MIN(CONVERT(FLOAT,['+ @Column_Name +'])) AS TotalEnergy, CONVERT(VARCHAR,Time_stamp,103) AS TIME_STAMP
				FROM HL_Logs 
				WHERE ['+ @Column_Name +'] IS NOT NULL AND Time_stamp BETWEEN '''+ CONVERT(varchar, @Start_Date, 110) +''' AND '''+ CONVERT(varchar, @End_Date, 110) +''' AND ID_LOCATION = '+ CONVERT(varchar, @ID_Location) +'
				GROUP BY CONVERT(VARCHAR,Time_stamp,111), CONVERT(VARCHAR,Time_stamp,103) 
				ORDER BY CONVERT(VARCHAR,Time_stamp,111);'
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnDifferenceByDays_GeneratorContent]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnDifferenceByDays_GeneratorContent]
	-- Add the parameters for the stored procedure here
	@IdLocation int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT MAX(CONVERT(FLOAT,['+ @Column_Name +'])) - MIN(CONVERT(FLOAT,['+ @Column_Name +'])) AS TotalEnergy, CONVERT(VARCHAR,TimeStamp,103) AS TimeStamp
				FROM GeneratorContent 
				WHERE ['+ @Column_Name +'] IS NOT NULL AND TimeStamp BETWEEN '''+ CONVERT(varchar, @Start_Date, 110) +''' AND '''+ CONVERT(varchar, @End_Date, 110) +''' AND IdLocation = '+ CONVERT(varchar, @IdLocation) +'
				GROUP BY CONVERT(VARCHAR,TimeStamp,111), CONVERT(VARCHAR,TimeStamp,103) 
				ORDER BY CONVERT(VARCHAR,TimeStamp,111);'
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnDifferenceByHoursOfDays]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get differnce in eah hour over 1 day from any hl_log column 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnDifferenceByHoursOfDays]
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT MAX(CONVERT(FLOAT,['+ @Column_Name +'])) - MIN(CONVERT(FLOAT,['+ @Column_Name +'])) AS TotalEnergy, DATEPART(hh,Time_stamp) AS HR, DAY(Time_stamp) AS DY, MONTH(Time_stamp) AS MTH, YEAR(Time_stamp) AS YR
				FROM HL_Logs 
				WHERE ['+ @Column_Name +'] IS NOT NULL AND Time_stamp BETWEEN '''+ CONVERT(varchar, @Start_Date, 110) +''' AND '''+ CONVERT(varchar, @End_Date, 110) +''' AND ID_LOCATION = '+ CONVERT(varchar, @ID_Location) +'
				GROUP BY DAY(Time_stamp), DATEPART(hh,Time_stamp), MONTH(Time_stamp), YEAR(Time_stamp)
				ORDER BY YR, MTH, DY, HR';
				
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnDifferenceByHoursOfDays_GeneratorContent]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get differnce in eah hour over 1 day from any hl_log column 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnDifferenceByHoursOfDays_GeneratorContent]
	-- Add the parameters for the stored procedure here
	@IdLocation int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT MAX(CONVERT(FLOAT,['+ @Column_Name +'])) - MIN(CONVERT(FLOAT,['+ @Column_Name +'])) AS TotalEnergy, DATEPART(hh,TimeStamp) AS HR, DAY(TimeStamp) AS DY, MONTH(TimeStamp) AS MTH, YEAR(TimeStamp) AS YR
				FROM GeneratorContent 
				WHERE ['+ @Column_Name +'] IS NOT NULL AND TimeStamp BETWEEN '''+ CONVERT(varchar, @Start_Date, 110) +''' AND '''+ CONVERT(varchar, @End_Date, 110) +''' AND IdLocation = '+ CONVERT(varchar, @IdLocation) +'
				GROUP BY DAY(TimeStamp), DATEPART(hh,TimeStamp), MONTH(TimeStamp), YEAR(TimeStamp)
				ORDER BY YR, MTH, DY, HR';
				
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnDifferenceByMonthsOfYear]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnDifferenceByMonthsOfYear]
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN

	--First and last days of the month(s)
	DECLARE @StartOfMonth DATETIME
	DECLARE @EndOfMonth DATETIME

	SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, @Start_Date), 0);
	SET @EndOfMonth = DATEADD(month, DATEDIFF(MONTH, 0, @End_Date) + 1, 0) - 1
	
	declare @sql nvarchar(4000);
	set @sql='SELECT MAX(CONVERT(FLOAT,['+ @Column_Name +'])) - MIN(CONVERT(FLOAT,['+ @Column_Name +'])) AS TotalEnergy, MONTH(Time_stamp) AS MTH, YEAR(Time_stamp) AS YR
			FROM HL_Logs 
			WHERE ['+ @Column_Name +'] IS NOT NULL AND Time_stamp BETWEEN '''+ CONVERT(varchar, @StartOfMonth, 110) +''' AND '''+ CONVERT(varchar, @EndOfMonth, 110) +''' AND ID_LOCATION = '+ CONVERT(varchar, @ID_Location) +'
			GROUP BY MONTH(Time_stamp), YEAR(Time_stamp)
			ORDER BY YR, MTH;'
    exec sp_executesql @sql

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnDifferenceByMonthsOfYear_GeneratorContent]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnDifferenceByMonthsOfYear_GeneratorContent]
	-- Add the parameters for the stored procedure here
	@IdLocation int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN

	--First and last days of the month(s)
	DECLARE @StartOfMonth DATETIME
	DECLARE @EndOfMonth DATETIME

	SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, @Start_Date), 0);
	SET @EndOfMonth = DATEADD(month, DATEDIFF(MONTH, 0, @End_Date) + 1, 0) - 1
	
	declare @sql nvarchar(4000);
	set @sql='SELECT MAX(CONVERT(FLOAT,['+ @Column_Name +'])) - MIN(CONVERT(FLOAT,['+ @Column_Name +'])) AS TotalEnergy, MONTH(TimeStamp) AS MTH, YEAR(TimeStamp) AS YR
			FROM GeneratorContent 
			WHERE ['+ @Column_Name +'] IS NOT NULL AND TimeStamp BETWEEN '''+ CONVERT(varchar, @StartOfMonth, 110) +''' AND '''+ CONVERT(varchar, @EndOfMonth, 110) +''' AND IdLocation = '+ CONVERT(varchar, @IdLocation) +'
			GROUP BY MONTH(TimeStamp), YEAR(TimeStamp)
			ORDER BY YR, MTH;'
    exec sp_executesql @sql

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnOverTimePlot]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnOverTimePlot]
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT ['+ @Column_Name +'] AS Data, Time_stamp
				FROM HL_Logs 
				WHERE ['+ @Column_Name +'] IS NOT NULL AND Time_stamp BETWEEN '''+ CONVERT(varchar, @Start_Date, 110) +''' AND '''+ CONVERT(varchar, @End_Date, 110) +''' AND ID_LOCATION = '+ CONVERT(varchar, @ID_Location) +'
				ORDER BY Time_stamp;'
	 print @sql
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetColumnOverTimePlot_GeneratorContent]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetColumnOverTimePlot_GeneratorContent]
	-- Add the parameters for the stored procedure here
	@IdLocation int,
	@Column_Name nvarchar(10),
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT CAST(['+ @Column_Name +'] AS float) AS Data, TimeStamp
				FROM GeneratorContent 
				WHERE ['+ @Column_Name +'] IS NOT NULL AND TimeStamp BETWEEN '''+ CONVERT(varchar, @Start_Date, 110) +''' AND '''+ CONVERT(varchar, @End_Date, 110) +''' AND IdLocation = '+ CONVERT(varchar, @IdLocation) +'
				ORDER BY TimeStamp;'
	 print @sql
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetEvents]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Get the event reasons for an exempt period
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetEvents]
	-- Add the parameters for the stored procedure here
	@IDLOC		INT,
	@DTDOWN		DATETIME,
	@DTUP		DATETIME

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT dbo.GeneratorContent.Id, dbo.GeneratorContent.TimeStamp, ISNULL(EV.LABEL,EV.REASON) AS REASON, ISNULL(dbo.GeneratorContent.EVENT, 'N/A') AS EVENT FROM dbo.GeneratorContent, HL_EVENTS AS EV 
	WHERE dbo.GeneratorContent.TimeStamp BETWEEN @DTDOWN AND @DTUP AND EV.ID = IdEvent AND IdLocation = @IDLOC AND IdEvent NOT IN (SELECT dbo.HL_Events.ID AS ID_EVENT 
																														  FROM dbo.HL_Events INNER JOIN dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID 
																														  WHERE (dbo.CategorizedEvents.ID_Category = 1)) AND IdEvent <> 842						
	ORDER BY TimeStamp
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetHistoryById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 14/01/2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetHistoryById]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
	SET NOCOUNT ON;

SELECT [ID]
      ,[Time_stamp]
      ,(Select GENSETNAME from HL_Locations where ID = ID_Location ) AS Genset
      ,(Select Reason from hl_events where ID = ID_Event ) AS Reason
     ,[EVENT]
      ,[RPM]
      ,[Pwr]
      ,[Gfrq]
      ,[Vg1]
      ,[Vg2]
      ,[Vg3]
      ,[Vg12]
      ,[Vg23]
      ,[Vg31]
      ,[Ig1]
      ,[Ig2]
      ,[Ig3]
      ,[BIN]
      ,[BOUT]
      ,[Mode]
      ,[LTHWrT]
      ,[LTHWfT]
      ,[OilB4F]
      ,[CCpres]
      ,[OilLev]
      ,[ActPfi]
      ,[ActDem]
      ,[CH4]
      ,[OilT]
      ,[AirInT]
      ,[RecAT]
      ,[JWTout]
      ,[JWTin]
      ,[JWGKin]
      ,[CylA1]
      ,[CylA2]
      ,[CylA3]
      ,[CylA4]
      ,[CylA5]
      ,[CylA6]
      ,[CylA7]
      ,[CylA8]
      ,[CylB1]
      ,[CylB2]
      ,[CylB3]
      ,[CylB4]
      ,[CylB5]
      ,[CylB6]
      ,[CylB7]
      ,[CylB8]
      ,[kWhour]
      ,[Runhrs]
      ,[Numstr]
      ,[NumUns]
      ,[Q]
      ,[LChr]
      ,[Mfrq]
      ,[Vm1]
      ,[Vm2]
      ,[Vm3]
      ,[Vm12]
      ,[Vm23]
      ,[Vm31]
      ,[Pmns]
      ,[Qmns]
      ,[MPF]
      ,[MVS]
      ,[SRO]
      ,[VRO]
      ,[UBat]
      ,[CPUT]
      ,[ActPwr]
      ,[Amb]
      ,[GasP]
      ,[GasMet]
      ,[PF]
      ,[H2S]
      ,[ThrPos]
      ,[kVarho]
      ,[BI1]
      ,[BI2]
      ,[BI3]
      ,[BI4]
      ,[BI5]
      ,[BI6]
      ,[BI7]
      ,[BI8]
      ,[BI9]
      ,[BI10]
      ,[BI11]
      ,[BO1]
      ,[BO2]
      ,[BO3]
      ,[CylA9]
      ,[CylA10]
      ,[CylB9]
      ,[CylB10]
      ,[BI12]
      ,[TEMv]
      ,[MLChr]
      ,[GroKwh]
      ,[BO4]
      ,[DT_Processed]
      ,[IcOut]
      ,[D+]
      ,[U]
      ,[V]
      ,[W]
      ,[GFlwRte]
      ,[GFlwM3]
      ,[Spare]
      ,[HWFlo]
      ,[HWRtn]
      ,[HtMet]
      ,[ChMet]
      ,[BO5]
      ,[UpdateTime_Processed]
      ,[StartupTime_Processed]
      ,[TotRunPact]
      ,[TotRunPnomAll]
      ,[SumMWh]
      ,[PwrDem]
      ,[ActPwrReq]
      ,[ImpLoad]
      ,[AuxKwh]
		FROM HL_Logs
		where ID_Location = @location
		and Time_Stamp between @begin and @end
		order by Time_Stamp asc
	
	


		
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetHistoryById_GeneratorContent]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 14/01/2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetHistoryById_GeneratorContent]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
	SET NOCOUNT ON;

SELECT [ID]
      ,[TimeStamp]
      ,(Select GENSETNAME from HL_Locations where ID = IdLocation ) AS Genset
      ,(Select Reason from hl_events where ID = IdEvent ) AS Reason
      ,[EVENT]
      ,[RPM]
      ,[Pwr]
      ,[Gfrq]
      ,[Vg1]
      ,[Vg2]
      ,[Vg3]
      ,[Vg12]
      ,[Vg23]
      ,[Vg31]
      ,[Ig1]
      ,[Ig2]
      ,[Ig3]
      ,[BIN]
      ,[BOUT]
      ,[Mode]
      ,[LTHWrT]
      ,[LTHWfT]
      ,[OilB4F]
      ,[CCpres]
      ,[OilLev]
      ,[ActPfi]
      ,[ActDem]
      ,[CH4]
      ,[OilT]
      ,[AirInT]
      ,[RecAT]
      ,[JWTout]
      ,[JWTin]
      ,[JWGKin]
      ,[CylA1]
      ,[CylA2]
      ,[CylA3]
      ,[CylA4]
      ,[CylA5]
      ,[CylA6]
      ,[CylA7]
      ,[CylA8]
      ,[CylB1]
      ,[CylB2]
      ,[CylB3]
      ,[CylB4]
      ,[CylB5]
      ,[CylB6]
      ,[CylB7]
      ,[CylB8]
      ,[kWhour]
      ,[Runhrs]
      ,[Numstr]
      ,[NumUns]
      ,[Q]
      ,[LChr]
      ,[Mfrq]
      ,[Vm1]
      ,[Vm2]
      ,[Vm3]
      ,[Vm12]
      ,[Vm23]
      ,[Vm31]
      ,[Pmns]
      ,[Qmns]
      ,[MPF]
      ,[MVS]
      ,[SRO]
      ,[VRO]
      ,[UBat]
      ,[CPUT]
      ,[ActPwr]
      ,[Amb]
      ,[GasP]
      ,[GasMet]
      ,[PF]
      ,[H2S]
      ,[ThrPos]
      ,[kVarho]
      ,[BI1]
      ,[BI2]
      ,[BI3]
      ,[BI4]
      ,[BI5]
      ,[BI6]
      ,[BI7]
      ,[BI8]
      ,[BI9]
      ,[BI10]
      ,[BI11]
      ,[BO1]
      ,[BO2]
      ,[BO3]
      ,[CylA9]
      ,[CylA10]
      ,[CylB9]
      ,[CylB10]
      ,[BI12]
      ,[TEMv]
      ,[MLChr]
      ,[GroKwh]
      ,[BO4]
      ,_ShutdownProcessed
      ,[IcOut]
      ,[U]
      ,[V]
      ,[W]
      ,[GFlwRte]
      ,[GFlwM3]
      ,[HWFlo]
      ,[HWRtn]
      ,[BO5]
      ,_UpdateProcessed
      ,_StartupProcessed
      ,[TotRunPact]
      ,[TotRunPnomAll]
      ,[SumMWh]
      ,[PwrDem]
      ,[ActPwrReq]
      ,[ImpLoad]
      ,[AuxKwh]

FROM GeneratorContent
WHERE IdLocation = @location
AND [TimeStamp] BETWEEN @begin and @end
ORDER BY [TimeStamp] ASC
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetkWhPerDayByIdGraph]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetkWhPerDayByIdGraph]
	-- Add the parameters for the stored procedure here
	@BEGIN DATETIME,
	@END DATETIME,
	@ID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT MAX(CONVERT(FLOAT,KWHOUR)) - MIN(CONVERT(FLOAT,KWHOUR)) AS KWHOUR, CONVERT(VARCHAR,TIME_STAMP,103) AS TIME_STAMP 
	FROM HL_LOGS 
	WHERE KWHOUR IS NOT NULL AND TIME_STAMP BETWEEN @BEGIN AND @END AND ID_LOCATION = @ID 
	GROUP BY CONVERT(VARCHAR,TIME_STAMP,111), CONVERT(VARCHAR,TIME_STAMP,103) 
	ORDER BY CONVERT(VARCHAR,TIME_STAMP,111)
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetPrimaryGensetIdByGensetId]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetPrimaryGensetIdByGensetId]
	-- Add the parameters for the stored procedure here
	@ID_Location int
AS
BEGIN
	
	 SELECT TOP 1 ID FROM HL_Locations WHERE BLACKBOX_SN = 
	 (SELECT BLACKBOX_SN FROM HL_Locations WHERE ID=@ID_Location)
	 ORDER BY GENSETNAME ASC
	 
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetRunHoursPerDayByIdGraph]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetRunHoursPerDayByIdGraph]
	-- Add the parameters for the stored procedure here
	@BEGIN DATETIME,
	@END DATETIME,
	@ID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT CASE when MAX(CONVERT(FLOAT, Runhrs)) - 
                 MIN(CONVERT(FLOAT,Runhrs)) > 24 
            then 24 
            else MAX(CONVERT(FLOAT,Runhrs)) - 
                 MIN(CONVERT(FLOAT,Runhrs))  
			END AS RUNHO,
        CONVERT(VARCHAR,TIME_STAMP,103) AS TIME_STAMP 
	FROM HL_LOGS 
	WHERE TIME_STAMP BETWEEN @BEGIN AND @END AND ID_LOCATION = @ID 
	GROUP BY CONVERT(VARCHAR,TIME_STAMP,103), CONVERT(VARCHAR,TIME_STAMP,111) 
	ORDER BY CONVERT(VARCHAR,TIME_STAMP,111)

	
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetRunHoursPerDayWithMaxMin]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetRunHoursPerDayWithMaxMin]
	-- Add the parameters for the stored procedure here
	@BEGIN DATETIME,
	@END DATETIME,
	@ID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT CASE WHEN MAX(CONVERT(FLOAT, Runhrs)) - MIN(CONVERT(FLOAT,Runhrs)) > 24 
							THEN 24 
			      ELSE MAX(CONVERT(FLOAT,Runhrs)) - MIN(CONVERT(FLOAT,Runhrs))  
			      END AS DailyRunHours,
				   MAX(CONVERT(FLOAT,Runhrs)) AS MaxHours,  MIN(CONVERT(FLOAT,Runhrs)) AS MinHours ,
				  CONVERT(VARCHAR,TIME_STAMP,103) AS [TimeStamp]
	FROM HL_LOGS 
	WHERE TIME_STAMP BETWEEN @BEGIN AND @END AND ID_LOCATION = @ID 
	GROUP BY CONVERT(VARCHAR,TIME_STAMP,103), CONVERT(VARCHAR,TIME_STAMP,111) 
	ORDER BY CONVERT(VARCHAR,TIME_STAMP,111)

	
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetSummaryByUserGensetIds]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetSummaryByUserGensetIds]
	@STARTDT AS DATE,
	@ENDDT AS DATE,
	@IDS integer_list_tbltype
READONLY AS
BEGIN
	SET NOCOUNT ON;

SELECT LOGS.ID_LOCATION, LOC.GENSETNAME,/* 
		ContractInformation.ContractOutput,ContractInformation.DutyCycle,*/
		(SELECT 'RUNHOURS' = CASE WHEN ISNUMERIC(MAX(CONVERT(FLOAT,Logs.Runhrs)) - MIN(CONVERT(FLOAT,Logs.Runhrs))) = 1
		THEN MAX(CONVERT(FLOAT,Logs.Runhrs)) - MIN(CONVERT(FLOAT,Logs.Runhrs))
		ELSE 0 END) AS HOURSRUN,
		(SELECT 'KWPRODUCED' = CASE WHEN ISNUMERIC(MAX(CONVERT(FLOAT,LOGS.KWHOUR)) - MIN(CONVERT(FLOAT,LOGS.KWHOUR))) = 1
		THEN (MAX(CONVERT(FLOAT,LOGS.KWHOUR)) - MIN(CONVERT(FLOAT,LOGS.KWHOUR)))
		ELSE 0 END) AS KWPRODUCED,
		(
		SELECT  COUNT(IDDOWN)
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.ID_LOCATION
		GROUP BY ID_LOCATION
		)  AS NOSTOPS,
		(
		SELECT  MIN(DTUP)
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.ID_LOCATION
		GROUP BY ID_LOCATION
		)  AS FIRSTSTART,
		(
		SELECT  MAX(DTDOWN) 
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.ID_LOCATION
		GROUP BY ID_LOCATION
		)  AS LASTSTOP
FROM dbo.HL_Logs AS LOGS 
	INNER JOIN dbo.HL_Locations AS LOC 
	ON LOGS.ID_Location = LOC.ID 
	--LEFT OUTER JOIN dbo.ContractInformation 
	--ON LOC.ID_ContractInformation = dbo.ContractInformation.ID

WHERE TIME_STAMP BETWEEN CONVERT(VARCHAR,@STARTDT,111) AND DATEADD(day, 1, CONVERT(VARCHAR,@ENDDT,111))
AND LOC.ID = LOGS.ID_LOCATION
AND LOC.ID IN (SELECT N FROM @IDS)
-- Catch Bad Values
--AND ISNUMERIC(MAX(CONVERT(FLOAT,Logs.Runhrs)) ) = 1
-- End Catch Bad Values
GROUP BY LOGS.ID_LOCATION,LOC.GENSETNAME--,ContractInformation.ContractOutput,ContractInformation.DutyCycle
ORDER BY LOC.GENSETNAME
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetSummaryByUserGensetIds_GeneratorContent]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetSummaryByUserGensetIds_GeneratorContent]
	@STARTDT AS DATE,
	@ENDDT AS DATE,
	@IDS integer_list_tbltype
READONLY AS
BEGIN
	SET NOCOUNT ON;

SELECT LOGS.IdLocation, LOC.GENSETNAME,/* 
		ContractInformation.ContractOutput,ContractInformation.DutyCycle,*/
		(SELECT 'RUNHOURS' = CASE WHEN ISNUMERIC(MAX(CONVERT(FLOAT,Logs.Runhrs)) - MIN(CONVERT(FLOAT,Logs.Runhrs))) = 1
		THEN MAX(CONVERT(FLOAT,Logs.Runhrs)) - MIN(CONVERT(FLOAT,Logs.Runhrs))
		ELSE 0 END) AS HOURSRUN,
		(SELECT 'KWPRODUCED' = CASE WHEN ISNUMERIC(MAX(CONVERT(FLOAT,LOGS.kWhour)) - MIN(CONVERT(FLOAT,LOGS.kWhour))) = 1
		THEN (MAX(CONVERT(FLOAT,LOGS.KWHOUR)) - MIN(CONVERT(FLOAT,LOGS.kWhour)))
		ELSE 0 END) AS KWPRODUCED,
		(
		SELECT  COUNT(IDDOWN)
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.IdLocation
		GROUP BY ID_LOCATION
		)  AS NOSTOPS,
		(
		SELECT  MIN(DTUP)
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.IdLocation
		GROUP BY ID_LOCATION
		)  AS FIRSTSTART,
		(
		SELECT  MAX(DTDOWN) 
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.IdLocation
		GROUP BY ID_LOCATION
		)  AS LASTSTOP
FROM dbo.GeneratorContent AS LOGS 
	INNER JOIN dbo.HL_Locations AS LOC 
	ON LOGS.IdLocation = LOC.ID 
	--LEFT OUTER JOIN dbo.ContractInformation 
	--ON LOC.ID_ContractInformation = dbo.ContractInformation.ID

WHERE TimeStamp BETWEEN CONVERT(VARCHAR,@STARTDT,111) AND DATEADD(day, 1, CONVERT(VARCHAR,@ENDDT,111))
AND LOC.ID = LOGS.IdLocation
AND LOC.ID IN (SELECT N FROM @IDS)
-- Catch Bad Values
--AND ISNUMERIC(MAX(CONVERT(FLOAT,Logs.Runhrs)) ) = 1
-- End Catch Bad Values
GROUP BY LOGS.IdLocation,LOC.GENSETNAME--,ContractInformation.ContractOutput,ContractInformation.DutyCycle
ORDER BY LOC.GENSETNAME
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetTotalHoursRunById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetTotalHoursRunById]
	-- Add the parameters for the stored procedure here
	@ID_LOCATION	INT

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP 1 RUNHRS AS Hrs 
	FROM dbo.HL_LOGS 
	WHERE ID_LOCATION = @ID_LOCATION
	ORDER BY Time_Stamp DESC
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Genset_GetTotalkWhProducedById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Genset_GetTotalkWhProducedById]
	-- Add the parameters for the stored procedure here
	@ID_LOCATION	INT

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT TOP 1 kWhour AS kWh 
	FROM dbo.HL_LOGS 
	WHERE ID_LOCATION = @ID_LOCATION
	ORDER BY Time_Stamp DESC
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_GensetNote_GetByGensetId]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: <Create Date,,>
-- Description:	Get user comments related to a genset
-- =============================================
CREATE PROCEDURE [dbo].[ed_GensetNote_GetByGensetId] 
	@location int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
	   [Id]
	  ,[UserId]
      ,[CommentDate]
      ,[Comment]
      ,[Flag]
			
	FROM GensetComments
	WHERE ID_Location = @location
	
	ORDER BY CommentDate
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_GensetNote_GetById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: <Create Date,,>
-- Description:	Get user comments related to a genset
-- =============================================
CREATE PROCEDURE [dbo].[ed_GensetNote_GetById] 
	@location int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
	   [ID_Location]
	  ,[UserId]
      ,[CommentDate]
      ,[Comment]
      ,[Flag]
			
	FROM GensetComments
	WHERE ID_Location = @location
	
	ORDER BY CommentDate
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_GensetNote_Insert]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: <Create Date,,>
-- Description:	Inserts a new note
-- =============================================
CREATE PROCEDURE [dbo].[ed_GensetNote_Insert] 
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@UserId nvarchar(128),
	@comment nvarchar(512),
	@flag bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into GensetComments(ID_Location, UserId, CommentDate, Comment, Flag)
	values (@ID_Location, @UserId, GETDATE(), @comment, @flag)
	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_History_GetColumnNames]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: April 2015
-- Description:	Returns a list of column names in a table
-- =============================================
CREATE PROCEDURE [dbo].[ed_History_GetColumnNames]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = N'HL_Logs'
	AND COLUMN_NAME NOT LIKE '%ID%'
	AND COLUMN_NAME NOT LIKE '%Time_Stamp%'
	AND COLUMN_NAME NOT LIKE '%EVENT%'
	AND COLUMN_NAME NOT LIKE '%DT_Processed%'
	AND COLUMN_NAME NOT LIKE '%ItemDATE%'
	AND COLUMN_NAME NOT LIKE '%ItemTIME%'
	AND COLUMN_NAME NOT LIKE '%SITENAME%'
	AND COLUMN_NAME NOT LIKE '%GENSETNAME%'
	AND COLUMN_NAME NOT LIKE '%GENSET_SN%'
	AND COLUMN_NAME NOT LIKE '%REASON%'
	AND COLUMN_NAME NOT LIKE '%UpdateTime_Processed%'
	ORDER BY COLUMN_NAME
END
GO
/****** Object:  StoredProcedure [dbo].[ed_IdentityRole_AddPage]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_IdentityRole_AddPage]
	@FilePageName NVARCHAR(MAX),
	@RoleId NVARCHAR(128)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO IdentityRoleAccess(RoleId, FilePageName)
	VALUES (@RoleId, @FilePageName)	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_IdentityRole_DeletePage]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_IdentityRole_DeletePage]
	@FilePageName NVARCHAR(MAX),
	@RoleId NVARCHAR(128)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM IdentityRoleAccess
	WHERE RoleId = @RoleId
	AND FilePageName = @FilePageName
END
GO
/****** Object:  StoredProcedure [dbo].[ed_IdentityRole_GetPagesByIds]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_IdentityRole_GetPagesByIds]
	@RoleIds string_list_tbltype
READONLY AS
BEGIN
	SET NOCOUNT ON;

    SELECT FilePageName 
	FROM IdentityRoleAccess
	WHERE RoleId IN (SELECT S FROM @RoleIds)
	GROUP BY FilePageName
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import]
AS
BEGIN

    SET NOCOUNT ON

    INSERT INTO DataBaseLog VALUES (GETDATE(), 'ReportingSystem(Azure)', 'EOS update started.')

	--Delete corrupt data
	DELETE FROM [Staging].[GeneratorData] WHERE ISNUMERIC([RPM]) = 0 and RPM is not null
	SET DATEFORMAT dmy;
    DELETE FROM [Staging].[GeneratorData] WHERE ISDATE(ItemDATE) = 0
	DELETE FROM [Staging].[GeneratorData] WHERE ISDATE(ItemTIME) = 0
	--Delete corrupt data

	--Import CSV data from Mx2i Units
	EXEC Staging.Import_MergeGeneratorDataToGeneratorLog
	EXEC Staging.FixBadNumericsGeneratorLog
	EXEC ed_Import_NormalizeToGeneratorContent
	--Import CSV data from Mx2i Units

	--Process Energy Meters
	--EXEC ed_Import_NormalizeToEnergyMeters
	--EXEC ed_Import_NormalizeToDirisA20Meters
	--EXEC ed_Import_NormalizeToGasMeters
	--EXEC ed_Import_NormalizeToLGE650Meters
	--Process Energy Meters

	--Process Specific Event types
	--EXEC ed_Import_ProcessShutdowns
	EXEC ed_Import_ProcessGeneratorAvailability
	EXEC ed_Import_ProcessCustomEvents
	EXEC ed_Import_ProcessStartups
	--Process Specific Event types

	--Update Timestamps
	EXEC ed_Import_UpdateGensetLastRecordTimes
	--Update Timestamps

	INSERT INTO Update_Control(LastUpdate)
	VALUES(GETDATE())
	
	insert into DataBaseLog values (GETDATE(), 'ReportingSystem(Azure)', 'EOS update completed.')

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_NormalizeToDirisA20Meters]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <13/12/2011>
-- Description:	<Copy data from dbo.RTCU to dbo.HistoryLog ignoring duplicate records and uses fixed columns>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_NormalizeToDirisA20Meters]

AS

--Add the new data to the SQL
BEGIN TRANSACTION

 --Insert goes here
INSERT INTO [dbo].EnergyMeters_Diris_A20([Timestamp],[Serial],[I-1],[I-2],[I-3],[I-N],[V12],[V23],[V31],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr])
	                     
	   SELECT [Timestamp],[Serial],[I-1],[I-2],[I-3],[I-N],[V12],[V23],[V31],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr]
	   FROM
	   (
			SELECT [Timestamp],[Serial],[I-1],[I-2],[I-3],[I-N],[V12],[V23],[V31],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr],
			rn = ROW_NUMBER() OVER 
			(
				PARTITION BY [TimeStamp], [Serial]
				ORDER BY [TimeStamp] DESC
			)
			FROM [Staging].EnergyMetersDirisA20Data

		) AS EnergyMetersDirisA20Data
		WHERE rn = 1
		AND NOT EXISTS 
		(
			SELECT 1 FROM dbo.EnergyMeters_Diris_A20 -- Look for duplicates where all 3 condistions below match
			WHERE [TimeStamp]  = EnergyMetersDirisA20Data.[TimeStamp]
			AND Serial = EnergyMetersDirisA20Data.Serial
		)

COMMIT TRANSACTION
		
TRUNCATE TABLE Staging.EnergyMetersDirisA20Data -- Clear the pre-staging table
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_NormalizeToEnergyMeters]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <13/12/2011>
-- Description:	<Copy data from dbo.RTCU to dbo.HistoryLog ignoring duplicate records and uses fixed columns>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_NormalizeToEnergyMeters]

AS

--Add the new data to the SQL
BEGIN TRANSACTION

 --Insert goes here
INSERT INTO [dbo].EnergyMeters([TimeStamp],[ID_Location],
	   [Power_1],[Energy_1],[FlowVol_1],[TempWarm_1],[TempCold_1],[Power_2],[Energy_2],[FlowVol_2],[TempWarm_2],[TempCold_2],
	   [Power_3],[Energy_3],[FlowVol_3],[TempWarm_3],[TempCold_3],[Power_4],[Energy_4],[FlowVol_4],[TempWarm_4],[TempCold_4],[Power_5],[Energy_5],[FlowVol_5],[TempWarm_5],[TempCold_5],
	   [Power_6],[Energy_6],[FlowVol_6],[TempWarm_6],[TempCold_6],[Power_7],[Energy_7],[FlowVol_7],[TempWarm_7],[TempCold_7],[Power_8],[Energy_8],[FlowVol_8],[TempWarm_8],[TempCold_8],
	   [Power_9],[Energy_9],[FlowVol_9],[TempWarm_9],[TempCold_9],[Power_11],[Energy_11],[FlowVol_11],[TempWarm_11],[TempCold_11],[Power_16],[Energy_16],[FlowVol_16],[TempWarm_16],[TempCold_16])
	                     
SELECT [TimeStamp],ID_Location,
	   [Power_1],[Energy_1],[FlowVol_1],[TempWarm_1],[TempCold_1],[Power_2],[Energy_2],[FlowVol_2],[TempWarm_2],[TempCold_2],
	   [Power_3],[Energy_3],[FlowVol_3],[TempWarm_3],[TempCold_3],[Power_4],[Energy_4],[FlowVol_4],[TempWarm_4],[TempCold_4],[Power_5],[Energy_5],[FlowVol_5],[TempWarm_5],[TempCold_5],
	   [Power_6],[Energy_6],[FlowVol_6],[TempWarm_6],[TempCold_6],[Power_7],[Energy_7],[FlowVol_7],[TempWarm_7],[TempCold_7],[Power_8],[Energy_8],[FlowVol_8],[TempWarm_8],[TempCold_8],
	   [Power_9],[Energy_9],[FlowVol_9],[TempWarm_9],[TempCold_9],[Power_11],[Energy_11],[FlowVol_11],[TempWarm_11],[TempCold_11],[Power_16],[Energy_16],[FlowVol_16],[TempWarm_16],[TempCold_16]
	   
FROM
(
SELECT [TimeStamp],LOC.ID AS ID_Location,
       [Power_1],[Energy_1],[FlowVol_1],[TempWarm_1],[TempCold_1],[Power_2],[Energy_2],[FlowVol_2],[TempWarm_2],[TempCold_2],
	   [Power_3],[Energy_3],[FlowVol_3],[TempWarm_3],[TempCold_3],[Power_4],[Energy_4],[FlowVol_4],[TempWarm_4],[TempCold_4],[Power_5],[Energy_5],[FlowVol_5],[TempWarm_5],[TempCold_5],
	   [Power_6],[Energy_6],[FlowVol_6],[TempWarm_6],[TempCold_6],[Power_7],[Energy_7],[FlowVol_7],[TempWarm_7],[TempCold_7],[Power_8],[Energy_8],[FlowVol_8],[TempWarm_8],[TempCold_8],
	   [Power_9],[Energy_9],[FlowVol_9],[TempWarm_9],[TempCold_9],[Power_11],[Energy_11],[FlowVol_11],[TempWarm_11],[TempCold_11],[Power_16],[Energy_16],[FlowVol_16],[TempWarm_16],[TempCold_16],
		
	rn = ROW_NUMBER() OVER 
	(
		PARTITION BY [TimeStamp], LOC.ID
		ORDER BY [TimeStamp] DESC
	)
	FROM [Staging].EnergyMetersData AS EM, HL_Locations AS LOC
	WHERE EM.Genset_SN = LOC.GENSET_SN) AS EnergyMetersData
	WHERE rn = 1 AND NOT EXISTS 
	(
		SELECT 1 FROM dbo.EnergyMeters -- Look for duplicates where all 3 condistions below match
		WHERE [TimeStamp]  = EnergyMetersData.[TimeStamp]
		AND ID_Location = EnergyMetersData.ID_Location
	)

COMMIT TRANSACTION
		
TRUNCATE TABLE Staging.EnergyMetersData -- Clear the pre-staging table
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_NormalizeToGasMeters]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <13/12/2011>
-- Description:	<Copy data from dbo.RTCU to dbo.HistoryLog ignoring duplicate records and uses fixed columns>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_NormalizeToGasMeters]

AS

--Add the new data to the SQL
BEGIN TRANSACTION

 --Insert goes here
INSERT INTO [dbo].GasMeters([TimeStamp],[ID_Location],
	   [MassFlow_1],[Totaliser_1],[MassFlow_2],[Totaliser_2],[MassFlow_3],[Totaliser_3],[MassFlow_4],[Totaliser_4],[MassFlow_5],[Totaliser_5],[MassFlow_6],[Totaliser_6],[MassFlow_7],[Totaliser_7],[MassFlow_8],[Totaliser_8],[MassFlow_9],
       [Totaliser_9],[MassFlow_10],[Totaliser_10],[MassFlow_11],[Totaliser_11],[MassFlow_12],[Totaliser_12],[MassFlow_13],[Totaliser_13],[MassFlow_14],[Totaliser_14],[MassFlow_15],[Totaliser_15],[MassFlow_16],[Totaliser_16],[MassFlow_17],
       [Totaliser_17],[MassFlow_18],[Totaliser_18],[MassFlow_19],[Totaliser_19],[MassFlow_20],[Totaliser_20],[MassFlow_21],[Totaliser_21],[MassFlow_22],[Totaliser_22],[MassFlow_23],[Totaliser_23],[MassFlow_24],[Totaliser_24],[MassFlow_25],
       [Totaliser_25],[MassFlow_26],[Totaliser_26],[MassFlow_27],[Totaliser_27],[MassFlow_28],[Totaliser_28],[MassFlow_29],[Totaliser_29],[MassFlow_30],[Totaliser_30],[MassFlow_31],[Totaliser_31],[MassFlow_32],[Totaliser_32])
	                     
SELECT [TimeStamp], ID_Location,
	   [MassFlow_1],[Totaliser_1],[MassFlow_2],[Totaliser_2],[MassFlow_3],[Totaliser_3],[MassFlow_4],[Totaliser_4],[MassFlow_5],[Totaliser_5],[MassFlow_6],[Totaliser_6],[MassFlow_7],[Totaliser_7],[MassFlow_8],[Totaliser_8],[MassFlow_9],
       [Totaliser_9],[MassFlow_10],[Totaliser_10],[MassFlow_11],[Totaliser_11],[MassFlow_12],[Totaliser_12],[MassFlow_13],[Totaliser_13],[MassFlow_14],[Totaliser_14],[MassFlow_15],[Totaliser_15],[MassFlow_16],[Totaliser_16],[MassFlow_17],
       [Totaliser_17],[MassFlow_18],[Totaliser_18],[MassFlow_19],[Totaliser_19],[MassFlow_20],[Totaliser_20],[MassFlow_21],[Totaliser_21],[MassFlow_22],[Totaliser_22],[MassFlow_23],[Totaliser_23],[MassFlow_24],[Totaliser_24],[MassFlow_25],
       [Totaliser_25],[MassFlow_26],[Totaliser_26],[MassFlow_27],[Totaliser_27],[MassFlow_28],[Totaliser_28],[MassFlow_29],[Totaliser_29],[MassFlow_30],[Totaliser_30],[MassFlow_31],[Totaliser_31],[MassFlow_32],[Totaliser_32]
	   
FROM
(SELECT [TimeStamp], LOC.ID AS ID_Location,
   	    [MassFlow_1],[Totaliser_1],[MassFlow_2],[Totaliser_2],[MassFlow_3],[Totaliser_3],[MassFlow_4],[Totaliser_4],[MassFlow_5],[Totaliser_5],[MassFlow_6],[Totaliser_6],[MassFlow_7],[Totaliser_7],[MassFlow_8],[Totaliser_8],[MassFlow_9],
        [Totaliser_9],[MassFlow_10],[Totaliser_10],[MassFlow_11],[Totaliser_11],[MassFlow_12],[Totaliser_12],[MassFlow_13],[Totaliser_13],[MassFlow_14],[Totaliser_14],[MassFlow_15],[Totaliser_15],[MassFlow_16],[Totaliser_16],[MassFlow_17],
        [Totaliser_17],[MassFlow_18],[Totaliser_18],[MassFlow_19],[Totaliser_19],[MassFlow_20],[Totaliser_20],[MassFlow_21],[Totaliser_21],[MassFlow_22],[Totaliser_22],[MassFlow_23],[Totaliser_23],[MassFlow_24],[Totaliser_24],[MassFlow_25],
        [Totaliser_25],[MassFlow_26],[Totaliser_26],[MassFlow_27],[Totaliser_27],[MassFlow_28],[Totaliser_28],[MassFlow_29],[Totaliser_29],[MassFlow_30],[Totaliser_30],[MassFlow_31],[Totaliser_31],[MassFlow_32],[Totaliser_32],
	 rn = ROW_NUMBER() OVER 
	 (
		PARTITION BY [TimeStamp], LOC.ID
		ORDER BY [TimeStamp] DESC
	 )
	 FROM [Staging].GasMetersData AS GM, HL_Locations AS LOC
	 WHERE GM.Genset_SN = LOC.GENSET_SN) AS GasMetersData
	 WHERE rn = 1 AND NOT EXISTS 
	 (
		SELECT 1 FROM dbo.GasMeters -- Look for duplicates where all 3 condistions below match
		WHERE [TimeStamp]  = GasMetersData.[TimeStamp]
		AND ID_Location = GasMetersData.ID_Location
)

COMMIT TRANSACTION
		
TRUNCATE TABLE Staging.GasMetersData -- Clear the pre-staging table

GO
/****** Object:  StoredProcedure [dbo].[ed_Import_NormalizeToGeneratorContent]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 17/12/2009
-- Description:	Convert the data from Staging.GeneratorLog table to the SQL Normalized Structure
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_NormalizeToGeneratorContent]
AS
BEGIN

DECLARE @intErrorCode INT

BEGIN TRANSACTION

INSERT INTO HL_Events(REASON)
SELECT DISTINCT REASON
FROM Staging.GeneratorLog
WHERE REASON NOT IN
(SELECT DISTINCT REASON FROM HL_Events)

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

INSERT INTO HL_Locations(GENSET_SN, GENSETNAME, SITENAME)
SELECT DISTINCT GENSET_SN, 'UNNAMED' AS GENSITENAME, 'UNNAMED' AS SITENAME
FROM Staging.GeneratorLog
WHERE GENSET_SN NOT IN
(SELECT DISTINCT GENSET_SN FROM HL_Locations)

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

--Normalize the data for GeneratorContent
INSERT INTO dbo.GeneratorContent([IdLocation], [UtcRecieved], [UtcGenerated], [TimeStamp], [IdEvent], [Event], [Extended]
      ,[RPM], [Pwr], [PF], [Gfrq], [Vg1], [Vg2], [Vg3], [Vg12], [Vg23], [Vg31]
	  ,[Ig1], [Ig2], [Ig3], [Mfrq], [Vm1], [Vm2], [Vm3], [Vm12], [Vm23], [Vm31], [MPF], [SRO], [VRO], [Mode], [kWhour], [Runhrs], [ActPwr], [ActDem], [CylA1], [CylA2]
	  ,[CylA3], [CylA4], [CylA5], [CylA6], [CylA7], [CylA8], [CylA9], [CylA10], [CylB1], [CylB2], [CylB3], [CylB4], [CylB5], [CylB6], [CylB7], [CylB8], [CylB9], [CylB10]
	  ,[BIN], [BOUT], [MVS], [ActPwrReq], [Ubat], [CPUT], [TEMv], [LChr], [OilB4F], [OilLev], [OilT], [CCPres], [AirInT], [RecAT], [ThrPos], [CH4], [JWTin], [JWTout], [Numstr]
	  ,[BI1], [BI2], [BI3], [BI4], [BI5], [BI6], [BI7], [BI8], [BI9], [BI10], [BI11], [BI12], [BO1], [BO2], [BO3], [BO4], [BO5], [Pmns], [Qmns], [ActPfi], [MLChr], [Amb], [kVarho] 
	  ,[GasP], [LTHWfT], [LTHWrT], [GFlwRte], [GFlwM3], [H2S], [NumUns], [PwrDem], [JWGKin], [HWFlo], [HWRtn], [GasMet], [IcOut], [ImpLoad], [Q], [U], [V], [W], [Grokwh], [Auxkwh]   
	  ,[TotRunPact], [TotRunPnomAll], [SumMWh])

SELECT LOC.ID AS ID_Location, GETUTCDATE(), GETUTCDATE(), CONVERT(DATETIME, HL.ItemDATE + HL.ItemTIME) AS Time_Stamp, EV.ID AS ID_Event, [EVENT],(SELECT [D+],[Spare],[HtMet],[ChMet] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
		CAST([RPM] as smallint), CAST([Pwr] as smallint), CAST([PF] as float), CAST([Gfrq] as float),
		CAST([Vg1] as smallint), CAST([Vg2] as smallint), CAST([Vg3] as smallint), CAST([Vg12] as smallint), CAST([Vg23] as smallint), CAST([Vg31] as smallint), CAST([Ig1] as smallint),
		CAST([Ig2] as smallint), CAST([Ig3] as smallint), CAST([Mfrq] as float), CAST([Vm1] as smallint), CAST([Vm2] as smallint), CAST([Vm3] as smallint), CAST([Vm12] as smallint),
		CAST([Vm23] as smallint), CAST([Vm31] as smallint), CAST([MPF] as float), CAST([SRO] as float), CAST([VRO] as float), CAST([Mode] as char(3)), CAST([kWhour] as int),
		CAST([Runhrs] as int), CONVERT(smallint, CAST([ActPwr] as float)), CONVERT(smallint, CAST([ActDem] as float)), CAST([CylA1] as smallint), CAST([CylA2] as smallint), CAST([CylA3] as smallint), CAST([CylA4] as smallint),
		CAST([CylA5] as smallint), CAST([CylA6] as smallint), CAST([CylA7] as smallint), CAST([CylA8] as smallint), CAST([CylA9] as smallint), CAST([CylA10] as smallint), CAST([CylB1] as smallint),
		CAST([CylB2] as smallint), CAST([CylB3] as smallint), CAST([CylB4] as smallint), cAST([CylB5] as smallint), CAST([CylB6] as smallint), CAST([CylB7] as smallint), CAST([CylB8] as smallint),
		CAST([CylB9] as smallint), CAST([CylB10] as smallint), CAST([BIN] as nchar(16)), CAST([BOUT] as nchar(16)), CAST([MVS] as float), CAST([ActPwrReq] as smallint), CAST([UBat] as float),
		CAST([CPUT] as float), CAST([TEMv] as float), CAST([LChr] as char(1)), CAST([OilB4F] as float), CAST([OilLev] as smallint), CAST([OilT] as float), CAST([CCpres] as float),
		CAST([AirInT] as float), CONVERT(smallint, CAST([RecAT] as float)), CAST([ThrPos] as float), CAST([CH4] as float), CAST([JWTin] as float), CAST([JWTout] as float), CAST([Numstr] as smallint),
		CAST([BI1] as nchar(8)), CAST([BI2] as nchar(8)), CAST([BI3] as nchar(8)), CAST([BI4] as nchar(8)), CAST([BI5] as nchar(8)), CAST([BI6] as nchar(8)), CAST([BI7] as nchar(8)), CAST([BI8] as nchar(8)),
		CAST([BI9] as nchar(8)), CAST([BI10] as nchar(8)), CAST([BI11] as nchar(8)), CAST([BI12] as nchar(8)), CAST([BO1] as nchar(8)), CAST([BO2] as nchar(8)), CAST([BO3] as nchar(8)), CAST([BO4] as nchar(8)),
		CAST([BO5] as nchar(8)), CAST([Pmns] as smallint), CAST([Qmns] as smallint), CONVERT(smallint, CAST([ActPfi] as float)), CAST([MLChr] as char(1)), CAST([Amb] as float), CAST([kVarho] as int), CAST([GasP] as float),
		CAST([LTHWfT] as float), CAST([LTHWrT] as float), CAST([GFlwRte] as float), CAST([GFlwM3] as int), CAST([H2S] as smallint), CAST([NumUns] as smallint), CAST([PwrDem] as smallint),
		CAST([JWGKin] as float), CAST([HWFlo] as float), CAST([HWRtn] as float), CAST([GasMet] as int), CONVERT(smallint, CAST([IcOut] as float)), CAST([ImpLoad] as smallint), CAST([Q] as float), CAST([U] as float),
		CAST([V] as float), CAST([W] as float), CAST([GroKwh] as int), CAST([AuxKwh] as int), CAST([TotRunPact]  as int), CAST([TotRunPnomAll] as int), CAST([SumMWh] as int)
	                                      
FROM Staging.GeneratorLog AS HL, HL_Locations AS LOC, HL_Events AS EV
WHERE HL.GENSET_SN = LOC.GENSET_SN
AND HL.REASON = EV.REASON and HL_Processed is NULL
AND	  (ISNUMERIC([RPM]) = 1 OR RPM IS NULL) AND (ISNUMERIC([Pwr]) = 1 OR Pwr IS NULL) AND (ISNUMERIC([PF]) = 1 OR PF IS NULL) AND (ISNUMERIC([Gfrq]) = 1 OR Gfrq IS NULL) AND (ISNUMERIC([H2S]) = 1 OR H2S IS NULL) AND
	  (ISNUMERIC([Vg1]) = 1 OR Vg1 IS NULL) AND (ISNUMERIC([Vg2]) = 1 OR Vg2 IS NULL) AND (ISNUMERIC([Vg3]) = 1 OR Vg3 IS NULL) AND (ISNUMERIC([Vg12]) = 1 OR Vg12 IS NULL) AND (ISNUMERIC([Vg23]) = 1 OR Vg23 IS NULL) AND
	  (ISNUMERIC([Vg31]) = 1 OR Vg31 IS NULL) AND (ISNUMERIC([Ig1]) = 1 OR Ig1 IS NULL) AND (ISNUMERIC([Ig2]) = 1 OR Ig2 IS NULL) AND (ISNUMERIC([Ig3]) = 1 OR Ig3 IS NULL) AND (ISNUMERIC([Mfrq]) = 1 OR Mfrq IS NULL) AND
	  (ISNUMERIC([Vm1]) = 1 OR Vm1 IS NULL) AND (ISNUMERIC([Vm2]) = 1 OR Vm2 IS NULL) AND (ISNUMERIC([Vm3]) = 1 OR Vm3 IS NULL) AND (ISNUMERIC([Vm12]) = 1 OR Vm12 IS NULL) AND (ISNUMERIC([Vm23]) = 1 OR Vm23 IS NULL) AND 
	  (ISNUMERIC([Vm31]) = 1 OR Vm31 IS NULL) AND (ISNUMERIC([MPF]) = 1 OR MPF IS NULL) AND (ISNUMERIC([SRO]) = 1 OR SRO IS NULL) AND (ISNUMERIC([VRO]) = 1 OR VRO IS NULL) AND (ISNUMERIC([kWhour]) = 1 OR kWhour IS NULL) AND
	  (ISNUMERIC([Runhrs]) = 1 OR Runhrs IS NULL) AND (ISNUMERIC([ActPwr]) = 1 OR ActPwr IS NULL) AND (ISNUMERIC([ActDem]) = 1 OR ActDem IS NULL) AND  (ISNUMERIC([CylA1]) = 1 OR CylA1 IS NULL) AND (ISNUMERIC([CylA2]) = 1 OR CylA2 IS NULL) AND
	  (ISNUMERIC([CylA3]) = 1 OR CylA3 IS NULL) AND (ISNUMERIC([CylA4]) = 1 OR CylA4 IS NULL) AND (ISNUMERIC([CylA5]) = 1 OR CylA5 IS NULL) AND (ISNUMERIC([CylA6]) = 1 OR CylA6 IS NULL) AND (ISNUMERIC([CylA7]) = 1 OR CylA7 IS NULL) AND
	  (ISNUMERIC([CylA8]) = 1 OR CylA8 IS NULL) AND (ISNUMERIC([CylA9]) = 1 OR CylA9 IS NULL) AND (ISNUMERIC([CylA10]) = 1 OR CylA10 IS NULL) AND (ISNUMERIC([CylB1]) = 1 OR CylB1 IS NULL) AND (ISNUMERIC([CylB2]) = 1 OR CylB2 IS NULL) AND
	  (ISNUMERIC([CylB3]) = 1 OR CylB3 IS NULL) AND (ISNUMERIC([CylB4]) = 1 OR CylB4 IS NULL) AND (ISNUMERIC([CylB5]) = 1 OR CylB5 IS NULL) AND (ISNUMERIC([CylB6]) = 1 OR CylB6 IS NULL) AND (ISNUMERIC([CylB7]) = 1 OR CylB7 IS NULL) AND
	  (ISNUMERIC([CylB8]) = 1 OR CylB8 IS NULL) AND (ISNUMERIC([CylB9]) = 1 OR CylB9 IS NULL) AND (ISNUMERIC([CylB10]) = 1 OR CylB10 IS NULL) AND (ISNUMERIC([MVS]) = 1 OR MVS IS NULL) AND (ISNUMERIC([ActPwrReq]) = 1 OR ActPwrReq IS NULL) AND
	  (ISNUMERIC([UBat]) = 1 OR UBat IS NULL) AND (ISNUMERIC([CPUT]) = 1 OR CPUT IS NULL) AND (ISNUMERIC([TEMv]) = 1 OR TEMv IS NULL) AND (ISNUMERIC([OilB4F]) = 1 OR OilB4F IS NULL) AND (ISNUMERIC([OilLev]) = 1 OR OilLev IS NULL) AND
	  (ISNUMERIC([OilT]) = 1 OR OilT IS NULL) AND (ISNUMERIC([CCpres]) = 1 OR CCpres IS NULL) AND (ISNUMERIC([AirInT]) = 1 OR AirInT IS NULL) AND (ISNUMERIC([RecAT]) = 1 OR RecAT IS NULL) AND (ISNUMERIC([ThrPos]) = 1 OR ThrPos IS NULL) AND 
	  (ISNUMERIC([CH4]) = 1 OR CH4 IS NULL) AND (ISNUMERIC([JWTin]) = 1 OR JWTin IS NULL) AND (ISNUMERIC([JWTout]) = 1 OR JWTout IS NULL) AND (ISNUMERIC([Numstr]) = 1  OR Numstr IS NULL) AND (ISNUMERIC([Pmns]) = 1 OR Pmns IS NULL) AND 
	  (ISNUMERIC([Qmns]) = 1 OR Qmns IS NULL) AND (ISNUMERIC([ActPfi]) = 1 OR ActPfi IS NULL) AND (ISNUMERIC([Amb]) = 1 OR Amb IS NULL) AND (ISNUMERIC([kVarho]) = 1 OR kVarho IS NULL) AND (ISNUMERIC([GasP]) = 1 OR GasP IS NULL) AND
	  (ISNUMERIC([LTHWfT]) = 1 OR LTHWfT IS NULL) AND (ISNUMERIC([LTHWrT]) = 1 OR LTHWrT IS NULL) AND (ISNUMERIC([GFlwRte]) = 1 OR GFlwRte IS NULL) AND (ISNUMERIC([GFlwM3]) = 1 OR GFlwM3 IS NULL) AND (ISNUMERIC([NumUns]) = 1 OR NumUns IS NULL) AND
	  (ISNUMERIC([PwrDem]) = 1  OR PwrDem IS NULL) AND (ISNUMERIC([JWGKin]) = 1 OR JWGKin IS NULL) AND (ISNUMERIC([HWFlo]) = 1 OR HWFlo IS NULL) AND (ISNUMERIC([HWRtn]) = 1 OR HWRtn IS NULL) AND (ISNUMERIC([GasMet]) = 1 OR GasMet IS NULL) AND 
	  (ISNUMERIC([IcOut]) = 1 OR IcOut IS NULL) AND (ISNUMERIC([ImpLoad]) = 1 OR ImpLoad IS NULL) AND (ISNUMERIC([Q]) = 1 OR Q IS NULL) AND (ISNUMERIC([U]) = 1 OR U IS NULL) AND (ISNUMERIC([V]) = 1 OR V IS NULL) AND (ISNUMERIC([W]) = 1 OR W IS NULL) AND
	  (ISNUMERIC([GroKwh]) = 1 OR GroKwh IS NULL) AND (ISNUMERIC([AuxKwh]) = 1 OR AuxKwh IS NULL) AND (ISNUMERIC([TotRunPact] ) = 1 OR TotRunPact IS NULL) AND (ISNUMERIC([TotRunPnomAll]) = 1 OR TotRunPnomAll IS NULL) AND (ISNUMERIC([SumMWh]) = 1 OR SumMWh IS NULL)
		
SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

--No Problems
COMMIT TRANSACTION

UPDATE Staging.GeneratorLog SET HL_Processed = 1 WHERE HL_Processed IS NULL  AND
	  (ISNUMERIC([RPM]) = 1 OR RPM IS NULL) AND (ISNUMERIC([Pwr]) = 1 OR Pwr IS NULL) AND (ISNUMERIC([PF]) = 1 OR PF IS NULL) AND (ISNUMERIC([Gfrq]) = 1 OR Gfrq IS NULL) AND (ISNUMERIC([H2S]) = 1 OR H2S IS NULL) AND
	  (ISNUMERIC([Vg1]) = 1 OR Vg1 IS NULL) AND (ISNUMERIC([Vg2]) = 1 OR Vg2 IS NULL) AND (ISNUMERIC([Vg3]) = 1 OR Vg3 IS NULL) AND (ISNUMERIC([Vg12]) = 1 OR Vg12 IS NULL) AND (ISNUMERIC([Vg23]) = 1 OR Vg23 IS NULL) AND
	  (ISNUMERIC([Vg31]) = 1 OR Vg31 IS NULL) AND (ISNUMERIC([Ig1]) = 1 OR Ig1 IS NULL) AND (ISNUMERIC([Ig2]) = 1 OR Ig2 IS NULL) AND (ISNUMERIC([Ig3]) = 1 OR Ig3 IS NULL) AND (ISNUMERIC([Mfrq]) = 1 OR Mfrq IS NULL) AND
	  (ISNUMERIC([Vm1]) = 1 OR Vm1 IS NULL) AND (ISNUMERIC([Vm2]) = 1 OR Vm2 IS NULL) AND (ISNUMERIC([Vm3]) = 1 OR Vm3 IS NULL) AND (ISNUMERIC([Vm12]) = 1 OR Vm12 IS NULL) AND (ISNUMERIC([Vm23]) = 1 OR Vm23 IS NULL) AND 
	  (ISNUMERIC([Vm31]) = 1 OR Vm31 IS NULL) AND (ISNUMERIC([MPF]) = 1 OR MPF IS NULL) AND (ISNUMERIC([SRO]) = 1 OR SRO IS NULL) AND (ISNUMERIC([VRO]) = 1 OR VRO IS NULL) AND (ISNUMERIC([kWhour]) = 1 OR kWhour IS NULL) AND
	  (ISNUMERIC([Runhrs]) = 1 OR Runhrs IS NULL) AND (ISNUMERIC([ActPwr]) = 1 OR ActPwr IS NULL) AND (ISNUMERIC([ActDem]) = 1 OR ActDem IS NULL) AND (ISNUMERIC([CylA1]) = 1 OR CylA1 IS NULL) AND (ISNUMERIC([CylA2]) = 1 OR CylA2 IS NULL) AND
	  (ISNUMERIC([CylA3]) = 1 OR CylA3 IS NULL) AND (ISNUMERIC([CylA4]) = 1 OR CylA4 IS NULL) AND (ISNUMERIC([CylA5]) = 1 OR CylA5 IS NULL) AND (ISNUMERIC([CylA6]) = 1 OR CylA6 IS NULL) AND (ISNUMERIC([CylA7]) = 1 OR CylA7 IS NULL) AND
	  (ISNUMERIC([CylA8]) = 1 OR CylA8 IS NULL) AND (ISNUMERIC([CylA9]) = 1 OR CylA9 IS NULL) AND (ISNUMERIC([CylA10]) = 1 OR CylA10 IS NULL) AND (ISNUMERIC([CylB1]) = 1 OR CylB1 IS NULL) AND (ISNUMERIC([CylB2]) = 1 OR CylB2 IS NULL) AND
	  (ISNUMERIC([CylB3]) = 1 OR CylB3 IS NULL) AND (ISNUMERIC([CylB4]) = 1 OR CylB4 IS NULL) AND (ISNUMERIC([CylB5]) = 1 OR CylB5 IS NULL) AND (ISNUMERIC([CylB6]) = 1 OR CylB6 IS NULL) AND (ISNUMERIC([CylB7]) = 1 OR CylB7 IS NULL) AND
	  (ISNUMERIC([CylB8]) = 1 OR CylB8 IS NULL) AND (ISNUMERIC([CylB9]) = 1 OR CylB9 IS NULL) AND (ISNUMERIC([CylB10]) = 1 OR CylB10 IS NULL) AND
	  (ISNUMERIC([MVS]) = 1 OR MVS IS NULL) AND (ISNUMERIC([ActPwrReq]) = 1 OR ActPwrReq IS NULL) AND (ISNUMERIC([UBat]) = 1 OR UBat IS NULL) AND (ISNUMERIC([CPUT]) = 1 OR CPUT IS NULL) AND (ISNUMERIC([TEMv]) = 1 OR TEMv IS NULL) AND
	  (ISNUMERIC([OilB4F]) = 1 OR OilB4F IS NULL) AND (ISNUMERIC([OilLev]) = 1 OR OilLev IS NULL) AND (ISNUMERIC([OilT]) = 1 OR OilT IS NULL) AND (ISNUMERIC([CCpres]) = 1 OR CCpres IS NULL) AND (ISNUMERIC([AirInT]) = 1 OR AirInT IS NULL) AND
	  (ISNUMERIC([RecAT]) = 1 OR RecAT IS NULL) AND (ISNUMERIC([ThrPos]) = 1 OR ThrPos IS NULL) AND (ISNUMERIC([CH4]) = 1 OR CH4 IS NULL) AND (ISNUMERIC([JWTin]) = 1 OR JWTin IS NULL) AND (ISNUMERIC([JWTout]) = 1 OR JWTout IS NULL) AND
	  (ISNUMERIC([Numstr]) = 1  OR Numstr IS NULL)  AND (ISNUMERIC([Pmns]) = 1 OR Pmns IS NULL) AND (ISNUMERIC([Qmns]) = 1 OR Qmns IS NULL) AND (ISNUMERIC([ActPfi]) = 1 OR ActPfi IS NULL) AND (ISNUMERIC([Amb]) = 1 OR Amb IS NULL) AND 
	  (ISNUMERIC([kVarho]) = 1 OR kVarho IS NULL) AND (ISNUMERIC([GasP]) = 1 OR GasP IS NULL) AND (ISNUMERIC([LTHWfT]) = 1 OR LTHWfT IS NULL) AND (ISNUMERIC([LTHWrT]) = 1 OR LTHWrT IS NULL) AND (ISNUMERIC([GFlwRte]) = 1 OR GFlwRte IS NULL) AND
	  (ISNUMERIC([GFlwM3]) = 1 OR GFlwM3 IS NULL)  AND (ISNUMERIC([NumUns]) = 1 OR NumUns IS NULL) AND (ISNUMERIC([PwrDem]) = 1  OR PwrDem IS NULL) AND	  (ISNUMERIC([JWGKin]) = 1 OR JWGKin IS NULL) AND (ISNUMERIC([HWFlo]) = 1 OR HWFlo IS NULL) AND
	  (ISNUMERIC([HWRtn]) = 1 OR HWRtn IS NULL) AND (ISNUMERIC([GasMet]) = 1 OR GasMet IS NULL) AND (ISNUMERIC([IcOut]) = 1 OR IcOut IS NULL) AND (ISNUMERIC([ImpLoad]) = 1 OR ImpLoad IS NULL) AND (ISNUMERIC([Q]) = 1 OR Q IS NULL) AND
	  (ISNUMERIC([U]) = 1 OR U IS NULL) AND (ISNUMERIC([V]) = 1 OR V IS NULL) AND (ISNUMERIC([W]) = 1 OR W IS NULL) AND (ISNUMERIC([GroKwh]) = 1 OR GroKwh IS NULL) AND (ISNUMERIC([AuxKwh]) = 1 OR AuxKwh IS NULL) AND
	  (ISNUMERIC([TotRunPact] ) = 1 OR TotRunPact IS NULL) AND (ISNUMERIC([TotRunPnomAll]) = 1 OR TotRunPnomAll IS NULL) AND (ISNUMERIC([SumMWh]) = 1 OR SumMWh IS NULL)

GOTO FINISH

PROBLEM:
	IF (@intErrorCode <> 0) BEGIN
		PRINT 'Unexpected error occurred!'
		PRINT @@ERROR
		ROLLBACK TRANSACTION
	END
	
FINISH:
Print('End of function: ed_Import_NormalizeToGeneratorContent ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_NormalizeToHL_Logs]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 17/12/2009
-- Description:	Convert the data from Staging.GeneratorLog table to the SQL Normalized Structure
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_NormalizeToHL_Logs]
AS
BEGIN

DECLARE @intErrorCode INT

BEGIN TRANSACTION

INSERT INTO HL_Events(REASON)
SELECT DISTINCT REASON
FROM Staging.GeneratorLog
WHERE REASON NOT IN
(SELECT DISTINCT REASON FROM HL_Events)

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

INSERT INTO HL_Locations(GENSET_SN, GENSETNAME, SITENAME)
SELECT DISTINCT GENSET_SN, 'UNNAMED' AS GENSITENAME, 'UNNAMED' AS SITENAME
FROM Staging.GeneratorLog
WHERE GENSET_SN NOT IN
(SELECT DISTINCT GENSET_SN FROM HL_Locations)

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

--Normalize the data for logs
INSERT INTO HL_Logs(Time_Stamp, ID_Location, ID_Event,[EVENT]
      ,[RPM],[Pwr],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[BIN],[BOUT],[Mode],[LTHWrT],[LTHWfT]
      ,[OilB4F],[CCpres],[OilLev],[ActPfi],[ActDem],[CH4],[OilT],[AirInT],[RecAT],[JWTout],[JWTin],[JWGKin],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5]
      ,[CylA6],[CylA7],[CylA8],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[kWhour],[Runhrs],[Numstr],[NumUns],[Q],[LChr],[Mfrq]
      ,[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[Pmns],[Qmns],[MPF],[MVS],[SRO],[VRO],[UBat],[CPUT],[ActPwr],[Amb],[GasP],[GasMet],[PF],[H2S]
      ,[ThrPos],[kVarho],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BO1],[BO2],[BO3],[CylA9],[CylA10],[CylB9],[CylB10],[BI12],[TEMv]
	  ,[MLChr],[GroKwh],[BO4],[IcOut],[D+],[U],[V],[W],[GFlwRte],[GFlwM3],[Spare],[HWFlo],[HWRtn],[HtMet],[ChMet],[BO5],[TotRunPact],[TotRunPnomAll]
      ,[SumMWh],[PwrDem],[ActPwrReq],[ImpLoad],[AuxKwh])
	                     
SELECT 
	CONVERT(DATETIME, HL.ItemDATE + HL.ItemTIME) AS Time_Stamp,	LOC.ID AS ID_Location,	EV.ID AS ID_Event,[EVENT]
	 ,[RPM],[Pwr],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[BIN],[BOUT],[Mode],[LTHWrT],[LTHWfT]
      ,[OilB4F],[CCpres],[OilLev],[ActPfi],[ActDem],[CH4],[OilT],[AirInT],[RecAT],[JWTout],[JWTin],[JWGKin],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5]
      ,[CylA6],[CylA7],[CylA8],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[kWhour],[Runhrs],[Numstr],[NumUns],[Q],[LChr],[Mfrq]
      ,[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[Pmns],[Qmns],[MPF],[MVS],[SRO],[VRO],[UBat],[CPUT],[ActPwr],[Amb],[GasP],[GasMet],[PF],[H2S]
      ,[ThrPos],[kVarho],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BO1],[BO2],[BO3],[CylA9],[CylA10],[CylB9],[CylB10],[BI12],[TEMv]
	  ,[MLChr],[GroKwh],[BO4],[IcOut],[D+],[U],[V],[W],[GFlwRte],[GFlwM3],[Spare],[HWFlo],[HWRtn],[HtMet],[ChMet],[BO5],[TotRunPact],[TotRunPnomAll]
      ,[SumMWh],[PwrDem],[ActPwrReq],[ImpLoad],[AuxKwh]
	                     
FROM Staging.GeneratorLog AS HL, HL_Locations AS LOC, HL_Events AS EV
WHERE HL.GENSET_SN = LOC.GENSET_SN
AND HL.REASON = EV.REASON and HL_Processed is NULL
/*EXCEPT
	(SELECT CONVERT(VARCHAR, Time_Stamp, 120), ID_Location, ID_Event,[EVENT]
	,[RPM],[Pwr],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[BIN],[BOUT],[Mode],[LTHWrT],[LTHWfT]
      ,[OilB4F],[CCpres],[OilLev],[ActPfi],[ActDem],[CH4],[OilT],[AirInT],[RecAT],[JWTout],[JWTin],[JWGKin],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5]
      ,[CylA6],[CylA7],[CylA8],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[kWhour],[Runhrs],[Numstr],[NumUns],[Q],[LChr],[Mfrq]
      ,[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[Pmns],[Qmns],[MPF],[MVS],[SRO],[VRO],[UBat],[CPUT],[ActPwr],[Amb],[GasP],[GasMet],[PF],[H2S]
      ,[ThrPos],[kVarho],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BO1],[BO2],[BO3],[CylA9],[CylA10],[CylB9],[CylB10],[BI12],[TEMv]
	  ,[MLChr],[GroKwh],[BO4],[IcOut],[D+],[U],[V],[W],[GFlwRte],[GFlwM3],[Spare],[HWFlo],[HWRtn],[HtMet],[ChMet],[BO5],[TotRunPact],[TotRunPnomAll]
      ,[SumMWh],[PwrDem],[ActPwrReq],[ImpLoad],[AuxKwh]
     FROM HL_Logs)*/
		
SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

--No Problems
COMMIT TRANSACTION
update Staging.GeneratorLog
set HL_Processed = 1
where HL_Processed IS NULL
GOTO FINISH

PROBLEM:
	IF (@intErrorCode <> 0) BEGIN
		PRINT 'Unexpected error occurred!'
		PRINT @@ERROR
		ROLLBACK TRANSACTION
	END
	
FINISH:
Print('End of function: ed_Import_NormalizeToHL_Logs ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))
END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_NormalizeToLGE650Meters]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <13/12/2011>
-- Description:	<Copy data from dbo.RTCU to dbo.HistoryLog ignoring duplicate records and uses fixed columns>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_NormalizeToLGE650Meters]

AS

--Add the new data to the SQL
BEGIN TRANSACTION

 --Insert goes here
INSERT INTO [dbo].EnergyMeters_LG_E650([Timestamp],[Serial],
				  [F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0],[4_6_0],
				  [1_8_1],[2_8_1],[3_8_1],[4_8_1],[0_4_2],[32_7],[52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],
				  [1-1:32_32_0],[1-1:52_32_0],[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0])
	                     
SELECT [Timestamp],[Serial],
	   [F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0],[4_6_0],
	   [1_8_1],[2_8_1],[3_8_1],[4_8_1],[0_4_2],[32_7],[52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],
	   [1-1:32_32_0],[1-1:52_32_0],[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0]

FROM
(
	SELECT [Timestamp],[Serial],
		   [F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0],[4_6_0],
		   [1_8_1],[2_8_1],[3_8_1],[4_8_1],[0_4_2],[32_7],[52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],
		   [1-1:32_32_0],[1-1:52_32_0],[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0],
	
	rn = ROW_NUMBER() OVER 
	(
		PARTITION BY [TimeStamp], [Serial]
		ORDER BY [TimeStamp] DESC
	)
	FROM [Staging].EnergyMetersLGE650Data
) AS EnergyMetersLGE650Data
  WHERE rn = 1 AND NOT EXISTS 
  (
	SELECT 1 FROM dbo.EnergyMeters_LG_E650 -- Look for duplicates where all 3 condistions below match
	WHERE [TimeStamp]  = EnergyMetersLGE650Data.[TimeStamp]
	AND Serial = EnergyMetersLGE650Data.Serial
  )

COMMIT TRANSACTION
		
TRUNCATE TABLE Staging.EnergyMetersLGE650Data -- Clear the pre-staging table
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_ProcessCustomEvents]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/01/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_ProcessCustomEvents]
AS
BEGIN
	SET NOCOUNT ON;

declare @id int
declare @idrange int
declare @timestamp datetime
declare @idlocation int
declare @idevent int

declare @event1 int
declare @event2 int
declare @event3 int
declare @event4 int

set @event1 = 943 --GCB Opened 73 or 943
set @event2 = 939 --GCB Closed 72 or 939

declare @tmptbl TABLE
(
	ID_Location int,
	idDown int,
	idUp int,
	dtDown datetime,
	dtUp datetime,
	Reason nvarchar(200)
);

declare cur1 cursor fast_forward
for
	select id, TimeStamp, IdEvent, IdLocation
	from dbo.GeneratorContent
	where IdEvent = @event1 AND _ShutdownProcessed IS NULL AND TimeStamp >= Dateadd(Month, Datediff(Month, 0, DATEADD(m, -6, current_timestamp)), 0)
	order by TimeStamp asc
open cur1

fetch next from cur1
into @id,@timestamp,@idevent,@idlocation

while @@FETCH_STATUS = 0
begin
	insert into @tmptbl
	select top 1 IdLocation, @id as idDown, id as idUp, @timestamp as dtDown, TimeStamp as dtUp, ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM dbo.GeneratorContent, HL_EVENTS AS EV 
				 WHERE EV.ID = IdEvent 
				 AND IdLocation = @idlocation
				 AND TimeStamp <= (Select TimeStamp FROM dbo.GeneratorContent WHERE ID = @id)
				 AND IdEvent NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 AND IdEvent NOT IN (@event1,@event2) --Hardcoded, need a better solution here.
				 ORDER BY TimeStamp DESC),
			'UNKNOWN') AS REASON from dbo.GeneratorContent
	where TimeStamp > @timestamp
	and TimeStamp < getdate()
	and IdEvent = @event2
	and IdLocation = @idlocation
	order by TimeStamp asc
	
	/* Mark the ID as processed if rows returned - Not to be used again!!*/
	if @@ROWCOUNT = 1
	update dbo.GeneratorContent
	set _ShutdownProcessed = 1
	WHERE ID = @id

	fetch next from cur1
	into @id,@timestamp,@idevent,@idlocation
end

insert into exempts(ID_Location, iddown, idup, dtdown, dtup, timedifference, Reason)
select ID_Location, iddown, idup, dtdown, dtup, DATEDIFF(MINUTE, dtdown, dtup) as timedifference, Reason
from @tmptbl

except  
	select ID_Location, iddown, idup, convert(varchar, dtdown, 120), convert(varchar, dtup, 120), timedifference, Reason from exempts
except  
	select ID_Location, iddown, idup, convert(varchar, dtdown, 120), convert(varchar, OrigDtUp, 120), DATEDIFF(MINUTE, dtdown, OrigDtUp) as timedifference, Reason from exempts 

	
close cur1
deallocate cur1

Print('End of function: ed_Import_ProcessCustomEvents ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_ProcessGeneratorAvailability]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/01/2020
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_ProcessGeneratorAvailability]
AS
BEGIN
	SET NOCOUNT ON;

declare @id int
declare @idrange int
declare @timestamp datetime
declare @idlocation int
declare @idevent int

declare @event1 int
declare @event2 int

set @event1 = 4416 --Hst Not Available
set @event2 = 4415 --Hst Available


declare @tmptbl TABLE
(
	idLocation int,
	idUnavailable int,
	idAvailable int,
	dtUnavailable datetime,
	dtAvailable datetime,
	Reason nvarchar(200)
);

--locate the opening events, where the generator becomes unavailable and place into a cursor for processing
declare cur1 cursor fast_forward
for
	select Id, TimeStamp, IdEvent, IdLocation
	from dbo.GeneratorContent
	where IdEvent = @event1 AND _AvailabilityProcessed IS NULL AND TimeStamp >= Dateadd(Month, Datediff(Month, 0, DATEADD(m, -6, current_timestamp)), 0)
	order by TimeStamp asc
open cur1

--loop cursor
fetch next from cur1
into @id,@timestamp,@idevent,@idlocation

while @@FETCH_STATUS = 0
begin
	insert into @tmptbl
	select top 1 IdLocation, @id as idUnavailable, id as idAvailable, @timestamp as dtUnavailable, TimeStamp as dtAvailable, ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM dbo.GeneratorContent, HL_EVENTS AS EV 
				 WHERE EV.ID = IdEvent 
				 AND IdLocation = @idlocation
				 AND TimeStamp <= (Select TimeStamp FROM dbo.GeneratorContent WHERE ID = @id)
				 AND IdEvent NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 ORDER BY TimeStamp DESC),
			'UNKNOWN') AS REASON from dbo.GeneratorContent
	where TimeStamp > @timestamp
	and TimeStamp < getdate()
	and IdEvent = @event2
	and IdLocation = @idlocation
	order by TimeStamp asc

	--Mark the ID as processed if rows returned - Not to be used again!
	if @@ROWCOUNT = 1
	update dbo.GeneratorContent
	set _AvailabilityProcessed = 1
	WHERE ID = @id

	fetch next from cur1
	into @id,@timestamp,@idevent,@idlocation
end

insert into GeneratorAvailability(IdLocation, IdUnavailable, IdAvailable, DtUnavailable, DtAvailable, TimeDifference, Reason)
select IdLocation, IdUnavailable, IdAvailable, dtUnavailable, dtAvailable, DATEDIFF(MINUTE, dtUnavailable, dtAvailable) as timedifference, Reason
from @tmptbl

except  
	select IdLocation, IdUnavailable, IdAvailable, DtUnavailable, DtAvailable, TimeDifference, Reason from GeneratorAvailability

	
close cur1
deallocate cur1

Print('End of function: ed_Import_GeneratorAvailability ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_ProcessShutdowns]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		neil-rutherford
-- Create date: 08/01/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_ProcessShutdowns]
AS
BEGIN
	SET NOCOUNT ON;
	SET DEADLOCK_PRIORITY 5;

declare @Id int
declare @Idrange int
declare @TimeStamp datetime
declare @IdLocation int
declare @IdEvent int

declare @Event1 int
declare @Event2 int
declare @Event3 int
declare @Event4 int

set @Event1 = 73 --GCB Opened 73 or 943
set @Event2 = 72 --GCB Closed 72 or 939

declare @tmptbl TABLE
(
	IdLocation int,
	IdDown int,
	IdUp int,
	DtDown datetime,
	DtUp datetime,
	Reason nvarchar(200)
);

declare cur1 cursor fast_forward
for
	select Id, TimeStamp, IdEvent, IdLocation
	from dbo.GeneratorContent
	where IdEvent = @Event1 AND _ShutdownProcessed IS NULL AND TimeStamp >= DATEADD(d, -14, current_timestamp)
	order by TimeStamp asc
open cur1

fetch next from cur1
into @Id,@TimeStamp,@IdEvent,@IdLocation

while @@FETCH_STATUS = 0
begin
	insert into @tmptbl
	select top 1 IdLocation, @Id as IdDown, Id as IdUp, @TimeStamp as DtDown, TimeStamp as DtUp, ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM dbo.GeneratorContent, dbo.HL_Events AS Ev 
				 WHERE Ev.ID = IdEvent 
				 AND IdLocation = @IdLocation
				 AND TimeStamp <= (Select TimeStamp FROM dbo.GeneratorContent WHERE Id = @Id)
				 AND IdEvent NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 AND IdEvent NOT IN (@Event1,@Event2) --Hardcoded, need a better solution here.
				 ORDER BY TimeStamp DESC),
			'UNKNOWN') AS REASON from dbo.GeneratorContent
	where TimeStamp > @TimeStamp
	and TimeStamp < getdate()
	and IdEvent = @Event2
	and IdLocation = @IdLocation
	order by TimeStamp asc
	
	/* Mark the ID as processed if rows returned - Not to be used again!!*/
	if @@ROWCOUNT = 1
	update dbo.GeneratorContent
	set _ShutdownProcessed = 1
	WHERE Id = @Id

	fetch next from cur1
	into @Id,@TimeStamp,@IdEvent,@IdLocation
end

insert into dbo.Exempts(ID_Location, iddown, idup, dtdown, dtup, timedifference, Reason)
select IdLocation, IdDown, IdUp, DtDown, DtUp, DATEDIFF(MINUTE, DtDown, DtUp) as timedifference, Reason
from @tmptbl

except  
	select ID_Location, iddown, idup, convert(varchar, dtdown, 120), convert(varchar, dtup, 120), timedifference, Reason from dbo.Exempts
except  
	select ID_Location, iddown, idup, convert(varchar, dtdown, 120), convert(varchar, OrigDtUp, 120), DATEDIFF(MINUTE, dtdown, OrigDtUp) as timedifference, Reason from dbo.Exempts 

	
close cur1
deallocate cur1

Print('End of function: ed_Import_ProcessShutdowns ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_ProcessStartups]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/01/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_ProcessStartups]
AS
BEGIN
	SET NOCOUNT ON;
	SET DEADLOCK_PRIORITY 5;

declare @id int
declare @idrange int
declare @timestamp datetime
declare @idlocation int
declare @idevent int

declare @event1 int
declare @event2 int
declare @event3 int
declare @event4 int
declare @event5 int
declare @event6 int

set @event1 = 2272 --Hst Run Signal 2nd
set @event2 = 2388
--set @event2 = 2280 --Full Load
--set @event3 = 2282 --Full Load
--set @event4 = 2281 --Full Load
--set @event5 = 2283 --Full Load
--set @event6 = 2278 --Full Load

declare @tmptbl TABLE
(
	ID_Location int,
	idStart int,
	idFullLoad int,
	dtStart datetime,
	dtFullLoad datetime,
	Reason nvarchar(200)
);

declare cur1 cursor fast_forward
for
	select id, TimeStamp, IdEvent, IdLocation
	from dbo.GeneratorContent
	where IdEvent = @event1 AND _StartupProcessed IS NULL AND TimeStamp >= Dateadd(Month, Datediff(Month, 0, DATEADD(m, -6, current_timestamp)), 0)
	order by TimeStamp asc
open cur1

fetch next from cur1
into @id,@timestamp,@idevent,@idlocation

while @@FETCH_STATUS = 0
begin
	insert into @tmptbl
	select top 1 IdLocation, @id as idStart, id as idFullLoad, @timestamp as dtStart, TimeStamp as dtFullLoad, ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM dbo.GeneratorContent, HL_EVENTS AS EV 
				 WHERE EV.ID = IdEvent 
				 AND IdLocation = @idlocation
				 AND TimeStamp <= (Select TimeStamp FROM dbo.GeneratorContent WHERE ID = @id)
				 AND IdEvent NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 ORDER BY TimeStamp DESC),
			'UNKNOWN') AS REASON from dbo.GeneratorContent
	where TimeStamp > @timestamp
	and TimeStamp < getdate()
	and IdEvent = @event2
	and IdLocation = @idlocation
	order by TimeStamp asc

	/* Mark the ID as processed if rows returned - Not to be used again!!*/
	if @@ROWCOUNT = 1
	update dbo.GeneratorContent
	set _StartupProcessed = 1
	WHERE ID = @id


	fetch next from cur1
	into @id,@timestamp,@idevent,@idlocation
end

insert into LoadTimes(ID_Location, IDStart, IDFullLoad, DTStart, DTFullLoad, TimeDifference, Reason)
select ID_Location, idStart, idFullLoad, dtStart, dtFullLoad, DATEDIFF(MINUTE, dtStart, dtFullLoad) as timedifference, Reason
from @tmptbl

except  
	select ID_Location, IDStart, IDFullLoad, DTStart, DTFullLoad, TimeDifference, Reason from LoadTimes

	
close cur1
deallocate cur1

Print('End of function: ed_Import_ProcessStartups ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_UpdateEnergyMeterSerials]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil A Rutherford
-- Create date: 09-05-2016
-- Description:	Searches the meter data tables for new serials and inserts into the mapping tables
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_UpdateEnergyMeterSerials]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Diris A20 Meters
	INSERT INTO EnergyMeters_Mapping_Serial(Serial)
	SELECT DISTINCT Serial
	FROM EnergyMeters_Diris_A20
	WHERE Serial NOT IN
	(SELECT DISTINCT Serial FROM EnergyMeters_Mapping_Serial)

	-- L&G E650 Meters
	INSERT INTO EnergyMeters_Mapping_Serial(Serial)
	SELECT DISTINCT Serial
	FROM EnergyMeters_LG_E650
	WHERE Serial NOT IN
	(SELECT DISTINCT Serial FROM EnergyMeters_Mapping_Serial)

	Print('End of function: ed_Import_UpdateEnergyMeterSerials ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_UpdateGensetLastRecordTimes]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_UpdateGensetLastRecordTimes]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  --Create a table for IDS and insert all ids from locations
declare @ids table(idx int identity(1,1), id int)
	
insert into @ids SELECT DISTINCT t2.ID from Staging.GeneratorLog t1 Inner join HL_Locations t2 on t1.GENSET_SN = t2.GENSET_SN  where t1.UpdateTime_Processed IS NULL AND t1.HL_Processed = 1

declare @i int
declare @cnt int

-- loop counter values
select @i = min(idx) - 1, @cnt = max(idx) from @ids

while @i < @cnt
begin
    select @i = @i + 1

	declare @Lid int
    select @Lid = id from @ids where idx = @i
    
    declare @lstupdate datetime
    Select TOP 1 @lstupdate = CONVERT(DATETIME, ItemDATE + ItemTIME) from Staging.GeneratorLog where GENSET_SN = (Select GENSET_SN from HL_Locations where ID = @Lid) and UpdateTime_Processed IS NULL  AND HL_Processed = 1
		order by CONVERT(DATETIME, ItemDATE + ItemTIME) desc
    
    Update HL_Locations
    SET LASTUPDATE = @lstupdate
	WHERE ID = @Lid
	
	UPDATE Staging.GeneratorLog
	SET UpdateTime_Processed = 1
	WHERE UpdateTime_Processed IS NULL AND HL_Processed = 1 AND GENSET_SN = (Select GENSET_SN from HL_Locations where ID = @Lid)
end

	Print('End of function: ed_Import_UpdateGensetLastRecordTimes ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_UpdateTableIndexes]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_UpdateTableIndexes]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	insert into DataBaseLog values (GETDATE(), 'ReportingSystem(Azure)', 'Reindexing started.')
	
	ALTER INDEX idx_DT_Processed ON HL_Logs	REORGANIZE;
	ALTER INDEX idx_ID_Event ON HL_Logs	REORGANIZE;
	ALTER INDEX idx_ID_Location ON HL_Logs REORGANIZE;
	ALTER INDEX idx_kWhour ON HL_Logs REORGANIZE;
	ALTER INDEX idx_Runhrs ON HL_Logs REORGANIZE;
	ALTER INDEX idx_StartupTime_Processed ON HL_Logs REORGANIZE;
	ALTER INDEX idx_UpdateTime_Processed ON HL_Logs REORGANIZE;
	--ALTER INDEX idx_Partition_Time_Stamp ON HL_Logs REORGANIZE;
	--ALTER INDEX PK_HL_Logs ON HL_Logs REORGANIZE;
	
	insert into DataBaseLog values (GETDATE(), 'ReportingSystem(Azure)', 'Reindexing finished.')

	Print('End of function: ed_Import_UpdateTableIndexes ' + CONVERT( VARCHAR(24), SYSDATETIME(), 121))

END
GO
/****** Object:  StoredProcedure [dbo].[ed_Import_Xp_Cmdshell_SetUser]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/09/2017
-- Description:	Sets the users to connect to the EDLIS-EOS-01 FTP Server for all proceeding functions
-- =============================================
CREATE PROCEDURE [dbo].[ed_Import_Xp_Cmdshell_SetUser]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	exec xp_cmdshell 'net use \\EDLIS-EOS-01\ReportingSystem  /USER:EDLIS-EOS-01\ReportingSystem 3d1naReporting'

	Print('End of function: ed_Import_Xp_Cmdshell_SetUser ' +  CONVERT( VARCHAR(24), SYSDATETIME(), 121))
END
GO
/****** Object:  StoredProcedure [dbo].[ed_InsertDirisA20Reading]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/04/2020
-- Description:	Consume JSON Steam Readings
-- =============================================
CREATE PROCEDURE [dbo].[ed_InsertDirisA20Reading]
	@JSONData NVARCHAR(4000)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @_IdLocation AS INT
	DECLARE @_TimeStamp AS DATETIME
	DECLARE @_UtcRecieved AS DATETIME

	SET @_UtcRecieved = GETUTCDATE()

	BEGIN TRY
	-- Validate JSON
	IF (NOT ISJSON(@JSONData) > 0)  
		BEGIN
			PRINT 'ERROR: The JSON data is not valid.'  
			RETURN(1)  
		END
	-- Check the TimeStamp
	SELECT @_TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
	IF @_TimeStamp > DATEADD(HOUR, 24, GETDATE()) OR @_TimeStamp < DATEADD(DAY, -180, GETDATE())
		BEGIN
			PRINT 'ERROR: The TimeStamp is invalid, please check the controller time.'  
			RETURN(5)  
		END
	-- Make sure site serial serial exists
	SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@JSONData, '$.Header.Serial')
	IF @_IdLocation IS NULL
		BEGIN
			PRINT 'ERROR: The Generator Serial does not exist.'  
			RETURN(2)  
		END
	-- Does a record with the same TimeStamp exist
	IF (SELECT COUNT(*) FROM EnergyMeters.Steam
		WHERE TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
		AND IdLocation = @_IdLocation) > 0
		BEGIN
			PRINT 'ERROR: The record already exists.'  
			RETURN(4)  
		END
	ELSE

		-- Insert the data into the content table
		INSERT INTO EnergyMeters.DirisA20([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[Serial],[I-1],[I-2],[I-3],[I-N],[V1-2],[V2-3],[V3-1],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr])
		SELECT @_IdLocation,@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[Serial],[I-1],[I-2],[I-3],[I-N],[V1-2],[V2-3],[V3-1],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr]
		FROM OPENJSON(@JSONData)
			WITH (
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[Serial] nchar(12) N'$.Record.Serial',
				[I-1] float N'$.Readings.I1',
				[I-2] float N'$.Readings.I2',
				[I-3] float N'$.Readings.I3',
				[I-N] float N'$.Readings.IN',
				[V1-2] float N'$.Readings.V1V2',
				[V2-3] float N'$.Readings.V2V3',
				[V3-1] float N'$.Readings.V3V1',
				[V1-N] float N'$.Readings.V1N',
				[V2-N] float N'$.Readings.V2N',
				[V3-N] float N'$.Readings.V3N',
				[F] float N'$.Readings.F',
				[P] float N'$.Readings.P',
				[Q] float N'$.Readings.Q',
				[S] float N'$.Readings.S',
				[PF] float N'$.Readings.PF',
				[W] float N'$.Readings.W',
				[Wr] float N'$.Readings.Wr')
				
	END TRY
	BEGIN CATCH
		PRINT 'Unhandled error in procedure...';
		THROW;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[ed_InsertE650Reading]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/04/2020
-- Description:	Consume JSON Steam Readings
-- =============================================
CREATE PROCEDURE [dbo].[ed_InsertE650Reading]
	@JSONData NVARCHAR(4000)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @_IdLocation AS INT
	DECLARE @_TimeStamp AS DATETIME
	DECLARE @_UtcRecieved AS DATETIME

	SET @_UtcRecieved = GETUTCDATE()

	BEGIN TRY
	-- Validate JSON
	IF (NOT ISJSON(@JSONData) > 0)  
		BEGIN
			PRINT 'ERROR: The JSON data is not valid.'  
			RETURN(1)  
		END
	-- Check the TimeStamp
	SELECT @_TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
	IF @_TimeStamp > DATEADD(HOUR, 24, GETDATE()) OR @_TimeStamp < DATEADD(DAY, -180, GETDATE())
		BEGIN
			PRINT 'ERROR: The TimeStamp is invalid, please check the controller time.'  
			RETURN(5)  
		END
	-- Make sure site serial serial exists
	SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@JSONData, '$.Header.Serial')
	IF @_IdLocation IS NULL
		BEGIN
			PRINT 'ERROR: The Generator Serial does not exist.'  
			RETURN(2)  
		END
	-- Does a record with the same TimeStamp exist
	IF (SELECT COUNT(*) FROM EnergyMeters.Steam
		WHERE TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
		AND IdLocation = @_IdLocation) > 0
		BEGIN
			PRINT 'ERROR: The record already exists.'  
			RETURN(4)  
		END
	ELSE

		-- Insert the data into the content table
		INSERT INTO EnergyMeters.E650([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[Serial],[F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0]
										,[4_6_0],[1_8_1],[2_8_1],[3_8_1],[4_8_1],[0_4_2],[32_7],[52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],[1-1:32_32_0],[1-1:52_32_0]
										,[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0])
		SELECT @_IdLocation,@_UtcRecieved,[UtcGenerated],[TimeStamp],[Serial],[F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0]
										,[4_6_0],[1_8_1],[2_8_1],[3_8_1],[4_8_1],[0_4_2],[32_7],[52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],[1-1:32_32_0],[1-1:52_32_0]
										,[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0]
		FROM OPENJSON(@JSONData)
			WITH (
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[Serial] nchar(12) N'$.Record.Serial',
				[F_F] nchar(10) '$.Readings."F.F"',
				[0_9_1] nchar(12) '$.Readings."0.9.1"',
				[0_9_2] nchar(12) '$.Readings."0.9.2"',
				[1_2_0] nchar(12) '$.Readings."1.2.0"',
				[2_2_0] nchar(12) '$.Readings."2.2.0"',
				[3_2_0] nchar(12) '$.Readings."3.2.0"',
				[4_2_0] nchar(12) '$.Readings."4.2.0"',
				[1_6_0] nchar(12) '$.Readings."1.6.0"',
				[2_6_0] nchar(12) '$.Readings."2.6.0"',
				[3_6_0] nchar(12) '$.Readings."3.6.0"',
				[4_6_0] nchar(12) '$.Readings."4.6.0"',
				[1_8_1] nchar(12) '$.Readings."1.8.1"',
				[2_8_1] nchar(12) '$.Readings."2.8.1"',
				[3_8_1] nchar(12) '$.Readings."3.8.1"',
				[4_8_1] nchar(12) '$.Readings."4.8.1"',
				[0_4_2] nchar(12) '$.Readings."0.4.2"',
				[32_7] nchar(12) '$.Readings."32.7"',
				[52_7] nchar(12) '$.Readings."52.7"',
				[72_7] nchar(12) '$.Readings."72.7"',
				[1-1:32_36_0] nchar(12) '$.Readings."1-1:32.36.0"',
				[1-1:52_36_0] nchar(12) '$.Readings."1-1:52.36.0"',
				[1-1:72_36_0] nchar(12) '$.Readings."1-1:72.36.0"',
				[1-1:32_32_0] nchar(12) '$.Readings."1-1:32.32.0"',
				[1-1:52_32_0] nchar(12) '$.Readings."1-1:52.32.0"',
				[1-1:72_32_0] nchar(12) '$.Readings."1-1:72.32.0"',
				[16_7_0] nchar(12) '$.Readings."16.7.0"',
				[36_7_0] nchar(12) '$.Readings."36.7.0"',
				[56_7_0] nchar(12) '$.Readings."56.7.0"',
				[1_8_0] nchar(12) '$.Readings."1.8.0"')
				
	END TRY
	BEGIN CATCH
		PRINT 'Unhandled error in procedure...';
		THROW;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[ed_InsertGasReading]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/04/2020
-- Description:	Consume JSON Steam Readings
-- =============================================
CREATE PROCEDURE [dbo].[ed_InsertGasReading]
	@JSONData NVARCHAR(4000)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @_IdLocation AS INT
	DECLARE @_TimeStamp AS DATETIME
	DECLARE @_UtcRecieved AS DATETIME

	SET @_UtcRecieved = GETUTCDATE()

	BEGIN TRY
	-- Validate JSON
	IF (NOT ISJSON(@JSONData) > 0)  
		BEGIN
			PRINT 'ERROR: The JSON data is not valid.'  
			RETURN(1)  
		END
	-- Check the TimeStamp
	SELECT @_TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
	IF @_TimeStamp > DATEADD(HOUR, 24, GETDATE()) OR @_TimeStamp < DATEADD(DAY, -180, GETDATE())
		BEGIN
			PRINT 'ERROR: The TimeStamp is invalid, please check the controller time.'  
			RETURN(5)  
		END
	-- Make sure site serial serial exists
	SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@JSONData, '$.Header.Serial')
	IF @_IdLocation IS NULL
		BEGIN
			PRINT 'ERROR: The Generator Serial does not exist.'  
			RETURN(2)  
		END
	-- Does a record with the same TimeStamp exist
	IF (SELECT COUNT(*) FROM EnergyMeters.Steam
		WHERE TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
		AND IdLocation = @_IdLocation) > 0
		BEGIN
			PRINT 'ERROR: The record already exists.'  
			RETURN(4)  
		END
	ELSE

		-- Insert the data into the content table
		INSERT INTO EnergyMeters.Gas([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[MassFlow],[Totaliser])
		SELECT @_IdLocation,@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[MassFlow],[Totaliser]
		FROM OPENJSON(@JSONData)
			WITH (
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[MassFlow] float N'$.Readings.MassFlow',
				[Totaliser] float N'$.Readings.Totaliser')
				
	END TRY
	BEGIN CATCH
		PRINT 'Unhandled error in procedure...';
		THROW;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[ed_InsertGeneratorHistory]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 21/10/2019
-- Description:	Consume JSON History Logs
-- =============================================
CREATE PROCEDURE [dbo].[ed_InsertGeneratorHistory]
	@JSONData NVARCHAR(4000)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @_JSONExtended AS NVARCHAR(4000)
	DECLARE @_IdLocation AS INT
	DECLARE @_IdEvent AS INT
	DECLARE @_TimeStamp AS DATETIME
	DECLARE @_UtcRecieved AS DATETIME

	SET @_UtcRecieved = GETUTCDATE()

	DECLARE @CreatedEventId TABLE ([ID] [int]);

	BEGIN TRY
	-- Validate JSON
	IF (NOT ISJSON(@JSONData) > 0)  
		BEGIN
			PRINT 'ERROR: The JSON data is not valid.'  
			RETURN(1)  
		END
	-- Check the TimeStamp
	SELECT @_TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
	--IF @_TimeStamp > DATEADD(HOUR, 24, GETDATE()) OR @_TimeStamp < DATEADD(DAY, -180, GETDATE())
	--	BEGIN
	--		PRINT 'ERROR: The TimeStamp is invalid, please check the controller time.'  
	--		RETURN(5)  
	--	END
	-- Make sure site serial serial exists
	SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@JSONData, '$.Header.Serial')
	IF @_IdLocation IS NULL
		BEGIN
			PRINT 'ERROR: The Generator Serial does not exist.'  
			RETURN(2)  
		END
	-- Does the event id exist
	SELECT @_IdEvent = ID from dbo.HL_Events where REASON = JSON_VALUE(@JSONData, '$.Record.Reason')
	IF @_IdEvent IS NULL
		BEGIN
			PRINT 'ERROR: The Event does not exist. Creating..'
			INSERT INTO dbo.HL_Events
				OUTPUT INSERTED.ID
				INTO @CreatedEventId
				VALUES (JSON_VALUE(@JSONData, '$.Record.Reason'), null);

			SELECT TOP(1) @_IdEvent = ID from @CreatedEventId
		END
	-- Does a record with the same TimeStamp exist
	IF (SELECT COUNT(*) FROM dbo.GeneratorContent
		WHERE TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
		AND IdLocation = @_IdLocation AND IdEvent = @_IdEvent) > 0
		BEGIN
			PRINT 'ERROR: The record already exists.'  
			RETURN(4)  
		END
	ELSE
		-- Is it event json or standard data
		IF LEN(JSON_VALUE(@JSONData, '$.Content.Event')) > 0
			BEGIN
				PRINT 'INFO: Processing event.'
				-- Insert the data into the content table
				INSERT INTO GeneratorContent([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdEvent],[Event])
				SELECT @_IdLocation,GETUTCDATE(),[UtcGenerated],[TimeStamp],@_IdEvent,[Event]
				FROM OPENJSON(@JSONData)
					WITH (
						[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
						[TimeStamp] datetime N'strict $.Record.TimeStamp',
						[Event] nvarchar(256) N'$.Content.Event'
					)
					RETURN(0)
			END
		ELSE
		-- Check for either kwHour & Runhrs, or SumMWh
		-- Should be and 'OR' for kWhour and Runhrs, BAE needs Runhrs added.
		IF (JSON_VALUE(@JSONData, '$.Content.kWhour') IS NULL AND JSON_VALUE(@JSONData, '$.Content.Runhrs') IS NULL) AND JSON_VALUE(@JSONData, '$.Content.SumMWh') IS NULL
			BEGIN
				PRINT 'ERROR: The data must contain either kwHour & Runhrs, or SumMWh values.'  
				RETURN(6)  
			END
			-- Process the record
			BEGIN
				PRINT 'INFO: Processing data.'
				-- We want to save the undefined keys into the Extended column of the destination table, i.e. dynamic columns
				SET @_JSONExtended = JSON_QUERY(@JSONData,'$.Content');

				-- for each column in destination table, delete its json key, the remaining data will be the undefined keys
				DECLARE @MyCursor CURSOR;
				DECLARE @MyField NVARCHAR(128);
				BEGIN
					SET @MyCursor = CURSOR FOR
					SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_NAME = N'GeneratorContent'   

					OPEN @MyCursor 
					FETCH NEXT FROM @MyCursor 
					INTO @MyField

					WHILE @@FETCH_STATUS = 0
					BEGIN
					  --PRINT 'Removing::' + @MyField
					  SET @_JSONExtended=JSON_MODIFY(@_JSONExtended,'$.' + @MyField,NULL)
					  --PRINT @JSONExtended
					  FETCH NEXT FROM @MyCursor 
					  INTO @MyField 
					END; 

					CLOSE @MyCursor ;
					DEALLOCATE @MyCursor;
				END;

				-- Insert the data into the content table
				INSERT INTO GeneratorContent([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdEvent],[Event],[RPM],[Pwr],[PF],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[Mfrq],[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[MPF],[SRO],[VRO],[Mode],[kWhour],[Runhrs],[ActPwr],[ActDem],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5],[CylA6],[CylA7],[CylA8],[CylA9],[CylA10],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[CylB9],[CylB10],[BIN],[BOUT],[MVS],[ActPwrReq],[Ubat],[CPUT],[TEMv],[LChr],[OilB4F],[OilLev],[OilT],[CCPres],[AirInT],[RecAT],[ThrPos],[CH4],[JWTin],[JWTout],[Numstr],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BI12],[BO1],[BO2],[BO3],[BO4],[BO5],[Pmns],[Qmns],[ActPfi],[MLChr],[Amb],[kVarho],[GasP],[LTHWfT],[LTHWrT],[GFlwRte],[GFlwM3],[H2S],[NumUns],[PwrDem],[JWGKin],[HWFlo],[HWRtn],[GasMet],[IcOut],[ImpLoad],[Q],[U],[V],[W],[Grokwh],[Auxkwh],[TotRunPact],[TotRunPnomAll],[SumMWh],[Extended])
				SELECT @_IdLocation,@_UtcRecieved,[UtcGenerated],[TimeStamp],@_IdEvent,[Event],[RPM],[Pwr],[PF],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[Mfrq],[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[MPF],[SRO],[VRO],[Mode],[kWhour],[Runhrs],[ActPwr],[ActDem],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5],[CylA6],[CylA7],[CylA8],[CylA9],[CylA10],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[CylB9],[CylB10],[BIN],[BOUT],[MVS],[ActPwrReq],[Ubat],[CPUT],[TEMv],[LChr],[OilB4F],[OilLev],[OilT],[CCPres],[AirInT],[RecAT],[ThrPos],[CH4],[JWTin],[JWTout],[Numstr],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BI12],[BO1],[BO2],[BO3],[BO4],[BO5],[Pmns],[Qmns],[ActPfi],[MLChr],[Amb],[kVarho],[GasP],[LTHWfT],[LTHWrT],[GFlwRte],[GFlwM3],[H2S],[NumUns],[PwrDem],[JWGKin],[HWFlo],[HWRtn],[GasMet],[IcOut],[ImpLoad],[Q],[U],[V],[W],[Grokwh],[Auxkwh],[TotRunPact],[TotRunPnomAll],[SumMWh],LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@_JSONExtended, CHAR(32), ''), CHAR(10), ''), CHAR(13), ''), CHAR(9), '')))
				FROM OPENJSON(@JSONData)
					WITH (
						[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
						[TimeStamp] datetime N'strict $.Record.TimeStamp',
						[Event] nvarchar(256) N'$.Content.Event',
						[RPM] smallint N'$.Content.RPM',
						[Pwr] smallint N'$.Content.Pwr',
						[PF] float N'$.Content.PF',
						[Gfrq] float N'$.Content.Gfrq',
						[Vg1] smallint N'$.Content.Vg1',
						[Vg2] smallint N'$.Content.Vg2',
						[Vg3] smallint N'$.Content.Vg3',
						[Vg12] smallint N'$.Content.Vg12',
						[Vg23] smallint N'$.Content.Vg23',
						[Vg31] smallint N'$.Content.Vg31',
						[Ig1] smallint N'$.Content.Ig1',
						[Ig2] smallint N'$.Content.Ig2',
						[Ig3] smallint N'$.Content.Ig3',
						[Mfrq] float N'$.Content.Mfrq',
						[Vm1] smallint N'$.Content.Vm1',
						[Vm2] smallint N'$.Content.Vm2',
						[Vm3] smallint N'$.Content.Vm3',
						[Vm12] smallint N'$.Content.Vm12',
						[Vm23] smallint N'$.Content.Vm23',
						[Vm31] smallint N'$.Content.Vm31',
						[MPF] float N'$.Content.MPF',
						[SRO] float N'$.Content.SRO',
						[VRO] float N'$.Content.VRO',
						[Mode] char(3) N'$.Content.Mode',
						[kWhour] int N'$.Content.kWhour', --strict
						[Runhrs] int N'$.Content.Runhrs', --strict
						[ActPwr] smallint N'$.Content.ActPwr',
						[ActDem] smallint N'$.Content.ActDem',
						[CylA1] smallint N'$.Content.CylA1',
						[CylA2] smallint N'$.Content.CylA2',
						[CylA3] smallint N'$.Content.CylA3',
						[CylA4] smallint N'$.Content.CylA4',
						[CylA5] smallint N'$.Content.CylA5',
						[CylA6] smallint N'$.Content.CylA6',
						[CylA7] smallint N'$.Content.CylA7',
						[CylA8] smallint N'$.Content.CylA8',
						[CylA9] smallint N'$.Content.CylA9',
						[CylA10] smallint N'$.Content.CylA10',
						[CylB1] smallint N'$.Content.CylB1',
						[CylB2] smallint N'$.Content.CylB2',
						[CylB3] smallint N'$.Content.CylB3',
						[CylB4] smallint N'$.Content.CylB4',
						[CylB5] smallint N'$.Content.CylB5',
						[CylB6] smallint N'$.Content.CylB6',
						[CylB7] smallint N'$.Content.CylB7',
						[CylB8] smallint N'$.Content.CylB8',
						[CylB9] smallint N'$.Content.CylB9',
						[CylB10] smallint N'$.Content.CylB10',
						[BIN] nchar(16) N'$.Content.BIN',
						[BOUT] nchar(16) N'$.Content.BOUT',
						[MVS] float N'$.Content.MVS',
						[ActPwrReq] smallint N'$.Content.ActPwrReq',
						[Ubat] float N'$.Content.Ubat',
						[CPUT] float N'$.Content.CPUT',
						[TEMv] float N'$.Content.TEMv',
						[LChr] char(1) N'$.Content.LChr',
						[OilB4F] float N'$.Content.OilB4F',
						[OilLev] float N'$.Content.OilLev',
						[OilT] float N'$.Content.OilT',
						[CCPres] float N'$.Content.CCPres',
						[AirInT] float N'$.Content.AirInT',
						[RecAT] float N'$.Content.RecAT',
						[ThrPos] float N'$.Content.ThrPos',
						[CH4] float N'$.Content.CH4',
						[JWTin] float N'$.Content.JWTin',
						[JWTout] float N'$.Content.JWTout',
						[Numstr] smallint N'$.Content.Numstr',
						[BI1] nchar(8) N'$.Content.BI1',
						[BI2] nchar(8) N'$.Content.BI2',
						[BI3] nchar(8) N'$.Content.BI3',
						[BI4] nchar(8) N'$.Content.BI4',
						[BI5] nchar(8) N'$.Content.BI5',
						[BI6] nchar(8) N'$.Content.BI6',
						[BI7] nchar(8) N'$.Content.BI7',
						[BI8] nchar(8) N'$.Content.BI8',
						[BI9] nchar(8) N'$.Content.BI9',
						[BI10] nchar(8) N'$.Content.BI10',
						[BI11] nchar(8) N'$.Content.BI11',
						[BI12] nchar(8) N'$.Content.BI12',
						[BO1] nchar(8) N'$.Content.BO1',
						[BO2] nchar(8) N'$.Content.BO2',
						[BO3] nchar(8) N'$.Content.BO3',
						[BO4] nchar(8) N'$.Content.BO4',
						[BO5] nchar(8) N'$.Content.BO5',
						[Pmns] smallint N'$.Content.Pmns',
						[Qmns] smallint N'$.Content.Qmns',
						[ActPfi] smallint N'$.Content.ActPfi',
						[MLChr] char(1) N'$.Content.MLChr',
						[Amb] float N'$.Content.Amb',
						[kVarho] int N'$.Content.kVarho',
						[GasP] float N'$.Content.GasP',
						[LTHWfT] float N'$.Content.LTHWfT',
						[LTHWrT] float N'$.Content.LTHWrT',
						[GFlwRte] float N'$.Content.GFlwRte',
						[GFlwM3] int N'$.Content.GFlwM3',
						[H2S] smallint N'$.Content.H2S',
						[NumUns] smallint N'$.Content.NumUns',
						[PwrDem] smallint N'$.Content.PwrDem',
						[JWGKin] float N'$.Content.JWGKin',
						[HWFlo] float N'$.Content.HWFlo',
						[HWRtn] float N'$.Content.HWRtn',
						[GasMet] int N'$.Content.GasMet',
						[IcOut] smallint N'$.Content.IcOut',
						[ImpLoad] smallint N'$.Content.ImpLoad',
						[Q] float N'$.Content.Q',
						[U] float N'$.Content.U',
						[V] float N'$.Content.V',
						[W] float N'$.Content.W',
						[Grokwh] int N'$.Content.Grokwh',
						[Auxkwh] int N'$.Content.Auxkwh',
						[TotRunPact] smallint N'$.Content.TotRunPact',
						[TotRunPnomAll] smallint N'$.Content.TotRunPnomAll',
						[SumMWh] smallint N'$.Content.SumMWh')
				
				-- Update Updates Table
				UPDATE GeneratorContentUpdates SET UtcRecieved = @_UtcRecieved, UtcGenerated = JSON_VALUE(@JSONData, '$.Header.UtcGenerated'), TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp') WHERE IdLocation = @_IdLocation
				IF @@ROWCOUNT=0
					INSERT INTO GeneratorContentUpdates VALUES (@_IdLocation, @_UtcRecieved, JSON_VALUE(@JSONData, '$.Header.UtcGenerated'), JSON_VALUE(@JSONData, '$.Record.TimeStamp'))
				END
	END TRY
	BEGIN CATCH
		PRINT 'Unhandled error in procedure...';
		THROW;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[ed_InsertHeatReading]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/04/2020
-- Description:	Consume JSON Steam Readings
-- =============================================
CREATE PROCEDURE [dbo].[ed_InsertHeatReading]
	@JSONData NVARCHAR(4000)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @_IdLocation AS INT
	DECLARE @_TimeStamp AS DATETIME
	DECLARE @_UtcRecieved AS DATETIME

	SET @_UtcRecieved = GETUTCDATE()

	BEGIN TRY
	-- Validate JSON
	IF (NOT ISJSON(@JSONData) > 0)  
		BEGIN
			PRINT 'ERROR: The JSON data is not valid.'  
			RETURN(1)  
		END
	-- Check the TimeStamp
	SELECT @_TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
	IF @_TimeStamp > DATEADD(HOUR, 24, GETDATE()) OR @_TimeStamp < DATEADD(DAY, -180, GETDATE())
		BEGIN
			PRINT 'ERROR: The TimeStamp is invalid, please check the controller time.'  
			RETURN(5)  
		END
	-- Make sure site serial serial exists
	SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@JSONData, '$.Header.Serial')
	IF @_IdLocation IS NULL
		BEGIN
			PRINT 'ERROR: The Generator Serial does not exist.'  
			RETURN(2)  
		END
	-- Does a record with the same TimeStamp exist
	IF (SELECT COUNT(*) FROM EnergyMeters.Steam
		WHERE TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
		AND IdLocation = @_IdLocation) > 0
		BEGIN
			PRINT 'ERROR: The record already exists.'  
			RETURN(4)  
		END
	ELSE

		-- Insert the data into the content table
		INSERT INTO EnergyMeters.Heat([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[Power],[Energy],[Flow],[TempWarm],[TempCold])
		SELECT @_IdLocation,@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[Power],[Energy],[Flow],[TempWarm],[TempCold]
		FROM OPENJSON(@JSONData)
			WITH (
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[Power] float N'$.Readings.Power',
				[Energy] float N'$.Readings.Energy',
				[Flow] float N'$.Readings.Flow',
				[TempWarm] float N'$.Readings.TempWarm',
				[TempCold] float N'$.Readings.TempCold')
				
	END TRY
	BEGIN CATCH
		PRINT 'Unhandled error in procedure...';
		THROW;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[ed_InsertSteamReading]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 08/04/2020
-- Description:	Consume JSON Steam Readings
-- =============================================
CREATE PROCEDURE [dbo].[ed_InsertSteamReading]
	@JSONData NVARCHAR(4000)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @_IdLocation AS INT
	DECLARE @_TimeStamp AS DATETIME
	DECLARE @_UtcRecieved AS DATETIME

	SET @_UtcRecieved = GETUTCDATE()

	BEGIN TRY
	-- Validate JSON
	IF (NOT ISJSON(@JSONData) > 0)  
		BEGIN
			PRINT 'ERROR: The JSON data is not valid.'  
			RETURN(1)  
		END
	-- Check the TimeStamp
	SELECT @_TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
	IF @_TimeStamp > DATEADD(HOUR, 24, GETDATE()) OR @_TimeStamp < DATEADD(DAY, -180, GETDATE())
		BEGIN
			PRINT 'ERROR: The TimeStamp is invalid, please check the controller time.'  
			RETURN(5)  
		END
	-- Make sure site serial serial exists
	SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@JSONData, '$.Header.Serial')
	IF @_IdLocation IS NULL
		BEGIN
			PRINT 'ERROR: The Generator Serial does not exist.'  
			RETURN(2)  
		END
	-- Does a record with the same TimeStamp exist
	IF (SELECT COUNT(*) FROM EnergyMeters.Steam
		WHERE TimeStamp = JSON_VALUE(@JSONData, '$.Record.TimeStamp')
		AND IdLocation = @_IdLocation) > 0
		BEGIN
			PRINT 'ERROR: The record already exists.'  
			RETURN(4)  
		END
	ELSE

		-- Insert the data into the content table
		INSERT INTO EnergyMeters.Steam([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[Power],[VolFlow],[MassFlow],[Temp],[Pressure],[Energy])
		SELECT @_IdLocation,@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[Power],[VolFlow],[MassFlow],[Temp],[Pressure],[Energy]
		FROM OPENJSON(@JSONData)
			WITH (
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[Power] float N'$.Readings.Power',
				[VolFlow] float N'$.Readings.VolFlow',
				[MassFlow] float N'$.Readings.MassFlow',
				[Temp] float N'$.Readings.Temp',
				[Pressure] float N'$.Readings.Pressure',
				[Energy] float N'$.Readings.Energy')
				
	END TRY
	BEGIN CATCH
		PRINT 'Unhandled error in procedure...';
		THROW;
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTime_GetUpDownTimes]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <14/02/2012>
-- Description:	<Returns the Uptime and Downtime for a specific Exempt>
-- =============================================
CREATE PROCEDURE [dbo].[ed_LoadTime_GetUpDownTimes] 
	-- Add the parameters for the stored procedure here
	@ID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DtStart, DtFullLoad
	FROM dbo.LoadTimes
	WHERE ID=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTimes_GetById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_LoadTimes_GetById]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
SET NOCOUNT ON;
	
	SELECT 
	ID,
	ID_Location,
	IDStart,
	IDFullLoad,
	DtStart,
	DtFullLoad,
	TimeDifference,
	IsExempt,
	'YesNo' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END,
	Reason,
	ISNULL(Exclude, 0) AS Exclude
	FROM LoadTimes
	WHERE ID_Location = @location
	--AND (Exclude IS NULL OR Exclude = 0)
	AND DtStart between @begin and @end
	order by DtStart
END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTimes_GetByIdPdf]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			
-- Create date: 08/01/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ed_LoadTimes_GetByIdPdf]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
	SET NOCOUNT ON;
	
		SELECT DtStart As Start, DtFullLoad As 'Full Load', TimeDifference As 'Duration(min)',
			'Is Exempt?' = CASE(IsExempt) WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE 'Unverified' END,
			Details as Notes
		FROM LoadTimes
		WHERE ID_LOCATION = @LOCATION
		AND (Exclude IS NULL OR Exclude = 0)
		AND DtStart between @begin and @end
		ORDER BY DtStart
END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTimes_Reset]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 21/02/2012
-- Description:	Resets Exempt Details to the Original
-- =============================================
CREATE PROCEDURE [dbo].[ed_LoadTimes_Reset] 
	@ID INT
AS
BEGIN
	SET NOCOUNT ON;
	
		DECLARE @ORIG DATETIME
		
		SELECT @ORIG=OrigDtFullLoad --Assign Var
		FROM dbo.LoadTimes
		WHERE ID=@ID
	
		IF @ORIG IS NOT NULL
			UPDATE dbo.LoadTimes
			SET DtFullLoad=OrigDtFullLoad, TimeDifference=DATEDIFF(minute, DtStart, OrigDtFullLoad)
			WHERE ID=@ID

END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTimes_Update]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 14/02/2012
-- Description:	Update DTDOWN
-- =============================================
CREATE PROCEDURE [dbo].[ed_LoadTimes_Update]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@NEWDT DATETIME,
	@DIFF INT,
	@REASON NVARCHAR(18),
	@DTUPDOWN BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @DTUPDOWN=1
		UPDATE dbo.LoadTimes
		SET DtStart=@NEWDT, TimeDifference=@DIFF, Reason=@REASON
		WHERE ID=@ID
	ELSE
		UPDATE dbo.LoadTimes --Store Original Value
		SET OrigDtFullLoad=COALESCE(OrigDtFullLoad, DtFullLoad)
		WHERE ID=@ID
		UPDATE dbo.LoadTimes --Now Update
		SET DtFullLoad=@NEWDT, TimeDifference=@DIFF
		WHERE ID=@ID	
END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTimes_UpdateDetailsById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 14/02/2012
-- Description:	Writes a Description for Exempt of specific ID
-- =============================================
CREATE PROCEDURE [dbo].[ed_LoadTimes_UpdateDetailsById]
	-- Add the parameters for the stored procedure here
	@ID INT,
	@DETAILS NVARCHAR(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE dbo.LoadTimes
	SET Details=@DETAILS
	WHERE ID=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTimes_UpdateIsExcludedById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE Procedure [dbo].[ed_LoadTimes_UpdateIsExcludedById]
	@ID_LoadTime AS INT,
	@Exclude AS BIT
AS
BEGIN
	SET NOCOUNT ON;
	
	update LoadTimes
	set Exclude=@Exclude
	where ID=@ID_LoadTime
	   
END
GO
/****** Object:  StoredProcedure [dbo].[ed_LoadTimes_UpdateIsExemptById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ed_LoadTimes_UpdateIsExemptById]
	@ID INT,
	@IsExempt BIT
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE LoadTimes
    SET IsExempt=@IsExempt
    WHERE ID=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[getExemptTimes]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 15/02/2012
-- Description:	Returns Downtime, Uptime and Reason for selected ID
-- =============================================
CREATE PROCEDURE [dbo].[getExemptTimes] 
	-- Add the parameters for the stored procedure here
	@ID INT
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT DtDown, DtUp, TimeDifference
		FROM dbo.Exempts
		WHERE ID=@id
END
GO
/****** Object:  StoredProcedure [dbo].[GetFullLoadTimes_dafan2]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		paulo-villa
-- Create date: 08/01/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetFullLoadTimes_dafan2]
AS
BEGIN
	SET NOCOUNT ON;

declare @id int
declare @idrange int
declare @timestamp datetime
declare @idlocation int
declare @idevent int

declare @event1 int
declare @event2 int
declare @event3 int
declare @event4 int
declare @event5 int
declare @event6 int

set @event1 = 89 --Hst Run Signal 2nd
set @event2 = 2388
--set @event2 = 2280 --Full Load
--set @event3 = 2282 --Full Load
--set @event4 = 2281 --Full Load
--set @event5 = 2283 --Full Load
--set @event6 = 2278 --Full Load

declare @tmptbl TABLE
(
	ID_Location int,
	idStart int,
	idFullLoad int,
	dtStart datetime,
	dtFullLoad datetime,
	Reason nvarchar(200)
);

declare cur1 cursor fast_forward
for
	select id, time_stamp, id_event, id_location
	from HL_Logs
	where ID_Event = @event1
	and id_location = 245
	order by time_stamp asc
open cur1

fetch next from cur1
into @id,@timestamp,@idevent,@idlocation

while @@FETCH_STATUS = 0
begin
	insert into @tmptbl
	select top 1 ID_Location, @id as idStart, id as idFullLoad, @timestamp as dtStart, time_stamp as dtFullLoad, ISNULL(
				(SELECT TOP 1 ISNULL(EV.LABEL,EV.REASON) AS REASON
				 FROM HL_LOGS, HL_EVENTS AS EV 
				 WHERE EV.ID = ID_EVENT 
				 AND ID_LOCATION = @idlocation
				 AND Time_Stamp <= (Select Time_stamp FROM HL_Logs WHERE ID = @id)
				 AND ID_EVENT NOT IN (
					SELECT dbo.HL_Events.ID AS ID_EVENT
					FROM dbo.HL_Events INNER JOIN
						dbo.CategorizedEvents ON dbo.HL_Events.ID = dbo.CategorizedEvents.ID_Event INNER JOIN
						dbo.EventCategory ON dbo.CategorizedEvents.ID_Category = dbo.EventCategory.ID
					WHERE (dbo.CategorizedEvents.ID_Category = 1)
				 )
				 ORDER BY TIME_STAMP DESC),
			'UNKNOWN') AS REASON from HL_Logs
	where Time_Stamp > @timestamp
	and Time_Stamp < getdate()
	and ID_Event = @event2
	and ID_Location = @idlocation
	order by Time_Stamp asc

	fetch next from cur1
	into @id,@timestamp,@idevent,@idlocation
end

insert into LoadTimes(ID_Location, IDStart, IDFullLoad, DTStart, DTFullLoad, TimeDifference, Reason)
select ID_Location, idStart, idFullLoad, dtStart, dtFullLoad, DATEDIFF(MINUTE, dtStart, dtFullLoad) as timedifference, Reason
from @tmptbl

except  
	select ID_Location, IDStart, IDFullLoad, DTStart, DTFullLoad, TimeDifference, Reason from LoadTimes

	
close cur1
deallocate cur1

Print('End of function: GetSTORFullLoadTime')

END
GO
/****** Object:  StoredProcedure [dbo].[GetGeneratorHistoryById]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 14/01/2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetGeneratorHistoryById]
	@location int,
	@begin datetime,
	@end datetime
AS
BEGIN
	SET NOCOUNT ON;

SELECT t1.Id
      ,[TimeStamp]
      ,t2.GENSETNAME AS Generator
      ,t3.REASON AS Reason
      ,[IdLocation]
      ,[UtcRecieved]
      ,[UtcGenerated]
      ,[TimeStamp]
      ,[IdEvent]
      ,[Event]
      ,[Extended]
      ,[RPM]
      ,[Pwr]
      ,[PF]
      ,[Gfrq]
      ,[Vg1]
      ,[Vg2]
      ,[Vg3]
      ,[Vg12]
      ,[Vg23]
      ,[Vg31]
      ,[Ig1]
      ,[Ig2]
      ,[Ig3]
      ,[Mfrq]
      ,[Vm1]
      ,[Vm2]
      ,[Vm3]
      ,[Vm12]
      ,[Vm23]
      ,[Vm31]
      ,[MPF]
      ,[SRO]
      ,[VRO]
      ,[Mode]
      ,[kWhour]
      ,[Runhrs]
      ,[ActPwr]
      ,[ActDem]
      ,[CylA1]
      ,[CylA2]
      ,[CylA3]
      ,[CylA4]
      ,[CylA5]
      ,[CylA6]
      ,[CylA7]
      ,[CylA8]
      ,[CylA9]
      ,[CylA10]
      ,[CylB1]
      ,[CylB2]
      ,[CylB3]
      ,[CylB4]
      ,[CylB5]
      ,[CylB6]
      ,[CylB7]
      ,[CylB8]
      ,[CylB9]
      ,[CylB10]
      ,[BIN]
      ,[BOUT]
      ,[MVS]
      ,[ActPwrReq]
      ,[Ubat]
      ,[CPUT]
      ,[TEMv]
      ,[LChr]
      ,[OilB4F]
      ,[OilLev]
      ,[OilT]
      ,[CCPres]
      ,[AirInT]
      ,[RecAT]
      ,[ThrPos]
      ,[CH4]
      ,[JWTin]
      ,[JWTout]
      ,[Numstr]
      ,[BI1]
      ,[BI2]
      ,[BI3]
      ,[BI4]
      ,[BI5]
      ,[BI6]
      ,[BI7]
      ,[BI8]
      ,[BI9]
      ,[BI10]
      ,[BI11]
      ,[BI12]
      ,[BO1]
      ,[BO2]
      ,[BO3]
      ,[BO4]
      ,[BO5]
      ,[Pmns]
      ,[Qmns]
      ,[ActPfi]
      ,[MLChr]
      ,[Amb]
      ,[kVarho]
      ,[GasP]
      ,[LTHWfT]
      ,[LTHWrT]
      ,[GFlwRte]
      ,[GFlwM3]
      ,[H2S]
      ,[NumUns]
      ,[PwrDem]
      ,[JWGKin]
      ,[HWFlo]
      ,[HWRtn]
      ,[GasMet]
      ,[IcOut]
      ,[ImpLoad]
      ,[Q]
      ,[U]
      ,[V]
      ,[W]
      ,[Grokwh]
      ,[Auxkwh]
      ,[TotRunPact]
      ,[TotRunPnomAll]
      ,[SumMWh]
	  
		FROM GeneratorContent t1
		INNER JOIN HL_Locations t2
		ON t1.IdLocation = t2.ID
		INNER JOIN HL_Events t3
		ON t1.IdEvent = t3.ID
		WHERE t1.IdLocation = @location
		AND TimeStamp BETWEEN @begin AND @end
		ORDER BY t1.TimeStamp ASC
			
END
GO
/****** Object:  StoredProcedure [dbo].[getIDsOfBB_SN]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil A. Rutherford>
-- Create date: <17/01/2012>
-- Description:	<Returns live binary status info for a site>
-- =============================================
CREATE PROCEDURE [dbo].[getIDsOfBB_SN] 
	
	@BB_SN nvarchar(9)

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT ID FROM HL_Locations WHERE BLACKBOX_SN = @BB_SN
	
END
GO
/****** Object:  StoredProcedure [dbo].[GETLABELEDCOLUMNS]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETLABELEDCOLUMNS]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT COLUMNNAME, COLUMNLABEL
	FROM COLUMNLABELS 
	WHERE COLUMNLABEL <> '' 
	ORDER BY COLUMNLABEL
	
END
GO
/****** Object:  StoredProcedure [dbo].[getLoadTimeDetails]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 14/02/2012
-- Description:	Reads a Description for Exempt of specific ID
-- =============================================
CREATE PROCEDURE [dbo].[getLoadTimeDetails]
	-- Add the parameters for the stored procedure here
	@ID INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Details
	FROM dbo.LoadTimes
	WHERE ID=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[getLogBout3]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil A. Rutherford>
-- Create date: <17/01/2012>
-- Description:	<Returns live binary status info for a site>
-- =============================================
CREATE PROCEDURE [dbo].[getLogBout3] 
	
	@ID_Location int

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT chp_Status from BB_LiveAlarms
	WHERE ID_Location = @ID_Location
	
END
GO
/****** Object:  StoredProcedure [dbo].[getMeterEnergyByHoursOfDay]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[getMeterEnergyByHoursOfDay]
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@Modbus_Addr int,
	@Day datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT MAX(CONVERT(FLOAT,[Energy.'+ CONVERT(varchar, @Modbus_Addr) +'])) - MIN(CONVERT(FLOAT,[Energy.'+ CONVERT(varchar, @Modbus_Addr) +'])) AS TotalEnergy, DATEPART(hh,Timestamp) AS HR, DAY(Timestamp) AS DY, MONTH(Timestamp) AS MTH, YEAR(Timestamp) AS YR
				FROM EnergyMeters 
				WHERE [Energy.'+ CONVERT(varchar, @Modbus_Addr) +'] IS NOT NULL AND CONVERT(varchar, Timestamp, 110) = '''+ CONVERT(varchar, @Day, 110) +''' AND ID_LOCATION = '+ CONVERT(varchar, @ID_Location) +'
				GROUP BY DAY(Timestamp), DATEPART(hh,Timestamp), MONTH(Timestamp), YEAR(Timestamp)
				ORDER BY HR';
				
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[getMeterEnergyByMonthsOfYear]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[getMeterEnergyByMonthsOfYear]
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@Modbus_Addr int,
	@Year datetime
	
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT MAX(CONVERT(FLOAT,[Energy.'+ CONVERT(varchar, @Modbus_Addr) +'])) - MIN(CONVERT(FLOAT,[Energy.'+ CONVERT(varchar, @Modbus_Addr) +'])) AS TotalEnergy, MONTH(Timestamp) AS MTH, YEAR(Timestamp) AS YR
				FROM EnergyMeters 
				WHERE [Energy.'+ CONVERT(varchar, @Modbus_Addr) +'] IS NOT NULL AND YEAR(Timestamp)='''+ CONVERT(varchar(4), @Year, 20) +''' AND ID_LOCATION = '+ CONVERT(varchar, @ID_Location) +'
				GROUP BY YEAR(Timestamp), MONTH(Timestamp)
				ORDER BY MTH;'
     exec sp_executesql @sql
END
GO
/****** Object:  StoredProcedure [dbo].[getMeterEnergyData]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Rutherford
-- Create date: 02/02/2015
-- Description:	Get the total 
-- =============================================
CREATE PROCEDURE [dbo].[getMeterEnergyData]
	-- Add the parameters for the stored procedure here
	@ID_Location int,
	@Modbus_Addr int,
	@Start_Date datetime,
	@End_Date datetime
AS
BEGIN
	
	 declare @sql nvarchar(4000);
	 set @sql='SELECT [Timestamp] AS TimeStamp, [Power.'+ CONVERT(varchar, @Modbus_Addr) +'] AS [Power], [Energy.'+ CONVERT(varchar, @Modbus_Addr) +'] AS Energy, [FlowVol.'+ CONVERT(varchar, @Modbus_Addr) +'] AS FlowVol, [TempWarm.'+ CONVERT(varchar, @Modbus_Addr) +'] AS TempWarm, [TempCold.'+ CONVERT(varchar, @Modbus_Addr) +'] AS TempCold
			   FROM EnergyMeters
			   WHERE Timestamp BETWEEN '''+ CONVERT(varchar, @Start_Date, 110) +''' AND '''+ CONVERT(varchar, @End_Date, 110) +''' AND ID_LOCATION = '+ CONVERT(varchar, @ID_Location) +'
			   ORDER BY Timestamp;'
			   
     exec sp_executesql @sql

END
GO
/****** Object:  StoredProcedure [dbo].[getModbusLinkState]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil A. Rutherford>
-- Create date: <17/01/2012>
-- Description:	<Returns live binary status info for a site>
-- =============================================
CREATE PROCEDURE [dbo].[getModbusLinkState] 
	
	@ID_Location int

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT ST_ComapLink from BB_UnitStatus
	WHERE ID_Location = @ID_Location
	
END
GO
/****** Object:  StoredProcedure [dbo].[getNonUpdatingUnits]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <19-06-2014>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getNonUpdatingUnits] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ID, GENSETNAME, SITENAME, BLACKBOX_SN, LASTUPDATE, BLACLBOX_LASTPING = (SELECT ST_LastStatusUpdateTime FROM Blackboxes WHERE BB_SerialNo = BLACKBOX_SN) , 
		DATEDIFF(DAY, LASTUPDATE, GETDATE()) AS NumberOfDays
			FROM HL_Locations WHERE LASTUPDATE < DATEADD(HOUR, -24, GETDATE())
				AND GensetEnabled = 1 ORDER BY GENSETNAME
END
GO
/****** Object:  StoredProcedure [dbo].[GETPAGESBYROLES]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETPAGESBYROLES]
	@ROLES string_list_tbltype
READONLY AS
BEGIN
	SET NOCOUNT ON;

    SELECT FilePageName 
	FROM RolesAccess
	WHERE RoleName IN (SELECT S FROM @ROLES)
	GROUP BY FilePageName
END
GO
/****** Object:  StoredProcedure [dbo].[getperfGasMeterAddr]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getperfGasMeterAddr]
	@location int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Modbus_Addr FROM GasMeters_Mapping WHERE ID_Location=@location
END
GO
/****** Object:  StoredProcedure [dbo].[getRecordsCount]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil A. Rutherford
-- Create date: 07-09-2012
-- Description:	Counts the number of records per day over a date range
-- =============================================
CREATE PROCEDURE [dbo].[getRecordsCount] 
	@LOCATION as INT,
	@BEGIN as datetime,
	@END as datetime
	AS
BEGIN
	SET NOCOUNT ON;
	
	WITH CTE_Dates AS 
	( 
    SELECT @BEGIN AS cte_date 
    UNION ALL 
    SELECT DATEADD(DAY, 1, cte_date) 
    FROM CTE_Dates 
    WHERE DATEADD(DAY, 1, cte_date) <= @END 
	) 
	
	SELECT 
	ISNULL(COUNT(*), 0) AS counted_leads,  
	cte_date as TIME_STAMP  
	FROM CTE_Dates 
	LEFT JOIN HL_Logs ON DATEADD(dd, 0, DATEDIFF(dd, 0, Time_Stamp)) = cte_date 
	WHERE Time_Stamp >= @BEGIN and Time_Stamp < @END and ID_Location = @LOCATION
	AND ID_Event = 182
	GROUP BY cte_date 
END
GO
/****** Object:  StoredProcedure [dbo].[getSitename]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 02/08/2012
-- Description:	Get Genset name from ID
-- =============================================
CREATE PROCEDURE [dbo].[getSitename]
	@IDLOCATION AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT SITENAME
	FROM HL_Locations
	WHERE ID = @IDLOCATION
END
GO
/****** Object:  StoredProcedure [dbo].[getSMSLog]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getSMSLog] 
	@BEGIN DATETIME,
	@END DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	
	

	SELECT ID, (SELECT GENSETNAME FROM HL_Locations WHERE ID = ID_LOCATION) AS Genset,SMS_SendTime,SMS_Recipient, SMS_Content
	FROM BB_SMSLog
	WHERE SMS_SendTime BETWEEN @BEGIN AND @END
	ORDER BY SMS_SendTime DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GETSUMMARY]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		paulo-villa
-- Create date: 18/01/2010
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GETSUMMARY] 
	@STARTDT AS DATE,
	@ENDDT AS DATE
AS
BEGIN
	SET NOCOUNT ON;

SELECT LOGS.ID_LOCATION, LOC.GENSETNAME,/* 
		ContractInformation.ContractOutput,ContractInformation.DutyCycle,*/
		/*(SELECT (SELECT TOP 1 CONVERT(FLOAT,ISNULL(Runhrs,Runho)) FROM [ReportingSystem].[dbo].[HL_Logs] WHERE Time_Stamp BETWEEN @STARTDT AND @ENDDT and Runhrs IS NOT NULL
		order by Time_Stamp desc) - (SELECT TOP 1 CONVERT(FLOAT,ISNULL(Runhrs,Runho)) FROM [ReportingSystem].[dbo].[HL_Logs]
		WHERE Time_Stamp BETWEEN @STARTDT AND @ENDDT and Runhrs IS NOT NULL
		order by Time_Stamp ASC)) AS HOURSRUN,*/
		
		MAX(CONVERT(FLOAT,ISNULL(Runhrs,Runho))) - MIN(CONVERT(FLOAT,ISNULL(Runhrs,Runho))) AS HOURSRUN,
		
		(MAX(CONVERT(FLOAT,LOGS.KWHOUR)) - MIN(CONVERT(FLOAT,LOGS.KWHOUR)))AS KWPRODUCED,
		(
		SELECT  COUNT(IDDOWN)
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.ID_LOCATION
		GROUP BY ID_LOCATION
		)  AS NOSTOPS,
		(
		SELECT  MIN(DTUP)
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.ID_LOCATION
		GROUP BY ID_LOCATION
		)  AS FIRSTSTART,
		(
		SELECT  MAX(DTDOWN) 
		FROM EXEMPTS AS EX
		WHERE CONVERT(VARCHAR,EX.DTDOWN,111) <= @ENDDT
		AND CONVERT(VARCHAR,EX.DTUP,111) >= @STARTDT
		AND EX.ID_LOCATION = LOGS.ID_LOCATION
		GROUP BY ID_LOCATION
		)  AS LASTSTOP
FROM dbo.HL_Logs AS LOGS 
	INNER JOIN dbo.HL_Locations AS LOC 
	ON LOGS.ID_Location = LOC.ID 
	--LEFT OUTER JOIN dbo.ContractInformation 
	--ON LOC.ID_ContractInformation = dbo.ContractInformation.ID

WHERE CONVERT(VARCHAR,TIME_STAMP,111) BETWEEN @STARTDT AND @ENDDT
AND LOC.ID = LOGS.ID_LOCATION
GROUP BY LOGS.ID_LOCATION,LOC.GENSETNAME--,ContractInformation.ContractOutput,ContractInformation.DutyCycle
ORDER BY LOC.GENSETNAME
END
GO
/****** Object:  StoredProcedure [dbo].[GraphEventsDay]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GraphEventsDay]
	-- Add the parameters for the stored procedure here
	@BEGIN DATETIME,
	@END DATETIME,
	@ID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT COUNT(*) AS EVENT_CNT, CONVERT(VARCHAR,TIME_STAMP,103) AS TIME_STAMP 
	FROM HL_LOGS 
	WHERE TIME_STAMP BETWEEN @BEGIN AND @END AND ID_LOCATION = @ID and ID_Event <> 182
	GROUP BY CONVERT(VARCHAR,TIME_STAMP,103), CONVERT(VARCHAR,TIME_STAMP,111) 
	ORDER BY CONVERT(VARCHAR,TIME_STAMP,111)
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[import_DynNormalizeData]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil-Rutherford
-- Create date: 17/12/2009
-- Description:	Convert the data from HistoryLog table to the SQL Normalized Structure
-- =============================================
CREATE PROCEDURE [dbo].[import_DynNormalizeData]
AS
BEGIN

DECLARE @intErrorCode INT

BEGIN TRANSACTION

INSERT INTO HL_Events(REASON)
SELECT DISTINCT REASON
FROM HistoryLog
WHERE REASON NOT IN
(SELECT DISTINCT REASON FROM HL_Events)

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

INSERT INTO HL_Locations(GENSET_SN, GENSETNAME, SITENAME)
SELECT DISTINCT GENSET_SN, 'UNNAMED' AS GENSITENAME, 'UNNAMED' AS SITENAME
FROM HistoryLog
WHERE GENSET_SN NOT IN
(SELECT DISTINCT GENSET_SN FROM HL_Locations)

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

-- Match columns in HL_Logs with HistoryLog ------------------------------------------------------------------------------------------

IF (SELECT COUNT(COLUMN_NAME)-(SELECT COUNT(COLUMN_NAME) - 4 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='HL_Logs')
	 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='HistoryLog') > 0
BEGIN
		declare @column_name nvarchar(50)

		declare cur1 cursor fast_forward
		for
			SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='HistoryLog'
			AND COLUMN_NAME NOT IN (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='HL_Logs')	
			
		open cur1

		fetch next from cur1
		into @column_name

		while @@FETCH_STATUS = 0
		begin
		if (@column_name <> 'HL_Processed')
			execute('ALTER TABLE HL_Logs ADD [' + @column_name + '] nvarchar(50)')
			--print @column_name
			fetch next from cur1
			into @column_name
		end

		close cur1
		deallocate cur1
 
END

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

---- Lets try and get the column name to a string
	DECLARE @c varchar(8000), @t varchar(128)
	SET @c = ''

	SET @t='HistoryLog'


	SELECT @c = @c + ', [' + c.name + ']'
		FROM syscolumns c INNER JOIN sysobjects o ON o.id = c.id

		WHERE o.name = @t and c.name <> 'HL_Processed'
		ORDER BY colid

	SET @c = Substring(@c, 85, Datalength(@c) - 2)
	--Just at RPM,
	SELECT @c

--Normalize the data for logs
execute('INSERT INTO HL_Logs(Time_Stamp, ID_Location, ID_Event
			  ,[EVENT], ' + @c +')
SELECT CONVERT(DATETIME, HL.ItemDATE + HL.ItemTIME) AS Time_Stamp,
	LOC.ID AS ID_Location,
	EV.ID AS ID_Event
	  ,[EVENT], ' + @c +'
FROM HistoryLog AS HL, HL_Locations AS LOC, HL_Events AS EV
WHERE HL.GENSET_SN = LOC.GENSET_SN
AND HL.REASON = EV.REASON and HL_Processed is NULL
EXCEPT
	(SELECT convert(varchar, Time_Stamp, 120), ID_Location, ID_Event
			  ,[EVENT], ' + @c +'
     FROM HL_Logs)')
		
		

SELECT @intErrorCode = @@ERROR
IF (@intErrorCode <> 0) GOTO PROBLEM

--No Problems
COMMIT TRANSACTION
update HistoryLog
set HL_Processed = 1
where HL_Processed IS NULL
GOTO FINISH

PROBLEM:
	IF (@intErrorCode <> 0) BEGIN
		PRINT 'Unexpected error occurred!'
		PRINT @@ERROR
		ROLLBACK TRANSACTION
	END
	
FINISH:
Print('End of function: NORMALIZEDATA')
END
GO
/****** Object:  StoredProcedure [dbo].[p_rename_columns]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <12/9/2011>
-- Description:	<Renames tables columns from first row of records (CSV)>
-- =============================================
CREATE PROCEDURE [dbo].[p_rename_columns] (@table sysname) 
AS 
 
declare @name sysname,  
        @col sysname, 
        @sql nvarchar(max) 
 
declare cur cursor  
local read_only  
for select name  
      from sys.columns  
     where object_id = object_id(@table) 
 
open cur 
fetch next from cur into @name 
 
while @@fetch_status = 0  
  begin 
    
    select @sql = N'select top (1) @col = ' + @name + N' from ' + @table 

    exec sp_executesql @sql, N'@col sysname output', @col output 
 
    select @sql = N'exec sp_rename ''' + quotename(@table) + N'.' + quotename(@name) + N''', ''' + @col + N'''' 
    exec (@sql) 
 
    fetch next from cur into @name 
  end  
close cur 
deallocate cur 
 
select @sql = N'DELETE TOP (1) from ' + quotename(@table) 
exec (@sql)
GO
/****** Object:  StoredProcedure [dbo].[sms_getNumber]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sms_getNumber] 
	-- Add the parameters for the stored procedure her
	@BLACKBOX_SN nvarchar(9)
AS
BEGIN

	SET NOCOUNT ON;
	
	declare @ID_Location integer
	
	SELECT @ID_Location = ID 
	FROM HL_Locations 
	WHERE BLACKBOX_SN = @BLACKBOX_SN
	
	SELECT SMS_Recipient FROM sms_Mapping WHERE ID = (
		SELECT ID_SMS_Group FROM HL_Locations WHERE ID = @ID_Location)
	
END
GO
/****** Object:  StoredProcedure [dbo].[sms_Mappings]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sms_Mappings]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ID,SMS_Group,SMS_Recipient
	FROM sms_Mapping
	ORDER BY SMS_Group
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FindStringInTable]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[sp_FindStringInTable] @stringToFind VARCHAR(100), @schema sysname, @table sysname 
AS

BEGIN TRY
   DECLARE @sqlCommand varchar(max) = 'SELECT * FROM [' + @schema + '].[' + @table + '] WHERE ' 
	   
   SELECT @sqlCommand = @sqlCommand + '[' + COLUMN_NAME + '] LIKE ''' + @stringToFind + ''' OR '
   FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = @schema
   AND TABLE_NAME = @table 
   AND DATA_TYPE IN ('char','nchar','ntext','nvarchar','text','varchar')

   SET @sqlCommand = left(@sqlCommand,len(@sqlCommand)-3)
   EXEC (@sqlCommand)
   PRINT @sqlCommand
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 

GO
/****** Object:  StoredProcedure [dbo].[spSearchStringInTable]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[spSearchStringInTable]
(@SearchString NVARCHAR(MAX),
 @Table_Schema sysname = 'dbo',
 @Table_Name sysname)
 AS
 BEGIN
DECLARE @Columns NVARCHAR(MAX), @Cols NVARCHAR(MAX), @PkColumn NVARCHAR(MAX)
  
-- Get all character columns
SET @Columns = STUFF((SELECT ', ' + QUOTENAME(Column_Name)
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE DATA_TYPE IN ('text','ntext','varchar','nvarchar','char','nchar')
 AND TABLE_NAME = @Table_Name AND TABLE_SCHEMA = @Table_Schema
 ORDER BY COLUMN_NAME
 FOR XML PATH('')),1,2,'');
  
IF @Columns IS NULL -- no character columns
   RETURN -1;
  
-- Get columns for select statement - we need to convert all columns to nvarchar(max)
SET @Cols = STUFF((SELECT ', CAST(' + QUOTENAME(Column_Name) + ' AS nvarchar(max)) COLLATE DATABASE_DEFAULT AS ' + QUOTENAME(Column_Name)
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE DATA_TYPE IN ('text','ntext','varchar','nvarchar','char','nchar')
 AND TABLE_NAME = @Table_Name AND TABLE_SCHEMA = @Table_Schema
 ORDER BY COLUMN_NAME
 FOR XML PATH('')),1,2,'');
   
 SET @PkColumn = STUFF((SELECT N' + ''|'' + ' + ' CAST(' + QUOTENAME(CU.COLUMN_NAME) + ' AS nvarchar(max)) COLLATE DATABASE_DEFAULT '
  
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
INNER JOIN
INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS CU
ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND
TC.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
  
 WHERE TC.TABLE_SCHEMA = @Table_Schema AND TC.TABLE_NAME = @Table_Name
 ORDER BY CU.ORDINAL_POSITION
 FOR XML PATH('')),1,9,'');
  
 IF @PkColumn IS NULL
    SELECT @PkColumn = 'CAST(NULL AS nvarchar(max))';
      
 -- set select statement using dynamic UNPIVOT
 DECLARE @SQL NVARCHAR(MAX)
 SET @SQL = 'SELECT *, ' + QUOTENAME(@Table_Schema,'''') + ' AS [Table Schema], ' + QUOTENAME(@Table_Name,'''') + ' AS [Table Name]' +
  ' FROM
  (SELECT '+ @PkColumn + ' AS [PK Column], ' + @Cols + ' FROM ' + QUOTENAME(@Table_Schema) + '.' + QUOTENAME(@Table_Name) +  ' ) src UNPIVOT ([Column Value] for [Column Name] IN (' + @Columns + ')) unpvt
 WHERE [Column Value] LIKE ''%'' + @SearchString + ''%'''
   
 --print @SQL
  
EXECUTE sp_ExecuteSQL @SQL, N'@SearchString nvarchar(max)', @SearchString;
END
GO
/****** Object:  StoredProcedure [dbo].[updateSMSgroups]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateSMSgroups] 
	
	@genset_sn as nvarchar(8),
	@SMS_Group_id as integer
	
AS
BEGIN
	
	UPDATE HL_Locations
	SET ID_SMS_Group = @SMS_Group_id
	WHERE GENSET_SN = @genset_sn
	
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUnit]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil A. Rutherford
-- Create date: 18-05-2015
-- Description:	Updates a datalogger unit to in Blackbox table
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUnit] 
	-- Add the parameters for the stored procedure here
	@BB_SerialNo nvarchar(9),
	@CFG_ConnectedControllersCount int,
	@CFG_GensetName01 nvarchar(25),
	@CFG_GensetName02 nvarchar(25),
	@CFG_GensetName03 nvarchar(25),
	@CFG_GensetName04 nvarchar(25),
	@CFG_GensetName05 nvarchar(25),
	@CFG_GensetName06 nvarchar(25),
	@CFG_GensetName07 nvarchar(25),
	@CFG_GensetName08 nvarchar(25),
	@CFG_GensetSN01 nvarchar(8),
	@CFG_GensetSN02 nvarchar(8),
	@CFG_GensetSN03 nvarchar(8),
	@CFG_GensetSN04 nvarchar(8),
	@CFG_GensetSN05 nvarchar(8),
	@CFG_GensetSN06 nvarchar(8),
	@CFG_GensetSN07 nvarchar(8),
	@CFG_GensetSN08 nvarchar(8),
	@CFG_BaudRate nvarchar(10),
	@CFG_EthernetModuleEn bit,
	@CFG_HMAddr01 int,
	@CFG_HMAddr02 int,
	@CFG_HMAddr03 int,
	@CFG_HMAddr04 int,
	@CFG_HMAddr05 int,
	@CFG_HMAddr06 int,
	@CFG_HMAddr07 int,
	@CFG_HMAddr08 int,
	@CFG_SMAddr01 int,
	@CFG_SMAddr02 int,
	@CFG_SMAddr03 int,
	@CFG_SMAddr04 int,
	@CFG_SMAddr05 int,
	@CFG_SMAddr06 int,
	@CFG_SMAddr07 int,
	@CFG_SMAddr08 int,
	@CFG_GMAddr01 int,
	@CFG_GMAddr02 int,
	@CFG_GMAddr03 int,
	@CFG_GMAddr04 int,
	@CFG_CommsObjFilePath nvarchar(200),
    @CFG_CommsObjNameStr nvarchar(max),
    @CFG_CommsObjDimStr nvarchar(max),
    @CFG_CommsObjTypeStr nvarchar(max),
    @CFG_CommsObjLenStr nvarchar(max),
    @CFG_CommsObjDecStr nvarchar(max),
    @CFG_CommsObjOfsStr nvarchar(max),
    @CFG_CommsObjObjStr nvarchar(max),
    @CFG_HistoryColNameStr nvarchar(max),
    @CFG_HistoryColIDsStr nvarchar(max),
    @CFG_HistoryColTypeStr nvarchar(max),
    @CFG_DevMode bit,
    @CFG_AddOnCallNo01 nchar(11),
    @CFG_AddOnCallNo02 nchar(11),
    @CFG_AddOnCallNo03 nchar(11),
    @CFG_AddOnCallNo04 nchar(11),
    @CFG_AddOnCallNo05 nchar(11),
    @CFG_GenStatEmail nvarchar(50),
    @CFG_AdminEmail nvarchar(50),
    @CFG_ModbusSlaveEn bit,
    @CFG_STORWarnEn bit,
    @CFG_RegDemand int,
    @CFG_RegCylTempAvg int,
    @CFG_RegCylTempMax int,
    @CFG_RegCylTempMin int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Get the current values
	SELECT @CFG_ConnectedControllersCount = CFG_ConnectedControllersCount,
			@CFG_GensetName01 = CFG_GensetName01,
			 @CFG_GensetName02 = CFG_GensetName02,
			  @CFG_GensetName03 = CFG_GensetName03,
			   @CFG_GensetName04 = CFG_GensetName04,
			    @CFG_GensetName05 = CFG_GensetName05,
			     @CFG_GensetName06 = CFG_GensetName06,
			      @CFG_GensetName07 = CFG_GensetName07,
			       @CFG_GensetName08 = CFG_GensetName08,
			@CFG_GensetSN01 = CFG_GensetSN01,
			 @CFG_GensetSN02 = CFG_GensetSN02,
			  @CFG_GensetSN03 = CFG_GensetSN03,
			   @CFG_GensetSN04 = CFG_GensetSN04,
			    @CFG_GensetSN05 = CFG_GensetSN05,
			     @CFG_GensetSN06 = CFG_GensetSN06,
			      @CFG_GensetSN07 = CFG_GensetSN07,
			       @CFG_GensetSN08 = CFG_GensetSN08,
			        @CFG_BaudRate = CFG_BaudRate,
			         @CFG_EthernetModuleEn = CFG_EthernetModuleEn
	FROM Blackboxes
	WHERE BB_SerialNo = @BB_SerialNo

    -- Insert statements for procedure here
	UPDATE Blackboxes SET CFG_ConnectedControllersCount = @CFG_ConnectedControllersCount,
						  CFG_GensetName01 = @CFG_GensetName01,
						   CFG_GensetName02 = @CFG_GensetName02,
							CFG_GensetName03 = @CFG_GensetName03,
							 CFG_GensetName04 = @CFG_GensetName04,
							  CFG_GensetName05 = @CFG_GensetName05,
							   CFG_GensetName06 = @CFG_GensetName06,
							    CFG_GensetName07 = @CFG_GensetName07,
							     CFG_GensetName08 = @CFG_GensetName08,
							CFG_GensetSN01 = @CFG_GensetSN01,
							 CFG_GensetSN02 = @CFG_GensetSN02,
							  CFG_GensetSN03 = @CFG_GensetSN03,
							   CFG_GensetSN04 = @CFG_GensetSN04,
							    CFG_GensetSN05 = @CFG_GensetSN05,
							     CFG_GensetSN06 = @CFG_GensetSN06,
							      CFG_GensetSN07 = @CFG_GensetSN07,
							       CFG_GensetSN08 = @CFG_GensetSN08,
							        CFG_BaudRate = @CFG_BaudRate,
							         CFG_EthernetModuleEn = @CFG_EthernetModuleEn,
							CFG_HMAddr01 = @CFG_HMAddr01,
							 CFG_HMAddr02 = @CFG_HMAddr02,
							  CFG_HMAddr03 = @CFG_HMAddr03,
							   CFG_HMAddr04 = @CFG_HMAddr04,
							    CFG_HMAddr05 = @CFG_HMAddr05,
							     CFG_HMAddr06 = @CFG_HMAddr06,
							      CFG_HMAddr07 = @CFG_HMAddr07,
							       CFG_HMAddr08 = @CFG_HMAddr08,
							        CFG_SMAddr01 = @CFG_SMAddr01,
							CFG_SMAddr02 = @CFG_SMAddr02,
							 CFG_SMAddr03 = @CFG_SMAddr03,
							  CFG_SMAddr04 = @CFG_SMAddr04,
							   CFG_SMAddr05 = @CFG_SMAddr05,
							    CFG_SMAddr06 = @CFG_SMAddr06,
							     CFG_SMAddr07 = @CFG_SMAddr07,
							      CFG_SMAddr08 = @CFG_SMAddr08,
							       CFG_GMAddr01 = @CFG_GMAddr01,
									CFG_GMAddr02 = @CFG_GMAddr02,
									 CFG_GMAddr03 = @CFG_GMAddr03,
									  CFG_GMAddr04 = @CFG_GMAddr04,
									   CFG_CommsObjFilePath = @CFG_CommsObjFilePath,
									    CFG_CommsObjNameStr = @CFG_CommsObjNameStr,
									     CFG_CommsObjDimStr = @CFG_CommsObjDimStr, 
							CFG_CommsObjTypeStr = @CFG_CommsObjTypeStr,
							 CFG_CommsObjLenStr = @CFG_CommsObjLenStr,
							  CFG_CommsObjDecStr = @CFG_CommsObjDecStr,
							   CFG_CommsObjOfsStr = @CFG_CommsObjOfsStr,
							    CFG_CommsObjObjStr = @CFG_CommsObjObjStr,
							     CFG_HistoryColNameStr = @CFG_HistoryColNameStr,
							CFG_HistoryColIDsStr = @CFG_HistoryColIDsStr,
							 CFG_HistoryColTypeStr = @CFG_HistoryColTypeStr,
							  CFG_DevMode = @CFG_DevMode,
							   CFG_AddOnCallNo01 = @CFG_AddOnCallNo01,
							    CFG_AddOnCallNo02 = @CFG_AddOnCallNo02,
							     CFG_AddOnCallNo03 = @CFG_AddOnCallNo03,
							      CFG_AddOnCallNo04 = @CFG_AddOnCallNo04,
							       CFG_AddOnCallNo05 = @CFG_AddOnCallNo05,
							CFG_GenStatEmail = @CFG_GenStatEmail,
							 CFG_AdminEmail = @CFG_AdminEmail,
							  CFG_ModbusSlaveEn = @CFG_ModbusSlaveEn,
							   CFG_STORWarnEn = @CFG_STORWarnEn,
							    CFG_RegDemand = @CFG_RegDemand,
							     CFG_RegCylTempAvg = @CFG_RegCylTempAvg,
							      CFG_RegCylTempMax = @CFG_RegCylTempMax,
							       CFG_RegCylTempMin = @CFG_RegCylTempMin
			
			WHERE BB_SerialNo = @BB_SerialNo
	
	
	
END
GO
/****** Object:  StoredProcedure [Staging].[BulkLoadEnergyMetersDataFromAzure]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [Staging].[BulkLoadEnergyMetersDataFromAzure]
@sourceFileName NVARCHAR(100)
AS

DECLARE @FileID INT;
DECLARE @fileName NVARCHAR(MAX) = REPLACE(@sourceFileName, '.csv', '');
DECLARE @bulkFile NVARCHAR(MAX) =  @sourceFileName;

-- File ID
DROP TABLE IF EXISTS #EnergyMetersResult;
CREATE TABLE #EnergyMetersResult(FileID INT);

INSERT INTO #EnergyMetersResult EXEC [Staging].[SetEnergyMetersFileMetadata] @fileName;
SELECT TOP 1 @FileID = FileID  FROM #EnergyMetersResult;

DROP TABLE IF EXISTS #energymeters_stage_metadata;
CREATE TABLE #energymeters_stage_metadata(
	[FileID] [int] NOT NULL,
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
)

CREATE TABLE #energymeters_stage_history(
	[FileID] [int] NOT NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DataTXT] [varchar](8000) NOT NULL,
	[RecordValue] [nvarchar](50) NULL
)

CREATE TABLE #energymeters_stage_history_parsed(
	[RowID] [int] NULL,
	[FieldID] [int] NULL,
	[FieldName] [varchar](50) NULL,
	[RecordValue] [nvarchar](50) NULL
)

-- Copy file in its raw format
DECLARE @sql NVARCHAR(MAX);

SET @sql = N'
INSERT INTO #energymeters_stage_history
(
	FileID,
	DataTXT
)
SELECT 
	FileID = ' + CAST(@FileID AS NVARCHAR(9)) + ',
	DataRow
FROM OPENROWSET(
	BULK ''' + @bulkFile  + ''', 
	DATA_SOURCE = ''EnergyMeterImport-Storage'',
	FIRSTROW=1,
	FORMATFILE=''eos-csv.fmt'',
	FORMATFILE_DATA_SOURCE = ''SQL-Storage'') as t
';

--PRINT @sql;
EXEC(@sql);

--remove trailing commas from all rows
DECLARE @badchar CHAR(1) = ',';
UPDATE #energymeters_stage_history
SET DataTXT = substring(rtrim(DataTXT), 1, len(rtrim(DataTXT)) - len(@badchar))
WHERE  rtrim(DataTXT) LIKE '%' + @badchar

--Staging Metadata table
DECLARE @Header VARCHAR(5000), @FieldName VARCHAR(5000);
     SELECT @Header = REPLACE(DataTXT, '.', '_') -- EnergyMeters files use . when the should be _
     FROM #energymeters_stage_history
     WHERE RowID = 1
           AND FileID = @FileID;

	INSERT INTO #energymeters_stage_metadata(FileID, FieldName)
	SELECT @FileID, SS.value
	FROM string_split(@Header, ',') as SS

-- Find columns with the same name and give them a numeric suffix
;with Dupes as(SELECT RowNo = ROW_NUMBER() over
(Partition by FieldName order by FieldID), FieldID, FieldName FROM #energymeters_stage_metadata)

UPDATE #energymeters_stage_metadata
SET #energymeters_stage_metadata.FieldName = d.FieldName + CONVERT(VARCHAR(2),d.RowNo)
FROM #energymeters_stage_metadata m
INNER JOIN Dupes d
ON  m.FieldID = d.FieldID
WHERE d.RowNo > 1

-- Insert new fields to Metadata and Update Prioduction Table
DECLARE cur_fields CURSOR FORWARD_ONLY
FOR SELECT
       s.FieldName,
       'Alter Table Staging.EnergyMetersData ADD ['+s.FieldName+'] float' AS Remediation
    FROM #energymeters_stage_metadata AS s
    WHERE NOT EXISTS
    (
        SELECT
           *
        FROM Staging.EnergyMetersMetadata AS m
        WHERE s.FieldName = m.FieldName
    )
    AND s.FileID = @FileID

DECLARE @NewFieldName VARCHAR(500),
        @sqlAlter  NVARCHAR(1000);
 
OPEN cur_fields;
 
FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;

print @NewFieldName;
print @sqlAlter;
 
WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Staging.EnergyMetersMetadata_history
        (
		   FileID,
           FieldName
        )
        VALUES
        (
		@FileID,
         @NewFieldName
        );
		INSERT INTO Staging.EnergyMetersMetadata
        (
           FieldName
        )
        VALUES(@NewFieldName);
        EXEC sp_executesql @sqlAlter;
        FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;
    END;

CLOSE cur_fields;
DEALLOCATE cur_fields;

--Final
DECLARE @sqlCMD       NVARCHAR(MAX),
				@sqlHeader    NVARCHAR(MAX),
				@sqlStage     NVARCHAR(MAX),
				@Fields       NVARCHAR(MAX),
				@SourceFields NVARCHAR(MAX),
				@SetFields    NVARCHAR(MAX);

SET @Fields = '';
SET @SourceFields = '';
SET @SetFields = '';

SELECT
   @Fields = @Fields+'['+FieldName+'], ',
   @SourceFields = @SourceFields+'source.['+FieldName+'], ',
   @SetFields = @SetFields+'target.['+FieldName+'] = source.['+FieldName+'], '
FROM #energymeters_stage_metadata
WHERE FileID = @FileID
		AND FieldID > 0;

SET @Fields = LEFT(@Fields, LEN(@Fields) - 1);

SET @SourceFields = LEFT(@SourceFields, LEN(@SourceFields) - 1);

SET @SetFields = LEFT(@SetFields, LEN(@SetFields) - 1);

print @Fields;
print @SourceFields;
print @SetFields;

TRUNCATE TABLE #energymeters_stage_history_parsed;

SET @sqlHeader = 'WITH RawData(RowID, FieldID, RecordValue) AS (SELECT RowID, ROW_NUMBER() OVER(PARTITION BY RowID ORDER BY RowID) AS FieldID, Value FROM #energymeters_stage_history s CROSS APPLY string_split (SUBSTRING(DataTXT, CHARINDEX(DataTXT, 1)+1, 5000), '+''''+','+''''+') WHERE FileID = '+CONVERT(VARCHAR(10), @FileID)+' AND RowID > 1), Result(RowID, FieldID, FieldName,RecordValue) AS (SELECT r.RowID, m.FieldID, m.FieldName, r.RecordValue FROM #energymeters_stage_metadata AS m JOIN RawData AS r ON m.FieldID = r.FieldID where m.FileID = '+CONVERT(VARCHAR(10), @FileID)+') ';

SET @sqlStage = 'insert into #energymeters_stage_history_parsed (RowID, FieldID, FieldName, RecordValue) select RowID, FieldID, FieldName, NULLIF(RecordValue, '''') from Result where RecordValue is not NULL';

SET @sqlCMD = @sqlHeader + @sqlStage;

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

SET @sqlCMD = '';

SELECT
   @sqlCMD = 'merge Staging.EnergyMetersData as target using (SELECT '+CONVERT( VARCHAR(10), @FileID)+', '+@Fields+' from (select [RowID], [FieldName], [RecordValue] from #energymeters_stage_history_parsed) as s Pivot(MAX([RecordValue]) for [FieldName] in ('+@Fields+')) as p) as source ([FileID], '+@Fields+') on (target.[FileID] = source.[FileID]) when matched then update set '+@SetFields+' when not matched then insert([FileID], '+@Fields+') values (source.[FileID], '+@SourceFields+');';

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

   --Cleanup
   DROP TABLE IF EXISTS #energymeters_stage_metadata;
   DROP TABLE IF EXISTS #energymeters_stage_history;
   DROP TABLE IF EXISTS #energymeters_stage_history_parsed;
GO
/****** Object:  StoredProcedure [Staging].[BulkLoadEnergyMetersDirisA20DataFromAzure]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [Staging].[BulkLoadEnergyMetersDirisA20DataFromAzure]
@sourceFileName NVARCHAR(100)
AS

DECLARE @FileID INT;
DECLARE @fileName NVARCHAR(MAX) = REPLACE(@sourceFileName, '.csv', '');
DECLARE @bulkFile NVARCHAR(MAX) =  @sourceFileName;

-- File ID
DROP TABLE IF EXISTS #EnergyMetersDirisA20Result;
CREATE TABLE #EnergyMetersDirisA20Result(FileID INT);

INSERT INTO #EnergyMetersDirisA20Result EXEC [Staging].[SetEnergyMetersDirisA20FileMetadata] @fileName;
SELECT TOP 1 @FileID = FileID  FROM #EnergyMetersDirisA20Result;

DROP TABLE IF EXISTS #energymetersdirisa20_stage_metadata;
CREATE TABLE #energymetersdirisa20_stage_metadata(
	[FileID] [int] NOT NULL,
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
)

CREATE TABLE #energymetersdirisa20_stage_history(
	[FileID] [int] NOT NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DataTXT] [varchar](8000) NOT NULL,
	[RecordValue] [nvarchar](50) NULL
)

CREATE TABLE #energymetersdirisa20_stage_history_parsed(
	[RowID] [int] NULL,
	[FieldID] [int] NULL,
	[FieldName] [varchar](50) NULL,
	[RecordValue] [nvarchar](50) NULL
)

-- Copy file in its raw format
DECLARE @sql NVARCHAR(MAX);

SET @sql = N'
INSERT INTO #energymetersdirisa20_stage_history
(
	FileID,
	DataTXT
)
SELECT 
	FileID = ' + CAST(@FileID AS NVARCHAR(9)) + ',
	DataRow
FROM OPENROWSET(
	BULK ''' + @bulkFile  + ''', 
	DATA_SOURCE = ''EnergyMeterImport-Storage'',
	FIRSTROW=1,
	FORMATFILE=''eos-csv.fmt'',
	FORMATFILE_DATA_SOURCE = ''SQL-Storage'') as t
';

--PRINT @sql;
EXEC(@sql);

--remove trailing commas from all rows
DECLARE @badchar CHAR(1) = ',';
UPDATE #energymetersdirisa20_stage_history
SET DataTXT = substring(rtrim(DataTXT), 1, len(rtrim(DataTXT)) - len(@badchar))
WHERE  rtrim(DataTXT) LIKE '%' + @badchar

--Staging Metadata table
DECLARE @Header VARCHAR(5000), @FieldName VARCHAR(5000);
     SELECT @Header = REPLACE(DataTXT, '.', '_') -- EnergyMetersDirisA20 files use . when the should be _
     FROM #energymetersdirisa20_stage_history
     WHERE RowID = 1
           AND FileID = @FileID;

	INSERT INTO #energymetersdirisa20_stage_metadata(FileID, FieldName)
	SELECT @FileID, SS.value
	FROM string_split(@Header, ',') as SS

-- Find columns with the same name and give them a numeric suffix
;with Dupes as(SELECT RowNo = ROW_NUMBER() over
(Partition by FieldName order by FieldID), FieldID, FieldName FROM #energymetersdirisa20_stage_metadata)

UPDATE #energymetersdirisa20_stage_metadata
SET #energymetersdirisa20_stage_metadata.FieldName = d.FieldName + CONVERT(VARCHAR(2),d.RowNo)
FROM #energymetersdirisa20_stage_metadata m
INNER JOIN Dupes d
ON  m.FieldID = d.FieldID
WHERE d.RowNo > 1

-- Insert new fields to Metadata and Update Prioduction Table
DECLARE cur_fields CURSOR FORWARD_ONLY
FOR SELECT
       s.FieldName,
       'Alter Table Staging.EnergyMetersDirisA20Data ADD ['+s.FieldName+'] float' AS Remediation
    FROM #energymetersdirisa20_stage_metadata AS s
    WHERE NOT EXISTS
    (
        SELECT
           *
        FROM Staging.EnergyMetersDirisA20Metadata AS m
        WHERE s.FieldName = m.FieldName
    )
    AND s.FileID = @FileID

DECLARE @NewFieldName VARCHAR(500),
        @sqlAlter  NVARCHAR(1000);
 
OPEN cur_fields;
 
FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;

print @NewFieldName;
print @sqlAlter;
 
WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Staging.EnergyMetersDirisA20Metadata_history
        (
		   FileID,
           FieldName
        )
        VALUES
        (
		@FileID,
         @NewFieldName
        );
		INSERT INTO Staging.EnergyMetersDirisA20Metadata
        (
           FieldName
        )
        VALUES(@NewFieldName);
        EXEC sp_executesql @sqlAlter;
        FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;
    END;

CLOSE cur_fields;
DEALLOCATE cur_fields;

--Final
DECLARE @sqlCMD       NVARCHAR(MAX),
				@sqlHeader    NVARCHAR(MAX),
				@sqlStage     NVARCHAR(MAX),
				@Fields       NVARCHAR(MAX),
				@SourceFields NVARCHAR(MAX),
				@SetFields    NVARCHAR(MAX);

SET @Fields = '';
SET @SourceFields = '';
SET @SetFields = '';

SELECT
   @Fields = @Fields+'['+FieldName+'], ',
   @SourceFields = @SourceFields+'source.['+FieldName+'], ',
   @SetFields = @SetFields+'target.['+FieldName+'] = source.['+FieldName+'], '
FROM #energymetersdirisa20_stage_metadata
WHERE FileID = @FileID
		AND FieldID > 0;

SET @Fields = LEFT(@Fields, LEN(@Fields) - 1);

SET @SourceFields = LEFT(@SourceFields, LEN(@SourceFields) - 1);

SET @SetFields = LEFT(@SetFields, LEN(@SetFields) - 1);

print @Fields;
print @SourceFields;
print @SetFields;

TRUNCATE TABLE #energymetersdirisa20_stage_history_parsed;

SET @sqlHeader = 'WITH RawData(RowID, FieldID, RecordValue) AS (SELECT RowID, ROW_NUMBER() OVER(PARTITION BY RowID ORDER BY RowID) AS FieldID, Value FROM #energymetersdirisa20_stage_history s CROSS APPLY string_split (SUBSTRING(DataTXT, CHARINDEX(DataTXT, 1)+1, 5000), '+''''+','+''''+') WHERE FileID = '+CONVERT(VARCHAR(10), @FileID)+' AND RowID > 1), Result(RowID, FieldID, FieldName,RecordValue) AS (SELECT r.RowID, m.FieldID, m.FieldName, r.RecordValue FROM #energymetersdirisa20_stage_metadata AS m JOIN RawData AS r ON m.FieldID = r.FieldID where m.FileID = '+CONVERT(VARCHAR(10), @FileID)+') ';

SET @sqlStage = 'insert into #energymetersdirisa20_stage_history_parsed (RowID, FieldID, FieldName, RecordValue) select RowID, FieldID, FieldName, NULLIF(RecordValue, '''') from Result where RecordValue is not NULL';

SET @sqlCMD = @sqlHeader + @sqlStage;

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

SET @sqlCMD = '';

SELECT
   @sqlCMD = 'merge Staging.EnergyMetersDirisA20Data as target using (SELECT '+CONVERT( VARCHAR(10), @FileID)+', '+@Fields+' from (select [RowID], [FieldName], [RecordValue] from #energymetersdirisa20_stage_history_parsed) as s Pivot(MAX([RecordValue]) for [FieldName] in ('+@Fields+')) as p) as source ([FileID], '+@Fields+') on (target.[FileID] = source.[FileID]) when matched then update set '+@SetFields+' when not matched then insert([FileID], '+@Fields+') values (source.[FileID], '+@SourceFields+');';

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

   --Cleanup
   DROP TABLE IF EXISTS #energymetersdirisa20_stage_metadata;
   DROP TABLE IF EXISTS #energymetersdirisa20_stage_history;
   DROP TABLE IF EXISTS #energymetersdirisa20_stage_history_parsed;
GO
/****** Object:  StoredProcedure [Staging].[BulkLoadEnergyMetersLGE650DataFromAzure]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [Staging].[BulkLoadEnergyMetersLGE650DataFromAzure]
@sourceFileName NVARCHAR(100)
AS

DECLARE @FileID INT;
DECLARE @fileName NVARCHAR(MAX) = REPLACE(@sourceFileName, '.csv', '');
DECLARE @bulkFile NVARCHAR(MAX) =  @sourceFileName;

-- File ID
DROP TABLE IF EXISTS #EnergyMetersLGE650Result;
CREATE TABLE #EnergyMetersLGE650Result(FileID INT);

INSERT INTO #EnergyMetersLGE650Result EXEC [Staging].[SetEnergyMetersLGE650FileMetadata] @fileName;
SELECT TOP 1 @FileID = FileID  FROM #EnergyMetersLGE650Result;

DROP TABLE IF EXISTS #energymeterslge650_stage_metadata;
CREATE TABLE #energymeterslge650_stage_metadata(
	[FileID] [int] NOT NULL,
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
)

CREATE TABLE #energymeterslge650_stage_history(
	[FileID] [int] NOT NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DataTXT] [varchar](8000) NOT NULL,
	[RecordValue] [nvarchar](50) NULL
)

CREATE TABLE #energymeterslge650_stage_history_parsed(
	[RowID] [int] NULL,
	[FieldID] [int] NULL,
	[FieldName] [varchar](50) NULL,
	[RecordValue] [nvarchar](50) NULL
)

-- Copy file in its raw format
DECLARE @sql NVARCHAR(MAX);

SET @sql = N'
INSERT INTO #energymeterslge650_stage_history
(
	FileID,
	DataTXT
)
SELECT 
	FileID = ' + CAST(@FileID AS NVARCHAR(9)) + ',
	DataRow
FROM OPENROWSET(
	BULK ''' + @bulkFile  + ''', 
	DATA_SOURCE = ''EnergyMeterImport-Storage'',
	FIRSTROW=1,
	FORMATFILE=''eos-csv.fmt'',
	FORMATFILE_DATA_SOURCE = ''SQL-Storage'') as t
';

--PRINT @sql;
EXEC(@sql);

--remove trailing commas from all rows
DECLARE @badchar CHAR(1) = ',';
UPDATE #energymeterslge650_stage_history
SET DataTXT = substring(rtrim(DataTXT), 1, len(rtrim(DataTXT)) - len(@badchar))
WHERE  rtrim(DataTXT) LIKE '%' + @badchar

--Staging Metadata table
DECLARE @Header VARCHAR(5000), @FieldName VARCHAR(5000);
     SELECT @Header = REPLACE(DataTXT, '.', '_') -- EnergyMetersLGE650 files use . when the should be _
     FROM #energymeterslge650_stage_history
     WHERE RowID = 1
           AND FileID = @FileID;

	INSERT INTO #energymeterslge650_stage_metadata(FileID, FieldName)
	SELECT @FileID, SS.value
	FROM string_split(@Header, ',') as SS

-- Find columns with the same name and give them a numeric suffix
;with Dupes as(SELECT RowNo = ROW_NUMBER() over
(Partition by FieldName order by FieldID), FieldID, FieldName FROM #energymeterslge650_stage_metadata)

UPDATE #energymeterslge650_stage_metadata
SET #energymeterslge650_stage_metadata.FieldName = d.FieldName + CONVERT(VARCHAR(2),d.RowNo)
FROM #energymeterslge650_stage_metadata m
INNER JOIN Dupes d
ON  m.FieldID = d.FieldID
WHERE d.RowNo > 1

-- Insert new fields to Metadata and Update Prioduction Table
DECLARE cur_fields CURSOR FORWARD_ONLY
FOR SELECT
       s.FieldName,
       'Alter Table Staging.EnergyMetersLGE650Data ADD ['+s.FieldName+'] float' AS Remediation
    FROM #energymeterslge650_stage_metadata AS s
    WHERE NOT EXISTS
    (
        SELECT
           *
        FROM Staging.EnergyMetersLGE650Metadata AS m
        WHERE s.FieldName = m.FieldName
    )
    AND s.FileID = @FileID

DECLARE @NewFieldName VARCHAR(500),
        @sqlAlter  NVARCHAR(1000);
 
OPEN cur_fields;
 
FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;

print @NewFieldName;
print @sqlAlter;
 
WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Staging.EnergyMetersLGE650Metadata_history
        (
		   FileID,
           FieldName
        )
        VALUES
        (
		@FileID,
         @NewFieldName
        );
		INSERT INTO Staging.EnergyMetersLGE650Metadata
        (
           FieldName
        )
        VALUES(@NewFieldName);
        EXEC sp_executesql @sqlAlter;
        FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;
    END;

CLOSE cur_fields;
DEALLOCATE cur_fields;

--Final
DECLARE @sqlCMD       NVARCHAR(MAX),
				@sqlHeader    NVARCHAR(MAX),
				@sqlStage     NVARCHAR(MAX),
				@Fields       NVARCHAR(MAX),
				@SourceFields NVARCHAR(MAX),
				@SetFields    NVARCHAR(MAX);

SET @Fields = '';
SET @SourceFields = '';
SET @SetFields = '';

SELECT
   @Fields = @Fields+'['+FieldName+'], ',
   @SourceFields = @SourceFields+'source.['+FieldName+'], ',
   @SetFields = @SetFields+'target.['+FieldName+'] = source.['+FieldName+'], '
FROM #energymeterslge650_stage_metadata
WHERE FileID = @FileID
		AND FieldID > 0;

SET @Fields = LEFT(@Fields, LEN(@Fields) - 1);

SET @SourceFields = LEFT(@SourceFields, LEN(@SourceFields) - 1);

SET @SetFields = LEFT(@SetFields, LEN(@SetFields) - 1);

print @Fields;
print @SourceFields;
print @SetFields;

TRUNCATE TABLE #energymeterslge650_stage_history_parsed;

SET @sqlHeader = 'WITH RawData(RowID, FieldID, RecordValue) AS (SELECT RowID, ROW_NUMBER() OVER(PARTITION BY RowID ORDER BY RowID) AS FieldID, Value FROM #energymeterslge650_stage_history s CROSS APPLY string_split (SUBSTRING(DataTXT, CHARINDEX(DataTXT, 1)+1, 5000), '+''''+','+''''+') WHERE FileID = '+CONVERT(VARCHAR(10), @FileID)+' AND RowID > 1), Result(RowID, FieldID, FieldName,RecordValue) AS (SELECT r.RowID, m.FieldID, m.FieldName, r.RecordValue FROM #energymeterslge650_stage_metadata AS m JOIN RawData AS r ON m.FieldID = r.FieldID where m.FileID = '+CONVERT(VARCHAR(10), @FileID)+') ';

SET @sqlStage = 'insert into #energymeterslge650_stage_history_parsed (RowID, FieldID, FieldName, RecordValue) select RowID, FieldID, FieldName, NULLIF(RecordValue, '''') from Result where RecordValue is not NULL';

SET @sqlCMD = @sqlHeader + @sqlStage;

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

SET @sqlCMD = '';

SELECT
   @sqlCMD = 'merge Staging.EnergyMetersLGE650Data as target using (SELECT '+CONVERT( VARCHAR(10), @FileID)+', '+@Fields+' from (select [RowID], [FieldName], [RecordValue] from #energymeterslge650_stage_history_parsed) as s Pivot(MAX([RecordValue]) for [FieldName] in ('+@Fields+')) as p) as source ([FileID], '+@Fields+') on (target.[FileID] = source.[FileID]) when matched then update set '+@SetFields+' when not matched then insert([FileID], '+@Fields+') values (source.[FileID], '+@SourceFields+');';

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

   --Cleanup
   DROP TABLE IF EXISTS #energymeterslge650_stage_metadata;
   DROP TABLE IF EXISTS #energymeterslge650_stage_history;
   DROP TABLE IF EXISTS #energymeterslge650_stage_history_parsed;
GO
/****** Object:  StoredProcedure [Staging].[BulkLoadGasMetersDataFromAzure]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Staging].[BulkLoadGasMetersDataFromAzure]
@sourceFileName NVARCHAR(100)
AS

DECLARE @FileID INT;
DECLARE @fileName NVARCHAR(MAX) = REPLACE(@sourceFileName, '.csv', '');
DECLARE @bulkFile NVARCHAR(MAX) =  @sourceFileName;

-- File ID
DROP TABLE IF EXISTS #GasMetersResult;
CREATE TABLE #GasMetersResult(FileID INT);

INSERT INTO #GasMetersResult EXEC [Staging].[SetGasMetersFileMetadata] @fileName;
SELECT TOP 1 @FileID = FileID  FROM #GasMetersResult;

DROP TABLE IF EXISTS #gasmeters_stage_metadata;
CREATE TABLE #gasmeters_stage_metadata(
	[FileID] [int] NOT NULL,
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
)

CREATE TABLE #gasmeters_stage_history(
	[FileID] [int] NOT NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DataTXT] [varchar](8000) NOT NULL,
	[RecordValue] [nvarchar](50) NULL
)

CREATE TABLE #gasmeters_stage_history_parsed(
	[RowID] [int] NULL,
	[FieldID] [int] NULL,
	[FieldName] [varchar](50) NULL,
	[RecordValue] [nvarchar](50) NULL
)

-- Copy file in its raw format
DECLARE @sql NVARCHAR(MAX);

SET @sql = N'
INSERT INTO #gasmeters_stage_history
(
	FileID,
	DataTXT
)
SELECT 
	FileID = ' + CAST(@FileID AS NVARCHAR(9)) + ',
	DataRow
FROM OPENROWSET(
	BULK ''' + @bulkFile  + ''', 
	DATA_SOURCE = ''EnergyMeterImport-Storage'',
	FIRSTROW=1,
	FORMATFILE=''eos-csv.fmt'',
	FORMATFILE_DATA_SOURCE = ''SQL-Storage'') as t
';

--PRINT @sql;
EXEC(@sql);

--remove trailing commas from all rows
DECLARE @badchar CHAR(1) = ',';
UPDATE #gasmeters_stage_history
SET DataTXT = substring(rtrim(DataTXT), 1, len(rtrim(DataTXT)) - len(@badchar))
WHERE  rtrim(DataTXT) LIKE '%' + @badchar

--Staging Metadata table
DECLARE @Header VARCHAR(5000), @FieldName VARCHAR(5000);
     SELECT @Header = REPLACE(DataTXT, '.', '_') -- GasMeters files use . when the should be _
     FROM #gasmeters_stage_history
     WHERE RowID = 1
           AND FileID = @FileID;

	INSERT INTO #gasmeters_stage_metadata(FileID, FieldName)
	SELECT @FileID, SS.value
	FROM string_split(@Header, ',') as SS

-- Find columns with the same name and give them a numeric suffix
;with Dupes as(SELECT RowNo = ROW_NUMBER() over
(Partition by FieldName order by FieldID), FieldID, FieldName FROM #gasmeters_stage_metadata)

UPDATE #gasmeters_stage_metadata
SET #gasmeters_stage_metadata.FieldName = d.FieldName + CONVERT(VARCHAR(2),d.RowNo)
FROM #gasmeters_stage_metadata m
INNER JOIN Dupes d
ON  m.FieldID = d.FieldID
WHERE d.RowNo > 1

-- Insert new fields to Metadata and Update Production Table
DECLARE cur_fields CURSOR FORWARD_ONLY
FOR SELECT
       s.FieldName,
       'Alter Table Staging.GasMetersData ADD ['+s.FieldName+'] float' AS Remediation
    FROM #gasmeters_stage_metadata AS s
    WHERE NOT EXISTS
    (
        SELECT
           *
        FROM Staging.GasMetersMetadata AS m
        WHERE s.FieldName = m.FieldName
    )
    AND s.FileID = @FileID

DECLARE @NewFieldName VARCHAR(500),
        @sqlAlter  NVARCHAR(1000);
 
OPEN cur_fields;
 
FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;

print @NewFieldName;
print @sqlAlter;
 
WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Staging.GasMetersMetadata_history
        (
		   FileID,
           FieldName
        )
        VALUES
        (
		@FileID,
         @NewFieldName
        );
		INSERT INTO Staging.GasMetersMetadata
        (
           FieldName
        )
        VALUES(@NewFieldName);
        EXEC sp_executesql @sqlAlter;
        FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;
    END;

CLOSE cur_fields;
DEALLOCATE cur_fields;

--Final
DECLARE @sqlCMD       NVARCHAR(MAX),
				@sqlHeader    NVARCHAR(MAX),
				@sqlStage     NVARCHAR(MAX),
				@Fields       NVARCHAR(MAX),
				@SourceFields NVARCHAR(MAX),
				@SetFields    NVARCHAR(MAX);

SET @Fields = '';
SET @SourceFields = '';
SET @SetFields = '';

SELECT
   @Fields = @Fields+'['+FieldName+'], ',
   @SourceFields = @SourceFields+'source.['+FieldName+'], ',
   @SetFields = @SetFields+'target.['+FieldName+'] = source.['+FieldName+'], '
FROM #gasmeters_stage_metadata
WHERE FileID = @FileID
		AND FieldID > 0;

SET @Fields = LEFT(@Fields, LEN(@Fields) - 1);

SET @SourceFields = LEFT(@SourceFields, LEN(@SourceFields) - 1);

SET @SetFields = LEFT(@SetFields, LEN(@SetFields) - 1);

print @Fields;
print @SourceFields;
print @SetFields;

TRUNCATE TABLE #gasmeters_stage_history_parsed;

SET @sqlHeader = 'WITH RawData(RowID, FieldID, RecordValue) AS (SELECT RowID, ROW_NUMBER() OVER(PARTITION BY RowID ORDER BY RowID) AS FieldID, Value FROM #gasmeters_stage_history s CROSS APPLY string_split (SUBSTRING(DataTXT, CHARINDEX(DataTXT, 1)+1, 5000), '+''''+','+''''+') WHERE FileID = '+CONVERT(VARCHAR(10), @FileID)+' AND RowID > 1), Result(RowID, FieldID, FieldName,RecordValue) AS (SELECT r.RowID, m.FieldID, m.FieldName, r.RecordValue FROM #gasmeters_stage_metadata AS m JOIN RawData AS r ON m.FieldID = r.FieldID where m.FileID = '+CONVERT(VARCHAR(10), @FileID)+') ';

SET @sqlStage = 'insert into #gasmeters_stage_history_parsed (RowID, FieldID, FieldName, RecordValue) select RowID, FieldID, FieldName, NULLIF(RecordValue, '''') from Result where RecordValue is not NULL';

SET @sqlCMD = @sqlHeader + @sqlStage;

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

SET @sqlCMD = '';

SELECT
   @sqlCMD = 'merge Staging.GasMetersData as target using (SELECT '+CONVERT( VARCHAR(10), @FileID)+', '+@Fields+' from (select [RowID], [FieldName], [RecordValue] from #gasmeters_stage_history_parsed) as s Pivot(MAX([RecordValue]) for [FieldName] in ('+@Fields+')) as p) as source ([FileID], '+@Fields+') on (target.[FileID] = source.[FileID]) when matched then update set '+@SetFields+' when not matched then insert([FileID], '+@Fields+') values (source.[FileID], '+@SourceFields+');';

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

   --Cleanup
   DROP TABLE IF EXISTS #gasmeters_stage_metadata;
   DROP TABLE IF EXISTS #gasmeters_stage_history;
   DROP TABLE IF EXISTS #gasmeters_stage_history_parsed;
GO
/****** Object:  StoredProcedure [Staging].[BulkLoadGeneratorDataFromAzure]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [Staging].[BulkLoadGeneratorDataFromAzure]
@sourceFileName NVARCHAR(100)
AS

DECLARE @FileID INT;
DECLARE @fileName NVARCHAR(MAX) = REPLACE(@sourceFileName, '.csv', '');
DECLARE @bulkFile NVARCHAR(MAX) =  @sourceFileName;

-- File ID
DROP TABLE IF EXISTS #GeneratorResult;
CREATE TABLE #GeneratorResult(FileID INT);

INSERT INTO #GeneratorResult EXEC [Staging].[SetGeneratorFileMetadata] @fileName;
SELECT TOP 1 @FileID = FileID  FROM #GeneratorResult;

DROP TABLE IF EXISTS #generator_stage_metadata;
CREATE TABLE #generator_stage_metadata(
	[FileID] [int] NOT NULL,
	[FieldID] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [varchar](50) NOT NULL
)

CREATE TABLE #generator_stage_history(
	[FileID] [int] NOT NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[DataTXT] [varchar](8000) NOT NULL,
	[RecordValue] [nvarchar](50) NULL
)

CREATE TABLE #generator_stage_history_parsed(
	[RowID] [int] NULL,
	[FieldID] [int] NULL,
	[FieldName] [varchar](50) NULL,
	[RecordValue] [nvarchar](50) NULL
)

-- Copy file in its raw format
DECLARE @sql NVARCHAR(MAX);

SET @sql = N'
INSERT INTO #generator_stage_history
(
	FileID,
	DataTXT
)
SELECT 
	FileID = ' + CAST(@FileID AS NVARCHAR(9)) + ',
	DataRow
FROM OPENROWSET(
	BULK ''' + @bulkFile  + ''', 
	DATA_SOURCE = ''GeneratorImport-Storage'',
	FIRSTROW=1,
	FORMATFILE=''eos-csv.fmt'',
	FORMATFILE_DATA_SOURCE = ''SQL-Storage'') as t
';

--PRINT @sql;
EXEC(@sql);

--remove trailing commas from all rows
DECLARE @badchar CHAR(1) = ',';
UPDATE #generator_stage_history
SET DataTXT = substring(rtrim(DataTXT), 1, len(rtrim(DataTXT)) - len(@badchar))
WHERE  rtrim(DataTXT) LIKE '%' + @badchar

--Staging Metadata table
DECLARE @Header VARCHAR(5000), @FieldName VARCHAR(5000);
     SELECT @Header = DataTXT
     FROM #generator_stage_history
     WHERE RowID = 1
           AND FileID = @FileID;

	INSERT INTO #generator_stage_metadata(FileID, FieldName)
	SELECT @FileID, SS.value
	FROM string_split(@Header, ',') as SS

-- Find columns with the same name and give them a numeric suffix
;with Dupes as(SELECT RowNo = ROW_NUMBER() over
(Partition by FieldName order by FieldID), FieldID, FieldName FROM #generator_stage_metadata)

UPDATE #generator_stage_metadata
SET #generator_stage_metadata.FieldName = d.FieldName + CONVERT(VARCHAR(2),d.RowNo)
FROM #generator_stage_metadata m
INNER JOIN Dupes d
ON  m.FieldID = d.FieldID
WHERE d.RowNo > 1

-- Insert new fields to Metadata and Update Prioduction Table
DECLARE cur_fields CURSOR FORWARD_ONLY
FOR SELECT
       s.FieldName,
       'Alter Table Staging.GeneratorData ADD ['+s.FieldName+'] nvarchar(50)' AS Remediation
    FROM #generator_stage_metadata AS s
    WHERE NOT EXISTS
    (
        SELECT
           *
        FROM Staging.GeneratorMetadata AS m
        WHERE s.FieldName = m.FieldName
    )
    AND s.FileID = @FileID

DECLARE @NewFieldName VARCHAR(500),
        @sqlAlter  NVARCHAR(1000);
 
OPEN cur_fields;
 
FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;

print @NewFieldName;
print @sqlAlter;
 
WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Staging.GeneratorMetadata_history
        (
		   FileID,
           FieldName
        )
        VALUES
        (
		@FileID,
         @NewFieldName
        );
		INSERT INTO Staging.GeneratorMetadata
        (
           FieldName
        )
        VALUES(@NewFieldName);
        EXEC sp_executesql @sqlAlter;
        FETCH NEXT FROM cur_fields INTO @NewFieldName, @sqlAlter;
    END;

CLOSE cur_fields;
DEALLOCATE cur_fields;

--Final
DECLARE @sqlCMD       NVARCHAR(MAX),
				@sqlHeader    NVARCHAR(MAX),
				@sqlStage     NVARCHAR(MAX),
				@Fields       NVARCHAR(MAX),
				@SourceFields NVARCHAR(MAX),
				@SetFields    NVARCHAR(MAX);

SET @Fields = '';
SET @SourceFields = '';
SET @SetFields = '';

SELECT
   @Fields = @Fields+'['+FieldName+'], ',
   @SourceFields = @SourceFields+'source.['+FieldName+'], ',
   @SetFields = @SetFields+'target.['+FieldName+'] = source.['+FieldName+'], '
FROM #generator_stage_metadata
WHERE FileID = @FileID
		AND FieldID > 0;

SET @Fields = LEFT(@Fields, LEN(@Fields) - 1);

SET @SourceFields = LEFT(@SourceFields, LEN(@SourceFields) - 1);

SET @SetFields = LEFT(@SetFields, LEN(@SetFields) - 1);

print @Fields;
print @SourceFields;
print @SetFields;

TRUNCATE TABLE #generator_stage_history_parsed;

SET @sqlHeader = 'WITH RawData(RowID, FieldID, RecordValue) AS (SELECT RowID, ROW_NUMBER() OVER(PARTITION BY RowID ORDER BY RowID) AS FieldID, Value FROM #generator_stage_history s CROSS APPLY string_split (SUBSTRING(DataTXT, CHARINDEX(DataTXT, 1)+1, 5000), '+''''+','+''''+') WHERE FileID = '+CONVERT(VARCHAR(10), @FileID)+' AND RowID > 1), Result(RowID, FieldID, FieldName,RecordValue) AS (SELECT r.RowID, m.FieldID, m.FieldName, r.RecordValue FROM #generator_stage_metadata AS m JOIN RawData AS r ON m.FieldID = r.FieldID where m.FileID = '+CONVERT(VARCHAR(10), @FileID)+') ';

SET @sqlStage = 'insert into #generator_stage_history_parsed (RowID, FieldID, FieldName, RecordValue) select RowID, FieldID, FieldName, NULLIF(RecordValue, '''') from Result where RecordValue is not NULL';

SET @sqlCMD = @sqlHeader + @sqlStage;

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

SET @sqlCMD = '';

SELECT
   @sqlCMD = 'merge Staging.GeneratorData as target using (SELECT '+CONVERT( VARCHAR(10), @FileID)+', '+@Fields+' from (select [RowID], [FieldName], [RecordValue] from #generator_stage_history_parsed) as s Pivot(MAX([RecordValue]) for [FieldName] in ('+@Fields+')) as p) as source ([FileID], '+@Fields+') on (target.[FileID] = source.[FileID]) when matched then update set '+@SetFields+' when not matched then insert([FileID], '+@Fields+') values (source.[FileID], '+@SourceFields+');';

print @sqlCMD;

EXEC sp_executesql
   @sqlCMD;

   --Cleanup
   DROP TABLE IF EXISTS #generator_stage_metadata;
   DROP TABLE IF EXISTS #generator_stage_history;
   DROP TABLE IF EXISTS #generator_stage_history_parsed;
GO
/****** Object:  StoredProcedure [Staging].[BulkLoadGeneratorJsonFromAzure]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Staging].[BulkLoadGeneratorJsonFromAzure]
@sourceFileName NVARCHAR(100)
AS

DECLARE @FileID INT;
DECLARE @fileName NVARCHAR(MAX) = REPLACE(@sourceFileName, '.json', '');
DECLARE @bulkFile NVARCHAR(MAX) =  @sourceFileName;
DECLARE @_JSONData AS NVARCHAR(MAX);
DECLARE @_JSONExtended AS NVARCHAR(4000)
DECLARE @_UtcRecieved AS DATETIME;
DECLARE @_IdLocation AS INT
DECLARE @_IdEvent AS INT
DECLARE @_RowsInQuery AS INT

-- Temp tables
DROP TABLE IF EXISTS #GeneratorContentTemp;
CREATE TABLE #GeneratorContentTemp(IdLocation int,UtcRecieved datetime,UtcGenerated datetime,TimeStamp datetime,IdEvent int,Event nvarchar(128),Extended nvarchar(4000),RPM smallint,Pwr smallint,
	PF float,Gfrq float,Vg1 smallint,Vg2 smallint,Vg3 smallint,Vg12 smallint,Vg23 smallint,Vg31 smallint,Ig1 smallint,Ig2 smallint,Ig3 smallint,Mfrq float,Vm1 smallint,Vm2 smallint,Vm3 smallint,
	Vm12 smallint,Vm23 smallint,Vm31 smallint,MPF float,SRO float,VRO float,Mode char(3),kWhour int,Runhrs int,ActPwr smallint,ActDem smallint,CylA1 smallint,CylA2 smallint,CylA3 smallint,CylA4 smallint,
	CylA5 smallint,CylA6 smallint,CylA7 smallint,CylA8 smallint,CylA9 smallint,CylA10 smallint,CylB1 smallint,CylB2 smallint,CylB3 smallint,CylB4 smallint,CylB5 smallint,CylB6 smallint,CylB7 smallint,
	CylB8 smallint,CylB9 smallint,CylB10 smallint,BIN nchar(16),BOUT nchar(16),MVS float,ActPwrReq smallint,Ubat float,CPUT float,TEMv float,LChr char(1),OilB4F float,OilLev float,OilT float,CCPres float,AirInT float,
	RecAT float,ThrPos float,CH4 float,JWTin float,JWTout float,Numstr smallint,BI1 nchar(8),BI2 nchar(8),BI3 nchar(8),BI4 nchar(8),BI5 nchar(8),BI6 nchar(8),BI7 nchar(8),BI8 nchar(8),BI9 nchar(8),BI10 nchar(8),
	BI11 nchar(8),BI12 nchar(8),BO1 nchar(8),BO2 nchar(8),BO3 nchar(8),BO4 nchar(8),BO5 nchar(8),Pmns smallint,Qmns smallint,ActPfi smallint,MLChr char(1),Amb float,kVarho int,GasP float,LTHWfT float,
	LTHWrT float,GFlwRte float,GFlwM3 int,H2S smallint,NumUns smallint,PwrDem smallint,JWGKin float,HWFlo float,HWRtn float,GasMet int,IcOut smallint,ImpLoad smallint,Q float,U float,V float,W float,
	Grokwh int,Auxkwh int,TotRunPact int,TotRunPnomAll int,SumMWh int,Generator nvarchar(255),Reason nvarchar(255))

DROP TABLE IF EXISTS #JsonGeneratorStaging;
CREATE TABLE #JsonGeneratorStaging([JsonTXT] [varchar](MAX) NOT NULL)

-- Copy file in its raw format
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'
INSERT INTO #JsonGeneratorStaging
(
	JsonTXT
)
SELECT BulkColumn
FROM OPENROWSET(
	BULK ''' + @bulkFile  + ''', 
	DATA_SOURCE = ''JsonGeneratorImport-Storage'',
	SINGLE_CLOB) as t
';

--PRINT @sql;
EXEC(@sql);

-- Set the variable
SELECT @_JSONData = JsonTXT FROM #JsonGeneratorStaging

SET @_UtcRecieved = GETUTCDATE()

-- Validate JSON
IF (NOT ISJSON(@_JSONData) > 0)  
BEGIN
	PRINT 'ERROR: The JSON data is not valid.'  
	RETURN(1)  
END

DECLARE @totalKeys INT
DECLARE @currentKey INT = 0;

SELECT @totalKeys = COUNT(*)
FROM OPENJSON(@_JSONData)

--Loop each row
WHILE @currentKey < @totalKeys
BEGIN

	--PRINT 'Current key: ' + CAST(@currentKey AS VARCHAR);

	-- Process it
	BEGIN TRY
	-- Make sure site serial serial exists
	SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@_JSONData, '$[' + CAST(@currentKey AS VARCHAR) + '].Header.Serial')
	IF @_IdLocation = 0
		BEGIN
			PRINT 'ERROR: The Generator Serial does not exist.'  
			RETURN(2)  
		END
	-- Does the event id exist
	SELECT @_IdEvent = ID from dbo.HL_Events where REASON = JSON_VALUE(@_JSONData, '$[' + CAST(@currentKey AS VARCHAR) + '].Record.Reason')
	IF @_IdEvent = 0
		BEGIN
			PRINT 'ERROR: The Event does not exist.'
			RETURN(3)  
		END
	-- Is it event json or standard data
	IF LEN(JSON_VALUE(@_JSONData, '$[' + CAST(@currentKey AS VARCHAR) + '].Content.Event')) > 0
		BEGIN
			PRINT 'INFO: Processing event.'
			-- Insert the data into the content table
			INSERT INTO #GeneratorContentTemp([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdEvent],[Event])
			SELECT @_IdLocation,GETUTCDATE(),[UtcGenerated],[TimeStamp],@_IdEvent,[Event]
			FROM OPENJSON(@_JSONData, '$[' + CAST(@currentKey AS VARCHAR) + ']')
				WITH (
					[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
					[TimeStamp] datetime N'strict $.Record.TimeStamp',
					[Event] nvarchar(256) N'$.Content.Event'
				) S WHERE NOT EXISTS (SELECT * FROM dbo.GeneratorContent Dest WHERE @_IdLocation = Dest.IdLocation AND S.TimeStamp = Dest.TimeStamp AND @_IdEvent = Dest.IdEvent)
		END
	ELSE
		BEGIN
			--PRINT 'INFO: Processing data.'
			-- We want to save the undefined keys into the Extended column of the destination table, i.e. dynamic columns
			SET @_JSONExtended = JSON_QUERY(@_JSONData,'$[' + CAST(@currentKey AS VARCHAR) + '].Content');

			--PRINT @_JSONExtended

			-- for each column in destination table, delete its json key, the remaining data will be the undefined keys
			DECLARE @MyCursor CURSOR;
			DECLARE @MyField NVARCHAR(128);
			BEGIN
				SET @MyCursor = CURSOR FOR
				SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_NAME = N'GeneratorContent'   

				OPEN @MyCursor 
				FETCH NEXT FROM @MyCursor 
				INTO @MyField

				WHILE @@FETCH_STATUS = 0
				BEGIN
					--PRINT 'Removing::' + @MyField
					SET @_JSONExtended=JSON_MODIFY(@_JSONExtended,'$.' + @MyField,NULL)
					--PRINT @JSONExtended
					FETCH NEXT FROM @MyCursor 
					INTO @MyField 
				END; 

				CLOSE @MyCursor ;
				DEALLOCATE @MyCursor;
			END;

			-- Insert the data into the content table
			INSERT INTO #GeneratorContentTemp([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdEvent],[Event],[Extended],[RPM],[Pwr],[PF],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[Mfrq],[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[MPF],[SRO],[VRO],[Mode],[kWhour],[Runhrs],[ActPwr],[ActDem],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5],[CylA6],[CylA7],[CylA8],[CylA9],[CylA10],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[CylB9],[CylB10],[BIN],[BOUT],[MVS],[ActPwrReq],[Ubat],[CPUT],[TEMv],[LChr],[OilB4F],[OilLev],[OilT],[CCPres],[AirInT],[RecAT],[ThrPos],[CH4],[JWTin],[JWTout],[Numstr],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BI12],[BO1],[BO2],[BO3],[BO4],[BO5],[Pmns],[Qmns],[ActPfi],[MLChr],[Amb],[kVarho],[GasP],[LTHWfT],[LTHWrT],[GFlwRte],[GFlwM3],[H2S],[NumUns],[PwrDem],[JWGKin],[HWFlo],[HWRtn],[GasMet],[IcOut],[ImpLoad],[Q],[U],[V],[W],[Grokwh],[Auxkwh],[TotRunPact],[TotRunPnomAll],[SumMWh])
			SELECT [IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdEvent],[Event],[Extended],[RPM],[Pwr],[PF],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[Mfrq],[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[MPF],[SRO],[VRO],[Mode],[kWhour],[Runhrs],[ActPwr],[ActDem],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5],[CylA6],[CylA7],[CylA8],[CylA9],[CylA10],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[CylB9],[CylB10],[BIN],[BOUT],[MVS],[ActPwrReq],[Ubat],[CPUT],[TEMv],[LChr],[OilB4F],[OilLev],[OilT],[CCPres],[AirInT],[RecAT],[ThrPos],[CH4],[JWTin],[JWTout],[Numstr],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BI12],[BO1],[BO2],[BO3],[BO4],[BO5],[Pmns],[Qmns],[ActPfi],[MLChr],	[Amb],[kVarho],[GasP],[LTHWfT],[LTHWrT],[GFlwRte],[GFlwM3],[H2S],[NumUns],[PwrDem],[JWGKin],[HWFlo],[HWRtn],[GasMet],[IcOut],[ImpLoad],[Q],[U],[V],[W],[Grokwh],[Auxkwh],[TotRunPact],[TotRunPnomAll],[SumMWh]
			FROM
			(
				SELECT @_IdLocation AS IdLocation,@_UtcRecieved AS UtcRecieved,[UtcGenerated],[TimeStamp],@_IdEvent AS IdEvent,[Event],LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@_JSONExtended,CHAR(32), ''), CHAR(10), ''), CHAR(13), ''), CHAR(9), ''))) AS Extended,[RPM],[Pwr],[PF],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[Mfrq],[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[MPF],[SRO],[VRO],[Mode],[kWhour],[Runhrs],[ActPwr],[ActDem],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5],[CylA6],[CylA7],[CylA8],[CylA9],[CylA10],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[CylB9],[CylB10],[BIN],[BOUT],[MVS],[ActPwrReq],[Ubat],[CPUT],[TEMv],[LChr],[OilB4F],[OilLev],[OilT],[CCPres],[AirInT],[RecAT],[ThrPos],[CH4],[JWTin],[JWTout],[Numstr],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BI12],[BO1],[BO2],[BO3],[BO4],[BO5],[Pmns],[Qmns],[ActPfi],[MLChr],[Amb],[kVarho],[GasP],[LTHWfT],[LTHWrT],[GFlwRte],[GFlwM3],[H2S],[NumUns],[PwrDem],[JWGKin],[HWFlo],[HWRtn],[GasMet],[IcOut],[ImpLoad],[Q],[U],[V],[W],[Grokwh],[Auxkwh],[TotRunPact],[TotRunPnomAll],[SumMWh]
				FROM
				(
					SELECT [UtcGenerated],[TimeStamp],[Event],[RPM],[Pwr],[PF],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[Mfrq],[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],
						   [MPF],[SRO],[VRO],[Mode],[kWhour],[Runhrs],[ActPwr],[ActDem],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5],[CylA6],[CylA7],[CylA8],[CylA9],[CylA10],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],
						   [CylB9],[CylB10],[BIN],[BOUT],[MVS],[ActPwrReq],[Ubat],[CPUT],[TEMv],[LChr],[OilB4F],[OilLev],[OilT],[CCPres],[AirInT],[RecAT],[ThrPos],[CH4],[JWTin],[JWTout],[Numstr],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],
						   [BI7],[BI8],[BI9],[BI10],[BI11],[BI12],[BO1],[BO2],[BO3],[BO4],[BO5],[Pmns],[Qmns],[ActPfi],[MLChr],[Amb],[kVarho],[GasP],[LTHWfT],[LTHWrT],[GFlwRte],[GFlwM3],[H2S],[NumUns],[PwrDem],[JWGKin],[HWFlo],
						   [HWRtn],[GasMet],[IcOut],[ImpLoad],[Q],[U],[V],[W],[Grokwh],[Auxkwh],[TotRunPact],[TotRunPnomAll],[SumMWh]
					FROM OPENJSON(@_JSONData, '$[' + CAST(@currentKey AS VARCHAR) + ']')
					WITH (
							[UtcGenerated] datetime N'strict $.Header.UtcGenerated',[TimeStamp] datetime N'strict $.Record.TimeStamp',[Event] nvarchar(256) N'$.Content.Event',[RPM] smallint N'$.Content.RPM',
								[Pwr] smallint N'$.Content.Pwr',[PF] float N'$.Content.PF',[Gfrq] float N'$.Content.Gfrq',[Vg1] smallint N'$.Content.Vg1',[Vg2] smallint N'$.Content.Vg2',[Vg3] smallint N'$.Content.Vg3',
								[Vg12] smallint N'$.Content.Vg12',[Vg23] smallint N'$.Content.Vg23',[Vg31] smallint N'$.Content.Vg31',[Ig1] smallint N'$.Content.Ig1',[Ig2] smallint N'$.Content.Ig2',[Ig3] smallint N'$.Content.Ig3',
								[Mfrq] float N'$.Content.Mfrq',[Vm1] smallint N'$.Content.Vm1',[Vm2] smallint N'$.Content.Vm2',[Vm3] smallint N'$.Content.Vm3',[Vm12] smallint N'$.Content.Vm12',[Vm23] smallint N'$.Content.Vm23',
								[Vm31] smallint N'$.Content.Vm31',[MPF] float N'$.Content.MPF',[SRO] float N'$.Content.SRO',[VRO] float N'$.Content.VRO',[Mode] char(3) N'$.Content.Mode',[kWhour] int N'$.Content.kWhour',
								[Runhrs] int N'$.Content.Runhrs',[ActPwr] smallint N'$.Content.ActPwr',[ActDem] smallint N'$.Content.ActDem',[CylA1] smallint N'$.Content.CylA1',[CylA2] smallint N'$.Content.CylA2',[CylA3] smallint N'$.Content.CylA3',
								[CylA4] smallint N'$.Content.CylA4',[CylA5] smallint N'$.Content.CylA5',[CylA6] smallint N'$.Content.CylA6',[CylA7] smallint N'$.Content.CylA7',[CylA8] smallint N'$.Content.CylA8',[CylA9] smallint N'$.Content.CylA9',
								[CylA10] smallint N'$.Content.CylA10',[CylB1] smallint N'$.Content.CylB1',[CylB2] smallint N'$.Content.CylB2',[CylB3] smallint N'$.Content.CylB3',[CylB4] smallint N'$.Content.CylB4',[CylB5] smallint N'$.Content.CylB5',
								[CylB6] smallint N'$.Content.CylB6',[CylB7] smallint N'$.Content.CylB7',[CylB8] smallint N'$.Content.CylB8',[CylB9] smallint N'$.Content.CylB9',[CylB10] smallint N'$.Content.CylB10',[BIN] nchar(16) N'$.Content.BIN',
								[BOUT] nchar(16) N'$.Content.BOUT',[MVS] float N'$.Content.MVS',[ActPwrReq] smallint N'$.Content.ActPwrReq',[Ubat] float N'$.Content.Ubat',[CPUT] float N'$.Content.CPUT',[TEMv] float N'$.Content.TEMv',
								[LChr] char(1) N'$.Content.LChr',[OilB4F] float N'$.Content.OilB4F',[OilLev] float N'$.Content.OilLev',[OilT] float N'$.Content.OilT',[CCPres] float N'$.Content.CCPres',[AirInT] float N'$.Content.AirInT',
								[RecAT] float N'$.Content.RecAT',[ThrPos] float N'$.Content.ThrPos',[CH4] float N'$.Content.CH4',[JWTin] float N'$.Content.JWTin',[JWTout] float N'$.Content.JWTout',[Numstr] smallint N'$.Content.Numstr',
								[BI1] nchar(8) N'$.Content.BI1',[BI2] nchar(8) N'$.Content.BI2',[BI3] nchar(8) N'$.Content.BI3',[BI4] nchar(8) N'$.Content.BI4',[BI5] nchar(8) N'$.Content.BI5',[BI6] nchar(8) N'$.Content.BI6',
								[BI7] nchar(8) N'$.Content.BI7',[BI8] nchar(8) N'$.Content.BI8',[BI9] nchar(8) N'$.Content.BI9',[BI10] nchar(8) N'$.Content.BI10',[BI11] nchar(8) N'$.Content.BI11',[BI12] nchar(8) N'$.Content.BI12',
								[BO1] nchar(8) N'$.Content.BO1',[BO2] nchar(8) N'$.Content.BO2',[BO3] nchar(8) N'$.Content.BO3',[BO4] nchar(8) N'$.Content.BO4',[BO5] nchar(8) N'$.Content.BO5',[Pmns] smallint N'$.Content.Pmns',
								[Qmns] smallint N'$.Content.Qmns',[ActPfi] smallint N'$.Content.ActPfi',[MLChr] char(1) N'$.Content.MLChr',[Amb] float N'$.Content.Amb',[kVarho] int N'$.Content.kVarho',[GasP] float N'$.Content.GasP',
								[LTHWfT] float N'$.Content.LTHWfT',[LTHWrT] float N'$.Content.LTHWrT',[GFlwRte] float N'$.Content.GFlwRte',[GFlwM3] int N'$.Content.GFlwM3',[H2S] smallint N'$.Content.H2S',[NumUns] smallint N'$.Content.NumUns',
								[PwrDem] smallint N'$.Content.PwrDem',[JWGKin] float N'$.Content.JWGKin',[HWFlo] float N'$.Content.HWFlo',[HWRtn] float N'$.Content.HWRtn',[GasMet] int N'$.Content.GasMet',[IcOut] smallint N'$.Content.IcOut',
								[ImpLoad] smallint N'$.Content.ImpLoad',[Q] float N'$.Content.Q',[U] float N'$.Content.U',[V] float N'$.Content.V',[W] float N'$.Content.W',[Grokwh] int N'$.Content.Grokwh',
								[Auxkwh] int N'$.Content.Auxkwh',[TotRunPact] smallint N'$.Content.TotRunPact',[TotRunPnomAll] smallint N'$.Content.TotRunPnomAll',[SumMWh] smallint N'$.Content.SumMWh'
					)
				) X) S WHERE NOT EXISTS (SELECT * FROM dbo.GeneratorContent Dest WHERE s.IdLocation = Dest.IdLocation AND S.TimeStamp = Dest.TimeStamp AND S.IdEvent = Dest.IdEvent)
		END
	END TRY
	BEGIN CATCH
		PRINT 'Unhandled error in procedure...';
		THROW;
	END CATCH;

	SET @currentKey = @currentKey + 1;
END
PRINT 'All keys processed: ' + CAST(@currentKey AS VARCHAR);

INSERT INTO dbo.GeneratorContent (
	[IdLocation], [UtcRecieved], [UtcGenerated], [TimeStamp], [IdEvent], [Event], [Extended], [RPM], [Pwr], [PF], [Gfrq],
	[Vg1], [Vg2], [Vg3], [Vg12], [Vg23], [Vg31], [Ig1], [Ig2], [Ig3], [Mfrq], [Vm1], [Vm2], [Vm3], [Vm12], [Vm23], [Vm31],
	[MPF], [SRO], [VRO], [Mode], [kWhour], [Runhrs], [ActPwr], [ActDem], [CylA1], [CylA2], [CylA3], [CylA4], [CylA5],
	[CylA6], [CylA7], [CylA8], [CylA9], [CylA10], [CylB1], [CylB2], [CylB3], [CylB4], [CylB5], [CylB6], [CylB7], [CylB8],
	[CylB9], [CylB10], [BIN], [BOUT], [MVS], [ActPwrReq], [Ubat], [CPUT], [TEMv], [LChr], [OilB4F], [OilLev], [OilT],
	[CCPres], [AirInT], [RecAT], [ThrPos], [CH4], [JWTin], [JWTout], [Numstr], [BI1], [BI2], [BI3], [BI4], [BI5], [BI6],
	[BI7], [BI8], [BI9], [BI10], [BI11], [BI12], [BO1], [BO2], [BO3], [BO4], [BO5], [Pmns], [Qmns], [ActPfi], [MLChr],
	[Amb], [kVarho], [GasP], [LTHWfT], [LTHWrT], [GFlwRte], [GFlwM3], [H2S], [NumUns], [PwrDem], [JWGKin], [HWFlo],
	[HWRtn], [GasMet], [IcOut], [ImpLoad], [Q], [U], [V], [W], [Grokwh], [Auxkwh], [TotRunPact], [TotRunPnomAll], [SumMWh])
SELECT 
	[IdLocation], [UtcRecieved], [UtcGenerated], [TimeStamp], [IdEvent], [Event], [Extended], [RPM], [Pwr], [PF], [Gfrq],
	[Vg1], [Vg2], [Vg3], [Vg12], [Vg23], [Vg31], [Ig1], [Ig2], [Ig3], [Mfrq], [Vm1], [Vm2], [Vm3], [Vm12], [Vm23], [Vm31],
	[MPF], [SRO], [VRO], [Mode], [kWhour], [Runhrs], [ActPwr], [ActDem], [CylA1], [CylA2], [CylA3], [CylA4], [CylA5],
	[CylA6], [CylA7], [CylA8], [CylA9], [CylA10], [CylB1], [CylB2], [CylB3], [CylB4], [CylB5], [CylB6], [CylB7], [CylB8],
	[CylB9], [CylB10], [BIN], [BOUT], [MVS], [ActPwrReq], [Ubat], [CPUT], [TEMv], [LChr], [OilB4F], [OilLev], [OilT],
	[CCPres], [AirInT], [RecAT], [ThrPos], [CH4], [JWTin], [JWTout], [Numstr], [BI1], [BI2], [BI3], [BI4], [BI5], [BI6],
	[BI7], [BI8], [BI9], [BI10], [BI11], [BI12], [BO1], [BO2], [BO3], [BO4], [BO5], [Pmns], [Qmns], [ActPfi], [MLChr],
	[Amb], [kVarho], [GasP], [LTHWfT], [LTHWrT], [GFlwRte], [GFlwM3], [H2S], [NumUns], [PwrDem], [JWGKin], [HWFlo],
	[HWRtn], [GasMet], [IcOut], [ImpLoad], [Q], [U], [V], [W], [Grokwh], [Auxkwh], [TotRunPact], [TotRunPnomAll], [SumMWh] 
FROM #GeneratorContentTemp
SET @_RowsInQuery = @@RowCount

DROP TABLE IF EXISTS #GeneratorContentTemp;
RETURN @_RowsInQuery
GO
/****** Object:  StoredProcedure [Staging].[BulkLoadMeterJsonFromAzure]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Staging].[BulkLoadMeterJsonFromAzure]
@sourceFileName NVARCHAR(100)
AS

DECLARE @FileID INT;
DECLARE @fileName NVARCHAR(MAX) = REPLACE(@sourceFileName, '.json', '');
DECLARE @bulkFile NVARCHAR(MAX) =  @sourceFileName;
DECLARE @_JSONData AS NVARCHAR(MAX);
DECLARE @_UtcRecieved AS DATETIME;
DECLARE @_type AS NVARCHAR(10);
DECLARE @_IdLocation AS INT;

-- File ID
DROP TABLE IF EXISTS #JsonEnergyMetersResult;
CREATE TABLE #JsonEnergyMetersResult(FileID INT);

INSERT INTO #JsonEnergyMetersResult EXEC [Staging].[SetJsonEnergyMetersFileMetadata] @fileName;
SELECT TOP 1 @FileID = FileID  FROM #JsonEnergyMetersResult;

DROP TABLE IF EXISTS #JsonEnergyMeterStaging;
CREATE TABLE #JsonEnergyMeterStaging([JsonTXT] [varchar](MAX) NOT NULL)

-- Copy file in its raw format
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'
INSERT INTO #JsonEnergyMeterStaging
(
	JsonTXT
)
SELECT BulkColumn
FROM OPENROWSET(
	BULK ''' + @bulkFile  + ''', 
	DATA_SOURCE = ''JsonEnergyMeterImport-Storage'',
	SINGLE_CLOB) as t
';

--PRINT @sql;
EXEC(@sql);

-- Set the variable
SELECT @_JSONData = JsonTXT FROM #JsonEnergyMeterStaging

SET @_UtcRecieved = GETUTCDATE()

-- Validate JSON
IF (NOT ISJSON(@_JSONData) > 0)  
BEGIN
	PRINT 'ERROR: The JSON data is not valid.'   
END
SELECT @_IdLocation = ID from dbo.HL_Locations where GENSET_SN = JSON_VALUE(@_JSONData, '$[0].Header.Serial')
IF @_IdLocation IS NULL
BEGIN
	PRINT 'ERROR: The Generator Serial does not exist.'   
END

-- What type of meter
SELECT @_type = JSON_VALUE(@_JSONData, N'strict $[0].Header.Type')
IF @_type = 'DirisA20'
	BEGIN
		INSERT INTO EnergyMeters.DirisA20([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[Serial],[I-1],[I-2],[I-3],[I-N],[V1-2],[V2-3],[V3-1],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr])
		SELECT ID,@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[Serial],[I-1],[I-2],[I-3],[I-N],[V1-2],[V2-3],[V3-1],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr]
		FROM (
		SELECT L.ID,[UtcGenerated],[TimeStamp],[IdMeter],[Serial],[I-1],[I-2],[I-3],[I-N],[V1-2],[V2-3],[V3-1],[V1-N],[V2-N],[V3-N],[F],[P],[Q],[S],[PF],[W],[Wr]
		FROM OPENJSON(@_JSONData) WITH ([GensetSerial] nvarchar(9) N'strict $.Header.Serial',[UtcGenerated] datetime N'strict $.Header.UtcGenerated',[TimeStamp] datetime N'strict $.Record.TimeStamp',
						[IdMeter] int N'$.Record.MeterId',[Serial] nchar(12) N'$.Record.Serial',[I-1] float N'$.Readings.I1',[I-2] float N'$.Readings.I2',[I-3] float N'$.Readings.I3',[I-N] float N'$.Readings.IN',
						[V1-2] float N'$.Readings.V1V2',[V2-3] float N'$.Readings.V2V3',[V3-1] float N'$.Readings.V3V1',[V1-N] float N'$.Readings.V1N',	[V2-N] float N'$.Readings.V2N',[V3-N] float N'$.Readings.V3N',
						[F] float N'$.Readings.F',[P] float N'$.Readings.P',[Q] float N'$.Readings.Q',[S] float N'$.Readings.S',[PF] float N'$.Readings.PF',[W] float N'$.Readings.W',[Wr] float N'$.Readings.Wr'
						) M	INNER JOIN HL_Locations L ON M.GensetSerial = L.GENSET_SN) AS DirisData
		WHERE NOT EXISTS (SELECT * FROM EnergyMeters.DirisA20 Dest WHERE DirisData.[TimeStamp] = Dest.TimeStamp AND DirisData.ID = Dest.IdLocation AND DirisData.IdMeter = Dest.IdMeter)
	END
ELSE IF @_type = 'E650'
	BEGIN
		INSERT INTO EnergyMeters.E650([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[Serial],[F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0],[4_6_0],[1_8_1],[2_8_1],
									  [3_8_1],[4_8_1],[0_4_2],[32_7],[52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],[1-1:32_32_0],[1-1:52_32_0],[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0])
		SELECT ID,@_UtcRecieved,[UtcGenerated],[TimeStamp],[Serial],[F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0],[4_6_0],[1_8_1],[2_8_1],[3_8_1],[4_8_1],[0_4_2],[32_7],
									  [52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],[1-1:32_32_0],[1-1:52_32_0],[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0]
		FROM (
		SELECT L.ID,[UtcGenerated],[TimeStamp],[Serial],[F_F],[0_9_1],[0_9_2],[1_2_0],[2_2_0],[3_2_0],[4_2_0],[1_6_0],[2_6_0],[3_6_0],[4_6_0],[1_8_1],[2_8_1],[3_8_1],[4_8_1],[0_4_2],[32_7],
									  [52_7],[72_7],[1-1:32_36_0],[1-1:52_36_0],[1-1:72_36_0],[1-1:32_32_0],[1-1:52_32_0],[1-1:72_32_0],[16_7_0],[36_7_0],[56_7_0],[1_8_0]
		FROM OPENJSON(@_JSONData)
				WITH ([GensetSerial] nvarchar(9) N'strict $.Header.Serial',[UtcGenerated] datetime N'strict $.Header.UtcGenerated',[TimeStamp] datetime N'strict $.Record.TimeStamp',
					[IdMeter] int N'$.Record.MeterId',[Serial] nchar(12) N'$.Record.Serial',[F_F] nchar(10) '$.Readings."F.F"',[0_9_1] nchar(12) '$.Readings."0.9.1"',
					[0_9_2] nchar(12) '$.Readings."0.9.2"',[1_2_0] nchar(12) '$.Readings."1.2.0"',[2_2_0] nchar(12) '$.Readings."2.2.0"',[3_2_0] nchar(12) '$.Readings."3.2.0"',
					[4_2_0] nchar(12) '$.Readings."4.2.0"',[1_6_0] nchar(12) '$.Readings."1.6.0"',[2_6_0] nchar(12) '$.Readings."2.6.0"',[3_6_0] nchar(12) '$.Readings."3.6.0"',
					[4_6_0] nchar(12) '$.Readings."4.6.0"',[1_8_1] nchar(12) '$.Readings."1.8.1"',[2_8_1] nchar(12) '$.Readings."2.8.1"',[3_8_1] nchar(12) '$.Readings."3.8.1"',
					[4_8_1] nchar(12) '$.Readings."4.8.1"',[0_4_2] nchar(12) '$.Readings."0.4.2"',[32_7] nchar(12) '$.Readings."32.7"',[52_7] nchar(12) '$.Readings."52.7"',
					[72_7] nchar(12) '$.Readings."72.7"',[1-1:32_36_0] nchar(12) '$.Readings."1-1:32.36.0"',[1-1:52_36_0] nchar(12) '$.Readings."1-1:52.36.0"',
					[1-1:72_36_0] nchar(12) '$.Readings."1-1:72.36.0"',[1-1:32_32_0] nchar(12) '$.Readings."1-1:32.32.0"',[1-1:52_32_0] nchar(12) '$.Readings."1-1:52.32.0"',
					[1-1:72_32_0] nchar(12) '$.Readings."1-1:72.32.0"',[16_7_0] nchar(12) '$.Readings."16.7.0"',[36_7_0] nchar(12) '$.Readings."36.7.0"',[56_7_0] nchar(12) '$.Readings."56.7.0"',
					[1_8_0] nchar(12) '$.Readings."1.8.0"')	M INNER JOIN HL_Locations L ON M.GensetSerial = L.GENSET_SN) AS E650Data
		WHERE NOT EXISTS (SELECT * FROM EnergyMeters.E650 Dest WHERE E650Data.[TimeStamp] = Dest.TimeStamp AND E650Data.ID = Dest.IdLocation AND E650Data.Serial = Dest.Serial)
	END
ELSE IF @_type = 'Heat'
	BEGIN
		INSERT INTO EnergyMeters.Heat([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[Power],[Energy],[Flow],[TempWarm],[TempCold])
		SELECT [ID],@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[Power],[Energy],[Flow],[TempWarm],[TempCold]
		FROM (
		SELECT L.ID,[UtcGenerated],[TimeStamp],[IdMeter],[Power],[Energy],[Flow],[TempWarm],[TempCold]
		FROM OPENJSON(@_JSONData)
			WITH (
				[GensetSerial] nvarchar(9) N'strict $.Header.Serial',
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[Power] float N'$.Readings.Power',
				[Energy] float N'$.Readings.Energy',
				[Flow] float N'$.Readings.Flow',
				[TempWarm] float N'$.Readings.TempWarm',
				[TempCold] float N'$.Readings.TempCold') M INNER JOIN HL_Locations L ON M.GensetSerial = L.GENSET_SN) AS HeatData
		WHERE NOT EXISTS (SELECT * FROM EnergyMeters.Heat Dest WHERE HeatData.[TimeStamp] = Dest.[TimeStamp] AND HeatData.ID = Dest.IdLocation AND HeatData.IdMeter = Dest.IdMeter)
	END
ELSE IF @_type = 'Gas'
	BEGIN
		INSERT INTO EnergyMeters.Gas([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[MassFlow],[Totaliser])
		SELECT [ID],@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[MassFlow],[Totaliser]
		FROM (
		SELECT L.ID,[UtcGenerated],[TimeStamp],[IdMeter],[MassFlow],[Totaliser]
		FROM OPENJSON(@_JSONData)
			WITH (
				[GensetSerial] nvarchar(9) N'strict $.Header.Serial',
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[MassFlow] float N'$.Readings.MassFlow',
				[Totaliser] float N'$.Readings.Totaliser') M INNER JOIN HL_Locations L ON M.GensetSerial = L.GENSET_SN) AS GasData
		WHERE NOT EXISTS (SELECT * FROM EnergyMeters.Gas Dest WHERE GasData.[TimeStamp] = Dest.[TimeStamp] AND GasData.ID = Dest.IdLocation AND GasData.IdMeter = Dest.IdMeter)
	END
ELSE IF @_type = 'Steam'
	BEGIN
		INSERT INTO EnergyMeters.Steam([IdLocation],[UtcRecieved],[UtcGenerated],[TimeStamp],[IdMeter],[Power],[VolFlow],[MassFlow],[Temp],[Pressure],[Energy])
		SELECT [ID],@_UtcRecieved,[UtcGenerated],[TimeStamp],[IdMeter],[Power],[VolFlow],[MassFlow],[Temp],[Pressure],[Energy]
		FROM (
		SELECT L.ID,[UtcGenerated],[TimeStamp],[IdMeter],[Power],[VolFlow],[MassFlow],[Temp],[Pressure],[Energy]
		FROM OPENJSON(@_JSONData)
			WITH (
				[GensetSerial] nvarchar(9) N'strict $.Header.Serial',
				[UtcGenerated] datetime N'strict $.Header.UtcGenerated',
				[TimeStamp] datetime N'strict $.Record.TimeStamp',
				[IdMeter] int N'$.Record.MeterId',
				[Power] float N'$.Readings.Power',
				[VolFlow] float N'$.Readings.VolFlow',
				[MassFlow] float N'$.Readings.MassFlow',
				[Temp] float N'$.Readings.Temp',
				[Pressure] float N'$.Readings.Pressure',
				[Energy] float N'$.Readings.Energy') M INNER JOIN HL_Locations L ON M.GensetSerial = L.GENSET_SN) AS SteamData
		WHERE NOT EXISTS (SELECT * FROM EnergyMeters.Steam Dest WHERE SteamData.[TimeStamp] = Dest.[TimeStamp] AND SteamData.ID = Dest.IdLocation AND SteamData.IdMeter = Dest.IdMeter)
	END

	--Cleanup
   DROP TABLE IF EXISTS #JsonEnergyMetersResult;
   DROP TABLE IF EXISTS #JsonEnergyMeterStaging;
GO
/****** Object:  StoredProcedure [Staging].[FixBadNumericsGeneratorLog]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [Staging].[FixBadNumericsGeneratorLog]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Fix SmallInts
	 UPDATE Staging.GeneratorLog SET Pwr = REPLACE(Pwr,'--','-')
	 FROM Staging.GeneratorLog WHERE HL_Processed is null

	 UPDATE Staging.GeneratorLog SET ActPwr = REPLACE(ActPwr,'--','-')
	 FROM Staging.GeneratorLog WHERE HL_Processed is null

	 UPDATE Staging.GeneratorLog SET ActPfi = REPLACE(ActPfi,'--','-')
	 FROM Staging.GeneratorLog WHERE HL_Processed is null

	 UPDATE Staging.GeneratorLog SET H2S = REPLACE(H2S,'--','-')
	 FROM Staging.GeneratorLog WHERE HL_Processed is null

	 -- Fix floats
	UPDATE Staging.GeneratorLog SET CCpres = REPLACE(CCpres,'--','-')
	FROM Staging.GeneratorLog WHERE HL_Processed IS NULL

	UPDATE Staging.GeneratorLog SET CH4 = REPLACE(CH4,'--','-')
	FROM Staging.GeneratorLog WHERE HL_Processed IS NULL

	UPDATE Staging.GeneratorLog SET LTHWfT = REPLACE(LTHWfT,'--','-')
	FROM Staging.GeneratorLog WHERE HL_Processed IS NULL
	
	UPDATE Staging.GeneratorLog SET LTHWrT = REPLACE(LTHWrT,'--','-')
	FROM Staging.GeneratorLog WHERE HL_Processed IS NULL

END
GO
/****** Object:  StoredProcedure [Staging].[Import_MergeGeneratorDataToGeneratorLog]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Neil Rutherford>
-- Create date: <13/12/2011>
-- Description:	<Copy data from dbo.RTCU to dbo.HistoryLog ignoring duplicate records and uses fixed columns>
-- =============================================
CREATE PROCEDURE [Staging].[Import_MergeGeneratorDataToGeneratorLog]

AS

--Add the new data to the SQL
BEGIN TRANSACTION

SET DATEFORMAT dmy;

 --Insert goes here
INSERT INTO [Staging].GeneratorLog(ItemDATE, ItemTIME, SITENAME, GENSETNAME, GENSET_SN, REASON, [EVENT]
	  ,[RPM],[Pwr],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[BIN],[BOUT],[Mode],[LTHWrT],[LTHWfT]
      ,[OilB4F],[CCpres],[OilLev],[ActPfi],[ActDem],[CH4],[OilT],[AirInT],[RecAT],[JWTout],[JWTin],[JWGKin],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5]
      ,[CylA6],[CylA7],[CylA8],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[kWhour],[Runhrs],[Numstr],[NumUns],[Q],[LChr],[Mfrq]
      ,[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[Pmns],[Qmns],[MPF],[MVS],[SRO],[VRO],[UBat],[CPUT],[ActPwr],[Amb],[GasP],[GasMet],[PF],[H2S]
      ,[ThrPos],[kVarho],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BO1],[BO2],[BO3],[CylA9],[CylA10],[CylB9],[CylB10],[BI12],[TEMv]
	  ,[MLChr],[GroKwh],[BO4],[IcOut],[D+],[U],[V],[W],[GFlwRte],[GFlwM3],[Spare],[HWFlo],[HWRtn],[HtMet],[ChMet],[BO5],[TotRunPact],[TotRunPnomAll]
      ,[SumMWh],[PwrDem],[ActPwrReq],[ImpLoad],[AuxKwh])
	                     
			 SELECT CONVERT(DATETIME,ItemDATE,103), ItemTIME, SITENAME, GENSETNAME, GENSET_SN, REASON, [EVENT]
			  ,[RPM],[Pwr],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[BIN],[BOUT],[Mode],[LTHWrT],[LTHWfT]
			  ,[OilB4F],[CCpres],[OilLev],[ActPfi],[ActDem],[CH4],[OilT],[AirInT],[RecAT],[JWTout],[JWTin],[JWGKin],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5]
			  ,[CylA6],[CylA7],[CylA8],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[kWhour],[Runhrs],[Numstr],[NumUns],[Q],[LChr],[Mfrq]
			  ,[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[Pmns],[Qmns],[MPF],[MVS],[SRO],[VRO],[UBat],[CPUT],[ActPwr],[Amb],[GasP],[GasMet],[PF],[H2S]
			  ,[ThrPos],[kVarho],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BO1],[BO2],[BO3],[CylA9],[CylA10],[CylB9],[CylB10],[BI12],[TEMv]
			  ,[MLChr],[GroKwh],[BO4],[IcOut],[D+],[U],[V],[W],[GFlwRte],[GFlwM3],[Spare],[HWFlo],[HWRtn],[HtMet],[ChMet],[BO5],[TotRunPact],[TotRunPnomAll]
			  ,[SumMWh],[PwrDem],[ActPwrReq],[ImpLoad],[AuxKwh]
			  FROM
			  (
						SELECT CONVERT(DATETIME,ItemDATE,103) AS ItemDATE, ItemTIME, SITENAME, GENSETNAME, GENSET_SN, REASON, [EVENT]
						  ,[RPM],[Pwr],[Gfrq],[Vg1],[Vg2],[Vg3],[Vg12],[Vg23],[Vg31],[Ig1],[Ig2],[Ig3],[BIN],[BOUT],[Mode],[LTHWrT],[LTHWfT]
						  ,[OilB4F],[CCpres],[OilLev],[ActPfi],[ActDem],[CH4],[OilT],[AirInT],[RecAT],[JWTout],[JWTin],[JWGKin],[CylA1],[CylA2],[CylA3],[CylA4],[CylA5]
						  ,[CylA6],[CylA7],[CylA8],[CylB1],[CylB2],[CylB3],[CylB4],[CylB5],[CylB6],[CylB7],[CylB8],[kWhour],[Runhrs],[Numstr],[NumUns],[Q],[LChr],[Mfrq]
						  ,[Vm1],[Vm2],[Vm3],[Vm12],[Vm23],[Vm31],[Pmns],[Qmns],[MPF],[MVS],[SRO],[VRO],[UBat],[CPUT],[ActPwr],[Amb],[GasP],[GasMet],[PF],[H2S]
						  ,[ThrPos],[kVarho],[BI1],[BI2],[BI3],[BI4],[BI5],[BI6],[BI7],[BI8],[BI9],[BI10],[BI11],[BO1],[BO2],[BO3],[CylA9],[CylA10],[CylB9],[CylB10],[BI12],[TEMv]
						  ,[MLChr],[GroKwh],[BO4],[IcOut],[D+],[U],[V],[W],[GFlwRte],[GFlwM3],[Spare],[HWFlo],[HWRtn],[HtMet],[ChMet],[BO5],[TotRunPact],[TotRunPnomAll]
						  ,[SumMWh],[PwrDem],[ActPwrReq],[ImpLoad],[AuxKwh],
				
						rn = ROW_NUMBER() OVER 
						(
							  PARTITION BY ItemDATE, ItemTIME, GENSET_SN
							  ORDER BY RPM DESC
						)
						FROM [Staging].[GeneratorData]
				) AS GeneratorData
					WHERE rn = 1
					AND NOT EXISTS 
				(
						SELECT 1 FROM [Staging].[GeneratorLog] -- Look for duplicates where all 3 condistions below match
						WHERE ItemDATE  = CONVERT(DATETIME,GeneratorData.ItemDATE,103)
						 AND ItemTIME  = GeneratorData.ItemTIME
						 AND GENSET_SN = GeneratorData.GENSET_SN
				) 
				AND (kWhour >= 0 OR SumMWh > 0 OR [EVENT] NOT LIKE '%[^a-zA-Z0-9 ."=()-]%') -- Conditions for a valid row, kWhour condition update to = to for Heinekin
				AND ISDATE(CONVERT(DATETIME,ItemDATE,103)) = 1 AND ItemDATE IS NOT NULL AND itemTIME IS NOT NULL; -- Conditions for a valid Date

COMMIT TRANSACTION
		
TRUNCATE TABLE Staging.GeneratorData -- Clear the pre-staging table
GO
/****** Object:  StoredProcedure [Staging].[SetEnergyMetersDirisA20FileMetadata]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [Staging].[SetEnergyMetersDirisA20FileMetadata]
@fileName NVARCHAR(128)
AS

SET XACT_ABORT ON

BEGIN TRAN

	DELETE d FROM Staging.[EnergyMetersDirisA20File] d WHERE d.Name = @fileName

	INSERT INTO Staging.[EnergyMetersDirisA20File](Name) OUTPUT inserted.Id VALUES (@fileName)

COMMIT TRAN
GO
/****** Object:  StoredProcedure [Staging].[SetEnergyMetersFileMetadata]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [Staging].[SetEnergyMetersFileMetadata]
@fileName NVARCHAR(128)
AS

SET XACT_ABORT ON

BEGIN TRAN

	DELETE d FROM Staging.[EnergyMetersFile] d WHERE d.Name = @fileName

	INSERT INTO Staging.[EnergyMetersFile](Name) OUTPUT inserted.Id VALUES (@fileName)

COMMIT TRAN
GO
/****** Object:  StoredProcedure [Staging].[SetEnergyMetersLGE650FileMetadata]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Staging].[SetEnergyMetersLGE650FileMetadata]
@fileName NVARCHAR(128)
AS

SET XACT_ABORT ON

BEGIN TRAN

	DELETE d FROM Staging.[EnergyMetersLGE650File] d WHERE d.Name = @fileName

	INSERT INTO Staging.[EnergyMetersLGE650File](Name) OUTPUT inserted.Id VALUES (@fileName)

COMMIT TRAN
GO
/****** Object:  StoredProcedure [Staging].[SetGasMetersFileMetadata]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [Staging].[SetGasMetersFileMetadata]
@fileName NVARCHAR(128)
AS

SET XACT_ABORT ON

BEGIN TRAN

	DELETE d FROM Staging.[GasMetersFile] d WHERE d.Name = @fileName

	INSERT INTO Staging.[GasMetersFile](Name) OUTPUT inserted.Id VALUES (@fileName)

COMMIT TRAN
GO
/****** Object:  StoredProcedure [Staging].[SetGeneratorFileMetadata]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [Staging].[SetGeneratorFileMetadata]
@fileName NVARCHAR(128)
AS

SET XACT_ABORT ON

BEGIN TRAN

	DELETE d FROM Staging.[GeneratorFile] d WHERE d.Name = @fileName

	INSERT INTO Staging.[GeneratorFile](Name) OUTPUT inserted.Id VALUES (@fileName)

COMMIT TRAN
GO
/****** Object:  StoredProcedure [Staging].[SetJsonEnergyMetersFileMetadata]    Script Date: 26/05/2020 18:27:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Staging].[SetJsonEnergyMetersFileMetadata]
@fileName NVARCHAR(128)
AS

SET XACT_ABORT ON

BEGIN TRAN

	DELETE d FROM Staging.[JsonEnergyMetersFile] d WHERE d.Name = @fileName

	INSERT INTO Staging.[JsonEnergyMetersFile](Name) OUTPUT inserted.Id VALUES (@fileName)

COMMIT TRAN
GO
USE [master]
GO
ALTER DATABASE [ReportingSystemProd] SET  READ_WRITE 
GO
