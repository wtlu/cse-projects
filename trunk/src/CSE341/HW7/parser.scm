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

; Pre: valid lst of symbols
; Post: parses a factor at the front of a list, replacing the tokens that were part
; of the factor with the numeric value of the factor
(define (parse-factor lst) 
  (cond [(not (null? lst)) 
         (let ((first (car lst))
               (rest (cdr lst)))
           (cond [(eqv? '+ first) (parse-factor rest)] 
                 [(eqv? '- first) 
                  (let ((answer (parse-factor rest)))
                    (cons (* -1 (car answer)) (cdr answer)))]
                 [(number? first) (cons first rest)]
                 [(symbol=? 'lparen first) 
                  (let ((answer (parse-expression rest)))
                    (cond [(and (not (null? (cdr answer))) 
                                (symbol? (cadr answer)) (symbol=? 'rparen (cadr answer))) 
                           (cons (car answer) (cddr answer))]
                          [(error "illegal factor")]))]
                 [(assoc first functions)
                  (let* ((ansExp (parse-factor rest))
                         (ansCode (list (cdr (assoc first functions)) (car ansExp))))
                    (cons (eval ansCode) (cdr ansExp)))]
                 [else (error "illegal factor")]))]
        [else (error "illegal factor")]))

; Pre: valid lst of symbols
; Post: parses an element at the front of a list, replacing the tokens thatwere part
; of the element with the numeric value of the element
(define (parse-element lst)
  (define (helper tokens)
    (cond [(null? (cdr tokens)) tokens] 
          [(eqv? '^ (cadr tokens))
           (if (null? (cddr tokens)) (error "illegal element")
               (let ((tokAns (parse-factor (cddr tokens))))
                 (helper(cons (expt (car tokens) (car tokAns)) (cdr tokAns)))))]
          [(integer? (car tokens)) tokens]
          [(cons (exact->inexact (car tokens)) (cdr tokens))]))
  (cond [(not (null? lst)) (let ((factorResult (parse-factor lst)))
                             (cond [(null? (cdr factorResult)) factorResult]
                                   [(helper factorResult)]))]
        [else (error "illegal element")]))

; Pre: valid lst of symbols
; Post: parses a term at the front of a list, replacing the tokens that were part
; of the term with the nermeric value of the term
(define (parse-term lst)
  (define (helper tokens)
    (cond [(or (eqv? '* (cadr tokens)) (eqv? '/ (cadr tokens)))
           (let ((tokAns (parse-element (cddr tokens))))
             (if (eqv? '* (cadr tokens)) 
                 (helper(cons (* (car tokens) (car tokAns)) (cdr tokAns)))
                 (helper(cons (exact->inexact(/ (car tokens) (car tokAns))) (cdr tokAns)))))]
          [tokens]))
  (cond [ (not(null? lst)) (let ((elementResult (parse-element lst)))
                             (cond [(null? (cdr elementResult)) elementResult]
                                   [(helper elementResult)]))]
        [else (error "illegal term")]))

; Pre: valid lst of symbols
; Post: parses an expression at the front of a list, replacing the tokens that
; were part of the expression with the numeric value of the expression
(define (parse-expression lst)
  (define (helper tokens)
    (cond [(null? (cdr tokens)) tokens] 
          [(or (eqv? '+ (cadr tokens)) (eqv? '- (cadr tokens)))
           (let ((tokAns (parse-term (cddr tokens))))
             (if (eqv? '+ (cadr tokens)) 
                 (helper(cons (+ (car tokens) (car tokAns)) (cdr tokAns)))
                 (helper(cons (- (car tokens) (car tokAns)) (cdr tokAns)))))]
          [tokens]))
  (cond [(not (null? lst)) (let ((termResult (parse-term lst)))
                             (cond [(null? (cdr termResult)) termResult]
                                   [(helper termResult)]))]
        [else (error "illegal expression")]))

; Pre: valid lst of symbols
; Post: parses a test at teh front of the list, replacing the tokens that were part
; of the test with the boolean value of the test
(define (parse-test lst)
  (let* ((expAns (parse-expression lst))
         (operator (cadr expAns))
         (modedOp (if (symbol=? '<> operator) 'equal? operator))
         (expAns2 (parse-expression (cddr expAns)))
         (code (list modedOp (car expAns) (car expAns2))))
    (if (symbol=? '<> operator) (cons (not(eval code)) (cdr expAns2))
        (cons (eval code) (cdr expAns2)))))