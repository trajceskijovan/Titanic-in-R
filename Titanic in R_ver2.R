# -----------------------------------------------------------------
# Jovan Trajceski
# Topic: Titanic
# -----------------------------------------------------------------

library(ggplot2)
library(dplyr)

# Import data
train <- read.csv("C:\\Users\\...\\train.csv", header = TRUE, stringsAsFactors = FALSE, na.strings = c("NA", ""))
test <- read.csv("C:\\Users\\...\\test.csv",  header = TRUE, stringsAsFactors = FALSE, na.strings = c("NA", "") )

# Data Structure
length(train)
length(test)

str(train)
str(test)

# Recode "Survived" variable in the test data frames 
test$Survived <- NA

# Merge the test dataset and the train data frames 
all <- rbind(train, test) 
str(all)

# Check the NAs for each variables
colSums(is.na(all))
        
summary(all)

# Exploring some of the most important variables
# Convert the types of " Sex"  variable ," Survived"  variable  and "Pclass"  variable into factors  
# Covert the types of the variables 
all$Sex <- as.factor(all$Sex)
all$Survived <- as.factor(all$Survived)
all$Pclass <- as.factor(all$Pclass)
str(all)

# How many people died and survived on the Titanic
summary(na.omit(all$Survived))


ggplot(all[!is.na(all$Survived),], aes(x = Survived, fill = Survived)) + geom_bar(stat='count') + 
    labs(x = 'How many people died and survived on the Titanic?') + 
    geom_label(stat='count',aes(label=..count..), size=7)

# Sex/gender variable
summary(all$Sex)

ggplot(all, aes(x = Sex, fill = Sex)) + 
    geom_bar(stat='count', position='dodge') + 
    labs(x = 'All data') + geom_label(stat='count', aes(label=..count..)) + 
    scale_fill_manual('legend', values = c('female' = 'pink', 'male' = 'green'))



# Did females have more chances to survive?
# Use subset() function to select the group of male who survived in train dataset
Male_train <- subset(train,Sex=='male')  
Male_survived <- subset(train,train$Survived=="1" & train$Sex=="male")
# number of observations
Male_survived_rate <-109/577

# Use subset() function to select the group of female who survived in train dataset
Female_train <- subset(train,Sex=="female")
Female_survived <- subset(train,train$Survived=="1" & train$Sex=="female")
Female_train
Female_survived
Female_survived_rate <- 233/314

# Sex/gender
ggplot(all[!is.na(all$Survived),], aes(x = Sex, fill = Survived)) + 
geom_bar(stat='count', position='dodge') +
labs(x = 'Training data only') + 
geom_label(stat='count', aes(label=..count..))

# SEX/GENDER:
# In train dataset, 466 are women, and 843 are men
# 18.9% of the men survived, and 74.2% of the women survived
# Sex/gender seems a very important predictor

# Passenger class:
ggplot(all, aes(x = Pclass, fill = Pclass)) + 
    geom_bar(stat='count', position='dodge') +
    labs(x = 'Pclass, All data') + geom_label(stat='count', aes(label=..count..))  

ggplot(all[!is.na(all$Survived),], aes(x = Pclass, fill = Survived)) + 
geom_bar(stat='count', position='dodge') + 
labs(x = 'Training data only')
 
ggplot(all[!is.na(all$Survived),], aes(x = Pclass, fill = Survived)) + 
     geom_bar(stat='count', position='stack') + 
    labs(x = 'Training data only', y= "Count") + facet_grid(.~Sex)


# Passenger class:
# Most passengers are from 3rd class
# A majority of first-class passengers survived, and most people in 3rd class died
# It seems that survival is strongly correlated with the passenger class
# Women in 1st and 2nd class had more chance to survive. For men, 2nd class was almost as bad as 3rd class

# Passenger class
# Generate a new varible to represent different group
all$PclassSex[all$Pclass=='1' & all$Sex=='male'] <- 'P1Male'  #1 class=1, 
all$PclassSex[all$Pclass=='2' & all$Sex=='male'] <- 'P2Male' # 2 - second class
all$PclassSex[all$Pclass=='3' & all$Sex=='male'] <- 'P3Male'
all$PclassSex[all$Pclass=='1' & all$Sex=='female'] <- 'P1Female'
all$PclassSex[all$Pclass=='2' & all$Sex=='female'] <- 'P2Female'
all$PclassSex[all$Pclass=='3' & all$Sex=='female'] <- 'P3Female'
all$PclassSex <- as.factor(all$PclassSex)

