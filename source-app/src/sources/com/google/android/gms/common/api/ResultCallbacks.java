package com.google.android.gms.common.api;

import android.util.Log;
import com.google.android.gms.common.api.Result;

public abstract class ResultCallbacks<R extends Result> implements ResultCallback<R> {
    public abstract void onFailure(Status status);

    @Override
    public final void onResult(R r) {
        Status status = r.getStatus();
        if (status.isSuccess()) {
            onSuccess(r);
            return;
        }
        onFailure(status);
        if (r instanceof Releasable) {
            try {
                ((Releasable) r).release();
            } catch (RuntimeException e) {
                String strValueOf = String.valueOf(r);
                String.valueOf(strValueOf);
                Log.w("ResultCallbacks", "Unable to release ".concat(String.valueOf(strValueOf)), e);
            }
        }
    }

    public abstract void onSuccess(R r);
}
