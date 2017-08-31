##### RDA 3. Original Code ######

setwd("/Users/Quentin/Documents/NYCDataScienceAcademy/R Data Analysis and Visualization")
getwd()
# Baby names data ---------------------------------------------------------
#Remember to set your working directory.
bnames = read.csv("bnames.csv", stringsAsFactors = FALSE)
births = read.csv("births.csv", stringsAsFactors = FALSE)

View(bnames)

head(bnames,5)
tail(bnames,5)

library(ggplot2)

mike <- bnames[bnames$name == "Mike", ]
qplot(year, prop, data = mike, geom = "line")

vivian <- bnames[bnames$name == "Vivian", ]
qplot(year, prop, data = vivian, geom = "line")

qplot(year, prop, data = vivian, geom = "point")

qplot(year, prop, data = vivian, geom = "line", color = sex)

michaels <- bnames[bnames$name == "Michael" |
                     bnames$name == "Michelle", ]
qplot(year, prop, data = michaels, geom = "line",
      color = interaction(sex, name))

vivian <- bnames[bnames$name == "Vivian", ]
qplot(year, prop, data = vivian, geom = "line")


# dplyr -------------------------------------------------------------------

install.packages("dplyr")
library(dplyr)

bnames = tbl_df(bnames)
births = tbl_df(births)
class(bnames)


# Subset, Transform and Reorder -------------------------------------------

df = data.frame(
  color = c("blue", "black", "blue", "blue", "black"),
  value = 1:5)
tbl = tbl_df(df)
View(df)
class(df)
class(tbl)

# Filter ------------------------------------------------------------------

filter(tbl, color == "blue")
filter(df, value %in% c(1, 4))
vivian = filter(bnames, name == "Vivian")
vivian$soundex[1]
filter(bnames, sex == "girl" & (year == 1900 | year == 2000))
filter(bnames, year > 2000 & prop > 0.01)[order(abs(bnames$prop), decreasing=T),][1:10,]
order(abs(bnames$prop), decreasing=T)

?filter
# select ------------------------------------------------------------------
select(tbl, color)
select(tbl, -color)
help(select)
select(bnames, soundex)
select(bnames, starts_with("sound"))
select(bnames, ends_with("ex"))

head(
  select(iris, petal_length = Petal.Length)
)

head(
  rename(iris, petal_length = Petal.Length)
)
Petal.Length

# arrange -----------------------------------------------------------------

df1 = data.frame(color = c(4,1,5,3,2),
                 value = 1:5)
df1
arrange(df1, color)

df_order = order(df1$color) #Returns the indices for ascending order of color.
df_order
df1[df_order,]

arrange(df1, desc(color)) #Arranging the data in descending order.

arrange(bnames, desc(prop))[20,]
arrange(filter(bnames, name == "Vivian"), desc(prop))[1,]

# mutate ------------------------------------------------------------------

mutate(tbl, double = 2 * value)
mutate(tbl, double = 2 * value, quadruple = 4 * value)
transmute(tbl, double = 2 * value, quadruple = 4 * value)
?transmute

# summarise ---------------------------------------------------------------

summarise(tbl, total = sum(value))
summarise(tbl, total = sum(value), avg = mean(value))
head(
  mutate(vivian, perc = prop * 100)
)
summarise(vivian, 
          min = min(prop),
          mean = mean(prop),
          max = max(prop))


# Joining Data Sets -------------------------------------------------------

births
head(bnames)
head(births)
x = data.frame(
  name = c("John", "Paul", "George", "Ringo", "Stuart", "Pete"),
  instrument = c("guitar", "bass", "guitar", "drums", "bass",
                 "drums"))
y = data.frame(
  name = c("John", "Paul", "George", "Ringo", "Brian"),
  band = c("TRUE", "TRUE", "TRUE", "TRUE", "FALSE"))

x
y
left_join(x, y, by = "name") #To which column is the error referring?
inner_join(x, y, by = "name")
semi_join(x, y, by = "name")
anti_join(x, y, by = "name")

bnames2 = left_join(bnames, births, by = c("year","sex"))
bnames2
bnames2 = mutate(bnames2, n = round(prop * births))
bnames2


# Groupwise Operations ----------------------------------------------------

vivian = filter(bnames2, name == "Vivian")
sum(vivian$n)

Johns = filter(bnames2, name == "John")
sum(Johns$n)

#We could have also used the summarise function.
summarise(vivian, total = sum(n))

boynames = filter(bnames, sex=='boy')
boynames2 = unique(boynames)
print(boynames, n=100)


# group_by ----------------------------------------------------------------

summarise(tbl, total = sum(value))
by_color = group_by(tbl, color) #Has a new grouped table component.
summarise(by_color, total = sum(value))
group_by(bnames2, name) #This looks very similar to bnames2; what???s different?

by_name = group_by(bnames2, name)
totals = summarise(by_name, total = sum(n))
head(totals)

group_by(bnames2, name, sex)
by_name = group_by(bnames2, name)
group_by(by_name, sex) #Doesn???t yield what we really wanted...

name_sex = group_by(bnames2, name, sex)
totals2 = summarise(name_sex, total = sum(n))
head(totals2)

by_name_sex = group_by(bnames2, name, sex)
ungroup(by_name_sex)

by_soundex = group_by(bnames2, soundex)
stotals = summarise(by_soundex, total = sum(n))
stotals

arrange(stotals, desc(total))

j500 = filter(bnames, soundex == "J500")
unique(j500$name)

year_sex = group_by(bnames2, year, sex)
year_sex
ytotals = summarise(year_sex, births = sum(n))
ytotals

year_sex = group_by(bnames2, year, sex)
ranks = mutate(year_sex, rank = rank(desc(prop)))
ranks
?rank

ones = filter(ranks, rank == 1)
ones = select(ones, year, name, sex)
unique(ones$name)

arrange(summarise(group_by(ones, name), count = n()), desc(count))


arrange(summarise(group_by(ones, name), count = n()), desc(count))
#Or...
group_by(ones,name) %>% 
  summarise(.,count=n()) %>% 
  arrange(.,desc(count))


bnames3 = select(bnames2,-soundex) #Dropping the soundex column.
name_sex = group_by(bnames3, name, sex)
name_sex

bnames3 = select(bnames2,-soundex)
name_sex = group_by(bnames3, name, sex)
summary1 = summarise(name_sex, total = sum(n))
summary1 #Summarises first by going across the sex group.

bnames3 = select(bnames2,-soundex)
name_sex = group_by(bnames3, name, sex)
summary1 = summarise(name_sex, total = sum(n))
summary2 = summarise(summary1, total = sum(total))
summary2 #Summarises second by going across the name group.

bnames3 = select(bnames2,-soundex)
name_sex = group_by(bnames3, name, sex)
summary1 = summarise(name_sex, total = sum(n))
summary2 = summarise(summary1, total = sum(total))
summary3 = summarise(summary2, total = sum(total))
summary3 #Summarises by compressing the remaining information.

dim(bnames)
Quentins=bnames[bnames$name=="Quentin",]
qplot(year, prop, data=Quentins, geom = "line")
Ginas=bnames[bnames$name=="Gina",]
qplot(year, prop, data=Ginas, geom = "line")

# Summary -----------------------------------------------------------------

browseVignettes(package = "dplyr")
