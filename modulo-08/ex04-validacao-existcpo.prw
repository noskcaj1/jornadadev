#include "protheus.ch"   // Definicoes padrao do Protheus


// ============================================================
// VALCLI001 - Funcao de validacao de campo.
// Confere se o cliente informado no cadastro de Pets (ZA1)
// realmente existe na tabela de Clientes (SA1).
// Usada tipicamente no X3_VALID de um campo da ZA1.
// Retorna .T. (aceita) ou .F. (rejeita a digitacao).
// ============================================================
USER FUNCTION VALCLI001()

    // ExistCpo: verifica se a chave existe na tabela informada.
    // Aqui monta a chave: filial + codigo do cliente + loja,
    // e procura na SA1 pelo indice 1.
    // M->ZA1_CLIENT e M->ZA1_LOJA sao os valores que o usuario
    // acabou de digitar (variaveis de memoria do formulario).
    // O "!" na frente inverte: entra no IF quando NAO existe.
    IF !ExistCpo("SA1", xFilial("SA1") + M->ZA1_CLIENT + M->ZA1_LOJA, 1)

        // Cliente nao encontrado na SA1 -> avisa o usuario...
        MsgAlert("Cliente não cadastrado na SA1!", "Atenção")

        RETURN .F.   // ...e rejeita o valor digitado (campo nao e aceito)

    ENDIF

RETURN .T.   // Cliente existe -> validacao aprovada, aceita o valor

// ============================================================
/* O fluxo é direto: a função pega o cliente + loja que o usuário digitou na tela de Pets, monta a chave de busca e pergunta pra SA1 "esse cliente existe?". Se não existir, mostra o aviso e retorna .F., o que faz o Protheus recusar o valor e não deixar o usuário sair do campo. Se existir, retorna .T. e a digitação é aceita.

Alguns pontos que valem entender, ligando com o que você já viu:

É o mesmo ExistCpo do exercício 3 (lá você usou no Z2_CONTAT pra validar contato na SZ1). A diferença é que aqui a validação está numa função separada, em vez de estar direto no X3_VALID. Isso é útil quando a regra é mais complexa ou você quer reaproveitá-la — no X3_VALID do campo você põe só U_VALCLI001().

O M-> são as variáveis de memória do formulário — o que está sendo digitado naquele momento, ainda não gravado. Por isso a validação enxerga o valor "ao vivo".

A chave xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA tem que bater exatamente com o índice 1 da SA1, que é A1_FILIAL+A1_COD+A1_LOJA. Ou seja, o tamanho de ZA1_CLIENT precisa ser igual ao de A1_COD, e ZA1_LOJA igual ao de A1_LOJA — senão a chave não casa e a validação recusa cliente válido (é a mesma armadilha de tamanho de campo que te alertei nos exercícios anteriores).

Um detalhe sobre o ExistCpo: ele já mostra uma mensagem padrão de "não cadastrado" sozinho quando não encontra. Como você adicionou um MsgAlert próprio antes do RETURN .F., pode ser que apareçam duas mensagens (a sua + a do ExistCpo). Se isso acontecer e te incomodar, é só tirar o MsgAlert e deixar o ExistCpo avisar, ou usar dbSeek no lugar dele pra ter controle total da mensagem.*/
