
-- The data date range is 1 month, from 2016–04–12 to 2015–05–12 
SELECT MIN(ActivityDate) AS StartDate, MAX(ActivityDate) AS EndDate 
FROM `bellabeat-case-study-406709.Bellabeat.dailyActivity` ;

-- Participants who entered their weight --
SELECT COUNT(DISTINCT Id) AS Participants
FROM `bellabeat-case-study-406709.Bellabeat.weightLogInfo` ;

-- Participants who recorded their sleep --
SELECT COUNT(DISTINCT Id) AS Participants
FROM `bellabeat-case-study-406709.Bellabeat.sleepDay` ;

--Number of sleep entries for each participtant -- 
SELECT DISTINCT(COUNT(Id)) AS EntryCount, Id
FROM `bellabeat-case-study-406709.Bellabeat.sleepDay` 
GROUP BY Id;

-- find any duplicate 
SELECT Id, ActivityDate, COUNT(*)
FROM `bellabeat-case-study-406709.Bellabeat.dailyActivity` 
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1;

SELECT Id, ActivityDay, COUNT(*)
FROM `bellabeat-case-study-406709.Bellabeat.dailyCalories` 
GROUP BY Id, ActivityDay
HAVING COUNT(*) > 1;

SELECT Id, Date, COUNT(*)
FROM `bellabeat-case-study-406709.Bellabeat.weightLogInfo` 
GROUP BY Id, Date
HAVING COUNT(*) > 1;

SELECT Id, ActivityHour, COUNT(*)
FROM `bellabeat-case-study-406709.Bellabeat.hourlyCalories` 
GROUP BY Id, ActivityHour
HAVING COUNT(*) > 1;

SELECT Id, ActivityHour, COUNT(*)
FROM `bellabeat-case-study-406709.Bellabeat.hourlySteps` 
GROUP BY Id, ActivityHour
HAVING COUNT(*) > 1;

-- find any duplicate 
WITH daily_sleep_clean 
AS (
     SELECT *,
	ROW_NUMBER() OVER (PARTITION BY Id
	) AS DuplicateCount
	FROM `bellabeat-case-study-406709.Bellabeat.sleepDay` )
SELECT * 
FROM daily_sleep_clean
WHERE DuplicateCount = 1;





-- create Minutes Till Sleep and Total Hours a sleep columns
SELECT  *, (ROUND(TotalMinutesAsleep/60,1)) AS TotalHoursAsleep ,
	(TotalTimeInBed - TotalMinutesAsleep) AS MinutesTillSleep
FROM `bellabeat-case-study-406709.Bellabeat.daily_sleep_clean`;

-- create Sedentary Hours and TotalActive Hours columns to observe the relationship between them and how do they affect each other
SELECT  Id, ActivityDate, TotalSteps, TotalDistance, ActivityDate,
	(ROUND(SedentaryMinutes/60,1)) AS SedentaryHours,
	(ROUND((VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes)/60,1)) AS TotalActiveHours, 
	Calories
FROM `bellabeat-case-study-406709.Bellabeat.dailyActivity`
WHERE(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes) > 0 
AND Calories > 0;
	
-- join daily_activity and daily_sleep_clean that has been transformed

SELECT  activity.Id,
	activity.ActivityDate, 
	sleep.SleepDay, 
	activity.TotalSteps, 
	activity.SedentaryHours, 
	activity.TotalActiveHours, 
	sleep.TotalHoursAsleep, 
	sleep.MinutesTillSleep
FROM `bellabeat-case-study-406709.Bellabeat.dailyActivity_Trans` AS activity
INNER JOIN `bellabeat-case-study-406709.Bellabeat.daily_sleep_clean_Trans` AS sleep
ON activity.Id = sleep.Id
ORDER BY activity.TotalActiveHours DESC;


-- BMI Categories
SELECT * EXCEPT(Fat,WeightKg,LogId,IsManualReport),
	CASE
	 WHEN BMI < 18.5 THEN "Underweight"
	 WHEN BMI < 25.0 THEN "Healthy"
	 WHEN BMI < 30.0 THEN "Overweight"
	 ELSE "Obese" END AS BMICategories
FROM `bellabeat-case-study-406709.Bellabeat.weightLogInfo`
WHERE BMI > 0;

