show databases;
use library;
show tables;
# 1. Show the members under the name "Jens S." who were born before 1970 that became members of the library in 2013.
Select * From tmember Where cName  LIKE 'Jens S.' And Year(dBirth) < 1970 AND YEAR(dNewMember) = 2013;
# 2. Show those books that have not been published by the publishing companies with ID 15 and 32, except if they were published before 2000.
SELECT * FROM tbook WHERE  nPublishingCompanyID NOT IN (15,32) OR nPublishingYear < 2000;
# 3. Show the name and surname of the members who have a phone number, but no address.
SELECT cName, cSurname FROM tmember WHERE  cPhoneNo IS NOT NULL AND cAddress IS NULL;
# 4. Show the authors with surname "Byatt" whose name starts by an "A" (uppercase) and contains an "S" (uppercase).
SELECT * FROM tauthor WHERE cSurname LIKE 'Byatt' AND LEFT(cName,1) LIKE 'A' AND cName LIKE '%S%';
# 5. Show the number of books published in 2007 by the publishing company with ID 32.
#displays num of books
select count(*) AS "NUM" from tbook where nPublishingYear = 2007 AND nPublishingCompanyID = 32;
#displays this book
SELECT * FROM tbook WHERE nPublishingYear = 2007 AND nPublishingCompanyID = 32;
# 6. For each day of the year 2014, show the number of books loaned by the member with CPR "0305393207";
SELECT * FROM tloan WHERE YEAR(dLoan) = 2014 AND cCPR = '0305393207' ORDER BY dLoan ASC;
#displays days with loans
SELECT dLoan, COUNT(dLoan) FROM tloan WHERE YEAR(dLoan) = 2014 AND cCPR = '0305393207' GROUP BY dLoan ORDER BY dLoan ASC;

# 7. Modify the previous clause so that only those days where the member was loaned more than one book appear.
SELECT dLoan, COUNT(dLoan) FROM tloan WHERE YEAR(dLoan) = 2014 AND cCPR = '0305393207' GROUP BY dLoan HAVING count(dLoan) > 1 ORDER BY dLoan;

# 8. Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
SELECT * FROM tmember ORDER BY dNewMember DESC, cSurname, cName;

# 9. Show the title of all books published by the publishing company with ID 32 along with their theme or themes.

select tbook.ctitle, ttheme.cName from tbook, ttheme where nPublishingCompanyID = 32;
# 10. Show the name and surname of every author along with the number of books authored by them, but only for authors who have registered books on the database.

SELECT cName, cSurname, COUNT(*) AS "Books Authored"
FROM tauthorship
          JOIN tbook USING (nBookID)
          JOIN tauthor USING (nAuthorID) GROUP BY tauthor.nAuthorID;
# 11. Show the name and surname of all the authors with published books along with the lowest publishing year for their books.
SELECT tauthor.cName, tauthor.cSurname, MIN(tbook.nPublishingYear)
FROM tauthor
JOIN tauthorship ON tauthor.nAuthorID = tauthorship.nAuthorID
JOIN tbook ON tauthorship.nBookID = tbook.nBookID group by  tauthor.cName, tauthor.cSurname;



# 12. For each signature and loan date, show the title of the corresponding books and the name and surname of the member who had them loaned.

select t.cSignature, tloan.dLoan, t2.cTitle , t3.cName, t3.cSurname from tloan join tbookcopy t on tloan.cSignature = t.cSignature join tbook t2 on t.nBookID = t2.nBookID join tmember t3 on tloan.cCPR = t3.cCPR ORDER BY dLoan asc;



# 13. Repeat exercises 9 to 12 using the modern JOIN notation.
#9
select  tbook.ctitle, t2.cName from tbook join tbooktheme t on tbook.nBookID = t.nBookID join ttheme t2 on t.nThemeID = t2.nThemeID where nPublishingCompanyID = 32;

# 14. Show all theme names along with the titles of their associated books. All themes must appear (even if there are no books for some particular themes). Sort by theme name.
select ttheme.cName, t2.cTitle from ttheme join tbooktheme t on ttheme.nThemeID = t.nThemeID join tbook t2 on t.nBookID = t2.nBookID order by ttheme.cName;


# 15. Show the name and surname of all members who joined the library in 2013 along with the title of the books they took on loan during that same year. All members must be shown, even if they did not take any book on loan during 2013. Sort by member surname and name.se
select tmember.cName, tmember.cSurname, t3.cTitle from tmember cross join tloan t on tmember.cCPR = t.cCPR cross join  tbookcopy t2 on t.cSignature = t2.cSignature cross join tbook t3 on t2.nBookID = t3.nBookID
where  Year(tmember.dNewMember) = 2013 and YEAR(t.dLoan) = 2013  ORDER BY tmember.cSurname, tmember.cName;

