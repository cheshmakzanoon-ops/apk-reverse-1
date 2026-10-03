package androidx.compose.p002ui.node;

import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.JvmInline;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\n\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0083@\u0018\u00002\u00020\u0001B\u000f\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001b\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0000H\u0086\u0002ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014J\u001a\u0010\u0015\u001a\u00020\u000b2\b\u0010\u0012\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u0016\u0010\u0017J\u0010\u0010\u0018\u001a\u00020\u0011HÖ\u0001¢\u0006\u0004\b\u0019\u0010\u001aJ\u0010\u0010\u001b\u001a\u00020\u001cHÖ\u0001¢\u0006\u0004\b\u001d\u0010\u001eR\u0011\u0010\u0006\u001a\u00020\u00078F¢\u0006\u0006\u001a\u0004\b\b\u0010\tR\u0011\u0010\n\u001a\u00020\u000b8F¢\u0006\u0006\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f\u0088\u0001\u0002\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001f"}, d2 = {"Landroidx/compose/ui/node/DistanceAndInLayer;", "", "packedValue", "", "constructor-impl", "(J)J", "distance", "", "getDistance-impl", "(J)F", "isInLayer", "", "isInLayer-impl", "(J)Z", "getPackedValue", "()J", "compareTo", "", "other", "compareTo-S_HNhKs", "(JJ)I", "equals", "equals-impl", "(JLjava/lang/Object;)Z", "hashCode", "hashCode-impl", "(J)I", "toString", "", "toString-impl", "(J)Ljava/lang/String;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
final class DistanceAndInLayer {
    private final long packedValue;

    public static final DistanceAndInLayer m6212boximpl(long j) {
        return new DistanceAndInLayer(j);
    }

    public static long m6214constructorimpl(long j) {
        return j;
    }

    public static boolean m6215equalsimpl(long j, Object obj) {
        return (obj instanceof DistanceAndInLayer) && j == ((DistanceAndInLayer) obj).m6221unboximpl();
    }

    public static final boolean m6216equalsimpl0(long j, long j2) {
        return j == j2;
    }

    public static int m6218hashCodeimpl(long j) {
        return UByte$.ExternalSyntheticBackport0.m(j);
    }

    public static final boolean m6219isInLayerimpl(long j) {
        return ((int) (j & 4294967295L)) != 0;
    }

    public static String m6220toStringimpl(long j) {
        return "DistanceAndInLayer(packedValue=" + j + ')';
    }

    public boolean equals(Object obj) {
        return m6215equalsimpl(this.packedValue, obj);
    }

    public int hashCode() {
        return m6218hashCodeimpl(this.packedValue);
    }

    public String toString() {
        return m6220toStringimpl(this.packedValue);
    }

    public final long m6221unboximpl() {
        return this.packedValue;
    }

    private DistanceAndInLayer(long j) {
        this.packedValue = j;
    }

    public final long getPackedValue() {
        return this.packedValue;
    }

    public static final int m6213compareToS_HNhKs(long j, long j2) {
        boolean zM6219isInLayerimpl = m6219isInLayerimpl(j);
        if (zM6219isInLayerimpl != m6219isInLayerimpl(j2)) {
            return zM6219isInLayerimpl ? -1 : 1;
        }
        return (int) Math.signum(m6217getDistanceimpl(j) - m6217getDistanceimpl(j2));
    }

    public static final float m6217getDistanceimpl(long j) {
        return Float.intBitsToFloat((int) (j >> 32));
    }
}
