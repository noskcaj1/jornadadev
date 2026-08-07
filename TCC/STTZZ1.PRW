#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STTZZ1
================================================================================
 Controle de Fornecimento (ZZ1) - Certificados de qualidade ISO 9001
================================================================================
 mBrowse da tabela ZZ1 com:

   * LEGENDA por situacao do certificado:
        Vermelho  ZZ1_VALCER <  dDataBase        (certificado VENCIDO)
        Amarelo   ZZ1_VALCER <= dDataBase + 30   (vence em ate 30 dias)
        Verde     demais                         (certificado OK)

   * BOTAO "Ocorrencias" que abre a ZZ2 ja FILTRADA pelo controle selecionado
     (chama U_STTZZ2FLT).

   * CRUD protegido por BEGIN SEQUENCE (via U_ExecCRUD da STTZZLIB).

   * PROTECAO DE EXCLUSAO: nao permite excluir a ZZ1 se existir ZZ2 vinculada.

 Menu: SIGACOM > Cadastros > Controle ISO 9001 > Controle de Fornecimento

 @type    function
 @author  TCC - Harbour/ADVPL - Do Zero ao Protheus
 @since   2025
 @version 2.0
/*/

// Titulo unico da manutencao (evita literais repetidos)
#DEFINE ST1_TITULO  "Controle de Fornecimento (ISO 9001)"

USER FUNCTION STTZZ1()
	Local aArea    := GetArea()
	Local cAlias   := "ZZ1"
	Local aCores   := {}
	Private cCadastro := ST1_TITULO   // titulo lido pelo mBrowse/AxCadastro
	Private aRotina := {}             // mBrowse le aRotina do escopo (Private), nao por parametro

	// ------------------------------------------------------------------
	// 1) Acoes do browse (aRotina)
	//    Todas as operacoes de manutencao roteiam para U_STTZZ1MNT, que
	//    aplica o tratamento de erros centralizado.
	// ------------------------------------------------------------------
	aAdd(aRotina, {"Pesquisar",   "AxPesqui",     0, 1})
	aAdd(aRotina, {"Visualizar",  "U_STTZZ1MNT",  0, 2})
	aAdd(aRotina, {"Incluir",     "U_STTZZ1MNT",  0, 3})
	aAdd(aRotina, {"Alterar",     "U_STTZZ1MNT",  0, 4})
	aAdd(aRotina, {"Excluir",     "U_STTZZ1MNT",  0, 5})
	aAdd(aRotina, {"Ocorrencias", "U_STTZZ1OCO",  0, 6})   // botao extra

	// ------------------------------------------------------------------
	// 2) Legenda (cores) - avaliada de cima para baixo; a 1a que casar vence
	// ------------------------------------------------------------------
	aAdd(aCores, {"ZZ1_VALCER <  dDataBase",      "BR_VERMELHO"})  // vencido
	aAdd(aCores, {"ZZ1_VALCER <= dDataBase + 30", "BR_AMARELO" })  // vence em 30 dias
	aAdd(aCores, {".T.",                          "BR_VERDE"   })  // ok

	// ------------------------------------------------------------------
	// 3) Abre o browse posicionado na ordem 1 (chave primaria)
	// ------------------------------------------------------------------
	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()

	// aRotina NAO e passada por parametro: mBrowse le a Private aRotina do
	// escopo do chamador. O 6o parametro posicional e "aFixos" (outra coisa).
	mBrowse(6, 1, 22, 75, cAlias, , , , , , aCores)

	RestArea(aArea)
Return NIL


/*/{Protheus.doc} STTZZ1MNT
--------------------------------------------------------------------------------
 Roteador de manutencao da ZZ1. Recebe a operacao do browse (nOpc) e delega
 ao motor CRUD com tratamento de erros (U_ExecCRUD), informando:
    - a validacao de confirmacao (U_ST1TudoOk);
    - a validacao de exclusao    (U_ST1VldExc) - bloqueia se houver ZZ2.

 Assinatura padrao exigida pelo mBrowse: (cAlias, nReg, nOpc).