# 16. Show the name and surname of all authors along with their nationality or nationalities and the titles of their books. Every author must be shown, even though s/he has no registered books. Sort by author name and surname.
SELECT tauthor.cName, tauthor.cSurname, tcountry.cName, tbook.cTitle
FROM tauthor
LEFT  JOIN tnationality ON tauthor.nAuthorID = tnationality.nAuthorID
LEFT  JOIN tcountry ON tnationality.nCountryID = tcountry.nCountryID
LEFT  JOIN tauthorship ON tauthor.nAuthorID = tauthorship.nAuthorID
LEFT  JOIN tbook on tauthorship.nBookID = tbook.nBookID
ORDER BY tauthor.cName, tauthor.cSurname;
# 17. Show the title of those books which have had different editions published in both 1970 and 1989.
select tbook.cTitle from tbook  where nPublishingYear in(1970,1989) group by cTitle having count(tbook.cTitle) > 1;



# 18. Show the surname and name of all members who joined the library in December 2013 followed by the surname and name of those authors whose name is “William”.
select tmember.cName, tmember.cSurname, tauthor.cName, tauthor.cSurname, tmember.dNewMember from tmember  join tauthor where tauthor.cName LIKE 'William' and year(dNewMember) = 2013 and month(dNewMember) = 12;
# 19. Show the name and surname of the first chronological member of the library using subqueries.
select cName, cSurname, dNewMember from tmember  order by  date (dNewMember) asc  limit 1;

# 20. For each publishing year, show the number of book titles published by publishing companies from countries that constitute the nationality for at least three authors. Use subqueries.
SELECT nPublishingYear, COUNT(*)
FROM tbook
 JOIN tpublishingcompany USING (nPublishingCompanyID)
 JOIN (SELECT nCountryID, COUNT(*)
FROM tauthor
LEFT JOIN  tnationality USING (nAuthorID)
GROUP BY nCountryID
HAVING COUNT(*) >= 3) c
ON c.nCountryID=tpublishingcompany.nCountryID
GROUP BY nPublishingYear
ORDER BY nPublishingYear;
# 21. Show the name and country of all publishing companies with the headings "Name" and "Country".
select tpublishingcompany.cName, t.cName from tpublishingcompany join tcountry t on tpublishingcompany.nCountryID = t.nCountryID;
# 22. Show the titles of the books published between 1926 and 1978 that were not published by the publishing company with ID 32.
SELECT cTitle FROM tbook WHERE nPublishingYear BETWEEN  1926 AND 1978 AND  nPublishingCompanyID = 32;

# 23. Show the name and surname of the members who joined the library after 2016 and have no address.
SELECT cSurname, cName FROM tmember WHERE YEAR(dNewMember) > 2016  AND cAddress IS NULL;
# 24. Show the country codes for countries with publishing companies. Exclude repeated values.
SELECT DISTINCT tcountry.nCountryID, tcountry.cName from tcountry join tpublishingcompany t on tcountry.nCountryID = t.nCountryID;
# 25. Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".
select tbook.cTitle from tbook join tpublishingcompany  t on tbook.nPublishingCompanyID = t.nPublishingCompanyID where tbook.cTitle like 'The Tale%' and t.cName not like 'Lynch Inc';
# 26. Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.
select distinct ttheme.cName from ttheme
join tbooktheme t on ttheme.nThemeID = t.nThemeID
join  tbook t2 on t.nBookID = t2.nBookID
join tpublishingcompany t3 on t2.nPublishingCompanyID = t3.nPublishingCompanyID where t3.cName LIKE 'Lynch Inc';

# 27. Show the titles of those books which have never been loaned.
SELECT DISTINCT tbook.cTitle
FROM tbook left join tbookcopy  on tbook.nBookID = tbookcopy.nBookID
left join tloan  on tbookcopy.cSignature = tloan.cSignature
where tloan.dLoan is null;

# 28. For each publishing company, show its number of existing books under the heading "No. of Books".
select tpublishingcompany.cName, count(*) As 'No. of Books' from tpublishingcompany join tbook t on tpublishingcompany.nPublishingCompanyID = t.nPublishingCompanyID group by tpublishingcompany.cName;

# 29. Show the number of members who took some book on a loan during 2013.
select  count(*) AS "Num of m. loan book in 2013" from tmember join tloan t on tmember.cCPR = t.cCPR where year(dLoan) = 2013;

# 30. For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".
select tbook.cTitle, count(t.nAuthorID) as 'No. of Authors' from tbook join tauthorship t on tbook.nBookID = t.nBookID  group by tbook.cTitle having count(*) > 1;



