package com.google.common.util.concurrent;

import java.util.concurrent.atomic.AtomicReferenceArray;

public final class C0792xa7a47114 {
    public static boolean m316m(AtomicReferenceArray atomicReferenceArray, int i, Object obj, Object obj2) {
        while (!atomicReferenceArray.compareAndSet(i, obj, obj2)) {
            if (atomicReferenceArray.get(i) != obj) {
                return false;
            }
        }
        return true;
    }
}
