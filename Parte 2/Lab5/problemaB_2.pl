main:- EstadoInicial = [[3, 3],  [0, 0], i],     EstadoFinal = [[0, 0], [3, 3], f],
    between(1,1000,CosteMax),            % Buscamos solución de coste 0; si no, de 1, etc.
    camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
    reverse(Camino, Camino1), write(Camino1), write(" con coste "), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ).              % Caso base: cuando el estado actual es el estado final.
camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ):-
    CosteMax>0,
    unPaso( CostePaso, EstadoActual, EstadoSiguiente ),  % En B.1 y B.2, CostePaso es 1.
    \+member( EstadoSiguiente, CaminoHastaAhora ),
    CosteMax1 is CosteMax-CostePaso,
    camino( CosteMax1, EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal ).


% P_O_I = Persones en Origen en Inicial
% C_D_F = Canibals en Desti en Final

unPaso(1, [[P_O_I, C_O_I], [P_D_I, C_D_I], i], [[P_O_F, C_O_F], [P_D_F, C_D_F], f]) :-
    between(0, 2, MovPersona), between(0, 2, MovCanibal),
    MovPersona + MovCanibal >= 1,
    MovPersona + MovCanibal =< 2,
    MovPersona =< P_O_I,
    MovCanibal =< C_O_I,
    P_D_F is P_D_I + MovPersona,
    C_D_F is C_D_I + MovCanibal,
    P_O_F is P_O_I - MovPersona, 
    C_O_F is C_O_I - MovCanibal,
    (P_O_F = 0 ; P_O_F >= C_O_F),
    (P_D_F = 0 ; P_D_F >= C_D_F).

unPaso(1, [[P_O_I, C_O_I], [P_D_I, C_D_I], f], [[P_O_F, C_O_F], [P_D_F, C_D_F], i]) :-
    between(0, 2, MovPersona), between(0, 2, MovCanibal),
    MovPersona + MovCanibal >= 1,
    MovPersona + MovCanibal =< 2,
    MovPersona =< P_D_I,
    MovCanibal =< C_D_I,
    P_D_F is P_D_I - MovPersona,
    C_D_F is C_D_I - MovCanibal,
    P_O_F is P_O_I + MovPersona, 
    C_O_F is C_O_I + MovCanibal,
    (P_O_F = 0 ; P_O_F >= C_O_F),
    (P_D_F = 0 ; P_D_F >= C_D_F).