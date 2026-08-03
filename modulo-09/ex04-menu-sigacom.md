# Exercício 4 — Menu no módulo de Compras (SIGACOM)

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic"> - Objetivo: </span> colocar as telas de Contatos e Interações no menu do módulo de Compras (SIGACOM), pra serem acessadas como rotinas normais do sistema.

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic"> - Estrutura de menu criada:</span> uma pasta Cadastros com duas opções — Contatos (abre a STTIP003) e Interações (todas) (abre a listagem geral de interações).

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic"> - Rotina nova criada (STTIP004B / listagem geral):</span> cópia da STTIP004 sem o filtro e sem a exigência de contato selecionado, porque uma tela chamada direto pelo menu não tem um contato pré-selecionado pra filtrar.

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic"> - Diferença entre as duas versões de interações:</span> a STTIP004 é contextual (mostra as interações de um contato, chamada pelo botão) e a versão geral mostra todas as interações (chamada pelo menu).

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic"> - Cadastro no Configurador (SIGACFG):</span> na parte de Menu do Sistema, montou a pasta e amarrou cada opção ao nome da função correspondente.

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic"> - Problema resolvido no caminho:</span> o erro de "função duplicada" não era do código, e sim uma sobra de compilação antiga presa no RPO — corrigido recompilando/limpando o objeto (ou renomeando a função).

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic"> - Aprendizado central:</span> uma rotina só passa a fazer parte do sistema quando registrada no menu, e o ponto de acesso muda como a rotina é escrita — tela por botão pode contar com contexto pronto; tela por menu tem que funcionar sozinha.

## Teste realizado

Os dois itens aparecem em **Compras → Cadastros** e abrem sem erro:
- "Contatos" abre a `STTIP003` (com o botão Interações).
- "Interações (todas)" abre a `STTIP004B`, mostrando todas as interações, sem filtro.

> Diferença chave: `STTIP004` (filtrada, via botão) mostra só as interações do contato posicionado; `STTIP004B` (menu) mostra a base inteira.


