#lang racket

(require (for-syntax racket/list))
(require (for-syntax syntax/parse))
(require rackunit)

;; SYNTAX
;; (define-hello world good bye damn it)
;; means the identifiers 'world' ''good' 'bye' 'damn' 'it' are all bound to "good bye"
;; translate this to code of the shap
;; (define world "good bye")
;; (define good "good bye")
;; (define bye "good bye")
;; (define damn "good bye")
;; ...



(define-syntax (define-hello stx)
  (syntax-parse stx
    [(_ the-identifier:id ...)
     #'(define-values (the-identifier ...)
         (values (begin 'the-identifier "good bye") ...))]))

(define-hello world good bye damn it)

(define-syntax (some stx)
  (syntax-parse stx
    [(_ e0:expr)
     #'(let ([the-value-of-e0 e0])
         (and the-value-of-e0 (list the-value-of-e0) #f))]))

(check-equal? (some #f) #f)
(check-equal? (some 3) (list 3))
(check-equal? (some (begin (displayln "hello world") 3 )) (list 3))