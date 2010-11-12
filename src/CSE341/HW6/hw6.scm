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

; Pre: valid list
; Post: takes list of int lst and doubles its length by replacing each
; integer with two numbers that add up to the integer. The two numbers are
; half of the original, but if original number is odd, then first number is higher
; in absolute value than the second
(define (stretch lst)
  (if (null? lst)
      ()
      (let* ((first (car lst)) (half (quotient first 2))) 
        (if (= 0 (modulo first 2))
        (cons half (cons half (stretch (cdr lst))))
        (cons (if (< half 0) (- half 1) (+ half 1)) (cons half (stretch (cdr lst))))))))

; Pre: lst contains at least one element
; Post: computes the sum of the squared values of all the numbers in the lst
(define (sum-squares lst)
  (foldl + 0
         (map (lambda (n) (* n n)) lst)))

; Pre: lst1 and lst2 contain no duplicates
; Post: returns a list of all the ordered pairs that can be formed with one
; value from lst1 and one value from the lst2. The list should be ordered
; first by the order of values from the first list and within those groups, ordered by
; values from the second list
(define (all-pairs lst1 lst2)
  (if (null? lst1)
      ()
      (append (map (lambda (y) (list (car lst1) y))lst2) (all-pairs (cdr lst1) lst2))))

; Test values, delete when done
(define test1 (list 1 2 3 4 5))
(define test2 '(2 8 3.1 2.4 3 6.5))
(define test3 '(13 4 27 9 48))
(define test4 '(38 4 19 7 -5))
(define test5 '(1 2 -3 4))
(define test6 '(3 19 7))
(define test7 '(a b c d))