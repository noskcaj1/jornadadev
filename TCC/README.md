# Controle de Fornecimento — Não Conformidades ISO 9001

**TCC — Programa START (TOTVS Paulista) · Harbour/ADVPL — Do Zero ao Protheus**

Autor: **Jackson Silvano Branco de Miranda** (entrega individual)

Módulo: **SIGACOM** (Compras) · Ambiente: Protheus / Harbour

> O enunciado completo está em [`tcc.pdf`](tcc.pdf) e a rubrica de avaliação em
> [`rubrica-validacao.pdf`](rubrica-validacao.pdf). Este README documenta o que foi
> efetivamente construído nesta entrega.

---

## 1. O problema de negócio

A Indústria XYZ precisa monitorar as **não conformidades na entrada de materiais**
dos seus fornecedores para se manter em conformidade com o processo de certificação
**ISO 9001**. O sistema registra:

- os **certificados de qualidade** de cada fornecedor, com validade e tolerância (%)
  de não conformidade aceitável;
- as **ocorrências de não conformidade** em cada entrega, vinculadas ao certificado
  do fornecedor.

As tabelas se apoiam nos cadastros padrão de **Fornecedores (SA2)** e **Produtos (SB1)**.

---

## 2. Estrutura das tabelas

### ZZ1 — Controle de Fornecimento (acesso Compartilhado)

| Campo          | Tipo | Tam | Dec | Contexto          | Observação                               |
| -------------- | ---- | --- | --- | ----------------- | ------------------------------------------ |
| `ZZ1_FILIAL` | C    | 2   | 0   | Real              |                                            |
| `ZZ1_CODIGO` | C    | 6   | 0   | Real              | Chave do controle                          |
| `ZZ1_FORNEC` | C    | 6   | 0   | Real              | Fornecedor (SA2)                           |
| `ZZ1_LOJAFO` | C    | 2   | 0   | Real              | Loja do fornecedor                         |
| `ZZ1_NOMEFO` | C    | 40  | 0   | **Virtual** | Nome do fornecedor via`Posicione` na SA2 |
| `ZZ1_CERTIF` | C    | 256 | 0   | Real              | Dados do certificado de qualidade          |
| `ZZ1_VALCER` | D    | 8   | 0   | Real              | Validade do certificado                    |
| `ZZ1_TOLERA` | N    | 5   | 2   | Real              | Tolerância (%) de não conformidade       |
| `ZZ1_TOTOK`  | N    | 12  | 2   | Real              | Qtde. total conforme (acumulado)           |
| `ZZ1_TOTNOK` | N    | 12  | 2   | Real              | Qtde. total não conforme (acumulado)      |

Índices: `1` filial+código (chave primária) · `2` filial+fornecedor+loja ·
`3` filial+validade do certificado.

### ZZ2 — Ocorrências do Fornecedor (acesso Compartilhado)

| Campo          | Tipo | Tam | Dec | Contexto          | Observação                               |
| -------------- | ---- | --- | --- | ----------------- | ------------------------------------------ |
| `ZZ2_FILIAL` | C    | 2   | 0   | Real              |                                            |
| `ZZ2_CONFOR` | C    | 6   | 0   | Real              | Controle (→ ZZ1)                          |
| `ZZ2_FORNEC` | C    | 6   | 0   | Real              | Fornecedor (via gatilho, a partir da ZZ1)  |
| `ZZ2_LOJAFO` | C    | 2   | 0   | Real              | Loja do fornecedor (via gatilho)           |
| `ZZ2_NOMEFO` | C    | 40  | 0   | **Virtual** | Nome do fornecedor via`Posicione`        |
| `ZZ2_DATA`   | D    | 8   | 0   | Real              | Data da ocorrência (gatilho na inclusão) |
| `ZZ2_HORA`   | C    | 5   | 0   | Real              | Hora da ocorrência (gatilho na inclusão) |
| `ZZ2_CODPRO` | C    | 15  | 0   | Real              | Produto (SB1)                              |
| `ZZ2_QTDOK`  | N    | 12  | 0   | Real              | Qtde. conforme                             |
| `ZZ2_QTDNOK` | N    | 12  | 0   | Real              | Qtde. não conforme                        |
| `ZZ2_VLRUNI` | N    | 12  | 2   | Real              | Valor unitário                            |
| `ZZ2_TOTOK`  | N    | 12  | 2   | **Virtual** | `ZZ2_QTDOK * ZZ2_VLRUNI`                 |
| `ZZ2_TOTNOK` | N    | 12  | 2   | **Virtual** | `ZZ2_QTDNOK * ZZ2_VLRUNI`                |

