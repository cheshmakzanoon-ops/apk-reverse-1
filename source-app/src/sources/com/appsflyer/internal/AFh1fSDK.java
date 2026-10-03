package com.appsflyer.internal;

import java.util.Locale;

public enum AFh1fSDK {
    SUCCESS,
    FAILURE,
    NA,
    INTERNAL_ERROR;

    @Override
    public final String toString() {
        return super.toString().toLowerCase(Locale.getDefault());
    }
}
