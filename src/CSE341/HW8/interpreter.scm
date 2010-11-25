; CSE341
; Wei-Ting Lu 
; 11/22/2010
; TA: Robert Johnson 
; Quiz Section: AA
; HW8 - This program implements a subset of the BASIC programming language

(include "hw7.scm")
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
           ;(display firstLine)
           ;(display rest)
           (cond [(symbol=? 'END (caadr firstLine)) (display "PROGRAM TERMINATED")]
                 [(symbol=? 'REM (caadr firstLine)) (begin (display "comment")(newline)(run-program rest))]
                 [(symbol=? 'LET (caadr firstLine)) (begin (display "let ") (newline) (process-let (cdadr firstLine) (car firstLine))(run-program rest))]
                 [(symbol=? 'PRINT (caadr firstLine)) (let* ()
                                                        (begin (display "print statement")(newline)(run-program rest)))]))]))

; Pre: statement is a let statement with correct line number
; Post: process the let statement
(define (process-let lst n)
  (let* ((varName(car lst))
         (equalsSign(cadr lst))
         (restLine(cddr lst)))
    ;(display "The Whole line is")
    ;(display lst)
    (display "\nThe rest of the line is ")
    (display restLine) (newline)
  (cond [(and (variable? varName) (symbol=? '= equalsSign))
         (let ((resultLst(subsitude-expression restLine n)))
           (display "the resulting lst is")
           (display resultLst)
           (display "processing let statement") (newline) (set! symbolTable (cons (cons varName (try-parse-expression (subsitude-expression restLine n) n)) symbolTable))
           (display symbolTable))]
        [(display "ILLEGAL LET")])))

; Pre: statement is a valid expression
; Post: process the list and replace any variables found with the one from symbolTable
(define (subsitude-expression lst n)
  ;(display "Subbing in this list:")
  ;(display lst)
  ;(newline)
  (cond [(null? lst) lst]
        [(let ((first (car lst))
               (rest (cdr lst)))
           (cond [(variable? first) (display "looking up:")(display first)
                                    (let ((lookup (assoc first symbolTable)))
                                      (display "lookup is:")
                                      (display lookup)
                                      (if lookup (cons (cadr lookup) (subsitude-expression rest n))
                                          (error "LINE" n': "DEBUG ILLEGAL EXPRESSION")))]
                 [else (cons first (subsitude-expression rest n))]))])
  ;(display "result lst is:")
  ;(display lst) (newline)
  )