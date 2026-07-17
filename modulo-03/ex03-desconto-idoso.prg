function main()
    local cNome, cData, nPreco, dNasc, nIdade, nDesc

    SET DATE FORMAT TO "dd/mm/yyyy"

    Accept "Nome: " To cNome
    Accept "Nascimento (dd/mm/aaaa): " To cData
    Input  "Preço (R$): " To nPreco

    dNasc := hb_CToD( cData, "dd/mm/yyyy" )
    nIdade := Int( ( Date() - dNasc ) / 365 )
    nDesc := iif( nIdade >= 60, nPreco * 0.125, 0 )

    ? Replicate( "=", 45 )
    ? PadC( "Resumo da venda", 45 )
    ? Replicate( "=", 45 )
    ? "Cliente:  " + AllTrim( cNome )
    ? "Idade:    " + hb_NToS( nIdade ) + " anos"
    ? "Preço:    R$ " + Str( nPreco, 10, 2 )
    ? "Desconto: R$ " + Str( nDesc, 10, 2 ) + iif( nDesc > 0, "  (12,5% sênior)", "" )
    ? "Total:    R$ " + Str( nPreco - nDesc, 10, 2 )
    ? Replicate( "=", 45 )
return nil




