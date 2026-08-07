#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"

/*/{Protheus.doc} STTZZLIB
================================================================================
 Biblioteca de Funcoes Comuns  -  Controle ISO 9001 (SIGACOM)
================================================================================
 Este fonte concentra TODA a regra de negocio reutilizavel do projeto de
 Controle de Fornecimento (ZZ1) e Ocorrencias (ZZ2).

 Objetivo: ZERO duplicacao de codigo. As rotinas STTZZ1.PRW e STTZZ2.PRW,
 os gatilhos (SX7) e as validacoes do dicionario (SX3) chamam sempre estas
 funcoes, garantindo um unico ponto de manutencao.

 Conteudo:
   Funcoes utilitarias
     U_NomeFornecedor(cFornec, cLoja) ...... Nome do fornecedor via POSICIONE (SA2)
     U_ZZ1NomeFor() / U_ZZ2NomeFor() ....... Wrappers p/ campo "Form. Variavel" do
                                             SX3 (limite de 20 caracteres)
     U_ZZ2TotOk() / U_ZZ2TotNok() .......... Idem, para ZZ2_TOTOK/ZZ2_TOTNOK
     U_NomeProduto(cCodPro) ................. Descricao do produto via POSICIONE (SB1)
     U_PercNaoConforme(nOk, nNok) .......... Percentual de nao conformidade
     U_CertificadoVencendo(dValCer) ........ .T. se o certificado vence em 30 dias
     U_ForaToleranc(cConfor, nOk, nNok) .... .T. se a ocorrencia excede a tolerancia
     U_TolFornec(cConfor) .................. Tolerancia (%) do controle ZZ1
     U_GravarLogTCC(cFuncao, oErro) ........ Log tecnico de erros em arquivo

   Motor CRUD (tratamento de erros centralizado)
     U_ExecCRUD(...) ....................... Envelopa AxInclui/AxAltera/... em
                                             BEGIN SEQUENCE com log e rollback

   POO
     Classe ZFORNISO ....................... Encapsula a analise de conformidade
                                             de um fornecedor (Programacao O.O.)

 @type    library
 @author  TCC - Harbour/ADVPL - Do Zero ao Protheus
 @since   2025
 @version 2.0
/*/

// --------------------------------------------------------------------------
// Constantes de negocio (evitam "numeros magicos" espalhados pelo codigo)
// --------------------------------------------------------------------------
#DEFINE TCC_DIAS_ALERTA   30                      // Janela de alerta do certificado
#DEFINE TCC_TOL_MIN       0                       // Tolerancia minima permitida
#DEFINE TCC_TOL_MAX       100                     // Tolerancia maxima permitida
#DEFINE TCC_LOG_ARQ       "\log_tcc_iso9001.log"  // Arquivo de log tecnico

#IFNDEF CRLF
	#DEFINE CRLF          (Chr(13) + Chr(10))
#ENDIF


/*/{Protheus.doc} ExisteReg
--------------------------------------------------------------------------------
 Substituto generico do ExistCpo() nesse build. ExistCpo() se mostrou
 nao-confiavel para varios alias (SA2, SB1 e ate a propria tabela custom
 ZZ1 dentro de ST2TudoOk) - retorna .F. mesmo com registro existente,
 filial correta e sem bloqueio (hipoteses de aspas na formula, filial
 divergente e flag Bloqueado descartadas uma a uma via diagnostico com
 U_ZZ2DbgSB1 - causa raiz exata dentro do ExistCpo nao identificada).
 Um dbSeek puro, na mesma chave, sempre encontrou o registro corretamente -
 esta funcao formaliza esse caminho comprovado como validacao definitiva.
 Usar SEMPRE no lugar de ExistCpo() neste projeto daqui em diante.

 @param cAlias  Caractere  Alias da tabela
 @param cChave  Caractere  Chave de busca ja montada (ex.: xFilial(...)+codigo)
 @param nOrdem  Numerico   Ordem de indice a usar na busca (default 1)
 @return lOk    Logico     .T. se o registro existe
--------------------------------------------------------------------------------
/*/
USER FUNCTION ExisteReg(cAlias, cChave, nOrdem)
	Local lOk   := .F.
	Local aArea := GetArea()

	Default nOrdem := 1

	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(nOrdem))
	lOk := (cAlias)->(dbSeek(cChave))

	RestArea(aArea)
