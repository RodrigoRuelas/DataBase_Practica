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

-- Tabla Categoría
CREATE TABLE Categoria (
    idCategoria INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Nombre UNIQUE (Nombre) -- Restriccion unique: no se puede repetir dos nombre de categorias
);

-- Tabla Producto
CREATE TABLE Producto (
    idProducto INT IDENTITY(1,1) PRIMARY KEY,
    codeProducto NVARCHAR(10) NOT NULL,
    nombreProducto NVARCHAR(100) NOT NULL,
    idCategoria INT,
    precioUnitario DECIMAL(10, 2) DEFAULT 0.00,
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria),
    CONSTRAINT UQ_codeProducto UNIQUE (codeProducto), -- Restriccion unique: dos productos no pueden tener un mismo codigo 
    CONSTRAINT CHK_precioUnitario CHECK (precioUnitario >= 0) -- Restriccion check: los precios de los productos deben ser mayores o iguales que 0.00
);

-- Tabla Zona de Inventario
CREATE TABLE Zona (
    idZona INT IDENTITY(1,1) PRIMARY KEY,
    NombreZona NVARCHAR(50) NOT NULL UNIQUE, -- Ejemplo: 'Almacén Central', 'Pasillo A', 'Exhibición'
    Descripcion NVARCHAR(200)
);

-- Tabla Inventario (Corregida: Relación Producto-Zona)
CREATE TABLE Inventario (
    idInventario INT IDENTITY(1,1) PRIMARY KEY,
    idZona INT NOT NULL, 
    idProducto INT NOT NULL,
    StockActual INT DEFAULT 0,
    CONSTRAINT FK_Inventario_Zona FOREIGN KEY (idZona) REFERENCES Zona(idZona),
    CONSTRAINT FK_Inventario_Producto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    CONSTRAINT UQ_Zona_Producto UNIQUE (idZona, idProducto), -- Un producto puede estar en varias zonas, pero no repetirse en la misma
    CONSTRAINT CHK_StockNoNegativo CHECK (StockActual >= 0) -- Restriccion check: no puede haber stock negativo en los productos
);

-- Tabla Movimientos (En lugar de Entrada/Salida por separado)
CREATE TABLE MovimientoInventario (
    idMovimiento INT IDENTITY(1,1) PRIMARY KEY,
    idProducto INT NOT NULL,
    idZona INT NOT NULL, 
    TipoMovimiento CHAR(1) CHECK (TipoMovimiento IN ('E', 'S')), -- E: Entrada, S: Salida
    Cantidad INT NOT NULL,
    Fecha DATETIME DEFAULT GETDATE(), -- Incluye la hora para mayor precisión
    CONSTRAINT FK_Movimiento_Producto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    CONSTRAINT FK_Movimiento_Zona FOREIGN KEY (idZona) REFERENCES Zona(idZona),
    CONSTRAINT CHK_CantidadMovimiento CHECK (Cantidad > 0) -- Restriccion check: no puede haber movimientos negativos
);

-- Tabla Venta
CREATE TABLE Venta (
    idVenta INT IDENTITY(1,1) PRIMARY KEY,
    numComprobante NVARCHAR(20) NOT NULL,
    tipoComprobante NVARCHAR(50) NOT NULL,
    fechaVenta DATETIME DEFAULT GETDATE(),
    idCliente INT NOT NULL,
    Subtotal DECIMAL(12, 2) NOT NULL,
    IGV DECIMAL(12, 2) NOT NULL,
    Descuento DECIMAL(12, 2) DEFAULT 0.00,
    Total DECIMAL(12, 2) NOT NULL,
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Tabla DetalleVenta
CREATE TABLE DetalleVenta (
    idDetalleVenta INT IDENTITY(1,1) PRIMARY KEY,
    idVenta INT NOT NULL,
    idProducto INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitarioVenta DECIMAL(12, 2) NOT NULL,
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);