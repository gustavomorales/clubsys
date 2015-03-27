-- phpMyAdmin SQL Dump
-- version 4.2.3deb1.precise~ppa.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 27, 2015 at 11:07 AM
-- Server version: 5.6.15
-- PHP Version: 5.3.10-1ubuntu3.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `clubsys`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_actividad`(IN `instructor` INT, IN `nombre` VARCHAR(200), IN `descripcion` VARCHAR(200), IN `fecha_inicio` DATE)
    NO SQL
BEGIN

INSERT INTO `actividad`(`instructor_id`, `nombre`, `descripcion`) VALUES (instructor,nombre,descripcion);

INSERT INTO `historial_horario`(`actividad_id`, `fecha_implementacion`) VALUES ((SELECT id FROM actividad ORDER BY id DESC LIMIT 1),fecha_inicio);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_historial_horario`(IN `actividad` INT, IN `fecha_inicio` INT)
    NO SQL
BEGIN

  INSERT INTO `historial_horario`(`actividad_id`, `fecha_implementacion`)
    VALUES (actividad,fecha_inicio);
    
    DELETE FROM `clase` WHERE clase.actividad_id = actividad
    AND clase.fecha > fecha_inicio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_horario`(IN `actividad` INT, IN `dia` INT, IN `horario_llegada` TIME, IN `hora_salida` TIME)
    NO SQL
BEGIN

INSERT INTO `horario`(`hora_entrada`, `hora_salida`, `dia`, `historial_id`) VALUES (horario_llegada,hora_salida,dia, (SELECT id FROM historial_horario WHERE actividad_id = actividad
ORDER BY id DESC LIMIT 1));


SELECT @primerDia := `fecha_implementacion`
FROM historial_horario
WHERE historial_horario.actividad_id = actividad
ORDER BY id DESC LIMIT 1;

SELECT @cantidad := COUNT(*) FROM actividad
INNER JOIN historial_horario INNER JOIN horario
WHERE historial_horario.actividad_id = actividad.id
AND horario.historial_id = historial_horario.id;

SELECT @horario := horario.dia as dia FROM actividad
INNER JOIN historial_horario INNER JOIN horario
WHERE historial_horario.actividad_id = actividad.id
AND horario.historial_id = historial_horario.id
ORDER BY horario.id DESC LIMIT 1;



    WHILE WEEKDAY(@primerDia) != dia DO
        SET @primerDia = DATE_ADD(@primerDia, INTERVAL 1 DAY);
    END WHILE;

    WHILE YEAR(@primerDia) = YEAR(CURDATE()) DO
        INSERT INTO `clase`(`actividad_id`, `fecha`)
        VALUES (actividad,@primerDia);
        
        SET @primerDia = DATE_ADD(@primerDia, INTERVAL 7 DAY);
    END WHILE;
    
    
    SELECT WEEKDAY(@primerDia);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_usuario`(IN `tipo` INT, IN `nombres` VARCHAR(150), IN `apellido` VARCHAR(100), IN `pass` VARCHAR(100), IN `direccion` VARCHAR(150), IN `nacimiento` DATE)
    NO SQL
INSERT INTO `usuario`(`tipo_id`, `nombres`, `apellido`, `password`, `direccion`, `fecha_nacimiento`) VALUES (tipo,nombres,apellido,PASSWORD(pass),direccion,nacimiento)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `actividad`
--

