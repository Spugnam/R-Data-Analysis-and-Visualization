
# Data Transformation Overview --------------------------------------------
# Subset
#Three different ways to do the exact same thing!
data_sub = iris[iris$Species=='setosa', 3:5]
data_sub1 = subset(iris, Species=='setosa', 3:5)
data_sub2 = with(iris, iris[Species=='setosa', 3:5])
head(data_sub, 1); head(data_sub1, 1); head(data_sub2, 1)
#Transform
#The transform() function can be used to create a new column in an existing dataset.
?transform
iris_tr = transform(iris, v1=log(Sepal.Length))
head(iris_tr, 1)
#Equivalent:
iris_tr1 = iris
iris_tr1$v1 = log(iris$Sepal.Length)
head(iris_tr1, 1)
# Discretize
#The cut() function can be used to transform a numeric variable into a categorical variable.
groupvec = quantile(iris_tr$v1, c(0, 0.25, 0.50, 0.75, 1.0))
labels = c('A', 'B', 'C', 'D')
iris_tr$v2 = cut(iris_tr$v1, breaks=groupvec, labels=labels, include.lowest=TRUE)

groupvec
dim(groupvec)
iris_tr[c(1,6), ]
# Set Levels of a Factor
vec = rep(c(0,1), c(4,6))
vec
#Converting to a factor and creating the labels/levels all at once.
vec_fac = factor(vec, labels=c('male','female'))
vec_fac
#First converting to a factor.
vec1 = factor(rep(c(0,1,3), c(4,6,2)))
vec1
#Then creating the labels/levels.
levels(vec1) = c("male", "female", "male")
vec1
vec2 = factor(rep(c('b','a'), c(4,6)))
vec2
levels(vec2)
relevel(vec2, ref='b') #Changing the reference level.

# Data Reshape ------------------------------------------------------------

data = iris[, 1:4] #A wide dataset; columns are variables, rows are observations.
head(data, 5)
head(iris, 10)

# Use the stack() function to reshape to long form; use unstack() for wide form. 
data_l = stack(data) #A long dataset; treats all elements as pieces of data.
data_w = unstack(data_l) #A wide dataset; columns are variables, rows are obs.
str(data_l); str(data_w)
View(data_l)

#Let's take the last two columns of iris and reshape them to wide form.
subdata = iris[ ,4:5] #This subset of the overall data is in long form.
subdata[c(1,51, 101), ]
subdata_w = unstack(subdata) #Each factor becomes a column in the wide form.
head(subdata_w, 1)

# reshape2
install.packages("reshape2")
library(reshape2)                  #Cast long format to wide format.
dcast(data=subdata,             #Specifying the data to manipulate.
      formula=Species ~ .,      #Species should be the main column; nothing else.
      value.var='Petal.Width',  #Values to fill in should come from Petal.Width.
      fun=mean)                    #Aggregate the values by the mean.
?dcast
iris_long = melt(data=iris,         #Melt wide format to long format.
                 id.vars ='Species')           #The main identification variable is Species.
set.seed(5)
i = sample(nrow(iris_long), 5)
iris_long[i, ]

dcast(data=iris_long,                  #Specifying the data to manipulate.
      formula=Species ~ variable,  #Species is main col.; swing variable col.
      value.var = 'value',               #Values to fill in should come from value col.
      fun=mean)                           #Aggregate the values by the mean.
#In-class exercise using Tips dataset
dcast(tips, sex ~ ., value.var='tip', fun=mean)
dcast(tips, sex ~ size, value.var='tip', fun=mean)
dcast(tips, sex ~ . , value.var='total_bill', fun=mean)


# Split and Combine Data --------------------------------------------------

datax = data.frame(id=c(1,2,3), gender=c('M', 'F', 'M'))
datay = data.frame(id=c(3,1,2), name=c('tom','john','mary'))
datax; datay
merge(datax, datay, by='id')

iris_split = split(iris, iris$Species)
class(iris_split)
attributes(iris_split)
str(iris_split)

