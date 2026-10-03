package com.google.android.gms.internal.measurement;

import android.os.IBinder;
import android.os.IInterface;

public abstract class zzcb extends zzbx implements zzby {
    public static zzby zza(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.finsky.externalreferrer.IGetInstallReferrerService");
        if (iInterfaceQueryLocalInterface instanceof zzby) {
            return (zzby) iInterfaceQueryLocalInterface;
        }
        return new zzca(iBinder);
    }
}
