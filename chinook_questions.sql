-- Using a subquery, find the name of all tracks from the album 'Californication'

select name 
from track
where albumId = (select albumid
from album
where title = 'Californication');

-- Find the total number of invoices for each customer along with the customer’s full name, city and email.
select concat(FirstName,' ',LastName) CustomerName, city, email, (select count(*)
from invoice
where invoice.customerID=customer.customerID) Invoices 
from customer;

-- Retrieve the track name, album, artist, and trackID for all the albums.
select t.name , trackID, a.title, a.artistID
from album a left join track t using (albumId);

-- Retrieve a list with the managers last name, and the last name of the employees who report to him or her.
select a.lastname manager, b.lastname employee
from employee a join employee b where (a.employeeID=b.reportsto);

-- Find the name and ID of the artists who do not have albums.
select ar.name, ar.artistid
from artist ar
where ar.artistid not in (select artistID
from album);

-- Use a UNION to create a list of all the employee’s & customer’s first names and last names ordered by the last name in descending order.
select firstname, lastname
from employee
union 
select firstname, lastname
from customer
order by lastname desc;

-- See if there are any customers who have a different city listed in their billing city versus their customer city.

select count(*)
from customer left join invoice
on customer.customerid=invoice.customerid
where customer.city <> invoice.billingcity;

-- Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
select customerId, firstName, LastName, country
from customer
where country <> 'USA';

-- Provide a query only showing the Customers from Brazil.

select *
from customer
where country = 'Brazil';

-- Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.

select firstname, lastname, invoiceid, invoicedate, billingcountry
from customer join invoice using (customerID)
where billingcountry = 'Brazil';

-- Provide a query showing only the Employees who are Sales Agents.

select *
from employee
where title = 'Sales Support Agent';

-- Provide a query showing a unique list of billing countries from the Invoice table.

select distinct billingcountry
from invoice;

-- Provide a query showing the invoices of customers who are from Brazil.

select * 
from customer c, invoice i
where c.country= 'Brazil' and
c.customerid=i.customerid;

-- Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
select e.firstname, e.lastname, i.invoiceid, i.customerid, i.invoicedate, i.billingaddress, i.billingcountry, i.billingpostalcode, i.total
from customer as c join invoice as i on c.customerid = i.customerid
join employee as e
on e.employeeid = c.supportrepid
order by e.employeeid;

-- Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
select c.firstname customerFirst, c.lastname CustomerLast, c.country, e.firstname EmployeeFirst, e.lastname EmployeeLast, i.total
from invoice i join customer c on i.customerid=c.customerid 
join employee e on e.employeeid=c.supportrepid;

-- How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?
select count(i.invoiceid), sum(i.total)
from invoice i 
where year(i.invoicedate) = 2009; 

-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
select count(*)
from invoiceline 
where invoiceid = 37; 

-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
select invoiceID, count(*)
from invoiceline
group by invoiceID;

-- Provide a query that includes the track name with each invoice line item.

select i.*, name 
from invoiceline i join track t using (trackID);

-- Provide a query that includes the purchased track name AND artist name with each invoice line item.

select i.*, t.name TrackName, ar.name ArtistName
from invoiceline i, track t, album al, artist ar
where i.trackid=t.trackid
and t.albumid=al.albumid
and al.artistid=ar.artistid;

-- Provide a query that shows the # of invoices per country. HINT: GROUP BY

select billingcountry, count(*)
from invoice
group by billingcountry;

-- Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.

select P.name, p2.playlistID, count(p2.trackID) Songs
from playlist p join playlistTrack p2 on (p.playlistid=p2.playlistid)
group by 1,2;

-- Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.

select t.name track, al.title album, m.name mediatype, g.name genre
from track t, album al, mediatype m, genre g
where t.albumid=al.albumid
and t.genreid=g.genreid
and t.mediatypeid=m.mediatypeid
group by 1;

-- Provide a query that shows all Invoices but includes the # of invoice line items.

select invoice.*, count(invoicelineid)
from invoice join invoiceline using (invoiceid)
group by invoice.invoiceid;

-- Provide a query that shows total sales made by each sales agent.

select e.firstname, e.lastname, count(i.invoiceid) TotalSales
from invoice i, customer c, employee e
where i.customerID=c.customerID
and c.supportrepid=e.employeeid
group by e.employeeid;

-- Which sales agent made the most in sales in 2009?
select e.firstname, e.lastname, count(i.invoiceid) TotalSales
from invoice i, customer c, employee e
where i.customerID=c.customerID
and c.supportrepid=e.employeeid
and year(invoicedate) = 2009
group by e.employeeid
order by totalsales desc 
limit 1;

-- Which sales agent made the most in sales in 2010?

select e.firstname, e.lastname, count(i.invoiceid) TotalSales
from invoice i, customer c, employee e
where i.customerID=c.customerID
and c.supportrepid=e.employeeid
and year(invoicedate) = 2010
group by e.employeeid
order by totalsales desc 
limit 1;


-- Which sales agent made the most in sales over all?

select e.firstname, e.lastname, count(i.invoiceid) TotalSales
from invoice i, customer c, employee e
where i.customerID=c.customerID
and c.supportrepid=e.employeeid
group by e.employeeid
order by totalsales desc 
limit 1;

-- Provide a query that shows the # of customers assigned to each sales agent.

select e.employeeID, e.firstname, e.lastname, count(distinct i.customerID)
from invoice i join customer c using (customerID) join employee e on(c.supportrepid=e.employeeid)
group by 1;


-- Provide a query that shows the total sales per country. Which country's customers spent the most?

select billingcountry, sum(total) sales
from invoice
group by billingcountry
order by sales desc;

-- Provide a query that shows the most purchased track of 2013.

select *, count(t.trackid) sales
from invoiceline il join invoice i using (invoiceid) join track t on t.trackid=il.trackid
where year(i.invoicedate) = 2013
group by t.trackid
order by sales desc;

-- Provide a query that shows the top 5 most purchased tracks over all.

select t.trackid, count(i.trackid) sales
from track t join invoiceline i using (trackid)
group by 1
order by sales desc
limit 5;

-- Provide a query that shows the top 3 best selling artists.
select ar.name, count(i.trackid) sales
from artist ar, album a, track t, invoiceline i
where ar.artistID=a.artistid
and a.albumid=t.albumid
and t.trackid=i.trackid
group by ar.artistid
order by sales desc limit 3;

-- Provide a query that shows the most purchased Media Type.
select m.mediatypeid, m.name, count(i.trackid)
from mediatype m, track t, invoiceline i
where m.mediatypeid=t.mediatypeid
and t.trackid=i.trackid
group by 1 
order by count(i.trackid) desc
limit 1;