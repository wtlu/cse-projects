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

; the whole program in one giant list, initially empty
(define refWholeCode null)

; Pre:
; Post: runs the given BASIC code that is passed in as a lst
(define (run-program lst)
  (set! refWholeCode lst)
  (cond [(null? lst) ()]
        [(null? (car lst)) ()]
        [(let* ((firstLine (car lst))
               (rest (cdr lst)))
           (cond [(symbol=? 'END (caadr firstLine)) (display "PROGRAM TERMINATED")]
                 [(symbol=? 'REM (caadr firstLine)) (run-program rest)]
                 [(symbol=? 'LET (caadr firstLine)) 
                  (begin (process-let (cdadr firstLine) (car firstLine))(run-program rest))]
                 [(symbol=? 'INPUT (caadr firstLine)) (process-input (cdadr firstLine) (car firstLine)) (run-program rest)]
                 [(symbol=? 'PRINT (caadr firstLine)) 
                  (begin (process-print (cdadr firstLine) (car firstLine)) (run-program rest))]
                 [(symbol=? 'GOTO (caadr firstLine)) (run-program (process-goto (cdadr firstLine) (car firstLine)))]
                 [(symbol=? 'IF (caadr firstLine)) (display "IF statement")(run-program rest)]
                 [(symbol=? 'GOSUB (caadr firstLine)) (display "GOSUB statement")(run-program rest)]
                 [(symbol=? 'RETURN (caadr firstLine)) (display "RETURN statement")(run-program rest)]
                 [(symbol=? 'FOR (caadr firstLine)) (display "FOR statement")(run-program rest)]
                 [(symbol=? 'NEXT (caadr firstLine)) (display "NEXT statement")(run-program rest)]))]))

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

; Pre: statement is a input statement with correct line number
; Post: process the input statement
(define (process-input lst n)
  ;(display "input statement") (newline)
  (cond [(null? lst) (error (string-append "LINE " (number->string n) ": ILLEGAL INPUT COMMAND"))]
        [(let ((varName (car lst))
               (rest (cdr lst)))
           ;(display varName) (newline)
           ;(display rest) (newline)
           (cond [(and (variable? varName) (null? rest))
                  ;(display "now processing and getting input")
                  (let ((inputVal (read)))
                    (if (number? inputVal) (process-let (list varName '= inputVal) n) 
                        (error (string-append "LINE " (number->string n) ": INPUT MUST BE A NUMBER"))))]))]
                 [(error (string-append "LINE " (number->string n) ": ILLEGAL INPUT COMMAND"))]))

; Pre: statement is a goto statement with correct line number
; Post: process the goto statement. If line number does not exists, throws NO SUCH LINE NUMBER
; If GOTO is followed by non-integer or has extraneous text after the integer throws ILLEGAL GOTO
(define (process-goto lst n)
  
  ; Pre: refWholeCode is valid and already set to the BASIC code initally passed in
  ; to run-program
  ; Post: finds the the line number that match the given jumpHere and returns the
  ; code that starts with that line. If line number does not exist, throws error
  ; NO SUCH LINE NUMBER
  (define (findLine lst jumpHere n)
    (cond [(null? lst) (error (string-append "LINE " (number->string n) ": NO SUCH LINE NUMBER"))]
          [(let ((firstLineCode (car lst)))
             (if (= (car firstLineCode) jumpHere)
                 lst
                 (findLine (cdr lst) jumpHere n)))]))
  ;(display refWholeCode) (newline)
  (cond [(null? lst) (error (string-append "LINE " (number->string n) ": ILLEGAL GOTO"))]
        [(let ((lineNum (car lst))
               (rest (cdr lst)))
           (cond [(and (number? lineNum) (null? rest)) (findLine refWholeCode lineNum n)]
                 [(error (string-append "LINE " (number->string n) ": ILLEGAL GOTO"))]))]))
       