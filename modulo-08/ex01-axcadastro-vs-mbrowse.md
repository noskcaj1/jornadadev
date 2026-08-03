# Exercício 1 — AxCadastro × mBrowse 
## a. Quando usar AxCadastro e quando usar mBrowse

**AxCadastro** monta um CRUD completo (browse + tela de manutenção) praticamente sozinho, lendo tudo do dicionário. É a escolha para **cadastros simples**, sem nenhuma customização.
> Exemplo: uma tabela de raças de pets, ou de categorias — só preciso de incluir/alterar/excluir/visualizar, nada além disso.

**mBrowse** monta só a *grade* e me dá controle total: eu defino o `aRotina` (os botões), posso adicionar botões próprios, legendas coloridas, filtros, chamar outras rotinas etc. É a escolha quando o cadastro precisa de **customização**.
> Exemplo: a rotina de Contatos com um botão "Interações" que abre outra tabela, ou a de Pets com legendas coloridas por idade.

Resumindo: `AxCadastro` = rápido e engessado; `mBrowse` = trabalhoso, porém flexível.

## b. Cite três coisas que o mBrowse faz e o AxCadastro não faz.

1. **Legendas coloridas** nas linhas do browse (parâmetro `aColors`).
2. **Botões customizados** no `aRotina` (opções tipo 6) que chamam funções próprias — ex.: abrir uma rotina relacionada.
3. **Filtros pré-definidos** (`cFiltro`) e controle sobre colunas fixas / ordem exibida.

## c. Na configuração de legendas ( aColors ), por que a regra ".T." deve ficar por último?

O Protheus avalia as regras do `aColors` **de cima para baixo** e aplica a **primeira** que retornar `.T.`. Como `".T."` é sempre verdadeiro, se ela estivesse antes das outras "engoliria" todas as linhas e as regras específicas abaixo dela **nunca seriam alcançadas**. Colocando `".T."` por último, ela funciona como a **cor padrão** (o "senão"), aplicada só a quem não bateu em nenhuma regra específica.

## d. Qual a diferença entre um campo Virtual (X3_RELACAO) e um gatilho (SX7) para preencher o nome do cliente?

Em uma frase: o **virtual** é sempre atual mas não existe na tabela; o **gatilho** grava um valor que fica "congelado" até alguém alterar o registro de novo.

---

| | **Campo Virtual (X3_RELACAO)** | **Gatilho (SX7)** |
|---|---|---|
| Onde fica o dado | **Não é gravado** — calculado toda vez que o registro é lido (via `POSICIONE`) | **Gravado fisicamente** num campo Real, no momento em que preencho o campo de origem |
| Atualização | Sempre reflete o valor **atual** da SA1 (se o cliente muda de nome, o virtual mostra o novo) | É um "retrato" do momento — se o nome mudar na SA1 depois, o valor gravado **não** muda sozinho |
| Espaço em disco | Não ocupa | Ocupa |
| Consulta/relatório direto | Não dá para consultar como dado gravado | Dá — está armazenado |
| Custo | Recalcula a cada leitura | Grava uma vez |


