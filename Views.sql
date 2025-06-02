

-- Views – Frontend Integration Support 


--1. ViewPopularBooks Books with average rating > 4.5 + total loans
SELECT 
    b.BID,
    b.Title,
    AVG(r.Rating) AS AverageRating,
    COUNT(l.LID) AS TotalLoans
FROM 
    Book b
JOIN 
    Review r ON b.BID = r.BID
JOIN 
    Loans l ON b.BID = l.BID
GROUP BY 
    b.BID, b.Title
HAVING 
    AVG(r.Rating) > 4.5;



--ViewMemberLoanSummary Member loan count + total fines paid 

SELECT 
    m.MemberID,
    m.FirstName  AS MemberName,
    COUNT(DISTINCT l.LID) AS LoanCount,
    ISNULL(SUM(p1.Amount), 0) + ISNULL(SUM(p2.MemberID), 0) + ISNULL(SUM(p3.LID), 0) AS TotalFinesPaid
FROM 
    Members m
LEFT JOIN 
    Loans l ON m.MemberID = l.MemberID
LEFT JOIN 
    Payment1 p1 ON m.MemberID = p1.Amount
LEFT JOIN 
    Payment2 p2 ON m.MemberID = p2.MemberID
LEFT JOIN 
    Payment3 p3 ON m.MemberID = p3.LID
GROUP BY
    m.MemberID, m.FirstName;


---ViewAvailableBooks Available books grouped by genre, ordered by price

SELECT 
    b.BID,
    b.Title,
    b.Genre,
    b.Price,
    b.Statu
FROM 
    Book b
WHERE 
    b.Statu = 'Issued'
ORDER BY 
    b.Genre,
    b.Price;


---ViewLoanStatusSummary Loan stats (issued, returned, overdue) per library	
SELECT 
    l.LibraryID AS LibraryID,
    l.Names AS LibraryName,

   
    COUNT(CASE WHEN ln.Statu = 'Issued' THEN 1 END) AS IssuedLoans,

  
    COUNT(CASE WHEN ln.Statu = 'Returned' THEN 1 END) AS ReturnedLoans,

    COUNT(CASE 
        WHEN ln.Statu = 'Issued' AND ln.DuDate < GETDATE() THEN 1 
    END) AS OverdueLoans

FROM 
    Libraries l
JOIN 
    Book b ON l.LibraryID = b.LibraryID
JOIN 
    Loans ln ON b.BID = ln.BID
GROUP BY 
    l.LibraryID, l.Names;


---ViewPaymentOverview Payment info with member, book, and status
SELECT 
    p.ID AS PaymentID,
    m.MemberID AS MemberID,
    m.FirstName AS MemberName,
    b.BID AS BookID,
    b.Title AS BookTitle,
    p.Amount,
    p.PDate
FROM 
    Payment1 p
JOIN 
    Members m ON p.ID = m.MemberID
JOIN 
    Book b ON p.ID = b.BID;
