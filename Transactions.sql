
-------------8. Transactions – Ensuring Consistency 

--Borrowing a book (loan insert + update availability)
BEGIN TRANSACTION;

BEGIN TRY
  
    INSERT INTO Loans (BID, MemberID, LDate, DuDate, Statu)
    VALUES (1, 1, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');


    UPDATE Book
    SET Statu = 'Unavailable'
    WHERE BID =1;

    COMMIT;  
END TRY
BEGIN CATCH
    ROLLBACK;  
    PRINT 'Error occurred during borrowing process.';
END CATCH;



---Returning a book (update status, return date, availability) 
BEGIN TRANSACTION;

BEGIN TRY
  
    UPDATE Loans
    SET returnes = GETDATE(),
        Statu = 'Returned'
    WHERE LID = 1;

  
    UPDATE Book
    SET Statu = 'Available'
    WHERE BID = (
        SELECT BID FROM Loans WHERE LID = 1
    );

    COMMIT; 
END TRY
BEGIN CATCH
    ROLLBACK;  
    PRINT 'Error occurred during return process.';
END CATCH;




--Registering a payment (with validation) 
CREATE PROCEDURE sp_RegisterPayment
    @LoanID INT,
    @Amount DECIMAL(10,2),
    @PaymentDate DATE
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @FineDue DECIMAL(10,2);

      
        SELECT @FineDue = DuDate
        FROM Loans
        WHERE LID = @LoanID;

       
        IF @Amount > @FineDue
        BEGIN
            RAISERROR ('Amount exceeds fine due.', 16, 1);
            ROLLBACK;
            RETURN;
        END

  
        INSERT INTO Payment1(ID, Amount, PDate)
        VALUES (@LoanID, @Amount, @PaymentDate);



        COMMIT; 
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Error registering payment.';
    END CATCH
END


--Batch loan insert with rollback on failure
BEGIN TRANSACTION;

BEGIN TRY


 
    IF EXISTS (SELECT 1 FROM Book WHERE BID = 101 AND Statu = 0)
        THROW 50000, 'Book 101 not available.', 1;

    IF EXISTS (SELECT 1 FROM Book WHERE BID = 102 AND Statu = 0)
        THROW 50000, 'Book 102 not available.', 1;

    
    INSERT INTO Loans(MemberID, BID, LDate, DuDate, Statu)
    VALUES 
        (1, 101, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued'),
        (2, 102, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

   
    UPDATE Book SET Statu = 0 WHERE BID IN (101, 102);

    COMMIT;
    PRINT 'Batch insert successful.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
