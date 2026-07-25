PROCEDURE Main()
    LOCAL nA  := LerNumero( "Primeiro numero: " )
    LOCAL nB  := LerNumero( "Segundo numero.: " )
    LOCAL cOp := LerTexto( "Operacao (+ - * /): " )
    LOCAL nResultado
 
    IF Calcular( nA, nB, cOp, @nResultado )
        MostrarResultado( nA, nB, cOp, nResultado )
    ELSE
        ? "Erro: operacao invalida ou divisao por zero."
    ENDIF
 
RETURN
 
FUNCTION Calcular( nA, nB, cOp, nRes )
    DO CASE
        CASE cOp == "+" ;  nRes := nA + nB
        CASE cOp == "-" ;  nRes := nA - nB
        CASE cOp == "*" ;  nRes := nA * nB
        CASE cOp == "/"
            IF nB == 0
                RETURN .F.
            ENDIF
            nRes := nA / nB
            OTHERWISE
            RETURN .F.
    ENDCASE
RETURN .T.
 
PROCEDURE MostrarResultado( nA, nB, cOp, nRes )
    ? AllTrim( Str( nA ) ), cOp, AllTrim( Str( nB ) ), "=", AllTrim( Str( nRes ) )
RETURN
 
FUNCTION LerNumero( cPrompt )
    LOCAL cValor := ""
    ACCEPT cPrompt TO cValor
RETURN Val( cValor )
 
FUNCTION LerTexto( cPrompt )
    LOCAL cValor := ""
    ACCEPT cPrompt TO cValor
RETURN AllTrim( cValor )
 