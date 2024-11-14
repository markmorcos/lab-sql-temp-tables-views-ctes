-- 1.
CREATE OR REPLACE VIEW rental_information_per_customer AS
SELECT c.customer_id, CONCAT(first_name, " ", last_name) AS customer_name, email AS customer_email, COUNT(*) AS rental_count
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

-- 2.
DROP TABLE total_paid_per_customer;
CREATE TEMPORARY TABLE total_paid_per_customer AS
SELECT p.customer_id, SUM(amount) AS total_paid FROM rental_information_per_customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY customer_id;

-- 3.
WITH cte_rental_and_payment_summary AS (
	SELECT customer_name, customer_email, rental_count, total_paid FROM rental_information_per_customer r
    JOIN total_paid_per_customer p ON p.customer_id = r.customer_id
)
SELECT customer_name, customer_email, rental_count, total_paid, total_paid / rental_count AS average_payment_per_rental FROM cte_rental_and_payment_summary;
