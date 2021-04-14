
#' Symbol check
#'
#' Check if a cryptocurrency symbol is known from the package or resembles a symbol known from the package.
#'
#' @param symbol a character string of the symbol to check in the list. Default is "BTC" for Bitcoin.
#'
#' @return a list containing the full name of the cryptocurrency matching the symbol or a dataframe of proposals.
#'
#' @examples
#' symbolCheck("BTC")
#' symbolCheck("BT")
#' symbolCheck("XBTCZ")
#' symbolCheck("XYZ")

#' @author Vincent KV <contact@vincentkv.com>
#' @import stringr
#' @export

symbolCheck <- function(symbol){
  options(warn=-1)
  #devtools::load_all()
  #library(Cryptics)
  #data("cryptolist",envir=environment())

  #cryptolist$symbol=str_remove_all(cryptolist$symbol,"-USD")
  #cryptolist$full_name=str_remove_all(cryptolist$full_name," USD")

  if (symbol %in% cryptolist$symbol){

    if (cryptolist$full_name[which(cryptolist$symbol==symbol)] != ""){#si le full name n'est pas vide
      cryptoname=cryptolist$full_name[which(cryptolist$symbol==symbol)]#on renvoie le full name correspondant au symbole
    } else{
      cryptoname=symbol #symbole en absence de full name
    }
    return(list("Valid symbol",cryptoname))

  }
  #si le symbole n'est pas dans la liste

  vec0in=c()
  vec1in=c()
  if (length(grep(symbol,cryptolist$symbol))!=0){#mais qu'il est contenu dans d'autres symboles
    vec0in=cryptolist$symbol[grep(symbol,cryptolist$symbol)]
    vec1in=cryptolist$full_name[grep(symbol,cryptolist$symbol)]
  }

  vec0=c()
  vec1=c()
  for (i in 1:length(cryptolist$symbol)){
    if (grepl(cryptolist$symbol[i],symbol)){#variante de grep qui renvoie un booléen au lieu de la position
      vec0=c(vec0,cryptolist$symbol[i])
      vec1=c(vec1,cryptolist$full_name[i])
    }
  }

  df=data.frame(symbol=c(vec0in,vec0),
                full_name=c(vec1in,vec1))

  if(length(c(vec0in,vec0))!=0){
    return(list("Your symbol is not found in the list of the supported currencies, maybe you meant one of those :",df))
  } else {
    return(list("Your symbol is not found in the list of the supported currencies."))
  }
}











#' Cryptocurrency course
#'
#' Get the daily data (Open, High, Low, Close, Adjusted, Volume) of a particular cryptocurrency from its creation until today.
#'
#' @param symbol a character string of the symbol. Default is "BTC" for Bitcoin.
#' @param currency a character string for the region of the currency. "USD", "EUR", "GBP"... Default is "USD" for US Dollar.
#'
#' @return if found, a time series of the searched cryptocurrency.
#'
#' @examples
#' my_course=cryptoCourse(symbol="LTC")
#' my_course=cryptoCourse(currency="EUR")
#' my_course=cryptoCourse(symbol="TRX",currency="GBP")
#'

#' @author Vincent KV <contact@vincentkv.com>
#' @import tseries
#' @export

cryptoCourse <- function(symbol="BTC",currency="USD"){
  options(warn=-1)
  result=symbolCheck(symbol)
  if(result[[1]]=="Valid symbol"){
    cryptoname=result[[2]]
    quotename=paste(symbol,"-",currency,sep="")
    #quotename=crypto
    beginningOfTimes <- as.Date("2000-01-01")
    actualDate <- as.Date(Sys.Date())

    ts=get.hist.quote(instrument = quotename,start=beginningOfTimes,end=actualDate,quote = c("Open","High","Low","Close","Adjusted","Volume"))
    return(ts)
  }
  if(result[[1]]=="Your symbol is not found in the list of the supported currencies, maybe you meant one of those :"){
    print("Your symbol is not found in the list of the supported currencies, maybe you meant one of those :")
    print(result[[2]])
  }
  if(result[[1]]=="Your symbol is not found in the list of the supported currencies."){
    print("Your symbol is not found in the list of the supported currencies.")
  }

}







