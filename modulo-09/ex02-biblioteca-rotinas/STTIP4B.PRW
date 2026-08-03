#include "protheus.ch"

// ============================================================
// STTIP004B - Listagem GERAL de interacoes (SZ2), sem filtro.
// Versao da STTIP004 que mostra todas as interacoes,
// independente de contato. Chamada direto pelo menu.
// ============================================================
User Function STTIP4B()

    Private cCadastro := "Interacoes (Todas)"
    Private aRotina   := {}

    // Botoes padrao do browse
    AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
    AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
    AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
    AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
    AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})

    DbSelectArea("SZ2")   // Tabela de Interacoes
    DbSetOrder(1)         // Indice 1 (Z2_FILIAL+Z2_CONTAT)
    DbGoTop()             // Primeiro registro

    // mBrowse SEM filtro: mostra todas as interacoes
    mBrowse(6, 1, 22, 75, "SZ2")

Return Nil
