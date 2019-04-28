USE `gtarp`;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_mecano','Mécano',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_mecano','Mécano',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('mecano','Mécano')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('mecano',0,'recrue','Apprenti',800,'{}','{}'),
  ('mecano',1,'novice','Mechanicien',1100,'{}','{}'),
  ('mecano',2,'experimente','Mechanicien chef',1500,'{}','{}'),
  ('mecano',3,'chief','Ingenieur Mechanique',2200,'{}','{}'),
  ('mecano',4,'boss','Garagiste',3500,'{}','{}')
;

INSERT INTO `items` (name, label) VALUES
  ('gazbottle', 'bouteille de gaz'),
  ('fixtool', 'outils réparation'),
  ('carotool', 'outils carosserie'),
  ('blowpipe', 'Chalumeaux'),
  ('fixkit', 'Kit réparation'),
  ('carokit', 'Kit carosserie')
;