DROP DATABASE IF EXISTS ClinicaOdontoDB;

CREATE DATABASE ClinicaOdontoDB 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE ClinicaOdontoDB;

-- CRIANDO AS TABELAS 

-- PACIENTE
CREATE TABLE PACIENTE (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(255),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_cpf_paciente 
    CHECK (cpf REGEXP '^[0-9]{3}\\.[0-9]{3}\\.[0-9]{3}-[0-9]{2}$')
);

-- TABELA DENTISTA
CREATE TABLE DENTISTA (
    id_dentista INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100) NOT NULL, cro VARCHAR(20) UNIQUE NOT NULL,
    especialidade ENUM('Ortodontista', 'Endodontista', 'Periodontista', 'Implantodontista', 'Odontopediatra', 'Cirurgiao-dentista',
	'Protesista', 'Cirurgiao Bucomaxilofacial') NOT NULL, telefone VARCHAR(15) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, data_admissao DATE NOT NULL,
	status ENUM('Ativo', 'Inativo', 'Licenca') DEFAULT 'Ativo'
);

-- FUNCIONARIO
CREATE TABLE FUNCIONARIO (id_funcionario INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(100) NOT NULL, cpf VARCHAR(14) UNIQUE NOT NULL,
cargo ENUM('Recepcionista', 'Assistente Dental', 'Higienista', 'Auxiliar Administrativo', 'Gerente', 'Tecnico de Radiologia') NOT NULL,
telefone VARCHAR(15) NOT NULL, salario DECIMAL(10,2) NOT NULL, data_admissao DATE NOT NULL, CONSTRAINT chk_salario_positivo CHECK (salario > 0)
);

-- SALA
CREATE TABLE SALA (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,
    numero_sala VARCHAR(10) UNIQUE NOT NULL,
    tipo_sala ENUM('Consultorio','Sala de Cirurgia','Raio-X','Esterilizacao','Sala de Espera') NOT NULL,
    status ENUM('Disponivel','Em Uso','Manutencao') DEFAULT 'Disponivel'
);

-- TRATAMENTO
CREATE TABLE TRATAMENTO (
    id_tratamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_tratamento VARCHAR(100) NOT NULL,
    descricao TEXT,
    valor_base DECIMAL(10,2) NOT NULL,
    duracao_media_minutos INT NOT NULL,
    CONSTRAINT chk_valor_base CHECK (valor_base >= 0)
);

-- PRONTUARIO
CREATE TABLE PRONTUARIO (
    id_prontuario INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL UNIQUE,
    diagnostico TEXT,
    alergias TEXT,
    observacoes TEXT,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- AGENDAMENTO

CREATE TABLE AGENDAMENTO (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY, data_agendada DATE NOT NULL,
    hora_agendada TIME NOT NULL,
    status ENUM('Confirmado','Pendente','Cancelado','Realizado','Nao Compareceu') DEFAULT 'Pendente',
    id_paciente INT NOT NULL,
    id_dentista INT NOT NULL,
    id_sala INT NOT NULL,
    id_funcionario INT NOT NULL,

    FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente),
    FOREIGN KEY (id_dentista) REFERENCES DENTISTA(id_dentista),
    FOREIGN KEY (id_sala) REFERENCES SALA(id_sala),
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario),

    UNIQUE KEY uk_agendamento (data_agendada, hora_agendada, id_dentista, id_sala)
);

-- CONSULTA
CREATE TABLE CONSULTA (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    data_consulta DATE NOT NULL,
    horario TIME NOT NULL,
    status ENUM('Agendada','Em Andamento','Finalizada','Cancelada') DEFAULT 'Agendada',
    observacoes TEXT,
    id_paciente INT NOT NULL,
    id_dentista INT NOT NULL,

    FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente),
    FOREIGN KEY (id_dentista) REFERENCES DENTISTA(id_dentista)
);

-- CONSULTA_TRATAMENTO

CREATE TABLE CONSULTA_TRATAMENTO (
    id_consulta INT,
    id_tratamento INT,
    quantidade INT DEFAULT 1,
    valor_aplicado DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_consulta, id_tratamento),

    FOREIGN KEY (id_consulta) REFERENCES CONSULTA(id_consulta)
    ON DELETE CASCADE,

    FOREIGN KEY (id_tratamento) REFERENCES TRATAMENTO(id_tratamento),

    CONSTRAINT chk_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_valor_aplicado CHECK (valor_aplicado >= 0)
);


-- PAGAMENTO
CREATE TABLE PAGAMENTO (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento ENUM('Dinheiro','Cartao Credito','Cartao Debito','Pix','Convenio') NOT NULL,
    data_pagamento DATE NOT NULL,
    id_consulta INT NOT NULL,

    FOREIGN KEY (id_consulta) REFERENCES CONSULTA(id_consulta),
    CONSTRAINT chk_valor_pagamento CHECK (valor > 0)


) COMMENT = 'Pagamentos realizados por consulta';

-- ADICIONANDO OS DADOS DAS RESPECTIVAS TABELAS 

