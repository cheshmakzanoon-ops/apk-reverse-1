package androidx.compose.p000ui.text.style;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/style/TextDirection;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class TextDirection {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Ltr = m1707constructorimpl(1);
    private static final int Rtl = m1707constructorimpl(2);
    private static final int Content = m1707constructorimpl(3);
    private static final int ContentOrLtr = m1707constructorimpl(4);
    private static final int ContentOrRtl = m1707constructorimpl(5);
    private static final int Unspecified = m1707constructorimpl(Integer.MIN_VALUE);

    public static final TextDirection m1706boximpl(int i) {
        return new TextDirection(i);
    }

    public static int m1707constructorimpl(int i) {
        return i;
    }

    public static boolean m1708equalsimpl(int i, Object obj) {
        return (obj instanceof TextDirection) && i == ((TextDirection) obj).getValue();
    }

    public static final boolean m1709equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m1710hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1708equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1710hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private TextDirection(int i) {
        this.value = i;
    }

    public String toString() {
        return m1711toStringimpl(this.value);
    }

    public static String m1711toStringimpl(int i) {
        if (m1709equalsimpl0(i, Ltr)) {
            return "Ltr";
        }
        if (m1709equalsimpl0(i, Rtl)) {
            return "Rtl";
        }
        if (m1709equalsimpl0(i, Content)) {
            return "Content";
        }
        if (m1709equalsimpl0(i, ContentOrLtr)) {
            return "ContentOrLtr";
        }
        if (m1709equalsimpl0(i, ContentOrRtl)) {
            return "ContentOrRtl";
        }
        return m1709equalsimpl0(i, Unspecified) ? "Unspecified" : "Invalid";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000e\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/style/TextDirection$Companion;", "", "()V", "Content", "Landroidx/compose/ui/text/style/TextDirection;", "getContent-s_7X-co", "()I", "I", "ContentOrLtr", "getContentOrLtr-s_7X-co", "ContentOrRtl", "getContentOrRtl-s_7X-co", "Ltr", "getLtr-s_7X-co", "Rtl", "getRtl-s_7X-co", "Unspecified", "getUnspecified-s_7X-co", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m1716getLtrs_7Xco() {
            return TextDirection.Ltr;
        }

        public final int m1717getRtls_7Xco() {
            return TextDirection.Rtl;
        }

        public final int m1713getContents_7Xco() {
            return TextDirection.Content;
        }

        public final int m1714getContentOrLtrs_7Xco() {
            return TextDirection.ContentOrLtr;
        }

        public final int m1715getContentOrRtls_7Xco() {
            return TextDirection.ContentOrRtl;
        }

        public final int m1718getUnspecifieds_7Xco() {
            return TextDirection.Unspecified;
        }
    }
}
