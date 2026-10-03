package com.google.android.gms.common.internal;

import android.os.IBinder;
import android.os.RemoteException;

public final class zzu extends com.google.android.gms.internal.common.zza implements ICancelToken {
    zzu(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.common.internal.ICancelToken");
    }

    @Override
    public final void cancel() throws RemoteException {
        zzC(2, zza());
    }
}
