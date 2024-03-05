CREATE TABLE exames (
    cpf VARCHAR(14),
    "nome paciente" VARCHAR(255),
    "email paciente" VARCHAR(255),
    "data nascimento paciente" DATE,
    "endereço/rua paciente" VARCHAR(255),
    "cidade paciente" VARCHAR(100),
    "estado patiente" VARCHAR(20),
    "crm médico" VARCHAR(20),
    "crm médico estado" VARCHAR(20),
    "nome médico" VARCHAR(255),
    "email médico" VARCHAR(255),
    "token resultado exame" VARCHAR(255),
    "data exame" DATE,
    "tipo exame" VARCHAR(255),
    "limites tipo exame" VARCHAR(255),
    "resultado tipo exame" VARCHAR(255)
);