Return lOk


/*/{Protheus.doc} NomeFornecedor
--------------------------------------------------------------------------------
 Retorna o nome (A2_NOME) do fornecedor a partir do codigo e da loja,
 posicionando na SA2 pela ordem 1 (A2_FILIAL + A2_COD + A2_LOJA).

 @param cFornec  Caractere  Codigo do fornecedor (A2_COD)
 @param cLoja    Caractere  Loja do fornecedor   (A2_LOJA)
 @return cNome   Caractere  Nome do fornecedor, ou "" se nao encontrado
--------------------------------------------------------------------------------
/*/
USER FUNCTION NomeFornecedor(cFornec, cLoja)
	Local cNome := ""
	Local aArea := GetArea()

	Default cFornec := ""
	Default cLoja   := ""

	If !Empty(cFornec)
		// Abertura explicita da SA2 antes do Posicione: nesse ambiente, o
		// acesso implicito a alias fora do escopo corrente (Form. Variavel,
		// Gatilho) nao se mostrou confiavel - mesma causa raiz do "Alias
		// does not exist" ja visto nos gatilhos da ZZ2.
		If Select("SA2") == 0
			dbSelectArea("SA2")
		EndIf
		cNome := Posicione("SA2", 1, xFilial("SA2") + cFornec + cLoja, "A2_NOME")
	EndIf

	RestArea(aArea)
Return cNome


/*/{Protheus.doc} ZZ1NomeFor
--------------------------------------------------------------------------------
 Wrapper de ZERO argumentos de U_NomeFornecedor(), para uso no campo
 "Form. Variavel" (X3_RELACAO) do SX3 do ZZ1_NOMEFO. Esse campo do dicionario
 tem limite de 20 caracteres e nao comporta nem o POSICIONE() completo nem a
 chamada U_NomeFornecedor(ZZ1_FORNEC,ZZ1_LOJAFO) por extenso. Le os campos do
 registro ZZ1 corrente, ja posicionado pelo mBrowse no momento do calculo.

 @return cNome  Caractere  Nome do fornecedor do registro ZZ1 corrente
--------------------------------------------------------------------------------
/*/
USER FUNCTION ZZ1NomeFor()
Return U_NomeFornecedor(ZZ1->ZZ1_FORNEC, ZZ1->ZZ1_LOJAFO)


/*/{Protheus.doc} ZZ2NomeFor
--------------------------------------------------------------------------------
 Wrapper de ZERO argumentos de U_NomeFornecedor(), para uso no campo
 "Form. Variavel" (X3_RELACAO) do SX3 do ZZ2_NOMEFO. Mesma razao do
 ZZ1NomeFor (limite de 20 caracteres no campo do dicionario).

 @return cNome  Caractere  Nome do fornecedor do registro ZZ2 corrente
--------------------------------------------------------------------------------
/*/
USER FUNCTION ZZ2NomeFor()
Return U_NomeFornecedor(ZZ2->ZZ2_FORNEC, ZZ2->ZZ2_LOJAFO)


/*/{Protheus.doc} ZZ2GatNome
--------------------------------------------------------------------------------
 Wrapper de gatilho para preencher o Nome do Fornecedor (ZZ2_NOMEFO) a partir
 do codigo do controle (M->ZZ2_CONFOR). Evita estourar o limite de tamanho do
 campo X7_REGRA do SX7 (limite de caracteres).

 @return cNome  Caractere  Nome do fornecedor buscado na SA2 via ZZ1
--------------------------------------------------------------------------------
/*/
USER FUNCTION ZZ2GatNome()
	Local cNome   := ""
	Local cFornec := ""
	Local cLoja   := ""
	Local aArea   := GetArea()

	If !Empty(M->ZZ2_CONFOR)
		cFornec := Posicione("ZZ1", 1, xFilial("ZZ1") + M->ZZ2_CONFOR, "ZZ1_FORNEC")
		cLoja   := Posicione("ZZ1", 1, xFilial("ZZ1") + M->ZZ2_CONFOR, "ZZ1_LOJAFO")
		If !Empty(cFornec)
			cNome := Posicione("SA2", 1, xFilial("SA2") + cFornec + cLoja, "A2_NOME")
		EndIf
	EndIf

	RestArea(aArea)
