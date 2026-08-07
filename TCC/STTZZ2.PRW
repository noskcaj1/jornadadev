#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STTZZ2
================================================================================
 Ocorrencias de Fornecedores (ZZ2) - Nao conformidades por entrega
================================================================================
 mBrowse da tabela ZZ2 com:

   * LEGENDA por conformidade (DIFERENCIAL - calcula %NC vs tolerancia ZZ1):
        Vermelho  %NC > ZZ1_TOLERA   (acima da tolerancia do certificado)
        Verde     %NC <= ZZ1_TOLERA  (dentro da tolerancia)

     onde  %NC = ( ZZ2_QTDNOK / (ZZ2_QTDOK + ZZ2_QTDNOK) ) * 100
     (calculado por U_PercNaoConforme; comparacao por U_ForaToleranc)

   * CRUD protegido por BEGIN SEQUENCE (via U_ExecCRUD da STTZZLIB).

   * Versao FILTRADA (U_STTZZ2FLT) chamada pelo botao "Ocorrencias" da STTZZ1,
     exibindo apenas as ZZ2 de um controle ZZ1 especifico.

 Menu: SIGACOM > Cadastros > Controle ISO 9001 > Ocorrencias de Fornecedores

 @type    function
 @author  TCC - Harbour/ADVPL - Do Zero ao Protheus
 @since   2025
 @version 2.0
/*/

#DEFINE ST2_TITULO  "Ocorrencias de Fornecedores (ISO 9001)"

USER FUNCTION STTZZ2()
	Local aArea   := GetArea()

	// Browse completo (sem filtro)
	ST2Browse(.F., "")

	RestArea(aArea)
Return NIL


/*/{Protheus.doc} STTZZ2FLT
--------------------------------------------------------------------------------
 Versao FILTRADA da ZZ2. Chamada pelo botao "Ocorrencias" da STTZZ1.
 Exibe somente as ocorrencias cujo ZZ2_CONFOR seja igual ao controle informado.

 @param cCodigoZZ1  Caractere  Codigo do controle ZZ1 (ZZ1_CODIGO)
--------------------------------------------------------------------------------
/*/
USER FUNCTION STTZZ2FLT(cCodigoZZ1)
	Local aArea := GetArea()

	Default cCodigoZZ1 := ""

	// Browse filtrado pelo controle selecionado
	ST2Browse(.T., cCodigoZZ1)

	RestArea(aArea)
Return NIL


/*/{Protheus.doc} ST2Browse
--------------------------------------------------------------------------------
 Nucleo unico do browse da ZZ2 (evita duplicar codigo entre a visao completa
 e a visao filtrada). Monta aRotina, legenda e, quando solicitado, aplica o
 filtro por controle (ZZ2_CONFOR).

 @param lFiltra  Logico     .T. aplica filtro por controle
 @param cConfor  Caractere  Codigo do controle a filtrar (quando lFiltra)
