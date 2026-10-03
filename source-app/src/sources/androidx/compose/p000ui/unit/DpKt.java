package androidx.compose.p000ui.unit;

import androidx.compose.p000ui.util.MathHelpersKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000B\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0010\u0006\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b:\n\u0002\u0018\u0002\n\u0002\b\u000e\u001a\"\u00105\u001a\u00020\u00012\u0006\u00106\u001a\u00020\b2\u0006\u00107\u001a\u00020\bH\u0007ø\u0001\u0000¢\u0006\u0004\b8\u00109\u001a\"\u0010:\u001a\u00020\u00022\u0006\u00102\u001a\u00020\b2\u0006\u0010\u0014\u001a\u00020\bH\u0007ø\u0001\u0000¢\u0006\u0004\b;\u00109\u001a*\u0010<\u001a\u00020\b2\u0006\u0010=\u001a\u00020\b2\u0006\u0010>\u001a\u00020\b2\u0006\u0010?\u001a\u00020\u000eH\u0007ø\u0001\u0000¢\u0006\u0004\b@\u0010A\u001a*\u0010<\u001a\u00020\u00012\u0006\u0010=\u001a\u00020\u00012\u0006\u0010>\u001a\u00020\u00012\u0006\u0010?\u001a\u00020\u000eH\u0007ø\u0001\u0000¢\u0006\u0004\bB\u0010C\u001a*\u0010<\u001a\u00020\u00022\u0006\u0010=\u001a\u00020\u00022\u0006\u0010>\u001a\u00020\u00022\u0006\u0010?\u001a\u00020\u000eH\u0007ø\u0001\u0000¢\u0006\u0004\bD\u0010C\u001a#\u0010E\u001a\u00020\b2\u0006\u0010F\u001a\u00020\b2\u0006\u0010G\u001a\u00020\bH\u0087\bø\u0001\u0000¢\u0006\u0004\bH\u0010I\u001a#\u0010J\u001a\u00020\b2\u0006\u0010F\u001a\u00020\b2\u0006\u0010G\u001a\u00020\bH\u0087\bø\u0001\u0000¢\u0006\u0004\bK\u0010I\u001a\u001f\u0010L\u001a\u00020\b*\u00020\b2\u0006\u0010M\u001a\u00020\bH\u0087\bø\u0001\u0000¢\u0006\u0004\bN\u0010I\u001a\u001f\u0010O\u001a\u00020\b*\u00020\b2\u0006\u0010P\u001a\u00020\bH\u0087\bø\u0001\u0000¢\u0006\u0004\bQ\u0010I\u001a'\u0010R\u001a\u00020\b*\u00020\b2\u0006\u0010M\u001a\u00020\b2\u0006\u0010P\u001a\u00020\bH\u0087\bø\u0001\u0000¢\u0006\u0004\bS\u0010A\u001a%\u0010T\u001a\u00020\b*\u00020\b2\f\u0010U\u001a\b\u0012\u0004\u0012\u00020\b0VH\u0086\bø\u0001\u0000¢\u0006\u0004\bW\u0010X\u001a%\u0010T\u001a\u00020\u0001*\u00020\u00012\f\u0010U\u001a\b\u0012\u0004\u0012\u00020\u00010VH\u0086\bø\u0001\u0000¢\u0006\u0004\bY\u0010Z\u001a%\u0010T\u001a\u00020\u0002*\u00020\u00022\f\u0010U\u001a\b\u0012\u0004\u0012\u00020\u00020VH\u0086\bø\u0001\u0000¢\u0006\u0004\b[\u0010Z\u001a\u001f\u0010\\\u001a\u00020\b*\u00020\t2\u0006\u0010]\u001a\u00020\bH\u0087\nø\u0001\u0000¢\u0006\u0004\b^\u0010_\u001a\u001f\u0010\\\u001a\u00020\b*\u00020\u000e2\u0006\u0010]\u001a\u00020\bH\u0087\nø\u0001\u0000¢\u0006\u0004\b^\u0010I\u001a\u001f\u0010\\\u001a\u00020\u0002*\u00020\u000e2\u0006\u0010.\u001a\u00020\u0002H\u0087\nø\u0001\u0000¢\u0006\u0004\b`\u0010a\u001a\u001f\u0010\\\u001a\u00020\b*\u00020\u00112\u0006\u0010]\u001a\u00020\bH\u0087\nø\u0001\u0000¢\u0006\u0004\b^\u0010b\u001a\u001f\u0010\\\u001a\u00020\u0002*\u00020\u00112\u0006\u0010.\u001a\u00020\u0002H\u0087\nø\u0001\u0000¢\u0006\u0004\b`\u0010c\"\u001e\u0010\u0000\u001a\u00020\u0001*\u00020\u00028FX\u0087\u0004¢\u0006\f\u0012\u0004\b\u0003\u0010\u0004\u001a\u0004\b\u0005\u0010\u0006\"\u001f\u0010\u0007\u001a\u00020\b*\u00020\t8Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\n\u0010\u000b\u001a\u0004\b\f\u0010\r\"\u001f\u0010\u0007\u001a\u00020\b*\u00020\u000e8Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\n\u0010\u000f\u001a\u0004\b\f\u0010\u0010\"\u001f\u0010\u0007\u001a\u00020\b*\u00020\u00118Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\n\u0010\u0012\u001a\u0004\b\f\u0010\u0013\"\u001f\u0010\u0014\u001a\u00020\b*\u00020\u00158Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\u0016\u0010\u0017\u001a\u0004\b\u0018\u0010\u0019\"\u001f\u0010\u001a\u001a\u00020\u001b*\u00020\b8Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\u001c\u0010\u000f\u001a\u0004\b\u001d\u0010\u001e\"\u001f\u0010\u001f\u001a\u00020\u001b*\u00020\b8Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b \u0010\u000f\u001a\u0004\b!\u0010\u001e\"\u001f\u0010\u001f\u001a\u00020\u001b*\u00020\u00018Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\"\u0010\u0004\u001a\u0004\b#\u0010$\"\u001f\u0010\u001f\u001a\u00020\u001b*\u00020\u00028Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b%\u0010\u0004\u001a\u0004\b&\u0010$\"\u001f\u0010'\u001a\u00020\u001b*\u00020\b8Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b(\u0010\u000f\u001a\u0004\b)\u0010\u001e\"\u001f\u0010'\u001a\u00020\u001b*\u00020\u00018Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b*\u0010\u0004\u001a\u0004\b+\u0010$\"\u001f\u0010'\u001a\u00020\u001b*\u00020\u00028Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b,\u0010\u0004\u001a\u0004\b-\u0010$\"\u001f\u0010.\u001a\u00020\u0002*\u00020\u00158Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b/\u0010\u0017\u001a\u0004\b0\u00101\"\u001f\u00102\u001a\u00020\b*\u00020\u00158Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b3\u0010\u0017\u001a\u0004\b4\u0010\u0019\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006d"}, d2 = {"center", "Landroidx/compose/ui/unit/DpOffset;", "Landroidx/compose/ui/unit/DpSize;", "getCenter-EaSLcWc$annotations", "(J)V", "getCenter-EaSLcWc", "(J)J", "dp", "Landroidx/compose/ui/unit/Dp;", "", "getDp$annotations", "(D)V", "getDp", "(D)F", "", "(F)V", "(F)F", "", "(I)V", "(I)F", ViewHierarchyConstants.DIMENSION_HEIGHT_KEY, "Landroidx/compose/ui/unit/DpRect;", "getHeight$annotations", "(Landroidx/compose/ui/unit/DpRect;)V", "getHeight", "(Landroidx/compose/ui/unit/DpRect;)F", "isFinite", "", "isFinite-0680j_4$annotations", "isFinite-0680j_4", "(F)Z", "isSpecified", "isSpecified-0680j_4$annotations", "isSpecified-0680j_4", "isSpecified-jo-Fl9I$annotations", "isSpecified-jo-Fl9I", "(J)Z", "isSpecified-EaSLcWc$annotations", "isSpecified-EaSLcWc", "isUnspecified", "isUnspecified-0680j_4$annotations", "isUnspecified-0680j_4", "isUnspecified-jo-Fl9I$annotations", "isUnspecified-jo-Fl9I", "isUnspecified-EaSLcWc$annotations", "isUnspecified-EaSLcWc", "size", "getSize$annotations", "getSize", "(Landroidx/compose/ui/unit/DpRect;)J", ViewHierarchyConstants.DIMENSION_WIDTH_KEY, "getWidth$annotations", "getWidth", "DpOffset", "x", "y", "DpOffset-YgX7TsA", "(FF)J", "DpSize", "DpSize-YgX7TsA", "lerp", "start", "stop", "fraction", "lerp-Md-fbLM", "(FFF)F", "lerp-xhh869w", "(JJF)J", "lerp-IDex15A", "max", "a", "b", "max-YgX7TsA", "(FF)F", "min", "min-YgX7TsA", "coerceAtLeast", "minimumValue", "coerceAtLeast-YgX7TsA", "coerceAtMost", "maximumValue", "coerceAtMost-YgX7TsA", "coerceIn", "coerceIn-2z7ARbQ", "takeOrElse", "block", "Lkotlin/Function0;", "takeOrElse-D5KLDUw", "(FLkotlin/jvm/functions/Function0;)F", "takeOrElse-gVKV90s", "(JLkotlin/jvm/functions/Function0;)J", "takeOrElse-itqla9I", "times", "other", "times-3ABfNKs", "(DF)F", "times-6HolHcs", "(FJ)J", "(IF)F", "(IJ)J", "ui-unit_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class DpKt {
    public static void m1862getCenterEaSLcWc$annotations(long j) {
    }

    public static void getDp$annotations(double d) {
    }

    public static void getDp$annotations(float f) {
    }

    public static void getDp$annotations(int i) {
    }

    public static void getHeight$annotations(DpRect dpRect) {
    }

    public static void getSize$annotations(DpRect dpRect) {
    }

    public static void getWidth$annotations(DpRect dpRect) {
    }

    public static final boolean m1863isFinite0680j_4(float f) {
        return !(f == Float.POSITIVE_INFINITY);
    }

    public static void m1864isFinite0680j_4$annotations(float f) {
    }

    public static void m1866isSpecified0680j_4$annotations(float f) {
    }

    public static final boolean m1867isSpecifiedEaSLcWc(long j) {
        return j != 9205357640488583168L;
    }

    public static void m1868isSpecifiedEaSLcWc$annotations(long j) {
    }

    public static final boolean m1869isSpecifiedjoFl9I(long j) {
        return j != 9205357640488583168L;
    }

    public static void m1870isSpecifiedjoFl9I$annotations(long j) {
    }

    public static void m1872isUnspecified0680j_4$annotations(float f) {
    }

    public static final boolean m1873isUnspecifiedEaSLcWc(long j) {
        return j == 9205357640488583168L;
    }

    public static void m1874isUnspecifiedEaSLcWc$annotations(long j) {
    }

    public static final boolean m1875isUnspecifiedjoFl9I(long j) {
        return j == 9205357640488583168L;
    }

    public static void m1876isUnspecifiedjoFl9I$annotations(long j) {
    }

    public static final boolean m1865isSpecified0680j_4(float f) {
        return !Float.isNaN(f);
    }

    public static final boolean m1871isUnspecified0680j_4(float f) {
        return Float.isNaN(f);
    }

    public static final float getDp(int i) {
        return C0027Dp.m1835constructorimpl(i);
    }

    public static final float getDp(double d) {
        return C0027Dp.m1835constructorimpl((float) d);
    }

    public static final float getDp(float f) {
        return C0027Dp.m1835constructorimpl(f);
    }

    public static final float m1886times3ABfNKs(float f, float f2) {
        return C0027Dp.m1835constructorimpl(f * f2);
    }

    public static final float m1885times3ABfNKs(double d, float f) {
        return C0027Dp.m1835constructorimpl(((float) d) * f);
    }

    public static final float m1887times3ABfNKs(int i, float f) {
        return C0027Dp.m1835constructorimpl(i * f);
    }

    public static final float m1881minYgX7TsA(float f, float f2) {
        return C0027Dp.m1835constructorimpl(Math.min(f, f2));
    }

    public static final float m1880maxYgX7TsA(float f, float f2) {
        return C0027Dp.m1835constructorimpl(Math.max(f, f2));
    }

    public static final float m1860coerceIn2z7ARbQ(float f, float f2, float f3) {
        return C0027Dp.m1835constructorimpl(RangesKt.coerceIn(f, f2, f3));
    }

    public static final float m1858coerceAtLeastYgX7TsA(float f, float f2) {
        return C0027Dp.m1835constructorimpl(RangesKt.coerceAtLeast(f, f2));
    }

    public static final float m1859coerceAtMostYgX7TsA(float f, float f2) {
        return C0027Dp.m1835constructorimpl(RangesKt.coerceAtMost(f, f2));
    }

    public static final float m1878lerpMdfbLM(float f, float f2, float f3) {
        return C0027Dp.m1835constructorimpl(MathHelpersKt.lerp(f, f2, f3));
    }

    public static final long m1883takeOrElsegVKV90s(long j, Function0<DpOffset> function0) {
        return j != 9205357640488583168L ? j : ((DpOffset) function0.invoke()).getPackedValue();
    }

    public static final long m1879lerpxhh869w(long j, long j2, float f) {
        float fLerp = MathHelpersKt.lerp(DpOffset.m1896getXD9Ej5fM(j), DpOffset.m1896getXD9Ej5fM(j2), f);
        float fLerp2 = MathHelpersKt.lerp(DpOffset.m1898getYD9Ej5fM(j), DpOffset.m1898getYD9Ej5fM(j2), f);
        return DpOffset.m1891constructorimpl((((long) Float.floatToRawIntBits(fLerp)) << 32) | (((long) Float.floatToRawIntBits(fLerp2)) & 4294967295L));
    }

    public static final long m1884takeOrElseitqla9I(long j, Function0<DpSize> function0) {
        return j != 9205357640488583168L ? j : ((DpSize) function0.invoke()).getPackedValue();
    }

    public static final long m1861getCenterEaSLcWc(long j) {
        float fM1835constructorimpl = C0027Dp.m1835constructorimpl(DpSize.m1933getWidthD9Ej5fM(j) / 2.0f);
        return DpOffset.m1891constructorimpl((((long) Float.floatToRawIntBits(C0027Dp.m1835constructorimpl(DpSize.m1931getHeightD9Ej5fM(j) / 2.0f))) & 4294967295L) | (Float.floatToRawIntBits(fM1835constructorimpl) << 32));
    }

    public static final long m1889times6HolHcs(int i, long j) {
        return DpSize.m1939timesGh9hcWk(j, i);
    }

    public static final long m1888times6HolHcs(float f, long j) {
        return DpSize.m1938timesGh9hcWk(j, f);
    }

    public static final long m1877lerpIDex15A(long j, long j2, float f) {
        float fM1878lerpMdfbLM = m1878lerpMdfbLM(DpSize.m1933getWidthD9Ej5fM(j), DpSize.m1933getWidthD9Ej5fM(j2), f);
        float fM1878lerpMdfbLM2 = m1878lerpMdfbLM(DpSize.m1931getHeightD9Ej5fM(j), DpSize.m1931getHeightD9Ej5fM(j2), f);
        return DpSize.m1924constructorimpl((((long) Float.floatToRawIntBits(fM1878lerpMdfbLM)) << 32) | (((long) Float.floatToRawIntBits(fM1878lerpMdfbLM2)) & 4294967295L));
    }

    public static final float getWidth(DpRect dpRect) {
        return C0027Dp.m1835constructorimpl(dpRect.m1919getRightD9Ej5fM() - dpRect.m1918getLeftD9Ej5fM());
    }

    public static final float getHeight(DpRect dpRect) {
        return C0027Dp.m1835constructorimpl(dpRect.m1917getBottomD9Ej5fM() - dpRect.m1920getTopD9Ej5fM());
    }

    public static final float m1882takeOrElseD5KLDUw(float f, Function0<C0027Dp> function0) {
        return !Float.isNaN(f) ? f : ((C0027Dp) function0.invoke()).m1849unboximpl();
    }

    public static final long m1856DpOffsetYgX7TsA(float f, float f2) {
        return DpOffset.m1891constructorimpl((((long) Float.floatToRawIntBits(f2)) & 4294967295L) | (Float.floatToRawIntBits(f) << 32));
    }

    public static final long m1857DpSizeYgX7TsA(float f, float f2) {
        return DpSize.m1924constructorimpl((((long) Float.floatToRawIntBits(f2)) & 4294967295L) | (Float.floatToRawIntBits(f) << 32));
    }

    public static final long getSize(DpRect dpRect) {
        return m1857DpSizeYgX7TsA(C0027Dp.m1835constructorimpl(dpRect.m1919getRightD9Ej5fM() - dpRect.m1918getLeftD9Ej5fM()), C0027Dp.m1835constructorimpl(dpRect.m1917getBottomD9Ej5fM() - dpRect.m1920getTopD9Ej5fM()));
    }
}