# Creating the Title variable
#Extracting Title and Surname from Name
Name <- strsplit(all$Name, split = '[,.-]')

all$Surname <- sapply(Name,"[", 1) 
#  "[" is a function that extracts part of an object— the first  component of the list name.
# [,.-] means the symbols in the Name variables

# Extracting the Title from Name
Name1 <- strsplit(all$Name, split = '[,.]')
all$Title <- sapply(Name1, "[",2)
all$Title <- sub(' ', '', all$Title) #removing spaces before title
table(all$Title)


# Merge the title variable 
all$Title[all$Title %in% c("Mlle", "Ms")] <- "Miss"
all$Title[all$Title== "Mme"] <- "Mrs"
all$Title[!(all$Title %in% c('Master', 'Miss', 'Mr', 'Mrs'))] <- "Rare Title"
all$Title <- as.factor(all$Title)
table(all$Title)


# To create the family size for each person on the boat, I will add up 
# his/her number of parents/children, his/her number of siblings/spouses, 
# and of course add one (the person himself).

#creating family size variable (Fsize)
all$Fsize <- all$SibSp+all$Parch +1

# Plot Survived against Fsize(family size)
ggplot(all[!is.na(all$Survived),], aes(x = Fsize, fill = Survived)) +geom_bar(stat='count', position='dodge') +
    scale_x_continuous(breaks=c(1:11)) + labs(x = 'Family Size')

# Summary:
#Solo travelers had a much higher chance to die than to survive.
#People traveling in families of 2-4 people had a relatively high chance to survive than to die
#People traveling in families of 5+ people had a lower chance to survive


# Dealing with the Age variables
# Plot survived against Age with density plot 
ggplot(all[(!is.na(all$Survived) & !is.na(all$Age)),], aes(x = Age, fill = Survived)) + geom_density(alpha=0.5) + labs(title="Survival density and Age") + scale_x_continuous()
# Summary: Survival chances of ages 20-30 are low

# Plot survived against Age with boxplot 
ggplot(all[!is.na(all$Age),], aes(x = Title, y = Age, fill=Pclass )) + geom_boxplot() + scale_y_continuous() + theme_grey()
# Summary:
# Title and Pclass seem the most important predictors for Age  
# “Masters” are all very young


# Predicting Age with Linear Regression
# lm() is the function used for running a linear regression 
# Age is the dependent variable, and Pclass + Sex + SibSp + Parch + Embarked + Title are all the independent variables that are included in the linear regression
AgeLM <- lm(Age ~ Pclass + Sex + SibSp + Parch + Embarked + Title , data=all[!is.na(all$Age),])
summary(AgeLM)


# Adjust the model 
AgeLM1 <- lm(Age ~ Pclass  + SibSp  + Embarked + Title , data=all[!is.na(all$Age),])
summary(AgeLM1)

#The most significant predictors according to Linear Regression were Passenger Class and Title
#Young people seems to be more likely in Class 2 and Class 3

# Get the predicted value
# predict() is used to predict values based on linear model object.
all$AgeLM <- predict(AgeLM1, all)

# Imputing Linear Regression predictions for missing Ages
# ”Mark” the observations with NA for Age variable 
# which() function will return the position of the elements in a logical vector which are TRUE.
MissingAge <- which(is.na(all$Age))
all$Age[MissingAge] <- all$AgeLM[MissingAge]

# Dealing with the Fare variable
# Display passengers with missing Fare
all[which(is.na(all$Fare)), c('Surname', 'Title', 'Survived', 'Pclass', 'Age', 'SibSp', 'Parch', 'Ticket', 'Fare', 'Cabin', 'Embarked')]

# Replace NA with mean value of his class 
P3Male <- subset(all,PclassSex=='P3Male')
all$Fare[1044] <- mean(P3Male$Fare,na.rm=TRUE)

# Although there now are no missing Fare value anymore, I still noticed that 17 Fares have the value 0. 
# These people are not children that might have traveled for free.
# Display passengers with zero for Fare
all[which(all$Fare==0), c('Surname', 'Title', 'Survived', 'Pclass', 'Age', 'SibSp', 'Parch', 'Ticket', 'Fare', 'Cabin', 'Embarked')]

