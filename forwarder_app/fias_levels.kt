val (city, house, flat, fiasLevel, houseFiasId) = address
when {
    fiasLevel == "9" -> {
        return Ok("")
    }
    fiasLevel == "8" && flat != null -> {
        return Ok("")
    }
    fiasLevel == "8" && flat == null -> {
        return Ok("Укажите офис")
    }
    house != null && houseFiasId == null -> {
        return Ok("Дом не найден в ФИАС")
    }
    fiasLevel in listOf("7") && house == null -> {
        return Error("Укажите улицу, дом")
    }
    fiasLevel in listOf("4", "5", "6", "65") && house == null -> {
        return Error("Укажите улицу, дом")
    }
    city == null && fiasLevel in listOf("0", "1", "3") -> {
        return Error("Укажите город")
    }
    else -> {
        return Error("Укажите адрес подробнее")
    }
};
