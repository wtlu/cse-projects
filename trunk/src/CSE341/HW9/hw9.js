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

// Pre: string is valid
// Post: returns a new string with same characters as original, but
// with the text converted to "Pig Latin"
function pigLatin() {
	//Todo
    print("work in progress");
}