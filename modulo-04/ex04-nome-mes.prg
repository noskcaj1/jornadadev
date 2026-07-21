function Main()
    
    local nMes := 0
    local aMeses := { ;
        "Janeiro", "Fevereiro", "Marco", "Abril", ;
            "Maio", "Junho", "Julho", "Agosto", ;
                "Setembro", "Outubro", "Novembro", "Dezembro" ;
                    }
    
    INPUT "Digite o numero do mes: " to nMes
    
    if nMes >= 1 .and. nMes <= len( aMeses ) .and. nMes == int( nMes )
        ? aMeses[ nMes ]
    else
        ? "Mes invalido."
    endif
    
return nil