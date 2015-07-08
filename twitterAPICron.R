library('twitteR')
library('tm')

library(tm)


api_key <- "3oAoOU7Kg44WVwTfiXJkltmMY"
api_secret <- "TBLVrOkMVTiVRz0PcPEY31zI00dx5476Hde1CtnP3a9Bjdk86g"
access_token <- "2180208666-GRspSe17ilE9n2hWBi948mCPpzwxc3Rax1I1B7i"
access_token_secret <- "g7EmvEXnQfaI0yjmVoxVqVlXLlBTr4vcWL5NGYbOmPjtd"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

today <- Sys.Date()

for(i in 0:2){
  ttimHunt <- paste("TimHunt",today,sep = "_")
  sincea<-as.character(today-(i+1))
  untila<-as.character(today-i)
  sincea
  untila
  ttimHunt<-searchTwitter('#timhunt',n=100000,since=sincea,until=untila)
  dfTimHunt <- do.call("rbind", lapply(ttimHunt, as.data.frame))
  fileTimHunt<-sprintf("%s_%s_timhunt",sincea,untila)
  save(dfTimHunt,file=fileTimHunt)
}

for(i in 0:2){
  ttimHunt <- paste("TimHuntSeparate",today,sep = "_")
  sincea<-as.character(today-(i+1))
  untila<-as.character(today-i)
  sincea
  untila
  ttimHunt<-searchTwitter('tim hunt',n=100000,since=sincea,until=untila)
  dfTimHunt <- do.call("rbind", lapply(ttimHunt, as.data.frame))
  fileTimHunt<-sprintf("%s_%s_timhuntSep",sincea,untila)
  save(dfTimHunt,file=fileTimHunt)
}

for(i in 0:2){
  ttimHunt <- paste("womeninscience",today,sep = "_")
  sincea<-as.character(today-(i+1))
  untila<-as.character(today-i)
  sincea
  untila
  ttimHunt<-searchTwitter('#womeninscience',n=100000,since=sincea,until=untila)
  dfTimHunt <- do.call("rbind", lapply(ttimHunt, as.data.frame))
  fileTimHunt<-sprintf("%s_%s_womenInScience",sincea,untila)
  save(dfTimHunt,file=fileTimHunt)
}

for(i in 0:2){
  ttimHunt <- paste("distractinglySexy",today,sep = "_")
  sincea<-as.character(today-(i+1))
  untila<-as.character(today-i)
  sincea
  untila
  ttimHunt<-searchTwitter('#distractinglysexy',n=100000,since=sincea,until=untila)
  dfTimHunt <- do.call("rbind", lapply(ttimHunt, as.data.frame))
  fileTimHunt<-sprintf("%s_%s_distractinglysexy",sincea,untila)
  save(dfTimHunt,file=fileTimHunt)
}







##%convert to a data fram because the other form is impossible to handle

dfTimHuntSeparate <- do.call("rbind", lapply(ttimHuntSeparate, as.data.frame))
dfWomenInScience <- do.call("rbind", lapply(twomenInScience, as.data.frame))
dfDistractinglySexy <- do.call("rbind", lapply(distractinglySexy, as.data.frame))


fileTimHuntSeparate<-sprintf("%s_timhuntSeparate",today)
fileWomenInScience<-sprintf("%s_womenInScience",today)
fileSexy<-sprintf("%s_Sexy",today)


save(dfTimHuntSeparate,file=fileTimHuntSeparate)
save(dfWomenInScience,file=fileWomenInScience)
save(dfDistractinglySexy,file=fileSexy)


rdmTweets <- userTimeline("rdatamining", n=100)



