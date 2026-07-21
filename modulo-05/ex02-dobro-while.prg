function Main()

    local nValor := 0

    while .T.
        input "Digite um valor (0 ou negativo para sair): " to nValor
        if nValor <= 0
            exit
        endif
        ? "Dobro:", nValor * 2
    enddo

return nil
