package androidx.compose.p000ui.unit;

import androidx.compose.ui.geometry.Rect;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0082\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0004\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0014"}, d2 = {"Landroidx/compose/ui/unit/DensityImpl;", "Landroidx/compose/ui/unit/Density;", "density", "", "fontScale", "(FF)V", "getDensity", "()F", "getFontScale", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class DensityImpl implements Density {
    private final float density;
    private final float fontScale;

    public static DensityImpl copy$default(DensityImpl densityImpl, float f, float f2, int i, Object obj) {
        if ((i & 1) != 0) {
            f = densityImpl.density;
        }
        if ((i & 2) != 0) {
            f2 = densityImpl.fontScale;
        }
        return densityImpl.copy(f, f2);
    }

    public final float getDensity() {
        return this.density;
    }

    public final float getFontScale() {
        return this.fontScale;
    }

    public final DensityImpl copy(float density, float fontScale) {
        return new DensityImpl(density, fontScale);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof DensityImpl)) {
            return false;
        }
        DensityImpl densityImpl = (DensityImpl) other;
        return Float.compare(this.density, densityImpl.density) == 0 && Float.compare(this.fontScale, densityImpl.fontScale) == 0;
    }

    public int hashCode() {
        return (Float.floatToIntBits(this.density) * 31) + Float.floatToIntBits(this.fontScale);
    }

    @Override
    public int mo1787roundToPxR2X_6o(long j) {
        return Density.CC.m1797$default$roundToPxR2X_6o(this, j);
    }

    @Override
    public int mo1788roundToPx0680j_4(float f) {
        return Density.CC.m1798$default$roundToPx0680j_4(this, f);
    }

    @Override
    public float mo1831toDpGaN1DYA(long j) {
        return FontScaling.CC.m1944$default$toDpGaN1DYA(this, j);
    }

    @Override
    public float mo1789toDpu2uoSUM(float f) {
        return Density.CC.m1799$default$toDpu2uoSUM(this, f);
    }

    @Override
    public float mo1790toDpu2uoSUM(int i) {
        return Density.CC.m1800$default$toDpu2uoSUM((Density) this, i);
    }

    @Override
    public long mo1791toDpSizekrfVVM(long j) {
        return Density.CC.m1801$default$toDpSizekrfVVM(this, j);
    }

    @Override
    public float mo1792toPxR2X_6o(long j) {
        return Density.CC.m1802$default$toPxR2X_6o(this, j);
    }

    @Override
    public float mo1793toPx0680j_4(float f) {
        return Density.CC.m1803$default$toPx0680j_4(this, f);
    }

    @Override
    public Rect toRect(DpRect dpRect) {
        return Density.CC.$default$toRect(this, dpRect);
    }

    @Override
    public long mo1794toSizeXkaWNTQ(long j) {
        return Density.CC.m1804$default$toSizeXkaWNTQ(this, j);
    }

    @Override
    public long mo1832toSp0xMU5do(float f) {
        return FontScaling.CC.m1945$default$toSp0xMU5do(this, f);
    }

    @Override
    public long mo1795toSpkPz2Gy4(float f) {
        return Density.CC.m1805$default$toSpkPz2Gy4(this, f);
    }

    @Override
    public long mo1796toSpkPz2Gy4(int i) {
        return Density.CC.m1806$default$toSpkPz2Gy4((Density) this, i);
    }

    public String toString() {
        return "DensityImpl(density=" + this.density + ", fontScale=" + this.fontScale + ')';
    }

    public DensityImpl(float f, float f2) {
        this.density = f;
        this.fontScale = f2;
    }

    @Override
    public float getDensity() {
        return this.density;
    }

    @Override
    public float getFontScale() {
        return this.fontScale;
    }
}
