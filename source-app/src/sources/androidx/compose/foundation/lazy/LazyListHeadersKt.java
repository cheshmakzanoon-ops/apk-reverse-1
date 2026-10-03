package androidx.compose.foundation.lazy;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;

@Metadata(d1 = {"\u0000 \n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\b\n\u0002\b\u0004\u001aF\u0010\u0000\u001a\u0004\u0018\u00010\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u00032\u0006\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\u0006\u0010\t\u001a\u00020\b2\u0006\u0010\n\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\bH\u0000¨\u0006\f"}, d2 = {"findOrComposeLazyListHeader", "Landroidx/compose/foundation/lazy/LazyListMeasuredItem;", "composedVisibleItems", "", "itemProvider", "Landroidx/compose/foundation/lazy/LazyListMeasuredItemProvider;", "headerIndexes", "", "", "beforeContentPadding", "layoutWidth", "layoutHeight", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyListHeadersKt {
    public static final LazyListMeasuredItem findOrComposeLazyListHeader(List<LazyListMeasuredItem> list, LazyListMeasuredItemProvider lazyListMeasuredItemProvider, List<Integer> list2, int i, int i2, int i3) {
        int index = ((LazyListMeasuredItem) CollectionsKt.first(list)).getIndex();
        int size = list2.size();
        int iIntValue = -1;
        int iIntValue2 = -1;
        int i4 = 0;
        while (i4 < size && list2.get(i4).intValue() <= index) {
            iIntValue2 = list2.get(i4).intValue();
            i4++;
            iIntValue = ((i4 < 0 || i4 > CollectionsKt.getLastIndex(list2)) ? -1 : list2.get(i4)).intValue();
        }
        int size2 = list.size();
        int offset = Integer.MIN_VALUE;
        int offset2 = Integer.MIN_VALUE;
        int i5 = -1;
        for (int i6 = 0; i6 < size2; i6++) {
            LazyListMeasuredItem lazyListMeasuredItem = list.get(i6);
            if (lazyListMeasuredItem.getIndex() == iIntValue2) {
                offset = lazyListMeasuredItem.getOffset();
                i5 = i6;
            } else if (lazyListMeasuredItem.getIndex() == iIntValue) {
                offset2 = lazyListMeasuredItem.getOffset();
            }
        }
        if (iIntValue2 == -1) {
            return null;
        }
        LazyListMeasuredItem lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default = LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, iIntValue2, 0L, 2, null);
        lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default.setNonScrollableItem(true);
        int iMax = offset != Integer.MIN_VALUE ? Math.max(-i, offset) : -i;
        if (offset2 != Integer.MIN_VALUE) {
            iMax = Math.min(iMax, offset2 - lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default.getSize());
        }
        lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default.position(iMax, i2, i3);
        if (i5 != -1) {
            list.set(i5, lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default);
        } else {
            list.add(0, lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default);
        }
        return lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default;
    }
}
