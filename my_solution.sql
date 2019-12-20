
-- TODO: Obviously these are not the optimal answers. Improve them.

-- Part 1: Find witnesses

SELECT date, type, description, city
FROM crime_scene_report
WHERE date=20180115 AND city='SQL City';

-- This provided me the information of the witnesses.

-- Witness 1: Lives in the last house of “Northwestern Dr”
-- Witness 2: Named Annabel, lives on “Franklin Ave.”


-- Part 2: Connect witnesses to personal
SELECT id, name
FROM person
WHERE address_street_name LIKE '%Frank%'AND name LIKE '%Annabel%';

-- >> Annabel Miller, person id 16371

SELECT id,name,address_number
FROM person
WHERE address_street_name LIKE '%Northwestern%'
ORDER BY address_number DESC
LIMIT 1;

-- >> Morty Schapiro, person id 14887

-- Part 3: Connect witness person id to interview
SELECT person_id, transcript
FROM interview
WHERE person_id = 16371 OR person_id = 14887;

-- 14887 (Morty): I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". Only gold members have those bags. 
-- The man got into a car with a plate that included "H42W".

-- 16371 (Annabel): I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

-- Suspect Gym Info: Membership status gold, number includes 48Z, last checked in 20180109
-- Suspect Car Info: Includes H42W

-- Part 4: Connect interview details and interviewees with 

SELECT m.name, m.person_id, m.membership_status, get_fit_now_check_in.check_in_date
FROM get_fit_now_member m
JOIN get_fit_now_check_in on m.id = get_fit_now_check_in.membership_id
WHERE m.membership_status = 'gold' AND 
		get_fit_now_check_in.check_in_date = 20180109