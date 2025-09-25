/* 1. Create a table called employees with the following structure
 emp_id (integer, should not be NULL and should be a primary key)
 emp_name (text, should not be NULL)
 age (integer, should have a check constraint to ensure the age is at least 18)
 email (text, should be unique for each employee)
 salary (decimal, with a default value of 30,000).
 Write the SQL query to create the above table with all constraints. */
 
 CREATE TABLE employees (
    emp_id INT PRIMARY KEY NOT NULL,
    emp_name TEXT NOT NULL,
    age INT CHECK (age >= 18),
    email TEXT UNIQUE,
    salary DECIMAL(10,2) DEFAULT 30000
);

--

 /* 2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints */
 
 -- Constraints in a database are rules applied to table columns that ensure the accuracy, reliability, and consistency of the data stored. They act like safeguards, preventing invalid or inconsistent data from being entered, which helps maintain **data integrity**. --

### **Purpose of Constraints**

1. **Prevent invalid data entry**
   Example: An age column with a constraint that requires values to be ≥ 18 ensures no underage employee is entered.

2. **Enforce uniqueness**
   Example: An email column with a `UNIQUE` constraint ensures no two employees share the same email address.

3. **Maintain consistency across tables**
   Example: A foreign key ensures that an order cannot exist without a valid customer in the customer table.

4. **Provide default values**
   Example: If salary isn’t provided, a `DEFAULT` constraint can automatically assign a base salary.

---

### **Common Types of Constraints**

1. **PRIMARY KEY**

   * Ensures each row in a table is unique and identifiable.
   * Example: `emp_id INT PRIMARY KEY` ensures each employee has a unique ID.

2. **FOREIGN KEY**

   * Maintains relationships between tables by referencing a key in another table.
   * Example: `dept_id INT REFERENCES departments(dept_id)` ensures employees belong to valid departments.

3. **NOT NULL**

   * Prevents missing or undefined values.
   * Example: `emp_name TEXT NOT NULL` ensures every employee has a name.

4. **UNIQUE**

   * Ensures all values in a column are distinct.
   * Example: `email TEXT UNIQUE` ensures no duplicate emails.

5. **CHECK**

   * Validates data based on a condition.
   * Example: `age INT CHECK (age >= 18)` ensures only valid ages are stored.

6. **DEFAULT**

   * Assigns a value automatically if none is provided.
   * Example: `salary DECIMAL(10,2) DEFAULT 30000` gives new employees a base salary.

---

/* 3.Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer. */

Good question — let’s break it down clearly:

---

### **Why apply the NOT NULL constraint?**

The `NOT NULL` constraint ensures that a column must always have a value.

* It prevents missing or undefined data.
* It’s useful for attributes that are essential for every record.

**Example:**

* In an `employees` table, `emp_name NOT NULL` ensures that every employee has a name.
* Without it, you could accidentally insert a row with no name, which doesn’t make sense for real-world data.

---

### **Can a primary key contain NULL values?**

**No, a primary key cannot contain NULL values.**

Here’s why:

1. **Uniqueness requirement**:
   A primary key must uniquely identify each row. If `NULL` were allowed, two rows with `NULL` in the primary key column would violate this uniqueness, because `NULL` is treated as "unknown" and multiple "unknowns" can’t guarantee uniqueness.

2. **NOT NULL is implied**:
   When you define a column as a primary key, the database automatically applies `NOT NULL`.

   * Example:

     
     emp_id INT PRIMARY KEY
     is equivalent to
     emp_id INT NOT NULL UNIQUE
     
---

 /* 4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint. */
 
 Got it — let’s go step by step.

When working with **existing tables**, you use the `ALTER TABLE` command to add or remove constraints.

---

## **1. Adding a Constraint**

You use `ALTER TABLE ... ADD CONSTRAINT` to add a new rule.

### Example: Add a unique constraint on the `email` column


ALTER TABLE employees
ADD CONSTRAINT unique_email UNIQUE (email);


Here:

* `unique_email` is the **name of the constraint** (you can choose any descriptive name).
* This ensures no two employees can have the same email.

### Another example: Add a check constraint on salary


ALTER TABLE employees
ADD CONSTRAINT check_salary CHECK (salary >= 30000);


---

## **2. Removing a Constraint**

You use `ALTER TABLE ... DROP CONSTRAINT` (syntax depends a little on the database system).

