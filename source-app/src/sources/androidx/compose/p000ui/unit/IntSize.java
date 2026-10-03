package androidx.compose.p000ui.unit;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 $2\u00020\u0001:\u0001$B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u0010\u0010\u0010\u001a\u00020\u0007H\u0087\n¢\u0006\u0004\b\u0011\u0010\u000bJ\u0010\u0010\u0012\u001a\u00020\u0007H\u0087\n¢\u0006\u0004\b\u0013\u0010\u000bJ\u001e\u0010\u0014\u001a\u00020\u00002\u0006\u0010\u0015\u001a\u00020\u0007H\u0087\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0016\u0010\u0017J\u001a\u0010\u0018\u001a\u00020\u00192\b\u0010\u0015\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u001a\u0010\u001bJ\u0010\u0010\u001c\u001a\u00020\u0007HÖ\u0001¢\u0006\u0004\b\u001d\u0010\u000bJ\u001e\u0010\u001e\u001a\u00020\u00002\u0006\u0010\u0015\u001a\u00020\u0007H\u0087\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u001f\u0010\u0017J\u000f\u0010 \u001a\u00020!H\u0017¢\u0006\u0004\b\"\u0010#R\u001a\u0010\u0006\u001a\u00020\u00078FX\u0087\u0004¢\u0006\f\u0012\u0004\b\b\u0010\t\u001a\u0004\b\n\u0010\u000bR\u0016\u0010\u0002\u001a\u00020\u00038\u0000X\u0081\u0004¢\u0006\b\n\u0000\u0012\u0004\b\f\u0010\tR\u001a\u0010\r\u001a\u00020\u00078FX\u0087\u0004¢\u0006\f\u0012\u0004\b\u000e\u0010\t\u001a\u0004\b\u000f\u0010\u000b\u0088\u0001\u0002\u0092\u0001\u00020\u0003\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006%"}, d2 = {"Landroidx/compose/ui/unit/IntSize;", "", "packedValue", "", "constructor-impl", "(J)J", ViewHierarchyConstants.DIMENSION_HEIGHT_KEY, "", "getHeight$annotations", "()V", "getHeight-impl", "(J)I", "getPackedValue$annotations", ViewHierarchyConstants.DIMENSION_WIDTH_KEY, "getWidth$annotations", "getWidth-impl", "component1", "component1-impl", "component2", "component2-impl", "div", "other", "div-YEO4UFw", "(JI)J", "equals", "", "equals-impl", "(JLjava/lang/Object;)Z", "hashCode", "hashCode-impl", "times", "times-YEO4UFw", "toString", "", "toString-impl", "(J)Ljava/lang/String;", "Companion", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class IntSize {

    public static final Companion INSTANCE = new Companion(null);
    private static final long Zero = m2004constructorimpl(0);
    private final long packedValue;

    public static final IntSize m2001boximpl(long j) {
        return new IntSize(j);
    }

    public static long m2004constructorimpl(long j) {
        return j;
    }

    public static boolean m2006equalsimpl(long j, Object obj) {
        return (obj instanceof IntSize) && j == ((IntSize) obj).getPackedValue();
    }

    public static final boolean m2007equalsimpl0(long j, long j2) {
        return j == j2;
    }

    public static void getHeight$annotations() {
    }

    public static final int m2008getHeightimpl(long j) {
        return (int) (j & 4294967295L);
    }

    public static void getPackedValue$annotations() {
    }

    public static void getWidth$annotations() {
    }

    public static final int m2009getWidthimpl(long j) {
        return (int) (j >> 32);
    }

    public static int m2010hashCodeimpl(long j) {
        return UByte$.ExternalSyntheticBackport0.m(j);
    }

    public boolean equals(Object obj) {
        return m2006equalsimpl(this.packedValue, obj);
    }

    public int hashCode() {
        return m2010hashCodeimpl(this.packedValue);
    }

    public final long getPackedValue() {
        return this.packedValue;
    }

    private IntSize(long j) {
        this.packedValue = j;
    }

    public static final int m2002component1impl(long j) {
        return m2009getWidthimpl(j);
    }

    public static final int m2003component2impl(long j) {
        return m2008getHeightimpl(j);
    }

    public static final long m2011timesYEO4UFw(long j, int i) {
        return m2004constructorimpl((((long) (((int) (j >> 32)) * i)) << 32) | (((long) (((int) (j & 4294967295L)) * i)) & 4294967295L));
    }

    public static final long m2005divYEO4UFw(long j, int i) {
        return m2004constructorimpl((((long) (((int) (j >> 32)) / i)) << 32) | (((long) (((int) (j & 4294967295L)) / i)) & 4294967295L));
    }

    public static String m2012toStringimpl(long j) {
        return m2009getWidthimpl(j) + " x " + m2008getHeightimpl(j);
    }

    public String toString() {
        return m2012toStringimpl(this.packedValue);
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\b"}, d2 = {"Landroidx/compose/ui/unit/IntSize$Companion;", "", "()V", "Zero", "Landroidx/compose/ui/unit/IntSize;", "getZero-YbymL2g", "()J", "J", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final long m2014getZeroYbymL2g() {
            return IntSize.Zero;
        }
    }
}
