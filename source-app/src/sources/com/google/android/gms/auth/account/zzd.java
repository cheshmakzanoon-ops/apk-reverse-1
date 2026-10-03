package com.google.android.gms.auth.account;

import android.os.IBinder;
import android.os.IInterface;

public abstract class zzd extends com.google.android.gms.internal.auth.zzb implements zzc {
    public static zzc zzc(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IInterface iInterfaceQueryLocalInterface = iBinder.queryLocalInterface("com.google.android.gms.auth.account.IWorkAccountService");
        if (iInterfaceQueryLocalInterface instanceof zzc) {
            return (zzc) iInterfaceQueryLocalInterface;
        }
        return new zze(iBinder);
    }
}
