(* 	CSE341
	Wei-Ting Lu 
	10/12/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW2 - This program contains several short individual functions
	      that combine to do RSA encryption
*)


val p = 131; 	(* first chosen prime for RSA encryption *)
val q = 239; 	(* second prime chosen prime for RSA encryption *)
val n = p * q; 	(* used for modulus *)
val e = 1363; 	(* public key *)
val d = 227; 	(* private key *)

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
	


(* 	Pre: k and b are both greater than 0
			numbers in the list are all > 0 and < b
	Post: Returns list obtained by combining integers in the
			given base. Consecutive sequences of k values are 
			replaced with teh single integer. Produces
			empty list if passed an empty list
*)
fun pack(lst, k, b) = 
	let
		(* 	Pre: x and y are integers, y not negative
			Post: Returns the result of raising the first integer (x) to
			power of the second (y). Note that we assume every integer 
			to the 0 power is 1
		*)
		fun pow(x, 0) = 1
		|	pow(x, y) = x * pow(x, y - 1);
		
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
	
(* 	Pre: lst/b combination to unpack was generated by a legal call
		on pack with same base
	Post: Returns list obtained by expanding each integer using the
			given list
*)
fun unpack(lst, b) =
	let
		(* 	Pre: x < b
			Post: Returns list obtained by expanding the integer using
					the given base
		*)
		fun unpackOne(x, b) = 
			if x div b = 0 then [x]
			else (x mod b)::unpackOne(x div b, b)


		(*  Given a list L = [a, b, c, ..., y, z], returns [z, y, ..., c, b, a].
		   Implemented tail-recursively to be more efficient (O(n)).
		   The helper parameter 'tempList' is used as an 'accumulator' to store
		   values being built up in progress. *)
		fun reverse([]) = []
		|   reverse(L) =
				let
					fun helper([], tempList) = tempList
					|   helper(first::rest, tempList) = helper(rest, first::tempList)
				in
					helper(L, [])
				end
	in
		if lst = [] then []
		else reverse(unpackOne(hd(lst), b)) @ unpack(tl(lst),b)
	end;


(* 	Pre: y >= 0
	Post: Returns (x^y mod n)
*)
fun modPow(x, y, n) =
	let
		(* 	Pre: y >= 0, y is even
			Post: Returns (x^y mod n)
		*)	
		fun modPowEven(x, 0, n) = 1
		|	modPowEven(x, 2, n) = (x * x) mod n
		|	modPowEven(x, y, n) = 
				if y mod 2 = 1 then (((modPowEven(x, y div 2, n) * modPowEven(x, y div 2, n)) mod n)*(x mod n) ) mod n
				else (modPowEven(x, y div 2, n) * modPowEven(x, y div 2, n)) mod n;
	in
		if y mod 2 = 1 then (modPowEven(x, y - 1, n) * (x mod n)) mod n
		else modPowEven(x, y, n)
	end;
	
(* 	Pre: valid string
	Post: Produces a list of encrypted integers based on five arguments
	a string s, an integer key e, a modulus n, an integer per, and integer base
	converts the string into a list or ordinal values, packs the values with
	giveb base and given number of ordinals to pack, and then encrypts each 
	integer x in the resultint list by replacing it with (x^e mod n)
*)
fun encrypt(s, e, n, per, base) = 
	let
		val lst = pack(stringToInts(s), per, base)
		
		(*encrypts the int of the lst to x^e mod n*)
		fun encryptLst([], y, modn) = []
		|	encryptLst(first::rest, y, modn) = modPow(first, y, modn)::encryptLst(rest,y, modn)
	in
		encryptLst(lst, e, n)
	end;

(* 	Pre: valid lst from encrpt
	Post: produces a decrypted string based on lst of encrypted integers,
	integer key d, integer modulus n, and integer base
*)
fun decrypt(lst, d, n, base) =
	let
		(*decrypts the ints of the list with x^d mod n*)
		fun decryptLst([], y, modn) = []
		|	decryptLst(first::rest, y, modn) = modPow(first, y, modn)::decryptLst(rest, y, modn)
	in
		intsToString(unpack(decryptLst(lst, d, n), base))
	end;

val message = "Twas brillig and the slithy toves did gyre and gimble";
val code = encrypt(message, e, n, 2, 128);
val decoded = decrypt(code, d, n, 128);