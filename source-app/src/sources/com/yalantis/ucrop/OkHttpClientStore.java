package com.yalantis.ucrop;

import okhttp3.OkHttpClient;

public class OkHttpClientStore {
    public static final OkHttpClientStore INSTANCE = new OkHttpClientStore();
    private OkHttpClient client;

    private OkHttpClientStore() {
    }

    public OkHttpClient getClient() {
        if (this.client == null) {
            this.client = new OkHttpClient();
        }
        return this.client;
    }

    void setClient(OkHttpClient okHttpClient) {
        this.client = okHttpClient;
    }
}
