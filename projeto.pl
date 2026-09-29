:- encoding(utf8).
% Margarida Mineiro 1117883
:- style_check(-discontiguous). % para nao se queixar descontinuidade da BD
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- ['codigoAuxiliar.pl']. % Ficheiro dado
:- ['bd_estudantes.pl']. % Ficheiro dado
:- ['listas_palavras.pl']. % Ficheiro dado

% Parte I
% Função que devolve a média de uma lista de valores
media([], 0) :- !.
media(ListaValores, Media) :-
    sum_list(ListaValores, Soma),
    length(ListaValores, Contagem), 
    Contagem > 0,
    arredonda(Soma/Contagem, Media). 

% Função que devolve a média dos alunos com idade entre X e Y
mediaNotasPorIdade(IdadeMin, IdadeMax, Media) :-
    findall(Nota, 
        ( estudante(Id, Idade, _),
          Idade > IdadeMin,
          Idade =< IdadeMax,
          exame(Id, Nota)
        ), 
        Notas),
    media(Notas, Media).

% Função Aux que seleciona o género e a frequência de aulas
genFreq(Gen, Freq) :-
    estudante(Id, _, Gen),
    atividade(Id, _, _, Freq).

% Função que devolve a média da frequência de aulas por género
freqPorGenero(Genero, MediaFreq) :- 
    findall(Freq, 
        ( genFreq(Gen, Freq), 
          Genero == Gen
        ), 
    Frequencias),
    media(Frequencias, MediaFreq).

% Função que devolve os alunos que não se encontram em boa saúde 
alertaSaude(HorasSono, Exercicio, SaudeMental, ListaAlunos) :- 
    findall(Id,
        ( saude(Id, Horas, QualidadeAlimentacao, Exerc, Saude),
          QualidadeAlimentacao == fraca,
          Horas < HorasSono,
          Exerc < Exercicio,
          Saude < SaudeMental
        ),
    ListaAlunos).

% Função que devolve a probabilidade de um aluno atingir 
% uma nota com base no nº de horas que passa à frente de um ecrã
probEcraNotasAltas(HorasEcra, Nota, Probabilidade) :- 
    findall(N, 
        ( atividade(Id, _, Horas, _),
          Horas > HorasEcra,
          exame(Id, N),
          N > Nota
        ), 
        Ns),
    length(Ns,PUniao),
    findall(Id,
        ( atividade(Id, _, Horas, _), 
          Horas > HorasEcra
        ), 
        Ids),
    length(Ids, PHoras), 
    arredonda(PUniao / PHoras, Probabilidade).

% Função que subtrai o valor de todos os elementos da lista
subtraiValorDeLista([], _, []).
subtraiValorDeLista([P|R], Valor, [Pf|Rf]) :-
    Pf is P - Valor,
    subtraiValorDeLista(R, Valor, Rf).

% Função que devolve a soma do quadrado dos elementos de uma lista
somaQuadrados([], 0).
somaQuadrados([P|R], Resultado) :-
    somaQuadrados(R, Resultadof),
    Resultado is Resultadof + P*P.

% Função que devolve o produto escalar de duas listas
produtoEscalar(Lista1, Lista2, Resultado) :-
    ( same_length(Lista1, Lista2),
      produtoEscalar_(Lista1, Lista2, Resultado)).

produtoEscalar_([], [], 0).
produtoEscalar_([P1|R1], [P2|R2], Resultado) :-
    produtoEscalar_(R1, R2, Resultadof),
    Resultado is Resultadof + P1*P2.

% Função Aux que devolve o numerador da correlação
numerador(Lista1, Lista2, Num) :- 
    length(Lista1, L),
    produtoEscalar(Lista1, Lista2, Prod),
    sum_list(Lista1, S1),
    sum_list(Lista2, S2),
    Num is L*Prod - S1*S2.

% Função Aux que devolve a primeira parcela do denominador da correlação (Sem raiz)
denom1(Lista1, Den1) :-
    length(Lista1, L),
    sum_list(Lista1, S1),
    somaQuadrados(Lista1, SQ1),
    Den1 is L*SQ1 - S1*S1.

% Função Aux que devolve a segunda parcela do denominador da correlação (Sem raiz)
denom2(Lista2, Den2) :-
    length(Lista2, L),
    somaQuadrados(Lista2, SQ2),
    sum_list(Lista2, S2),
    Den2 is L*SQ2 - S2*S2.

