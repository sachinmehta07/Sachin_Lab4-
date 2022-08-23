#    Q3  Display the total number of customers based on gender 
#        who have placed orders of worth at least Rs.3000.

Select count(p.cus_gender) as "Number of Customers", p.cus_gender from
(select c.cus_id, c.cus_name,c.cus_gender,o.ord_id,o.ord_amount
from customer as c,`order` as O where o.cus_id=c.cus_id and o.ord_amount>=3000 group by c.cus_id) as P
group by cus_gender;

# Q4 Display all the orders along with product name ordered by a customer having Customer_Id=2

select pr.pro_name,p.ord_id,p.ord_date,p.cus_id,p.ord_amount from product pr inner join
(select o.ord_id, o.pricing_id,o.ord_date,o.cus_id,o.ord_amount,s.pro_id from `order` O, supplier_pricing S 
where cus_id=2 and o.pricing_id=s.pricing_id) as P on p.pro_id=pr.pro_id;

# Q5 Display the Supplier details who can supply more than one product.

select * from Supplier having supp_id in
(select supp_id from supplier_pricing group by supp_id having count(pro_id)>1);

# Q6 Find the least expensive product from each category 
#    and print the table with category id, name, product name and price of the product

Select c.cat_id, c.cat_Name, Q.pro_name,min(Q.supp_price) as Price_of_Product from 
category c inner join
(select s.pro_id,cat_id,supp_price,p.pro_name from supplier_pricing S,product P 
where s.pro_id=p.pro_id)as Q  on c.cat_id=Q.cat_id group by cat_id; 

# Q7)	Display the Id and Name of the Product ordered after “2021-10-05”.

Select p.pro_id, p.pro_name from product P inner join
(select s.pro_id, o.pricing_id from `order` o ,supplier_pricing S 
where o.ord_date > '2021-10-05' and o.pricing_id=s.pricing_id) as Q on q.pro_id=p.pro_id;

# Q8)	Display customer name and gender whose names start or end with character 'A'.

select cus_name,cus_gender from Customer where cus_name like 'A%' or cus_name like '%A';

# Q9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service.
#       For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”,
#    If rating >2 print “Average Service” else print “Poor Service”.

delimiter &&
create procedure Display_Supplier_Value()
Begin
select s.supp_id as Supplier_Id,s.supp_name as Supplier_Name, avg(a.rat_ratstars) as Rating, 
Case
    when avg(a.rat_ratstars)=5 then "Excellent Service"
    when avg(a.rat_ratstars)>4 then "Good Service"
    when avg(a.rat_ratstars)>2 then "Avg Service"
    else "Poor Service" end
    as Type_of_service from Supplier S inner join  
(select q.ord_id,q.pricing_id,s.Supp_id, q.rat_ratstars from supplier_pricing s inner join
(select o.pricing_id,r.rat_ratstars,r.ord_id from rating r,`order` o where r.ord_id=o.ord_id) 
as Q on q.pricing_id=s.pricing_id order by ord_id) as A on a.supp_id=s.supp_id group by Supplier_Id;

End &&

call Display_Supplier_Value;