Return cNome


/*/{Protheus.doc} ZZ2TotOk
--------------------------------------------------------------------------------
 Wrapper de ZERO argumentos para uso no campo "Form. Variavel" (X3_RELACAO) do
 SX3 do ZZ2_TOTOK. A formula direta (ZZ2_QTDOK*ZZ2_VLRUNI, 20 caracteres) fica
 na borda do limite de 20 caracteres do campo do dicionario; o wrapper evita
 corte por causa de mudancas futuras nos nomes.

 @return nTotal  Numerico  ZZ2_QTDOK * ZZ2_VLRUNI do registro ZZ2 corrente
--------------------------------------------------------------------------------
/*/
USER FUNCTION ZZ2TotOk()
Return ZZ2->ZZ2_QTDOK * ZZ2->ZZ2_VLRUNI


/*/{Protheus.doc} ZZ2TotNok
--------------------------------------------------------------------------------
 Wrapper de ZERO argumentos para uso no campo "Form. Variavel" (X3_RELACAO) do
 SX3 do ZZ2_TOTNOK. A formula direta (ZZ2_QTDNOK*ZZ2_VLRUNI) tem 21
 caracteres, EXCEDE o limite de 20 do campo do dicionario e fica cortada.

 @return nTotal  Numerico  ZZ2_QTDNOK * ZZ2_VLRUNI do registro ZZ2 corrente
--------------------------------------------------------------------------------
/*/
USER FUNCTION ZZ2TotNok()
Return ZZ2->ZZ2_QTDNOK * ZZ2->ZZ2_VLRUNI


/*/{Protheus.doc} NomeProduto
--------------------------------------------------------------------------------
 Retorna a descricao (B1_DESC) do produto informado, posicionando na SB1
 pela ordem 1 (B1_FILIAL + B1_COD).

 @param cCodPro  Caractere  Codigo do produto (B1_COD)
 @return cDesc   Caractere  Descricao do produto, ou "" se nao encontrado
--------------------------------------------------------------------------------
/*/
USER FUNCTION NomeProduto(cCodPro)
	Local cDesc := ""
	Local aArea := GetArea()

	Default cCodPro := ""

	If !Empty(cCodPro)
		cDesc := Posicione("SB1", 1, xFilial("SB1") + cCodPro, "B1_DESC")
	EndIf

	RestArea(aArea)
Return cDesc


/*/{Protheus.doc} PercNaoConforme
--------------------------------------------------------------------------------
 Calcula o percentual de nao conformidade de uma entrega.

 Formula:  %NC = ( nNok / (nOk + nNok) ) * 100

 Protege contra divisao por zero: se nao houver quantidade, retorna 0.

 @param nOk    Numerico  Quantidade conforme
 @param nNok   Numerico  Quantidade nao conforme
 @return nPerc Numerico  Percentual de nao conformidade (0 a 100)
--------------------------------------------------------------------------------
/*/
USER FUNCTION PercNaoConforme(nOk, nNok)
	Local nPerc  := 0
	Local nTotal := 0

	Default nOk  := 0
	Default nNok := 0

	nTotal := nOk + nNok

	If nTotal > 0
		nPerc := (nNok / nTotal) * 100
	EndIf

Return nPerc


/*/{Protheus.doc} CertificadoVencendo
--------------------------------------------------------------------------------
 Indica se o certificado esta na janela de alerta: ainda valido, porem
 vencendo dentro dos proximos TCC_DIAS_ALERTA dias (default 30).

 @param dValCer  Data     Data de validade do certificado (ZZ1_VALCER)
 @return lVence  Logico   .T. se vence em ate 30 dias (e ainda nao venceu)
--------------------------------------------------------------------------------
/*/
USER FUNCTION CertificadoVencendo(dValCer)
	Local lVence := .F.

	Default dValCer := CToD("  /  /  ")

	If !Empty(dValCer)
		lVence := (dValCer >= dDataBase) .And. (dValCer <= dDataBase + TCC_DIAS_ALERTA)
	EndIf

