#lang brag

taco-program: [ /"\n"* ] taco-leaf+ [ /"\n"* ]
taco-leaf: /"#" taco-or-not{7} /"$"
@taco-or-not: taco | not-a-taco
taco: /"%"
not-a-taco: /"#" /"$"