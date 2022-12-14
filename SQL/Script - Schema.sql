USE [master]
GO
/****** Object:  Database [sqlfenix]    Script Date: 28/08/2022 8:06:37 ******/
CREATE DATABASE [sqlfenix]
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [sqlfenix].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [sqlfenix] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [sqlfenix] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [sqlfenix] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [sqlfenix] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [sqlfenix] SET ARITHABORT OFF 
GO
ALTER DATABASE [sqlfenix] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [sqlfenix] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [sqlfenix] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [sqlfenix] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [sqlfenix] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [sqlfenix] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [sqlfenix] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [sqlfenix] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [sqlfenix] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [sqlfenix] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [sqlfenix] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [sqlfenix] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [sqlfenix] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [sqlfenix] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [sqlfenix] SET  MULTI_USER 
GO
ALTER DATABASE [sqlfenix] SET DB_CHAINING OFF 
GO
ALTER DATABASE [sqlfenix] SET ENCRYPTION ON
GO
ALTER DATABASE [sqlfenix] SET QUERY_STORE = ON
GO
ALTER DATABASE [sqlfenix] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 7), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 10, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [sqlfenix]
GO
ALTER DATABASE SCOPED CONFIGURATION SET ACCELERATED_PLAN_FORCING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ASYNC_STATS_UPDATE_WAIT_AT_LOW_PRIORITY = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET BATCH_MODE_ADAPTIVE_JOINS = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET BATCH_MODE_MEMORY_GRANT_FEEDBACK = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET BATCH_MODE_ON_ROWSTORE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET CE_FEEDBACK = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET DEFERRED_COMPILATION_TV = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET DW_COMPATIBILITY_LEVEL = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ELEVATE_ONLINE = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ELEVATE_RESUMABLE = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET EXEC_QUERY_STATS_FOR_SCALAR_FUNCTIONS = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET GLOBAL_TEMPORARY_TABLE_AUTO_DROP = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET INTERLEAVED_EXECUTION_TVF = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ISOLATE_SECURITY_POLICY_CARDINALITY = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LAST_QUERY_PLAN_STATS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LIGHTWEIGHT_QUERY_PROFILING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET OPTIMIZE_FOR_AD_HOC_WORKLOADS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SENSITIVE_PLAN_OPTIMIZATION = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PAUSED_RESUMABLE_INDEX_ABORT_DURATION_MINUTES = 1440;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ROW_MODE_MEMORY_GRANT_FEEDBACK = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET TSQL_SCALAR_UDF_INLINING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET VERBOSE_TRUNCATION_WARNINGS = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET XTP_PROCEDURE_EXECUTION_STATISTICS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET XTP_QUERY_EXECUTION_STATISTICS = OFF;
GO
USE [sqlfenix]
GO
/****** Object:  UserDefinedFunction [dbo].[ASIENTOS_DISPONIBLES]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ASIENTOS_DISPONIBLES](@IDBUS INTEGER,@IDITINERARIO INTEGER,@FECHA DATE)
RETURNS @ASIENTOS_DISPONIBLES TABLE
(
    IdAsiento  INT not null primary key,
	ESTADO CHAR(10)
)
AS
BEGIN
	DECLARE @I INT
	DECLARE @N_ASIENTOS INTEGER

	SET @N_ASIENTOS = (SELECT BUS.NroAsientos FROM BUS WHERE BUS.IdBus=@IDBUS)
	SET @I = 1
	WHILE (@I<=@N_ASIENTOS)
		BEGIN
			INSERT @ASIENTOS_DISPONIBLES
			SELECT @I,dbo.ESTADO(@I,@IDBUS,@IDITINERARIO,@FECHA)
			SET @I = @I + 1
		END
    RETURN 
END

GO
/****** Object:  UserDefinedFunction [dbo].[ASIENTOS_OCUPADOS]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ASIENTOS_OCUPADOS](@IDBUS INT,@IDITINERARIO INT,@FECHA DATE)
RETURNS @TABLA_ASIENTOS TABLE
(
    IdAsiento  int not null primary key
)
AS
BEGIN
    INSERT @TABLA_ASIENTOS
        SELECT DISTINCT V.Asiento
		FROM dbo.BUS B
		INNER JOIN dbo.VIAJE V	ON	B.IdBus=V.IdBus
		INNER JOIN dbo.ITINERARIO I ON V.IdItinerario=I.Id
		WHERE B.IDBUS=@IDBUS AND V.FECHA=@FECHA AND I.ID = @IDITINERARIO

    RETURN 
END

GO
/****** Object:  UserDefinedFunction [dbo].[CALCULAR]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[CALCULAR] (
	@VALOR INT

	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @RETORNO INT

		SET @RETORNO = @VALOR

		RETURN @RETORNO
	END
GO
/****** Object:  UserDefinedFunction [dbo].[CALCULAR_BUSES_DISPONIBLES]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CALCULAR_BUSES_DISPONIBLES] (@CANTIDAD_BUSES INTEGER)
	RETURNS INTEGER
	AS
	BEGIN
		DECLARE @CANTIDAD_BUS_ACTIVOS INTEGER
		DECLARE @ESTADO TINYINT
		SET @ESTADO = (SELECT B.ESTADO FROM BUS B WHERE B.IdBus = @CANTIDAD_BUSES)
		-- SET @ESTADO = 1
		IF @CANTIDAD_BUSES>13
			SET @CANTIDAD_BUS_ACTIVOS = @ESTADO + dbo.CALCULAR_BUSES_DISPONIBLES(@CANTIDAD_BUSES-1)
		ELSE
			SET @CANTIDAD_BUS_ACTIVOS = @ESTADO
		RETURN @CANTIDAD_BUS_ACTIVOS	
	END
GO
/****** Object:  UserDefinedFunction [dbo].[ESTADO]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ESTADO](@N1 INTEGER,@IDBUS INTEGER,@IDITINERARIO INTEGER,@FECHA DATE)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @MSJ VARCHAR(10)

	IF (EXISTS(SELECT * 
	FROM VIAJE V
	INNER JOIN ITINERARIO I ON V.IdItinerario= I.ID
	WHERE IdBus=@IDBUS AND FECHA=@FECHA AND I.ID = @IDITINERARIO AND ASIENTO=@N1))
		SET @MSJ = 'OCUPADO'
	ELSE
		SET @MSJ = 'DISPONIBLE'
	RETURN @MSJ
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
/****** Object:  UserDefinedFunction [dbo].[SUMA_CUADRADOS]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EJERCICIO DE SUMA DE CUADRADOS DESDE UN NÚMERO HASTA N
	CREATE FUNCTION [dbo].[SUMA_CUADRADOS](@N INTEGER)
	RETURNS INTEGER
	AS
	BEGIN
		DECLARE @SUMA INTEGER

		IF(@N>0)
			SET @SUMA = @N*@N + dbo.SUMA_CUADRADOS(@N-1)
		ELSE
			SET @SUMA = @N*@N
		RETURN @SUMA
	END
GO
/****** Object:  UserDefinedFunction [dbo].[SUMA_DIGITOS]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[SUMA_DIGITOS] (@NUMERO INTEGER)
	RETURNS INTEGER
	AS
	BEGIN
		DECLARE @SUMA INTEGER

		IF(@NUMERO>0)
			SET @SUMA = @NUMERO%10 + dbo.SUMA_DIGITOS(@NUMERO/10)
		ELSE
			SET @SUMA = @NUMERO
		RETURN @SUMA
	END
GO
/****** Object:  Table [dbo].[ASEGURADORA]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASEGURADORA](
	[RUC] [char](12) NOT NULL,
	[NroPoliza] [char](8) NULL,
	[FechaFinSeguro] [datetime] NULL,
	[FechaInicioSeguro] [datetime] NULL,
	[Nombre] [varchar](255) NULL,
	[Telefono] [varchar](255) NULL,
	[Direccion] [varchar](255) NULL,
 CONSTRAINT [XPKASEGURADORA] PRIMARY KEY CLUSTERED 
(
	[RUC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BOLETA_ENCOMIENDA]    Script Date: 28/08/2022 8:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOLETA_ENCOMIENDA](
	[NroEncomienda] [char](12) NOT NULL,
	[LugarEmpresa] [char](30) NULL,
	[PuntoEmision] [char](30) NULL,
	[FechaEmision] [datetime] NULL,
	[TipoEncomienda] [char](30) NULL,
	[Origen] [char](30) NULL,
	[Destino] [char](30) NULL,
	[CondPago] [char](30) NULL,
	[DocAnexos] [char](30) NULL,
	[Servicio] [char](30) NULL,
	[Descripcion] [char](30) NULL,
	[Descuento] [float] NULL,
	[IGV] [float] NULL,
	[ImporteTotal] [float] NULL,
	[Observacion] [char](30) NULL,
	[DNIconsignado] [char](8) NOT NULL,
	[DNImensajero] [char](8) NOT NULL,
	[IdModulo] [int] NOT NULL,
	[RUC] [char](12) NOT NULL,
	[IdRemitente] [int] NOT NULL,
 CONSTRAINT [XPKBOLETA_ENCOMIENDA] PRIMARY KEY CLUSTERED 
(
	[NroEncomienda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BOLETA_PASAJE]    Script Date: 28/08/2022 8:06:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOLETA_PASAJE](
	[NroBoleta] [int] IDENTITY(1,1) NOT NULL,
	[FechaEmision] [date] NULL,
	[HoraEmision] [time](7) NULL,
	[IGV] [float] NULL,
	[ImporteTotal] [money] NULL,
	[CondicionPago] [char](30) NULL,
	[Observacion] [char](30) NULL,
	[IdPasajero] [int] NOT NULL,
	[Descuentos] [float] NULL,
	[RUC] [char](12) NOT NULL,
	[IdModulo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NroBoleta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BUS]    Script Date: 28/08/2022 8:06:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BUS](
	[IdBus] [int] IDENTITY(1,1) NOT NULL,
	[FechaAdquisicion] [datetime] NULL,
	[NroAsientos] [int] NULL,
	[Costo] [money] NULL,
	[Matricula] [varchar](7) NULL,
	[Estado] [tinyint] NULL,
	[Infracciones] [int] NULL,
 CONSTRAINT [XPKBUS] PRIMARY KEY CLUSTERED 
(
	[IdBus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONSIGNADO]    Script Date: 28/08/2022 8:06:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONSIGNADO](
	[Apellidos] [char](30) NULL,
	[Nombres] [char](30) NULL,
	[DNIconsignado] [char](8) NOT NULL,
 CONSTRAINT [XPKCONSIGNADO] PRIMARY KEY CLUSTERED 
(
	[DNIconsignado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ENCOMIENDA_DETALLE]    Script Date: 28/08/2022 8:06:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ENCOMIENDA_DETALLE](
	[Descripcion] [varchar](90) NULL,
	[Unidad] [varchar](90) NULL,
	[Cantidad] [int] NULL,
	[Total] [float] NULL,
	[NroEncomienda] [char](12) NOT NULL,
	[IdDetalle] [int] NOT NULL,
 CONSTRAINT [XPKENCOMIENDA_DETALLE] PRIMARY KEY CLUSTERED 
(
	[IdDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GUIA_REMISION_REMITENTE]    Script Date: 28/08/2022 8:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GUIA_REMISION_REMITENTE](
	[FechaInicioTranslado] [datetime] NULL,
	[FechaImpresion] [datetime] NULL,
	[NroImpresion] [int] NULL,
	[DireccionPuntoLlegada] [char](30) NULL,
	[DireccionPuntoPartida] [char](30) NULL,
	[MotivoTranslado] [char](30) NULL,
	[NroRemision] [int] NOT NULL,
	[SerieNumDocumento] [int] NULL,
	[RUCtransportista] [char](12) NOT NULL,
	[RUC] [char](12) NOT NULL,
	[IdRemitente] [int] NOT NULL,
 CONSTRAINT [XPKGUIA_REMISION_REMITENTE] PRIMARY KEY CLUSTERED 
(
	[NroRemision] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ITINERARIO]    Script Date: 28/08/2022 8:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ITINERARIO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdEmbarque] [int] NULL,
	[IdDesembarque] [int] NULL,
	[Habilitado] [tinyint] NULL,
	[Costo] [money] NULL,
	[TurnoLlegada] [time](7) NULL,
	[TurnoSalida] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MANTENIMIENTO]    Script Date: 28/08/2022 8:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MANTENIMIENTO](
	[Fecha] [datetime] NULL,
	[IdBus] [int] NOT NULL,
	[IdMecanico] [int] NOT NULL,
 CONSTRAINT [XPKMANTENIMIENTO] PRIMARY KEY CLUSTERED 
(
	[IdBus] ASC,
	[IdMecanico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MECANICO]    Script Date: 28/08/2022 8:06:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MECANICO](
	[IdMecanico] [int] NOT NULL,
	[Certificado] [char](30) NULL,
	[Nombre] [char](30) NULL,
	[Apellido] [char](30) NULL,
	[Telefono] [char](9) NULL,
 CONSTRAINT [XPKMECANICO] PRIMARY KEY CLUSTERED 
(
	[IdMecanico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MENSAJERO]    Script Date: 28/08/2022 8:06:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MENSAJERO](
	[DNImensajero] [char](8) NOT NULL,
	[Nombre] [char](30) NULL,
	[Telefono] [char](9) NULL,
	[IdVehiculo] [int] NOT NULL,
 CONSTRAINT [XPKMENSAJERO] PRIMARY KEY CLUSTERED 
(
	[DNImensajero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MODULO_ATENCION]    Script Date: 28/08/2022 8:07:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MODULO_ATENCION](
	[IdModulo] [int] NOT NULL,
	[Oficina] [int] NULL,
	[Descripcion] [int] NULL,
	[IdRecepcionista] [int] NOT NULL,
 CONSTRAINT [XPKMODULO_ATENCION] PRIMARY KEY CLUSTERED 
(
	[IdModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PASAJE_DETALLE]    Script Date: 28/08/2022 8:07:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PASAJE_DETALLE](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Unidad] [char](30) NULL,
	[Cantidad] [int] NULL,
	[NroBoleta] [int] NOT NULL,
	[IdViaje] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NroBoleta] ASC,
	[IdViaje] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PASAJERO]    Script Date: 28/08/2022 8:07:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PASAJERO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApellidoPaterno] [varchar](255) NULL,
	[ApellidoMaterno] [varchar](255) NULL,
	[Nombres] [varchar](255) NULL,
	[DNI] [char](8) NULL,
	[Genero] [varchar](20) NULL,
	[Email] [varchar](255) NULL,
	[Telefono] [char](9) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PILOTO]    Script Date: 28/08/2022 8:07:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PILOTO](
	[IdConductor] [int] NOT NULL,
	[Nombre] [char](30) NULL,
	[ApellidoPaterno] [varchar](255) NULL,
	[Licencia] [char](30) NULL,
	[Vivienda] [varchar](120) NULL,
	[Nacimiento] [datetime] NULL,
	[ApellidoMaterno] [varchar](255) NULL,
 CONSTRAINT [XPKPILOTO] PRIMARY KEY CLUSTERED 
(
	[IdConductor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RECEPCIONISTA]    Script Date: 28/08/2022 8:07:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECEPCIONISTA](
	[IdRecepcionista] [int] NOT NULL,
	[Nombre] [varchar](70) NULL,
 CONSTRAINT [XPKRECEPCIONISTA] PRIMARY KEY CLUSTERED 
(
	[IdRecepcionista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REMISION_REMITENTE_DETALLE]    Script Date: 28/08/2022 8:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REMISION_REMITENTE_DETALLE](
	[DescripcionObjeto] [char](30) NULL,
	[Cantidad] [int] NULL,
	[UnidadMedida] [char](30) NULL,
	[Peso] [float] NULL,
	[NroRemision] [int] NOT NULL,
	[IdDetalle] [int] NOT NULL,
 CONSTRAINT [XPKREMISION_REMITENTE_DETALLE] PRIMARY KEY CLUSTERED 
(
	[IdDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REMITENTE]    Script Date: 28/08/2022 8:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REMITENTE](
	[Direccion] [char](30) NULL,
	[RUC] [char](12) NOT NULL,
	[Nombre] [varchar](70) NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRepresentante] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REPRESENTANTE]    Script Date: 28/08/2022 8:07:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REPRESENTANTE](
	[Apellidos] [char](30) NULL,
	[Nombres] [char](30) NULL,
	[DNIrepresentate] [char](8) NOT NULL,
	[Telefono] [char](9) NULL,
	[Correo] [char](30) NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RUTA]    Script Date: 28/08/2022 8:07:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RUTA](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](255) NULL,
	[Embarque] [int] NULL,
	[Desembarque] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SERVICIO]    Script Date: 28/08/2022 8:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SERVICIO](
	[Descripcion] [varchar](255) NULL,
	[IdServico] [int] IDENTITY(1,1) NOT NULL,
	[TipoServicio] [char](30) NULL,
	[PrecioAdicional] [float] NULL,
 CONSTRAINT [XPKSERVICIO] PRIMARY KEY CLUSTERED 
(
	[IdServico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 28/08/2022 8:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TERMINAL]    Script Date: 28/08/2022 8:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TERMINAL](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Direccion] [varchar](255) NULL,
	[Region] [varchar](255) NOT NULL,
	[Ciudad] [varchar](255) NULL,
	[Telefono] [varchar](12) NULL,
	[Celular] [char](9) NULL,
	[AperturaPasaje] [time](7) NULL,
	[AperturaEncomienda] [time](7) NULL,
	[CierreEncomienda] [time](7) NULL,
	[CierrePasaje] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRANSPORTISTA]    Script Date: 28/08/2022 8:07:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRANSPORTISTA](
	[RUCtransportista] [char](12) NOT NULL,
	[Denominacion] [char](30) NULL,
	[Licencia] [char](30) NULL,
	[NombreEmpresa] [char](30) NULL,
 CONSTRAINT [XPKDATOS_TRANSPORTISTA] PRIMARY KEY CLUSTERED 
(
	[RUCtransportista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERS]    Script Date: 28/08/2022 8:07:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERS](
	[usuario] [varchar](30) NULL,
	[contrasenia] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VEHICULO]    Script Date: 28/08/2022 8:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VEHICULO](
	[IdVehiculo] [int] NOT NULL,
	[Tipo] [char](30) NULL,
	[Capacidad] [float] NULL,
 CONSTRAINT [XPKVEHICULO] PRIMARY KEY CLUSTERED 
(
	[IdVehiculo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VIAJE]    Script Date: 28/08/2022 8:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VIAJE](
	[IdViaje] [int] NOT NULL,
	[Fecha] [date] NULL,
	[Asiento] [int] NULL,
	[Desplazamiento] [char](30) NULL,
	[IdBus] [int] NOT NULL,
	[IdPiloto] [int] NOT NULL,
	[IdItinerario] [int] NULL,
	[IdServicio] [int] NULL,
 CONSTRAINT [XPKVIAJE] PRIMARY KEY CLUSTERED 
(
	[IdViaje] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA]  WITH CHECK ADD  CONSTRAINT [FK_BE_R] FOREIGN KEY([IdRemitente])
REFERENCES [dbo].[REMITENTE] ([Id])
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA] CHECK CONSTRAINT [FK_BE_R]
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA]  WITH CHECK ADD  CONSTRAINT [R_49] FOREIGN KEY([DNIconsignado])
REFERENCES [dbo].[CONSIGNADO] ([DNIconsignado])
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA] CHECK CONSTRAINT [R_49]
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA]  WITH CHECK ADD  CONSTRAINT [R_50] FOREIGN KEY([DNImensajero])
REFERENCES [dbo].[MENSAJERO] ([DNImensajero])
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA] CHECK CONSTRAINT [R_50]
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA]  WITH CHECK ADD  CONSTRAINT [R_64] FOREIGN KEY([IdModulo])
REFERENCES [dbo].[MODULO_ATENCION] ([IdModulo])
GO
ALTER TABLE [dbo].[BOLETA_ENCOMIENDA] CHECK CONSTRAINT [R_64]
GO
ALTER TABLE [dbo].[BOLETA_PASAJE]  WITH CHECK ADD  CONSTRAINT [FK_BP_P] FOREIGN KEY([IdPasajero])
REFERENCES [dbo].[PASAJERO] ([Id])
GO
ALTER TABLE [dbo].[BOLETA_PASAJE] CHECK CONSTRAINT [FK_BP_P]
GO
ALTER TABLE [dbo].[BOLETA_PASAJE]  WITH CHECK ADD  CONSTRAINT [R_47] FOREIGN KEY([RUC])
REFERENCES [dbo].[ASEGURADORA] ([RUC])
GO
ALTER TABLE [dbo].[BOLETA_PASAJE] CHECK CONSTRAINT [R_47]
GO
ALTER TABLE [dbo].[BOLETA_PASAJE]  WITH CHECK ADD  CONSTRAINT [R_63] FOREIGN KEY([IdModulo])
REFERENCES [dbo].[MODULO_ATENCION] ([IdModulo])
GO
ALTER TABLE [dbo].[BOLETA_PASAJE] CHECK CONSTRAINT [R_63]
GO
ALTER TABLE [dbo].[ENCOMIENDA_DETALLE]  WITH CHECK ADD  CONSTRAINT [R_11] FOREIGN KEY([NroEncomienda])
REFERENCES [dbo].[BOLETA_ENCOMIENDA] ([NroEncomienda])
GO
ALTER TABLE [dbo].[ENCOMIENDA_DETALLE] CHECK CONSTRAINT [R_11]
GO
ALTER TABLE [dbo].[GUIA_REMISION_REMITENTE]  WITH CHECK ADD  CONSTRAINT [FK_GRR_R] FOREIGN KEY([IdRemitente])
REFERENCES [dbo].[REMITENTE] ([Id])
GO
ALTER TABLE [dbo].[GUIA_REMISION_REMITENTE] CHECK CONSTRAINT [FK_GRR_R]
GO
ALTER TABLE [dbo].[GUIA_REMISION_REMITENTE]  WITH CHECK ADD  CONSTRAINT [R_58] FOREIGN KEY([RUCtransportista])
REFERENCES [dbo].[TRANSPORTISTA] ([RUCtransportista])
GO
ALTER TABLE [dbo].[GUIA_REMISION_REMITENTE] CHECK CONSTRAINT [R_58]
GO
ALTER TABLE [dbo].[ITINERARIO]  WITH CHECK ADD FOREIGN KEY([IdDesembarque])
REFERENCES [dbo].[TERMINAL] ([Id])
GO
ALTER TABLE [dbo].[ITINERARIO]  WITH CHECK ADD FOREIGN KEY([IdEmbarque])
REFERENCES [dbo].[TERMINAL] ([Id])
GO
ALTER TABLE [dbo].[MANTENIMIENTO]  WITH CHECK ADD  CONSTRAINT [R_60] FOREIGN KEY([IdBus])
REFERENCES [dbo].[BUS] ([IdBus])
GO
ALTER TABLE [dbo].[MANTENIMIENTO] CHECK CONSTRAINT [R_60]
GO
ALTER TABLE [dbo].[MANTENIMIENTO]  WITH CHECK ADD  CONSTRAINT [R_61] FOREIGN KEY([IdMecanico])
REFERENCES [dbo].[MECANICO] ([IdMecanico])
GO
ALTER TABLE [dbo].[MANTENIMIENTO] CHECK CONSTRAINT [R_61]
GO
ALTER TABLE [dbo].[MENSAJERO]  WITH CHECK ADD  CONSTRAINT [R_57] FOREIGN KEY([IdVehiculo])
REFERENCES [dbo].[VEHICULO] ([IdVehiculo])
GO
ALTER TABLE [dbo].[MENSAJERO] CHECK CONSTRAINT [R_57]
GO
ALTER TABLE [dbo].[MODULO_ATENCION]  WITH CHECK ADD  CONSTRAINT [FK_MA_T] FOREIGN KEY([Oficina])
REFERENCES [dbo].[TERMINAL] ([Id])
GO
ALTER TABLE [dbo].[MODULO_ATENCION] CHECK CONSTRAINT [FK_MA_T]
GO
ALTER TABLE [dbo].[MODULO_ATENCION]  WITH CHECK ADD  CONSTRAINT [R_62] FOREIGN KEY([IdRecepcionista])
REFERENCES [dbo].[RECEPCIONISTA] ([IdRecepcionista])
GO
ALTER TABLE [dbo].[MODULO_ATENCION] CHECK CONSTRAINT [R_62]
GO
ALTER TABLE [dbo].[PASAJE_DETALLE]  WITH CHECK ADD FOREIGN KEY([IdViaje])
REFERENCES [dbo].[VIAJE] ([IdViaje])
GO
ALTER TABLE [dbo].[PASAJE_DETALLE]  WITH CHECK ADD FOREIGN KEY([NroBoleta])
REFERENCES [dbo].[BOLETA_PASAJE] ([NroBoleta])
GO
ALTER TABLE [dbo].[REMISION_REMITENTE_DETALLE]  WITH CHECK ADD  CONSTRAINT [R_34] FOREIGN KEY([NroRemision])
REFERENCES [dbo].[GUIA_REMISION_REMITENTE] ([NroRemision])
GO
ALTER TABLE [dbo].[REMISION_REMITENTE_DETALLE] CHECK CONSTRAINT [R_34]
GO
ALTER TABLE [dbo].[REMITENTE]  WITH CHECK ADD  CONSTRAINT [FK_R_R] FOREIGN KEY([IdRepresentante])
REFERENCES [dbo].[REPRESENTANTE] ([Id])
GO
ALTER TABLE [dbo].[REMITENTE] CHECK CONSTRAINT [FK_R_R]
GO
ALTER TABLE [dbo].[RUTA]  WITH CHECK ADD FOREIGN KEY([Desembarque])
REFERENCES [dbo].[TERMINAL] ([Id])
GO
ALTER TABLE [dbo].[RUTA]  WITH CHECK ADD FOREIGN KEY([Embarque])
REFERENCES [dbo].[TERMINAL] ([Id])
GO
ALTER TABLE [dbo].[VIAJE]  WITH CHECK ADD  CONSTRAINT [FK_IV] FOREIGN KEY([IdItinerario])
REFERENCES [dbo].[ITINERARIO] ([Id])
GO
ALTER TABLE [dbo].[VIAJE] CHECK CONSTRAINT [FK_IV]
GO
ALTER TABLE [dbo].[VIAJE]  WITH CHECK ADD  CONSTRAINT [FK_VS] FOREIGN KEY([IdServicio])
REFERENCES [dbo].[SERVICIO] ([IdServico])
GO
ALTER TABLE [dbo].[VIAJE] CHECK CONSTRAINT [FK_VS]
GO
ALTER TABLE [dbo].[VIAJE]  WITH CHECK ADD  CONSTRAINT [R_54] FOREIGN KEY([IdBus])
REFERENCES [dbo].[BUS] ([IdBus])
GO
ALTER TABLE [dbo].[VIAJE] CHECK CONSTRAINT [R_54]
GO
ALTER TABLE [dbo].[VIAJE]  WITH CHECK ADD  CONSTRAINT [R_55] FOREIGN KEY([IdPiloto])
REFERENCES [dbo].[PILOTO] ([IdConductor])
GO
ALTER TABLE [dbo].[VIAJE] CHECK CONSTRAINT [R_55]
GO
/****** Object:  StoredProcedure [dbo].[sp_alterdiagram]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_alterdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[SP_AumentarPrecio]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AumentarPrecio]
	@Id					varchar(30),
	@NuevoPrecio		float output
as
begin
	select * from ITINERARIO where Id = @Id
	
	update ITINERARIO set Costo*=1.1 where Id = @Id

	select @NuevoPrecio=Costo from ITINERARIO where Id = @Id
end
GO
/****** Object:  StoredProcedure [dbo].[SP_BuscarPasajero]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_BuscarPasajero]
	@DNI				char(8)
as
begin
	select * from Pasajero where DNI=@DNI
end
GO
/****** Object:  StoredProcedure [dbo].[SP_CREAR_CLIENTE]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CREAR_CLIENTE]

    @ApellidoPaterno    VARCHAR(255),
    @ApellidoMaterno    VARCHAR(255),
    @Nombres            CHAR(30),
    @DNI                CHAR(8),
    @Codigo             INT,
    @Genero             VARCHAR(20)
AS
BEGIN
    -- Insert rows into table 'PASAJERO' in schema '[dbo]'
    INSERT INTO [dbo].[PASAJERO]
        ( -- Columns to insert data into
        ApellidoPaterno,
        ApellidoMaterno,
        Nombres,
        DNI,
        CodPasajero,
        Genero
        )
    VALUES
        ( -- First row: values for the columns in the list above
            @ApellidoPaterno,
            @ApellidoMaterno,
            @Nombres,
            @DNI,
            @Codigo,
            @Genero
    )
END
GO
/****** Object:  StoredProcedure [dbo].[sp_creatediagram]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_creatediagram]
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END
	
GO
/****** Object:  StoredProcedure [dbo].[SP_DisminuirPrecio]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_DisminuirPrecio]
	@TipoServicio		varchar(30),
	@NuevoPrecio		float output
as
begin
	select * from SERVICIO where TipoServicio = @TipoServicio
	
	update SERVICIO set PrecioAdicional*=0.8 where TipoServicio = @TipoServicio

	select @NuevoPrecio=PrecioAdicional from SERVICIO where TipoServicio = @TipoServicio
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dropdiagram]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_dropdiagram]
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[SP_GENERAR_BOLETA_PASAJE]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GENERAR_BOLETA_PASAJE]
    @NroBoleta INT
AS
BEGIN
    SELECT
        BP.NroBoleta,
        BP.FechaEmision,
        BP.HoraEmision,
        BP.IGV,
        BP.ImporteTotal,
        BP.CondicionPago,
        BP.Observacion,
        BP.Descuentos,
        BP.RUC,
        P.ApellidoPaterno,
        P.ApellidoMaterno,
        P.Nombres,
        P.DNI,
        R.Nombre,
        T.Direccion,
        T.Ciudad,
        T.Region
    FROM BOLETA_PASAJE BP
        INNER JOIN PASAJERO P ON BP.IdPasajero = P.Id
        INNER JOIN MODULO_ATENCION M ON BP.IdModulo = M.IdModulo
        INNER JOIN RECEPCIONISTA R ON M.IdRecepcionista = R.IdRecepcionista
        INNER JOIN TERMINAL T ON M.Oficina = T.Id
    WHERE BP.NroBoleta = @NroBoleta
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GENERAR_BOLETA_PASAJE_DETALLES]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GENERAR_BOLETA_PASAJE_DETALLES]
    @NroBoleta INT
AS
BEGIN
    SELECT
        S.Descripcion,
        PD.Unidad,
        PD.Cantidad,
        TD.Ciudad as 'Desembarque',
        TE.Ciudad as 'Embarque',
        I.TurnoSalida as 'Turno de Salida',
        I.TurnoLlegada as 'Turno de Llegada',
        I.Costo
    FROM BOLETA_PASAJE BP
        INNER JOIN PASAJE_DETALLE PD ON BP.NroBoleta = PD.NroBoleta
        INNER JOIN VIAJE V ON PD.IdViaje = V.IdViaje
        INNER JOIN SERVICIO S ON V.IdServicio = S.IdServico
        INNER JOIN ITINERARIO I ON V.IdItinerario = I.Id
        INNER JOIN TERMINAL TD ON I.IdDesembarque = TD.Id
        INNER JOIN TERMINAL TE ON I.IdEmbarque = TE.Id
    WHERE BP.NroBoleta = @NroBoleta
END
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagramdefinition]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagramdefinition]
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[sp_helpdiagrams]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_helpdiagrams]
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END
	
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTADO_CLIENTES_FRM]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_LISTADO_CLIENTES_FRM]
AS
BEGIN
    -- body of the stored procedure
    SELECT
        FORMAT(CodPasajero, '00000000') as 'Codigo',
        ApellidoPaterno,
        ApellidoMaterno,
        Nombres,
        DNI,
        Genero
    FROM PASAJERO
END
GO
/****** Object:  StoredProcedure [dbo].[sp_renamediagram]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_renamediagram]
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END
	
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_REGISTROS]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_REPORTE_REGISTROS]
AS
BEGIN
SELECT  (
        SELECT COUNT(*)
        FROM   ASEGURADORA
        ) AS ASEGURADORA,
         (
        SELECT COUNT(*)
        FROM   BOLETA_ENCOMIENDA
        ) AS BOLETA_ENCOMIENDA,
        (
        SELECT COUNT(*)
        FROM   BOLETA_PASAJE
        ) AS BOLETA_PASAJE,
        (
        SELECT COUNT(*)
        FROM   BUS
        ) AS BUS,
        (
        SELECT COUNT(*)
        FROM   CONSIGNADO
        ) AS CONSIGNADO,
        (
        SELECT COUNT(*)
        FROM   ENCOMIENDA_DETALLE
        ) AS ENCOMIENDA_DETALLE,
        (
        SELECT COUNT(*)
        FROM   GUIA_REMISION_REMITENTE
        ) AS GUIA_REMISION_REMITENTE,
        (
        SELECT COUNT(*)
        FROM   MANTENIMIENTO
        ) AS MANTENIMIENTO,
        (
        SELECT COUNT(*)
        FROM   MECANICO
        ) AS MECANICO,
        (
        SELECT COUNT(*)
        FROM   MENSAJERO
        ) AS MENSAJERO,
        (
        SELECT COUNT(*)
        FROM   MODULO_ATENCION
        ) AS MODULO_ATENCION,
        (
        SELECT COUNT(*)
        FROM   PASAJERO
        ) AS PASAJERO,
        (
        SELECT COUNT(*)
        FROM   PASAJE_DETALLE
        ) AS PASAJE_DETALLE,
        (
        SELECT COUNT(*)
        FROM   PILOTO
        ) AS PILOTO,
        (
        SELECT COUNT(*)
        FROM   RECEPCIONISTA
        ) AS RECEPCIONISTA,
        (
        SELECT COUNT(*)
        FROM   REMISION_REMITENTE_DETALLE
        ) AS REMISION_REMITENTE_DETALLE,
        (
        SELECT COUNT(*)
        FROM   REMITENTE
        ) AS REMITENTE,
        (
        SELECT COUNT(*)
        FROM   REPRESENTANTE
        ) AS REPRESENTANTE,
        (
        SELECT COUNT(*)
        FROM   SERVICIO
        ) AS SERVICIO,
        (
        SELECT COUNT(*)
        FROM   TRANSPORTISTA
        ) AS TRANSPORTISTA,
        (
        SELECT COUNT(*)
        FROM   VEHICULO
        ) AS VEHICULO,
        (
        SELECT COUNT(*)
        FROM   VIAJE
        ) AS VIAJE,
        (
        SELECT COUNT(*)
        FROM   TERMINAL
        ) AS TERMINAL,
        (
        SELECT COUNT(*)
        FROM   ITINERARIO
        ) AS ITINERARIO

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ResumenBoleta]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_ResumenBoleta]
	@DNI		char(8)
as
begin
	select
		BP.NroBoleta							as		'Boleta',
		(convert(datetime, BP.FechaEmision)+convert(datetime, BP.HoraEmision))	as		'Fecha y Hora',
		P.DNI									as		'DNI Pasajero',
		(P.ApellidoPaterno+' '+P.ApellidoMaterno+' '+P.Nombres)				as		'Nombres Pasajero',
		PD.Cantidad								as		'N° de Asientos',
		--PD.PrecioUnitario						as		'Precio U',
		--PD.Descripcion							as		'Descripcion',
		BP.ImporteTotal							as		'Total a Pagar'
	from BOLETA_PASAJE BP
		inner join
			PASAJE_DETALLE PD	on		BP.NroBoleta = PD.NroBoleta
		inner join
			PASAJERO P			on		BP.IdPasajero =  P.Id
	where P.DNI = @DNI
end
GO
/****** Object:  StoredProcedure [dbo].[SP_ResumenEncomienda]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_ResumenEncomienda]
	@DNI			char(8)
as
begin
	select
		BE.NroEncomienda				as		'#',
		BE.FechaEmision					as		'Fecha y Hora',
		BE.Origen						as		'Origen',
		BE.Destino						as		'Destino',
		RT.DNIrepresentate				as		'DNI Remitente',
		RT.Apellidos+' '+RT.Nombres		as		'Nombres Remitente',
		C.DNIconsignado					as		'DNI Detinatario',
		C.Apellidos+' '+C.Nombres		as		'Nombres Destinatario',
		ED.Cantidad						as		'Cantidad',
		ED.Unidad						as		'Unidad',
		ED.Descripcion					as		'Descripcion',
		BE.ImporteTotal					as		'Total a Pagar'
	from BOLETA_ENCOMIENDA BE
		inner join
			ENCOMIENDA_DETALLE ED		on		BE.NroEncomienda = ED.NroEncomienda												
		inner join
			CONSIGNADO C				on		BE.DNIconsignado =  C.DNIconsignado
		inner join
			REMITENTE R				on		BE.IdRemitente = R.Id
		inner join
			REPRESENTANTE RT			on		R.IdRepresentante =  RT.Id
	where RT.DNIrepresentate = @DNI or C.DNIconsignado = @DNI
end
GO
/****** Object:  StoredProcedure [dbo].[sp_upgraddiagrams]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[sp_upgraddiagrams]
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END
	
GO
/****** Object:  StoredProcedure [dbo].[SP_ViajesPiloto]    Script Date: 28/08/2022 8:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_ViajesPiloto]
	@IdConductor	int
as
begin
	select
		P.IdConductor			as		'# Piloto',
		(P.ApellidoPaterno+' '+P.ApellidoMaterno+' '+P.Nombre)			as		'Nombres',
		P.Licencia				as		'N° Licencia',
		B.Matricula				as		'Matricula Bus',
		V.Desplazamiento		as		'Ruta',
		V.Fecha					as		'Fecha'
	from VIAJE V
		inner join
			BUS B				on		V.IdBus = B.IdBus
		inner join
			PILOTO P			on		V.IdPiloto = P.IdConductor
	where P.IdConductor = @IdConductor
end
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysdiagrams'
GO
USE [master]
GO
ALTER DATABASE [sqlfenix] SET  READ_WRITE 
GO

CREATE TRIGGER [dbo].[TR_BOLETA_PASAJE_DETALLE] ON [dbo].[PASAJE_DETALLE] FOR INSERT
AS
BEGIN
    DECLARE @costo MONEY
    DECLARE @cantidad INT
    DECLARE @importeTotal MONEY
    DECLARE @nroBoleta INT
    DECLARE @Impr FLOAT
    DECLARE @IGV  FLOAT

    SET @nroBoleta = (SELECT NroBoleta
    FROM inserted)
    SET @costo = (
           SELECT IT.Costo
    FROM inserted I INNER JOIN VIAJE V ON I.IdViaje = V.IdViaje INNER JOIN ITINERARIO IT ON V.IdItinerario = IT.Id)

    SET @cantidad = (
           SELECT Cantidad
    FROM inserted)

    SET @costo = @costo * @cantidad

    IF @costo > 0 
       BEGIN
        SET @importeTotal = (SELECT ISNULL(ImporteTotal, '$0.0')
        FROM BOLETA_PASAJE
        WHERE NroBoleta = @nroBoleta)

        SET @IGV = (SELECT IGV
        FROM BOLETA_PASAJE
        WHERE NroBoleta = @nroBoleta)

        SET @Impr = (@importeTotal + @costo)

        UPDATE BOLETA_PASAJE SET ImporteTotal = @Impr + (@Impr*@IGV)
    END
    ELSE
        ROLLBACK
END
GO
ALTER TABLE [dbo].[PASAJE_DETALLE] ENABLE TRIGGER [TR_BOLETA_PASAJE_DETALLE]
GO