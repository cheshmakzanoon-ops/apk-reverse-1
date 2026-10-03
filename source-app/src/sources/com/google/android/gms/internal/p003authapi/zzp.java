package com.google.android.gms.internal.p003authapi;

import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;

final class zzp extends zzh {
    private BaseImplementation.ResultHolder<Status> zzaq;

    zzp(BaseImplementation.ResultHolder<Status> resultHolder) {
        this.zzaq = resultHolder;
    }

    @Override
    public final void zzd(Status status) {
        this.zzaq.setResult(status);
    }
}