### Example: Remove the unique constraint from the `email` column


ALTER TABLE employees
DROP CONSTRAINT unique_email;

Now the `email` column can have duplicates.

---

## **Important Notes**

* In **MySQL**, the syntax is slightly different:

  * To drop a unique constraint or primary key, you often need to know the **index name**. For example:


    ALTER TABLE employees DROP INDEX unique_email;

* In **PostgreSQL / Oracle / SQL Server**, the syntax with `DROP CONSTRAINT` works directly.

---

/* 5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. Provide an example of an error message that might occur when violating a constraint. */

## **Consequences of Violating Constraints**

When you try to insert, update, or delete data that breaks a constraint, the database **rejects the operation**. This prevents invalid or inconsistent data from being stored.

Here’s what happens for each type of violation:

1. **NOT NULL violation**

   * If you try to insert a row without a required value, the database refuses.
   * Example: Inserting an employee without a name when `emp_name NOT NULL` is defined.

2. **UNIQUE violation**

   * If you insert or update a column with a value that already exists, the database blocks it.
   * Example: Two employees with the same email when `email UNIQUE` is enforced.

3. **CHECK violation**

   * If data doesn’t meet the condition, the operation fails.
   * Example: Inserting an age of 15 when `CHECK (age >= 18)` exists.

4. **PRIMARY KEY violation**

   * Inserting a duplicate or `NULL` value in a primary key column isn’t allowed.
   * Example: Two rows with the same `emp_id`.

5. **FOREIGN KEY violation**

   * If a record references another table, but that record doesn’t exist, the insert/update fails.
   * Example: Assigning an employee to a `dept_id` that doesn’t exist in the `departments` table.
   * Similarly, deleting a parent row that still has child rows referencing it will fail unless `ON DELETE CASCADE` is set.

## **Example of Error Messages**

Error messages vary by database system, but here are some common ones:

* **NOT NULL violation (PostgreSQL example):**

  ```
  ERROR:  null value in column "emp_name" violates not-null constraint
  ```

* **UNIQUE violation (MySQL example):**

  ```
  ERROR 1062 (23000): Duplicate entry 'john.doe@email.com' for key 'employees.email'
  ```

* **CHECK violation (PostgreSQL example):**

  ```
  ERROR:  new row for relation "employees" violates check constraint "employees_age_check"
  ```

* **FOREIGN KEY violation (SQL Server example):**

  ```
  The INSERT statement conflicted with the FOREIGN KEY constraint "fk_employee_department".
  The conflict occurred in database "CompanyDB", table "departments", column 'dept_id'.
  ```

---

 /* 6. You created a products table without constraints as follows: 
 CREATE TABLE products (
 product_id INT,
 product_name VARCHAR(50),
 price DECIMAL(10, 2)); 
 
 Now, you realise that
 The product_id should be a primary key
 The price should have a default value of 50.00 */
 
### **Step 1: Make `product_id` a Primary Key**


ALTER TABLE products
ADD CONSTRAINT pk_product PRIMARY KEY (product_id);

---

### **Step 2: Add Default Value for `price`**

ALTER TABLE products
ALTER COLUMN price SET DEFAULT 50.00;

* This sets the default price to `50.00` if none is provided during insert.

---

 -- 7. You have two tables: Students and Classes. Write a query to fetch the student_name and class_name for each student using an INNER JOIN --
 
SELECT
    s.student_name,
    c.class_name
FROM
    students s
INNER JOIN
    classes c ON s.class_id = c.class_id;
    
--  8. Consider the following three tables: Orders, Customer and Products.  Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are listed even if they are not associated with an order --

CREATE Table Orders(
	order_id INT PRIMARY KEY,
    order_date DATE ,
    customer_id INT UNIQUE
);
INSERT INTO Orders (order_id, order_date, customer_id)
VALUES
('1', '2024-01-01', '101'),
('2', '2024-01-03', '102');

CREATE Table Customers(
	customer_id INT PRIMARY KEY,
    customer_name CHAR(20) UNIQUE
);
INSERT INTO Customers (customer_id, customer_name)
VALUES
('101', 'Alice'),
('102', 'Bob');

