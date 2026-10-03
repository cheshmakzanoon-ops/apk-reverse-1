package com.google.android.gms.location;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.internal.BaseImplementation;

public abstract class zzbi<R extends Result> extends BaseImplementation.ApiMethodImpl<R, com.google.android.gms.internal.location.zzaz> {
    public zzbi(GoogleApiClient googleApiClient) {
        super(LocationServices.API, googleApiClient);
    }

    @Override
    public final void setResult(Object obj) {
        super.setResult((Result) obj);
    }
}
