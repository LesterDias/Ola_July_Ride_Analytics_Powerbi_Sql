DROP TABLE IF EXISTS bookings;

CREATE TABLE bookings (
    date TEXT,
    time TEXT,
    booking_id TEXT,
    booking_status TEXT,
    customer_id TEXT,
    vehicle_type TEXT,
    pickup_location TEXT,
    drop_location TEXT,
    v_tat TEXT,
    c_tat TEXT,
    canceled_rides_by_customer TEXT,
    canceled_rides_by_driver TEXT,
    incomplete_rides TEXT,
    incomplete_rides_reason TEXT,
    booking_value TEXT,
    payment_method TEXT,
    ride_distance TEXT,
    driver_ratings TEXT,
    customer_rating TEXT,
    vehicle_images TEXT
);


SELECT * FROM bookings;

SELECT COUNT(*) FROM bookings;
SELECT * FROM bookings LIMIT 5;



'''1. Retrieve all successful bookings:'''
Create View Successful_Bookings As
SELECT * FROM bookings
WHERE booking_status = 'Success';

SELECT * FROM Successful_Bookings;



'''2. Find the average ride distance for each vehicle type:'''
CREATE OR REPLACE VIEW Ride_Distance_For_Each_Vehicle AS
SELECT
    vehicle_type,
    ROUND(
        AVG(
            CASE
                WHEN ride_distance ~ '^[0-9]+(\.[0-9]+)?$'
                THEN ride_distance::NUMERIC
                ELSE NULL
            END
        ),
        2
    ) AS avg_distance
FROM bookings
WHERE vehicle_type <> 'Vehicle_Type'
GROUP BY vehicle_type;



SELECT * FROM Ride_Distance_For_Each_Vehicle;



'''3. Get the total number of cancelled rides by customers:'''
Create View Canceled_Rides_By_Customers AS
SELECT COUNT(*) FROM bookings
WHERE booking_status = 'Canceled by Customer';

SELECT * FROM Canceled_Rides_By_Customers;



'''4. List the top 5 customers who booked the highest number of rides:'''
Create View Top_5_Customers AS
SELECT customer_id, COUNT(booking_id) AS total_rides
FROM bookings
GROUP BY customer_id
ORDER BY total_rides DESC LIMIT 5;


SELECT * FROM Top_5_Customers;



'''5. Get the number of rides cancelled by drivers due to personal and car-related issues:'''
Create View Canceled_By_Drivers_P_C_Issues AS
SELECT COUNT(*)
FROM  bookings
WHERE canceled_rides_by_driver = 'Personal & Car related issue';

SELECT * FROM Canceled_By_Drivers_P_C_Issues



'''6. Find the maximum and minimum driver ratings for Prime Sedan bookings:'''
Create View Max_Min_Driver_Rating as
SELECT MAX(driver_ratings) AS max_rating,
MIN(driver_ratings) AS min_rating
FROM bookings WHERE vehicle_type = 'Prime Sedan'

SELECT * FROM Max_Min_Driver_Rating



'''7. Retrieve all rides where payment was made using UPI:'''
Create View UPI_Payments as
SELECT * FROM bookings
WHERE payment_method = 'UPI'

SELECT * FROM UPI_Payments;



'''8. Find the average customer rating per vehicle type:'''
CREATE OR REPLACE VIEW AVG_Cust_Rating AS
SELECT
    vehicle_type,
    ROUND(
        AVG(
            CASE
                WHEN customer_rating ~ '^[0-9]+(\.[0-9]+)?$'
                THEN customer_rating::NUMERIC
                ELSE NULL
            END
        ),
        2
    ) AS avg_customer_rating
FROM bookings
WHERE vehicle_type <> 'Vehicle_Type'
GROUP BY vehicle_type;

SELECT * FROM AVG_Cust_Rating


'''9. Calculate the total booking value of rides completed successfully:'''
Create View Total_Successful_Ride_Value as
SELECT
    SUM(
        CASE
            WHEN booking_value ~ '^[0-9]+(\.[0-9]+)?$'
            THEN booking_value::NUMERIC
            ELSE NULL
        END
    ) AS total_successful_value
FROM bookings
WHERE booking_status = 'Success'
  AND booking_value <> 'Booking_Value';

SELECT * FROM Total_Successful_Ride_Value
  


'''10. List all incomplete rides along with the reason:'''
Create View Incomplete_Rides_Reason as
SELECT booking_id, incomplete_rides_reason
FROM bookings
WHERE incomplete_rides = 'Yes'

SELECT * FROM Incomplete_Rides_Reason


