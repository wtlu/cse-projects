(*
CSE 341, Homework 4, Marty Stepp
A set of utility functions/data to be used as helpers by your n-grams code.
To use them, write the following at the top of your file:
    use "ngram.sml";
*)

use "utility.sml";

(* basic data type for storing n-grams: each stores a list of n-1 words,  *)
(* a total word count, and a list of word/count pairs for all completions *)
(* of the (n-1) words.                                                    *)
datatype ngram = Ngram of string list * int * (string * int) list;

(* datatype for a binary search tree of ngrams where we can quickly find *)
(* an entry given a list of (n-1) words.                                 *)
datatype NgramTree = Empty | NgramNode of ngram * NgramTree * NgramTree;

(* returns the list of the leading (n-1) words for this ngram *)
fun getWords(Ngram(words, count, choices)) = words;

(* returns true if the given string can be the beginning of a sentence (is capitalized). *)
fun isSentenceStart(str) = Char.isUpper(hd(explode(str)));

(* returns true if the given string can be the end of a sentence *)
fun isSentenceEnd(str) = Char.contains ".!?" (List.last(explode(str)));

(* Given a file name, opens the file and turns it into a list of tokens *)
fun read(fileName) =
        let fun ok(ch) = Char.isAlpha(ch) orelse (Char.contains "'.;,!?" ch)
            val bad = not o ok;
        in String.tokens bad (TextIO.inputAll(TextIO.openIn(fileName)))
        end;

(* Given a list of words, prints the words to fit within 75 columns of *)
(* output with a blank line afterwards.                                *)
fun printList(lst) =
    let fun process(n, []) = print("\n\n")
        |   process(0, x::xs) = (print(x); process(size(x), xs))
        |   process(n, x::xs) =
                if n + size(x) + 1 > 75 then (print("\n"); process(0, x::xs))
                else (print(" " ^ x); process(n + size(x) + 1, xs))
    in process(0, lst)
    end;



(* sorts a list with the quicksort algorithm given a comparison function *)
(* and a list of values                                                  *)
fun quicksort(f, []) = []
|   quicksort(f, pivot::rest) =
        let fun split([], ys, zs) = quicksort(f, ys) @ [pivot] @ quicksort(f, zs)
            |   split(x::xs, ys, zs) =
                    if f(x, pivot) then split(xs, x::ys, zs)
                    else split(xs, ys, x::zs)
        in split(rest, [], [])
        end;

(* a random number generator initialized using the current time *)
val utilityRandom =
    let val time = IntInf.toInt(Time.toSeconds(Time.now()) mod 
                                Int.toLarge(valOf(Int.maxInt)))
    in Random.rand(time, 42)
    end;

(* returns a random int value *)
fun randomInt() = Random.randInt(utilityRandom);