iris_unsplit <- unsplit(iris_split, iris$Species)
class(iris_unsplit)
iris_unsplit[c(1,51, 101), ]
#Split Example
library(reshape2) #Not using the reshape2 functions, just want the tips dataset.
tips
tips_by_sex = split(tips, tips$sex)
head(tips_by_sex[[1]], 2)
ratio_fun = function(x) {
  sum(x$tip) / sum(x$total_bill)
}
result = lapply(tips_by_sex, ratio_fun)
result


# Character Manipulation --------------------------------------------------
fruit = 'apple orange grape banana'
nchar(fruit)

split.string.list = strsplit(fruit, split=' ')
split.string.list
fruitvec = unlist(split.string.list)
fruitvec

paste(fruitvec, collapse = ' ')
paste(fruitvec, collapse=',')
paste(fruitvec, 'extra')
paste(fruitvec, 'extra', sep = '.')

n = 1:20
xvar = paste('x', n, sep = '')
right = paste(xvar, collapse = ' + ')
left = 'y ~'
my_formula = paste(left, right)
my_formula

substr(fruit, 1, 5)
substr(fruit, 1, 7)
substr(fruit, 9, 21)

gsub('apple', 'strawberry', fruit)
gsub('a', '?', fruit)
gsub('an', 'HA', fruit)
?gsub

grep('grape', fruitvec)
grep('a', fruitvec)
grep('an', fruitvec)
fruitvec
# Case Study: Exploring CRAN ----------------------------------------------

#get packages table
install.packages("XML")
library(XML)
web = 'http://cran.r-project.org/web/packages/available_packages_by_name.html'
packages = readHTMLTable(web, stringsAsFactors = FALSE)

pnames = packages[[1]][ ,1]
length(pnames)

pnames = pnames[2:11]
b = 'http://cran.r-project.org/web/packages/'
a = '/index.html'
urls = paste0(b, pnames, a)

table = readHTMLTable(urls[1], stringsAsFactors=FALSE, header=FALSE)
info = table[[1]]
paste0(info$V1, info$V2)

tables = lapply(urls, readHTMLTable, stringsAsFactors=FALSE, header=FALSE)
infos = lapply(tables, function(x) x[[1]])
infovec = lapply(infos, function(x) paste0(x$V1, x$V2))

aname = lapply(infovec, function(x) x[grep('Author:', x)])
anamevec = lapply(aname, function(x) substr(x, 8, nchar(x)))
anamevec = unlist(anamevec)
name.df = data.frame(pnames, anamevec)


# Manipulating Dates and Timestamps ---------------------------------------
date1 = '1989-05-04'
date1 = as.Date(date1)
class(date1)

date1 = '05/04/1989'
date1 = as.Date(date1, format='%m/%d/%Y')
date1

date2 = date1 + 31
date2 - date1

date2 > date1

Sys.Date() - structure(0, class='Date')

dates = seq(date1, length=4, by='day')
format(dates, '%w')

weekdays(dates)

time1 = ISOdatetime(2011,1,1,0,0,0)
rtimes = ISOdatetime(2013, rep(4:5,5), sample(30,10), 0, 0, 0)
time1
rtimes

#install.packages("xts")
library(xts)
x = 1:4
y = seq(as.Date('2001-01-01'), length=4, by='day')
y
date1 = xts(x, y)
date1

value = coredata(date1)
value
coredata(date1) = 2:5
time = index(date1)

x = 5:2
y = seq(as.Date('2001-01-02'), length=4, by='day')
date2 = xts(x, y)
date3 = cbind(date1, date2)
names(date3) = c('v1', 'v2')
date4 = rbind(date1, date2)
names(date4) = 'value'
date4

window(date4, start=as.Date("2001-01-04"))
#lag() and diff() are still available
lag(date2)
diff(date2) 


# Case Study: Exploring Stock Data ----------------------------------------

install.packages("quantmod")
library(quantmod)
options(getSymbols.auto.assign=FALSE)
library(xts)
SSEC = getSymbols('^SSEC', src='yahoo', from='2000-01-01')
head(SSEC, 3)

data = SSEC
data$ratio = with(SSEC, diff(SSEC.Close)/SSEC.Close)
data$ratio
data.df = as.data.frame(data)
data.df[order(abs(data.df$ratio), decreasing=T), ][1:5, ]


