; CSE341
; Wei-Ting Lu 
; 11/22/2010
; TA: Robert Johnson 
; Quiz Section: AA
; HW8 - This program implements a subset of the BASIC programming language

(include "parser.scm")
(include "hw8-support.scm")

; cache of declared variables, initially empty
(define symbolTable null)

; Pre:
; Post: runs the given BASIC code that is passed in as a lst
(define (run-program lst)
  (cond [(null? lst) ()]
        [(null? (car lst)) ()]
        [(let* ((firstLine (car lst))
               (rest (cdr lst)))
           (cond [(symbol=? 'END (caadr firstLine)) (display "PROGRAM TERMINATED")]
                 [(symbol=? 'REM (caadr firstLine)) (run-program rest)]
                 [(symbol=? 'LET (caadr firstLine)) 
                  (begin (process-let (cdadr firstLine) (car firstLine))(run-program rest))]
                 [(symbol=? 'PRINT (caadr firstLine)) 
                  (begin (process-print (cdadr firstLine) (car firstLine)) (run-program rest))]))]))

; Pre: statement is a let statement with correct line number
; Post: process the let statement
(define (process-let lst n)
  (let* ((varName(car lst))
         (equalsSign(cadr lst))
         (restLine(cddr lst)))
  (cond [(and (variable? varName) (symbol=? '= equalsSign))
         (let* ((resultLst(subsitude-expression restLine n))
                (resultLst2(try-parse-expression resultLst n)))
            (set! symbolTable (cons (cons varName (car(try-parse-expression (subsitude-expression restLine n) n))) symbolTable)))]
        [(display "ILLEGAL LET")])))

; Pre: statement is a valid expression
; Post: process the list and replace any variables found with the one from symbolTable
(define (subsitude-expression lst n)
  (cond [(null? lst) lst]
        [(let ((first (car lst))
               (rest (cdr lst)))
           (cond [(variable? first) (let ((lookup (assoc first symbolTable)))
                                      (if lookup (cons (cdr lookup) (subsitude-expression rest n))
                                          (error "LINE" n': "DEBUG ILLEGAL EXPRESSION")))]
                 [else (cons first (subsitude-expression rest n))]))])
  )

; Pre: statement is a print statement with correct line number
; Post: process the print statement
(define (process-print lst n)
  ;(display "to print:")
  ;(display lst)
  (cond [(null? lst) (newline)]
        [(let ((first (car lst))
               (rest (cdr lst)))
           (cond [(and (symbol? (car lst)) (symbol=? 'comma (car lst))) (display " ")
                  (if (not (null? rest)) (process-print rest n))]
                 [(string? (car lst)) (display (car lst)) (process-print rest n)]
                 [else (let ((newResult (try-parse-expression (subsitude-expression lst n) n))) 
                         (display(car newResult)) (process-print (cdr newResult) n))]))]))