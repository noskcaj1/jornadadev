//Declarando a codificação e o idioma do programa
REQUEST HB_CODEPAGE_UTF8
REQUEST HB_LANG_PT

// Declarando a função principal do programa
FUNCTION Main()

    //Declarando as variáveis
    LOCAL cNome   := "Jackson Miranda"
    LOCAL cCidade := "São Paulo"
    LOCAL cCurso  := "Harbour/ADVPL"

    // Selecionando a codificação e o idioma
    hb_cdpSelect( "UTF8" )
    hb_langSelect( "PT" )

    //Exibindo a ficha de apresentação
    QOut( "==============================" )
    QOut( "     FICHA DE APRESENTACÃO" )
    QOut( "==============================" )
    QOut( "Nome   : " + cNome )
    QOut( "Cidade : " + cCidade )
    QOut( "Curso  : " + cCurso )
    QOut( "==============================" )

RETURN NIL