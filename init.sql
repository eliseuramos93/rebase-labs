CREATE TABLE exames (
    cpf VARCHAR(14),
    nome_paciente VARCHAR(255),
    email_paciente VARCHAR(255),
    data_nascimento_paciente DATE,
    endereco_paciente VARCHAR(255),
    cidade_paciente VARCHAR(100),
    estado_paciente VARCHAR(20),
    crm_medico VARCHAR(20),
    crm_medico_estado VARCHAR(20),
    nome_medico VARCHAR(255),
    email_medico VARCHAR(255),
    token_resultado_exame VARCHAR(255),
    data_exame DATE,
    tipo_exame VARCHAR(255),
    limites_tipo_exame VARCHAR(255),
    resultado_tipo_exame VARCHAR(255)
);