#include "protheus.ch"   // Traz definicoes padrao do Protheus (constantes, comandos, etc.)

// ============================================================
// STTIP003 - Tela principal: cadastro/browse de Contatos (SZ1)
// ============================================================
User Function STTIP003()

	// aColors: define a cor (legenda) de cada linha do browse.
	// O Protheus avalia a expressao da 1a coluna; se der .T., usa a cor da 2a coluna.
	// Ele testa de cima pra baixo e para na primeira que der verdadeiro.
	Local aColors := {;
		{"U_ST3TEMINT()", "BR_VERDE"},;    // Se o contato TEM interacao -> verde
	{".T."           , "BR_VERMELHO"};  // Senao (sempre verdadeiro) -> vermelho
	}

	// cCadastro: titulo que aparece no topo da tela.
	// aRotina: lista de botoes/opcoes do browse. Precisam ser Private
	// porque o mBrowse le essas variaveis do ambiente.
	Private cCadastro := "Contatos"
	Private aRotina   := {}

	// Monta os botoes do browse. Cada item = {Titulo, Funcao, 0, NumeroDaOpcao}
	// As funcoes Ax... sao padrao do Protheus (pesquisa, visualiza, inclui, etc.)
	AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
	AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
	AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
	AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
	AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})
	AAdd(aRotina, {"Interacoes", "U_ST3INT", 0, 6})  // Botao customizado -> abre as interacoes

	DbSelectArea("SZ1")   // Seleciona a tabela de Contatos como area de trabalho ativa
	DbSetOrder(1)         // Usa o indice 1 (Z1_FILIAL+Z1_CODIGO): ordena por codigo
	DbGoTop()             // Posiciona no primeiro registro

	// mBrowse: desenha o browse na tela.
	// (6,1,22,75) = coordenadas da janela; "SZ1" = tabela; aColors na posicao das cores.
	mBrowse(6, 1, 22, 75, "SZ1", , , , , , aColors)

Return Nil


// ============================================================
// ST3INT - Acao do botao "Interacoes".
// Valida se ha um contato selecionado e abre a tela de interacoes.
// (Nome curto: max. 10 caracteres neste build.)
// ============================================================
User Function ST3INT()

	// Se nao ha registro posicionado (fim de arquivo) OU o codigo esta vazio,
	// avisa o usuario e sai sem abrir nada.
	If SZ1->(Eof()) .Or. Empty(SZ1->Z1_CODIGO)
		MsgAlert("Selecione um contato primeiro.", "Atencao")
		Return Nil
	EndIf

	U_STTIP004()   // Contato valido -> chama a tela de Interacoes (STTIP004)

Return Nil


// ============================================================
// ST3TEMINT - Funcao de apoio (usada no aColors).
// Retorna .T. se o contato posicionado tiver ao menos uma interacao na SZ2.
// E isso que faz a linha ficar verde ou vermelha.
// ============================================================
User Function ST3TEMINT()

	Local lTem  := .F.          // Comeca assumindo que NAO tem interacao
	Local aArea := GetArea()    // Guarda a area/posicao atual pra restaurar no fim
	// (evita bagunçar o browse ao mexer em outra tabela)

	// So faz a busca se houver um contato valido posicionado
	If !SZ1->(Eof()) .And. !Empty(SZ1->Z1_CODIGO)
		DbSelectArea("SZ2")     // Vai para a tabela de Interacoes
		DbSetOrder(1)           // Indice 1 da SZ2 (Z2_FILIAL+Z2_CONTAT)
		// Procura uma interacao cuja chave = filial + codigo do contato atual.
		// DbSeek retorna .T. se encontrar -> significa que o contato tem interacao.
		lTem := DbSeek(xFilial("SZ2") + SZ1->Z1_CODIGO)
	EndIf

	RestArea(aArea)   // Restaura a tabela/posicao que estava ativa antes

Return lTem           // Devolve .T. (verde) ou .F. (vermelho) para o aColors