Return lVence


/*/{Protheus.doc} TolFornec
--------------------------------------------------------------------------------
 Retorna a tolerancia (%) cadastrada no controle de fornecimento (ZZ1)
 a partir do codigo de controle informado.

 @param cConfor  Caractere  Codigo do controle (ZZ1_CODIGO / ZZ2_CONFOR)
 @return nTol    Numerico   Tolerancia percentual do certificado
--------------------------------------------------------------------------------
/*/
USER FUNCTION TolFornec(cConfor)
	Local nTol  := 0
	Local aArea := GetArea()

	Default cConfor := ""

	If !Empty(cConfor)
		nTol := Posicione("ZZ1", 1, xFilial("ZZ1") + cConfor, "ZZ1_TOLERA")
	EndIf

	RestArea(aArea)
Return nTol


/*/{Protheus.doc} ForaToleranc
--------------------------------------------------------------------------------
 Regra usada pela LEGENDA da ZZ2: informa se a ocorrencia estourou a
 tolerancia definida no certificado do fornecedor (ZZ1_TOLERA).

 Reaproveita U_PercNaoConforme() e U_TolFornec() (zero duplicacao).

 @param cConfor  Caractere  Codigo do controle ZZ1 (ZZ2_CONFOR)
 @param nOk      Numerico   Qtde conforme     (ZZ2_QTDOK)
 @param nNok     Numerico   Qtde nao conforme (ZZ2_QTDNOK)
 @return lFora   Logico     .T. se %NC > tolerancia (vermelho na legenda)
--------------------------------------------------------------------------------
/*/
USER FUNCTION ForaToleranc(cConfor, nOk, nNok)
	Local lFora  := .F.
	Local nPerc  := 0
	Local nTol   := 0

	Default cConfor := ""
	Default nOk     := 0
	Default nNok    := 0

	nPerc := U_PercNaoConforme(nOk, nNok)
	nTol  := U_TolFornec(cConfor)

	lFora := (nPerc > nTol)

Return lFora


/*/{Protheus.doc} GravarLogTCC
--------------------------------------------------------------------------------
 Grava, em arquivo texto no RootPath do servidor, o log tecnico de um erro
 capturado por BEGIN SEQUENCE / RECOVER USING oErro.

 O log e apenas tecnico; ao usuario final e exibida uma mensagem amigavel
 (ver U_ExecCRUD). Assim separamos "experiencia do usuario" de "diagnostico".

 @param cFuncao  Caractere  Nome/contexto da funcao onde ocorreu o erro
 @param oErro    Objeto     Objeto de erro (classe Error) do RECOVER
 @return NIL
--------------------------------------------------------------------------------
/*/
USER FUNCTION GravarLogTCC(cFuncao, oErro)
	Local nHandle  := 0
	Local cLinha   := ""
	Local cArq     := TCC_LOG_ARQ
	Local cUsuario := ""

	Default cFuncao := "?"

	// Identificacao do usuario logado (compatibilidade entre releases)
	cUsuario := IIF(Type("cUserName") == "C", cUserName, "?")

	// Monta a linha de log
	cLinha += Replicate("-", 78) + CRLF
	cLinha += "[" + DToC(Date()) + " " + Time() + "] Funcao: " + AllTrim(cFuncao) + CRLF
	cLinha += "Usuario: " + AllTrim(cUsuario) + "  |  Filial: " + FWFilial() + CRLF

	If ValType(oErro) == "O"
		cLinha += "Descricao...: " + AllTrim(cValToChar(oErro:Description)) + CRLF
		cLinha += "Operacao....: " + AllTrim(cValToChar(oErro:Operation))   + CRLF
		cLinha += "GenCode.....: " + cValToChar(oErro:GenCode)              + CRLF
		cLinha += "SubCode.....: " + cValToChar(oErro:SubCode)              + CRLF
	Else
		cLinha += "Descricao...: (erro nao instanciado)" + CRLF
	EndIf
	cLinha += CRLF

	// Abre (ou cria) o arquivo e grava no final
	nHandle := FOpen(cArq, FO_READWRITE)
	If nHandle == -1
		nHandle := FCreate(cArq)
	EndIf

	If nHandle >= 0
		FSeek(nHandle, 0, FS_END)
		FWrite(nHandle, cLinha, Len(cLinha))
		FClose(nHandle)
	EndIf

	// Espelha tambem no console do server (util em ambiente de homologacao)
	ConOut("[TCC-ISO9001] " + AllTrim(cFuncao) + " -> " + ;
		IIF(ValType(oErro) == "O", AllTrim(cValToChar(oErro:Description)), "erro"))

