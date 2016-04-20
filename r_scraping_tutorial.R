link <- "http://www.koprivnice.org/zastupitelstvo/2015/z150910/hlasovani/0011.xml"

html <- readLines(link, encoding = "utf-8")
html <- data.frame(html)
html$include <- sapply(html$html, function(x) ifelse(grepl("Deputy id", x) == T, 1, 0))
html <- html[which(html$include == 1), ]
html <- data.frame(do.call('rbind', strsplit(as.character(html$html), "=")))

voter_id <- data.frame(do.call('rbind', strsplit(as.character(html$X2), '"')))
voter_id <- data.frame(voter_id$X2)
names(voter_id) <- "voter_id"

title <- data.frame(do.call('rbind', strsplit(as.character(html$X5), '"')))
title <- data.frame(title$X2)
names(title) <- "title"

given_name <- data.frame(do.call('rbind', strsplit(as.character(html$X6), '"')))
given_name <- data.frame(given_name$X2)
names(given_name) <- "given_name"

family_name <- data.frame(do.call('rbind', strsplit(as.character(html$X7), '"')))
family_name <- data.frame(family_name$X2)
names(family_name) <- "family_name"

group <- data.frame(do.call('rbind', strsplit(as.character(html$X8), '"')))
group <- data.frame(group$X2)
names(group) <- "group"

option <- data.frame(do.call('rbind', strsplit(as.character(html$X9), '"')))
option <- data.frame(option$X2)
names(option) <- "option"

result <- cbind(voter_id, title)
result <- cbind(result, given_name)
result <- cbind(result, family_name)
result <- cbind(result, group)
result <- cbind(result, option)
result$vote_event_id <- link

rm(list = ls() [!ls() %in% c("html", "link")])

for (i in c(2, 5:9)) {
  
  data <- data.frame(do.call('rbind', strsplit(as.character(html[, i]), '"')))
  data <- data.frame(data$X2)
  
  if (i == 2) {
    
    result <- data
    
  } else {
    
    result <- cbind(result, data)
    
  } # if (i == 2)
  
} # for (i in c(2, 5:9))

names(result) <- c("voter_id", "title", "family_name", "given_name", "group", "option")

result$vote_event_id <- link

rm(list = ls())

link <- "http://www.koprivnice.cz/index.php?id=usneseni-zastupitelstva-mesta-koprivnice"

sessions <- readLines(link, encoding = "utf-8")
sessions <- data.frame(sessions)
sessions$include <- sapply(sessions$sessions, function(x) ifelse(grepl("http://www.koprivnice.org/zastupitelstvo/", x) == T, 1, 0))
sessions <- sessions[which(sessions$include == 1), ]
sessions <- data.frame(do.call('rbind', strsplit(as.character(sessions$sessions), '"')))
sessions <- data.frame(sessions$X2)
names(sessions) <- "session_name"
sessions$session_link <- paste0(sessions$session, "hlasovani/index.xml")

for (i in 1:nrow(sessions)) {
  
  print(sessions[i, 2])
  
  vote_event <- readLines(sessions[i, 2], encoding = "utf-8")
  vote_event <- data.frame(vote_event)
  vote_event$include <- sapply(vote_event$vote_event, function(x) ifelse(grepl("location=", x) == T, 1, 0))
  vote_event <- vote_event[which(vote_event$include == 1), ]
  vote_event <- data.frame(do.call('rbind', strsplit(as.character(vote_event$vote_event), '"')))
  vote_event <- paste0(sessions[i, 1], "hlasovani/", vote_event$X34)
  vote_event <- data.frame(vote_event)
  names(vote_event) <- "vote_event_link"
  
  if (exists("vote_events") == FALSE) {
    
    vote_events <- vote_event
    
  } else {
    
    vote_events <- rbind(vote_events, vote_event)
    
  } # if (exists("vote_events") == FALSE)
  
} # for (i in sessions)

for (i in vote_events$vote_event_link) {
  
  print(i)
  
  html <- readLines(i, encoding = "utf-8")
  html <- data.frame(html)
  html$include <- sapply(html$html, function(x) ifelse(grepl("Deputy id", x) == T, 1, 0))
  html <- html[which(html$include == 1), ]
  html <- data.frame(do.call('rbind', strsplit(as.character(html$html), "=")))
  
  for (j in c(2, 5:9)) {
    
    data <- data.frame(do.call('rbind', strsplit(as.character(html[, j]), '"')))
    data <- data.frame(data$X2)
    
    if (j == 2) {
      
      result <- data
      
    } else {
      
      result <- cbind(result, data)
      
    } # if (j == 2)
    
  } # for (j in c(2, 5:9))
  
  names(result) <- c("voter_id", "title", "family_name", "given_name", "group", "option")
  result$vote_event_id <- i
  
  if (exists("votes") == FALSE) {
    
    votes <- result
    
  } else {
    
    votes <- rbind(votes, result)
    
  } # if (exists("votes") == FALSE)
  
} # for (i in 1:nrow(vote_events))

rm(list = ls() [!ls() %in% c("votes")])
