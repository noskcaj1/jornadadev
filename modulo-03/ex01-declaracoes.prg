function main()

    local cNomeFuncionario  := "Damião"
    local nSalarioBruto     := 2500.00
    local lAtivo            := .T.
    local cCodDepartamento  := "TI"
    local cDataAdmissao     := hb_CToD( "07/04/2013", "dd/mm/yyyy" )


    ? "Nome: "             + cNomeFuncionario
    ? "Salário Bruto: "    + Str( nSalarioBruto, 10, 2 )
    ? "Ativo?: "           + iif( lAtivo, "Sim", "Não" )
    ? "Data de Admissão: " + DToC( cDataAdmissao )
    ? "Departamento: "     + cCodDepartamento

return nil