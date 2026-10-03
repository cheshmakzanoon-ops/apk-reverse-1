package androidx.compose.p002ui.input.pointer;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/input/pointer/PointerEventType;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class PointerEventType {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Unknown = m5793constructorimpl(0);
    private static final int Press = m5793constructorimpl(1);
    private static final int Release = m5793constructorimpl(2);
    private static final int Move = m5793constructorimpl(3);
    private static final int Enter = m5793constructorimpl(4);
    private static final int Exit = m5793constructorimpl(5);
    private static final int Scroll = m5793constructorimpl(6);

    public static final PointerEventType m5792boximpl(int i) {
        return new PointerEventType(i);
    }

    private static int m5793constructorimpl(int i) {
        return i;
    }

    public static boolean m5794equalsimpl(int i, Object obj) {
        return (obj instanceof PointerEventType) && i == ((PointerEventType) obj).getValue();
    }

    public static final boolean m5795equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m5796hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m5794equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m5796hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006R\u0019\u0010\u0012\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0013\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0014"}, d2 = {"Landroidx/compose/ui/input/pointer/PointerEventType$Companion;", "", "()V", "Enter", "Landroidx/compose/ui/input/pointer/PointerEventType;", "getEnter-7fucELk", "()I", "I", "Exit", "getExit-7fucELk", "Move", "getMove-7fucELk", "Press", "getPress-7fucELk", "Release", "getRelease-7fucELk", "Scroll", "getScroll-7fucELk", "Unknown", "getUnknown-7fucELk", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m5805getUnknown7fucELk() {
            return PointerEventType.Unknown;
        }

        public final int m5802getPress7fucELk() {
            return PointerEventType.Press;
        }

        public final int m5803getRelease7fucELk() {
            return PointerEventType.Release;
        }

        public final int m5801getMove7fucELk() {
            return PointerEventType.Move;
        }

        public final int m5799getEnter7fucELk() {
            return PointerEventType.Enter;
        }

        public final int m5800getExit7fucELk() {
            return PointerEventType.Exit;
        }

        public final int m5804getScroll7fucELk() {
            return PointerEventType.Scroll;
        }
    }

    private PointerEventType(int i) {
        this.value = i;
    }

    public String toString() {
        return m5797toStringimpl(this.value);
    }

    public static String m5797toStringimpl(int i) {
        if (m5795equalsimpl0(i, Press)) {
            return "Press";
        }
        if (m5795equalsimpl0(i, Release)) {
            return "Release";
        }
        if (m5795equalsimpl0(i, Move)) {
            return "Move";
        }
        if (m5795equalsimpl0(i, Enter)) {
            return "Enter";
        }
        if (m5795equalsimpl0(i, Exit)) {
            return "Exit";
        }
        return m5795equalsimpl0(i, Scroll) ? "Scroll" : "Unknown";
    }
}