-- PACIENTES
INSERT INTO PACIENTE (nome, data_nascimento, cpf, telefone, email, endereco) VALUES
('João Silva Santos', '1985-03-15', '981.987.739-51', '(81) 98765-4321', 'joao.silva@gmail.com', 'Rua da Aurora, 123 - Boa Vista - Recife/PE'),
('Maria Oliveira Souza', '1992-07-22', '234.567.890-12', '(81) 99876-5432', 'maria.oliveira@email.com', 'Av. Boa Viagem, 1500 - Boa Viagem - Recife/PE'),
('Pedro Costa Lima', '1978-11-05', '345.678.901-23', '(81) 97654-3210', 'pedro.costa@email.com', 'Rua do Sol, 456 - Carmo - Olinda/PE'),
('Ana Beatriz Mendes', '2000-01-30', '456.789.012-34', '(81) 96543-2109', 'ana.mendes@email.com', 'Rua do Futuro, 789 - Graças - Recife/PE'),
('Carlos Eduardo Rocha', '1989-06-12', '567.890.123-45', '(81) 95432-1098', 'carlos.rocha@email.com', 'Av. Conselheiro Aguiar, 234 - Pina - Recife/PE'),
('Juliana Ferreira Costa', '1995-04-18', '678.901.234-56', '(81) 94321-0987', 'juliana.ferreira@email.com', 'Rua 13 de Maio, 567 - Varadouro - Olinda/PE'),
('Roberto Almeida Nunes', '1982-09-25', '789.012.345-67', '(81) 93210-9876', 'roberto.almeida@email.com', 'Av. Cruz Cabugá, 890 - Santo Amaro - Recife/PE'),
('Rodrigo Alves Correia', '1987-04-12', '148.259.360-12', '(81) 97654-3210', 'rodrigo.correia@gmail.com', 'Rua Benfica, 432 - Madalena - Recife/PE'),
('Aline Souza Guimarães', '1993-08-25', '259.360.471-23', '(81) 98765-1234', 'aline.guimaraes@hotmail.com', 'Av. Getúlio Vargas, 120 - Centro - Paulista/PE'),
('Ricardo Melo Peixoto', '1980-12-03', '360.471.582-34', '(81) 97531-8642', 'ricardo.peixoto@outlook.com', 'Rua do Amparo, 55 - Amparo - Olinda/PE'),
('Juliana Frota de Alencar', '1995-02-14', '471.582.693-45', '(81) 98422-9753', 'juliana.alencar@gmail.com', 'Rua da Harmonia, 88 - Casa Amarela - Recife/PE'),
('Gabriel Nunes Fagundes', '1989-06-29', '582.693.804-56', '(81) 99111-2233', 'gabriel.fagundes@yahoo.com.br', 'Av. Norte, 3210 - Casa Amarela - Recife/PE'),
('Camila Viana Vasconcelos', '1991-10-10', '693.804.915-67', '(81) 98877-1122', 'camila.viana@gmail.com', 'Rua Prudente de Morais, 45 - Jardim Paulista - Paulista/PE'),
('Lucas Carvalho de Oliveira', '1997-01-05', '804.915.026-78', '(81) 98123-4567', 'lucas.carvalho@gmail.com', 'Av. Caxangá, 405 - Cordeiro - Recife/PE'),
('Letícia Rocha Miranda', '1984-05-19', '915.026.137-89', '(81) 99654-8899', 'leticia.miranda@hotmail.com', 'Rua da Aurora, 77 - Boa Vista - Recife/PE'),
('Matheus Costa de Andrade', '2001-09-22', '026.137.248-90', '(81) 98711-5544', 'matheus.andrade@outlook.com', 'Rua Real da Torre, 1500 - Torre - Recife/PE'),
('Beatriz Mendes Nogueira', '1994-03-08', '137.248.359-01', '(81) 99222-3344', 'beatriz.mendes@gmail.com', 'Rua dos Navegantes, 204 - Boa Viagem - Recife/PE'),
('Thiago Barbosa da Silva', '1986-07-17', '248.359.460-12', '(81) 98444-7788', 'thiago.barbosa@yahoo.com', 'Av. Agamenon Magalhães, 99 - Derby - Recife/PE'),
('Larissa Antunes Meireles', '1998-11-30', '359.460.571-23', '(81) 99988-7766', 'larissa.meireles@gmail.com', 'Av. Cláudio Gueiros, 400 - Janga - Paulista/PE'),
('Felipe Teixeira de Souza', '1983-02-27', '460.571.682-34', '(81) 98811-9900', 'felipe.souza@hotmail.com', 'Rua de São Bento, 18 - Varadouro - Olinda/PE'),
('Amanda Pinheiro de Castro', '1990-06-11', '571.682.793-45', '(81) 98112-2334', 'amanda.castro@gmail.com', 'Av. Recife, 820 - Areias - Recife/PE'),
('Bruno Cardoso de Freitas', '1985-09-04', '682.793.904-56', '(81) 99411-5522', 'bruno.freitas@outlook.com', 'Rua do Hospício, 12 - Boa Vista - Recife/PE'),
('Mariana Xavier Linhares', '1996-12-15', '793.904.015-67', '(81) 98223-4455', 'mariana.linhares@gmail.com', 'Av. Rio Doce, 1400 - Rio Doce - Olinda/PE'),
('Daniel Borges Fontes', '1979-05-24', '904.015.126-78', '(81) 99145-6677', 'daniel.fontes@yahoo.com.br', 'Rua Imperial, 312 - São José - Recife/PE'),
('Isabela Ramos Junqueira', '1992-01-18', '015.126.237-89', '(81) 99766-1122', 'isabela.junqueira@gmail.com', 'Av. Beira Mar, 50 - Pau Amarelo - Paulista/PE'),
('Gustavo Neves de Almeida', '1988-08-07', '126.237.348-90', '(81) 98844-3311', 'gustavo.almeida@hotmail.com', 'Rua Domingos Ferreira, 24 - Boa Viagem - Recife/PE'),
('Fernanda Couto de Barros', '1999-03-26', '237.348.459-01', '(81) 99122-8899', 'fernanda.barros@gmail.com', 'Av. Boa Viagem, 410 - Boa Viagem - Recife/PE'),
('André Freire de Moraes', '1982-10-14', '348.459.560-12', '(81) 99933-4455', 'andre.moraes@outlook.com', 'Rua José Bonifácio, 1105 - Carmo - Olinda/PE'),
('Caroline Guimarães Ortiz', '1994-07-01', '459.560.671-23', '(81) 98144-7788', 'caroline.ortiz@gmail.com', 'Rua da Saudade, 18 - Santo Antônio - Recife/PE'),
('Renan Sales Cavalcanti', '1981-11-20', '560.671.782-34', '(81) 98755-2233', 'renan.cavalcanti@yahoo.com', 'Rua da União, 92 - Boa Vista - Recife/PE'),
('Patrícia Azevedo Malta', '1993-04-13', '671.782.893-45', '(81) 99611-4455', 'patricia.malta@gmail.com', 'Av. Conde da Boa Vista, 460 - Boa Vista - Recife/PE'),
('Diego Valente Pires', '1986-09-09', '782.893.904-56', '(81) 98422-3366', 'diego.pires@hotmail.com', 'Rua Padre Roma, 1820 - Tamarineira - Recife/PE'),
('Natália Montenegro Leite', '1997-02-28', '893.904.015-67', '(81) 99255-7788', 'natalia.leite@gmail.com', 'Rua da Moeda, 14 - Recife Antigo - Recife/PE'),
('Sandro Miranda de Assis', '1978-06-05', '804.015.126-78', '(81) 98166-0011', 'sandro.assis@outlook.com', 'Av. Ayrton Senna, 845 - Piedade - Jaboatão dos Guararapes/PE'),
('Vanessa Cordeiro Novaes', '1995-10-21', '815.126.237-89', '(81) 99977-2233', 'vanessa.novaes@gmail.com', 'Rua Belém de São Francisco, 290 - Timbi - Camaragibe/PE'),
('Vitor Hugo Peixoto Filho', '1990-12-12', '826.237.348-90', '(81) 98833-4411', 'vitor.filho@yahoo.com.br', 'Av. Ministro Marcos Freire, 1200 - Janga - Paulista/PE'),
('Priscila Toledo Prado', '1992-05-16', '837.348.459-01', '(81) 99144-8855', 'priscila.prado@gmail.com', 'Rua do Bom Jesus, 530 - Recife Antigo - Recife/PE'),
('Leonardo Assis de Franco', '1984-03-24', '848.459.560-12', '(81) 98455-6622', 'leonardo.franco@hotmail.com', 'Av. Guararapes, 2100 - Santo Antônio - Recife/PE'),
('Tatiane Diniz Junqueira', '1996-07-07', '849.560.671-23', '(81) 99122-4499', 'tatiane.junqueira@gmail.com', 'Rua do Lima, 330 - Santo Amaro - Recife/PE'),
('Marcelo Malta da Silveira', '1985-01-30', '860.671.782-34', '(81) 98133-7744', 'marcelo.silveira@outlook.com', 'Rua da Concórdia, 105 - São José - Recife/PE'),
('Milena Moura Albuquerque', '1993-09-14', '871.782.893-45', '(81) 99744-8811', 'milena.albuquerque@gmail.com', 'Rua Manoel Borba, 14 - Bairro Novo - Olinda/PE'),
('Eduardo Valente Ferraz', '1982-11-02', '882.893.904-56', '(81) 98455-1133', 'eduardo.ferraz@yahoo.com', 'Rua Visconde de Suassuna, 3000 - Santo Amaro - Recife/PE'),
('Jéssica Lopes Pires', '1991-06-21', '893.904.015-97', '(81) 99166-2255', 'jessica.pires@gmail.com', 'Av. Bernardo Vieira de Melo, 1500 - Candeias - Jaboatão dos Guararapes/PE'),
('Roberto Xavier Amaral', '1977-10-18', '704.026.126-78', '(81) 98877-3344', 'roberto.amaral@hotmail.com', 'Rua da Matriz, 420 - Centro - Paulista/PE'),
('Gabriela Cordeiro Ramos', '1998-04-09', '715.126.237-89', '(81) 99911-5566', 'gabriela.ramos@gmail.com', 'Av. Sigismundo Gonçalves, 850 - Carmo - Olinda/PE'),
('Sérgio Meireles Justo', '1983-08-27', '726.237.348-90', '(81) 98122-6677', 'sergio.justo@outlook.com', 'Rua Sete de Setembro, 1230 - Casa Forte - Recife/PE'),
('Julio Cesar Fagundes Neto', '1988-02-11', '737.348.459-01', '(81) 99733-4411', 'julio.neto@gmail.com', 'Rua do Bonfim, 45 - Carmo - Olinda/PE'),
('Amanda Passos Barreto', '1994-05-19', '748.459.560-12', '(81) 98411-9988', 'amanda.barreto@yahoo.com.br', 'Av. Doutor Belmino Correia, 120 - Timbi - Camaragibe/PE'),
('Ricardo Franco da Rocha', '1981-12-25', '759.560.671-23', '(81) 99155-2244', 'ricardo.rocha@gmail.com', 'Rua Capitão Lima, 700 - Santo Amaro - Recife/PE'),
('Fernanda Rezende Ortiz', '1992-07-06', '760.671.782-34', '(81) 98844-1188', 'fernanda.ortiz@hotmail.com', 'Rua do Riachuelo, 210 - Boa Vista - Recife/PE');

