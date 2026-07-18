function Main()

    local nSalario := 0
    local nReajuste
    local nNovoSalario
 
    input "Digite o salario atual: R$ " to nSalario
 
    if nSalario < 1000
       nReajuste := 0.15
    elseif nSalario <= 2000
       nReajuste := 0.12
    elseif nSalario <= 4000
       nReajuste := 0.08
    else
       nReajuste := 0.05
    endif
 
    nNovoSalario := nSalario * ( 1 + nReajuste )
 
    ? "Percentual de reajuste:", nReajuste * 100, "%"
    ? "Novo salario: R$", nNovoSalario
 
return nil