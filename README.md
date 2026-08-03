# Jornada Dev - TOTVS Paulista

Este repositório reúne minha caminhada pela **Jornada Dev da TOTVS**, um programa de formação que parte do zero absoluto em lógica de programação e vai até o desenvolvimento de rotinas dentro do ecossistema **Protheus**, usando a linguagem **AdvPL**.

Cada pasta `modulo-XX` representa uma etapa da trilha, com os exercícios e desafios propostos ao longo do curso — do primeiro "Olá, mundo!" até gatilhos, telas de cadastro e tratamento de erros em transações no ERP. A ideia aqui é registrar a evolução: não só o código final, mas o raciocínio por trás de cada exercício.

## 🧭 Trilha percorrida

### Módulo 01 — Primeiros passos em AdvPL
O pontapé inicial: configurar o ambiente e escrever os primeiros programas. Exercícios de "Hello World", saudação personalizada, apresentação pessoal e exibição de data/hora — o básico para perder o medo da sintaxe e ver o primeiro código rodando de verdade.

### Módulo 02 — Lógica, algoritmos e fluxogramas
Antes de codar, pensar. Este módulo trabalha o raciocínio lógico puro: validar se um "algoritmo" em texto livre realmente é válido, escrever pseudocódigo (área de retângulo, par ou ímpar, maior de três números), desenhar fluxogramas de desconto e praticar refinamento sucessivo (quebrar um problema grande em passos cada vez mais detalhados).

### Módulo 03 — Variáveis, tipos e operadores
Aqui a lógica vira código de verdade. Declarações de variáveis, fórmulas matemáticas, um cálculo de desconto para idosos, comparações de igualdade e o cálculo de média ponderada — a base de qualquer programa em AdvPL.

### Módulo 04 — Estruturas condicionais
Ensinando o programa a tomar decisões: comparar maior e menor valor, calcular reajuste salarial, montar uma calculadora simples, converter número do mês para nome por extenso e simular regras de um plano de saúde com múltiplas condições.

### Módulo 05 — Estruturas de repetição
Hora de fazer o código trabalhar por você. Sequências com `FOR`, dobro de um valor com `WHILE`, uma "máquina de soma", validação de dados de aluno em loop, um programa com repetição controlada por menu e o clássico jogo de adivinhar o número.

### Módulo 06 — Funções e modularização
O salto para um código mais organizado e reutilizável. Discussão sobre função x procedimento, um relógio modularizado, refatoração da calculadora em funções, uma pequena biblioteca matemática (fatorial, número primo, MDC, MMC), o jogo de Jokenpô modular, cálculo de dias da semana, estatísticas de uma lista de números, sistema de notas, carrinho de compras, o algoritmo Bubble Sort e, como desafio maior, um controle de estoque dividido em múltiplos arquivos (`principal.prg` + biblioteca própria).

### Módulo 07 — Dicionário de dados do Protheus
Primeira imersão no ERP: como o Protheus organiza suas tabelas. Conceitos fundamentais do dicionário de dados, a estrutura de uma tabela customizada `ZA1` (cadastro de Pets, usado como fio condutor dos desafios), recriação prática dessa tabela no Configurador (`SIGACFG`), criação de campo customizado na tabela padrão `SA1` (Clientes) e o entendimento de filial e da função `xFilial()`.

### Módulo 08 — Telas, cadastros e regras de negócio
Colocando a tabela `ZA1` para funcionar na tela. Comparação entre `AxCadastro` e `mBrowse` (quando usar CRUD pronto e quando customizar), finalização da estrutura da `ZA1` (com campo virtual de nome do cliente), tela de cadastro via `AxCadastro`, validação de existência de código (`ExistCpo`), browse customizado (`mBrowse`) com legendas coloridas, um gatilho que busca e preenche endereço a partir do CEP (com direito a um pequeno proxy em Python) e um filtro por mês na listagem.

### Módulo 09 — Dicionário avançado, gatilhos e tratamento de erros
O módulo mais desafiador da trilha até aqui. Modelagem completa de duas tabelas relacionadas (`SZ1` - Contatos e `SZ2` - Interações), com campos, índices e domínios no dicionário de dados; uma biblioteca de rotinas reaproveitáveis; campos virtuais, gatilhos automáticos (`SX7`) e validação cruzada entre tabelas; criação de um menu dentro do módulo de Compras (`SIGACOM`); tratamento de erros com `BEGIN SEQUENCE`/`RECOVER` e `ErrorBlock`; gravação seguindo o padrão "à prova de falhas" com `BeginTran`/`CommitTran`/`RollBackTran`; e, como desafio final, um executor seguro genérico e uma validação de integridade referencial (impedir excluir um Contato que tenha Interações vinculadas).

## 📈 Panorama geral

| Módulo | Foco principal |
|---|---|
| 01 | Primeiros programas em AdvPL |
| 02 | Lógica de programação e fluxogramas |
| 03 | Variáveis, tipos e operadores |
| 04 | Estruturas condicionais |
| 05 | Estruturas de repetição |
| 06 | Funções, modularização e algoritmos |
| 07 | Dicionário de dados do Protheus |
| 08 | Telas, cadastros e regras de negócio |
| 09 | Gatilhos, validações e tratamento de erros |

Do "Olá, mundo!" a rotinas com transação e integridade referencial no Protheus — cada módulo empilha um pouco mais de complexidade em cima do anterior, e essa pasta é o registro dessa evolução. 🚀
