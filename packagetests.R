library(devtools)
install_github("VincentKV/Cryptics")
library(Cryptics)
symbolCheck("BTC")

cryptoCourse(symbol="TRX",currency="GBP")
normalizedCourse(cryptoCourse(symbol="LTC",currency="EUR"))
historic(symbol="LTC",currency="GBP")
#candlesticks(symbol="LTC",currency="GBP",start="2019-09-01",end="2020-02-10")
viewAllCryptos()
invest(amount=20,start="2019-02-01")
invest(symbol="LTC",amount=20,start="2021-01-01",end="2021-04-01")
historic()


my_wallet=wallet(symbol="LTC",currency="USD",amount=20,start="2021-01-01",end="2021-04-01")

my_portfolio=portfolio(list(wallet(symbol = "TRX",amount = 20,start = "2021-01-01"),
                            wallet(symbol = "BTC",amount = 30,start = "2020-07-01",end = "2021-02-01"),
                            wallet(symbol = "LTC",amount = 25,start = "2021-03-01")))
cointrack(my_portfolio)
