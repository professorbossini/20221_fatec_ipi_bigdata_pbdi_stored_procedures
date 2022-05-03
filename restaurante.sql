-- restaurante
-- criação das tabelas
-- DROP TABLE tb_cliente;
CREATE TABLE IF NOT EXISTS tb_cliente(
	cod_cliente SERIAL PRIMARY KEY,
	nome VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_pedido(
	cod_pedido SERIAL PRIMARY KEY,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	status VARCHAR(200) DEFAULT 'aberto',
	cod_cliente INT NOT NULL,
	CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES tb_cliente(cod_cliente)
);

CREATE TABLE IF NOT EXISTS tb_tipo_item (
	cod_tipo SERIAL PRIMARY KEY,
	descricao VARCHAR(200) NOT NULL
);
INSERT INTO tb_tipo_item (descricao) VALUES ('Bebida'), ('Comida');
SELECT * FROM tb_tipo_item;


CREATE TABLE IF NOT EXISTS tb_item(
	cod_item SERIAL PRIMARY KEY,
	descricao VARCHAR(200) NOT NULL,
	valor NUMERIC (10, 2) NOT NULL,
	cod_tipo INT NOT NULL,
	CONSTRAINT fk_tipo_item FOREIGN KEY (cod_tipo) REFERENCES tb_tipo_item(cod_tipo)
);

INSERT INTO tb_item (descricao, valor, cod_tipo) VALUES
('Refrigerante', 7, 1),
('Suco', 8, 1),
('Hamburguer', 12, 2),
('Batata frita', 9, 2);

CREATE TABLE IF NOT EXISTS tb_item_pedido(
	--surrogate key
	cod_item_pedido SERIAL PRIMARY KEY,
	cod_item INT,
	cod_pedido INT,
	CONSTRAINT fk_item FOREIGN KEY (cod_item) REFERENCES tb_item(cod_item),
	CONSTRAINT fk_pedido FOREIGN KEY (cod_pedido) REFERENCES tb_pedido(cod_pedido)
	--(1, 4), (1, 4)
);
-------------------------------------------------------------------------------------
-- cadastro de cliente
-- vejamos como funciona um parâmetro com valor default
CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente (IN nome VARCHAR(200), IN codigo INT DEFAULT NULL)
LANGUAGE plpgsql
AS $$
BEGIN
	IF codigo IS NULL THEN
		INSERT INTO tb_cliente (nome) VALUES (nome);
	ELSE
		INSERT INTO tb_cliente (codigo, nome) VALUES (codigo, nome);
	END IF;
END;
$$

CALL sp_cadastrar_cliente ('Joáo da Silva');
CALL sp_cadastrar_cliente ('Maria Santos');
-------------------------------------------------------------------------------------
-- criar um pedido, como se o cliente entrasse no restaurante e pegasse a comanda
CREATE OR REPLACE PROCEDURE sp_criar_pedido(OUT cod_pedido INT, IN cod_cliente INT)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO tb_pedido (cod_cliente) VALUES (cod_cliente);
	SELECT LASTVAL() INTO cod_pedido;
END;
$$

DO
$$
DECLARE
	cod_cliente INT;
	cod_pedido INT;
BEGIN
	--pega o código da pessoa cujo nome é Maria Santos
	SELECT c.cod_cliente FROM tb_cliente c WHERE c.nome LIKE 'Maria Santos' INTO cod_cliente;
	CALL sp_criar_pedido (cod_pedido, cod_cliente);
	RAISE NOTICE 'Pedido de código % criado para o cliente %', cod_pedido, cod_cliente;
END;
$$








