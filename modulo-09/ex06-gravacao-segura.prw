#include "protheus.ch"

/*/{Protheus.doc} STTIP003SALVAR
Gravacao "a prova de falhas" de um Contato (SZ1).

Estrategia:
  - valida Z1_CLIENTE e Z1_ASSUNTO (usa Break() se faltar algo);
  - grava dentro de BeginTran() + BEGIN SEQUENCE, com RecLock/MsUnLock;
  - se der qualquer erro no meio -> RECOVER: RollBackTran(), mensagem
    amigavel e U_GRAVARLOG();
  - so chama CommitTran() se TUDO deu certo.

Assim nunca sobra registro gravado "pela metade".
/*/
USER FUNCTION STTIP003SALVAR()

    Local lOk         := .T.
    Local oErro
    Local bErroAntigo := ErrorBlock({|e| Break(e)})

    BeginTran()

    BEGIN SEQUENCE

        // ---- validacoes (Break interrompe e cai no RECOVER) ----
        If Empty(M->Z1_CLIENTE)
            Break("Informe o cliente antes de gravar.")
        EndIf
        If Empty(M->Z1_ASSUNTO)
            Break("Informe o assunto antes de gravar.")
        EndIf

        // ---- gravacao ----
        dbSelectArea("SZ1")
        RecLock("SZ1", .T.)                          // .T. = inclusao
            SZ1->Z1_FILIAL  := xFilial("SZ1")
            SZ1->Z1_CODIGO  := U_ProxCodigoSZ1()     // helper da STTIPLIB
            SZ1->Z1_CLIENTE := M->Z1_CLIENTE
            SZ1->Z1_ASSUNTO := M->Z1_ASSUNTO
        MsUnLock()

        // ---- so confirma se chegou ate aqui sem erro ----
        CommitTran()
        MsgInfo("Contato gravado com sucesso!", "OK")

    RECOVER USING oErro

        RollBackTran()                               // desfaz tudo

        // mensagem amigavel: se veio de validacao (string) mostra ela;
        // se veio de erro real (objeto) mostra texto generico.
        If ValType(oErro) == "C"
            MsgAlert(oErro, "Atencao")
        Else
            MsgStop("Nao foi possivel gravar o contato. Nada foi salvo.", "Erro")
        EndIf

        U_GRAVARLOG("STTIP003SALVAR", oErro)
        lOk := .F.

    END SEQUENCE

    ErrorBlock(bErroAntigo)

Return lOk


/*/{Protheus.doc} GRAVARLOG
Grava uma linha de log (funcao + descricao do erro) num arquivo texto.
Aceita tanto um objeto de erro quanto uma string (validacao via Break).

Coloque tambem esta funcao na sua STTIPLIB.PRW (aqui vai junto para
o exercicio ficar autocontido).
/*/
USER FUNCTION GRAVARLOG(cFuncao, oErro)

    Local cDesc  := ""
    Local cLinha := ""
    Local nHandle := 0
    Local cArq   := "\log_sttip.txt"
    Default cFuncao := "?"

    // descobre a descricao conforme o tipo do que foi recebido
    Do Case
        Case ValType(oErro) == "O"                   // objeto de erro
            cDesc := oErro:Description
        Case ValType(oErro) == "C"                   // string (validacao)
            cDesc := oErro
        Otherwise
            cDesc := "Interrompido sem descricao."
    EndCase

    cLinha := DToC(Date()) + " " + Time() + " | " + ;
              AllTrim(cFuncao) + " | " + AllTrim(cDesc) + CRLF

    // abre para append; se nao existir, cria
    nHandle := FOpen(cArq, 1)
    If nHandle == -1
        nHandle := FCreate(cArq)
    Else
        FSeek(nHandle, 0, 2)                          // vai para o fim do arquivo
    EndIf

    If nHandle != -1
        FWrite(nHandle, cLinha)
        FClose(nHandle)
    EndIf

Return NIL
