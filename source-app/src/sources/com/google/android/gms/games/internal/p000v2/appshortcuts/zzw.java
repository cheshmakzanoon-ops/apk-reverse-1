package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.content.Intent;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.internal.games_v2.zzb;
import com.google.android.gms.internal.games_v2.zzc;

public abstract class zzw extends zzb implements zzx {
    public zzw() {
        super("com.google.android.gms.games.internal.v2.appshortcuts.IAppShortcutsServiceCallback");
    }

    @Override
    protected final boolean zza(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i == 1) {
            Status status = (Status) zzc.zzb(parcel, Status.CREATOR);
            zzc.zze(parcel);
            zzd(status);
        } else if (i == 2) {
            zzg zzgVar = (zzg) zzc.zzb(parcel, zzg.CREATOR);
            zzc.zze(parcel);
            zzb(zzgVar);
        } else {
            if (i != 3) {
                return false;
            }
            Intent intent = (Intent) zzc.zzb(parcel, Intent.CREATOR);
            zzc.zze(parcel);
            zzc(intent);
        }
        return true;
    }
}
