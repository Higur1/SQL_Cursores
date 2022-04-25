CREATE DATABASE ExCursores

USE ExCursores
CREATE TABLE Filiais(
id_filial INT,
logradouro VARCHAR(3),
numero INT 

PRIMARY KEY (id_filial)
)

CREATE TABLE Cliente(
id_cliente INT IDENTITY,
nome VARCHAR(9),
filial INT,
gasto_final DECIMAL(7,2)

PRIMARY KEY (id_cliente),
FOREIGN KEY (filial) REFERENCES Filiais(id_filial)

)
INSERT INTO Filiais VALUES
(1,'R.A', 250),
(2,'R.B', 500),
(3,'R.C', 125)

INSERT INTO Cliente (nome, filial, gasto_final)VALUES
('Cliente1', 1, 6404.00),
('Cliente2', 1, 5652.00),
('Cliente3', 3, 1800.00),
('Cliente4', 2, 3536.00),
('Cliente5', 2, 8110.00),
('Cliente6', 2, 5256.00),
('Cliente7', 2, 6879.00),
('Cliente8', 2, 7092.00),
('Cliente9', 3, 7976.00),
('Cliente10', 3, 4192.00),
('Cliente11', 3, 8278.00),
('Cliente12', 1, 8913.00)

CREATE FUNCTION fn_cli_fil_3()
RETURNS @tabela TABLE (
	id_cliente INT,
	nome_cliente VARCHAR(9),
	gasto_filial_3 DECIMAL (7,2),
	multa_filiais DECIMAL (7,2)

)
AS BEGIN
	DECLARE @id_cliente INT,
			@nome_cliente VARCHAR(9),
			@filial INT,
			@gasto DECIMAL(7,2),
			@gasto_filial_3 DECIMAL(7,2),
			@multa_filiais DECIMAL(7,2)
	DECLARE c_filiais CURSOR
	FOR SELECT id_cliente FROM Cliente
	OPEN  c_filiais
	FETCH NEXT FROM c_filiais INTO @id_cliente 
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @filial = (SELECT filial FROM Cliente WHERE id_cliente = @id_cliente)

		IF @filial = 3
		BEGIN
			SET @nome_cliente = (SELECT nome FROM Cliente WHERE id_cliente = @id_cliente)
			SET @gasto = (SELECT gasto_final FROM Cliente WHERE id_cliente = @id_cliente)
			SET @gasto_filial_3 = 
				CASE 
					WHEN @gasto <= 3000.00 THEN @gasto * 0.85
					WHEN @gasto > 3000.00 and @gasto <= 6000.00 THEN @gasto * 0.75
					WHEN @gasto > 6000.00 THEN @gasto * 0.65
				END
			SET @multa_filiais = 
				CASE 
					WHEN @gasto <= 3000.00 THEN @gasto * 0.15
					WHEN @gasto > 3000.00 and @gasto <= 6000.00 THEN @gasto * 0.25
					WHEN @gasto > 6000.00 THEN @gasto * 0.35
				END

			INSERT INTO @tabela VALUES
			(@id_cliente, @nome_cliente, @gasto_filial_3, @multa_filiais)
		END
		FETCH NEXT FROM c_filiais INTO @id_cliente
	END
	CLOSE c_filiais
	DEALLOCATE c_filiais

	RETURN
END

SELECT * FROM  fn_cli_fil_3()