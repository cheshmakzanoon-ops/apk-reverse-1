package com.google.android.gms.common.api.internal;

import com.google.android.gms.common.api.Status;

public class StatusCallback extends IStatusCallback.Stub {
    private final BaseImplementation.ResultHolder<Status> resultHolder;

    public StatusCallback(BaseImplementation.ResultHolder<Status> resultHolder) {
        this.resultHolder = resultHolder;
    }

    @Override
    public void onResult(Status status) {
        this.resultHolder.setResult(status);
    }
}
