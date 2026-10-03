package com.google.android.gms.common.api.internal;

import com.google.android.gms.common.api.OptionalPendingResult;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.ResultTransform;
import com.google.android.gms.common.api.TransformedResult;
import java.util.concurrent.TimeUnit;

public final class OptionalPendingResultImpl<R extends Result> extends OptionalPendingResult<R> {
    private final BasePendingResult zaa;

    public OptionalPendingResultImpl(PendingResult pendingResult) {
        this.zaa = (BasePendingResult) pendingResult;
    }

    @Override
    public final void addStatusListener(PendingResult.StatusListener statusListener) {
        this.zaa.addStatusListener(statusListener);
    }

    @Override
    public final R await() {
        return (R) this.zaa.await();
    }

    @Override
    public final void cancel() {
        this.zaa.cancel();
    }

    @Override
    public final R get() {
        if (this.zaa.isReady()) {
            return (R) this.zaa.await(0L, TimeUnit.MILLISECONDS);
        }
        throw new IllegalStateException("Result is not available. Check that isDone() returns true before calling get().");
    }

    @Override
    public final boolean isCanceled() {
        return this.zaa.isCanceled();
    }

    @Override
    public final boolean isDone() {
        return this.zaa.isReady();
    }

    @Override
    public final void setResultCallback(ResultCallback<? super R> resultCallback) {
        this.zaa.setResultCallback(resultCallback);
    }

    @Override
    public final <S extends Result> TransformedResult<S> then(ResultTransform<? super R, ? extends S> resultTransform) {
        return this.zaa.then(resultTransform);
    }

    @Override
    public final R await(long j, TimeUnit timeUnit) {
        return (R) this.zaa.await(j, timeUnit);
    }

    @Override
    public final void setResultCallback(ResultCallback<? super R> resultCallback, long j, TimeUnit timeUnit) {
        this.zaa.setResultCallback(resultCallback, j, timeUnit);
    }
}
