package androidx.compose.p000ui.text.style;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.webkit.Profile;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0007\b\u0087@\u0018\u0000 \u001e2\u00020\u0001:\u0004\u001e\u001f !B!\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0004\b\b\u0010\tB\u0011\b\u0002\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0004\b\b\u0010\fJ.\u0010\u0010\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0007ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u001a\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u0016\u0010\u0017J\u0010\u0010\u0018\u001a\u00020\u000bHÖ\u0001¢\u0006\u0004\b\u0019\u0010\fJ\u000f\u0010\u001a\u001a\u00020\u001bH\u0016¢\u0006\u0004\b\u001c\u0010\u001dR\u000e\u0010\n\u001a\u00020\u000bX\u0080\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\u0002\u001a\u00020\u00038Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\r\u0010\fR\u0017\u0010\u0004\u001a\u00020\u00058Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u000e\u0010\fR\u0017\u0010\u0006\u001a\u00020\u00078Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u000f\u0010\f\u0088\u0001\n\u0092\u0001\u00020\u000b\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\""}, d2 = {"Landroidx/compose/ui/text/style/LineBreak;", "", "strategy", "Landroidx/compose/ui/text/style/LineBreak$Strategy;", "strictness", "Landroidx/compose/ui/text/style/LineBreak$Strictness;", "wordBreak", "Landroidx/compose/ui/text/style/LineBreak$WordBreak;", "constructor-impl", "(III)I", "mask", "", "(I)I", "getStrategy-fcGXIks", "getStrictness-usljTpc", "getWordBreak-jp8hJ3c", "copy", "copy-gijOMQM", "(IIII)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "Strategy", "Strictness", "WordBreak", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class LineBreak {
    private final int mask;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Simple = m1613constructorimpl(LineBreak_androidKt.packBytes(Strategy.INSTANCE.m1642getSimplefcGXIks(), Strictness.INSTANCE.m1653getNormalusljTpc(), WordBreak.INSTANCE.m1663getDefaultjp8hJ3c()));
    private static final int Heading = m1613constructorimpl(LineBreak_androidKt.packBytes(Strategy.INSTANCE.m1640getBalancedfcGXIks(), Strictness.INSTANCE.m1652getLooseusljTpc(), WordBreak.INSTANCE.m1664getPhrasejp8hJ3c()));
    private static final int Paragraph = m1613constructorimpl(LineBreak_androidKt.packBytes(Strategy.INSTANCE.m1641getHighQualityfcGXIks(), Strictness.INSTANCE.m1654getStrictusljTpc(), WordBreak.INSTANCE.m1663getDefaultjp8hJ3c()));
    private static final int Unspecified = m1613constructorimpl(0);

    public static final LineBreak m1612boximpl(int i) {
        return new LineBreak(i);
    }

    private static int m1613constructorimpl(int i) {
        return i;
    }

    public static boolean m1617equalsimpl(int i, Object obj) {
        return (obj instanceof LineBreak) && i == ((LineBreak) obj).getMask();
    }

    public static final boolean m1618equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m1622hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1617equalsimpl(this.mask, obj);
    }

    public int hashCode() {
        return m1622hashCodeimpl(this.mask);
    }

    public final int getMask() {
        return this.mask;
    }

    private LineBreak(int i) {
        this.mask = i;
    }

    public static int m1614constructorimpl(int i, int i2, int i3) {
        return m1613constructorimpl(LineBreak_androidKt.packBytes(i, i2, i3));
    }

    public static final int m1619getStrategyfcGXIks(int i) {
        return Strategy.m1634constructorimpl(LineBreak_androidKt.unpackByte1(i));
    }

    public static final int m1620getStrictnessusljTpc(int i) {
        return Strictness.m1645constructorimpl(LineBreak_androidKt.unpackByte2(i));
    }

    public static final int m1621getWordBreakjp8hJ3c(int i) {
        return WordBreak.m1657constructorimpl(LineBreak_androidKt.unpackByte3(i));
    }

    public static int m1616copygijOMQM$default(int i, int i2, int i3, int i4, int i5, Object obj) {
        if ((i5 & 1) != 0) {
            i2 = m1619getStrategyfcGXIks(i);
        }
        if ((i5 & 2) != 0) {
            i3 = m1620getStrictnessusljTpc(i);
        }
        if ((i5 & 4) != 0) {
            i4 = m1621getWordBreakjp8hJ3c(i);
        }
        return m1615copygijOMQM(i, i2, i3, i4);
    }

    public static final int m1615copygijOMQM(int i, int i2, int i3, int i4) {
        return m1614constructorimpl(i2, i3, i4);
    }

    public String toString() {
        return m1623toStringimpl(this.mask);
    }

    public static String m1623toStringimpl(int i) {
        return "LineBreak(strategy=" + ((Object) Strategy.m1638toStringimpl(m1619getStrategyfcGXIks(i))) + ", strictness=" + ((Object) Strictness.m1649toStringimpl(m1620getStrictnessusljTpc(i))) + ", wordBreak=" + ((Object) WordBreak.m1661toStringimpl(m1621getWordBreakjp8hJ3c(i))) + ')';
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000e\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R$\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007R$\u0010\t\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\n\u0010\u0002\u001a\u0004\b\u000b\u0010\u0007R$\u0010\f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\r\u0010\u0002\u001a\u0004\b\u000e\u0010\u0007R$\u0010\u000f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0010\u0010\u0002\u001a\u0004\b\u0011\u0010\u0007\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/style/LineBreak$Companion;", "", "()V", "Heading", "Landroidx/compose/ui/text/style/LineBreak;", "getHeading-rAG3T2k$annotations", "getHeading-rAG3T2k", "()I", "I", "Paragraph", "getParagraph-rAG3T2k$annotations", "getParagraph-rAG3T2k", "Simple", "getSimple-rAG3T2k$annotations", "getSimple-rAG3T2k", "Unspecified", "getUnspecified-rAG3T2k$annotations", "getUnspecified-rAG3T2k", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void m1625getHeadingrAG3T2k$annotations() {
        }

        public static void m1626getParagraphrAG3T2k$annotations() {
        }

        public static void m1627getSimplerAG3T2k$annotations() {
        }

        public static void m1628getUnspecifiedrAG3T2k$annotations() {
        }

        private Companion() {
        }

        public final int m1631getSimplerAG3T2k() {
            return LineBreak.Simple;
        }

        public final int m1629getHeadingrAG3T2k() {
            return LineBreak.Heading;
        }

        public final int m1630getParagraphrAG3T2k() {
            return LineBreak.Paragraph;
        }

        public final int m1632getUnspecifiedrAG3T2k() {
            return LineBreak.Unspecified;
        }
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/style/LineBreak$Strategy;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @JvmInline
    public static final class Strategy {
        private final int value;

        public static final Companion INSTANCE = new Companion(null);
        private static final int Simple = m1634constructorimpl(1);
        private static final int HighQuality = m1634constructorimpl(2);
        private static final int Balanced = m1634constructorimpl(3);
        private static final int Unspecified = m1634constructorimpl(0);

        public static final Strategy m1633boximpl(int i) {
            return new Strategy(i);
        }

        public static int m1634constructorimpl(int i) {
            return i;
        }

        public static boolean m1635equalsimpl(int i, Object obj) {
            return (obj instanceof Strategy) && i == ((Strategy) obj).getValue();
        }

        public static final boolean m1636equalsimpl0(int i, int i2) {
            return i == i2;
        }

        public static int m1637hashCodeimpl(int i) {
            return i;
        }

        public boolean equals(Object obj) {
            return m1635equalsimpl(this.value, obj);
        }

        public int hashCode() {
            return m1637hashCodeimpl(this.value);
        }

        public final int getValue() {
            return this.value;
        }

        @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u000e"}, d2 = {"Landroidx/compose/ui/text/style/LineBreak$Strategy$Companion;", "", "()V", "Balanced", "Landroidx/compose/ui/text/style/LineBreak$Strategy;", "getBalanced-fcGXIks", "()I", "I", "HighQuality", "getHighQuality-fcGXIks", "Simple", "getSimple-fcGXIks", "Unspecified", "getUnspecified-fcGXIks", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final int m1642getSimplefcGXIks() {
                return Strategy.Simple;
            }

            public final int m1641getHighQualityfcGXIks() {
                return Strategy.HighQuality;
            }

            public final int m1640getBalancedfcGXIks() {
                return Strategy.Balanced;
            }

            public final int m1643getUnspecifiedfcGXIks() {
                return Strategy.Unspecified;
            }
        }

        private Strategy(int i) {
            this.value = i;
        }

        public String toString() {
            return m1638toStringimpl(this.value);
        }

        public static String m1638toStringimpl(int i) {
            if (m1636equalsimpl0(i, Simple)) {
                return "Strategy.Simple";
            }
            if (m1636equalsimpl0(i, HighQuality)) {
                return "Strategy.HighQuality";
            }
            if (m1636equalsimpl0(i, Balanced)) {
                return "Strategy.Balanced";
            }
            return m1636equalsimpl0(i, Unspecified) ? "Strategy.Unspecified" : "Invalid";
        }
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/style/LineBreak$Strictness;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @JvmInline
    public static final class Strictness {

        public static final Companion INSTANCE = new Companion(null);
        private static final int Default = m1645constructorimpl(1);
        private static final int Loose = m1645constructorimpl(2);
        private static final int Normal = m1645constructorimpl(3);
        private static final int Strict = m1645constructorimpl(4);
        private static final int Unspecified = m1645constructorimpl(0);
        private final int value;

        public static final Strictness m1644boximpl(int i) {
            return new Strictness(i);
        }

        public static int m1645constructorimpl(int i) {
            return i;
        }

        public static boolean m1646equalsimpl(int i, Object obj) {
            return (obj instanceof Strictness) && i == ((Strictness) obj).getValue();
        }

        public static final boolean m1647equalsimpl0(int i, int i2) {
            return i == i2;
        }

        public static int m1648hashCodeimpl(int i) {
            return i;
        }

        public boolean equals(Object obj) {
            return m1646equalsimpl(this.value, obj);
        }

        public int hashCode() {
            return m1648hashCodeimpl(this.value);
        }

        public final int getValue() {
            return this.value;
        }

        @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0010"}, d2 = {"Landroidx/compose/ui/text/style/LineBreak$Strictness$Companion;", "", "()V", Profile.DEFAULT_PROFILE_NAME, "Landroidx/compose/ui/text/style/LineBreak$Strictness;", "getDefault-usljTpc", "()I", "I", "Loose", "getLoose-usljTpc", "Normal", "getNormal-usljTpc", "Strict", "getStrict-usljTpc", "Unspecified", "getUnspecified-usljTpc", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final int m1651getDefaultusljTpc() {
                return Strictness.Default;
            }

            public final int m1652getLooseusljTpc() {
                return Strictness.Loose;
            }

            public final int m1653getNormalusljTpc() {
                return Strictness.Normal;
            }

            public final int m1654getStrictusljTpc() {
                return Strictness.Strict;
            }

            public final int m1655getUnspecifiedusljTpc() {
                return Strictness.Unspecified;
            }
        }

        private Strictness(int i) {
            this.value = i;
        }

        public String toString() {
            return m1649toStringimpl(this.value);
        }

        public static String m1649toStringimpl(int i) {
            if (m1647equalsimpl0(i, Default)) {
                return "Strictness.None";
            }
            if (m1647equalsimpl0(i, Loose)) {
                return "Strictness.Loose";
            }
            if (m1647equalsimpl0(i, Normal)) {
                return "Strictness.Normal";
            }
            if (m1647equalsimpl0(i, Strict)) {
                return "Strictness.Strict";
            }
            return m1647equalsimpl0(i, Unspecified) ? "Strictness.Unspecified" : "Invalid";
        }
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/style/LineBreak$WordBreak;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @JvmInline
    public static final class WordBreak {

        public static final Companion INSTANCE = new Companion(null);
        private static final int Default = m1657constructorimpl(1);
        private static final int Phrase = m1657constructorimpl(2);
        private static final int Unspecified = m1657constructorimpl(0);
        private final int value;

        public static final WordBreak m1656boximpl(int i) {
            return new WordBreak(i);
        }

        public static int m1657constructorimpl(int i) {
            return i;
        }

        public static boolean m1658equalsimpl(int i, Object obj) {
            return (obj instanceof WordBreak) && i == ((WordBreak) obj).getValue();
        }

        public static final boolean m1659equalsimpl0(int i, int i2) {
            return i == i2;
        }

        public static int m1660hashCodeimpl(int i) {
            return i;
        }

        public boolean equals(Object obj) {
            return m1658equalsimpl(this.value, obj);
        }

        public int hashCode() {
            return m1660hashCodeimpl(this.value);
        }

        public final int getValue() {
            return this.value;
        }

        @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\f"}, d2 = {"Landroidx/compose/ui/text/style/LineBreak$WordBreak$Companion;", "", "()V", Profile.DEFAULT_PROFILE_NAME, "Landroidx/compose/ui/text/style/LineBreak$WordBreak;", "getDefault-jp8hJ3c", "()I", "I", "Phrase", "getPhrase-jp8hJ3c", "Unspecified", "getUnspecified-jp8hJ3c", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final int m1663getDefaultjp8hJ3c() {
                return WordBreak.Default;
            }

            public final int m1664getPhrasejp8hJ3c() {
                return WordBreak.Phrase;
            }

            public final int m1665getUnspecifiedjp8hJ3c() {
                return WordBreak.Unspecified;
            }
        }

        private WordBreak(int i) {
            this.value = i;
        }

        public String toString() {
            return m1661toStringimpl(this.value);
        }

        public static String m1661toStringimpl(int i) {
            if (m1659equalsimpl0(i, Default)) {
                return "WordBreak.None";
            }
            if (m1659equalsimpl0(i, Phrase)) {
                return "WordBreak.Phrase";
            }
            return m1659equalsimpl0(i, Unspecified) ? "WordBreak.Unspecified" : "Invalid";
        }
    }
}
