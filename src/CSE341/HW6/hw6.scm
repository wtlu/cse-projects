; CSE341
; Wei-Ting Lu 
; 11/11/2010
; TA: Robert Johnson 
; Quiz Section: AA
; HW6 - This program contains several short individual functions

; Pre: str is valid string and n is valid integer
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

; Pre: valid list of numbers
; Post: takes list of numbers and collapse successive pairs of numbers
; by replacing the pair with the sum of the numbers. If list has odd length 
; then last value is not collapsed
(define (collapse lst)
  (if (<= (length lst) 1)
      lst
      (cons (+ (car lst) (cadr lst)) (collapse (cddr lst)))))

; Pre: valid int list
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

; Pre: lst is valid number list and contains at least one element
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

; Pre: n is a valid integer and is greater than or equal to 0
; Post: generates a random expression of depth n
; expression of depth 0 would produce either sumbol x or sumbol y with equal probability
; expression of depth greater than 0 it would produce one of the following five Scheme:
; expressions, each with equal probability
; (cos (* pi expr))
; (sin (* pi expr))
; (/ (+ expr expr) 2.0)
; (/ (round (* expr 10.0)) 10.0)
; (* expr expr)
(define (generate n)
  (let* ((random0or1 (round(random)))
         (random0to4 (round(* (random) 4))))
    (if (= n 0)
    (if (= random0or1 0) 'x 'y)
    (cond ((= random0to4 0) (list 'cos (list '* 'pi (generate (- n 1)))))
          ((= random0to4 1) (list 'sin (list '* 'pi (generate (- n 1)))))
          ((= random0to4 2) (list '/ (list '+ (generate (- n 1)) (generate (- n 1))) 2.0))
          ((= random0to4 3) (list '/ (list 'round (list '* (generate (- n 1)) 10.0)) 10.0))
          ((= random0to4 4) (list '* (generate (- n 1)) (generate (- n 1))))))))