# Autoavaliação — TCC Controle ISO 9001

## O que foi entregue

- Dicionário completo (SX2/SX3/SIX/SX7/SXB) para as duas tabelas do projeto,
  **ZZ1 (Controle de Fornecimento)** e **ZZ2 (Ocorrências de Não
  Conformidade)** — construído campo a campo direto no Configurador, não só
  copiado de um CSV pronto.
- As duas rotinas de manutenção (`STTZZ1.PRW`, `STTZZ2.PRW`), com mBrowse,
  legendas por cor, CRUD protegido e um botão extra (`Ocorrências`) que
  integra as duas telas.
- Biblioteca central (`STTZZLIB.PRW`) com zero duplicação de regra de
  negócio, motor de CRUD com `BEGIN SEQUENCE`, log técnico e uma classe POO
  (`ZFORNISO`) que encapsula a análise de conformidade de um fornecedor.
- Todos os diferenciais da rubrica: POO, legenda diferencial da ZZ2 (%NC vs
  tolerância), bloqueio de exclusão referencial, zero duplicação.
- Massa de dados de teste cadastrada e exercitada de ponta a ponta no
  ambiente MP8 real (não só planejada em CSV) — ver `evidencias/EVIDENCIAS.md`.

## Desafios enfrentados (e como foram resolvidos)

**1. `ExistCpo()` não confiável neste build.** A função padrão do Protheus
para checar existência de registro retornava `.F.` para registros que
comprovadamente existiam (SA2, SB1 e até a própria tabela ZZ1). Em vez de
aceitar isso como "o sistema é assim mesmo", diagnostiquei a causa
comparando `ExistCpo()` com um `dbSeek()` bruto na mesma chave — o `dbSeek`
sempre encontrava o registro certo, isolando o problema na função em si.
Criei `U_ExisteReg()` como substituto confiável e apliquei em todas as
validações do projeto.

**2. Gatilhos que acessam outra tabela precisam de configuração extra.**
Descobri que um gatilho cuja regra referencia outro alias (ex.:
`POSICIONE("SA2", ...)`) precisa do `Tipo=Estrangeiro` e do campo `Alias`
preenchidos no dicionário — sem isso, a gravação falhava com "Alias does not
exist" porque nenhuma tabela estava aberta no momento em que o gatilho era
avaliado.

**3. Campo calculado (Virtual) não renderizava em nenhuma tela.** Um campo
Virtual cujo cálculo depende de outra tabela (nome do fornecedor via SA2)
simplesmente não aparecia — nem no browse, nem no Visualizar/Alterar. Depois
de descartar teorias mais simples (cache, alias não aberto), converti o
campo para Real, preenchido pelo gatilho já existente — resolveu em todas as
telas de uma vez, incluindo a consulta padrão (F3).

**4. Gatilho só dispara ao sair do campo de origem.** Reaprendi (na prática)
que abrir um registro em Alterar e clicar OK sem tocar no campo de origem
não é suficiente para reprocessar um gatilho — é preciso passar pelo campo
específico.

## Autoavaliação por critério da rubrica

| Critério           | Como avalio                        | Observação                                                                                                                 |
| ------------------- | ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Dicionário         | Completo                           | Construído e testado campo a campo no Configurador                                                                          |
| Rotinas funcionais  | Completo                           | Testado ao vivo — legendas, filtro ZZ1→ZZ2, tudo confirmado                                                                |
| Validações        | Completo, com ressalva documentada | `ExistCpo` substituído por `U_ExisteReg` — mesma regra de negócio, implementação mais confiável (ver README §2.6) |
| Gatilhos            | Completo                           | Testado, incluindo a correção de Tipo/Alias                                                                                |
| Tratamento de erros | Completo                           | `BEGIN SEQUENCE`/`RECOVER` + log técnico em todo CRUD                                                                   |
| Biblioteca comum    | Completo                           | Zero duplicação                                                                                                            |
| Menu                | Completo                           |                                                                                                                              |
| Documentação      | Completo                           | README + evidências escritas + docx                                                                                         |

## O que eu levo deste projeto

Antes desse TCC eu nunca tinha encostado num ambiente Protheus. Todo o meu contato com o curso foi a base teórica dos módulos, e confesso que não fazia ideia do tamanho da distância entre "entender o conceito de dicionário de dados" e efetivamente sentar na frente do Configurador e fazer um campo funcionar. Foi muito enriquecente exatamente por isso: o TCC não testou se eu sabia decorar o que é SX3 ou gatilho, testou se eu conseguia sobreviver ao ambiente real, que é bem menos arrumado que o slide.

O que mais me marcou foi perceber que a maior parte dos problemas não estava no meu código ADVPL — estava em detalhes de configuração que nenhuma aula cobre em profundidade: um campo "Form. Variável" que corta silenciosamente depois de 20 caracteres, uma caixa de texto que duplica aspas sozinha quando você cola uma fórmula, um gatilho que só reprocessa se você tocar de verdade no campo de origem. Nada disso é "difícil" no sentido de exigir lógica complexa, mas é o tipo de coisa que só se aprende errando e comparando print com print até a ficha cair.

O ponto alto (e o mais frustrante na hora) foi caçar o bug do `ExistCpo()`. Levei um tempo bom insistindo em teorias sobre aspas, filial errada, cadastro bloqueado — todas descartadas uma a uma — até finalmente comparar a função padrão do Protheus com um `dbSeek()` cru na mesma chave e ver, preto no branco, que a função nativa estava retornando errado. Foi a primeira vez que precisei desconfiar de uma função "de framework" em vez do meu próprio código, e construir um substituto (`U_ExisteReg`) que eu mesmo comprovei que funcionava, em vez de simplesmente aceitar o comportamento quebrado. Isso mudou a forma como vou depurar qualquer sistema legado daqui pra frente: sempre isolar a variável, nunca confiar de olhos fechados numa peça só porque ela é "padrão".

Também levo a lição de que campo virtual, gatilho e validação de dicionário são três ferramentas com propósitos bem diferentes, e usá-las no lugar errado (um gatilho que dispara nele mesmo, uma validação de campo que roda antes da hora) quebra tudo de um jeito que não aparece no código-fonte, só na tela rodando. Sair da teoria e ver isso acontecer ao vivo — e ter que decidir, com dado real na mão, entre aceitar uma limitação documentada ou converter a estrutura pra resolver de vez — foi a parte que mais se pareceu com o dia a dia real de quem mantém sistema legado em produção.

Fecho o projeto bem mais confiante pra entrar num ambiente Protheus de verdade do que estava na primeira aula.

<!-- Espaço para sua reflexão pessoal: o que foi mais desafiador, o que você
     faria diferente, o que aprendeu sobre debugging em ambiente real vs.
     teoria. -->
