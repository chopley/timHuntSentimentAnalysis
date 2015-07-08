library('twitteR')
library('tm')


api_key <- "3oAoOU7Kg44WVwTfiXJkltmMY"
api_secret <- "TBLVrOkMVTiVRz0PcPEY31zI00dx5476Hde1CtnP3a9Bjdk86g"
access_token <- "2180208666-GRspSe17ilE9n2hWBi948mCPpzwxc3Rax1I1B7i"
access_token_secret <- "g7EmvEXnQfaI0yjmVoxVqVlXLlBTr4vcWL5NGYbOmPjtd"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)


##get all the twitter feeds in SA with parliament mentioned in them
ttimHunt<-searchTwitter('#timhunt',n=10000,since='2015-06-08')
twomenInScience<-searchTwitter('#womeninscience',n=10000,since='2015-06-08')
distractinglySexy<-searchTwitter('#distractinglysexy',n=10000,since='2015-06-08')



ttSAOneDF<-twListToDF(ttSAOne)
ttSA<-ttSATwo


##%convert to a data fram because the other form is impossible to handle
df <- do.call("rbind", lapply(ttSA, as.data.frame))

##find the tweets that have EFF mentioned
ttValsEFF<-lapply(1:length(ttSA),function(x) { grepl("*EFF*", df$text[x])})
ttValsDA<-lapply(1:length(ttSA),function(x) { grepl("*DA*", df$text[x])})
ttValsANC<-lapply(1:length(ttSA),function(x) { grepl("*ANC*", df$text[x])})

percentANC<-length(ttValsANC[ttValsANC=='TRUE'])/1000
percentDA<-length(ttValsDA[ttValsDA=='TRUE'])/1000
percentEFF<-length(ttValsEFF[ttValsEFF=='TRUE'])/1000

nTrue<- length(ttVals[ttVals=='TRUE'])



rdmTweets <- userTimeline("rdatamining", n=100)
n <- length(rdmTweets)
rdmTweets[1:3]
df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
dim(df)


abortion<-searchTwitter('#prolife+#prochoice',n=1000)
abortionDF<-twListToDF(abortion)
library(tm)
myCorpus <- Corpus(VectorSource(abortionDF$text))
##After that, the corpus needs a couple of transformations, including changing letters to lower case, removing punctuations/numbers and removing stop words. The general English stop-word list is tailored by adding "available" and "via" and removing "r".
##convert alltext to lower case
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
# remove punctuation
myCorpus <- tm_map(myCorpus, removePunctuation)
# remove stopwords
# keep "r" by removing it from stopwordsmyCorpus <- tm_map(myCorpus, tolower)
my_stopwords <- c(stopwords('english'), 'prolife', 'prochoice')
myCorpus <- tm_map(myCorpus, removeWords, my_stopwords)
myDTM <- TermDocumentMatrix(myCorpus)
findFreqTerms(myDTM, lowfreq=30)
findAssocs(myDTM, 'fetus', 0.20)

# remove sparse terms to simplify the cluster plot
# Note: tweak the sparse parameter to determine the number of words.
# About 10-30 words is good.
myDTM2 <- removeSparseTerms(myDTM, sparse=0.95)
myDF <- as.data.frame(inspect(myDTM2))

myDF.scale <- scale(myDF)
d <- dist(myDF.scale, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")
plot(fit) # display dendogram?

groups <- cutree(fit, k=2) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters
rect.hclust(fit, k=2, border="red")

##building a wordcloud
m <- as.matrix(myDTM2)
v <- sort(rowSums(m), decreasing=TRUE)
myNames <- names(v)
k <- which(names(v)=="miners")
myNames[k] <- "mining"
d <- data.frame(word=myNames, freq=v)
wordcloud(d$word, d$freq, min.freq=2)

termDocMatrix[5:10,1:20]
termDocMatrix <- as.matrix(termDocMatrix)
# change it to a Boolean matrix
termDocMatrix[termDocMatrix>=1] <- 1
# transform into a term-term adjacency matrix
termMatrix <- termDocMatrix %*% t(termDocMatrix)
library(igraph)
# build a graph from the above matrix
 g <- graph.adjacency(termMatrix, weighted=T, mode = "undirected")
# remove loops
g <- simplify(g)
# set labels and degrees of vertices
V(g)$label <- V(g)$name
V(g)$degree <- degree(g)
# set seed to make the layout reproducible
 set.seed(3952)
 layout1 <- layout.fruchterman.reingold(g)
 plot(g, layout=layout1)
idx <- which(myStopwords == "r")
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)