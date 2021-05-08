
use mydb;
select * from bank_account_details;
select * from bank_account_relationship_details;
select * from bank_account_transaction;
select * from bank_branch_pl;
select * from bank_customer;
select * from bank_customer_export;
select * from bank_customer_messages;
select * from bank_interest_rate;
select * from bank_inventory_pricing;
select * from department_details;
select * from employee_details;



#Q1. Print product, price, sum of quantity more than 5 sold during all three months.  
select product,price,sum(quantity) from bank_inventory_pricing group by product having sum(quantity) > 5;

#Q2.Print product, quantity , month and count of records for which estimated_sale_price is less than purchase_cost
 select product,quantity,month ,count(product) from bank_inventory_pricing where estimated_sale_price < purchase_cost 
 and estimated_sale_price is not null and purchase_cost is not null ;
 
 select product,quantity,month ,count(*) from bank_inventory_pricing where estimated_sale_price < purchase_cost 
 group by product;
#Q3. Extarct the 3rd highest value of column Estimated_sale_price from bank_inventory_pricing dataset
select * from bank_inventory_pricing order by estimated_sale_price  desc limit 2,1;

#Q4. Count all duplicate values of column Product from table bank_inventory_pricing
select product,count(product) as duplicate from bank_inventory_pricing  group by product having count(product)>1;

#Q5. Create a view 'bank_details' for the product 'PayPoints' and Quantity is greater than 2 
create view bank_details as
select *  from bank_inventory_pricing where product='PayPoints' and quantity >2;

#Q6 Update view bank_details1 and add new record in bank_details1.
-- --example(Producct=PayPoints, Quantity=3, Price=410.67)
create view bank_details1 as
select *  from bank_inventory_pricing ;

insert into bank_details1 (product,Quantity,price) values('Paypoints',3,410.67);
#Q7.Real Profit = revenue - cost  Find for which products, branch level real profit is more than the estimated_profit in Bank_branch_PL.
select branch,product,(revenue-cost) as real_profit from bank_branch_pl
where (revenue-cost)>estimated_profit ;

#Q8.Find the least calculated profit earned during all 3 periods
select min(revenue-cost) from bank_branch_pl where revenue-cost >=0 ;
#Q9. In Bank_Inventory_pricing, 
-- a) convert Quantity data type from numeric to character 
alter table Bank_Inventory_pricing modify Quantity varchar(10);

-- b) Add then, add zeros before the Quantity field.  
---- in complete question
#Q10. Write a MySQL Query to print first_name , last_name of the titanic_ds whose first_name Contains ‘U’
select first_name , last_name from employee_details where first_name like '%U%';
#Q11.Reduce 30% of the cost for all the products and print the products whose  calculated profit at branch is exceeding estimated_profit .
update  bank_branch_pl set cost=cost-cost*0.3 ;
select * from bank_branch_pl where (revenue-cost) > estimated_profit;
#Q12.Write a MySQL query to print the observations from the Bank_Inventory_pricing table excluding the values “BusiCard” And “SuperSave” from the column Product
select * from Bank_Inventory_pricing where product not in ('BusiCard','SuperSave');
#Q13. Extract all the columns from Bank_Inventory_pricing where price between 220 and 300
select * from Bank_Inventory_pricing where price between 220 and 300; 

#Q14. Display all the non duplicate fields in the Product form Bank_Inventory_pricing table and display first 5 records.
select * from Bank_Inventory_pricing;
select product,count(product) as duplicate from bank_inventory_pricing  group by product having count(product)>1;

select  product as not_duplicate from Bank_Inventory_pricing group by product having count(product)=1 limit 5;
#Q15.Update price column of Bank_Inventory_pricing with an increase of 15%  when the quantity is more than 3.

