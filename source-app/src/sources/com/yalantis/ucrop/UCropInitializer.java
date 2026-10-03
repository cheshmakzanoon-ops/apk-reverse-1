package com.yalantis.ucrop;

import okhttp3.OkHttpClient;

public class UCropInitializer {
    public UCropInitializer setOkHttpClient(OkHttpClient okHttpClient) {
        OkHttpClientStore.INSTANCE.setClient(okHttpClient);
        return this;
    }
}
