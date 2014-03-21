%Charles Teese
%Principals of Programming Languages
%HW6

%Problem 1
%a 
dupList([], []).%if it is an empty list, then it should return an empty list.
dupList([Head| Tail], DupList) :-%duplicates each item in the list
	append([Head], [Head], Heads),%creates a list countaining the Head of the list twice
	dupList(Tail, Dups),%recusivly calls dupList on the tail of the list
	append(Heads, Dups, DupList).%creates a list with all of the original list values duplicated. 

%b 
dupItem(List, DupList, 1):-%returns the item unchanged
	append(List, [], DupList).
dupItem([Item|Rest], List, Num) :-%takes an item and duplicates it a specified number of times
	Num > 1,%verifies that we don't dup items more than the specified number of times
	Next is Num - 1,%sets next num for recursion
	dupList([Item], DupedItem),%duplicates the first item of the list
	append(Rest, DupedItem, NewList),%adds teh duplicated item to the list of items that are all teh same item
	dupItem(NewList, List, Next).%recurs to next step of duplication 

dupListTimes([], [], _).%if the list is empty, then there is nothing to duplicate 
dupListTimes([Head | Tail], DupedList, Num) :-%duplicates each item in the list a certain number of times.
	dupItem([Head], DupedItem, Num),%duplicates the first item in the list Num times
	dupListTimes(Tail, NextDupLists, Num),%recusivly calls dupListTimes on the rest of the list
	append(DupedItem, NextDupLists, DupedList).%combines all of the lists of duplicated items



%Problem 3

%states each month and how many days it has
month(january, 31).
month(feburary, 28).
month(march, 31).
month(april, 30).
month(may, 31).
month(june, 30).
month(july, 31).
month(august, 31).
month(september, 30).
month(october, 31).
month(november, 30).
month(december, 31).

%states what the next consecutive month is
next_month(january, feburary).
next_month(feburary, march).
next_month(march, april).
next_month(april, may).
next_month(may, june).
next_month(june, july).
next_month(july, august).
next_month(august, september).
next_month(september, october).
next_month(october, november).
next_month(november, december).
next_month(december, january).

%states what the next consecutive day of the week is
next_day_of_week(sunday, monday).
next_day_of_week(monday, tuesday).
next_day_of_week(tuesday, wednesday).
next_day_of_week(wednesday, thursday).
next_day_of_week(thursday, friday).
next_day_of_week(friday, saturday).
next_day_of_week(saturday, sunday).

%calulates if Year is a leap year
leap_year(Year) :-
	(0 is mod(Year, 100)) %if is new century, then only leap if divisible by 400. otherwise only leap if divisible by 4.
		-> 
		(0 is mod(Year, 400))
		; 
		(0 is mod(Year, 4)). 


next_day(DayOfWeek, Month, Day, Year, NextDayOfWeek, NextMonth, NextDay, NextYear) :-%finds the next consecutive day of the week and month, month, and year.
	next_day_of_week(DayOfWeek, NextDayOfWeek),%gets next day of the week
	((Month = feburary -> leap_year(Year)) %checks for leap year and compensates for it
		-> 
		Days = 29 
		;
		month(Month, Days)
	),
	((Day < Days) %finds next day of month, month, and year
		-> %verifies day does not exced the number of days in the current month 
		NextDay is Day + 1,%incrses day num by one, keeps month and year the same
		NextMonth = Month,
		NextYear = Year
		;%moves to next month and possibly next year
		NextDay = 1,%resets day count to 1
		next_month(Month, NextMonth),%finds next month
		(NextMonth = january %checks if is end of year
			-> 
			NextYear is Year + 1 %goes to next year
			;
			NextYear = Year%keeps same year
		)
	).

countSundays(CurrNumSundays, EndNumSundays, _, december, 31, 2000) :-%stops countSundays on the chosen end date 
	EndNumSundays = CurrNumSundays.