-- DENTISTAS
INSERT INTO DENTISTA (nome, cro, especialidade, telefone, email, data_admissao) VALUES
('Rafael Mendes Brahmer', 'PE10234', 'Ortodontista', '(81) 98124-5501', 'rafael.brahmer@gmail.com', '2020-01-15'),
('Fernanda Alves Coutinho', 'PE10235', 'Endodontista', '(81) 98235-6612', 'fernanda.coutinho@gmail.com', '2019-03-20'),
('Lucas Henrique Moraes', 'PE10236', 'Implantodontista', '(81) 98346-7723', 'lucas.moraes@gmail.com', '2021-07-11'),
('Amanda Ribeiro Costa', 'PE10237', 'Odontopediatra', '(81) 98457-8834', 'amanda.costa@gmail.com', '2018-05-09'),
('Thiago Barbosa Freire', 'PE10238', 'Periodontista', '(81) 98568-9945', 'thiago.freire@gmail.com', '2022-02-14'),
('Juliana Mendes Rocha', 'PE10239', 'Ortodontista', '(81) 98679-1156', 'juliana.rocha@gmail.com', '2020-11-01'),
('Carlos Eduardo Lima', 'PE10240', 'Cirurgião-dentista', '(81) 98780-2267', 'carlos.lima@gmail.com', '2017-08-18'),
('Beatriz Monteiro Alves','PE10241', 'Endodontista', '(81) 98891-3378', 'beatriz.alves@gmail.com', '2021-09-27'),
('Ricardo Nunes Silva', 'PE10242', 'Implantodontista', '(81) 98902-4489', 'ricardo.silva@gmail.com', '2019-12-03'),
('Larissa Antunes Melo', 'PE10243', 'Odontopediatra', '(81) 98113-5590', 'larissa.melo@gmail.com', '2023-01-10'),
('Felipe Andrade Souza', 'PE10244', 'Periodontista', '(81) 98224-6601', 'felipe.souza@gmail.com', '2018-04-22'),
('Camila Fernandes Ramos','PE10245', 'Ortodontista', '(81) 98335-7712', 'camila.ramos@gmail.com', '2022-06-17'),
('Eduardo Cavalcanti Lima', 'PE10246', 'Cirurgião-dentista', '(81) 98446-8823', 'eduardo.lima@gmail.com', '2020-10-05'),
('Vanessa Ribeiro Costa', 'PE10247', 'Endodontista', '(81) 98557-9934', 'vanessa.costa@gmail.com', '2019-01-29'),
('Gabriel Santos Oliveira', 'PE10248', 'Implantodontista', '(81) 98668-1145', 'gabriel.oliveira@gmail.com', '2021-03-13'),
('Patrícia Gomes Andrade', 'PE10249', 'Odontopediatra', '(81) 98779-2256', 'patricia.andrade@gmail.com', '2017-11-08'),
('Matheus Cavalcanti Rocha', 'PE10250', 'Periodontista', '(81) 98880-3367', 'matheus.rocha@gmail.com', '2022-08-25'),
('Natália Souza Moura', 'PE10251', 'Ortodontista', '(81) 98991-4478', 'natalia.moura@gmail.com', '2020-05-14'),
('Diego Valente Pires', 'PE10252', 'Cirurgião-dentista', '(81) 98102-5589', 'diego.pires@gmail.com', '2018-09-30'),
('Tatiane Diniz Junqueira', 'PE10253', 'Endodontista', '(81) 98213-6690', 'tatiane.junqueira@gmail.com', '2021-12-12'),
('Bruno Cardoso Freitas', 'PE10254', 'Implantodontista', '(81) 98324-7701', 'bruno.freitas@gmail.com', '2019-06-06'),
('Priscila Toledo Prado', 'PE10255', 'Odontopediatra', '(81) 98435-8812', 'priscila.prado@gmail.com', '2023-02-19'),
('Leonardo Assis Franco', 'PE10256', 'Protesista', '(81) 98546-9923', 'leonardo.franco@gmail.com', '2017-03-28'),
('Marcela Freire Costa', 'PE10257', 'Protesista', '(81) 98657-1134', 'marcela.costa@gmail.com', '2022-07-07'),
('Henrique Freitas Silva', 'PE10258', 'Cirurgião Bucomaxilofacial', '(81) 98768-2245', 'henrique.silva@gmail.com', '2020-04-16'),
('Raquel Nogueira Costa', 'PE10259', 'Cirurgião Bucomaxilofacial', '(81) 98879-3356', 'raquel.costa@gmail.com', '2018-10-21'),
('Otávio Rocha Santos', 'PE10260', 'Cirurgião Bucomaxilofacial', '(81) 98990-4467', 'otavio.santos@gmail.com', '2021-01-31'),
('Cláudia Mendes Freire', 'PE10261', 'Cirurgião Bucomaxilofacial', '(81) 98155-7732', 'claudia.freire@gmail.com', '2019-05-18');