Return NIL


/*/{Protheus.doc} FWFilial
--------------------------------------------------------------------------------
 Wrapper de compatibilidade: retorna a filial corrente de forma segura em
 releases antigos (MP8) que nao possuem FWFilial nativa.
--------------------------------------------------------------------------------
/*/
STATIC FUNCTION FWFilial()
	Local cFil := ""
	cFil := IIF(Type("cFilAnt") == "C", cFilAnt, Space(2))
Return cFil


/*/{Protheus.doc} ExecCRUD
--------------------------------------------------------------------------------
 MOTOR CRUD com tratamento de erros CENTRALIZADO.

 Toda operacao de manutencao (incluir/alterar/visualizar/excluir) das rotinas
 STTZZ1 e STTZZ2 passa por aqui. Isso garante que TODA gravacao esteja
 protegida por BEGIN SEQUENCE, com:
    - mensagem amigavel ao usuario;
    - log tecnico via U_GravarLogTCC();
    - rollback da transacao em caso de falha.

 @param cAlias   Caractere  Alias da tabela (ZZ1 / ZZ2)
 @param cTitulo  Caractere  Titulo da janela de manutencao
 @param nOpc     Numerico   Operacao: 2=Visualizar 3=Incluir 4=Alterar 5=Excluir
 @param cTudoOk  Caractere  Expressao/funcao de validacao na confirmacao
 @param cVldExc  Caractere  Expressao/funcao de validacao para exclusao
 @return lOk     Logico     .T. se a operacao foi concluida sem erro
--------------------------------------------------------------------------------
/*/
USER FUNCTION ExecCRUD(cAlias, cTitulo, nOpc, cTudoOk, cVldExc)
	Local aArea  := GetArea()
	Local nReg   := 0
	Local lOk    := .T.
	Local oErro

	Default cTitulo := "Manutencao"
	Default nOpc    := 2
	Default cTudoOk := ".T."
	Default cVldExc := ".T."

	dbSelectArea(cAlias)
	nReg := (cAlias)->(Recno())

	BEGIN SEQUENCE

		Do Case
		Case nOpc == 2                                  // Visualizar
			AxVisual(cAlias, nReg, nOpc)

		Case nOpc == 3                                  // Incluir
			AxInclui(cAlias, nReg, nOpc, , , , cTudoOk)

		Case nOpc == 4                                  // Alterar
			AxAltera(cAlias, nReg, nOpc, , , , cTudoOk)

		Case nOpc == 5                                  // Excluir
			// Validacao de integridade (ex.: ZZ1 com ZZ2 vinculada)
			If &(cVldExc)
				BEGIN TRANSACTION
					AxDeleta(cAlias, nReg, nOpc)
				END TRANSACTION
			Else
				MsgStop("Exclusao nao permitida. Verifique os registros " + ;
					"vinculados a este cadastro.", "Controle ISO 9001")
				lOk := .F.
			EndIf
		EndCase

		RECOVER USING oErro

		// Falhou: registra tecnicamente e avisa o usuario com mensagem clara
		U_GravarLogTCC(cTitulo, oErro)
		MsgStop("Nao foi possivel concluir a operacao." + CRLF + CRLF + ;
			"Detalhe tecnico: " + ;
			IIF(ValType(oErro) == "O", AllTrim(cValToChar(oErro:Description)), "-") + CRLF + CRLF + ;
			"O erro foi registrado no log do sistema.", "Controle ISO 9001")
		lOk := .F.

	END SEQUENCE

	RestArea(aArea)
Return lOk


