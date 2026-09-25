CREATE TABLE CHURN_DATA (
	CUSTOMERID INT PRIMARY KEY,
	CHURN INT,
	TENURE INT,
	PREFERREDLOGINDEVICE VARCHAR(40),
	CITYTIER INT,
	WAREHOUSETOHOME INT,
	PREFERREDPAYMENTMODE VARCHAR(50),
	GENDER VARCHAR(20),
	HOURSPENDONAPP INT,
	NUMBEROFDEVICEREGISTERED INT,
	PREFEREDORDERCAT VARCHAR(70),
	SATISFACTIONSCORE INT,
	MARITALSTATUS VARCHAR(15),
	NUMBEROFADDRESS INT,
	COMPLAIN INT,
	ORDERAMOUNTHIKEFROMLASTYEAR INT,
	COUPONUSED INT,
	ORDERCOUNT INT,
	DAYSINCELASTORDER INT,
	CASHBACKAMOUNT INT
)
SELECT
	*
FROM
	CHURN_DATA;

1 ) Write a query to find customer with high churn risk..
SELECT
	CUSTOMERID,
	DAYSINCELASTORDER,
	SATISFACTIONSCORE
FROM
	CHURN_DATA
WHERE
	SATISFACTIONSCORE <= 3
	AND DAYSINCELASTORDER >= 10;
2 ) write a query to identify customer who have made only one purchase..
SELECT
	CUSTOMERID,
	ORDERCOUNT
FROM
	CHURN_DATA
WHERE
	ORDERCOUNT = 1;
3 ) write a query to find the highest value customer based on thair purchases value..
SELECT
	CUSTOMERID,
	TENURE,
	ORDERCOUNT
FROM
	CHURN_DATA
WHERE
	TENURE >= 10
	AND ORDERCOUNT >= 10;
4 ) write a query to find a customer who have not purchases recently..
SELECT
	CUSTOMERID,
	DAYSINCELASTORDER
FROM
	CHURN_DATA
WHERE
	DAYSINCELASTORDER >= 15;
5 ) write a query to analyse churn rate by customer segment..
SELECT
	CITYTIER,
	COUNT(*) AS TOTALCUSTOMERS,
	SUM(CHURN) AS CHURNEDCUSTOMERS,
	ROUND(SUM(CHURN) * 100.0 / COUNT(*), 2) AS CHURNRATE
FROM
	CHURN_DATA
GROUP BY
	CITYTIER
ORDER BY
	CHURNRATE DESC;

6) Compare churned vs active cstomer
SELECT
	CHURN,
	COUNT(*) AS CUSTOMER,
	AVG(ORDERCOUNT) AS AVGORDER,
	AVG(DAYSINCELASTORDER) AS AVGDAYSINCELASTORDER,
	AVG(SATISFACTIONSCORE) AS AVGSATISFACTIONSCORE,
	AVG(CASHBACKAMOUNT) AS AVGCASHBACKAMOUNT
FROM
	CHURN_DATA
GROUP BY
	CHURN;
7 )Find high spending but low frequency customer
SELECT
	CUSTOMERID,
	ORDERCOUNT,
	CASHBACKAMOUNT
FROM
	CHURN_DATA
WHERE
	ORDERCOUNT <= 2
	AND CASHBACKAMOUNT >= (
		SELECT
			AVG(CASHBACKAMOUNT)
		FROM
			CHURN_DATA
	)
ORDER BY
	CASHBACKAMOUNT DESC;
8 ) Find customer segment with highest retention potentional..
SELECT
    PreferedOrderCat,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 0 THEN 1 ELSE 0 END) AS ActiveCustomers,
    ROUND(
        SUM(CASE WHEN Churn = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS RetentionRate
FROM Churn_Data
GROUP BY PreferedOrderCat
ORDER BY RetentionRate DESC;
9 ) Identified customer showing early sigh of churn..
SELECT CustomerID, OrderCount, DaySinceLastOrder, SatisfactionScore, Churn
FROM ecommerce_churn
WHERE DaySinceLastOrder >= 20
   OR SatisfactionScore <= 2
ORDER BY DaySinceLastOrder DESC;
10 ) Create customer retation priority list..
SELECT
    CustomerID,
    Churn,
    OrderCount,
    DaySinceLastOrder,
    SatisfactionScore,
    CashbackAmount,
    CASE
        WHEN Churn = 1 AND SatisfactionScore <= 2 
             AND DaySinceLastOrder >= 30 THEN 'High Priority'
        WHEN Churn = 1 OR DaySinceLastOrder >= 20 THEN 'Medium Priority'
        ELSE 'Low Priority'
    END AS RetentionPriority
FROM churn_data
ORDER BY
    CASE
        WHEN Churn = 1 AND SatisfactionScore <= 2 
             AND DaySinceLastOrder >= 30 THEN 1
        WHEN Churn = 1 OR DaySinceLastOrder >= 20 THEN 2
        ELSE 3
    END;