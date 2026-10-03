package com.google.android.gms.location;

import android.os.RemoteException;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzw implements RemoteCall {
    static final RemoteCall zza = new zzw();

    private zzw() {
    }

    @Override
    public final void accept(Object obj, Object obj2) throws RemoteException {
        ((com.google.android.gms.internal.location.zzaz) obj).zzK(new zzao((TaskCompletionSource) obj2));
    }
}
