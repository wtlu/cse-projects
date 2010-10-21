(*
CSE 341, Homework 3, Marty Stepp
A set of utility functions/data to be used as helpers by your personality test code.
To use them, write the following at the top of your file:
    use "utility-ptest.sml";
*)

use "utility.sml";

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

(* returns a list of random ints of given length; assumes n >= 0 *)
fun randList(n) =
        let fun build(0) = []
            |   build(m) = Random.randInt(utilityRandom)::build(m - 1)
        in build(n)
        end;

(* returns whether or not a number is prime *)
fun isPrime(2) = true
|   isPrime(n) =
        let fun noFactors(m) =
                if m * m > n then true
                else n mod m <> 0 andalso noFactors(m + 2)
        in n > 1 andalso n mod 2 = 1 andalso noFactors(3)
        end;

(* translates a string of 70 A's and B's into 4 lists of A's and B's *)
exception not_multiple_7;
fun translate1(string) =
        let fun build(l1, l2, l3, l4, []) = [l1, l2, l3, l4]
            |   build(l1, l2, l3, l4, a::b::c::d::e::f::g::rest) =
                    build(a::l1, b::c::l2, d::e::l3, f::g::l4, rest) 
            |   build(a) = raise not_multiple_7
        in build([], [], [], [], mapx(str, explode(string)))
        end;

(* a combination of functions used to produce pretty output *)
(* when done with the assignment, type: displayall(answer); *)
val spaces = "                                                  ";
fun ljustify(str, n) = String.substring(str ^ spaces, 0, n);
fun rjustify(str, n) = String.substring(spaces, 0, n - size(str)) ^ str;
fun displayNums(list) = 
    reduce(op ^, mapx(fn(x) => rjustify(x, 6), mapx(Int.toString, list)));
fun display1(a, b, c) = ljustify(a, 40) ^ displayNums(b) ^ "  " ^ c ^ "\n";
fun displayAll(list) = print(ljustify("name", 40) ^ 
    "   E/I   S/N   T/F   J/P  Type\n" ^  reduce(op ^, mapx(display1, list)));

(* print entries for bonus *)
fun bigPrint(list) = print(reduce(op ^,
    mapx(fn(a, b, c) => a ^ ", average distance = " ^ Int.toString(b) ^
    ", individual distances:\n" ^ reduce(op ^, mapx(fn(x, y) =>
    "(" ^ x ^ ", " ^ Int.toString(y) ^ ")\n", c))  ^ "\n\n", list)));

