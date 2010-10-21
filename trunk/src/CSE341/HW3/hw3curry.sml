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