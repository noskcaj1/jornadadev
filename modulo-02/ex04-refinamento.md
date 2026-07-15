# Exercícios — Módulo 2: Lógica, algoritmos e fluxogramas

- **Aluno:** Jackson Miranda
- **Aula:** 2 · 14/07
- **Curso:** Jornada DEV START — Programa START (TOTVS Paulista)
- **Prazo sugerido:** até a Aula 3 (15/07)
- **Onde entregar:** atividade do Módulo 2 no Google Classroom
  
-------

## Exercício 4 — Refinamento sucessivo

Aplique a técnica do refinamento sucessivo (visão geral → detalhamento) para o problema:

    “Um sistema de caixa de supermercado deve registrar os itens de uma compra, calcular o
    subtotal, aplicar desconto se o cliente tiver cartão fidelidade (5%) e mostrar o total a
    pagar.”

Entregue dois níveis: o Nível 1 (visão geral, 3–4 passos) e o Nível 2 (cada passo detalhado).

-----

## Nível 1 — Visão geral

	Algoritmo CaixaSupermercado

	Início

		1. Registrar os itens da compra
		2. Calcular o subtotal
		3. Aplicar desconto se o cliente tiver cartão fidelidade
		4. Mostrar o total a pagar
		
	Fim
	
## Nível 2 — Detalhamento de cada passo

<span style="color:rgb(146, 153, 231); font-size: 20px;">→ Passo 1 — Registrar os itens da compra</span>
	
	subtotal ← 0
	quantidadeItens ← 0
	Escreva "Digite o preço do item (ou 0 para encerrar):"
		
	Leia preco
		
	Enquanto preco ≠ 0 faça
		
		subtotal ← subtotal + preco
		quantidadeItens ← quantidadeItens + 1
			
		Escreva "Próximo item (0 para encerrar):"
			
		Leia preco
			
	FimEnquanto
		
	
<span style="color:rgb(146, 153, 231); font-size: 20px;">→ Passo 2 — Calcular o subtotal</span>
	
	subtotal ← 0
	Para cada item registrado faça
		subtotal ← subtotal + preco_do_item
			
	FimPara
		
		
<span style="color:rgb(146, 153, 231); font-size: 20px;">→ Passo 3 — Aplicar desconto se tiver cartão fidelidade</span>
	
	Escreva "O cliente tem cartão fidelidade? (S/N)"
	Leia resposta
	Se (resposta = "S") Então
		desconto ← subtotal * 0,05
		total ← subtotal - desconto
	Senão
		desconto ← 0
		total ← subtotal
	FimSe
		
		
<span style="color:rgb(146, 153, 231); font-size: 20px;">→ Passo 4 — Mostrar o total a pagar</span>
		
	Escreva "----- CUPOM FISCAL -----"
	Escreva "Itens registrados: ", quantidadeItens
	Escreva "Subtotal: R$ ", subtotal
	Escreva "Desconto: R$ ", desconto
	Escreva "TOTAL A PAGAR: R$ ", total
		
<span style="color:rgb(88, 189, 155); font-size: 20px;">→ Algoritmo Completo:</span>

	Algoritmo CaixaSupermercado
	
	Var
		preco, subtotal, desconto, total: real
		quantidadeItens: inteiro
		resposta: caractere
		
	Início
	
		subtotal ← 0
		quantidadeItens ← 0

		Escreva "Digite o preço do item (0 para encerrar):"
		Leia preco
		Enquanto preco ≠ 0 faça
			subtotal ← subtotal + preco
			quantidadeItens ← quantidadeItens + 1
			Escreva "Próximo item (0 para encerrar):"
			Leia preco
		FimEnquanto

		Escreva "Tem cartão fidelidade? (S/N)"
		Leia resposta
		Se (resposta = "S") Então
			desconto ← subtotal * 0,05
		Senão
			desconto ← 0
		FimSe
		
		total ← subtotal - desconto
		
		Escreva "----- CUPOM FISCAL -----"
		Escreva "Itens: ", quantidadeItens
		Escreva "Subtotal: R$ ", subtotal
		Escreva "Desconto: R$ ", desconto
		Escreva "Total a pagar: R$ ", total
		
	Fim