% Função Aux que devolve o denominador da correlação
denominador(Lista1, Lista2, Den) :-
    denom1(Lista1, Den1),
    denom2(Lista2, Den2),
    Den is sqrt(Den1*Den2).

% Função que retorna a correlação entre duas listas
correlacao(Lista1, Lista2, Resultado) :-
    same_length(Lista1, Lista2),
    numerador(Lista1, Lista2, Num),
    denominador(Lista1, Lista2, Den),
    arredonda(Num / Den, Resultado).

% Parte II
% Função que devolve o tamanho de uma palavra
tamanho(Palavra, Tamanho) :-
    string_chars(Palavra, Caracteres), 
    length(Caracteres, Tamanho).

% Função que verifica se duas palavras tem o mesmo tamanho e 
% devolve a lista com os seus caracteres
verificaECalcula(Palavra1, Palavra2, CaracteresPalavra1, CaracteresPalavra2) :-
    string_chars(Palavra1, CaracteresPalavra1), 
    string_chars(Palavra2, CaracteresPalavra2), 
    length(CaracteresPalavra1, Tam1), 
    length(CaracteresPalavra2, Tam2), 
    Tam1 == Tam2.
    
% Função que devolve o nº de palavras com N de tamanho de uma lista
quantasN(Id, N, Quantas) :-
    lista_palavras(Id, Lista),
    quantasN1(N, Quantas, Lista).

quantasN1(_, 0, []) :- !. 
quantasN1(N, Quantas, [P|R]) :-
    tamanho(P, Tam),
    quantasN1(N, QuantasResto, R),
    ( Tam =:= N ->
        Quantas is QuantasResto + 1;
        Quantas is QuantasResto
    ).

% Função que devolve o nº de palavras que começa com C de uma lista
quantasC(Id, C, Quantas) :-
    lista_palavras(Id, Lista),
    quantasC1(C, Quantas, Lista).

quantasC1(_, 0, []) :- !. 
quantasC1(C, Quantas, [P|R]) :-
    string_chars(P, [P1|_]),
    quantasC1(C, QuantasResto, R),
    ( P1 == C ->
        Quantas is QuantasResto + 1;
        Quantas is QuantasResto
    ).

% Função que devolve a Lista2 apagando a primeira ocorrência de Elemento na Lista 1
apagaElemento(_, [], []).
apagaElemento(Elemento, [Elemento|R], R) :- !.
apagaElemento(Elemento, [P|R], [P|R2]) :-
    apagaElemento(Elemento, R, R2).

% Função que devolve as posições ordenadas de cada caracter em Palavra
posicoesPalavra(Palavra, Posicoes) :-
    carEpos(Palavra, Pares),
    keysort(Pares, SortedPares),
    maplist(parToFinal, SortedPares, Posicoes).

% Função Aux que devolve os pares desordenados Caracter-Posição
carEpos(Palavra, Pares) :-
    string_chars(Palavra, Cars), 
    carEpos(Cars, Pares, 1). 
carEpos([], [], _).
carEpos([P|R], [P-Pos|R2], Pos) :-
    Pos1 is Pos + 1, 
    carEpos(R, R2, Pos1).

% Função Aux que transforma "C-O" em "(C,O)"
parToFinal(C-O, (C,O)).

% Função que retorna uma lista de 0s e 2s, em que 2 significa que a Palavra1 e
% a Palavra2 têm o mesmo caracter na posição i, e 0 que não. 
pista1(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Cars1, Cars2), 
    carsIguais(Cars1, Cars2, Pista).

% Função Aux da pista 1   
carsIguais([], [], []). 
carsIguais([P|R], [P1|R1], [P2|R2]) :-
    ( P == P1 -> 
        P2 = 2;
        P2 = 0        
    ),
    carsIguais(R, R1, R2).

% Função que devolve a correspondência entre duas palavras, indicando 2 para 
% letras corretas na posição, 1 para letras existentes noutra posição e 0 caso contrário.
pista2(Palavra1, Palavra2, Pista) :- 
    verificaECalcula(Palavra1, Palavra2, Cars1, Cars2),
    pista2Aux(Cars1, Cars2, Cars1, Pista). 

