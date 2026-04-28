-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : sam. 25 avr. 2026 à 14:21
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gestiondesaccidentsroutiers`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `del_rap` (IN `num` VARCHAR(30))   BEGIN DELETE FROM rapport WHERE numero_rapport = num; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_vic` (IN `id` INT)   BEGIN DELETE FROM victime WHERE id_victime = id; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_zo__check` (IN `n` VARCHAR(50))   BEGIN DELETE FROM zone WHERE nom_zone = n; SELECT * FROM zone; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_con` (IN `n` VARCHAR(50), IN `t` VARCHAR(20))   BEGIN INSERT INTO conducteur (nom,telephone) VALUES (n, t); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_region` (IN `n` VARCHAR(50), IN `s` INT, IN `p` INT)   BEGIN INSERT INTO region (nom_region,superficie,population) VALUES (n, s, p); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_rou` (IN `n` VARCHAR(50), IN `z` INT)   BEGIN INSERT INTO route (nom_route,id_zone) VALUES (n, z); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ins_zo` (IN `n` VARCHAR(50), IN `r` INT)   BEGIN INSERT INTO zone (nom_zone, id_region) VALUES (n, r); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MajLongueurRoute` (IN `p_id` INT, IN `p_longueur` INT)   BEGIN UPDATE route SET longueur_km = p_longueur WHERE id_route = p_id; SELECT * FROM route WHERE id_route = p_id; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_age` (IN `a` INT)   BEGIN SELECT * FROM victime WHERE age = a; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_cond` (IN `n` VARCHAR(50))   BEGIN SELECT * FROM conducteur WHERE nom = n; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_rap` (IN `num` VARCHAR(30))   BEGIN SELECT * FROM rapport WHERE numero_rapport = num; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_route_zone` (IN `id` INT)   BEGIN SELECT * FROM route WHERE id_zone = id; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_zone` (IN `n` VARCHAR(50))   BEGIN SELECT * FROM zone WHERE nom_zone = n; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upd_age` (IN `id` INT, IN `nouv_age` INT)   BEGIN UPDATE victime SET age = nouv_age WHERE id_victime = id; SELECT * FROM victime WHERE id_victime = id; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upd_route` (IN `id` INT, IN `longue` INT)   BEGIN UPDATE route SET longueur_km = longue WHERE id_route = id; SELECT * FROM route WHERE id_route = id; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upd_tel` (IN `n` VARCHAR(50), IN `nouv_tel` VARCHAR(20))   BEGIN UPDATE conducteur SET telephone = nouv_tel WHERE nom = n; SELECT * FROM conducteur WHERE nom = n; END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `accident`
--

