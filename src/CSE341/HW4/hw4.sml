(* 	CSE341
	Wei-Ting Lu 
	10/25/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW4 - This program contains implementation of Markov chain that solves the ngram problem
*)

use "utility.sml";
use "ngram.sml";

(* Defining an exception type to raise when a number is out of range. *)
exception OutOfRange

(* Part A: Processing the Input File*)
(*	Pre:	lst of strings is valid
	Post: takes list of words and integer n and produce a list of tuples
	where each tuple sotres the pair: (n - 1 leading words, nth completion word)*)
fun	groupWords([], _) = [] 
|	groupWords(lst as first::rest, n) =
		if (length(lst) < n) then []
		else if n < 2 then raise OutOfRange
		else
			let
				fun createTuple([], _) = ([], "")
				|	createTuple(_, 0) = raise OutOfRange
				|	createTuple(first::rest, 1) = ([], first)
				|	createTuple(first::rest, n) =
						let
							val (a,b) = createTuple(rest, n - 1)
						in
							(first::a, b)
						end;
				val (a,b) = createTuple(lst, n);
			in
				(a,b)::groupWords(rest, n)
			end;

val words = ["Twas", "brillig", "and", "the", "slithy", "toves"];

(*Part B: Grouping Words into N-Grams*)

(*	Pre: lst and string in correct format.
	Post: takes string lst of leading words and a string 
	representing a completion word and turns it into an initial ngram
	instance storing that data with total count of 1*)
fun createNgram(lst, str) = Ngram(lst, 1, [(str, 1)]);

(*Part C: Building an N-gram Tree*)

(*Part D: Generating Random Text*)