CREATE Table Products(
	product_id INT PRIMARY KEY,
    product_name CHAR(20) UNIQUE,
    order_id CHAR(10) NOT NULL
);
INSERT INTO Products (product_id, product_name, order_id)
VALUES
('1', 'Laptop', '1'),
('2', 'Phone', 'NULL');

SELECT 
    o.order_id,
    c.customer_name,
    p.product_name
FROM 
    Orders o
LEFT JOIN Products p ON o.order_id = p.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id

UNION

SELECT 
    p.order_id,
    NULL AS customer_name,
    p.product_name
FROM 
    Products p
LEFT JOIN Orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

/* 9.Given are the two tables- sales and products. Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function. */

CREATE Table Sales(
	sale_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    amount FLOAT
);
INSERT INTO Sales (sale_id, product_id, amount)
VALUES
('1', '101', '500'),
('2', '102', '300'),
('3', '101', 700);

CREATE Table Products (
	product_id INT PRIMARY KEY,
    product_name CHAR(20) UNIQUE
);
INSERT INTO Products (product_id, product_name)
VALUES
('101', 'Laptop'),
('102', 'Phone');

SELECT 
    p.product_name,
    SUM(s.amount) AS total_sales
FROM 
    Sales s
INNER JOIN Products p ON s.product_id = p.product_id
GROUP BY 
    p.product_name;
 
/* 10. You are given three tables: orders, customers, and order_details. Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer using an INNER JOIN between all three tables. */

CREATE Table Orders(
	order_id INT PRIMARY KEY,
    order_date DATE ,
    customer_id INT UNIQUE
);
INSERT INTO Orders (order_id, order_date, customer_id)
VALUES
('1', '2024-01-02', '1'),
('2', '2024-01-05', '2');

CREATE Table Customers(
	customer_id INT PRIMARY KEY,
    customer_name CHAR(20) UNIQUE
);
INSERT INTO Customers (customer_id, customer_name)
VALUES
('1', 'Alice'),
('2', 'Bob');

CREATE Table Order_Details(
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT
);
INSERT INTO Order_Details (order_id, product_id, quantity)
VALUES
('1', '101', '2'),
('1', '102', '1'),
('2', '101', '3');

SELECT 
    o.order_id,
    c.customer_name,
    od.quantity
FROM 
    Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id;


-- SQL Commands --

/* Assignment Created by Sugata Mondal */

/* 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences */

Ans:- **Maven Movies Database Keys

The Maven Movies database uses a combination of primary and foreign keys to define relationships between its tables and maintain data integrity.

**Primary Keys (PK)**

A primary key is a column or a set of columns that uniquely identifies each row in a table. Its like a unique ID card for every record. It must contain unique values and cannot be NULL.

- actor table: actor_id
- address table: address_id
- category table: category_id
- city table: city_id

**Foreign Keys (FK)**

A foreign key is a column or a set of columns in one table that references the primary key of another table. Its purpose is to link tables and enforce referential integrity 🔗. This ensures that the data in the foreign key column always corresponds to a valid record in the primary key table.
- address table: city_id (refers to city.city_id)
- city table: country_id (refers to country.country_id)
- customer table: store_id (refers to store.store_id), address_id (refers to address.address_id)
- film table: language_id (refers to language.language_id), original_language_id (refers to language.language_id)

/*2. List all details of actors*/

SELECT * FROM actor;

/*3. List all customer information from DB*/

SELECT * FROM customer;

/*4. List different countries*/

SELECT DISTINCT country FROM country;

/*5 (S). Display all active customers*/

SELECT * FROM customer WHERE active = 1;

/*6. List rental IDs for customer with ID 1*/

SELECT rental_id FROM rental WHERE customer_id = 1;

/*7. Films whose rental duration > 5*/

SELECT * FROM film WHERE rental_duration > 5;

/*8. Count films with replacement cost > 15 and < 20*/

SELECT COUNT(*) FROM film WHERE replacement_cost > 15 AND replacement_cost < 20;

/*9. Count unique first names of actors*/

SELECT COUNT(DISTINCT first_name) FROM actor;

/*10. First 10 customer records*/

SELECT * FROM customer LIMIT 10;

/*11. First 3 customers whose first name starts with 'A'*/

SELECT * FROM customer WHERE first_name LIKE 'A%' LIMIT 3;

/*12. Names of first 5 movies rated 'R'*/

SELECT title FROM film WHERE rating = 'R' LIMIT 5;

