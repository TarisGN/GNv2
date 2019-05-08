USE `essentialmode`;

CREATE TABLE `weashops` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,

  PRIMARY KEY (`id`)
);

INSERT INTO `licenses` (type, label) VALUES
  ('weapon', "Permis de port d'arme")
;

INSERT INTO `items` (`name`, `label`) VALUES 
('clip', 'Chargeur')
;


INSERT INTO `weashops` (name, item, price) VALUES
	('GunShop', 'WEAPON_NIGHTSTICK', 150),
	('BlackWeashop', 'WEAPON_NIGHTSTICK', 150),
	('GunShop', 'WEAPON_BAT', 100),
	('BlackWeashop', 'WEAPON_BAT', 100),
	('GunShop', 'WEAPON_BALL', 50),
	('BlackWeashop', 'WEAPON_BALL', 50),
	('BlackWeashop', 'WEAPON_PISTOL', 50000)
;
