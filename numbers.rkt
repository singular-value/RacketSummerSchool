#lang racket/base
(require (only-in racket/list
                  first
                  [second snd]))

first
snd

(define five 5)

(provide (rename-out [five my-favorite-number]))