USE `gtarp`;
 
CREATE TABLE IF NOT EXISTS `vgn_lottery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `numbers` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `datastore_data` (`name`, `owner`, `data`) VALUES
	('system', NULL, '0');