update Bank_Inventory_pricing set price=price+price*0.15 where quantity > 3;
#Q16. Show Round off values of the price without displaying decimal scale from Bank_Inventory_pricing
select round(price) from Bank_Inventory_pricing;
#Q17.Increase the length of Product size by 30 characters from Bank_Inventory_pricing.
alter table Bank_Inventory_pricing modify product varchar(30);
#Q18. Add '100' in column price where quantity is greater than 3 and dsiplay that column as 'new_price' 
select quantity,price+100 as new_price from bank_inventory_pricing where quantity >3 ;
#Q19. Display all saving account holders have “Add-on Credit Cards" and “Credit cards" 
select * from  bank_account_details where account_type in ('Add-on Credit Card','Credit Card');
#Q20.
# a) Display records of All Accounts , their Account_types, the transaction amount.
# b) Along with first step, Display other columns with corresponding linking account number, account types 
# c) After retrieving all records of accounts and their linked accounts, display the  transaction amount of accounts appeared  in another column.

-- a)
select bad.Account_Number,Account_type,Transaction_amount from bank_account_details bad join bank_account_transaction bat using (Account_Number) order by Account_Number;
-- b)
select bad.Account_Number,Account_type,Transaction_amount,bad.* from bank_account_details bad join bank_account_transaction bat using (Account_Number) order by Account_Number;
-- c)
-- same as first
#Q21.Display all type of “Credit cards”  accounts including linked “Add-on Credit Cards" 


select * from bank_account_relationship_details where account_type='Credit Card' or account_number in
 (select account_number from bank_account_relationship_details where account_type='Add-on Credit Card' and 
 Linking_Account_Number is not NULL) ;
# type accounts with their respective aggregate sum of transaction amount. 
select Account_type,sum(Transaction_amount) from bank_account_transaction join bank_account_details using(Account_Number)
group by Account_type;
# Ref: Check linking relationship in bank_transaction_relationship_details.
# Check transaction_amount in bank_account_transaction. 




#Q22. Compare the aggregate transaction amount of current month versus aggregate transaction with previous months.
# Display account_number, transaction_amount , 
-- sum of current month transaction amount ,
-- current month transaction date , 
-- sum of previous month transaction amount , 
-- previous month transaction date.
select account_number, transaction_amount , sum(Transaction_amount) as sum ,Transaction_Date from bank_account_transaction where  extract( month from Transaction_Date) =extract(month from sysdate())
or extract( month from Transaction_Date) =extract(month from sysdate())-1
group by extract( month from Transaction_Date);

#Q23.Display individual accounts absolute transaction of every next  month is greater than the previous months .

#Q24. Find the no. of transactions of credit cards including add-on Credit Cards
  select count(*) from   bank_account_transaction join bank_account_details using (account_number) where 
  Account_type in ('Add-on Credit Card','SAVINGS');
#Q25.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where department_name is Contracting (Note
#Department_id of employee_details table must be other than the list within IN operator.
    select employee_details.EMPLOYEE_ID,FIRST_NAME,LAST_NAME,PHONE_NUMBER,SALARY,JOB_ID from employee_details join department_details using (DEPARTMENT_ID)
    where DEPARTMENT_NAME='Contracting';
#Q26. Display savings accounts and its corresponding Recurring deposits transactions are more than 4 times.
select * from bank_account_transaction;

#Q27. From employee_details fetch only employee_id, ,first_name, last_name , phone_number ,email, job_id where job_id should not be IT_PROG.
select * from employee_details;
select EMPLOYEE_ID,FIRST_NAME,LAST_NAME,PHONE_NUMBER,EMAIL from employee_details where JOB_ID <>'IT_PROG';
#Q29.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where manager_id is '60' (Note
#Department_id of employee_details table must be other than the list within IN operator.
select EMPLOYEE_ID,FIRST_NAME,LAST_NAME,PHONE_NUMBER,EMAIL from employee_details where MANAGER_ID =60;


#Q30.Create a new table as emp_dept and insert the result obtained after performing inner join on the two tables employee_details and department_details.
create table emp_dept as
select ed.EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,ed.MANAGER_ID,dd.DEPARTMENT_NAME,LOCATION_ID
from employee_details ed join department_details dd using (DEPARTMENT_ID);

