package com.google.android.gms.internal.auth;

import android.os.IBinder;
import android.os.IInterface;

public abstract class zzf extends zzb implements zze {
    public static zze zza(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.auth.IAuthManagerService");
        if (iInterfaceQueryLocalInterface instanceof zze) {
            return (zze) iInterfaceQueryLocalInterface;
        }
        return new zzg(iBinder);
    }
}
