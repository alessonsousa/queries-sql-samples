SET LANGUAGE PORTUGUESE;

SELECT 
	
	CASE
		WHEN FXCX.CODFILIAL = 1 THEN 'MATRIZ - JUAZEIRO DO NORTE'
		WHEN FXCX.CODFILIAL = 3 THEN 'FILIAL - FORTALEZA'
		WHEN FXCX.CODFILIAL = 4 THEN 'FILIAL - ARARIPINA'
	END																								[FILIAL],
	FCXA.CODCXA																						[CAIXA],
	FCXA.DESCRICAO																					[NOME CAIXA],
	FXCX.IDXCX																						[EXTRATO],
	CASE
		WHEN FLANBAIXA.IDXCX IS NOT NULL THEN FLAN.IDLAN
		ELSE FXCX.IDXCX
	END																								[REFERENCIA],
	CASE
		WHEN FXCX.TIPO = 0 THEN 'NADA'
		WHEN FXCX.TIPO = 1 THEN 'SAQUE MANUAL'
		WHEN FXCX.TIPO = 2 THEN 'DEP�SITO MANUAL'
		WHEN FXCX.TIPO = 3 THEN 'SAQUE TRANSF.'
		WHEN FXCX.TIPO = 4 THEN 'DEP�SITO TRANSF.'
		WHEN FXCX.TIPO = 5 THEN 'DEP�SITO NA BAIXA'
		WHEN FXCX.TIPO = 6 THEN 'SAQUE NA BAIXA'
		WHEN FXCX.TIPO = 7 THEN 'SAQUE DO CHEQUE'
		WHEN FXCX.TIPO = 8 THEN 'DEP�S. CANCEL. DA BAIXA'
		WHEN FXCX.TIPO = 9 THEN 'SAQUE CANCEL. DE BAIXA'
		WHEN FXCX.TIPO = 10 THEN 'DEP. CANC. DE CHEQUE'
		WHEN FXCX.TIPO = 11 THEN 'SAQUE CPMF'
		WHEN FXCX.TIPO = 12 THEN 'RECEBIMENTO VIA CHEQUE'
		WHEN FXCX.TIPO = 13 THEN 'SAQUE CANC. RECEBIM. DE CHEQUE'
		WHEN FXCX.TIPO = 14 THEN 'DEP�S. CANC. DE CPMF'
		WHEN FXCX.TIPO = 15 THEN 'DESCONTO EM ABERTO'
		WHEN FXCX.TIPO = 16 THEN 'DESCONTO EFETIVADO'
		WHEN FXCX.TIPO = 17 THEN 'DEVOLU��O DE DESCONTO'
		WHEN FXCX.TIPO = 18 THEN 'SAQUE TRANSF. CONCILIA. CART�O'
		WHEN FXCX.TIPO = 19 THEN 'DEP. CONCILIA. CART�O'
		WHEN FXCX.TIPO = 20 THEN 'SAQUE TAXA ADM CART�O'
		WHEN FXCX.TIPO = 21 THEN 'RENDIMENTO FINANCEIRO'
	END																								[TIPO_EXTRATO],
	CASE
		WHEN FLANBAIXA.IDXCX IS NOT NULL THEN FLAN.HISTORICO
		ELSE FXCX.HISTORICO
	END																								[HISTORICO],
	CASE
		WHEN FLANBAIXARATCCU.CODNATFINANCEIRA IS NOT NULL THEN TTBORCAMENTO.DESCRICAO
		ELSE 'N�O INFORMADO'
	END																								[NATUREZA FINANCEIRA], 
	CLASSIF.DESCRICAO																				[CLASSIFICACAO],
	FCFO.NOMEFANTASIA																				[CLIENTE/FORNECEDOR],
	FXCX.CODCCUSTO, 
	GCCUSTO.NOME																					[CENTRO DE CUSTO],
	CONVERT(NUMERIC(10,2), FXCX.VALOR)																[VALOR EXTRATO],
	CONVERT(NUMERIC(10,2), FXCX.VALORCONTABIL / 
			CASE 
			WHEN (SELECT COUNT(EXTRATO.IDXCX) FROM FLANBAIXA AS EXTRATO WHERE EXTRATO.IDXCX = FLANBAIXA.IDXCX) > 1
				THEN (SELECT COUNT(EXTRATO.IDXCX) FROM FLANBAIXA AS EXTRATO WHERE EXTRATO.IDXCX = FLANBAIXA.IDXCX)	
			WHEN FLANBAIXARATCCU.VALOR IS NULL or FLANBAIXARATCCU.VALOR = (FXCX.VALORCONTABIL * -1)
				THEN 1 
			WHEN 	FLANBAIXARATCCU.VALOR IS NOT NULL THEN
				(SELECT COUNT(CONTADOR.VALOR) from FLANBAIXARATCCU AS CONTADOR WHERE CONTADOR.IDLAN = FLANBAIXARATCCU.IDLAN)
				
				END)											[VALOR CONTABIL],
	CONVERT(NUMERIC(10,2), FLANBAIXARATCCU.VALOR)													[VALOR BAIXADO],
	CASE
		WHEN FLANBAIXA.IDXCX IS NOT NULL AND FXCX.TIPO IN (1,3,6,7,9,11,13,18,20) THEN CONVERT(NUMERIC(10,2), FLANRATCCU.VALOR * (-1))
		WHEN FLANBAIXA.IDXCX IS NOT NULL AND FXCX.TIPO NOT IN (1,3,6,7,9,11,13,18,20) THEN CONVERT(NUMERIC(10,2), FLANRATCCU.VALOR)
		ELSE CONVERT(NUMERIC(10,2), FXCX.VALOR)
	END																								[VALOR DO EXTRATO OU RATEIO],
	
	CONCAT(MONTH(FXCX.DATA), ' - ', DATENAME(MONTH, FXCX.DATA)) 									[COMPETENCIA],
	CONVERT(VARCHAR(12), FXCX.DATA, 103)															[DATA]
