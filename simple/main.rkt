#lang racket

(provide #%module-begin
         [rename-out zero #%datum])

(define-syntax (zero stx)
  (displayln stx)
  #'0)