--------------------------------------------------------------------------------
/*/
STATIC FUNCTION ST2Browse(lFiltra, cConfor)
	Local cAlias  := "ZZ2"
	Local aCores  := {}
	Local bFiltro
	Private cCadastro := ST2_TITULO   // titulo lido pelo mBrowse/AxCadastro
	Private aRotina := {}             // mBrowse le aRotina do escopo (Private), nao por parametro

	Default lFiltra := .F.
	Default cConfor := ""

	// ------------------------------------------------------------------
	// 1) Acoes do browse
	// ------------------------------------------------------------------
	aAdd(aRotina, {"Pesquisar",  "AxPesqui",     0, 1})
	aAdd(aRotina, {"Visualizar", "U_STTZZ2MNT",  0, 2})
	aAdd(aRotina, {"Incluir",    "U_STTZZ2MNT",  0, 3})
	aAdd(aRotina, {"Alterar",    "U_STTZZ2MNT",  0, 4})
	aAdd(aRotina, {"Excluir",    "U_STTZZ2MNT",  0, 5})

	// ------------------------------------------------------------------
	// 2) Legenda: %NC vs tolerancia do certificado (ZZ1_TOLERA)
	//    U_ForaToleranc reaproveita a biblioteca (calculo unico).
	// ------------------------------------------------------------------
	aAdd(aCores, {"U_ForaToleranc(ZZ2_CONFOR, ZZ2_QTDOK, ZZ2_QTDNOK)", "BR_VERMELHO"})
	aAdd(aCores, {".T.",                                               "BR_VERDE"   })

	// ------------------------------------------------------------------
	// 3) Selecao / filtro
	// ------------------------------------------------------------------
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()

	If lFiltra .And. !Empty(cConfor)
		cCadastro := ST2_TITULO + " - Controle " + AllTrim(cConfor)
		bFiltro   := {|| ZZ2->ZZ2_CONFOR == cConfor}
		dbSetFilter(bFiltro, "ZZ2_CONFOR == '" + cConfor + "'")
		dbGoTop()
	EndIf

	// aRotina NAO e passada por parametro: mBrowse le a Private aRotina do
	// escopo do chamador. O 6o parametro posicional e "aFixos" (outra coisa).
	mBrowse(6, 1, 22, 75, cAlias, , , , , , aCores)

	// Limpa o filtro ao sair (higiene de area de trabalho)
	If lFiltra
		dbSelectArea(cAlias)
		dbClearFilter()
	EndIf

Return NIL


/*/{Protheus.doc} STTZZ2MNT
--------------------------------------------------------------------------------
 Roteador de manutencao da ZZ2. Delega ao motor CRUD com tratamento de erros,
 aplicando a validacao de confirmacao U_ST2TudoOk.
--------------------------------------------------------------------------------
/*/
USER FUNCTION STTZZ2MNT(cAlias, nReg, nOpc)
	Local lOk := .T.

	Default cAlias := "ZZ2"
	Default nOpc   := 2

	lOk := U_ExecCRUD(cAlias, ST2_TITULO, nOpc, "U_ST2TudoOk()", ".T.")

Return lOk


/*/{Protheus.doc} ST2TudoOk
--------------------------------------------------------------------------------
 Validacao de CONFIRMACAO (TudoOk) da ZZ2, no momento de gravar:

    1. Controle (ZZ2_CONFOR) deve existir na ZZ1;
    2. Produto (ZZ2_CODPRO) deve existir na SB1;
    3. Data da ocorrencia nao pode ser futura;
    4. Consistencia: deve haver ao menos uma quantidade (OK ou NOK) informada.

 @return lOk  Logico  .T. libera a gravacao; .F. mantem o usuario na tela
--------------------------------------------------------------------------------
/*/
USER FUNCTION ST2TudoOk()
	Local lOk := .T.

	// 1) Controle existe na ZZ1?
	// ExistCpo() nao e confiavel nesse build - ver U_ExisteReg em STTZZLIB.PRW.
	If lOk .And. !U_ExisteReg("ZZ1", xFilial("ZZ1") + M->ZZ2_CONFOR, 1)
		Help(, , "ST2TudoOk", , "Controle de fornecimento (ZZ1) inexistente.", 1, 0)
		lOk := .F.
	EndIf

	// 2) Produto existe na SB1?
	If lOk .And. !U_ExisteReg("SB1", xFilial("SB1") + M->ZZ2_CODPRO, 1)
		Help(, , "ST2TudoOk", , "Produto nao cadastrado na SB1.", 1, 0)
		lOk := .F.
	EndIf

	// 3) Data nao pode ser futura
	If lOk .And. M->ZZ2_DATA > dDataBase
		Help(, , "ST2TudoOk", , "A data da ocorrencia nao pode ser futura.", 1, 0)
		lOk := .F.
	EndIf

	// 4) Consistencia de quantidades
	If lOk .And. (M->ZZ2_QTDOK + M->ZZ2_QTDNOK) <= 0
		Help(, , "ST2TudoOk", , "Informe ao menos uma quantidade (conforme ou nao conforme).", 1, 0)
		lOk := .F.
	EndIf

Return lOk
