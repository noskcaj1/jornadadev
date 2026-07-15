//Declarando a codificação e o idioma do programa
REQUEST HB_CODEPAGE_UTF8
REQUEST HB_LANG_PT

// Declarando a função principal do programa
FUNCTION Main()

    // Selecionando a codificação e o idioma
    hb_cdpSelect( "UTF8" )
    hb_langSelect( "PT" )

    // Exibindo a ficha de apresentação
    QOut( "==============================" )
    QOut( "     FICHA DE APRESENTACÃO" )
    QOut( "==============================" )
    QOut( "Nome   : Jackson Miranda" )
    QOut( "Cidade : São Paulo" )
    QOut( "Curso  : Harbour/ADVPL" )
    QOut( "==============================" )

return NIL