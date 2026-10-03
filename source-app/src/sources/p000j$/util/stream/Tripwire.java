package p000j$.util.stream;

import java.security.AccessController;
import java.security.PrivilegedAction;

abstract class Tripwire {
    static final boolean ENABLED = ((Boolean) AccessController.doPrivileged(new PrivilegedAction() {
        @Override
        public final Object run() {
            return Boolean.valueOf(Boolean.getBoolean("org.openjdk.java.util.stream.tripwire"));
        }
    })).booleanValue();

    static void trip(Class cls, String str) {
        throw new UnsupportedOperationException(cls + " tripwire tripped but logging not supported: " + str);
    }
}
