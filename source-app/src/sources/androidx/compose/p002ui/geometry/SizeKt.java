package androidx.compose.p002ui.geometry;

import androidx.compose.ui.util.MathHelpersKt;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000>\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0010\u0007\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0006\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u001d\u0010\u000f\u001a\u00020\u00022\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0011H\u0007¢\u0006\u0002\u0010\u0013\u001a*\u0010\u0014\u001a\u00020\u00022\u0006\u0010\u0015\u001a\u00020\u00022\u0006\u0010\u0016\u001a\u00020\u00022\u0006\u0010\u0017\u001a\u00020\u0011H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019\u001a%\u0010\u001a\u001a\u00020\u0002*\u00020\u00022\f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00020\u001cH\u0086\bø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u001e\u001a\u001f\u0010\u001f\u001a\u00020\u0002*\u00020 2\u0006\u0010!\u001a\u00020\u0002H\u0087\nø\u0001\u0000¢\u0006\u0004\b\"\u0010#\u001a\u001f\u0010\u001f\u001a\u00020\u0002*\u00020\u00112\u0006\u0010!\u001a\u00020\u0002H\u0087\nø\u0001\u0000¢\u0006\u0004\b\"\u0010$\u001a\u001f\u0010\u001f\u001a\u00020\u0002*\u00020%2\u0006\u0010!\u001a\u00020\u0002H\u0087\nø\u0001\u0000¢\u0006\u0004\b\"\u0010&\u001a\u0016\u0010'\u001a\u00020(*\u00020\u0002H\u0007ø\u0001\u0000¢\u0006\u0004\b)\u0010*\"\u001e\u0010\u0000\u001a\u00020\u0001*\u00020\u00028FX\u0087\u0004¢\u0006\f\u0012\u0004\b\u0003\u0010\u0004\u001a\u0004\b\u0005\u0010\u0006\"\u001f\u0010\u0007\u001a\u00020\b*\u00020\u00028Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\t\u0010\u0004\u001a\u0004\b\n\u0010\u000b\"\u001f\u0010\f\u001a\u00020\b*\u00020\u00028Æ\u0002X\u0087\u0004¢\u0006\f\u0012\u0004\b\r\u0010\u0004\u001a\u0004\b\u000e\u0010\u000b\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006+"}, d2 = {"center", "Landroidx/compose/ui/geometry/Offset;", "Landroidx/compose/ui/geometry/Size;", "getCenter-uvyYCjk$annotations", "(J)V", "getCenter-uvyYCjk", "(J)J", "isSpecified", "", "isSpecified-uvyYCjk$annotations", "isSpecified-uvyYCjk", "(J)Z", "isUnspecified", "isUnspecified-uvyYCjk$annotations", "isUnspecified-uvyYCjk", "Size", "width", "", "height", "(FF)J", "lerp", "start", "stop", "fraction", "lerp-VgWVRYQ", "(JJF)J", "takeOrElse", "block", "Lkotlin/Function0;", "takeOrElse-TmRCtEA", "(JLkotlin/jvm/functions/Function0;)J", "times", "", "size", "times-d16Qtg0", "(DJ)J", "(FJ)J", "", "(IJ)J", "toRect", "Landroidx/compose/ui/geometry/Rect;", "toRect-uvyYCjk", "(J)Landroidx/compose/ui/geometry/Rect;", "ui-geometry_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SizeKt {
    public static void m4426getCenteruvyYCjk$annotations(long j) {
    }

    public static final boolean m4427isSpecifieduvyYCjk(long j) {
        return j != InlineClassHelperKt.UnspecifiedPackedFloats;
    }

    public static void m4428isSpecifieduvyYCjk$annotations(long j) {
    }

    public static final boolean m4429isUnspecifieduvyYCjk(long j) {
        return j == InlineClassHelperKt.UnspecifiedPackedFloats;
    }

    public static void m4430isUnspecifieduvyYCjk$annotations(long j) {
    }

    public static final long m4432takeOrElseTmRCtEA(long j, Function0<Size> function0) {
        return j != InlineClassHelperKt.UnspecifiedPackedFloats ? j : ((Size) function0.invoke()).getPackedValue();
    }

    public static final long m4431lerpVgWVRYQ(long j, long j2, float f) {
        if (j == InlineClassHelperKt.UnspecifiedPackedFloats || j2 == InlineClassHelperKt.UnspecifiedPackedFloats) {
            InlineClassHelperKt.throwIllegalStateException("Offset is unspecified");
        }
        float fLerp = MathHelpersKt.lerp(Float.intBitsToFloat((int) (j >> 32)), Float.intBitsToFloat((int) (j2 >> 32)), f);
        float fLerp2 = MathHelpersKt.lerp(Float.intBitsToFloat((int) (j & 4294967295L)), Float.intBitsToFloat((int) (j2 & 4294967295L)), f);
        return Size.m4406constructorimpl((((long) Float.floatToRawIntBits(fLerp)) << 32) | (((long) Float.floatToRawIntBits(fLerp2)) & 4294967295L));
    }

    public static final long m4435timesd16Qtg0(int i, long j) {
        return Size.m4418times7Ah8Wj8(j, i);
    }

    public static final long m4433timesd16Qtg0(double d, long j) {
        return Size.m4418times7Ah8Wj8(j, (float) d);
    }

    public static final long m4434timesd16Qtg0(float f, long j) {
        return Size.m4418times7Ah8Wj8(j, f);
    }

    public static final Rect m4436toRectuvyYCjk(long j) {
        return RectKt.m4386Recttz77jQw(Offset.INSTANCE.m4362getZeroF1C5BW0(), j);
    }

    public static final long m4425getCenteruvyYCjk(long j) {
        if (j == InlineClassHelperKt.UnspecifiedPackedFloats) {
            InlineClassHelperKt.throwIllegalStateException("Size is unspecified");
        }
        return OffsetKt.Offset(Float.intBitsToFloat((int) (j >> 32)) / 2.0f, Float.intBitsToFloat((int) (j & 4294967295L)) / 2.0f);
    }

    public static final long Size(float f, float f2) {
        return Size.m4406constructorimpl((((long) Float.floatToRawIntBits(f2)) & 4294967295L) | (Float.floatToRawIntBits(f) << 32));
    }
}
