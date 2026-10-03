package p000j$.util.concurrent;

import java.util.concurrent.atomic.AtomicReference;

public abstract class AbstractC0513x12cd702b {
    public static boolean m1726m(AtomicReference atomicReference, Object obj, Object obj2) {
        while (!atomicReference.compareAndSet(obj, obj2)) {
            if (atomicReference.get() != obj) {
                return false;
            }
        }
        return true;
    }
}
