; CSE341
; Wei-Ting Lu 
; 11/11/2010
; TA: Robert Johnson 
; Quiz Section: AA
; HW6 - This program contains several short individual functions

; Post: returns the given string str repeated the given number of times n 
(define (repl str n)
  (if (<= n 0)
      ""
      (string-append str (repl str (- n 1)))))
     

; Pre: n is positive integer greater than 0
; Post: takes integer n and returns list of factorization of that integer
; with all possible 2s factored out
(define (list-twos n)
  (if (= 1 (modulo n 2))
      (list n)
      (cons 2 (list-twos (/ n 2)))))