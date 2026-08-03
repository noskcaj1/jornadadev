#include "protheus.ch"   // Definicoes padrao do Protheus

// ============================================================
// STTIP004 - Tela de Interacoes (SZ2) de um contato especifico.
// E chamada pelo botao "Interacoes" do STTIP003, ja com um
// contato posicionado na SZ1.
// ============================================================
User Function STTIP004()

	// Variaveis locais de trabalho:
	Local cContato := ""   // Vai guardar o codigo do contato selecionado
	Local cFiltro  := ""   // Vai guardar a expressao de filtro da SZ2

	// cCadastro: titulo da tela. aRotina: botoes do browse.
	// Ambos Private porque o mBrowse le do ambiente.
	Private cCadastro := "Interacoes do Contato"
	Private aRotina   := {}

	// Trava de seguranca: so continua se houver um contato valido na SZ1.
	// Select("SZ1") == 0 -> a tabela SZ1 nem esta aberta.
	// SZ1->(Eof())       -> nao ha registro posicionado.
	// Empty(...Z1_CODIGO)-> o codigo esta vazio.
	// Em qualquer desses casos, avisa e sai sem abrir a tela.
	If Select("SZ1") == 0 .Or. SZ1->(Eof()) .Or. Empty(SZ1->Z1_CODIGO)
		MsgAlert("Selecione um contato valido.", "Atencao")
		Return Nil
	EndIf

	// Guarda o codigo do contato atual, que sera usado no filtro.
	cContato := SZ1->Z1_CODIGO

	// Monta os botoes padrao do browse de interacoes.
	AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
	AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
	AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
	AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
	AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})

	// Monta a expressao de filtro como texto (string).
	// Resultado, por exemplo: Z2_FILIAL == '  ' .And. Z2_CONTAT == 'EMP001'
	// Isso faz o browse mostrar SO as interacoes daquele contato.
	cFiltro := "Z2_FILIAL == '" + xFilial("SZ2") + "' .And. " +;
		"Z2_CONTAT == '" + cContato + "'"

	DbSelectArea("SZ2")        // Vai para a tabela de Interacoes
	DbSetOrder(1)              // Indice 1 (Z2_FILIAL+Z2_CONTAT)

	// Set Filter To &(cFiltro): aplica o filtro.
	// O "&" faz a macro-execucao: transforma o texto de cFiltro
	// numa expressao de verdade e a ativa sobre a SZ2.
	Set Filter To &(cFiltro)

	DbGoTop()                  // Posiciona no 1o registro que passa no filtro

	// Desenha o browse da SZ2 (ja filtrado).
	mBrowse(6, 1, 22, 75, "SZ2")

	// Limpeza depois que o usuario fecha a tela:
	DbSelectArea("SZ2")        // Garante que a SZ2 e a area ativa
	Set Filter To              // Remove o filtro (sem argumento = limpa)
	// Importante pra nao "vazar" o filtro para outras rotinas

Return Nil
