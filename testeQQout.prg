request hb_codepage_utf8
request hb_lang_pt_BR

function main()

    hb_cdpselect("UTF8")
    hb_langselect("pt_BR")
    QOut("Linha 1") //pula linha ao final   
    qout("ººººººººººººººººººººººººººººººººº") //pula linha ao final
    qout("") //pula linha ao final
    QQOut("Sem ") //não pula linha ao final
    QQOut("Pular linha") //pula linha ao final
    qout("")
    qout(" ================================") //pula linha ao final
    qout("")
    qout("Linha 2") //pula linha ao final
    qout("ººººººººººººººººººººººººººººººººº") //pula linha ao final
    qout("") //pula linha ao final
    qqout("Testando acentuação: ")//não pula linha ao final
    qqout("ç, ã, é, ê, á, í, ó, ú, á")
    qout("")
    qout("")

return NIL
