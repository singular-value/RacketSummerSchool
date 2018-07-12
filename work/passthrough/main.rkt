#lang racket

;;(provide #%module-begin #%datum #%app #%top #%top-interaction + - * /)
(require racket)
(provide (all-from-out racket))

(module reader syntax/module-reader
  passthrough)