/*13. Customers whose first name starts with 'A'*/

SELECT * FROM customer WHERE first_name LIKE 'A%';

/*14. Customers whose first name ends with 'a'*/

SELECT * FROM customer WHERE first_name LIKE '%a';

/*15. First 4 cities starting and ending with 'a'*/

SELECT city FROM city WHERE city LIKE 'a%a' LIMIT 4;

/*16. Customers whose first name has 'NI' anywhere*/

SELECT * FROM customer WHERE first_name LIKE '%NI%';

/*17. Customers with 'r' in 2nd position*/

SELECT * FROM customer WHERE first_name LIKE '_r%';

/*18. Customers whose name starts with 'a' and length ≥ 5*/

SELECT * FROM customer WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;

/*19. Customers whose name starts with 'a' and ends with 'o'*/

SELECT * FROM customer WHERE first_name LIKE 'a%o';

/*20. Films with rating PG or PG-13 (IN operator)*/

SELECT * FROM film WHERE rating IN ('PG', 'PG-13');

/*21. Films with length between 50 and 100*/

SELECT * FROM film WHERE length BETWEEN 50 AND 100;

/*22. Top 50 actors (LIMIT)*/

SELECT * FROM actor LIMIT 50;

/*23. Distinct film IDs from inventory*/

SELECT DISTINCT film_id FROM inventory;

---

-- Functions --

Here you go — full questions with short SQL answers:

---

/*Question 1:
Retrieve the total number of rentals made in the Sakila database.*/

SELECT COUNT(*) AS total_rentals FROM rental;

/*Question 2:
Find the average rental duration (in days) of movies rented from the Sakila database.*/

SELECT AVG(rental_duration) AS avg_duration FROM film;

/*Question 3:*
Display the first name and last name of customers in uppercase.*/

SELECT UPPER(first_name), UPPER(last_name) FROM customer;

/*Question 4:
Extract the month from the rental date and display it alongside the rental ID.*/

SELECT rental_id, MONTH(rental_date) AS rental_month FROM rental;

/*Question 5:**
Retrieve the count of rentals for each customer (display customer ID and the count of rentals).*/

SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

/*Question 6:**
Find the total revenue generated by each store.*/

SELECT store_id, SUM(amount) AS total_revenue
FROM payment
GROUP BY store_id;

/*Question 7:**
Determine the total number of rentals for each category of movies.*/

SELECT c.name AS category, COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

/*Question 8:
Find the average rental rate of movies in each language.*/

SELECT l.name AS language, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

 -- JOINS --
 
/*Question 9:
Display the title of the movie, customer’s first name, and last name who rented it.*/

SELECT f.title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

/*Question 10:
Retrieve the names of all actors who have appeared in the film "Gone with the Wind."*/

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

/*Question 11:
Retrieve the customer names along with the total amount they’ve spent on rentals.*/

SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

/* Assignment Created by Sugata Mondal */

/*Question 12:**
List the titles of movies rented by each customer in a particular city (e.g., 'London').*/

SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY c.customer_id, f.title;

-- Advanced Joins and GROUP BY --

/*Question 13:
Display the top 5 rented movies along with the number of times they’ve been rented.*/

SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id
ORDER BY rental_count DESC
LIMIT 5;

/*Question 14:**
Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).*/

SELECT r.customer_id, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE i.store_id IN (1, 2)
GROUP BY r.customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

-- Windows Function --

/*1. Rank the customers based on the total amount they’ve spent on rentals */

SELECT c.customer_id, c.first_name, c.last_name,
       SUM(p.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS rank
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

/*2. Calculate the cumulative revenue generated by each film over time. */

SELECT f.film_id, f.title, r.rental_date, SUM(p.amount) 
       OVER (PARTITION BY f.film_id ORDER BY r.rental_date) AS cumulative_revenue
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN payment p ON r.rental_id = p.rental_id;

/*3. Determine the average rental duration for each film. */

SELECT f.film_id, f.title, AVG(r.rental_duration) AS avg_rental_duration
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id;

/*4. Identify the top 3 films in each category based on rental counts. */

SELECT category_id, title, rental_count
FROM (
    SELECT c.category_id, f.title, COUNT(r.rental_id) AS rental_count,
           ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY COUNT(r.rental_id) DESC) AS rn
    FROM film f
    JOIN film_category c ON f.film_id = c.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.category_id, f.film_id
) AS sub
WHERE rn <= 3;