pista2Aux([], [], _, []). 
pista2Aux([P|R], [P1|R1], Palavra1, [P2|R2]) :-
    ( P == P1 -> 
        P2 = 2; 
        ( member(P1, Palavra1) -> 
            P2 = 1; 
            P2 = 0
        )       
    ), 
    pista2Aux(R, R1, Palavra1, R2). 

% Função que respeita as regras do Wordle
pista3(Palavra1, Palavra2, Pista) :-   
    verificaECalcula(Palavra1, Palavra2, Cars1, Cars2), 
    dois(Cars1, Cars2, Cars1, AuxF, Pista1),
    uns(Cars1, Cars2, AuxF, Pista1, Pista).

% Função Aux que marca os 2
dois([], [], Aux, Aux, []).
dois([P|R], [P1|R1], Aux, AuxF, [P3|R3]):-
    ( P == P1 ->
        P3 = 2,
        apagaElemento(P, Aux, Aux1);
        P3 = 0,
        Aux1 = Aux
    ),
    dois(R, R1, Aux1, AuxF, R3).

% Função Aux que marca os 1 e 0
uns([], [], _, [], []).
uns([_|R], [P1|R1], Aux, [P2|R2], [P3|R3]) :-
    ( P2 == 2 ->
        P3 = 2,
        Aux1 = Aux;
        ( member(P1, Aux) ->
            P3 = 1,
            apagaElemento(P1, Aux, Aux1);
            P3 = 0,
            Aux1 = Aux
        )
    ),
    uns(R, R1, Aux1, R2, R3).

% Parte III
% Função que devolve as possiveis ordens para ver os filmes tendo em conta as restrições
maratonaFilmes(ListaFilmes, ListaRestricoes, Programacao) :-
    empties(ListaFilmes, Lista),
    findall(Possiveis, 
        (permutation(Lista, Possiveis), verifica(Possiveis, ListaRestricoes))
        , PossiveisF),
    sort(PossiveisF, Programacao).

% Função que verifica se uma programação satisfaz todas as restrições
verifica(_, []) :- !.
verifica(P, [Res1|Resto]) :-
    verificaAux(P, Res1), 
    verifica(P, Resto). 

% Função que verifica que Filme de terror só pode passar em sessões específicas
verificaAux(P, terror(Filme)) :- 
    nth1(Idx, P, Filme),
    member(Idx, [3,4,7]).

% Função que verifica que Filme só pode passar em uma sessão específica
verificaAux(P, soPode(Filme, Sessao)) :- 
    nth1(Sessao, P, Filme).

% Função que verifica que Filme nunca pode passar em uma sessão específica
verificaAux(P, nunca(Filme, Sessao)) :- 
    nth1(Sessao, P, NFilme), 
    NFilme \== Filme.

% Função que verifica que Filme2 deve passar imediatamente após Filme1 no mesmo dia
verificaAux(P, seguido(Filme1, Filme2)) :- 
    nth1(Idx, P, Filme1), 
    Idx2 is Idx + 1,
    nth1(Idx2, P, Filme2), 
    mesmo_dia(Idx, Idx2).

% Função que verifica que Filme1 e 2 não podem passar seguidos no mesmo dia
verificaAux(P, naoSeguido(Filme1, Filme2)) :- 
    \+ (nth1(Idx, P, Filme1),
        Idx2 is Idx + 1,
        nth1(Idx2, P, Filme2), 
        mesmo_dia(Idx, Idx2)),
    \+ (nth1(Idy, P, Filme2),
        Idy2 is Idy + 1,
        nth1(Idy2, P, Filme1), 
        mesmo_dia(Idy, Idy2)).

% Função que verifica que Filme1 deve passar antes de Filme2
verificaAux(P, antes(Filme1, Filme2)):- 
    nth1(Idx1, P, Filme1),
    nth1(Idx2, P, Filme2),
    Idx1 < Idx2.

% Função Aux que verifica se os indices da sessão são no mesmo dia
mesmo_dia(Idx1, Idx2) :-
    Idx1 =< 4,
    Idx2 =< 4.

mesmo_dia(Idx1, Idx2) :-
    Idx1 >= 5,
    Idx2 >= 5.

% Função Aux que completa a lista de filmes com sessões vazias (empty) até 7 posições
empties(ListaFilmes, Programacoes) :-
    length(ListaFilmes, N), 
    Empty is 7 - N, 
    length(Empties, Empty),
    maplist(=('empty'), Empties),
    append(ListaFilmes, Empties, Programacoes). 

% The End