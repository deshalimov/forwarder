val loginId = getLoginId()

val rearrangement_button: FloatingActionButton = findViewById(R.id.rearrangementButton)

rearrangement_button.setOnClickListener {
    val script = "UPDATE external_data_items edi " +
            "JOIN external_data_items_waybills ediw ON ediw.item_id = edi.id " +
            "JOIN organizations o ON o.id = 
edi.organization_id" +
            "JOIN cargo_owners co ON co.id = 
edi.cargo_owner_id" +
            "JOIN cargo_owner_profile_details copd ON 
copd.cargo_owner_id = co.id " +
            "JOIN carriers c ON c.id = edi.carrier_id " +
            "JOIN carrier_profile_details cpd ON 
cpd.carrier_id = c.id " +
            "JOIN organizations o_2 ON 
o_2.id = edi.consignee_id" +
            "JOIN organizations o_3 ON o_3.id = 
edi.consignor_id" +
            "SET " +
            "ediw.organization = CONCAT_WS(', ', o.value, o.inn, o.address_value), " +
            "ediw.cargo_owner = copd.organization_name,"+
            "ediw.product = CONCAT(edi.nomenclature, ', год урожая ', edi.crops_year), " +
            "ediw.consignor = o_3.value, " +
            "ediw.consignee = o_2.value, " +
            "ediw.shipping_organization = CONCAT_WS(' ', cpd.organization_full_name, cpd.legal_address, 'ИНН ', cpd.individual_taxpayer_number), " +
            "ediw.origin_address = o_2.address_value, " +
            "ediw.destination_address=o_3.address_value"+
            "WHERE edi.manager_id = $loginId;"

    val db = writableDatabase
    db.execSQL(script)
    db.close()
}
