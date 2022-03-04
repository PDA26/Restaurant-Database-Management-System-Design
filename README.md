DAMG6210_Project
==

Topic
--
Restaurant Database Management System


Problem Statement
--
The existing system of the restaurant is maintained manually making it time consuming and tedious.<br>
-	All data is maintained manually, increasing the chances of error and complexity of maintenance. <br>
-	The same data is entered every day, which is a redundant process.<br>
-	No database available for the employees, customers, and the prime members.<br>
-	There is no system of reserving the table online.<br>
-	The food cannot be ordered online for delivery.<br>
-	The option of going contactless in the restaurant during covid was not available.<br>
-	Audit of inventory and transactions is difficult.<br>

Objectives
--
The objective is to digitize the restaurant system with the below mentioned features:
-	Online reservation of the table.
-	Basis the past choices a custom menu will be available to each customer along with the traditional menu. 
-	Free delivery of birthday cake for the prime members.
-	Contactless delivery of food.
-	Assignment of delivery boys for specific areas.
-	Online checkout at the table, ensuring no contact.

Proposed Solution for the Identified problems
--
>All data is maintained manually, increasing the chances of error and complexity of maintenance.
>>To overcome the said problem, a database management system has been created for the restaurant, where instead of maintaining the data manually, the data will be logged in its respective entity (such as customer, employees, orders, tables, menu …etc.) that will provide a structured data which can further be easily referred to, managed, and maintained. Moreover, different database DML functionalities, objects such as triggers, indexes, partitions, views, stored procedures, functions can be used which would not only fine tune the system but also play a vital role in maintaining the ETL process of database, hence making automating and processing of the data easier.

>The same data is entered every day, which is a redundant process.
>>Redundancy is being removed by the following design:
>>>Customer data need not be entered manually every time the customer is visiting the restaurant. All the relevant details will be present in the table customer, such as customer_id, customer_memberid, customer_lname, customer_fname etc.
>>>All the employee data will be maintained in the tables employee and attendant and it would be easy to keep track of all the employees.
>>>The reservations will be taken care of by the database ensuring no two reservations for the same table and at the same time overlap. 
>>>All the tables will be normalized ensuring the data is unique and consistent.

>No database available for the employees, customers, and the prime members.
>>Three different tables for employees, customers and prime members have been created. Each table, employee, customer and member have their unique ids, such as employee_id, customer_id and member_id respectively. These ids will help to determine each of the employee, customer, and member.

>There is no system of reserving the table online.
>>Reservation Entity is created in the database to reserve the table online, data in this table has reservation_id attribute as primary key (pk) to maintain uniqueness. The reservation table has the attribute customer_id and reservation_tableId (foreign key) which further helps to identify the table which has been reserved.
>>There is a reservation_timeIn and reservation_timeOut attribute associated with the reservation table and the attribute table_availability helps in identifying if a table has been booked for a specific time thus avoiding duplicate and multiple bookings. Every time a customer will attempt to book an already booked table, a trigger will be generated.

>The food cannot be ordered online for delivery.
>>The table deliverOrder has been created for storing orders for delivery. The key order_customerId identifies the customer which has placed the order, attribute order_zipcode is the primary key to the table area, which stores the data of the assigned delivery agents for respective zip codes, using the key, delivery_id.
>>The delivery _id is the primary key for the table deliver which has a relationship with the employee table as the delivery agent will also be an employee with the restaurant. 


>Assignment of delivery agents for specific areas.
>>The table area is created which will contain all the zip codes within a certain range. The key deliver_id in the area table is the primary key to the entity deliver. The deliver table has a relationship with the employee table, where the data of the delivery agent will be stored as the delivery agent is also the employee in the restaurant. 
>>The key deliver_availability, will store the information of the availability of the delivery agent. If the assigned delivery agent is not available, then the assignment will be allocated to the next delivery agent.


>The option of going contactless in the restaurant during covid was not available. 
>>The issue of going contactless is being resolved by the below design
>>>The option of food delivery will ensure contactless delivery of the food. If the customer checks the contactless option, then the same will be notified to the delivery agent.
>>>When a customer is seated in the restaurant there is an option of paying the bill without needing an attendant. The bill generated of the table is stored in the entity table, in the attribute table_bill. The customer can make the payment against the bill generated and the data payment_id, table_customerId, payment_time will be stored in the entity payment.

>Audit of inventory and transactions is difficult
>>With the creation of database auditing of the inventory and the transactions made is possible and easy to track
>>>The table payment keeps the records of all the payments made. The attribute payment_id identifies the payment, table_customerId stores the ID of the customer who made the payment and attributes payment_time and payment_mainValue stores the information about the date and time of the payment made and the total value of the payment. 
>>>The table inventory will keep the track of all the inventory present using the attributes inventory_name and inventory_quant. Whenever a dish is ordered, the database will calculate which and how many ingredients will be used and subtract the quantity from the inventory. This function can be realized by using the entity dishFormula.
>>>Weekly, monthly, and annual reports can be easily generated to identify different aspects related to sales and inventory. 

>Basis the past choices a custom menu will be available to each customer along with the traditional menu
>>Certain customers will be members which can be identified using the attribute member_id stored in the table member. Basis the past choices of the members a custom menu will be developed, using an algorithm, for the customers. The choices of the customer will be saved in the attribute member_flavour.

>Free delivery of birthday cake for the prime members.
>>The birthdays of each of the members will be stored in the attribute member_birth. A trigger will be generated on their birthday, ensuring free delivery of birthday cake to each of the members

User
--
1.Admin                Password: Nature@74876253<br>
2.MANAGER              Password: Admin123456789<br>
3.ATTENDANT            Password: Admin123456789<br>
4.DELIVERYAGENT        Password: Admin123456789<br>
5.CUSTOMER             Password: Admin123456789<br>
