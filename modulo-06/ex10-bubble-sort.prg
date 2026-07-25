#define QTD 10

PROCEDURE Main()
    LOCAL aNumeros := GerarAleatorios( QTD, 1, 99 )
 
    ? "Antes.:", ListaNumeros( aNumeros )
    BubbleSort( aNumeros )
    ? "Depois:", ListaNumeros( aNumeros )
RETURN
 
FUNCTION BubbleSort( aVetor )
    LOCAL nI, nJ, nTmp
    FOR nI := 1 TO Len( aVetor ) - 1
        FOR nJ := 1 TO Len( aVetor ) - nI          
            IF aVetor[ nJ ] > aVetor[ nJ + 1 ]
                nTmp             := aVetor[ nJ ]      
                aVetor[ nJ ]     := aVetor[ nJ + 1 ]
                aVetor[ nJ + 1 ] := nTmp
            ENDIF
        NEXT
    NEXT
RETURN aVetor
 
FUNCTION GerarAleatorios( nQtd, nMin, nMax )
    LOCAL aV := {}, nI
    FOR nI := 1 TO nQtd
        AAdd( aV, hb_RandomInt( nMin, nMax ) )
    NEXT
RETURN aV
 
FUNCTION ListaNumeros( aV )
    LOCAL cSaida := "", nValor
    FOR EACH nValor IN aV
        cSaida += AllTrim( Str( nValor ) ) + " "
    NEXT
RETURN AllTrim( cSaida )
 