CREATE TABLE `accident` (
  `id_accident` int(11) NOT NULL,
  `date_accident` date NOT NULL,
  `heure_accident` time NOT NULL,
  `description` text DEFAULT NULL,
  `type_accident` enum('collision','renversement','pietons','autre') NOT NULL,
  `id_route` int(11) DEFAULT NULL,
  `gravite` enum('leger','grave','mortel') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `conducteur`
--

CREATE TABLE `conducteur` (
  `id_conducteur` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `date_naissance` date NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `adresse` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `conducteur`
--

INSERT INTO `conducteur` (`id_conducteur`, `nom`, `prenom`, `date_naissance`, `telephone`, `adresse`) VALUES
(1, 'Ndayishimiye', 'Pierre', '1985-03-14', '69001111', 'Bujumbura'),
(2, 'Niyonkuru', 'Marie', '1990-07-22', '69002222', 'Gitega'),
(3, 'Hakizimana', 'Jean', '1978-11-05', '69003333', 'Ngozi'),
(4, 'Nkurunziza', 'Aline', '1995-01-18', '69004444', 'Muyinga'),
(5, 'Bigirimana', 'Emmanuel', '1983-05-30', '69005555', 'Bujumbura'),
(6, 'Ntahoturi', 'Clarisse', '1988-09-12', '69006666', 'Bururi');

--
-- Déclencheurs `conducteur`
--
DELIMITER $$
CREATE TRIGGER `tr_rotation_conducteur` AFTER INSERT ON `conducteur` FOR EACH ROW BEGIN DECLARE total INT; SELECT COUNT(*) INTO total FROM conducteur; IF total > 5 THEN DELETE FROM conducteur WHERE id_conducteur = ( SELECT id_min FROM ( SELECT MIN(id_conducteur) AS id_min FROM conducteur ) AS tmp ); END IF; END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `corbeille_victime`
--

CREATE TABLE `corbeille_victime` (
  `id` int(11) DEFAULT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `date_suppression` datetime DEFAULT NULL,
  `date_expiration` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `corbeille_victime`
--

INSERT INTO `corbeille_victime` (`id`, `nom`, `date_suppression`, `date_expiration`) VALUES
(6, 'Test', '2026-04-25 12:26:31', '2026-04-27 12:26:31');

-- --------------------------------------------------------

--
-- Structure de la table `rapport`
--

CREATE TABLE `rapport` (
  `id_rapport` int(11) NOT NULL,
  `numero_rapport` varchar(30) NOT NULL,
  `date_rapport` date NOT NULL,
  `observations` text DEFAULT NULL,
  `id_accident` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `rapport`
--

INSERT INTO `rapport` (`id_rapport`, `numero_rapport`, `date_rapport`, `observations`, `id_accident`) VALUES
(1, 'RAP-2024-001', '2024-01-06', 'Deux blesses graves evacues au CHU', 1),
(2, 'RAP-2024-002', '2024-01-13', 'Renversement camion', 2),
(3, 'RAP-2024-003', '2024-01-21', 'Pieton renverse leger', 3),
(4, 'RAP-2024-004', '2024-02-04', 'Double deces', 4);

-- --------------------------------------------------------

--
-- Structure de la table `region`
--

CREATE TABLE `region` (
  `id_region` int(11) NOT NULL,
  `nom_region` varchar(100) NOT NULL,
  `superficie` decimal(10,0) DEFAULT NULL,
  `population` int(11) DEFAULT NULL,
  `chef_lieu` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `region`
--

INSERT INTO `region` (`id_region`, `nom_region`, `superficie`, `population`, `chef_lieu`) VALUES
(1, 'Bujumbura Mairie', 87, 1000000, 'Bujumbura'),
(2, 'Gitega', 1979, 730000, 'Gitega'),
(3, 'Ngozi', 1474, 620000, 'Ngozi'),
(4, 'Muyinga', 1739, 540000, 'Muyinga'),
(5, 'Makamba', 1960, 430000, 'Makamba');

-- --------------------------------------------------------

--
-- Structure de la table `route`
--

CREATE TABLE `route` (
  `id_route` int(11) NOT NULL,
  `nom_route` varchar(100) NOT NULL,
  `longueur_km` decimal(8,0) DEFAULT NULL,
  `id_zone` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `route`
--

INSERT INTO `route` (`id_route`, `nom_route`, `longueur_km`, `id_zone`) VALUES
(1, 'RN1 Bujumbura-Gitega', 120, 1),
(2, 'RN2 Gitega-Ngozi', 0, 5),
(3, 'Boulevard du 28 Novembre', 0, 1),
(4, 'Avenue de la Cathedrale', 0, 2),
(5, 'avenue de la mission', 20, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `vehicule`
--

CREATE TABLE `vehicule` (
  `id_vehicule` int(11) NOT NULL,
  `immatriculation` varchar(20) NOT NULL,
  `marque` varchar(50) NOT NULL,
  `modele` varchar(50) DEFAULT NULL,
  `annee_fabrication` int(11) DEFAULT NULL,
  `id_conducteur` int(11) DEFAULT NULL,
  `couleur` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `victime`
--

CREATE TABLE `victime` (
  `id_victime` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `sexe` enum('M','F') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `victime`
--

INSERT INTO `victime` (`id_victime`, `nom`, `prenom`, `age`, `sexe`) VALUES
(1, 'Kabura', 'Anselme', 35, 'M'),
(2, 'Minani', 'Rose', 28, 'F'),
(3, 'Nduwimana', 'Oscar', 45, 'M'),
(4, 'Nkurikiye', 'Solange', 22, 'F'),
(5, 'Bigirindavyi', 'Leon', 50, 'M');

--
-- Déclencheurs `victime`
--
DELIMITER $$
CREATE TRIGGER `tr_corbeille_victime` BEFORE DELETE ON `victime` FOR EACH ROW BEGIN INSERT INTO corbeille_victime (id, nom, date_suppression, date_expiration) VALUES (OLD.id_victime, OLD.nom, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY)); END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_details_rapports`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_details_rapports` (
`numero_rapport` varchar(30)
,`date_rapport` date
,`observations` text
,`id_accident` int(11)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_details_zones`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_details_zones` (
`id_zone` int(11)
,`nom_zone` varchar(100)
,`nom_region` varchar(100)
,`chef_lieu` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_liste_conducteurs_public`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_liste_conducteurs_public` (
`nom` varchar(100)
,`prenom` varchar(100)
,`date_naissance` date
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_victimes_majeures`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_victimes_majeures` (
`id_victime` int(11)
,`nom` varchar(100)
,`prenom` varchar(100)
,`age` int(11)
,`sexe` enum('M','F')
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_cond_buj`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_cond_buj` (
`nom` varchar(100)
,`prenom` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_contact_cond`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_contact_cond` (
`nom` varchar(100)
,`telephone` varchar(20)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_deces`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_deces` (
`id_rapport` int(11)
,`numero_rapport` varchar(30)
,`date_rapport` date
,`observations` text
,`id_accident` int(11)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_grandes_regions`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_grandes_regions` (
`nom_region` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_liste_routes`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_liste_routes` (
`nom_route` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_petites_regions`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_petites_regions` (
`nom_region` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_rapports_2024`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_rapports_2024` (
`id_rapport` int(11)
,`numero_rapport` varchar(30)
,`date_rapport` date
,`observations` text
,`id_accident` int(11)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_routes_a_remplir`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_routes_a_remplir` (
`id_route` int(11)
,`nom_route` varchar(100)
,`longueur_km` decimal(8,0)
,`id_zone` int(11)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_routes_bujumbura`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_routes_bujumbura` (
`nom_route` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_rural`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_rural` (
`nom_zone` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_victimes_enfants`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_victimes_enfants` (
`id_victime` int(11)
,`nom` varchar(100)
,`prenom` varchar(100)
,`age` int(11)
,`sexe` enum('M','F')
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_victimes_m`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_victimes_m` (
`nom` varchar(100)
,`prenom` varchar(100)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_zones_urbaines`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_zones_urbaines` (
`id_zone` int(11)
,`nom_zone` varchar(100)
,`type_zone` enum('urbaine','rurale')
,`id_region` int(11)
);

-- --------------------------------------------------------

--
-- Structure de la table `zone`
--

CREATE TABLE `zone` (
  `id_zone` int(11) NOT NULL,
  `nom_zone` varchar(100) NOT NULL,
  `type_zone` enum('urbaine','rurale') NOT NULL,
  `id_region` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `zone`
--

INSERT INTO `zone` (`id_zone`, `nom_zone`, `type_zone`, `id_region`) VALUES
(1, 'Centre Bujumbura', 'urbaine', 1),
(2, 'Ngagara', 'urbaine', 1),
(3, 'Kamenge', 'urbaine', 1),
(4, 'Gitega Centre', 'urbaine', 2);

-- --------------------------------------------------------

--
-- Structure de la vue `vue_details_rapports`
--
DROP TABLE IF EXISTS `vue_details_rapports`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vue_details_rapports`  AS SELECT `rapport`.`numero_rapport` AS `numero_rapport`, `rapport`.`date_rapport` AS `date_rapport`, `rapport`.`observations` AS `observations`, `rapport`.`id_accident` AS `id_accident` FROM `rapport` ;

-- --------------------------------------------------------

--
-- Structure de la vue `vue_details_zones`
--
DROP TABLE IF EXISTS `vue_details_zones`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vue_details_zones`  AS SELECT `z`.`id_zone` AS `id_zone`, `z`.`nom_zone` AS `nom_zone`, `r`.`nom_region` AS `nom_region`, `r`.`chef_lieu` AS `chef_lieu` FROM (`zone` `z` join `region` `r` on(`z`.`id_region` = `r`.`id_region`)) ;

-- --------------------------------------------------------

--
-- Structure de la vue `vue_liste_conducteurs_public`
--
DROP TABLE IF EXISTS `vue_liste_conducteurs_public`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vue_liste_conducteurs_public`  AS SELECT `conducteur`.`nom` AS `nom`, `conducteur`.`prenom` AS `prenom`, `conducteur`.`date_naissance` AS `date_naissance` FROM `conducteur` ;

-- --------------------------------------------------------

--
-- Structure de la vue `vue_victimes_majeures`
--
DROP TABLE IF EXISTS `vue_victimes_majeures`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vue_victimes_majeures`  AS SELECT `victime`.`id_victime` AS `id_victime`, `victime`.`nom` AS `nom`, `victime`.`prenom` AS `prenom`, `victime`.`age` AS `age`, `victime`.`sexe` AS `sexe` FROM `victime` WHERE `victime`.`age` >= 18 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_cond_buj`
--
DROP TABLE IF EXISTS `v_cond_buj`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_cond_buj`  AS SELECT `conducteur`.`nom` AS `nom`, `conducteur`.`prenom` AS `prenom` FROM `conducteur` WHERE `conducteur`.`adresse` = 'bujumbura' ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_contact_cond`
--
DROP TABLE IF EXISTS `v_contact_cond`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_contact_cond`  AS SELECT `conducteur`.`nom` AS `nom`, `conducteur`.`telephone` AS `telephone` FROM `conducteur` ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_deces`
--
DROP TABLE IF EXISTS `v_deces`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_deces`  AS SELECT `rapport`.`id_rapport` AS `id_rapport`, `rapport`.`numero_rapport` AS `numero_rapport`, `rapport`.`date_rapport` AS `date_rapport`, `rapport`.`observations` AS `observations`, `rapport`.`id_accident` AS `id_accident` FROM `rapport` WHERE `rapport`.`observations` like '%deces%' ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_grandes_regions`
--
DROP TABLE IF EXISTS `v_grandes_regions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_grandes_regions`  AS SELECT `region`.`nom_region` AS `nom_region` FROM `region` WHERE `region`.`population` > 500000 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_liste_routes`
--
DROP TABLE IF EXISTS `v_liste_routes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_liste_routes`  AS SELECT `route`.`nom_route` AS `nom_route` FROM `route` ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_petites_regions`
--
DROP TABLE IF EXISTS `v_petites_regions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_petites_regions`  AS SELECT `region`.`nom_region` AS `nom_region` FROM `region` WHERE `region`.`superficie` < 1000 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_rapports_2024`
--
DROP TABLE IF EXISTS `v_rapports_2024`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_rapports_2024`  AS SELECT `rapport`.`id_rapport` AS `id_rapport`, `rapport`.`numero_rapport` AS `numero_rapport`, `rapport`.`date_rapport` AS `date_rapport`, `rapport`.`observations` AS `observations`, `rapport`.`id_accident` AS `id_accident` FROM `rapport` WHERE `rapport`.`date_rapport` like '2024%' ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_routes_a_remplir`
--
DROP TABLE IF EXISTS `v_routes_a_remplir`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_routes_a_remplir`  AS SELECT `route`.`id_route` AS `id_route`, `route`.`nom_route` AS `nom_route`, `route`.`longueur_km` AS `longueur_km`, `route`.`id_zone` AS `id_zone` FROM `route` WHERE `route`.`longueur_km` = 0 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_routes_bujumbura`
--
DROP TABLE IF EXISTS `v_routes_bujumbura`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_routes_bujumbura`  AS SELECT `route`.`nom_route` AS `nom_route` FROM `route` WHERE `route`.`id_zone` = 1 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_rural`
--
DROP TABLE IF EXISTS `v_rural`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_rural`  AS SELECT `zone`.`nom_zone` AS `nom_zone` FROM `zone` WHERE `zone`.`type_zone` = 'rurale' ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_victimes_enfants`
--
DROP TABLE IF EXISTS `v_victimes_enfants`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_victimes_enfants`  AS SELECT `victime`.`id_victime` AS `id_victime`, `victime`.`nom` AS `nom`, `victime`.`prenom` AS `prenom`, `victime`.`age` AS `age`, `victime`.`sexe` AS `sexe` FROM `victime` WHERE `victime`.`age` < 18 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_victimes_m`
--
DROP TABLE IF EXISTS `v_victimes_m`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_victimes_m`  AS SELECT `victime`.`nom` AS `nom`, `victime`.`prenom` AS `prenom` FROM `victime` WHERE `victime`.`sexe` = 'M' ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_zones_urbaines`
--
DROP TABLE IF EXISTS `v_zones_urbaines`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_zones_urbaines`  AS SELECT `zone`.`id_zone` AS `id_zone`, `zone`.`nom_zone` AS `nom_zone`, `zone`.`type_zone` AS `type_zone`, `zone`.`id_region` AS `id_region` FROM `zone` WHERE `zone`.`type_zone` = 'urbaine' ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `accident`
--
ALTER TABLE `accident`
  ADD PRIMARY KEY (`id_accident`);

--
-- Index pour la table `conducteur`
--
ALTER TABLE `conducteur`
  ADD PRIMARY KEY (`id_conducteur`);

--
-- Index pour la table `rapport`
--
ALTER TABLE `rapport`
  ADD PRIMARY KEY (`id_rapport`),
  ADD UNIQUE KEY `numero_rapport` (`numero_rapport`);

--
-- Index pour la table `region`
--
ALTER TABLE `region`
  ADD PRIMARY KEY (`id_region`);

--
-- Index pour la table `route`
--
ALTER TABLE `route`
  ADD PRIMARY KEY (`id_route`);

--
-- Index pour la table `vehicule`
--
ALTER TABLE `vehicule`
  ADD PRIMARY KEY (`id_vehicule`),
  ADD UNIQUE KEY `immatriculation` (`immatriculation`);

--
-- Index pour la table `victime`
--
ALTER TABLE `victime`
  ADD PRIMARY KEY (`id_victime`);

--
-- Index pour la table `zone`
--
ALTER TABLE `zone`
  ADD PRIMARY KEY (`id_zone`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `accident`
--
ALTER TABLE `accident`
  MODIFY `id_accident` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `conducteur`
--
ALTER TABLE `conducteur`
  MODIFY `id_conducteur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `rapport`
--
ALTER TABLE `rapport`
  MODIFY `id_rapport` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `region`
--
ALTER TABLE `region`
  MODIFY `id_region` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `route`
--
ALTER TABLE `route`
  MODIFY `id_route` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `vehicule`
--
ALTER TABLE `vehicule`
  MODIFY `id_vehicule` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `victime`
--
ALTER TABLE `victime`
  MODIFY `id_victime` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `zone`
--
ALTER TABLE `zone`
  MODIFY `id_zone` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
