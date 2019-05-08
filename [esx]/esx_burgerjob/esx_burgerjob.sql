SET @job_name = 'burgershot';
SET @society_name = 'society_burgershot';
SET @job_Name_Caps = 'BurgerShot';


INSERT INTO `datastore` (name, label, shared) VALUES 
    (@society_name, @job_Name_Caps, 1)
;

