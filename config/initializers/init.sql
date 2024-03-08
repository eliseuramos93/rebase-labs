SET client_min_messages=WARNING;

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

CREATE TABLE IF NOT EXISTS patients (
    id SERIAL NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL NOT NULL UNIQUE,
    crm VARCHAR(20) NOT NULL UNIQUE,
    crm_state VARCHAR(20) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS examinations (
    id SERIAL NOT NULL UNIQUE,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    result_token VARCHAR(255) NOT NULL UNIQUE,
    date DATE NOT NULL
);

ALTER TABLE examinations
ADD CONSTRAINT fk_patient_id 
FOREIGN KEY (patient_id) 
REFERENCES patients(id)
ON DELETE CASCADE;

ALTER TABLE examinations
ADD CONSTRAINT fk_doctor_id
FOREIGN KEY (doctor_id)
REFERENCES doctors(id)
ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS tests (
    id SERIAL NOT NULL UNIQUE,
    examination_id INTEGER NOT NULL,
    type VARCHAR(255) NOT NULL,
    limits VARCHAR(255) NOT NULL,
    results VARCHAR(255) NOT NULL
);

ALTER TABLE tests
ADD CONSTRAINT fk_examination_id
FOREIGN KEY (examination_id)
REFERENCES examinations(id)
ON DELETE CASCADE;