/*5. Calculate the difference in rental counts between each customer’s total rentals and the average rentals across all customers. */

WITH customer_rentals AS (
    SELECT customer_id, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY customer_id
), avg_rentals AS (
    SELECT AVG(total_rentals) AS avg_rentals FROM customer_rentals
)
SELECT cr.customer_id, cr.total_rentals, cr.total_rentals - ar.avg_rentals AS difference
FROM customer_rentals cr
CROSS JOIN avg_rentals ar;

/*6. Find the monthly revenue trend for the entire rental store */

SELECT DATE_FORMAT(r.rental_date, '%Y-%m') AS month, SUM(p.amount) AS monthly_revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY month
ORDER BY month;

/* 7. Identify the customers whose total spending falls within the top 20% of all customers. */

SELECT customer_id, first_name, last_name, total_spent
FROM (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent,
           NTILE(5) OVER (ORDER BY SUM(p.amount) DESC) AS percentile_rank
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
) AS ranked
WHERE percentile_rank = 1;

/* 8. Calculate the running total of rentals per category, ordered by rental count. */

SELECT category_id, title, COUNT(r.rental_id) AS rentals,
       SUM(COUNT(r.rental_id)) OVER (PARTITION BY category_id ORDER BY COUNT(r.rental_id)) AS running_total
FROM film f
JOIN film_category c ON f.film_id = c.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY category_id, title;

/*9. Find the films rented less than the average rental count for their respective categories. */

WITH category_avg AS (
    SELECT c.category_id, AVG(rental_count) AS avg_rentals
    FROM (
        SELECT f.film_id, c.category_id, COUNT(r.rental_id) AS rental_count
        FROM film f
        JOIN film_category c ON f.film_id = c.film_id
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY f.film_id, c.category_id
    ) AS sub
    GROUP BY c.category_id
)
SELECT f.title, c.category_id, COUNT(r.rental_id) AS rentals
FROM film f
JOIN film_category c ON f.film_id = c.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, c.category_id
HAVING COUNT(r.rental_id) < (SELECT avg_rentals FROM category_avg WHERE category_id = c.category_id);

/* 10.Identify the top 5 months with the highest revenue and display the revenue generated in each month */

	SELECT month, monthly_revenue
FROM (
    SELECT DATE_FORMAT(r.rental_date, '%Y-%m') AS month, SUM(p.amount) AS monthly_revenue
    FROM rental r
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY month
) AS monthly
ORDER BY monthly_revenue DESC
LIMIT 5;

-- Normalisation & CTE --

### **1. First Normal Form (1NF)**
**Question:** Identify a table in the Sakila database that violates 1NF and explain how to normalize it.

**Example Table:** Imagine a `customer` table that has a column `phone_numbers` storing multiple numbers separated by commas.

**Violation:**

* 1NF requires atomic (indivisible) values. Storing multiple phone numbers in one column violates this.

**Normalization to 1NF:**

* Split the `phone_numbers` column into a separate table:

```text
Customer_Phone
-----------------------
customer_id | phone_number
```

* Now each row stores only **one phone number per customer**, achieving 1NF.


### **2. Second Normal Form (2NF)**
**Question:** Determine whether a table is in 2NF and how to normalize it if it violates 2NF.

**Example Table:** `film_actor`

* Columns: `actor_id`, `film_id`, `actor_first_name`, `actor_last_name`

**Check for 2NF:**

* 2NF requires that every non-key column depends on the **whole primary key**.
* `film_actor` has a **composite primary key** (`actor_id`, `film_id`).
* Columns `actor_first_name` and `actor_last_name` depend **only on `actor_id`**, not on the combination of `actor_id` and `film_id`.

**Violation:** Not in 2NF.

**Normalization:**

* Move actor-specific columns to `actor` table:

```text
film_actor
-------------
actor_id | film_id

actor
-------------
actor_id | first_name | last_name
```

Now `film_actor` contains only foreign keys, satisfying 2NF.


### **3. Third Normal Form (3NF)**
**Question:** Identify a table that violates 3NF.

**Example Table:** `payment` with columns:
`payment_id`, `customer_id`, `rental_id`, `staff_id`, `store_id`

**Transitive Dependency:**

