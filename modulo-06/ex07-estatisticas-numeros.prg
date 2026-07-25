#define QTD 10

 PROCEDURE Main()
    LOCAL aNumeros := LerNumeros( QTD )
    LOCAL nSoma    := 0
 
    ASort( aNumeros )                           
    AEval( aNumeros, {| n | nSoma += n } )       
 
    ? "Ordenados:", ListaNumeros( aNumeros )
    ? "Soma.....:", nSoma
    ? "Media....:", nSoma / Len( aNumeros )
    ? "Menor....:", aNumeros[ 1 ]
    ? "Maior....:", aNumeros[ Len( aNumeros ) ]
    RETURN

 FUNCTION LerNumeros( nQtd )
    LOCAL aV := {}, nI
    FOR nI := 1 TO nQtd
       AAdd( aV, LerNumero( "Numero " + AllTrim( Str( nI ) ) + ": " ) )
    NEXT
    RETURN aV
 
 FUNCTION ListaNumeros( aV )
    LOCAL cSaida := "", nValor
    FOR EACH nValor IN aV
       cSaida += AllTrim( Str( nValor ) ) + " "
    NEXT
    RETURN AllTrim( cSaida )
 
 FUNCTION LerNumero( cPrompt )
    LOCAL cValor := ""
    ACCEPT cPrompt TO cValor
    RETURN Val( cValor )
 