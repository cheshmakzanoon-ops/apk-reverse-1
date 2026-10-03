package com.google.android.gms.common;

import java.util.concurrent.Callable;

final class zzx extends zzy {
    private final Callable zze;

    zzx(Callable callable, byte[] bArr) {
        super(false, 1, 5, null, null, -1L, null);
        this.zze = callable;
    }

    @Override
    final String zza() {
        try {
            return (String) this.zze.call();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
