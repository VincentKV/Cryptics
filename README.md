# Cryptics

![GitHub Logo](/images/banner.png)

## Installation
Prior to download this package, make sure you have devtools installed and loaded :
```
install.packages("devtools")
library(devtools)
```
Then, download and load the package :
```
install_github("VincentKV/Cryptics")
library(Cryptics)
```
## Functions

### Symbol check

If you want to check that a cryptocurrency is supported by the package, you need to type in its symbol. For example, "BTC" for Bitcoin. 
![GitHub Logo](/images/symbolcheck1new.png)

If you are not sure about the exact symbol, symbolcheck() provides you suggestions.
![GitHub Logo](/images/symbolcheck2new.png)

### View all cryptocurrencies

You can also visualize all the cryptocurrencies supported by the Cryptics package, and sort the columns alphabetically for a quicker search.
![GitHub Logo](/images/viewall1.png)

### Cryptocurrency course

Get the daily data (Open, High, Low, Close, Adjusted, Volume) of a particular cryptocurrency from its creation until today. Returns a time series.
![GitHub Logo](/images/cryptocourse1.png)

### Coin tracker graph

Plot an interactive graph with the historical data of your portfolio.
![GitHub Logo](/images/cointrackcommand.png)
![GitHub Logo](/images/cointrack.png)

The default is Bitcoin in US Dollar.
![GitHub Logo](/images/cryptocourse2.png)

### Normalized cryptocurrency course

Normalize a course between 0 and 1 to easily compare cryptocurrencies and work with percentages. The values taken are the "Opens". 1 is the all-time-high. Returns a time series.
![GitHub Logo](/images/normalizedcourse.png)

### Return on investment

Compute the simple gain or loss given a specific cryptocurrency and a particular amount of money invested in it during a period of time. Currency does not matter. 20 euros (or dollars...) invested in Litecoin on 2021-01-01 would be 31.69 euros on 2021-04-01.
![GitHub Logo](/images/invest1.png)

The default is Bitcoin with today as end date. 20 euros invested in Bitcoin on 2021-02-01 would be 327.52 euros today.
![GitHub Logo](/images/invest2.png)

### Historical data graph

Plot an interactive graph with the normalized historical data of a single cryptocurrency. The default is Bitcoin in US Dollar. USD is advised as there is more data in this currency.
![GitHub Logo](/images/historiccommand.png)
![GitHub Logo](/images/historic.png)

### Wallet 

The wallet is the perfect way to keep track on an investment.
Compute the time series of earnings and losses given a specific cryptocurrency and a particular amount of money invested in it during a period of time. The default is Bitcoin with today as end date. 
![GitHub Logo](/images/wallet.png)

### Portfolio

The portfolio takes the list of your wallets and compute the time series of your total earnings and losses.
![GitHub Logo](/images/portfolio.png)
