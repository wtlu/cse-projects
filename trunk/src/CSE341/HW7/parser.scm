; CSE341
; Wei-Ting Lu 
; 11/16/2010
; TA: Robert Johnson 
; Quiz Section: AA
; HW7 - This program contains set of procedures for parsing various token sequences
; that appear in programs written in the BASIC language

; the grammar is as follows:
; <test> ::= <expression> ("<" | ">" | "<=" | ">=" | "=" | "<>") <expression>
; <expression> ::= <term> {("+" | "-") <term>}
; <term> ::= <element> {("*" | "/") <element>}
; <element> ::= <factor> {"^" <factor>}
; <factor> ::= <number> | ("-" | "+") <factor> | "(" <expression> ")" | 
;              <f> "(" <expression> ")"
; <f> ::= SIN | COS | TAN | ATN | EXP | ABS | LOG | SQR | RND | INT

; below is an association list indicating what Scheme procedure to call
; for each BASIC function
(define functions
  '((SIN . sin) (COS . cos) (TAN . tan) (ATN . atan) (EXP . exp) (ABS . abs)
    (LOG . log) (SQR . sqrt) (RND . rand) (INT . trunc)))

; have to define our own random number function because BASIC ignores its
; argument
(define (rand n) (random))

; have to define our own trunc function because BASIC returns an int
(define (trunc n) (inexact->exact (truncate n)))

; Pre:
; Post: parses a factor at the front of a list, replacing the tokens that were part
; of the factor with the numeric value of the factor
(define (parse-factor lst) 
  (let ((first (car lst))
        (rest (cdr lst)))
    (cond [(eqv? '+ first) (parse-factor rest)] 
          [(eqv? '- first) 
           (let ((answer (parse-factor rest)))
             (cons (* -1 (car answer)) (cdr answer)))]
          [(number? first) (cons first rest)]
          [else (display "first thing is not a number")])))

; Pre:
; Post: parses an element at the front of a list, replacing the tokens thatwere part
; of the element with the numeric value of the element
(define (parse-element lst)
  (define (helper tokens)
    (if (eqv? '^ (cadr tokens))
        (let ((tokAns (parse-factor (cddr tokens))))
          (helper(cons (expt (car tokens) (car tokAns)) (cdr tokAns))))
        (if (integer? (car tokens))
            tokens
            (cons (exact->inexact (car tokens)) (cdr tokens)))))
  (let ((factorResult (parse-factor lst)))
    (cond [(null? (cdr factorResult)) factorResult]
          [(helper factorResult)])))

; Pre:
; Post: parses a term at the front of a list, replacing the tokens that were part
; of the term with the nermeric value of the term
(define (parse-term lst)
  (define (helper tokens)
    (if (eqv? '* (cadr tokens))
        (let ((tokAns (parse-element (cddr tokens))))
          (helper(cons (* (car tokens) (car tokAns)) (cdr tokAns))))
        (if (integer? (car tokens))
            tokens
            (cons (exact->inexact (car tokens)) (cdr tokens))))
    )
  (let ((elementResult (parse-element lst)))
    (cond [(null? (cdr elementResult)) elementResult]
          [(helper elementResult)])))

; testing values delete after use
(define test1 '(2 + 2))
(define test2 '(- 2 + 2))
(define test3 '(+ 2 + 2))
(define test4 '(- - 2 + 2))
(define test5 '(- - - - - 2 2))
(define test6 '(+ - - + + - + - + 2 2))
(define test7 '(2 ^ 2 ^ 3 THEN 450))
(define test8 '(2 ^ 2 ^ -3 THEN 450))
(define test9 '(2.3 ^ 4.5 * 7.3))
(define test10 '(7.4 + 2.3))
(define test11 '(2 ^ 3 ^ 4 ^ 5 2 ^ 3 4 ^ 5))
(define test12 '(- - - 2 + 2))
(define test13 '(2 ^ 3 - 4))
(define test14 '(- - 2 ^ - - - 3 * 17))
(define test15 '(2 ^ 3 ^ 2 / 14))
(define test16 '(- - - 7 ^ - - 4 ^ - - - 2 < 74.5))
(define test17 '(2.5 * 4 + 9.8))