(* raw data for the personality test *)
val data = [
("Marty", "ABABAAAAABAAAABABBBABBAAAAABBAAAABBBBBBBBABABABABABAAAAAABBBBAABAABABA"),
("Stuart", "BBBBBBBBBBBBBABBBBABBBBBAABAABBBBBBBBBABBBBBBBBABBBBBBBBABABABBBBBABBB"),
("Eric", "AABAABABABABAABAABAAAAABABBAAAAABAAAAABAAAAAAABBAABAAAABAAABAAAAABAABA"),
("DavidB", "AABBABBAABABAAABAAAABABABBBBAABBAAAAABAAABAAABBAAABBAAAAABABABBABBBABA"),
("Cody", "BBBBABBBABABAABBBBABAABBAAAABBBBBBBBABABBBAAAAAABBAAABAABAABABBBBAAABA"),
("Jenny", "ABBAAABAABAAAABBAAABBABBAABBABBBABBAABAABAABBBABBABBAABBBBBBABBABBAABA"),
("KZ", "BBBBABABAABAABBAABAAAABBBAAABABBABABABAAAABABBAABBAAAAABBAABAABBBBAABA"),
("bored enough to take this", "BABAAABBABAAAABAABAAAAABAABABA-BAAABAAAAAABAA-AAABAAABAABBA-ABABAAAAAA"),
("heather", "AABBBABBABBAAABBBBBABABBAABABAABAAABAAAAAABBABAABAAABAABBAAAAAAABABABA"),
("Yo Yo Ma Ma", "B-BAAAABABBAAAAAABABAAAABABABAAAABABAAAAAABAAABABAAAAAAABAAAAABAAAAAAA"),
("Robert", "BABAAABBA-AAAAAAAAAAABAB-AAABABAA-AAAAAAAABAAAAABAABAAAA-AABAAAAAAAAAA"),
("Crom", "BBBBABBBBBBBBABBBABBBBBBBBAABABBABABABABAABABBBAABAAAAABBBAAABBBBBAABB"),
("AFKforever", "BBABAAABBBAAAABABAAABAABAAAAABABAABBABAAAABBBABAAAABAAAABBBAAAAABABBAA"),
("Titus", "BABABAABBBBAAABAAAAAAABBBABABBBBABABAAAAABBBBAABABAAABAABBBAABABBAAABA"),
("Girls Dead Monster", "BAABBABBABAAAABAABAABBABAABABBBBABABBBAABBBAAAABAAABAABBBAABABAABAAAAA"),
("Ryan", "BAABBAAAABBABAABBABBBBAAAABBBAAABBBAAAABBBBBABAABBABBBAABABABBBBBAABBB"),
("Zelos", "AABBBABAABABAABAABBAAABBBABABBABBAABAAAAAABAABBAABAABBAABAABAAABABABAA"),
("Danny Dominator", "AABBBABBABAABABABABAAABBBABABABBABABAABABABAAABABBAAAAABAAABAAABABABBB"),
("Julia", "ABABBABAAAABBAA-BBBAAABBBBBABAABBAAAAAABAAABABBAAAAABAABAAABBBAAABAABA"),
("Gumgo", "BABBBBBBAAABBBBAAABBBABBBBBABAABABABAAAAABBAABBABAAABBBBBAABABBABBBABB"),
("Cremepuff", "AABBBBBBBBBAABBBBBAAABAABABABBABAAABBAAAAABABBABBBABAAAABBBBABABBAAABA"),
("roy", "AABABAAABAAABABABABAAAABAAAAAABAAAAAABAAAABBABAABABAABABBABAABAABAAAAA"),
("Link", "AABAAABBBBBAAABBAABAAABBABBABABBABAAAAAAABBBBABAAAAAAAAAAAAAAAAAAAAAAA"),
("Alex", "AABBBBBAAAABBABAAABAAAAAAABAAABAAAAAAAAAAAAAABAABAAAABAAAAABAAAAAAAABA"),
("James Gosling", "BABBAABBABABBABAAABAAAAAAAAABBABABABAAAAABBAAAAABBAAAAABBAABAABBAAABAA"),
("Elise", "BBBBABBBAAABAABAABBAAABABBBAAABBBAABAAABAAAAABAABAAABAABBA-BAAAAABBBAA"),
("qkt", "BBABBABBABABBBBABABAAABABBBBBABAAABBAABBBBA-AA-BBABB-AAAB-AAABBBAAABBA"),
("alice", "BBBB-ABBAAABAABAABBAB-A-BBAABABBBAABAAABAABAA-BAAAABBBAABA-AAAABBBABAA"),
("Cauchy-Riemann", "BBBAAAABBBAAAAAAAAAAABAAAAAAABAAAAAAABAAAABAAAABABABAAAAAAABABAABAAAAA"),
("Friedrich Wilhelm", "BBBAABBBAAAAAABAAABAABBBAABBABABAAABAAAAAABAAAAAABAAABAABAABAAABAAAAAA"),
("J", "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"),
("gremlin", "AABBABBAAAAAABAABBBAAABBBBBABABBBBAAABBAAAAAABBAAAAABAABAABBAAAAABBBBA"),
("Tom Clancy", "AAABBABBBBABBABAABBAABABBBAAAABABBBBAABABBAAABBABAABBBAABBABAAAAAABBAA"),
("Atilla the Hun", "BBBBAABBAAABAABAAABAABBBABBABABBBAABAAAAAABAABBAAAABBAABBAABAAAAABABAA"),
("Bulbasaur", "BBBAABBBABAAAABAAAAABBBAAAAABBABAAABABAAABBAAAABABBBAABABAAAAAABBAAAAA"),
("LANDON MEERNIK (That guy with long hair)", "AABABBABBBAAABABAAAAAAABAAAAAAABABAAAAAAAABABAAAAAAAAAABABAAAABABAAABB"),
("Banana", "ABBBBABAABBAAABBABBBABBBABAAAABBBABBABABBBBABAABBAAABAABBBBAAABAABBBAA"),
("jared", "BBABBABBBABBAAABABBABBBAABBAABBBBBABABBBAAABBBBAABBBBBAAAABBAABBBBBBBA"),
("Colin Scott", "BBBBAABBBBAABBBBBAAABBBBAAABABBBABBBBBAABBBBBAAAAABBAABABBAAABBABBAABB"),
("Voldemort", "AABBBABBAABBBABAABBAAAAAAABAAABBBBBAAAAAAABAAAAAABAAABAABAABAAABBAAAAA")];
