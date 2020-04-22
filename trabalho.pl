:- multifile contribuinte/11.
:- multifile depente/4.
:- dynamic contribuinte/11.
:- dynamic dependente/4.
:- dynamic cont/1.
:- dynamic renda_total/1.


% - - BACK END - - 
% Funções gerais

incluir_contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular):-
    assert(contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular)),
    writeln('Contribuinte incluso com sucesso!'),!.
    

incluir_dependente(CPF_contribuinte, Nome_dep, Idade_dep, Genero_dep):-
    assert(dependente(CPF_contribuinte, Nome_dep, Idade_dep, Genero_dep)),
    writeln('Dependente incluso com sucesso!'),!.

localizar_contribuinte(CPF):-
    write('CPF   |   NOME  |   G   |   REN   |   LOG   |  NUM  |   COMP   |   CID  |   EST   |   CEP   |   CEL\n'),
    contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular),
format('\n~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w\n', [CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular]), fail.

localizar_contribuinte(_):-
    write('Fim da busca...'),!.

excluir_contribuinte(CPF):-
    retractall(contribuinte(CPF, _,_,_,_,_,_,_,_,_,_)), retractall(dependente(CPF, _,_,_)).

counter_dependentes(CPF):-
    cont(X),
    dependente(CPF,_,_,_),
    Y is X + 1,
    assert(cont(Y)),
    retract(cont(X));cont(0),!.

relatorio_contribuinte:-
    write('CPF   |   NOME  |   G   |   REN   |   LOG   |  NUM  |   COMP   |   CID  |   EST   |   CEP   |   CEL | DESCONTO\n'), 
    write('--------------------------------------------------------------------------------------------------------------\n'),
    fail.
relatorio_contribuinte:-
    contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular),
    counter_dependentes(CPF),
    cont(Y),
    Desconto is Y *1200,
    renda_total(R),
    RTA is R + Renda_anual,
    assert(renda_total(RTA)),
    format('~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w\n', [CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular, Desconto]), 
    write('--------------------------------------------------------------------------------------------------------------\n'),
    retract(cont(Y)), retractall(renda_total(R)), assert(cont(0)),
    fail.

relatorio_contribuinte:-
    renda_total(X),
    format('Renda total anual: ~w \n', [X]),
    retractall(renda_total(X)),
    assert(renda_total(0)),
    write('Fim da busca...'), !.


salvar_dados_em_arquivo:-
    tell('dados_contribuintes.pl'), listing(contribuinte/11), told,
    tell('dados_dependentes.pl'), listing(dependente/4),told,!.


carregar_dados:-
    consult('dados_contribuintes.pl'),
    consult('dados_dependentes.pl').


limpar_dados:-
    excluir_contribuinte(_).

encerrar:-
    write('\e[2J'),
    writeln(' MENU '),
    write('Saindo!'), !.


setup:-
    retractall(cont(_)),
    retractall(renda_total(_)),
    assert(cont(0)),
    assert(renda_total(0)).

% - - FRONT END - -

% Menu principal
trabalho:-
    setup,
    write('\e[2J'), nl,
    write(' CONSULTA DE CONTRIBUINTES '),
    writeln('Escolha opção: '), nl,
    writeln('| 1 | Incluir Contribuinte'),
    writeln('| 2 | Incluir Dependente'),
    writeln('| 3 | Localizar Contribuinte pelo CPF'),
    writeln('| 4 | Excluir Contribuinte e Seus Dependentes'),
    writeln('| 5 | Relatório de Contribuintes'),
    writeln('| 6 | Salvar Dados em Arquivo'),
    writeln('| 7 | Carregar Dados de arquivo'),
    writeln('| 8 | Limpar Dados de Cadastro'),
    writeln('| 9 | Encerrar'),nl,
    writeln('Informe a opção: '),
    read(Entrada),
    Entrada =\= 9,
    executar( Entrada );
    trabalho.

% Fim do Programa
trabalho:- encerrar.


% Mapeamento de funções

executar(1):-
    op1, !.
executar(2):-
    op2,!.
executar(3):-
    op3,!.
executar(4):-
    op4,!.
executar(5):-
    op5,!.
executar(6):-
    op6,!.
executar(7):-
    op7,!.
executar(8):-
    op8,!.

% Entradas do usuário

op1:-
    writeln('Digite os dados do contribuinte desejado:'),
    write('\nCPF '), read(CPF),
    write('\nNome '), read(Nome),
    write('\nGênero '), read(Genero),
    write('\nRenda Anual '),read(Renda_anual),
    write('\nLogradouro '), read(Logradouro),
    write('\nNúmero '), read(Numero),
    write('\nComplemento '), read(Complemento),
    write('\nCidade '), read(Cidade),
    write('\nEstado '), read(Estado),
    write('\nCEP '), read(CEP),
    write('\nCelular'), read(Celular),
    incluir_contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular),!.

op2:-
    writeln('Digite os dados dos dependentes'),
    write('\nCPF do contribuinte: '), read(CPF),
    write('\nNome do Dependente: '), read(Nome_dep),
    write('\nIdade do Dependente: '), read(Idade_dep),
    write('\nGenero do dependente: '), read(Genero_dep),
    incluir_dependente(CPF, Nome_dep, Idade_dep, Genero_dep),!.


op3:-
    write('Digite o CPF do contribuinte '), read(CPF),
    localizar_contribuinte(CPF),!.

op4:-
    write('Digite o CPF do contribuinte '), read(CPF),
    excluir_contribuinte(CPF),!.

op5:-
    relatorio_contribuinte,!.

op6:-
    salvar_dados_em_arquivo,!.

op7:-
    carregar_dados,!.

op8:-
    limpar_dados,!.

op9:-
    encerrar,!.
