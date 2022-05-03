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
CREATE OR REPLACE PROCEDURE sp_acha_maior (OUT resultado INT, IN valor1 INT, IN valor2 INT)
LANGUAGE plpgsql
AS $$
BEGIN
	CASE
		WHEN valor1 > valor2 THEN
			-- resultado := valor1;
			$1 := valor1;
		ELSE
			resultado := valor2;
	END CASE;
END;
$$

DO
$$
DECLARE
	resultado INT;
BEGIN
	CALL sp_acha_maior(resultado, 2, 3);
	RAISE NOTICE '% é o maior', resultado;
END;
$$

--DROP PROCEDURE IF EXISTS sp_acha_maior;
CREATE OR REPLACE PROCEDURE sp_acha_maior (INOUT valor1 INT, IN valor2 INT)
LANGUAGE plpgsql
AS $$
BEGIN
	IF valor2 > valor1 THEN
		-- 2 := valor2;
		valor1 := valor2;
	END IF;
END;
$$

DO $$
DECLARE
	valor1 INT := 2;
	valor2 INT := 3;	
BEGIN
	CALL sp_acha_maior(valor1, valor2);
	RAISE NOTICE '% é o maior', valor1;
END;
$$










