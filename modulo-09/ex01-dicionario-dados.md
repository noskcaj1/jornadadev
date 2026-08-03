# Exercício 1 — Dicionário de dados completo (SZ1 e SZ2)

Projeto de **Contatos (SZ1)** e **Interações (SZ2)**: um contato tem várias interações (1 → N).

## SX2 — Criado Tabelas (modo Compartilhado)

| Tabela | Descrição   | Modo         |
|--------|-------------|--------------|
| SZ1    | Contatos    | Compartilhado |
| SZ2    | Interações  | Compartilhado |

## SX3 — Criado Campos

### SZ1 (Contatos)
| Campo       | Tipo | Tam. | Contexto | Descrição                          |
|-------------|------|------|----------|------------------------------------|
| Z1_FILIAL   | C    | 2    | Real     | Filial                             |
| Z1_CODIGO   | C    | 6    | Real     | Código do contato (chave)          |
| Z1_NOME     | C    | 40   | Real     | Nome do contato                    |
| Z1_CLIENTE  | C    | 6    | Real     | Cliente vinculado (SA1 → A1_COD)   |
| Z1_LOJA     | C    | 2    | Real     | Loja do cliente                    |
| Z1_ASSUNTO  | C    | 40   | Real     | Assunto principal                  |

### SZ2 (Interações)
| Campo       | Tipo | Tam. | Contexto | Descrição                                        |
|-------------|------|------|----------|--------------------------------------------------|
| Z2_FILIAL   | C    | 2    | Real     | Filial                                           |
| Z2_CONTAT   | C    | 6    | Real     | Contato (SZ1 → Z1_CODIGO) — chave                |
| Z2_SEQUEN   | C    | 3    | Real     | Sequência da interação — chave                   |
| Z2_TIPO     | C    | 1    | Real     | Tipo (domínio Z2 no SX5: E/L/R/V/W)              |
| Z2_DATA     | D    | 8    | Real     | Data (preenchida por gatilho)                    |
| Z2_HORA     | C    | 5    | Real     | Hora (preenchida por gatilho)                    |
| Z2_USUAR    | C    | 20   | Real     | Usuário (preenchido por gatilho)                 |
| Z2_DESCRI   | C    | 60   | Real     | Descrição da interação                           |
| Z2_CODIGO   | C    | 6    | **Virtual** | Cliente do contato (via POSICIONE na SZ1)     |
| Z2_ASSUNT   | C    | 40   | **Virtual** | Assunto do contato (via POSICIONE na SZ1)     |

Relações dos virtuais (X3_RELACAO), detalhadas no Ex. 3.

## SIX — Criado Índices
- **SZ1 ordem 1:** `Z1_FILIAL + Z1_CODIGO`
- **SZ2 ordem 1:** `Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN`

A ordem 1 da SZ2 começa pelo contato, o que permite listar todas as interações de um contato juntas (é o que o botão "Interações" e o filtro do Ex. 2 usam).

## SX5 — Criado (VIA APSDU) Códigos na Z2 (domínios) e tipos de interação 

| Tabela | Chave | Descrição (sugestão) |
|--------|-------|----------------------|
| Z2     | E     | E-mail               |
| Z2     | L     | Ligação              |
| Z2     | R     | Reunião              |
| Z2     | V     | Visita               |
| Z2     | W     | WhatsApp             |

## Prints do Configurador anexos na pasta imagens: **SX2**, **SX3**, **SIX** e **SX5** (domínio Z2).

## SZ1 - SX2, SX3, SIX

<img src= "imagens\SZ1_SX2_SX3_SIX.png" width="900">

## SZ2 - SX2, SX3, SIX E SX5

<img src= "imagens\SZ2_SX2_SX3_SIX_SX5.png" width="900">
