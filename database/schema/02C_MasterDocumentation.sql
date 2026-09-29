USE ProductionERP;
Go

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'Semiconductor material types used in epiwafer manufacturing.',
    @level0type=N'SCHEMA',
    @level0name=N'Master',
    @level1type=N'TABLE',
    @level1name=N'Material';
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'Finished semiconductor epiwafer products manufactured for customers.',
    @level0type=N'SCHEMA',
    @level0name=N'Master',
    @level1type=N'TABLE',
    @level1name=N'Product';
GO