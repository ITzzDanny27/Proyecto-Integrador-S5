-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-01-2024 a las 23:38:19
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `minimarket`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `FiltrarFechaDetalle` (IN `fechaMin` DATETIME, IN `fechaMax` DATETIME)   BEGIN
    SELECT
        hd.ID_DETALLE,
        hd.ID_VENTA,
        hd.CODIGO,
        hd.NOMBRE,
        hd.PRECIO,
        hd.CANTIDAD,
        hd.TOTAL,
        hd.FECHA
    FROM 
        historial_detalle hd
    WHERE 
        hd.FECHA >= fechaMin
        AND hd.FECHA < DATE_ADD(fechaMax, INTERVAL 1 DAY);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `FiltrarProductosH_FECHA_X_ACCION` (IN `fecha_inicio` DATETIME, IN `fecha_fin` DATETIME, IN `acciones` VARCHAR(10))   SELECT 
    c.categoria,
    hp.CODIGO,
    hp.NOMBRE,
    hp.PROVEEDOR,
    hp.STOCK,
    hp.STOCK_EDITADO,
    hp.PRECIO_COMPRA,
    hp.PRECIO_COMPRA_EDITADO,
    hp.PRECIO_VENTA,
    hp.PRECIO_VENTA_EDITADO,
    hp.FECHA_HORA,
    hp.ACCION
FROM 
    historial_productos hp
INNER JOIN 
    categoria c 
ON 
    c.ID_CATEGORIA = hp.ID_CATEGORIA