-- FUNCIONARIOS
INSERT INTO FUNCIONARIO (nome, cpf, cargo, telefone, salario, data_admissao) VALUES
('Marcos Vinicius Almeida', '847.521.396-14', 'Recepcionista', '(81) 97214-5831', 1800.00, '2022-01-10'),
('Juliana Ferreira Costa', '193.684.275-90', 'Assistente Dental', '(81) 98145-2276', 2200.00, '2021-03-15'),
('Carlos Eduardo Lima', '562.903.174-28', 'Higienista', '(81) 97488-6512', 2100.00, '2020-07-21'),
('Amanda Souza Rocha', '731.458.296-05', 'Auxiliar Administrativo', '(81) 98321-7745', 2500.00, '2019-11-05'),
('Fernanda Alves Mendes', '248.795.613-47', 'Gerente', '(81) 97954-1182', 4500.00, '2018-04-12'),
('Ricardo Nunes Silva', '915.372.864-19', 'Técnico de Radiologia', '(81) 98763-2401', 3200.00, '2022-08-09'),
('Patrícia Gomes Andrade', '604.281.753-66', 'Recepcionista', '(81) 97135-8824', 1800.00, '2023-01-17'),
('Lucas Barbosa Freire', '382.614.905-31', 'Assistente Dental', '(81) 98442-1607', 2200.00, '2021-09-22'),
('Beatriz Monteiro Lima', '759.103.842-57', 'Higienista', '(81) 97309-5541', 2100.00, '2020-02-14'),
('Thiago Cardoso Melo', '421.896.537-80', 'Auxiliar Administrativo', '(81) 98277-4930', 2500.00, '2019-05-30'),
('Vanessa Ribeiro Costa', '873.214.659-12', 'Gerente', '(81) 97802-6615', 4700.00, '2017-06-18'),
('Gabriel Santos Oliveira', '156.947.328-44', 'Técnico de Radiologia', '(81) 98614-3372', 3200.00, '2022-10-11'),
('Larissa Almeida Rocha', '690.472.815-93', 'Recepcionista', '(81) 97550-2048', 1800.00, '2024-01-08'),
('Matheus Cavalcanti Lima', '237.805.491-60', 'Assistente Dental', '(81) 98199-7214', 2200.00, '2021-07-19'),
('Camila Fernandes Souza', '584.126.973-22', 'Higienista', '(81) 97281-6003', 2100.00, '2020-09-03'),
('Eduardo Freitas Nogueira', '312.759.684-51', 'Auxiliar Administrativo', '(81) 98801-4479', 2500.00, '2018-12-01'),
('Jéssica Ramos Pereira', '946.283.570-18', 'Gerente', '(81) 97763-1195', 4800.00, '2016-03-27'),
('Leonardo Xavier Melo', '105.638.924-77', 'Técnico de Radiologia', '(81) 98570-2638', 3300.00, '2021-11-25'),
('Aline Barros Silva', '728.491.350-42', 'Recepcionista', '(81) 97344-9820', 1800.00, '2023-05-14'),
('Roberto Araújo Costa', '461.250.897-35', 'Assistente Dental', '(81) 98015-7743', 2200.00, '2022-02-09'),
('Natália Souza Moura', '294.870.531-68', 'Higienista', '(81) 97618-5520', 2100.00, '2020-04-16'),
('Felipe Andrade Lima', '637.154.982-03', 'Auxiliar Administrativo', '(81) 98977-3146', 2500.00, '2019-07-07'),
('Caroline Mendes Rocha', '812.593.470-29', 'Gerente', '(81) 97440-1287', 5000.00, '2015-08-20'),
('Diego Santos Freitas', '359.741.628-94', 'Técnico de Radiologia', '(81) 98362-4450', 3200.00, '2022-06-30'),
('Priscila Alves Costa', '540.982.316-71', 'Recepcionista', '(81) 97128-6643', 1800.00, '2024-02-12'),
('André Nunes Lima', '781.346.205-58', 'Assistente Dental', '(81) 98704-2218', 2200.00, '2021-10-01'),
('Tatiane Rocha Melo', '263.518.904-16', 'Higienista', '(81) 97531-8904', 2100.00, '2020-03-05'),
('Bruno Pereira Gomes', '694.203.781-45', 'Auxiliar Administrativo', '(81) 98143-7752', 2500.00, '2018-11-22'),
('Milena Barbosa Silva', '428.670.159-83', 'Gerente', '(81) 97888-3316', 4600.00, '2017-09-13'),
('Sandro Freire Costa', '915.438.270-62', 'Técnico de Radiologia', '(81) 98629-1047', 3300.00, '2023-04-18'),
('Débora Almeida Ramos', '347.905.182-27', 'Recepcionista', '(81) 97315-2284', 1800.00, '2022-12-06'),
('Renato Cavalcanti Souza', '582.761.439-50', 'Assistente Dental', '(81) 98264-7150', 2200.00, '2021-01-29'),
('Viviane Costa Nogueira', '160.492.783-91', 'Higienista', '(81) 97491-5508', 2100.00, '2020-06-17'),
('Maurício Santos Lima', '739.184.526-40', 'Auxiliar Administrativo', '(81) 98852-3321', 2500.00, '2019-10-10'),
('Kelly Ferreira Rocha', '251.637.890-74', 'Gerente', '(81) 97741-6005', 4900.00, '2016-01-15'),
('Rafael Andrade Melo', '864.209.315-33', 'Técnico de Radiologia', '(81) 98590-7741', 3200.00, '2023-07-03'),
('Bianca Oliveira Costa', '473.850.126-88', 'Recepcionista', '(81) 97206-9415', 1800.00, '2024-03-11'),
('Caio Nunes Freitas', '920.475.681-14', 'Assistente Dental', '(81) 98117-5032', 2200.00, '2022-05-08'),
('Evelyn Barros Lima', '315.864.297-59', 'Higienista', '(81) 97654-1180', 2100.00, '2021-08-26'),
('João Pedro Silva', '687.123.540-26', 'Auxiliar Administrativo', '(81) 98308-6674', 2500.00, '2019-02-02'),
('Marcela Freire Costa', '142.986.753-61', 'Gerente', '(81) 97915-3328', 5100.00, '2015-04-09'),
('Igor Santos Rocha', '598.320.174-47', 'Técnico de Radiologia', '(81) 98773-2519', 3400.00, '2023-09-19'),
('Paula Mendes Lima', '376.451.982-05', 'Recepcionista', '(81) 97194-8402', 1800.00, '2024-04-25'),
('Vinicius Andrade Costa', '801.247.635-72', 'Assistente Dental', '(81) 98461-7710', 2200.00, '2022-07-14'),
('Cecília Barbosa Melo', '264.738.591-38', 'Higienista', '(81) 97508-1149', 2100.00, '2021-12-21'),
('Henrique Freitas Silva', '953.184.620-85', 'Auxiliar Administrativo', '(81) 98226-3995', 2500.00, '2018-06-01'),
('Raquel Nogueira Costa', '417.692.305-11', 'Gerente', '(81) 97837-6024', 5300.00, '2014-08-28'),
('Otávio Rocha Santos', '630.851.472-96', 'Técnico de Radiologia', '(81) 98672-1408', 3500.00, '2023-11-07'),
('Yasmin Cavalcanti Lima', '285.940.761-53', 'Recepcionista', '(81) 97362-8851', 1800.00, '2024-05-10'),
('Cláudio Pereira Alves', '741.305.896-24', 'Assistente Dental', '(81) 98044-7163', 2200.00, '2022-09-16');

-- SALAS 
INSERT INTO SALA (numero_sala, tipo_sala, status) VALUES
('S01', 'Consultório', 'Disponível'),
('S02', 'Consultório', 'Em Uso'),
('S03', 'Consultório', 'Disponível'),
('S04', 'Consultório', 'Manutenção'),
('S05', 'Consultório', 'Disponível'),
('S06', 'Consultório', 'Em Uso'),
('S07', 'Consultório', 'Disponível'),
('S08', 'Consultório', 'Disponível'),
('S09', 'Consultório', 'Em Uso'),
('S10', 'Consultório', 'Disponível'),
('C01', 'Sala de Cirurgia', 'Disponível'),
('C02', 'Sala de Cirurgia', 'Em Uso'),
('C03', 'Sala de Cirurgia', 'Manutenção'),
('C04', 'Sala de Cirurgia', 'Disponível'),
('RX01', 'Raio-X', 'Disponível'),
('RX02', 'Raio-X', 'Em Uso'),
('RX03', 'Raio-X', 'Manutenção'),
('EST01', 'Esterilização', 'Disponível'),
('EST02', 'Esterilização', 'Em Uso'),
('ESP01', 'Sala de Espera', 'Disponível'),
('ESP02', 'Sala de Espera', 'Disponível'),
('ESP03', 'Sala de Espera', 'Em Uso'),
('S11', 'Consultório', 'Disponível'),
('S12', 'Consultório', 'Disponível'),
('S13', 'Consultório', 'Em Uso'),
('S14', 'Consultório', 'Disponível'),
('S15', 'Consultório', 'Manutenção'),
('S16', 'Consultório', 'Disponível'),
('S17', 'Consultório', 'Em Uso'),
('S18', 'Consultório', 'Disponível'),
('S19', 'Consultório', 'Disponível'),
('S20', 'Consultório', 'Em Uso');

