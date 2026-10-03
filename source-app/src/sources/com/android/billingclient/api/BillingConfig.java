package com.android.billingclient.api;

import org.json.JSONException;
import org.json.JSONObject;

public final class BillingConfig {
    private final String countryCode;

    BillingConfig(String str) throws JSONException {
        this.countryCode = new JSONObject(str).optString("countryCode");
    }

    private BillingConfig(String str, String str2) {
        this.countryCode = str2;
    }

    static BillingConfig forCountryCode(String str) {
        return new BillingConfig(null, str);
    }

    public String getCountryCode() {
        return this.countryCode;
    }
}
