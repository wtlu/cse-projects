(* 	CSE341
	Wei-Ting Lu 
	11/1/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW5 - This program contains implementation a structure called CalendarDate
			that can be used to represent calendar dates
*)

type calendarDate = {year: int, month: int, day: int};
(*A type to represent the days in a week*)
datatype day = Sun | Mon | Tue | Wed | Thu | Fri | Sat;

(* Defining an exception type to raise when a date is invalid. *)
exception IllegalDate;

val example = {year=1979, month=9, day=19} :calendarDate; (* Sep 19, 1979 *)

(*	Post: accepts three int parameters representing a year, month, and day
	returns a date representing the given year, month, and date.
	raises IllegalDate exception if the parameters represent an invalid date*)
fun new(y, m, d) = 
	if (y < 1753) orelse (m < 1 andalso m > 12) then raise IllegalDate
	else if m = 2 andalso d > 29 then raise IllegalDate
	else if (m = 4 orelse m = 6 orelse m = 9 orelse m = 11) andalso d > 30 then raise IllegalDate
	else if d > 31 orelse d < 1 then raise IllegalDate
	else {year=y, month=m, day=d} : calendarDate;
	
(*	Pre: valid calendarDate
	Post: returns a value of type order indicating whether the first date
	comes ealier or later than the second date. Returns equal if they are the same*)
fun compare(c1 as {year=y1, month=m1, day=d1}:calendarDate, 
	c2 as {year=y2, month=m2, day=d2}:calendarDate) =
		if y1 < y2 then LESS
		else if y1 > y2 then GREATER
		else 
			if m1 < m2 then LESS
			else if m1 > m2 then GREATER
			else
				if d1 < d2 then LESS
				else if d1 > d2 then GREATER
				else EQUAL

(*	Post: returns the number of days that separate the two dates passed in*)
fun daysBetween(c1 as {year=y1, month=m1, day=d1}:calendarDate, 
	c2 as {year=y2, month=m2, day=d2}:calendarDate) =
		if compare(c1, c2) = LESS then daysBetween(c2, c1)
		else 0;
		
(* Post: returns true if that date takes place during a leap year, false otherwise*)
fun isLeapYear({year, month, day}:calendarDate) =
	if (year mod 4 = 0) then
		if (year mod 100 = 0) andalso (year mod 400 = 0) then true
		else if (year mod 100 = 0) then false
		else true
	else false;		
	
(* Returns how many days are in the given month in the date*)
fun daysInMonth(c as {year, month=2, day}:calendarDate) = 
	if isLeapYear(c) then 29 else 28
|	daysInMonth({year, month, day}:calendarDate) = 
		if month = 4 orelse month = 6 orelse month = 9 orelse month = 11 then 30
		else 31;

(* Returns how many days are in the given year in the date*)
fun daysInYear(c as {year, month, day}:calendarDate) = 
	if isLeapYear(c) then 366 else 365;

(*returns a string representing that date in year/month/day format*)
fun toString({year, month, day}:calendarDate) = 
	Int.toString(year)^"/"^Int.toString(month)^"/"^Int.toString(day);

val example = {year=1979, month=9, day=19} :calendarDate; (* Sep 19, 1979 *)
val test1 = new(2010, 10, 31);
val test2 = new(2010, 3, 20);
val test3 = new(2011, 8, 11);
val test4 = new(2010, 10, 29);
val test5 = new(2010, 20, 30);
val test6 = new(2011, 1, 1);
val test7 = new(2012, 2, 2);
val test8 = new(2012, 3, 3);
val test9 = new(2012, 4, 5);
val test10 = new(2012, 5, 6);
val test11 = new(2012, 6, 7);
val test12 = new(2012, 7, 7);
val test13 = new(2012, 8, 8);
val test14 = new(2012, 9, 8);
val test15 = new(2012, 10, 8);
val test16 = new(2012, 11, 8);
val test17 = new(1998, 12, 25);
val test18 = new(1996, 1, 1);
val test19 = new(2004, 2, 2);
val test20 = new(1900, 3, 30);
