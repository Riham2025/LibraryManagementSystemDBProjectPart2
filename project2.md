## Repository Name: Library Management System - DB Project Part2 
Goal: Elevate your database from functional to production-ready. In this phase, you’ll improve 
performance, enable advanced reporting, implement automation, and ensure transactional integrity — 
just like a backend engineer in a real-world system.

## 1. SELECT Queries
1- GET /loans/overdue → List all overdue loans with member name, book title, due date

![](./image/1.PNG)


2- GET /books/unavailable → List books not available

![](./image/2.PNG)


3- GET /books/unavailable → List books not available

![](./image/3.PNG)


4- GET /members/top-borrowers → Members who borrowed >2 books

![](./image/4.PNG)


5- GET /books/:id/ratings → Show average rating per book

![](./image/5.PNG)


6- GET /members/inactive → List members with no loans 

![](./image/6.PNG)


7- GET /payments/summary → Total fine paid per member

![](./image/7.PNG) 


8- GET /reviews → Reviews with member and book info

![](./image/8.PNG)


9- GET /books/popular → List top 3 books by number of times they were loaned

![](./image/9.PNG)


10- GET /members/:id/history → Retrieve full loan history of a specific member including book title, 
loan & return dates

![](./image/10.PNG)


11- GET /books/:id/reviews → Show all reviews for a book with member name and comments

![](./image/11.PNG)


12- GET /libraries/:id/staff → List all staff working in a given library

![](./image/12.PNG)


13- GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range

![](./image/13.PNG)


14- GET /loans/active → List all currently active loans (not yet returned) with member and book info

![](./image/14.PNG)


15- GET /members/with-fines → List members who have paid any fine

![](./image/15.PNG)


16- GET /books/never-reviewed →  List books that have never been reviewed

![](./image/16.PNG)


17- // GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status.

![](./image/17.PNG)


18- //GET /members/inactive →List all members who have never borrowed any book. 

![](./image/18.PNG)


19- //GET /books/never-loaned → List books that were never loaned.

![](./image/19.PNG)


20- GET /payments →List all payments with member name and book title.

![](./image/20.PNG)


21- //GET /loans/overdue→ List all overdue loans with member and book details.

![](./image/21.PNG)


22- //GET /books/:id/loan-count → Show how many times a book has been loaned.

![](./image/22.PNG)


23- //GET /members/:id/fines → Get total fines paid by a member across all loans. 

![](./image/23.PNG)


24- //GET /libraries/:id/book-stats → Show count of available and unavailable books in a library.

![](./image/24.PNG)


25- 25- //GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5.

![](./image/25.PNG)



## 2. Indexing Strategy – Performance Optimization
Apply indexes to speed up commonly-used queries: 

--------------- Library Table

1. Library Table Non-clustered on Name → Search by name :

![](./image/26.PNG)

2. Non-clustered on Location → Filter by location :

![](./image/27.PNG)

 --------------- Book Table

3. Book Table Clustered on LibraryID, ISBN → Lookup by book in specific library

![](./image/28.PNG)

4. Non-clustered on Genre → Filter by genre 

![](./image/29.PNG)

----------------Loan Table 

5. Non-clustered on MemberID → Loan history

![](./image/30.PNG)

6. Non-clustered on Status → Filter by status

![](./image/31.PNG)

7. Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks

![](./image/32.PNG)


##  Views – Frontend Integration Support

1. ViewPopularBooks Books with average rating > 4.5 + total loans

![](./image/33.PNG)

2.ViewMemberLoanSummary Member loan count + total fines paid  

![](./image/34.PNG)

3. ViewAvailableBooks Available books grouped by genre, ordered by price

![](./image/35.PNG)

4. ViewLoanStatusSummary Loan stats (issued, returned, overdue) per library

![](./image/36.PNG)

5. ViewPaymentOverview Payment info with member, book, and status

![](./image/37.PNG)


##  3. Functions – Reusable Logic 

1. GetBookAverageRating(BookID) Returns average rating of a book 

![](./image/38.PNG)

2. GetNextAvailableBook(Genre, Title, LibraryID) Fetches the next available book

![](./image/39.PNG)

3. CalculateLibraryOccupancyRate(LibraryID) Returns % of books currently issued 

![](./image/40.PNG)

4. fn_GetMemberLoanCount Return the total number of loans made by a given member.

![](./image/41.PNG)

5. fn_GetLateReturnDays Return the number of late days for a loan (0 if not late).

![](./image/42.PNG)

6. fn_ListAvailableBooksByLibrary Returns a table of available books from a specific library. 

![](./image/43.PNG)

7. fn_GetTopRatedBooks Returns books with average rating ≥ 4.5 

![](./image/44.PNG)

8. fn_FormatMemberName Returns the full name formatted as "LastName, FirstName" 

![](./image/45.PNG)


## 4. Stored Procedures – Backend Automation 

1. sp_MarkBookUnavailable(BookID) Updates availability after issuing

![](./image/46.PNG)

2. sp_UpdateLoanStatus() Checks dates and updates loan statuses

![](./image/47.PNG)

3. sp_RankMembersByFines() Ranks members by total fines paid 

![](./image/48.PNG)

## 5. Triggers – Real-Time Business Logic

1. After new loan → set book to unavailable

![](./image/49.PNG)

2. trg_CalculateLibraryRevenue After new payment → update library revenue 

![](./image/50.PNG)

3. trg_LoanDateValidation Prevents invalid return dates on insert 

![](./image/51.PNG)


## 6. Aggregation Functions – Dashboard Reports 

1. Total fines per member

![](./image/52.PNG)

2. Most active libraries (by loan count)

![](./image/53.PNG)

3. Avg book price per genre 

![](./image/54.PNG)

4. Top 3 most reviewed books 

![](./image/55.PNG)

5. Library revenue report 

![](./image/56.PNG)

6. Member activity summary (loan + fines)

![](./image/57.PNG)


## 7. Advanced Aggregations – Analytical Insight 

1. HAVING for filtering aggregates

![](./image/58.PNG)

2. Subqueries for complex logic (e.g., max price per genre)

![](./image/59.PNG)

3. Occupancy rate calculations 

![](./image/60.PNG)

4. Members with loans but no fine 

![](./image/61.PNG)

5. Genres with high average ratings

![](./image/62.PNG)


## 8. Transactions – Ensuring Consistency 

1. Borrowing a book (loan insert + update availability)

![](./image/63.PNG)

2. Returning a book (update status, return date, availability).

![](./image/64.PNG)

3. Registering a payment (with validation) 

![](./image/65.PNG)

4. Batch loan insert with rollback on failure

