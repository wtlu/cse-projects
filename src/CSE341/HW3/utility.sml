(*
CSE 341, Marty Stepp
A set of utility functions to be used as helpers by your other programs.
To use them, write the following at the top of your file:
    use "utility.sml";
*)

open List;

(* Applies function F to each element of the given list [a,b,c,...],
   producing a new list [F(a),F(b),F(c),...]. *)
fun mapx(F, []) = []
|   mapx(F, first::rest) = F(first) :: mapx(F, rest);

(* Calls function P on each element of the given list [a,b,c,...];
   P is an inclusion test that returns either true or false.
   The elements for which P returns true are kept; the others discarded. *)
fun filterx(P, []) = []
|   filterx(P, first::rest) = 
        if P(first) then first :: filterx(P, rest)
        else filterx(P, rest);

(* Calls function F successively on pairs of elements from the given list
   to combine pairs into a single element until only one element remains. *)
exception EmptyList;
fun reduce(F, []) = raise EmptyList
|   reduce(F, [value]) = value
|   reduce(F, first::rest) = F(first, reduce(F, rest));


(* A helper operator to produce a range of numbers;
   a--b produces [a, a+1, ..., b-1, b]. *)
infix --;
fun min--max =
		if min > max then []
		else min :: (min + 1 -- max);

(* Converts an infix 2-argument function/operator into curried form.
   For example, curry op+ returns a curried version of the addition operator. *)
fun curry operator a b = operator(a, b);
