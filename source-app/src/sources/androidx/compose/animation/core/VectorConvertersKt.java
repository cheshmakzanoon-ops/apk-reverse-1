package androidx.compose.animation.core;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.DpKt;
import androidx.compose.ui.unit.DpOffset;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntOffsetKt;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.FloatCompanionObject;
import kotlin.jvm.internal.IntCompanionObject;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u0090\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\u001aJ\u0010*\u001a\u000e\u0012\u0004\u0012\u0002H+\u0012\u0004\u0012\u0002H,0\u0001\"\u0004\b\u0000\u0010+\"\b\b\u0001\u0010,*\u00020-2\u0012\u0010.\u001a\u000e\u0012\u0004\u0012\u0002H+\u0012\u0004\u0012\u0002H,0/2\u0012\u00100\u001a\u000e\u0012\u0004\u0012\u0002H,\u0012\u0004\u0012\u0002H+0/\u001a \u00101\u001a\u00020\b2\u0006\u00102\u001a\u00020\b2\u0006\u00103\u001a\u00020\b2\u0006\u00104\u001a\u00020\bH\u0000\"\u001a\u0010\u0000\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00060\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u00060\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0011\u001a\u000e\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00130\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00030\u0001*\u00020\u00178F¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u0019\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00130\u0001*\u00020\u001a8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u001b\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00030\u0001*\u00020\u001c8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u001d\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u0001*\u00020\u001e8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u001f\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001*\u00020 8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010!\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u00030\u0001*\u00020\"8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010#\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00030\u0001*\u00020$8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010%\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00060\u0001*\u00020&8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010'\"!\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u00060\u0001*\u00020(8F¢\u0006\u0006\u001a\u0004\b\u0018\u0010)¨\u00065"}, d2 = {"DpOffsetToVector", "Landroidx/compose/animation/core/TwoWayConverter;", "Landroidx/compose/ui/unit/DpOffset;", "Landroidx/compose/animation/core/AnimationVector2D;", "DpToVector", "Landroidx/compose/ui/unit/Dp;", "Landroidx/compose/animation/core/AnimationVector1D;", "FloatToVector", "", "IntOffsetToVector", "Landroidx/compose/ui/unit/IntOffset;", "IntSizeToVector", "Landroidx/compose/ui/unit/IntSize;", "IntToVector", "", "OffsetToVector", "Landroidx/compose/ui/geometry/Offset;", "RectToVector", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/animation/core/AnimationVector4D;", "SizeToVector", "Landroidx/compose/ui/geometry/Size;", "VectorConverter", "Landroidx/compose/ui/geometry/Offset$Companion;", "getVectorConverter", "(Landroidx/compose/ui/geometry/Offset$Companion;)Landroidx/compose/animation/core/TwoWayConverter;", "Landroidx/compose/ui/geometry/Rect$Companion;", "(Landroidx/compose/ui/geometry/Rect$Companion;)Landroidx/compose/animation/core/TwoWayConverter;", "Landroidx/compose/ui/geometry/Size$Companion;", "(Landroidx/compose/ui/geometry/Size$Companion;)Landroidx/compose/animation/core/TwoWayConverter;", "Landroidx/compose/ui/unit/Dp$Companion;", "(Landroidx/compose/ui/unit/Dp$Companion;)Landroidx/compose/animation/core/TwoWayConverter;", "Landroidx/compose/ui/unit/DpOffset$Companion;", "(Landroidx/compose/ui/unit/DpOffset$Companion;)Landroidx/compose/animation/core/TwoWayConverter;", "Landroidx/compose/ui/unit/IntOffset$Companion;", "(Landroidx/compose/ui/unit/IntOffset$Companion;)Landroidx/compose/animation/core/TwoWayConverter;", "Landroidx/compose/ui/unit/IntSize$Companion;", "(Landroidx/compose/ui/unit/IntSize$Companion;)Landroidx/compose/animation/core/TwoWayConverter;", "Lkotlin/Float$Companion;", "(Lkotlin/jvm/internal/FloatCompanionObject;)Landroidx/compose/animation/core/TwoWayConverter;", "Lkotlin/Int$Companion;", "(Lkotlin/jvm/internal/IntCompanionObject;)Landroidx/compose/animation/core/TwoWayConverter;", "TwoWayConverter", "T", "V", "Landroidx/compose/animation/core/AnimationVector;", "convertToVector", "Lkotlin/Function1;", "convertFromVector", "lerp", "start", "stop", "fraction", "animation-core_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class VectorConvertersKt {
    private static final TwoWayConverter<Float, AnimationVector1D> FloatToVector = TwoWayConverter(new Function1<Float, AnimationVector1D>() {
        public final AnimationVector1D invoke(float f) {
            return new AnimationVector1D(f);
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).floatValue());
        }
    }, new Function1<AnimationVector1D, Float>() {
        public final Float invoke(AnimationVector1D animationVector1D) {
            return Float.valueOf(animationVector1D.getValue());
        }
    });
    private static final TwoWayConverter<Integer, AnimationVector1D> IntToVector = TwoWayConverter(new Function1<Integer, AnimationVector1D>() {
        public final AnimationVector1D invoke(int i) {
            return new AnimationVector1D(i);
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }
    }, new Function1<AnimationVector1D, Integer>() {
        public final Integer invoke(AnimationVector1D animationVector1D) {
            return Integer.valueOf((int) animationVector1D.getValue());
        }
    });
    private static final TwoWayConverter<Dp, AnimationVector1D> DpToVector = TwoWayConverter(new Function1<Dp, AnimationVector1D>() {
        public Object invoke(Object obj) {
            return m475invoke0680j_4(((Dp) obj).unbox-impl());
        }

        public final AnimationVector1D m475invoke0680j_4(float f) {
            return new AnimationVector1D(f);
        }
    }, new Function1<AnimationVector1D, Dp>() {
        public Object invoke(Object obj) {
            return Dp.box-impl(m476invokeu2uoSUM((AnimationVector1D) obj));
        }

        public final float m476invokeu2uoSUM(AnimationVector1D animationVector1D) {
            return Dp.constructor-impl(animationVector1D.getValue());
        }
    });
    private static final TwoWayConverter<DpOffset, AnimationVector2D> DpOffsetToVector = TwoWayConverter(new Function1<DpOffset, AnimationVector2D>() {
        public Object invoke(Object obj) {
            return m473invokejoFl9I(((DpOffset) obj).unbox-impl());
        }

        public final AnimationVector2D m473invokejoFl9I(long j) {
            return new AnimationVector2D(DpOffset.getX-D9Ej5fM(j), DpOffset.getY-D9Ej5fM(j));
        }
    }, new Function1<AnimationVector2D, DpOffset>() {
        public Object invoke(Object obj) {
            return DpOffset.box-impl(m474invokegVRvYmI((AnimationVector2D) obj));
        }

        public final long m474invokegVRvYmI(AnimationVector2D animationVector2D) {
            return DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(animationVector2D.getV1()), Dp.constructor-impl(animationVector2D.getV2()));
        }
    });
    private static final TwoWayConverter<Size, AnimationVector2D> SizeToVector = TwoWayConverter(new Function1<Size, AnimationVector2D>() {
        public Object invoke(Object obj) {
            return m483invokeuvyYCjk(((Size) obj).getPackedValue());
        }

        public final AnimationVector2D m483invokeuvyYCjk(long j) {
            return new AnimationVector2D(Size.m4415getWidthimpl(j), Size.m4412getHeightimpl(j));
        }
    }, new Function1<AnimationVector2D, Size>() {
        public Object invoke(Object obj) {
            return Size.m4403boximpl(m484invoke7Ah8Wj8((AnimationVector2D) obj));
        }

        public final long m484invoke7Ah8Wj8(AnimationVector2D animationVector2D) {
            return SizeKt.Size(animationVector2D.getV1(), animationVector2D.getV2());
        }
    });
    private static final TwoWayConverter<Offset, AnimationVector2D> OffsetToVector = TwoWayConverter(new Function1<Offset, AnimationVector2D>() {
        public Object invoke(Object obj) {
            return m481invokek4lQ0M(((Offset) obj).getPackedValue());
        }

        public final AnimationVector2D m481invokek4lQ0M(long j) {
            return new AnimationVector2D(Offset.m4346getXimpl(j), Offset.m4347getYimpl(j));
        }
    }, new Function1<AnimationVector2D, Offset>() {
        public Object invoke(Object obj) {
            return Offset.m4335boximpl(m482invoketuRUvjQ((AnimationVector2D) obj));
        }

        public final long m482invoketuRUvjQ(AnimationVector2D animationVector2D) {
            return OffsetKt.Offset(animationVector2D.getV1(), animationVector2D.getV2());
        }
    });
    private static final TwoWayConverter<IntOffset, AnimationVector2D> IntOffsetToVector = TwoWayConverter(new Function1<IntOffset, AnimationVector2D>() {
        public Object invoke(Object obj) {
            return m477invokegyyYBs(((IntOffset) obj).unbox-impl());
        }

        public final AnimationVector2D m477invokegyyYBs(long j) {
            return new AnimationVector2D(IntOffset.getX-impl(j), IntOffset.getY-impl(j));
        }
    }, new Function1<AnimationVector2D, IntOffset>() {
        public Object invoke(Object obj) {
            return IntOffset.box-impl(m478invokeBjo55l4((AnimationVector2D) obj));
        }

        public final long m478invokeBjo55l4(AnimationVector2D animationVector2D) {
            return IntOffsetKt.IntOffset(Math.round(animationVector2D.getV1()), Math.round(animationVector2D.getV2()));
        }
    });
    private static final TwoWayConverter<IntSize, AnimationVector2D> IntSizeToVector = TwoWayConverter(new Function1<IntSize, AnimationVector2D>() {
        public Object invoke(Object obj) {
            return m479invokeozmzZPI(((IntSize) obj).unbox-impl());
        }

        public final AnimationVector2D m479invokeozmzZPI(long j) {
            return new AnimationVector2D(IntSize.getWidth-impl(j), IntSize.getHeight-impl(j));
        }
    }, new Function1<AnimationVector2D, IntSize>() {
        public Object invoke(Object obj) {
            return IntSize.box-impl(m480invokeYEO4UFw((AnimationVector2D) obj));
        }

        public final long m480invokeYEO4UFw(AnimationVector2D animationVector2D) {
            return IntSizeKt.IntSize(RangesKt.coerceAtLeast(Math.round(animationVector2D.getV1()), 0), RangesKt.coerceAtLeast(Math.round(animationVector2D.getV2()), 0));
        }
    });
    private static final TwoWayConverter<Rect, AnimationVector4D> RectToVector = TwoWayConverter(new Function1<Rect, AnimationVector4D>() {
        public final AnimationVector4D invoke(Rect rect) {
            return new AnimationVector4D(rect.getLeft(), rect.getTop(), rect.getRight(), rect.getBottom());
        }
    }, new Function1<AnimationVector4D, Rect>() {
        public final Rect invoke(AnimationVector4D animationVector4D) {
            return new Rect(animationVector4D.getV1(), animationVector4D.getV2(), animationVector4D.getV3(), animationVector4D.getV4());
        }
    });

    public static final float lerp(float f, float f2, float f3) {
        return (f * (1 - f3)) + (f2 * f3);
    }

    public static final <T, V extends AnimationVector> TwoWayConverter<T, V> TwoWayConverter(Function1<? super T, ? extends V> function1, Function1<? super V, ? extends T> function2) {
        return new TwoWayConverterImpl(function1, function2);
    }

    public static final TwoWayConverter<Float, AnimationVector1D> getVectorConverter(FloatCompanionObject floatCompanionObject) {
        return FloatToVector;
    }

    public static final TwoWayConverter<Integer, AnimationVector1D> getVectorConverter(IntCompanionObject intCompanionObject) {
        return IntToVector;
    }

    public static final TwoWayConverter<Rect, AnimationVector4D> getVectorConverter(Rect.Companion companion) {
        return RectToVector;
    }

    public static final TwoWayConverter<Dp, AnimationVector1D> getVectorConverter(Dp.Companion companion) {
        return DpToVector;
    }

    public static final TwoWayConverter<DpOffset, AnimationVector2D> getVectorConverter(DpOffset.Companion companion) {
        return DpOffsetToVector;
    }

    public static final TwoWayConverter<Size, AnimationVector2D> getVectorConverter(Size.Companion companion) {
        return SizeToVector;
    }

    public static final TwoWayConverter<Offset, AnimationVector2D> getVectorConverter(Offset.Companion companion) {
        return OffsetToVector;
    }

    public static final TwoWayConverter<IntOffset, AnimationVector2D> getVectorConverter(IntOffset.Companion companion) {
        return IntOffsetToVector;
    }

    public static final TwoWayConverter<IntSize, AnimationVector2D> getVectorConverter(IntSize.Companion companion) {
        return IntSizeToVector;
    }
}