-- TRATAMENTOS
INSERT INTO TRATAMENTO (nome_tratamento, descricao, valor_base, duracao_media_minutos) VALUES
('Limpeza Dentária', 'Procedimento de profilaxia e remoção de tártaro', 120.00, 40),
('Clareamento Dental', 'Clareamento estético dos dentes', 850.00, 90),
('Canal', 'Tratamento endodôntico em dente comprometido', 950.00, 120),
('Extração Simples', 'Remoção simples de dente', 200.00, 45),
('Extração de Siso', 'Cirurgia para remoção do siso', 750.00, 90),
('Restauração em Resina', 'Restauração estética dental', 180.00, 50),
('Aplicação de Flúor', 'Aplicação preventiva de flúor', 80.00, 20),
('Ortodontia', 'Manutenção de aparelho ortodôntico', 250.00, 40),
('Implante Dentário', 'Colocação de implante dentário', 3200.00, 180),
('Prótese Dentária', 'Confecção e ajuste de prótese', 2100.00, 120),
('Consulta Odontológica', 'Avaliação clínica geral', 100.00, 30),
('Radiografia Panorâmica', 'Exame panorâmico bucal', 150.00, 25),
('Radiografia Periapical', 'Radiografia localizada', 70.00, 15),
('Cirurgia Gengival', 'Procedimento cirúrgico periodontal', 1300.00, 120),
('Tratamento Periodontal', 'Tratamento de gengivite e periodontite', 600.00, 60),
('Selante Dental', 'Aplicação de selante em dentes', 110.00, 25),
('Faceta de Resina', 'Aplicação estética em resina', 700.00, 90),
('Faceta de Porcelana', 'Aplicação de faceta em porcelana', 1800.00, 120),
('Pino Dentário', 'Instalação de pino intracanal', 500.00, 60),
('Urgência Odontológica', 'Atendimento emergencial', 250.00, 45),
('Ajuste de Aparelho', 'Manutenção ortodôntica', 180.00, 30),
('Documentação Ortodôntica', 'Exames para ortodontia', 400.00, 60),
('Remoção de Tártaro', 'Limpeza profunda dental', 150.00, 45),
('Placa de Bruxismo', 'Confecção de placa miorrelaxante', 650.00, 50),
('Tratamento de Cárie', 'Remoção de cárie e restauração', 220.00, 40),
('Enxerto Ósseo', 'Reconstrução óssea bucal', 2500.00, 150),
('Recontorno Estético', 'Ajuste estético dental', 300.00, 35),
('Consulta Infantil', 'Atendimento odontopediátrico', 120.00, 30),
('Odontopediatria Preventiva', 'Prevenção bucal infantil', 140.00, 35),
('Tratamento de Sensibilidade', 'Aplicação para redução de sensibilidade', 160.00, 25),
('Cirurgia Oral Menor', 'Procedimento cirúrgico bucal simples', 900.00, 100),
('Laser Terapêutico', 'Aplicação de laser odontológico', 200.00, 20),
('Avaliação Estética', 'Planejamento estético dental', 180.00, 40),
('Lente de Contato Dental', 'Aplicação de lentes dentárias', 2500.00, 140),
('Profilaxia Infantil', 'Limpeza dental infantil', 90.00, 25),
('Teste de Oclusão', 'Avaliação da mordida', 130.00, 20),
('Tratamento ATM', 'Tratamento para articulação mandibular', 700.00, 70),
('Recimentação de Coroa', 'Fixação de coroa dentária', 210.00, 30),
('Coroa de Porcelana', 'Instalação de coroa estética', 1600.00, 110),
('Raspagem Subgengival', 'Limpeza periodontal profunda', 450.00, 60),
('Bichectomia', 'Cirurgia estética facial', 2800.00, 120),
('Consulta de Retorno', 'Reavaliação clínica', 0.00, 20),
('Frenectomia', 'Remoção de freio labial ou lingual', 750.00, 60),
('Pulpectomia', 'Tratamento pulpar infantil', 320.00, 45),
('Pulpotomia', 'Tratamento parcial da polpa dentária', 280.00, 40),
('Aparelho Estético', 'Instalação de aparelho transparente', 3500.00, 150),
('Contenção Ortodôntica', 'Instalação de contenção pós-aparelho', 450.00, 35),
('Escaneamento Intraoral', 'Escaneamento digital da arcada', 300.00, 20),
('Mockup Dental', 'Simulação estética do sorriso', 550.00, 50),
('Consulta Pré-Cirúrgica', 'Avaliação antes de cirurgia', 170.00, 30);

