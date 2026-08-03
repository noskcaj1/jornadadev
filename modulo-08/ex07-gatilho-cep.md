# Exercício 7 — A brincadeira do CEP: gatilho que preenche o endereço

## Passos executados (resumo)
Como não encontrei o arquivo do `stcep.prw` no material (no ato da execução desse exercício o professor ainda não havia postado), fiz o seguinte:

1. Testei se o Protheus possuia HTTPGET e se ele acessa HTTPS;
2. Diagnosticado por script, incompatibilidade com HTTPS/TLS atual do ViaCEP.
3. Aplicado solução: Criado serviço em python - cep_proxy.py - ela consome a API do viacep utilizando apenas bibliotecas nativas do Python, validando localmente no navegador - http://127.0.0.1:8080/cep/18035000 - resultado: OK|Rua Exemplo|Centro|Sorocaba|SP|3552205
4. reformulado funções STCEP completa (com a solução em python) para os gatilhos (trazendo também o código do IBGE que utilizarei para responder a questão .d)
5. compilação do arquivo criado stcep.prw, resultado ok.
7. testado função com um item de menu teste denominado U_STCEPTESTE, teste bem sucedido, retornou CEP: 18035-000, Logradouro: ..., Bairro: ..., Cidade: Sorocaba, UF: SP, IBGE: ...
8. Configurado gatilhos no SX7,
9. Testes no cadastro de clientes.

---

## a. Diferença entre campo, contra-domínio e regra num gatilho

- **Campo (domínio):** é o campo que **dispara** o gatilho quando é preenchido. Aqui é o `A1_CEP` — é a "origem".
- **Contra-domínio:** é o campo de **destino**, o que vai ser preenchido pelo gatilho (ex.: `A1_BAIRRO`, `A1_MUN`, `A1_EST`).
- **Regra:** é a **expressão/fórmula** que calcula o valor a ser jogado no contra-domínio (ex.: `U_STCEP(M->A1_CEP,"BAIRRO")`).

Em uma frase: *ao mexer no **campo**, o Protheus roda a **regra** e coloca o resultado no **contra-domínio**.*

## b. Por que a regra usa M->A1_CEP e não SA1->A1_CEP

Porque, durante a inclusão/alteração, o valor que o usuário acabou de digitar ainda **não foi gravado** na tabela — ele está só na **memória** (buffer da tela), acessível pelo prefixo `M->`. O gatilho dispara **antes** de salvar o registro.

- `M->A1_CEP` → o CEP **atual**, que a pessoa acabou de digitar. ✅
- `SA1->A1_CEP` → o valor **antigo** gravado no disco (ou vazio, na inclusão). ❌

Usar `SA1->` traria o endereço errado (ou nenhum), porque leria o dado de antes da digitação.

## c. CEPs dentro do fonte — dois problemas em produção e como resolver

**Problema 1 — Manutenção travada no desenvolvedor.**
Cada CEP novo, correção ou cidade que muda de faixa exige **editar o fonte e recompilar**. Isso é lento, arriscado e depende de programador para uma informação que é puramente cadastral.
> Solução: mover os CEPs para uma **tabela do dicionário** (uma tabela customizada, ex.: `ZCEP`), que o pessoal de negócio mantém pelo próprio Protheus, sem recompilar nada.

**Problema 2 — Dados incompletos e desatualizados.**
O Brasil tem milhões de CEPs e eles mudam. Colocar alguns "na mão" no fonte cobre pouquíssimos casos e envelhece rápido.
> Solução: consumir um **serviço externo** (ex.: uma API de CEP como a ViaCEP) em tempo de execução, trazendo o endereço sempre atual e completo. Dá para **cachear** o resultado na tabela `ZCEP` para não bater na API toda hora.

## d. Se pedissem para preencher também o código do município (A1_COD_MUN)

Eu criei um **4º gatilho** no `A1_CEP`:

| Sequência | Contra-domínio | Regra                            |
|-----------|----------------|----------------------------------|
| 004       | A1_COD_MUN     | `U_STCEP(M->A1_CEP,"CODMUN")`    |

E garantiria que a fonte de dados (a função `U_STCEP`, a tabela `ZCEP` ou a API) **retorne também o código IBGE do município**. Como o `A1_COD_MUN` costuma referenciar uma tabela de municípios (CC2), eu ainda validaria se o código retornado existe lá, para não gravar um município inválido.
