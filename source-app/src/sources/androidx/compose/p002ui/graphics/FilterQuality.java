package androidx.compose.p002ui.graphics;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\b\u001a\u00020\t2\b\u0010\n\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u000b\u0010\fJ\u0010\u0010\r\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u000e\u0010\u0005J\u000f\u0010\u000f\u001a\u00020\u0010H\u0016¢\u0006\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007\u0088\u0001\u0002¨\u0006\u0014"}, d2 = {"Landroidx/compose/ui/graphics/FilterQuality;", "", "value", "", "constructor-impl", "(I)I", "getValue", "()I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class FilterQuality {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int None = m4683constructorimpl(0);
    private static final int Low = m4683constructorimpl(1);
    private static final int Medium = m4683constructorimpl(2);
    private static final int High = m4683constructorimpl(3);

    public static final FilterQuality m4682boximpl(int i) {
        return new FilterQuality(i);
    }

    public static int m4683constructorimpl(int i) {
        return i;
    }

    public static boolean m4684equalsimpl(int i, Object obj) {
        return (obj instanceof FilterQuality) && i == ((FilterQuality) obj).m4688unboximpl();
    }

    public static final boolean m4685equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m4686hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m4684equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m4686hashCodeimpl(this.value);
    }

    public final int m4688unboximpl() {
        return this.value;
    }

    private FilterQuality(int i) {
        this.value = i;
    }

    public final int getValue() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u000e"}, d2 = {"Landroidx/compose/ui/graphics/FilterQuality$Companion;", "", "()V", "High", "Landroidx/compose/ui/graphics/FilterQuality;", "getHigh-f-v9h1I", "()I", "I", "Low", "getLow-f-v9h1I", "Medium", "getMedium-f-v9h1I", "None", "getNone-f-v9h1I", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m4692getNonefv9h1I() {
            return FilterQuality.None;
        }

        public final int m4690getLowfv9h1I() {
            return FilterQuality.Low;
        }

        public final int m4691getMediumfv9h1I() {
            return FilterQuality.Medium;
        }

        public final int m4689getHighfv9h1I() {
            return FilterQuality.High;
        }
    }

    public String toString() {
        return m4687toStringimpl(this.value);
    }

    public static String m4687toStringimpl(int i) {
        if (m4685equalsimpl0(i, None)) {
            return "None";
        }
        if (m4685equalsimpl0(i, Low)) {
            return "Low";
        }
        if (m4685equalsimpl0(i, Medium)) {
            return "Medium";
        }
        return m4685equalsimpl0(i, High) ? "High" : "Unknown";
    }
}
