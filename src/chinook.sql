show databases;
use Chinook;
show tables;

select * from Album;
select * from Playlist;
#1. How many songs are there in the playlist “Grunge”?
select count(*) As 'Grunge' from Playlist where Name LIKE 'Grunge';
#2.Show information about artists whose name includes the text “Jack” and about artists whose name includes the text “John”, but not the text “Martin”.
select *
from Artist where Name LIKE '%Jack%' or Name like '%John%' and Name NOT LIKE '%Martin%';
#3.For each country where some invoice has been issued, show the total invoice monetary amount, but only for countries where at least $100 have been invoiced. Sort the information from higher to lower monetary amount.
select Invoice.BillingCountry, SUM(Total) from Invoice group by BillingCountry  HAVING SUM(Total) >= 100 order by 2 DESC;

#4.Get the phone number of the boss of those employees who have given support to clients who have bought some song composed by “Miles Davis” in “MPEG Audio File” format.
SELECT DISTINCT employee.Phone FROM employee
 JOIN customer ON employee.EmployeeId = customer.SupportRepId
JOIN invoice ON customer.CustomerId = invoice.CustomerId
JOIN invoiceline ON invoice.InvoiceId = invoiceline.InvoiceId
 JOIN track ON invoiceline.TrackId = track.TrackId
AND track.Composer = 'Miles Davis';

#5.Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova” genre whose title starts by the word “Samba”.
select DISTINCT * from Album join Track T on Album.AlbumId = T.AlbumId join Genre G on T.GenreId = G.GenreId where G.Name = 'Bossa Nova' and Album.Title like 'Samba%';
select * from Album where Title like 'Samba%';



#6.For each genre, show the average length of its songs in minutes (without indicating seconds). Use the headers “Genre” and “Minutes”, and include only genres that have any song longer than half an hour.
SELECT genre.Name AS Genre, FLOOR(AVG(track.Milliseconds / 60000)) AS Minutes
FROM genre
         JOIN track ON genre.GenreId = track.GenreId
GROUP BY genre.Name
HAVING AVG((track.Milliseconds / 60000) > 30);

#7.How many client companies have no state?
select count(Company)
from Customer WHERE Company Is NOT  NULL;
#8.For each employee with clients in the “USA”, “Canada” and “Mexico” show the number of clients from these countries s/he has given support, only when this number is higher than 6. Sort the query by number of clients. Regarding the employee, show his/her first name and surname separated by a space. Use “Employee” and “Clients” as headers.
SELECT CONCAT(employee.FirstName, ' ', employee.LastName) AS Employee,
       COUNT(customer.Country) AS Clients
FROM employee
         JOIN customer ON employee.EmployeeId = customer.SupportRepId
WHERE customer.Country = 'USA' OR customer.Country = 'Canada' OR customer.Country = 'Mexico'
GROUP BY employee
HAVING Clients > 6
ORDER BY Clients;

#9.For each client from the “USA”, show his/her surname and name (concatenated and separated by a comma) and their fax number. If they do not have a fax number, show the text “S/he has no fax”. Sort by surname and first name.
select CONCAT(Customer.FirstName, ' ', Customer.LastName) AS INFO,
CASE
WHEN Customer.Fax is null THEN 'S/he has no fax'
ELSE Customer.Fax
END AS 'FAX'
from Customer
WHERE Customer.Country = 'USA'
ORDER BY FirstName, LastName;



#10.For each employee, show his/her first name, last name, and their age at the time they were hired.
select Employee.FirstName, Employee.LastName, TIMESTAMPDIFF(YEAR Emp) from Employee