PROCEDURE Main()
    LOCAL nTick
 
    FOR nTick := 1 TO 30
        ExibirHora( FormatarHora( ObterHora() ) )
        Inkey( 1 )                      // pausa de ~1 segundo
    NEXT
 
RETURN
 
FUNCTION ObterHora()
RETURN Seconds()
 
FUNCTION FormatarHora( nSegundos )
    LOCAL nH := Int( nSegundos / 3600 )
    LOCAL nM := Int( ( nSegundos % 3600 ) / 60 )
    LOCAL nS := Int( nSegundos ) % 60
RETURN StrZero( nH, 2 ) + ":" + StrZero( nM, 2 ) + ":" + StrZero( nS, 2 )
 
PROCEDURE ExibirHora( cHora )
    CLS
    ? "=== RELOGIO DIGITAL ==="
    ?
    ? "        " + cHora
RETURN
 