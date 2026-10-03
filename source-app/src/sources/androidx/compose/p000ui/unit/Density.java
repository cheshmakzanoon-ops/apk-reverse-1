package androidx.compose.p000ui.unit;

import androidx.compose.ui.geometry.Rect;
import androidx.compose.ui.geometry.Size;
import androidx.compose.ui.geometry.SizeKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\bg\u0018\u00002\u00020\u0001J\u0016\u0010\b\u001a\u00020\t*\u00020\nH\u0017ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\fJ\u0016\u0010\b\u001a\u00020\t*\u00020\rH\u0017ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000fJ\u0019\u0010\u0010\u001a\u00020\n*\u00020\u0003H\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u0019\u0010\u0010\u001a\u00020\n*\u00020\tH\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0013J\u0016\u0010\u0014\u001a\u00020\u0015*\u00020\u0016H\u0017ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018J\u0016\u0010\u0019\u001a\u00020\u0003*\u00020\nH\u0017ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u0012J\u0016\u0010\u0019\u001a\u00020\u0003*\u00020\rH\u0017ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u001cJ\f\u0010\u001d\u001a\u00020\u001e*\u00020\u001fH\u0017J\u0016\u0010 \u001a\u00020\u0016*\u00020\u0015H\u0017ø\u0001\u0000¢\u0006\u0004\b!\u0010\u0018J\u0019\u0010\"\u001a\u00020\r*\u00020\u0003H\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b#\u0010$J\u0019\u0010\"\u001a\u00020\r*\u00020\tH\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b#\u0010%R\u001a\u0010\u0002\u001a\u00020\u00038&X§\u0004¢\u0006\f\u0012\u0004\b\u0004\u0010\u0005\u001a\u0004\b\u0006\u0010\u0007ø\u0001\u0002\u0082\u0002\u0011\n\u0005\b¡\u001e0\u0001\n\u0002\b!\n\u0004\b!0\u0001¨\u0006&À\u0006\u0003"}, d2 = {"Landroidx/compose/ui/unit/Density;", "Landroidx/compose/ui/unit/FontScaling;", "density", "", "getDensity$annotations", "()V", "getDensity", "()F", "roundToPx", "", "Landroidx/compose/ui/unit/Dp;", "roundToPx-0680j_4", "(F)I", "Landroidx/compose/ui/unit/TextUnit;", "roundToPx--R2X_6o", "(J)I", "toDp", "toDp-u2uoSUM", "(F)F", "(I)F", "toDpSize", "Landroidx/compose/ui/unit/DpSize;", "Landroidx/compose/ui/geometry/Size;", "toDpSize-k-rfVVM", "(J)J", "toPx", "toPx-0680j_4", "toPx--R2X_6o", "(J)F", "toRect", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/unit/DpRect;", "toSize", "toSize-XkaWNTQ", "toSp", "toSp-kPz2Gy4", "(F)J", "(I)J", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public interface Density extends FontScaling {
    float getDensity();

    int mo1787roundToPxR2X_6o(long j);

    int mo1788roundToPx0680j_4(float f);

    float mo1789toDpu2uoSUM(float f);

    float mo1790toDpu2uoSUM(int i);

    long mo1791toDpSizekrfVVM(long j);

    float mo1792toPxR2X_6o(long j);

    float mo1793toPx0680j_4(float f);

    Rect toRect(DpRect dpRect);

    long mo1794toSizeXkaWNTQ(long j);

    long mo1795toSpkPz2Gy4(float f);

    long mo1796toSpkPz2Gy4(int i);

    public final class CC {
        public static float m1803$default$toPx0680j_4(Density _this, float f) {
            return f * _this.getDensity();
        }

        public static int m1798$default$roundToPx0680j_4(Density _this, float f) {
            float fMo1793toPx0680j_4 = _this.mo1793toPx0680j_4(f);
            if (Float.isInfinite(fMo1793toPx0680j_4)) {
                return Integer.MAX_VALUE;
            }
            return Math.round(fMo1793toPx0680j_4);
        }

        public static float m1802$default$toPxR2X_6o(Density _this, long j) {
            if (!TextUnitType.m2060equalsimpl0(TextUnit.m2031getTypeUIouoOA(j), TextUnitType.INSTANCE.m2065getSpUIouoOA())) {
                throw new IllegalStateException("Only Sp can convert to Px".toString());
            }
            return _this.mo1793toPx0680j_4(_this.mo1831toDpGaN1DYA(j));
        }

        public static int m1797$default$roundToPxR2X_6o(Density _this, long j) {
            return Math.round(_this.mo1792toPxR2X_6o(j));
        }

        public static float m1800$default$toDpu2uoSUM(Density _this, int i) {
            return C0027Dp.m1835constructorimpl(i / _this.getDensity());
        }

        public static long m1806$default$toSpkPz2Gy4(Density _this, int i) {
            return _this.mo1832toSp0xMU5do(_this.mo1790toDpu2uoSUM(i));
        }

        public static float m1799$default$toDpu2uoSUM(Density _this, float f) {
            return C0027Dp.m1835constructorimpl(f / _this.getDensity());
        }

        public static long m1805$default$toSpkPz2Gy4(Density _this, float f) {
            return _this.mo1832toSp0xMU5do(_this.mo1789toDpu2uoSUM(f));
        }

        public static Rect $default$toRect(Density _this, DpRect dpRect) {
            return new Rect(_this.mo1793toPx0680j_4(dpRect.m1918getLeftD9Ej5fM()), _this.mo1793toPx0680j_4(dpRect.m1920getTopD9Ej5fM()), _this.mo1793toPx0680j_4(dpRect.m1919getRightD9Ej5fM()), _this.mo1793toPx0680j_4(dpRect.m1917getBottomD9Ej5fM()));
        }

        public static long m1804$default$toSizeXkaWNTQ(Density _this, long j) {
            return j != 9205357640488583168L ? SizeKt.Size(_this.mo1793toPx0680j_4(DpSize.m1933getWidthD9Ej5fM(j)), _this.mo1793toPx0680j_4(DpSize.m1931getHeightD9Ej5fM(j))) : Size.Companion.getUnspecified-NH-jbRc();
        }

        public static long m1801$default$toDpSizekrfVVM(Density _this, long j) {
            return j != 9205357640488583168L ? DpKt.m1857DpSizeYgX7TsA(_this.mo1789toDpu2uoSUM(Size.getWidth-impl(j)), _this.mo1789toDpu2uoSUM(Size.getHeight-impl(j))) : DpSize.INSTANCE.m1942getUnspecifiedMYxV2XQ();
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class DefaultImpls {
        public static void getDensity$annotations() {
        }

        @Deprecated
        public static float m1821toDpGaN1DYA(Density density, long j) {
            return FontScaling.CC.m1944$default$toDpGaN1DYA(density, j);
        }

        @Deprecated
        public static long m1828toSp0xMU5do(Density density, float f) {
            return FontScaling.CC.m1945$default$toSp0xMU5do(density, f);
        }

        @Deprecated
        public static float m1826toPx0680j_4(Density density, float f) {
            return CC.m1803$default$toPx0680j_4(density, f);
        }

        @Deprecated
        public static int m1820roundToPx0680j_4(Density density, float f) {
            return CC.m1798$default$roundToPx0680j_4(density, f);
        }

        @Deprecated
        public static float m1825toPxR2X_6o(Density density, long j) {
            return CC.m1802$default$toPxR2X_6o(density, j);
        }

        @Deprecated
        public static int m1819roundToPxR2X_6o(Density density, long j) {
            return CC.m1797$default$roundToPxR2X_6o(density, j);
        }

        @Deprecated
        public static float m1823toDpu2uoSUM(Density density, int i) {
            return CC.m1800$default$toDpu2uoSUM(density, i);
        }

        @Deprecated
        public static long m1830toSpkPz2Gy4(Density density, int i) {
            return CC.m1806$default$toSpkPz2Gy4(density, i);
        }

        @Deprecated
        public static float m1822toDpu2uoSUM(Density density, float f) {
            return CC.m1799$default$toDpu2uoSUM(density, f);
        }

        @Deprecated
        public static long m1829toSpkPz2Gy4(Density density, float f) {
            return CC.m1805$default$toSpkPz2Gy4(density, f);
        }

        @Deprecated
        public static Rect toRect(Density density, DpRect dpRect) {
            return CC.$default$toRect(density, dpRect);
        }

        @Deprecated
        public static long m1827toSizeXkaWNTQ(Density density, long j) {
            return CC.m1804$default$toSizeXkaWNTQ(density, j);
        }

        @Deprecated
        public static long m1824toDpSizekrfVVM(Density density, long j) {
            return CC.m1801$default$toDpSizekrfVVM(density, j);
        }
    }
}
