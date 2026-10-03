package com.google.android.gms.internal.p003authapi;

import android.util.Base64;
import java.util.Random;

public final class zzal {
    private static final Random zzcv = new Random();

    public static String zzr() {
        byte[] bArr = new byte[16];
        zzcv.nextBytes(bArr);
        return Base64.encodeToString(bArr, 11);
    }
}
