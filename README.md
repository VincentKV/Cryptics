# Cryptics

![GitHub Logo](/images/banner.png)

## Installation
Prior to download this package, make sure you have devtools installed :
```
install.packages("devtools")
library(devtools)
```
Then, download the package :
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

## Cryptocurrency course

Get the daily data (Open, High, Low, Close, Adjusted, Volume) of a particular cryptocurrency from its creation until today. Returns a time series.
![GitHub Logo](/images/cryptocourse1.png)

The default is Bitcoin in US Dollar.
![GitHub Logo](/images/cryptocourse2.png)
