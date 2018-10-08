USE [Merch]
GO

/****** Object:  Table [Planning].[DeliveryStop]    Script Date: 1/29/2018 4:18:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Mesh].[DeliveryStop](
	[PKEY] [bigint] NOT NULL,
	[RouteID] [int] NOT NULL,
	[Sequence] [int] NOT NULL,
	[StopType] [varchar](20) NOT NULL,
	[SAPAccountNumber] [int] NULL,
	[PlannedArrival] [datetime2](7) NOT NULL,
	[TravelToTime] [int] NOT NULL,
	[ServiceTime] [int] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModified] [datetime2](0) NOT NULL,
	[LocalSyncTime] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_DeliveryStop] PRIMARY KEY CLUSTERED 
(
	[PKEY] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE Mesh.[DeliveryStop]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryStop_DeliveryRoute] FOREIGN KEY([PKEY])
REFERENCES [Mesh].[DeliveryRoute] ([PKEY])
GO

ALTER TABLE Mesh.[DeliveryStop] CHECK CONSTRAINT [FK_DeliveryStop_DeliveryRoute]
GO

