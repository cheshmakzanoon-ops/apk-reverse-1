package androidx.compose.p002ui.graphics;

import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0010\u0007\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \"2\u00020\u0001:\u0001\"B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u0010\u0010\u000e\u001a\u00020\tH\u0087\n¢\u0006\u0004\b\u000f\u0010\u000bJ\u0010\u0010\u0010\u001a\u00020\tH\u0087\n¢\u0006\u0004\b\u0011\u0010\u000bJ'\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\f\u001a\u00020\tø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0013\u0010\u0014J\u001a\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u0018\u0010\u0019J\u0010\u0010\u001a\u001a\u00020\u001bHÖ\u0001¢\u0006\u0004\b\u001c\u0010\u001dJ\u0010\u0010\u001e\u001a\u00020\u001fHÖ\u0001¢\u0006\u0004\b \u0010!R\u0016\u0010\u0002\u001a\u00020\u00038\u0000X\u0081\u0004¢\u0006\b\n\u0000\u0012\u0004\b\u0006\u0010\u0007R\u0011\u0010\b\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\f\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\r\u0010\u000b\u0088\u0001\u0002\u0092\u0001\u00020\u0003\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006#"}, d2 = {"Landroidx/compose/ui/graphics/TransformOrigin;", "", "packedValue", "", "constructor-impl", "(J)J", "getPackedValue$annotations", "()V", "pivotFractionX", "", "getPivotFractionX-impl", "(J)F", "pivotFractionY", "getPivotFractionY-impl", "component1", "component1-impl", "component2", "component2-impl", "copy", "copy-zey9I6w", "(JFF)J", "equals", "", "other", "equals-impl", "(JLjava/lang/Object;)Z", "hashCode", "", "hashCode-impl", "(J)I", "toString", "", "toString-impl", "(J)Ljava/lang/String;", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class TransformOrigin {
    private final long packedValue;

    public static final Companion INSTANCE = new Companion(null);
    private static final long Center = TransformOriginKt.TransformOrigin(0.5f, 0.5f);

    public static final TransformOrigin m4988boximpl(long j) {
        return new TransformOrigin(j);
    }

    public static long m4991constructorimpl(long j) {
        return j;
    }

    public static boolean m4994equalsimpl(long j, Object obj) {
        return (obj instanceof TransformOrigin) && j == ((TransformOrigin) obj).getPackedValue();
    }

    public static final boolean m4995equalsimpl0(long j, long j2) {
        return j == j2;
    }

    public static void getPackedValue$annotations() {
    }

    public static int m4998hashCodeimpl(long j) {
        return UByte$.ExternalSyntheticBackport0.m(j);
    }

    public static String m4999toStringimpl(long j) {
        return "TransformOrigin(packedValue=" + j + ')';
    }

    public boolean equals(Object obj) {
        return m4994equalsimpl(this.packedValue, obj);
    }

    public int hashCode() {
        return m4998hashCodeimpl(this.packedValue);
    }

    public String toString() {
        return m4999toStringimpl(this.packedValue);
    }

    public final long getPackedValue() {
        return this.packedValue;
    }

    private TransformOrigin(long j) {
        this.packedValue = j;
    }

    public static final float m4989component1impl(long j) {
        return m4996getPivotFractionXimpl(j);
    }

    public static final float m4990component2impl(long j) {
        return m4997getPivotFractionYimpl(j);
    }

    public static long m4993copyzey9I6w$default(long j, float f, float f2, int i, Object obj) {
        if ((i & 1) != 0) {
            f = m4996getPivotFractionXimpl(j);
        }
        if ((i & 2) != 0) {
            f2 = m4997getPivotFractionYimpl(j);
        }
        return m4992copyzey9I6w(j, f, f2);
    }

    public static final long m4992copyzey9I6w(long j, float f, float f2) {
        return TransformOriginKt.TransformOrigin(f, f2);
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\b"}, d2 = {"Landroidx/compose/ui/graphics/TransformOrigin$Companion;", "", "()V", "Center", "Landroidx/compose/ui/graphics/TransformOrigin;", "getCenter-SzJe1aQ", "()J", "J", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final long m5001getCenterSzJe1aQ() {
            return TransformOrigin.Center;
        }
    }

    public static final float m4996getPivotFractionXimpl(long j) {
        return Float.intBitsToFloat((int) (j >> 32));
    }

    public static final float m4997getPivotFractionYimpl(long j) {
        return Float.intBitsToFloat((int) (j & 4294967295L));
    }
}
