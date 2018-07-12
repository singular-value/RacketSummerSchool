#lang racket
(require (for-syntax syntax/parse))
 
(provide #%module-begin
         (rename-out [literal-datum #%datum]
                     [plus +]
                     [multiply *]
                     [minus -]
                     [divide /]
                     [my-sqrt sqrt]
                     [complain-app #%app]
                     [complain-top #%top]
                     [unwrap #%top-interaction])
         square
         conjugate)
 
(define-syntax (literal-datum stx)
  (syntax-parse stx
    [(_ . v:number) #'(#%datum . v)]
    [(_ . b:boolean) #'(#%datum . b)]
    [(_ . s:string) #'(#%datum . s)]
    [(_ . other) (raise-syntax-error #f "not allowed" #'other)]))
 
(define-syntax (plus stx)
  (syntax-parse stx
   [(_ n1 n2) #'(+ n1 n2)]))

(define-syntax (multiply stx)
  (syntax-parse stx
   [(_ n1 n2) #'(* n1 n2)]))

(define-syntax (minus stx)
  (syntax-parse stx
   [(_ n1 n2) #'(- n1 n2)]))

(define-syntax (divide stx)
  (syntax-parse stx
   [(_ n1 n2) #'(/ n1 n2)]))

(define-syntax (square stx)
  (syntax-parse stx
   [(_ n) #'(* n n)]))

(define-syntax (my-sqrt stx)
  (syntax-parse stx
   [(_ n) #'(sqrt n)]))

(define-syntax (conjugate stx)
  (syntax-parse stx
   [(_ n) #'(- (real-part n) (* (imag-part n) 0+i))]))
 
(define-syntax (complain-app stx)
  (define (complain msg src-stx)
    (raise-syntax-error 'parentheses msg src-stx))
  (define without-app-stx
    (syntax-parse stx [(_ e ...) (syntax/loc stx (e ...))]))
  (syntax-parse stx
   [(_)
    (complain "empty parentheses are not allowed" without-app-stx)]
   [(_ n:number)
    (complain "extra parentheses are not allowed around numbers" #'n)]
   [(_ x:id _ ...)
    (complain "unknown operator" #'x)]
   [_
    (complain "something is wrong here" without-app-stx)]))

(define-syntax (complain-top stx)
  (syntax-parse stx
    [(_ . x:id)
     (raise-syntax-error 'variable "unknown" #'x)]))

(define-syntax (unwrap stx)
  (syntax-parse stx
    [(_ . e)
     #'e]))