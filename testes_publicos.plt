:- use_module(library(plunit)).

% Test suite for various predicates
% To run the tests:
% ?- run_tests.

:- begin_tests(predicates).

% Parte 1
test(media_1) :- media([1, 2, 4, 6], Media),
                 assertion(Media =:= 3.25).

test(media_2) :- media([], Media),
                 assertion(Media =:= 0.00).

test(media_3) :- media([1.2, 1.5, 10, 9.6], Media),
                 assertion(Media =:= 5.57).

test(mediaNotasPorIdade_1) :- mediaNotasPorIdade(16, 18, Media),
                 assertion(Media =:= 69.87).

test(mediaNotasPorIdade_2) :- mediaNotasPorIdade(16, 30, Media),
                 assertion(Media =:= 69.95).

test(freqPorGenero_1) :- freqPorGenero(feminino, Media),
                 assertion(Media =:= 84.70).

test(alertaSaude_1) :- alertaSaude(6, 3, 5, ListaAlaunos),
                 assertion(ListaAlaunos == [s1067,s1212,s1348,s1598]).

test(alertaSaude_2) :- alertaSaude(7, 4, 6, ListaAlunos),
                 assertion(ListaAlunos == [s1033,s1051,s1067,s1070,s1118,s1163,s1164,s1209,s1212,s1262,s1298,s1348,s1376,s1399,s1472,s1518,s1551,s1598]).

test(probEcraNotasAltas_1) :- probEcraNotasAltas(4.3, 80, Probabilidade),
                 assertion(Probabilidade =:= 0).

test(probEcraNotasAltas_2) :- probEcraNotasAltas(4, 80, Probabilidade),
                 assertion(Probabilidade =:=  0.21).


test(subtraiValorDeLista_1) :- subtraiValorDeLista([2, 7, 8, 1], 4, Resultado),
                 assertion(Resultado == [-2,3,4,-3]).

test(somaQuadrados_1) :- somaQuadrados([2, 7, 8, 1], Resultado),
                 assertion(Resultado =:= 118).

test(produtoEscalar_1) :- produtoEscalar([2, 4, 6], [1, 2, 3], Resultado),
                 assertion(Resultado =:= 28).

test(correlacao_1) :- correlacao([1, 2, 3], [60, 70, 90], Resultado),
                 assertion(Resultado =:= 0.98).

test(correlacao_2) :- correlacao([1, 2, 3], [90, 70, 60], Resultado),
                 assertion(Resultado =:= -0.98).

test(correlacao_3) :- correlacao([1, 10, 6], [60, 100, 90], Resultado),
                 assertion(Resultado =:= 0.98).
                 
% Parte 2

test(tamanho_1) :- tamanho(fidalgo, T),
                 assertion(T == 7).

test(tamanho_2) :- tamanho(cão, T),
                 assertion(T == 3).

test(tamanho_3) :- tamanho("Palhaço", T),
                 assertion(T == 7).

test(verificaECalcula_1) :- verificaECalcula(palhaço, fidalgo, Lista1, Lista2),
                 assertion(Lista1 == [p,a,l,h,a,ç,o]),
                 assertion(Lista2 == [f,i,d,a,l,g,o]).

test(verificaECalcula_2, [fail]) :- verificaECalcula(palhaço, cão, _, _).


test(quantasN_1) :- quantasN(mini, 7, Quantas),
                 assertion(Quantas == 3).

test(quantasN_2) :- quantasN(mini, 4, Quantas),
                 assertion(Quantas == 0).


test(quantasC_1) :- quantasC(mini, f, Quantas),
                 assertion(Quantas == 1).

test(quantasC_2) :- quantasC(pt, f, Quantas),
                 assertion(Quantas == 47).

test(quantasC_3) :- quantasC(mini, m, Quantas),
                 assertion(Quantas =:= 2).


test(apagaElemento_1) :- apagaElemento(8, [2, 8, 3, 8, 4], L),
                 assertion(L == [2,3,8,4]).

test(apagaElemento_2) :- apagaElemento(5, [2, 8, 3, 8, 4], L),
                 assertion(L == [2,8,3,8,4]).

test(posicoesPalavra_1) :- posicoesPalavra(batata, Posicoes),
                 assertion(Posicoes == [(a,2),(a,4),(a,6),(b,1),(t,3),(t,5)]).

test(pista1_1, [fail]) :- pista1(lara, lar, _).

test(pista1_2) :- pista1(lara, pera, L),
                 assertion(L == [0,0,2,2]).

test(pista1_3) :- pista1(ramal, arara, L),
                 assertion(L == [0,0,0,0,0]).

test(pista1_3) :- pista1(ramal, arara, L),
                 assertion(L == [0,0,0,0,0]).

test(pista1_4) :- pista1(acelera, batatas, L),
                 assertion(L == [0,0,0,0,0,0,0]).


test(pista2_1, [fail]) :- pista2(lara, lar, _).

test(pista2_2) :- pista2(lara, pera, L),
                 assertion(L == [0,0,2,2]).

test(pista2_3) :- pista2(ramal, arara, L),
                 assertion(L == [1,1,1,1,1]).

test(pista2_4) :- pista2(acelera, batatas, L),
                 assertion(L = [0,1,0,1,0,1,0]).

test(pista3_1, [fail]) :- pista3(lara, lar, _).

test(pista3_2) :- pista3(lara, pera, L),
                 assertion(L == [0,0,2,2]).

test(pista3_3) :- pista3(ramal, arara,  L),
                 assertion(L == [1,1,1,0,0]).

test(pista3_4) :- pista3(acelera, batatas, L),
                 assertion(L == [0,1,0,1,0,0,0]).
                 
test(pista3_5) :- pista3(babaa, aabba, L),
                 assertion(L == [1,2,2,1,2]).

test(pista3_5) :- pista3(babaa, aabca, L),
                 assertion(L == [1,2,2,0,2]).
                 

test(maratonaFilmes_1) :- maratonaFilmes([strangeDays, léon, memento, indianaJones, jfk, amadeus, topSecret], [soPode(léon, 1), soPode(amadeus, 5), soPode(jfk, 7), naoSeguido(memento, strangeDays), seguido(amadeus, topSecret), nunca(memento, 2)], Programacao), 
                 assertion(Programacao == [[léon,strangeDays,indianaJones,memento,amadeus,topSecret,jfk]]).

test(maratonaFilmes_2) :-  maratonaFilmes([f1, f2, f3, f4, f5],[soPode(f1, 1), seguido(f1, f2), terror(f3), soPode(f4, 7), naoSeguido(f4, f3), nunca(f5, 6)], Programacao),
                 assertion(Programacao == [[f1,f2,empty,f3,f5,empty,f4],[f1,f2,f3,empty,f5,empty,f4],[f1,f2,f3,f5,empty,empty,f4],[f1,f2,f5,f3,empty,empty,f4]]).

test(maratonaFilmes_3) :- maratonaFilmes([f1, f2, f3, f4, f5], [soPode(f1, 1), seguido(f2, f1)], H),
                 assertion(H == []).

:- end_tests(predicates).    
                