#Include "Protheus.ch"

/*/{Protheus.doc} zCriaSX5
Cria a tabela generica Z2 (SX5) com suas chaves,
sem depender da tela do Configurador.

Como usar:
  1. Compile este fonte no seu ambiente (TDS / VSCode com plugin TOTVS).
  2. Execute a funcao U_zCriaSX5 (por menu, ou pelo "Executar" da IDE).
  3. Pode rodar mais de uma vez: chaves ja existentes nao sao duplicadas.

Observacao:
  - Z2 comeca com "Z" (tabela customizada). OK.
  - Se a Z2 ja estiver em uso por outra coisa, troque cTabela.
/*/
User Function zCriaSX5()

    Local aArea    := GetArea()
    Local cTabela  := "Z2"                    // codigo da tabela
    Local cDescr   := "TIPOS DE CONTATO"      // descricao (informativo - ajuste se quiser)
    Local aChaves  := {}
    Local nX       := 0
    Local nCriadas := 0

    // { Chave , Descricao PT , Descricao ES , Descricao EN }
    aAdd(aChaves, {"E", "E-mail"  , "Correo"   , "E-mail"  })
    aAdd(aChaves, {"L", "Ligacao" , "Llamada"  , "Call"    })
    aAdd(aChaves, {"R", "Reuniao" , "Reunion"  , "Meeting" })
    aAdd(aChaves, {"V", "Visita"  , "Visita"   , "Visit"   })
    aAdd(aChaves, {"W", "WhatsApp", "WhatsApp" , "WhatsApp"})

    dbSelectArea("SX5")
    dbSetOrder(1)   // Indice 1 = X5_FILIAL + X5_TABELA + X5_CHAVE

    For nX := 1 To Len(aChaves)

        If !SX5->(dbSeek(xFilial("SX5") + cTabela + PadR(aChaves[nX][1], TamSX3("X5_CHAVE")[1])))

            RecLock("SX5", .T.)
                SX5->X5_FILIAL := xFilial("SX5")
                SX5->X5_TABELA := cTabela
                SX5->X5_CHAVE  := aChaves[nX][1]
                SX5->X5_DESCRI := aChaves[nX][2]

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
            "Chaves incluidas agora: " + cValToChar(nCriadas), "Concluido")

Return Nil
