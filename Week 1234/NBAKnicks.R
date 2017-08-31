load("~/Desktop/data/Knicks.rda")
View(data)
summary(data)

library(dplyr)
library(ggplot2)

# (1)
data1 <- group_by(data,season) %>%
  summarise(., win_ratio = sum(win == "W") / sum((sum(win == "W") + (sum(win == "L")))))
plot_1 <- qplot(season, win_ratio, data = data1, geom = "bar", stat='identity', fill = win_ratio)

# (2)
data2 <- group_by(data,season,visiting) %>%
  summarise(.,win_ratio = sum(win == "W") / sum((sum(win == "W") + (sum(win == "L")))))
plot_2 <- qplot(season, win_ratio, data = data2, geom = "bar", stat='identity', fill = visiting, position = 'dodge')

# (3)
plot_3 <- qplot(points, data = data, binwidth = 2) + facet_wrap(~season)

# (4)
data4 <- group_by(data, opponent) %>% 
  summarise(., win_rate = sum(win == "W") / (sum(win == "W") + (sum(win == "L"))), diff = mean(points - opp))

p <- ggplot(data4, aes(x=diff, y = win_rate)) + 
  geom_point(color = "red4", size = 4) + 
  geom_hline(y=0.5,colour='grey20',size=0.5,linetype=2) +
  geom_vline(x=0,colour='grey20',size=0.5,linetype=2) +
  geom_text(data=data4,
            aes(x=diff,y=win_rate,label=opponent),
            hjust=0.7, vjust=1.4,angle = -30) +
  theme_bw()