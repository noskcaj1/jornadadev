#define MEDIA_MINIMA 7

PROCEDURE Main()
    LOCAL nQtd    := LerNumero( "Quantos alunos? " )
    LOCAL aAlunos := {}, nI
 
    FOR nI := 1 TO nQtd
        ? "--- Aluno " + AllTrim( Str( nI ) ) + " ---"
        AAdd( aAlunos, LerAluno() )
    NEXT
 
    ExibirBoletim( aAlunos )
RETURN
 
FUNCTION LerAluno()
    RETURN { LerTexto( "Nome: " ), ;
        LerNumero( "Nota 1: " ), ;
        LerNumero( "Nota 2: " ), ;
        LerNumero( "Nota 3: " ), ;
        LerNumero( "Nota 4: " ) }
 
FUNCTION MediaAluno( aAluno )
RETURN ( aAluno[ 2 ] + aAluno[ 3 ] + aAluno[ 4 ] + aAluno[ 5 ] ) / 4
 
PROCEDURE ExibirBoletim( aAlunos )
    LOCAL aAluno, nMedia
    ? ""
    ? "=== BOLETIM ==="
    FOR EACH aAluno IN aAlunos
        nMedia := MediaAluno( aAluno )
        ? PadR( aAluno[ 1 ], 15 ), ;
            "Media:", Str( nMedia, 5, 2 ), ;
            IIf( nMedia >= MEDIA_MINIMA, "-> APROVADO", "-> REPROVADO" )
    NEXT
RETURN
 
FUNCTION LerNumero( cPrompt )
    LOCAL c := ""
    ACCEPT cPrompt TO c
RETURN Val( c )
 
FUNCTION LerTexto( cPrompt )
    LOCAL c := ""
    ACCEPT cPrompt TO c
RETURN AllTrim( c )
 