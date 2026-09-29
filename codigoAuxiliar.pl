% Auxiliar para arredondar para duas casas decimais
arredonda(X, Y) :-
    Y is round(X * 100) / 100.