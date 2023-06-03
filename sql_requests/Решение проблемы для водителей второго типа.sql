WITH 
num AS
	(
SELECT u.id,  CONCAT('+7', repeat(0, 10-LENGTH(u.id)), u.id) AS number_upd
	FROM users u
	),
u_number as
	(
		SELECT u.number
		FROM users u
		WHERE u.`type` = 'driver'
		GROUP BY u.`number`
		HAVING COUNT(u.`number`)>1
	),
temp as
	(
		SELECT u.id AS 'u_id_cd_g', cd.id AS 'id норм В',
		cd1.u_id as u_id_bad, cd1.cd_id AS id_cd_bad, 
		us_num.number_upd
		FROM u_number,
		(
		SELECT u.number AS u_number, cd.carrier_id AS c_id, u.id as u_id, cd.id AS cd_id,
		cd.first_name AS cd_first_name, cd.last_name AS cd_last_name, cd.middle_name AS cd_middle_name
			FROM u_number, users u
			JOIN carriers_drivers cd ON cd.user_id = u.id
			JOIN carriers c ON c.id = cd.carrier_id
			JOIN carrier_profile_details cpd ON cpd.carrier_id = c.id
			WHERE u.`number` = u_number.`number`
		) AS cd1,
		num AS us_num, carriers_drivers cd
		JOIN drivers d ON cd.user_id = d.id
		JOIN users u ON u.id = d.id
		JOIN carriers c ON c.id = cd.carrier_id
		JOIN carrier_profile_details cpd ON cpd.carrier_id = c.id
		WHERE 1=1
		and u.`number` = u_number.`number`
		and u.number = cd1.u_number
		AND cd.`status` != 'deleted'
		AND cd.carrier_id != cd1.c_id
		AND u.id != cd1.u_id
		AND cd1.u_id = us_num.id
		AND CONCAT_WS(' ', cd.last_name, cd.first_name, cd.middle_name) = 
		CONCAT_WS(' ', cd1.cd_last_name, cd1.cd_first_name, cd1.cd_middle_name)
	)

UPDATE temp, users u, carriers_drivers cd
SET cd.user_id = temp.u_id_cd_g,
u.number = temp.number_upd
WHERE cd.id = temp.id_cd_bad
AND u.id = temp.u_id_bad;