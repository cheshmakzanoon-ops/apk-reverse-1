package com.google.android.gms.internal.measurement;

import android.os.Binder;

public final class zzge {
    public static <V> V zza(zzgd<V> zzgdVar) {
        try {
            return zzgdVar.zza();
        } catch (SecurityException unused) {
            long jClearCallingIdentity = Binder.clearCallingIdentity();
            try {
                return zzgdVar.zza();
            } finally {
                Binder.restoreCallingIdentity(jClearCallingIdentity);
            }
        }
    }
}
