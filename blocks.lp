
time(0..horizon).

action(move(B,L)) :- block(B), loc(L), B != L.


%on(B,B2,0) :- init(on(B,B2)).

{on(B,L,0)} :- block(B), loc(L), B != L.

clear(B,0) :- not on(B2,B,0) : block(B2), B2 != B; block(B).
clear(table,0).

#program step(t).
{do(A,t) : action(A)} 1.
1 {on(B,L,t) : loc(L), B != L} 1 :- block(B).

clear(B,t) :- not on(B2,B,t) : block(B2), B2 != B; block(B).
clear(table,t).

%precondition
:- do(move(B,L),t), not clear(L,t-1).
:- do(move(B,L),t), not clear(B,t-1).

%postcodition
:- do(move(B,L),t), not on(B,L,t).
%on(B,L,t) :- do(move(B,L),t).

%inertia
:- on(B,L,t), not on(B,L,t-1), not do(move(B,L),t), block(B), time(T), T>0.

% cant have 2 blocks on 1 block
:- on(B1,B,t), on(B2,B,t), B1 < B2, block(B).

% cant have 1 block on 2 blocks
:- on(B,B1,t), on(B,B2,t), B1 < B2.

% block can't be on top of each other
:- on(B1,B2,t), on(B2,B1,t).

% block can't be on itself
:- on(B,B,t).
