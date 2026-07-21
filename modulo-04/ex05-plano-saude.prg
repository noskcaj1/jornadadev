function Main()
    
    Local nIdade := 0
    local   nDependentes := 0
    Local nValorBase
    LOcal nValortotal
    
    input "Digite a idade: " to nIdade
    input "Numero de dependentes: " to nDependentes
    
    if nIdade < 0 .or. nDependentes < 0 .or. nDependentes != int( nDependentes )
        ? "Dados invalidos."
    return nil
endif

if nIdade <= 25
    nValorBase := 180
elseif nIdade <= 40
    nValorBase := 260
elseif nIdade <= 60
    nValorBase := 380
else
    nValorBase := 520
endif

nValortotal := nValorBase + nDependentes * 90

? "Valor base: R$", nValorBase
? "Adicional: R$", nDependentes * 90
? "Valor mensal total: R$", nValortotal

return nil