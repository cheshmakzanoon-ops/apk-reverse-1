package androidx.compose.p000ui.unit;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u000f\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\u0010\u0000\n\u0002\b\f\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0087@\u0018\u0000 &2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001&B\u000f\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001b\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u0000H\u0097\u0002ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\fJ\u001b\u0010\r\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000fJ\u001e\u0010\r\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u0003H\u0087\nø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u000fJ\u001e\u0010\r\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\tH\u0087\nø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011J\u001a\u0010\u0012\u001a\u00020\u00132\b\u0010\n\u001a\u0004\u0018\u00010\u0014HÖ\u0003¢\u0006\u0004\b\u0015\u0010\u0016J\u0010\u0010\u0017\u001a\u00020\tHÖ\u0001¢\u0006\u0004\b\u0018\u0010\u0019J\u001b\u0010\u001a\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u000fJ\u001b\u0010\u001c\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u000fJ\u001e\u0010\u001e\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\u0003H\u0087\nø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010\u000fJ\u001e\u0010\u001e\u001a\u00020\u00002\u0006\u0010\n\u001a\u00020\tH\u0087\nø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010\u0011J\u000f\u0010 \u001a\u00020!H\u0017¢\u0006\u0004\b\"\u0010#J\u0016\u0010$\u001a\u00020\u0000H\u0087\nø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b%\u0010\u0005R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007\u0088\u0001\u0002\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006'"}, d2 = {"Landroidx/compose/ui/unit/Dp;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(F)F", "getValue", "()F", "compareTo", "", "other", "compareTo-0680j_4", "(FF)I", "div", "div-0680j_4", "(FF)F", "div-u2uoSUM", "(FI)F", "equals", "", "", "equals-impl", "(FLjava/lang/Object;)Z", "hashCode", "hashCode-impl", "(F)I", "minus", "minus-5rwHm24", "plus", "plus-5rwHm24", "times", "times-u2uoSUM", "toString", "", "toString-impl", "(F)Ljava/lang/String;", "unaryMinus", "unaryMinus-D9Ej5fM", "Companion", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class C0027Dp implements Comparable<C0027Dp> {

    public static final Companion INSTANCE = new Companion(null);
    private static final float Hairline = m1835constructorimpl(0.0f);
    private static final float Infinity = m1835constructorimpl(Float.POSITIVE_INFINITY);
    private static final float Unspecified = m1835constructorimpl(Float.NaN);
    private final float value;

    public static final C0027Dp m1833boximpl(float f) {
        return new C0027Dp(f);
    }

    public static float m1835constructorimpl(float f) {
        return f;
    }

    public static final float m1836div0680j_4(float f, float f2) {
        return f / f2;
    }

    public static boolean m1839equalsimpl(float f, Object obj) {
        return (obj instanceof C0027Dp) && Float.compare(f, ((C0027Dp) obj).m1849unboximpl()) == 0;
    }

    public static final boolean m1840equalsimpl0(float f, float f2) {
        return Float.compare(f, f2) == 0;
    }

    public static int m1841hashCodeimpl(float f) {
        return Float.floatToIntBits(f);
    }

    public boolean equals(Object obj) {
        return m1839equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1841hashCodeimpl(this.value);
    }

    public final float m1849unboximpl() {
        return this.value;
    }

    @Override
    public int compareTo(C0027Dp c0027Dp) {
        return m1848compareTo0680j_4(c0027Dp.m1849unboximpl());
    }

    private C0027Dp(float f) {
        this.value = f;
    }

    public final float getValue() {
        return this.value;
    }

    public static final float m1843plus5rwHm24(float f, float f2) {
        return m1835constructorimpl(f + f2);
    }

    public static final float m1842minus5rwHm24(float f, float f2) {
        return m1835constructorimpl(f - f2);
    }

    public static final float m1847unaryMinusD9Ej5fM(float f) {
        return m1835constructorimpl(-f);
    }

    public static final float m1837divu2uoSUM(float f, float f2) {
        return m1835constructorimpl(f / f2);
    }

    public static final float m1838divu2uoSUM(float f, int i) {
        return m1835constructorimpl(f / i);
    }

    public static final float m1844timesu2uoSUM(float f, float f2) {
        return m1835constructorimpl(f * f2);
    }

    public static final float m1845timesu2uoSUM(float f, int i) {
        return m1835constructorimpl(f * i);
    }

    public static int m1834compareTo0680j_4(float f, float f2) {
        return Float.compare(f, f2);
    }

    public int m1848compareTo0680j_4(float f) {
        return m1834compareTo0680j_4(this.value, f);
    }

    public String toString() {
        return m1846toStringimpl(this.value);
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R$\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007R$\u0010\t\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\n\u0010\u0002\u001a\u0004\b\u000b\u0010\u0007R$\u0010\f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\r\u0010\u0002\u001a\u0004\b\u000e\u0010\u0007\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u000f"}, d2 = {"Landroidx/compose/ui/unit/Dp$Companion;", "", "()V", "Hairline", "Landroidx/compose/ui/unit/Dp;", "getHairline-D9Ej5fM$annotations", "getHairline-D9Ej5fM", "()F", "F", "Infinity", "getInfinity-D9Ej5fM$annotations", "getInfinity-D9Ej5fM", "Unspecified", "getUnspecified-D9Ej5fM$annotations", "getUnspecified-D9Ej5fM", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void m1850getHairlineD9Ej5fM$annotations() {
        }

        public static void m1851getInfinityD9Ej5fM$annotations() {
        }

        public static void m1852getUnspecifiedD9Ej5fM$annotations() {
        }

        private Companion() {
        }

        public final float m1853getHairlineD9Ej5fM() {
            return C0027Dp.Hairline;
        }

        public final float m1854getInfinityD9Ej5fM() {
            return C0027Dp.Infinity;
        }

        public final float m1855getUnspecifiedD9Ej5fM() {
            return C0027Dp.Unspecified;
        }
    }

    public static String m1846toStringimpl(float f) {
        if (Float.isNaN(f)) {
            return "Dp.Unspecified";
        }
        return f + ".dp";
    }
}
