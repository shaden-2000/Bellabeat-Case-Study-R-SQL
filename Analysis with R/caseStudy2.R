# Import necessary libraries
install.packages("tidyverse")
install.packages("sqldf")
install.packages("readr")
install.packages('xlsx')  
library(tidyverse)
library(lubridate) 
library(dplyr)
library(ggplot2)
library(tidyr)
library(sqldf)
library(readr)
library(xlsx)




# Importing The Datasets and creating dataframes
daily_activity <- read_csv("dailyActivity_merged.csv")
sleep_per_day <- read_csv("sleepDay_merged.csv")
weight_log_info <- read_csv("weightLogInfo_merged.csv")
daily_calories <- read_csv("dailyCalories_merged.csv")
hourly_intensities <- read_csv("hourlyIntensities_merged.csv")
hourly_steps <- read_csv("hourlySteps_merged.csv")
hourlyCalories_merged <- read_csv("hourlyCalories_merged.csv")

# ---------------------------------------------Exploring the Data---------------------------------------------


#1- Take a look at the datasets
head(daily_activity)
head(sleep_per_day)
head(weight_log_info)
head(daily_calories)
head(hourly_intensities)
head(hourly_steps)
#2- Identify all the columns
colnames(daily_activity)
colnames(sleep_per_day)
colnames(weight_log_info)
colnames(daily_calories)
colnames(hourly_intensities)
colnames(hourly_steps)

#3- display the internal structure
str(daily_activity)
str(sleep_per_day)
str(weight_log_info)
str(daily_calories)
str(hourly_intensities)
str(hourly_steps)


#4- 

# Convert Day to date format in  ( daily_activity , sleep_per_day , weight_log_info )
# Rename various dates to Day in ( daily_activity , sleep_per_day , weight_log_info )

daily_activity <-daily_activity %>%
  mutate_at(vars(ActivityDate), as.Date, format = "%m/%d/%y") %>%
  rename("Day"="ActivityDate") 



sleep_per_day <-sleep_per_day %>%
  mutate_at(vars(SleepDay), as.Date, format = "%m/%d/%y") %>%
  rename("Day"="SleepDay")

weight_log_info <-weight_log_info %>%
  mutate_at(vars(Date),as.Date, format = "%m/%d/%y") %>%
  rename("Day"="Date")


hourly_activity$ActivityHour <- mdy_hms(hourly_activity$ActivityHour)


#5- Check for Any nulls

# -----------weight_log_info Dataset-----------
if(sum(is.na(weight_log_info)) == 0 ){
  print("Non-nulls-valuse")
} else {
  # count total missing values  
  print(paste("Count of total missing values - ", sum(is.na(weight_log_info ))))
  
  
  # Position of missing values
  print("Position of missing values -") 
  which(is.na(weight_log_info)) 
}


# -----------daily_activity Dataset-----------
if(sum(is.na(daily_activity)) == 0 ){
  print("Non-nulls-valuse")
} else {
  # count total missing values  
  print(paste("Count of total missing values - ", sum(is.na(daily_activity))))
  
  
  # Position of missing values
  print("Position of missing values -") 
  which(is.na(daily_activity)) 
}


# -----------sleep_per_day Dataset-----------
if(sum(is.na(sleep_per_day)) == 0 ){
  print("Non-nulls-valuse")
} else {
  # count total missing values  
  print(paste("Count of total missing values - ", sum(is.na(sleep_per_day))))
  
  
  # Position of missing values
  print("Position of missing values -") 
  which(is.na(sleep_per_day)) 
}



# -----------daily_calories Dataset-----------
if(sum(is.na(daily_calories)) == 0 ){
  print("Non-nulls-valuse")
} else {
  # count total missing values  
  print(paste("Count of total missing values - ", sum(is.na(daily_calories))))
  
  
  # Position of missing values
  print("Position of missing values -") 
  which(is.na(daily_calories)) 
}



# -----------hourly_intensities Dataset -----------
if(sum(is.na(hourly_intensities)) == 0 ){
  print("Non-nulls-valuse")
} else {
  # count total missing values  
  print(paste("Count of total missing values - ", sum(is.na(hourly_intensities))))
  
  
  # Position of missing values
  print("Position of missing values -") 
  which(is.na(hourly_intensities)) 
}


# -----------hourly_steps Dataset-----------
if(sum(is.na(hourly_steps)) == 0 ){
  print("Non-nulls-valuse")
} else {
  # count total missing values  
  print(paste("Count of total missing values - ", sum(is.na(hourly_steps))))
  
  
  # Position of missing values
  print("Position of missing values -") 
  which(is.na(hourly_steps)) 
}

#6- While examining the column names, I realized that I could merge the three datasets 
#containing time-related information into a single dataset using the “Id” and “ActivityHour” columns.

#Merging hourly_intensity, hourly_calories,hourly_steps in one single dataset

hourly_activity <- merge(hourly_intensities,hourlyCalories_merged ,by=c("Id","ActivityHour"))
hourly_activity <- merge(hourly_activity,hourly_steps,by=c("Id","ActivityHour"))
View(hourly_activity)

#7-How many unique participants are there.
n_distinct(daily_activity$Id)
n_distinct(sleep_per_day$Id)
n_distinct(weight_log_info$Id)
n_distinct(hourly_activity$Id)
#weight datasets has only 8 unique participants so it will be excluded



# ---------------------------------------------Data analysis and visualizations---------------------------------------------

