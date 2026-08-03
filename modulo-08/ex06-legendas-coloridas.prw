#include "protheus.ch"   // Definicoes padrao do Protheus


// ============================================================
// STTIP002 - Cadastro de Pets (ZA1) com legenda de cores.
// Evolucao da versao anterior: agora o browse pinta cada linha
// conforme a idade do pet, calculada a partir da data de
// nascimento (ZA1_NASC).
// ============================================================
User Function STTIP002()

    Local cFiltro := ""   // Declarada para uso futuro (filtro); nao usada ainda aqui

    // aColors: define a cor de cada linha do browse.
    // O Protheus avalia as expressoes de cima pra baixo e usa
    // a cor da PRIMEIRA que der .T. (verdadeira).
    // dDataBase = data-base do sistema (a data "de hoje" do Protheus).
    Local aColors := {;
        {"ZA1_NASC < dDataBase - 3650", "BR_VERMELHO"},;  // Nasc. ha mais de 3650 dias (~10 anos) -> pet idoso -> vermelho
        {"ZA1_NASC == dDataBase"      , "BR_AMARELO"} ,;  // Nasceu exatamente hoje -> amarelo
        {".T."                        , "BR_VERDE"}   ;   // Qualquer outro caso -> verde
    }

    // cCadastro: titulo da tela. aRotina: botoes do browse.
    // Ambos Private porque o mBrowse os le do ambiente.
    Private cCadastro := "Cadastro de Pets"
    Private aRotina   := {}

    // Botoes padrao do browse
    AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
    AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
    AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
    AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
    AAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})

    DbSelectArea("ZA1")   // Seleciona a tabela de Pets
    DbSetOrder(1)         // Indice 1 (ordena por essa chave)
    DbGoTop()             // Posiciona no primeiro registro

    // mBrowse: desenha o browse ja com as cores (aColors na posicao das cores).
    mBrowse(1, 1, 22, 75, "ZA1", , , , , , aColors)

Return Nil

// ============================================================
/*O fluxo é o mesmo do STTIP002 anterior, mas agora com aColors, que define a cor de cada linha do browse. 
O Protheus avalia as expressões na ordem que você colocou e aplica a cor da primeira que for verdadeira. 
Assim, pets idosos ficam vermelhos, pets nascidos hoje ficam amarelos, e todos os outros ficam verdes. 
O mBrowse recebe aColors como parâmetro e pinta as linhas conforme essas regras.*/
