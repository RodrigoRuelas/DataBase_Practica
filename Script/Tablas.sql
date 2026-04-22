-- Tabla Cliente
CREATE TABLE Cliente (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
	TipoCliente CHAR(1) NOT NULL CHECK (TipoCliente IN ('N', 'E')), -- 'N' natural, 'E' empresa
    Direccion1 NVARCHAR(100) NOT NULL,
    Direccion2 NVARCHAR(100),
    Telefono NVARCHAR(20)
);

-- Tabla Natural
CREATE TABLE ClienteNatural (
    idCliente INT PRIMARY KEY,
    DNI CHAR(8) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    ApellidoP NVARCHAR(100) NOT NULL,
    ApellidoM NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Natural_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT UQ_DNI UNIQUE (DNI) -- Restriccion unique: no puede haber dos personas con el mismo DNI
);

-- Tabla Empresa
CREATE TABLE ClienteEmpresa (
    idCliente INT PRIMARY KEY,
    RUC CHAR(11) NOT NULL,
    RazonSocial NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Empresa_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
	CONSTRAINT UQ_RUC UNIQUE (RUC), -- Restriccion unique: no puede haber dos empresas con el mismo RUC
	CONSTRAINT UQ_RazonSocial UNIQUE (RazonSocial) -- Restriccion unique: no puede haber dos empresas con la misma Razon Social
);