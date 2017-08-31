
# Objects -----------------------------------------------------------------

## Vector Basics

#basic arithmetic
1 + 1 * 3 

#numerical and string vectors
c(0, 1, 1, 2, 3, 9)
c("Hello, World!", "I am an R user")
1:6
typeof(c(0, 1, 1, 2, 3, 9))

#vector addition
c(1, 2, 3, 4) + c(3, 4, 5, 6)
c(1, 2, 3, 4) + c(1, 2)

## Variables
x = c(1, 2, 3, 4)
x
x[2]; x[2:4]
x[-4]
x[x > 2]

## Mathematical Functions
exp(1)
exp(c(1, 2, 3, 4))

## Data Frames
city = c('New York', 'San Francisco', 'Chicago', 'Houston', 'Los Angeles')
age = c(23, 43, 51, 32, 60)
sex = c('F', 'M', 'F', 'F', 'M')
people = data.frame(city, age, sex)
people

people$age; people$sex
people$age > 30 #Conditioned samples extracted from column
people$city[people$age > 30] #Conditioning across variables

inspections = read.csv('data/BrooklynInspectionResults.csv', header=TRUE)
inspections[c(66, 70, 71, 72), -2]

class(inspections)

#Extract the restaurants surveyed
restaurants = inspections$DBA

#Count the number of unique restaurants in the data set
restaurant_set = unique(restaurants)
length(restaurant_set)

#Limit the data to only those entries with critical violations
inspections = inspections[inspections$CRITICAL.FLAG == "Critical", ]

#install.packages("openxlsx")
library(openxlsx)
excel_data = read.xlsx("data/excel.xlsx", sheet=1)  #read first sheet

#install.packages("foreign")
library(foreign)
stata_data = read.dta("data/statafile.dta")
spss_data = read.spss("data/spssfile.sav")
sas_data = read.xport("data/sasfile.xpt")

write.table(people, file='write/people.csv', sep=',')
write.csv(people, file='write/people.csv') #Equivalent statement

## Lists
people.list = list(AgeOfIndividual=age, Location=city, Gender=sex)
people.list

people.list$tabular.data = people
people.list$tabular.data

people.list[[length(people.list)]]

## Object Features
class(people)
attributes(people)
str(people)
typeof(people)

## Models and Formulas
#A sample model y is a function of variables x1 to xn
y ~ x1 + x2 + x3 + ... + xn
#install.packages("lattice")
library(lattice)
xyplot(dist ~ speed, data=cars)
model = lm(dist ~ speed, data=cars)
class(model)
summary(model)
#Putting the two together
xyplot(dist ~ speed, data=cars, type = c("p","r"))
?xyplot

# In-depth Study of Data Objects ------------------------------------------

vector1 = seq(2, 10, by=2) 
vector2 = 1:10 + 2
vector3 = 1:(10 + 2)
##Numerical Integration
n = 100
w = pi/n
x = seq(from = 0, to = pi, length = n)
rect = sin(x) * w
sum(rect)

group1 = rep(1:3, times=c(8, 10, 9))
group2 = factor(group1)
group2
class(group1)
class(group2)
?factor

set.seed(0)
vec_logic = c(TRUE, TRUE, TRUE, FALSE)
vec_char = c('A', 'B', 'C', 'D') 
vec_num1 = runif(5)
vec_char2 = sample(c('A', 'B'), size=10, replace=TRUE)
vec_num2 = numeric(10) #10-item zero vector 
vec_logic; vec_char2; vec_num2


set.seed(0)
vector = rnorm(10)
vec_max = max(vector)
vec_min = min(vector)
vector_trimmed = vector[vector < vec_max & vector > vec_min]
vec_mean = mean(vector_trimmed)
vec_mean

vector = 1:12
my_matrix = matrix(vector, nrow = 3, ncol = 4, byrow = F) #Default.
my_matrix
dim(vector) = c(4, 3)
vector

set.seed(0)
vector1 = vector2 = vector3 = rnorm(3)
my_matrix = cbind(vector1, vector2, vector3)
vector1
my_matrix

my_mat = matrix(1:9,3,3)
my_mat
my_mat[1:2, ]

a = array(1:8, dim = c(2, 2, 2))
a

city = c('Seattle', 'Chicago', 'Boston', 'Houston')
temp = c(78, 74, 50, 104)
data = data.frame(city, temp)

data[ ,1]
data[ ,'city']
data$city

data = data.frame(city, temp, stringsAsFactors = F)
data$city = factor(data$city)
ave = mean(data$temp)
data[data$temp > ave, ]
data = data.frame(city, temp)
summary(data)
dim(data)
head(data)
str(data)

order(data$temp)
data[order(data$temp), ]
data[order(data$temp, decreasing=TRUE), ][1:2, ]

temp = c(27, 29, 23, 14, NA)
mean(temp)
mean(temp, na.rm=TRUE)
temp = c(27, 29, 23, 14, NULL)
length(temp)
people.list$tabular.data = NULL

