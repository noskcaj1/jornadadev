#include "protheus.ch"   // Definicoes padrao do Protheus


// ============================================================
// STTIP002 - Ponto de entrada 1: abre o cadastro de Pets
// mostrando SO os pets cadastrados no mes/ano atual (com filtro).
// ============================================================
User Function STTIP002()

    STBrowse(.T.)   // .T. = com filtro (so os do mes atual)

Return Nil


// ============================================================
// STTODOS - Ponto de entrada 2: abre o MESMO cadastro, mas
// mostrando todos os pets (sem filtro). E o que o botao
// "Mostrar Todos" chama.
// ============================================================
User Function STTODOS()

    STBrowse(.F.)   // .F. = sem filtro (todos)

Return Nil


// ============================================================
// STHIST - Acao do botao "Historico".
// Mostra dados basicos do pet que estiver selecionado no browse.
// ============================================================
User Function STHIST()

    // Se nao ha registro posicionado, avisa e sai.
    If ZA1->(Eof())
        MsgAlert("Nenhum pet selecionado.", "Historico")
        Return Nil
    EndIf

    // MsgInfo: caixa de informacao. Monta o texto com codigo e raca.
    // AllTrim tira os espacos em branco das pontas.
    // CRLF quebra a linha (Carriage Return + Line Feed).
    MsgInfo(;
        "Codigo: " + AllTrim(ZA1->ZA1_COD) + CRLF +;
        "Raca: "   + AllTrim(ZA1->ZA1_RACA),;
        "Historico do Pet";
        )

Return Nil


// ============================================================
// STBrowse - Funcao Static (interna, so visivel neste arquivo).
// Concentra a montagem do browse. As duas User Functions acima
// chamam ela, mudando so o parametro lFiltrar. Evita codigo
// duplicado: uma tela, dois comportamentos.
// ============================================================
Static Function STBrowse(lFiltrar)

    // Legenda de cores por idade do pet (mesma logica de antes).
    Local aColors := {;
        {"ZA1_NASC < dDataBase - 3650", "BR_VERMELHO"},;  // > ~10 anos -> vermelho
        {"ZA1_NASC == dDataBase"      , "BR_AMARELO"} ,;  // nasceu hoje -> amarelo
        {".T."                        , "BR_VERDE"}   ;   // demais -> verde
        }

    Private cCadastro := "Cadastro de Pets"
    Private aRotina   := {}

    // Default: se STBrowse for chamada sem parametro, assume .T. (com filtro).
    // Protecao contra lFiltrar vir nulo.
    Default lFiltrar := .T.

    // Botoes padrao + o botao customizado "Historico"
    AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
    AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
    AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
    AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
    AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})
    AAdd(aRotina, {"Historico" , "U_STHIST", 0, 6})

    // So mostra o botao "Mostrar Todos" quando a tela esta filtrada
    // (nao faz sentido oferecer "mostrar todos" se ja mostra todos).
    If lFiltrar
        AAdd(aRotina, {"Mostrar Todos", "U_STTODOS()", 0, 6})
    EndIf

    DbSelectArea("ZA1")   // Tabela de Pets
    DbSetOrder(1)         // Indice 1
    DbClearFilter()       // Limpa qualquer filtro anterior antes de comecar

    // Se for pra filtrar, aplica o filtro de "cadastrados no mes/ano atual".
    If lFiltrar

        // DbSetFilter recebe DOIS argumentos que dizem a MESMA regra:
        //  1) um code block {|| ... } -> a regra que o sistema executa
        //  2) a mesma regra em TEXTO  -> usada para exibir/registrar o filtro
        // A regra: data de cadastro (ZA1_DTCAD) preenchida E no mesmo mes E
        // mesmo ano da data-base atual.
        DbSetFilter(;
            {|| !Empty(ZA1->ZA1_DTCAD) .And. ;
            Month(ZA1->ZA1_DTCAD) == Month(dDataBase) .And. ;
            Year(ZA1->ZA1_DTCAD) == Year(dDataBase)},;
            "!Empty(ZA1->ZA1_DTCAD) .AND. " +;
            "Month(ZA1->ZA1_DTCAD) == Month(dDataBase) .AND. " +;
            "Year(ZA1->ZA1_DTCAD) == Year(dDataBase)";
            )

    EndIf

    DbGoTop()   // Posiciona no 1o registro (ja considerando o filtro)

    // Desenha o browse com as cores
    mBrowse(1, 1, 22, 75, "ZA1", , , , , , aColors)

    // Limpeza ao sair: garante que o filtro nao "vaza" pra outras rotinas
    DbSelectArea("ZA1")
    DbClearFilter()

Return Nil

// ============================================================

/*O fluxo geral: existem duas portas de entrada (STTIP002 com filtro e STTODOS sem filtro), mas as duas chamam a mesma função 
interna STBrowse, que monta o browse. A diferença entre elas é só o parâmetro lFiltrar. Dentro do browse tem o botão Histórico, 
que abre uma caixa com dados do pet selecionado, e — só na versão filtrada — o botão Mostrar Todos, que reabre sem filtro.

As três coisas novas aqui, que valem entender bem:

Função Static para evitar duplicação. Em vez de escrever a montagem do browse duas vezes (uma filtrada, uma não), você escreve 
uma vez em STBrowse e as duas User Functions chamam ela mudando um parâmetro. Static Function quer dizer que ela é privada deste arquivo — 
não aparece no menu nem pode ser chamada de fora. É o jeito certo de organizar código auxiliar. Repara que ela não tem o 
prefixo U_ justamente por não ser uma User Function pública.

DbSetFilter com code block + texto. Esse é o filtro "de verdade" do Protheus, mais robusto que o Set Filter To que você usou no STTIP004. 
Ele recebe a regra duas vezes: primeiro como um code block {|| ... } (que é o que o sistema realmente executa) e depois como string 
(a mesma regra em texto, usada pra registrar/exibir o filtro). As duas têm que dizer a mesma coisa. A regra aqui filtra os pets cujo 
ZA1_DTCAD (data de cadastro) cai no mês e ano atuais.

DbClearFilter no começo e no fim. É a mesma disciplina de limpeza do Set Filter To vazio: limpa antes (pra não herdar filtro de outra tela) 
e depois (pra não deixar filtro pendurado na ZA1 pra próxima rotina).

Dois pontos de atenção, um deles um provável bug: Repara que o botão Histórico e o Mostrar Todos têm os dois o número de opção 6 (0, 6). 
Isso é uma colisão — dois itens do aRotina com o mesmo nOpc. Pode causar comportamento estranho (um "roubar" o clique do outro). 
O "Mostrar Todos" deveria ser 7. Vale corrigir: AAdd(aRotina, {"Mostrar Todos", "U_STTODOS()", 0, 7}).

Consistência de chamada nos botões customizados: "Historico" está como "U_STHIST" (sem parênteses) e "Mostrar Todos" como "U_STTODOS()" (com parênteses). 
Lembra da nossa saga — nesse seu build, o que funcionou foi com parênteses. Então, se o botão Histórico não disparar, troca pra "U_STHIST()". 
Deixe os dois no mesmo padrão pra não ter surpresa.
