(* 	CSE341
	Wei-Ting Lu 
	10/4/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW1 - This program contains several short individual functions
*)

(* 	Pre: Value is integer between 1 and 12 inclusive
	Post: Returns the number of days in the month designated by
	the integer passed in. Does not account for leap year
*)
fun daysInMonth(x) = 
	if x = 2 then 28
	else if x = 4 orelse x = 6 orelse x = 9 orelse x = 11 then 30
	else 31;
	
(* 	Pre: x and y are integers, y not negative
	Post: Returns the result of raising the first integer (x) to
	power of the second (y). Note that we assume every integer 
	to the 0 power is 1
*)
fun pow(x, y) =
	if y = 0 then 1
	else x * pow(x, y - 1);
	
(* 	Pre: x is not negative
	Post: Returns the sum of the first x reciprocals
*)
fun sumTo(x) = 
	if x = 0 then 0.0
	else 1.0 / real(x) + sumTo(x - 1);
	
(* 	Pre: x is not negative
	Post: Returns a string composed of the given number (x)
	of occurrences of the string (str).
*)
fun repeat(str, x) = 
	if x = 0 then ""
	else str^repeat(str, x - 1);	
	
(* 	Pre: x is integer
	Post: Returns the number of factors of two in the number
*)
fun twos(x) = 
	if x mod 2 = 1 then 0
	else 1 + twos(x div 2);
	
	
(* 	Pre: x is integer between 1 and 12 inclusive
	Post: Returns the number of days of the year between
	1 and 365 that is represented by that month/day
*)
fun sumOfMonths(x) =
	if x = 0 then 0
	else daysInMonth(x) + sumOfMonths(x - 1);	
	
(* 	Pre: x is integer between 1 and 12 inclusive
	y is a valid number of days in a month
	Post: Returns the number of days of the year between
	1 and 365 that is represented by that month/day
*)
fun absoluteDay(x, y) = 
	y + sumOfMonths(x - 1);
	
(* 	Pre: x is integer between 1 and 12 inclusive
	Post: Returns the number of days of the year between
	1 and 365 that is represented by that month/day
*)
fun countNegative(lst) =
	if lst = nil then 0
	else if hd(lst) < 0 then 1 + countNegative(tl(lst))
	else countNegative(tl(lst));

(* 	Pre: x is valid integer
	Post: Returns the tuple where the integers in the 
	tuple is replaced by its absolute value
*)	
fun absTuple(x, y) = 
	(if x < 0 then ~x else x, if y < 0 then ~y else y);
	
(* 	Pre: lst is valid list of int * int tuples
	Post: Returns a list of int * int tuples where every 
	integer is replaced by its absolute value
*)	
fun absList(lst) = 
	if lst = nil then []
	else absTuple(hd(lst)) :: absList(tl(lst));
	
(* 	Pre: x is greater than or equal to 0
	Post: Returns a int*int tuple whose pair of integers
	sum equals the integer and which are each half of the original.
	For odd numbers, the second value should be one higher than the first
*)	
fun splitOneNum(x) =
	if x mod 2 = 0 then (x div 2, x div 2)
	else (x div 2, x div 2 + 1);

(* 	Pre: lst is valid list of int that are all 
	greater than or equal to 0
	Post: a list of the tuples obtained by splitting 
	each integer in the list into a pair of integers 
	whose sum equals the integer and which are 
	each half of the original. For odd numbers, the 
	second value should be one higher than the first
*)	
fun split(lst) = 
	if lst = nil then []
	else splitOneNum(hd(lst)) :: split(tl(lst));	

	
(*	Pre: lst is valid int
	Post: true if list is in sorted (nondecreasing)
	order, false otherwise. empty list and list of one
	element are sorted.
*)
fun isSorted(lst) =
	if lst = nil orelse length(lst) = 1 then true
	else hd(lst) < hd(tl(lst)) andalso isSorted(tl(lst));

(*	Pre: lst is valid int
	Post: returns the list obtained by collapsing successive
	pairs in the original list by replacing each pair with its sum
*)
fun collapse(lst) = 
	if lst = nil then []
	else if length(lst) = 1 then lst
	else (hd(lst) + hd(tl(lst))) :: collapse(tl(tl(lst)));

(*	Pre: lst is valid int list and sorted (nondecreasing)
			x is valid int
	Post: returns the list obtained by inserting the integer
	into the list so as to preserve sorted order
*)
fun insert(x, lst) = 
	if lst = nil then [x]
	else if hd(lst) < x then hd(lst) :: insert(x, tl(lst))
	else x :: lst;

(*	Pre: lst is valid int list
	Post: returns the list obtained by sorting
	the list into nondecreasing order
*)
fun insertionSort(lst) = 
	if lst = nil then lst
	else insert(hd(lst), insertionSort(tl(lst)));