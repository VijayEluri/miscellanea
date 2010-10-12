#!/usr/bin/env mzscheme

#lang scheme

;; The script runs with mzscheme compiler
;; count-intersections solves a sub problem of the main problem 
;; i.e it only solves the problem where x1 < x2 and y1 < y2
;; That too the stepper procedure inside count-intersections
;; only solves this subproblem for the first block.

;; A "block" is defined as the smallest number of squares 
;; which are intersected by the line such that bottom left
;; co-ordinates of the first square and the top right co-
;; -ordiantes of the last square forming the block are integers.

;; e.g In input example 1. of the given problem, co-ordinates (1, 1) 
;; and (2, 2) form a block.
;; Similarly in input example 3. (1, 1) and (4, 3) form a block.

;; Some points to note:
;; 1. A line is always made up of integral no of blocks (>= 1)
;;     e.g input example 1 is made up of five blocks
;;         input example 2 is made up of 1 block
;;         input example 3 is made up of 2 block and so on...
;; 2. The number of squars intersected in any block for a particular
;;    line will always be the same because of symmetry.

(define (count-intersections x1 y1 x2 y2)
  (define (gradient xi yi xj yj)
    (/ (- yj yi) (- xj xi)))
  (define (length xi yi xj yj)
    (sqrt (+ (sqr (- xj xi)) (sqr (- yj yi)))))
  (define line-length (length x1 y1 x2 y2))
  (define line-gradient (gradient x1 y1 x2 y2))
  (define (gather-info-from-1st-block)
    (define (stepper xi yi intersection-count)
      (let ([grad (gradient x1 y1 (+ xi 1) (+ yi 1))))
        (cond ([< line-gradient grad)
               (stepper (+ xi 1) yi (+ 1 intersection-count)))
              ([> line-gradient grad)
               (stepper xi (+ yi 1) (+ 1 intersection-count)))
              ([= line-gradient grad)
               (cons (cons (+ xi 1) (+ yi 1))
                     (+ 1 intersection-count))))))
    (stepper x1 y1 0))

  (let* ([block-info (gather-info-from-1st-block)) 
         (point (car block-info)) ;; the end-point of the first block
         (block-sqr-cnt (cdr block-info)) 
         (block-length (length x1
                               y1   ;; the starting point of the block is x1 y1 since this is the first block
                               (car point)
                               (cdr point))))
    ;; rounding is used because of results like 5.9999999 etc...
    ;; After rounding numbers look like 5.0 or 6.0 etc so 
    ;; converting them to exact quantities like 5, 6 (just to be on the safer side).

    ;; number of blocks * number of intersected squares in each block
    ;; = total number of intersected squares
    (inexact->exact (round (* (/ line-length block-length) block-sqr-cnt))))) 


(define (count-intersections/preprocess)
  (let* ([argv (current-command-line-arguments))
         (x1 (string->number (vector-ref argv 0)))
         (y1 (string->number (vector-ref argv 1)))
         (x2 (string->number (vector-ref argv 2)))
         (y2 (string->number (vector-ref argv 3))))
    (cond ([or (= x1 x2) (= y1 y2)) 0) ;; no squares interesected
          ([> x1 x2]
           (if (> y1 y2)
               (count-intersections x2 y2 x1 y1) ;; gradient shift by 180 degrees since count-intersection assumes x1 < x2 and y1 < y2 
               (count-intersections x1 y1 (- (* 2 x1) x2) y2))) ;; gradient shift by 2x degrees where x is the angle (clockwise) it makes with y-axis.
          ([< x1 x2]
           (if (< y1 y2)
               (count-intersections x1 y1 x2 y2) ;; ideal case for count-intersections procedure
               (count-intersections x1 y1 x2 (- (* 2 y1) y2))))))) ;; gradient shift by 2x degrees where x is the angle (counter-clockwise) it makes with x-axis.

(count-intersections/preprocess)         







