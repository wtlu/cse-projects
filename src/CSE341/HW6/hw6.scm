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

; Pre: valid list
; Post: takes list of numbers and collapse successive pairs of numbers
; by replacing the pair with the sum of the numbers. If list has odd length 
; then last value is not collapsed
(define (collapse lst)
  (if (<= (length lst) 1)
      lst
      (cons (+ (car lst) (cadr lst)) (collapse (cddr lst)))))

; Test values, delete when done
(define test1 (list 1 2 3 4 5))
(define test2 '(2 8 3.1 2.4 3 6.5))
(define test3 '(13 4 27 9 48))