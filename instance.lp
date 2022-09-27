#const horizon=12.

block(1..3).
loc(table).
loc(B) :- block(B).

init(on(1,table)).
init(on(2,1)).
init(on(3,2)).

goal(on(3,table)).
goal(on(2,3)).
goal(on(1,2)).
