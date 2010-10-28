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
val test = ["to", "be"]
val test2 = "or"
val ngtest = Ngram(["to","be"],1,[("or",1)]);

(*Part B: Grouping Words into N-Grams*)

(*	Pre: lst and string in correct format.
	Post: takes string lst of leading words and a string 
	representing a completion word and turns it into an initial ngram
	instance storing that data with total count of 1*)
fun createNgram(lst, str) = Ngram(lst, 1, [(str, 1)]);


(*	Pre: n-gram and word is valid
	Post: takes existing ng n-gram and completion word str and produces 
	new n-gram that includes the given word that n-gram's list of completions*)
fun addToNgram(Ngram(lead, count, tupleLst), str) = 
	let
		fun processLst([]) = [(str, 1)]
		|	processLst(first::rest) = 
			let
				val (word, frequency) = first
			in
				if word = str then (word, frequency+1)::rest
				else first::processLst(rest)
			end;
	in
		Ngram(lead, count+1, processLst(tupleLst))
	end;

(*	Pre: Ngram is valid
	Post: takes the n-gram and chooses randomly from its list of completion words
	using the existing statistical frequency of the various completion words to weight 
	the random selection*)
fun randomCompletion(Ngram(lead, count, tupleLst)) =
	let
		val randCount = randomInt() mod count
		fun processLst([], _) = raise OutOfRange
		|	processLst((first as (a,b))::rest, 0) = a
		|	processLst((first as (a,b))::rest, index) = 
				if index - b < 0 then a
				else processLst(rest, index - b)
	in
		processLst(tupleLst, randCount)
	end;
	
val ng2 = addToNgram(ngtest, "or");
val ng3 = addToNgram(ng2, "with");

(*Part C: Building an N-gram Tree*)

(*Part D: Generating Random Text*)