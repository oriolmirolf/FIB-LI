% Característiques:
% numcasa, color, profesion, animal, bebida, pais.

solucio(SOL) :- 
    %SOL = [ [1,C1,P1,A1,B1,N1],
    %        [2,C2,P2,A2,B2,N2],
    %        [3,C3,P3,A3,B3,N3],
    %        [4,C4,P4,A4,B4,N4],
    %        [5,C5,P5,A5,B5,N5] ] ,

    SOL = [ [1,_,_,_,_,_],
            [2,_,_,_,_,_],
            [3,_,_,_,_,_],
            [4,_,_,_,_,_],
            [5,_,_,_,_,_] ] , 
%
    %1 - El que vive en la casa roja es de Per ́u
    member( [_, roja, _, _, _, peru], SOL),

    %2 - Al franc ́es le gusta el perro
    member( [_, _, _, perro, _, frances], SOL),
    
    %3 - El pintor es japon ́es
    member( [_, _, pintor, _, _, japones], SOL),

    %4 - Al chino le gusta el ron
    member( [_, _, _, _, ron, chino], SOL),

    %5 - El h ́ungaro vive en la primera casa
    member( [1, _, _, _, _, hungaro], SOL),

    %6 - Al de la casa verde le gusta el co ̃nac
    member( [_, verde, _, _, conyac, _], SOL),

    %7 - La casa verde est ́a justo a la izquierda de la blanca
    member( [NumeroCasaVerde, verde, _, _, _, _], SOL),
    member( [NumeroCasaBlanca, blanca, _, _, _, _], SOL), 
    NumeroCasaVerde is NumeroCasaBlanca - 1,
    
    %8 - El escultor cr ́ıa caracoles
    member( [_, _, escultor, caracoles, _, _], SOL),

    %9 - El de la casa amarilla es actor
    member( [_, amarilla, actor, _, _, _], SOL),

    %10 - El de la tercera casa bebe cava
    member( [3, _, _, _, cava, _], SOL),

    %11 - El que vive al lado del actor tiene un caballo
    member( [Pos1_11, _, actor, _, _, _], SOL),
    member( [Pos2_11, _, _, caballo, _, _], SOL), 
    alLado(Pos1_11, Pos2_11),

    %12 - El h ́ungaro vive al lado de la casa azul
    member( [Pos1_12, azul, _, _, _, _], SOL),
    member( [Pos2_12, _, _, _, _, hungaro], SOL), 
    alLado(Pos1_12, Pos2_12),

    %13 - Al notario la gusta el whisky
    member( [_, _, notario, _, whisky, _], SOL),

    %14 - El que vive al lado del m ́edico tiene un ardilla
    member( [Pos1_14, _, medico, _, _, _], SOL),
    member( [Pos2_14, _, _, ardilla, _, _], SOL),
    alLado(Pos1_14, Pos2_14),
    
    write(SOL), !.

alLado(Pos1, Pos2) :-
    (Pos2 is Pos1 - 1 ; Pos2 is Pos1 + 1).
    