Índices: `1` filial+controle+data+hora (chave primária) · `2` filial+fornecedor+loja+data ·
`3` filial+data.

> Os campos numéricos (`ZZ2_VLRUNI`, `ZZ2_QTDOK`, `ZZ2_QTDNOK`, `ZZ2_TOTOK`, `ZZ2_TOTNOK`)
> têm o **Formato** (`X3_PICTURE`) configurado — sem isso o campo aceita só 1 dígito na
> tela mesmo com o tamanho correto no dicionário.

O dicionário completo (SX2/SX3/SIX/SX7/SXB) está em [`Dados-e-Dicionario/`](Dados-e-Dicionario/),
nos dois formatos: `.dbf` (importação real no Protheus) e `.csv` (espelho legível, gerado
por [`converte-dicionario.prg`](Dados-e-Dicionario/converte-dicionario.prg)).

---

## 3. Gatilhos (SX7)

| Tabela | Campo origem   | Campo destino  | Regra                                                            |
| ------ | -------------- | -------------- | ---------------------------------------------------------------- |
| ZZ1    | `ZZ1_FORNEC` | `ZZ1_NOMEFO` | `Posicione` na SA2                                             |
| ZZ2    | `ZZ2_CONFOR` | `ZZ2_FORNEC` | `Posicione` na ZZ1                                             |
| ZZ2    | `ZZ2_CONFOR` | `ZZ2_LOJAFO` | `Posicione` na ZZ1                                             |
| ZZ2    | `ZZ2_CONFOR` | `ZZ2_NOMEFO` | `U_ZZ2GatNome()` (wrapper que busca fornecedor via ZZ1 → SA2) |
| ZZ2    | `ZZ2_DATA`   | `ZZ2_DATA`   | `IF(INCLUI, dDataBase, ZZ2->ZZ2_DATA)`                         |
| ZZ2    | `ZZ2_HORA`   | `ZZ2_HORA`   | `IF(INCLUI, Time(), ZZ2->ZZ2_HORA)`                            |

---

## 4. Validações obrigatórias

Implementadas em **duas camadas** (defesa em profundidade):

1. **Dicionário (SX3, `X3_VALID`)** — validação campo a campo na digitação.
2. **Código (`U_ST1TudoOk` / `U_ST2TudoOk` em `fontes/STTZZ1.PRW` e `STTZZ2.PRW`)** —
   revalida tudo na confirmação da tela, usando `U_ExisteReg()` (função própria em
   `STTZZLIB.PRW` — ver observação abaixo) em vez de `ExistCpo()`.

| Campo                      | Regra                                        |
| -------------------------- | -------------------------------------------- |
| `ZZ1_FORNEC`             | Deve existir na SA2 (fornecedor + loja)      |
| `ZZ1_VALCER`             | Não pode ser retroativa na inclusão        |
| `ZZ1_TOLERA`             | Entre 0 e 100                                |
| `ZZ2_CONFOR`             | Deve existir na ZZ1                          |
| `ZZ2_CODPRO`             | Deve existir na SB1                          |
| `ZZ2_DATA`               | Não pode ser futura                         |
| `ZZ2_QTDOK + ZZ2_QTDNOK` | Deve haver ao menos uma quantidade informada |

