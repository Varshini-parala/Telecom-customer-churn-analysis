CREATE DATABASE customer_churn_analysis;
USE customer_churn_analysis;

describe churn;

SELECT * FROM churn;

SELECT COUNT(*) FROM churn;

SELECT * FROM churn LIMIT 10;

ALTER TABLE churn
MODIFY customerID VARCHAR(50);

ALTER TABLE churn
ADD PRIMARY KEY (customerID);

SET SQL_SAFE_UPDATES = 0;

UPDATE churn
SET TotalCharges = NULL
WHERE TotalCharges = '';

ALTER TABLE churn
MODIFY TotalCharges FLOAT;

SELECT 
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS totalcharges_nulls
FROM churn;

UPDATE churn
SET TotalCharges = 0
WHERE TotalCharges IS NULL;

SELECT customerID, COUNT(*)
FROM churn
GROUP BY customerID
HAVING COUNT(*) > 1;

UPDATE churn
SET 
    OnlineSecurity = CASE 
        WHEN OnlineSecurity = 'No internet service' THEN 'No' 
        ELSE OnlineSecurity END,

    OnlineBackup = CASE 
        WHEN OnlineBackup = 'No internet service' THEN 'No' 
        ELSE OnlineBackup END,

    DeviceProtection = CASE 
        WHEN DeviceProtection = 'No internet service' THEN 'No' 
        ELSE DeviceProtection END,

    TechSupport = CASE 
        WHEN TechSupport = 'No internet service' THEN 'No' 
        ELSE TechSupport END,

    StreamingTV = CASE 
        WHEN StreamingTV = 'No internet service' THEN 'No' 
        ELSE StreamingTV END,

    StreamingMovies = CASE 
        WHEN StreamingMovies = 'No internet service' THEN 'No' 
        ELSE StreamingMovies END,

    MultipleLines = CASE 
        WHEN MultipleLines = 'No phone service' THEN 'No' 
        ELSE MultipleLines END;


UPDATE churn
SET 
customerID = TRIM(customerID),
gender = TRIM(gender),
Partner = TRIM(Partner),
Dependents = TRIM(Dependents),
PaymentMethod = TRIM(PaymentMethod),
Churn = TRIM(Churn);

SELECT DISTINCT Churn FROM churn;
SELECT DISTINCT Contract FROM churn;
SELECT DISTINCT InternetService FROM churn;

#Overall Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM churn;

#Overall Churn Rate
SELECT 
    Contract,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM churn
GROUP BY Contract
ORDER BY churn_rate DESC;

#Churn by Internet Service
SELECT 
    InternetService,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM churn
GROUP BY InternetService;

#Churn by Payment Method
SELECT 
    PaymentMethod,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM churn
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

#Churn vs Monthly Charges
SELECT 
    Churn,
    AVG(tenure) AS avg_tenure
FROM churn
GROUP BY Churn;

#Senior Citizen Impact
SELECT 
    SeniorCitizen,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM churn
GROUP BY SeniorCitizen;

#High Risk Customers
SELECT *
FROM churn
WHERE 
    Contract = 'Month-to-month'
    AND MonthlyCharges > 70
    AND tenure < 12
    AND Churn = 'Yes';
    
