package com.example.forwarder_app

package DadataApiClient

fun main() {
	val apiClient = DadataApiClient("https://suggestions.dadata.ru", "API_KEY")
	
	// получение 
	val suggestions_txt = apiClient.getSuggestions("Ростов-на-Дону Мильчакова 8А")
	val region = suggestions.firstOrNull()?.split(',', limit = 3)?.getOrNull(0)?.trim()
	val city = suggestions.firstOrNull()?.split(',', limit = 3)?.getOrNull(1)?.trim()
	val streetWithHouse = suggestions.firstOrNull()?.split(',', limit = 3)?.getOrNull(2)?.trim()
	val street = streetWithHouse?.split(' ', limit = 2)?.getOrNull(1)?.trim()
	val house = streetWithHouse?.replace(street ?: "", "")?.trim()
	val originId = "$region, $city, $street, $house"
	println(suggestions_txt)
		

	val suggestions = apiClient.getSuggestionsByFiasId ("2c2deb2d-7fa2-43e5-b7a7- 391fae6fdf29")
	val region = suggestions.firstOrNull()?.split(',', limit = 3)?.getOrNull(0)?.trim()
	val city = suggestions.firstOrNull()?.split(',', limit = 3)?.getOrNull(1)?.trim()
	val streetWithHouse = suggestions.firstOrNull()?.split(',', limit = 3)?.getOrNull(2)?.trim()
	val street = streetWithHouse?.split(' ', limit = 2)?.getOrNull(1)?.trim()
	val house = streetWithHouse?.replace(street ?: "", "")?.trim()
	val originId = "$region, $city, $street, $house"
	println(originId)
}