-- PRONTUARIO DOS PACIENTES
INSERT INTO PRONTUARIO (id_paciente, diagnostico, alergias, observacoes) VALUES
(1, 'Cárie dentária leve', 'Nenhuma', 'Paciente apresenta boa higiene bucal'),
(2, 'Gengivite inicial', 'Penicilina', 'Recomendado uso de enxaguante bucal'),
(3, 'Sensibilidade dental', 'Nenhuma', 'Evitar alimentos muito gelados'),
(4, 'Necessidade de canal', 'Dipirona', 'Dor frequente no molar superior'),
(5, 'Desgaste dental', 'Nenhuma', 'Possível bruxismo'),
(6, 'Cárie profunda', 'Amoxicilina', 'Necessário retorno em 15 dias'),
(7, 'Tártaro excessivo', 'Nenhuma', 'Indicada limpeza urgente'),
(8, 'Dente fraturado', 'Ibuprofeno', 'Paciente sofreu queda'),
(9, 'Periodontite moderada', 'Nenhuma', 'Acompanhamento periodontal'),
(10, 'Mordida desalinhada', 'Nenhuma', 'Encaminhado para ortodontia'),
(11, 'Cárie superficial', 'Paracetamol', 'Boa recuperação'),
(12, 'Inflamação gengival', 'Nenhuma', 'Orientado sobre escovação'),
(13, 'Necessidade de extração', 'Nenhuma', 'Siso incluso'),
(14, 'Bruxismo', 'Nimesulida', 'Uso de placa recomendado'),
(15, 'Clareamento dental', 'Nenhuma', 'Paciente deseja melhora estética'),
(16, 'Canal infeccionado', 'Penicilina', 'Uso de antibiótico prescrito'),
(17, 'Prótese mal ajustada', 'Nenhuma', 'Necessário ajuste'),
(18, 'Cárie recorrente', 'Dipirona', 'Retorno em 30 dias'),
(19, 'Sensibilidade gengival', 'Nenhuma', 'Evitar bebidas ácidas'),
(20, 'Dente incluso', 'Nenhuma', 'Avaliação cirúrgica solicitada'),
(21, 'Faceta desgastada', 'Ibuprofeno', 'Troca recomendada'),
(22, 'Inflamação periodontal', 'Nenhuma', 'Tratamento periodontal iniciado'),
(23, 'Quebra de restauração', 'Nenhuma', 'Nova restauração necessária'),
(24, 'Consulta preventiva', 'Amoxicilina', 'Paciente saudável'),
(25, 'Dor mandibular', 'Nenhuma', 'Suspeita de ATM'),
(26, 'Tártaro leve', 'Nenhuma', 'Indicada profilaxia'),
(27, 'Canal concluído', 'Paracetamol', 'Paciente sem dor'),
(28, 'Mau hálito persistente', 'Nenhuma', 'Orientado higiene da língua'),
(29, 'Extração recente', 'Dipirona', 'Boa cicatrização'),
(30, 'Aparelho desalinhado', 'Nenhuma', 'Necessário ajuste ortodôntico'),
(31, 'Dente quebrado', 'Nenhuma', 'Avaliar colocação de coroa'),
(32, 'Cárie infantil', 'Ibuprofeno', 'Responsável orientado'),
(33, 'Gengivite avançada', 'Nenhuma', 'Tratamento contínuo'),
(34, 'Implante em avaliação', 'Penicilina', 'Exames solicitados'),
(35, 'Desgaste por bruxismo', 'Nenhuma', 'Uso noturno de placa'),
(36, 'Infecção dentária', 'Amoxicilina', 'Paciente medicado'),
(37, 'Restauração antiga', 'Nenhuma', 'Troca recomendada'),
(38, 'Consulta estética', 'Nenhuma', 'Planejamento de facetas'),
(39, 'Dente sensível', 'Nimesulida', 'Uso de creme dental específico'),
(40, 'Mordida cruzada', 'Nenhuma', 'Encaminhado para ortodontista'),
(41, 'Sangramento gengival', 'Nenhuma', 'Melhorar uso do fio dental'),
(42, 'Canal incompleto', 'Dipirona', 'Retorno obrigatório'),
(43, 'Placa bacteriana', 'Nenhuma', 'Necessária limpeza'),
(44, 'Dor no siso', 'Ibuprofeno', 'Extração indicada'),
(45, 'Fratura parcial', 'Nenhuma', 'Avaliar restauração estética'),
(46, 'Cárie extensa', 'Penicilina', 'Tratamento urgente'),
(47, 'Clareamento em andamento', 'Nenhuma', 'Evitar café e refrigerante'),
(48, 'Prótese quebrada', 'Nenhuma', 'Nova moldagem necessária'),
(49, 'ATM leve', 'Paracetamol', 'Exercícios mandibulares recomendados'),
(50, 'Paciente sem alterações', 'Nenhuma', 'Retorno anual recomendado');

-- AGENDAMENTO
INSERT INTO AGENDAMENTO 
(data_agendada, hora_agendada, status, id_paciente, id_dentista, id_sala, id_funcionario) VALUES
('2026-04-01', '08:00:00', 'Confirmado', 1, 1, 1, 1),
('2026-04-02', '08:30:00', 'Realizado', 2, 2, 2, 2),
('2026-04-03', '09:00:00', 'Pendente', 3, 3, 3, 3),
('2026-04-04', '09:30:00', 'Cancelado', 4, 4, 4, 4),
('2026-04-05', '10:00:00', 'Confirmado', 5, 5, 5, 5),
('2026-04-06', '08:00:00', 'Realizado', 6, 6, 6, 6),
('2026-04-07', '08:30:00', 'Pendente', 7, 7, 7, 7),
('2026-04-08', '09:00:00', 'Não Compareceu', 8, 8, 8, 8),
('2026-04-09', '09:30:00', 'Confirmado', 9, 9, 9, 9),
('2026-04-10', '10:00:00', 'Realizado', 10, 10, 10, 10),
('2026-04-11', '08:00:00', 'Pendente', 11, 11, 11, 11),
('2026-04-12', '08:30:00', 'Confirmado', 12, 12, 12, 12),
('2026-04-13', '09:00:00', 'Cancelado', 13, 13, 13, 13),
('2026-04-14', '09:30:00', 'Realizado', 14, 14, 14, 14),
('2026-04-15', '10:00:00', 'Confirmado', 15, 15, 15, 15),
('2026-04-16', '08:00:00', 'Pendente', 16, 16, 16, 16),
('2026-04-17', '08:30:00', 'Confirmado', 17, 17, 17, 17),
('2026-04-18', '09:00:00', 'Realizado', 18, 18, 18, 18),
('2026-04-19', '09:30:00', 'Não Compareceu', 19, 19, 19, 19),
('2026-04-20', '10:00:00', 'Confirmado', 20, 20, 20, 20),
('2026-04-21', '08:00:00', 'Cancelado', 21, 21, 21, 21),
('2026-04-22', '08:30:00', 'Realizado', 22, 22, 22, 22),
('2026-04-23', '09:00:00', 'Pendente', 23, 23, 23, 23),
('2026-04-24', '09:30:00', 'Confirmado', 24, 24, 24, 24),
('2026-04-25', '10:00:00', 'Realizado', 25, 25, 25, 25),
('2026-04-26', '08:00:00', 'Confirmado', 26, 26, 26, 26),
('2026-04-27', '08:30:00', 'Pendente', 27, 27, 27, 27),
('2026-04-28', '09:00:00', 'Cancelado', 28, 1, 28, 28),
('2026-05-01', '08:00:00', 'Realizado', 29, 2, 29, 29),
('2026-05-02', '08:30:00', 'Confirmado', 30, 3, 30, 30),
('2026-05-03', '09:00:00', 'Pendente', 31, 4, 31, 31),
('2026-05-04', '09:30:00', 'Realizado', 32, 5, 32, 32),
('2026-05-05', '10:00:00', 'Confirmado', 33, 6, 1, 33),
('2026-05-06', '08:00:00', 'Não Compareceu', 34, 7, 2, 34),
('2026-05-07', '08:30:00', 'Confirmado', 35, 8, 3, 35),
('2026-05-08', '09:00:00', 'Realizado', 36, 9, 4, 36),
('2026-05-09', '09:30:00', 'Pendente', 37, 10, 5, 37),
('2026-05-10', '10:00:00', 'Confirmado', 38, 11, 6, 38);

