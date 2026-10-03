package com.google.android.gms.cloudmessaging;

import android.os.Looper;
import android.os.Message;

final class zzaa extends com.google.android.gms.internal.cloudmessaging.zzf {
    final Rpc zza;

    zzaa(Rpc rpc, Looper looper) {
        super(looper);
        this.zza = rpc;
    }

    @Override
    public final void handleMessage(Message message) {
        Rpc.zzc(this.zza, message);
    }
}
