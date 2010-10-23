(* 	CSE341
	Wei-Ting Lu 
	10/20/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW3 - This program contains several short individual functions
*)

use "utility.sml";

(* Defining an exception type to raise when a number is out of range. *)
exception OutOfRange

(* a << b = x times 2 raised to the b power. *)
infix <<;

fun a << b = 
	if b < 0 then raise OutOfRange
	else let 
		(* 	Pre: y is non-negative integer
			Post: Returns the result of raising 2 to
			power of the (y).
		*)
		fun pow2(0) = 1
		|	pow2(y) = 2 * pow2(y - 1)
	in
		a * pow2(b)
	end;

(* 
list1 ~~ list2 produces a new list whose elements come 
from list1 and list2 in alternating order 
*)
infix ~~;

fun list1 ~~ [] = list1
|	[] ~~ list2 = list2
|	(first1::rest1) ~~ (first2::rest2) = [first1, first2] @ (rest1 ~~ rest2);

(*test values delete when done*)
val testa = [1,2,3];
val testb = [4,5,6];
val testc = [8,6];
val testd = [3,9,1,7];
val teste = [12,2,4,0];
val testf = [5];
val testg = [3,17,~9,34,~7,2];
val testh = [1,3,~8,14,0,7,~22,45];
val testi = ["what", "you", "see", "is", "what", "you", "get"];
val testj = ["there", "ain't", "no", "such", "thing", "as", "a", "free", "lunch"];
val testk = ["four", "score", "and", "seven", "years", "ago"];

(*takes two integers k and n and produce list of first k multiples of n*)
fun multiples(k, n) = mapx( fn x => (x*n), 1--k);

(* 	Pre: x is not negative or 0
	Post: Returns the sum of the first x reciprocals
*)
fun sumTo(x) = reduce( op +, mapx(fn n => (1.0/ real(n)), 1--x));

(* 	Pre: lst is valid int list
	Post: Produces a count of number of negative integers in given lst
*)
fun countNegative(lst) = length(filterx(fn x => (x<0), lst));

(* 	Pre: m and n are positive integers
	Post: produces a list of all tuples whose
	first value is between 1 and m and whose second value is between 1 and n
*)
fun allPairs(n, m) = reduce(op@, mapx(fn x => mapx(fn y => (x, y), 1--m), 1--n));

(* Post: produces 2n + 3*)
val timesTwoPlusThree = (curry op+ 3) o (curry op* 2);

(* Post: returns true if n is positive, else false*)
val positive = curry op< 0;

(* Post: returns a list of of the first n even numbers
starting with 2*)
val evens = (map (curry op* 2)) o (curry op-- 1);

(* Post: takes a list of integers and produces a list of the 
square roots of the positive integers in the list, rounded
to the nearest integer*)
val roots = (map (round o Math.sqrt o real)) o filter (curry op< 0);

(*	Pre: lst of strings do not contain empty strings
	Post: takes the lst of strings and produces a string 
	compost of the uppercased letters of each string in the lst*)
val acronym = implode o map (Char.toUpper o hd o explode);

(*	Post: takes lst of strings and produces lst obtained by 
	reversing the order of the letters in each string and 
	reversing the overall order of strings in the lst*)
val reverseStrings = rev o map (implode o rev o explode);