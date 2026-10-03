package androidx.compose.material3;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\b\u001a\u00020\t2\b\u0010\n\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u000b\u0010\fJ\u0010\u0010\r\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u000e\u0010\u0005J\u000f\u0010\u000f\u001a\u00020\u0010H\u0016¢\u0006\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007\u0088\u0001\u0002¨\u0006\u0014"}, d2 = {"Landroidx/compose/material3/TimePickerSelectionMode;", "", "value", "", "constructor-impl", "(I)I", "getValue", "()I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class TimePickerSelectionMode {

    public static final Companion INSTANCE = new Companion(null);
    private static final int Hour = m3081constructorimpl(0);
    private static final int Minute = m3081constructorimpl(1);
    private final int value;

    public static final TimePickerSelectionMode m3080boximpl(int i) {
        return new TimePickerSelectionMode(i);
    }

    private static int m3081constructorimpl(int i) {
        return i;
    }

    public static boolean m3082equalsimpl(int i, Object obj) {
        return (obj instanceof TimePickerSelectionMode) && i == ((TimePickerSelectionMode) obj).m3086unboximpl();
    }

    public static final boolean m3083equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m3084hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m3082equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m3084hashCodeimpl(this.value);
    }

    public final int m3086unboximpl() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\n"}, d2 = {"Landroidx/compose/material3/TimePickerSelectionMode$Companion;", "", "()V", "Hour", "Landroidx/compose/material3/TimePickerSelectionMode;", "getHour-yecRtBI", "()I", "I", "Minute", "getMinute-yecRtBI", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m3087getHouryecRtBI() {
            return TimePickerSelectionMode.Hour;
        }

        public final int m3088getMinuteyecRtBI() {
            return TimePickerSelectionMode.Minute;
        }
    }

    private TimePickerSelectionMode(int i) {
        this.value = i;
    }

    public final int getValue() {
        return this.value;
    }

    public String toString() {
        return m3085toStringimpl(this.value);
    }

    public static String m3085toStringimpl(int i) {
        if (m3083equalsimpl0(i, Hour)) {
            return "Hour";
        }
        return m3083equalsimpl0(i, Minute) ? "Minute" : "";
    }
}
