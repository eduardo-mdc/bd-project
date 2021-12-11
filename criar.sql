PRAGMA FOREIGN_KEYS = ON;

DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS VENDA;
DROP TABLE IF EXISTS REPARACAO;
DROP TABLE IF EXISTS FUNCIONARIO;
DROP TABLE IF EXISTS SALARIO_MENSAL;
DROP TABLE IF EXISTS ESPECIALIDADE;
DROP TABLE IF EXISTS INCREMENTO_VENDA;
DROP TABLE IF EXISTS INCREMENTO_REPARACAO;
DROP TABLE IF EXISTS PECA;
DROP TABLE IF EXISTS PECA_REPARACAO;
DROP TABLE IF EXISTS PECA_FORNECEDOR;
DROP TABLE IF EXISTS PECA_VENDA;
DROP TABLE IF EXISTS FORNECEDOR;
DROP TABLE IF EXISTS ARMAZEM;

CREATE TABLE CLIENTE (
  ID_CLIENTE INTEGER,
  NIF CHAR(9) UNIQUE,
  NOME VARCHAR(256) NOT NULL,
  MORADA VARCHAR(512) NOT NULL,
  EMAIL VARCHAR(256) UNIQUE NOT NULL,
  TELEMOVEL CHAR(9) UNIQUE,
  CONSTRAINT CLIENTE_PK PRIMARY KEY (ID_CLIENTE)
);

CREATE TABLE VENDA (
  ID_VENDA INTEGER,
  DESIGNACAO TEXT,
  CUSTO FLOAT NOT NULL,
  DATA_SERVICO DATE NOT NULL,
  MORADA_CARGA VARCHAR(512) NOT NULL,
  MORADA_DESCARGA VARCHAR(512) NOT NULL,
  LUCRO FLOAT ,
  ID_CLIENTE INTEGER NOT NULL,
  CONSTRAINT VENDA_PK PRIMARY KEY (ID_VENDA),
  CONSTRAINT VENDA_FK FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
  CONSTRAINT CUSTO_CHECK CHECK (CUSTO > 0),
  CONSTRAINT LUCRO_CHECK CHECK(LUCRO > 0)
);

CREATE TABLE REPARACAO (
  ID_REPARACAO INTEGER,
  DESIGNACAO TEXT,
  CUSTO FLOAT,
  DATA_SERVICO DATE NOT NULL,
  DATA_INICIO DATE NOT NULL,
  DATA_FINAL DATE NOT NULL,
  ID_CLIENTE INTEGER NOT NULL,
  CONSTRAINT REPARACAO_PK PRIMARY KEY (ID_REPARACAO),
  --CHECK (DATA_INICIO < DATA_FINAL),
  CONSTRAINT REPARACAO_FK FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
  CONSTRAINT CUSTO_CHECK CHECK (CUSTO > 0)

);

CREATE TABLE FORNECEDOR (
  ID_FORNECEDOR INTEGER,
  NOME VARCHAR (255) NOT NULL,
  CONSTRAINT FORNECEDOR_PK PRIMARY KEY (ID_FORNECEDOR)
);

CREATE TABLE PECA (
  ID_PECA INTEGER,
  MODELO VARCHAR(128) NOT NULL,
  PRECO_VENDA FLOAT NOT NULL,
  STOCK INTEGER NOT NULL,
  CONSTRAINT PECA_PK PRIMARY KEY (ID_PECA),
  CONSTRAINT PRECO_VENDA CHECK (PRECO_VENDA > 0),
  CONSTRAINT STOCK CHECK (STOCK >= 0)
);

CREATE TABLE ESPECIALIDADE (
  ID_ESPECIALIDADE INTEGER,
  NOME VARCHAR(256) NOT NULL,
  PRECO_HORA FLOAT NOT NULL,
  CONSTRAINT ESPECIALIDADE_PK PRIMARY KEY (ID_ESPECIALIDADE),
  CONSTRAINT PRECO_HORA_CHECK CHECK (PRECO_HORA > 0)
);

CREATE TABLE FUNCIONARIO (
  ID_FUNCIONARIO INTEGER,
  NOME VARCHAR(256) NOT NULL,
  MORADA VARCHAR(512) NOT NULL,
  EMAIL VARCHAR(256) NOT NULL,
  TELEMOVEL CHAR(9),
  SALARIO_BASE FLOAT NOT NULL,
  ID_ESPECIALIDADE INTEGER NOT NULL,
  CONSTRAINT FUNCIONARIO_PK PRIMARY KEY (ID_FUNCIONARIO),
  CONSTRAINT FUNCIONARIO_FK FOREIGN KEY (ID_ESPECIALIDADE) REFERENCES ESPECIALIDADE(ID_ESPECIALIDADE)
);

