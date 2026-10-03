package com.google.android.gms.internal.play_billing;

import sun.misc.Unsafe;

public final class zzcp$$ExternalSyntheticBackportWithForwarding0 {
    public static boolean m26m(Unsafe unsafe, Object obj, long j, Object obj2, Object obj3) {
        while (!unsafe.compareAndSwapObject(obj, j, obj2, obj3)) {
            if (unsafe.getObject(obj, j) != obj2) {
                return false;
            }
        }
        return true;
    }
}
