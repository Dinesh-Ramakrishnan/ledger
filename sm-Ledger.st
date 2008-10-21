"
prototype ledger file parser in squeak
Simon Michael

test scripts:

s1 := LedgerParserTests sample1 readStream
PositionableStream
2007/10/7 the fairmont sonoma mission inn & spa
    expenses:food:dining  $11
    expenses:gifts:so  $10.55
    assets:wells-fargo:checking  $-21.55

p := LedgerParser on: LedgerParserTests sample1
s1 reset
p parseWith: p accountname 'ab'
p parseWith: p description
p parseWith: p descriptionline
p parseWith: p transactionline
p parseWith: p entry
p parseWith: p ledgerfile
p parse
(p parse2: s1)
p:= LedgerParser on: '  c
'.
p s match: p space and: p accountname andMaybe: '2' action: [:m|m]

LedgerParser parse: '2007/10/1 some description
  a:b  $10
  c

' with: #entry
"


Object subclass: #Amount
	instanceVariableNames: 'currency quantity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!Amount commentStamp: 'sm 10/15/2007 06:08' prior: 0!
I represent the amount transferred in one LedgerTransaction.

Instance Variables
	currency:		the currency - $, euro, bricks, GOOG, zorkmoids
	quantity:		the amount.
!


!Amount methodsFor: 'accessing' stamp: 'sm 10/15/2007 06:20'!
currency
	^ currency! !

!Amount methodsFor: 'accessing' stamp: 'sm 10/15/2007 06:21'!
currency: aCurrency
	currency := aCurrency! !

!Amount methodsFor: 'accessing' stamp: 'sm 10/15/2007 06:21'!
quantity
	^ quantity! !

!Amount methodsFor: 'accessing' stamp: 'sm 10/15/2007 06:21'!
quantity: aQuantity
	quantity := aQuantity! !


!Amount methodsFor: 'arithmetic' stamp: 'sm 10/15/2007 06:34'!
+ operand
	^ Amount currency: self currency quantity: self quantity + operand quantity

	! !

!Amount methodsFor: 'arithmetic' stamp: 'sm 10/15/2007 12:06'!
negated
	^ Amount currency: currency quantity: quantity negated! !


!Amount methodsFor: 'comparing' stamp: 'sm 10/15/2007 11:54'!
= operand
	^ self currency = operand currency & (self quantity = operand quantity)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Amount class
	instanceVariableNames: ''!

!Amount class methodsFor: 'instance creation' stamp: 'sm 10/15/2007 06:23'!
currency: aCurrencyOrSymbol quantity: aQuantity
	^ self new currency: (Currency lookup: aCurrencyOrSymbol); quantity: aQuantity! !

!Amount class methodsFor: 'instance creation' stamp: 'sm 10/15/2007 12:38'!
zero
	^ self currency: #'$' quantity: 0! !


Symbol subclass: #Currency
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!Currency commentStamp: 'sm 10/15/2007 06:08' prior: 0!
I identify the currency of a LedgerTransaction!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Currency class
	instanceVariableNames: ''!

!Currency class methodsFor: 'instance creation' stamp: 'sm 10/15/2007 06:16'!
named: aCurrencySymbol
	^ self lookup: aCurrencySymbol! !


Object subclass: #Ledger
	instanceVariableNames: 'entries'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!Ledger commentStamp: 'sm 10/14/2007 13:52' prior: 0!
I represent a financial ledger, in the style of http://newartisans.com/software/ledger.html (let's call that jwledger). I can parse (simplified) jwledger files and answer queries about the data therein. The home page for this project would be http://joyful.com/Ledger .!


!Ledger methodsFor: 'accessing' stamp: 'sm 10/14/2007 02:39'!
entries
	"Answer the value of entries"

	^ entries! !

!Ledger methodsFor: 'accessing' stamp: 'sm 10/14/2007 02:39'!
entries: anObject
	"Set the value of entries"

	entries := anObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Ledger class
	instanceVariableNames: ''!

!Ledger class methodsFor: 'instance creation' stamp: 'sm 10/14/2007 13:28'!
withEntries: entries
	^ self new entries: entries! !


