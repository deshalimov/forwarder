val regionWithType = addressData?.region_with_type
val cityWithType = addressData?.city_with_type
val streetWithType = addressData?.street_with_type
val house = "${addressData?.house_type ?: ""} ${addressData?.house ?: ""}"
val originId = "$regionWithType, $cityWithType, $streetWithType, $house"
