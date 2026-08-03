# Exercício 3 — Gatilhos, campos virtuais e validações cruzadas (SZ2)

Objetivo: deixar a SZ2 "esperta" — trazendo dados do contato sozinha, preenchendo data/hora/usuário automaticamente e recusando contato inexistente.

## 1. Campos virtuais na SZ2 (X3_RELACAO)

Trazem informação do contato (SZ1) sem gravar de novo na SZ2:

**Z2_CODIGO** (cliente do contato):
```advpl
POSICIONE("SZ1", 1, xFilial("SZ1") + M->Z2_CONTAT, "Z1_CLIENTE")
```

**Z2_ASSUNT** (assunto do contato):
```advpl
POSICIONE("SZ1", 1, xFilial("SZ1") + M->Z2_CONTAT, "Z1_ASSUNTO")
```

- Ordem 1 da SZ1 = `Z1_FILIAL + Z1_CODIGO`, e `Z2_CONTAT` guarda justamente o `Z1_CODIGO`, por isso a chave é `xFilial("SZ1") + M->Z2_CONTAT`.
- Uso `M->Z2_CONTAT` porque estou calculando com o contato que está sendo digitado na tela.
- Sendo virtuais, sempre refletem o valor atual da SZ1.

## 2. Gatilhos automáticos na SZ2 (SX7)

Configurados no campo de disparo, com a **fase** indicando quando rodam.

| Campo (disparo) | Contra-domínio | Regra                                   | Fase |
|-----------------|----------------|-----------------------------------------|------|
| (inclusão)      | Z2_DATA        | `dDataBase`                             | 1    |
| (inclusão)      | Z2_USUAR       | `cNomUsr`                               | 1    |
| Z2_?            | Z2_HORA        | `IF(INCLUI, Time(), SZ2->Z2_HORA)`      | 3    |

Observações:
- **Fase** define o momento do processamento (1 = mais cedo; 3 = mais tarde). Data e usuário entram cedo (fase 1); a hora usa fase 3.
- `Z2_HORA` usa `IF(INCLUI, Time(), SZ2->Z2_HORA)`: **na inclusão** pega a hora atual (`Time()`); **na alteração** mantém a hora já gravada (`SZ2->Z2_HORA`), para não "resetar" o horário original.
- `cNomUsr` = nome do usuário logado; `dDataBase` = data-base do sistema.

## 3. Validação cruzada no X3_VALID do Z2_CONTAT

Garante que o contato informado existe na SZ1:
```advpl
ExistCpo("SZ1", xFilial("SZ1") + M->Z2_CONTAT, 1)
```
- `ExistCpo` retorna `.T.` se a chave existir na SZ1 (ordem 1). Se não existir, bloqueia o campo e exibe a mensagem de ajuda padrão.

## Teste esperado
Ao **incluir** uma interação: `Z2_DATA`, `Z2_HORA` e `Z2_USUAR` aparecem preenchidos sozinhos; e digitar um contato que não existe na SZ1 é **recusado** pela validação.
