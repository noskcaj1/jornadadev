/*
 * estoque_lib.prg  -  Operacoes de array do controle de estoque.
 * Incluida pelo principal.prg via SET PROCEDURE TO.
 *
 * Registro de produto: { codigo, nome, quantidade, preco_unitario }
 */

#define P_COD   1
#define P_NOME  2
#define P_QTD   3
#define P_PRECO 4

// Opcao 1 - cadastra validando codigo unico.
PROCEDURE CadastrarProduto( aEstoque )
   LOCAL nCod   := LerNumero( "Codigo: " )
   LOCAL cNome, nQtd, nPreco

   IF nCod <= 0
      ? "Codigo invalido."
      RETURN
   ENDIF
   IF BuscarProduto( aEstoque, nCod ) > 0
      ? "Ja existe um produto com esse codigo."
      RETURN
   ENDIF

   cNome  := LerTexto( "Nome: " )
   nQtd   := LerNumero( "Quantidade inicial: " )
   nPreco := LerNumero( "Preco unitario: " )

   AAdd( aEstoque, { nCod, cNome, nQtd, nPreco } )
   ? "Produto cadastrado!"
RETURN

// Opcao 2 - lista percorrendo com FOR.
PROCEDURE ListarProdutos( aEstoque )
   LOCAL nI
   IF Empty( aEstoque )
      ? "Nenhum produto cadastrado."
      RETURN
   ENDIF
   ? "COD  NOME                 QTD    PRECO"
   ? Replicate( "-", 45 )
   FOR nI := 1 TO Len( aEstoque )
      ? Str( aEstoque[ nI ][ P_COD ], 4 ), ;
         PadR( aEstoque[ nI ][ P_NOME ], 20 ), ;
         Str( aEstoque[ nI ][ P_QTD ], 5 ), ;
         Str( aEstoque[ nI ][ P_PRECO ], 8, 2 )
   NEXT
RETURN

// Opcao 3 - entrada (aumenta quantidade).
PROCEDURE EntradaEstoque( aEstoque )
   LOCAL nPos := LocalizarOuAvisar( aEstoque )
   LOCAL nQtd
   IF nPos == 0
      RETURN
   ENDIF
   nQtd := LerNumero( "Quantidade de entrada: " )
   IF nQtd <= 0
      ? "Quantidade invalida."
      RETURN
   ENDIF
   aEstoque[ nPos ][ P_QTD ] += nQtd
   ? "Entrada registrada. Novo saldo:", aEstoque[ nPos ][ P_QTD ]
RETURN

// Opcao 4 - saida (diminui; valida saldo suficiente).
PROCEDURE SaidaEstoque( aEstoque )
   LOCAL nPos := LocalizarOuAvisar( aEstoque )
   LOCAL nQtd
   IF nPos == 0
      RETURN
   ENDIF
   nQtd := LerNumero( "Quantidade de saida: " )
   IF nQtd <= 0
      ? "Quantidade invalida."
      RETURN
   ENDIF
   IF nQtd > aEstoque[ nPos ][ P_QTD ]
      ? "Estoque insuficiente! Saldo atual:", aEstoque[ nPos ][ P_QTD ]
      RETURN
   ENDIF
   aEstoque[ nPos ][ P_QTD ] -= nQtd
   ? "Saida registrada. Novo saldo:", aEstoque[ nPos ][ P_QTD ]
RETURN

// Opcao 5 - devolve a posicao pelo codigo, ou 0 se nao achar.
FUNCTION BuscarProduto( aEstoque, nCod )
RETURN AScan( aEstoque, {| a | a[ P_COD ] == nCod } )

// Opcao 6 - relatorio de valor em estoque por produto e total geral.
PROCEDURE Relatorio( aEstoque )
   LOCAL nI, nValor, nTotal := 0
   IF Empty( aEstoque )
      ? "Nenhum produto cadastrado."
      RETURN
   ENDIF
   ? "RELATORIO DE VALOR EM ESTOQUE"
   ? Replicate( "-", 45 )
   FOR nI := 1 TO Len( aEstoque )
      nValor := aEstoque[ nI ][ P_QTD ] * aEstoque[ nI ][ P_PRECO ]
      nTotal += nValor
      ? PadR( aEstoque[ nI ][ P_NOME ], 20 ), "R$", Str( nValor, 10, 2 )
   NEXT
   ? Replicate( "-", 45 )
   ? PadR( "TOTAL GERAL", 20 ), "R$", Str( nTotal, 10, 2 )
RETURN

// ---- Auxiliares internos ----

// Pede o codigo, procura e ja avisa se nao existir. Devolve posicao ou 0.
STATIC FUNCTION LocalizarOuAvisar( aEstoque )
   LOCAL nPos := BuscarProduto( aEstoque, LerNumero( "Codigo do produto: " ) )
   IF nPos == 0
      ? "Produto nao encontrado."
   ENDIF
RETURN nPos

FUNCTION LerNumero( cPrompt )
   LOCAL c := ""
   ACCEPT cPrompt TO c
RETURN Val( c )

FUNCTION LerTexto( cPrompt )
   LOCAL c := ""
   ACCEPT cPrompt TO c
RETURN AllTrim( c )
