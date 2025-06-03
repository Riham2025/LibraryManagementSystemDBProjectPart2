
------------------------. Stored Procedures – Backend Automation 

-- 1. sp_MarkBookUnavailable(BookID) Updates availability after issuing 

CREATE OR ALTER PROCEDURE sp_MarkBookUnavailable
    @BookID INT
AS
BEGIN
    UPDATE Book
    SET Statu = 0
    WHERE BID = @BookID;
END;
GO


--- 2. sp_UpdateLoanStatus() Checks dates and updates loan statuses 
CREATE PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    SET NOCOUNT ON;

    
    UPDATE Loans
    SET Statu = 'Returned'
    WHERE returnes IS NOT NULL;

    UPDATE Loans
    SET Statu = 'Overdue'
    WHERE returnes IS NULL AND DuDate < GETDATE();

    UPDATE Loans
    SET Statu = 'Issued'
    WHERE returnes IS NULL AND DuDate >= GETDATE();
END


---3. sp_RankMembersByFines() Ranks members by total fines paid 
CREATE PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        m.MemberID,
        m.FirstName,
        m.LastName,
        SUM(p.Amount) AS TotalFinesPaid,
        RANK() OVER (ORDER BY SUM(p.Amount) DESC) AS FineRank
    FROM 
        Members m
    JOIN 
        Payment1 p ON m.MemberID = p.ID
    GROUP BY 
        m.MemberID, m.FirstName, m.LastName
END
