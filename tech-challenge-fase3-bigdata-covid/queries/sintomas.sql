with 
--B001 
  -- CTE para sintomas semana anterior
sintomas_semana_anterior AS (
  SELECT
    DB.ANO,
    DB.MES,
    SUM(IF(CAST(DB.B0011 AS INT64) = 1, 1, 0)) AS `Febre`,
    SUM(IF(CAST(DB.B0012 AS INT64) = 1, 1, 0)) AS `Tosse`,
    SUM(IF(CAST(DB.B0013 AS INT64) = 1, 1, 0)) AS `Dor_de_garganta`,
    SUM(IF(CAST(DB.B0014 AS INT64) = 1, 1, 0)) AS `Dificuldade_para_respirar`,
    SUM(IF(CAST(DB.B0015 AS INT64) = 1, 1, 0)) AS `Dor_de_cabeca`,
    SUM(IF(CAST(DB.B0016 AS INT64) = 1, 1, 0)) AS `Dor_no_peito`,
    SUM(IF(CAST(DB.B0017 AS INT64) = 1, 1, 0)) AS `Nausea_enjoo`,
    SUM(IF(CAST(DB.B0018 AS INT64) = 1, 1, 0)) AS `Nariz_entupido_ou_escorrendo`,
    SUM(IF(CAST(DB.B0019 AS INT64) = 1, 1, 0)) AS `Fadiga_cansaco`,
    SUM(IF(CAST(DB.B00110 AS INT64) = 1, 1, 0)) AS `Dor_nos_olhos`,
    SUM(IF(CAST(DB.B00111 AS INT64) = 1, 1, 0)) AS `Perda_de_cheiro_ou_de_sabor`,
    SUM(IF(CAST(DB.B00112 AS INT64) = 1, 1, 0)) AS `Dor_muscular_dor_no_corpo`,
    SUM(IF(CAST(DB.B00113 AS INT64) = 1, 1, 0)) AS `Diarreia`,
    ROUND((SUM(IF(CAST(DB.B0011 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Febre_percentual`,
    ROUND((SUM(IF(CAST(DB.B0012 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Tosse_percentual`,
    ROUND((SUM(IF(CAST(DB.B0013 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Dor_de_garganta_percentual`,
    ROUND((SUM(IF(CAST(DB.B0014 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Dificuldade_para_respirar_percentual`,
    ROUND((SUM(IF(CAST(DB.B0015 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Dor_de_cabeca_percentual`,
    ROUND((SUM(IF(CAST(DB.B0016 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Dor_no_peito_percentual`,
    ROUND((SUM(IF(CAST(DB.B0017 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Nausea_enjoo_percentual`,
    ROUND((SUM(IF(CAST(DB.B0018 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Nariz_entupido_ou_escorrendo_percentual`,
    ROUND((SUM(IF(CAST(DB.B0019 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Fadiga_cansaco_percentual`,
    ROUND((SUM(IF(CAST(DB.B00110 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Dor_nos_olhos_percentual`,
    ROUND((SUM(IF(CAST(DB.B00111 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Perda_de_cheiro_ou_de_sabor_percentual`,
    ROUND((SUM(IF(CAST(DB.B00112 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Dor_muscular_dor_no_corpo_percentual`,
    ROUND((SUM(IF(CAST(DB.B00113 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Diarreia_percentual`
  FROM 
    basedosdados.br_ibge_pnad_covid.microdados AS DB 
  WHERE   
    (CAST(DB.B0011 AS INT64) = 1 OR CAST(DB.B0012 AS INT64) = 1 OR CAST(DB.B0013 AS INT64) = 1 OR
     CAST(DB.B0014 AS INT64) = 1 OR CAST(DB.B0015 AS INT64) = 1 OR CAST(DB.B0016 AS INT64) = 1 OR
     CAST(DB.B0017 AS INT64) = 1 OR CAST(DB.B0018 AS INT64) = 1 OR CAST(DB.B0019 AS INT64) = 1 OR
     CAST(DB.B00110 AS INT64) = 1 OR CAST(DB.B00111 AS INT64) = 1 OR CAST(DB.B00112 AS INT64) = 1 OR
     CAST(DB.B00113 AS INT64) = 1)
    AND DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
  GROUP BY 
    DB.ANO, DB.MES
),

-- B002
busca_atendimento_medico as (
        SELECT 
        DB.ANO,
        DB.MES,
        COUNT(CASE WHEN CAST(DB.B005 AS INT64) = 1 THEN 1 END) AS qtd_busca_atendimento_medico,
        COUNT(CASE WHEN CAST(DB.B005 AS INT64) = 2 THEN 1 END) AS qtd_nao_busca_atendimento_medico,
        ROUND((SUM(IF(CAST(DB.B002 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS perc_populacao_internada
        
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB 
    WHERE   
        CAST(DB.B002 AS INT64) IN (1, 2)
        AND DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO,DB.MES
),

--B003
    
   medidas_tomadas as ( 
    
    SELECT 
        DB.ANO,
        DB.MES,
        -- FICAR EM CASA
         COUNT(CASE WHEN CAST(DB.B0031 AS INT64) = 1 THEN 1 END) AS qtd_ficou_em_casa
        ,COUNT(CASE WHEN CAST(DB.B0031 AS INT64) = 2 THEN 1 END) AS qtd_nao_ficou_em_casa

        -- LIGAR PRA UM PROFISSIONAL DA SAUDE
        ,COUNT(CASE WHEN CAST(DB.B0032 AS INT64) = 1 THEN 1 END) AS qtd_ligou_profissional_saude
        ,COUNT(CASE WHEN CAST(DB.B0032 AS INT64) = 2 THEN 1 END) AS qtd_nao_ligou_profissional_saude

        -- REMEDIO POR CONTA PROPRIA
        ,COUNT(CASE WHEN CAST(DB.B0033 AS INT64) = 1 THEN 1 END) AS qtd_remedio_conta_propria
        ,COUNT(CASE WHEN CAST(DB.B0033 AS INT64) = 2 THEN 1 END) AS qtd_nao_remedio_conta_propria


        -- REMEDIO POR ORIENTAÇAO MEDICA
        ,COUNT(CASE WHEN CAST(DB.B0034 AS INT64) = 1 THEN 1 END) AS qtd_remedio_orientacao_medica
        ,COUNT(CASE WHEN CAST(DB.B0034 AS INT64) = 2 THEN 1 END) AS qtd_nao_remedio_orientacao_medica

        -- RECEBEU VISITA DO PROFISSIONAL DO SUS
        ,COUNT(CASE WHEN CAST(DB.B0035 AS INT64) = 1 THEN 1 END) AS qtd_recebeu_visita_profissional_sus
        ,COUNT(CASE WHEN CAST(DB.B0035 AS INT64) = 2 THEN 1 END) AS qtd_nao_recebeu_visita_profissional_sus
        
        -- RECEBEU VISITA DE PROFISSIONAL DA SAUDE PARTICULAR
        ,COUNT(CASE WHEN CAST(DB.B0036 AS INT64) = 1 THEN 1 END) AS qtd_recebeu_visita_profissional_particular
        ,COUNT(CASE WHEN CAST(DB.B0036 AS INT64) = 2 THEN 1 END) AS qtd_nao_recebeu_visita_profissional_particular

        -- OUTRA PROVIDENCIA
        ,COUNT(CASE WHEN CAST(DB.B0037 AS INT64) = 1 THEN 1 END) AS qtd_tomou_outra_previdencia
        ,COUNT(CASE WHEN CAST(DB.B0037 AS INT64) = 2 THEN 1 END) AS qtd_nao_tomou_outra_previdencia

    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB 
    WHERE
        CAST(DB.B0031 AS INT64) IN (1, 2)
        OR CAST(DB.B0032 AS INT64) IN (1, 2)
        OR CAST(DB.B0033 AS INT64) IN (1, 2)
        OR CAST(DB.B0034 AS INT64) IN (1, 2)
        OR CAST(DB.B0035 AS INT64) IN (1, 2)
        OR CAST(DB.B0036 AS INT64) IN (1, 2)
        OR CAST(DB.B0037 AS INT64) IN (1, 2)
        AND DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO,DB.MES),


-- B004
locais_atendimento as (
    SELECT
        DB.ANO,
        DB.MES,
        count(*) as qtd_populacao_entrevistada,
        SUM(IF(CAST(DB.B0041 AS INT64) = 1, 1, 0)) AS `Posto_de_saude_outros`,
        SUM(IF(CAST(DB.B0042 AS INT64) = 1, 1, 0)) AS `PS_SUS_UPA`,
        SUM(IF(CAST(DB.B0043 AS INT64) = 1, 1, 0)) AS `Hospital_SUS`,
        SUM(IF(CAST(DB.B0044 AS INT64) = 1, 1, 0)) AS `Ambulatorio_forcas_armadas`,
        SUM(IF(CAST(DB.B0045 AS INT64) = 1, 1, 0)) AS `PS_forcas_armadas`,
        SUM(IF(CAST(DB.B0046 AS INT64) = 1, 1, 0)) AS `Hospital_forcas_armadas`,
        ROUND((SUM(IF(CAST(DB.B0041 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Posto_de_saude_outros_percent`,
        ROUND((SUM(IF(CAST(DB.B0042 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `PS_SUS_UPA_percent`,
        ROUND((SUM(IF(CAST(DB.B0043 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Hospital_SUS_percent`,
        ROUND((SUM(IF(CAST(DB.B0044 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Ambulatorio_forcas_armadas_percent`,
        ROUND((SUM(IF(CAST(DB.B0045 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `PS_forcas_armadas_percent`,
        ROUND((SUM(IF(CAST(DB.B0046 AS INT64) = 1, 1, 0)) / COUNT(*)) * 100, 2) AS `Hospital_forcas_armadas_percent`,
     FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB 
    WHERE
        DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO,DB.MES
),


-- B005 e B006
internacao as (
        SELECT 
        DB.ANO,
        DB.MES,
        COUNT(CASE WHEN CAST(DB.B005 AS INT64) = 1 THEN 1 END) AS qtd_populacao_atendida,
        COUNT(CASE WHEN CAST(DB.B005 AS INT64) = 3 THEN 1 END) AS qtd_populacao_nao_atendida,
        COUNT(CASE WHEN CAST(DB.B005 AS INT64) = 2 THEN 1 END) AS qtd_populacao_sem_necessidade_atendimento,
        COUNT(CASE WHEN CAST(DB.B006 AS INT64) = 1 THEN 1 END) AS qtd_dos_internados_precisaram_respiracao_artificial
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB 
    WHERE   
        CAST(DB.B005 AS INT64) IN (1, 2, 3)
        AND DB.ANO = 2020 AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO,DB.MES
),


-- B007
plano_saude as (
    SELECT 
        DB.ANO,
        DB.MES,
        COUNT(CASE WHEN CAST(DB.B007 AS INT64) = 1 THEN 1 END) AS qtd_com_plano_saude,
        COUNT(CASE WHEN CAST(DB.B007 AS INT64) = 2 THEN 1 END) AS qtd_sem_plano_saude
    FROM 
        basedosdados.br_ibge_pnad_covid.microdados DB 
    WHERE   
        CAST(DB.B007 AS INT64) IN (1, 2)
        AND DB.ANO = 2020
        AND DB.MES IN (5, 6, 7)
    GROUP BY 
        DB.ANO,
        DB.MES)




select
     ss.ANO
    ,ss.MES
    
    -- SINTOMAS SEMANAS ANTERIOR
    ,ss.Febre
    ,ss.Tosse
    ,ss.Dor_de_garganta
    ,ss.Dificuldade_para_respirar
    ,ss.Dor_de_cabeca
    ,ss.Dor_no_peito
    ,ss.Nausea_enjoo
    ,ss.Nariz_entupido_ou_escorrendo
    ,ss.Fadiga_cansaco
    ,ss.Dor_nos_olhos
    ,ss.Perda_de_cheiro_ou_de_sabor
    ,ss.Dor_muscular_dor_no_corpo
    ,ss.Diarreia
    ,ss.Febre_percentual
    ,ss.Tosse_percentual
    ,ss.Dor_de_garganta_percentual
    ,ss.Dificuldade_para_respirar_percentual
    ,ss.Dor_de_cabeca_percentual
    ,ss.Dor_no_peito_percentual
    ,ss.Nausea_enjoo_percentual
    ,ss.Nariz_entupido_ou_escorrendo_percentual
    ,ss.Fadiga_cansaco_percentual
    ,ss.Dor_nos_olhos_percentual
    ,ss.Perda_de_cheiro_ou_de_sabor_percentual
    ,ss.Dor_muscular_dor_no_corpo_percentual
    ,ss.Diarreia_percentual

    -- INTERNAÇÃO
    ,inter.qtd_populacao_atendida
    ,inter.qtd_populacao_nao_atendida
    ,inter.qtd_populacao_sem_necessidade_atendimento
    ,inter.qtd_dos_internados_precisaram_respiracao_artificial

    -- BUSCA ATENDIMENTO MÉDICO
    ,bam.qtd_busca_atendimento_medico
    ,bam.qtd_nao_busca_atendimento_medico
    ,bam.perc_populacao_internada

    -- MEDIDAS TOMADAS
    ,mt.qtd_ficou_em_casa
    ,mt.qtd_nao_ficou_em_casa
    ,mt.qtd_ligou_profissional_saude
    ,mt.qtd_nao_ligou_profissional_saude
    ,mt.qtd_remedio_conta_propria
    ,mt.qtd_nao_remedio_conta_propria
    ,mt.qtd_remedio_orientacao_medica
    ,mt.qtd_nao_remedio_orientacao_medica
    ,mt.qtd_recebeu_visita_profissional_sus
    ,mt.qtd_nao_recebeu_visita_profissional_sus
    ,mt.qtd_recebeu_visita_profissional_particular
    ,mt.qtd_nao_recebeu_visita_profissional_particular
    ,mt.qtd_tomou_outra_previdencia
    ,mt.qtd_nao_tomou_outra_previdencia

    -- LOCAIS DE ATENDIMENTO
    ,la.qtd_populacao_entrevistada
    ,la.Posto_de_saude_outros
    ,la.PS_SUS_UPA
    ,la.Hospital_SUS
    ,la.Ambulatorio_forcas_armadas
    ,la.PS_forcas_armadas
    ,la.Hospital_forcas_armadas
    ,la.Posto_de_saude_outros_percent
    ,la.PS_SUS_UPA_percent
    ,la.Hospital_SUS_percent
    ,la.Ambulatorio_forcas_armadas_percent
    ,la.PS_forcas_armadas_percent
    ,la.Hospital_forcas_armadas_percent

    -- PLANO DE SAUDE
    ,ps.qtd_com_plano_saude
    ,ps.qtd_sem_plano_saude

from sintomas_semana_anterior ss 
join plano_saude ps                                 on ps.MES = ss.MES and ps.ANO = ss.ANO
join busca_atendimento_medico bam                   on bam.MES = ss.MES and bam.ANO = ss.ANO
join medidas_tomadas mt                             on mt.MES = ss.MES and mt.ANO = ss.ANO
join internacao inter                               on inter.MES = ss.MES and inter.ANO = ss.ANO
join locais_atendimento la                          on la.MES = ss.MES and la.ANO = ss.ANO
WHERE ss.ANO = 2020 AND ss.MES IN (5, 6, 7)