/* CSE341
Wei-Ting Lu 
12/5/2010
TA: Robert Johnson 
Quiz Section: AA
HW9 - This program contains several short individual functions
*/


// Pre: string is valid, n passed in is valid integer
// Post: returns the string repeated n times. If n is <= 0, returns empty string
// if n is not passed, assume an n of 1
function repl(str, n) {
	if (typeof(n) === "undefined")
		n = 1;
	
	if (n <= 0)
		return ""
	else
		return str + repl(str, n - 1);
}

// Pre: n is valid integer
// Post: returns true if the integer is a prime number, false otherwise
function isPrime(n) {
	if (n <= 1)
		return false;
		
	var endValue = Math.sqrt(n);
	for (var i = 2; i <= endValue; i++) {
		if ( (n % i) === 0)
			return false;
	}
	return true;
}

// Pre: object that stores various attributes of box as its properties
// is valid. In particular, if defined, boxObject's width and height property
// should be intergers >= 2. Border and filling should be strings of one character
// Post: draws a text fiture of a rectangular box based on the passed in object with
// following properties. If property is absent, use default values shown
// width: number of characters wide for the box (default 10)
// height: number of characters wide for the box (default 5)
// border: character to use to draw around the outside of the box (default "*")
// filling: character to use to draw in the interior of the box (default ".")
function box(boxObject) {
	if (typeof(boxObject) === "undefined")
		boxObject = {};
	if (typeof(boxObject["width"]) === "undefined")
		boxObject["width"] = 10;
	if (typeof(boxObject["height"]) === "undefined")
		boxObject["height"] = 5;
	if (typeof(boxObject["border"]) === "undefined")
		boxObject["border"] = "*";
	if (typeof(boxObject["filling"]) === "undefined")
		boxObject["filling"] = ".";		
		
	// Pre: n and borderChar are not undefined
	// Builds the border row containing n characters of of borderChar
	function buildBorderRow(n, borderChar) {
		var result = ""
		for (var i = 0; i < n; i++) {
			result += borderChar;
		}
		return result;
	}
	
	// Pre: n, borderChar, fillingChar are not undefined
	// Builds a row of n - 2 filling wraped around 1 character of borderChar
	function buildFillingRow(n, borderChar, fillingChar) {
		var result = borderChar;
		for (var i = 0; i < (n - 2); i++) {
			result += fillingChar;
		}
		return (result + borderChar)
	}
	
    print(buildBorderRow(boxObject.width, boxObject.border));
	for (var i = 0; i < boxObject.height - 2; i++) {
		print(buildFillingRow(boxObject.width, boxObject.border, boxObject.filling));
	}
	print(buildBorderRow(boxObject.width, boxObject.border));
}

// Taken from lecture 25 to implement curry
function toArray(a, i) {          // converts a
    var result = [], i = i || 0;  // duck-typed obj
    while (i < a.length) {        // into an array
        result.push(a[i++]);
    }
    return result;
};
// Taken from lecture 25 to implement curry function
function curry(f) {       // Usage: curry(f, arg1, ...)
    var args = toArray(arguments, 1);  // remove f
    return function() {
        return f.apply(this,
            args.concat(toArray(arguments)));
    };
}


// Pre: string s is valid
// Post: returns a new string with same characters as original, but
// with the text converted to "Pig Latin"
function pigLatin(s) {
	
	// Checks if the given string does not starts with a vowel
	// returns true if str does not start with vowel, false otherwise
	function notStartWithVowel(str) {
		return !((str[0]) === "a" || (str[0] === "e") || (str[0] === "i") ||
			(str[0] === "o") || (str[0] === "u"))
	}
	var result = s.split(" ").filter(notStartWithVowel).map(function(x) 
		{ return x.slice(1) + "-" + x[0] + "ay"}).join(" ");
	
    return result;
}

// Pre: Number type exists
// Post: adds a method squared to all numbers that returns the square of the number
Number.prototype.squared = function () { return this*this }

// Pre: Array type exists
// Post: adds a method shuffle to all arrays that rearranges the elements of the array
// into a randomly chosen order with equal probability. 
Array.prototype.shuffle = function () {
	for (var i = (this.length -1); i >= 1; i--) {
		var j = (Math.round(Math.random() * i));
		var temp = this[i];
		this[i] = this[j];
		this[j] = temp;
	}
}

// Pre: String type exists. Words in the string are separaed by exactly one space.
// Post: adds a method toTitleCase to all strings that returns a new string where each word
// of the original string has its first letter in upper case and the rest of ththat word's
// letters in lowercase.
String.prototype.toTitleCase = function() {
	//todo
	print("work in progress");
}

// Pre: String type exists.
// Post: adds a method toAlternatingCase to all strings that returns a new string that 
// contains the same characters and the original, but alternating between upper and lowercase.
// By default, the first character should be uppercase, the seond lowercase, the third uppercase,
// and so on. But if an optional boolean parameter of true (or any truthy value) is passed, then
// the effect is opposite (1st character is lower, 2nd is upper, etc).
String.prototype.toAlternatingCase = function() {
	//todo
	print("work in progress");
}

// Pre: String type exists.
// Post: adds a method toLeetSpeak to all strings that contains the same characters as the
// original, but with various subsititutions to convert the text to "Leet Speak".
// Substitue 4 for A, 3 for E, 1 for I, 0 for O, Z for S. Also convert the string to 
// Alternating case, starting with the first letter captitalized. 
String.prototype.toLeetSpeak = function() {

}

// Pre: n is valid integer
// Post: returns true if the integer is a prime number, false otherwise
function isPrime2(n) {
	if (n <= 1)
		return false;
		
	var endValue = Math.sqrt(n);
	for (var i = 2; i <= endValue; i++) {
		if ( (n % i) === 0)
			return false;
	}
	return true;
}

// Pre: minimum and maximum value are integers >= 0
// Post: returns an array containing all prime numbers that appear in that range (inclusive)
// If minimum is greater than the maximum, return empty array. 
function primesInRange(min, max) {
	//todo
	print("work in progress");
}

// Testing variables, delete when done
var s = "Seattle Mariners are a great team eh?";
var n = 7;
var a = [10, 20, 30, 40, 50, 60, 70, 80, 90];

