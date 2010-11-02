(*
CSE 341, ML Homework 5 (Date)
This signature provides an external interface for a structure that provides
various functions to manipulate calendar dates.
Your file should implement this signature and all of its various functions.
*)

signature CALENDARDATE =
sig
    (* types and exceptions *)
    type calendarDate;
    datatype day = Sun | Mon | Tue | Wed | Thu | Fri | Sat;
    exception IllegalDate;
    
    (* 'constructor' *)
    val new: int * int * int -> calendarDate;

    (* functions *)
    val compare: calendarDate * calendarDate -> order;
    val daysBetween: calendarDate * calendarDate -> int;
    val daysInMonth: calendarDate -> int;
    val daysInYear: calendarDate -> int;
    val isLeapYear: calendarDate -> bool;
    val next: calendarDate -> calendarDate;
    val previous: calendarDate -> calendarDate;
    val shift: calendarDate * int -> calendarDate;
    val toString: calendarDate -> string;

    (* extra credit functions *)
    val dayOfWeek: calendarDate -> day;
    val today: unit -> calendarDate;
end;
