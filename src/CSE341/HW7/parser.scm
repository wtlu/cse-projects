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
