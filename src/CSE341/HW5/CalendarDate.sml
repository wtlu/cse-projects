(* 	CSE341
	Wei-Ting Lu 
	11/1/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW5 - This program contains implementation a structure called CalendarDate
			that can be used to represent calendar dates
*)

use "CALENDARSIG.sml";

structure CalendarDate :> CALENDARDATE = struct
	type calendarDate = {year: int, month: int, day: int};
	(*A type to represent the days in a week*)
	datatype day = Sun | Mon | Tue | Wed | Thu | Fri | Sat;

	(* Defining an exception type to raise when a date is invalid. *)
	exception IllegalDate;

	val example = {year=1979, month=9, day=19} :calendarDate; (* Sep 19, 1979 *)

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

	(*	Post: accepts three int parameters representing a year, month, and day
		returns a date representing the given year, month, and date.
		raises IllegalDate exception if the parameters represent an invalid date*)
	fun new(y, m, d) = 
		if (y < 1753) orelse (m < 1 andalso m > 12) orelse (d < 1) then raise IllegalDate
		else if d > daysInMonth({year=y, month=m, day=1}) then raise IllegalDate	
		else {year=y, month=m, day=d} : calendarDate;
		
	(* returns the date that occurs one day after that date*)
	fun next(c as {year, month, day}:calendarDate) = 
		if (daysInMonth(c) = day) then
			if (month = 12) then new(year + 1, 1, 1)
			else new(year, month + 1, 1)
		else new(year, month, day+1);
		
	(* returns the date that occurs one day before the date*)
	fun previous({year=1753, month=1, day=1}) = raise IllegalDate
	|	previous(c as {year, month, day}:calendarDate) =
		if (day = 1) then
			if (month = 1) then new(year - 1, 12, 31)
			else new (year, month - 1, daysInMonth(new(year, month - 1, day)))
		else new(year, month, day-1);

		
	(*	Pre: client will not attempt to shift to a date earlier than January 1, 1753
		Post: returns a new date that is exactly shift days away from the date passed in*)
	fun shift(c, 0) = c
	|	shift(c:calendarDate, n) = 
			if n > 0 then shift(next(c), n - 1)
			else shift(previous(c), n + 1)
		
	(*	Post: returns the number of days that separate the two dates passed in*)
	fun daysBetween(c1 as {year=y1, month=m1, day=d1}:calendarDate, 
		c2 as {year=y2, month=m2, day=d2}:calendarDate) =
		if compare(c1, c2) = GREATER then daysBetween(c2, c1)
		else if compare(c1, c2) = EQUAL then 0
		else 1 + daysBetween(next(c1), c2);
			
	(*returns a string representing that date in year/month/day format*)
	fun toString({year, month, day}:calendarDate) = 
		Int.toString(year)^"/"^Int.toString(month)^"/"^Int.toString(day);

	(* Following are extra credit*)

	(* Returns an instance of the datatype day representing the day
		of the week on which the given date falls*)
	fun dayOfWeek(c:calendarDate) = Sun;

	(*	Returns a date that reprsents the current date on which the program is being run*)
	fun today() = 
		shift({year=1970, month=1, day=1},ceil(Real.fromLargeInt(Time.toSeconds(Time.now()))/86400.0)-1);


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
	val test21 = new(2010, 9, 19);
	val test22 = new(2010, 9, 29);
end;