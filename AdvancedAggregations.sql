
-------------------------------------7. Advanced Aggregations – Analytical Insight  

-- HAVING for filtering aggregates 
SELECT 
    m.MemberID,
    m.FirstName,
    m.LastName,
    SUM(p.Amount) AS TotalFines
FROM 
    Members m
JOIN 
    Loans l ON m.MemberID = l.MemberID
JOIN 
    Payment1 p ON l.LID = p.ID
GROUP BY 
    m.MemberID, m.FirstName, m.LastName
HAVING 
    SUM(p.Amount) > 20;


--Subqueries for complex logic (e.g., max price per genre) 
SELECT 
    Genre,
    Title,
    Price
FROM 
    Book b
WHERE 
    Price = (
        SELECT MAX(Price)
        FROM Book
        WHERE Genre = b.Genre
    );


--Occupancy rate calculations  
/*  Occupancy Rate = percentage of books whose Statu is not 'Returned'  */
SELECT
    l.LibraryID,
    l.Names        AS LibraryName,
    COUNT(*)       AS TotalBooks,
    SUM(CASE WHEN b.Statu IN ('Issued','Overdue')
             THEN 1 ELSE 0 END)                AS LoanedBooks,
    /* cast to decimal to keep the fractional part */
    CAST(
        SUM(CASE WHEN b.Statu IN ('Issued','Overdue')
                 THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*),0)                    -- avoid divide-by-zero
        AS DECIMAL(5,2)
    ) AS OccupancyRate
FROM  Libraries l
LEFT JOIN Book b
       ON b.LibraryID = l.LibraryID
GROUP BY l.LibraryID, l.Names
ORDER BY OccupancyRate DESC;


--Members with loans but no fine 
SELECT DISTINCT m.MemberID, m.FirstName, m.LastName
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
LEFT JOIN Payment1 p1 ON l.LID = p1.ID
LEFT JOIN Payment2 p2 ON l.LID = p2.LID
LEFT JOIN Payment3 p3 ON l.LID = p3.ID
WHERE 
    ISNULL(p1.Amount, 0) = 0
    AND ISNULL(p2.LID, 0) = 0
    AND ISNULL(p3.ID, 0) = 0;


---Genres with high average ratings 

SELECT 
    b.Genre,
    AVG(r.Rating) AS AverageRating
FROM 
    Book b
JOIN 
    Review r ON b.BID = r.BID
GROUP BY 
    b.Genre
HAVING 
    AVG(r.Rating) > 4.0;