sapply(iris[ ,1:4], function(x) sd(x)/mean(x))
mylist = as.list(iris[ ,1:4])
sapply(mylist, mean)
lapply(mylist, mean)
?sapply
myfunc = function(x) {
  ret = c(mean(x), sd(x))
  return(ret)
}
result = lapply(mylist, myfunc)
result

result.matrix = t(as.data.frame(result))
colnames(result.matrix) = c("mean", "sd")
result.matrix

set.seed(1)
vec = round(runif(12) * 100)
mat = matrix(vec, 3, 4)
mat
apply(mat, 1, sum) #Applying across the rows.

apply(mat, 2, function(x) max(x)-min(x)) #Applying across the columns.
tapply(X = iris$Sepal.Length, INDEX=list(iris$Species), FUN=mean)
with(iris, tapply(X = Sepal.Length, INDEX=list(Species), FUN=mean))
with(iris, aggregate(Sepal.Length, by = list(Species), mean))


# Control Statements ------------------------------------------------------

num = 5
if (num %% 2 != 0) {
  cat(num, 'is odd')
}

num = 4
if (num %% 2 != 0) {
  cat(num, 'is odd')
} else {
  cat(num, 'is even')
}

if (num %% 2 != 0) {
  cat(num, 'is odd')
} else if (num == 0) {
  cat(num, 'is even, although many people do not realize it.')
} else {
  cat(num, 'is even')
}

num = 1:6
ifelse(num %% 2 == 0, yes='even', no='odd')

set.seed(0)
age = sample(0:100, 20, replace=TRUE)
res = ifelse(age > 70, 'old', ifelse(age <= 30, 'young', 'mid'))
res

age[1]
age_group = cut(age, breaks=c(0,30,70,100), labels=FALSE) #Returns integers.
age_group
switch(age_group[1], 'young', 'middle', 'old')

age_type = 'middle'
switch(age_type,
       young = age[age <= 30],
       middle = age[age <= 70 & age > 30]  ,
       old = age[age > 70]
)

campaign_data = read.csv('data/campaign_contributions.csv', header=TRUE)
campaign_data = campaign_data[campaign_data$AMNT > 0, ]
summary(campaign_data$AMNT)

str(campaign_data$CANDID)


id = "BB"  #Bloomberg.
size = "platinum"
data = campaign_data[campaign_data$CANDID == id, ]
switch(size,
       "bronze" = nrow(data[data$AMNT <= 50, ])/nrow(data),
       "silver" = nrow(data[data$AMNT <= 250 & data$AMNT > 50, ])/nrow(data),
       "gold" = nrow(data[data$AMNT <= 500 & data$AMNT > 250, ])/nrow(data),
       "platinum" = nrow(data[data$AMNT > 500, ])/nrow(data)
)


sign_data = read.csv('data/TimesSquareSignage.csv', header=TRUE)
obs = nrow(sign_data)
for (i in 1:obs) {
  if (is.na(sign_data$Width[i])) {
    cat('WARNING: Missing width for sign no.', i, '\n')
  }
}

i = 1
while (i <= obs) {
  if (is.na(sign_data$Width[i])) {
    cat('WARNING: Missing width for sign no.', i, '\n')
  }
  i = i + 1
}

i = 1
nas = which(is.na(sign_data$Width))
while (i < 6) {
  cat('WARNING: Missing width for sign no.', nas[i], '\n')
  i = i + 1
  if (i > 5) {
    cat('WARNING: Turned up more than 5 missing values')
  }
}

i = 1
j = 1
repeat {
  if (is.na(sign_data$Width[i])) {
    cat('WARNING: Missing width for sign no.', i, '\n')
    j = j + 1
  }
  if (j > 5) {
    cat('WARNING: Encountered more than 5 missing values')
    break
  }
  i = i + 1
  if (i > nrow(sign_data)) {
    break
  }
}

findprime = function(x) {
  if (x %in% c(2, 3, 5, 7)) return(TRUE)
  if (x %% 2 == 0 | x == 1) return(FALSE)
  xsqrt = round(sqrt(x))
  xseq = seq(from = 3, to = xsqrt, by = 2)
  if (all(x %% xseq != 0)) return(TRUE)
  else return(FALSE)
}
findprime(97*97)

system.time({
  x1 = c()
  for (i in 1:1e5) {
    y = findprime(i)
    x1[i] = y
  }
})
mean(x1)

system.time({
  x2 = logical(1e4)
  for (i in 1:1e4) {
    y = findprime(i)
    x2[i] = y
  }
})

system.time({
  sapply(1:1e4, findprime)
})

i = 2
x = 1:2
while (x[i] < 1e3) {
  x [i+1] = x[i-1] + x[i]
  i = i + 1
}
x = x[-i]
print(x)


# Functions ---------------------------------------------------------------

calc_area = function(r) {
  area = pi*r^2
  return(area)
}
calc_area(4)

DegreesToRadians = function(d) {
  valueInRadians = d * pi / 180
  return(valueInRadians)
}
DegreesToRadians(145)

ConeVolume = function(r, h) {
  volume = pi * r^2 * (h / 3)
  return(volume)
}
ConeVolume(2, 5)

