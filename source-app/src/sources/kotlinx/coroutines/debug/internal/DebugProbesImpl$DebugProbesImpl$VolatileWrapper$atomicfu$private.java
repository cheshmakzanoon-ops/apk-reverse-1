package kotlinx.coroutines.debug.internal;

import java.util.concurrent.atomic.AtomicIntegerFieldUpdater;
import java.util.concurrent.atomic.AtomicLongFieldUpdater;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
public class DebugProbesImpl$DebugProbesImpl$VolatileWrapper$atomicfu$private {
    private static final AtomicIntegerFieldUpdater installations$volatile$FU = AtomicIntegerFieldUpdater.newUpdater(DebugProbesImpl$DebugProbesImpl$VolatileWrapper$atomicfu$private.class, "installations$volatile");
    private static final AtomicLongFieldUpdater sequenceNumber$volatile$FU = AtomicLongFieldUpdater.newUpdater(DebugProbesImpl$DebugProbesImpl$VolatileWrapper$atomicfu$private.class, "sequenceNumber$volatile");
    private volatile int installations$volatile;
    private volatile long sequenceNumber$volatile;

    private DebugProbesImpl$DebugProbesImpl$VolatileWrapper$atomicfu$private() {
    }

    public DebugProbesImpl$DebugProbesImpl$VolatileWrapper$atomicfu$private(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private final int getInstallations$volatile() {
        return this.installations$volatile;
    }

    private final long getSequenceNumber$volatile() {
        return this.sequenceNumber$volatile;
    }

    private final void setInstallations$volatile(int i) {
        this.installations$volatile = i;
    }

    private final void setSequenceNumber$volatile(long j) {
        this.sequenceNumber$volatile = j;
    }
}
