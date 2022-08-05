package com.example.laspa_ok;

import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RetrofitClient {


    public  static Retrofit retrofit;
    private static String BASE_URL = "https://test.laspa.lg.gov.ng/LaspaApp/Api/";

//    String key = "123";

    public  static  Retrofit getRetrofitInstance(){

        if (retrofit == null){

            retrofit = new Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

        }
        return retrofit;

    }




}
