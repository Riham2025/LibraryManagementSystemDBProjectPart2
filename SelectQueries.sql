
create database LibraryManagementSystem2 


USE LibraryManagementSystem2;

-----Members
CREATE TABLE Members (
MemberID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50)NOT NULL,
EstablishDate DATE
);

----Libraries
CREATE TABLE Libraries (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,  
    Names VARCHAR(100) NOT NULL,               
    Locations VARCHAR(100),                    
    EstYear INT CHECK (EstYear >= 1800),      
    ConNum VARCHAR(20) UNIQUE,                
    Statu VARCHAR(50) DEFAULT 'Open'
        
);
----Book
CREATE TABLE Book (
    BID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Genre VARCHAR(50) CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Statu VARCHAR(20) DEFAULT 'Issued'
        CHECK (Statu IN ('Issued', 'Returned', 'Overdue')),
    Price DECIMAL(10,2) CHECK (Price > 0),
    Locations VARCHAR(100),
    MemberID INT,
    LibraryID INT );

	

		alter table book
       ADD FOREIGN KEY (LibraryID) REFERENCES Libraries(LibraryID)
        ON DELETE CASCADE ON UPDATE CASCADE ;

		alter table Book 
	add  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE ;
    

----Review
CREATE TABLE Review (
    RID INT,
    BID INT,
    MemberID INT,
    RDate DATE NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR(500),
    PRIMARY KEY (RID, BID, MemberID),
    FOREIGN KEY (BID) REFERENCES Book(BID)
	);

	alter table Review
    add FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE ;


---staff
CREATE TABLE Staff (
    SID INT IDENTITY(1,1) PRIMARY KEY,            
    FName VARCHAR(50) NOT NULL,                     
    LName VARCHAR(50) NOT NULL,                    
    Position VARCHAR(50),                           
    PhoneN VARCHAR(20),                           
    LibraryID INT
	);

	alter table Staff 
    add FOREIGN KEY (LibraryID) REFERENCES Libraries(LibraryID)
    ON DELETE CASCADE
    ON UPDATE CASCADE ;


-------payment1 
CREATE TABLE Payment1 (
    ID INT IDENTITY(1,1) PRIMARY KEY,            
    Method VARCHAR(50) NOT NULL,                 
    Amount DECIMAL(10,2) CHECK (Amount > 0), 
    PDate DATE NOT NULL                        
);

-------payment2
CREATE TABLE Payment2 (
    LID INT PRIMARY KEY,                             
    bID INT NOT NULL,                               
    MemberID INT NOT NULL 
	);

alter table Payment2 
	add  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE NO ACTION ON UPDATE NO ACTION ;



-------payment3
CREATE TABLE Payment3 (
    LID INT NOT NULL,       
    ID INT NOT NULL,  
);

