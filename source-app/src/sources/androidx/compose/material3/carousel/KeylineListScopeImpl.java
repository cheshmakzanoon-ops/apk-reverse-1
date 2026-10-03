package androidx.compose.material3.carousel;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.collections.CollectionsKt;
import kotlin.collections.IntIterator;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\b\u0002\u0018\u00002\u00020\u0001:\u0001#B\u0005¢\u0006\u0002\u0010\u0002J\u0018\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00062\u0006\u0010\u000f\u001a\u00020\u0010H\u0016JT\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00130\u00122\u0006\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u00062\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0015\u001a\u00020\u00062\u0006\u0010\u0016\u001a\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u00062\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\u0012H\u0002J(\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u0016\u001a\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u00062\u0006\u0010\u001a\u001a\u00020\u001bø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001dJ&\u0010\u001e\u001a\u00020\u00192\u0006\u0010\u0016\u001a\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0006J\b\u0010\u001f\u001a\u00020\u0004H\u0002J\u0018\u0010 \u001a\u00020\u00102\u0006\u0010\u000e\u001a\u00020\u00062\u0006\u0010!\u001a\u00020\u0006H\u0002J \u0010\"\u001a\u00020\u00102\u0006\u0010\u000e\u001a\u00020\u00062\u0006\u0010!\u001a\u00020\u00062\u0006\u0010\u0016\u001a\u00020\u0006H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006$"}, d2 = {"Landroidx/compose/material3/carousel/KeylineListScopeImpl;", "Landroidx/compose/material3/carousel/KeylineListScope;", "()V", "firstFocalIndex", "", "focalItemSize", "", "pivotIndex", "pivotOffset", "tmpKeylines", "", "Landroidx/compose/material3/carousel/KeylineListScopeImpl$TmpKeyline;", "add", "", "size", "isAnchor", "", "createKeylinesWithPivot", "", "Landroidx/compose/material3/carousel/Keyline;", "lastFocalIndex", "itemMainAxisSize", "carouselMainAxisSize", "itemSpacing", "createWithAlignment", "Landroidx/compose/material3/carousel/KeylineList;", "carouselAlignment", "Landroidx/compose/material3/carousel/CarouselAlignment;", "createWithAlignment-waks0t8", "(FFI)Landroidx/compose/material3/carousel/KeylineList;", "createWithPivot", "findLastFocalIndex", "isCutoffLeft", "offset", "isCutoffRight", "TmpKeyline", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class KeylineListScopeImpl implements KeylineListScope {
    private float focalItemSize;
    private float pivotOffset;
    private int firstFocalIndex = -1;
    private int pivotIndex = -1;
    private final List<TmpKeyline> tmpKeylines = new ArrayList();

    private final boolean isCutoffLeft(float size, float offset) {
        float f = size / 2;
        return offset - f < 0.0f && offset + f > 0.0f;
    }

    private final boolean isCutoffRight(float size, float offset, float carouselMainAxisSize) {
        float f = size / 2;
        return offset - f < carouselMainAxisSize && offset + f > carouselMainAxisSize;
    }

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0082\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000b\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\f\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\r\u001a\u00020\u00052\b\u0010\u000e\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0004\u0010\u0007R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\t¨\u0006\u0013"}, d2 = {"Landroidx/compose/material3/carousel/KeylineListScopeImpl$TmpKeyline;", "", "size", "", "isAnchor", "", "(FZ)V", "()Z", "getSize", "()F", "component1", "component2", "copy", "equals", "other", "hashCode", "", "toString", "", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class TmpKeyline {
        private final boolean isAnchor;
        private final float size;

        public static TmpKeyline copy$default(TmpKeyline tmpKeyline, float f, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                f = tmpKeyline.size;
            }
            if ((i & 2) != 0) {
                z = tmpKeyline.isAnchor;
            }
            return tmpKeyline.copy(f, z);
        }

        public final float getSize() {
            return this.size;
        }

        public final boolean getIsAnchor() {
            return this.isAnchor;
        }

        public final TmpKeyline copy(float size, boolean isAnchor) {
            return new TmpKeyline(size, isAnchor);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof TmpKeyline)) {
                return false;
            }
            TmpKeyline tmpKeyline = (TmpKeyline) other;
            return Float.compare(this.size, tmpKeyline.size) == 0 && this.isAnchor == tmpKeyline.isAnchor;
        }

        public int hashCode() {
            return (Float.floatToIntBits(this.size) * 31) + UByte$.ExternalSyntheticBackport0.m(this.isAnchor);
        }

        public String toString() {
            return "TmpKeyline(size=" + this.size + ", isAnchor=" + this.isAnchor + ')';
        }

        public TmpKeyline(float f, boolean z) {
            this.size = f;
            this.isAnchor = z;
        }

        public final float getSize() {
            return this.size;
        }

        public final boolean isAnchor() {
            return this.isAnchor;
        }
    }

    @Override
    public void add(float size, boolean isAnchor) {
        this.tmpKeylines.add(new TmpKeyline(size, isAnchor));
        if (size > this.focalItemSize) {
            this.firstFocalIndex = CollectionsKt.getLastIndex(this.tmpKeylines);
            this.focalItemSize = size;
        }
    }

    public final KeylineList createWithPivot(float carouselMainAxisSize, float itemSpacing, int pivotIndex, float pivotOffset) {
        return new KeylineList(createKeylinesWithPivot(pivotIndex, pivotOffset, this.firstFocalIndex, findLastFocalIndex(), this.focalItemSize, carouselMainAxisSize, itemSpacing, this.tmpKeylines));
    }

    public final KeylineList m3235createWithAlignmentwaks0t8(float carouselMainAxisSize, float itemSpacing, int carouselAlignment) {
        float f;
        int iFindLastFocalIndex = findLastFocalIndex();
        int i = this.firstFocalIndex;
        int i2 = iFindLastFocalIndex - i;
        this.pivotIndex = i;
        if (CarouselAlignment.m3215equalsimpl0(carouselAlignment, CarouselAlignment.INSTANCE.m3219getCenterNUL3oTo())) {
            float f2 = 0.0f;
            if (itemSpacing != 0.0f) {
                int i3 = i2 % 2;
                if (i3 + ((((i3 ^ 2) & ((-i3) | i3)) >> 31) & 2) != 0) {
                    f2 = itemSpacing / 2.0f;
                }
            }
            float f3 = 2;
            f = ((carouselMainAxisSize / f3) - ((this.focalItemSize / f3) * i2)) - f2;
        } else {
            f = CarouselAlignment.m3215equalsimpl0(carouselAlignment, CarouselAlignment.INSTANCE.m3220getEndNUL3oTo()) ? carouselMainAxisSize - (this.focalItemSize / 2) : this.focalItemSize / 2;
        }
        this.pivotOffset = f;
        return new KeylineList(createKeylinesWithPivot(this.pivotIndex, f, this.firstFocalIndex, iFindLastFocalIndex, this.focalItemSize, carouselMainAxisSize, itemSpacing, this.tmpKeylines));
    }

    private final int findLastFocalIndex() {
        int i = this.firstFocalIndex;
        while (i < CollectionsKt.getLastIndex(this.tmpKeylines)) {
            int i2 = i + 1;
            if (this.tmpKeylines.get(i2).getSize() != this.focalItemSize) {
                break;
            }
            i = i2;
        }
        return i;
    }

    private final List<Keyline> createKeylinesWithPivot(int pivotIndex, float pivotOffset, int firstFocalIndex, int lastFocalIndex, float itemMainAxisSize, float carouselMainAxisSize, float itemSpacing, List<TmpKeyline> tmpKeylines) {
        float f;
        float size;
        boolean z;
        float f2;
        float f3;
        float size2;
        IntIterator it;
        float f4;
        boolean z2;
        float size3;
        IntIterator it2;
        float f5;
        int iNextInt;
        TmpKeyline tmpKeyline;
        float size4;
        boolean z3;
        float size5;
        boolean z4;
        int iNextInt2;
        TmpKeyline tmpKeyline2;
        float size6;
        float fAbs;
        boolean z5;
        TmpKeyline tmpKeyline3 = tmpKeylines.get(pivotIndex);
        ArrayList arrayList = new ArrayList();
        if (!isCutoffLeft(tmpKeyline3.getSize(), pivotOffset)) {
            if (isCutoffRight(tmpKeyline3.getSize(), pivotOffset, carouselMainAxisSize)) {
                size = ((tmpKeyline3.getSize() / 2) + pivotOffset) - carouselMainAxisSize;
            } else {
                f = 0.0f;
            }
            float size7 = tmpKeyline3.getSize();
            if (firstFocalIndex <= pivotIndex || pivotIndex > lastFocalIndex) {
                z = false;
            } else {
                z = true;
            }
            arrayList.add(new Keyline(size7, pivotOffset, pivotOffset, z, tmpKeyline3.isAnchor(), true, f));
            f2 = 2;
            f3 = itemMainAxisSize / f2;
            size2 = (pivotOffset - f3) - itemSpacing;
            it = RangesKt.downTo(pivotIndex - 1, 0).iterator();
            f4 = size2;
            while (it.hasNext()) {
                iNextInt2 = it.nextInt();
                tmpKeyline2 = tmpKeylines.get(iNextInt2);
                size6 = size2 - (tmpKeyline2.getSize() / f2);
                float f6 = f4 - f3;
                if (isCutoffLeft(tmpKeyline2.getSize(), size6)) {
                    fAbs = Math.abs(size6 - (tmpKeyline2.getSize() / f2));
                } else {
                    fAbs = 0.0f;
                }
                float size8 = tmpKeyline2.getSize();
                if (firstFocalIndex <= iNextInt2 || iNextInt2 > lastFocalIndex) {
                    z5 = false;
                } else {
                    z5 = true;
                }
                arrayList.add(0, new Keyline(size8, size6, f6, z5, tmpKeyline2.isAnchor(), false, fAbs));
                size2 -= tmpKeyline2.getSize() + itemSpacing;
                f4 -= itemMainAxisSize + itemSpacing;
            }
            z2 = false;
            size3 = pivotOffset + f3 + itemSpacing;
            it2 = RangesKt.until(pivotIndex + 1, tmpKeylines.size()).iterator();
            f5 = size3;
            while (it2.hasNext()) {
                iNextInt = it2.nextInt();
                tmpKeyline = tmpKeylines.get(iNextInt);
                size4 = (tmpKeyline.getSize() / f2) + size3;
                float f7 = f5 + f3;
                z3 = z2;
                if (isCutoffRight(tmpKeyline.getSize(), size4, carouselMainAxisSize)) {
                    size5 = ((tmpKeyline.getSize() / f2) + size4) - carouselMainAxisSize;
                } else {
                    size5 = 0.0f;
                }
                float size9 = tmpKeyline.getSize();
                if (firstFocalIndex <= iNextInt || iNextInt > lastFocalIndex) {
                    z4 = z3;
                } else {
                    z4 = true;
                }
                arrayList.add(new Keyline(size9, size4, f7, z4, tmpKeyline.isAnchor(), false, size5));
                size3 += tmpKeyline.getSize() + itemSpacing;
                f5 += itemMainAxisSize + itemSpacing;
                z2 = z3;
            }
            return arrayList;
        }
        size = pivotOffset - (tmpKeyline3.getSize() / 2);
        f = size;
        float size10 = tmpKeyline3.getSize();
        if (firstFocalIndex <= pivotIndex) {
            z = false;
        } else {
            z = false;
        }
        arrayList.add(new Keyline(size10, pivotOffset, pivotOffset, z, tmpKeyline3.isAnchor(), true, f));
        f2 = 2;
        f3 = itemMainAxisSize / f2;
        size2 = (pivotOffset - f3) - itemSpacing;
        it = RangesKt.downTo(pivotIndex - 1, 0).iterator();
        f4 = size2;
        while (it.hasNext()) {
            iNextInt2 = it.nextInt();
            tmpKeyline2 = tmpKeylines.get(iNextInt2);
            size6 = size2 - (tmpKeyline2.getSize() / f2);
            float f8 = f4 - f3;
            if (isCutoffLeft(tmpKeyline2.getSize(), size6)) {
                fAbs = Math.abs(size6 - (tmpKeyline2.getSize() / f2));
            } else {
                fAbs = 0.0f;
            }
            float size11 = tmpKeyline2.getSize();
            if (firstFocalIndex <= iNextInt2) {
                z5 = false;
            } else {
                z5 = false;
            }
            arrayList.add(0, new Keyline(size11, size6, f8, z5, tmpKeyline2.isAnchor(), false, fAbs));
            size2 -= tmpKeyline2.getSize() + itemSpacing;
            f4 -= itemMainAxisSize + itemSpacing;
        }
        z2 = false;
        size3 = pivotOffset + f3 + itemSpacing;
        it2 = RangesKt.until(pivotIndex + 1, tmpKeylines.size()).iterator();
        f5 = size3;
        while (it2.hasNext()) {
            iNextInt = it2.nextInt();
            tmpKeyline = tmpKeylines.get(iNextInt);
            size4 = (tmpKeyline.getSize() / f2) + size3;
            float f9 = f5 + f3;
            z3 = z2;
            if (isCutoffRight(tmpKeyline.getSize(), size4, carouselMainAxisSize)) {
                size5 = ((tmpKeyline.getSize() / f2) + size4) - carouselMainAxisSize;
            } else {
                size5 = 0.0f;
            }
            float size12 = tmpKeyline.getSize();
            if (firstFocalIndex <= iNextInt) {
                z4 = z3;
            } else {
                z4 = z3;
            }
            arrayList.add(new Keyline(size12, size4, f9, z4, tmpKeyline.isAnchor(), false, size5));
            size3 += tmpKeyline.getSize() + itemSpacing;
            f5 += itemMainAxisSize + itemSpacing;
            z2 = z3;
        }
        return arrayList;
    }
}
