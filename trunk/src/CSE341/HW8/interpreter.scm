; CSE341
; Wei-Ting Lu 
; 11/22/2010
; TA: Robert Johnson 
; Quiz Section: AA
; HW8 - This program implements a subset of the BASIC programming language

(include "hw7.scm")
(include "hw8-support.scm")

(define (run-program lst)
  (cond [(null? lst) ()]
        [(null? (car lst)) ()]
        [(let* ((firstLine (car lst))
               ;(debug1 (display firstLine))
               (rest (cdr lst))
               ;(debug2 (display rest))
               )
           (cond [(symbol=? 'END (caadr firstLine)) (display '"PROGRAM TERMINATED")]
                 [(symbol=? 'REM (caadr firstLine)) (run-program rest)]))]))