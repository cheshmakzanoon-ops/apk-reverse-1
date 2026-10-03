package androidx.compose.animation.core;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u0010\u0010\r\u001a\u00020\u000eHÖ\u0001¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/animation/core/StartOffsetType;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class StartOffsetType {

    public static final Companion INSTANCE = new Companion(null);
    private static final int Delay = m461constructorimpl(-1);
    private static final int FastForward = m461constructorimpl(1);
    private final int value;

    public static final StartOffsetType m460boximpl(int i) {
        return new StartOffsetType(i);
    }

    private static int m461constructorimpl(int i) {
        return i;
    }

    public static boolean m462equalsimpl(int i, Object obj) {
        return (obj instanceof StartOffsetType) && i == ((StartOffsetType) obj).getValue();
    }

    public static final boolean m463equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m464hashCodeimpl(int i) {
        return i;
    }

    public static String m465toStringimpl(int i) {
        return "StartOffsetType(value=" + i + ')';
    }

    public boolean equals(Object obj) {
        return m462equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m464hashCodeimpl(this.value);
    }

    public String toString() {
        return m465toStringimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\n"}, d2 = {"Landroidx/compose/animation/core/StartOffsetType$Companion;", "", "()V", "Delay", "Landroidx/compose/animation/core/StartOffsetType;", "getDelay-Eo1U57Q", "()I", "I", "FastForward", "getFastForward-Eo1U57Q", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m467getDelayEo1U57Q() {
            return StartOffsetType.Delay;
        }

        public final int m468getFastForwardEo1U57Q() {
            return StartOffsetType.FastForward;
        }
    }

    private StartOffsetType(int i) {
        this.value = i;
    }
}
