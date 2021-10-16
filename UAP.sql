use [Dj Card Shop]


-- 2
GO
CREATE PROCEDURE NameFinder @FindString varchar
	AS
	IF (@FindString = NULL)
	BEGIN
	PRINT 'Invalid Parameter: Parameter shouldn’t be NULL.'
	END
	
	ELSE IF (@FindString = '')
	BEGIN 
	PRINT 'Invalid Parameter: Parameter should be a character(s).' 
	END

	ELSE IF EXISTS(SELECT * FROM Customer WHERE CustomerName = '%' + @FindString + '%')
	BEGIN
	(SELECT * FROM Customer WHERE CustomerName = '%' + @FindString + '%')
	END

	EXEC NameFinder 'd'

-- 3
GO
	CREATE PROCEDURE TransactionRevealer @FindString varchar
	AS 
	BEGIN
	
	PRINT 'Transaction Report'
	PRINT '|Customer Name		|Customer Phone		|Sales Date		|Total Price		|'
	PRINT '------------------------------------------------------------------------------'
	
	DECLARE TranCursor  CURSOR
	FOR 

	SELECT CustomerName, Customer.CustomerPhoneNumber, SalesDate, [Total Price] = SUM(Card.CardSalesPrice * DetailSalesTransaction.Quantity)
	FROM Customer

	JOIN HeaderSalesTransaction ON Customer.CustomerID = HeaderSalesTransaction.CustomerID
	JOIN DetailSalesTransaction ON HeaderSalesTransaction.SalesID = DetailSalesTransaction.SalesID
	JOIN [Card] ON DetailSalesTransaction.CardID = [Card].CardID
	
	WHERE CustomerName LIKE '%'+@FindString+'%'

	GROUP BY Customer.CustomerName, Customer.CustomerPhoneNumber, HeaderSalesTransaction.SalesDate
	ORDER BY Customer.CustomerName

	DECLARE @name varchar, @number varchar, @tgl DATE, @total INT
	OPEN TranCursor

	FETCH NEXT FROM TranCursor
	INTO @name,@number,@tgl,@total

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
	PRINT '|'+ @name + '	|' + @number +'		|' + CONVERT(VARCHAR, @tgl, 107)+'        |Rp. '+CAST (@total AS VARCHAR)+'        |'
        FETCH NEXT FROM transactionCursor
        INTO @name,@number,@tgl,@total
    END
    
    CLOSE transactionCursor
    DEALLOCATE transactionCursor

	END

	EXEC TransactionRevealer 'd'

-- 4
GO
CREATE TRIGGER CustomDateTrigger ON Customer
	FOR INSERT AS
	BEGIN
	SELECT CustomerID, CustomerName, CustomerPhoneNumber
	FROM inserted
	END

GO 
INSERT Customer
VALUES ('CU011', 'Test', 'Male', 'Test Street', '081234123412')


	
