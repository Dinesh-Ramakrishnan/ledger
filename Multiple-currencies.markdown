# Currency Trading Accounts

Currency trading accounts allows one to keep track of currency gains and
losses at any instant of time.  This means that for any given period, the
balance sheet will change by the profit earnt during that period.  For a
fuller description of currency trading accounts and their motivation see
[here](http://www.mathstat.dal.ca/~selinger/accounting/tutorial.html#4).

We’ll start by banking 10,000 Australian dollars.

    2009/01/01 First sale
            Income:Sales                            -10000.00 AUD
            Assets:Bank                              10000.00 AUD

Now on the first of February we’ll receive a bill 1,000 euros for
Marketing.  The key point is that we route all of our currency trades
through the currency trading accounts.

    P 2009/02/01 EUR 2.00 AUD
    2009/02/01 Marketing (1 EUR = 2.00 AUD)
            Expenses:Marketing                        2000.00 AUD
            Currency:AUD                             -2000.00 AUD
            Liabilities:Accounts Payable:EUR         -1000.00 EUR
            Currency:EUR                              1000.00 EUR

Now on the 15th of February the Euro will only be worth $1.90.

    P 2009/02/15 EUR 1.90 AUD

Now let’s look at our balance sheet with the euro liability transformed
into Australian dollars.  Note that `-X` is only supported in ledger 3 or
later.

    $ ledger -X AUD -f invoice.dat bal assets liabilities
           10,000.00 AUD  Assets:Bank
           -1,900.00 AUD  Liabilities:Accounts Payable:EUR
    --------------------
            8,100.00 AUD

and the income statement

    $ ledger -X AUD -f invoice.dat bal income expenses currency
             -100.00 AUD  Currency
           -2,000.00 AUD    AUD
            1,900.00 AUD    EUR
            2,000.00 AUD  Expenses:Marketing
          -10,000.00 AUD  Income:Sales
    --------------------
           -8,100.00 AUD

The key point to note is that our “Currency” account has a profit of $100
in it.  Note that this currency gain is currently an unrealized gain.

On the first of March we’ll pay this invoice, except the euro will now be
worth $1.95.  Again note that route all of our currency conversions
through our trading account.

    P 2009/03/01 EUR 1.95 AUD
    2009/03/01 Pay Marketing Invoice (1 EUR = 1.95 AUD)
            Assets:Bank                              -1950.00 AUD
            Currency:AUD                              1950.00 AUD
            Liabilities:Accounts Payable:EUR          1000.00 EUR
            Currency:EUR                             -1000.00 EUR

Here is the balance sheet

    $ ledger -X AUD -f invoice.dat bal assets liabilities      
            8,050.00 AUD  Assets:Bank

and the income statement

    $ ledger -X AUD -f invoice.dat bal income expenses currency
              -50.00 AUD  Currency:AUD
            2,000.00 AUD  Expenses:Marketing
          -10,000.00 AUD  Income:Sales
    --------------------
           -8,050.00 AUD

As you can see our currency gain has fallen from $100 to $50 as the
exchange rate has moved again.  However at all times our balance sheet
matched our income statement.