-- CONSULTA
INSERT INTO CONSULTA
(data_consulta, horario, status, observacoes, id_paciente, id_dentista) VALUES
('2026-06-01', '08:00:00', 'Finalizada', NULL, 1, 2),
('2026-06-01', '09:00:00', 'Agendada', NULL, 2, 5),
('2026-06-01', '10:00:00', 'Cancelada', NULL, 3, 1),
('2026-06-01', '11:00:00', 'Em Andamento', NULL, 4, 7),
('2026-06-01', '13:00:00', 'Agendada', NULL, 5, 3),
('2026-06-01', '14:00:00', 'Finalizada', NULL, 6, 6),
('2026-06-02', '08:00:00', 'Agendada', NULL, 7, 4),
('2026-06-02', '09:00:00', 'Cancelada', NULL, 8, 8),
('2026-06-02', '10:00:00', 'Finalizada', NULL, 9, 2),
('2026-06-02', '11:00:00', 'Agendada', NULL, 10, 9),
('2026-06-02', '13:00:00', 'Em Andamento', NULL, 11, 1),
('2026-06-02', '14:00:00', 'Finalizada', NULL, 12, 5),
('2026-06-03', '08:00:00', 'Agendada', NULL, 13, 7),
('2026-06-03', '09:00:00', 'Cancelada', NULL, 14, 4),
('2026-06-03', '10:00:00', 'Finalizada', NULL, 15, 3),
('2026-06-03', '11:00:00', 'Agendada', NULL, 16, 8),
('2026-06-03', '13:00:00', 'Em Andamento', NULL, 17, 2),
('2026-06-03', '14:00:00', 'Finalizada', NULL, 18, 6),
('2026-06-04', '08:00:00', 'Agendada', NULL, 19, 9),
('2026-06-04', '09:00:00', 'Cancelada', NULL, 20, 10),
('2026-06-04', '10:00:00', 'Finalizada', NULL, 21, 1),
('2026-06-04', '11:00:00', 'Agendada', NULL, 22, 5),
('2026-06-04', '13:00:00', 'Em Andamento', NULL, 23, 7),
('2026-06-04', '14:00:00', 'Finalizada', NULL, 24, 2),
('2026-06-05', '08:00:00', 'Agendada', NULL, 25, 6),
('2026-06-05', '09:00:00', 'Cancelada', NULL, 26, 4),
('2026-06-05', '10:00:00', 'Finalizada', NULL, 27, 8),
('2026-06-05', '11:00:00', 'Agendada', NULL, 28, 3),
('2026-06-05', '13:00:00', 'Em Andamento', NULL, 29, 9),
('2026-06-05', '14:00:00', 'Finalizada', NULL, 30, 1),
('2026-06-06', '08:00:00', 'Agendada', NULL, 31, 5),
('2026-06-06', '09:00:00', 'Cancelada', NULL, 32, 7),
('2026-06-06', '10:00:00', 'Finalizada', NULL, 33, 2),
('2026-06-06', '11:00:00', 'Agendada', NULL, 34, 10),
('2026-06-06', '13:00:00', 'Em Andamento', NULL, 35, 6),
('2026-06-06', '14:00:00', 'Finalizada', NULL, 36, 8),
('2026-06-07', '08:00:00', 'Agendada', NULL, 37, 4),
('2026-06-07', '09:00:00', 'Cancelada', NULL, 38, 3),
('2026-06-07', '10:00:00', 'Finalizada', NULL, 39, 9),
('2026-06-07', '11:00:00', 'Agendada', NULL, 40, 1),
('2026-06-07', '13:00:00', 'Em Andamento', NULL, 41, 5),
('2026-06-07', '14:00:00', 'Finalizada', NULL, 42, 7),
('2026-06-08', '08:00:00', 'Agendada', NULL, 43, 2),
('2026-06-08', '09:00:00', 'Cancelada', NULL, 44, 6),
('2026-06-08', '10:00:00', 'Finalizada', NULL, 45, 8),
('2026-06-08', '11:00:00', 'Agendada', NULL, 46, 4),
('2026-06-08', '13:00:00', 'Em Andamento', NULL, 47, 10),
('2026-06-08', '14:00:00', 'Finalizada', NULL, 48, 3),
('2026-06-09', '08:00:00', 'Agendada', NULL, 49, 1),
('2026-06-09', '09:00:00', 'Cancelada', NULL, 50, 9);

-- CONSULTA_TRATAMENTO
INSERT INTO CONSULTA_TRATAMENTO
(id_consulta, id_tratamento, quantidade, valor_aplicado)
VALUES
(1, 1, 1, 150.00),
(2, 3, 1, 300.00),
(3, 5, 2, 500.00),
(4, 2, 1, 120.00),
(5, 4, 1, 450.00),
(6, 6, 1, 200.00),
(7, 7, 1, 800.00),
(8, 8, 2, 1000.00),
(9, 9, 1, 250.00),
(10, 10, 1, 600.00),
(11, 1, 1, 150.00),
(12, 2, 1, 120.00),
(13, 3, 1, 300.00),
(14, 4, 2, 900.00),
(15, 5, 1, 250.00),
(16, 6, 1, 200.00),
(17, 7, 1, 800.00),
(18, 8, 1, 500.00),
(19, 9, 2, 700.00),
(20, 10, 1, 600.00),
(21, 1, 1, 150.00),
(22, 3, 2, 600.00),
(23, 5, 1, 250.00),
(24, 2, 1, 120.00),
(25, 4, 1, 450.00),
(26, 6, 2, 400.00),
(27, 7, 1, 800.00),
(28, 8, 1, 500.00),
(29, 9, 1, 350.00),
(30, 10, 1, 600.00),
(31, 1, 1, 150.00),
(32, 2, 1, 120.00),
(33, 3, 1, 300.00),
(34, 4, 1, 450.00),
(35, 5, 2, 500.00),
(36, 6, 1, 200.00),
(37, 7, 1, 800.00),
(38, 8, 1, 500.00),
(39, 9, 1, 350.00),
(40, 10, 2, 1200.00),
(41, 1, 1, 150.00),
(42, 2, 1, 120.00),
(43, 3, 1, 300.00),
(44, 4, 1, 450.00),
(45, 5, 1, 250.00),
(46, 6, 1, 200.00),
(47, 7, 2, 1600.00),
(48, 8, 1, 500.00),
(49, 9, 1, 350.00),
(50, 10, 1, 600.00);

-- PAGAMENTO
INSERT INTO PAGAMENTO
(valor, forma_pagamento, data_pagamento, id_consulta) VALUES
(150.00, 'Pix', '2026-06-01', 1),
(300.00, 'Cartao Credito', '2026-06-01', 2),
(500.00, 'Dinheiro', '2026-06-01', 3),
(120.00, 'Cartao Debito', '2026-06-01', 4),
(450.00, 'Convenio', '2026-06-01', 5),
(200.00, 'Pix', '2026-06-02', 6),
(800.00, 'Cartao Credito', '2026-06-02', 7),
(1000.00, 'Dinheiro', '2026-06-02', 8),
(250.00, 'Cartao Debito', '2026-06-02', 9),
(600.00, 'Convenio', '2026-06-02', 10),
(150.00, 'Pix', '2026-06-03', 11),
(120.00, 'Cartao Credito', '2026-06-03', 12),
(300.00, 'Dinheiro', '2026-06-03', 13),
(900.00, 'Cartao Debito', '2026-06-03', 14),
(250.00, 'Convenio', '2026-06-03', 15),
(200.00, 'Pix', '2026-06-04', 16),
(800.00, 'Cartao Credito', '2026-06-04', 17),
(500.00, 'Dinheiro', '2026-06-04', 18),
(700.00, 'Cartao Debito', '2026-06-04', 19),
(600.00, 'Convenio', '2026-06-04', 20),
(150.00, 'Pix', '2026-06-05', 21),
(600.00, 'Cartao Credito', '2026-06-05', 22),
(250.00, 'Dinheiro', '2026-06-05', 23),
(120.00, 'Cartao Debito', '2026-06-05', 24),
(450.00, 'Convenio', '2026-06-05', 25),
(400.00, 'Pix', '2026-06-06', 26),
(800.00, 'Cartao Credito', '2026-06-06', 27),
(500.00, 'Dinheiro', '2026-06-06', 28),
(350.00, 'Cartao Debito', '2026-06-06', 29),
(600.00, 'Convenio', '2026-06-06', 30),
(150.00, 'Pix', '2026-06-07', 31),
(120.00, 'Cartao Credito', '2026-06-07', 32),
(300.00, 'Dinheiro', '2026-06-07', 33),
(450.00, 'Cartao Debito', '2026-06-07', 34),
(500.00, 'Convenio', '2026-06-07', 35),
(200.00, 'Pix', '2026-06-08', 36),
(800.00, 'Cartao Credito', '2026-06-08', 37),
(500.00, 'Dinheiro', '2026-06-08', 38),
(350.00, 'Cartao Debito', '2026-06-08', 39),
(1200.00, 'Convenio', '2026-06-08', 40),
(150.00, 'Pix', '2026-06-09', 41),
(120.00, 'Cartao Credito', '2026-06-09', 42),
(300.00, 'Dinheiro', '2026-06-09', 43),
(450.00, 'Cartao Debito', '2026-06-09', 44),
(250.00, 'Convenio', '2026-06-09', 45),
(200.00, 'Pix', '2026-06-10', 46),
(1600.00, 'Cartao Credito', '2026-06-10', 47),
(500.00, 'Dinheiro', '2026-06-10', 48),
(350.00, 'Cartao Debito', '2026-06-10', 49),
(600.00, 'Convenio', '2026-06-10', 50);