> **Nota técnica:** durante os testes, `ExistCpo()` se mostrou não confiável neste
> build para SA2/SB1/ZZ1 (retornava `.F.` mesmo com o registro existente e sem
> bloqueio). A função `U_ExisteReg()` (um `dbSeek` direto) foi criada em
> `STTZZLIB.PRW` como substituto confiável e é usada em todo o projeto — inclusive
> no `X3_VALID` de `ZZ2_CONFOR` no dicionário, para manter a mesma regra nas duas
> camadas de validação.

---

## 5. Rotinas (`fontes/`)

### `STTZZ1.PRW` — `USER FUNCTION STTZZ1()`

mBrowse da ZZ1 com:

- Legenda por situação do certificado (vermelho: vencido · amarelo: vence em até 30
  dias · verde: ok);
- Botão **"Ocorrências"** que abre a ZZ2 filtrada pelo controle selecionado
  (`U_STTZZ2FLT`);
- CRUD roteado por `U_ExecCRUD` (ver item 6), com bloqueio de exclusão se houver
  ZZ2 vinculada (**diferencial**: integridade referencial).

### `STTZZ2.PRW` — `USER FUNCTION STTZZ2()` / `USER FUNCTION STTZZ2FLT(cCodigoZZ1)`

mBrowse da ZZ2, com versão completa e versão filtrada (mesmo núcleo `ST2Browse`,
zero duplicação de código). Legenda compara o **% de não conformidade da ocorrência**
com a **tolerância do certificado (`ZZ1_TOLERA`)** — vermelho se estourou, verde se
dentro da tolerância (**diferencial**).

### `STTZZLIB.PRW` — biblioteca de funções comuns

Concentra toda a regra de negócio reutilizável:

| Função                                | Uso                                                                                                                                                                             |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `U_NomeFornecedor(cFornec, cLoja)`    | Nome do fornecedor via`Posicione` (SA2)                                                                                                                                       |
| `U_NomeProduto(cCodPro)`              | Descrição do produto via`Posicione` (SB1)                                                                                                                                   |
| `U_PercNaoConforme(nOk, nNok)`        | Percentual de não conformidade                                                                                                                                                 |
| `U_CertificadoVencendo(dValCer)`      | `.T.` se o certificado vence em até 30 dias                                                                                                                                  |
| `U_ForaToleranc(cConfor, nOk, nNok)`  | `.T.` se a ocorrência excede a tolerância do certificado                                                                                                                    |
| `U_ExisteReg(cAlias, cChave, nOrdem)` | Substituto confiável de`ExistCpo()`                                                                                                                                          |
| `U_GravarLogTCC(cFuncao, oErro)`      | Log técnico de erros em arquivo                                                                                                                                                |
| `U_ExecCRUD(...)`                     | Motor CRUD único — envolve`AxInclui/AxAltera/AxVisual/AxDeleta` em `BEGIN SEQUENCE`, com mensagem amigável, log e rollback                                               |
| Classe`ZFORNISO`                      | **Diferencial (POO)** — encapsula a análise de conformidade acumulada de um fornecedor (`AddOcorrencia`, `PercNaoConf`, `ForaTolerancia`, `Status`, `Resumo`) |

---

## 6. Tratamento de erros

Toda operação de gravação (incluir/alterar/excluir) passa por `U_ExecCRUD()`, que
envolve a operação em `BEGIN SEQUENCE / RECOVER USING oErro`:

- mensagem amigável ao usuário na tela;
- log técnico completo (`U_GravarLogTCC`) — grava em arquivo (`log_tcc_iso9001.log`
  no `RootPath` do servidor) e também no console (`ConOut`);
- exclusão da ZZ1 usa `BEGIN TRANSACTION` adicional, com validação de integridade
  (bloqueia se existir ZZ2 vinculada) antes de efetivar.

---

## 7. Menu (SIGACOM)

Adicionado em `Cadastros → Controle ISO 9001`, dentro do menu padrão de Compras
([`Dados-e-Dicionario/sigacom.xnu`](Dados-e-Dicionario/sigacom.xnu)):

```
Cadastros
 └── Controle Iso 9001
      ├── Controle de Fornecimento      → U_STTZZ1
      └── Ocorrências de Fornecedor     → U_STTZZ2
```

---

## 8. Como instalar / importar o dicionário