#' Normalized cryptocurrency course
#'
#' Normalizes a given cryptocurrency time series between 0 and 1. The values taken are the "Opens". 1 is the all-time-high.
#'
#' @param ts a time series.
#'
#' @return a normalized time series.
#'
#' @examples
#' my_normalized_course=normalizedCourse(cryptoCourse(symbol="LTC",currency="EUR"))
#'

#' @author Vincent KV <contact@vincentkv.com>
#' @export

normalizedCourse <- function(ts){
  options(warn=-1)
  #normalizedTs=ts$Open/max(ts$Open,na.rm = TRUE)
  ts=ts$Open/max(ts$Open,na.rm = TRUE)
  return(ts)
}









#' Wallet for a single cryptocurrency
#'
#' Computes the time series of earnings and losses given a specific cryptocurrency and a particular amount of money invested in it during a period of time.
#'
#' @param symbol a character string of the symbol. Default is "BTC" for Bitcoin.
#' @param currency a character string for the region of the currency. "USD", "EUR", "GBP"... Default is "USD" for US Dollar.
#' @param amount a numeric value for the amount of money invested, in the previous currency.
#' @param start a date in "YYYY-MM-DD" format when the money is invested.
#' @param end a date in "YYYY-MM-DD" format when the money is withdrawed. Default is today.
#'
#'
#'
#' @return a time series.
#'
#' @examples
#' my_wallet=wallet(symbol="BTC",currency="USD",amount=20,start="2021-01-01",end="2021-04-01")
#'

#' @author Vincent KV <contact@vincentkv.com>
#' @import tseries
#' @import xts
#' @export

wallet <- function(symbol="BTC",currency="USD",amount,start,end=as.Date(Sys.Date())){
  options(warn=-1)
  start=as.Date(start)
  end=as.Date(end)
  ts=cryptoCourse(symbol,currency)
  ts=normalizedCourse(ts)
  adjust=ts[which(time(ts)==start)]

  #si end vaut la date actuelle mais que cette dernière ne figure pas encore dans les data...
  if(end==as.Date(Sys.Date()) && as.Date(Sys.Date())!=time(ts)[length(ts)]){
    end=as.Date(Sys.Date()-1)#on décale au jour précédent
  }
  if(end==as.Date(Sys.Date()-1) && as.Date(Sys.Date()-1)!=time(ts)[length(ts)]){
    end=as.Date(Sys.Date()-2)#on décale au jour précédent
  }
  N=which(time(ts)==end)-which(time(ts)==start)+1

  #Passage en xts
  XTS <- xts(x = ts[which(time(ts)==start):which(time(ts)==end)], order.by = time(ts)[which(time(ts)==start):which(time(ts)==end)])
  addts=xts(x=rep((1-adjust),N),order.by = time(ts)[which(time(ts)==start):which(time(ts)==end)])
  multts=xts(x=rep(amount,N),order.by = time(ts)[which(time(ts)==start):which(time(ts)==end)])

  coefserie=(XTS+as.numeric(addts))*as.numeric(multts)#toute la série est réhaussée par rapport à la première valeur

  return(coefserie)
}








#' Return on investment for a single cryptocurrency
#'
#' Computes the simple gain or loss given a specific cryptocurrency and a particular amount of money invested in it during a period of time.
#'
#' @param symbol a character string of the symbol. Default is "BTC" for Bitcoin.
#' @param amount a numeric value for the amount of money invested, in the previous currency.
#' @param start a date in "YYYY-MM-DD" format when the money is invested.
#' @param end a date in "YYYY-MM-DD" format when the money is withdrawed. Default is today.
#'
#'
#'
#' @return a numeric value.
#'
#' @examples
#' my_gain=invest(symbol="BTC",amount=20,start="2021-01-01",end="2021-04-01")
#'

#' @author Vincent KV <contact@vincentkv.com>
#' @import tseries
#' @export
#'

