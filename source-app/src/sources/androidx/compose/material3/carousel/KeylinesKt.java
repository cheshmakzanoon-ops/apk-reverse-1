package androidx.compose.material3.carousel;

import androidx.compose.ui.unit.Density;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.jvm.functions.Function1;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000*\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0005\u001a \u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00012\u0006\u0010\u0004\u001a\u00020\u0001H\u0002\u001a0\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00012\u0006\u0010\b\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\u00012\u0006\u0010\n\u001a\u00020\u00012\u0006\u0010\u000b\u001a\u00020\fH\u0000\u001aD\u0010\r\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0007\u001a\u00020\u00012\u0006\u0010\u0010\u001a\u00020\u00012\u0006\u0010\b\u001a\u00020\u00012\u0006\u0010\u0011\u001a\u00020\u00122\b\b\u0002\u0010\u0013\u001a\u00020\u00012\b\b\u0002\u0010\u0014\u001a\u00020\u0001H\u0000\u001a(\u0010\u0015\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0007\u001a\u00020\u00012\u0006\u0010\u0016\u001a\u00020\u00012\u0006\u0010\b\u001a\u00020\u0001H\u0000¨\u0006\u0017"}, d2 = {"calculateMediumChildSize", "", "minimumMediumSize", "largeItemSize", "remainingSpace", "createLeftAlignedKeylineList", "Landroidx/compose/material3/carousel/KeylineList;", "carouselMainAxisSize", "itemSpacing", "leftAnchorSize", "rightAnchorSize", "arrangement", "Landroidx/compose/material3/carousel/Arrangement;", "multiBrowseKeylineList", "density", "Landroidx/compose/ui/unit/Density;", "preferredItemSize", "itemCount", "", "minSmallItemSize", "maxSmallItemSize", "uncontainedKeylineList", "itemSize", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class KeylinesKt {
    public static KeylineList multiBrowseKeylineList$default(Density density, float f, float f2, float f3, int i, float f4, float f5, int i2, Object obj) {
        if ((i2 & 32) != 0) {
            f4 = density.toPx-0680j_4(CarouselDefaults.INSTANCE.m3224getMinSmallItemSizeD9Ej5fM$material3_release());
        }
        float f6 = f4;
        if ((i2 & 64) != 0) {
            f5 = density.toPx-0680j_4(CarouselDefaults.INSTANCE.m3223getMaxSmallItemSizeD9Ej5fM$material3_release());
        }
        return multiBrowseKeylineList(density, f, f2, f3, i, f6, f5);
    }

    public static final KeylineList multiBrowseKeylineList(Density density, float f, float f2, float f3, int i, float f4, float f5) {
        if (f == 0.0f || f2 == 0.0f) {
            return KeylineListKt.emptyKeylineList();
        }
        int[] iArr = {1};
        int[] iArr2 = {1, 0};
        float fMin = Math.min(f2, f);
        float fCoerceIn = RangesKt.coerceIn(fMin / 3.0f, f4, f5);
        float f6 = (fMin + fCoerceIn) / 2.0f;
        int[] iArr3 = f < ((float) 2) * f4 ? new int[]{0} : iArr;
        int iMax = Math.max(1, (int) Math.floor(((f - (ArraysKt.maxOrThrow(iArr2) * f6)) - (ArraysKt.maxOrThrow(iArr3) * f5)) / fMin));
        int iCeil = (int) Math.ceil(f / fMin);
        int i2 = (iCeil - iMax) + 1;
        int[] iArr4 = new int[i2];
        for (int i3 = 0; i3 < i2; i3++) {
            iArr4[i3] = iCeil - i3;
        }
        float f7 = density.toPx-0680j_4(CarouselDefaults.INSTANCE.m3222getAnchorSizeD9Ej5fM$material3_release());
        Arrangement arrangementFindLowestCostArrangement = Arrangement.INSTANCE.findLowestCostArrangement(f, f3, fCoerceIn, f4, f5, iArr3, f6, iArr2, fMin, iArr4);
        if (arrangementFindLowestCostArrangement != null && arrangementFindLowestCostArrangement.itemCount() > i) {
            int smallCount = arrangementFindLowestCostArrangement.getSmallCount();
            int mediumCount = arrangementFindLowestCostArrangement.getMediumCount();
            for (int iItemCount = arrangementFindLowestCostArrangement.itemCount() - i; iItemCount > 0; iItemCount--) {
                if (smallCount > 0) {
                    smallCount--;
                } else if (mediumCount > 1) {
                    mediumCount--;
                }
            }
            arrangementFindLowestCostArrangement = Arrangement.INSTANCE.findLowestCostArrangement(f, f3, fCoerceIn, f4, f5, new int[]{smallCount}, f6, new int[]{mediumCount}, fMin, iArr4);
        }
        if (arrangementFindLowestCostArrangement == null) {
            return KeylineListKt.emptyKeylineList();
        }
        return createLeftAlignedKeylineList(f, f3, f7, f7, arrangementFindLowestCostArrangement);
    }

    public static final KeylineList createLeftAlignedKeylineList(float f, float f2, final float f3, final float f4, final Arrangement arrangement) {
        return KeylineListKt.m3234keylineListOfWNYm7Xg(f, f2, CarouselAlignment.INSTANCE.m3221getStartNUL3oTo(), new Function1<KeylineListScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((KeylineListScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(KeylineListScope keylineListScope) {
                keylineListScope.add(f3, true);
                int largeCount = arrangement.getLargeCount();
                Arrangement arrangement2 = arrangement;
                for (int i = 0; i < largeCount; i++) {
                    KeylineListScope.CC.add$default(keylineListScope, arrangement2.getLargeSize(), false, 2, null);
                }
                int mediumCount = arrangement.getMediumCount();
                Arrangement arrangement3 = arrangement;
                for (int i2 = 0; i2 < mediumCount; i2++) {
                    KeylineListScope.CC.add$default(keylineListScope, arrangement3.getMediumSize(), false, 2, null);
                }
                int smallCount = arrangement.getSmallCount();
                Arrangement arrangement4 = arrangement;
                for (int i3 = 0; i3 < smallCount; i3++) {
                    KeylineListScope.CC.add$default(keylineListScope, arrangement4.getSmallSize(), false, 2, null);
                }
                keylineListScope.add(f4, true);
            }
        });
    }

    public static final KeylineList uncontainedKeylineList(Density density, float f, float f2, float f3) {
        if (f == 0.0f || f2 == 0.0f) {
            return KeylineListKt.emptyKeylineList();
        }
        float fMin = Math.min(f2 + f3, f);
        int iMax = Math.max(1, (int) Math.floor(f / fMin));
        float f4 = f - (iMax * fMin);
        int i = f4 > 0.0f ? 1 : 0;
        float f5 = density.toPx-0680j_4(CarouselDefaults.INSTANCE.m3222getAnchorSizeD9Ej5fM$material3_release());
        float fCalculateMediumChildSize = calculateMediumChildSize(f5, fMin, f4);
        return createLeftAlignedKeylineList(f, f3, Math.max(Math.min(f5, f2), fCalculateMediumChildSize * 0.5f), f5, new Arrangement(0, 0.0f, 0, fCalculateMediumChildSize, i, fMin, iMax));
    }

    private static final float calculateMediumChildSize(float f, float f2, float f3) {
        float fMax = Math.max(1.5f * f3, f);
        float f4 = f2 * 0.85f;
        return fMax > f4 ? Math.max(f4, f3 * 1.2f) : fMax;
    }
}
