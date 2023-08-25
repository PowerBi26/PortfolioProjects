--combining all the data from month 1 to 12 then returning/selecting only the columns that will be used to analyze.
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202201-divvy-tripdata$'] a 
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202202-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202203-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From..['202204-divvy-tripdata$'] a 
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202205-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202206-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202207-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202208-divvy-tripdata$'] a
Union All 
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202209-divvy-publictripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202210-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202211-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202212-divvy-tripdata$'] a

--we'll create new table for the complete bike trip data
Create Table CompleteBikeTripDate
(
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
member_casual nvarchar(255)
)

Insert Into CompleteBikeTripData
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202201-divvy-tripdata$'] a 
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202202-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202203-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From..['202204-divvy-tripdata$'] a 
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202205-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202206-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202207-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202208-divvy-tripdata$'] a
Union All 
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202209-divvy-publictripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202210-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202211-divvy-tripdata$'] a
Union All
Select a.ride_id, a.rideable_type, a.started_at, a.ended_at, a.member_casual
From ..['202212-divvy-tripdata$'] a

Select *
From ..CompleteBikeTripData



--NOW WE PREPARE/CLEAN THE COMPLETE DATA TO BE ANALYZED 
Select *
From ..CompleteBikeTripData

--we separate date and time from the started_at column 
Select CONVERT(DATE,[started_at]) as date,
	   CONVERT(TIME(0),[started_at]) as start_time,
	   CONVERT(TIME(0),[ended_at]) as end_time
From ..CompleteBikeTripData

--I added date,start_time and end_time columns
ALTER TABLE ..CompleteBikeTripData
ADD date Nvarchar(50);

Update ..CompleteBikeTripData
Set date = CONVERT(DATE,[started_at])

ALTER TABLE ..CompleteBikeTripData
ADD start_time Nvarchar(50);

Update ..CompleteBikeTripData
Set start_time = CONVERT(TIME(0),[started_at]) 

ALTER TABLE ..CompleteBikeTripData
ADD end_time Nvarchar(50);

Update ..CompleteBikeTripData
Set end_time = CONVERT(TIME(0),[ended_at])



--DATENAME function to return the day of the week from the date column then permanently added a date column in the table
Select DATENAME(WEEKDAY, date) AS day_of_week
From ..CompleteBikeTripData

ALTER TABLE ..CompleteBikeTripData
ADD day_of_week Nvarchar(50);

Update ..CompleteBikeTripData
Set day_of_week = DATENAME(WEEKDAY, date) 


Select *
From ..CompleteBikeTripData


--creating view for analytics 
Create View BikeTripDateToAnalyze as
Select ride_id, rideable_type, member_casual, date, start_time, end_time, day_of_week
From ..CompleteBikeTripData

Select *
From ..BikeTripDateToAnalyze
