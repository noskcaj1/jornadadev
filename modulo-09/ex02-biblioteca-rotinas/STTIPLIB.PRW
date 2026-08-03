#include "protheus.ch"
USER FUNCTION NomeCliente(cCliente, cLoja)
    Local cNome := ""
    Default cCliente := ""
    Default cLoja    := ""

    If !Empty(cCliente)
        cNome := Posicione("SA1", 1, xFilial("SA1") + cCliente + cLoja, "A1_NOME")
    EndIf

Return AllTrim(cNome)



USER FUNCTION ProxCodigoSZ1()
    Local cProx  := ""
    Local nTam   := TamSX3("Z1_CODIGO")[1]
    Local nMaior := 0
    Local aArea  := GetArea()

    dbSelectArea("SZ1")
    dbSetOrder(1)                       // Z1_FILIAL + Z1_CODIGO
    dbSeek(xFilial("SZ1"))
    Do While !Eof() .And. SZ1->Z1_FILIAL == xFilial("SZ1")
        nMaior := Max(nMaior, Val(SZ1->Z1_CODIGO))
        dbSkip()
    EndDo

    cProx := StrZero(nMaior + 1, nTam)

    RestArea(aArea)
Return cProx


USER FUNCTION ProxSequenSZ2(cContato)
    Local cProx  := ""
    Local nTam   := TamSX3("Z2_SEQUEN")[1]
    Local nMaior := 0
    Local aArea  := GetArea()
    Default cContato := ""

    dbSelectArea("SZ2")
    dbSetOrder(1)                       // Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN
    dbSeek(xFilial("SZ2") + cContato)
    Do While !Eof() .And. SZ2->Z2_FILIAL == xFilial("SZ2") .And. SZ2->Z2_CONTAT == cContato
        nMaior := Max(nMaior, Val(SZ2->Z2_SEQUEN))
        dbSkip()
    EndDo

    cProx := StrZero(nMaior + 1, nTam)

    RestArea(aArea)
Return cProx


USER FUNCTION DescTipoInteracao(cTipo)
    Local cDesc := ""
    Default cTipo := ""

    If !Empty(cTipo)

        cDesc := AllTrim(X5Descri("Z2", cTipo))
    EndIf

Return cDesc
