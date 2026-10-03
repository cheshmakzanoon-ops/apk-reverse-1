package com.google.android.gms.internal.play_billing;

import sun.misc.Unsafe;

public final class zzcp {
    public static boolean zza(Unsafe unsafe, Object obj, long j, Object obj2, Object obj3) {
        while (!zzcp$$ExternalSyntheticBackportWithForwarding0.m26m(unsafe, obj, j, obj2, obj3)) {
            if (unsafe.getObject(obj, j) != obj2) {
                return false;
            }
        }
        return true;
    }
}
