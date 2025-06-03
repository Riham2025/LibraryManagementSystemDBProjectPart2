
--------------------------- 3. Functions – Reusable Logi

--GetBookAverageRating(BookID) 
--1. GetBookAverageRating(BookID) 
--Returns average rating of a book 

CREATE FUNCTION GetBookAverageRating (@BookID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AverageRating FLOAT;

    SELECT @AverageRating = AVG(Rating)
    FROM Review
    WHERE BID = @BookID;

    RETURN @AverageRating;
END;

--to call GetBookAverageRating
SELECT dbo.GetBookAverageRating(1) AS AverageRating;


--GetNextAvailableBook(Genre, Title, LibraryID) Fetches the next available book
CREATE FUNCTION GetNextAvailableBook (
    @Genre NVARCHAR(50),
    @Title NVARCHAR(100),
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN
    SELECT TOP 1 
        b.BID,
        b.Title,
        b.Genre,
        b.ISBN,
        b.LibraryID
    FROM 
        Book b
    LEFT JOIN 
        Loans l ON b.BID = l.BID AND l.Statu = 'Issued'
    WHERE 
        b.Genre = @Genre
        AND b.Title = @Title
        AND b.LibraryID = @LibraryID
        AND l.LID IS NULL 
    ORDER BY 
        b.BID;

--to call GetBookAverageRating
		SELECT * 
FROM dbo.GetNextAvailableBook('Fiction', 'Fictional World', 1);


---CalculateLibraryOccupancyRate(LibraryID) Returns % of books currently issued 
CREATE FUNCTION CalculateLibraryOccupancyRate (
    @LibraryID INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @TotalBooks INT;
    DECLARE @IssuedBooks INT;

    SELECT @TotalBooks = COUNT(*) 
    FROM Book 
    WHERE LibraryID = @LibraryID;

    SELECT @IssuedBooks = COUNT(DISTINCT b.BID)
    FROM Book b
    JOIN Loans l ON b.BID = l.BID
    WHERE 
        b.LibraryID = @LibraryID
        AND l.Statu = 'active';

    IF @TotalBooks = 0
        RETURN 0;

    RETURN CAST(@IssuedBooks * 100.0 / @TotalBooks AS DECIMAL(5,2));
END;

--to call GetBookAverageRating
SELECT dbo.CalculateLibraryOccupancyRate(3) AS OccupancyRate;


---fn_GetMemberLoanCount Return the total number of loans made by a given member. 
CREATE FUNCTION fn_GetMemberLoanCount (
    @MemberID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @LoanCount INT;

    SELECT @LoanCount = COUNT(*)
    FROM Loans
    WHERE MemberID = @MemberID;

    RETURN @LoanCount;
END;

SELECT dbo.fn_GetMemberLoanCount(1) AS TotalLoans;


---fn_GetLateReturnDays Return the number of late days for a loan (0 if not late). 
CREATE FUNCTION fn_GetLateReturnDays (
    @LoanID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @LateDays INT;

    SELECT @LateDays = 
        CASE 
            WHEN returnes IS NOT NULL AND returnes > DuDate THEN DATEDIFF(DAY, DuDate, returnes)
            ELSE 0
        END
    FROM Loans
    WHERE LID = @LoanID;

    RETURN ISNULL(@LateDays, 0);
END;

SELECT dbo.fn_GetLateReturnDays(101) AS LateDays;


---fn_ListAvailableBooksByLibrary Returns a table of available books from a specific library. 
CREATE FUNCTION fn_ListAvailableBooksByLibrary (
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN
    SELECT 
        b.BID,
        b.Title,
        b.Genre,
        b.Price
    FROM 
        Book b
    WHERE 
        b.LibraryID = @LibraryID
        AND b.BID NOT IN (
            SELECT BID 
            FROM Loans 
            WHERE returnes IS NULL
        );

		SELECT * 
FROM fn_ListAvailableBooksByLibrary(2);



---fn_GetTopRatedBooks Returns books with average rating ≥ 4.5 
CREATE FUNCTION fn_GetTopRatedBooks()
RETURNS TABLE
AS
RETURN
    SELECT 
        b.BID,
        b.Title,
        AVG(r.Rating) AS AverageRating
    FROM 
        Book b
    JOIN 
        Review r ON b.BID = r.BID
    GROUP BY 
        b.BID, b.Title
    HAVING 
        AVG(r.Rating) >= 4.5;

		SELECT * FROM fn_GetTopRatedBooks();


		--fn_FormatMemberName Returns the full name formatted as "LastName, FirstName" 
		CREATE FUNCTION fn_FormatMemberName
(
    @MemberID INT
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @FullName VARCHAR(100);

    SELECT @FullName = LastName + ', ' + FirstName
    FROM Members
    WHERE MemberID = @MemberID;

    RETURN @FullName;
END

SELECT dbo.fn_FormatMemberName(1);

