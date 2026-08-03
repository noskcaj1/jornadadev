# Exercício 2 — Estrutura da tabela ZA1 (Pets)

## a. Campos da ZA1

| Campo        | Tipo          | Tamanho | Descrição                                       |
|--------------|---------------|---------|-------------------------------------------------|
| ZA1_FILIAL   | Caractere (C) | 2       | Filial — obrigatório em toda tabela do Protheus |
| ZA1_COD      | Caractere (C) | 6       | Código do pet (chave) — *recomendado*           |
| ZA1_NOME     | Caractere (C) | 40      | Nome do pet                                     |
| ZA1_RACA     | Caractere (C) | 30      | Raça                                            |
| ZA1_NASC     | Data (D)      | 8       | Data de nascimento                              |

> Observações:
> - O campo de filial acompanha a configuração de filiais da empresa; o padrão clássico é tamanho **2**.
> - Em aula os campos foram **nome, raça, nascimento e filial**. O `ZA1_COD` é uma adição recomendada para servir de chave do índice (fica mais robusto do que indexar pelo nome).

## b. Que índice faria sentido? (analogia da lista telefônica)

Sem índice, o sistema lê a tabela inteira, registro por registro — como folhear a lista telefônica página a página. Com índice, ele vai direto ao registro, como quando a lista está ordenada por nome.

**Índice de ordem 1: `ZA1_FILIAL + ZA1_COD`** (ou `ZA1_FILIAL + ZA1_NOME`, se a busca for pelo nome do pet).

O índice **sempre começa pelo campo de filial**, porque no Protheus as buscas acontecem dentro de uma filial — não faz sentido procurar "o pet X" sem antes saber de qual filial ele é.

## c. Por que o prefixo da tabela é Z

A TOTVS reserva os prefixos **Z** (e Y) para **customizações do cliente**. As tabelas padrão do ERP usam outros prefixos (SA1, SB1, SC5...). Usando Z, você garante que:
- sua tabela não colide com nenhuma tabela padrão;
- ela **não será sobrescrita** numa atualização/upgrade do ERP.

Ou seja, `ZA1` grita "isso aqui é meu, não é da TOTVS".

## d. Por que os campos começam com ZA1_ (e não só o nome solto)

No Protheus, **todo campo carrega o prefixo da sua tabela**. O framework e o dicionário se apoiam nesse prefixo para saber a que tabela o campo pertence: `A1_NOME` é da SA1, `ZA1_NOME` é da ZA1.

Isso:
- evita ambiguidade (dois campos `NOME` em tabelas diferentes seriam indistinguíveis);
- permite que o sistema monte telas, relatórios e filtros automaticamente a partir do dicionário.

Um campo "solto" (só `NOME`) quebraria essa convenção e o framework não saberia mapeá-lo à tabela.
