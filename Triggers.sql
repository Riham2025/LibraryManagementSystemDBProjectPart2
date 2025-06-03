

-------------5. Triggers – Real-Time Business Logic

--1. trg_UpdateBookAvailability After new loan → set book to unavailable 
CREATE TRIGGER trg_UpdateBookAvailability
ON Loans
AFTER INSERT
AS
BEGIN
    UPDATE Book
    SET  Statu= 'Unavailable'
    WHERE BID IN (
        SELECT BID
        FROM INSERTED
    );
END;

---2. trg_CalculateLibraryRevenue After new payment → update library revenue 
CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payment1
AFTER INSERT
AS
BEGIN
    UPDATE l
    SET l.TotalRevenue = l.TotalRevenue + p.TotalAmount
    FROM Library l
    INNER JOIN (
        SELECT LibraryID, SUM(Amount) AS TotalAmount
        FROM INSERTED
        GROUP BY LibraryID
    ) p ON l.LID = p.LibraryID;
END;


--3. trg_LoanDateValidation Prevents invalid return dates on insert 
CREATE TRIGGER trg_LoanDateValidation
ON Loans
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        WHERE returnes IS NOT NULL AND Returnes < LDate
    )
    BEGIN
        RAISERROR ('Return date cannot be before loan date.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO Loans(LID, MemberID, BID, LDate, DuDate, Returnes, Statu)
        SELECT LID, MemberID, BID, LDate, DuDate, Returnes, Statu
        FROM INSERTED;
    END
END;


