

---1. Indexing Strategy – Performance Optimization 
--Apply indexes to speed up commonly-used queries:

-----------------------Library Table 
--Non-clustered on Name → Search by name :
SELECT * FROM Libraries WHERE Names = 'Northside Library';

--Non-clustered on Location → Filter by location :
SELECT * FROM Libraries WHERE Locations = 'North End';


-----------------------Book Table 
--Clustered on LibraryID, ISBN → Lookup by book in specific library
SELECT * 
FROM Book 
WHERE LibraryID = 1 AND ISBN = '9781111111111';

--Non-clustered on Genre → Filter by genre 
SELECT COUNT(*) as Filtergenre 
FROM Book
WHERE Genre = 'Reference';


----------------------Loan Table 
--Non-clustered on MemberID → Loan history
CREATE NONCLUSTERED INDEX IX_Loan_MemberID
ON Loans (MemberID);

SELECT * --Example
FROM Loans
WHERE MemberID = 1;

--Non-clustered on Status → Filter by status 
CREATE NONCLUSTERED INDEX IX_Loan_Status
ON Loans (Statu);

SELECT LID, MemberID, BID
FROM Loans
WHERE Statu = 'Returned';

--Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks
CREATE NONCLUSTERED INDEX IX_Loan_BookID_LoanDate_ReturnDate
ON Loans (BID, LDate, Returnes);

SELECT BID, LDate, Returnes
FROM Loans
WHERE LDate < returnes;








