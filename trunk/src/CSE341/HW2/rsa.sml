(* 	CSE341
	Wei-Ting Lu 
	10/12/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW1 - This program contains several short individual functions
	      that combine to do RSA encryption
*)

(* 	Pre: Strings made up of characters that have range 1 to 127 inclusive
	Post: Returns a list of integers that represnet the ordinal
	values of the sequence of characters in s
*)
fun stringToInts(s) = 
	let
		fun charToInts([]) = []
		|   charToInts(first::rest) = ord(first)::charToInts(rest)
	in
		charToInts(explode(s))
	end;
	
(* 	Pre: Ints within range 1 to 127 inclusive
	Post: Takes the list of ordinal values and returning
	the corresponding string.
*)
fun intsToString(lst) = 
	let
		fun intsToChars([]) = []
		|   intsToChars(first::rest) = chr(first)::intsToChars(rest)
	in
		implode(intsToChars(lst))
	end;
	
(* 	Pre: x and y are integers, y not negative
	Post: Returns the result of raising the first integer (x) to
	power of the second (y). Note that we assume every integer 
	to the 0 power is 1
*)
fun pow(x, 0) = 1
|	pow(x, y) = x * pow(x, y - 1);

val lst = [18, 3, 95, 48, 22, 39, 47, 12, 73, 15]; 

(* 	Pre: k and b are both greater than 0
			numbers in the list are all > 0 and < b
	Post: Returns list obtained by combining integers in the
			given base. Consecutive sequences of k values are 
			replaced with teh single integer. Produces
			empty list if passed an empty list
*)
fun pack(lst, k, b) = 
	let
		(* 	Pre: inital passed lst is correctly formatted,
					passed in values are not negative
			Post: returns a tuple of list, with first value the 
					first x values of lst, and second value
					the rest of the lst
		*)
		fun getLst([],_) = ([], [])
		|	getLst(lst, 0) = ([], lst)
		|	getLst(first::rest, x) = 
				let
					val (a,b) = getLst(rest, x - 1)
				in
					(first::a, b)
				end
				
		(* 	Pre: inital passed lst is correctly formatted,
					passed in values are not negative
			Post: packs the values in the lst into one integer
		*)
		fun packOne([], _, _) = 0
		|	packOne(first::rest, k, b) = first * pow(b,(k - 1)) + packOne(rest, k - 1, b)
		val (a,c) = getLst(lst, k)
	in
		if lst = [] then []
		else if length(lst) < k then [packOne(lst, length(lst), b)]
		else packOne(a, k, b)::pack(c, k, b)
			
	end;