* `store_id` depends on `staff_id`, not directly on `payment_id`.

**Violation:** Not in 3NF because non-key attribute (`store_id`) depends on another non-key attribute (`staff_id`).

**Normalization:**

* Remove `store_id` from `payment` and get it through the `staff` table:

```text
payment
-------------
payment_id | customer_id | rental_id | staff_id

staff
-------------
staff_id | store_id
```

Now there are no transitive dependencies, achieving 3NF.

 /* 4. Normalization Process:
               a. Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF. */

**Unnormalized Form:**

```
actor_id | film_id | actor_first_name | actor_last_name
```

**Step 1 — 1NF:**

* Ensure atomic values (already atomic here).

**Step 2 — 2NF:**

* Remove partial dependency (`actor_first_name` and `actor_last_name` depend only on `actor_id`).
* Result:

```text
film_actor
-------------
actor_id | film_id

actor
-------------
actor_id | first_name | last_name
```

**Step 3 — 3NF:**

* No transitive dependencies exist, so 3NF is achieved.

/*5. CTE Basics
**Question:** Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in.*/

WITH actor_films AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT first_name, last_name, film_count
FROM actor_films
ORDER BY film_count DESC;

/* Assignment Created by Sugata Mondal */

/*Question 5: CTE Basics**
Retrieve the distinct list of actor names and the number of films they have acted in:*/

WITH actor_films AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT first_name, last_name, film_count
FROM actor_films
ORDER BY film_count DESC;

/*Question 6: CTE with Joins**
Combine `film` and `language` to display film title, language name, and rental rate:*/

WITH film_info AS (
    SELECT f.film_id, f.title, l.name AS language, f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT title, language, rental_rate
FROM film_info;

/*Question 7: CTE for Aggregation**
Find total revenue per customer (sum of payments):*/

WITH customer_revenue AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, cr.total_spent
FROM customer c
JOIN customer_revenue cr ON c.customer_id = cr.customer_id
ORDER BY cr.total_spent DESC;

/*Question 8: CTE with Window Functions
Rank films based on rental duration:*/

WITH film_rank AS (
    SELECT film_id, title, rental_duration,
           RANK() OVER (ORDER BY rental_duration DESC) AS rank
    FROM film
)
SELECT title, rental_duration, rank
FROM film_rank
ORDER BY rank;

/*Question 9: CTE and Filtering**
List customers with more than 2 rentals, then join with customer table:*/

WITH frequent_customers AS (
    SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > 2
)
SELECT c.customer_id, c.first_name, c.last_name, fc.rental_count
FROM frequent_customers fc
JOIN customer c ON fc.customer_id = c.customer_id;

/*Question 10: CTE for Date Calculations
Find the total number of rentals made each month:*/

WITH monthly_rentals AS (
    SELECT DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
           COUNT(*) AS total_rentals
    FROM rental
    GROUP BY rental_month
)
SELECT rental_month, total_rentals
FROM monthly_rentals
ORDER BY rental_month;

/*Question 11: CTE and Self-Join**
Generate pairs of actors who appeared in the same film:*/

WITH actor_pairs AS (
    SELECT fa1.film_id, fa1.actor_id AS actor1_id, fa2.actor_id AS actor2_id
    FROM film_actor fa1
    JOIN film_actor fa2 
      ON fa1.film_id = fa2.film_id
     AND fa1.actor_id < fa2.actor_id
)
SELECT ap.film_id, a1.first_name AS actor1_first, a1.last_name AS actor1_last,
       a2.first_name AS actor2_first, a2.last_name AS actor2_last
FROM actor_pairs ap
JOIN actor a1 ON ap.actor1_id = a1.actor_id
JOIN actor a2 ON ap.actor2_id = a2.actor_id
ORDER BY ap.film_id;

/*Question 12: CTE for Recursive Search**
Find all employees who report (directly or indirectly) to a specific manager:*/

WITH RECURSIVE employee_hierarchy AS (
    SELECT staff_id, first_name, last_name, reports_to
    FROM staff
    WHERE reports_to = 1  -- replace 1 with the manager_id you are searching for
    UNION ALL
    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
    FROM staff s
    JOIN employee_hierarchy eh ON s.reports_to = eh.staff_id
)
SELECT staff_id, first_name, last_name, reports_to
FROM employee_hierarchy;









