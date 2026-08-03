#include "protheus.ch"   // Definicoes padrao do Protheus


// ============================================================
// STTIP001 - Cadastro simples de Pets (tabela ZA1).
// Usa AxCadastro, o cadastro mais basico do Protheus:
// monta sozinho o browse + as opcoes (pesquisar, incluir,
// visualizar, alterar, excluir), sem precisar montar aRotina.
// ============================================================
USER FUNCTION STTIP001()

    // cCadastro: titulo que aparece no topo da tela.
    // Private porque o AxCadastro le essa variavel do ambiente.
    PRIVATE cCadastro := "Pets"

    dbSelectArea("ZA1")   // Seleciona a tabela de Pets como area ativa
    dbSetOrder(1)         // Usa o indice 1 da ZA1 (ordena os registros por essa chave)

    // AxCadastro: cadastro padrao "pronto".
    // Parametros: ("ALIAS", "Titulo").
    // Ele ja desenha o browse e disponibiliza as operacoes basicas,
    // tudo automatico a partir dos campos da tabela no dicionario (SX3).
    AxCadastro("ZA1", "Pets")

RETURN NIL

// ============================================================
/*O fluxo é o mais simples possível: o programa seleciona a tabela ZA1, define o índice de ordenação e chama o AxCadastro, que faz todo o resto sozinho.

Vale entender a diferença entre esse programa e os anteriores (STTIP003/004), porque é o ponto principal aqui:

O AxCadastro é o cadastro "tudo pronto". Você não monta aRotina, não chama mBrowse — ele já entrega o browse com os botões padrão (pesquisar, visualizar, incluir, alterar, excluir) montados a partir dos campos da tabela no dicionário. É ideal pra um cadastro simples que não precisa de nada customizado.

Já o mBrowse + aRotina (que você usou no STTIP003) é a versão "montada na mão". Dá mais trabalho, mas é o que permite adicionar coisas customizadas — como aquele botão Interacoes, as cores das linhas (aColors), ou filtros. O AxCadastro, por ser automático, não te deixa acrescentar um botão próprio.

Ou seja: AxCadastro quando é um cadastro simples e padrão; mBrowse/aRotina quando você precisa de comportamento sob medida. O STTIP001 é o exemplo do primeiro caso.*/