Object subclass: #LedgerDocs
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!LedgerDocs commentStamp: 'sm 10/14/2007 17:41' prior: 0!
Readmes, todo lists etc. for the Ledger package. See the class side.!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LedgerDocs class
	instanceVariableNames: ''!

!LedgerDocs class methodsFor: 'documentation' stamp: 'sm 10/15/2007 12:42'!
README ^ '
A Squeak port of ledger, see http://joyful.com/Ledger for more.
'! !


Object subclass: #LedgerEntry
	instanceVariableNames: 'date description transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!LedgerEntry commentStamp: 'sm 10/14/2007 17:48' prior: 0!
I represent a balanced entry in a Ledger. All my transactions add up to 0.!


!LedgerEntry methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:31'!
date
	"Answer the value of date"

	^ date! !

!LedgerEntry methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:31'!
date: anObject
	"Set the value of date"

	date := anObject! !

!LedgerEntry methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:31'!
description
	"Answer the value of description"

	^ description! !

!LedgerEntry methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:31'!
description: anObject
	"Set the value of description"

	description := anObject! !

!LedgerEntry methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:31'!
transactions
	"Answer the value of transactions"

	^ transactions! !

!LedgerEntry methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:31'!
transactions: anObject
	"Set the value of transactions"

	transactions := anObject! !


!LedgerEntry methodsFor: 'updating' stamp: 'sm 10/15/2007 12:41'!
autoBalance
	"Fill in my missing amount when there is exactly one omitted. Return
	myself mutated, or nil if there are too many amounts left blank."
	| normals blanks |
	normals := self transactions
				select: [:t | t amount notNil].
	blanks := self transactions
				select: [:t | t amount isNil].
	blanks size = 0
		ifTrue: [^ self].
	blanks size = 1
		ifTrue: [blanks first amount: (normals
					inject: Amount zero
					into: [:sum :t | sum + t amount]) negated.
			^ self].
	^ nil! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LedgerEntry class
	instanceVariableNames: ''!

!LedgerEntry class methodsFor: 'creation' stamp: 'sm 10/15/2007 12:39'!
withDate: dateString description: descriptionString
	"Create an instance with this date and description"
	^ self new date: dateString;
		 description: descriptionString! !


Object subclass: #LedgerParser
	instanceVariableNames: 's p'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!LedgerParser commentStamp: 'sm 10/15/2007 04:34' prior: 0!
I parse a ledger file stream and return a Ledger.

For ledger file format examples, see LedgerParserTests.
Here is the (simplified) grammar:

ledgerfile = entry*
entry = descriptionline, transactionline+
descriptionline = date, space, description, newline
transactionline = space, accountname, space, amount, newline
accountname = string [:, string]*
amount = currency, quantity
currency = $
quantity = number

Methods in the parsers category return MEPS parsers. 
I use an instance variable p as a self alias for greater readability.
I keep the stream I am parsing in instance var s.

Here are more MEPS notes.

MEPS parses a PositionableStream. To do this it uses

parsers
a MEPS parser is anything that handles from:startingWith:
namely a character, string, regex, or block.
When applied to a stream, if it matches what's next,
it returns some value (typically itself or a list),
if it doesn't match, it returns nil.

I don't fully understand block parsers.
It should take no args, and evaluate to...
It's a way to delay application of a parser...

parser combining methods
these are helper methods which combine parsers in various patterns of and, or, maybe. 
Each pattern must have a method defined for it; many are provided.
if the combined parse succeeds, they call the action block with the parse result, otherwise return nil

imperative code
parse logic can also be added via additional imperative code