WHERE 
    hp.FECHA_HORA >= fecha_inicio
    AND hp.FECHA_HORA < DATE_ADD(fecha_fin, INTERVAL 1 DAY)
    AND hp.ACCION LIKE CONCAT('%',acciones, '%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `FiltrarVentas_FECHA_X_ACCION` (IN `fecha_inicio` DATETIME, IN `fecha_fin` DATETIME, IN `acciones` VARCHAR(10))   BEGIN
SELECT
     hv.ID_VENTA,
        hv.ID_USUARIO,
        hv.IDENTIFICACION,
        hv.SUBTOTAL,
        hv.DESCUENTO,
        hv.TOTAL,
        hv.FECHA,
        hv.ACCION
    FROM 
        historial_ventas hv
    WHERE 
        hv.FECHA >= fecha_inicio
        AND hv.FECHA < DATE_ADD(fecha_fin, INTERVAL 1 DAY)
        AND hv.ACCION LIKE CONCAT('%', acciones, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `FiltrarVentas_FECHA_X_ACC_USUARIO` (IN `fecha_inicio` DATETIME, IN `fecha_fin` DATETIME, IN `acciones` VARCHAR(10), IN `id_usuario` INT)   BEGIN
    SELECT
        hv.ID_VENTA,
        hv.ID_USUARIO,
        hv.IDENTIFICACION,
        hv.SUBTOTAL,
        hv.DESCUENTO,
        hv.TOTAL,
        hv.FECHA,
        hv.ACCION
    FROM
        historial_ventas hv
    WHERE
        hv.FECHA >= fecha_inicio
        AND hv.FECHA < DATE_ADD(fecha_fin, INTERVAL 1 DAY)
        AND hv.ACCION LIKE CONCAT('%', acciones, '%')
        AND hv.ID_USUARIO = id_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GananciasPorVendedor` (IN `idUsuario` INT)   BEGIN
SELECT 
        d.ID_DETALLE,
        v.ID_USUARIO,
        p.NOMBRE,
        prov.RUC,
        p.PRECIO_COMPRA,
        p.PRECIO_VENTA,
        d.CANTIDAD,
        d.TOTAL AS SUBTOTAL,
        g.DESCUENTO,
        (d.TOTAL - g.DESCUENTO) AS TOTAL,
        g.GANANCIA_X_PRODUCTO,
        v.FECHA
    FROM ganancias g
    INNER JOIN detalle d ON d.ID_DETALLE = g.ID_DETALLE
    INNER JOIN ventas v ON d.ID_VENTA = v.ID_VENTA
    INNER JOIN productos p ON d.ID_PRODUCTO = p.ID_PRODUCTO
    INNER JOIN proveedor prov ON p.ID_PROVEEDOR = prov.ID_PROVEEDOR
    WHERE v.ID_USUARIO=idUsuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gananciasPorVendedorH` (IN `idUsuario` INT, IN `fecha_inicio` DATETIME, IN `fecha_fin` DATETIME)   BEGIN
SELECT 
id_detalle,
id_usuario,
producto,
precio_compra,
precio_venta,
cantidad,
subtotal,
descuento,
total,
ganancia,
fecha_registro
FROM historial_ganancias 
WHERE id_usuario=idUsuario 
AND fecha_registro >= fecha_inicio
AND fecha_registro < DATE_ADD(fecha_fin, INTERVAL 1 DAY);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HistorialProductosXCategoria` (IN `ID_CATEGORIA` INT)   BEGIN
SELECT 
    c.categoria,
    hp.CODIGO,
    hp.NOMBRE,
    hp.PROVEEDOR,
    hp.STOCK,
    hp.STOCK_EDITADO,
    hp.PRECIO_COMPRA,
    hp.PRECIO_COMPRA_EDITADO,
    hp.PRECIO_VENTA,
    hp.PRECIO_VENTA_EDITADO,
    hp.FECHA_HORA,
    hp.ACCION
FROM 
    historial_productos hp
INNER JOIN 
    categoria c 
ON 
    c.ID_CATEGORIA = hp.ID_CATEGORIA
WHERE 
    hp.ID_CATEGORIA = ID_CATEGORIA;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HistorialProductosXProveedor` (IN `proveedor` VARCHAR(20))   BEGIN
SELECT 
    c.categoria,
    hp.CODIGO,
    hp.NOMBRE,
    hp.PROVEEDOR,
    hp.STOCK,
    hp.STOCK_EDITADO,
    hp.PRECIO_COMPRA,
    hp.PRECIO_COMPRA_EDITADO,
    hp.PRECIO_VENTA,
    hp.PRECIO_VENTA_EDITADO,
    hp.FECHA_HORA,
    hp.ACCION
FROM 
    historial_productos hp
INNER JOIN 
    categoria c 
ON 
    c.ID_CATEGORIA = hp.ID_CATEGORIA
WHERE 
    hp.PROVEEDOR LIKE CONCAT('%', proveedor, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MostrarVentasPorVendedor` (IN `vendedorID` INT)   BEGIN
    SELECT 
        v.ID_VENTA, 
        v.ID_USUARIO, 
        c.IDENTIFICACION, 
        v.Subtotal, 
        v.Descuento, 
        v.Total, 
        v.FECHA
    FROM 
        ventas AS v
    INNER JOIN 
        usuarios AS u ON v.ID_USUARIO = u.ID_USUARIO
    INNER JOIN 
        clientes AS c ON v.ID_CLIENTE = c.ID_CLIENTE
    WHERE 
        u.ID_USUARIO = vendedorID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerGananciasRango` (IN `gMin` FLOAT(4), IN `gMax` FLOAT(4))   BEGIN
    SELECT 
        g.ID_DETALLE,        
        v.ID_USUARIO,          
        p.NOMBRE,              
        prov.RUC,              
        p.PRECIO_COMPRA,       
        p.PRECIO_VENTA,        
        d.CANTIDAD,            
        d.TOTAL AS SUBTOTAL,   
        g.DESCUENTO,           
        (d.TOTAL - g.DESCUENTO) AS TOTAL, 
        g.GANANCIA_X_PRODUCTO  
    FROM 
        ganancias g
    INNER JOIN 
        detalle d ON d.ID_DETALLE = g.ID_DETALLE
    INNER JOIN 
        ventas v ON d.ID_VENTA = v.ID_VENTA
    INNER JOIN 
        productos p ON d.ID_PRODUCTO = p.ID_PRODUCTO
    INNER JOIN 
        proveedor prov ON prov.ID_PROVEEDOR = p.ID_PROVEEDOR
    WHERE 
        g.GANANCIA_X_PRODUCTO BETWEEN gMin AND gMax;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerGananciasRangoH` (IN `gMin` FLOAT, IN `gMax` FLOAT)   SELECT * FROM historial_ganancias  
WHERE ganancia BETWEEN gMin AND gMax$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosFecha` (IN `fecha_cad` DATE)   BEGIN
    SELECT
        c.CATEGORIA,
        p.CODIGO,
        p.NOMBRE,
        p.PROVEEDOR,
        p.STOCK,
        p.PRECIO_COMPRA,
        p.PRECIO_VENTA,
        p.FECHA_CADUCACION
    FROM productos p
    INNER JOIN categoria c ON c.ID_CATEGORIA = p.ID_CATEGORIA
    WHERE p.FECHA_CADUCACION = fecha_cad;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosPorStock` (IN `stockMinimo` INT, IN `stockMaximo` INT)   BEGIN
    SELECT 
        c.CATEGORIA,
        p.CODIGO,
        p.NOMBRE,
        p.PROVEEDOR,
        p.STOCK,
        p.PRECIO_COMPRA,
        p.PRECIO_VENTA,
        p.FECHA_CADUCACION
    FROM productos p 
    INNER JOIN categoria c ON c.ID_CATEGORIA = p.ID_CATEGORIA
    WHERE p.STOCK BETWEEN stockMinimo AND stockMaximo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosXCategoria` (IN `ID_CATEGORIA` INT)   SELECT 
        c.CATEGORIA,
        p.CODIGO,
        p.NOMBRE,
        p.PROVEEDOR,
        p.STOCK,
        p.PRECIO_COMPRA,
        p.PRECIO_VENTA,
        p.FECHA_CADUCACION
    FROM productos p 
    INNER JOIN categoria c ON c.ID_CATEGORIA = p.ID_CATEGORIA
    WHERE c.ID_CATEGORIA=ID_CATEGORIA$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosXPrecio_Compra` (IN `precioC_Min` FLOAT, IN `precioC_Max` FLOAT)   BEGIN
SELECT 
      c.CATEGORIA,
      p.CODIGO,
      p.NOMBRE,
      p.PROVEEDOR,
      p.STOCK,
      p.PRECIO_COMPRA,
      p.PRECIO_VENTA,
      p.FECHA_CADUCACION
      FROM productos p
INNER JOIN categoria c ON c.ID_CATEGORIA = p.ID_CATEGORIA
    WHERE p.PRECIO_COMPRA BETWEEN precioC_Min AND precioC_Max;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosXPrecio_Venta` (IN `precioV_min` INT, IN `precioV_max` INT)   BEGIN
SELECT 
        c.CATEGORIA,
        p.CODIGO,
        p.NOMBRE,
        p.PROVEEDOR,
        p.STOCK,
        p.PRECIO_COMPRA,
        p.PRECIO_VENTA,
        p.FECHA_CADUCACION
    FROM productos p 
    INNER JOIN categoria c ON c.ID_CATEGORIA = p.ID_CATEGORIA
    WHERE p.PRECIO_VENTA BETWEEN precioV_min AND precioV_max;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosXProveedor` (IN `ID_PROVEEDOR` INT)   SELECT 
        c.CATEGORIA,
        p.CODIGO,
        p.NOMBRE,
        p.PROVEEDOR,
        p.STOCK,
        p.PRECIO_COMPRA,
        p.PRECIO_VENTA,
        p.FECHA_CADUCACION
    FROM productos p 
    INNER JOIN categoria c ON c.ID_CATEGORIA = p.ID_CATEGORIA
    INNER JOIN proveedor pro ON pro.ID_PROVEEDOR = p.ID_PROVEEDOR
    WHERE pro.ID_PROVEEDOR=ID_PROVEEDOR$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarVentaDetalleGanancia` (IN `_ID_VENTA` INT, IN `_ID_PRODUCTO` INT, IN `_DESCUENTO` FLOAT(10,2), IN `_GANANCIA_X_PRODUCTO` FLOAT(10,2), OUT `_ID_DETALLE` INT)   BEGIN
    -- Obtiene el ID_DETALLE existente para la venta y producto actuales.
    SELECT ID_DETALLE INTO _ID_DETALLE
    FROM detalle
    WHERE ID_PRODUCTO = _ID_PRODUCTO AND ID_VENTA = _ID_VENTA;
    
    -- Si no hay un detalle existente, inserta uno nuevo y obtén el ID_DETALLE generado automáticamente.
    IF _ID_DETALLE IS NULL THEN
        INSERT INTO detalle (ID_PRODUCTO, ID_VENTA, precio, cantidad, total) 
        VALUES (_ID_PRODUCTO, _ID_VENTA, _PRECIO, _CANTIDAD, _TOTAL);

        -- Obtén el ID_DETALLE generado automáticamente.
        SET _ID_DETALLE = LAST_INSERT_ID();
    END IF;

    -- Inserta la ganancia usando el ID_DETALLE obtenido.
    INSERT INTO ganancias (ID_DETALLE, ID_VENTA, ID_PRODUCTO, DESCUENTO, GANANCIA_X_PRODUCTO) 
    VALUES (_ID_DETALLE,_ID_VENTA, _ID_PRODUCTO, _DESCUENTO, _GANANCIA_X_PRODUCTO);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `ID_CATEGORIA` int(11) NOT NULL,
  `CATEGORIA` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`ID_CATEGORIA`, `CATEGORIA`) VALUES
(1, 'ABARROTES'),
(2, 'ENLATADOS'),
(3, 'LÁCTEOS'),
(4, 'BOTANAS'),
(5, 'DULCES'),
(6, 'BEBIDAS'),
(7, 'EMBUTIDOS'),
(8, 'HIGIENE'),
(9, 'USO DOMESTICO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `ID_CLIENTE` int(11) NOT NULL,
  `IDENTIFICACION` varchar(15) NOT NULL,
  `NOMBRE` varchar(20) NOT NULL,
  `APELLIDO` varchar(20) NOT NULL,
  `CORREO` varchar(50) DEFAULT NULL,
  `TELEFONO` varchar(15) DEFAULT NULL,
  `DIRECCION` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`ID_CLIENTE`, `IDENTIFICACION`, `NOMBRE`, `APELLIDO`, `CORREO`, `TELEFONO`, `DIRECCION`) VALUES
(11, '9999999999', 'Consumidor Final', 'XXXXXXXXXXX', 'XXXXXXXXXXX', '9999999999', 'XXXXXXXXXXX'),
(17, '2350918856', 'moises', 'loor', 'moisesloor6@gmail.com', '01899727272', 'Calle 4, Ciudad');

--
-- Disparadores `clientes`
--
DELIMITER $$
CREATE TRIGGER `VerificarCorreoInsertClientes` BEFORE INSERT ON `clientes` FOR EACH ROW BEGIN
    IF NOT INSTR(NEW.CORREO, '@') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo debe contener un @';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificarCorreoUpdateClientes` BEFORE UPDATE ON `clientes` FOR EACH ROW BEGIN
    IF NOT INSTR(NEW.CORREO, '@') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo debe contener un @';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle`
--

CREATE TABLE `detalle` (
  `ID_DETALLE` int(11) NOT NULL,
  `ID_PRODUCTO` int(11) NOT NULL,
  `ID_VENTA` int(11) NOT NULL,
  `PRECIO` float(10,2) NOT NULL,
  `CANTIDAD` int(11) NOT NULL,
  `TOTAL` float(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle`
--

INSERT INTO `detalle` (`ID_DETALLE`, `ID_PRODUCTO`, `ID_VENTA`, `PRECIO`, `CANTIDAD`, `TOTAL`) VALUES
(1, 91, 1, 1.00, 3, 3.00),
(2, 93, 1, 0.50, 5, 2.50),
(3, 95, 2, 0.50, 3, 1.50),
(4, 96, 2, 3.50, 3, 10.50);

--
-- Disparadores `detalle`
--
DELIMITER $$
CREATE TRIGGER `after_insert_detalles` AFTER INSERT ON `detalle` FOR EACH ROW BEGIN

    -- No necesitas declarar estas variables si solo vas a utilizar la información de NEW

    -- Insertando en la tabla historial_detalle
    INSERT INTO historial_detalle(
        ID_DETALLE,
        ID_PRODUCTO,
        CODIGO,
        NOMBRE,
        ID_VENTA,
        ID_USUARIO,
        IDENTIFICACION,
        PRECIO,
        CANTIDAD,
        TOTAL,
        FECHA
    ) VALUES (
        NEW.ID_DETALLE,
        NEW.ID_PRODUCTO,
        (SELECT CODIGO FROM productos WHERE ID_PRODUCTO = NEW.ID_PRODUCTO),
        (SELECT NOMBRE FROM productos WHERE ID_PRODUCTO = NEW.ID_PRODUCTO),
        NEW.ID_VENTA, 
        (SELECT ID_USUARIO FROM ventas WHERE ID_VENTA = NEW.ID_VENTA),
        (SELECT IDENTIFICACION FROM clientes WHERE ID_CLIENTE = (SELECT ID_CLIENTE FROM ventas WHERE ID_VENTA = NEW.ID_VENTA)),
        NEW.PRECIO,
        NEW.CANTIDAD,
        NEW.TOTAL,  
        NOW()
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ganancias`
--

CREATE TABLE `ganancias` (
  `ID_GANANCIA` int(11) NOT NULL,
  `ID_VENTA` int(11) DEFAULT NULL,
  `ID_PRODUCTO` int(11) DEFAULT NULL,
  `ID_DETALLE` int(11) DEFAULT NULL,
  `DESCUENTO` float(10,2) DEFAULT NULL,
  `GANANCIA_X_PRODUCTO` float(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ganancias`
--

INSERT INTO `ganancias` (`ID_GANANCIA`, `ID_VENTA`, `ID_PRODUCTO`, `ID_DETALLE`, `DESCUENTO`, `GANANCIA_X_PRODUCTO`) VALUES
(3, 2, 95, 3, 0.15, 0.60),
(4, 2, 96, 4, 1.05, 2.70);

--
-- Disparadores `ganancias`
--
DELIMITER $$
CREATE TRIGGER `after_insert_ganancia` AFTER INSERT ON `ganancias` FOR EACH ROW BEGIN
    INSERT INTO historial_ganancias (
        id_detalle, 
        id_usuario, 
        producto, 
        precio_compra, 
        precio_venta, 
        cantidad, 
        subtotal, 
        descuento, 
        total, 
        ganancia, 
        fecha_registro
    )
    SELECT 
        NEW.ID_DETALLE,
        v.ID_USUARIO,
        p.NOMBRE,
        p.PRECIO_COMPRA,
        p.PRECIO_VENTA,
        d.CANTIDAD,
        d.TOTAL AS SUBTOTAL,
        NEW.DESCUENTO,
        (d.TOTAL - NEW.DESCUENTO) AS TOTAL,
        NEW.GANANCIA_X_PRODUCTO,
        NOW()
    FROM detalle d
    INNER JOIN ventas v ON d.ID_VENTA = v.ID_VENTA
    INNER JOIN productos p ON d.ID_PRODUCTO = p.ID_PRODUCTO
    INNER JOIN proveedor prov ON p.ID_PROVEEDOR = prov.ID_PROVEEDOR
    WHERE d.ID_DETALLE = NEW.ID_DETALLE;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_detalle`
--

CREATE TABLE `historial_detalle` (
  `ID_HISTORIAL` int(11) NOT NULL,
  `ID_DETALLE` int(11) NOT NULL,
  `ID_PRODUCTO` int(11) NOT NULL,
  `CODIGO` varchar(20) NOT NULL,
  `NOMBRE` varchar(40) NOT NULL,
  `ID_VENTA` int(11) NOT NULL,
  `ID_USUARIO` int(11) NOT NULL,
  `IDENTIFICACION` varchar(15) NOT NULL,
  `PRECIO` float(10,2) NOT NULL,
  `CANTIDAD` int(11) NOT NULL,
  `TOTAL` float(10,2) NOT NULL,
  `FECHA` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_detalle`
--

INSERT INTO `historial_detalle` (`ID_HISTORIAL`, `ID_DETALLE`, `ID_PRODUCTO`, `CODIGO`, `NOMBRE`, `ID_VENTA`, `ID_USUARIO`, `IDENTIFICACION`, `PRECIO`, `CANTIDAD`, `TOTAL`, `FECHA`) VALUES
(1, 1, 45, '56456', 'pancho', 121, 1, '9999999999', 1.00, 1, 1.00, '2024-01-18 16:31:23'),
(2, 2, 28, '35', 'GDFDGFSS', 121, 1, '9999999999', 10.00, 3, 30.00, '2024-01-18 16:31:23'),
(3, 3, 28, '35', 'GDFDGFSS', 122, 1, '9999999999', 10.00, 5, 50.00, '2024-01-18 16:43:33'),
(4, 4, 45, '56456', 'pancho', 122, 1, '9999999999', 1.00, 1, 1.00, '2024-01-18 16:43:33'),
(5, 5, 45, '56456', 'pancho', 123, 1, '9999999999', 1.00, 12, 12.00, '2024-01-18 16:54:17'),
(6, 6, 29, '3543', 'GDFDGFSS', 123, 1, '9999999999', 10.00, 4, 40.00, '2024-01-18 16:54:17'),
(7, 7, 45, '56456', 'pancho', 124, 1, '9999999999', 1.00, 3, 3.00, '2024-01-18 17:07:17'),
(8, 8, 28, '35', 'GDFDGFSS', 124, 1, '9999999999', 10.00, 4, 40.00, '2024-01-18 17:07:17'),
(9, 9, 45, '56456', 'pancho', 125, 1, '9999999999', 1.00, 5, 5.00, '2024-01-18 17:11:53'),
(10, 10, 53, '5454', 'gfgfgf', 125, 1, '9999999999', 6.00, 5, 30.00, '2024-01-18 17:11:53'),
(11, 1, 55, '545232', 'Leche Condensada hTA', 126, 1, '9999999999', 3.00, 3, 9.00, '2024-01-18 18:20:27'),
(12, 2, 57, '22323', 'Doritos ', 127, 1, '123456787', 0.50, 5, 2.50, '2024-01-18 18:21:14'),
(13, 3, 58, '91822', 'Nuggets Plumrose', 128, 1, '9999999999', 1.50, 3, 4.50, '2024-01-18 18:57:44'),
(14, 4, 57, '22323', 'Doritos ', 128, 1, '9999999999', 0.50, 3, 1.50, '2024-01-18 18:57:44'),
(15, 5, 60, '5646', 'fgfgdfgdf', 129, 1, '9999999999', 6.00, 2, 12.00, '2024-01-18 22:56:11'),
(16, 6, 54, '545454', 'Galletas JK', 129, 1, '9999999999', 0.50, 2, 1.00, '2024-01-18 22:56:11'),
(17, 7, 54, '545454', 'Galletas JK', 130, 1, '9999999999', 0.50, 4, 2.00, '2024-01-19 15:45:06'),
(18, 8, 56, '122132', 'Axion100', 131, 1, '9999999999', 4.00, 3, 12.00, '2024-01-20 11:07:34'),
(19, 9, 54, '545454', 'Galletas JK', 131, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 11:07:34'),
(20, 10, 64, '200', 'DFGFD', 132, 1, '087654321', 6.00, 3, 18.00, '2024-01-20 11:10:03'),
(21, 11, 54, '545454', 'Galletas JK', 133, 1, '32121332', 0.50, 3, 1.50, '2024-01-20 11:37:14'),
(22, 12, 56, '122132', 'Axion100', 133, 1, '32121332', 4.00, 4, 16.00, '2024-01-20 11:37:14'),
(23, 13, 62, '199', 'Yogurt Toni 1L ', 133, 1, '32121332', 3.00, 4, 12.00, '2024-01-20 11:37:14'),
(24, 14, 56, '122132', 'Axion100', 134, 1, '9999999999', 4.00, 3, 12.00, '2024-01-20 19:34:19'),
(25, 15, 72, '201', 'FDSSDF', 134, 1, '9999999999', 6.00, 3, 18.00, '2024-01-20 19:34:20'),
(26, 16, 64, '200', 'DFGFD', 135, 1, '9999999999', 6.00, 4, 24.00, '2024-01-20 20:48:02'),
(27, 17, 72, '201', 'FDSSDF', 136, 1, '9999999999', 6.00, 5, 30.00, '2024-01-20 20:51:43'),
(28, 18, 64, '200', 'DFGFD', 137, 1, '9999999999', 6.00, 5, 30.00, '2024-01-20 20:53:35'),
(29, 19, 56, '122132', 'Axion100', 138, 1, '9999999999', 4.00, 10, 40.00, '2024-01-20 20:55:54'),
(30, 20, 64, '200', 'DFGFD', 139, 1, '9999999999', 6.00, 5, 30.00, '2024-01-20 20:57:52'),
(31, 21, 64, '200', 'DFGFD', 140, 1, '9999999999', 6.00, 5, 30.00, '2024-01-20 20:59:28'),
(32, 22, 64, '200', 'DFGFD', 141, 1, '9999999999', 6.00, 5, 30.00, '2024-01-20 21:01:59'),
(33, 23, 72, '201', 'FDSSDF', 142, 1, '9999999999', 6.00, 5, 30.00, '2024-01-20 21:05:02'),
(34, 24, 64, '200', 'DFGFD', 143, 1, '9999999999', 6.00, 4, 24.00, '2024-01-20 21:06:44'),
(35, 25, 57, '22323', 'Doritos ', 144, 1, '9999999999', 0.50, 5, 2.50, '2024-01-20 21:11:39'),
(36, 26, 64, '200', 'DFGFD', 145, 1, '9999999999', 6.00, 4, 24.00, '2024-01-20 21:15:41'),
(37, 27, 72, '201', 'FDSSDF', 146, 1, '9999999999', 6.00, 4, 24.00, '2024-01-20 21:41:48'),
(38, 28, 54, '545454', 'Galletas JK', 147, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 22:38:26'),
(39, 29, 54, '545454', 'Galletas JK', 148, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 22:42:41'),
(40, 30, 55, '545232', 'Leche Condensada hTA', 148, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 22:42:41'),
(41, 31, 77, '2222', 'MIEL', 148, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 22:42:41'),
(42, 32, 54, '545454', 'Galletas JK', 149, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 23:02:14'),
(43, 33, 55, '545232', 'Leche Condensada hTA', 149, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 23:02:15'),
(44, 34, 77, '2222', 'MIEL', 149, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 23:02:15'),
(45, 35, 54, '545454', 'Galletas JK', 150, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 23:07:35'),
(46, 36, 55, '545232', 'Leche Condensada hTA', 150, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 23:07:35'),
(47, 37, 77, '2222', 'MIEL', 150, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 23:07:35'),
(48, 38, 54, '545454', 'Galletas JK', 151, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 23:09:49'),
(49, 39, 55, '545232', 'Leche Condensada hTA', 151, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 23:09:49'),
(50, 40, 77, '2222', 'MIEL', 151, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 23:09:50'),
(51, 41, 54, '545454', 'Galletas JK', 152, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 23:14:53'),
(52, 42, 55, '545232', 'Leche Condensada hTA', 152, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 23:14:53'),
(53, 43, 77, '2222', 'MIEL', 152, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 23:14:53'),
(54, 44, 54, '545454', 'Galletas JK', 153, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 23:25:16'),
(55, 45, 55, '545232', 'Leche Condensada hTA', 153, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 23:25:16'),
(56, 46, 77, '2222', 'MIEL', 153, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 23:25:16'),
(57, 47, 54, '545454', 'Galletas JK', 154, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 23:28:04'),
(58, 48, 55, '545232', 'Leche Condensada hTA', 154, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 23:28:04'),
(59, 49, 77, '2222', 'MIEL', 154, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 23:28:04'),
(60, 50, 54, '545454', 'Galletas JK', 155, 1, '9999999999', 0.50, 4, 2.00, '2024-01-20 23:57:46'),
(61, 51, 55, '545232', 'Leche Condensada hTA', 155, 1, '9999999999', 3.50, 3, 10.50, '2024-01-20 23:57:46'),
(62, 52, 77, '2222', 'MIEL', 155, 1, '9999999999', 5.50, 2, 11.00, '2024-01-20 23:57:46'),
(63, 53, 54, '545454', 'Galletas JK', 156, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 00:03:05'),
(64, 54, 55, '545232', 'Leche Condensada hTA', 156, 1, '9999999999', 3.50, 3, 10.50, '2024-01-21 00:03:05'),
(65, 55, 77, '2222', 'MIEL', 156, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 00:03:05'),
(66, 56, 54, '545454', 'Galletas JK', 157, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 00:27:46'),
(67, 57, 55, '545232', 'Leche Condensada hTA', 157, 1, '9999999999', 3.50, 3, 10.50, '2024-01-21 00:27:46'),
(68, 58, 77, '2222', 'MIEL', 157, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 00:27:46'),
(69, 59, 77, '2222', 'MIEL', 157, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 00:27:46'),
(70, 60, 77, '2222', 'MIEL', 157, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 00:28:03'),
(71, 61, 77, '2222', 'MIEL', 157, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 00:28:05'),
(72, 62, 54, '545454', 'Galletas JK', 158, 1, '9999999999', 0.50, 2, 1.00, '2024-01-21 00:33:45'),
(73, 63, 77, '2222', 'MIEL', 158, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 00:33:45'),
(74, 64, 54, '545454', 'Galletas JK', 159, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 01:04:01'),
(75, 65, 62, '199', 'Yogurt Toni 1L ', 159, 1, '9999999999', 3.00, 3, 9.00, '2024-01-21 01:04:01'),
(76, 66, 54, '545454', 'Galletas JK', 160, 1, '9999999999', 0.50, 3, 1.50, '2024-01-21 01:05:46'),
(77, 67, 62, '199', 'Yogurt Toni 1L ', 160, 1, '9999999999', 3.00, 4, 12.00, '2024-01-21 01:05:46'),
(78, 72, 60, '5646', 'fgfgdfgdf', 163, 1, '9999999999', 6.00, 3, 18.00, '2024-01-21 01:41:55'),
(79, 73, 55, '545232', 'Leche Condensada hTA', 163, 1, '9999999999', 3.50, 3, 10.50, '2024-01-21 01:41:55'),
(80, 74, 55, '545232', 'Leche Condensada hTA', 164, 1, '9999999999', 3.50, 3, 10.50, '2024-01-21 01:45:12'),
(81, 75, 62, '199', 'Yogurt Toni 1L ', 165, 1, '9999999999', 3.00, 2, 6.00, '2024-01-21 01:48:31'),
(82, 76, 57, '22323', 'Doritos ', 166, 1, '9999999999', 0.50, 3, 1.50, '2024-01-21 01:51:53'),
(83, 77, 54, '545454', 'Galletas JK', 167, 1, '9999999999', 0.50, 2, 1.00, '2024-01-21 13:42:10'),
(84, 78, 77, '2222', 'MIEL', 167, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 13:42:10'),
(85, 79, 77, '2222', 'MIEL', 168, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 13:45:00'),
(86, 80, 77, '2222', 'MIEL', 169, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 13:47:06'),
(87, 81, 54, '545454', 'Galletas JK', 170, 1, '9999999999', 0.50, 3, 1.50, '2024-01-21 13:51:11'),
(88, 82, 54, '545454', 'Galletas JK', 171, 1, '9999999999', 0.50, 3, 1.50, '2024-01-21 13:54:13'),
(89, 83, 77, '2222', 'MIEL', 172, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 13:55:46'),
(90, 84, 77, '2222', 'MIEL', 173, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 14:01:00'),
(91, 85, 55, '545232', 'Leche Condensada hTA', 174, 1, '9999999999', 3.50, 4, 14.00, '2024-01-21 14:04:46'),
(92, 86, 60, '5646', 'fgfgdfgdf', 175, 1, '9999999999', 6.00, 3, 18.00, '2024-01-21 14:06:47'),
(93, 87, 72, '201', 'FDSSDF', 176, 1, '9999999999', 6.00, 3, 18.00, '2024-01-21 14:10:46'),
(94, 88, 72, '201', 'FDSSDF', 176, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:10:47'),
(95, 89, 77, '2222', 'MIEL', 177, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 14:12:14'),
(96, 90, 54, '545454', 'Galletas JK', 177, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 14:12:14'),
(97, 91, 77, '2222', 'MIEL', 177, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:12:14'),
(98, 92, 54, '545454', 'Galletas JK', 177, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:12:15'),
(99, 93, 54, '545454', 'Galletas JK', 178, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 14:27:14'),
(100, 94, 55, '545232', 'Leche Condensada hTA', 178, 1, '9999999999', 3.50, 3, 10.50, '2024-01-21 14:27:14'),
(101, 95, 77, '2222', 'MIEL', 178, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 14:27:14'),
(102, 96, 54, '545454', 'Galletas JK', 178, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:27:14'),
(103, 97, 55, '545232', 'Leche Condensada hTA', 178, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:27:14'),
(104, 98, 77, '2222', 'MIEL', 178, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:27:15'),
(105, 99, 77, '2222', 'MIEL', 179, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 14:32:06'),
(106, 100, 54, '545454', 'Galletas JK', 179, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 14:32:06'),
(107, 101, 77, '2222', 'MIEL', 180, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 14:42:05'),
(108, 102, 77, '2222', 'MIEL', 181, 1, '9999999999', 5.50, 4, 22.00, '2024-01-21 14:51:51'),
(109, 103, 72, '201', 'FDSSDF', 181, 1, '9999999999', 6.00, 3, 18.00, '2024-01-21 14:51:51'),
(110, 104, 77, '2222', 'MIEL', 181, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:51:51'),
(111, 105, 72, '201', 'FDSSDF', 181, 1, '9999999999', 0.00, 0, 0.00, '2024-01-21 14:51:51'),
(112, 106, 77, '2222', 'MIEL', 182, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 15:01:18'),
(113, 107, 72, '201', 'FDSSDF', 183, 1, '9999999999', 6.00, 4, 24.00, '2024-01-21 15:04:43'),
(114, 109, 77, '2222', 'MIEL', 184, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 15:14:19'),
(115, 110, 77, '2222', 'MIEL', 185, 1, '9999999999', 5.50, 4, 22.00, '2024-01-21 15:16:56'),
(116, 111, 77, '2222', 'MIEL', 186, 1, '9999999999', 5.50, 4, 22.00, '2024-01-21 15:19:09'),
(117, 112, 54, '545454', 'Galletas JK', 187, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 15:21:33'),
(118, 113, 77, '2222', 'MIEL', 187, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 15:21:33'),
(119, 114, 54, '545454', 'Galletas JK', 188, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 18:59:17'),
(120, 115, 77, '2222', 'MIEL', 188, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 18:59:17'),
(121, 116, 54, '545454', 'Galletas JK', 189, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 19:01:05'),
(122, 117, 77, '2222', 'MIEL', 189, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 19:01:05'),
(123, 118, 54, '545454', 'Galletas JK', 190, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 19:03:47'),
(124, 119, 77, '2222', 'MIEL', 190, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 19:03:47'),
(125, 120, 54, '545454', 'Galletas JK', 191, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 19:08:34'),
(126, 121, 77, '2222', 'MIEL', 191, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 19:08:34'),
(127, 122, 77, '2222', 'MIEL', 192, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 19:16:05'),
(128, 123, 54, '545454', 'Galletas JK', 193, 1, '9999999999', 0.50, 4, 2.00, '2024-01-21 19:21:28'),
(129, 124, 55, '545232', 'Leche Condensada hTA', 193, 1, '9999999999', 3.50, 3, 10.50, '2024-01-21 19:21:28'),
(130, 125, 77, '2222', 'MIEL', 193, 1, '9999999999', 5.50, 2, 11.00, '2024-01-21 19:21:28'),
(131, 126, 77, '2222', 'MIEL', 194, 1, '9999999999', 5.50, 3, 16.50, '2024-01-21 21:46:49'),
(132, 127, 54, '545454', 'Galletas JK', 194, 1, '9999999999', 0.50, 2, 1.00, '2024-01-21 21:46:49'),
(133, 128, 77, '2222', 'MIEL', 195, 1, '9999999999', 5.50, 2, 11.00, '2024-01-22 00:24:30'),
(134, 129, 54, '545454', 'Galletas JK', 195, 1, '9999999999', 0.50, 4, 2.00, '2024-01-22 00:24:30'),
(135, 130, 55, '545232', 'Leche Condensada hTA', 196, 1, '9999999999', 3.50, 3, 10.50, '2024-01-22 01:32:50'),
(136, 131, 54, '545454', 'Galletas JK', 196, 1, '9999999999', 0.50, 4, 2.00, '2024-01-22 01:32:50'),
(137, 132, 72, '201', 'FDSSDF', 196, 1, '9999999999', 6.00, 2, 12.00, '2024-01-22 01:32:50'),
(138, 133, 54, '545454', 'Galletas JK', 197, 1, '9999999999', 0.50, 4, 2.00, '2024-01-22 15:40:28'),
(139, 134, 55, '545232', 'Leche Condensada hTA', 197, 1, '9999999999', 3.50, 3, 10.50, '2024-01-22 15:40:28'),
(140, 135, 54, '545454', 'Galletas JK', 198, 1, '9999999999', 0.50, 4, 2.00, '2024-01-22 16:21:22'),
(141, 136, 77, '2222', 'MIEL', 198, 1, '9999999999', 5.50, 2, 11.00, '2024-01-22 16:21:22'),
(142, 137, 54, '545454', 'Galletas JK', 199, 1, '9999999999', 0.50, 4, 2.00, '2024-01-22 16:23:39'),
(143, 138, 77, '2222', 'MIEL', 199, 1, '9999999999', 5.50, 2, 11.00, '2024-01-22 16:23:39'),
(144, 139, 54, '545454', 'Galletas JK', 200, 1, '9999999999', 0.50, 4, 2.00, '2024-01-22 16:25:41'),
(145, 140, 55, '545232', 'Leche Condensada hTA', 200, 1, '9999999999', 3.50, 3, 10.50, '2024-01-22 16:25:41'),
(146, 141, 54, '545454', 'Galletas JK', 201, 7, '087654321', 0.50, 4, 2.00, '2024-01-23 19:21:06'),
(147, 142, 55, '545232', 'Leche Condensada hTA', 201, 7, '087654321', 3.50, 3, 10.50, '2024-01-23 19:21:06'),
(148, 143, 57, '22323', 'Doritos ', 201, 7, '087654321', 0.50, 4, 2.00, '2024-01-23 19:21:06'),
(149, 144, 77, '2222', 'MIEL', 201, 7, '087654321', 5.50, 2, 11.00, '2024-01-23 19:21:06'),
(150, 145, 54, '545454', 'Galletas JK', 202, 7, '087654321', 0.50, 4, 2.00, '2024-01-23 19:26:08'),
(151, 146, 55, '545232', 'Leche Condensada hTA', 202, 7, '087654321', 3.50, 3, 10.50, '2024-01-23 19:26:08'),
(152, 147, 77, '2222', 'MIEL', 202, 7, '087654321', 5.50, 2, 11.00, '2024-01-23 19:26:08'),
(153, 148, 54, '545454', 'Galletas JK', 203, 7, '9999999999', 0.50, 4, 2.00, '2024-01-23 19:57:31'),
(154, 149, 55, '545232', 'Leche Condensada hTA', 203, 7, '9999999999', 3.50, 3, 10.50, '2024-01-23 19:57:31'),
(155, 150, 77, '2222', 'MIEL', 203, 7, '9999999999', 5.50, 2, 11.00, '2024-01-23 19:57:31'),
(156, 151, 54, '545454', 'Galletas JK', 204, 7, '9999999999', 0.50, 4, 2.00, '2024-01-23 19:59:04'),
(157, 152, 55, '545232', 'Leche Condensada hTA', 204, 7, '9999999999', 3.50, 3, 10.50, '2024-01-23 19:59:04'),
(158, 153, 77, '2222', 'MIEL', 204, 7, '9999999999', 5.50, 2, 11.00, '2024-01-23 19:59:04'),
(159, 154, 54, '545454', 'Galletas JK', 205, 7, '9999999999', 0.50, 4, 2.00, '2024-01-23 20:00:35'),
(160, 155, 54, '545454', 'Galletas JK', 206, 7, '9999999999', 0.50, 2, 1.00, '2024-01-23 20:05:21'),
(161, 156, 80, '211232', 'dfdfdfdfdfdfdfd', 206, 7, '9999999999', 7.00, 2, 14.00, '2024-01-23 20:05:21'),
(162, 157, 54, '545454', 'Galletas JK', 207, 7, '9999999999', 0.50, 1, 0.50, '2024-01-23 20:09:58'),
(163, 158, 83, '54545', 'gfgdfgfd', 208, 7, '123456787', 6.00, 4, 24.00, '2024-01-23 20:34:53'),
(164, 159, 83, '54545', 'gfgdfgfd', 209, 7, '123456787', 6.00, 1, 6.00, '2024-01-23 20:51:06'),
(165, 160, 54, '545454', 'Galletas JK', 209, 7, '123456787', 0.50, 1, 0.50, '2024-01-23 20:51:06'),
(166, 161, 55, '545232', 'Leche Condensada hTA', 209, 7, '123456787', 3.50, 2, 7.00, '2024-01-23 20:51:06'),
(167, 162, 82, '1818272', 'Maraja', 210, 7, '9999999999', 5.50, 3, 16.50, '2024-01-24 01:26:26'),
(168, 163, 85, '176627', 'mini cola -Coca Cola', 211, 7, '9999999999', 0.50, 4, 2.00, '2024-01-24 20:36:47'),
(169, 164, 86, '71282', 'Yogurt 1L - Toni', 211, 7, '9999999999', 3.50, 3, 10.50, '2024-01-24 20:36:47'),
(170, 165, 87, '718282', 'Miel-Orchata', 211, 7, '9999999999', 5.50, 2, 11.00, '2024-01-24 20:36:47'),
(171, 166, 89, '21212', 'Pipa-Nestle', 212, 7, '9999999999', 1.00, 4, 4.00, '2024-01-24 21:59:14'),
(172, 167, 89, '21212', 'Pipa-Nestle', 213, 7, '9999999999', 1.00, 3, 3.00, '2024-01-24 22:00:43'),
(173, 168, 84, '1818272', 'Maraja', 213, 7, '9999999999', 6.50, 3, 19.50, '2024-01-24 22:00:43'),
(174, 169, 87, '718282', 'Miel-Orchata', 214, 7, '9999999999', 5.50, 3, 16.50, '2024-01-24 22:02:59'),
(175, 170, 89, '21212', 'Pipa-Nestle', 214, 7, '9999999999', 1.00, 2, 2.00, '2024-01-24 22:02:59'),
(176, 171, 86, '71282', 'Yogurt 1L - Toni', 215, 7, '9999999999', 3.50, 3, 10.50, '2024-01-24 22:10:33'),
(177, 172, 80, '211232', 'dfdfdfdfdfdfdfd', 215, 7, '9999999999', 7.00, 2, 14.00, '2024-01-24 22:10:33'),
(178, 1, 91, '001', 'Leche-Lenutrit 1L', 1, 2, '9999999999', 1.00, 3, 3.00, '2024-01-25 16:23:12'),
(179, 2, 93, '003', 'Coca Cola Mini', 1, 2, '9999999999', 0.50, 5, 2.50, '2024-01-25 16:23:12'),
(180, 3, 95, '005', 'Doritos', 2, 1, '9999999999', 0.50, 3, 1.50, '2024-01-25 16:44:22'),
(181, 4, 96, '003', 'Lavaplatos-Axion', 2, 1, '9999999999', 3.50, 3, 10.50, '2024-01-25 16:44:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_ganancias`
--

CREATE TABLE `historial_ganancias` (
  `id_historial` int(11) NOT NULL,
  `id_detalle` int(11) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `producto` varchar(40) DEFAULT NULL,
  `precio_compra` float(10,2) DEFAULT NULL,
  `precio_venta` float(10,2) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `subtotal` float(10,2) DEFAULT NULL,
  `descuento` float(10,2) DEFAULT NULL,
  `total` float(10,2) NOT NULL,
  `ganancia` float(10,2) DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_ganancias`
--

INSERT INTO `historial_ganancias` (`id_historial`, `id_detalle`, `id_usuario`, `producto`, `precio_compra`, `precio_venta`, `cantidad`, `subtotal`, `descuento`, `total`, `ganancia`, `fecha_registro`) VALUES
(1, 133, 1, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.00, 2.00, 1.00, '2024-01-22'),
(2, 134, 1, 'Leche Condensada hTA', 2.25, 3.50, 3, 10.50, 0.00, 10.00, 3.75, '2024-01-22'),
(3, 137, 1, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.00, 2.00, 1.00, '2024-01-22'),
(4, 138, 1, 'MIEL', 3.50, 5.50, 2, 11.00, 0.00, 11.00, 4.00, '2024-01-22'),
(5, 139, 1, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.00, 2.00, 1.00, '2024-01-22'),
(6, 140, 1, 'Leche Condensada hTA', 2.25, 3.50, 3, 10.50, 0.00, 10.50, 3.75, '2024-01-22'),
(7, 141, 7, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.10, 1.90, 0.90, '2024-01-23'),
(8, 142, 7, 'Leche Condensada hTA', 2.25, 3.50, 3, 10.50, 0.53, 9.97, 3.23, '2024-01-23'),
(9, 143, 7, 'Doritos ', 0.25, 0.50, 4, 2.00, 0.10, 1.90, 0.90, '2024-01-23'),
(10, 144, 7, 'MIEL', 3.50, 5.50, 2, 11.00, 0.55, 10.45, 3.45, '2024-01-23'),
(11, 145, 7, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.10, 1.90, 0.90, '2024-01-23'),
(12, 146, 7, 'Leche Condensada hTA', 2.25, 3.50, 3, 10.50, 0.53, 9.97, 3.23, '2024-01-23'),
(13, 147, 7, 'MIEL', 3.50, 5.50, 2, 11.00, 0.55, 10.45, 3.45, '2024-01-23'),
(14, 148, 7, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.10, 1.90, 0.90, '2024-01-23'),
(15, 149, 7, 'Leche Condensada hTA', 2.25, 3.50, 3, 10.50, 0.53, 9.97, 3.23, '2024-01-23'),
(16, 150, 7, 'MIEL', 3.50, 5.50, 2, 11.00, 0.55, 10.45, 3.45, '2024-01-23'),
(17, 151, 7, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.10, 1.90, 0.90, '2024-01-23'),
(18, 152, 7, 'Leche Condensada hTA', 2.25, 3.50, 3, 10.50, 0.53, 9.97, 3.23, '2024-01-23'),
(19, 153, 7, 'MIEL', 3.50, 5.50, 2, 11.00, 0.55, 10.45, 3.45, '2024-01-23'),
(20, 154, 7, 'Galletas JK', 0.25, 0.50, 4, 2.00, 0.00, 2.00, 1.00, '2024-01-23'),
(21, 155, 7, 'Galletas JK', 0.25, 0.50, 2, 1.00, 0.00, 1.00, 0.50, '2024-01-23'),
(22, 156, 7, 'dfdfdfdfdfdfdfd', 6.00, 7.00, 2, 14.00, 0.00, 14.00, 2.00, '2024-01-23'),
(23, 157, 7, 'Galletas JK', 0.25, 0.50, 1, 0.50, 0.00, 0.50, 0.25, '2024-01-23'),
(24, 158, 7, 'gfgdfgfd', 5.00, 6.00, 4, 24.00, 1.20, 22.80, 2.80, '2024-01-23'),
(25, 159, 7, 'gfgdfgfd', 5.00, 6.00, 1, 6.00, 0.00, 6.00, 1.00, '2024-01-23'),
(26, 160, 7, 'Galletas JK', 0.25, 0.50, 1, 0.50, 0.00, 0.50, 0.25, '2024-01-23'),
(27, 161, 7, 'Leche Condensada hTA', 2.25, 3.50, 2, 7.00, 0.00, 7.00, 2.50, '2024-01-23'),
(28, 162, 7, 'Maraja', 3.50, 5.50, 3, 16.50, 0.00, 16.50, 6.00, '2024-01-24'),
(29, 163, 7, 'mini cola -Coca Cola', 0.25, 0.50, 4, 2.00, 0.10, 1.90, 0.90, '2024-01-24'),
(30, 164, 7, 'Yogurt 1L - Toni', 2.25, 3.50, 3, 10.50, 0.53, 9.97, 3.23, '2024-01-24'),
(31, 165, 7, 'Miel-Orchata', 3.50, 5.50, 2, 11.00, 0.55, 10.45, 3.45, '2024-01-24'),
(32, 166, 7, 'Pipa-Nestle', 0.40, 1.00, 4, 4.00, 0.00, 4.00, 2.40, '2024-01-24'),
(33, 167, 7, 'Pipa-Nestle', 0.40, 1.00, 3, 3.00, 0.15, 2.85, 1.65, '2024-01-24'),
(34, 168, 7, 'Maraja', 4.50, 6.50, 3, 19.50, 0.98, 18.52, 5.03, '2024-01-24'),
(35, 169, 7, 'Miel-Orchata', 3.50, 5.50, 3, 16.50, 0.82, 15.68, 5.17, '2024-01-24'),
(36, 170, 7, 'Pipa-Nestle', 0.40, 1.00, 2, 2.00, 0.10, 1.90, 1.10, '2024-01-24'),
(37, 171, 7, 'Yogurt 1L - Toni', 2.25, 3.50, 3, 10.50, 1.05, 9.45, 2.70, '2024-01-24'),
(38, 172, 7, 'dfdfdfdfdfdfdfd', 6.00, 7.00, 2, 14.00, 1.40, 12.60, 0.60, '2024-01-24'),
(39, 1, 2, 'Leche-Lenutrit 1L', 0.50, 1.00, 3, 3.00, 0.60, 2.40, 0.90, '2024-01-25'),
(40, 2, 2, 'Coca Cola Mini', 0.25, 0.50, 5, 2.50, 0.50, 2.00, 0.75, '2024-01-25'),
(41, 3, 1, 'Doritos', 0.25, 0.50, 3, 1.50, 0.15, 1.35, 0.60, '2024-01-25'),
(42, 4, 1, 'Lavaplatos-Axion', 2.25, 3.50, 3, 10.50, 1.05, 9.45, 2.70, '2024-01-25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_productos`
--

CREATE TABLE `historial_productos` (
  `ID_HISTORIAL` int(11) NOT NULL,
  `ID_CATEGORIA` int(11) NOT NULL,
  `ID_PRODUCTO` int(11) DEFAULT NULL,
  `ID_PROVEEDOR` int(11) DEFAULT NULL,
  `CODIGO` varchar(20) DEFAULT NULL,
  `NOMBRE` varchar(20) DEFAULT NULL,
  `PROVEEDOR` varchar(20) DEFAULT NULL,
  `STOCK` int(11) DEFAULT NULL,
  `STOCK_EDITADO` int(11) NOT NULL,
  `PRECIO_COMPRA` float(10,2) DEFAULT NULL,
  `PRECIO_COMPRA_EDITADO` int(11) NOT NULL,
  `PRECIO_VENTA` float(10,2) NOT NULL,
  `PRECIO_VENTA_EDITADO` int(11) NOT NULL,
  `FECHA_HORA` datetime DEFAULT current_timestamp(),
  `ACCION` varchar(10) DEFAULT 'INSERT'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_productos`
--

INSERT INTO `historial_productos` (`ID_HISTORIAL`, `ID_CATEGORIA`, `ID_PRODUCTO`, `ID_PROVEEDOR`, `CODIGO`, `NOMBRE`, `PROVEEDOR`, `STOCK`, `STOCK_EDITADO`, `PRECIO_COMPRA`, `PRECIO_COMPRA_EDITADO`, `PRECIO_VENTA`, `PRECIO_VENTA_EDITADO`, `FECHA_HORA`, `ACCION`) VALUES
(1, 7, 59, 3, '4343', 'Kalu', '3-Proveedor3', 10, 0, 1.00, 0, 2.00, 0, '2024-01-18 18:47:50', 'INSERT'),
(2, 7, 59, 3, '4343', 'Kalu', 'Proveedor3', 10, 30, 1.00, 2, 2.00, 4, '2024-01-18 18:52:03', 'UPDATE'),
(3, 7, 59, 3, '4343', 'Kalu', 'Proveedor3', 30, 30, 2.00, 2, 4.00, 4, '2024-01-18 18:53:48', 'DELETE'),
(4, 1, 58, 7, '91822', 'Nuggets Plumrose', '7-GDFG', 50, 47, 0.75, 1, 1.50, 2, '2024-01-18 18:57:44', 'UPDATE'),
(5, 4, 57, 3, '22323', 'Doritos ', '3-Proveedor3', 15, 12, 0.25, 0, 0.50, 0, '2024-01-18 18:57:44', 'UPDATE'),
(6, 3, 60, 1, '5646', 'fgfgdfgdf', '1-Proveedor1', 56, 0, 5.00, 0, 6.00, 0, '2024-01-18 19:33:33', 'INSERT'),
(7, 3, 61, 1, '56456', 'fgfgdfgdf', '1-Proveedor1', 56, 0, 5.00, 0, 6.00, 0, '2024-01-18 19:33:47', 'INSERT'),
(8, 5, 45, 7, '56456', 'pancho', 'GDFG', 30, 30, 0.50, 0, 1.00, 1, '2024-01-18 19:33:50', 'DELETE'),
(9, 3, 61, 1, '56456', 'fgfgdfgdf', '1-Proveedor1', 56, 56, 5.00, 5, 6.00, 6, '2024-01-18 19:33:50', 'DELETE'),
(10, 3, 60, 1, '5646', 'fgfgdfgdf', '1-Proveedor1', 56, 54, 5.00, 5, 6.00, 6, '2024-01-18 22:56:11', 'UPDATE'),
(11, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 60, 58, 0.25, 0, 0.50, 0, '2024-01-18 22:56:11', 'UPDATE'),
(12, 4, 62, 1, '199', 'Yogurt Toni 1L ', '1-Proveedor1', 10, 0, 1.50, 0, 3.00, 0, '2024-01-18 23:24:28', 'INSERT'),
(13, 2, 64, 1, '200', 'gdfgdf', '1-Proveedor1', 45, 0, 2.00, 0, 3.00, 0, '2024-01-18 23:25:18', 'INSERT'),
(14, 3, 62, 1, '199', 'Yogurt Toni 1L ', 'Proveedor1', 10, 20, 1.50, 2, 3.00, 3, '2024-01-18 23:26:04', 'UPDATE'),
(15, 1, 66, 1, '200G', 'DFGFD', '1-Proveedor1', 4, 0, 5.00, 0, 6.00, 0, '2024-01-18 23:56:54', 'INSERT'),
(16, 1, 66, 1, '200G', 'DFGFD', 'Proveedor1', 4, 4, 5.00, 5, 6.00, 6, '2024-01-18 23:57:01', 'UPDATE'),
(17, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 45, 4, 2.00, 5, 3.00, 6, '2024-01-18 23:57:05', 'UPDATE'),
(18, 1, 66, 1, '200G', 'DFGFD', 'Proveedor1', 4, 4, 5.00, 5, 6.00, 6, '2024-01-18 23:57:09', 'DELETE'),
(19, 3, 72, 3, '201', 'FDSSDF', '3-Proveedor3', 5, 0, 5.00, 0, 6.00, 0, '2024-01-19 00:12:11', 'INSERT'),
(20, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 58, 54, 0.25, 0, 0.50, 0, '2024-01-19 15:45:06', 'UPDATE'),
(21, 9, 56, 3, '122132', 'Axion100', '3-Proveedor3', 30, 27, 3.00, 3, 4.00, 4, '2024-01-20 11:07:34', 'UPDATE'),
(22, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 54, 50, 0.25, 0, 0.50, 0, '2024-01-20 11:07:34', 'UPDATE'),
(23, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 4, 1, 5.00, 5, 6.00, 6, '2024-01-20 11:10:03', 'UPDATE'),
(24, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 50, 47, 0.25, 0, 0.50, 0, '2024-01-20 11:37:14', 'UPDATE'),
(25, 9, 56, 3, '122132', 'Axion100', '3-Proveedor3', 27, 23, 3.00, 3, 4.00, 4, '2024-01-20 11:37:14', 'UPDATE'),
(26, 3, 62, 1, '199', 'Yogurt Toni 1L ', 'Proveedor1', 20, 16, 1.50, 2, 3.00, 3, '2024-01-20 11:37:14', 'UPDATE'),
(27, 9, 56, 3, '122132', 'Axion100', '3-Proveedor3', 23, 20, 3.00, 3, 4.00, 4, '2024-01-20 19:34:20', 'UPDATE'),
(28, 3, 72, 3, '201', 'FDSSDF', '3-Proveedor3', 5, 2, 5.00, 5, 6.00, 6, '2024-01-20 19:34:20', 'UPDATE'),
(29, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 2, 20, 5.00, 5, 6.00, 6, '2024-01-20 20:00:50', 'UPDATE'),
(30, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 1, 40, 5.00, 5, 6.00, 6, '2024-01-20 20:47:40', 'UPDATE'),
(31, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 40, 36, 5.00, 5, 6.00, 6, '2024-01-20 20:48:02', 'UPDATE'),
(32, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 20, 15, 5.00, 5, 6.00, 6, '2024-01-20 20:51:43', 'UPDATE'),
(33, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 36, 31, 5.00, 5, 6.00, 6, '2024-01-20 20:53:35', 'UPDATE'),
(34, 9, 56, 3, '122132', 'Axion100', '3-Proveedor3', 20, 10, 3.00, 3, 4.00, 4, '2024-01-20 20:55:55', 'UPDATE'),
(35, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 31, 26, 5.00, 5, 6.00, 6, '2024-01-20 20:57:52', 'UPDATE'),
(36, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 26, 21, 5.00, 5, 6.00, 6, '2024-01-20 20:59:28', 'UPDATE'),
(37, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 21, 16, 5.00, 5, 6.00, 6, '2024-01-20 21:01:59', 'UPDATE'),
(38, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 15, 10, 5.00, 5, 6.00, 6, '2024-01-20 21:05:02', 'UPDATE'),
(39, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 16, 12, 5.00, 5, 6.00, 6, '2024-01-20 21:06:44', 'UPDATE'),
(40, 4, 57, 3, '22323', 'Doritos ', '3-Proveedor3', 12, 7, 0.25, 0, 0.50, 0, '2024-01-20 21:11:39', 'UPDATE'),
(41, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 12, 120, 5.00, 5, 6.00, 6, '2024-01-20 21:15:27', 'UPDATE'),
(42, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 120, 116, 5.00, 5, 6.00, 6, '2024-01-20 21:15:41', 'UPDATE'),
(43, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 10, 6, 5.00, 5, 6.00, 6, '2024-01-20 21:41:48', 'UPDATE'),
(44, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 47, 43, 0.25, 0, 0.50, 0, '2024-01-20 22:38:26', 'UPDATE'),
(45, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 27, 27, 2.00, 2, 3.00, 4, '2024-01-20 22:39:42', 'UPDATE'),
(46, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 40, 0, 3.50, 0, 5.50, 0, '2024-01-20 22:40:32', 'INSERT'),
(47, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 43, 39, 0.25, 0, 0.50, 0, '2024-01-20 22:42:41', 'UPDATE'),
(48, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 27, 24, 2.25, 2, 3.50, 4, '2024-01-20 22:42:41', 'UPDATE'),
(49, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 40, 38, 3.50, 4, 5.50, 6, '2024-01-20 22:42:41', 'UPDATE'),
(50, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 39, 35, 0.25, 0, 0.50, 0, '2024-01-20 23:02:15', 'UPDATE'),
(51, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 24, 21, 2.25, 2, 3.50, 4, '2024-01-20 23:02:15', 'UPDATE'),
(52, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 38, 36, 3.50, 4, 5.50, 6, '2024-01-20 23:02:15', 'UPDATE'),
(53, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 35, 31, 0.25, 0, 0.50, 0, '2024-01-20 23:07:36', 'UPDATE'),
(54, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 21, 18, 2.25, 2, 3.50, 4, '2024-01-20 23:07:36', 'UPDATE'),
(55, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 36, 34, 3.50, 4, 5.50, 6, '2024-01-20 23:07:36', 'UPDATE'),
(56, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 31, 27, 0.25, 0, 0.50, 0, '2024-01-20 23:09:50', 'UPDATE'),
(57, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 18, 15, 2.25, 2, 3.50, 4, '2024-01-20 23:09:50', 'UPDATE'),
(58, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 34, 32, 3.50, 4, 5.50, 6, '2024-01-20 23:09:50', 'UPDATE'),
(59, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 27, 23, 0.25, 0, 0.50, 0, '2024-01-20 23:14:53', 'UPDATE'),
(60, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 15, 12, 2.25, 2, 3.50, 4, '2024-01-20 23:14:53', 'UPDATE'),
(61, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 32, 30, 3.50, 4, 5.50, 6, '2024-01-20 23:14:53', 'UPDATE'),
(62, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 12, 9, 2.25, 2, 3.50, 4, '2024-01-20 23:25:17', 'UPDATE'),
(63, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 30, 28, 3.50, 4, 5.50, 6, '2024-01-20 23:25:17', 'UPDATE'),
(64, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 23, 19, 0.25, 0, 0.50, 0, '2024-01-20 23:28:04', 'UPDATE'),
(65, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 9, 6, 2.25, 2, 3.50, 4, '2024-01-20 23:28:04', 'UPDATE'),
(66, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 28, 26, 3.50, 4, 5.50, 6, '2024-01-20 23:28:04', 'UPDATE'),
(67, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 19, 15, 0.25, 0, 0.50, 0, '2024-01-20 23:57:46', 'UPDATE'),
(68, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 6, 3, 2.25, 2, 3.50, 4, '2024-01-20 23:57:46', 'UPDATE'),
(69, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 26, 24, 3.50, 4, 5.50, 6, '2024-01-20 23:57:46', 'UPDATE'),
(70, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 15, 11, 0.25, 0, 0.50, 0, '2024-01-21 00:03:05', 'UPDATE'),
(71, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 3, 0, 2.25, 2, 3.50, 4, '2024-01-21 00:03:05', 'UPDATE'),
(72, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 24, 22, 3.50, 4, 5.50, 6, '2024-01-21 00:03:06', 'UPDATE'),
(73, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 0, 90, 2.25, 2, 3.50, 4, '2024-01-21 00:26:46', 'UPDATE'),
(74, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 11, 7, 0.25, 0, 0.50, 0, '2024-01-21 00:27:46', 'UPDATE'),
(75, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 90, 87, 2.25, 2, 3.50, 4, '2024-01-21 00:27:46', 'UPDATE'),
(76, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 22, 20, 3.50, 4, 5.50, 6, '2024-01-21 00:27:46', 'UPDATE'),
(77, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 7, 5, 0.25, 0, 0.50, 0, '2024-01-21 00:33:45', 'UPDATE'),
(78, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 20, 17, 3.50, 4, 5.50, 6, '2024-01-21 00:33:45', 'UPDATE'),
(79, 5, 54, 1, '545454', 'Galletas JK', '1-Proveedor1', 5, 1, 0.25, 0, 0.50, 0, '2024-01-21 01:04:01', 'UPDATE'),
(80, 3, 62, 1, '199', 'Yogurt Toni 1L ', 'Proveedor1', 16, 13, 1.50, 2, 3.00, 3, '2024-01-21 01:04:01', 'UPDATE'),
(81, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 1, 100, 0.25, 0, 0.50, 0, '2024-01-21 01:05:22', 'UPDATE'),
(82, 4, 57, 1, '22323', 'Doritos ', 'Proveedor1', 7, 79, 0.25, 0, 0.50, 0, '2024-01-21 01:05:26', 'UPDATE'),
(83, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 6, 60, 5.00, 5, 6.00, 6, '2024-01-21 01:05:32', 'UPDATE'),
(84, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 100, 97, 0.25, 0, 0.50, 0, '2024-01-21 01:05:47', 'UPDATE'),
(85, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 17, 14, 3.50, 4, 5.50, 6, '2024-01-21 01:21:17', 'UPDATE'),
(86, 3, 60, 1, '5646', 'fgfgdfgdf', '1-Proveedor1', 54, 52, 5.00, 5, 6.00, 6, '2024-01-21 01:21:17', 'UPDATE'),
(87, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 97, 95, 0.25, 0, 0.50, 0, '2024-01-21 01:29:10', 'UPDATE'),
(88, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 60, 57, 5.00, 5, 6.00, 6, '2024-01-21 01:29:10', 'UPDATE'),
(89, 3, 60, 1, '5646', 'fgfgdfgdf', '1-Proveedor1', 52, 49, 5.00, 5, 6.00, 6, '2024-01-21 01:41:55', 'UPDATE'),
(90, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 87, 84, 2.25, 2, 3.50, 4, '2024-01-21 01:41:55', 'UPDATE'),
(91, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 84, 81, 2.25, 2, 3.50, 4, '2024-01-21 01:45:12', 'UPDATE'),
(92, 3, 62, 1, '199', 'Yogurt Toni 1L ', 'Proveedor1', 13, 11, 1.50, 2, 3.00, 3, '2024-01-21 01:48:31', 'UPDATE'),
(93, 4, 57, 1, '22323', 'Doritos ', 'Proveedor1', 79, 76, 0.25, 0, 0.50, 0, '2024-01-21 01:51:53', 'UPDATE'),
(94, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 95, 93, 0.25, 0, 0.50, 0, '2024-01-21 13:42:10', 'UPDATE'),
(95, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 14, 12, 3.50, 4, 5.50, 6, '2024-01-21 13:42:10', 'UPDATE'),
(96, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 12, 10, 3.50, 4, 5.50, 6, '2024-01-21 13:45:00', 'UPDATE'),
(97, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 10, 7, 3.50, 4, 5.50, 6, '2024-01-21 13:47:06', 'UPDATE'),
(98, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 93, 90, 0.25, 0, 0.50, 0, '2024-01-21 13:51:11', 'UPDATE'),
(99, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 90, 87, 0.25, 0, 0.50, 0, '2024-01-21 13:54:13', 'UPDATE'),
(100, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 7, 5, 3.50, 4, 5.50, 6, '2024-01-21 13:55:46', 'UPDATE'),
(101, 5, 77, 3, '2222', 'MIEL', '3-Proveedor3', 5, 2, 3.50, 4, 5.50, 6, '2024-01-21 14:01:00', 'UPDATE'),
(102, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 81, 77, 2.25, 2, 3.50, 4, '2024-01-21 14:04:46', 'UPDATE'),
(103, 3, 60, 1, '5646', 'fgfgdfgdf', '1-Proveedor1', 49, 46, 5.00, 5, 6.00, 6, '2024-01-21 14:06:48', 'UPDATE'),
(104, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 57, 54, 5.00, 5, 6.00, 6, '2024-01-21 14:10:46', 'UPDATE'),
(105, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 2, 40, 3.50, 4, 5.50, 6, '2024-01-21 14:11:51', 'UPDATE'),
(106, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 40, 37, 3.50, 4, 5.50, 6, '2024-01-21 14:12:14', 'UPDATE'),
(107, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 87, 83, 0.25, 0, 0.50, 0, '2024-01-21 14:12:14', 'UPDATE'),
(108, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 83, 79, 0.25, 0, 0.50, 0, '2024-01-21 14:27:15', 'UPDATE'),
(109, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 77, 74, 2.25, 2, 3.50, 4, '2024-01-21 14:27:15', 'UPDATE'),
(110, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 37, 35, 3.50, 4, 5.50, 6, '2024-01-21 14:27:15', 'UPDATE'),
(111, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 35, 33, 3.50, 4, 5.50, 6, '2024-01-21 14:32:06', 'UPDATE'),
(112, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 79, 75, 0.25, 0, 0.50, 0, '2024-01-21 14:32:06', 'UPDATE'),
(113, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 33, 30, 3.50, 4, 5.50, 6, '2024-01-21 14:42:05', 'UPDATE'),
(114, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 30, 26, 3.50, 4, 5.50, 6, '2024-01-21 14:51:51', 'UPDATE'),
(115, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 54, 51, 5.00, 5, 6.00, 6, '2024-01-21 14:51:51', 'UPDATE'),
(116, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 26, 23, 3.50, 4, 5.50, 6, '2024-01-21 15:01:18', 'UPDATE'),
(117, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 51, 47, 5.00, 5, 6.00, 6, '2024-01-21 15:04:43', 'UPDATE'),
(118, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 23, 20, 3.50, 4, 5.50, 6, '2024-01-21 15:14:19', 'UPDATE'),
(119, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 20, 16, 3.50, 4, 5.50, 6, '2024-01-21 15:16:56', 'UPDATE'),
(120, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 16, 12, 3.50, 4, 5.50, 6, '2024-01-21 15:19:09', 'UPDATE'),
(121, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 75, 71, 0.25, 0, 0.50, 0, '2024-01-21 15:21:33', 'UPDATE'),
(122, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 12, 10, 3.50, 4, 5.50, 6, '2024-01-21 15:21:33', 'UPDATE'),
(123, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 71, 67, 0.25, 0, 0.50, 0, '2024-01-21 18:59:17', 'UPDATE'),
(124, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 10, 8, 3.50, 4, 5.50, 6, '2024-01-21 18:59:17', 'UPDATE'),
(125, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 67, 63, 0.25, 0, 0.50, 0, '2024-01-21 19:01:06', 'UPDATE'),
(126, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 8, 6, 3.50, 4, 5.50, 6, '2024-01-21 19:01:06', 'UPDATE'),
(127, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 63, 59, 0.25, 0, 0.50, 0, '2024-01-21 19:03:47', 'UPDATE'),
(128, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 6, 4, 3.50, 4, 5.50, 6, '2024-01-21 19:03:47', 'UPDATE'),
(129, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 59, 55, 0.25, 0, 0.50, 0, '2024-01-21 19:08:34', 'UPDATE'),
(130, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 4, 2, 3.50, 4, 5.50, 6, '2024-01-21 19:08:34', 'UPDATE'),
(131, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 2, 0, 3.50, 4, 5.50, 6, '2024-01-21 19:16:05', 'UPDATE'),
(132, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 0, 40, 3.50, 4, 5.50, 6, '2024-01-21 19:20:49', 'UPDATE'),
(133, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 55, 51, 0.25, 0, 0.50, 0, '2024-01-21 19:21:28', 'UPDATE'),
(134, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 74, 71, 2.25, 2, 3.50, 4, '2024-01-21 19:21:28', 'UPDATE'),
(135, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 40, 38, 3.50, 4, 5.50, 6, '2024-01-21 19:21:28', 'UPDATE'),
(136, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 38, 35, 3.50, 4, 5.50, 6, '2024-01-21 21:46:49', 'UPDATE'),
(137, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 51, 49, 0.25, 0, 0.50, 0, '2024-01-21 21:46:49', 'UPDATE'),
(138, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 35, 33, 3.50, 4, 5.50, 6, '2024-01-22 00:24:30', 'UPDATE'),
(139, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 49, 45, 0.25, 0, 0.50, 0, '2024-01-22 00:24:31', 'UPDATE'),
(140, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 71, 68, 2.25, 2, 3.50, 4, '2024-01-22 01:32:50', 'UPDATE'),
(141, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 45, 41, 0.25, 0, 0.50, 0, '2024-01-22 01:32:50', 'UPDATE'),
(142, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 47, 45, 5.00, 5, 6.00, 6, '2024-01-22 01:32:50', 'UPDATE'),
(143, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 41, 37, 0.25, 0, 0.50, 0, '2024-01-22 15:40:28', 'UPDATE'),
(144, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 68, 65, 2.25, 2, 3.50, 4, '2024-01-22 15:40:28', 'UPDATE'),
(145, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 37, 33, 0.25, 0, 0.50, 0, '2024-01-22 16:21:23', 'UPDATE'),
(146, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 33, 31, 3.50, 4, 5.50, 6, '2024-01-22 16:21:23', 'UPDATE'),
(147, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 33, 29, 0.25, 0, 0.50, 0, '2024-01-22 16:23:39', 'UPDATE'),
(148, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 31, 29, 3.50, 4, 5.50, 6, '2024-01-22 16:23:39', 'UPDATE'),
(149, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 29, 25, 0.25, 0, 0.50, 0, '2024-01-22 16:25:41', 'UPDATE'),
(150, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 65, 62, 2.25, 2, 3.50, 4, '2024-01-22 16:25:41', 'UPDATE'),
(151, 2, 78, 2, '233232', 'dfggfdgfd', '2-Proveedor2', 56, 0, 5.00, 0, 7.00, 0, '2024-01-23 15:13:06', 'INSERT'),
(152, 5, 79, 3, '4333', 'dsdssdds', '3-Proveedor3', 56, 0, 4.00, 0, 5.00, 0, '2024-01-23 15:14:15', 'INSERT'),
(153, 4, 80, 3, '211232', 'dfdfdfdfdfdfdfd', '3-Proveedor3', 5, 0, 6.00, 0, 7.00, 0, '2024-01-23 15:18:02', 'INSERT'),
(154, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 25, 21, 0.25, 0, 0.50, 0, '2024-01-23 19:21:07', 'UPDATE'),
(155, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 62, 59, 2.25, 2, 3.50, 4, '2024-01-23 19:21:07', 'UPDATE'),
(156, 4, 57, 1, '22323', 'Doritos ', 'Proveedor1', 76, 72, 0.25, 0, 0.50, 0, '2024-01-23 19:21:07', 'UPDATE'),
(157, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 29, 27, 3.50, 4, 5.50, 6, '2024-01-23 19:21:07', 'UPDATE'),
(158, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 21, 17, 0.25, 0, 0.50, 0, '2024-01-23 19:26:08', 'UPDATE'),
(159, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 59, 56, 2.25, 2, 3.50, 4, '2024-01-23 19:26:08', 'UPDATE'),
(160, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 27, 25, 3.50, 4, 5.50, 6, '2024-01-23 19:26:08', 'UPDATE'),
(161, 5, 82, 1, '1818272', 'Maraja', '1-Proveedor1', 30, 0, 3.50, 0, 5.50, 0, '2024-01-23 19:33:41', 'INSERT'),
(162, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 17, 13, 0.25, 0, 0.50, 0, '2024-01-23 19:57:31', 'UPDATE'),
(163, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 56, 53, 2.25, 2, 3.50, 4, '2024-01-23 19:57:31', 'UPDATE'),
(164, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 25, 23, 3.50, 4, 5.50, 6, '2024-01-23 19:57:31', 'UPDATE'),
(165, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 13, 9, 0.25, 0, 0.50, 0, '2024-01-23 19:59:04', 'UPDATE'),
(166, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 53, 50, 2.25, 2, 3.50, 4, '2024-01-23 19:59:04', 'UPDATE'),
(167, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 23, 21, 3.50, 4, 5.50, 6, '2024-01-23 19:59:04', 'UPDATE'),
(168, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 9, 5, 0.25, 0, 0.50, 0, '2024-01-23 20:00:35', 'UPDATE'),
(169, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 5, 3, 0.25, 0, 0.50, 0, '2024-01-23 20:05:21', 'UPDATE'),
(170, 4, 80, 3, '211232', 'dfdfdfdfdfdfdfd', '3-Proveedor3', 5, 3, 6.00, 6, 7.00, 7, '2024-01-23 20:05:21', 'UPDATE'),
(171, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 3, 2, 0.25, 0, 0.50, 0, '2024-01-23 20:09:59', 'UPDATE'),
(172, 2, 83, 11, '54545', 'gfgdfgfd', '11-Markta', 5, 0, 5.00, 0, 6.00, 0, '2024-01-23 20:33:28', 'INSERT'),
(173, 2, 83, 11, '54545', 'gfgdfgfd', '11-Markta', 5, 1, 5.00, 5, 6.00, 6, '2024-01-23 20:34:53', 'UPDATE'),
(174, 2, 83, 11, '54545', 'gfgdfgfd', '11-Markta', 1, 0, 5.00, 5, 6.00, 6, '2024-01-23 20:51:06', 'UPDATE'),
(175, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 2, 1, 0.25, 0, 0.50, 0, '2024-01-23 20:51:06', 'UPDATE'),
(176, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 50, 48, 2.25, 2, 3.50, 4, '2024-01-23 20:51:06', 'UPDATE'),
(177, 2, 83, 1, '54545', 'gfgdfgfd', 'Proveedor1', 0, 20, 5.00, 5, 6.00, 6, '2024-01-24 01:08:45', 'UPDATE'),
(179, 9, 56, 3, '122132', 'Axion100', '3-Proveedor3', 10, 10, 3.00, 3, 4.00, 4, '2024-01-24 01:20:48', 'DELETE'),
(180, 5, 54, 1, '545454', 'Galletas JK', 'Proveedor1', 1, 1, 0.25, 0, 0.50, 0, '2024-01-24 01:21:46', 'DELETE'),
(181, 3, 55, 1, '545232', 'Leche Condensada hTA', 'Proveedor1', 48, 48, 2.25, 2, 3.50, 4, '2024-01-24 01:21:48', 'DELETE'),
(182, 4, 57, 1, '22323', 'Doritos ', 'Proveedor1', 72, 72, 0.25, 0, 0.50, 0, '2024-01-24 01:21:50', 'DELETE'),
(183, 1, 58, 7, '91822', 'Nuggets Plumrose', '7-GDFG', 47, 47, 0.75, 1, 1.50, 2, '2024-01-24 01:21:52', 'DELETE'),
(184, 3, 60, 1, '5646', 'fgfgdfgdf', '1-Proveedor1', 46, 46, 5.00, 5, 6.00, 6, '2024-01-24 01:21:54', 'DELETE'),
(185, 3, 62, 1, '199', 'Yogurt Toni 1L ', 'Proveedor1', 11, 11, 1.50, 2, 3.00, 3, '2024-01-24 01:21:56', 'DELETE'),
(186, 1, 64, 1, '200', 'DFGFD', 'Proveedor1', 116, 116, 5.00, 5, 6.00, 6, '2024-01-24 01:21:58', 'DELETE'),
(187, 5, 77, 1, '2222', 'MIEL', 'Proveedor1', 21, 21, 3.50, 4, 5.50, 6, '2024-01-24 01:22:00', 'DELETE'),
(188, 3, 72, 1, '201', 'FDSSDF', 'Proveedor1', 45, 45, 5.00, 5, 6.00, 6, '2024-01-24 01:22:32', 'DELETE'),
(189, 2, 83, 1, '54545', 'gfgdfgfd', 'Proveedor1', 20, 20, 5.00, 5, 6.00, 6, '2024-01-24 01:22:42', 'UPDATE'),
(190, 2, 83, 1, '54545', 'gfgdfgfd', 'Proveedor1', 20, 20, 5.00, 5, 6.00, 6, '2024-01-24 01:22:55', 'UPDATE'),
(191, 2, 83, 1, '54545', 'gfgdfgfd', 'Proveedor1', 20, 20, 5.00, 5, 6.00, 6, '2024-01-24 01:23:09', 'DELETE'),
(192, 5, 82, 1, '1818272', 'Maraja', '1-Proveedor1', 30, 27, 3.50, 4, 5.50, 6, '2024-01-24 01:26:26', 'UPDATE'),
(193, 5, 82, 1, '1818272', 'Maraja', '1-Proveedor1', 27, 27, 3.50, 4, 5.50, 6, '2024-01-24 17:55:34', 'DELETE'),
(194, 3, 84, 9, '1818272', 'Maraja', '9-GDFGsdds', 21, 0, 3.50, 0, 5.50, 0, '2024-01-24 17:55:54', 'INSERT'),
(195, 3, 84, 9, '1818272', 'Maraja', 'GDFGsdds', 21, 21, 3.50, 4, 5.50, 6, '2024-01-24 17:56:10', 'UPDATE'),
(196, 4, 80, 1, '211232', 'dfdfdfdfdfdfdfd', 'Proveedor1', 3, 30, 6.00, 6, 7.00, 7, '2024-01-24 19:52:23', 'UPDATE'),
(197, 3, 85, 3, '176627', 'mini cola -Coca Cola', '3-Proveedor3', 50, 0, 0.25, 0, 0.50, 0, '2024-01-24 20:25:28', 'INSERT'),
(198, 5, 86, 3, '71282', 'Yogurt 1L - Toni', '3-Proveedor3', 10, 0, 2.25, 0, 3.50, 0, '2024-01-24 20:32:01', 'INSERT'),
(199, 5, 87, 7, '718282', 'Miel-Orchata', '7-GDFG', 6, 0, 3.50, 0, 5.50, 0, '2024-01-24 20:33:11', 'INSERT'),
(200, 3, 86, 7, '71282', 'Yogurt 1L - Toni', 'GDFG', 10, 10, 2.25, 2, 3.50, 4, '2024-01-24 20:33:25', 'UPDATE'),
(201, 6, 85, 7, '176627', 'mini cola -Coca Cola', 'GDFG', 50, 50, 0.25, 0, 0.50, 0, '2024-01-24 20:33:35', 'UPDATE'),
(202, 6, 85, 7, '176627', 'mini cola -Coca Cola', 'GDFG', 50, 46, 0.25, 0, 0.50, 0, '2024-01-24 20:36:48', 'UPDATE'),
(203, 3, 86, 7, '71282', 'Yogurt 1L - Toni', 'GDFG', 10, 7, 2.25, 2, 3.50, 4, '2024-01-24 20:36:48', 'UPDATE'),
(204, 5, 87, 7, '718282', 'Miel-Orchata', '7-GDFG', 6, 4, 3.50, 4, 5.50, 6, '2024-01-24 20:36:48', 'UPDATE'),
(205, 5, 89, 3, '21212', 'Pipa-Nestle', '3-Proveedor3', 20, 0, 0.40, 0, 1.00, 0, '2024-01-24 21:58:56', 'INSERT'),
(206, 5, 89, 3, '21212', 'Pipa-Nestle', '3-Proveedor3', 20, 16, 0.40, 0, 1.00, 1, '2024-01-24 21:59:14', 'UPDATE'),
(207, 5, 89, 3, '21212', 'Pipa-Nestle', '3-Proveedor3', 16, 13, 0.40, 0, 1.00, 1, '2024-01-24 22:00:44', 'UPDATE'),
(208, 3, 84, 9, '1818272', 'Maraja', 'GDFGsdds', 21, 18, 4.50, 4, 6.50, 6, '2024-01-24 22:00:44', 'UPDATE'),
(209, 5, 87, 7, '718282', 'Miel-Orchata', '7-GDFG', 4, 1, 3.50, 4, 5.50, 6, '2024-01-24 22:02:59', 'UPDATE'),
(210, 5, 89, 3, '21212', 'Pipa-Nestle', '3-Proveedor3', 13, 11, 0.40, 0, 1.00, 1, '2024-01-24 22:02:59', 'UPDATE'),
(211, 3, 86, 7, '71282', 'Yogurt 1L - Toni', 'GDFG', 7, 4, 2.25, 2, 3.50, 4, '2024-01-24 22:10:33', 'UPDATE'),
(212, 4, 80, 1, '211232', 'dfdfdfdfdfdfdfd', 'Proveedor1', 30, 28, 6.00, 6, 7.00, 7, '2024-01-24 22:10:33', 'UPDATE'),
(213, 3, 91, 12, '001', 'Leche-Lenutrit 1L', '12-Proveedor1', 50, 0, 0.50, 0, 1.00, 0, '2024-01-25 15:53:39', 'INSERT'),
(214, 5, 92, 14, '002', 'Miel', '14-Proveedor2', 30, 0, 3.50, 0, 5.50, 0, '2024-01-25 15:56:48', 'INSERT'),
(215, 6, 93, 16, '003', 'Coca Cola Mini', '16-Proveedor3', 25, 0, 0.25, 0, 0.50, 0, '2024-01-25 15:57:46', 'INSERT'),
(216, 9, 94, 12, '004', 'Lavaplatos-Axion', '12-Proveedor1', 10, 0, 2.25, 0, 3.50, 0, '2024-01-25 15:58:52', 'INSERT'),
(217, 4, 95, 14, '005', 'Doritos', '14-Proveedor2', 40, 0, 0.25, 0, 0.50, 0, '2024-01-25 15:59:34', 'INSERT'),
(218, 3, 91, 12, '001', 'Leche-Lenutrit 1L', '12-Proveedor1', 50, 47, 0.50, 0, 1.00, 1, '2024-01-25 16:23:12', 'UPDATE'),
(219, 6, 93, 16, '003', 'Coca Cola Mini', '16-Proveedor3', 25, 20, 0.25, 0, 0.50, 0, '2024-01-25 16:23:12', 'UPDATE'),
(220, 9, 96, 14, '003', 'Lavaplatos-Axion', '14-Proveedor2', 40, 0, 2.25, 0, 3.50, 0, '2024-01-25 16:41:23', 'INSERT'),
(221, 4, 95, 14, '005', 'Doritos', '14-Proveedor2', 40, 37, 0.25, 0, 0.50, 0, '2024-01-25 16:44:23', 'UPDATE'),
(222, 9, 96, 14, '003', 'Lavaplatos-Axion', '14-Proveedor2', 40, 37, 2.25, 2, 3.50, 4, '2024-01-25 16:44:23', 'UPDATE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_ventas`
--

CREATE TABLE `historial_ventas` (
  `ID_HISTORIAL` int(11) NOT NULL,
  `ID_VENTA` int(11) DEFAULT NULL,
  `IDENTIFICACION` varchar(15) DEFAULT NULL,
  `ID_USUARIO` int(11) NOT NULL,
  `ID_CLIENTE` int(11) NOT NULL,
  `SUBTOTAL` float(10,2) NOT NULL,
  `DESCUENTO` float(10,2) NOT NULL,
  `TOTAL` float(10,2) NOT NULL,
  `FECHA` datetime NOT NULL,
  `ACCION` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_ventas`
--

INSERT INTO `historial_ventas` (`ID_HISTORIAL`, `ID_VENTA`, `IDENTIFICACION`, `ID_USUARIO`, `ID_CLIENTE`, `SUBTOTAL`, `DESCUENTO`, `TOTAL`, `FECHA`, `ACCION`) VALUES
(16, 23, '087654321', 4, 2, 0.00, 0.00, 5.00, '2024-01-11 00:00:00', 'INSERT'),
(23, 28, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:05:00', 'INSERT'),
(24, 29, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:06:12', 'INSERT'),
(25, 30, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:08:33', 'INSERT'),
(26, 31, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:10:55', 'INSERT'),
(37, 42, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:37:11', 'INSERT'),
(38, 43, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:38:41', 'INSERT'),
(39, 44, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:38:51', 'INSERT'),
(40, 45, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:39:01', 'INSERT'),
(41, 46, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:41:57', 'INSERT'),
(42, 47, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:47:16', 'INSERT'),
(43, 48, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:50:19', 'INSERT'),
(44, 49, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:53:50', 'INSERT'),
(45, 50, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:54:33', 'INSERT'),
(46, 51, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 13:59:50', 'INSERT'),
(47, 52, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 14:35:54', 'INSERT'),
(48, 53, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 14:42:34', 'INSERT'),
(49, 54, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 14:43:56', 'INSERT'),
(50, 55, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 14:45:33', 'INSERT'),
(51, 56, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 14:47:51', 'INSERT'),
(52, 57, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 14:49:20', 'INSERT'),
(53, 58, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 15:20:48', 'INSERT'),
(54, 59, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 15:23:15', 'INSERT'),
(55, 60, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 15:32:39', 'INSERT'),
(57, 61, '', 1, 11, 45.00, 4.50, 41.00, '2024-01-15 17:56:06', 'INSERT'),
(58, 62, '', 1, 11, 75.00, 11.25, 64.00, '2024-01-15 17:58:39', 'INSERT'),
(61, 63, '', 1, 11, 8.00, 0.00, 8.00, '2024-01-15 19:59:39', 'INSERT'),
(62, 64, '', 1, 11, 16.00, 0.00, 16.00, '2024-01-15 20:00:15', 'INSERT'),
(63, 65, '', 1, 11, 16.00, 0.00, 16.00, '2024-01-15 20:00:50', 'INSERT'),
(68, 66, '', 1, 11, 38.00, 3.80, 34.00, '2024-01-15 21:18:40', 'INSERT'),
(69, 67, '', 1, 11, 54.00, 8.10, 46.00, '2024-01-15 21:24:07', 'INSERT'),
(70, 68, '', 1, 11, 16.00, 0.00, 16.00, '2024-01-15 21:33:10', 'INSERT'),
(71, 69, '', 1, 11, 24.00, 1.20, 23.00, '2024-01-15 21:35:58', 'INSERT'),
(72, 70, '', 1, 11, 30.00, 3.00, 27.00, '2024-01-15 21:36:43', 'INSERT'),
(74, 71, '', 1, 11, 40.00, 4.00, 36.00, '2024-01-15 22:14:09', 'INSERT'),
(75, 72, '', 1, 11, 40.00, 4.00, 36.00, '2024-01-15 22:19:09', 'INSERT'),
(76, 73, '', 1, 11, 40.00, 4.00, 36.00, '2024-01-15 22:20:43', 'INSERT'),
(77, 74, '', 1, 11, 30.00, 3.00, 27.00, '2024-01-15 22:23:42', 'INSERT'),
(78, 75, '', 1, 11, 46.00, 4.60, 41.00, '2024-01-15 22:24:07', 'INSERT'),
(79, 76, '', 1, 11, 16.00, 0.00, 16.00, '2024-01-15 22:46:54', 'INSERT'),
(80, 77, '', 1, 11, 10.00, 0.00, 10.00, '2024-01-15 22:47:59', 'INSERT'),
(81, 78, '', 1, 11, 16.00, 0.00, 16.00, '2024-01-15 23:00:42', 'INSERT'),
(82, 79, '', 1, 11, 52.00, 7.80, 44.00, '2024-01-15 23:04:01', 'INSERT'),
(83, 80, '', 1, 11, 52.00, 7.80, 44.00, '2024-01-15 23:04:09', 'INSERT'),
(84, 81, '', 1, 11, 22.00, 1.10, 21.00, '2024-01-15 23:07:47', 'INSERT'),
(85, 82, '', 1, 11, 50.00, 7.50, 43.00, '2024-01-15 23:08:41', 'INSERT'),
(86, 83, '', 1, 11, 50.00, 7.50, 43.00, '2024-01-15 23:11:52', 'INSERT'),
(87, 84, '', 1, 11, 36.00, 3.60, 32.00, '2024-01-15 23:14:23', 'INSERT'),
(88, 85, '', 1, 11, 31.00, 3.10, 28.00, '2024-01-15 23:15:38', 'INSERT'),
(89, 86, '', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 12:40:54', 'INSERT'),
(90, 87, '', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 12:44:38', 'INSERT'),
(91, 88, '', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 12:49:55', 'INSERT'),
(92, 89, '', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 12:52:52', 'INSERT'),
(93, NULL, '', 1, 11, 68.00, 10.20, 58.00, '2024-01-16 13:05:43', 'INSERT'),
(94, NULL, '', 1, 11, 16.00, 0.00, 16.00, '2024-01-16 19:42:16', 'INSERT'),
(101, NULL, '9999999999', 1, 11, 16.00, 0.00, 16.00, '2024-01-16 23:23:08', 'DELETE'),
(102, NULL, '9999999999', 1, 11, 68.00, 10.20, 58.00, '2024-01-16 23:31:42', 'DELETE'),
(103, 89, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 23:37:28', 'DELETE'),
(104, 88, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 23:37:43', 'DELETE'),
(105, 87, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 23:37:51', 'DELETE'),
(106, 86, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-16 23:39:15', 'DELETE'),
(107, 57, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-16 23:43:53', 'DELETE'),
(108, 92, NULL, 1, 11, 44.00, 4.40, 40.00, '2024-01-17 02:29:58', 'INSERT'),
(109, 25, '123456787', 1, 1, 5.00, 0.00, 5.00, '2024-01-17 02:51:18', 'DELETE'),
(110, 93, NULL, 1, 11, 65.00, 9.75, 55.00, '2024-01-17 02:54:44', 'INSERT'),
(111, 94, NULL, 1, 11, 27.00, 1.35, 26.00, '2024-01-17 02:57:04', 'INSERT'),
(112, 95, NULL, 1, 11, 24.00, 1.20, 23.00, '2024-01-17 10:24:05', 'INSERT'),
(113, 96, NULL, 1, 11, 3.00, 0.00, 3.00, '2024-01-17 10:35:18', 'INSERT'),
(118, 96, '9999999999', 1, 11, 3.00, 0.00, 3.00, '2024-01-18 10:06:39', 'DELETE'),
(119, 95, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-18 10:06:44', 'DELETE'),
(120, 94, '9999999999', 1, 11, 27.00, 1.35, 25.65, '2024-01-18 10:06:51', 'DELETE'),
(121, 97, NULL, 1, 11, 55.00, 8.25, 46.75, '2024-01-18 10:08:01', 'INSERT'),
(122, 97, '9999999999', 1, 11, 55.00, 8.25, 46.75, '2024-01-18 10:08:39', 'DELETE'),
(123, 93, '9999999999', 1, 11, 65.00, 9.75, 55.25, '2024-01-18 10:08:45', 'DELETE'),
(124, 92, '9999999999', 1, 11, 44.00, 4.40, 39.60, '2024-01-18 10:08:48', 'DELETE'),
(125, 98, NULL, 1, 11, 40.00, 4.00, 36.00, '2024-01-18 10:09:57', 'INSERT'),
(126, 99, NULL, 1, 11, 5.00, 0.00, 5.00, '2024-01-18 10:11:08', 'INSERT'),
(127, 99, '9999999999', 1, 11, 5.00, 0.00, 5.00, '2024-01-18 10:37:46', 'DELETE'),
(128, 100, NULL, 1, 11, 38.00, 3.80, 34.20, '2024-01-18 10:38:39', 'INSERT'),
(129, 101, NULL, 1, 11, 86.00, 12.90, 73.10, '2024-01-18 10:41:41', 'INSERT'),
(130, 101, '9999999999', 1, 11, 86.00, 12.90, 73.10, '2024-01-18 10:42:21', 'DELETE'),
(131, 100, '9999999999', 1, 11, 38.00, 3.80, 34.20, '2024-01-18 10:46:37', 'DELETE'),
(132, 102, NULL, 1, 11, 68.00, 10.20, 57.80, '2024-01-18 10:47:32', 'INSERT'),
(133, 102, '9999999999', 1, 11, 68.00, 10.20, 57.80, '2024-01-18 10:48:11', 'DELETE'),
(134, 103, NULL, 1, 11, 50.00, 7.50, 42.50, '2024-01-18 10:51:27', 'INSERT'),
(135, 103, '9999999999', 1, 11, 50.00, 7.50, 42.50, '2024-01-18 10:51:57', 'DELETE'),
(136, 104, NULL, 1, 11, 66.00, 9.90, 56.10, '2024-01-18 15:00:47', 'INSERT'),
(137, 105, NULL, 1, 11, 35.00, 3.50, 31.50, '2024-01-18 15:12:43', 'INSERT'),
(138, 106, NULL, 1, 11, 35.00, 3.50, 31.50, '2024-01-18 15:22:12', 'INSERT'),
(139, 107, NULL, 1, 11, 55.00, 8.25, 46.75, '2024-01-18 15:27:28', 'INSERT'),
(140, 108, NULL, 1, 11, 35.00, 3.50, 31.50, '2024-01-18 15:28:48', 'INSERT'),
(141, 109, NULL, 1, 11, 52.00, 7.80, 44.20, '2024-01-18 15:30:51', 'INSERT'),
(142, 110, NULL, 1, 11, 55.00, 8.25, 46.75, '2024-01-18 15:38:55', 'INSERT'),
(143, 111, NULL, 1, 11, 55.00, 8.25, 46.75, '2024-01-18 15:41:50', 'INSERT'),
(144, 112, NULL, 1, 11, 7.00, 0.00, 7.00, '2024-01-18 15:54:56', 'INSERT'),
(145, 113, NULL, 1, 11, 9.00, 0.00, 9.00, '2024-01-18 15:57:19', 'INSERT'),
(146, 114, NULL, 1, 11, 44.00, 4.40, 39.60, '2024-01-18 16:01:19', 'INSERT'),
(147, 115, NULL, 1, 11, 4.00, 0.00, 4.00, '2024-01-18 16:06:55', 'INSERT'),
(148, 116, NULL, 1, 11, 18.00, 0.00, 18.00, '2024-01-18 16:08:28', 'INSERT'),
(149, 117, NULL, 1, 11, 43.00, 4.30, 38.70, '2024-01-18 16:09:32', 'INSERT'),
(150, 118, NULL, 1, 11, 18.00, 0.00, 18.00, '2024-01-18 16:10:32', 'INSERT'),
(151, 119, NULL, 1, 11, 50.00, 7.50, 42.50, '2024-01-18 16:26:59', 'INSERT'),
(152, 120, NULL, 1, 11, 44.00, 4.40, 39.60, '2024-01-18 16:28:24', 'INSERT'),
(153, 121, NULL, 1, 11, 31.00, 3.10, 27.90, '2024-01-18 16:31:22', 'INSERT'),
(154, 122, NULL, 1, 11, 51.00, 7.65, 43.35, '2024-01-18 16:43:32', 'INSERT'),
(155, 123, NULL, 1, 11, 52.00, 7.80, 44.20, '2024-01-18 16:54:15', 'INSERT'),
(156, 124, NULL, 1, 11, 43.00, 4.30, 38.70, '2024-01-18 17:07:16', 'INSERT'),
(157, 125, NULL, 1, 11, 35.00, 3.50, 31.50, '2024-01-18 17:11:52', 'INSERT'),
(158, 50, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:16', 'DELETE'),
(159, 49, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:17', 'DELETE'),
(160, 48, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:19', 'DELETE'),
(161, 47, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:21', 'DELETE'),
(162, 46, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:22', 'DELETE'),
(163, 45, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:23', 'DELETE'),
(164, 44, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:24', 'DELETE'),
(165, 43, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:26', 'DELETE'),
(166, 42, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:09:28', 'DELETE'),
(167, 60, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:00', 'DELETE'),
(168, 59, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:01', 'DELETE'),
(169, 58, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:03', 'DELETE'),
(170, 56, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:04', 'DELETE'),
(171, 55, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:05', 'DELETE'),
(172, 54, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:07', 'DELETE'),
(173, 53, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:08', 'DELETE'),
(174, 52, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:09', 'DELETE'),
(175, 51, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:10', 'DELETE'),
(176, 41, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:12', 'DELETE'),
(177, 40, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:13', 'DELETE'),
(178, 39, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:14', 'DELETE'),
(179, 38, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:16', 'DELETE'),
(180, 37, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:17', 'DELETE'),
(181, 36, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:18', 'DELETE'),
(182, 35, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:20', 'DELETE'),
(183, 34, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:21', 'DELETE'),
(184, 33, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:22', 'DELETE'),
(185, 32, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:24', 'DELETE'),
(186, 31, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:26', 'DELETE'),
(187, 30, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:27', 'DELETE'),
(188, 29, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:28', 'DELETE'),
(189, 28, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:10:30', 'DELETE'),
(190, 26, '9999999999', 1, 11, 5.00, 0.00, 5.00, '2024-01-18 18:10:32', 'DELETE'),
(191, 23, '087654321', 4, 2, 0.00, 0.00, 5.00, '2024-01-18 18:10:34', 'DELETE'),
(192, 85, '9999999999', 1, 11, 31.00, 3.10, 27.90, '2024-01-18 18:10:40', 'DELETE'),
(193, 98, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-18 18:10:49', 'DELETE'),
(194, 84, '9999999999', 1, 11, 36.00, 3.60, 32.40, '2024-01-18 18:10:51', 'DELETE'),
(195, 83, '9999999999', 1, 11, 50.00, 7.50, 42.50, '2024-01-18 18:10:52', 'DELETE'),
(196, 82, '9999999999', 1, 11, 50.00, 7.50, 42.50, '2024-01-18 18:10:53', 'DELETE'),
(197, 81, '9999999999', 1, 11, 22.00, 1.10, 20.90, '2024-01-18 18:10:54', 'DELETE'),
(198, 80, '9999999999', 1, 11, 52.00, 7.80, 44.20, '2024-01-18 18:10:56', 'DELETE'),
(199, 79, '9999999999', 1, 11, 52.00, 7.80, 44.20, '2024-01-18 18:10:57', 'DELETE'),
(200, 78, '9999999999', 1, 11, 16.00, 0.00, 16.00, '2024-01-18 18:10:58', 'DELETE'),
(201, 77, '9999999999', 1, 11, 10.00, 0.00, 10.00, '2024-01-18 18:11:00', 'DELETE'),
(202, 76, '9999999999', 1, 11, 16.00, 0.00, 16.00, '2024-01-18 18:11:01', 'DELETE'),
(203, 75, '9999999999', 1, 11, 46.00, 4.60, 41.40, '2024-01-18 18:11:02', 'DELETE'),
(204, 74, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-18 18:11:04', 'DELETE'),
(205, 73, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-18 18:11:05', 'DELETE'),
(206, 72, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-18 18:11:06', 'DELETE'),
(207, 71, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-18 18:11:08', 'DELETE'),
(208, 70, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-18 18:11:09', 'DELETE'),
(209, 69, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-18 18:11:11', 'DELETE'),
(210, 68, '9999999999', 1, 11, 16.00, 0.00, 16.00, '2024-01-18 18:11:13', 'DELETE'),
(211, 67, '9999999999', 1, 11, 54.00, 8.10, 45.90, '2024-01-18 18:11:14', 'DELETE'),
(212, 66, '9999999999', 1, 11, 38.00, 3.80, 34.20, '2024-01-18 18:11:16', 'DELETE'),
(213, 65, '9999999999', 1, 11, 16.00, 0.00, 16.00, '2024-01-18 18:11:17', 'DELETE'),
(214, 64, '9999999999', 1, 11, 16.00, 0.00, 16.00, '2024-01-18 18:11:19', 'DELETE'),
(215, 63, '9999999999', 1, 11, 8.00, 0.00, 8.00, '2024-01-18 18:11:20', 'DELETE'),
(216, 62, '9999999999', 1, 11, 75.00, 11.25, 63.75, '2024-01-18 18:11:21', 'DELETE'),
(217, 61, '9999999999', 1, 11, 45.00, 4.50, 40.50, '2024-01-18 18:11:22', 'DELETE'),
(218, 125, '9999999999', 1, 11, 35.00, 3.50, 31.50, '2024-01-18 18:11:25', 'DELETE'),
(219, 124, '9999999999', 1, 11, 43.00, 4.30, 38.70, '2024-01-18 18:11:37', 'DELETE'),
(220, 123, '9999999999', 1, 11, 52.00, 7.80, 44.20, '2024-01-18 18:11:38', 'DELETE'),
(221, 122, '9999999999', 1, 11, 51.00, 7.65, 43.35, '2024-01-18 18:11:40', 'DELETE'),
(222, 121, '9999999999', 1, 11, 31.00, 3.10, 27.90, '2024-01-18 18:11:42', 'DELETE'),
(223, 120, '9999999999', 1, 11, 44.00, 4.40, 39.60, '2024-01-18 18:11:43', 'DELETE'),
(224, 119, '9999999999', 1, 11, 50.00, 7.50, 42.50, '2024-01-18 18:11:47', 'DELETE'),
(225, 118, '9999999999', 1, 11, 18.00, 0.00, 18.00, '2024-01-18 18:11:48', 'DELETE'),
(226, 117, '9999999999', 1, 11, 43.00, 4.30, 38.70, '2024-01-18 18:11:50', 'DELETE'),
(227, 116, '9999999999', 1, 11, 18.00, 0.00, 18.00, '2024-01-18 18:11:51', 'DELETE'),
(228, 115, '9999999999', 1, 11, 4.00, 0.00, 4.00, '2024-01-18 18:11:52', 'DELETE'),
(229, 114, '9999999999', 1, 11, 44.00, 4.40, 39.60, '2024-01-18 18:11:53', 'DELETE'),
(230, 113, '9999999999', 1, 11, 9.00, 0.00, 9.00, '2024-01-18 18:11:55', 'DELETE'),
(231, 112, '9999999999', 1, 11, 7.00, 0.00, 7.00, '2024-01-18 18:11:56', 'DELETE'),
(232, 111, '9999999999', 1, 11, 55.00, 8.25, 46.75, '2024-01-18 18:11:57', 'DELETE'),
(233, 110, '9999999999', 1, 11, 55.00, 8.25, 46.75, '2024-01-18 18:11:58', 'DELETE'),
(234, 109, '9999999999', 1, 11, 52.00, 7.80, 44.20, '2024-01-18 18:12:01', 'DELETE'),
(235, 108, '9999999999', 1, 11, 35.00, 3.50, 31.50, '2024-01-18 18:12:02', 'DELETE'),
(236, 107, '9999999999', 1, 11, 55.00, 8.25, 46.75, '2024-01-18 18:12:03', 'DELETE'),
(237, 106, '9999999999', 1, 11, 35.00, 3.50, 31.50, '2024-01-18 18:12:04', 'DELETE'),
(238, 105, '9999999999', 1, 11, 35.00, 3.50, 31.50, '2024-01-18 18:12:06', 'DELETE'),
(239, 104, '9999999999', 1, 11, 66.00, 9.90, 56.10, '2024-01-18 18:12:07', 'DELETE'),
(240, 126, NULL, 1, 11, 9.00, 0.00, 9.00, '2024-01-18 18:20:26', 'INSERT'),
(241, 127, NULL, 1, 1, 2.50, 0.00, 2.50, '2024-01-18 18:21:13', 'INSERT'),
(242, 127, '123456787', 1, 1, 2.50, 0.00, 2.50, '2024-01-18 18:22:04', 'DELETE'),
(243, 126, '9999999999', 1, 11, 9.00, 0.00, 9.00, '2024-01-18 18:22:06', 'DELETE'),
(244, 128, NULL, 1, 11, 6.00, 0.00, 6.00, '2024-01-18 18:57:43', 'INSERT'),
(245, 128, '9999999999', 1, 11, 6.00, 0.00, 6.00, '2024-01-18 19:03:44', 'DELETE'),
(246, 129, NULL, 1, 11, 13.00, 0.00, 13.00, '2024-01-18 22:56:10', 'INSERT'),
(247, 130, NULL, 1, 11, 2.00, 0.00, 2.00, '2024-01-19 15:45:05', 'INSERT'),
(248, 131, NULL, 1, 11, 14.00, 0.00, 14.00, '2024-01-20 11:07:33', 'INSERT'),
(249, 132, NULL, 1, 2, 18.00, 0.00, 18.00, '2024-01-20 11:10:01', 'INSERT'),
(250, 133, '32121332', 1, 9, 29.50, 1.48, 28.02, '2024-01-20 11:37:12', 'INSERT'),
(251, 133, '32121332', 1, 9, 29.50, 1.48, 28.02, '2024-01-20 11:42:22', 'DELETE'),
(252, 134, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-20 19:34:18', 'INSERT'),
(253, 135, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-20 20:48:01', 'INSERT'),
(254, 136, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-20 20:51:42', 'INSERT'),
(255, 137, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-20 20:53:34', 'INSERT'),
(256, 138, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-20 20:55:53', 'INSERT'),
(257, 139, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-20 20:57:51', 'INSERT'),
(258, 140, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-20 20:59:27', 'INSERT'),
(259, 141, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-20 21:01:58', 'INSERT'),
(260, 142, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-20 21:05:01', 'INSERT'),
(261, 143, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-20 21:06:42', 'INSERT'),
(262, 144, '9999999999', 1, 11, 2.50, 0.00, 2.50, '2024-01-20 21:11:38', 'INSERT'),
(263, 145, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-20 21:15:40', 'INSERT'),
(264, 146, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-20 21:41:47', 'INSERT'),
(265, 147, '9999999999', 1, 11, 2.00, 0.00, 2.00, '2024-01-20 22:38:24', 'INSERT'),
(266, 148, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 22:42:39', 'INSERT'),
(267, 149, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 23:02:13', 'INSERT'),
(268, 150, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 23:07:34', 'INSERT'),
(269, 151, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 23:09:48', 'INSERT'),
(270, 152, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 23:14:52', 'INSERT'),
(271, 153, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 23:25:15', 'INSERT'),
(272, 154, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 23:28:02', 'INSERT'),
(273, 155, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-20 23:57:45', 'INSERT'),
(274, 156, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-21 00:03:04', 'INSERT'),
(275, 157, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-21 00:27:45', 'INSERT'),
(276, 158, '9999999999', 1, 11, 17.50, 0.00, 17.50, '2024-01-21 00:33:44', 'INSERT'),
(277, 159, '9999999999', 1, 11, 11.00, 0.00, 11.00, '2024-01-21 01:03:59', 'INSERT'),
(278, 160, '9999999999', 1, 11, 13.50, 0.00, 13.50, '2024-01-21 01:05:45', 'INSERT'),
(279, 161, '9999999999', 1, 11, 28.50, 1.43, 27.08, '2024-01-21 01:21:15', 'INSERT'),
(280, 163, '9999999999', 1, 11, 28.50, 1.43, 27.08, '2024-01-21 01:41:53', 'INSERT'),
(281, 164, '9999999999', 1, 11, 10.50, 0.00, 10.50, '2024-01-21 01:45:11', 'INSERT'),
(282, 165, '9999999999', 1, 11, 6.00, 0.00, 6.00, '2024-01-21 01:48:30', 'INSERT'),
(283, 166, '9999999999', 1, 11, 1.50, 0.00, 1.50, '2024-01-21 01:51:52', 'INSERT'),
(284, 167, '9999999999', 1, 11, 12.00, 0.00, 12.00, '2024-01-21 13:42:09', 'INSERT'),
(285, 168, '9999999999', 1, 11, 11.00, 0.00, 11.00, '2024-01-21 13:44:59', 'INSERT'),
(286, 169, '9999999999', 1, 11, 16.50, 0.00, 16.50, '2024-01-21 13:47:05', 'INSERT'),
(287, 170, '9999999999', 1, 11, 1.50, 0.00, 1.50, '2024-01-21 13:51:10', 'INSERT'),
(288, 171, '9999999999', 1, 11, 1.50, 0.00, 1.50, '2024-01-21 13:54:11', 'INSERT'),
(289, 172, '9999999999', 1, 11, 11.00, 0.00, 11.00, '2024-01-21 13:55:45', 'INSERT'),
(290, 173, '9999999999', 1, 11, 16.50, 0.00, 16.50, '2024-01-21 14:00:59', 'INSERT'),
(291, 174, '9999999999', 1, 11, 14.00, 0.00, 14.00, '2024-01-21 14:04:45', 'INSERT'),
(292, 175, '9999999999', 1, 11, 18.00, 0.00, 18.00, '2024-01-21 14:06:46', 'INSERT'),
(293, 176, '9999999999', 1, 11, 18.00, 0.00, 18.00, '2024-01-21 14:10:45', 'INSERT'),
(294, 177, '9999999999', 1, 11, 18.50, 0.00, 18.50, '2024-01-21 14:12:13', 'INSERT'),
(295, 178, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-21 14:27:13', 'INSERT'),
(296, 179, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-21 14:32:04', 'INSERT'),
(297, 180, '9999999999', 1, 11, 16.50, 0.00, 16.50, '2024-01-21 14:42:04', 'INSERT'),
(298, 181, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-21 14:51:50', 'INSERT'),
(299, 182, '9999999999', 1, 11, 16.50, 0.00, 16.50, '2024-01-21 15:01:17', 'INSERT'),
(300, 183, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-21 15:04:42', 'INSERT'),
(301, 184, '9999999999', 1, 11, 16.50, 0.00, 16.50, '2024-01-21 15:14:18', 'INSERT'),
(302, 185, '9999999999', 1, 11, 22.00, 1.10, 20.90, '2024-01-21 15:16:55', 'INSERT'),
(303, 186, '9999999999', 1, 11, 22.00, 1.10, 20.90, '2024-01-21 15:19:08', 'INSERT'),
(304, 187, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-21 15:21:31', 'INSERT'),
(305, 188, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-21 18:59:16', 'INSERT'),
(306, 189, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-21 19:01:04', 'INSERT'),
(307, 190, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-21 19:03:46', 'INSERT'),
(308, 191, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-21 19:08:33', 'INSERT'),
(309, 192, '9999999999', 1, 11, 11.00, 0.00, 11.00, '2024-01-21 19:16:04', 'INSERT'),
(310, 193, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-21 19:21:27', 'INSERT'),
(311, 194, '9999999999', 1, 11, 17.50, 0.00, 17.50, '2024-01-21 21:46:47', 'INSERT'),
(312, 195, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-22 00:24:29', 'INSERT'),
(313, 196, '9999999999', 1, 11, 24.50, 1.23, 23.27, '2024-01-22 01:32:48', 'INSERT'),
(314, 197, '9999999999', 1, 11, 12.50, 0.00, 12.50, '2024-01-22 15:40:26', 'INSERT'),
(315, 198, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-22 16:21:21', 'INSERT'),
(316, 199, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-22 16:23:38', 'INSERT'),
(317, 200, '9999999999', 1, 11, 12.50, 0.00, 12.50, '2024-01-22 16:25:40', 'INSERT'),
(318, 201, '087654321', 7, 2, 25.50, 1.27, 24.23, '2024-01-23 19:21:05', 'INSERT'),
(319, 202, '087654321', 7, 2, 23.50, 1.18, 22.33, '2024-01-23 19:26:06', 'INSERT'),
(320, 203, '9999999999', 7, 11, 23.50, 1.18, 22.33, '2024-01-23 19:57:30', 'INSERT'),
(321, 204, '9999999999', 7, 11, 23.50, 1.18, 22.33, '2024-01-23 19:59:03', 'INSERT'),
(322, 205, '9999999999', 7, 11, 2.00, 0.00, 2.00, '2024-01-23 20:00:34', 'INSERT'),
(323, 206, '9999999999', 7, 11, 15.00, 0.00, 15.00, '2024-01-23 20:05:20', 'INSERT'),
(324, 207, '9999999999', 7, 11, 0.50, 0.00, 0.50, '2024-01-23 20:09:57', 'INSERT'),
(325, 208, '123456787', 7, 1, 24.00, 1.20, 22.80, '2024-01-23 20:34:52', 'INSERT'),
(326, 209, '123456787', 7, 1, 13.50, 0.00, 13.50, '2024-01-23 20:51:04', 'INSERT'),
(327, 210, '9999999999', 7, 11, 16.50, 0.00, 16.50, '2024-01-24 01:26:24', 'INSERT'),
(328, 211, '9999999999', 7, 11, 23.50, 1.18, 22.33, '2024-01-24 20:36:46', 'INSERT'),
(329, 129, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-24 21:30:20', 'DELETE'),
(330, 130, '9999999999', 1, 11, 2.00, 0.00, 2.00, '2024-01-24 21:30:20', 'DELETE'),
(331, 131, '9999999999', 1, 11, 14.00, 0.00, 14.00, '2024-01-24 21:30:20', 'DELETE'),
(332, 134, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-24 21:30:20', 'DELETE'),
(333, 135, '9999999999', 1, 11, 24.00, 1.20, 22.80, '2024-01-24 21:30:20', 'DELETE'),
(334, 136, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-24 21:30:20', 'DELETE'),
(335, 137, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-24 21:30:20', 'DELETE'),
(336, 138, '9999999999', 1, 11, 40.00, 4.00, 36.00, '2024-01-24 21:30:20', 'DELETE'),
(337, 139, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-24 21:30:20', 'DELETE'),
(338, 140, '9999999999', 1, 11, 30.00, 3.00, 27.00, '2024-01-24 21:30:20', 'DELETE'),
(339, 148, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(340, 149, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(341, 150, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(342, 151, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(343, 152, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(344, 153, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(345, 154, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(346, 155, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(347, 156, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(348, 157, '9999999999', 1, 11, 23.50, 1.18, 22.33, '2024-01-24 21:30:29', 'DELETE'),
(349, 187, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-24 21:30:44', 'DELETE'),
(350, 188, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-24 21:30:45', 'DELETE'),
(351, 189, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-24 21:30:45', 'DELETE'),
(352, 190, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-24 21:30:45', 'DELETE'),
(353, 191, '9999999999', 1, 11, 13.00, 0.00, 13.00, '2024-01-24 21:30:45', 'DELETE'),
(354, 212, '9999999999', 7, 11, 4.00, 0.00, 4.00, '2024-01-24 21:59:12', 'INSERT'),
(355, 213, '9999999999', 7, 11, 22.50, 1.13, 21.38, '2024-01-24 22:00:42', 'INSERT'),
(356, 214, '9999999999', 7, 11, 18.50, 0.93, 17.58, '2024-01-24 22:02:57', 'INSERT'),
(357, 215, '9999999999', 7, 11, 24.50, 2.45, 22.05, '2024-01-24 22:10:31', 'INSERT'),
(358, 1, '9999999999', 2, 11, 5.50, 1.10, 4.40, '2024-01-25 16:23:10', 'INSERT'),
(359, 2, '9999999999', 1, 11, 12.00, 1.20, 10.80, '2024-01-25 16:44:21', 'INSERT');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `ID_PRODUCTO` int(11) NOT NULL,
  `ID_PROVEEDOR` int(11) NOT NULL,
  `ID_CATEGORIA` int(11) NOT NULL,
  `CODIGO` varchar(20) NOT NULL,
  `NOMBRE` varchar(20) NOT NULL,
  `PROVEEDOR` varchar(20) NOT NULL,
  `STOCK` int(3) NOT NULL,
  `PRECIO_COMPRA` float(10,2) NOT NULL,
  `PRECIO_VENTA` float(10,2) NOT NULL,
  `FECHA_CADUCACION` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`ID_PRODUCTO`, `ID_PROVEEDOR`, `ID_CATEGORIA`, `CODIGO`, `NOMBRE`, `PROVEEDOR`, `STOCK`, `PRECIO_COMPRA`, `PRECIO_VENTA`, `FECHA_CADUCACION`) VALUES
(92, 14, 5, '002', 'Miel', '14-Proveedor2', 30, 3.50, 5.50, '2024-07-02'),
(95, 14, 4, '005', 'Doritos', '14-Proveedor2', 37, 0.25, 0.50, '2025-01-01'),
(96, 14, 9, '003', 'Lavaplatos-Axion', '14-Proveedor2', 37, 2.25, 3.50, '2024-05-03');

--
-- Disparadores `productos`
--
DELIMITER $$
CREATE TRIGGER `after_delete_productos` BEFORE DELETE ON `productos` FOR EACH ROW BEGIN
    INSERT INTO historial_productos (
        ID_CATEGORIA,
        ID_PRODUCTO, 
        ID_PROVEEDOR, 
        CODIGO, 
        NOMBRE, 
        PROVEEDOR, 
        STOCK,
        STOCK_EDITADO,  -- Asumiendo que quieres guardar el stock antiguo como stock editado
        PRECIO_COMPRA,
        PRECIO_COMPRA_EDITADO,  -- Asumiendo que quieres guardar el precio de compra antiguo como precio de compra editado
        PRECIO_VENTA,
        PRECIO_VENTA_EDITADO,  -- Asumiendo que quieres guardar el precio de venta antiguo como precio de venta editado
        FECHA_HORA, 
        ACCION
    ) VALUES (
        OLD.ID_CATEGORIA,
        OLD.ID_PRODUCTO, 
        OLD.ID_PROVEEDOR, 
        OLD.CODIGO, 
        OLD.NOMBRE, 
        OLD.PROVEEDOR, 
        OLD.STOCK,
        OLD.STOCK,  -- Este campo es STOCK_EDITADO y aquí se usa el stock antiguo
        OLD.PRECIO_COMPRA, 
        OLD.PRECIO_COMPRA,  -- Este campo es PRECIO_COMPRA_EDITADO y aquí se usa el precio de compra antiguo
        OLD.PRECIO_VENTA,
        OLD.PRECIO_VENTA,  -- Este campo es PRECIO_VENTA_EDITADO y aquí se usa el precio de venta antiguo
        NOW(), 
        'DELETE'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_productos` AFTER INSERT ON `productos` FOR EACH ROW BEGIN
   INSERT INTO historial_productos (ID_PRODUCTO,ID_PROVEEDOR,ID_CATEGORIA, CODIGO, NOMBRE, PROVEEDOR, STOCK, PRECIO_COMPRA, PRECIO_VENTA, FECHA_HORA, ACCION)
   VALUES (NEW.ID_PRODUCTO,NEW.ID_PROVEEDOR,NEW.ID_CATEGORIA, NEW.CODIGO, NEW.NOMBRE, NEW.PROVEEDOR, NEW.STOCK, NEW.PRECIO_COMPRA, NEW.PRECIO_VENTA, NOW(), 'INSERT');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_productos` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
    INSERT INTO historial_productos (ID_CATEGORIA ,ID_PRODUCTO, ID_PROVEEDOR, CODIGO, NOMBRE, PROVEEDOR, STOCK, STOCK_EDITADO, PRECIO_COMPRA, PRECIO_COMPRA_EDITADO, PRECIO_VENTA, PRECIO_VENTA_EDITADO, FECHA_HORA, ACCION)
    VALUES (NEW.ID_CATEGORIA ,NEW.ID_PRODUCTO, NEW.ID_PROVEEDOR, NEW.CODIGO, NEW.NOMBRE, NEW.PROVEEDOR, OLD.STOCK, NEW.STOCK, OLD.PRECIO_COMPRA, NEW.PRECIO_COMPRA, OLD.PRECIO_VENTA, NEW.PRECIO_VENTA, NOW(), 'UPDATE');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `ID_PROVEEDOR` int(11) NOT NULL,
  `RUC` varchar(15) NOT NULL,
  `NOMBRE` varchar(20) NOT NULL,
  `TELEFONO` varchar(15) NOT NULL,
  `DIRECCION` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`ID_PROVEEDOR`, `RUC`, `NOMBRE`, `TELEFONO`, `DIRECCION`) VALUES
(14, '1315779726001', 'Proveedor2', '0963021228', 'Dirección 2'),
(19, '1303872574001', 'Proveedor1', '0999999', 'asdasd'),
(20, '0503967648001', 'Proveedor3', '0963021224', 'Direccion 3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID_USUARIO` int(11) NOT NULL,
  `NOMBRE` varchar(20) NOT NULL,
  `CORREO` varchar(50) NOT NULL,
  `CONTRASENIA` varchar(100) NOT NULL,
  `ROL` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID_USUARIO`, `NOMBRE`, `CORREO`, `CONTRASENIA`, `ROL`) VALUES
(1, 'Administrador', 'admeduardito26@gmail.com', 'bvWKtWLVySZ7lIiGSon+YQ==', 'Administrador'),
(2, 'AnaVentas', 'ventaseduardito26@gmail.com', 'DTdsyG3T677rPXLI/XZdFg==', 'Vendedor');

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `verificar_correo_antes_actualizar` BEFORE UPDATE ON `usuarios` FOR EACH ROW BEGIN
    IF NOT INSTR(NEW.CORREO, '@') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo debe contener un @';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificar_correo_antes_insertar` BEFORE INSERT ON `usuarios` FOR EACH ROW BEGIN
    IF NOT INSTR(NEW.CORREO, '@') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo debe contener un @';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `ID_VENTA` int(11) NOT NULL,
  `ID_USUARIO` int(11) DEFAULT NULL,
  `ID_CLIENTE` int(11) NOT NULL,
  `SUBTOTAL` float(10,2) NOT NULL,
  `DESCUENTO` float(10,2) NOT NULL,
  `TOTAL` float(10,2) NOT NULL,
  `FECHA` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`ID_VENTA`, `ID_USUARIO`, `ID_CLIENTE`, `SUBTOTAL`, `DESCUENTO`, `TOTAL`, `FECHA`) VALUES
(1, 2, 11, 5.50, 1.10, 4.40, '2024-01-25 00:00:00'),
(2, 1, 11, 12.00, 1.20, 10.80, '2024-01-25 00:00:00');

--
-- Disparadores `ventas`
--
DELIMITER $$
CREATE TRIGGER `after_insert_venta` AFTER INSERT ON `ventas` FOR EACH ROW BEGIN
    DECLARE cliente_identificacion VARCHAR(15);

    -- Obtener la identificación del cliente de la venta que está siendo insertada.
    SELECT c.IDENTIFICACION INTO cliente_identificacion
    FROM clientes c
    WHERE c.ID_CLIENTE = NEW.ID_CLIENTE;

    -- Insertar el registro en historial_ventas con la identificación del cliente.
    -- Nota: Esto es inusual en un trigger BEFORE INSERT, ya que usualmente se utiliza para validar o modificar datos antes de la inserción.
    INSERT INTO historial_ventas (
        ID_VENTA,
        ID_USUARIO,
        ID_CLIENTE,
        IDENTIFICACION,
        SUBTOTAL,
        DESCUENTO,
        TOTAL,
        FECHA,
        ACCION
    ) VALUES (
        NEW.ID_VENTA,
        NEW.ID_USUARIO,
        NEW.ID_CLIENTE,
        cliente_identificacion,
        NEW.SUBTOTAL,
        NEW.DESCUENTO,
        NEW.TOTAL,
        NOW(),
        'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_ventas` BEFORE DELETE ON `ventas` FOR EACH ROW BEGIN
    DECLARE cliente_identificacion VARCHAR(15);

    -- Obtener la identificación del cliente antes de que la venta sea eliminada
    SELECT c.IDENTIFICACION INTO cliente_identificacion
    FROM clientes c
    WHERE c.ID_CLIENTE = OLD.ID_CLIENTE;


    -- Insertar el registro en historial_ventas con la identificación del cliente.
    INSERT INTO historial_ventas (
        ID_VENTA,
        ID_USUARIO,
        ID_CLIENTE,
        IDENTIFICACION,
        SUBTOTAL,
        DESCUENTO,
        TOTAL,
        FECHA,
        ACCION
    ) VALUES (
        OLD.ID_VENTA,
        OLD.ID_USUARIO,
        OLD.ID_CLIENTE,
        cliente_identificacion,
        OLD.SUBTOTAL,
        OLD.DESCUENTO,
        OLD.TOTAL,
        NOW(),
        'DELETE'
    );
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`ID_CATEGORIA`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`ID_CLIENTE`),
  ADD UNIQUE KEY `IDENTIFICACION` (`IDENTIFICACION`);

--
-- Indices de la tabla `detalle`
--
ALTER TABLE `detalle`
  ADD PRIMARY KEY (`ID_DETALLE`),
  ADD KEY `FK_RELATIONSHIP_2` (`ID_PRODUCTO`),
  ADD KEY `FK_RELATIONSHIP_9` (`ID_VENTA`);

--
-- Indices de la tabla `ganancias`
--
ALTER TABLE `ganancias`
  ADD PRIMARY KEY (`ID_GANANCIA`),
  ADD KEY `ID_DETALLE` (`ID_DETALLE`),
  ADD KEY `ID_PRODUCTO` (`ID_PRODUCTO`),
  ADD KEY `ID_VENTA` (`ID_VENTA`);

--
-- Indices de la tabla `historial_detalle`
--
ALTER TABLE `historial_detalle`
  ADD PRIMARY KEY (`ID_HISTORIAL`);

--
-- Indices de la tabla `historial_ganancias`
--
ALTER TABLE `historial_ganancias`
  ADD PRIMARY KEY (`id_historial`);

--
-- Indices de la tabla `historial_productos`
--
ALTER TABLE `historial_productos`
  ADD PRIMARY KEY (`ID_HISTORIAL`),
  ADD KEY `fk_categoria_historial` (`ID_CATEGORIA`);

--
-- Indices de la tabla `historial_ventas`
--
ALTER TABLE `historial_ventas`
  ADD PRIMARY KEY (`ID_HISTORIAL`),
  ADD KEY `fk_venta_cliente` (`ID_VENTA`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`ID_PRODUCTO`),
  ADD UNIQUE KEY `CODIGO` (`CODIGO`),
  ADD KEY `FK_RELATIONSHIP_4` (`ID_PROVEEDOR`),
  ADD KEY `fk_categoria_producto` (`ID_CATEGORIA`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`ID_PROVEEDOR`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID_USUARIO`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`ID_VENTA`),
  ADD KEY `FK_RELATIONSHIP_7` (`ID_USUARIO`),
  ADD KEY `FK_RELATIONSHIP_8` (`ID_CLIENTE`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `ID_CATEGORIA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `ID_CLIENTE` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `detalle`
--
ALTER TABLE `detalle`
  MODIFY `ID_DETALLE` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `ganancias`
--
ALTER TABLE `ganancias`
  MODIFY `ID_GANANCIA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `historial_detalle`
--
ALTER TABLE `historial_detalle`
  MODIFY `ID_HISTORIAL` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT de la tabla `historial_ganancias`
--
ALTER TABLE `historial_ganancias`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT de la tabla `historial_productos`
--
ALTER TABLE `historial_productos`
  MODIFY `ID_HISTORIAL` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=223;

--
-- AUTO_INCREMENT de la tabla `historial_ventas`
--
ALTER TABLE `historial_ventas`
  MODIFY `ID_HISTORIAL` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=360;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ID_PRODUCTO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `ID_PROVEEDOR` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID_USUARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `ID_VENTA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle`
--
ALTER TABLE `detalle`
  ADD CONSTRAINT `FK_RELATIONSHIP_9` FOREIGN KEY (`ID_VENTA`) REFERENCES `ventas` (`ID_VENTA`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ganancias`
--
ALTER TABLE `ganancias`
  ADD CONSTRAINT `ganancias_ibfk_1` FOREIGN KEY (`ID_DETALLE`) REFERENCES `detalle` (`ID_DETALLE`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ganancias_ibfk_2` FOREIGN KEY (`ID_PRODUCTO`) REFERENCES `productos` (`ID_PRODUCTO`) ON DELETE CASCADE,
  ADD CONSTRAINT `ganancias_ibfk_3` FOREIGN KEY (`ID_VENTA`) REFERENCES `ventas` (`ID_VENTA`);

--
-- Filtros para la tabla `historial_productos`
--
ALTER TABLE `historial_productos`
  ADD CONSTRAINT `fk_categoria_historial` FOREIGN KEY (`ID_CATEGORIA`) REFERENCES `categoria` (`ID_CATEGORIA`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `FK_RELATIONSHIP_4` FOREIGN KEY (`ID_PROVEEDOR`) REFERENCES `proveedor` (`ID_PROVEEDOR`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_categoria_producto` FOREIGN KEY (`ID_CATEGORIA`) REFERENCES `categoria` (`ID_CATEGORIA`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `FK_RELATIONSHIP_7` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuarios` (`ID_USUARIO`),
  ADD CONSTRAINT `FK_RELATIONSHIP_8` FOREIGN KEY (`ID_CLIENTE`) REFERENCES `clientes` (`ID_CLIENTE`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