# Function: group_by + summarise
# group_by() takes an existing table and converts it into a grouped table where operations 
# are performed "by group“
# Get a mean dataset for each PclassSex
zeroFare <- all%>%
    group_by(PclassSex) %>%
    summarise(MeanFare=mean(Fare))

# Replace the zero value 
# left_join(): A merge operation between two data frames where the merge returns all of the rows from one table (the left side) and any matching rows from the second table.
all <- left_join(all, zeroFare, by = "PclassSex")
all$Fare[which(all$Fare==0)] <- all$MeanFare[which(all$Fare==0)]

# Dealing with the Embarked variable
# Display passengers with missing Embarked
all[which(is.na(all$Embarked)),c('Surname', 'Title', 'Survived', 'Pclass', 'Age', 'SibSp', 'Parch', 'Ticket', 'Fare', 'Embarked') ]
# Both women are traveling solo from a family perspective (Fsize=1), 
# but must be friends as they are both are traveling on ticket 113572 and have the same fare

# Display passengers with Ticket number 113572
all[which(all$Ticket==113572),c('Surname', 'Title', 'Survived', 'Pclass', 'Age', 'SibSp', 'Parch', 'Ticket', 'Fare', 'Embarked')]
# Nobody else was traveling on this ticket

# Find the mean value of Fare for each Pclass in different embarked city
PclassFare <- all%>%
    group_by(Pclass, Embarked) %>%
    summarise(MeanPclass=mean(Fare))
all$Embarked[c(62,830)] <- 'S'

# Plot Embarked against Survived with bar chart
ggplot(all[!is.na(all$Survived),], aes(x = Embarked, fill = Survived)) +
    geom_bar(stat='count') + theme_grey() + labs(x = 'Embarked', y= 'Count')


# y axis become to the proportion of a given cut level that is comprised of each clarity level
ggplot(all[!is.na(all$Survived),], aes(x = Embarked, fill = Survived)) +
    geom_bar(stat='count', position= 'fill') + theme_grey() + labs(x = 'Embarked', y= 'Percent')

# Plot survived against Embarked and PclassSex
ggplot(all[!is.na(all$Survived),], aes(x = PclassSex, fill = Survived)) +
    geom_bar() + labs(title="Survival density, PclassSex, and Embarked") +
    scale_x_discrete() + theme_grey() + facet_grid(.~Embarked)
# Many 1st class passengers boarded at Cherbourg
# Southampton survival rates are worse than Cherbourg in all Pclass/Sex combinations
# Cherbourg survival rates are better than Queenstown
# Almost all Queenstown passengers boarded 3rd class
# For Queenstown, within 3rd class, female survival rate is better than Cherbourg and male survival rate is worse than Cherbourg
# Most of male victims in 2nd class and 3rd class were boarded at Southampton.

# Dealing with the Cabin variable & Dealing with Children in the model
# Dealing with the Cabin variable 
# Delete the Cabin variables
all <- all[,-11]

# Dealing with Children in the model
# Plot survived against children
ggplot(all[all$Age<14.5 &!is.na(all$Survived),], aes(x=Pclass, fill=Survived))+ geom_bar(stat='count') + theme_grey()
# All children in P2 survived
# Most children in P3 die
# Consider excluding P3 from the Child

# Adding an “Is Solo” variable" based on Siblings and Spouse (SibSp) only
# Dealing with Children in the model
# Generate a new variable 
all$IsChildP12 <- 'No'
# Identify the children in P1 and P2 class
all$IsChildP12[all$Age<14.5 & all$Pclass %in% c('1', '2')] <- 'Yes'
all$IsChildP12 <- as.factor(all$IsChildP12)
# %in%: identify if the child belongs to P1 or P2 class

# Adding an “ Solo” variable" based on Siblings and Spouse (SibSp) only
all$Solo[all$SibSp==0] <- 'Yes' # Passengers who have 0 siblings aboard 
all$Solo[all$SibSp!=0] <- 'No'  # Passengers who have at least one sibling aboard 
all$Solo <- as.factor(all$Solo)

ggplot(all[!is.na(all$Survived),], aes(x = Solo, fill = Survived)) +
  geom_bar(stat='count') + theme_grey()
