CREATE PROCEDURE sp_ola_procedures()
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE 'Olá, procedimentos!!';
END;
$$

CALL sp_ola_procedures();

--def ola (nome):
	-- print ("Hello, " + nome)
-- nome é um parâmetro formal

--ola('Pedro')

CREATE OR REPLACE PROCEDURE sp_ola_usuario(IN nome VARCHAR(200))
LANGUAGE plpgsql
AS $$
BEGIN
	-- acessando o parâmetro pelo nome
	RAISE NOTICE 'Olá, %', nome;
	-- assim também vale
	RAISE NOTICE 'Olá, %', $1;
END
$$
-- actual parameter
CALL sp_ola_usuario('Pedro');
--var := sp_ola_usuario('Pedro');

-- sqrt(2): zero reusabilidade
CREATE OR REPLACE PROCEDURE sp_acha_maior (IN valor1 INT, IN valor2 INT)
LANGUAGE plpgsql
AS $$
BEGIN
	IF valor1 > valor2 THEN
		RAISE NOTICE '% é o maior', valor1;
	ELSE
		RAISE NOTICE '% é o maior', valor2;
	END IF;
END
$$

CALL sp_acha_maior(2, 3);

-- DROP PROCEDURE IF EXISTS sp_acha_maior;
CREATE OR REPLACE PROCEDURE sp_acha_maior











