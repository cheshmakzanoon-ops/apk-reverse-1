package androidx.compose.p000ui.text;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/PlaceholderVerticalAlign;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class PlaceholderVerticalAlign {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int AboveBaseline = m1184constructorimpl(1);
    private static final int Top = m1184constructorimpl(2);
    private static final int Bottom = m1184constructorimpl(3);
    private static final int Center = m1184constructorimpl(4);
    private static final int TextTop = m1184constructorimpl(5);
    private static final int TextBottom = m1184constructorimpl(6);
    private static final int TextCenter = m1184constructorimpl(7);

    public static final PlaceholderVerticalAlign m1183boximpl(int i) {
        return new PlaceholderVerticalAlign(i);
    }

    public static int m1184constructorimpl(int i) {
        return i;
    }

    public static boolean m1185equalsimpl(int i, Object obj) {
        return (obj instanceof PlaceholderVerticalAlign) && i == ((PlaceholderVerticalAlign) obj).getValue();
    }

    public static final boolean m1186equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m1187hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1185equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1187hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private PlaceholderVerticalAlign(int i) {
        this.value = i;
    }

    public String toString() {
        return m1188toStringimpl(this.value);
    }

    public static String m1188toStringimpl(int i) {
        if (m1186equalsimpl0(i, AboveBaseline)) {
            return "AboveBaseline";
        }
        if (m1186equalsimpl0(i, Top)) {
            return "Top";
        }
        if (m1186equalsimpl0(i, Bottom)) {
            return "Bottom";
        }
        if (m1186equalsimpl0(i, Center)) {
            return "Center";
        }
        if (m1186equalsimpl0(i, TextTop)) {
            return "TextTop";
        }
        if (m1186equalsimpl0(i, TextBottom)) {
            return "TextBottom";
        }
        return m1186equalsimpl0(i, TextCenter) ? "TextCenter" : "Invalid";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006R\u0019\u0010\u0012\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0013\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0014"}, d2 = {"Landroidx/compose/ui/text/PlaceholderVerticalAlign$Companion;", "", "()V", "AboveBaseline", "Landroidx/compose/ui/text/PlaceholderVerticalAlign;", "getAboveBaseline-J6kI3mc", "()I", "I", "Bottom", "getBottom-J6kI3mc", "Center", "getCenter-J6kI3mc", "TextBottom", "getTextBottom-J6kI3mc", "TextCenter", "getTextCenter-J6kI3mc", "TextTop", "getTextTop-J6kI3mc", "Top", "getTop-J6kI3mc", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m1190getAboveBaselineJ6kI3mc() {
            return PlaceholderVerticalAlign.AboveBaseline;
        }

        public final int m1196getTopJ6kI3mc() {
            return PlaceholderVerticalAlign.Top;
        }

        public final int m1191getBottomJ6kI3mc() {
            return PlaceholderVerticalAlign.Bottom;
        }

        public final int m1192getCenterJ6kI3mc() {
            return PlaceholderVerticalAlign.Center;
        }

        public final int m1195getTextTopJ6kI3mc() {
            return PlaceholderVerticalAlign.TextTop;
        }

        public final int m1193getTextBottomJ6kI3mc() {
            return PlaceholderVerticalAlign.TextBottom;
        }

        public final int m1194getTextCenterJ6kI3mc() {
            return PlaceholderVerticalAlign.TextCenter;
        }
    }
}
