package androidx.compose.foundation.lazy.staggeredgrid;

import androidx.compose.foundation.lazy.layout.MutableIntervalList;
import androidx.compose.p002ui.layout.AlignmentLine;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.ui.unit.DensityKt;
import androidx.compose.ui.unit.IntSize;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.collections.MapsKt;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function1;
import kotlinx.coroutines.CoroutineScopeKt;

@Metadata(d1 = {"\u0000 \n\u0000\n\u0002\u0010\u0015\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\u001a\u0016\u0010\b\u001a\u0004\u0018\u00010\t*\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0004\u0010\u0005\u001a\u0004\b\u0006\u0010\u0007¨\u0006\r"}, d2 = {"EmptyArray", "", "EmptyLazyStaggeredGridLayoutInfo", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasureResult;", "getEmptyLazyStaggeredGridLayoutInfo$annotations", "()V", "getEmptyLazyStaggeredGridLayoutInfo", "()Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasureResult;", "findVisibleItem", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemInfo;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridLayoutInfo;", "itemIndex", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyStaggeredGridMeasureResultKt {
    private static final int[] EmptyArray;
    private static final LazyStaggeredGridMeasureResult EmptyLazyStaggeredGridLayoutInfo;

    public static void getEmptyLazyStaggeredGridLayoutInfo$annotations() {
    }

    public static final LazyStaggeredGridItemInfo findVisibleItem(LazyStaggeredGridLayoutInfo lazyStaggeredGridLayoutInfo, final int i) {
        if (lazyStaggeredGridLayoutInfo.getVisibleItemsInfo().isEmpty()) {
            return null;
        }
        int index = ((LazyStaggeredGridItemInfo) CollectionsKt.first(lazyStaggeredGridLayoutInfo.getVisibleItemsInfo())).getIndex();
        if (i > ((LazyStaggeredGridItemInfo) CollectionsKt.last(lazyStaggeredGridLayoutInfo.getVisibleItemsInfo())).getIndex() || index > i) {
            return null;
        }
        return (LazyStaggeredGridItemInfo) CollectionsKt.getOrNull(lazyStaggeredGridLayoutInfo.getVisibleItemsInfo(), CollectionsKt.binarySearch$default(lazyStaggeredGridLayoutInfo.getVisibleItemsInfo(), 0, 0, new Function1<LazyStaggeredGridItemInfo, Integer>() {
            {
                super(1);
            }

            public final Integer invoke(LazyStaggeredGridItemInfo lazyStaggeredGridItemInfo) {
                return Integer.valueOf(lazyStaggeredGridItemInfo.getIndex() - i);
            }
        }, 3, (Object) null));
    }

    static {
        int[] iArr = new int[0];
        EmptyArray = iArr;
        MeasureResult measureResult = new MeasureResult() {
            private final Map<AlignmentLine, Integer> alignmentLines = MapsKt.emptyMap();
            private final int height;
            private final int width;

            public static void getAlignmentLines$annotations() {
            }

            @Override
            public Function1 getRulers() {
                return MeasureResult.CC.$default$getRulers(this);
            }

            @Override
            public void placeChildren() {
            }

            @Override
            public int getWidth() {
                return this.width;
            }

            @Override
            public int getHeight() {
                return this.height;
            }

            @Override
            public Map<AlignmentLine, Integer> getAlignmentLines() {
                return this.alignmentLines;
            }
        };
        MeasureResult measureResult2 = measureResult;
        float f = 0.0f;
        boolean z = false;
        boolean z2 = false;
        boolean z3 = false;
        int i = 0;
        int i2 = 0;
        int i3 = 0;
        int i4 = 0;
        int i5 = 0;
        EmptyLazyStaggeredGridLayoutInfo = new LazyStaggeredGridMeasureResult(iArr, iArr, f, measureResult2, z, z2, z3, new LazyStaggeredGridSlots(iArr, iArr), new LazyStaggeredGridSpanProvider(new MutableIntervalList()), DensityKt.Density$default(1.0f, 0.0f, 2, (Object) null), i, CollectionsKt.emptyList(), IntSize.Companion.getZero-YbymL2g(), i2, i3, i4, i5, 0, CoroutineScopeKt.CoroutineScope(EmptyCoroutineContext.INSTANCE), null);
    }

    public static final LazyStaggeredGridMeasureResult getEmptyLazyStaggeredGridLayoutInfo() {
        return EmptyLazyStaggeredGridLayoutInfo;
    }
}
