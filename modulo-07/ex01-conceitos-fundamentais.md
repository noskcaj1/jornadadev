# Exercício 1 — Conceitos fundamentais

---

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic">a. Qual é a função do AppServer?</span>

<span style="font-size: 1.2em; color:rgb(240, 159, 159); font-weight: bold; font-style: italic">R:</span> O AppServer é o servidor de aplicação do Protheus — o serviço que fica no meio, entre o SmartClient (a tela) e o banco de dados. É ele quem interpreta e executa o código ADVPL/TL++ (lido do RPO), aplica as regras de negócio e gerencia as conexões. Se o AppServer não estiver no ar, o SmartClient não tem com quem "conversar".

---

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic">b. O que é o RPO?</span>

<span style="font-size: 1.2em; color:rgb(240, 159, 159); font-weight: bold; font-style: italic">R:</span> O RPO (Repositório de Objetos / Repositório de Programas Objeto) é o arquivo onde ficam guardados todos os fontes já compilados: funções, rotinas e telas. O AppServer lê o RPO para saber o que executar. Quando você compila um fonte, ele vai parar no RPO — é o "repositório de executáveis" do sistema.

---

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic">c. Para que serve o Configurador (SIGACFG)?</span>

<span style="font-size: 1.2em; color:rgb(240, 159, 159); font-weight: bold; font-style: italic">R:</span> É o módulo de administração/configuração do Protheus. Nele se mexe no dicionário de dados (SX2, SX3, índices), cadastram-se empresas e filiais, usuários e grupos de acesso, parâmetros e menus. É o lugar "de bastidor" onde se prepara o ambiente antes de usar os módulos de negócio.

---

<span style="font-size: 1.2em; color:rgba(164, 252, 255, 0.99); font-style: italic">d. Qual a diferença entre campo Real e campo Virtual no SX3?</span>

<span style="font-size: 1.2em; color:rgb(240, 159, 159); font-weight: bold; font-style: italic">R:</span> O campo **Real** existe fisicamente na tabela — ocupa espaço e grava o dado no disco. O campo **Virtual** não existe na tabela: é calculado em tempo de execução por uma fórmula/expressão definida no dicionário. Aparece na tela, mas não é armazenado; é sempre recalculado quando necessário.

---


