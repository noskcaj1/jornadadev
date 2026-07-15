REQUEST HB_CODEPAGE_UTF8
REQUEST HB_LANG_PT

#define ESC 27

FUNCTION Main()

    LOCAL nKey := 0

    hb_cdpSelect( "UTF8" )
    hb_langSelect( "PT" )

    SET DATE FORMAT TO "dd/mm/yyyy"

    SetCursor( 0 )
    CLS

    QOut( "||====================================||" )
    QOut( "||     FICHA DE APRESENTACÃO          ||" )
    QOut( "||====================================||" )
    QOut( "||Nome   : Jackson Miranda            ||" )
    QOut( "||Cidade : São Paulo                  ||" )
    QOut( "||Curso  : Harbour/ADVPL              ||" )
    QOut( "||====================================||" )  
    QOut( "" )

    @ 9, 0 SAY "||Pressione ESC para sair do programa.||"
    @ 10, 0 SAY "||====================================||"

    DO WHILE nKey != ESC
        @ 8, 0 SAY "||Data e Hora: " + DToC( Date() ) + " " + Time() + "    ||"
        nKey := Inkey( 1 )
    ENDDO

    setcursor( 1 )
    @ 11, 0 SAY "||========== *Até mais!* =============||"
    
RETURN NIL