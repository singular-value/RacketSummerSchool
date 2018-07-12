#lang racket
(require (for-syntax syntax/parse))

(define-syntax (where stx)
  (syntax-parse stx
    ((_ body [id val-expr] ...) #'(let ([id val-expr] ...) body))
    )
)

(define-syntax (where* stx)
  (syntax-parse stx
    ((_ body [id val-expr] ...) #`(let* #,(reverse (syntax->list #'([id val-expr] ...))) body))
    )
)


(where (+ my-favorite-number 2)
  [my-favorite-number 8])

(where (op 10 (+ my-favorite-number an-ok-number))
  [my-favorite-number 8]
  [an-ok-number 2]
  [op *])

(where* (list x y z)
  [x (+ y 4)]
  [y (+ z 2)]
  [z 1])