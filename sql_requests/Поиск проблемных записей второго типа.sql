SELECT u.id, cd.id, cd.`status`,
CONCAT_WS(' ', cd.last_name, cd.first_name, cd.middle_name),
u.number AS 'тлф норм', cpd.organization_name,
cd1.u_id, cd1.cd_id, cd1.`status`, 
CONCAT_WS(' ', cd1.cd_last_name, cd1.cd_first_name, cd1.cd_middle_name),
cd1.u_number,
cd1.organization_name,
us_num.number
FROM 
(
	SELECT u.id as u_id, cd.id AS cd_id,
	cd.carrier_id AS c_id, u.number AS u_number,
	cd.first_name AS cd_first_name, cd.last_name AS cd_last_name, cd.middle_name AS cd_middle_name,
	cd.`status` AS 'status', cpd.organization_name AS organization_name
	FROM users u
	JOIN carriers_drivers cd ON cd.user_id = u.id
	JOIN carriers c ON c.id = cd.carrier_id
	JOIN carrier_profile_details cpd ON cpd.carrier_id = c.id
	WHERE u.`number` IN
		(
			SELECT u.`number`
			FROM users u
			WHERE u.`type` = 'driver'
			GROUP BY u.`number`
			HAVING COUNT(u.`number`)>1
		)
) AS cd1,
(
	SELECT u.id,  CONCAT('+7', repeat(0, 10-LENGTH(u.id)), u.id) AS 'number'
	FROM users u
) AS us_num, carriers_drivers cd
JOIN drivers d ON cd.user_id = d.id
JOIN users u ON u.id = d.id
left JOIN carriers c ON c.id = cd.carrier_id
left JOIN carrier_profile_details cpd ON cpd.carrier_id = c.id
WHERE 1=1
and u.`number` IN
	(
		SELECT u.`number`
		FROM users u
		WHERE u.`type` = 'driver'
		GROUP BY u.`number`
		HAVING COUNT(u.`number`)>1
	)
and u.number = cd1.u_number
AND cd.`status` != 'deleted'
AND cd.carrier_id != cd1.c_id
AND u.id != cd1.u_id
AND cd1.u_id = us_num.id
AND CONCAT_WS(' ', cd.last_name, cd.first_name, cd.middle_name) = 
CONCAT_WS(' ', cd1.cd_last_name, cd1.cd_first_name, cd1.cd_middle_name);