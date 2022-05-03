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
-------------------------------------------------------------------------------------
-- adicionar um item a um pedido
CREATE OR REPLACE PROCEDURE sp_adicionar_item_a_pedido(IN cod_item INT, IN cod_pedido INT)
LANGUAGE plpgsql
AS $$
BEGIN
	-- inserir um novo item ao pedido
	INSERT INTO tb_item_pedido (cod_item, cod_pedido) VALUES (cod_item, cod_pedido);
	-- atualizar a data de modificação do pedido
	UPDATE tb_pedido p SET data_modificacao = CURRENT_TIMESTAMP WHERE p.cod_pedido = $2;
END;
$$
SELECT * FROM tb_item;
SELECT * FROM tb_pedido;
CALL sp_adicionar_item_a_pedido(1, 1);
CALL sp_adicionar_item_a_pedido(3, 1);
SELECT * FROM tb_item_pedido;
-------------------------------------------------------------------------------------
-- calcular valor total de um pedido
CREATE OR REPLACE PROCEDURE sp_calcular_valor_de_um_pedido (IN p_cod_pedido INT, OUT p_valor_total INT)
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT SUM(valor) FROM
	tb_pedido p
	INNER JOIN tb_item_pedido ip ON
	p.cod_pedido = ip.cod_pedido
	INNER JOIN tb_item i ON
	i.cod_item = ip.cod_item
	WHERE p.cod_pedido = p_cod_pedido
	INTO p_valor_total;
END;
$$

DO $$
DECLARE
	valor_total INT;
	cod_pedido INT := 1;
BEGIN
	CALL sp_calcular_valor_de_um_pedido(cod_pedido, valor_total);
	RAISE NOTICE 'Total do pedido %: R$ %', cod_pedido, valor_total;
END;
$$










