PROCEDURE Main()
    LOCAL aDias := { "Domingo", "Segunda", "Terca", "Quarta", ;
        "Quinta", "Sexta", "Sabado" }
    LOCAL nDia := LerNumero( "Digite um numero de 1 a 7: " )
 
    IF nDia >= 1 .AND. nDia <= Len( aDias )
        ? "Dia da semana:", aDias[ nDia ]      
    ELSE
        ? "Numero invalido! Informe um valor entre 1 e 7."
    ENDIF
 
RETURN
 
FUNCTION LerNumero( cPrompt )
    LOCAL cValor := ""
    ACCEPT cPrompt TO cValor
RETURN Val( cValor )
 