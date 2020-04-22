:- multifile contribuinte/11.
:- multifile depente/4.
:- dynamic contribuinte/11.
:- dynamic dependente/4.
:- dynamic cont/1.
:- dynamic renda_total/1.

incluir_contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular):-
    assert(contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular)),!.
    

incluir_dependente(CPF_contribuinte, Nome_dep, Idade_dep, Genero_dep):-
    assert(dependente(CPF_contribuinte, Nome_dep, Idade_dep, Genero_dep)),!.

localizar_contribuinte(CPF):-
    write('CPF   |   NOME  |   G   |   REN   |   LOG   |  NUM  |   COMP   |   CID  |   EST   |   CEP   |   CEL\n'),
    contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular),
format('\n~w|~w|~w|~w |~w|~w|~w|~w|~w|~w|~w\n', [CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular]), fail.

localizar_contribuinte(_):-
    write('Fim da busca...'),!.

excluir_contribuinte(CPF):-
    retractall(contribuinte(CPF, _,_,_,_,_,_,_,_,_,_)), retractall(dependente(CPF, _,_,_)).

counter_dependentes(CPF):-
    cont(X),
    dependente(CPF,_,_,_),
    Y is X + 1,
    assert(cont(Y)),
    retract(cont(X));cont(0).

relatorio_contribuinte():-
    write('CPF   |   NOME  |   G   |   REN   |   LOG   |  NUM  |   COMP   |   CID  |   EST   |   CEP   |   CEL | DESCONTO\n'), 
    write('--------------------------------------------------------------------------------------------------------------\n'),
    fail.
relatorio_contribuinte():-
contribuinte(CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular),
counter_dependentes(CPF),
cont(Y),
Desconto is Y *1200,
renda_total(R),
RTA is R + Renda_anual,
assert(renda_total(RTA)),
retractall(renda_total(R)),
format('~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w\n', [CPF, Nome, Genero, Renda_anual, Logradouro, Numero, Complemento, Cidade, Estado, CEP, Celular, Desconto]), 
write('--------------------------------------------------------------------------------------------------------------\n'),
retract(cont(Y)), assert(cont(0)),
fail.

relatorio_contribuinte():-
    renda_total(X),
    format('Renda total anual: ~w \n', [X]),
    retractall(renda_total(X)),
    assert(renda_total(0)),
    write('Fim da busca...'), !.



salvar_dados_em_arquivo():-
    tell('dados_contribuintes.pl'), listing(contribuinte//1), told,
    tell('dados_dependentes.pl'), listing(dependente/4),told,!.

carregar_dados():-
    consult('dados_contribuintes.pl'),
    consult('dados_dependentes.pl').

limpar_dados():-
    excluir_contribuinte(_).

encerrar():-
    halt(0).
