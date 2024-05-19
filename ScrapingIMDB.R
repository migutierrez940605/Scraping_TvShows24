#Install the libraries for this project.
library(rvest)
library(dplyr)
library(httr)
library(RSelenium)
library(tidyverse)

#We select the web page and read it.
url1<-"https://www.imdb.com/list/ls522886649/?view=detailed&sort=user_rating,desc&st_dt=&mode=detail&page=1&ref_=ttls_vm_dtl"
webpage<-read_html(url1)

#Select the column´s data by name, year, genre, rating, vote, and synopses. Also, we fix the data to get the same number of rows.
titles<-html_nodes(webpage,".lister-item-index+ a")%>% html_text()

year<-html_nodes(webpage,".unbold:nth-child(3)") %>% html_text() #The code "%>% str_replace_all("[//(//)]","")" is for cleaning the "()" symbol, but we don't apply because we will use SQL for it#
length(year)
yearfix<-year[! year %in% c(year[1],year[2],year[3],year[4])]

genre<-html_nodes(webpage,".genre")%>% html_text()
length(genre)

rating<-html_nodes(webpage,".ipl-rating-star.small .ipl-rating-star__rating") %>% html_text()
length(rating)
n1<-c("unknown","unknown")
ratingfix<-append(rating,n1)

votes<-html_nodes(webpage,".text-muted .text-muted+ span") %>% html_text()
length(votes)
n2<-c("unknown","unknown")
votesfix<-append(votes,n2)

synopsis<-html_nodes(webpage,"p:nth-child(3) , .ipl-rating-widget+ p") %>% html_text()
length(synopsis)
synopsisfix<-synopsis[! synopsis %in% c(synopsis[71])]

# After fixing the vectors above, We check if the columns have the same number of rows.
length(titles)
length(yearfix)
length(genre)
length(ratingfix)
length(votesfix)
length(synopsisfix)

#We join the vectors in a data frame and view it. Also, we export it in Excel format
tv_shows24<-data.frame(
  Title= titles,
  Year= yearfix,
  Genre= genre,
  Rating= ratingfix,
  Vote= votesfix,
  Synopsis= synopsisfix,
  stringsAsFactors = FALSE
)
View(tv_shows24)
write.csv(tv_shows24,"tv_shows24.csv")





