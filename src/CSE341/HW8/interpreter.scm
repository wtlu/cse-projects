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
        [(let ((firstLine (car lst))
               (rest (cdr lst)))
           (display (append(firstLine (run-program(rest))))))]))