package androidx.compose.p002ui.input.key;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/input/key/KeyEventType;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class KeyEventType {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Unknown = m5688constructorimpl(0);
    private static final int KeyUp = m5688constructorimpl(1);
    private static final int KeyDown = m5688constructorimpl(2);

    public static final KeyEventType m5687boximpl(int i) {
        return new KeyEventType(i);
    }

    public static int m5688constructorimpl(int i) {
        return i;
    }

    public static boolean m5689equalsimpl(int i, Object obj) {
        return (obj instanceof KeyEventType) && i == ((KeyEventType) obj).getValue();
    }

    public static final boolean m5690equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m5691hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m5689equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m5691hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private KeyEventType(int i) {
        this.value = i;
    }

    public String toString() {
        return m5692toStringimpl(this.value);
    }

    public static String m5692toStringimpl(int i) {
        if (m5690equalsimpl0(i, KeyUp)) {
            return "KeyUp";
        }
        if (m5690equalsimpl0(i, KeyDown)) {
            return "KeyDown";
        }
        return m5690equalsimpl0(i, Unknown) ? "Unknown" : "Invalid";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\f"}, d2 = {"Landroidx/compose/ui/input/key/KeyEventType$Companion;", "", "()V", "KeyDown", "Landroidx/compose/ui/input/key/KeyEventType;", "getKeyDown-CS__XNY", "()I", "I", "KeyUp", "getKeyUp-CS__XNY", "Unknown", "getUnknown-CS__XNY", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m5696getUnknownCS__XNY() {
            return KeyEventType.Unknown;
        }

        public final int m5695getKeyUpCS__XNY() {
            return KeyEventType.KeyUp;
        }

        public final int m5694getKeyDownCS__XNY() {
            return KeyEventType.KeyDown;
        }
    }
}