countSundays(CurrNumSundays, NewNumSundays, DayOfWeek, Month, Day, Year) :-%counts the number of sundays that land on the first of the month between two given dates.
	Year < 2001,%makes sure that we do not calculate sundays that are not in the range we are looking at 
	next_day(DayOfWeek, Month, Day, Year, NextDayOfWeek, NextMonth, NextDay, NextYear),%finds the next day
	((NextDayOfWeek = sunday -> Day =:= 1) %checks if next day is a sunday and the first of a month. 
		-> %if so, then increment NextNumSundays
		NextNumSundays is CurrNumSundays + 1
		;%otherwise keep the same
		NextNumSundays = CurrNumSundays
	),
	countSundays(NextNumSundays, NewNumSundays, NextDayOfWeek, NextMonth, NextDay, NextYear).%recurs till date specified in base case

euler19(Sundays) :-%finds the number of sundays that land on the first of the month between Januaray 1, 1901 and December 31, 2000
	countSundays(0, Sundays, monday, january, 1, 1901).



%Problem 4

%colors of the houses
color(yellow).
color(blue).
color(red).
color(ivory).
color(green).

%nationalities of the people who live in the hourses
nationality(norwegian).
nationality(ukrainian).
nationality(englishman).
nationality(spaniard).
nationality(japanese).

%beverage that the owners of the houses drink
beverage(water).
beverage(tea).
beverage(milk).
beverage(orange_juice).
beverage(coffee).

%cigarettes that the owners of the houses smoke
cigarettes(kools).
cigarettes(old_gold).
cigarettes(lucky_strike).
cigarettes(parliament).
cigarettes(chesterfield).

%pets at the different houses
pet(fox).
pet(horse).
pet(snails).
pet(dog).
pet(zebra).

house(Color, Nationality, Beverage, Cigarettes, Pet) :- %verifies that a house has the one of each property  
	color(Color),
	nationality(Nationality),
	beverage(Beverage),
	cigarettes(Cigarettes),
	pet(Pet).

check_next_to(House1, House2, Houses) :-%checks for House2 being to the right of House1
	check_next_to_right(House1, House2, Houses).
check_next_to(House1, House2, Houses) :-%checks for House2 being to the left of House1
	reverse(Houses, HousesR),
	check_next_to_right(House1, House2, HousesR).

check_next_to_right(House1, House2, [House1|[House2|_]]).
check_next_to_right(House1, House2, [_|[Head2|Tail]]) :-%checks if House2 is just to the right of House1, but not to the left
	check_next_to_right(House1, House2, [Head2|Tail]).

rule([House1|_], House1).
rule([_| Tail], House1) :-%says that some house has the properties of House1
	rule(Tail, House1).

zebraPuzzle(Houses) :- %Solves the Zebra Puzzle
	Houses = [house(_, norwegian, _,	_, _),
			  house(_, _, _,	_, _),
			  house(_, _, milk, _, _),
			  house(_, _, _, _, _),
			  house(_, _, _, _, _)],%verifies that there are 5 houses and sets ordering rules about the houses

	%sets rules about houses next to each other 
	check_next_to(house(_, _, _, kools, _), house(_, _, _, _, horse), Houses),
	check_next_to(house(_, _, _, chesterfield, _), house(_, _, _, _, fox), Houses),
	check_next_to_right(house(ivory, _, _, _, _), house(green, _, _, _, _), Houses),
	check_next_to(house(_, norwegian, _, _, _), house(blue, _, _, _, _), Houses),

	%sets rules about sertain houses 
	rule(Houses, house(red, englishman, _, _, _)),
	rule(Houses, house(_, spaniard, _, _, dog)),
	rule(Houses, house(green, _, coffee, _, _)),
	rule(Houses, house(_, ukrainian, tea, _, _)),
	rule(Houses, house(_, _, _, old_gold, snails)),
	rule(Houses, house(yellow, _, _, kools, _)),
	rule(Houses, house(_, _, orange_juice, lucky_strike, _)),
	rule(Houses, house(_, japanese, _, parliament, _)),
	rule(Houses, house(_, _, water, _, _)),
	rule(Houses, house(_, _, _, _, zebra)).


