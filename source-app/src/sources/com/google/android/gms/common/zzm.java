package com.google.android.gms.common;

import java.lang.ref.WeakReference;

abstract class zzm extends zzj {
    private static final WeakReference zzb = new WeakReference(null);
    private WeakReference zza;

    zzm(byte[] bArr) {
        super(bArr);
        this.zza = zzb;
    }

    protected abstract byte[] zzb();

    @Override
    final byte[] zzc() {
        byte[] bArrZzb;
        synchronized (this) {
            bArrZzb = (byte[]) this.zza.get();
            if (bArrZzb == null) {
                bArrZzb = zzb();
                this.zza = new WeakReference(bArrZzb);
            }
        }
        return bArrZzb;
    }
}