--------------------------------------------------------------------------------
/*/
USER FUNCTION STTZZ1MNT(cAlias, nReg, nOpc)
	Local lOk := .T.

	Default cAlias := "ZZ1"
	Default nOpc   := 2

	lOk := U_ExecCRUD(cAlias, ST1_TITULO, nOpc, "U_ST1TudoOk()", "U_ST1VldExc()")

Return lOk


/*/{Protheus.doc} STTZZ1OCO
--------------------------------------------------------------------------------
 Acao do botao "Ocorrencias": abre a ZZ2 filtrada pelo controle (ZZ1_CODIGO)
 do registro atualmente selecionado no browse.
--------------------------------------------------------------------------------
/*/
USER FUNCTION STTZZ1OCO(cAlias, nReg, nOpc)
	Local aArea   := GetArea()
	Local cCodZZ1 := ""

	Default cAlias := "ZZ1"

	// O mBrowse ja posicionou a ZZ1 no registro destacado
	cCodZZ1 := ZZ1->ZZ1_CODIGO

	If Empty(cCodZZ1)
		MsgInfo("Selecione um controle de fornecimento para ver as ocorrencias.", ST1_TITULO)
	Else
		U_STTZZ2FLT(cCodZZ1)   // abre a ZZ2 filtrada
	EndIf

	RestArea(aArea)
Return NIL


/*/{Protheus.doc} ST1TudoOk
--------------------------------------------------------------------------------
 Validacao de CONFIRMACAO (TudoOk) da ZZ1, chamada no momento de gravar.
 Reforca, em nivel de tela inteira, as regras de negocio (defesa em
 profundidade, complementando as validacoes campo-a-campo do SX3):

    1. Fornecedor deve existir na SA2 (cod + loja);
    2. Tolerancia deve estar entre 0 e 100;
    3. Na INCLUSAO, a validade do certificado nao pode ser retroativa.

 @return lOk  Logico  .T. libera a gravacao; .F. mantem o usuario na tela
--------------------------------------------------------------------------------
/*/
USER FUNCTION ST1TudoOk()
	Local lOk := .T.

	// 1) Fornecedor existe?
	// ExistCpo() nao e confiavel p/ tabelas padrao (SA2/SB1) nesse build -
	// ver U_ExisteReg em STTZZLIB.PRW. Tambem faltava o prefixo xFilial("SA2").
	If lOk .And. !U_ExisteReg("SA2", xFilial("SA2") + M->ZZ1_FORNEC + M->ZZ1_LOJAFO, 1)
		Help(, , "ST1TudoOk", , "Fornecedor/Loja nao cadastrado na SA2.", 1, 0)
		lOk := .F.
	EndIf

	// 2) Tolerancia entre 0 e 100
	If lOk .And. !(M->ZZ1_TOLERA >= 0 .And. M->ZZ1_TOLERA <= 100)
		Help(, , "ST1TudoOk", , "A tolerancia deve estar entre 0 e 100%.", 1, 0)
		lOk := .F.
	EndIf

	// 3) Validade do certificado na inclusao
	If lOk .And. INCLUI .And. M->ZZ1_VALCER < dDataBase
		Help(, , "ST1TudoOk", , "A validade do certificado nao pode ser retroativa.", 1, 0)
		lOk := .F.
	EndIf

Return lOk


/*/{Protheus.doc} ST1VldExc
--------------------------------------------------------------------------------
 Validacao de EXCLUSAO da ZZ1 (DIFERENCIAL / integridade referencial).

 Impede a exclusao de um controle de fornecimento (ZZ1) caso existam
 ocorrencias (ZZ2) vinculadas a ele (ZZ2_CONFOR == ZZ1_CODIGO).

 @return lPode  Logico  .T. pode excluir; .F. bloqueia a exclusao
--------------------------------------------------------------------------------
/*/
USER FUNCTION ST1VldExc()
	Local lPode   := .T.
	Local aArea   := GetArea()
	Local cCodZZ1 := ZZ1->ZZ1_CODIGO

	dbSelectArea("ZZ2")
	dbSetOrder(1)                                          // ZZ2_FILIAL + ZZ2_CONFOR + ...
	If dbSeek(xFilial("ZZ2") + cCodZZ1)
		lPode := .F.
		MsgStop("Nao e possivel excluir: existem ocorrencias (ZZ2) " + ;
			"vinculadas a este controle de fornecimento.", ST1_TITULO)
	EndIf

	RestArea(aArea)
Return lPode
