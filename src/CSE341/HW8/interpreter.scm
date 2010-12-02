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

; whether currently in GOSUB call, initially false
(define inSubroutine #f)

; the statement to go to after gosub call, if called, initally empty
(define refCodeAfterGoSub null)

; list of declared for loops variables, front of the list beings the most recently used value
(define forLoopVars '(X))

; Pre:
; Post: runs the given BASIC code that is passed in as a lst
(define (run-program lst)
  (set! refWholeCode lst)
  (cond [(null? lst) ()]
        [(null? (car lst)) ()]
        [(let* ((firstLine (car lst))
               (rest (cdr lst)))
           (cond [(symbol=? 'END (caadr firstLine)) (process-end (car firstLine))]
                 [(symbol=? 'REM (caadr firstLine)) (run-program rest)]
                 [(symbol=? 'LET (caadr firstLine)) 
                  (begin (process-let (cdadr firstLine) (car firstLine))(run-program rest))]
                 [(symbol=? 'INPUT (caadr firstLine)) (process-input (cdadr firstLine) (car firstLine)) (run-program rest)]
                 [(symbol=? 'PRINT (caadr firstLine)) 
                  (begin (process-print (cdadr firstLine) (car firstLine)) (run-program rest))]
                 [(symbol=? 'GOTO (caadr firstLine)) (run-program (process-goto (cdadr firstLine) (car firstLine)))]
                 [(symbol=? 'IF (caadr firstLine)) (process-if (cdadr firstLine) rest (car firstLine))] ;(run-program rest)]
                 [(symbol=? 'GOSUB (caadr firstLine)) (process-gosub (cdadr firstLine) rest (car firstLine))]
                 [(symbol=? 'RETURN (caadr firstLine)) (process-return (cdadr firstLine) (car firstLine))]
                 [(symbol=? 'FOR (caadr firstLine)) (process-for (cdadr firstLine) rest (car firstLine))(run-program rest)]
                 [(symbol=? 'NEXT (caadr firstLine)) (display "NEXT statement") (process-next (cdadr firstLine) (car firstLine)) (run-program rest)]))]))

; Pre: statement is a end statement
; Post: process the end statement
(define (process-end n)
  (if inSubroutine (error (string-append "LINE " (number->string n) ": MISSING RETURN"))
      (display "PROGRAM TERMINATED")))

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
       
; Pre: statement is a if statement with correct line number. Following the form of if statement
; the line number should be a simple integer
; Post: process the if statement. If the word TEHN is missing or if it's not followed by an integer
; or if the integer has extraneous text after it, thows ILLEGAL IF
(define (process-if lst restCode n)
  ;(display "process if statemnt") (newline)
  (cond [(null? lst) (error (string-append "LINE " (number->string n) ": ILLEGAL IF"))]
        [(let ((lineToProcess (try-parse-test (subsitude-expression lst n) n)))
           ;(display lineToProcess) (newline)
           (cond [(or (null? lineToProcess) (null? (cdr lineToProcess)) 
                      (not (and (symbol? (cadr lineToProcess)) 
                                (symbol=? 'THEN (cadr lineToProcess))))
                      (null? (cddr lineToProcess)) (not (number? (caddr lineToProcess)))) 
                  (error (string-append "LINE " (number->string n) ": ILLEGAL IF"))]
                 [(car lineToProcess) (run-program (process-goto (list (caddr lineToProcess)) n))]
                 [(not (car lineToProcess)) (run-program restCode)]
                 [(error (string-append "LINE " (number->string n) ": ILLEGAL IF"))]))]))

; Pre: statement is a gosub statement with correct line number.
; Post: process the gosub statement. If gosub sommand is not followed by an integer or if it has
; extraneous text after the integer, then thorw ILLEGAL GOSUB. If it tries to execute two GOSUB
; commands in a row without a call on return in between, will throw ALREADY IN SUBROUTINE
(define (process-gosub lst rest n)
  (cond [inSubroutine (error (string-append "LINE " (number->string n) ": ALREADY IN SUBROUTINE"))] 
        [(and (not (null? lst)) (number? (car lst)) (null? (cdr lst)))
         (set! inSubroutine #t) (set! refCodeAfterGoSub rest)
         (run-program (process-goto (list (car lst)) n))]
        [(error (string-append "LINE " (number->string n) ": ILLEGAL GOSUB"))]))

; Pre: statement is a return statement with correct line number
; Post process the return statement.
(define (process-return lst n)
  ;(display "return statement") (newline)
  (cond [(not inSubroutine) (error (string-append "LINE " (number->string n) ": NOT IN SUBROUTINE"))]
        [(null? lst) (set! inSubroutine #f)(run-program refCodeAfterGoSub)]
        [(error (string-append "LINE " (number->string n) ": ILLEGAL RETURN"))]))

; Pre: statement is a for statement with correct line number
; Post: process the for statement. If For is not followed by a legal variable name or
; if the variable is not followed by =, throw ILLEGAL FOR. If the first expression is
; not followed by TO, throw MISSING TO. If there's extra text after second expression
; throw EXTRANEOUS TEXT AFTER ENDING EXPRESSION
; If END command is reached without completing all loops, throw MISSING NEXT
(define (process-for lst rest n)
  (display "FOR work in progress")(newline)
  (cond [(and (not (null? lst)) (variable? (car lst)) (not (null? (cdr lst))) (symbol? (cadr lst))
              (symbol=? '= (cadr lst)))
         (let* ((forVariable (car lst))
                (lineToProcess (try-parse-expression (subsitude-expression (cddr lst) n) n))
                (exp1 (car lineToProcess))
                (preExp2 (if (and (not (null? (cdr lineToProcess))) (symbol? (cadr lineToProcess)) 
                               (symbol=? 'TO (cadr lineToProcess))) 
                          (try-parse-expression (cddr lineToProcess) n) 
                          (error (string-append "LINE " (number->string n) ": MISSING TO"))))
                (exp2 (if (null? (cdr preExp2))
                              (car preExp2)
                              (error (string-append "LINE " (number->string n) 
                                                    ": EXTRANEOUS TEXT AFTER ENDING EXPRESSION"))))) 
           (display "do for loop") (newline) 
           (display exp1) (newline)
           (display exp2) (newline)
           (display lineToProcess) (newline)
           (cond [(display "do stuff now that we're actually in for loop")] 
                 ;Needs to check whether the current variable has been declared
                 ; If so, then check whether this is a inner for loop
                 ; if it's not a inner for loop, just keep going with code
                 ; test whehter exp1 is less than exp2, if so, then run the program in the next line
                 ; if exp1 > exp2, decrement exp1 by 1, jump to line after the next keyword
                 ; if for loop is a inner for loop, needs to check for illegal variables
                 ))]
        [(error (string-append "LINE " (number->string n) ": ILLEGAL FOR"))])
  )

; Pre: statement is a next statement with correct line number
; Post: process the next statement. If the variable mentioned in the next command does not match
; the variable from the most recently encounted for command, throw VARIABLE IN NEXT DOESN'T MATCH
; If program uses same variable in oth an inner and outer loop, throw ILLEGAL NESTED LOOP
; If a next command is not followed by a legal variable name and nothing else, throw ILLEGAL NEXT
; If a next command does not have a corresponding FOR, throw NEXT WITHOUT FOR
(define (process-next lst n)
  (display "NEXT work in progress")
  (cond [(and (not (null? lst)) (variable? (car lst)))
         (let ((currentVar (car lst)))
           (cond [(null? forLoopVars) 
                  (error (string-append "LINE " (number->string n) ": NEXT WITHOUT FOR"))]
                 [(not (symbol=? (car forLoopVars) currentVar)) 
                  (error (string-append "LINE " (number->string n) 
                                        ": VARIABLE IN NEXT DOESN'T MATCH"))]
                 [(let ((lookup (assoc currentVar symbolTable)))
                    (if lookup 
                        (set! symbolTable (cons (cons currentVar (+ (cdr lookup) 1)) symbolTable)) ;Also needs to run-program on the line where it finds the for loop again
                        (error (string-append "LINE " (number->string n) ": ILLEGAL NEXT"))))])) 
         (display symbolTable)]
        [(error (string-append "LINE " (number->string n) ": ILLEGAL NEXT"))]))
