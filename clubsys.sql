-- phpMyAdmin SQL Dump
-- version 4.2.3deb1.precise~ppa.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 07, 2015 at 10:56 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_historial_precio`(IN `actividad` INT, IN `fecha_implementacion` DATE, IN `valor` DOUBLE)
    NO SQL
BEGIN

IF actividad = 0 THEN
	INSERT INTO  `historial_precio`(`fecha_implementacion`,
    `actividad_id`, `valor`) 
    VALUES (MAKEDATE(YEAR(fecha_implementacion),1), 0, valor);
    
ELSE
	INSERT INTO `historial_precio`(`fecha_implementacion`,
    `actividad_id`, `valor`) 
    VALUES (month_first_day(fecha_implementacion), actividad, valor);
    
END IF;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_pagos`(IN `historial_id` DATE)
    NO SQL
BEGIN

	SELECT @fecha := `fecha_implementacion` FROM historial_precio
    WHERE id = historial_id;
    SET @fecha_temporal = @fecha;
    SELECT @precio := `valor` FROM historial_precio
    WHERE id = historial_id;
    SELECT @actividad := `actividad_id` FROM historial_precio
    WHERE id = historial_id;
    SELECT @ultimo_usuario := MAX(id) FROM usuario;
    SET @id_actual := 1;
    SET @usuario_actual := NULL;
    
    
    IF @actividad = 0 THEN
    	WHILE @id_actual <= @ultimo_usuario DO
			IF EXISTS (SELECT * FROM `usuario`
            WHERE id = @id_actual) THEN
            	INSERT INTO `pago`
                (`tipo`, `actividad_id`, `usuario`,
                 `fecha`, `vencimiento`)
                 VALUES (1 ,0, @id_actual, @fecha,
                 DATE_ADD(@fecha, INTERVAL 6 MONTH));
                 
             END IF;
             SET @id_actual = @id_actual + 1;
         END WHILE;
            
    	
    ELSE
    	WHILE @id_actual <= @ultimo_usuario DO
			IF EXISTS (SELECT * FROM `actividad_por_usuario`
            WHERE usuario_id = @id_actual AND
            actividad_id = @actividad) THEN
            	WHILE YEAR(@fecha_temporal) = YEAR(@fecha) DO
                    INSERT INTO `pago`
                    (`tipo`, `actividad_id`, `usuario`,
                     `fecha`, `vencimiento`)
                     VALUES (1 ,0, @id_actual, @fecha,
                     DATE_ADD(@fecha, INTERVAL 2 MONTH));
                     
                 	 SET @fecha_temporal := DATE_ADD(@fecha_temporal,
                 	INTERVAL 1 MONTH);
                 END WHILE;
                 
                 SET @fecha_temporal = @fecha;
             END IF;
             SET @id_actual = @id_actual + 1;
         END WHILE;
    
    END IF;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_usuario`(IN `tipo` INT, IN `nombres` VARCHAR(150), IN `apellido` VARCHAR(100), IN `pass` VARCHAR(100), IN `direccion` VARCHAR(150), IN `nacimiento` DATE, IN `dni` INT)
    NO SQL
INSERT INTO `usuario`(`tipo_id`, `nombres`, `apellido`, `password`, `direccion`, `fecha_nacimiento`, `dni`) VALUES (tipo,nombres,apellido,PASSWORD(pass),direccion,nacimiento, dni)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `desinscribir_a_actividad`(IN `actividad` INT, IN `usuario` INT)
    NO SQL
UPDATE `actividad_por_usuario` SET `fecha_finalizacion`=DATE(CURRENT_TIMESTAMP()) WHERE
`actividad_id` = actividad AND `usuario_id` = usuario$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inscribir_a_actividad`(IN `usuario_id` INT, IN `actividad_id` INT)
    NO SQL
