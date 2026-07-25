# Exercício 1 — Função ou procedimento?

- `Str()` -> **Função** -> Recebe um número e **retorna** a string correspondente (`cTexto := Str(10)`).    

- `QOut()` -> **Procedimento** -> Só **exibe** o texto na tela; não devolve valor para ser reaproveitado.   

- `Date()` -> **Função** -> **Retorna** a data atual do sistema para uso em expressões (`dHoje := Date()`).  

- `Len()` -> **Função** -> **Retorna** o tamanho (número) de uma string ou array (`n := Len(aV)`).  

- `Upper()` -> **Função** -> **Retorna** uma nova string em maiúsculas (`c := Upper("oi")`).  

- `ClearScreen()` -> **Procedimento** -> Só **executa a ação** de limpar a tela; não retorna dado algum.  


**Conclusão:** funções produzem um resultado que "volta" para quem chamou; procedimentos produzem um efeito no mundo (tela, arquivo, etc.) e seu "retorno" não é aproveitado.
