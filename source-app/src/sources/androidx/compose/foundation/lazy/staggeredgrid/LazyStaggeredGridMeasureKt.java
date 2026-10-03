package androidx.compose.foundation.lazy.staggeredgrid;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.lazy.layout.LazyLayoutMeasureScope;
import androidx.compose.foundation.lazy.layout.ObservableScopeInvalidator;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.ArrayDeque;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u009e\u0001\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0015\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\u001a\u0017\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007H\u0082\b\u001a5\u0010\t\u001a\u0002H\n\"\u0004\b\u0000\u0010\n2\u0006\u0010\u000b\u001a\u00020\f2\u0017\u0010\r\u001a\u0013\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u0002H\n0\u000e¢\u0006\u0002\b\u000fH\u0083\b¢\u0006\u0002\u0010\u0010\u001aR\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00130\u0012*\u00020\u00142\u0012\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00050\u000e2!\u0010\u0016\u001a\u001d\u0012\u0013\u0012\u00110\u0003¢\u0006\f\b\u0017\u0012\b\b\u0018\u0012\u0004\b\b(\u0019\u0012\u0004\u0012\u00020\u00010\u000e2\u0006\u0010\u001a\u001a\u00020\u0001H\u0083\b\u001a;\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00130\u0012*\u00020\u00142\u0012\u0010\u001c\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00130\u001e0\u001d2\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\u0003H\u0002¢\u0006\u0002\u0010\"\u001a\u001d\u0010#\u001a\u00020\b*\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00130\u001e0\u001dH\u0002¢\u0006\u0002\u0010$\u001a\u001c\u0010%\u001a\u00020\u0005*\u00020\u00142\u0006\u0010&\u001a\u00020 2\u0006\u0010'\u001a\u00020\u0003H\u0002\u001a7\u0010(\u001a\u00020\u0005\"\u0004\b\u0000\u0010\n*\b\u0012\u0004\u0012\u0002H\n0\u00122\b\b\u0002\u0010)\u001a\u00020\u00012\u0012\u0010*\u001a\u000e\u0012\u0004\u0012\u0002H\n\u0012\u0004\u0012\u00020\u00050\u000eH\u0082\b\u001a\u001c\u0010+\u001a\u00020\u0003*\u00020\u00142\u0006\u0010,\u001a\u00020\u00032\u0006\u0010-\u001a\u00020\u0003H\u0002\u001a+\u0010.\u001a\u00020\u0005*\u00020/2\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00050\u000eH\u0082\bø\u0001\u0000¢\u0006\u0004\b0\u00101\u001a\f\u00102\u001a\u00020\u0003*\u00020 H\u0002\u001a2\u00103\u001a\u00020\u0003\"\u0004\b\u0000\u0010\n*\b\u0012\u0004\u0012\u0002H\n0\u001d2\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u0002H\n\u0012\u0004\u0012\u00020\u00030\u000eH\u0082\b¢\u0006\u0002\u00104\u001a\u0016\u00105\u001a\u00020\u0003*\u00020 2\b\b\u0002\u00106\u001a\u00020\u0003H\u0000\u001a\u001e\u00107\u001a\u00020\u0003*\u00020 2\u0006\u00108\u001a\u00020/H\u0002ø\u0001\u0000¢\u0006\u0004\b9\u0010:\u001a,\u0010;\u001a\u00020<*\u00020\u00142\u0006\u0010=\u001a\u00020\u00032\u0006\u0010>\u001a\u00020 2\u0006\u0010?\u001a\u00020 2\u0006\u0010@\u001a\u00020\u0001H\u0003\u001a\u008c\u0001\u0010A\u001a\u00020<*\u00020\f2\u0006\u0010B\u001a\u00020C2\f\u0010D\u001a\b\u0012\u0004\u0012\u00020\u00030\u00122\u0006\u0010E\u001a\u00020F2\u0006\u0010G\u001a\u00020H2\u0006\u0010I\u001a\u00020J2\u0006\u0010K\u001a\u00020\u00012\u0006\u0010L\u001a\u00020\u00012\u0006\u0010M\u001a\u00020N2\u0006\u0010O\u001a\u00020\u00032\u0006\u0010P\u001a\u00020\u00032\u0006\u0010Q\u001a\u00020\u00032\u0006\u0010R\u001a\u00020\u00032\u0006\u0010S\u001a\u00020T2\u0006\u0010U\u001a\u00020VH\u0001ø\u0001\u0000¢\u0006\u0004\bW\u0010X\u001a\u0014\u0010Y\u001a\u00020\u0005*\u00020 2\u0006\u0010Z\u001a\u00020\u0003H\u0002\u001a!\u0010[\u001a\u00020 *\u00020 2\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u000eH\u0082\b\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0002\u001a\u00020\u0003X\u0082T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\\"}, d2 = {"DebugLoggingEnabled", "", "Unset", "", "debugLog", "", "message", "Lkotlin/Function0;", "", "withDebugLogging", "T", "scope", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;", "block", "Lkotlin/Function1;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;Lkotlin/jvm/functions/Function1;)Ljava/lang/Object;", "calculateExtraItems", "", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasuredItem;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasureContext;", "position", "filter", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "itemIndex", "beforeVisibleBounds", "calculateVisibleItems", "measuredItems", "", "Lkotlin/collections/ArrayDeque;", "itemScrollOffsets", "", "mainAxisLayoutSize", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasureContext;[Lkotlin/collections/ArrayDeque;[II)Ljava/util/List;", "debugRender", "([Lkotlin/collections/ArrayDeque;)Ljava/lang/String;", "ensureIndicesInRange", "indices", "itemCount", "fastForEach", "reverse", "action", "findPreviousItemIndex", "item", "lane", "forEach", "Landroidx/compose/foundation/lazy/staggeredgrid/SpanRange;", "forEach-nIS5qE8", "(JLkotlin/jvm/functions/Function1;)V", "indexOfMaxValue", "indexOfMinBy", "([Ljava/lang/Object;Lkotlin/jvm/functions/Function1;)I", "indexOfMinValue", "minBound", "maxInRange", "indexRange", "maxInRange-jy6DScQ", "([IJ)I", "measure", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasureResult;", "initialScrollDelta", "initialItemIndices", "initialItemOffsets", "canRestartMeasure", "measureStaggeredGrid", "state", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;", "pinnedItems", "itemProvider", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemProvider;", "resolvedSlots", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridSlots;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "isVertical", "reverseLayout", "contentOffset", "Landroidx/compose/ui/unit/IntOffset;", "mainAxisAvailableSize", "mainAxisSpacing", "beforeContentPadding", "afterContentPadding", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "measureStaggeredGrid-XtK8cYQ", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;Ljava/util/List;Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemProvider;Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridSlots;JZZJIIIILkotlinx/coroutines/CoroutineScope;Landroidx/compose/ui/graphics/GraphicsContext;)Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridMeasureResult;", "offsetBy", "delta", "transform", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyStaggeredGridMeasureKt {
    private static final boolean DebugLoggingEnabled = false;
    private static final int Unset = Integer.MIN_VALUE;

    private static final void debugLog(Function0<String> function0) {
    }

    private static final <T> T withDebugLogging(LazyLayoutMeasureScope lazyLayoutMeasureScope, Function1<? super LazyLayoutMeasureScope, ? extends T> function1) {
        return (T) function1.invoke(lazyLayoutMeasureScope);
    }

    private static final String debugRender(ArrayDeque<LazyStaggeredGridMeasuredItem>[] arrayDequeArr) {
        return "";
    }

    public static final LazyStaggeredGridMeasureResult m1294measureStaggeredGridXtK8cYQ(LazyLayoutMeasureScope lazyLayoutMeasureScope, LazyStaggeredGridState lazyStaggeredGridState, List<Integer> list, LazyStaggeredGridItemProvider lazyStaggeredGridItemProvider, LazyStaggeredGridSlots lazyStaggeredGridSlots, long j, boolean z, boolean z2, long j2, int i, int i2, int i3, int i4, CoroutineScope coroutineScope, GraphicsContext graphicsContext) {
        int i5;
        int iM1293maxInRangejy6DScQ;
        LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext = new LazyStaggeredGridMeasureContext(lazyStaggeredGridState, list, lazyStaggeredGridItemProvider, lazyStaggeredGridSlots, j, z, lazyLayoutMeasureScope, i, j2, i3, i4, z2, i2, coroutineScope, graphicsContext, null);
        int[] iArrUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release = lazyStaggeredGridState.updateScrollPositionIfTheFirstItemWasMoved$foundation_release(lazyStaggeredGridItemProvider, lazyStaggeredGridState.getScrollPosition().getIndices());
        int[] scrollOffsets = lazyStaggeredGridState.getScrollPosition().getScrollOffsets();
        if (iArrUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release.length != lazyStaggeredGridMeasureContext.getLaneCount()) {
            lazyStaggeredGridMeasureContext.getLaneInfo().reset();
            int laneCount = lazyStaggeredGridMeasureContext.getLaneCount();
            int[] iArr = new int[laneCount];
            int i6 = 0;
            while (i6 < laneCount) {
                if (i6 >= iArrUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release.length || (iM1293maxInRangejy6DScQ = iArrUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release[i6]) == -1) {
                    iM1293maxInRangejy6DScQ = i6 == 0 ? 0 : m1293maxInRangejy6DScQ(iArr, SpanRange.m1305constructorimpl(0, i6)) + 1;
                }
                iArr[i6] = iM1293maxInRangejy6DScQ;
                lazyStaggeredGridMeasureContext.getLaneInfo().setLane(iArr[i6], i6);
                i6++;
            }
            iArrUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release = iArr;
        }
        if (scrollOffsets.length != lazyStaggeredGridMeasureContext.getLaneCount()) {
            int laneCount2 = lazyStaggeredGridMeasureContext.getLaneCount();
            int[] iArr2 = new int[laneCount2];
            int i7 = 0;
            while (i7 < laneCount2) {
                if (i7 < scrollOffsets.length) {
                    i5 = scrollOffsets[i7];
                } else {
                    i5 = i7 == 0 ? 0 : iArr2[i7 - 1];
                }
                iArr2[i7] = i5;
                i7++;
            }
            scrollOffsets = iArr2;
        }
        return measure(lazyStaggeredGridMeasureContext, Math.round(lazyStaggeredGridState.getScrollToBeConsumed()), iArrUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release, scrollOffsets, true);
    }

    private static final LazyStaggeredGridMeasureResult measure(final LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext, int i, int[] iArr, int[] iArr2, boolean z) {
        int iIndexOf;
        int i2;
        int i3;
        int i4;
        int[] iArr3;
        int[] iArr4;
        int[] iArr5;
        int i5;
        int i6;
        int i7;
        int[] iArr6;
        List listEmptyList;
        int i8;
        boolean z2;
        boolean z3;
        boolean z4;
        int[] iArr7;
        List<Integer> list;
        int i9;
        boolean z5;
        boolean z6;
        int i10;
        int[] gaps;
        int i11;
        LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext2 = lazyStaggeredGridMeasureContext;
        int i12 = i;
        LazyLayoutMeasureScope measureScope = lazyStaggeredGridMeasureContext.getMeasureScope();
        int itemCount = lazyStaggeredGridMeasureContext.getItemProvider().getItemCount();
        if (itemCount <= 0 || lazyStaggeredGridMeasureContext.getLaneCount() == 0) {
            int i13 = Constraints.getMinWidth-impl(lazyStaggeredGridMeasureContext.getConstraints());
            int i14 = Constraints.getMinHeight-impl(lazyStaggeredGridMeasureContext.getConstraints());
            lazyStaggeredGridMeasureContext.getState().getItemAnimator$foundation_release().onMeasured(0, i13, i14, new ArrayList(), lazyStaggeredGridMeasureContext.getMeasuredItemProvider().getKeyIndexMap(), lazyStaggeredGridMeasureContext.getMeasuredItemProvider(), lazyStaggeredGridMeasureContext.getIsVertical(), false, lazyStaggeredGridMeasureContext.getLaneCount(), false, 0, 0, lazyStaggeredGridMeasureContext.getCoroutineScope(), lazyStaggeredGridMeasureContext.getGraphicsContext());
            long jM1213getMinSizeToFitDisappearingItemsYbymL2g = lazyStaggeredGridMeasureContext.getState().getItemAnimator$foundation_release().m1213getMinSizeToFitDisappearingItemsYbymL2g();
            if (!IntSize.equals-impl0(jM1213getMinSizeToFitDisappearingItemsYbymL2g, IntSize.Companion.getZero-YbymL2g())) {
                i13 = ConstraintsKt.constrainWidth-K40F9xA(lazyStaggeredGridMeasureContext.getConstraints(), IntSize.getWidth-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g));
                i14 = ConstraintsKt.constrainHeight-K40F9xA(lazyStaggeredGridMeasureContext.getConstraints(), IntSize.getHeight-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g));
            }
            return new LazyStaggeredGridMeasureResult(iArr, iArr2, 0.0f, MeasureScope.CC.layout$default(measureScope, i13, i14, null, new Function1<Placeable.PlacementScope, Unit>() {
                public final void invoke(Placeable.PlacementScope placementScope) {
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }
            }, 4, null), false, lazyStaggeredGridMeasureContext.getIsVertical(), false, lazyStaggeredGridMeasureContext.getResolvedSlots(), lazyStaggeredGridMeasureContext.getItemProvider().getSpanProvider(), measureScope, itemCount, CollectionsKt.emptyList(), IntSizeKt.IntSize(Constraints.getMinWidth-impl(lazyStaggeredGridMeasureContext.getConstraints()), Constraints.getMinHeight-impl(lazyStaggeredGridMeasureContext.getConstraints())), -lazyStaggeredGridMeasureContext.getBeforeContentPadding(), lazyStaggeredGridMeasureContext.getMainAxisAvailableSize() + lazyStaggeredGridMeasureContext.getAfterContentPadding(), lazyStaggeredGridMeasureContext.getBeforeContentPadding(), lazyStaggeredGridMeasureContext.getAfterContentPadding(), lazyStaggeredGridMeasureContext.getMainAxisSpacing(), lazyStaggeredGridMeasureContext.getCoroutineScope(), null);
        }
        int[] iArrCopyOf = Arrays.copyOf(iArr, iArr.length);
        String str = "copyOf(this, size)";
        Intrinsics.checkNotNullExpressionValue(iArrCopyOf, "copyOf(this, size)");
        int[] iArrCopyOf2 = Arrays.copyOf(iArr2, iArr2.length);
        Intrinsics.checkNotNullExpressionValue(iArrCopyOf2, "copyOf(this, size)");
        ensureIndicesInRange(lazyStaggeredGridMeasureContext2, iArrCopyOf, itemCount);
        offsetBy(iArrCopyOf2, -i12);
        int laneCount = lazyStaggeredGridMeasureContext.getLaneCount();
        ArrayDeque[] arrayDequeArr = new ArrayDeque[laneCount];
        for (int i15 = 0; i15 < laneCount; i15++) {
            arrayDequeArr[i15] = new ArrayDeque(16);
        }
        offsetBy(iArrCopyOf2, -lazyStaggeredGridMeasureContext.getBeforeContentPadding());
        boolean z7 = false;
        while (true) {
            if (!measure$lambda$41$hasSpaceBeforeFirst(iArrCopyOf, iArrCopyOf2, lazyStaggeredGridMeasureContext2)) {
                iIndexOf = -1;
                break;
            }
            iIndexOf = indexOfMaxValue(iArrCopyOf);
            int i16 = iArrCopyOf[iIndexOf];
            int length = iArrCopyOf2.length;
            for (int i17 = 0; i17 < length; i17++) {
                if (iArrCopyOf[i17] != iArrCopyOf[iIndexOf]) {
                    int i18 = iArrCopyOf2[i17];
                    int i19 = iArrCopyOf2[iIndexOf];
                    if (i18 < i19) {
                        iArrCopyOf2[i17] = i19;
                    }
                }
            }
            int iFindPreviousItemIndex = findPreviousItemIndex(lazyStaggeredGridMeasureContext2, i16, iIndexOf);
            if (iFindPreviousItemIndex < 0) {
                break;
            }
            long jM1289getSpanRangelOCCd4c = lazyStaggeredGridMeasureContext2.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), iFindPreviousItemIndex, iIndexOf);
            int i20 = (int) (4294967295L & jM1289getSpanRangelOCCd4c);
            LazyLayoutMeasureScope lazyLayoutMeasureScope = measureScope;
            int i21 = itemCount;
            int i22 = (int) (jM1289getSpanRangelOCCd4c >> 32);
            int i23 = i20 - i22;
            lazyStaggeredGridMeasureContext.getLaneInfo().setLane(iFindPreviousItemIndex, i23 != 1 ? -2 : i22);
            LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(iFindPreviousItemIndex, jM1289getSpanRangelOCCd4c);
            int iM1293maxInRangejy6DScQ = m1293maxInRangejy6DScQ(iArrCopyOf2, jM1289getSpanRangelOCCd4c);
            int[] gaps2 = i23 != 1 ? lazyStaggeredGridMeasureContext.getLaneInfo().getGaps(iFindPreviousItemIndex) : null;
            while (i22 < i20) {
                iArrCopyOf[i22] = iFindPreviousItemIndex;
                int mainAxisSizeWithSpacings = lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ.getMainAxisSizeWithSpacings() + iM1293maxInRangejy6DScQ + (gaps2 == null ? 0 : gaps2[i22]);
                iArrCopyOf2[i22] = mainAxisSizeWithSpacings;
                if (lazyStaggeredGridMeasureContext.getMainAxisAvailableSize() + mainAxisSizeWithSpacings <= 0) {
                    z7 = true;
                }
                i22++;
            }
            measureScope = lazyLayoutMeasureScope;
            itemCount = i21;
        }
        int i24 = -lazyStaggeredGridMeasureContext.getBeforeContentPadding();
        int i25 = iArrCopyOf2[0];
        if (i25 < i24) {
            i12 += i25;
            offsetBy(iArrCopyOf2, i24 - i25);
        }
        offsetBy(iArrCopyOf2, lazyStaggeredGridMeasureContext.getBeforeContentPadding());
        int i26 = -1;
        if (iIndexOf == -1) {
            iIndexOf = ArraysKt.indexOf(iArrCopyOf, 0);
        }
        if (iIndexOf != -1 && measure$lambda$41$misalignedStart(iArrCopyOf, lazyStaggeredGridMeasureContext2, iArrCopyOf2, iIndexOf) && z) {
            lazyStaggeredGridMeasureContext.getLaneInfo().reset();
            int length2 = iArrCopyOf.length;
            int[] iArr8 = new int[length2];
            int i27 = 0;
            while (i27 < length2) {
                iArr8[i27] = i26;
                i27++;
                i26 = -1;
            }
            int length3 = iArrCopyOf2.length;
            int[] iArr9 = new int[length3];
            for (int i28 = 0; i28 < length3; i28++) {
                iArr9[i28] = iArrCopyOf2[iIndexOf];
            }
            return measure(lazyStaggeredGridMeasureContext2, i12, iArr8, iArr9, false);
        }
        int[] iArrCopyOf3 = Arrays.copyOf(iArrCopyOf, iArrCopyOf.length);
        Intrinsics.checkNotNullExpressionValue(iArrCopyOf3, "copyOf(this, size)");
        int length4 = iArrCopyOf2.length;
        int[] iArr10 = new int[length4];
        for (int i29 = 0; i29 < length4; i29++) {
            iArr10[i29] = -iArrCopyOf2[i29];
        }
        int mainAxisSpacing = i24 + lazyStaggeredGridMeasureContext.getMainAxisSpacing();
        int iCoerceAtLeast = RangesKt.coerceAtLeast(lazyStaggeredGridMeasureContext.getMainAxisAvailableSize() + lazyStaggeredGridMeasureContext.getAfterContentPadding(), 0);
        boolean z8 = z7;
        int iIndexOfMinValue$default = indexOfMinValue$default(iArrCopyOf3, 0, 1, null);
        int laneCount2 = 0;
        while (iIndexOfMinValue$default != -1 && laneCount2 < lazyStaggeredGridMeasureContext.getLaneCount()) {
            int i30 = iArrCopyOf3[iIndexOfMinValue$default];
            iIndexOfMinValue$default = indexOfMinValue(iArrCopyOf3, i30);
            laneCount2++;
            if (i30 >= 0) {
                int i31 = i12;
                long jM1289getSpanRangelOCCd4c2 = lazyStaggeredGridMeasureContext2.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), i30, iIndexOfMinValue$default);
                LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ2 = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(i30, jM1289getSpanRangelOCCd4c2);
                int i32 = i24;
                String str2 = str;
                int[] iArr11 = iArrCopyOf;
                int i33 = (int) (jM1289getSpanRangelOCCd4c2 & 4294967295L);
                int[] iArr12 = iArrCopyOf2;
                int i34 = laneCount;
                int i35 = (int) (jM1289getSpanRangelOCCd4c2 >> 32);
                int i36 = i33 - i35;
                lazyStaggeredGridMeasureContext.getLaneInfo().setLane(i30, i36 != 1 ? -2 : i35);
                int iM1293maxInRangejy6DScQ2 = m1293maxInRangejy6DScQ(iArr10, jM1289getSpanRangelOCCd4c2);
                for (int i37 = i35; i37 < i33; i37++) {
                    iArr10[i37] = lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ2.getMainAxisSizeWithSpacings() + iM1293maxInRangejy6DScQ2;
                    iArrCopyOf3[i37] = i30;
                    arrayDequeArr[i37].addLast(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ2);
                }
                if (iM1293maxInRangejy6DScQ2 >= mainAxisSpacing || iArr10[i35] > mainAxisSpacing) {
                    i11 = 1;
                } else {
                    lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ2.setVisible(false);
                    i11 = 1;
                    z8 = true;
                }
                laneCount2 = i36 != i11 ? lazyStaggeredGridMeasureContext.getLaneCount() : laneCount2;
                i12 = i31;
                str = str2;
                i24 = i32;
                iArrCopyOf = iArr11;
                laneCount = i34;
                iArrCopyOf2 = iArr12;
            }
        }
        int i38 = i12;
        int i39 = i24;
        String str3 = str;
        int[] iArr13 = iArrCopyOf;
        int[] iArr14 = iArrCopyOf2;
        int i40 = laneCount;
        loop9: while (true) {
            int i41 = 0;
            while (true) {
                if (i41 >= length4) {
                    i2 = i40;
                    for (int i42 = 0; i42 < i2; i42++) {
                        if (!arrayDequeArr[i42].isEmpty()) {
                            i3 = itemCount;
                            i4 = 1;
                            break loop9;
                        }
                    }
                    break;
                }
                int i43 = iArr10[i41];
                if (i43 < iCoerceAtLeast || i43 <= 0) {
                    i2 = i40;
                    break;
                }
                i41++;
            }
            i4 = 1;
            int iIndexOfMinValue$default2 = indexOfMinValue$default(iArr10, 0, 1, null);
            int iMaxOrThrow = ArraysKt.maxOrThrow(iArrCopyOf3) + 1;
            i3 = itemCount;
            if (iMaxOrThrow >= i3) {
                break;
            }
            int i44 = iCoerceAtLeast;
            i40 = i2;
            itemCount = i3;
            int i45 = length4;
            int[] iArr15 = iArr10;
            int i46 = i38;
            int[] iArr16 = iArr13;
            int[] iArr17 = iArr14;
            int[] iArr18 = iArrCopyOf3;
            long jM1289getSpanRangelOCCd4c3 = lazyStaggeredGridMeasureContext2.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), iMaxOrThrow, iIndexOfMinValue$default2);
            int i47 = (int) (jM1289getSpanRangelOCCd4c3 & 4294967295L);
            int i48 = (int) (jM1289getSpanRangelOCCd4c3 >> 32);
            int i49 = i47 - i48;
            lazyStaggeredGridMeasureContext.getLaneInfo().setLane(iMaxOrThrow, i49 != 1 ? -2 : i48);
            LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ3 = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(iMaxOrThrow, jM1289getSpanRangelOCCd4c3);
            int iM1293maxInRangejy6DScQ3 = m1293maxInRangejy6DScQ(iArr15, jM1289getSpanRangelOCCd4c3);
            if (i49 != 1) {
                gaps = lazyStaggeredGridMeasureContext.getLaneInfo().getGaps(iMaxOrThrow);
                if (gaps == null) {
                    gaps = new int[lazyStaggeredGridMeasureContext.getLaneCount()];
                }
            } else {
                gaps = null;
            }
            for (int i50 = i48; i50 < i47; i50++) {
                if (gaps != null) {
                    gaps[i50] = iM1293maxInRangejy6DScQ3 - iArr15[i50];
                }
                iArr18[i50] = iMaxOrThrow;
                iArr15[i50] = iM1293maxInRangejy6DScQ3 + lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ3.getMainAxisSizeWithSpacings();
                arrayDequeArr[i50].addLast(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ3);
            }
            lazyStaggeredGridMeasureContext.getLaneInfo().setGaps(iMaxOrThrow, gaps);
            if (iM1293maxInRangejy6DScQ3 < mainAxisSpacing && iArr15[i48] <= mainAxisSpacing) {
                lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ3.setVisible(false);
            }
            iCoerceAtLeast = i44;
            iArr14 = iArr17;
            iArr13 = iArr16;
            iArrCopyOf3 = iArr18;
            i38 = i46;
            length4 = i45;
            iArr10 = iArr15;
        }
        int i51 = 0;
        while (i51 < i2) {
            ArrayDeque arrayDeque = arrayDequeArr[i51];
            while (arrayDeque.size() > i4 && !((LazyStaggeredGridMeasuredItem) arrayDeque.first()).getIsVisible()) {
                LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItem = (LazyStaggeredGridMeasuredItem) arrayDeque.removeFirst();
                int[] gaps3 = lazyStaggeredGridMeasuredItem.getSpan() != i4 ? lazyStaggeredGridMeasureContext.getLaneInfo().getGaps(lazyStaggeredGridMeasuredItem.getIndex()) : null;
                iArr14[i51] = iArr14[i51] - (lazyStaggeredGridMeasuredItem.getMainAxisSizeWithSpacings() + (gaps3 == null ? 0 : gaps3[i51]));
                i4 = 1;
            }
            LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItem2 = (LazyStaggeredGridMeasuredItem) arrayDeque.firstOrNull();
            iArr13[i51] = lazyStaggeredGridMeasuredItem2 != null ? lazyStaggeredGridMeasuredItem2.getIndex() : -1;
            i51++;
            i4 = 1;
        }
        for (int i52 : iArrCopyOf3) {
            if (i52 == i3 - 1) {
                offsetBy(iArr10, -lazyStaggeredGridMeasureContext.getMainAxisSpacing());
                break;
            }
        }
        int i53 = 0;
        while (true) {
            if (i53 < length4) {
                if (iArr10[i53] >= lazyStaggeredGridMeasureContext.getMainAxisAvailableSize()) {
                    iCoerceAtLeast = iCoerceAtLeast;
                    i2 = i2;
                    iArrCopyOf3 = iArrCopyOf3;
                    length4 = length4;
                    iArr5 = iArr10;
                    i5 = i38;
                    iArr4 = iArr13;
                    iArr3 = iArr14;
                    break;
                }
                i53++;
            } else {
                int mainAxisAvailableSize = lazyStaggeredGridMeasureContext.getMainAxisAvailableSize() - iArr10[indexOfMaxValue(iArr10)];
                iArr3 = iArr14;
                offsetBy(iArr3, -mainAxisAvailableSize);
                offsetBy(iArr10, mainAxisAvailableSize);
                boolean z9 = false;
                loop26: while (true) {
                    int length5 = iArr3.length;
                    int i54 = 0;
                    while (true) {
                        if (i54 >= length5) {
                            iArr4 = iArr13;
                            break loop26;
                        }
                        if (iArr3[i54] < lazyStaggeredGridMeasureContext.getBeforeContentPadding()) {
                            break;
                        }
                        i54++;
                        i38 = i38;
                    }
                    int iIndexOfMinValue$default3 = indexOfMinValue$default(iArr3, 0, 1, null);
                    int iIndexOfMaxValue = indexOfMaxValue(iArr13);
                    if (iIndexOfMinValue$default3 != iIndexOfMaxValue) {
                        if (iArr3[iIndexOfMinValue$default3] == iArr3[iIndexOfMaxValue]) {
                            iIndexOfMinValue$default3 = iIndexOfMaxValue;
                        } else {
                            z9 = true;
                        }
                    }
                    int i55 = iArr13[iIndexOfMinValue$default3];
                    if (i55 == -1) {
                        i55 = i3;
                    }
                    int iFindPreviousItemIndex2 = findPreviousItemIndex(lazyStaggeredGridMeasureContext2, i55, iIndexOfMinValue$default3);
                    if (iFindPreviousItemIndex2 < 0) {
                        iArr4 = iArr13;
                        if ((!z9 && !measure$lambda$41$misalignedStart(iArr4, lazyStaggeredGridMeasureContext2, iArr3, iIndexOfMinValue$default3)) || !z) {
                            break;
                        }
                        lazyStaggeredGridMeasureContext.getLaneInfo().reset();
                        int length6 = iArr4.length;
                        int[] iArr19 = new int[length6];
                        for (int i56 = 0; i56 < length6; i56++) {
                            iArr19[i56] = -1;
                        }
                        int length7 = iArr3.length;
                        int[] iArr20 = new int[length7];
                        for (int i57 = 0; i57 < length7; i57++) {
                            iArr20[i57] = iArr3[iIndexOfMinValue$default3];
                        }
                        return measure(lazyStaggeredGridMeasureContext2, i38, iArr19, iArr20, false);
                    }
                    int i58 = i38;
                    int[] iArr21 = iArr13;
                    int[] iArr22 = iArrCopyOf3;
                    long jM1289getSpanRangelOCCd4c4 = lazyStaggeredGridMeasureContext2.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), iFindPreviousItemIndex2, iIndexOfMinValue$default3);
                    int i59 = iCoerceAtLeast;
                    int i60 = i2;
                    int i61 = (int) (jM1289getSpanRangelOCCd4c4 & 4294967295L);
                    int i62 = length4;
                    int[] iArr23 = iArr10;
                    int i63 = (int) (jM1289getSpanRangelOCCd4c4 >> 32);
                    int i64 = i61 - i63;
                    lazyStaggeredGridMeasureContext.getLaneInfo().setLane(iFindPreviousItemIndex2, i64 != 1 ? -2 : i63);
                    LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ4 = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(iFindPreviousItemIndex2, jM1289getSpanRangelOCCd4c4);
                    int iM1293maxInRangejy6DScQ4 = m1293maxInRangejy6DScQ(iArr3, jM1289getSpanRangelOCCd4c4);
                    int[] gaps4 = i64 != 1 ? lazyStaggeredGridMeasureContext.getLaneInfo().getGaps(iFindPreviousItemIndex2) : null;
                    while (i63 < i61) {
                        if (iArr3[i63] != iM1293maxInRangejy6DScQ4) {
                            z9 = true;
                        }
                        arrayDequeArr[i63].addFirst(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ4);
                        iArr21[i63] = iFindPreviousItemIndex2;
                        iArr3[i63] = lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ4.getMainAxisSizeWithSpacings() + iM1293maxInRangejy6DScQ4 + (gaps4 == null ? 0 : gaps4[i63]);
                        i63++;
                    }
                    iArrCopyOf3 = iArr22;
                    iCoerceAtLeast = i59;
                    iArr13 = iArr21;
                    length4 = i62;
                    iArr10 = iArr23;
                    i2 = i60;
                    i38 = i58;
                }
                int[] iArr24 = iArr10;
                if (z9 && z) {
                    lazyStaggeredGridMeasureContext.getLaneInfo().reset();
                    return measure(lazyStaggeredGridMeasureContext2, i38, iArr4, iArr3, false);
                }
                int i65 = mainAxisAvailableSize + i38;
                int i66 = iArr3[indexOfMinValue$default(iArr3, 0, 1, null)];
                if (i66 < 0) {
                    i65 += i66;
                    iArr5 = iArr24;
                    offsetBy(iArr5, i66);
                    offsetBy(iArr3, -i66);
                } else {
                    iArr5 = iArr24;
                }
                i5 = i65;
                break;
            }
        }
        float scrollToBeConsumed = (MathKt.getSign(Math.round(lazyStaggeredGridMeasureContext.getState().getScrollToBeConsumed())) != MathKt.getSign(i5) || Math.abs(Math.round(lazyStaggeredGridMeasureContext.getState().getScrollToBeConsumed())) < Math.abs(i5)) ? lazyStaggeredGridMeasureContext.getState().getScrollToBeConsumed() : i5;
        int[] iArrCopyOf4 = Arrays.copyOf(iArr3, iArr3.length);
        Intrinsics.checkNotNullExpressionValue(iArrCopyOf4, str3);
        int length8 = iArrCopyOf4.length;
        for (int i67 = 0; i67 < length8; i67++) {
            iArrCopyOf4[i67] = -iArrCopyOf4[i67];
        }
        int i68 = i2;
        if (lazyStaggeredGridMeasureContext.getBeforeContentPadding() > lazyStaggeredGridMeasureContext.getMainAxisSpacing()) {
            for (int i69 = 0; i69 < i68; i69++) {
                ArrayDeque arrayDeque2 = arrayDequeArr[i69];
                int size = arrayDeque2.size();
                int i70 = 0;
                while (i70 < size) {
                    LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItem3 = (LazyStaggeredGridMeasuredItem) arrayDeque2.get(i70);
                    int[] gaps5 = lazyStaggeredGridMeasureContext.getLaneInfo().getGaps(lazyStaggeredGridMeasuredItem3.getIndex());
                    int mainAxisSizeWithSpacings2 = lazyStaggeredGridMeasuredItem3.getMainAxisSizeWithSpacings() + (gaps5 == null ? 0 : gaps5[i69]);
                    if (i70 == CollectionsKt.getLastIndex((List) arrayDeque2) || (i10 = iArr3[i69]) == 0 || i10 < mainAxisSizeWithSpacings2) {
                        break;
                    }
                    iArr3[i69] = i10 - mainAxisSizeWithSpacings2;
                    i70++;
                    iArr4[i69] = ((LazyStaggeredGridMeasuredItem) arrayDeque2.get(i70)).getIndex();
                }
            }
        }
        int beforeContentPadding = lazyStaggeredGridMeasureContext.getBeforeContentPadding() + lazyStaggeredGridMeasureContext.getAfterContentPadding();
        if (lazyStaggeredGridMeasureContext.getIsVertical()) {
            i6 = Constraints.getMaxWidth-impl(lazyStaggeredGridMeasureContext.getConstraints());
        } else {
            i6 = ConstraintsKt.constrainWidth-K40F9xA(lazyStaggeredGridMeasureContext.getConstraints(), ArraysKt.maxOrThrow(iArr5) + beforeContentPadding);
        }
        if (lazyStaggeredGridMeasureContext.getIsVertical()) {
            i7 = ConstraintsKt.constrainHeight-K40F9xA(lazyStaggeredGridMeasureContext.getConstraints(), ArraysKt.maxOrThrow(iArr5) + beforeContentPadding);
        } else {
            i7 = Constraints.getMaxHeight-impl(lazyStaggeredGridMeasureContext.getConstraints());
        }
        int iMin = (Math.min(lazyStaggeredGridMeasureContext.getIsVertical() ? i7 : i6, lazyStaggeredGridMeasureContext.getMainAxisAvailableSize()) - lazyStaggeredGridMeasureContext.getBeforeContentPadding()) + lazyStaggeredGridMeasureContext.getAfterContentPadding();
        int mainAxisSizeWithSpacings3 = iArrCopyOf4[0];
        List<Integer> pinnedItems = lazyStaggeredGridMeasureContext.getPinnedItems();
        int size2 = pinnedItems.size() - 1;
        if (size2 >= 0) {
            ArrayList arrayList = null;
            while (true) {
                int i71 = size2 - 1;
                int iIntValue = pinnedItems.get(size2).intValue();
                List<Integer> list2 = pinnedItems;
                int lane = lazyStaggeredGridMeasureContext.getLaneInfo().getLane(iIntValue);
                iArr6 = iArr4;
                if (lane == -2 || lane == -1) {
                    int i72 = 0;
                    while (true) {
                        if (i72 < i68) {
                            LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItem4 = (LazyStaggeredGridMeasuredItem) arrayDequeArr[i72].firstOrNull();
                            if ((lazyStaggeredGridMeasuredItem4 != null ? lazyStaggeredGridMeasuredItem4.getIndex() : -1) > iIntValue) {
                                i72++;
                            }
                        }
                    }
                } else {
                    LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItem5 = (LazyStaggeredGridMeasuredItem) arrayDequeArr[lane].firstOrNull();
                    z6 = (lazyStaggeredGridMeasuredItem5 != null ? lazyStaggeredGridMeasuredItem5.getIndex() : -1) > iIntValue;
                }
                if (z6) {
                    long jM1289getSpanRangelOCCd4c5 = lazyStaggeredGridMeasureContext2.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), iIntValue, 0);
                    if (arrayList == null) {
                        arrayList = new ArrayList();
                    }
                    ArrayList arrayList2 = arrayList;
                    LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ5 = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(iIntValue, jM1289getSpanRangelOCCd4c5);
                    mainAxisSizeWithSpacings3 -= lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ5.getMainAxisSizeWithSpacings();
                    lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ5.position(mainAxisSizeWithSpacings3, 0, iMin);
                    arrayList2.add(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ5);
                    arrayList = arrayList2;
                }
                if (i71 < 0) {
                    break;
                }
                pinnedItems = list2;
                i7 = i7;
                size2 = i71;
                iArr4 = iArr6;
                i68 = i68;
            }
            listEmptyList = arrayList;
        } else {
            i7 = i7;
            iArr6 = iArr4;
            listEmptyList = null;
        }
        if (listEmptyList == null) {
            listEmptyList = CollectionsKt.emptyList();
        }
        List<LazyStaggeredGridMeasuredItem> listCalculateVisibleItems = calculateVisibleItems(lazyStaggeredGridMeasureContext2, arrayDequeArr, iArrCopyOf4, iMin);
        int mainAxisSizeWithSpacings4 = iArrCopyOf4[0];
        List<Integer> pinnedItems2 = lazyStaggeredGridMeasureContext.getPinnedItems();
        int size3 = pinnedItems2.size();
        int i73 = 0;
        ArrayList arrayListEmptyList = null;
        while (i73 < size3) {
            int iIntValue2 = pinnedItems2.get(i73).intValue();
            if (iIntValue2 < i3) {
                int lane2 = lazyStaggeredGridMeasureContext.getLaneInfo().getLane(iIntValue2);
                if (lane2 != -2 && lane2 != -1) {
                    if (iArrCopyOf3[lane2] < iIntValue2) {
                        iArr7 = iArrCopyOf3;
                        list = pinnedItems2;
                    }
                    iArr7 = iArrCopyOf3;
                    list = pinnedItems2;
                    i9 = size3;
                    z5 = false;
                } else {
                    iArr7 = iArrCopyOf3;
                    int length9 = iArr7.length;
                    list = pinnedItems2;
                    int i74 = 0;
                    while (true) {
                        if (i74 < length9) {
                            i9 = size3;
                            if (iArr7[i74] < iIntValue2) {
                                i74++;
                                size3 = i9;
                            } else {
                                z5 = false;
                            }
                        }
                    }
                }
                i9 = size3;
                z5 = true;
            } else {
                iArr7 = iArrCopyOf3;
                list = pinnedItems2;
                i9 = size3;
                z5 = false;
            }
            if (z5) {
                long jM1289getSpanRangelOCCd4c6 = lazyStaggeredGridMeasureContext2.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), iIntValue2, 0);
                if (arrayListEmptyList == null) {
                    arrayListEmptyList = new ArrayList();
                }
                List list3 = arrayListEmptyList;
                LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ6 = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(iIntValue2, jM1289getSpanRangelOCCd4c6);
                lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ6.position(mainAxisSizeWithSpacings4, 0, iMin);
                mainAxisSizeWithSpacings4 += lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ6.getMainAxisSizeWithSpacings();
                list3.add(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ6);
                arrayListEmptyList = list3;
            }
            i73++;
            lazyStaggeredGridMeasureContext2 = lazyStaggeredGridMeasureContext;
            pinnedItems2 = list;
            size3 = i9;
            iArrCopyOf3 = iArr7;
        }
        int[] iArr25 = iArrCopyOf3;
        if (arrayListEmptyList == null) {
            arrayListEmptyList = CollectionsKt.emptyList();
        }
        final ArrayList arrayList3 = new ArrayList();
        arrayList3.addAll(listEmptyList);
        arrayList3.addAll(listCalculateVisibleItems);
        arrayList3.addAll(arrayListEmptyList);
        lazyStaggeredGridMeasureContext.getState().getItemAnimator$foundation_release().onMeasured((int) scrollToBeConsumed, i6, i7, arrayList3, lazyStaggeredGridMeasureContext.getMeasuredItemProvider().getKeyIndexMap(), lazyStaggeredGridMeasureContext.getMeasuredItemProvider(), lazyStaggeredGridMeasureContext.getIsVertical(), false, lazyStaggeredGridMeasureContext.getLaneCount(), false, ArraysKt.minOrThrow(iArr3), ArraysKt.maxOrThrow(iArr5) + beforeContentPadding, lazyStaggeredGridMeasureContext.getCoroutineScope(), lazyStaggeredGridMeasureContext.getGraphicsContext());
        long jM1213getMinSizeToFitDisappearingItemsYbymL2g2 = lazyStaggeredGridMeasureContext.getState().getItemAnimator$foundation_release().m1213getMinSizeToFitDisappearingItemsYbymL2g();
        if (IntSize.equals-impl0(jM1213getMinSizeToFitDisappearingItemsYbymL2g2, IntSize.Companion.getZero-YbymL2g())) {
            i8 = i7;
        } else {
            int i75 = lazyStaggeredGridMeasureContext.getIsVertical() ? i7 : i6;
            i6 = ConstraintsKt.constrainWidth-K40F9xA(lazyStaggeredGridMeasureContext.getConstraints(), Math.max(i6, IntSize.getWidth-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g2)));
            i8 = ConstraintsKt.constrainHeight-K40F9xA(lazyStaggeredGridMeasureContext.getConstraints(), Math.max(i7, IntSize.getHeight-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g2)));
            int i76 = lazyStaggeredGridMeasureContext.getIsVertical() ? i8 : i6;
            if (i76 != i75) {
                int size4 = arrayList3.size();
                for (int i77 = 0; i77 < size4; i77++) {
                    ((LazyStaggeredGridMeasuredItem) arrayList3.get(i77)).updateMainAxisLayoutSize(i76);
                }
            }
        }
        int i78 = length4;
        int i79 = 0;
        while (true) {
            if (i79 >= i78) {
                z2 = false;
                break;
            }
            if (iArr5[i79] > lazyStaggeredGridMeasureContext.getMainAxisAvailableSize()) {
                z2 = true;
                break;
            }
            i79++;
        }
        if (z2) {
            z3 = true;
        } else {
            int length10 = iArr25.length;
            int i80 = 0;
            while (true) {
                if (i80 >= length10) {
                    z4 = true;
                    break;
                }
                if (!(iArr25[i80] < i3 + (-1))) {
                    z4 = false;
                    break;
                }
                i80++;
            }
            if (z4) {
                z3 = true;
            } else {
                z3 = false;
            }
        }
        return new LazyStaggeredGridMeasureResult(iArr6, iArr3, scrollToBeConsumed, MeasureScope.CC.layout$default(measureScope, i6, i8, null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                List<LazyStaggeredGridMeasuredItem> list4 = arrayList3;
                LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext3 = lazyStaggeredGridMeasureContext;
                int size5 = list4.size();
                for (int i81 = 0; i81 < size5; i81++) {
                    list4.get(i81).place(placementScope, lazyStaggeredGridMeasureContext3);
                }
                ObservableScopeInvalidator.m1251attachToScopeimpl(lazyStaggeredGridMeasureContext.getState().m1302getPlacementScopeInvalidatorzYiylxw$foundation_release());
            }
        }, 4, null), z3, lazyStaggeredGridMeasureContext.getIsVertical(), z8, lazyStaggeredGridMeasureContext.getResolvedSlots(), lazyStaggeredGridMeasureContext.getItemProvider().getSpanProvider(), measureScope, i3, listCalculateVisibleItems, IntSizeKt.IntSize(i6, i8), i39, iCoerceAtLeast, lazyStaggeredGridMeasureContext.getBeforeContentPadding(), lazyStaggeredGridMeasureContext.getAfterContentPadding(), lazyStaggeredGridMeasureContext.getMainAxisSpacing(), lazyStaggeredGridMeasureContext.getCoroutineScope(), null);
    }

    private static final boolean measure$lambda$41$hasSpaceBeforeFirst(int[] iArr, int[] iArr2, LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext) {
        int length = iArr.length;
        for (int i = 0; i < length; i++) {
            int i2 = iArr[i];
            if (iArr2[i] < Math.max(-lazyStaggeredGridMeasureContext.getMainAxisSpacing(), 0) && i2 > 0) {
                return true;
            }
        }
        return false;
    }

    private static final boolean measure$lambda$41$misalignedStart(int[] iArr, LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext, int[] iArr2, int i) {
        int length = iArr.length;
        for (int i2 = 0; i2 < length; i2++) {
            if (findPreviousItemIndex(lazyStaggeredGridMeasureContext, iArr[i2], i2) == -1 && iArr2[i2] != iArr2[i]) {
                return true;
            }
        }
        int length2 = iArr.length;
        for (int i3 = 0; i3 < length2; i3++) {
            if (findPreviousItemIndex(lazyStaggeredGridMeasureContext, iArr[i3], i3) != -1 && iArr2[i3] >= iArr2[i]) {
                return true;
            }
        }
        int lane = lazyStaggeredGridMeasureContext.getLaneInfo().getLane(0);
        return (lane == 0 || lane == -1 || lane == -2) ? false : true;
    }

    private static final List<LazyStaggeredGridMeasuredItem> calculateVisibleItems(LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext, ArrayDeque<LazyStaggeredGridMeasuredItem>[] arrayDequeArr, int[] iArr, int i) {
        int size = 0;
        for (ArrayDeque<LazyStaggeredGridMeasuredItem> arrayDeque : arrayDequeArr) {
            size += arrayDeque.size();
        }
        ArrayList arrayList = new ArrayList(size);
        while (true) {
            for (ArrayDeque<LazyStaggeredGridMeasuredItem> arrayDeque2 : arrayDequeArr) {
                if (!((Collection) arrayDeque2).isEmpty()) {
                    int length = arrayDequeArr.length;
                    int i2 = -1;
                    int i3 = Integer.MAX_VALUE;
                    for (int i4 = 0; i4 < length; i4++) {
                        LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItem = (LazyStaggeredGridMeasuredItem) arrayDequeArr[i4].firstOrNull();
                        int index = lazyStaggeredGridMeasuredItem != null ? lazyStaggeredGridMeasuredItem.getIndex() : Integer.MAX_VALUE;
                        if (i3 > index) {
                            i2 = i4;
                            i3 = index;
                        }
                    }
                    LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItem2 = (LazyStaggeredGridMeasuredItem) arrayDequeArr[i2].removeFirst();
                    if (lazyStaggeredGridMeasuredItem2.getLane() == i2) {
                        long jM1305constructorimpl = SpanRange.m1305constructorimpl(lazyStaggeredGridMeasuredItem2.getLane(), lazyStaggeredGridMeasuredItem2.getSpan());
                        int iM1293maxInRangejy6DScQ = m1293maxInRangejy6DScQ(iArr, jM1305constructorimpl);
                        lazyStaggeredGridMeasuredItem2.position(iM1293maxInRangejy6DScQ, lazyStaggeredGridMeasureContext.getResolvedSlots().getPositions()[i2], i);
                        arrayList.add(lazyStaggeredGridMeasuredItem2);
                        int i5 = (int) (jM1305constructorimpl & 4294967295L);
                        for (int i6 = (int) (jM1305constructorimpl >> 32); i6 < i5; i6++) {
                            iArr[i6] = lazyStaggeredGridMeasuredItem2.getMainAxisSizeWithSpacings() + iM1293maxInRangejy6DScQ;
                        }
                    }
                }
            }
            return arrayList;
        }
    }

    private static final List<LazyStaggeredGridMeasuredItem> calculateExtraItems(LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext, Function1<? super LazyStaggeredGridMeasuredItem, Unit> function1, Function1<? super Integer, Boolean> function2, boolean z) {
        List<Integer> pinnedItems = lazyStaggeredGridMeasureContext.getPinnedItems();
        ArrayList arrayList = null;
        if (z) {
            int size = pinnedItems.size() - 1;
            if (size >= 0) {
                while (true) {
                    int i = size - 1;
                    int iIntValue = pinnedItems.get(size).intValue();
                    if (((Boolean) function2.invoke(Integer.valueOf(iIntValue))).booleanValue()) {
                        long jM1289getSpanRangelOCCd4c = lazyStaggeredGridMeasureContext.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), iIntValue, 0);
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                        }
                        LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(iIntValue, jM1289getSpanRangelOCCd4c);
                        function1.invoke(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ);
                        arrayList.add(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ);
                    }
                    if (i < 0) {
                        break;
                    }
                    size = i;
                }
            }
        } else {
            int size2 = pinnedItems.size();
            for (int i2 = 0; i2 < size2; i2++) {
                int iIntValue2 = pinnedItems.get(i2).intValue();
                if (((Boolean) function2.invoke(Integer.valueOf(iIntValue2))).booleanValue()) {
                    long jM1289getSpanRangelOCCd4c2 = lazyStaggeredGridMeasureContext.m1289getSpanRangelOCCd4c(lazyStaggeredGridMeasureContext.getItemProvider(), iIntValue2, 0);
                    if (arrayList == null) {
                        arrayList = new ArrayList();
                    }
                    LazyStaggeredGridMeasuredItem lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ2 = lazyStaggeredGridMeasureContext.getMeasuredItemProvider().m1298getAndMeasurejy6DScQ(iIntValue2, jM1289getSpanRangelOCCd4c2);
                    function1.invoke(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ2);
                    arrayList.add(lazyStaggeredGridMeasuredItemM1298getAndMeasurejy6DScQ2);
                }
            }
        }
        return arrayList == null ? CollectionsKt.emptyList() : arrayList;
    }

    private static final void m1292forEachnIS5qE8(long j, Function1<? super Integer, Unit> function1) {
        int i = (int) (j & 4294967295L);
        for (int i2 = (int) (j >> 32); i2 < i; i2++) {
            function1.invoke(Integer.valueOf(i2));
        }
    }

    private static final void offsetBy(int[] iArr, int i) {
        int length = iArr.length;
        for (int i2 = 0; i2 < length; i2++) {
            iArr[i2] = iArr[i2] + i;
        }
    }

    private static final int m1293maxInRangejy6DScQ(int[] iArr, long j) {
        int i = (int) (j & 4294967295L);
        int iMax = Integer.MIN_VALUE;
        for (int i2 = (int) (j >> 32); i2 < i; i2++) {
            iMax = Math.max(iMax, iArr[i2]);
        }
        return iMax;
    }

    public static int indexOfMinValue$default(int[] iArr, int i, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            i = Integer.MIN_VALUE;
        }
        return indexOfMinValue(iArr, i);
    }

    public static final int indexOfMinValue(int[] iArr, int i) {
        int length = iArr.length;
        int i2 = -1;
        int i3 = Integer.MAX_VALUE;
        for (int i4 = 0; i4 < length; i4++) {
            int i5 = i + 1;
            int i6 = iArr[i4];
            if (i5 <= i6 && i6 < i3) {
                i2 = i4;
                i3 = i6;
            }
        }
        return i2;
    }

    private static final <T> int indexOfMinBy(T[] tArr, Function1<? super T, Integer> function1) {
        int length = tArr.length;
        int i = -1;
        int i2 = Integer.MAX_VALUE;
        for (int i3 = 0; i3 < length; i3++) {
            int iIntValue = ((Number) function1.invoke(tArr[i3])).intValue();
            if (i2 > iIntValue) {
                i = i3;
                i2 = iIntValue;
            }
        }
        return i;
    }

    private static final int indexOfMaxValue(int[] iArr) {
        int length = iArr.length;
        int i = -1;
        int i2 = Integer.MIN_VALUE;
        for (int i3 = 0; i3 < length; i3++) {
            int i4 = iArr[i3];
            if (i2 < i4) {
                i = i3;
                i2 = i4;
            }
        }
        return i;
    }

    private static final int[] transform(int[] iArr, Function1<? super Integer, Integer> function1) {
        int length = iArr.length;
        for (int i = 0; i < length; i++) {
            iArr[i] = ((Number) function1.invoke(Integer.valueOf(iArr[i]))).intValue();
        }
        return iArr;
    }

    private static final void ensureIndicesInRange(LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext, int[] iArr, int i) {
        int length = iArr.length - 1;
        if (length < 0) {
            return;
        }
        while (true) {
            int i2 = length - 1;
            while (true) {
                if (iArr[length] < i && lazyStaggeredGridMeasureContext.getLaneInfo().assignedToLane(iArr[length], length)) {
                    break;
                } else {
                    iArr[length] = findPreviousItemIndex(lazyStaggeredGridMeasureContext, iArr[length], length);
                }
            }
            if (iArr[length] >= 0 && !lazyStaggeredGridMeasureContext.isFullSpan(lazyStaggeredGridMeasureContext.getItemProvider(), iArr[length])) {
                lazyStaggeredGridMeasureContext.getLaneInfo().setLane(iArr[length], length);
            }
            if (i2 < 0) {
                return;
            } else {
                length = i2;
            }
        }
    }

    private static final int findPreviousItemIndex(LazyStaggeredGridMeasureContext lazyStaggeredGridMeasureContext, int i, int i2) {
        return lazyStaggeredGridMeasureContext.getLaneInfo().findPreviousItemIndex(i, i2);
    }

    private static final <T> void fastForEach(List<? extends T> list, boolean z, Function1<? super T, Unit> function1) {
        if (z) {
            int size = list.size() - 1;
            if (size < 0) {
                return;
            }
            while (true) {
                int i = size - 1;
                function1.invoke(list.get(size));
                if (i < 0) {
                    return;
                } else {
                    size = i;
                }
            }
        } else {
            int size2 = list.size();
            for (int i2 = 0; i2 < size2; i2++) {
                function1.invoke(list.get(i2));
            }
        }
    }

    static void fastForEach$default(List list, boolean z, Function1 function1, int i, Object obj) {
        if ((i & 1) != 0) {
            z = false;
        }
        if (z) {
            int size = list.size() - 1;
            if (size < 0) {
                return;
            }
            while (true) {
                int i2 = size - 1;
                function1.invoke(list.get(size));
                if (i2 < 0) {
                    return;
                } else {
                    size = i2;
                }
            }
        } else {
            int size2 = list.size();
            for (int i3 = 0; i3 < size2; i3++) {
                function1.invoke(list.get(i3));
            }
        }
    }
}
