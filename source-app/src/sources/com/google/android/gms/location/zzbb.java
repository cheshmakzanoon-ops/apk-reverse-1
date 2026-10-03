package com.google.android.gms.location;

import android.location.Location;
import android.os.IBinder;
import android.os.RemoteException;

public final class zzbb extends com.google.android.gms.internal.location.zza implements zzbd {
    zzbb(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.location.ILocationListener");
    }

    @Override
    public final void zzd(Location location) throws RemoteException {
        throw null;
    }
}
