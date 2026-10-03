package androidx.compose.p000ui.text.input;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/input/KeyboardType;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class KeyboardType {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Unspecified = m1506constructorimpl(0);
    private static final int Text = m1506constructorimpl(1);
    private static final int Ascii = m1506constructorimpl(2);
    private static final int Number = m1506constructorimpl(3);
    private static final int Phone = m1506constructorimpl(4);
    private static final int Uri = m1506constructorimpl(5);
    private static final int Email = m1506constructorimpl(6);
    private static final int Password = m1506constructorimpl(7);
    private static final int NumberPassword = m1506constructorimpl(8);
    private static final int Decimal = m1506constructorimpl(9);

    public static final KeyboardType m1505boximpl(int i) {
        return new KeyboardType(i);
    }

    private static int m1506constructorimpl(int i) {
        return i;
    }

    public static boolean m1507equalsimpl(int i, Object obj) {
        return (obj instanceof KeyboardType) && i == ((KeyboardType) obj).getValue();
    }

    public static final boolean m1508equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m1509hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1507equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1509hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private KeyboardType(int i) {
        this.value = i;
    }

    public String toString() {
        return m1510toStringimpl(this.value);
    }

    public static String m1510toStringimpl(int i) {
        if (m1508equalsimpl0(i, Unspecified)) {
            return "Unspecified";
        }
        if (m1508equalsimpl0(i, Text)) {
            return "Text";
        }
        if (m1508equalsimpl0(i, Ascii)) {
            return "Ascii";
        }
        if (m1508equalsimpl0(i, Number)) {
            return "Number";
        }
        if (m1508equalsimpl0(i, Phone)) {
            return "Phone";
        }
        if (m1508equalsimpl0(i, Uri)) {
            return "Uri";
        }
        if (m1508equalsimpl0(i, Email)) {
            return "Email";
        }
        if (m1508equalsimpl0(i, Password)) {
            return "Password";
        }
        if (m1508equalsimpl0(i, NumberPassword)) {
            return "NumberPassword";
        }
        return m1508equalsimpl0(i, Decimal) ? "Decimal" : "Invalid";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b \b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R$\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007R$\u0010\t\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\n\u0010\u0002\u001a\u0004\b\u000b\u0010\u0007R$\u0010\f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\r\u0010\u0002\u001a\u0004\b\u000e\u0010\u0007R$\u0010\u000f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0010\u0010\u0002\u001a\u0004\b\u0011\u0010\u0007R$\u0010\u0012\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0013\u0010\u0002\u001a\u0004\b\u0014\u0010\u0007R$\u0010\u0015\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0016\u0010\u0002\u001a\u0004\b\u0017\u0010\u0007R$\u0010\u0018\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0019\u0010\u0002\u001a\u0004\b\u001a\u0010\u0007R$\u0010\u001b\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u001c\u0010\u0002\u001a\u0004\b\u001d\u0010\u0007R$\u0010\u001e\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u001f\u0010\u0002\u001a\u0004\b \u0010\u0007R$\u0010!\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\"\u0010\u0002\u001a\u0004\b#\u0010\u0007\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006$"}, d2 = {"Landroidx/compose/ui/text/input/KeyboardType$Companion;", "", "()V", "Ascii", "Landroidx/compose/ui/text/input/KeyboardType;", "getAscii-PjHm6EE$annotations", "getAscii-PjHm6EE", "()I", "I", "Decimal", "getDecimal-PjHm6EE$annotations", "getDecimal-PjHm6EE", "Email", "getEmail-PjHm6EE$annotations", "getEmail-PjHm6EE", "Number", "getNumber-PjHm6EE$annotations", "getNumber-PjHm6EE", "NumberPassword", "getNumberPassword-PjHm6EE$annotations", "getNumberPassword-PjHm6EE", "Password", "getPassword-PjHm6EE$annotations", "getPassword-PjHm6EE", "Phone", "getPhone-PjHm6EE$annotations", "getPhone-PjHm6EE", "Text", "getText-PjHm6EE$annotations", "getText-PjHm6EE", "Unspecified", "getUnspecified-PjHm6EE$annotations", "getUnspecified-PjHm6EE", "Uri", "getUri-PjHm6EE$annotations", "getUri-PjHm6EE", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void m1512getAsciiPjHm6EE$annotations() {
        }

        public static void m1513getDecimalPjHm6EE$annotations() {
        }

        public static void m1514getEmailPjHm6EE$annotations() {
        }

        public static void m1515getNumberPjHm6EE$annotations() {
        }

        public static void m1516getNumberPasswordPjHm6EE$annotations() {
        }

        public static void m1517getPasswordPjHm6EE$annotations() {
        }

        public static void m1518getPhonePjHm6EE$annotations() {
        }

        public static void m1519getTextPjHm6EE$annotations() {
        }

        public static void m1520getUnspecifiedPjHm6EE$annotations() {
        }

        public static void m1521getUriPjHm6EE$annotations() {
        }

        private Companion() {
        }

        public final int m1530getUnspecifiedPjHm6EE() {
            return KeyboardType.Unspecified;
        }

        public final int m1529getTextPjHm6EE() {
            return KeyboardType.Text;
        }

        public final int m1522getAsciiPjHm6EE() {
            return KeyboardType.Ascii;
        }

        public final int m1525getNumberPjHm6EE() {
            return KeyboardType.Number;
        }

        public final int m1528getPhonePjHm6EE() {
            return KeyboardType.Phone;
        }

        public final int m1531getUriPjHm6EE() {
            return KeyboardType.Uri;
        }

        public final int m1524getEmailPjHm6EE() {
            return KeyboardType.Email;
        }

        public final int m1527getPasswordPjHm6EE() {
            return KeyboardType.Password;
        }

        public final int m1526getNumberPasswordPjHm6EE() {
            return KeyboardType.NumberPassword;
        }

        public final int m1523getDecimalPjHm6EE() {
            return KeyboardType.Decimal;
        }
    }
}
