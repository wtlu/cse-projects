(* 	CSE341
	Wei-Ting Lu 
	10/20/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW3 - This program computes the answer to the 
	Keirsey personality test
*)

use "utility-ptest.sml";


val (name, result) = hd(data);

(*	Pre: lst is from result of running translate1
	Post: produces the lst of tuples (a,b) where a is count of As in
	the lst and b is the count of Bs in the lst. Should have four tuples
	in the list, each tuple indicating each of the four dimensions*)
fun translate2([]) = []
|	translate2(lst as first::rest) = 
		let
			fun countAB([]) = (0,0)
			|	countAB(first::rest) = 
					let
						val (x,y) = if first = "A" then (1,0) else (0,1)
						val (u,v) = countAB(rest)
					in
						(x + u, y + v)
					end
		in
			map countAB lst
		end;

(*	Pre: lst is from result of running translate2
	Post: Produces a lst of int where each int is the percentage of B 
	for each of four personality dimension*)
fun translate3(lst) = map (fn (x,y) => round((real(y)*100.0)/real(x + y))) lst;

exception WrongFormatLst	
(*	Pre: lst is from result of running translate3, should not be empty
	Post: returns the string of personality based on the dimensions*)
fun translate4([one,two,three,four]) = 
	let
		fun EorI(x) = if x < 50 then #"E" else if x = 50 then #"X" else #"I"
		fun SorN(x) = if x < 50 then #"S" else if x = 50 then #"X" else #"N"
		fun TorF(x) = if x < 50 then #"T" else if x = 50 then #"X" else #"F"
		fun JorP(x) = if x < 50 then #"J" else if x = 50 then #"X" else #"P"
	in
		implode([EorI(one), SorN(two), TorF(three), JorP(four)])
	end
|	translate4(_) = raise WrongFormatLst;

val martyResult = translate3(translate2(translate1(result)));
val realFirstResult = (name, martyResult, translate4(martyResult));

(*	Pre: given list is in right format i.e. (string * string) list
	Post: Operates on everyone's data, returning a list of three tuple
	first in tuple is name, second is score, third is personality*)
fun calculateEveryone([]) = []
|	calculateEveryone(first::rest) =
		let
			val (name, result) = first
			val calculatedResult = translate3(translate2(translate1(result)))
			val personality = translate4(calculatedResult)
		in
			(name, calculatedResult,personality) :: calculateEveryone(rest)
		end;

val answer = calculateEveryone(data);