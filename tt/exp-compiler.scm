#!/usr/bin/env mzscheme
#lang scheme

;; The script runs with the mzscheme compiler, 
;; The generate procedure (in compile) breaks the exp in two halfs,
;; each half acting as an operand to the operator that is present
;; in between e.g (3+2*5) is broken upto in 3, and 2*5 for the
;; operator + (since * has higher precedence). Since each half is 
;; also an expression, they are treated recursively by generate.

;; So when we are done generating instructions for two halfs, i.e
;; for the above given example,
;; for the fist half it would generate 
;; PUSH 3
;; and for the second half, it would generate
;; PUSH 2
;; PUSH 5
;; MUL
;; We simply display the operation i.e operator

;; Here the exp is a list and if the exp contains any parenthesises 
;; in between, then that becomes a separate list
;; e.g ((3+2)*5) exp is a list whose first element is a list with three elements (3 + 2),
;; second element is * and third element is 5
;; Note:: the exp ((3+2)*5) would classify as a mul? exp so that it is broken up into
;; (3+2) and 5 for the operator * (since "parenthesis" take precedence over other operators).

(define (compile exp)
    ;;just a helper functions so that I don't have to repeat myself
  (define (foo  exp operand-1 operand-2 string)
    (generate (operand-1 exp))
    (generate (operand-2 exp))
    (display string) (newline))
  (define (generate exp)
    (cond ((number? exp) (display "PUSH ") (display exp) (newline))
	  ((add? exp) (foo exp addend augend "ADD"))
	  ((sub? exp) (foo exp subtrahand minuend "SUB"))
	  ((mul? exp) (foo exp multiplier multiplicant "MUL"))
	  ((div? exp) (foo exp dividend divisor "DIV"))
	  ((parenthesised? exp) (generate (flat exp)))   ;; to tackle the case when the expression is arbitrarily nested.
	  (else (error "unknown operator/operand type" exp))))
  (generate exp))

(define (add? exp) (operator? exp '+))  ;; checks if the exp has a + operator in it
(define (sub? exp) (operator? exp '-))
(define (mul? exp)
  ;; The checks for + and - are not necessarily required here
  ;; since they (add? and sub?) come above the mul? check 
  ;; in the compile function... but still just for 
  ;; generality
  (and (not (or (operator? exp '+)
		(operator? exp '-)))
       (operator? exp '*)))
(define (div? exp)
  ;; read above comment
  (and (not (or (operator? exp '+)
		(operator? exp '-)))
       (operator? exp '/)))

(define (addend exp) (first-operand exp '+))
(define (augend exp) (second-operand exp '+))
(define (subtrahand exp) (first-operand exp '-))
(define (minuend exp) (second-operand exp '-))
(define (multiplier exp) (first-operand exp '*))
(define (multiplicant exp) (second-operand exp '*))
(define (dividend exp) (first-operand exp '/))
(define (divisor exp) (second-operand exp '/))

(define (operator? exp op) ;; checks whether the exp has the given operator or not
  (define (check-op exp)
    (if (null? exp)
	false
	(or (eq? (car exp) op)
	    (check-op (cdr exp)))))
  (check-op exp))

(define (first-operand exp op) ; returns first operand for operator "op" in exp.
  (define (foo exp)
    (if (or (null? exp) (eq? (car exp) op)) '()
	(cons (car exp)
	    (foo (cdr exp)))))
  (foo exp))
(define (second-operand exp op)
  (define (foo exp)
    (cond ((null? exp) '())
	  ((eq? (car exp) op) (cdr exp))
	  (else (foo (cdr exp)))))
  (foo exp))

(define (flat exp) (car exp)) 
(define (parenthesised? exp) ;; parenthesised expressions are of the for (((3+2)))
  (and (pair? exp))
       (null? (cdr exp)))

(define (exp-compiler/preprocess)
  (let* ((argv (current-command-line-arguments))
         (exp-string (vector-ref argv 0))
         ;; processing the string so the read can convert it to a list/(nested list).
         ;; Also appending the extra parenthesis since for some expressions parenthesis
         ;; may not be provided like 3+2
         (processed-exp-string 
          (string-append "(" 
                         (regexp-replace* #rx"" exp-string " ") 
                         ")")))
    (compile (call-with-input-string 
              processed-exp-string
              read))))

(exp-compiler/preprocess)