WITH carga_horaria AS (
    -- Quantas horas, por semana, normalmente trabalhava?
    SELECT 
        DB.ANO,
        DB.MES,
        MIN(DB.c008) AS min_carga_horaria,
        MAX(DB.c008) AS max_carga_horaria,
        AVG(DB.c008) AS media_carga_horaria
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB
    WHERE
        DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO, DB.MES
),
faixas_carga_horaria AS (
    SELECT
        DB.ANO,
        DB.MES,
        CASE
            WHEN DB.c008 >= 1 AND DB.c008 <= 40 THEN '1-40 horas'
            WHEN DB.c008 > 40 AND DB.c008 <= 80 THEN '40-80 horas'
            WHEN DB.c008 > 80 AND DB.c008 <= 120 THEN '80-120 horas'
            ELSE 'Acima de 120 horas'
        END AS faixa_carga_horaria
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB
    WHERE
        DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
),
rendimentos AS (
    SELECT 
        DB.ANO,
        DB.MES,
        MIN(DB.C01012) AS min_rendimentos,
        MAX(DB.C01012) AS max_rendimentos,
        AVG(DB.C01012) AS avg_rendimentos,
        COUNT(DB.C01012) AS qtd_respondentes_rendimentos
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB
    WHERE
        DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO, DB.MES
),
inss AS (
    SELECT 
        DB.ANO,
        DB.MES,
        SUM(IF(DB.C014 = '1', 1, 0)) AS Contribuiu_inss,
        SUM(IF(DB.C014 = '2', 1, 0)) AS Nao_Contribuiu_inss,
        ROUND((SUM(IF(DB.C014 = '1', 1, 0)) / COUNT(*)) * 100, 2) AS Contribuiu_inss_percentual,
        ROUND((SUM(IF(DB.C014 = '2', 1, 0)) / COUNT(*)) * 100, 2) AS Nao_Contribuiu_inss_percentual
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB
    WHERE
        DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO, DB.MES
),
trabalho_semana_passada AS (
    SELECT 
        DB.ANO,
        DB.MES,
        SUM(IF(DB.C015 = '1', 1, 0)) AS Procurou_Trabalho,
        SUM(IF(DB.C015 = '2', 1, 0)) AS Nao_Procurou_Trabalho,
        ROUND((SUM(IF(DB.C015 = '1', 1, 0)) / COUNT(*)) * 100, 2) AS Procurou_Trabalho_percentual,
        ROUND((SUM(IF(DB.C015 = '2', 1, 0)) / COUNT(*)) * 100, 2) AS Nao_Procurou_Trabalho_percentual
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB
    WHERE
        DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO, DB.MES
),
auxilio_emergenciial AS (
    SELECT 
        DB.ANO,
        DB.MES,
        SUM(IF(DB.D0051 = '1', 1, 0)) AS Recebeu_Auxilio,
        SUM(IF(DB.D0051 = '2', 1, 0)) AS Nao_Recebeu_Auxilio,
        ROUND((SUM(IF(DB.D0051 = '1', 1, 0)) / COUNT(*)) * 100, 2) AS Recebeu_Auxilio_percentual,
        ROUND((SUM(IF(DB.D0051 = '2', 1, 0)) / COUNT(*)) * 100, 2) AS Nao_Recebeu_Auxilio_percentual
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB
    WHERE
        DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO, DB.MES
)

SELECT
    ch.ANO,
    ch.MES,
    ch.min_carga_horaria,
    ch.max_carga_horaria,
    ch.media_carga_horaria,
    COUNT(CASE WHEN fc.faixa_carga_horaria = '1-40 horas' THEN 1 END) AS faixa_1_40,
    COUNT(CASE WHEN fc.faixa_carga_horaria = '40-80 horas' THEN 1 END) AS faixa_40_80,
    COUNT(CASE WHEN fc.faixa_carga_horaria = '80-120 horas' THEN 1 END) AS faixa_80_120,
    r.min_rendimentos,
    r.max_rendimentos,
    r.avg_rendimentos,
    r.qtd_respondentes_rendimentos,
    i.Contribuiu_inss,
    i.Nao_Contribuiu_inss,
    i.Contribuiu_inss_percentual,
    i.Nao_Contribuiu_inss_percentual,
    t.Procurou_Trabalho,
    t.Nao_Procurou_Trabalho,
    t.Procurou_Trabalho_percentual,
    t.Nao_Procurou_Trabalho_percentual,
    a.Recebeu_Auxilio,
    a.Nao_Recebeu_Auxilio,
    a.Recebeu_Auxilio_percentual,
    a.Nao_Recebeu_Auxilio_percentual
FROM
    carga_horaria ch
JOIN
    faixas_carga_horaria fc ON fc.ANO = ch.ANO AND fc.MES = ch.MES
JOIN
    rendimentos r ON r.ANO = ch.ANO AND r.MES = ch.MES
JOIN
    inss i ON i.ANO = ch.ANO AND i.MES = ch.MES
JOIN
    trabalho_semana_passada t ON t.ANO = ch.ANO AND t.MES = ch.MES
JOIN
    auxilio_emergenciial a ON a.ANO = ch.ANO AND a.MES = ch.MES
GROUP BY
    ch.ANO, ch.MES, ch.min_carga_horaria, ch.max_carga_horaria, ch.media_carga_horaria,
    r.min_rendimentos, r.max_rendimentos, r.avg_rendimentos, r.qtd_respondentes_rendimentos,
    i.Contribuiu_inss, i.Nao_Contribuiu_inss, i.Contribuiu_inss_percentual, i.Nao_Contribuiu_inss_percentual,
    t.Procurou_Trabalho, t.Nao_Procurou_Trabalho, t.Procurou_Trabalho_percentual, t.Nao_Procurou_Trabalho_percentual,
    a.Recebeu_Auxilio, a.Nao_Recebeu_Auxilio, a.Recebeu_Auxilio_percentual, a.Nao_Recebeu_Auxilio_percentual