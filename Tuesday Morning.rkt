#lang racket
(require rackunit
         (for-syntax syntax/parse))

(define-syntax (where stx)
  (syntax-parse stx
    [(_ body:expr
        [name:id rhs:expr] ...)
     #'(let ([name rhs] ...) body)
     ]))

(define-syntax (where* stx)
  (syntax-parse stx
    [(_ body:expr
        [name:id rhs:expr] ...)

     #`(let* #,(reverse (syntax->list #'([name rhs] ...))) body)
     ]))

(check-equal? (where (+ my-favorite-number 2) [my-favorite-number 8])
              (let ([my-favorite-number 8]) (+ my-favorite-number 2)))

(check-equal? (where (op 5) [op (lambda (x) (+ x x))])
              (let ([op (lambda (x) (+ x x))]) (op 5)))

(check-equal? (where 5)
              (let ()
                5))

(check-equal? (where (op 10 (+ my-favorite-number an-ok-number))
                     [my-favorite-number 8]
                     [an-ok-number 2]
                     [op *])
              (let ([my-favorite-number 8]
                    [an-ok-number 2]
                    [op *])
                (op 10 (+ my-favorite-number an-ok-number))))

(check-equal? (where* (list x y z)
                      [x (+ y 4)]
                      [y (+ z 2)]
                      [z 1])
              (let* ([z 1]
                    [y (+ z 2)]
                    [x (+ y 4)])
                (list x y z)))