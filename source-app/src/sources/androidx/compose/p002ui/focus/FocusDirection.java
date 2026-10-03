package androidx.compose.p002ui.focus;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/focus/FocusDirection;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class FocusDirection {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Next = m4249constructorimpl(1);
    private static final int Previous = m4249constructorimpl(2);
    private static final int Left = m4249constructorimpl(3);
    private static final int Right = m4249constructorimpl(4);

    private static final int f62Up = m4249constructorimpl(5);
    private static final int Down = m4249constructorimpl(6);
    private static final int Enter = m4249constructorimpl(7);
    private static final int Exit = m4249constructorimpl(8);

    public static final FocusDirection m4248boximpl(int i) {
        return new FocusDirection(i);
    }

    public static int m4249constructorimpl(int i) {
        return i;
    }

    public static boolean m4250equalsimpl(int i, Object obj) {
        return (obj instanceof FocusDirection) && i == ((FocusDirection) obj).getValue();
    }

    public static final boolean m4251equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m4252hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m4250equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m4252hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private FocusDirection(int i) {
        this.value = i;
    }

    public String toString() {
        return m4253toStringimpl(this.value);
    }

    public static String m4253toStringimpl(int i) {
        if (m4251equalsimpl0(i, Next)) {
            return "Next";
        }
        if (m4251equalsimpl0(i, Previous)) {
            return "Previous";
        }
        if (m4251equalsimpl0(i, Left)) {
            return "Left";
        }
        if (m4251equalsimpl0(i, Right)) {
            return "Right";
        }
        if (m4251equalsimpl0(i, f62Up)) {
            return "Up";
        }
        if (m4251equalsimpl0(i, Down)) {
            return "Down";
        }
        if (m4251equalsimpl0(i, Enter)) {
            return "Enter";
        }
        if (m4251equalsimpl0(i, Exit)) {
            return "Exit";
        }
        return "Invalid FocusDirection";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0014\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R$\u0010\b\u001a\u00020\u00048GX\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0007\u0012\u0004\b\t\u0010\u0002\u001a\u0004\b\n\u0010\u0006R$\u0010\u000b\u001a\u00020\u00048GX\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0007\u0012\u0004\b\f\u0010\u0002\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006R\u0019\u0010\u0012\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0013\u0010\u0006R\u0019\u0010\u0014\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0015\u0010\u0006R\u0019\u0010\u0016\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0017\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0018"}, d2 = {"Landroidx/compose/ui/focus/FocusDirection$Companion;", "", "()V", "Down", "Landroidx/compose/ui/focus/FocusDirection;", "getDown-dhqQ-8s", "()I", "I", "Enter", "getEnter-dhqQ-8s$annotations", "getEnter-dhqQ-8s", "Exit", "getExit-dhqQ-8s$annotations", "getExit-dhqQ-8s", "Left", "getLeft-dhqQ-8s", "Next", "getNext-dhqQ-8s", "Previous", "getPrevious-dhqQ-8s", "Right", "getRight-dhqQ-8s", "Up", "getUp-dhqQ-8s", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void m4255getEnterdhqQ8s$annotations() {
        }

        public static void m4256getExitdhqQ8s$annotations() {
        }

        private Companion() {
        }

        public final int m4261getNextdhqQ8s() {
            return FocusDirection.Next;
        }

        public final int m4262getPreviousdhqQ8s() {
            return FocusDirection.Previous;
        }

        public final int m4260getLeftdhqQ8s() {
            return FocusDirection.Left;
        }

        public final int m4263getRightdhqQ8s() {
            return FocusDirection.Right;
        }

        public final int m4264getUpdhqQ8s() {
            return FocusDirection.f62Up;
        }

        public final int m4257getDowndhqQ8s() {
            return FocusDirection.Down;
        }

        public final int m4258getEnterdhqQ8s() {
            return FocusDirection.Enter;
        }

        public final int m4259getExitdhqQ8s() {
            return FocusDirection.Exit;
        }
    }
}
