programa(Programa) :- 
    append([[begin], L, [end]], Programa),
    instrucciones(L), !.

%instrucciones(L) --> <instrucciones>.
instrucciones(L):- instruccion(L).
instrucciones(L):- append([L1,[;],L2],L), instruccion(L1), instrucciones(L2).

instruccion([Var1, =, Var2, +, Var3]) :- 
    variable(Var1), variable(Var2), variable(Var3).

instruccion(L) :- 
    append([[if], [Var1], [then], Inst1, [else], Inst2, [endif]], L),
    variable(Var1), instruccion(Inst1), instruccion(Inst2).

variable(x).
variable(y).
variable(z).