SDcalc = function(x, type='sample') {
  n = length(x)
  mu = mean(x)
  if (type == 'sample') {
    stdev = sqrt(sum((x-mu)^2)/(n-1))
  }
  if (type == 'population') {
    stdev = sqrt(sum((x-mu)^2)/(n))
  }
  return(stdev)
}
SDcalc(1:10); SDcalc(1:10, type='population')


SDcalc = function(x, type = 'sample') {
  stopifnot(is.numeric(x), length(x) > 0,
            type %in% c('sample', 'population'))
  x = x[!is.na(x)]
  n = length(x)
  mu = mean(x)
  if (type == 'sample') {
    stdev = sqrt(sum((x-mu)^2)/(n-1))
  }
  if (type == 'population') {
    stdev = sqrt(sum((x-mu)^2)/(n))
  }
  return(stdev)
}

SDcalc = function(x, type = 'sample', ...) {
  stopifnot(is.numeric(x), length(x) > 0,
            type %in% c('sample', 'population'))
  n = length(x)
  mu = mean(x, ...)
  if (type == 'sample') {
    stdev = sqrt(sum((x-mu)^2, ...)/(n-1))
  }
  if (type == 'population') {
    stdev = sqrt(sum((x-mu)^2, ...)/(n))
  }
  return(stdev)
}

test = c(1:10, NA)
SDcalc(test, type='sample')
SDcalc(test, type='sample', na.rm=TRUE)
Fac1 = function(n) {
  if (n == 0) return(1)
  return(n * Fac1(n-1))
}
Fac1(10)

#Compare the recursive definition with this one:
Fac2 = function(n) {
  if (n == 0) {
    return(1)
  } else {
    res = n
    while (n > 1) {
      res = res * (n - 1)
      n = n - 1
    }
  }
  return(res)
}
Fac2(10)

which_generation = function(birth_year) {
  if (birth_year > 2000) {
    category = 'Gen Z'
  } else if (birth_year > 1985) {
    category = 'Gen Y'
  } else if (birth_year > 1965) {
    category = 'Gen X'
  } else {
    category = 'Baby Boomer'
  }
  return(category)
}

#First test on a single birth year
which_generation(1989)

#Now with a set of birth years
years = c(1950, 1973, 1990, 2005)
which_generation(years)


which_generation = Vectorize(which_generation)
which_generation(years)

a <- c('NPR', 'New York Times', 'MSNBC')
b <- c('Wall Street Journal', 'NPR', 'Fox News')

'%int%' = function(x, y) {
  intersect(x, y)
}
a %int% b

c = c('Salon', 'The Onion', 'NPR')
a %int% b %int% c

news_list = list(a, b, c)
Reduce('%int%', news_list)

FuncList <- list(base = function(x) mean(x),
                 med = function(x) median(x),
                 manual = function(x) {
                   n <- length(x)
                   x <- sort(x)[c(-1,-n)]
                   mean(x)
                 })
set.seed(1)
x <- sample(100, 10)
FuncList$base(x)

for (f in FuncList) {
  print(f(x))
}

sapply(FuncList, function(f) f(x))
SdMean = function(x, type='sample') {
  stopifnot(is.numeric(x),
            length(x) > 0,
            type %in% c('sample', 'population'))
  x = x[!is.na(x)]
  n = length(x)
  mu = mean(x)
  if (type == 'sample') n = n-1
  stdev = sqrt(sum((x-mu)^2)/(n))
  return(stdev)
}

SdMedian = function(x, type='sample') {
  stopifnot(is.numeric(x),
            length(x) > 0,
            type %in% c('sample', 'population'))
  x = x[!is.na(x)]
  n = length(x)
  med = median(x)
  if (type == 'sample') n = n-1
  stdev = sqrt(sum((x-med)^2)/(n))
  return(stdev)
}

SdFunc = function(x, func, type='sample') {
  stopifnot(is.function(func), is.numeric(x), length(x) > 0,
            type %in% c('sample', 'population'))
  x = x[!is.na(x)]
  n = length(x)
  m = func(x)
  if (type == 'sample') n = n-1
  stdev = sqrt(sum((x-m)^2)/(n))
  return(stdev)
}

set.seed(1)
x = sample(100, 30)
SdFunc(x, type='sample') #Note the error. Missing func

SdFunc(x, func=median, type='sample')
SdFunc(x, func=FuncList$manual, type='sample')

SdFunc = function(func, type) {
  stopifnot(is.function(func),
            type %in% c('sample', 'population'))
  function(x) {
    stopifnot(is.numeric(x), length(x) > 0)
    x = x[!is.na(x)]
    n = length(x)
    m = func(x)
    if (type == 'sample') n = n-1
    stdev = sqrt(sum((x-m)^2)/(n))
    return(stdev)
  }
}

SdMean = SdFunc(func=mean, type='sample')
SdMedian = SdFunc(func=median, type='sample')

set.seed(1)
x = sample(100, 30)
SdMean(x)

SdMedian(x)
SdMean = SdFunc(func=mean, type='sample')
SdMedian = SdFunc(func=median, type='sample')

set.seed(1)
x = sample(100, 30)
SdMean(x)
SdMedian(x)











