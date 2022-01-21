

/*********DISCIPLINAS EQUIVALENTES A DISCIPLINAS DA GRADE NORMAL CONCLUIDAS****/
	SELECT DISTINCT
		SALUNO.RA										[MATRICULA],
		PPESSOA.NOME									[ALUNO],
		PPESSOA.EMAIL									[EMAIL],
		PPESSOA.TELEFONE2								[TELEFONE],
		SCURSO.NOME										[CURSO],
		SMODALIDADECURSO.DESCRICAO						[MODALIDADE CURSO],
		SHISTDISCEQUIVCONCLUIDAS.CODDISC				[C�DIGO DISCIPLINA],
		SHISTDISCEQUIVCONCLUIDAS.PLETIVO				[PERIODO LETIVO],
		SHISTDISCEQUIVCONCLUIDAS.DISCIPLINA				[DISCIPLINA],
		SHISTDISCCONCLUIDAS.CODPERIODO                  [PERIODO],
		SHISTDISCEQUIVCONCLUIDAS.STATUS					[STATUS]

	FROM SHISTDISCEQUIVCONCLUIDAS (NOLOCK)

		INNER JOIN SHISTDISCCONCLUIDAS (NOLOCK) ON
			SHISTDISCCONCLUIDAS.RA = SHISTDISCEQUIVCONCLUIDAS.RA
			AND SHISTDISCCONCLUIDAS.GREQUIV = SHISTDISCEQUIVCONCLUIDAS.GREQUIV
			AND SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL = SHISTDISCEQUIVCONCLUIDAS.IDHABILITACAOFILIAL
		INNER JOIN SHISTHABILITACAOALUNO (NOLOCK) ON
			SHISTHABILITACAOALUNO.RA = SHISTDISCCONCLUIDAS.RA
			AND SHISTHABILITACAOALUNO.IDHABILITACAOFILIAL = SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL
		INNER JOIN SHABILITACAOALUNO (NOLOCK) ON
			SHISTHABILITACAOALUNO.RA = SHABILITACAOALUNO.RA
			AND SHISTHABILITACAOALUNO.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
			AND SALUNO.RA = SHABILITACAOALUNO.RA
		INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
		INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.RA = SHABILITACAOALUNO.RA
			AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
			AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
			AND SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
		INNER JOIN SMODALIDADECURSO (NOLOCK) ON
			SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA
			AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO

	WHERE 
		SMATRICPL.CODSTATUS IN (12, 101, 111)
		AND SHABILITACAOALUNO.CODSTATUS = 19
		AND SALUNO.RA = 2015111138--2018210116
	/*STATUS NO CURSO CURSANDO*/
	--AND SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL IN (SELECT DISTINCT IDHABILITACAOFILIAL FROM SHABILITACAOALUNO WHERE SHABILITACAOALUNO.RA = 2018210116)/*= :P_IDHABILITACAOFILIAL*/

