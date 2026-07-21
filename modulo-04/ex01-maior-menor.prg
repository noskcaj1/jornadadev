function Main()
    
    local nValor1
    local nValor2
    
    input "Digite o primeiro valor: " to nValor1
    input "Digite o segundo valor: " to nValor2
    
    if nValor1 == nValor2
        ? "Os valores sao iguais."
    else
        if nValor1 > nValor2
            ? "Maior:", nValor1
            ? "Menor:", nValor2
        else
            ? "Maior:", nValor2
            ? "Menor:", nValor1
        endif
    endif
    
return nil