FROM FCXA (NOLOCK)
	INNER JOIN FXCX (NOLOCK) ON
			FXCX.CODCOLIGADA = FCXA.CODCOLIGADA
		AND FXCX.CODCXA = FCXA.CODCXA
	FULL OUTER JOIN FLANBAIXA (NOLOCK) ON
			FLANBAIXA.IDXCX = FXCX.IDXCX
		AND FLANBAIXA.CODCXA = FXCX.CODCXA
	LEFT JOIN FLANBAIXARATCCU ON
			FLANBAIXARATCCU.IDLAN = FLANBAIXA.IDLAN
		AND FLANBAIXARATCCU.IDBAIXA = FLANBAIXA.IDBAIXA
	LEFT JOIN FLAN (NOLOCK) ON
			FLAN.IDLAN = FLANBAIXA.IDLAN
	LEFT JOIN FCFO (NOLOCK) ON
			FCFO.CODCFO = FLAN.CODCFO
	FULL OUTER JOIN GCCUSTO (NOLOCK) ON
			GCCUSTO.CODCCUSTO = FXCX.CODCCUSTO
	FULL OUTER JOIN FLANRATCCU (NOLOCK) ON
			FLANRATCCU.IDLAN = FLANBAIXARATCCU.IDLAN
		AND FLANRATCCU.IDRATCCU = FLANBAIXARATCCU.IDRATCCU
	LEFT JOIN TTBORCAMENTO (NOLOCK) ON
			TTBORCAMENTO.CODTBORCAMENTO = FLANBAIXARATCCU.CODNATFINANCEIRA
	LEFT JOIN TTBORCAMENTO AS CLASSIF (NOLOCK) ON
			CLASSIF.CODCOLIGADA = FLANRATCCU.CODCOLNATFINANCEIRA
		AND CLASSIF.CODTBORCAMENTO = SUBSTRING(FLANRATCCU.CODNATFINANCEIRA,1,5)


WHERE CONVERT(VARCHAR(12), FXCX.DATA, 103) BETWEEN :DATA_INICIAL AND :DATA_FINAL
AND FXCX.TIPO not in (8,9)
AND FXCX.ESTORNADO = 0


/////////////////////

SET LANGUAGE PORTUGUESE;

