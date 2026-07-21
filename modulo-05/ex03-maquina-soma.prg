function Main()

    local nValor := 0
    local nTotal := 0
    local nQtd := 0

    while .T.
        input "Digite um valor (0 para encerrar): " to nValor
        if nValor == 0
            exit
        endif
        nTotal += nValor
        nQtd++
    enddo

    ? "Soma total:", nTotal
    ? "Quantidade de valores:", nQtd

return nil
