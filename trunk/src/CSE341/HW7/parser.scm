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
          [(symbol=? 'lparen first) 
           (let ((answer (parse-expression rest)))
             (cond [(symbol? (car answer)) (error "illegal factor")] 
                   [(null? (cdr answer)) (error "illegal factor")] ;[(symbol=? 'rparen (car answer)) (error "illegal factor")] 
                   [(symbol=? 'rparen (cadr answer)) (cons (car answer) (cddr answer))]
                   [(error "illegal factor")]))]
          [(assoc first functions)
           (let* ((ansExp (parse-factor rest))
                 (ansCode (list (cdr (assoc first functions)) (car ansExp))))
             (cons (eval ansCode) (cdr ansExp)))]
          [else (error "illegal factor")])))

; Pre:
; Post: parses an element at the front of a list, replacing the tokens thatwere part
; of the element with the numeric value of the element
(define (parse-element lst)
  (define (helper tokens)
    (cond [(null? (cdr tokens)) tokens] 
          [(eqv? '^ (cadr tokens))
           (let ((tokAns (parse-factor (cddr tokens))))
             (helper(cons (expt (car tokens) (car tokAns)) (cdr tokAns))))]
           ;(if (integer? (car tokens))
            ;   tokens
             ;  (cons (exact->inexact (car tokens)) (cdr tokens)))]
          [(integer? (car tokens)) tokens]
          [(cons (exact->inexact (car tokens)) (cdr tokens))]))
  (let ((factorResult (parse-factor lst)))
    (cond [(null? (cdr factorResult)) factorResult]
          [(helper factorResult)])))

; Pre:
; Post: parses a term at the front of a list, replacing the tokens that were part
; of the term with the nermeric value of the term
(define (parse-term lst)
  (define (helper tokens)
    (if (or (eqv? '* (cadr tokens)) (eqv? '/ (cadr tokens)))
        (let ((tokAns (parse-element (cddr tokens))))
          (if (eqv? '* (cadr tokens)) 
              (helper(cons (* (car tokens) (car tokAns)) (cdr tokAns)))
              (helper(cons (exact->inexact(/ (car tokens) (car tokAns))) (cdr tokAns)))))
        tokens))
  (let ((elementResult (parse-element lst)))
    (cond [(null? (cdr elementResult)) elementResult]
          [(helper elementResult)])))

; Post: parses an expression at the front of a list, replacing the tokens that
; were part of the expression with the numeric value of the expression
(define (parse-expression lst)
  (define (helper tokens)
    (if (or (eqv? '+ (cadr tokens)) (eqv? '- (cadr tokens)))
        (let ((tokAns (parse-term (cddr tokens))))
          (if (eqv? '+ (cadr tokens)) 
              (helper(cons (+ (car tokens) (car tokAns)) (cdr tokAns)))
              (helper(cons (- (car tokens) (car tokAns)) (cdr tokAns)))))
        tokens))
  (let ((termResult (parse-term lst)))
    (cond [(null? (cdr termResult)) termResult]
          [(helper termResult)])))

; Post: parses a test at teh front of the list, replacing the tokens that were part
; of the test with the boolean value of the test
(define (parse-test lst)
  (let* ((expAns (parse-expression lst))
        (operator (cadr expAns))
        (modedOp (if (symbol=? '<> operator) '(not equal?) operator))
        (expAns2 (parse-expression (cddr expAns)))
        (code (list modedOp (car expAns) (car expAns2))))
    (cons (eval code) (cdr expAns2))))
    

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
(define test18 '(38.7 / 2 / 3 THEN 210))
(define test19 '(7.4 * lparen 2.4 - 3.8 rparen / 4 - 8.7))
(define test20 '(3 / 4 + 9.7))
(define test21 '(2 * 3 * 4 + 3 * 8))
(define test22 '(24 / 2 - 13.4))
(define test23 '(12.4 - 7.8 * 3.5 THEN 40))
(define test24 '(2 + 3.4 - 7.9 <= 7.4))
(define test25 '(3 * 4 ^ 2 / 5 + SIN lparen 2 rparen))
(define test26 '(15 - 3 - 2 foo 2 + 2))
(define test27 '(lparen 7.3 - 3.4 rparen + 3.4))
(define test28 '(SQR lparen 12 + 3 * 6 - 5 rparen))
(define test29 '(- lparen 2 + 2 rparen * 4.5))
(define test30 '(3.8 2.9 OTHER STUFF))
(define test31 '(- 7.9 3.4 * 7.2))
(define test32 '(3.4 < 7.8 THEN 19))
(define test33 '(2.3 - 4.7 ^ 2.4 <> SQR lparen 8 - 4.2 ^ 2 * 9 rparen FOO))
(define test34 '(2 ^ 4 = 4 ^ 2))

"parse-factor *****************"
(parse-factor '(3.5 2.9 OTHER STUFF))
'(3.5 2.9 OTHER STUFF)
(parse-factor '(- 7.9 3.4 * 7.2))
'(-7.9 3.4 * 7.2)
(parse-factor '(lparen 7.3 - 3.4 rparen + 3.4))
'(3.9 + 3.4)
(parse-factor '(SQR lparen 12 + 3 * 6 - 5 rparen))
'(5)
(parse-factor '(- lparen 2 + 2 rparen * 4.5))
'(-4 * 4.5)
(parse-factor '(- 13 - 17 - 9))
'(-13 - 17 - 9)

"parse-element *****************"
(parse-element '(2 ^ 2 ^ 3 THEN 450))
'(64 THEN 450)
(parse-element '(2 ^ 2 ^ -3 THEN 450))
'(0.015625 THEN 450)
(parse-element '(2.3 ^ 4.5 * 7.3))
'(42.43998894277659 * 7.3)
(parse-element '(7.4 + 2.3))
'(7.4 + 2.3)
(parse-term '(2 ^ 3 ^ 4 ^ 5 2 ^ 3 4 ^ 5))
'(1152921504606846976 2 ^ 3 4 ^ 5)

"parse-term *****************"
(parse-term '(2.5 * 4 + 9.8))
'(10.0 + 9.8)
(parse-term '(38.7 / 2 / 3 THEN 210))
'(6.45 THEN 210)
(parse-term '(7.4 * lparen 2.4 - 3.8 rparen / 4 - 8.7))
'(-2.59 - 8.7)
(parse-term '(3 / 4 + 9.7))
'(0.75 + 9.7)
(parse-term '(2 * 3 * 4 + 3 * 8))
'(24 + 3 * 8)
(parse-term '(24 / 2 - 13.4))
'(12.0 - 13.4)

"parse-expression *****************"
(parse-expression '(12.4 - 7.8 * 3.5 THEN 40))
'(-14.9 THEN 40)
(parse-expression '(2 + 3.4 - 7.9 <= 7.4))
'(-2.5 <= 7.4)
(parse-expression '(3 * 4 ^ 2 / 5 + SIN lparen 2 rparen))
'(10.50929742682568)
(parse-expression '(15 - 3 - 2 foo 2 + 2))
'(10 foo 2 + 2)

"parse-test *****************"
(parse-test '(3.4 < 7.8 THEN 19))
'(#t THEN 19)
(parse-test '(2.3 - 4.7 ^ 2.4 <> SQR lparen 8 - 4.2 ^ 2 * 9 rparen FOO))
'(#t FOO)
(parse-test '(2 ^ 4 = 4 ^ 2))
'(#t)

"illegal *****************"
;(parse-term '(2.5 * 4 *))
;(parse-factor '(foo bar))
;(parse-factor '(- foo))
;(parse-term '(3 * foo))
;(parse-factor '(lparen rparen))
;(parse-factor '(lparen 2 + 3 4)) 