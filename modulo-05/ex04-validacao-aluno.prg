function Main()

    local cNome := ""
    local cDisc := ""
    local n1 := 0
    local n2 := 0

    while .T.
        accept "Nome: " to cNome
        if Len( Trim( cNome ) ) > 0
            exit
        endif
        ? "Nome nao pode ser vazio."
    enddo

    while .T.
        accept "Disciplina (3 letras maiusculas): " to cDisc
        if Len( cDisc ) == 3 .and. cDisc == Upper( cDisc )
            exit
        endif
        ? "Disciplina invalida."
    enddo

    while .T.
        input "Nota 1: " to n1
        if n1 >= 0 .and. n1 <= 10
            exit
        endif
        ? "Nota invalida."
    enddo

    while .T.
        input "Nota 2: " to n2
        if n2 >= 0 .and. n2 <= 10
            exit
        endif
        ? "Nota invalida."
    enddo

    ? "Nome:", cNome
    ? "Disciplina:", cDisc
    ? "Media:", ( n1 + n2 ) / 2

return nil
