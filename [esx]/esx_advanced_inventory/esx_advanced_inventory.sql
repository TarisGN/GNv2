--
-- Structure de la table `item_weight`
--

CREATE TABLE IF NOT EXISTS `item_weight` (
  `id` int(11) NOT NULL,
  `item` varchar(255) NOT NULL,
  `weight` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `item_weight`
--
ALTER TABLE `item_weight`
 ADD PRIMARY KEY (`id`);


-- Exemple

INSERT INTO `item_weight` (`id`, `item`, `weight`) VALUES
(1, 'pain', 20),
(2, 'eau', 50),
(3, 'weed', 200),
(4, 'weed_pooch', 300);