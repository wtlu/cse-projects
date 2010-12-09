/* CSE341
Wei-Ting Lu 
12/5/2010
TA: Robert Johnson 
Quiz Section: AA
HW9 - This program contains several short individual functions
*/

// To use underscore library
load("underscore.js");

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
Number.prototype.squared = function () { return this*this };

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
};

// Pre: String type exists. Words in the string are separaed by exactly one space.
// Post: adds a method toTitleCase to all strings that returns a new string where each word
// of the original string has its first letter in upper case and the rest of that word's
// letters in lowercase.
String.prototype.toTitleCase = function() {
	
	// Pre: passed in s is string
	// Post: process the word by turning the first letter to upper case and 
	// rest of the words letters in lowercase.
	function processOneWord(s) {
		var answer = "";
		for (var i = 0; i < s.length; i++) {
			if (i === 0) {
				answer += s[i].toUpperCase();
			} else {
				answer += s[i].toLowerCase();
			}
		}
		return answer;
	}
	var result = this.split(" ").map(processOneWord).join(" ");
	return result;
};

// Pre: String type exists.
// Post: adds a method toAlternatingCase to all strings that returns a new string that 
// contains the same characters and the original, but alternating between upper and lowercase.
// By default, the first character should be uppercase, the seond lowercase, the third uppercase,
// and so on. But if an optional boolean parameter of true (or any truthy value) is passed, then
// the effect is opposite (1st character is lower, 2nd is upper, etc).
String.prototype.toAlternatingCase = function(firstToLower) {
	//todo
	print("work in progress");

	if (typeof(firstToLower) === "undefined") {
		firstToLower = false;
	}
	
	var answer = "";
	var modNum = 1;
	if (firstToLower) {
		modNum = 0;
	}
	
	for (var i = 0; i < this.length; i++) {
		if (i % 2 === modNum) {
			answer += this[i].toLowerCase();
		} else {
			answer += this[i].toUpperCase();
		}
		
	}
	
	return answer;	
};

// Pre: String type exists.
// Post: adds a method toLeetSpeak to all strings that contains the same characters as the
// original, but with various subsititutions to convert the text to "Leet Speak".
// Substitue 4 for A, 3 for E, 1 for I, 0 for O, Z for S. Also convert the string to 
// Alternating case, starting with the first letter captitalized. 
String.prototype.toLeetSpeak = function() {
	var replacedA = this.replace(/A/ig, "4");
	var replacedE = replacedA.replace(/E/ig, "3");
	var replacedI = replacedE.replace(/I/ig, "1");
	var replacedO = replacedI.replace(/O/ig, "0");
	var replacedS = replacedO.replace(/S/ig, "Z");
	return replacedS.toAlternatingCase();
}

// Pre: n is valid integer
// Post: returns true if the integer is a prime number, false otherwise
// Note this is memoized version
var isPrime2 = _.memoize(isPrime);


// Pre: minimum and maximum value are integers >= 0
// Post: returns an array containing all prime numbers that appear in that range (inclusive)
// If minimum is greater than the maximum, return empty array. 
function primesInRange(min, max) {
	return _.range(min, max + 1).filter(isPrime2);
}

// Pre: Left value passed is less than or equal to the right value passed and 
// top value passed is less than or equal to the bottom value passed.
// Post: A constructor that accepts the four corner coordinate values and 
// uses them to initialize a newly created rectangle object. The order of the parameters
// is the same as if we were passing two points, (x1, y1), (x2, y2), where the first
// represented the top/left corner of the rectangle and the second represented 
// its bottom/right corner.
function Rectangle(left, top, right, bottom) {
	this.lt = left;
	this.tp = top;
	this.rt = right;
	this.bm = bottom;
}

// Post: Returns a string representation of the rectangle 
// in the format "{left=lt,right=rt,top=tp,bottom=bm}"
Rectangle.prototype.toString = function() {
	return "{left=" + this.lt + ",right=" + 
	this.rt + ",top=" + this.tp + ",bottom=" + this.bm + "}";
};

// Pre: client will pass all expected parameters to each function and that they
// will be of the appropriate type
// Post: Returns a new rectangle representing the largest rectangular area that is contained
// within both this rectangle and the given other rectangle. If rectangles do not overlap
// then function returns null
Rectangle.prototype.union = function(r) {
	return new Rectangle(Math.min(this.lt, r.lt), Math.min(this.tp, r.tp),
						Math.max(this.rt, r.rt), Math.max(this.bm, r.bm));
}

// Pre: client will pass all expected parameters to each function and that they
// will be of the appropriate type
// Post: Returns a representing the largest rectangular area that is 
// contained within both this rectangle and the given other rectangle.
Rectangle.prototype.intersect = function(r) {
	//todo
	print("work in progress");
	if (this.lt < r.lt) {
		if (this.tp < r.tp) {
			if (this.rt > r.rt) {
				if (this.bm > r.bm) {
					return new Rectangle(r.lt, r.tp, r.rt, r.bm);
				} else { //this.bm <= r.bm
					return new Rectangle(r.lt, r.tp, r.rt, this.bm);
				}
			} else {	// this.rt <= r.rt
				if (this.bm > r.bm) {
					return new Rectangle(r.lt, r.tp, this.rt, r.bm);
				} else { //this.bm <= r.bm
					return new Rectangle(r.lt, r.tp, this.rt, this.bm);
				}
			}
		} else { //this.tp >= r.tp
			if (this.rt > r.rt) {
				if (this.bm > r.bm) {
					return new Rectangle(r.lt, this.tp, r.rt, r.bm);
				} else { // this.bm <= r.bm
					return new Rectangle(r.lt, r.tp, r.rt, this.bm);
				}
			} else { //this.rt <= r.rt
				if (this.bm > r.bm) {
					return new Rectangle(r.lt, this.tp, this.rt, r.bm);
				} else { // this.bm <= r.bm
					return new Rectangle(r.lt, this.tp, this.rt, this.bm);
				}
			}
		}
	} else {
		return r.intersect(this);
	}

}

// Pre: client will pass all expected parameters to each function and that they
// will be of the appropriate type
// Post: Returns a true (or any truthy value) if the given point/rectangle lies
// entirely inside of this rectangle, and false (or any falsy value) otherwise.
Rectangle.prototype.contains = function(obj) {
	//todo
	print("work in progress");
}

// Testing variables, delete when done
var s = "Seattle Mariners are a great team eh?";
var n = 7;
var a = [10, 20, 30, 40, 50, 60, 70, 80, 90];
var s2 = "QUICK Fox JUmPs ovEr LazY DOg";
var s3 = "xx xx xx xxx xxx xxxx xxxx";
var s4 = "aaAAeeEEiiIIooOOuuUUssSS";
var r1 = new Rectangle(3, 5, 10, 19);
var r2 = new Rectangle(4, 2, 11, 8); // interesting union/intersection w/ r1
var r3 = new Rectangle(6, 8, 9, 11);
var r4 = new Rectangle(20, 19, 30, 32); // far away from the others
var r5 = new Rectangle(3, 5, 10, 19); // equal to r1
var p1 = {x: 7, y: 8}; // a point contained within r1
var p2 = {x: 1, y: 2}; // a point not contained within r1