alter table Payment3
  add  PRIMARY KEY (LID, ID) ;   

  alter table Payment3
    add FOREIGN KEY (ID) REFERENCES Payment1(ID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION ;
	
alter table Payment3
   add FOREIGN KEY (LID) REFERENCES Payment2(LID)
        ON DELETE CASCADE
        ON UPDATE CASCADE ; 
	

alter table Payment3 
	add  FOREIGN KEY (LID) REFERENCES Payment2(LID)
        ON DELETE NO ACTION ON UPDATE NO ACTION ;

---loans
CREATE TABLE Loans (
    LID INT,                                
    bID INT,                                
    MemberID INT,                           
    
    LDate DATE NOT NULL,                   
    DuDate DATE NOT NULL,                  
    returnes DATE,                           
    Statu VARCHAR(20) DEFAULT 'Issued'
           CHECK (Statu IN ('Issued', 'Returned', 'Overdue')), 

    PRIMARY KEY (LID, bID, MemberID) 
	);
	alter table Loans 
	add  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE NO ACTION ON UPDATE NO ACTION ;

		alter table Loans 
	add  FOREIGN KEY (LID) REFERENCES Payment2(LID)
        ON DELETE NO ACTION ON UPDATE NO ACTION ;

	delete from Loans
where LID = 8	

alter table Loans 
	add  FOREIGN KEY (bID) REFERENCES Book(bID)
        ON DELETE NO ACTION ON UPDATE NO ACTION ;		

	


---email
CREATE TABLE Email (
    Email VARCHAR(100) NOT NULL UNIQUE,           
    MemberID INT NOT NULL,                         

    PRIMARY KEY (Email, MemberID)
	);

alter table Email 
	add  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE NO ACTION ON UPDATE NO ACTION ;



---phone
CREATE TABLE Phone (
    Phone VARCHAR(20) NOT NULL,               
    MemberID INT NOT NULL,
	PRIMARY KEY (Phone, MemberID)
	);
	alter table phone 
	add  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE NO ACTION ON UPDATE NO ACTION ;


	


------------------------------------------------------------------------------


INSERT INTO Libraries (Names, Locations, EstYear, ConNum, Statu) VALUES ('Central Library', 'Downtown', 1950, '100001', 'Open');
INSERT INTO Libraries (Names, Locations, EstYear, ConNum, Statu) VALUES ('Eastside Branch', 'East City', 1975, '100002', 'Open');
INSERT INTO Libraries (Names, Locations, EstYear, ConNum, Statu) VALUES ('Northside Library', 'North End', 1990, '100003', 'Under Maintenance');

INSERT INTO Members (FirstName, LastName, EstablishDate) VALUES ('Ali', 'Hassan', '2020-01-01');
INSERT INTO Members (FirstName, LastName, EstablishDate) VALUES ('Sara', 'Omar', '2019-05-10');
INSERT INTO Members (FirstName, LastName, EstablishDate) VALUES ('John', 'Doe', '2021-03-15');
INSERT INTO Members (FirstName, LastName, EstablishDate) VALUES ('Mona', 'Ali', '2022-07-18');
INSERT INTO Members (FirstName, LastName, EstablishDate) VALUES ('Khalid', 'Yusuf', '2018-11-22');
INSERT INTO Members (FirstName, LastName, EstablishDate) VALUES ('Aisha', 'Saleh', '2023-02-05');

INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('SQL Basics', '9781111111111', 'Reference', 'Issued', 60.00, 'Shelf A1', 1, 1);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Data Science 101', '9782222222222', 'Non-fiction', 'Issued', 70.00, 'Shelf A2', 2, 1);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Children Stories', '9783333333333', 'Children', 'Returned', 30.00, 'Shelf B1', 3, 2);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Python Programming', '9784444444444', 'Reference', 'Issued', 80.00, 'Shelf A3', 4, 1);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Machine Learning', '9785555555555', 'Non-fiction', 'Issued', 90.00, 'Shelf A4', 5, 3);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Fictional World', '9786666666666', 'Fiction', 'Returned', 50.00, 'Shelf C1', 6, 2);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Big Data', '9787777777777', 'Non-fiction', 'Overdue', 100.00, 'Shelf A5', 1, 3);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Kids ABC', '9788888888888', 'Children', 'Issued', 25.00, 'Shelf B2', 2, 2);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('Networking Essentials', '9789999999999', 'Reference', 'Returned', 65.00, 'Shelf D1', 3, 1);
INSERT INTO Book (Title, ISBN, Genre, Statu, Price, Locations, MemberID, LibraryID) VALUES ('AI for Beginners', '9781010101010', 'Non-fiction', 'Issued', 95.00, 'Shelf A6', 4, 3);

INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (1, 1, 1, '2024-04-01', '2024-04-15', NULL, 'Issued');
INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (2, 2, 2, '2024-03-01', '2024-03-15', '2024-03-14', 'Returned');
INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (3, 3, 3, '2024-02-01', '2024-02-10', '2024-02-09', 'Returned');
INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (4, 4, 4, '2024-05-01', '2024-05-15', NULL, 'Issued');
INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (5, 5, 5, '2024-01-01', '2024-01-10', NULL, 'Overdue');
INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (6, 6, 6, '2024-03-10', '2024-03-20', '2024-03-19', 'Returned');
INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (7, 7, 1, '2024-05-01', '2024-05-10', NULL, 'Overdue');
INSERT INTO Loans (LID, bID, MemberID, LDate, DuDate, returnes, Statu) VALUES (8, 8, 2, '2024-04-10', '2024-04-20', NULL, 'Issued');

