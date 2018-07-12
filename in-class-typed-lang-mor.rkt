#lang racket

(require (for-syntax syntax/parse syntax/stx))
(provide
 if
 +
 (rename-out
  [typechecking-mb #%module-begin]))

(begin-for-syntax
  (define (compute e)
    ;; compute : StxExpr -> StxTy
    (syntax-parse e
      [_:integer #'Int]
      [_:boolean #'Bool]
      [_:string #'String]
      [_:function #'Function]
      [((~literal if) e1 e2 e3)
       #:when (check #'e1 #'Bool)
       #:with t (compute #'e2)
       #:when (check #'e3 #'t)
       #'t]
      [((~literal +) e1 e2)
       #:when (check #'e1 #'Int)
       #:when (check #'e2 #'Int)
       #`Int
       ]
      [e (raise-syntax-error
          `compute (format "could not compute type of ~a" (syntax->datum #'e)) #'e)]))


  ; check : ExprStx TyStx -> Bool
  ; checks that the given term has the given type
  (define (check e t-expected)
    (define t (compute e))
    (or (type=? t t-expected)
        (raise-syntax-error
         'check
         (format "error while checking term ~a: expected ~a; got ~a"
                 (syntax->datum e)
                 (syntax->datum t-expected)
                 (syntax->datum t)))))

  ; type=? : TyStx TyStx -> Bool
  ; type equality here is is stx equality
  (define (type=? t1 t2)
    (or (and (identifier? t1) (identifier? t2) (free-identifier=? t1 t2))
        (and (stx-pair? t1) (stx-pair? t2)
             (= (length (syntax->list t1))
                (length (syntax->list t2)))
             (andmap type=? (syntax->list t1) (syntax->list t2)))))

  )

(define-syntax (typechecking-mb stx)
  (syntax-parse stx
    [(_ e ...)
     #:do[(for ([e (syntax->list #'(e ...))])
            (printf "~a: ~a\n"
                    (syntax->datum e)
                    (syntax->datum (compute e))))]
     #'(#%module-begin (void))]))