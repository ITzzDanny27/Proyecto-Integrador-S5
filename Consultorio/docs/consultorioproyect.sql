-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-07-2024 a las 08:20:39
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
-- Base de datos: `consultorioproyect`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cita`
--

CREATE TABLE `cita` (
  `ID_CITA` int(11) NOT NULL,
  `ID_PACIENTE` int(11) DEFAULT NULL,
  `ID_RECEPCIONISTA` int(11) DEFAULT NULL,
  `FECHA` date NOT NULL,
  `HORA` time NOT NULL,
  `ESTADO` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cita_x_odontologo`
--

CREATE TABLE `cita_x_odontologo` (
  `ID_CITA` int(11) NOT NULL,
  `ID_ODONTOLOGO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consulta`
--

CREATE TABLE `consulta` (
  `ID_CONSULTA` int(11) NOT NULL,
  `ID_CITA` int(11) NOT NULL,
  `ID_TRATAMIENTO` int(11) DEFAULT NULL,
  `DESCRIPCION` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_medico`
--

CREATE TABLE `historial_medico` (
  `ID_HISTORIAL` int(11) NOT NULL,
  `ID_CONSULTA` int(11) DEFAULT NULL,
  `FECHA` date NOT NULL,
  `OBSERVACIONES` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `odontologo`
--

CREATE TABLE `odontologo` (
  `ID_ODONTOLOGO` int(11) NOT NULL,
  `NOMBRE` varchar(25) NOT NULL,
  `APELLIDO` varchar(25) NOT NULL,
  `ESPECIALIDAD` varchar(25) NOT NULL,
  `TELEFONO` varchar(15) NOT NULL,
  `CORREO_ELECTRONICO` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `ID_PACIENTE` int(11) NOT NULL,
  `PRIMER_NOMBRE` varchar(25) NOT NULL,
  `SEGUNDO_NOMBRE` varchar(25) DEFAULT NULL,
  `APELLIDO_PATERNO` varchar(25) NOT NULL,
  `APELLIDO_MATERNO` varchar(25) DEFAULT NULL,
  `FECHA_NACIMIENTO` date NOT NULL,
  `TELEFONO` varchar(15) NOT NULL,
  `CORREO_ELECTRONICO` varchar(50) DEFAULT NULL,
  `DIRECCION` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepcionista`
--

CREATE TABLE `recepcionista` (
  `ID_RECEPCIONISTA` int(11) NOT NULL,
  `NOMBRE` varchar(25) NOT NULL,
  `APELLIDO` varchar(25) NOT NULL,
  `TELEFONO` varchar(15) NOT NULL,
  `CORREO_ELECTRONICO` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tratamiento`
--

CREATE TABLE `tratamiento` (
  `ID_TRATAMIENTO` int(11) NOT NULL,
  `DESCRIPCION` varchar(50) NOT NULL,
  `COSTO` float NOT NULL,
  `DURACION` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cita`
--
ALTER TABLE `cita`
  ADD PRIMARY KEY (`ID_CITA`),
  ADD KEY `FK_CITA_PACIENTE__PACIENTE` (`ID_PACIENTE`),
  ADD KEY `FK_CITA_RECEPCION_RECEPCIO` (`ID_RECEPCIONISTA`);

--
-- Indices de la tabla `cita_x_odontologo`
--
ALTER TABLE `cita_x_odontologo`
  ADD PRIMARY KEY (`ID_CITA`,`ID_ODONTOLOGO`),
  ADD KEY `FK_CITA_X_O_CITA_X_OD_ODONTOLO` (`ID_ODONTOLOGO`);

--
-- Indices de la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD PRIMARY KEY (`ID_CONSULTA`),
  ADD KEY `FK_CONSULTA_CITA_X_CO_CITA` (`ID_CITA`),
  ADD KEY `FK_CONSULTA_TRATAMIEN_TRATAMIE` (`ID_TRATAMIENTO`);

--
-- Indices de la tabla `historial_medico`
--
ALTER TABLE `historial_medico`
  ADD PRIMARY KEY (`ID_HISTORIAL`),
  ADD KEY `FK_HISTORIA_HISTORIAL_CONSULTA` (`ID_CONSULTA`);

--
-- Indices de la tabla `odontologo`
--
ALTER TABLE `odontologo`
  ADD PRIMARY KEY (`ID_ODONTOLOGO`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`ID_PACIENTE`);

--
-- Indices de la tabla `recepcionista`
--
ALTER TABLE `recepcionista`
  ADD PRIMARY KEY (`ID_RECEPCIONISTA`);

--
-- Indices de la tabla `tratamiento`
--
ALTER TABLE `tratamiento`
  ADD PRIMARY KEY (`ID_TRATAMIENTO`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cita`
--
ALTER TABLE `cita`
  MODIFY `ID_CITA` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `consulta`
--
ALTER TABLE `consulta`
  MODIFY `ID_CONSULTA` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_medico`
--
ALTER TABLE `historial_medico`
  MODIFY `ID_HISTORIAL` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `odontologo`
--
ALTER TABLE `odontologo`
  MODIFY `ID_ODONTOLOGO` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `ID_PACIENTE` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recepcionista`
--
ALTER TABLE `recepcionista`
  MODIFY `ID_RECEPCIONISTA` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tratamiento`
--
ALTER TABLE `tratamiento`
  MODIFY `ID_TRATAMIENTO` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cita`
--
ALTER TABLE `cita`
  ADD CONSTRAINT `FK_CITA_PACIENTE__PACIENTE` FOREIGN KEY (`ID_PACIENTE`) REFERENCES `paciente` (`ID_PACIENTE`),
  ADD CONSTRAINT `FK_CITA_RECEPCION_RECEPCIO` FOREIGN KEY (`ID_RECEPCIONISTA`) REFERENCES `recepcionista` (`ID_RECEPCIONISTA`);

--
-- Filtros para la tabla `cita_x_odontologo`
--
ALTER TABLE `cita_x_odontologo`
  ADD CONSTRAINT `FK_CITA_X_O_CITA_X_OD_CITA` FOREIGN KEY (`ID_CITA`) REFERENCES `cita` (`ID_CITA`),
  ADD CONSTRAINT `FK_CITA_X_O_CITA_X_OD_ODONTOLO` FOREIGN KEY (`ID_ODONTOLOGO`) REFERENCES `odontologo` (`ID_ODONTOLOGO`);

--
-- Filtros para la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD CONSTRAINT `FK_CONSULTA_CITA_X_CO_CITA` FOREIGN KEY (`ID_CITA`) REFERENCES `cita` (`ID_CITA`),
  ADD CONSTRAINT `FK_CONSULTA_TRATAMIEN_TRATAMIE` FOREIGN KEY (`ID_TRATAMIENTO`) REFERENCES `tratamiento` (`ID_TRATAMIENTO`);

--
-- Filtros para la tabla `historial_medico`
--
ALTER TABLE `historial_medico`
  ADD CONSTRAINT `FK_HISTORIA_HISTORIAL_CONSULTA` FOREIGN KEY (`ID_CONSULTA`) REFERENCES `consulta` (`ID_CONSULTA`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