UNION ALL

	/*********DISCIPLINAS DA GRADE NORMAL CONCLUIDAS****/
	SELECT DISTINCT
		SALUNO.RA						[MATRICULA],
		PPESSOA.NOME					[ALUNO],
		PPESSOA.EMAIL                   [EMAIL],
		PPESSOA.TELEFONE2               [TELEFONE],
		SCURSO.NOME						[CURSO],
		SMODALIDADECURSO.DESCRICAO		[MODALIDADE CURSO],
		SHISTORICO.CODDISC				[C�DIGO DISCIPLINA],
		SHISTORICO.CODPERLET			[PERIODO LETIVO],
		SHISTORICO.NOMEDISC			    [DISCIPLINA],
		SDISCGRADE.CODPERIODO			[PERIODO],
		SHISTORICO.STATUS      [STATUS]
	
	FROM SHABILITACAOALUNO (NOLOCK)
		INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
			AND SALUNO.RA = SHABILITACAOALUNO.RA
		INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
		INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
			AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
			AND SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
		INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.RA = SHABILITACAOALUNO.RA
			AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		INNER JOIN SPLETIVO (NOLOCK) ON
				SMATRICPL.CODCOLIGADA = SPLETIVO.CODCOLIGADA
			AND SMATRICPL.CODFILIAL = SPLETIVO.CODFILIAL
			AND SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
		INNER JOIN SHISTORICO (NOLOCK) ON
			SHISTORICO.RA = SHABILITACAOALUNO.RA
			AND SHISTORICO.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
			AND SHISTORICO.RA = SALUNO.RA
		INNER JOIN SMODALIDADECURSO (NOLOCK) ON
			SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA
			AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
		INNER JOIN SGRADE (NOLOCK) ON
			SGRADE.CODCURSO = SHABILITACAOFILIAL.CODCURSO
			AND SGRADE.CODHABILITACAO = SHABILITACAOFILIAL.CODHABILITACAO
			AND SGRADE.CODGRADE = SHABILITACAOFILIAL.CODGRADE
		INNER JOIN SPERIODO (NOLOCK) ON
			SPERIODO.CODCOLIGADA = SGRADE.CODCOLIGADA
			AND SPERIODO.CODGRADE = SGRADE.CODGRADE
			AND SPERIODO.CODCURSO = SGRADE.CODCURSO
			AND SPERIODO.CODHABILITACAO = SGRADE.CODHABILITACAO
		INNER JOIN SDISCGRADE (NOLOCK) ON
			SDISCGRADE.CODCOLIGADA = SPERIODO.CODCOLIGADA
			AND SDISCGRADE.CODGRADE = SPERIODO.CODGRADE
			AND SDISCGRADE.CODCURSO = SPERIODO.CODCURSO
			AND SDISCGRADE.CODHABILITACAO = SPERIODO.CODHABILITACAO
			AND SDISCGRADE.CODPERIODO = SPERIODO.CODPERIODO
			AND SDISCGRADE.CODDISC = SHISTORICO.CODDISC
		INNER JOIN SDISCIPLINA (NOLOCK) ON
			SDISCIPLINA.CODCOLIGADA = SDISCGRADE.CODCOLIGADA
			AND SDISCIPLINA.CODDISC = SDISCGRADE.CODDISC
			AND SDISCIPLINA.CODDISC = SHISTORICO.CODDISC
		

	WHERE
		 SHABILITACAOALUNO.CODSTATUS = 19 /*STATUS NO CURSO CURSANDO*/
		AND SALUNO.RA = 2015111138--2018210116
		AND SMATRICPL.CODSTATUS IN (12, 101, 111)

UNION ALL

	/*********DISCIPLINAS DA GRADE NORMAL PENDENTE****/
	SELECT DISTINCT
		SALUNO.RA						[MATRICULA],
		PPESSOA.NOME					[ALUNO],
		PPESSOA.EMAIL					[EMAIL],
		PPESSOA.TELEFONE2				[TELEFONE],
		SCURSO.NOME						[CURSO],
		SMODALIDADECURSO.DESCRICAO		[MODALIDADE CURSO],
		SHISTDISCPENDENTES.CODDISC		[C�DIGO DISCIPLINA],
		SHISTDISCPENDENTES.PLETIVO      [PERIODO LETIVO],
		SHISTDISCPENDENTES.DISCIPLINA	[DISCIPLINA],
		SHISTDISCPENDENTES.CODPERIODO	[PERIODO],
		CASE 
	WHEN 
	SHISTDISCPENDENTES.STATUS IS NULL THEN	'Pendente'
	ELSE SHISTDISCPENDENTES.STATUS
	END [STATUS]

	FROM SHABILITACAOALUNO (NOLOCK)
		INNER JOIN SHISTDISCPENDENTES (NOLOCK) ON
			SHISTDISCPENDENTES.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
			AND SHISTDISCPENDENTES.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
			AND SHISTDISCPENDENTES.RA = SHABILITACAOALUNO.RA
		INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
			AND SALUNO.RA = SHABILITACAOALUNO.RA
		INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA
		INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA
			AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
			AND SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
		INNER JOIN SMATRICPL ON
			SMATRICPL.RA = SHABILITACAOALUNO.RA
			AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
		INNER JOIN SMODALIDADECURSO (NOLOCK) ON
			SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA
			AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
	WHERE
		SHABILITACAOALUNO.CODSTATUS = 19 /*STATUS NO CURSO CURSANDO*/
		AND (SHISTDISCPENDENTES.CODSTATUS <> 19 OR SHISTDISCPENDENTES.CODSTATUS IS NULL) /*STATUS CURSANDO NA DISCIPLINA*/
		AND SMATRICPL.CODSTATUS IN (12, 101, 111)
		AND SALUNO.RA = 2015111138--2018210116
ORDER BY ALUNO, PERIODO
