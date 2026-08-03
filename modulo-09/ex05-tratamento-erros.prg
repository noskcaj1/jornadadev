FUNCTION Main()

    // Declaracao das variaveis locais:
    LOCAL nA := 10, nB := 0, nRes   // nA=10, nB=0 (zero de proposito), nRes recebera o resultado
    LOCAL oErro                     // Vai guardar o objeto de erro, se acontecer um

    // ErrorBlock: define o que o sistema deve fazer quando ocorrer um erro.
    // Aqui trocamos o tratador padrao por um que executa Break(e), que
    // "joga" o erro para o RECOVER mais proximo (o do BEGIN SEQUENCE abaixo).
    // O retorno antigo e guardado em bErroAntigo para ser restaurado depois.
    LOCAL bErroAntigo := ErrorBlock({|e| Break(e)})

    // BEGIN SEQUENCE ... RECOVER ... END SEQUENCE:
    // e o bloco protegido. O codigo entre BEGIN e RECOVER roda normalmente;
    // se estourar um erro (via Break), o fluxo pula direto para o RECOVER.
    BEGIN SEQUENCE

        nRes := nA / nB                       // Divisao por zero -> gera erro em tempo de execucao
        QOut("Resultado: " + Str(nRes))       // Esta linha NAO roda, porque a de cima ja estourou

    RECOVER USING oErro

        // So chega aqui se houve erro. oErro contem os dados da excecao.
        // oErro:Description traz a mensagem do erro (ex.: "division by zero").
        QOut("Erro capturado: " + oErro:Description)

    END SEQUENCE

    // Restaura o tratador de erro original, pra nao afetar o resto do sistema.
    // (Boa educacao, igual ao RestArea/Set Filter To dos outros fontes.)
    ErrorBlock(bErroAntigo)

    // Como o erro foi tratado, a execucao continua normalmente daqui pra frente.
    QOut("O programa continua de pe!")

RETURN NIL

/* O programa tenta dividir 10 por 0. Isso normalmente derrubaria a execução com um erro fatal. Mas antes, o ErrorBlock({|e| Break(e)}) 
mudou o comportamento: quando o erro acontece, em vez de morrer, ele dispara um Break, que desvia o fluxo pro trecho RECOVER. Lá, o objeto 
oErro carrega os detalhes, e o oErro:Description mostra a mensagem. Depois o programa restaura o tratador original e segue em frente — por isso 
a última linha, "O programa continua de pe!", é impressa. Sem esse mecanismo, o programa pararia na divisão por zero.

Os três elementos-chave que valem gravar:

ErrorBlock define a "reação" a um erro. Trocá-lo por {|e| Break(e)} é o que permite redirecionar o erro pro RECOVER em vez de estourar a tela 
de erro do Protheus.

BEGIN SEQUENCE / RECOVER / END SEQUENCE é a estrutura de try/catch do ADVPL: o que está entre BEGIN e RECOVER é o "tente"; o RECOVER é o "se der 
errado, faça isto".

oErro:Description é uma das propriedades do objeto de erro. Existem outras úteis, como oErro:Operation (a operação que falhou) e oErro:GenCode 
(o código do erro) — 
dá pra usar todas dentro do RECOVER pra montar uma mensagem ou um log mais detalhado.

Uma observação prática: QOut imprime no console/log de saída, então é ótimo pra teste como esse. Em uma tela de verdade, no lugar dele você usaria 
um MsgAlert, MsgStop, ou gravaria o erro num arquivo de log. */
