
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

-- Part 4: Find the suspects based on given information

SELECT m.name, m.person_id, get_fit_now_check_in.check_in_date, person.license_id, drivers_license.plate_number
FROM get_fit_now_member m
JOIN get_fit_now_check_in on m.id = get_fit_now_check_in.membership_id
JOIN person on m.name = person.name
JOIN drivers_license on person.license_id = drivers_license.id
WHERE m.membership_status = 'gold' AND 
		get_fit_now_check_in.check_in_date = 20180109 AND
		drivers_license.plate_number LIKE '%H42W%'

-- Name: Jeremy Bowers
-- Person ID: 67318
-- License ID: 423327
-- Plate Number: 0H42W2

-------------------------Extra Challenge-------------------------------
-- If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villian behind this crime. 
-- If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries.


-- Part 1: Find the criminal's transcript
SELECT *
FROM interview
WHERE person_id = 67318

-- I was hired by a woman with a lot of money. 
-- I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
-- She has red hair and she drives a Tesla Model S. 
-- I know that she attended the SQL Symphony Concert 3 times in December 2017.

-- Part 2: Find the mastermind
SELECT p.name, COUNT(*) as event_attendance_frequency
FROM facebook_event_checkin fb
JOIN person as p on fb.person_id = p.id
JOIN drivers_license as dl on p.license_id = dl.id
WHERE dl.hair_color = 'red'
	AND dl.gender='female'
	AND car_make = 'Tesla'
	AND fb.date BETWEEN 20171201 AND 20180101
GROUP BY p.name
HAVING COUNT(*) >= 3