invest <- function(symbol="BTC",amount,start,end=as.Date(Sys.Date())){
  options(warn=-1)
  currency="USD"
  start=as.Date(start)
  end=as.Date(end)
  course=cryptoCourse(symbol,currency)
  ts=normalizedCourse(course)
  if(end==as.Date(Sys.Date()) && as.Date(Sys.Date())!=time(course)[length(course$Open)]){
    end=as.Date(Sys.Date()-1)#on décale au jour précédent
  }
  if(end==as.Date(Sys.Date()-1) && as.Date(Sys.Date()-1)!=time(course)[length(course$Open)]){
    end=as.Date(Sys.Date()-2)#on décale au jour précédent
  }

  evolDx=ts[end][[1]]/ts[start][[1]]
  gain=amount*evolDx
  return(gain)
}













#' Historical data graph
#'
#' Plots an interactive graph with the normalized historical data of a single cryptocurrency. The values taken are the "Opens".
#'
#' @param symbol a character string of the symbol. Default is "BTC" for Bitcoin.
#' @param currency a character string for the region of the currency. "USD", "EUR", "GBP"... Default is "USD" for US Dollar. USD is advised as there is more data in this currency.
#' @param norm a boolean to normalize the graph between 0 and 1. 1 is the all-time-high.
#' @param log a boolean to obtain the logarithm of the graph.
#'

#' @examples
#' historic()
#' historic(symbol="LTC",currency="GBP")
#'

#' @author Vincent KV <contact@vincentkv.com>
#' @import tseries
#' @import xts
#' @import dygraphs
#' @export
#'
historic <- function(symbol="BTC",currency="USD",norm=FALSE,log=FALSE){
  options(warn=-1)
  course=cryptoCourse(symbol,currency)#a double time-series
  df=normalizedCourse(course)#a time series rongly named df
  data <- xts(x = course$Open, order.by = time(df))
  title=paste("Normalized",symbol,"course",sep=" ")
  if(norm==TRUE){
    data <- xts(x = df, order.by = time(df))
  }
  if(log==TRUE){
    data <- xts(x = log(course$Open), order.by = time(df))
  }
  if(norm==TRUE && log==TRUE){
    return("Please choose between normalization and logarithm.")
  }
  p <- dygraph(data,
               main = title,
               ylab = "Value") %>%
    dyOptions( drawPoints = TRUE, pointSize = 0.1, fillGraph = TRUE) %>%
    dyRangeSelector()
  p
}








#' Candlestick chart
#'
#' Plots an interactive graph with the candlestick chart of a single cryptocurrency.
#'
#' @param symbol a character string of the symbol. Default is "BTC" for Bitcoin.
#' @param currency a character string for the region of the currency. "USD", "EUR", "GBP"... Default is "USD" for US Dollar.
#' @param start a date in "YYYY-MM-DD" format. Default is 30 days before today.
#' @param end a date in "YYYY-MM-DD" format. Default is today.
#' @param norm a boolean to normalize the graph between 0 and 1. 1 is the all-time-high.
#' @param log a boolean to obtain the logarithm of the graph.
#'
#'
#'
#' @examples
#' candlesticks()
#' candlesticks(symbol="LTC",currency="GBP",start="2019-09-01",end="2020-02-10")
#'

#' @author Vincent KV <contact@vincentkv.com>
#' @import tseries
#' @import xts
#' @import dygraphs
#' @export