install.packages("lubridate")
library(lubridate)
data$mday = month(data)
res = aggregate(data$ratio, data$mday, mean, na.rm=TRUE)
cat(format(res*100, digits=2, scientific=F))
?aggregate

# Case Study: Tencent QQ Data Analysis ------------------------------------

#install.packages(c("stringr","plyr"))
library(stringr)
library(plyr)
library(lubridate)
data = read.table('qqdata.csv', header=TRUE, sep=',',
                  stringsAsFactors=FALSE)
head(data, 3)

time = as.POSIXct(data$time, tz='GMT')
id = as.factor(data$id)
data1 = data.frame(id, time)

user = as.data.frame(table(data1$id))
user = user[order(user$Freq, decreasing=T), ]
user[1:5, ]  #getting the top five chat users

data1$hour = hour(data1$time)
hours = as.data.frame(table(data1$hour))
hours = hours[order(hours$Freq, decreasing=T), ]
data1$wday = wday(data1$time)
wdays = as.data.frame(table(data1$wday))
wdays = wdays[order(wdays$Freq, decreasing=T), ]


# Accessing Databases -----------------------------------------------------

install.packages(c("DBI","RSQLite","learningr"))
library(DBI)
library(RSQLite)
driver = dbDriver("SQLite")
db_file = system.file("extdata", "crabtag.sqlite", package="learningr")
conn = dbConnect(driver, db_file)
query = "SELECT count(*) FROM Daylog"
(id_block = dbGetQuery(conn, query))

dbDisconnect(conn)


# Getting Data from Web ---------------------------------------------
install.packages(c("RCurl","RJSONIO"))
library(RCurl)
library(RJSONIO)
#the 'mykey' variable might need to be changed; create your own if it doesn't work
mykey = 'a98d04ac43156c84'
url = paste0('http://api.wunderground.com/api/', 
             mykey, '/conditions/forecast/q/autoip.json')
print(url)

fromurl = function(finalurl) {
  web = getURL(finalurl)
  raw = fromJSON(web)
  high = raw$forecast$simpleforecast$forecastday[[2]]$high['celsius']
  low = raw$forecast$simpleforecast$forecastday[[2]]$low['celsius']
  condition = raw$forecast$simpleforecast$forecastday[[2]]$conditions
  currenttemp = raw$current_observation$temp_c
  currentweather = raw$current_observation$weather
  city = as.character(raw$current_observation$display_location['full'])
  result = list(city=city, current=paste(currenttemp, '??C ',
                                         currentweather, sep=''), 
                tomorrow=paste(low, '-', high,'??C ', condition, sep=''))
  names(result) = c('city', 'current', 'tomorrow')
  return(result)
}

fromurl(url)

library(XML)
url = 'http://mirrors.ustc.edu.cn/CRAN/web/packages/available_packages_by_date.html' 
tables = readHTMLTable(url,
                       stringsAsFactors=FALSE,
                       header=TRUE)
data = tables[[1]]
data[2,]

res = nchar(data[,2])
hist(res, main="R Package Name Length", xlab="Length")

library(XML)
url = "http://www.w3schools.com/xml/plant_catalog.xml"
xmlfile = xmlTreeParse(url)  #download and parse XML
xmltop = xmlRoot(xmlfile)    #get root node
xmlValue(xmltop[[10]][[1]])  #get leaf node data

xmlValue(xmltop[['PLANT']][['COMMON']])  #get data from children of 'xmltop'

xmlSApply(xmltop[[1]], xmlValue)  #get data from each child of XML nodes

plantcat = xmlSApply(xmltop, function(x) xmlSApply(x, xmlValue)) 
plantcat_df = data.frame(t(plantcat),row.names=NULL) 
plantcat_df[1:5,1:4]

library(RCurl)
library(XML)
url = 'http://www.imdb.com/title/tt0111161/criticreviews?ref_=tt_ov_rt'
raw = getURL(url)
data = htmlParse(raw)
xpath = '//tr[@itemprop="reviews"]/td[2]/div'
nodes = getNodeSet(data, xpath)
text = sapply(nodes, xmlValue)








