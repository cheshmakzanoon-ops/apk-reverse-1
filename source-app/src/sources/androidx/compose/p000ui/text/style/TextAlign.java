package androidx.compose.p000ui.text.style;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/style/TextAlign;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class TextAlign {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Left = m1693constructorimpl(1);
    private static final int Right = m1693constructorimpl(2);
    private static final int Center = m1693constructorimpl(3);
    private static final int Justify = m1693constructorimpl(4);
    private static final int Start = m1693constructorimpl(5);
    private static final int End = m1693constructorimpl(6);
    private static final int Unspecified = m1693constructorimpl(Integer.MIN_VALUE);

    public static final TextAlign m1692boximpl(int i) {
        return new TextAlign(i);
    }

    public static int m1693constructorimpl(int i) {
        return i;
    }

    public static boolean m1694equalsimpl(int i, Object obj) {
        return (obj instanceof TextAlign) && i == ((TextAlign) obj).getValue();
    }

    public static final boolean m1695equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m1696hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1694equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1696hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private TextAlign(int i) {
        this.value = i;
    }

    public String toString() {
        return m1697toStringimpl(this.value);
    }

    public static String m1697toStringimpl(int i) {
        if (m1695equalsimpl0(i, Left)) {
            return "Left";
        }
        if (m1695equalsimpl0(i, Right)) {
            return "Right";
        }
        if (m1695equalsimpl0(i, Center)) {
            return "Center";
        }
        if (m1695equalsimpl0(i, Justify)) {
            return "Justify";
        }
        if (m1695equalsimpl0(i, Start)) {
            return "Start";
        }
        if (m1695equalsimpl0(i, End)) {
            return "End";
        }
        return m1695equalsimpl0(i, Unspecified) ? "Unspecified" : "Invalid";
    }

    @Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010 \n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\f\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u00040\u0015R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006R\u0019\u0010\u0012\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0013\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0016"}, d2 = {"Landroidx/compose/ui/text/style/TextAlign$Companion;", "", "()V", "Center", "Landroidx/compose/ui/text/style/TextAlign;", "getCenter-e0LSkKk", "()I", "I", "End", "getEnd-e0LSkKk", "Justify", "getJustify-e0LSkKk", "Left", "getLeft-e0LSkKk", "Right", "getRight-e0LSkKk", "Start", "getStart-e0LSkKk", "Unspecified", "getUnspecified-e0LSkKk", "values", "", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m1702getLefte0LSkKk() {
            return TextAlign.Left;
        }

        public final int m1703getRighte0LSkKk() {
            return TextAlign.Right;
        }

        public final int m1699getCentere0LSkKk() {
            return TextAlign.Center;
        }

        public final int m1701getJustifye0LSkKk() {
            return TextAlign.Justify;
        }

        public final int m1704getStarte0LSkKk() {
            return TextAlign.Start;
        }

        public final int m1700getEnde0LSkKk() {
            return TextAlign.End;
        }

        public final List<TextAlign> values() {
            return CollectionsKt.listOf(new TextAlign[]{TextAlign.m1692boximpl(m1702getLefte0LSkKk()), TextAlign.m1692boximpl(m1703getRighte0LSkKk()), TextAlign.m1692boximpl(m1699getCentere0LSkKk()), TextAlign.m1692boximpl(m1701getJustifye0LSkKk()), TextAlign.m1692boximpl(m1704getStarte0LSkKk()), TextAlign.m1692boximpl(m1700getEnde0LSkKk())});
        }

        public final int m1705getUnspecifiede0LSkKk() {
            return TextAlign.Unspecified;
        }
    }
}
