## <u>Exercício 5 — A1_FILIAL e xFilial()</u>

<span style="font-size: 1.2em; color:rgb(77, 247, 239); font-weight: bold; font-style: italic">A) - </span><span style="font-size: 1.2em; color:rgba(77, 171, 247, 0.77); font-weight: bold; font-style: italic">Por que existe o campo A1_FILIAL na tabela SA1 (e por que toda tabela do Protheus,
incluindo a ZA1 que criamos, precisa de um campo de filial)?</span>

<span style="font-size: 1.1em; color:rgba(219, 138, 138, 0.88); font-style: italic">Resposta: </span> O Protheus foi feito para rodar **várias empresas e várias filiais na mesma base de dados**. A mesma tabela física (SA1, ZA1, etc.) guarda os registros de todas as filiais misturados — e o **campo de filial é o que diz a qual filial cada registro pertence**. Sem ele, não daria para separar "o cliente da filial 01" do "cliente da filial 02": tudo viraria um monte só. Por isso **toda tabela precisa de um campo de filial**, inclusive a `ZA1` que criamos (`ZA1_FILIAL`). Além disso, é o campo de filial que permite configurar (no SX2) se a tabela é **compartilhada** (as filiais enxergam os mesmos dados) ou **exclusiva** (cada filial tem os seus).

---

<span style="font-size: 1.2em; color:rgb(77, 247, 239); font-weight: bold; font-style: italic">B) - </span><span style="font-size: 1.2em; color:rgba(77, 171, 247, 0.77); font-weight: bold; font-style: italic">O que a função xFilial() tem a ver com isso? O que aconteceria se um programa
“escrevesse a filial na mão” em vez de usar xFilial() ?</span>

<span style="font-size: 1.1em; color:rgba(219, 138, 138, 0.88); font-style: italic">Resposta: </span> A função **`xFilial("SA1")`** devolve o valor de filial correto para **filtrar e gravar** naquela tabela, **respeitando o modo de compartilhamento configurado no SX2**:
- tabela **exclusiva** por filial → devolve a filial atual;
- tabela **compartilhada** → devolve vazio (ou o valor combinado).

Ou seja, o `xFilial()` "sabe" o que a configuração da tabela pede e entrega o valor certo.

**Se um programa escrevesse a filial na mão** Ele **ignoraria a configuração** de compartilhamento do SX2.
- Registros passariam a **sumir** ou aparecer **na filial errada**.
- O código **quebraria** ao rodar em outra filial/empresa, ou quando o modo de compartilhamento mudasse.
- A manutenção viraria um pesadelo — teria que caçar filial "chumbada" em todo canto.  
Usando `xFilial()`, o **mesmo código funciona corretamente em qualquer configuração** de empresa/filial, sem alteração.

---