SELECT 
	
	CASE
		WHEN FXCX.CODFILIAL = 1 THEN 'MATRIZ - JUAZEIRO DO NORTE'
		WHEN FXCX.CODFILIAL = 3 THEN 'FILIAL - FORTALEZA'
		WHEN FXCX.CODFILIAL = 4 THEN 'FILIAL - ARARIPINA'
	END																								[FILIAL],
	FCXA.CODCXA																						[CAIXA],
	FCXA.DESCRICAO																					[NOME CAIXA],
	FXCX.IDXCX																						[EXTRATO],
	CASE
		WHEN FLANBAIXA.IDXCX IS NOT NULL THEN FLAN.IDLAN
		ELSE FXCX.IDXCX
	END																								[REFERENCIA],
	CASE
		WHEN FXCX.TIPO = 0 THEN 'NADA'
		WHEN FXCX.TIPO = 1 THEN 'SAQUE MANUAL'
		WHEN FXCX.TIPO = 2 THEN 'DEP�SITO MANUAL'
		WHEN FXCX.TIPO = 3 THEN 'SAQUE TRANSF.'
		WHEN FXCX.TIPO = 4 THEN 'DEP�SITO TRANSF.'
		WHEN FXCX.TIPO = 5 THEN 'DEP�SITO NA BAIXA'
		WHEN FXCX.TIPO = 6 THEN 'SAQUE NA BAIXA'
		WHEN FXCX.TIPO = 7 THEN 'SAQUE DO CHEQUE'
		WHEN FXCX.TIPO = 8 THEN 'DEP�S. CANCEL. DA BAIXA'
		WHEN FXCX.TIPO = 9 THEN 'SAQUE CANCEL. DE BAIXA'
		WHEN FXCX.TIPO = 10 THEN 'DEP. CANC. DE CHEQUE'
		WHEN FXCX.TIPO = 11 THEN 'SAQUE CPMF'
		WHEN FXCX.TIPO = 12 THEN 'RECEBIMENTO VIA CHEQUE'
		WHEN FXCX.TIPO = 13 THEN 'SAQUE CANC. RECEBIM. DE CHEQUE'
		WHEN FXCX.TIPO = 14 THEN 'DEP�S. CANC. DE CPMF'
		WHEN FXCX.TIPO = 15 THEN 'DESCONTO EM ABERTO'
		WHEN FXCX.TIPO = 16 THEN 'DESCONTO EFETIVADO'
		WHEN FXCX.TIPO = 17 THEN 'DEVOLU��O DE DESCONTO'
		WHEN FXCX.TIPO = 18 THEN 'SAQUE TRANSF. CONCILIA. CART�O'
		WHEN FXCX.TIPO = 19 THEN 'DEP. CONCILIA. CART�O'
		WHEN FXCX.TIPO = 20 THEN 'SAQUE TAXA ADM CART�O'
		WHEN FXCX.TIPO = 21 THEN 'RENDIMENTO FINANCEIRO'
	END																								[TIPO_EXTRATO],
	CASE
		WHEN FLANBAIXA.IDXCX IS NOT NULL THEN FLAN.HISTORICO
		ELSE FXCX.HISTORICO
	END																								[HISTORICO],
	CASE
		WHEN FLANBAIXARATCCU.CODNATFINANCEIRA IS NOT NULL THEN TTBORCAMENTO.DESCRICAO
		ELSE 'N�O INFORMADO'
	END																								[NATUREZA FINANCEIRA], 
	CLASSIF.DESCRICAO																				[CLASSIFICACAO],
	FCFO.NOMEFANTASIA																				[CLIENTE/FORNECEDOR],
	FLANBAIXARATCCU.CODCCUSTO, 
	GCCUSTO.NOME																					[CENTRO DE CUSTO],
	CONVERT(NUMERIC(10,2), FXCX.VALOR)																[VALOR EXTRATO],
	CONVERT(NUMERIC(10,2), FXCX.VALORCONTABIL),
	FXCX.VALORCONTABIL / 
			case when
			(SELECT COUNT(EXTRATO.IDXCX) FROM FXCX AS EXTRATO WHERE replace(EXTRATO.numerodocumento,'/','') = replace(fxcx.numerodocumento,'/','') and CONVERT(VARCHAR(12), EXTRATO.DATA, 103) BETWEEN :DATA_INICIAL AND :DATA_FINAL and TTBORCAMENTO.DESCRICAO like 'FGTS Sobre Folha de Pagamento' ) > 1
				then (SELECT COUNT(CONTADOR.VALOR) from FLANBAIXARATCCU AS CONTADOR WHERE CONTADOR.IDLAN = FLANBAIXARATCCU.IDLAN) / (SELECT COUNT(EXTRATO.IDXCX) FROM FXCX AS EXTRATO WHERE replace(EXTRATO.numerodocumento,'/','') = replace(FXCX.numerodocumento,'/','') and CONVERT(VARCHAR(12), EXTRATO.DATA, 103) BETWEEN :DATA_INICIAL AND :DATA_FINAL and TTBORCAMENTO.DESCRICAO like 'FGTS Sobre Folha de Pagamento' )
			WHEN (SELECT COUNT(EXTRATO.IDXCX) FROM FLANBAIXA AS EXTRATO WHERE EXTRATO.IDXCX = FLANBAIXA.IDXCX) > 1
				THEN (SELECT COUNT(EXTRATO.IDXCX) FROM FLANBAIXA AS EXTRATO WHERE EXTRATO.IDXCX = FLANBAIXA.IDXCX)	
			WHEN FLANBAIXARATCCU.VALOR IS NULL or FLANBAIXARATCCU.VALOR = (FXCX.VALORCONTABIL * -1)
				THEN 1 
			WHEN 	FLANBAIXARATCCU.VALOR IS NOT NULL THEN
				(SELECT COUNT(CONTADOR.VALOR) from FLANBAIXARATCCU AS CONTADOR WHERE CONTADOR.IDLAN = FLANBAIXARATCCU.IDLAN)
				
				END	[VALOR CONTABIL],

	CONVERT(NUMERIC(10,2), FLANBAIXARATCCU.VALOR)													[VALOR BAIXADO],
	CASE
		WHEN FLANBAIXA.IDXCX IS NOT NULL AND FXCX.TIPO IN (1,3,6,7,9,11,13,18,20) THEN CONVERT(NUMERIC(10,2), FLANRATCCU.VALOR * (-1))
		WHEN FLANBAIXA.IDXCX IS NOT NULL AND FXCX.TIPO NOT IN (1,3,6,7,9,11,13,18,20) THEN CONVERT(NUMERIC(10,2), FLANRATCCU.VALOR)
		ELSE CONVERT(NUMERIC(10,2), FXCX.VALOR)
	END																								[VALOR DO EXTRATO OU RATEIO],
	
	CONCAT(MONTH(FXCX.DATA), ' - ', DATENAME(MONTH, FXCX.DATA)) 									[COMPETENCIA],
	CONVERT(VARCHAR(12), FXCX.DATA, 103)						[DATA],

	fxcx.ESTORNADO
