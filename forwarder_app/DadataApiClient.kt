import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import okhttp3.logging.HttpLoggingInterceptor
package com.example.forwarder_app

import org.json.JSONObject

class DadataApiClient(
    val baseUrl: String,
    val apiKey: String) 
{
    val client: OkHttpClient
    init {
val loggingInterceptor = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }

     val authInterceptor = Interceptor { chain ->
     val request: Request = chain.request().newBuilder()
.addHeader("Authorization", "Token $apiKey")
     .build()
            chain.proceed(request)
        }

        client = OkHttpClient.Builder()
            .addInterceptor(authInterceptor)
            .addInterceptor(loggingInterceptor)
            .build()
    }
	
	fun getSuggestions(query: String): AddressData? {
    val url = "${baseUrl}/suggest/address"
    val request = Request.Builder()
        .url(url)
        .post(FormBody.Builder().add("query", query)
		.build())
        .build()
    val response = client.newCall(request).execute()
    val suggestions = Gson().fromJson<SuggestionsResponse>(response.body()?.string(), SuggestionsResponse::class.java)
    return suggestions.suggestions.firstOrNull()?.data
	}
	
	fun getSuggestionsByFiasId(fiasId: String): List<String> {
val url = "${baseUrl}/findById/address"
     val request = Request.Builder()
     	.url(url)
         	.post(FormBody.Builder().add("query", fiasId).build())
           .build()
      val response = client.newCall(request).execute()
      val suggestions = JSONObject(response.body()?.string()).getJSONArray("suggestions")
            .map { it.getJSONObject("data").getString("value") }
            .toList()
      return suggestions
    }

}
