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
			
val example = {year=1979, month=9, day=19} :calendarDate; (* Sep 19, 1979 *)
val test1 = new(2010, 10, 31);
val test2 = new(2010, 3, 20);
val test3 = new(2011, 8, 11);
val test4 = new(2010, 10, 29);
val test5 = new(2010, 20, 30);