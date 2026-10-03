package com.google.android.gms.common.internal;

import com.google.android.gms.common.api.Response;
import com.google.android.gms.common.api.Result;

final class zaq implements PendingResultUtil.ResultConverter {
    final Response zaa;

    zaq(Response response) {
        this.zaa = response;
    }

    @Override
    public final Object convert(Result result) {
        this.zaa.setResult(result);
        return this.zaa;
    }
}
