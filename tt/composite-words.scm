#!/usr/bin/env mzscheme
#lang scheme

;; the script runs with Mzscheme compiler
;; The procedure composite-words simply goes
;; through each word to see whether its composite
;; or not. The main code lies in count-if-composite
;; procedure. This procedure when given a word
;; tries to find the maximum constituent words
;; (if any) which make up the composite word, and
;; if that number is greater than min no., it 
;; returns 1 else 0.

(define (composite-words word-lengths dictionary M)
  (define MIN-LENGTH 
    3)
  (define MIN-COMPOSITE-LENGTH 
    (* M MIN-LENGTH))
  (define (count-composite-words words)
    (cond ((null? words) 0)
          ((>= (string-length (car words)) MIN-COMPOSITE-LENGTH)
           (+ (count-if-composite (car words)) (count-composite-words (cdr words))))
          (else (count-composite-words (cdr words)))))
  (define (count-if-composite word)
    (define (count-constituent-words word)
      ;; At which position to break the word to check for constituent words depends upon the
      ;; list word-lengths which contains all possible lengths that a word from the given
      ;; dictionay can have.
      (cond ((null? word) 0)
            ((< (string-length word) MIN-LENGTH) 0)
            (else
             (apply 
              max      ;; maximum from the list of numbers (each number representing the number  of constituent sub-words in the given word)
              (map     
               (lambda (word-length)
                 (cond ((< word-length MIN-LENGTH) 0) ;; do not check for constituent words which are less than 3 chars long
                       ((< (string-length word) word-length) 0) ;; no need for checking once we surpass the length of the given word
                       ((= (string-length word) word-length) (hash-ref dictionary word 0))
                       (else (let ((substr (substring word 0 word-length)))
                               (if (hash-ref dictionary substr #f) 
                                   (let ((count (count-constituent-words (substring word word-length))))
                                     (if (= count 0) ;; if no constituents words can be formed out of the remaing string
                                         0           ;; total number of consituents words would be zero even if substr is present in the dictionary. 
                                         (+ count 1))) ;; the remaining string is composed of sub-words, so total no of constituent words is 1 + count, since substr was also a constituent word
                                   0))))) ;;substr not present in dictionary
               word-lengths)))))
    (if (>= (count-constituent-words word) M) 
        1 
        0))
  (count-composite-words (hash-map dictionary (lambda (key value) key))))

(define (composite-words/preprocess)
  (let* ((argv (current-command-line-arguments))
         (file (vector-ref argv 0))
         (min-no-of-constituent-words (vector-ref argv 1))
         (dictionary (make-hash))
         (word-lengths (make-hash)))
    (call-with-input-file file
      (lambda (in)
        (for ((l (in-lines in)))
             (hash-set! dictionary l 1)
             (hash-set! word-lengths (string-length l) #t)))) ;; using hashmap since i want unique lengths, not a single length repeated thousan times
    (composite-words 
     (hash-map word-lengths (lambda (key value) key)) 
     dictionary
     (string->number min-no-of-constituent-words))))

(composite-words/preprocess)