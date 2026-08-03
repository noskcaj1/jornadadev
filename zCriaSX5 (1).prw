#Include "Protheus.ch"

/*/{Protheus.doc} zCriaSX5
Cria uma tabela generica (SX5) com suas chaves diretamente,
sem depender da tela do Configurador.

Como usar:
  1. Ajuste cTabela, cDescr e o array aChaves abaixo.
  2. Compile este fonte no seu ambiente (TDS / VSCode com plugin TOTVS).
  3. Execute a funcao U_zCriaSX5 (por menu, ou pelo "Executar" da IDE).

Regras importantes:
  - cTabela tem 2 caracteres. Para tabela customizada, COMECE COM "Z"
    (ex.: Z1, ZA, ZZ). Codigos numericos 00-99 sao reservados da TOTVS.
  - Se a chave ja existir, ela nao e duplicada.

@author  Voce
@since   2026
@version 1.0
/*/
User Function zCriaSX5()

    Local aArea   := GetArea()
    Local cTabela := "Z1"                 // <== codigo da SUA tabela (2 chars, comece com Z)
    Local cDescr  := "MINHA TABELA"       // <== descricao da tabela (informativo)
    Local aChaves := {}
    Local nX      := 0
    Local nCriadas := 0

    // Estrutura de cada linha:
    // { Chave , Descricao PT , Descricao ES , Descricao EN }
    aAdd(aChaves, {"001", "Item Um"  , "Item Uno" , "Item One"  })
    aAdd(aChaves, {"002", "Item Dois", "Item Dos" , "Item Two"  })
    aAdd(aChaves, {"003", "Item Tres", "Item Tres", "Item Three"})

    dbSelectArea("SX5")
    dbSetOrder(1)   // Indice 1 = X5_FILIAL + X5_TABELA + X5_CHAVE

    For nX := 1 To Len(aChaves)

        // So inclui se ainda nao existir essa Tabela+Chave
        If !SX5->(dbSeek(xFilial("SX5") + cTabela + PadR(aChaves[nX][1], TamSX3("X5_CHAVE")[1])))

            RecLock("SX5", .T.)
                SX5->X5_FILIAL := xFilial("SX5")
                SX5->X5_TABELA := cTabela
                SX5->X5_CHAVE  := aChaves[nX][1]
                SX5->X5_DESCRI := aChaves[nX][2]

                // Descricoes ES / EN so se os campos existirem nesta versao
                If SX5->(FieldPos("X5_DESCSPA")) > 0
                    SX5->X5_DESCSPA := aChaves[nX][3]
                EndIf
                If SX5->(FieldPos("X5_DESCENG")) > 0
                    SX5->X5_DESCENG := aChaves[nX][4]
                EndIf
            SX5->(MsUnlock())

            nCriadas++
        EndIf

    Next nX

    RestArea(aArea)

    MsgInfo("Tabela " + cTabela + " (" + AllTrim(cDescr) + ")" + CRLF + ;
            "Chaves incluidas: " + cValToChar(nCriadas), "Concluido")

Return Nil
