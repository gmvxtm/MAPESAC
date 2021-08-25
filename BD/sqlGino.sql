USE [MAPESAC]
GO
/****** Object:  StoredProcedure [dbo].[Usp_List_Product]    Script Date: 24/08/2021 21:28:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=================================================
--Description:	SP para listar todos los productos que están activos en el sistema.
--Change:		-
--Example:		[dbo].[Usp_List_Product]
--================================================= 
ALTER PROC [dbo].[Usp_List_Product]
AS
BEGIN

	DECLARE	@CActiveStatus	CHAR(1)	=	'A';

	SELECT	IdProduct
			,[Name]
			,ISNULL(PathFile,'')
			,RecordStatus
	FROM	Product
	WHERE	RecordStatus	=	@CActiveStatus
END