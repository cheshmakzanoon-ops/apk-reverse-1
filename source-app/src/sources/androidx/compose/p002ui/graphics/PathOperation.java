package androidx.compose.p002ui.graphics;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/graphics/PathOperation;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class PathOperation {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Difference = m4884constructorimpl(0);
    private static final int Intersect = m4884constructorimpl(1);
    private static final int Union = m4884constructorimpl(2);
    private static final int Xor = m4884constructorimpl(3);
    private static final int ReverseDifference = m4884constructorimpl(4);

    public static final PathOperation m4883boximpl(int i) {
        return new PathOperation(i);
    }

    public static int m4884constructorimpl(int i) {
        return i;
    }

    public static boolean m4885equalsimpl(int i, Object obj) {
        return (obj instanceof PathOperation) && i == ((PathOperation) obj).getValue();
    }

    public static final boolean m4886equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m4887hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m4885equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m4887hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0010"}, d2 = {"Landroidx/compose/ui/graphics/PathOperation$Companion;", "", "()V", "Difference", "Landroidx/compose/ui/graphics/PathOperation;", "getDifference-b3I0S0c", "()I", "I", "Intersect", "getIntersect-b3I0S0c", "ReverseDifference", "getReverseDifference-b3I0S0c", "Union", "getUnion-b3I0S0c", "Xor", "getXor-b3I0S0c", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m4890getDifferenceb3I0S0c() {
            return PathOperation.Difference;
        }

        public final int m4891getIntersectb3I0S0c() {
            return PathOperation.Intersect;
        }

        public final int m4893getUnionb3I0S0c() {
            return PathOperation.Union;
        }

        public final int m4894getXorb3I0S0c() {
            return PathOperation.Xor;
        }

        public final int m4892getReverseDifferenceb3I0S0c() {
            return PathOperation.ReverseDifference;
        }
    }

    private PathOperation(int i) {
        this.value = i;
    }

    public String toString() {
        return m4888toStringimpl(this.value);
    }

    public static String m4888toStringimpl(int i) {
        if (m4886equalsimpl0(i, Difference)) {
            return "Difference";
        }
        if (m4886equalsimpl0(i, Intersect)) {
            return "Intersect";
        }
        if (m4886equalsimpl0(i, Union)) {
            return "Union";
        }
        if (m4886equalsimpl0(i, Xor)) {
            return "Xor";
        }
        return m4886equalsimpl0(i, ReverseDifference) ? "ReverseDifference" : "Unknown";
    }
}
