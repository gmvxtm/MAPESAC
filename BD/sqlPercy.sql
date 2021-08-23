USE [MAPESAC]
GO
/****** Object:  StoredProcedure [dbo].[Usp_Login]    Script Date: 20/08/2021 11:06:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para validar el acceso del usuario al sistema.
--Change:		-
--Example:		[dbo].[Usp_Login] 'admin', 'admin'
--================================================= 
ALTER PROC [dbo].[Usp_Login]
	@ParamIUsername		VARCHAR(100)
	,@ParamIPassword	VARCHAR(MAX)
AS
BEGIN
	SELECT	IdUser
			,Username
			,RecordStatus
			,IdProfile
	FROM	[User]
	WHERE	Username	=	@ParamIUsername
		AND	[Password]	=	@ParamIPassword
END

-----------------------------------------------------------------------------------------------------

--23/08/2021

USE [MAPESAC]
GO
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
			,RecordStatus
	FROM	Product
	WHERE	RecordStatus	=	@CActiveStatus
END