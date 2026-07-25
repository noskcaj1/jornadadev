SET PROCEDURE TO estoque_lib.prg

PROCEDURE Main()
   LOCAL aEstoque := {}
   LOCAL nOpcao

   DO WHILE .T.
      nOpcao := MostrarMenu()
      DO CASE
         CASE nOpcao == 1 ; CadastrarProduto( aEstoque )
         CASE nOpcao == 2 ; ListarProdutos( aEstoque )
         CASE nOpcao == 3 ; EntradaEstoque( aEstoque )
         CASE nOpcao == 4 ; SaidaEstoque( aEstoque )
         CASE nOpcao == 5 ; ConsultarProduto( aEstoque )
         CASE nOpcao == 6 ; Relatorio( aEstoque )
         CASE nOpcao == 0 ; EXIT
            OTHERWISE        ; ? "Opcao invalida!"
      ENDCASE
   ENDDO

   ? "Sistema encerrado."
RETURN

FUNCTION MostrarMenu()
   ? ""
   ? "===== CONTROLE DE ESTOQUE ====="
   ? "1 - Cadastrar produto"
   ? "2 - Listar produtos"
   ? "3 - Entrada de estoque"
   ? "4 - Saida de estoque"
   ? "5 - Buscar produto por codigo"
   ? "6 - Relatorio de valor em estoque"
   ? "0 - Sair"
RETURN LerNumero( "Escolha: " )

PROCEDURE ConsultarProduto( aEstoque )
   LOCAL nCod := LerNumero( "Codigo procurado: " )
   LOCAL nPos := BuscarProduto( aEstoque, nCod )
   IF nPos == 0
      ? "Produto nao encontrado."
   ELSE
      ? "Encontrado na posicao", nPos, "->", aEstoque[ nPos ][ 2 ]
   ENDIF
RETURN
