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

; testing values delete after use
(define test1 '(2 + 2))
(define test2 '(- 2 + 2))
(define test3 '(+ 2 + 2))
(define test4 '(- - 2 + 2))
(define test5 '(- - - - - 2 2))
(define test6 '(+ - - + + - + - + 2 2))