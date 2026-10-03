package androidx.compose.p000ui.unit;

import androidx.compose.p000ui.unit.fontscaling.FontScaleConverter;
import androidx.compose.ui.geometry.Rect;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0082\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÂ\u0003J'\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J\u0016\u0010\u0017\u001a\u00020\u0018*\u00020\u0019H\u0016ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001bJ\u0016\u0010\u001c\u001a\u00020\u0019*\u00020\u0018H\u0016ø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u001eR\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0014\u0010\u0004\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\t\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001f"}, d2 = {"Landroidx/compose/ui/unit/DensityWithConverter;", "Landroidx/compose/ui/unit/Density;", "density", "", "fontScale", "converter", "Landroidx/compose/ui/unit/fontscaling/FontScaleConverter;", "(FFLandroidx/compose/ui/unit/fontscaling/FontScaleConverter;)V", "getDensity", "()F", "getFontScale", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "toDp", "Landroidx/compose/ui/unit/Dp;", "Landroidx/compose/ui/unit/TextUnit;", "toDp-GaN1DYA", "(J)F", "toSp", "toSp-0xMU5do", "(F)J", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class DensityWithConverter implements Density {
    private final FontScaleConverter converter;
    private final float density;
    private final float fontScale;

    private final FontScaleConverter getConverter() {
        return this.converter;
    }

    public static DensityWithConverter copy$default(DensityWithConverter densityWithConverter, float f, float f2, FontScaleConverter fontScaleConverter, int i, Object obj) {
        if ((i & 1) != 0) {
            f = densityWithConverter.density;
        }
        if ((i & 2) != 0) {
            f2 = densityWithConverter.fontScale;
        }
        if ((i & 4) != 0) {
            fontScaleConverter = densityWithConverter.converter;
        }
        return densityWithConverter.copy(f, f2, fontScaleConverter);
    }

    public final float getDensity() {
        return this.density;
    }

    public final float getFontScale() {
        return this.fontScale;
    }

    public final DensityWithConverter copy(float density, float fontScale, FontScaleConverter converter) {
        return new DensityWithConverter(density, fontScale, converter);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof DensityWithConverter)) {
            return false;
        }
        DensityWithConverter densityWithConverter = (DensityWithConverter) other;
        return Float.compare(this.density, densityWithConverter.density) == 0 && Float.compare(this.fontScale, densityWithConverter.fontScale) == 0 && Intrinsics.areEqual(this.converter, densityWithConverter.converter);
    }

    public int hashCode() {
        return (((Float.floatToIntBits(this.density) * 31) + Float.floatToIntBits(this.fontScale)) * 31) + this.converter.hashCode();
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
    public long mo1795toSpkPz2Gy4(float f) {
        return Density.CC.m1805$default$toSpkPz2Gy4(this, f);
    }

    @Override
    public long mo1796toSpkPz2Gy4(int i) {
        return Density.CC.m1806$default$toSpkPz2Gy4((Density) this, i);
    }

    public String toString() {
        return "DensityWithConverter(density=" + this.density + ", fontScale=" + this.fontScale + ", converter=" + this.converter + ')';
    }

    public DensityWithConverter(float f, float f2, FontScaleConverter fontScaleConverter) {
        this.density = f;
        this.fontScale = f2;
        this.converter = fontScaleConverter;
    }

    @Override
    public float getDensity() {
        return this.density;
    }

    @Override
    public float getFontScale() {
        return this.fontScale;
    }

    @Override
    public long mo1832toSp0xMU5do(float f) {
        return TextUnitKt.getSp(this.converter.convertDpToSp(f));
    }

    @Override
    public float mo1831toDpGaN1DYA(long j) {
        if (!TextUnitType.m2060equalsimpl0(TextUnit.m2031getTypeUIouoOA(j), TextUnitType.INSTANCE.m2065getSpUIouoOA())) {
            throw new IllegalStateException("Only Sp can convert to Px".toString());
        }
        return C0027Dp.m1835constructorimpl(this.converter.convertSpToDp(TextUnit.m2032getValueimpl(j)));
    }
}
