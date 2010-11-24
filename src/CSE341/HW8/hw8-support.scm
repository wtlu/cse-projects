; CSE 341 support file for BASIC Interpreter
; originally written by Stuart Reges, 11/20/09
; modified by Marty Stepp, 11/20/2010

(require (lib "13.ss" "srfi")) ; for renumber

; predicate to test whether a value is a legal variable name in BASIC
(define (variable? v)
  (and (symbol? v)
       (let* ((chars (string->list (symbol->string v)))
              (len (length chars)))
         (and (pair? chars) (<= len 2) (char-upper-case? (car chars))
              (or (= len 1) (char-numeric? (cadr chars)))))))

; This method tries to execute function f with given lst; if an error occurs,
; it generates a new error with a line number and the given name
(define (try-f f lst n name)
  (with-handlers
   ((exn:fail?
     (lambda (exn)
       (error (string-append "LINE " (number->string n) ": ILLEGAL " name)))))
   (f lst)))

; function to try calling parse-test (reporting line number n if error)
(define (try-parse-test lst n)
  (try-f parse-test lst n "test"))

; function to try calling parse-expression (reporting line number n if error)
(define (try-parse-expression lst n)
  (try-f parse-expression lst n "expression"))
                               
; converts a string to a list of tokens; uses special tokens lparen, rparen
; and comma for ( ) ,
(define (tokenize str)
  (let ((re "[A-Z][A-Z0-9]*|<=|>=|<>|[-+*/(),^<>=]|[^-+*/<>=(),^A-Z]+"))
    (define (is-string s)
      (and (>= (string-length s) 1) (equal? "\"" (substring s 0 1))))
    (define (expand s)
      (regexp-match* re s))
    (define (to-symbol s)
      (let ((n (string->number s)))
        (cond
         (n n)
         ((equal? s "(") 'lparen)
         ((equal? s ")") 'rparen)
         ((equal? s ",") 'comma)
         (else (string->symbol s)))))
    (define (process s)
      (if (is-string s)
          (list (substring s 1 (- (string-length s) 1)))
          (map to-symbol
               (foldr append ()
                      (map expand (regexp-split "[ \t\r]+" s))))))
    (foldr append ()
           (map process
                (regexp-match* "[^\"]+|\"[^\"]*\"" (string-upcase str))))))

; special global variable for debugging purposes--remembers what value was
; most recently passed to run-program
(define debug ())

; main driver loop
(define main-loop
  (let ((program ())  ; current program, list of lists each with 3 values:
		      ; (line-number line-text line-tokens)
	(current-file-name "program.txt"))

    ; Examines the current program to make sure that it has a single legal
    ; END command as last line of program and if it does, it runs the
    ; current program (converts the 3-element lists into 2-element lists by
    ; stripping out the line text and calls run-program)
    (define (do-run)
      (define (strip lst) (list (car lst) (caddr lst)))
      (define (okay-end lst)
        (and (pair? lst)
             (let ((line (caddr (car lst))))
               (if (> (length lst) 1)
                   (and (not (eq? (car line) 'END))
                        (okay-end (cdr lst)))
                   (and (eq? (car line) 'END)
                        (null? (cdr line)))))))
      (if (pair? program)
          (if (okay-end program)
              (begin (set! debug (map strip program)) (run-program debug)
		     (newline))
              (begin (display "PROGRAM MUST HAVE ONE END COMMAND AS LAST LINE")
                     (newline)))))

    ; records a line of the program:
    ;   if line number is new, add to the program
    ;   if line number is old and text is empty, remove line
    ;   if line number is old and text is nonemmpty, replace old line
    (define (add-line number text)
      (letrec ((line (list number text (tokenize text)))
	       (delete (lambda (lst)
                         (cond ((null? lst) ())
                               ((> (caar lst) number) lst)
                               ((= (caar lst) number) (cdr lst))
                               (else (cons (car lst) (delete (cdr lst)))))))
               (search (lambda (lst)
                         (cond ((null? lst) (list line))
                               ((> (caar lst) number) (cons line lst))
                               ((= (caar lst) number) (cons line (cdr lst)))
                               (else (cons (car lst) (search (cdr lst))))))))
	(set! program (if (equal? text "")
			  (delete program)
			  (search program)))))

    ; prints text of the program
    (define (print-program)
      (let ((print-one (lambda (line)
                         (begin (display (car line))
                                (display (cadr line))
                                (newline)))))
        (map print-one program)))

    ; write only the text lines when writing the program
    (define (write-program p out)
      (define (process-entry e)
        (display (car e) out)
        (display (cadr e) out)
        (newline out))
      (map process-entry p))

    ; save current program using current file name, overwriting any old file
    (define (do-save)
      (let ((out (open-output-file current-file-name 'replace)))
        (write-program program out)
        (close-output-port out))
      (display "PROGRAM SAVED TO ")
      (display current-file-name)
      (newline))

    ; reset file name
    (define (reset-file-name prompt)
      (let ((response (read-line)))
        (set! current-file-name
              (if (> (string-length response) 0)
                  (substring response 1)
                  (begin (display prompt) (read-line))))))

    ; read the text lines and reconstruct program
    (define (read-program)
      (define (process in)
        (let ((line-number (read in)))
          (if (eof-object? line-number)
              ()
              (begin (add-line line-number (string-upcase (read-line in)))
                     (process in)))))
      (set! program ())
      (process (open-input-file current-file-name 'text))
      (display "READY.")
      (newline))
 
    ; restore saved file (new version with text only)
    (define (do-old)
      (reset-file-name "OLD FILE NAME TO OPEN? ")
      (read-program))

    ; start a new file
    (define (do-new)
      (set! program ())
      (do-rename))

    ; rename current program
    (define (do-rename)
      (reset-file-name "NEW FILE NAME TO USE? "))

    ; renumber lines of the program in increments of 10 (uses string library)
    (define (do-renumber)
      (define (make-table p n)
        (if (null? p)
            ()
            (cons (cons (caar p) n) (make-table (cdr p) (+ n 10)))))
      (define (replace-number str target num)
        (let ((index (string-contains str target))
              (str-num (number->string num)))
          (string-append (substring str 0 index) target " " str-num)))
      (define (replace-last lst value)
        (if (= (length lst) 1)
            (list value)
            (cons (car lst) (replace-last (cdr lst) value))))
      (define (last lst)
        (if (= (length lst) 1)
            (car lst)
            (last (cdr lst))))
      (define (one-entry entry table)
        (let* ((old-number (car entry))
               (new-number (cdr (assoc old-number table)))
               (old-string (cadr entry))
               (old-list (caddr entry))
               (command (car old-list)))
          (if (member command '(GOSUB GOTO IF))
              (let* ((number (last old-list))
                     (replacement (cdr (assoc number table))))
                (set! old-list (replace-last old-list replacement))
                (cond ((eq? command 'IF)
                       (set! old-string (replace-number old-string "THEN" replacement)))
                      ((eq? command 'GOSUB)
                       (set! old-string (replace-number old-string "GOSUB" replacement)))
                      ((eq? command 'GOTO)
                       (set! old-string (replace-number old-string "GOTO" replacement))))))
          (list new-number old-string old-list)))
      (let ((table (make-table program 10)))
        (set! program (map (lambda (e) (one-entry e table)) program))))

    ; main loop
    (define (loop)    
      (let* ((token (read))
             (command 
              (if (symbol? token)
                  (string->symbol (string-upcase (symbol->string token)))
                  token))
             (help "LEGAL COMMANDS ARE LIST, NEW, OLD, RENAME, RENUMBER, RUN, SAVE, STOP, UNSAVE")
             (display-line (lambda (text) (begin (display text) (newline)))))
        (if (eq? command 'STOP)
            (display-line "BYE BYE")
            (begin
              (cond ((eq? command 'LIST) (print-program))
                    ((eq? command 'RUN) (do-run))
                    ((eq? command 'SAVE) (do-save))
                    ((eq? command 'NEW) (do-new))
                    ((eq? command 'OLD) (do-old))
                    ((eq? command 'RENAME) (do-rename))
                    ((eq? command 'RENUMBER) (do-renumber))
                    ((and (integer? command) (> command 0))
                     (add-line command (string-upcase (read-line))))
                    ((eq? command 'UNSAVE) (read-program))
                    (else (display-line help)))
              (newline)
              (loop)))))
    loop))

; variation of mainloop that catches errors
(define (run)
  (with-handlers ((exn:fail? (lambda (exn)
                               (display (exn-message exn))
                               (newline)
                               (newline)
                               (run))))
                 (main-loop)))
