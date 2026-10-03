package com.google.android.gms.common.api.internal;

import android.os.IBinder;
import android.os.RemoteException;
import com.google.android.gms.common.api.Status;

public final class zaby extends com.google.android.gms.internal.base.zaa implements IStatusCallback {
    zaby(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.common.api.internal.IStatusCallback");
    }

    @Override
    public final void onResult(Status status) throws RemoteException {
        throw null;
    }
}
