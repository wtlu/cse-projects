(* 	CSE341
	Wei-Ting Lu 
	11/1/2010
	TA: Robert Johnson 
	Quiz Section: AA
	HW5 - This program contains implementation a structure called CalendarDate
			that can be used to represent calendar dates
*)

type calendarDate = {year: int, month: int, day: int};
(*A type to represent the days in a week*)
datatype day = Sun | Mon | Tue | Wed | Thu | Fri | Sat;

(* Defining an exception type to raise when a date is invalid. *)
exception IllegalDate;