-- INSERTS FINALIZADOS

-- falta só adicionar agr as consultas, a foto ta no grupo

-- CONSULTAS SIMPLES COM SELECT

SELECT * FROM PACIENTE;

SELECT * FROM DENTISTA;

SELECT * FROM FUNCIONARIO;

SELECT * FROM SALA;

SELECT * FROM TRATAMENTO;

SELECT * FROM PRONTUARIO;

SELECT * FROM AGENDAMENTO;

SELECT * FROM CONSULTA;

SELECT * FROM CONSULTA_TRATAMENTO;

SELECT * FROM PAGAMENTO;

SELECT nome, cpf FROM PACIENTE;

SELECT nome, especialidade FROM DENTISTA;

SELECT nome_tratamento, valor_base FROM TRATAMENTO;

SELECT numero_sala, status FROM SALA;

SELECT valor, forma_pagamento FROM PAGAMENTO;

-- FILTROS COM WHERE

SELECT * FROM PACIENTE WHERE nome LIKE 'A%';

SELECT * FROM DENTISTA WHERE especialidade = 'Ortodontista';

SELECT * FROM FUNCIONARIO WHERE salario > 3000;

SELECT * FROM SALA WHERE status = 'Disponivel';

SELECT * FROM TRATAMENTO WHERE valor_base > 1000;

SELECT * FROM CONSULTA WHERE status = 'Finalizada';

SELECT * FROM AGENDAMENTO WHERE status = 'Confirmado';

SELECT * FROM PAGAMENTO WHERE forma_pagamento = 'Pix';

SELECT * FROM PACIENTE WHERE data_nascimento > '1990-01-01';

SELECT * FROM DENTISTA WHERE data_admissao < '2020-01-01';

SELECT * FROM FUNCIONARIO WHERE cargo = 'Gerente';

SELECT * FROM TRATAMENTO WHERE duracao_media_minutos >= 60;

SELECT * FROM CONSULTA WHERE data_consulta = '2026-06-01';

SELECT * FROM PAGAMENTO WHERE valor >= 500;

SELECT * FROM AGENDAMENTO WHERE hora_agendada = '08:00:00';

-- JOINS

SELECT PACIENTE.nome, CONSULTA.data_consulta FROM PACIENTE JOIN CONSULTA ON PACIENTE.id_paciente = CONSULTA.id_paciente;

SELECT DENTISTA.nome, CONSULTA.status FROM DENTISTA JOIN CONSULTA ON DENTISTA.id_dentista = CONSULTA.id_dentista;

SELECT PACIENTE.nome, PRONTUARIO.diagnostico FROM PACIENTE
JOIN PRONTUARIO ON PACIENTE.id_paciente = PRONTUARIO.id_paciente;

SELECT CONSULTA.id_consulta, PAGAMENTO.valor FROM CONSULTA JOIN PAGAMENTO
ON CONSULTA.id_consulta = PAGAMENTO.id_consulta;

SELECT CONSULTA_TRATAMENTO.id_consulta, TRATAMENTO.nome_tratamento FROM CONSULTA_TRATAMENTO
JOIN TRATAMENTO ON CONSULTA_TRATAMENTO.id_tratamento = TRATAMENTO.id_tratamento;

SELECT PACIENTE.nome, AGENDAMENTO.data_agendada FROM PACIENTE
JOIN AGENDAMENTO ON PACIENTE.id_paciente = AGENDAMENTO.id_paciente;

SELECT DENTISTA.nome, AGENDAMENTO.hora_agendada FROM DENTISTA
JOIN AGENDAMENTO ON DENTISTA.id_dentista = AGENDAMENTO.id_dentista;

SELECT SALA.numero_sala, AGENDAMENTO.status FROM SALA
JOIN AGENDAMENTO ON SALA.id_sala = AGENDAMENTO.id_sala;

SELECT FUNCIONARIO.nome, AGENDAMENTO.data_agendada FROM FUNCIONARIO
JOIN AGENDAMENTO ON FUNCIONARIO.id_funcionario = AGENDAMENTO.id_funcionario;

SELECT PACIENTE.nome AS paciente, DENTISTA.nome AS dentista FROM CONSULTA
JOIN PACIENTE ON CONSULTA.id_paciente = PACIENTE.id_paciente
JOIN DENTISTA ON CONSULTA.id_dentista = DENTISTA.id_dentista;

-- CONSULTAS COM AGREGAÇÃO

-- COUNT
SELECT COUNT(*) AS total_pacientes FROM PACIENTE;

SELECT COUNT(*) AS total_consultas FROM CONSULTA;

SELECT COUNT(*) AS total_dentistas FROM DENTISTA;

-- SUM
SELECT SUM(valor) AS soma_pagamentos FROM PAGAMENTO;

SELECT SUM(valor_base) AS soma_tratamentos FROM TRATAMENTO;

SELECT SUM(salario) AS soma_salarios FROM FUNCIONARIO;

-- AVG
SELECT AVG(valor) AS media_pagamentos FROM PAGAMENTO;

SELECT AVG(valor_base) AS media_tratamentos FROM TRATAMENTO;

SELECT AVG(salario) AS media_salarios FROM FUNCIONARIO;

-- UPDATES

UPDATE PACIENTE SET telefone = '(81) 99999-0001' WHERE id_paciente = 1;

UPDATE PACIENTE SET endereco = 'Rua Nova, 100' WHERE id_paciente = 2;

UPDATE DENTISTA SET status = 'Licenca' WHERE id_dentista = 3;

UPDATE FUNCIONARIO SET salario = 3000
WHERE id_funcionario = 4;

UPDATE SALA SET status = 'Em Uso'
WHERE id_sala = 5;

UPDATE TRATAMENTO SET valor_base = 950
WHERE id_tratamento = 6;

UPDATE CONSULTA SET status = 'Finalizada'
WHERE id_consulta = 7;

UPDATE AGENDAMENTO SET status = 'Cancelado'
WHERE id_agendamento = 8;

UPDATE PAGAMENTO SET forma_pagamento = 'Pix'
WHERE id_pagamento = 9;

UPDATE PRONTUARIO SET observacoes = 'Paciente em observação'
WHERE id_prontuario = 10;

-- DELETES

DELETE FROM PAGAMENTO WHERE id_consulta = 48;

DELETE FROM CONSULTA_TRATAMENTO WHERE id_consulta = 48;

DELETE FROM CONSULTA WHERE id_consulta = 48;

DELETE FROM AGENDAMENTO WHERE id_agendamento = 38;

DELETE FROM PRONTUARIO WHERE id_prontuario = 999;

DELETE FROM TRATAMENTO WHERE id_tratamento = 999;

DELETE FROM SALA WHERE id_sala = 999;

DELETE FROM FUNCIONARIO WHERE id_funcionario = 999;

DELETE FROM DENTISTA WHERE id_dentista = 999;

DELETE FROM PACIENTE WHERE id_paciente = 999;