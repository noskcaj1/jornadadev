#define JOGADAS { "pedra", "papel", "tesoura" }

PROCEDURE Main()
    LOCAL cJogador, cCPU, cResultado
 
    ? "=== JOKENPO ==="
    DO WHILE .T.
        cJogador := Lower( LerTexto( "Sua jogada (pedra/papel/tesoura ou 'sair'): " ) )
        IF cJogador == "sair"
            EXIT
        ENDIF
        IF !ValidarJogada( cJogador )
            ? "Jogada invalida, tente de novo."
            LOOP
        ENDIF
 
        cCPU := SortearJogadaCPU()
        ? "CPU jogou:", cCPU
        cResultado := DefinirVencedor( cJogador, cCPU )
        ? IIf( cResultado == "empate", "Empate!", cResultado + " venceu!" )
        ?
    ENDDO
 
    ? "Ate a proxima!"
RETURN
 
FUNCTION SortearJogadaCPU()
    LOCAL aOpcoes := JOGADAS
RETURN aOpcoes[ hb_RandomInt( 1, 3 ) ]
 
FUNCTION ValidarJogada( cJogada )
RETURN AScan( JOGADAS, {| c | c == cJogada } ) > 0
 
FUNCTION DefinirVencedor( cJogador, cCPU )
    IF cJogador == cCPU
        RETURN "empate"
    ENDIF
    DO CASE
        CASE cJogador == "pedra"   .AND. cCPU == "tesoura" ; RETURN "Voce"
        CASE cJogador == "papel"   .AND. cCPU == "pedra"   ; RETURN "Voce"
        CASE cJogador == "tesoura" .AND. cCPU == "papel"   ; RETURN "Voce"
    ENDCASE
RETURN "CPU"
 
FUNCTION LerTexto( cPrompt )
    LOCAL cValor := ""
    ACCEPT cPrompt TO cValor
RETURN AllTrim( cValor )
 