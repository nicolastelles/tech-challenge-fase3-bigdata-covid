SELECT 
    DB.ANO,
    DB.MES,
    COUNT(*) AS qtd_populacao_entrevistada,
    -- Trabalhou na semana passada?
    SUM(IF(DB.C001 = '1', 1, 0)) AS Trabalhando,
    SUM(IF(DB.C001 = '2', 1, 0)) AS Nao_trabalhando,

    -- Estava afastado do trabalho?
    SUM(IF(DB.C002 = '1', 1, 0)) AS Afastado_Trabalho,
    SUM(IF(DB.C002 = '2', 1, 0)) AS Nao_Afastado_Trabalho,

    -- MOTIVO DO AFASTAMENTO
    SUM(IF(DB.C003 = '1', 1, 0)) AS Motivo_Afastamento_Quarentena,
    SUM(IF(DB.C003 = '2', 1, 0)) AS Motivo_Afastamento_Ferias,
    SUM(IF(DB.C003 = '3', 1, 0)) AS Motivo_Afastamento_Licenca_Maternidade,
    SUM(IF(DB.C003 = '4', 1, 0)) AS Motivo_Afastamento_Licenca_Remunerada,
    SUM(IF(DB.C003 = '5', 1, 0)) AS Motivo_Afastamento_Outra_Licenca_Remunerada,
    SUM(IF(DB.C003 = '6', 1, 0)) AS Motivo_Afastamento_Proprio_Negocio,
    SUM(IF(DB.C003 = '7', 1, 0)) AS Motivo_Afastamento_Fatores_Ocasionais,
    SUM(IF(DB.C003 = '8', 1, 0)) AS Motivo_Afastamento_Outros,


    -- Mais de Um Emprego
    SUM(IF(DB.C006 = '1', 1, 0)) AS mais_de_um_emprego,

    -- Trabalhou no local habitual?
    SUM(IF(DB.C012 = '1', 1, 0)) AS Trabalhou_Local_Habitual,
    SUM(IF(DB.C012 = '2', 1, 0)) AS Nao_Trabalhou_Local_Habitual,

    -- Trabalhou em home office?
    SUM(IF(DB.C013 = '1', 1, 0)) AS Trabalhou_HomeOffice,
    SUM(IF(DB.C013 = '2', 1, 0)) AS Nao_Trabalhou_HomeOffice,


    
    ROUND((SUM(IF(DB.C001 = '1', 1, 0)) / COUNT(*)) * 100, 2) AS Trabalhando_percentual,
    ROUND((SUM(IF(DB.C001 = '2', 1, 0)) / COUNT(*)) * 100, 2) AS Nao_trabalhando_percentual,
    ROUND((SUM(IF(DB.C006 = '1', 1, 0)) / COUNT(*)) * 100, 2) AS mais_de_um_emprego_percentual
FROM 
    basedosdados.br_ibge_pnad_covid.microdados DB 
WHERE
    DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
GROUP BY 
    DB.ANO,
    DB.MES;