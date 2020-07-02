
USE PIMSV2
Go
Set Statistics IO ON
Set Statistics TIME ON

Drop Proc If Exists dbo.COP_ProcLogic_1
GO
/***************************************************************************************
�� �ý��� ��		: COP_ProcLogic
�� ����/�������	: COP
--**************************************************************************************/
CREATE Proc dbo.COP_ProcLogic_1
	@UnivServiceId Int = 408401
	, @StartDate DateTime = '2019-12-01'
	, @EndDate DateTime = '2019-12-31'
AS
Begin
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	Select
		UnivServiceId,
		ServiceName
	From dbo.UnivService_Info
	where UnivID = 4084

	Select 
		UMI.MajorCode
		, UMI.MajorName
		--10	�Ϲ�����	I
		--24	Ư��(�Ϲݰ���)	I
		--13	Ư��(������������)	I
		, Sum(Case When USI.SelectionCode = '10' And SP.PayStatus is not null Then 1 Else 0 End) [�Ϲ�����_�����]
		, Sum(Case When USI.SelectionCode = '10' And SP.PayStatus is null Then 1 Else 0 End) [�Ϲ�����_�̵����]
		, Sum(Case When USI.SelectionCode = '24' And SP.PayStatus is not null Then 1 Else 0 End) [Ư��(�Ϲݰ���)_�����]
		, Sum(Case When USI.SelectionCode = '24' And SP.PayStatus is null Then 1 Else 0 End) [Ư��(�Ϲݰ���)_�̵����]
		, Sum(Case When USI.SelectionCode = '13' And SP.PayStatus is not null Then 1 Else 0 End) [Ư��(������������)_�����]
		, Sum(Case When USI.SelectionCode = '13' And SP.PayStatus is null Then 1 Else 0 End) [Ư��(������������)_�̵����]

		--20	������	O
		--52	�����	O
		--54	���ʻ�Ȱ����������	O
		--57	������Ż�ֹ�	O
		, Sum(Case When USI.SelectionCode = '20' And SP.PayStatus is not null Then 1 Else 0 End) [������_�����]
		, Sum(Case When USI.SelectionCode = '20' And SP.PayStatus is null Then 1 Else 0 End) [������_�̵����]
		, Sum(Case When USI.SelectionCode = '52' And SP.PayStatus is not null Then 1 Else 0 End) [�����_�����]
		, Sum(Case When USI.SelectionCode = '52' And SP.PayStatus is null Then 1 Else 0 End) [�����_�̵����]
		, Sum(Case When USI.SelectionCode = '54' And SP.PayStatus is not null Then 1 Else 0 End) [���ʻ�Ȱ����������_�����]
		, Sum(Case When USI.SelectionCode = '54' And SP.PayStatus is null Then 1 Else 0 End) [���ʻ�Ȱ����������_�̵����]
		, Sum(Case When USI.SelectionCode = '57' And SP.PayStatus is not null Then 1 Else 0 End) [������Ż�ֹ�_�����]
		, Sum(Case When USI.SelectionCode = '57' And SP.PayStatus is null Then 1 Else 0 End) [������Ż�ֹ�_�̵����]

	From dbo.Stu_CommonInfo Stu
	Inner Join dbo.UnivService_SelectionInfo USI On Stu.SelectionId = USI.SelectionId
	Inner Join dbo.UnivService_MajorInfo UMI On Stu.MajorId = UMI.MajorId
	Left Outer Join dbo.Stu_PayInfo SP On Stu.SRSID = SP.SRSID
		And SP.PayDate >= @StartDate
		And SP.PayDate <= @EndDate
		--And SP.PayDate BetWeen @StartDate And @EndDate
	Where Stu.UnivServiceID = @UnivServiceId
	And Stu.PassStatus = 1
	Group By UMI.MajorCode
		, UMI.MajorName

	/*
	Select 
		UMI.MajorCode
		, UMI.MajorName
		--10	�Ϲ�����	I
		--24	Ư��(�Ϲݰ���)	I
		--13	Ư��(������������)	I
		, Sum(Case When USI.SelectionCode = '10' And Stu.RegistStatus = 1 Then 1 Else 0 End) [�Ϲ�����_�����]
		, Sum(Case When USI.SelectionCode = '10' And Stu.RegistStatus = 0 Then 1 Else 0 End) [�Ϲ�����_�̵����]
		, Sum(Case When USI.SelectionCode = '24' And Stu.RegistStatus = 1 Then 1 Else 0 End) [Ư��(�Ϲݰ���)_�����]
		, Sum(Case When USI.SelectionCode = '24' And Stu.RegistStatus = 0 Then 1 Else 0 End) [Ư��(�Ϲݰ���)_�̵����]
		, Sum(Case When USI.SelectionCode = '13' And Stu.RegistStatus = 1 Then 1 Else 0 End) [Ư��(������������)_�����]
		, Sum(Case When USI.SelectionCode = '13' And Stu.RegistStatus = 0 Then 1 Else 0 End) [Ư��(������������)_�̵����]

		--20	������	O
		--52	�����	O
		--54	���ʻ�Ȱ����������	O
		--57	������Ż�ֹ�	O
		, Sum(Case When USI.SelectionCode = '20' And Stu.RegistStatus = 1 Then 1 Else 0 End) [������_�����]
		, Sum(Case When USI.SelectionCode = '20' And Stu.RegistStatus = 0 Then 1 Else 0 End) [������_�̵����]
		, Sum(Case When USI.SelectionCode = '52' And Stu.RegistStatus = 1 Then 1 Else 0 End) [�����_�����]
		, Sum(Case When USI.SelectionCode = '52' And Stu.RegistStatus = 0 Then 1 Else 0 End) [�����_�̵����]
		, Sum(Case When USI.SelectionCode = '54' And Stu.RegistStatus = 1 Then 1 Else 0 End) [���ʻ�Ȱ����������_�����]
		, Sum(Case When USI.SelectionCode = '54' And Stu.RegistStatus = 0 Then 1 Else 0 End) [���ʻ�Ȱ����������_�̵����]
		, Sum(Case When USI.SelectionCode = '57' And Stu.RegistStatus = 1 Then 1 Else 0 End) [������Ż�ֹ�_�����]
		, Sum(Case When USI.SelectionCode = '57' And Stu.RegistStatus = 0 Then 1 Else 0 End) [������Ż�ֹ�_�̵����]

	From dbo.Stu_CommonInfo Stu
	Inner Join dbo.Stu_PayInfo SP On Stu.SRSID = SP.SRSID
	Inner Join dbo.UnivService_SelectionInfo USI On Stu.SelectionId = USI.SelectionId
	Inner Join dbo.UnivService_MajorInfo UMI On Stu.MajorId = UMI.MajorId
	Where Stu.UnivServiceID = @UnivServiceId
	And SP.PayDate >= @StartDate
	And SP.PayDate <= @EndDate
	--And SP.PayDate BetWeen @StartDate And @EndDate
	And Stu.PassStatus = 1
	Group By UMI.MajorCode
		, UMI.MajorName
	*/

End
GO