INSERT INTO `actividad_por_usuario`(`fecha_inicio`, `usuario_id`, `actividad_id`) VALUES (DATE(CURRENT_TIMESTAMP()),usuario_id,actividad_id)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_faltas`(IN `clase_id` INT)
    NO SQL
UPDATE `clase_por_usuario` SET `asistencia`=FALSE WHERE asistencia IS NULL$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `month_first_day`(`day` DATE) RETURNS date
    DETERMINISTIC
BEGIN
  RETURN ADDDATE(LAST_DAY(SUBDATE(day, INTERVAL 1 MONTH)), 1);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `actividad`
--

CREATE TABLE IF NOT EXISTS `actividad` (
`id` int(11) NOT NULL,
  `instructor_id` int(11) DEFAULT NULL,
  `nombre` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `descripcion` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=4 ;

--
-- Dumping data for table `actividad`
--

INSERT INTO `actividad` (`id`, `instructor_id`, `nombre`, `descripcion`) VALUES
(3, 4, 'Gimnasia Artistica', 'Gimnasia Artistica');

-- --------------------------------------------------------

--
-- Table structure for table `actividad_por_usuario`
--

CREATE TABLE IF NOT EXISTS `actividad_por_usuario` (
  `fecha_inicio` date NOT NULL,
  `fecha_finalizacion` date DEFAULT '9999-12-31',
  `usuario_id` int(11) NOT NULL,
  `actividad_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii;

--
-- Dumping data for table `actividad_por_usuario`
--