INSERT INTO Payment1 (Method, Amount, PDate) VALUES ('Cash', 60.00, '2024-04-02');
INSERT INTO Payment1 (Method, Amount, PDate) VALUES ('Credit Card', 75.00, '2024-03-05');
INSERT INTO Payment1 (Method, Amount, PDate) VALUES ('Online', 90.00, '2024-01-02');
INSERT INTO Payment1 (Method, Amount, PDate) VALUES ('Cash', 30.00, '2024-05-01');

INSERT INTO Payment2 (LID, bID, MemberID)
VALUES (1, 1, 1),(3, 3, 3); 




INSERT INTO Payment3 (LID, ID)
VALUES (1, 1),(3, 3);   


INSERT INTO Staff (FName, LName, Position, PhoneN, LibraryID) VALUES ('Ahmed', 'Nour', 'Librarian', '0501234567', 1);
INSERT INTO Staff (FName, LName, Position, PhoneN, LibraryID) VALUES ('Laila', 'Mohsen', 'Assistant', '0502345678', 2);
INSERT INTO Staff (FName, LName, Position, PhoneN, LibraryID) VALUES ('Sami', 'Yahya', 'Manager', '0503456789', 3);
INSERT INTO Staff (FName, LName, Position, PhoneN, LibraryID) VALUES ('Nora', 'Adel', 'Technician', '0504567890', 1);

INSERT INTO Review (RID, BID, MemberID, RDate, Rating, Comments) VALUES (1, 1, 1, '2024-04-05', 5, 'Excellent resource.');
INSERT INTO Review (RID, BID, MemberID, RDate, Rating, Comments) VALUES (2, 2, 2, '2024-03-06', 4, 'Very informative.');
INSERT INTO Review (RID, BID, MemberID, RDate, Rating, Comments) VALUES (3, 3, 3, '2024-02-08', 3, 'Good for beginners.');
INSERT INTO Review (RID, BID, MemberID, RDate, Rating, Comments) VALUES (4, 4, 4, '2024-05-04', 5, 'Loved it.');
INSERT INTO Review (RID, BID, MemberID, RDate, Rating, Comments) VALUES (5, 5, 5, '2024-01-06', 2, 'Needs improvement.');
INSERT INTO Review (RID, BID, MemberID, RDate, Rating, Comments) VALUES (6, 6, 6, '2024-03-12', 4, 'Well written.');

insert into Email (email , MemberID) values 
('aaa@gmail.com' , 1), 
('www@gmail.com' , 2), 
('sss@gmail.com' , 3), 
('fff@gmail.com' , 4) ,
('ggg@gmail.com' , 5) ,
('bbb@gmail.com' , 6) ,
('ooo@gmail.com' , 7) ,
('mmm@gmail.com' , 8) ,
('zzz@gmail.com' , 9) ,
('vvv@gmail.com' , 10) ,
('nnn@gmail.com' , 11) ,
('uuu@gmail.com' , 12) ;



insert into Phone(phone , MemberID) values 
('91111111' , 1), 
('91111112' , 2), 
('91111113' , 3), 
('91111114' , 4) ,
('91111115' , 5) ,
('91111116' , 6) ,
('91111117' , 7) ,
('91111118' , 8) ,
('91111119' , 9) ,
('91111110' , 10) ,
('91111121' , 11) ,
('91119111' , 12) ;


delete from email 
where MemberID = 12

delete from Phone
where MemberID = 12







--------select
SELECT * FROM Members;

SELECT * FROM Libraries;

SELECT * FROM Book;

SELECT * FROM Loans;

SELECT * FROM Payment1;

SELECT * FROM Payment2;

SELECT * FROM Payment3;

SELECT * FROM Staff;

SELECT * FROM Review;

select * from Email;

select * from Phone;


---1 //GET /loans/overdue → List all overdue loans with member name, book title, due date 
SELECT 
    M.FirstName + ' ' + M.LastName AS MemberName,
    B.Title AS BookTitle,
    L.DuDate AS DueDate
FROM 
    Loans L
JOIN 
    Members M ON L.MemberID = M.MemberID
JOIN 
    Book B ON L.bID = B.BID
WHERE 
    L.Statu = 'Overdue';


---2 //GET /books/unavailable → List books not available 
SELECT Title 
FROM Book 
WHERE Statu <> 'Returned';

