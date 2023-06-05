%% Write a Prolog predicate eqSplit(L,S1,S2) that, given a list of
%% integers L, splits it into two disjoint subsets S1 and S2 such that
%% the sum of the numbers in S1 is equal to the sum of S2. It should
%% behave as follows:
%%
%% ?- eqSplit([1,5,2,3,4,7],S1,S2), write(S1), write('    '), write(S2), nl, fail.
%%
%% [1,5,2,3]    [4,7]
%% [1,3,7]    [5,2,4]
%% [5,2,4]    [1,3,7]
%% [4,7]    [1,5,2,3]


eqSplit(L, S1, S2) :-
    subset(L, S1),
    subtract(L, S1, S2),
    sum_list(S1, Sum),
    sum_list(S2, Sum).

% Generates all subsets of a given list. subset(L, Result).
subset([], []).
subset([H|T], [H|S]) :-
    subset(T, S).
subset([_|T], S) :-
    subset(T, S).