candlesticks <- function(symbol="BTC",currency="USD",start=Sys.Date()-30,end=Sys.Date(),norm=FALSE,log=FALSE){
  options(warn=-1)
  start=as.Date(start)
  end=as.Date(end)
  title=paste("Normalized",symbol,"candlestick chart",sep=" ")
  ts=cryptoCourse(symbol,currency)#a double time-series
  if(end==as.Date(Sys.Date()) && as.Date(Sys.Date())!=time(ts)[length(ts$Open)]){
    end=as.Date(Sys.Date()-1)#on décale au jour précédent
  }
  if(end==as.Date(Sys.Date()-1) && as.Date(Sys.Date()-1)!=time(ts)[length(ts$Open)]){
    end=as.Date(Sys.Date()-2)#on décale au jour précédent
  }
  #conversion de la time series en dataframe

  data <- data.frame(
    Date=seq(from=start, to=end, by=1 ),
    Open=ts$Open[which(time(ts)==start):which(time(ts)==end)],
    High=ts$High[which(time(ts)==start):which(time(ts)==end)],
    Low=ts$Low[which(time(ts)==start):which(time(ts)==end)],
    Close=ts$Close[which(time(ts)==start):which(time(ts)==end)]
  )
  if(norm==TRUE){
    data <- data.frame(
      Date=seq(from=start, to=end, by=1 ),
      Open=ts$Open[which(time(ts)==start):which(time(ts)==end)]/max(ts$High,na.rm = TRUE),
      High=ts$High[which(time(ts)==start):which(time(ts)==end)]/max(ts$High,na.rm = TRUE),
      Low=ts$Low[which(time(ts)==start):which(time(ts)==end)]/max(ts$High,na.rm = TRUE),
      Close=ts$Close[which(time(ts)==start):which(time(ts)==end)]/max(ts$High,na.rm = TRUE)
    )
  }
  if(log==TRUE){
    data <- data.frame(
      Date=seq(from=start, to=end, by=1 ),
      Open=log(ts$Open[which(time(ts)==start):which(time(ts)==end)]),
      High=log(ts$High[which(time(ts)==start):which(time(ts)==end)]),
      Low=log(ts$Low[which(time(ts)==start):which(time(ts)==end)]),
      Close=log(ts$Close[which(time(ts)==start):which(time(ts)==end)])
    )
  }
  if(norm==TRUE && log==TRUE){
    return("Please choose between normalization and logarithm.")
  }
  data <- xts(x = data[,-1], order.by = data$Date)

  # Plot it
  p <- dygraph(data,
               main=title,
               ylab = "Value") %>%
    dyCandlestick() %>%
    dyRangeSelector()
  p
}








#' Portfolio
#'
#' Computes the time series of your total earnings and losses given a list of wallets.
#'
#' @param walletlist a list of wallets.
#'
#'
#' @examples
#' my_portfolio=portfolio(list(wallet(symbol = "TRX",amount = 20,start = "2021-01-01"),wallet(symbol = "BTC",amount = 30,start = "2020-07-01",end = "2021-02-01"),wallet(symbol = "LTC",amount = 25,start = "2021-03-01")))
#'
#' @author Vincent KV <contact@vincentkv.com>
#' @import tseries
#' @export
portfolio <- function(walletlist){
  options(warn=-1)

  dateMin=start(walletlist[[1]])[1]
  dateMax=end(walletlist[[1]])[1]
  if (length(walletlist)!=1){
    for (i in 2:length(walletlist)){
      if(start(walletlist[[i]])[1]<dateMin){
        dateMin=start(walletlist[[i]])[1]
      }
      if(end(walletlist[[i]])[1]>dateMax){
        dateMax=end(walletlist[[i]])[1]
      }
    }
  }

  joineddf=data.frame(Date=dateMin:dateMax,
                      Money=rep(0,dateMax-dateMin+1)
  )

  for (i in 1:length(walletlist)) {
    for (j in 1:length(walletlist[[i]])){
      joineddf$Money[which(joineddf$Date==time(walletlist[[i]])[j])] = joineddf$Money[which(joineddf$Date==time(walletlist[[i]])[j])]+walletlist[[i]][j]
    }
  }

  finalmerge=ts(data=joineddf$Money,start = joineddf$Date[1],end=joineddf$Date[length(joineddf$Date)],frequency = 1)

  return(finalmerge)
}









#' Coin tracker graph
#'
#' Plots an interactive graph with the historical data of your portfolio.
#'
#' @param ts a time series.
#'
#'

#' @examples
#' my_portfolio=portfolio(list(wallet(symbol = "TRX",amount = 20,start = "2021-01-01"),wallet(symbol = "LTC",amount = 25,start = "2021-03-01")))
#' cointrack(my_portfolio)

#' @author Vincent KV <contact@vincentkv.com>
#' @import dygraphs
#' @export
#'
cointrack <- function(ts){
  options(warn=-1)
  p <- dygraph(ts,
               main="Portfolio evolution",
               ylab = "Money") %>%
    dyOptions( drawPoints = TRUE,colors = "#FFB200", pointSize = 0.1, fillGraph = TRUE) %>%
    dyRangeSelector()
  p
}