unlike true parser combinators, you can't simply combine parsers into a parser
you must mix parsers with parser combining methods or other imperative code
you can sort of fake it using blocks ?
!
]style[(613 994)f2,f2c255136000!


!LedgerParser methodsFor: 'accessing' stamp: 'sm 10/15/2007 01:21'!
s
	^ s! !

!LedgerParser methodsFor: 'accessing' stamp: 'sm 10/15/2007 01:21'!
s: aStream
	s := aStream! !


!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 12:25'!
accountleafname
	"match an account leaf name, which is a word or single-spaced
	phrase not containing : or newline
	
	a
	a aa 
	"
	^ [s
		matchWhileTrue: [:c | c ~= $: & (c ~= Character cr) & (c ~= Character space | (s peek ~= Character space))]
		action: [:m | m]]! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 03:58'!
accountname
	"match a possibly compound account name"
	^ [s
		matchOneOrMore: p accountleafname
		separatedBy: $:
		action: [:as | 
			(as
				inject: ''
				into: [:name :a | name , ':' , a]) allButFirst]]! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 12:07'!
amount
	"match a ledger transaction amount
	$-10.32
	$1"
	^ [s
		match: '$'
		and: '-?\d+(\.\d+)?' regex
		action: [:m | 
			Amount
				currency: m first asSymbol
				quantity: (Float readFrom: m second)]]! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 01:30'!
cr
	^ Character cr asString.
! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 01:30'!
date 
	^ '(\d\d\d\d)/(\d\d?)/(\d\d?)' regex
! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 04:24'!
description
	"match a ledger entry description: at least one word character, and everything else to the end of the line"
	^ ('(\w' , p notcr , '*)') regex.
! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 12:29'!
descriptionline
	"match the description line of a ledger entry, returning a (incomplete)
	LedgerEntry 
	
	2007/10/1 blah bl
	"
	^ [s
		match: p date
		and: p space
		and: p description
		and: p cr
		action: [:m | LedgerEntry withDate: m first description: m third]]! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 12:31'!
entry
	"match one ledger entry, including surrounding whitespace
	-> LedgerEntry 
	
	
	2007/10/1 the description
	account:a $10.00
	account:b $-10
	
	
	"
	^ [s
		match: p descriptionline
		and: p transactionlines2
		and: p cr
		action: [:l | (l first transactions: l second) autoBalance]]! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 04:23'!
ledger
"match a complete ledger file"
	^ [s matchZeroOrMore: p entry action: [:l | Ledger withEntries: l]].
! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 01:37'!
notcr
	^ '[^' , p cr , ']'! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 01:30'!
space
	^ ' +' regex
! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 01:30'!
space2
	^ '  +' regex
! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 12:32'!
transactionline
	"match one ledger transaction line, possibly with no amount ->
	LedgerTransaction 
	
	some:account  $10.
	"
	^ [s
		match: p space
		and: p accountname
		andMaybe: [s
				match: p space
				andMaybe: p amount
				action: [:m | m second]]
		and: p cr
		action: [:l | LedgerTransaction withAccount: l second amount: l third]]! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 04:37'!
transactionlines1
"match one or more ledger transaction lines -> { LedgerTransaction }

    some:account  $10.00
"
	^ [s
		matchOneOrMore: p transactionline
		action: [:l | l]].! !

!LedgerParser methodsFor: 'parsers' stamp: 'sm 10/15/2007 04:40'!
transactionlines2
"match two or more ledger transaction lines -> { LedgerTransaction }

    some:account  $10.00
    another        $20
"
	^ [s
		match: p transactionline
		and: p transactionlines1
		action: [:l | {l first}, l second]].! !


!LedgerParser methodsFor: 'initialize-release' stamp: 'sm 10/15/2007 01:42'!
initialize
	super initialize.
	p := self
	! !


!LedgerParser methodsFor: 'parsing' stamp: 'sm 10/15/2007 12:23'!
parse
	"parse my stream as a ledger file. This is version 2, one instance method per parse rule"
	^ s match: p ledger! !

!LedgerParser methodsFor: 'parsing' stamp: 'sm 10/15/2007 02:29'!
parseWith: parser
	"parse my current stream with parser, updating position and returning the value if it succeeds."
	^ s match: parser! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LedgerParser class
	instanceVariableNames: ''!

!LedgerParser class methodsFor: 'parsing' stamp: 'sm 10/15/2007 12:21'!
parse1: aStream 
	"parse a ledger file. The first, one-method version."
	| space space2 cr notcr date description descriptionline accountname amount transactionline transactionlines entry ledger spaceandamount |
	space := ' +' regex.
	space2 := '  +' regex.
	cr := Character cr asString.
	notcr := '[^' , cr , ']'.
	date := '(\d\d\d\d)/(\d\d?)/(\d\d?)' regex.
	description := ('(\w' , notcr , '*)') regex.
	accountname := ('[^: ' , cr , ']+(:[^: ' , cr , ']+)*') regex.
	amount := '\$\d+(\.\d+)?' regex.
	descriptionline := [aStream
				match: date
				and: space
				and: description
				and: cr
				action: [:l | LedgerEntry withDate: l first description: l third]].
	spaceandamount := [aStream
				match: space2
				and: amount
				action: [:l | l]].
	transactionline := [aStream
				match: space
				and: accountname
				andMaybe: spaceandamount
				and: cr
				action: [:l | LedgerTransaction withAccount: l second amount: l fourth]].
	transactionlines := [aStream
				matchOneOrMore: transactionline
				action: [:l | l]].
	entry := [aStream
				match: descriptionline
				and: transactionlines
				and: cr
				action: [:l | l first transactions: l second]].
	ledger := aStream
				matchZeroOrMore: entry
				action: [:l | Ledger withEntries: l].
	^ ledger! !

!LedgerParser class methodsFor: 'parsing' stamp: 'sm 10/15/2007 12:23'!
parse: string with: parserSelector 
	| p |
	p := LedgerParser on: string.
	^ p
		parseWith: (p perform: parserSelector)! !


!LedgerParser class methodsFor: 'instance creation' stamp: 'sm 10/15/2007 12:19'!
on: aStreamOrSequencableCollection 
	^ self new s: aStreamOrSequencableCollection readStream! !


TestCase subclass: #LedgerParserTests
	instanceVariableNames: ''
	classVariableNames: 'P'
	poolDictionaries: ''
	category: 'sm-Ledger'!
!LedgerParserTests commentStamp: 'sm 10/15/2007 12:18' prior: 0!
Tests of ledger parsing!


!LedgerParserTests methodsFor: 'testing' stamp: 'sm 10/15/2007 13:03'!
testAccountleafname
	self assert: [(LedgerParser
		parse: 'a'
		with: #accountleafname)
		= 'a'].
	self assert: [(LedgerParser
		parse: 'a a a'
		with: #accountleafname)
		= 'a a a'].
	self assert: [(LedgerParser
		parse: 'a  a'
		with: #accountleafname)
		= 'a'].
	self assert: [(LedgerParser
		parse: 'a:a'
		with: #accountleafname)
		= 'a'].! !

!LedgerParserTests methodsFor: 'testing' stamp: 'sm 10/15/2007 12:15'!
testAccountname
	self assert: [(LedgerParser
		parse: 'a'
		with: #accountname)
= 'a'].
	self
		assert: [(LedgerParser parse: 'a:b'
		with: #accountname)
= 'a:b'].
	self
		assert: [(LedgerParser parse: 'a a:b:c'
		with: #accountname)
= 'a a:b:c'].
	self
		assert: [(LedgerParser parse: 'a  a:b:c'
		with: #accountname)
		= 'a']! !

!LedgerParserTests methodsFor: 'testing' stamp: 'sm 10/15/2007 11:53'!
testAmount
	self
		assert: [| p | 
			p := LedgerParser on: '$1'.
			(p parseWith: p amount) = (Amount currency: #'$' quantity: 1.0)
			].
	self
		assert: [| p | 
			p := LedgerParser on: '$13.00'.
			(p parseWith: p amount)
				= (Amount currency: #'$' quantity: 13.0)].
	self
		assert: [| p | 
			p := LedgerParser on: '$-2'.
			(p parseWith: p amount)
				= (Amount currency: #'$' quantity: -2.0)]! !

!LedgerParserTests methodsFor: 'testing' stamp: 'sm 10/15/2007 12:11'!
testDescriptionline
	self
		assert: [(LedgerParser parse: '2007/10/1 some description
' with: #descriptionline) class = LedgerEntry]! !

!LedgerParserTests methodsFor: 'testing' stamp: 'sm 10/15/2007 12:15'!
testEntry
	| e a |
	self
		assert: [(LedgerParser parse: '2007/10/1 some description
  a:b  $10
  c    $-20.00

' with: #entry) class = LedgerEntry].
	e := LedgerParser parse: '2007/10/1 some description
  a:b  $10
  c

' with: #entry.
	self
		assert: [e class = LedgerEntry].
	self
		assert: [e transactions last account = 'c'].
	a := e transactions last amount.
	self
		assert: [a currency = #'$'].
	self
		assert: [a quantity = -10.0].
	self
		assert: [(LedgerParser parse: '2007/10/1 some description
  a:b  $10

' with: #entry)
				= nil]! !

!LedgerParserTests methodsFor: 'testing' stamp: 'sm 10/15/2007 12:12'!
testLedger
	| l |
	l := LedgerParser parse: LedgerParserTests sample1 with: #ledger.
	self
		assert: [l class = Ledger].
	self
		assert: [l entries size = 4].
	self
		assert: [(l entries
				inject: 0
				into: [:sum :e | sum + e transactions size])
				= 11]! !

!LedgerParserTests methodsFor: 'testing' stamp: 'sm 10/15/2007 12:12'!
testTransactionline
	self
		assert: [(LedgerParser parse: '  a:b  $10
' with: #transactionline) class = LedgerTransaction]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LedgerParserTests class
	instanceVariableNames: ''!

!LedgerParserTests class methodsFor: 'sample data' stamp: 'sm 10/15/2007 04:22'!
sample1
	^ 
'2007/10/7 the fairmont sonoma mission inn & spa
    expenses:food:dining  $11
    expenses:gifts:so  $10.55
    assets:wells fargo:checking  $-21.55

2007/10/7 the fairmont sonoma mission inn & spa
    expenses:food:dining  $23
    expenses:gifts:so  $22.26
    assets:wells fargo:checking  $-25.26

2007/10/7 longs drugs
    expenses:business:phone  $20
    assets:cash   $50
    assets:wells fargo:checking  $-70

2007/10/8 arco
    expenses:transportation:fuel  $38.85
    assets:wells fargo:checking  $-38.85

'! !


TestCase subclass: #LedgerTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!LedgerTests commentStamp: 'sm 10/15/2007 12:18' prior: 0!
Tests for most of the Ledger classes!


!LedgerTests methodsFor: 'testing-Ledger' stamp: 'sm 10/14/2007 22:20'!
testLedger
	| l |
	l := Ledger withEntries: {LedgerEntry new. LedgerEntry new}.
	self
		assert: [l entries size = 2].
! !


!LedgerTests methodsFor: 'testing-LedgerEntry' stamp: 'sm 10/14/2007 22:00'!
testLedgerEntry
	| e |
	e := LedgerEntry withDate: '2007/1/1' description: 'description'.
	self assert: [e date = '2007/1/1'].
	self assert: [e description = 'description'].
	! !


!LedgerTests methodsFor: 'testing-LedgerTransaction' stamp: 'sm 10/14/2007 22:20'!
testLedgerTransaction
	| t |
	t := LedgerTransaction withAccount: 'account' amount: 'amount'.
	self assert: [t account = 'account'].
	self assert: [t amount = 'amount']! !


Object subclass: #LedgerTransaction
	instanceVariableNames: 'account amount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!LedgerTransaction commentStamp: 'sm 10/14/2007 01:35' prior: 0!
I represent a flow of currency or commodity to one account, forming part of a ledger entry.!


!LedgerTransaction methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:32'!
account
	"Answer the value of account"

	^ account! !

!LedgerTransaction methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:32'!
account: anObject
	"Set the value of account"

	account := anObject! !

!LedgerTransaction methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:32'!
amount
	"Answer the value of amount"

	^ amount! !

!LedgerTransaction methodsFor: 'accessing' stamp: 'sm 10/14/2007 01:32'!
amount: anObject
	"Set the value of amount"

	amount := anObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LedgerTransaction class
	instanceVariableNames: ''!

!LedgerTransaction class methodsFor: 'instance creation' stamp: 'sm 10/14/2007 13:29'!
withAccount: s1 amount: s2 
	"Create a transaction of specified amount to this account"
	^ self new account: s1;
		 amount: s2! !


ScaledDecimal subclass: #Quantity
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'sm-Ledger'!
!Quantity commentStamp: 'sm 10/15/2007 12:18' prior: 0!
The numeric quantity of an Amount. Just a Float now, probably a ScaledDecimal later.!
