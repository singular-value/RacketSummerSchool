#lang br/quicklang
(require brag/support "grammar.rkt")
(provide (all-from-out br/quicklang) (all-defined-out))

(module+ reader
  (provide read-syntax))

(define (tokenize ip)
  (read-char ip))

(define (taco-program . pieces)
  pieces)

(define (taco-leaf . pieces)
  (integer->char (string->number (list->string (reverse pieces)) 2)))

(define (taco) #\1)

(define (not-a-taco) #\0)

(define (read-syntax src ip)
  (define token-thunk (λ () (tokenize ip)))
  (define parse-tree (parse token-thunk))
  (strip-context
   (with-syntax ([PT parse-tree])
     #'(module winner taco-victory
         (display (apply string PT))))))