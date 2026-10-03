package androidx.compose.foundation.layout;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\r\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0087@\u0018\u0000 \u001a2\u00020\u0001:\u0001\u001aB\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u001a\u0010\u000b\u001a\u00020\u00072\u0006\u0010\f\u001a\u00020\u0000H\u0000ø\u0001\u0000¢\u0006\u0004\b\r\u0010\u000eJ\u0010\u0010\u000f\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u0010\u0010\u0005J\u001b\u0010\u0011\u001a\u00020\u00002\u0006\u0010\f\u001a\u00020\u0000H\u0086\u0002ø\u0001\u0000¢\u0006\u0004\b\u0012\u0010\u0013J\u000f\u0010\u0014\u001a\u00020\u0015H\u0016¢\u0006\u0004\b\u0016\u0010\u0017J\u000f\u0010\u0018\u001a\u00020\u0015H\u0002¢\u0006\u0004\b\u0019\u0010\u0017R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001b"}, d2 = {"Landroidx/compose/foundation/layout/WindowInsetsSides;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hasAny", "sides", "hasAny-bkgdKaI$foundation_layout_release", "(II)Z", "hashCode", "hashCode-impl", "plus", "plus-gK_yJZ4", "(II)I", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "valueToString", "valueToString-impl", "Companion", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class WindowInsetsSides {
    private static final int AllowLeftInLtr;
    private static final int AllowLeftInRtl;
    private static final int AllowRightInLtr;
    private static final int AllowRightInRtl;
    private static final int Bottom;

    public static final Companion INSTANCE = new Companion(null);
    private static final int End;
    private static final int Horizontal;
    private static final int Left;
    private static final int Right;
    private static final int Start;
    private static final int Top;
    private static final int Vertical;
    private final int value;

    public static final WindowInsetsSides m1111boximpl(int i) {
        return new WindowInsetsSides(i);
    }

    private static int m1112constructorimpl(int i) {
        return i;
    }

    public static boolean m1113equalsimpl(int i, Object obj) {
        return (obj instanceof WindowInsetsSides) && i == ((WindowInsetsSides) obj).getValue();
    }

    public static final boolean m1114equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static final boolean m1115hasAnybkgdKaI$foundation_layout_release(int i, int i2) {
        return (i & i2) != 0;
    }

    public static int m1116hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1113equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1116hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private WindowInsetsSides(int i) {
        this.value = i;
    }

    public static final int m1117plusgK_yJZ4(int i, int i2) {
        return m1112constructorimpl(i | i2);
    }

    public static String m1118toStringimpl(int i) {
        return "WindowInsetsSides(" + m1119valueToStringimpl(i) + ')';
    }

    public String toString() {
        return m1118toStringimpl(this.value);
    }

    private static final String m1119valueToStringimpl(int i) {
        StringBuilder sb = new StringBuilder();
        int i2 = Start;
        if ((i & i2) == i2) {
            valueToString_impl$lambda$0$appendPlus(sb, "Start");
        }
        int i3 = Left;
        if ((i & i3) == i3) {
            valueToString_impl$lambda$0$appendPlus(sb, "Left");
        }
        int i4 = Top;
        if ((i & i4) == i4) {
            valueToString_impl$lambda$0$appendPlus(sb, "Top");
        }
        int i5 = End;
        if ((i & i5) == i5) {
            valueToString_impl$lambda$0$appendPlus(sb, "End");
        }
        int i6 = Right;
        if ((i & i6) == i6) {
            valueToString_impl$lambda$0$appendPlus(sb, "Right");
        }
        int i7 = Bottom;
        if ((i & i7) == i7) {
            valueToString_impl$lambda$0$appendPlus(sb, "Bottom");
        }
        String string = sb.toString();
        Intrinsics.checkNotNullExpressionValue(string, "StringBuilder().apply(builderAction).toString()");
        return string;
    }

    private static final void valueToString_impl$lambda$0$appendPlus(StringBuilder sb, String str) {
        if (sb.length() > 0) {
            sb.append('+');
        }
        sb.append(str);
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u001a\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001c\u0010\u0003\u001a\u00020\u0004X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u001c\u0010\b\u001a\u00020\u0004X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u001c\u0010\n\u001a\u00020\u0004X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u001c\u0010\f\u001a\u00020\u0004X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006R\u0019\u0010\u0012\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0013\u0010\u0006R\u0019\u0010\u0014\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0015\u0010\u0006R\u0019\u0010\u0016\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0017\u0010\u0006R\u0019\u0010\u0018\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0019\u0010\u0006R\u0019\u0010\u001a\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u001b\u0010\u0006R\u0019\u0010\u001c\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u001d\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001e"}, d2 = {"Landroidx/compose/foundation/layout/WindowInsetsSides$Companion;", "", "()V", "AllowLeftInLtr", "Landroidx/compose/foundation/layout/WindowInsetsSides;", "getAllowLeftInLtr-JoeWqyM$foundation_layout_release", "()I", "I", "AllowLeftInRtl", "getAllowLeftInRtl-JoeWqyM$foundation_layout_release", "AllowRightInLtr", "getAllowRightInLtr-JoeWqyM$foundation_layout_release", "AllowRightInRtl", "getAllowRightInRtl-JoeWqyM$foundation_layout_release", "Bottom", "getBottom-JoeWqyM", "End", "getEnd-JoeWqyM", "Horizontal", "getHorizontal-JoeWqyM", "Left", "getLeft-JoeWqyM", "Right", "getRight-JoeWqyM", "Start", "getStart-JoeWqyM", "Top", "getTop-JoeWqyM", "Vertical", "getVertical-JoeWqyM", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m1121getAllowLeftInLtrJoeWqyM$foundation_layout_release() {
            return WindowInsetsSides.AllowLeftInLtr;
        }

        public final int m1123getAllowRightInLtrJoeWqyM$foundation_layout_release() {
            return WindowInsetsSides.AllowRightInLtr;
        }

        public final int m1122getAllowLeftInRtlJoeWqyM$foundation_layout_release() {
            return WindowInsetsSides.AllowLeftInRtl;
        }

        public final int m1124getAllowRightInRtlJoeWqyM$foundation_layout_release() {
            return WindowInsetsSides.AllowRightInRtl;
        }

        public final int m1130getStartJoeWqyM() {
            return WindowInsetsSides.Start;
        }

        public final int m1126getEndJoeWqyM() {
            return WindowInsetsSides.End;
        }

        public final int m1131getTopJoeWqyM() {
            return WindowInsetsSides.Top;
        }

        public final int m1125getBottomJoeWqyM() {
            return WindowInsetsSides.Bottom;
        }

        public final int m1128getLeftJoeWqyM() {
            return WindowInsetsSides.Left;
        }

        public final int m1129getRightJoeWqyM() {
            return WindowInsetsSides.Right;
        }

        public final int m1127getHorizontalJoeWqyM() {
            return WindowInsetsSides.Horizontal;
        }

        public final int m1132getVerticalJoeWqyM() {
            return WindowInsetsSides.Vertical;
        }
    }

    static {
        int iM1112constructorimpl = m1112constructorimpl(8);
        AllowLeftInLtr = iM1112constructorimpl;
        int iM1112constructorimpl2 = m1112constructorimpl(4);
        AllowRightInLtr = iM1112constructorimpl2;
        int iM1112constructorimpl3 = m1112constructorimpl(2);
        AllowLeftInRtl = iM1112constructorimpl3;
        int iM1112constructorimpl4 = m1112constructorimpl(1);
        AllowRightInRtl = iM1112constructorimpl4;
        Start = m1117plusgK_yJZ4(iM1112constructorimpl, iM1112constructorimpl4);
        End = m1117plusgK_yJZ4(iM1112constructorimpl2, iM1112constructorimpl3);
        int iM1112constructorimpl5 = m1112constructorimpl(16);
        Top = iM1112constructorimpl5;
        int iM1112constructorimpl6 = m1112constructorimpl(32);
        Bottom = iM1112constructorimpl6;
        int iM1117plusgK_yJZ4 = m1117plusgK_yJZ4(iM1112constructorimpl, iM1112constructorimpl3);
        Left = iM1117plusgK_yJZ4;
        int iM1117plusgK_yJZ5 = m1117plusgK_yJZ4(iM1112constructorimpl2, iM1112constructorimpl4);
        Right = iM1117plusgK_yJZ5;
        Horizontal = m1117plusgK_yJZ4(iM1117plusgK_yJZ4, iM1117plusgK_yJZ5);
        Vertical = m1117plusgK_yJZ4(iM1112constructorimpl5, iM1112constructorimpl6);
    }
}
