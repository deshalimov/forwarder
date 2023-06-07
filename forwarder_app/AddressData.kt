data class AddressData(
    val postal_code: String?,
    val country: String?,
    val region_with_type: String?,
    val city_with_type: String?,
    val street_with_type: String?,
    val house_type: String?,
    val house: String?
)

data class AddressSuggestion(
    val value: String,
    val data: AddressData
)

data class SuggestionsResponse(
    val suggestions: List<AddressSuggestion>
)