---3 //GET /members/top-borrowers → Members who borrowed >2 books
SELECT COUNT(l.MemberID)as Number_Borrows , m.FirstName + ' ' + m.LastName AS full_Name
FROM Members m
JOIN
Loans l ON m.MemberID = l.MemberID
GROUP BY  m.FirstName + ' ' + m.LastName
HAVING COUNT(l.MemberID) >= 1  ; --no members was borrowed > 2 books

---4 //GET /books/:id/ratings → Show average rating per book
SELECT 
    b.Title,
    AVG(r.Rating) AS AverageRating
FROM 
    Book b
JOIN 
    Review r ON b.BID = r.BID
GROUP BY 
    b.Title;

---5 //GET /libraries/:id/genres → Count books by genre 
SELECT 
    Genre,
    COUNT(*) AS BookCount
FROM Book
GROUP BY 
    Genre;

---6 //GET /members/inactive → List members with no loans 
SELECT 
   FirstName + ' ' + LastName as fullName
FROM 
    Members m
LEFT JOIN 
    Loans l ON m.MemberID = l.MemberID
WHERE 
    l.MemberID IS NULL;

---7 //GET /payments/summary → Total fine paid per member  
SELECT 
    m.FirstName,
    m.LastName,
    SUM(p1.Amount) AS TotalPaid
FROM 
    Members m
JOIN 
    Payment2 p2 ON m.MemberID = p2.MemberID
JOIN 
    Payment3 p3 ON p2.LID = p3.LID
JOIN 
    Payment1 p1 ON p3.ID = p1.ID
GROUP BY 
    m.FirstName, m.LastName;

---8 //GET /reviews → Reviews with member and book info
SELECT 
    r.RID,
    b.Title AS BookTitle,
    m.FirstName + ' ' + m.LastName AS MemberName,
    r.RDate,
    r.Rating,
    r.Comments
FROM 
    Review r
JOIN 
    Book b ON r.BID = b.BID
JOIN 
    Members m ON r.MemberID = m.MemberID;

---9 //GET /books/popular → List top 3 books by number of times they were loaned 
SELECT TOP 3 
    b.Title,
    COUNT(l.bID) AS LoanCount
FROM 
    Loans l
JOIN 
    Book b ON l.bID = b.BID
GROUP BY 
    b.Title
ORDER BY 
    LoanCount DESC;

---10 //GET /members/:id/history → Retrieve full loan history of a specific member including book title, loan & return dates 
SELECT 
    b.Title AS BookTitle,
    l.LDate AS LoanDate,
    l.returnes AS ReturnDate
FROM 
    Loans l
JOIN 
    Book b ON l.bID = b.BID
WHERE 
    l.MemberID = 1;

---11 //GET /books/:id/reviews → Show all reviews for a book with member name and comments 
	SELECT 
    CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
    r.Comments
FROM 
    Review r
JOIN 
    Members m ON r.MemberID = m.MemberID

---12 //GET /libraries/:id/staff → List all staff working in a given library 
SELECT 
    SID,
    FName,
    LName,
    Position,
    PhoneN
FROM 
    Staff
---WHERE LibraryID = 1; // spicefic library

---13 //GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range
DECLARE @min DECIMAL(10,2) = 50.00;   -- Example min price, can be replaced by input param
DECLARE @max DECIMAL(10,2) = 80.00;  -- Example max price, can be replaced by input param

SELECT 
    b.BID,
    b.Title,
    b.Price,
    l.Names AS LibraryName
FROM 
    Book b
JOIN 
    Libraries l ON b.LibraryID = l.LibraryID
WHERE 
    b.Price BETWEEN @min AND @max;

---14 //GET /loans/active → List all currently active loans (not yet returned) with member and book info	
SELECT 
    l.LID,
    l.bID,
    b.Title,
    l.MemberID,
    m.FirstName,
    m.LastName,
    l.LDate,
    l.DuDate,
    l.Statu
FROM 
    Loans l
JOIN 
    Book b ON l.bID = b.BID
JOIN 
    Members m ON l.MemberID = m.MemberID
WHERE 
    l.Statu = 'Issued';