FROM FCXA (NOLOCK)
	INNER JOIN FXCX (NOLOCK) ON
			FXCX.CODCOLIGADA = FCXA.CODCOLIGADA
		AND FXCX.CODCXA = FCXA.CODCXA
	FULL OUTER JOIN FLANBAIXA (NOLOCK) ON
			FLANBAIXA.IDXCX = FXCX.IDXCX
		AND FLANBAIXA.CODCXA = FXCX.CODCXA
	LEFT JOIN FLANBAIXARATCCU ON
			FLANBAIXARATCCU.IDLAN = FLANBAIXA.IDLAN
		AND FLANBAIXARATCCU.IDBAIXA = FLANBAIXA.IDBAIXA
	LEFT JOIN FLAN (NOLOCK) ON
			FLAN.IDLAN = FLANBAIXA.IDLAN
	LEFT JOIN FCFO (NOLOCK) ON
			FCFO.CODCFO = FLAN.CODCFO
	FULL OUTER JOIN GCCUSTO (NOLOCK) ON
			GCCUSTO.CODCCUSTO = FLANBAIXARATCCU.CODCCUSTO
	FULL OUTER JOIN FLANRATCCU (NOLOCK) ON
			FLANRATCCU.IDLAN = FLANBAIXARATCCU.IDLAN
		AND FLANRATCCU.IDRATCCU = FLANBAIXARATCCU.IDRATCCU
	LEFT JOIN TTBORCAMENTO (NOLOCK) ON
			TTBORCAMENTO.CODTBORCAMENTO = FLANBAIXARATCCU.CODNATFINANCEIRA
	LEFT JOIN TTBORCAMENTO AS CLASSIF (NOLOCK) ON
			CLASSIF.CODCOLIGADA = FLANRATCCU.CODCOLNATFINANCEIRA
		AND CLASSIF.CODTBORCAMENTO = SUBSTRING(FLANRATCCU.CODNATFINANCEIRA,1,5)
WHERE CONVERT(VARCHAR(12), FXCX.DATA, 103) BETWEEN :DATA_INICIAL AND :DATA_FINAL
AND FXCX.TIPO not in (8,9)
AND FXCX.ESTORNADO = 0