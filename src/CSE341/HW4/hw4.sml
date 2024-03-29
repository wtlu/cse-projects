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
(* Defining an exception type to raise when a given input is invalid*)
exception InvalidInput

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
	


(*Part C: Building an N-gram Tree*)

(*	Pre: valid string lists
	Post: compare the list and return LESS if the first list comes alphabetically
	earlier than the second; EQUAL if the two lists are exactly the same; and
	GREATER if the first list comes alphabetically later than the second*)
fun stringListCompare([], []) = EQUAL
|	stringListCompare(_,[]) = GREATER
|	stringListCompare([],_) = LESS
|	stringListCompare(first1::rest1, first2::rest2) =
		if first1 = first2 then stringListCompare(rest1,rest2)
		else if String.<(first1, first2) then LESS
		else GREATER;



(*	Pre: Tree is formatted correctly
	Post: takes n-gram tree, a list of leading words, and completion word and produces tree
	obtained by inserting the leading words/completion word combination into the tree
	If the set of leading words is already in treem, the completion word should be added to that n-gram
	If not, a new ngram should be added to the tree with a frequency of 1. The tree should be ordered based on
	how the strings compare with each other. If n-gram tree is empty, the result is a new tree with the given data
	as its sole element*)
fun addToTree(Empty, lst, str) = NgramNode(createNgram(lst, str), Empty, Empty)
|	addToTree(NgramNode(ndata as Ngram(nlst, count, tupleLst), left, right), lst, str) =
			if (stringListCompare(lst, nlst) = EQUAL) then NgramNode(addToNgram(ndata, str), left, right)
			else if (stringListCompare(lst,nlst) = LESS) then NgramNode(ndata, addToTree(left, lst, str), right)
			else NgramNode(ndata, left, addToTree(right, lst, str));

(*	Pre: Assuming we are working with ">=2"-grams. Overall frequency in an n-gram
	is equal to the sum of the individual frequencies of its completion words
	no completion words have a frequency of 0 or less, the list of completion words
	is nonempty. n-gram tree is a proper binary search tree based on leading words lst
	and the n-gram tree is nonempty. Data passed to our functions are consistent in terms of
	n-gram length
	Post: takes a list of tuples of the form(leading words, completion word)
	and returns an n-gram tree built by inserting each tuple's data into an intitially
	empty n-gram tree*)
fun addAllToTree([]) = Empty
|	addAllToTree((a,b)::rest) = addToTree(addAllToTree(rest), a, b);

(*Part D: Generating Random Text*)

(*	Pre: Given tree contains at least one node whose first 
	leading word begins with a capital letter
	Post: randomly picks a list of (n-1) leading words where the first word 
	begins with a capital letter *)
fun randomStart(Empty) = raise InvalidInput
|	randomStart(root as NgramNode(ndata, left, right)) = 
		let
			(*Gets a list of list of leading words where the first word is capitalized*)
			fun getLstCapWords(Empty) = []
			|	getLstCapWords((NgramNode(ndata as Ngram(nlst, count, tupleLst), left, right))) =
					if isSentenceStart(hd(nlst))
						then nlst::getLstCapWords(left)@getLstCapWords(right)
					else
						getLstCapWords(left)@getLstCapWords(right)
			val lstCapWords = (getLstCapWords(root))
			val getRandomNum = randomInt() mod length(lstCapWords)
			
			(*picks a random word from the given list and random number*)
			fun getRandomWord([], _) = []
			|	getRandomWord(lst, 0) = hd(lst)
			|	getRandomWord(first::rest, n) = getRandomWord(rest, n - 1) 
		in
			getRandomWord(lstCapWords, getRandomNum)
		end;

(*	Pre: valid ngram tree and valid str lst
	Post: produces a n-gram option that is either the n-gram associated with the given
	set of leading words in the given tree, or NONE if not found*)		
fun lookup(Empty, lst) = NONE
|	lookup(NgramNode(ndata as Ngram(nlst, count, tupleLst), left, right), lst) = 
		if nlst = lst then SOME ndata
		else 
			let 
				val leftFind = lookup(left, lst)
				val rightFind = lookup(right, lst)
			in
				if isSome(leftFind) then leftFind
				else rightFind
			end;

 
(*	Pre: filename and file exists and readable
	Post: returns an n-gram tree constructed using the words from the given
	input file with n-grams of length n. If n is less than 2, then OutOfRange
	exception will be raised*)
fun buildTree(filename, n) = 
	if n < 2 then raise OutOfRange
	else addAllToTree(groupWords(read(filename), n));
	
(*	Pre: ngram tree not empty, count >= 0
	Post: produces a list of approximately count words that are randomly 
	generated using a given tree*)
fun randomDocument(_, 0) = []
|	randomDocument(Empty, _) = raise InvalidInput
|	randomDocument(root as NgramNode(ndata, left, right), count) =
		if count < 0 then raise OutOfRange
		else
			let
				val result = randomStart(root)
				fun getResult([],_, _) = raise InvalidInput
				|	getResult(window as windowFirst::windowRest, resultSentence, currentCount) =
						if currentCount < 1 andalso 
							(isSentenceEnd(last(resultSentence)) orelse last(resultSentence) = "") 
							then resultSentence
						else if currentCount < 1 then getResult(window, resultSentence, 1)
						else
							let
								val ngramNext = lookup(root, window)
								val handleSpecial = not (isSome(ngramNext))
								val startAgain = if (handleSpecial) then randomStart(root) else []
								val word = if handleSpecial then "" 
									else randomCompletion(valOf(ngramNext))
								val newResult = 
									if handleSpecial andalso currentCount > 0
										then resultSentence@startAgain
									else if handleSpecial then resultSentence
									else resultSentence@[word]
								val newWindow = if handleSpecial then startAgain else windowRest@[word]
							in
								getResult(newWindow, newResult, currentCount - 1)
							end;
			in
				getResult(result, result, count - length(result))
			end;