---15 //GET /members/with-fines → List members who have paid any fine 
SELECT DISTINCT 
    m.MemberID,
    m.FirstName,
    m.LastName
FROM 
    Members m
JOIN 
    Payment2 p2 ON m.MemberID = p2.MemberID
JOIN 
    Payment3 p3 ON p2.LID = p3.LID
JOIN 
    Payment1 p1 ON p3.ID = p1.ID
WHERE 
    p1.Amount > 0; -- assuming any payment amount is considered a fine paid

---16 //GET /books/never-reviewed →  List books that have never been reviewed
SELECT 
    b.BID,
    b.Title
FROM 
    Book b
LEFT JOIN 
    Review r ON b.BID = r.BID
WHERE 
    r.BID IS NULL;

---17 // GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status.
SELECT 
    l.LDate AS LoanDate,
    l.DuDate AS DueDate,
    l.returnes AS ReturnDate,
    b.Title,
    l.Statu AS LoanStatus
FROM 
    Loans l
JOIN 
    Book b ON l.bID = b.BID

ORDER BY 
    l.LDate DESC;

---18 //GET /members/inactive →List all members who have never borrowed any book. 
	SELECT 
    m.MemberID,
    m.FirstName,
    m.LastName
FROM 
    Members m
LEFT JOIN 
    Loans l ON m.MemberID = l.MemberID
WHERE 
    l.MemberID IS NULL;

---19 //GET /books/never-loaned → List books that were never loaned.
	SELECT 
    b.BID,
    b.Title
FROM 
    Book b
LEFT JOIN 
    Loans l ON b.BID = l.bID
WHERE 
    l.bID IS NULL;

---20 //GET /payments →List all payments with member name and book title.
SELECT 
    p1.ID AS PaymentID,
    p1.Method,
    p1.Amount,
    p1.PDate,
    m.FirstName,
    m.LastName,
    b.Title
FROM 
    Payment1 p1
JOIN 
    Payment3 p3 ON p1.ID = p3.ID
JOIN 
    Payment2 p2 ON p3.LID = p2.LID
JOIN 
    Members m ON p2.MemberID = m.MemberID
JOIN 
    Book b ON p2.bID = b.BID;


---21- //GET /loans/overdue→ List all overdue loans with member and book details.
SELECT 
    l.LID,
    l.LDate,
    l.DuDate,
    l.returnes,
    l.Statu,
    m.FirstName,
    m.LastName,
    b.Title
FROM 
    Loans l
JOIN 
    Members m ON l.MemberID = m.MemberID
JOIN 
    Book b ON l.bID = b.BID
WHERE 
    l.Statu = 'Overdue'; --

---22- //GET /books/:id/loan-count → Show how many times a book has been loaned.
SELECT 
    b.BID,
    b.Title,
    COUNT(l.bID) AS LoanCount
FROM 
    Book b
LEFT JOIN 
    Loans l ON b.BID = l.bID

GROUP BY 
    b.BID, b.Title;


---23- //GET /members/:id/fines → Get total fines paid by a member across all loans. 
SELECT 
    m.MemberID,
    m.FirstName + ' ' + m.LastName AS MemberName,
    SUM(p1.Amount) AS TotalFinesPaid
FROM 
    Members m
JOIN 
    Payment2 p2 ON m.MemberID = p2.MemberID
JOIN 
    Payment3 p3 ON p2.LID = p3.LID
JOIN 
    Payment1 p1 ON p3.ID = p1.ID

GROUP BY 
    m.MemberID, m.FirstName, m.LastName;



---24- //GET /libraries/:id/book-stats → Show count of available and unavailable books in a library.
SELECT
    SUM(CASE WHEN b.Statu = 'Available' THEN 1 ELSE 0 END) AS AvailableBooks,
    SUM(CASE WHEN b.Statu != 'Available' THEN 1 ELSE 0 END) AS UnavailableBooks
FROM
    Book b


---25- //GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5. 
SELECT 
    b.BID,
    b.Title,
    COUNT(r.RID) AS ReviewCount,
    AVG(r.Rating) AS AverageRating
FROM 
    Book b
JOIN 
    Review r ON b.BID = r.BID
GROUP BY 
    b.BID, b.Title
HAVING 
    COUNT(r.RID) > 5 AND AVG(r.Rating) > 4.5;
