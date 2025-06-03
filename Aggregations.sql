
--------6. Aggregation Functions – Dashboard Reports 


--1 Total fines per member

SELECT 
    m.MemberID,
    m.FirstName + ' ' + m.LastName AS MemberName,
    SUM(p.Amount) AS TotalFines
FROM 
    Members m
JOIN (
    SELECT ID, Amount FROM Payment1
    UNION ALL
    SELECT MemberID, LID FROM Payment2
    UNION ALL
    SELECT ID, LID FROM Payment3
) p ON m.MemberID = p.ID
GROUP BY 
    m.MemberID, m.FirstName, m.LastName
ORDER BY 
    TotalFines DESC;


---2 Most active libraries (by loan count)

SELECT 
    l.LibraryID,
    l.Names AS LibraryName,
    COUNT(lo.LID) AS TotalLoans
FROM 
    Libraries l
JOIN 
    Book b ON l.LibraryID = b.LibraryID
JOIN 
    Loans lo ON b.BID = lo.BID
GROUP BY 
    l.LibraryID, l.Names
ORDER BY 
    TotalLoans DESC;


--3 Avg book price per genre 
SELECT 
    Genre,
    AVG(Price) AS AvgPrice
FROM 
    Book
GROUP BY 
    Genre
ORDER BY 
    AvgPrice DESC;


--4 Top 3 most reviewed books 
SELECT TOP 3
    b.BID,
    b.Title,
    COUNT(r.RID) AS ReviewCount
FROM 
    Book b
JOIN 
    Review r ON b.BID = r.BID
GROUP BY 
    b.BID, b.Title
ORDER BY 
    ReviewCount DESC;


---5 Library revenue report 
SELECT 
    l.LibraryID,
    l.Names AS LibraryName,
    SUM(p.Amount) AS TotalRevenue
FROM 
    Payment1 p
JOIN 
    Loans lo ON p.ID = lo.LID
JOIN 
    Book b ON lo.BID = b.BID
JOIN 
    Libraries l ON b.LibraryID = l.LibraryID
GROUP BY 
    l.LibraryID, l.Names
ORDER BY 
    TotalRevenue DESC;


---6 Member activity summary (loan + fines) 
SELECT 
    m.MemberID,
    m.FirstName,
    m.LastName,
    COUNT(DISTINCT l.LID) AS LoanCount,
    ISNULL(SUM(p.Amount), 0) AS TotalFines
FROM 
    Members m
LEFT JOIN 
    Loans l ON m.MemberID = l.MemberID
LEFT JOIN 
    Payment1 p ON l.LID = p.ID
GROUP BY 
    m.MemberID, m.FirstName, m.LastName
ORDER BY 
    LoanCount DESC, TotalFines DESC;
