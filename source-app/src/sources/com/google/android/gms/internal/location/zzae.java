package com.google.android.gms.internal.location;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;

abstract class zzae extends com.google.android.gms.location.zzbi<Status> {
    public zzae(GoogleApiClient googleApiClient) {
        super(googleApiClient);
    }

    @Override
    public final Result createFailedResult(Status status) {
        return status;
    }
}
