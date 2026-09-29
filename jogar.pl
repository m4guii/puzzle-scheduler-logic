:- encoding(utf8).
%---------------
% Para jogares (tens NumPalpites hipóteses), N é o tamanho da palavra
%---------------

% Utilização de functores
avaliaJogada(PalavraMisterio, Palpite, TipoPista, Pista) :-
   F =.. [TipoPista, PalavraMisterio, Palpite, Pista],
   call(F).

/*
Predicado principal
- ID é o nome da lista de onde é retirada a palavra a adivinhar (palavra mistério)
- N é o tamanho da palavra
- NumPalpites é o número máximo de palpites
- TipoPista é o tipo de pista em jogo: pista1, pista2 ou pista3.
*/ 
jogar(ID, N, NumPalpites, TipoPista) :- 
    lista_palavras(ID, Palavras),
    findall(PalavraN, (member(PalavraN, Palavras), 
                        tamanho(PalavraN, N)),
                        ListaPalavrasN),
    random_member(PalavraMisterio, ListaPalavrasN), % escolhe uma palavra
    % write(PalavraMisterio), nl, % Tira o comentário se quiseres fazer batota
    jogada(PalavraMisterio, NumPalpites, TipoPista, 1).

/*
Predicado chamado em cada palpite (jogada).
- PalavraMisterio é a palavra a adivinhar.
- NumPalpites é o número máximo de palpites.
- TipoPista é o tipo de pista em jogo: pista1, pista2 ou pista3.
- NJogada é o número do palpite. 

Comportamento:
- Se excede o número de palpites possível, avisa que o jogo está perdido.
- Caso contrário, avalia a jogada tendo em conta os tipo de pista em jogo.
*/
jogada(PalavraMisterio, NumPalpites, _, NJogada) :- 
    NJogada > NumPalpites, 
    nl, write('Esgotaste os teus palpites. A palavra era: '), 
    write(PalavraMisterio), !.    
    

jogada(PalavraMisterio, NumPalpites, TipoPista, NJogada) :- 
    nl, write('Sugere uma palavra: '), read(Palpite),
    
    string_chars(PalavraMisterio, LetrasMisterio),
    string_chars(Palpite, LetrasPalpite),
    
    length(LetrasMisterio, N),
    length(LetrasPalpite, M),
    
    (N =\= M, !, 
     nl, write("A palavra tem de ter "), write(N), write(" letras."), nl,
     jogada(PalavraMisterio, NumPalpites, TipoPista, NJogada);
    
     avaliaJogada(PalavraMisterio, Palpite, TipoPista, Pista),
     
     (Palpite = PalavraMisterio, write('Boa!'), !;
      escreve(LetrasPalpite, Pista), nl,
      NJogada1 is NJogada + 1,
      jogada(PalavraMisterio, NumPalpites, TipoPista, NJogada1))).
      
/*
Verde se certo
Amarelo se existe, mas
Vermelho se errado
*/

escreve([], []) :- !.

escreve([H1 | T1], [H2 | T2]) :- 
    (H2 = 2, ansi_format([bold,fg(green)], '~w', [H1]), !;
     H2 = 1, ansi_format([bold,fg(yellow)], '~w', [H1]), !;
     ansi_format([bold,fg(red)], '~w', [H1])),
     escreve(T1, T2).