package com.google.android.gms.common.api;

import com.google.android.gms.common.Feature;

public final class UnsupportedApiCallException extends UnsupportedOperationException {
    private final Feature zza;

    public UnsupportedApiCallException(Feature feature) {
        this.zza = feature;
    }

    @Override
    public String getMessage() {
        String strValueOf = String.valueOf(this.zza);
        String.valueOf(strValueOf);
        return "Missing ".concat(String.valueOf(strValueOf));
    }
}
