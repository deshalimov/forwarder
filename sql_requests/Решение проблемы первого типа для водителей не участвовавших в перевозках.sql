WITH temp AS (
	SELECT cd1.id AS cd_bad, cd.id AS cd_good
	FROM carriers_drivers cd1, carriers_drivers cd
	JOIN drivers d ON cd.user_id = d.id
	JOIN users u ON u.id = d.id
	JOIN carriers c ON c.id = cd.carrier_id
	JOIN carrier_profile_details cpd ON cpd.carrier_id = c.id
	WHERE cd1.id IN
		(
			SELECT cd.id
			FROM users u
			JOIN drivers d ON d.id = u.id
			JOIN carriers_drivers cd ON cd.user_id = d.id
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
			AND cd.`status` = 'deleted'
		)
	and u.`number` IN
		(
			SELECT u.`number`
			FROM users u
			WHERE u.`type` = 'driver'
			GROUP BY u.`number`
			HAVING COUNT(u.`number`)>1
		)
	AND cd.`status` != 'deleted'
	AND cd.carrier_id = cd1.carrier_id
	AND CONCAT_WS(' ', cd.last_name, cd.first_name, cd.middle_name) = CONCAT_WS(' ', cd1.last_name, cd1.first_name, cd1.middle_name)
	AND cd1.deleted_at IS NULL
	) 

UPDATE carriers_drivers cd, 
(SELECT * FROM temp)  as temp2
SET cd.deleted_at = NOW()
where cd.id = temp2.cd_bad;
