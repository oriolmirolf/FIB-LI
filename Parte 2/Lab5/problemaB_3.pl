main:- EstadoInicial = [[1, 2, 5, 8], [], i],     EstadoFinal = [[], [1, 2, 5, 8], f],
    between(1,1000,CosteMax),            % Buscamos solución de coste 0; si no, de 1, etc.
    camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
    reverse(Camino, Camino1), write(Camino1), write(' con coste '), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ).              % Caso base: cuando el estado actual es el estado final.
camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ):-
    CosteMax>0,
    unPaso( CostePaso, EstadoActual, EstadoSiguiente ),  % En B.1 y B.2, CostePaso es 1.
    \+member( EstadoSiguiente, CaminoHastaAhora ),
    CosteMax1 is CosteMax-CostePaso,
    camino( CosteMax1, EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal ).

% Movem una persona d'origen a final
unPaso(Cost, [O_I, D_I, i], [O_F, D_F, f]):- 
    select(X, O_I, O_F),
    Cost is X,
    append([X], D_I, TMP2), sort(TMP2, D_F).
    
% Movem dues persona d'origen a final
unPaso(Cost, [O_I, D_I, i], [O_F, D_F, f]):- 
    select(X, O_I, TMP),
    select(Y, TMP, O_F),
    Cost is max(X, Y),
    append([X, Y], D_I, TMP2), sort(TMP2, D_F).

% Movem una persona de desti a origen
unPaso(Cost, [O_I, D_I, f], [O_F, D_F, i]):- 
    select(X, D_I, D_F),
    Cost is X,
    append([X], O_I, TMP2), sort(TMP2, O_F).
    
% Movem dues persona desti a origen
unPaso(Cost, [O_I, D_I, f], [O_F, D_F, i]):- 
    select(X, D_I, TMP),
    select(Y, TMP, D_F),
    Cost is max(X, Y),
    append([X, Y], O_I, TMP2), sort(TMP2, O_F).