//=============================================================================
//  PROGRAMACAO ORIENTADA A OBJETOS (POO)
//=============================================================================
/*/{Protheus.doc} ZFORNISO (Classe)
--------------------------------------------------------------------------------
 Classe que encapsula a analise de conformidade ISO 9001 de UM fornecedor.

 Demonstra os pilares de POO em ADVPL:
   - Encapsulamento : os totais e a regra de status ficam dentro do objeto;
   - Reuso          : os metodos chamam a mesma biblioteca (U_PercNaoConforme);
   - Coesao         : quem consome so pergunta "esta fora da tolerancia?".

 Uso tipico (ex.: em um relatorio de resumo por fornecedor):
     oForn := ZFORNISO():New("000001", "000005", "01", 5.00)
     oForn:AddOcorrencia(ZZ2_QTDOK, ZZ2_QTDNOK)
     If oForn:ForaTolerancia()
         // fornecedor reprovado
     EndIf

 @author  TCC - Harbour/ADVPL
 @since   2025
--------------------------------------------------------------------------------
/*/
	CLASS ZFORNISO

		DATA cCodigo   AS CHARACTER   // Codigo do controle (ZZ1_CODIGO)
		DATA cFornec   AS CHARACTER   // Codigo do fornecedor
		DATA cLoja     AS CHARACTER   // Loja do fornecedor
		DATA nTolera   AS NUMERIC     // Tolerancia (%) do certificado
		DATA nTotOk    AS NUMERIC     // Acumulado de qtde conforme
		DATA nTotNok   AS NUMERIC     // Acumulado de qtde nao conforme

		METHOD New(cCod, cForn, cLj, nTol) CONSTRUCTOR
		METHOD AddOcorrencia(nOk, nNok)          // Acumula uma ocorrencia
		METHOD PercNaoConf()                     // % de nao conformidade acumulado
		METHOD ForaTolerancia()                  // .T. se excedeu a tolerancia
		METHOD Status()                          // "APROVADO" / "REPROVADO"
		METHOD Resumo()                          // String descritiva para relatorio

	ENDCLASS


/*/{Protheus.doc} ZFORNISO:New
 Construtor. Inicializa o objeto com os dados do controle/fornecedor.
/*/
METHOD New(cCod, cForn, cLj, nTol) CLASS ZFORNISO
	Default cCod  := ""
	Default cForn := ""
	Default cLj   := ""
	Default nTol  := 0

	::cCodigo := cCod
	::cFornec := cForn
	::cLoja   := cLj
	::nTolera := nTol
	::nTotOk  := 0
	::nTotNok := 0
Return Self


/*/{Protheus.doc} ZFORNISO:AddOcorrencia
 Acumula as quantidades de uma ocorrencia (linha da ZZ2) ao objeto.
/*/
METHOD AddOcorrencia(nOk, nNok) CLASS ZFORNISO
	Default nOk  := 0
	Default nNok := 0
	::nTotOk  += nOk
	::nTotNok += nNok
Return Self


/*/{Protheus.doc} ZFORNISO:PercNaoConf
 Percentual de nao conformidade ACUMULADO do fornecedor.
 Reaproveita a funcao de biblioteca (unica formula em todo o projeto).
/*/
METHOD PercNaoConf() CLASS ZFORNISO
Return U_PercNaoConforme(::nTotOk, ::nTotNok)


/*/{Protheus.doc} ZFORNISO:ForaTolerancia
 .T. se o percentual acumulado excede a tolerancia do certificado.
/*/
METHOD ForaTolerancia() CLASS ZFORNISO
Return (::PercNaoConf() > ::nTolera)


/*/{Protheus.doc} ZFORNISO:Status
 Traduz a analise em um rotulo de negocio.
/*/
METHOD Status() CLASS ZFORNISO
Return IIF(::ForaTolerancia(), "REPROVADO", "APROVADO")


/*/{Protheus.doc} ZFORNISO:Resumo
 Devolve uma linha pronta para relatorio/console com o diagnostico.
/*/
METHOD Resumo() CLASS ZFORNISO
	Local cRet := ""
	cRet := "Fornecedor " + AllTrim(::cFornec) + "/" + AllTrim(::cLoja) + ;
		" | %NC: " + AllTrim(Str(::PercNaoConf(), 6, 2)) + ;
		" | Tol.: " + AllTrim(Str(::nTolera, 6, 2)) + ;
		" | " + ::Status()
Return cRet
