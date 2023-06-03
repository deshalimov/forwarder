WITH cd1 AS (
	SELECT cd1.id AS cd_bad, cd.id AS cd_good, doli.id AS doli_id, doli.driver_id AS doli_driver_id
	FROM carriers_drivers cd1, delivery_order_lot_items doli, carriers_drivers cd
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
	AND cd1.id = doli.driver_id
	AND CONCAT_WS(' ', cd.last_name, cd.first_name, cd.middle_name) =		CONCAT_WS(' ', cd1.last_name, cd1.first_name, cd1.middle_name)
	) 

UPDATE delivery_order_lot_items doli,
cd1 AS temp
SET doli.driver_id = temp.cd_good
WHERE doli.id = temp.doli_id;