1. No Configurador (SIGACFG), importe o dicionário a partir dos arquivos `.dbf` em
   [`Dados-e-Dicionario/`](Dados-e-Dicionario/) (`sx2990`, `sx3990`, `six990`,
   `sx7990`, `sxb990`) — cria as tabelas customizadas `ZZ1` e `ZZ2` e os respectivos
   gatilhos/consultas.
2. Importe também `sigacom.xnu` (menu do módulo Compras) para habilitar as duas
   novas opções em **Cadastros → Controle Iso 9001**.
3. Compile os fontes de [`fontes/`](fontes/) (`STTZZ1.PRW`, `STTZZ2.PRW`,
   `STTZZLIB.PRW`) no ambiente Protheus.
4. Para massa de teste, importe `sa2990.dbf` (fornecedores) e `sb1990.dbf`
   (produtos) na SA2/SB1 do ambiente.
5. Os arquivos `.csv` na mesma pasta são o **espelho em texto** do dicionário
   (gerados pelo utilitário [`converte-dicionario.prg`](Dados-e-Dicionario/converte-dicionario.prg),
   `hbmk2 converte-dicionario.prg` + executar) — servem para a validação
   automática ler a estrutura sem precisar abrir o `.dbf` binário; não são
   importados no Protheus.

---

## 9. Evidências

Em [`evidencias/`](evidencias/) há um **vídeo de demonstração** do sistema rodando
no ambiente Protheus (`vídeo - Controle de Não Conformidades ISO.mp4`), mostrando:

- o browse da ZZ1 com a legenda de vencimento do certificado;
- inclusão/alteração de um controle de fornecimento, com as validações campo a
  campo e de tela (`TudoOk`) em ação;
- o botão "Ocorrências" abrindo a ZZ2 já filtrada pelo controle selecionado;
- inclusão de uma ocorrência na ZZ2 e a legenda comparando o % de não
  conformidade com a tolerância do certificado;
- a proteção de exclusão da ZZ1 quando existem ZZ2 vinculadas.

---

## 10. Diferenciais implementados

- [X] Cabeçalho de documentação e comentários em todos os fontes;
- [X] Zero duplicação de código — toda regra reutilizável está em `STTZZLIB.PRW`;
- [X] Legenda da ZZ2 comparando o % de não conformidade com `ZZ1_TOLERA`;
- [X] Classe ADVPL (POO) — `ZFORNISO`, em `STTZZLIB.PRW`;
- [X] Impede excluir uma ZZ1 que tenha ZZ2 vinculada.

---

## 11. Estrutura do repositório

```
TCC/
├── README.md                    ← este arquivo
├── AUTOAVALIACAO.md              ← checklist de entrega
├── tcc.pdf, rubrica-validacao.pdf, README.pdf   ← enunciado e critérios (fornecidos pelo curso)
├── Dados-e-Dicionario/
│   ├── sx2990.dbf/.csv           ← tabelas (dicionário)
│   ├── sx3990.dbf/.csv           ← campos
│   ├── six990.dbf/.csv           ← índices
│   ├── sx7990.dbf/.csv           ← gatilhos
│   ├── sxb990.dbf/.csv           ← consultas F3
│   ├── zz1990.dbf/.csv           ← tabela ZZ1
│   ├── zz2990.dbf/.csv           ← tabela ZZ2
│   ├── sa2990.dbf                ← fornecedores de teste
│   ├── sb1990.dbf                ← produtos de teste
│   ├── sigacom.xnu                ← menu de Compras
│   └── converte-dicionario.prg   ← utilitário de exportação DBF → CSV
├── fontes/
│   ├── STTZZ1.PRW                ← rotina mBrowse da ZZ1
│   ├── STTZZ2.PRW                ← rotina mBrowse da ZZ2
│   └── STTZZLIB.PRW              ← biblioteca de funções comuns
└── evidencias/
    └── vídeo - Controle de Não Conformidades ISO.mp4
```

---

## 12. Participantes

Entrega individual — **Jackson Silvano Branco de Miranda**.