#1- Calculate the average number of steps a person takes per day
average_total_steps <- mean(daily_activity$TotalSteps)
average_total_steps

#2- Calculate average hours of sleep for all individuals
sleep_per_day <- sleep_per_day %>%
  mutate(HoursOfSleep = TotalMinutesAsleep / 60)
average_hours_of_sleep <- mean(sleep_per_day$HoursOfSleep)
average_hours_of_sleep


#3-quick summary statistics
daily_activity %>%  
  select(TotalSteps,
         TotalDistance,
         Calories,
         SedentaryMinutes) %>%
  summary()

sleep_per_day %>%  
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()

hourlyCalories_merged %>%  
  select(Calories) %>%
  summary()


#4-Findings
#Total steps recommended by the World Health Organization(WHO) is 10,000. Individuals have an average daily number of total steps to be 7,638.
#Bellabeat users have an average or 6.99 sleep hours just under the minimum recommended amount of sleep (7-8 hours) by World Health Organization(WHO).
#The individuals spent day 16.5 hours a day being sedentary.%60
#The average participant burns 2304 calories per day
#The average participant burns 97 calories per hour.
#the average number of steps taken is 7638, which is less than the needed 10000 steps.
#The average amount of time spent sedentary is 991.2 minutes, or 16.52 hours, which is much more than the recommended maximum of 7 hours.
#The average user sleeps for a total of 419 minutes, or around 7 hours.
#The average user’s average weight is 72 kg



#1)Relationship between steps taken in a day and sedentary minutes.
ggplot(data=daily_activity, aes(x=TotalSteps, y=SedentaryMinutes))+ geom_point() + labs(title = "Relationship between Total Steps taken and Sedentary Minutes")


#2)Relationship between minutes asleep and time in bed. We expect it to be almost completely linear.
ggplot(data=sleep_per_day, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + geom_point() + labs(title = "Relationship between Total Minutes Asleep and Total Time In Bed")

#3)Relationship between Total Steps Taken vs. Calories Burned
ggplot(data = daily_activity, aes(x = TotalSteps, y = Calories)) + geom_point() + labs(title = "Relationship between Total Steps Taken vs. Calories Burned")

#4)Merging these two datasets together (sleep_per_day, daily_activit) so we can explore some different relationships between activity and sleep as well.
combined_data <- merge(sleep_per_day, daily_activity, by="Id")

ggplot(data = combined_data, mapping = aes(x = SedentaryMinutes, y = TotalMinutesAsleep)) + 
  geom_point() + labs(title= "Sedentary Minutes and Total Minutes Asleep")

cor(combined_data$TotalMinutesAsleep,combined_data$SedentaryMinutes)

#The negative sign indicates a negative correlation, 
#which means that the less active a participant is, the less sleep they tend to get.

#5 Distribution of sleep time 
ggplot(combined_data, aes(TotalMinutesAsleep)) +
geom_histogram(bins=10, na.rm=TRUE,color = "#000000",fill="#fa8072" )+
labs(title="Distribution of Total Time Asleep", x="Total Time Asleep (minutes)") 

#6 Calories burned for every step taken
ggplot(data=daily_activity) + geom_point(mapping=aes(x=TotalSteps, y=Calories, color=Calories)) +
  geom_text(mapping = aes(x=10000,y=500,label="Average Steps",srt=-90)) +
  geom_text(mapping = aes(x=29000,y=2500,label="Average Calories")) +
  labs(x="Steps Taken",y="Calories Burned",title = "Calories burned for every step taken")
# With a few outliers at the bottom and top of the scatter plot, it is a positive correlation.
# The figure makes it evident that the intensity of calories burnt rises with the quantity of steps done.

# ---------------------------------------------RECOMMENDATIONS---------------------------------------------

 
# 1)The average number of steps per day is 7,638 wich is lower than what the World Health Organization(WHO) recommends (10,000 steps per day). Bellabeat can introduce reminders. This would increase benfits for the users and more usage for the app. do is suggest that users take at least 8,000 steps per day and explain the benefits that come with it.

# 2)Bellabeat should offer a progression system in the app to encourage participants to become at least fairly active.

# 3)Bellabeat can suggest some ideas for low calorie breakfast, lunch, and dinner foods to help users that want to lose weight.

# 4)The users should improve the quality and quantity of their sleep. Bellabeat should consider using app notifications reminding users to get enough rest, as well as recommending reducing sedentary time.

# 5)Participants are less active on Fridays. Bellabeat can use this knowledge to remind users to go for a walk on these days motivate users to go out and continue exercising.

# 6)Bellabeat can record the average wake-up time of its user and recommend the optimal bedtime through a notification to ensure being well-rested.

# 7)One of the initial recommendations is to set reminders during the peak activity hours to engage in physical exercise if the calorie goals set by the user have not been achieved.

# 8)One solution to encourage user activity could be to gamify the usage. The more a user achieves their daily, weekly, or monthly goals, the more points they would earn. These points could be used to obtain discounts on items like sports equipment, incentivizing users to stay active and engaged with the platform.

# 9) Positive correlation is seen in the relationships between steps taken and calories burned as well as between very active minutes and calories burned. So, this may be a successful marketing tactic.
 
# ---------------------------------------------SHARE---------------------------------------------
# Export data to excel(xlsx)and google sheets and tablue(csv)
write.xlsx(combined_data, file = "Fitbit_Fitness_Data.xlsx")
write.csv(combined_data, file = "Fitbit_Fitness_Data.csv")





