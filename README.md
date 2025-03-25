# Tech Challenge - Fase 3

## 📌 Descrição do Desafio

Este projeto tem como objetivo analisar o comportamento da população durante a pandemia da COVID-19, utilizando os microdados da **PNAD-COVID19** do IBGE. O foco é identificar indicadores relevantes que possam auxiliar um grande hospital no planejamento de ações em caso de novos surtos da doença.

## 📊 Estruturação do Banco de Dados

Os dados foram organizados no **Google BigQuery**, permitindo análises eficientes e escaláveis. A modelagem do banco seguiu os seguintes princípios:
- Seleção de **20 perguntas** da pesquisa PNAD-COVID19, conforme os requisitos do desafio.
- **Limitação de 3 meses de dados** para manter a análise focada e gerenciável.
    > Maio, Junho e Julho

- Criação de tabelas otimizadas para facilitar consultas e agregações.

## ❓ Perguntas Selecionadas

Foram escolhidas 20 perguntas, divididas em três categorias principais:

### **1️⃣ Caracterização dos sintomas clínicos da população**
- **B1** – Sintomas apresentados na semana anterior.
- **B2** – Busca por atendimento médico. (Por causa disso, foi a algum estabelecimento de saude?)
- **B3** – Medidas tomadas para recuperação.
- **B4** – Locais de atendimento procurados.
- **B5** – Necessidade de internação.
- **B6** – Necessidade de ventilação mecânica/intubação.
- **B7** – Possui plano de saúde?

### **2️⃣ Comportamento da população na época da COVID-19**
- **C1** – Trabalhou na semana passada?
- **C2** – Estava afastado do trabalho?
- **C3** – Motivo do afastamento.
- **C12** – Trabalhou no local habitual?
- **C13** – Trabalhou em home office?

### **3️⃣ Características econômicas da sociedade**
- **C7** – Tipo de ocupação (empregado, autônomo, empresário etc.).
- **C8** – Carga horária semanal.
- **C01012** – Rendimento normal do trabalho.
- **C14** – Contribuição para o INSS.
- **C15** – Procurou trabalho na semana passada?
- **D1e** – Recebeu auxílio emergencial?

## 📌 Próximos Passos

- **Ingestão de Dados:** Configuração e importação dos microdados no **Google BigQuery**.
- **Limpeza e Preparação:** Tratamento de dados ausentes e estruturação das tabelas.
- **Análises Exploratórias:** Geração de estatísticas descritivas e gráficos.
- **Geração de Insights:** Identificação de padrões e recomendações para o hospital.

---
🚀 **Vamos ao desenvolvimento!**