INSERT INTO `actividad_por_usuario` (`fecha_inicio`, `fecha_finalizacion`, `usuario_id`, `actividad_id`) VALUES
('2015-04-07', '9999-12-31', 2, 1),
('2015-04-07', '9999-12-31', 5, 3);

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
('448c16ad33ae89f3da0b78289df58d51', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0', 1428410015, ''),
('72fd753cdc075f42e5b8ac5a08d20bb5', '127.0.0.1', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 ', 1428414858, '');

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
  `asistencia` tinyint(1) DEFAULT NULL
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
  `fecha_implementacion` date NOT NULL,
  `fecha_finalizacion` date DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=4 ;

--
-- Dumping data for table `historial_horario`
--

INSERT INTO `historial_horario` (`id`, `actividad_id`, `fecha_implementacion`, `fecha_finalizacion`) VALUES
(3, 3, '2015-04-16', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `historial_precio`
--

CREATE TABLE IF NOT EXISTS `historial_precio` (
`id` int(11) NOT NULL,
  `fecha_implementacion` date NOT NULL,
  `actividad_id` int(11) DEFAULT NULL,
  `valor` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ascii AUTO_INCREMENT=1 ;

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
,`fecha_inicio` date
,`fecha_finalizacion` date
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
-- Stand-in structure for view `lista_participantes`
--
CREATE TABLE IF NOT EXISTS `lista_participantes` (
`actividad_id` int(11)
,`usuario_id` int(11)
,`nombre_actividad` varchar(30)
,`participante` varchar(202)
,`finalizacion` date
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `lista_usuarios`
--
CREATE TABLE IF NOT EXISTS `lista_usuarios` (
`usuario_id` int(11)
,`dni` int(11)
,`tipo_id` int(11)
,`tipo` varchar(30)
,`nombre_completo` varchar(202)
,`direccion` varchar(100)
,`fecha_nacimiento` date
,`fecha_inscripcion` date
);
-- --------------------------------------------------------

--
-- Table structure for table `pago`
--

CREATE TABLE IF NOT EXISTS `pago` (
`id` int(11) NOT NULL,
  `tipo` int(11) NOT NULL,
  `actividad_id` int(11) NOT NULL,
  `tesorero` int(11) DEFAULT NULL,
  `usuario` int(11) NOT NULL,
  `fecha` date NOT NULL,
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
  `dni` int(11) NOT NULL,
  `nombres` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `apellido` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `direccion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `hora_inscripcion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB  DEFAULT CHARSET=ascii AUTO_INCREMENT=7 ;

--
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`id`, `tipo_id`, `dni`, `nombres`, `apellido`, `password`, `direccion`, `fecha_nacimiento`, `hora_inscripcion`) VALUES
(4, 3, 293487777, 'Frepo', 'Profe', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Mi casa 1234 D5', '2014-01-23', '2015-04-07 10:50:54'),
(5, 4, 25896355, 'Segundo', 'Sombra', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Magallanes 123', '2015-04-06', '2015-04-07 10:52:42'),
(6, 2, 1236448, 'Amelia', 'Acentos', '*A4B6157319038724E3560894F7F932C8886EBFCF', 'Magallanes 123', '2015-04-06', '2015-04-07 10:54:07');

-- --------------------------------------------------------

--
-- Structure for view `lista_actividades`
--
DROP TABLE IF EXISTS `lista_actividades`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_actividades` AS select `actividad`.`id` AS `id`,concat(`usuario`.`apellido`,', ',`usuario`.`nombres`) AS `instructor`,`actividad`.`nombre` AS `nombre`,`actividad`.`descripcion` AS `descripcion`,max(`historial_horario`.`fecha_implementacion`) AS `fecha_inicio`,`historial_horario`.`fecha_finalizacion` AS `fecha_finalizacion` from ((`actividad` left join `usuario` on((`actividad`.`instructor_id` = `usuario`.`id`))) left join `historial_horario` on((`historial_horario`.`actividad_id` = `actividad`.`id`))) group by `actividad`.`id`;

-- --------------------------------------------------------

--
-- Structure for view `lista_clase`
--
DROP TABLE IF EXISTS `lista_clase`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_clase` AS select `actividad`.`nombre` AS `nombre`,concat(`usuario`.`apellido`,', ',`usuario`.`nombres`) AS `CONCAT(usuario.apellido,', ', usuario.nombres)`,`clase`.`fecha` AS `fecha`,`clase`.`descripcion` AS `descripcion` from ((`clase` join `actividad`) join `usuario` on(((`clase`.`actividad_id` = `actividad`.`id`) and (`actividad`.`instructor_id` = `usuario`.`id`)))) order by `clase`.`fecha`;

-- --------------------------------------------------------

--
-- Structure for view `lista_participantes`
--
DROP TABLE IF EXISTS `lista_participantes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_participantes` AS select `actividad_por_usuario`.`actividad_id` AS `actividad_id`,`actividad_por_usuario`.`usuario_id` AS `usuario_id`,`actividad`.`nombre` AS `nombre_actividad`,concat(`usuario`.`apellido`,', ',`usuario`.`nombres`) AS `participante`,`actividad_por_usuario`.`fecha_finalizacion` AS `finalizacion` from ((`usuario` join `actividad`) join `actividad_por_usuario` on(((`actividad_por_usuario`.`usuario_id` = `usuario`.`id`) and (`actividad_por_usuario`.`actividad_id` = `actividad`.`id`))));

-- --------------------------------------------------------

--
-- Structure for view `lista_usuarios`
--
DROP TABLE IF EXISTS `lista_usuarios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_usuarios` AS select `usuario`.`id` AS `usuario_id`,`usuario`.`dni` AS `dni`,`usuario`.`tipo_id` AS `tipo_id`,`tipo_usuario`.`nombre` AS `tipo`,concat(`usuario`.`apellido`,', ',`usuario`.`nombres`) AS `nombre_completo`,`usuario`.`direccion` AS `direccion`,`usuario`.`fecha_nacimiento` AS `fecha_nacimiento`,cast(`usuario`.`hora_inscripcion` as date) AS `fecha_inscripcion` from (`usuario` join `tipo_usuario` on((`tipo_usuario`.`id` = `usuario`.`tipo_id`)));

--
-- Indexes for dumped tables
--

--
-- Indexes for table `actividad`
--
ALTER TABLE `actividad`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `nombre` (`nombre`), ADD KEY `fk_Instructor` (`instructor_id`);

--
-- Indexes for table `actividad_por_usuario`
--
ALTER TABLE `actividad_por_usuario`
 ADD PRIMARY KEY (`usuario_id`,`actividad_id`);

--
-- Indexes for table `anuncio`
--
ALTER TABLE `anuncio`
 ADD PRIMARY KEY (`id`), ADD KEY `fk_Usuario` (`usuario_id`);

--
-- Indexes for table `ci_sessions`
--
ALTER TABLE `ci_sessions`
 ADD PRIMARY KEY (`session_id`), ADD KEY `last_activity_idx` (`last_activity`);

--
-- Indexes for table `clase`
--
ALTER TABLE `clase`
 ADD PRIMARY KEY (`id`), ADD KEY `fk_ActividadClase` (`actividad_id`);

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
 ADD PRIMARY KEY (`id`), ADD KEY `fk_Actividad` (`actividad_id`);

--
-- Indexes for table `historial_precio`
--
ALTER TABLE `historial_precio`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `horario`
--
ALTER TABLE `horario`
 ADD PRIMARY KEY (`id`), ADD KEY `fk_HistorialHorario` (`historial_id`);

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
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `dni` (`dni`), ADD KEY `fk_TipoUsuario` (`tipo_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `actividad`
--
ALTER TABLE `actividad`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
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
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `historial_precio`
--
ALTER TABLE `historial_precio`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `usuario`
--
ALTER TABLE `usuario`
ADD CONSTRAINT `fk_TipoUsuario` FOREIGN KEY (`tipo_id`) REFERENCES `tipo_usuario` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
