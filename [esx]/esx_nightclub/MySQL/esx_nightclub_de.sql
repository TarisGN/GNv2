SET @job_name = 'nightclub';
SET @society_name = 'society_nightclub';
SET @job_Name_Caps = 'Boite de nuit';



INSERT INTO `addon_account` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1),
  ('society_nightclub_fridge', 'Boite de nuit', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
    (@society_name, @job_Name_Caps, 1)
;

INSERT INTO `jobs` (name, label) VALUES
  (@job_name, @job_Name_Caps)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  (@job_name, 0, 'barman', 'Barman', 1450, '{}', '{}'),
  (@job_name, 1, 'dancer', 'Danseur', 1450, '{}', '{}'),
  (@job_name, 2, 'viceboss', 'Co-Manager', 3500, '{}', '{}'),
  (@job_name, 3, 'boss', 'Manager', 5000, '{}', '{}')
;
