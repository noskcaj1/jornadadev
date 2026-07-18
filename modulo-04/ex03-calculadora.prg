function Main()

    local cOp := ""
    local nA := 0, nB := 0
 
    accept "Operacao (+, -, *, /, ^, R): " to cOp
    cOp := upper( alltrim( cOp ) )
 
    input "Primeiro numero: " to nA
 
    if cOp != "R"
       input "Segundo numero: " to nB
    endif
 
    do case
    case cOp == "+"
       ? "Resultado:", nA + nB
    case cOp == "-"
       ? "Resultado:", nA - nB
    case cOp == "*"
       ? "Resultado:", nA * nB
    case cOp == "/" .and. nB != 0
       ? "Resultado:", nA / nB
    case cOp == "^"
       ? "Resultado:", nA ^ nB
    case cOp == "R"
       ? "Resultado:", sqrt( nA )
    case cOp == "/"
       ? "Erro: divisao por zero."
    otherwise
       ? "Operacao invalida."
    endcase
 
return nil