; 
; author: Stuart Reges
; date: 5/7/09
;  (minor modifications by Marty Stepp, 2010/11/04)
;
; This file contains a function called draw that can be used to produce random
; art.  It assumes that the file hw6.scm includes a working definition of
; the functions all-pairs and generate.

(include "hw6.scm")

; returns the list of integers between x and y inclusive
(define (range x y)
  (if (> x y)
      ()
      (cons x (range (+ x 1) y))))

; produces a drawing of given height and width by generating three functions of
; given expression depth and using them to compute rgb values for each pixel
(define (draw width height depth)
  (define (to-intensity n) (inexact->exact (round (+ 127.5 (* n 127.5)))))
  (define (to-x i) (- (/ (* 2.0 i) width) 1.0))
  (define (to-y i) (- (/ (* 2.0 i) height) 1.0))
  (define (generate-function) (eval (list 'lambda '(x y) (generate depth))))
  (let* ((f1 (generate-function))
         (f2 (generate-function))
         (f3 (generate-function))
         (bitmap (make-object bitmap% width height))
         (bm-dc (make-object bitmap-dc% bitmap))
         (frame (new frame% (label "CSE 341 Random Art") (width width)
                     (height (+ height 20))))
         (canvas (new canvas% (parent frame)
                      (paint-callback
                       (lambda (canvas dc) 
                         (send dc draw-bitmap bitmap 0 0))))))
    (send bm-dc clear)
    (map (lambda (lst)
           (let* ((x1 (car lst))
                  (y1 (cadr lst))
                  (x2 (to-x x1))
                  (y2 (to-y y1))
                  (rgb (lambda (f) (to-intensity (f x2 y2)))))
             (send bm-dc set-pixel x1 y1
                   (make-object color% (rgb f1) (rgb f2) (rgb f3)))))
         (all-pairs (range 0 width) (range 0 height)))
    (send frame show #t)))

; variation of draw that keeps drawing new pictures
(define (draw2 width height depth)
  (define (to-intensity n) (inexact->exact (round (+ 127.5 (* n 127.5)))))
  (define (to-x i) (- (/ (* 2.0 i) width) 1.0))
  (define (to-y i) (- (/ (* 2.0 i) height) 1.0))
  (define (generate-function) (eval (list 'lambda '(x y) (generate depth))))
  (letrec ((bitmap (make-object bitmap% width height))
           (bm-dc (make-object bitmap-dc% bitmap))
           (frame (new frame% (label "CSE 341 Random Art") (width width)
                       (height (+ height 20))))
           (canvas (new canvas% (parent frame)
                        (paint-callback (lambda (canvas dc) 
                                          (send dc draw-bitmap bitmap 0 0)))))
           (loop (lambda ()
                   (let* ((f1 (generate-function))
                          (f2 (generate-function))
                          (f3 (generate-function)))
                     (send bm-dc clear)
                     (map (lambda (lst)
                            (let* ((x1 (car lst))
                                   (y1 (cadr lst))
                                   (x2 (to-x x1))
                                   (y2 (to-y y1))
                                   (rgb (lambda (f) (to-intensity (f x2 y2)))))
                              (send bm-dc set-pixel x1 y1
                                    (make-object color% (rgb f1) (rgb f2) (rgb f3)))))
                          (all-pairs (range 0 width) (range 0 height)))
                                          (send frame show #f)
                     (send frame show #f)
                     (send frame show #t)
                     (sleep/yield 1)
                     (loop)))))
    (loop)))