CREATE TABLE IF NOT EXISTS `actividad` (
`id` int(11) NOT NULL,
  `instructor_id` int(11) NOT NULL,
  `nombre` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=16 ;

--
-- Dumping data for table `actividad`
--

INSERT INTO `actividad` (`id`, `instructor_id`, `nombre`, `descripcion`) VALUES
(1, 22, 'Natación', 'La natación es un deporte que consiste en el desplazamiento de una persona en el agua, sin que esta toque el suelo. Es regulado por la Federación Internacional de Natación.'),
(2, 21, 'sumo', 'Sumo es un tipo de lucha libre donde dos luchadores contrincantes o rikishi se enfrentan en un área circular. Es de origen japonés y mantiene gran parte de la tradición sintoista antigua.'),
(3, 22, 'aikido', 'El aikidō es un gendai budō o arte marcial moderno del Japón.Fue desarrollado inicialmente por el maestro Morihei Ueshiba (1883-1969), aproximadamente entre los años de 1930 y 1960.La característica fundamental del Aikido es la búsqueda de la neutralización del contrario en situaciones de conflicto, dando lugar a la derrota del adversario sin dañarlo, en lugar de simplemente destruirlo o humillarlo.'),
(4, 21, 'futbol', 'holasasa'),
(6, 21, 'Futbol 2', 'El partido se juega a las 18.15 hsssssssssss'),
(7, 21, 'cfdf', 'ds'),
(9, 20, 'Handball', 'blah'),
(10, 21, 'Karate', 'asdf'),
(13, 20, 'Gimnasia', 'asdf'),
(14, 22, 'Tai-chi', 'chuan');

-- --------------------------------------------------------

--
-- Table structure for table `actividad_por_usuario`
--

CREATE TABLE IF NOT EXISTS `actividad_por_usuario` (
  `fecha_inicio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_finalizacion` date DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `actividad_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `anuncio`
--

CREATE TABLE IF NOT EXISTS `anuncio` (
`id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `titulo` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `contenido` varchar(10000) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=ascii AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `ci_sessions`
--

CREATE TABLE IF NOT EXISTS `ci_sessions` (
  `session_id` varchar(40) NOT NULL DEFAULT '0',
  `ip_address` varchar(45) NOT NULL DEFAULT '0',
  `user_agent` varchar(120) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL DEFAULT '0',
  `user_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Dumping data for table `ci_sessions`
--

INSERT INTO `ci_sessions` (`session_id`, `ip_address`, `user_agent`, `last_activity`, `user_data`) VALUES
('0f5c762710bf5fe5d4ecc3bc2fe83ab3', '127.0.0.1', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 ', 1427464512, 'a:1:{s:17:"flash:old:success";s:39:"Actividad actualizada con &eacute;xito.";}'),
('3e6ca6dafc618395fd9642603dd367f2', '127.0.0.1', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 ', 1427459542, 'a:1:{s:17:"flash:new:mensaje";s:21:"Eliminaci?n exitosa.";}');

-- --------------------------------------------------------

--
-- Table structure for table `clase`
--

CREATE TABLE IF NOT EXISTS `clase` (
`id` int(11) NOT NULL,
  `actividad_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `clase_por_usuario`
--

CREATE TABLE IF NOT EXISTS `clase_por_usuario` (
  `usuario_id` int(11) NOT NULL,
  `id_clase` int(11) NOT NULL,
  `horario_llegada` time DEFAULT NULL,
  `hora_salida` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

-- --------------------------------------------------------

--
-- Table structure for table `comentario`
--

CREATE TABLE IF NOT EXISTS `comentario` (
`id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `anuncio_id` int(11) NOT NULL,
  `conenido` varchar(2000) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=ascii AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `etiqueta`
--

CREATE TABLE IF NOT EXISTS `etiqueta` (
`id` int(11) NOT NULL,
  `nombre` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `etiqueta_por_anuncio`
--

CREATE TABLE IF NOT EXISTS `etiqueta_por_anuncio` (
  `anuncio_id` int(11) NOT NULL,
  `etiqueta_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `historial_horario`
--

CREATE TABLE IF NOT EXISTS `historial_horario` (
`id` int(11) NOT NULL,
  `actividad_id` int(11) NOT NULL,
  `fecha_implementacion` date NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=13 ;

--
-- Dumping data for table `historial_horario`
--

INSERT INTO `historial_horario` (`id`, `actividad_id`, `fecha_implementacion`) VALUES
(1, 3, '2015-05-01'),
(2, 4, '2015-03-12'),
(3, 5, '2015-03-12'),
(4, 6, '2015-03-12'),
(5, 1, '2015-04-14'),
(6, 2, '2015-07-14'),
(7, 10, '2015-03-28'),
(8, 11, '2015-02-05'),
(9, 12, '2015-03-28'),
(10, 13, '2015-12-05'),
(11, 14, '2015-07-05'),
(12, 15, '2015-03-28');

-- --------------------------------------------------------

--
-- Table structure for table `historial_precio`
--

CREATE TABLE IF NOT EXISTS `historial_precio` (
`id` int(11) NOT NULL,
  `fecha_implementacion` date NOT NULL,
  `tipo_pago` int(11) NOT NULL,
  `actividad_id` int(11) DEFAULT NULL,
  `valor` decimal(11,2) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=4 ;

--
-- Dumping data for table `historial_precio`
--

INSERT INTO `historial_precio` (`id`, `fecha_implementacion`, `tipo_pago`, `actividad_id`, `valor`) VALUES
(1, '2015-01-01', 1, NULL, 1240.34),
(2, '2015-01-01', 2, NULL, 230.00),
(3, '2015-04-01', 2, NULL, 270.00);

-- --------------------------------------------------------

--
-- Table structure for table `horario`
--

CREATE TABLE IF NOT EXISTS `horario` (
`id` int(11) NOT NULL,
  `historial_id` int(11) NOT NULL,
  `hora_entrada` time NOT NULL,
  `hora_salida` time NOT NULL,
  `dia` tinyint(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `lista_actividades`
--
CREATE TABLE IF NOT EXISTS `lista_actividades` (
`id` int(11)
,`instructor` varchar(202)
,`nombre` varchar(30)
,`descripcion` varchar(800)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `lista_clase`
--
CREATE TABLE IF NOT EXISTS `lista_clase` (
`nombre` varchar(30)
,`CONCAT(usuario.apellido,', ', usuario.nombres)` varchar(202)
,`fecha` date
,`descripcion` varchar(200)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `lista_usuarios`
--
CREATE TABLE IF NOT EXISTS `lista_usuarios` (
`#` int(11)
,`tipoId` int(11)
,`Tipo` varchar(120)
,`Apellidos y nombres` varchar(202)
,`Dirección` varchar(100)
,`Fecha de nacimiento` date
,`Fecha de inscripción` date
);
-- --------------------------------------------------------

--
-- Table structure for table `pago`
--

CREATE TABLE IF NOT EXISTS `pago` (
`id` int(11) NOT NULL,
  `tipo` int(11) NOT NULL,
  `actividad_id` int(11) DEFAULT NULL,
  `tesorero` int(11) DEFAULT NULL,
  `usuario` int(11) NOT NULL,
  `mes` date NOT NULL,
  `vencimiento` date NOT NULL,
  `fecha_abonado` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `permiso`
--

CREATE TABLE IF NOT EXISTS `permiso` (
`id` int(11) NOT NULL,
  `descripcion` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=8 ;

--
-- Dumping data for table `permiso`
--

INSERT INTO `permiso` (`id`, `descripcion`) VALUES
(1, 'escribir blog'),
(2, 'registrar asistencias'),
(3, 'describir actividad'),
(4, 'efectuar cobros'),
(5, 'modificar precios'),
(6, 'enviar mail a usuarios'),
(7, 'administrar usuarios');

-- --------------------------------------------------------

--
-- Table structure for table `tipo_pago`
--

CREATE TABLE IF NOT EXISTS `tipo_pago` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Dumping data for table `tipo_pago`
--

INSERT INTO `tipo_pago` (`id`, `nombre`) VALUES
(1, 'matrícula'),
(2, 'cuota');

-- --------------------------------------------------------

--
-- Table structure for table `tipo_por_permiso`
--

CREATE TABLE IF NOT EXISTS `tipo_por_permiso` (
  `tipo_id` tinyint(4) NOT NULL,
  `permiso_id` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Dumping data for table `tipo_por_permiso`
--

INSERT INTO `tipo_por_permiso` (`tipo_id`, `permiso_id`) VALUES
(1, 1),
(1, 3),
(1, 5),
(1, 6),
(1, 7),
(2, 4),
(3, 1),
(3, 2),
(2, 6),
(3, 3),
(3, 6);

-- --------------------------------------------------------

--
-- Table structure for table `tipo_usuario`
--

CREATE TABLE IF NOT EXISTS `tipo_usuario` (
`id` int(11) NOT NULL,
  `nombre` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=5 ;

--
-- Dumping data for table `tipo_usuario`
--

INSERT INTO `tipo_usuario` (`id`, `nombre`) VALUES
(1, 'administrador'),
(2, 'tesorero'),
(3, 'instructor'),
(4, 'socio');

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
`id` int(11) NOT NULL,
  `tipo_id` int(11) NOT NULL,
  `nombres` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `apellido` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `direccion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `hora_inscripcion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=23 ;

--
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`id`, `tipo_id`, `nombres`, `apellido`, `password`, `direccion`, `fecha_nacimiento`, `hora_inscripcion`) VALUES
(1, 0, 'Jordan', 'Michael', '*948F9BEBA5FA4AD15FFF190593AC3EE1F9EDFE3F', 'Basket Blvd 512', '1973-02-17', '2015-03-06 10:32:11'),
(20, 3, 'Leonel', 'Messie', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Magallanes 123', '1983-02-01', '2015-03-27 09:43:57'),
(21, 3, 'Nat ', 'El malo', '*A4B6157319038724E3560894F7F932C8886EBFCF', '1234 everstreet', '1995-05-02', '2015-03-27 09:44:31'),
(22, 3, 'eric', 'trinchero', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'asdasd 651', '1995-05-04', '2015-03-27 09:44:54');

-- --------------------------------------------------------

--
-- Structure for view `lista_actividades`
--
DROP TABLE IF EXISTS `lista_actividades`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_actividades` AS select `actividad`.`id` AS `id`,concat(`usuario`.`apellido`,', ',`usuario`.`nombres`) AS `instructor`,`actividad`.`nombre` AS `nombre`,`actividad`.`descripcion` AS `descripcion` from (`actividad` join `usuario` on((`actividad`.`instructor_id` = `usuario`.`id`)));

-- --------------------------------------------------------

--
-- Structure for view `lista_clase`
--
DROP TABLE IF EXISTS `lista_clase`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_clase` AS select `actividad`.`nombre` AS `nombre`,concat(`usuario`.`apellido`,', ',`usuario`.`nombres`) AS `CONCAT(usuario.apellido,', ', usuario.nombres)`,`clase`.`fecha` AS `fecha`,`clase`.`descripcion` AS `descripcion` from ((`clase` join `actividad`) join `usuario` on(((`clase`.`actividad_id` = `actividad`.`id`) and (`actividad`.`instructor_id` = `usuario`.`id`)))) order by `clase`.`fecha`;

-- --------------------------------------------------------

--
-- Structure for view `lista_usuarios`
--
DROP TABLE IF EXISTS `lista_usuarios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_usuarios` AS select `usuario`.`id` AS `#`,`tipo_usuario`.`id` AS `tipoId`,concat(ucase(left(`tipo_usuario`.`nombre`,1)),substr(`tipo_usuario`.`nombre`,2)) AS `Tipo`,concat(`usuario`.`apellido`,', ',`usuario`.`nombres`) AS `Apellidos y nombres`,`usuario`.`direccion` AS `Dirección`,`usuario`.`fecha_nacimiento` AS `Fecha de nacimiento`,cast(`usuario`.`hora_inscripcion` as date) AS `Fecha de inscripción` from (`usuario` join `tipo_usuario`) where (`usuario`.`tipo_id` = `tipo_usuario`.`id`);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `actividad`
--
ALTER TABLE `actividad`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `anuncio`
--
ALTER TABLE `anuncio`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ci_sessions`
--
ALTER TABLE `ci_sessions`
 ADD PRIMARY KEY (`session_id`), ADD KEY `last_activity_idx` (`last_activity`);

--
-- Indexes for table `clase`
--
ALTER TABLE `clase`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comentario`
--
ALTER TABLE `comentario`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `etiqueta`
--
ALTER TABLE `etiqueta`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `historial_horario`
--
ALTER TABLE `historial_horario`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `historial_precio`
--
ALTER TABLE `historial_precio`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `horario`
--
ALTER TABLE `horario`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pago`
--
ALTER TABLE `pago`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permiso`
--
ALTER TABLE `permiso`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tipo_pago`
--
ALTER TABLE `tipo_pago`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tipo_usuario`
--
ALTER TABLE `tipo_usuario`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
 ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `actividad`
--
ALTER TABLE `actividad`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `anuncio`
--
ALTER TABLE `anuncio`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `clase`
--
ALTER TABLE `clase`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `comentario`
--
ALTER TABLE `comentario`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `etiqueta`
--
ALTER TABLE `etiqueta`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `historial_horario`
--
ALTER TABLE `historial_horario`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `historial_precio`
--
ALTER TABLE `historial_precio`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `horario`
--
ALTER TABLE `horario`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pago`
--
ALTER TABLE `pago`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `permiso`
--
ALTER TABLE `permiso`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `tipo_usuario`
--
ALTER TABLE `tipo_usuario`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=23;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;