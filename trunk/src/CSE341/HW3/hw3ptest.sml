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

(*Operates on one person's data*)

(*	Pre: lst is from result of running translate1
	Post: produces the lst of tuples (a,b) where a is count of As in
	the lst and b is the count of Bs in the lst. Should have four tuples
	in the list, each tuple indicating each of the four dimensions*)
fun translate2([]) = []
|	translate2(first::rest) = 
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
			countAB(first)::translate2(rest)
		end;

(*	Pre: lst is from result of running translate2
	Post: Produces a lst of int where each int is the percentage of B 
	for each of four personality dimension*)
fun translate3(lst) = 
	let
		fun percentB(x, y) = round((real(y)*100.0)/real(x + y))
	in
		map percentB lst
	end;
	
val martyResult = translate3(translate2(translate1(result)));