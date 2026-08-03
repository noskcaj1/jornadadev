#include "protheus.ch"

/*
 * Exercicio 7 (desafio) - fiz os dois.
 *   7a: U_VALEXCSZ1()      -> integridade referencial (nao deixa excluir
 *                             um Contato que tenha Interacoes vinculadas)
 *   7b: U_EXECUTARSEGURO() -> executor seguro generico (roda um bloco de
 *                             codigo protegido, loga erro e devolve .T./.F.)
 */


/*/{Protheus.doc} VALEXCSZ1  (7a)
Impede excluir um Contato (SZ1) que tenha Interacoes (SZ2) vinculadas.
Amarrar na exclusao (ex.: no aRotina/AxDeleta ou no X3 conforme o padrao
da rotina). Retorna .T. se PODE excluir; .F. se estiver bloqueado.
/*/
USER FUNCTION VALEXCSZ1()

    Local lPodeExcluir := .T.
    Local aArea        := GetArea()

    dbSelectArea("SZ2")
    dbSetOrder(1)                       // Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN

    // se achar QUALQUER interacao com Z2_CONTAT = contato atual, bloqueia
    If dbSeek(xFilial("SZ2") + SZ1->Z1_CODIGO)
        MsgStop("Este contato possui interacoes vinculadas e nao pode ser excluido.", "Atencao")
        lPodeExcluir := .F.
    EndIf

    RestArea(aArea)

    // Dica da apostila usando ExistCpo (equivalente, porem ExistCpo
    // exibe a mensagem-padrao de "nao encontrado"):
    //   If ExistCpo("SZ2", xFilial("SZ2") + SZ1->Z1_CODIGO, 1)
    //       lPodeExcluir := .F.
    //   EndIf

Return lPodeExcluir


/*/{Protheus.doc} EXECUTARSEGURO  (7b)
Executa um bloco de codigo dentro de um BEGIN SEQUENCE protegido.
Em caso de erro: mostra cMsgErro, grava log e devolve .F.
Se rodar tudo certo, devolve .T.

Uso:
    U_EXECUTARSEGURO({|| AbrirArquivo("dados.dbf")}, "Falha ao abrir dados")
/*/
USER FUNCTION EXECUTARSEGURO(bBloco, cMsgErro)

    Local lOk         := .T.
    Local oErro
    Local bErroAntigo := ErrorBlock({|e| Break(e)})
    Default cMsgErro  := "Ocorreu um erro na operacao."

    // se nao veio um bloco valido, nem tenta
    If ValType(bBloco) != "B"
        MsgStop("Bloco de codigo invalido.", "Erro")
        Return .F.
    EndIf

    BEGIN SEQUENCE

        Eval(bBloco)                    // executa o que foi passado
        lOk := .T.

    RECOVER USING oErro

        MsgStop(cMsgErro, "Erro")
        U_GRAVARLOG("EXECUTARSEGURO", oErro)   // helper do Ex.6 / STTIPLIB
        lOk := .F.

    END SEQUENCE

    ErrorBlock(bErroAntigo)

Return lOk
