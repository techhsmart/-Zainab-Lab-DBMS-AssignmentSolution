-- 1) Create schema and tables
Create Database if not exists `ecommerce` ;
use `ecommerce`;


create table if not exists `supplier`(
`SUPP_ID` int primary key,
`SUPP_NAME` varchar(50) ,
`SUPP_CITY` varchar(50),
`SUPP_PHONE` varchar(10)
);


CREATE TABLE IF NOT EXISTS `customer` (
  `CUS_ID` INT NOT NULL,
  `CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `CUS_PHONE` VARCHAR(10),
  `CUS_CITY` varchar(30) ,
  `CUS_GENDER` CHAR,
  PRIMARY KEY (`CUS_ID`));


CREATE TABLE IF NOT EXISTS `category` (
  `CAT_ID` INT NOT NULL,
  `CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
 
  PRIMARY KEY (`CAT_ID`)
  );


  CREATE TABLE IF NOT EXISTS `product` (
  `PRO_ID` INT NOT NULL,
  `PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
  `PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
  `CAT_ID` INT NOT NULL,
  PRIMARY KEY (`PRO_ID`),
  FOREIGN KEY (`CAT_ID`) REFERENCES category (`CAT_ID`)
  
  );


 CREATE TABLE IF NOT EXISTS `product_details` (
  `PROD_ID` INT NOT NULL,
  `PRO_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `PROD_PRICE` INT NOT NULL,
  PRIMARY KEY (`PROD_ID`),
  FOREIGN KEY (`PRO_ID`) REFERENCES product (`PRO_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES supplier(`SUPP_ID`)
  
  );


CREATE TABLE IF NOT EXISTS `order` (
  `ORD_ID` INT NOT NULL,
  `ORD_AMOUNT` INT NOT NULL,
  `ORD_DATE` DATE,
  `CUS_ID` INT NOT NULL,
  `PROD_ID` INT NOT NULL,
  PRIMARY KEY (`ORD_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES customer(`CUS_ID`),
  FOREIGN KEY (`PROD_ID`) REFERENCES product_details(`PROD_ID`)
  );


CREATE TABLE IF NOT EXISTS `rating` (
  `RAT_ID` INT NOT NULL,
  `CUS_ID` INT NOT NULL,
  `SUPP_ID` INT NOT NULL,
  `RAT_RATSTARS` INT NOT NULL,
  PRIMARY KEY (`RAT_ID`),
  FOREIGN KEY (`SUPP_ID`) REFERENCES supplier (`SUPP_ID`),
  FOREIGN KEY (`CUS_ID`) REFERENCES customer(`CUS_ID`)
  );


-- 2) Inserting data
insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');

  
INSERT INTO `CUSTOMER` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `CUSTOMER` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `CUSTOMER` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `CUSTOMER` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `CUSTOMER` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');


INSERT INTO `CATEGORY` VALUES( 1,"BOOKS");
INSERT INTO `CATEGORY` VALUES(2,"GAMES");
INSERT INTO `CATEGORY` VALUES(3,"GROCERIES");
INSERT INTO `CATEGORY` VALUES (4,"ELECTRONICS");
INSERT INTO `CATEGORY` VALUES(5,"CLOTHES");
  
  
INSERT INTO `PRODUCT` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `PRODUCT` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `PRODUCT` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `PRODUCT` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `PRODUCT` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

  
INSERT INTO PRODUCT_DETAILS VALUES(1,1,2,1500);
INSERT INTO PRODUCT_DETAILS VALUES(2,3,5,30000);
INSERT INTO PRODUCT_DETAILS VALUES(3,5,1,3000);
INSERT INTO PRODUCT_DETAILS VALUES(4,2,3,2500);
INSERT INTO PRODUCT_DETAILS VALUES(5,4,1,1000);


INSERT INTO `ORDER` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `ORDER` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `ORDER` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `ORDER` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `ORDER` VALUES(30,3500,"2021-08-16",4,3);
  
  
INSERT INTO `RATING` VALUES(1,2,2,4);
INSERT INTO `RATING` VALUES(2,3,4,3);
INSERT INTO `RATING` VALUES(3,5,1,5);
INSERT INTO `RATING` VALUES(4,1,3,2);
INSERT INTO `RATING` VALUES(5,4,5,4);


-- 3) Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
Select CUS_GENDER, count(CUS_GENDER) from `order-directory`.order O inner join customer C on O.CUS_ID = C.CUS_ID where O.ORD_AMOUNT >= 3000 group by CUS_GENDER;

-- 4) Display all the orders along with the product name ordered by a customer having Customer_Id=2.
Select o.cus_id, pj.pro_name 
from `order-directory`.order o inner join (Select pd.prod_id, p.pro_id, p.pro_name from product_details pd inner join product p on pd.PRO_ID=p.PRO_ID) as pj 
on o.prod_id=pj.prod_id
where o.cus_id = 2;

Select o.*, p.pro_name from `order-directory`.order o, product p, product_details pd where o.cus_id = 2 and o.prod_id = pd.prod_id and p.pro_id = pd.PRO_ID;

-- 5) Display the Supplier details who can supply more than one product.
Select s.*, count(pd.prod_id) as num_of_prod 
from supplier s inner join product_details pd on pd.supp_id = s.supp_id 
group by s.supp_id 
having num_of_prod >= 2;

-- 6) Find the category of the product whose order amount is minimum.
Select c.cat_name, c.cat_id 
from category c inner join 
	(Select p.cat_id, opd.* from product p inner join 
		(Select pd.pro_id, om.* from product_details pd inner join 
			(Select o.PROD_ID, min(o.ORD_AMOUNT) from `order-directory`.order o) 
		as om on om.prod_id = pd.prod_id) 
	as opd on opd.PRO_ID = p.pro_id) 
as popd on c.cat_id = popd.cat_id;


-- 7) Display the Id and Name of the Product ordered after “2021-10-05”.
Select p.pro_id, p.pro_name 
from `order-directory`.order o inner join product_details pd on pd.PROD_ID = o.PROD_ID inner join product p on p.PRO_ID = pd.PRO_ID
where o.ORD_DATE > '2021-10-05';

-- 8) Print the top 3 supplier name and id and their rating on the basis of their rating along with the customer name who has given the rating.
Select s.supp_name, s.supp_id, r.rat_ratstars, c.cus_name
from supplier s inner join rating r on s.SUPP_ID = r.SUPP_ID inner join customer c on r.CUS_ID = c.CUS_ID
order by r.RAT_RATSTARS desc limit 3;

-- 9) Display customer name and gender whose names start or end with character 'A'.
Select cus_name, cus_gender from customer where cus_name like 'A%' or cus_name like '%A'; 

-- 10) Display the total order amount of the male customers.
Select sum(o.ord_amount) as total_amount from `order-directory`.order o inner join customer c on o.CUS_ID = c.CUS_ID and c.CUS_GENDER = 'M';

-- 11) Display all the Customers left outer join with the orders.
Select * from customer c left OUTER join `order-directory`.order o on c.cus_id = o.cus_id; 

-- 12) Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 
--     then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
call supplierRatings();


-- Stored procedure 
CREATE PROCEDURE `supplierRatings` ()
BEGIN
select supplier.supp_name, supplier.supp_id, rating.rat_ratstars,
case
when rating.rat_ratstars > 4 then 'Genuine'
when rating.rat_ratstars > 2 then 'Average'
else 'Not Ok'
end as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id

END