# Exercício 2 — Completando a tabela ZA1 (o pet ganha um dono)

Agora a `ZA1` deixa de ficar "solta": cada pet passa a pertencer a um cliente da `SA1`.

## Entregas a seguir:
Prints do **SX2**, do **SX3** (com o `ZA1_NOMCLI` marcado como Virtual e o `X3_RELACAO` preenchido) e do **SIX** (as duas ordens).

## SX2 — Tabela
- **Prefixo/Alias:** `ZA1`
- **Nome:** "Tabela de Pets"
- **Modo:** Compartilhado


<img src= "imagens\SX2_TABELA.png" width="900">

## SX3 — Campos

| Campo        | Tipo          | Tam. | Contexto | Descrição / observação                                   |
|--------------|---------------|------|----------|----------------------------------------------------------|
| ZA1_FILIAL   | Caractere (C) | 2    | Real     | Filial (obrigatório)                                     |
| ZA1_COD      | Caractere (C) | 6    | Real     | Código do pet (chave)                                    |
| ZA1_NOME     | Caractere (C) | 40   | Real     | Nome do pet                                              |
| ZA1_RACA     | Caractere (C) | 30   | Real     | Raça                                                     |
| ZA1_NASC     | Data (D)      | 8    | Real     | Data de nascimento                                       |
| ZA1_CLIENT   | Caractere (C) | 6    | Real     | Código do cliente (SA1 → A1_COD)                         |
| ZA1_LOJA     | Caractere (C) | 2    | Real     | Loja do cliente (SA1 → A1_LOJA)                          |
| ZA1_NOMCLI   | Caractere (C) | 40   | **Virtual** | Nome do cliente (trazido da SA1)                      |
| ZA1_OBS      | Caractere (C) | 60   | Real     | Campo para Observações                     |


<img src= "imagens\SX3_CAMPOS.png" width="1100">

### Campo Virtual ZA1_NOMCLI
No `X3_RELACAO` do `ZA1_NOMCLI`:

```advpl
POSICIONE("SA1", 1, xFilial("SA1") + M->ZA1_CLIENT + M->ZA1_LOJA, "A1_NOME")
```

- `POSICIONE(alias, ordem, chave, campo)` procura na SA1, pela ordem 1, a chave `filial + código + loja` e devolve `A1_NOME`.
- Uso `M->ZA1_CLIENT`/`M->ZA1_LOJA` (memória) porque o campo é calculado com o que está sendo digitado na tela.
- Por ser **Virtual**, o nome nunca fica desatualizado: se o cliente mudar de nome na SA1, o pet passa a mostrar o novo nome automaticamente.

<img src= "imagens\VIRTUAL_ZA1_NOMCLI.png" width="1100">


## SIX — Índices
- **Ordem 1:** `ZA1_FILIAL + ZA1_COD` → busca/edição pelo código do pet.
- **Ordem 2:** `ZA1_FILIAL + ZA1_CLIENT + ZA1_LOJA` → listar/filtrar os pets **por dono** (todos os pets de um cliente).

Os dois índices começam pela filial, como manda a regra do Protheus.

<img src= "imagens\SIX_INDICES.png" width="1100">
