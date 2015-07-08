require(twitter)
require(sentiment)
require(plyr)
require(ggplot2)
require(wordcloud)
require(RColorBrewer)
require(tm)

#get a list of words that have emotions attached to them
wordList<-read.csv2('AFINN/AFINN-111.txt',sep='\t')

filenameList<-c('2015-06-08_2015-06-09_timhunt','2015-06-09_2015-06-10_timhunt','2015-06-10_2015-06-11_timhunt','2015-06-12_2015-06-13_timhunt',
                '2015-06-13_2015-06-14_timhunt','2015-06-15_2015-06-16_timhunt','2015-06-16_2015-06-17_timhunt','2015-06-21_2015-06-22_timhunt',
                '2015-06-22_2015-06-23_timhunt','2015-06-23_2015-06-24_timhunt','2015-06-26_2015-06-27_timhunt','2015-06-27_2015-06-28_timhunt',
                '2015-06-28_2015-06-29_timhunt')

load(filenameList[1])
df1<-dfTimHunt
for(i in 2:length(filenameList)){
  load(filenameList[i])
  df1<-rbind(df1,dfTimHunt)
}





# remove retweet entities
some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", df1$text)
# remove at people
some_txt = gsub("@\\w+", "", some_txt)
# remove punctuation
some_txt = gsub("[[:punct:]]", "", some_txt)
# remove numbers
some_txt = gsub("[[:digit:]]", "", some_txt)
# remove html links
some_txt = gsub("http\\w+", "", some_txt)
# remove unnecessary spaces
some_txt = gsub("[ \t]{2,}", " ", some_txt)
some_txt = gsub("^\\s+|\\s+$", "", some_txt)
some_txt<-tolower(some_txt)

#split the strings up
splitStrings<-strsplit(some_txt," ")
nSamples<-length(splitStrings)
myCorpus <- Corpus(VectorSource(some_txt))
my_stopwords <- c(stopwords('english'))
myCorpus <- tm_map(myCorpus, removeWords, my_stopwords,lazy=TRUE)

for(i in 1:length(myCorpus)){
    i
    #we use try to handle the cases where our cleaning has thrown out everything in the tweet :(
    try({
      #get the list of words remaining after cleaning a specific tweet
      a<-as.character(myCorpus[[i]])
      #split the words by space
      words<-strsplit(a," ")
      #find how many words are in this particular tweet
      nWords <-length(words[[1]])
      aSum<-0
      #now go through those words and create a vector that contains the emotional value of each word
      for(j in 1:nWords){
        #find the values for words contained in the lists
          aSum<-cbind(aSum,wordList[words[[1]][j]==wordList[1]][2])
        }
      #now try and find the mean of that vector- this should give an idea of how the tweeter felt about Tim Hun
      df1$emotion[i]<-mean(as.numeric(aSum),na.rm=TRUE)
      },silent=TRUE)
}




#now we plot histograms of the data
par(mfrow=c(4,4))
tstart <- strptime("2015-06-09 02:54:17 UTC", format="%Y-%m-%d %H:%M:%S",tz="UTC") 
tend<-tstart+ 60*60*24
meanEmotion<-mean(df1$emotion[((df1$created<tend)&(df1$created>tstart))])
Title<-paste(tstart,'\nEmotion',round(meanEmotion,3))
hist(df1$emotion[((df1$created<tend)&(df1$created>tstart))],30,main=Title,xlab='Emotion')


for(i in 1:20){
  tstart<-tstart + 60*60*24
  tend<-tend+ 60*60*24
  meanEmotion<-mean(df1$emotion[((df1$created<tend)&(df1$created>tstart))])
  Title<-paste(tstart,'\nEmotion',round(meanEmotion,3))
  try(hist(df1$emotion[((df1$created<tend)&(df1$created>tstart))],30,main=Title,xlab='Emotion'))
}






#create a corpus from the strings
myCorpus <- Corpus(VectorSource(df1$text))
#transfomr to lower
myCorpus <- tm_map(myCorpus, content_transformer(tolower),lazy=TRUE)
#remove punctuation
myCorpus <- tm_map(myCorpus, content_transformer(removePunctuation),lazy=TRUE)
my_stopwords <- c(stopwords('english'))
myCorpus <- tm_map(myCorpus, removeWords, my_stopwords,lazy=TRUE)
myCorpus <- tm_map(myCorpus, stripWhitespace,lazy=TRUE)

inspect(myCorpus[1:2])
myDTM <- TermDocumentMatrix(myCorpus)



dataframe<-data.frame(text=unlist(sapply(myCorpus, `[`)), stringsAsFactors=F)








# classify emotion
class_emo = classify_emotion(some_txt, algorithm="bayes", prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "unknown"

