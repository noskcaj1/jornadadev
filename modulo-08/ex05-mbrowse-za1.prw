#include "protheus.ch"   // Definicoes padrao do Protheus


// ============================================================
// STTIP002 - Cadastro de Pets (tabela ZA1) usando mBrowse.
// Faz o mesmo que o STTIP001 (AxCadastro), mas montado "na mao":
// aqui voce define os botoes e desenha o browse voce mesmo.
// ============================================================
USER FUNCTION STTIP002()

    // cCadastro: titulo da tela. aRotina: lista de botoes/opcoes.
    // Ambos Private porque o mBrowse le essas variaveis do ambiente.
    Private cCadastro := "Cadastro de Pets"
    Private aRotina   := {}

    // Monta os botoes do browse. Cada item = {Titulo, Funcao, 0, NumeroDaOpcao}
    // As funcoes Ax... sao as rotinas padrao do Protheus.
    AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
    AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
    AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
    AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
    AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})

    dbSelectArea("ZA1")   // Seleciona a tabela de Pets como area ativa
    dbSetOrder(1)         // Usa o indice 1 da ZA1 (ordena por essa chave)

    // mBrowse: desenha o browse na tela.
    // (6,1,22,75) = coordenadas da janela; "ZA1" = tabela exibida.
    mBrowse(6, 1, 22, 75, "ZA1")

Return NIL

// ============================================================
/*O fluxo é parecido com o do STTIP001: seleciona a tabela, define o índice e chama a função que desenha o browse. 
A diferença é que aqui você monta aRotina (a lista de botões) na mão, enquanto no AxCadastro ele já monta sozinho. 
O mBrowse desenha o browse na tela, mas não cria os botões — por isso você precisa definir aRotina antes.*/