CREATE TABLE SALARIO_MENSAL (
  ID_SALARIO_MENSAL INTEGER,
  MES INTEGER NOT NULL,
  SALARIO FLOAT NOT NULL,
  ANO INTEGER NOT NULL,
  ID_FUNCIONARIO INTEGER NOT NULL,
  CONSTRAINT SALARIO_MENSAL_PK PRIMARY KEY (ID_SALARIO_MENSAL),
  CONSTRAINT ID_FUNCIONARIO_FK FOREIGN KEY (ID_FUNCIONARIO) REFERENCES FUNCIONARIO(ID_FUNCIONARIO),
  CONSTRAINT MES_CHECK CHECK (MES > 0 AND MES <= 12),
  CONSTRAINT SALARIO_CHECK CHECK (SALARIO > 0)
);

CREATE TABLE INCREMENTO_VENDA (
  ID_VENDA INTEGER NOT NULL,
  ID_FUNCIONARIO INTEGER NOT NULL,
  CONSTRAINT INCREMENTO_VENDA_PK PRIMARY KEY (ID_VENDA,ID_FUNCIONARIO),
  CONSTRAINT ID_VENDA_FK FOREIGN KEY (ID_VENDA) REFERENCES VENDA(ID_VENDA),
  CONSTRAINT ID_FUNCIONARIO_FK FOREIGN KEY (ID_FUNCIONARIO) REFERENCES FUNCIONARIO(ID_FUNCIONARIO)
);

CREATE TABLE INCREMENTO_REPARACAO (
  ID_REPARACAO INTEGER NOT NULL,
  ID_FUNCIONARIO INTEGER NOT NULL,
  HORAS FLOAT DEFAULT 0,
  CONSTRAINT INCREMENTO_REPARACAO_PK PRIMARY KEY (ID_REPARACAO,ID_FUNCIONARIO),
  CONSTRAINT ID_REPARACAO_FK FOREIGN KEY (ID_REPARACAO) REFERENCES REPARACAO(ID_REPARACAO),
  CONSTRAINT ID_FUNCIONARIO_FK FOREIGN KEY (ID_FUNCIONARIO) REFERENCES FUNCIONARIO(ID_FUNCIONARIO),
  CONSTRAINT HORAS_CHECK  CHECK (HORAS > 0)
);

CREATE TABLE PECA_REPARACAO (
  ID_PECA INTEGER NOT NULL,
  ID_REPARACAO INTEGER NOT NULL,
  CONSTRAINT PECA_REPARACAO_PK PRIMARY KEY (ID_PECA,ID_REPARACAO),
  CONSTRAINT ID_PECA_FK FOREIGN KEY (ID_PECA) REFERENCES PECA(ID_PECA),
  CONSTRAINT ID_REPARACAO_FK FOREIGN KEY (ID_REPARACAO) REFERENCES REPARACAO(ID_REPARACAO)
);

CREATE TABLE PECA_FORNECEDOR (
  ID_PECA INTEGER NOT NULL,
  ID_FORNECEDOR INTEGER NOT NULL,
  PRECO_COMPRA INTEGER NOT NULL,
  CONSTRAINT PECA_FORNECEDOR_PK PRIMARY KEY (ID_PECA,ID_FORNECEDOR),
  CONSTRAINT PECA_PECA_FORNECEDOR_FK FOREIGN KEY (ID_PECA) REFERENCES PECA (ID_PECA),
  CONSTRAINT FORNECEDOR_PECA_FORNECEDOR_FK FOREIGN KEY (ID_FORNECEDOR) REFERENCES FORNECEDOR (ID_FORNECEDOR),
  CONSTRAINT PRECO_COMPRA_CHECK CHECK (PRECO_COMPRA >= 0)
);

CREATE TABLE PECA_VENDA (
  ID_VENDA INTEGER NOT NULL,
  ID_PECA INTEGER NOT NULL,
  N_PECA INTEGER NOT NULL,
  CONSTRAINT PECA_VENDA_PK PRIMARY KEY (ID_PECA,ID_VENDA),
  CONSTRAINT PECA_PECA_VENDA_FK FOREIGN KEY (ID_PECA) REFERENCES PECA (ID_PECA),
  CONSTRAINT VENDAR_PECA_VENDA_FK FOREIGN KEY (ID_VENDA) REFERENCES VENDA (ID_VENDA),
  CONSTRAINT N_PECA_CHECK  CHECK (N_PECA >= 0)
);


CREATE TABLE ARMAZEM (
  ID_ARMAZEM INTEGER,
  NOME VARCHAR (255) NOT NULL,
  MORADA VARCHAR (255) NOT NULL,
  AREA FLOAT NOT NULL,
  ID_FORNECEDOR INTEGER NOT NULL,
  CONSTRAINT ARMAZEM_PK PRIMARY KEY (ID_ARMAZEM),
  CONSTRAINT ARMAZEM_FK FOREIGN KEY (ID_FORNECEDOR) REFERENCES FORNECEDOR(ID_FORNECEDOR),
  CONSTRAINT AREA_CHECK CHECK (AREA > 0)
);
