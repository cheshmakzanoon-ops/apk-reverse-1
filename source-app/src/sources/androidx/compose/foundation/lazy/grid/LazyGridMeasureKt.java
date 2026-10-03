package androidx.compose.foundation.lazy.grid;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.lazy.layout.LazyLayoutItemAnimator;
import androidx.compose.foundation.lazy.layout.ObservableScopeInvalidator;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.runtime.MutableState;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.Unit;
import kotlin.collections.ArrayDeque;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.math.MathKt;
import kotlin.ranges.IntProgression;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000¦\u0001\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010!\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0011\n\u0002\b\u0002\u001aA\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00040\u00012\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0012\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u000b0\nH\u0083\b\u001a\u008c\u0001\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00020\r2\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u000f0\u00012\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\u0006\u0010\u0012\u001a\u00020\u00042\u0006\u0010\u0013\u001a\u00020\u00042\u0006\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0015\u001a\u00020\u00042\u0006\u0010\u0016\u001a\u00020\u00042\u0006\u0010\u0017\u001a\u00020\u000b2\b\u0010\u0018\u001a\u0004\u0018\u00010\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\u0006\u0010\u001c\u001a\u00020\u000b2\u0006\u0010\u001d\u001a\u00020\u001eH\u0002\u001a¸\u0002\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\"\u001a\u00020\u00042\u0006\u0010#\u001a\u00020\u00042\u0006\u0010$\u001a\u00020\u00042\u0006\u0010%\u001a\u00020\u00042\u0006\u0010&\u001a\u00020\u00042\u0006\u0010'\u001a\u00020\u00042\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+2\u0006\u0010\u0017\u001a\u00020\u000b2\b\u0010\u0018\u001a\u0004\u0018\u00010\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\u0006\u0010\u001c\u001a\u00020\u000b2\u0006\u0010\u001d\u001a\u00020\u001e2\f\u0010,\u001a\b\u0012\u0004\u0012\u00020\u00020-2\u0006\u0010.\u001a\u00020\u00042\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00040\u00012\u0006\u0010/\u001a\u0002002\u0006\u00101\u001a\u0002022\u0006\u00103\u001a\u00020423\u00105\u001a/\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b6\u0012\b\b7\u0012\u0004\b\b(8\u0012\u0016\u0012\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020+090\u00010\n2/\u0010:\u001a+\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0004\u0012\u0015\u0012\u0013\u0012\u0004\u0012\u00020<\u0012\u0004\u0012\u00020=0\n¢\u0006\u0002\b>\u0012\u0004\u0012\u00020?0;H\u0000ø\u0001\u0000¢\u0006\u0004\b@\u0010A\u001a+\u0010B\u001a\u00020=\"\u0004\b\u0000\u0010C*\b\u0012\u0004\u0012\u0002HC0\r2\f\u0010D\u001a\b\u0012\u0004\u0012\u0002HC0EH\u0002¢\u0006\u0002\u0010F\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006G"}, d2 = {"calculateExtraItems", "", "Landroidx/compose/foundation/lazy/grid/LazyGridMeasuredItem;", "pinnedItems", "", "measuredItemProvider", "Landroidx/compose/foundation/lazy/grid/LazyGridMeasuredItemProvider;", "measuredLineProvider", "Landroidx/compose/foundation/lazy/grid/LazyGridMeasuredLineProvider;", "filter", "Lkotlin/Function1;", "", "calculateItemsOffsets", "", "lines", "Landroidx/compose/foundation/lazy/grid/LazyGridMeasuredLine;", "itemsBefore", "itemsAfter", "layoutWidth", "layoutHeight", "finalMainAxisOffset", "maxOffset", "firstLineScrollOffset", "isVertical", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "reverseLayout", "density", "Landroidx/compose/ui/unit/Density;", "measureLazyGrid", "Landroidx/compose/foundation/lazy/grid/LazyGridMeasureResult;", "itemsCount", "mainAxisAvailableSize", "beforeContentPadding", "afterContentPadding", "spaceBetweenLines", "firstVisibleLineIndex", "firstVisibleLineScrollOffset", "scrollToBeConsumed", "", "constraints", "Landroidx/compose/ui/unit/Constraints;", "itemAnimator", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "slotsPerLine", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "placementScopeInvalidator", "Landroidx/compose/foundation/lazy/layout/ObservableScopeInvalidator;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "prefetchInfoRetriever", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "line", "Lkotlin/Pair;", "layout", "Lkotlin/Function3;", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "", "Lkotlin/ExtensionFunctionType;", "Landroidx/compose/ui/layout/MeasureResult;", "measureLazyGrid-OZKpZRA", "(ILandroidx/compose/foundation/lazy/grid/LazyGridMeasuredLineProvider;Landroidx/compose/foundation/lazy/grid/LazyGridMeasuredItemProvider;IIIIIIFJZLandroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;ZLandroidx/compose/ui/unit/Density;Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;ILjava/util/List;Lkotlinx/coroutines/CoroutineScope;Landroidx/compose/runtime/MutableState;Landroidx/compose/ui/graphics/GraphicsContext;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function3;)Landroidx/compose/foundation/lazy/grid/LazyGridMeasureResult;", "addAllFromArray", "T", "arr", "", "(Ljava/util/List;[Ljava/lang/Object;)V", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyGridMeasureKt {
    private static final int calculateItemsOffsets$reverseAware(int i, boolean z, int i2) {
        return !z ? i : (i2 - i) - 1;
    }

    public static final LazyGridMeasureResult m1186measureLazyGridOZKpZRA(int i, LazyGridMeasuredLineProvider lazyGridMeasuredLineProvider, LazyGridMeasuredItemProvider lazyGridMeasuredItemProvider, int i2, int i3, int i4, int i5, int i6, int i7, float f, long j, boolean z, Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, boolean z2, Density density, LazyLayoutItemAnimator<LazyGridMeasuredItem> lazyLayoutItemAnimator, int i8, List<Integer> list, CoroutineScope coroutineScope, final MutableState<Unit> mutableState, GraphicsContext graphicsContext, Function1<? super Integer, ? extends List<Pair<Integer, Constraints>>> function1, Function3<? super Integer, ? super Integer, ? super Function1<? super Placeable.PlacementScope, Unit>, ? extends MeasureResult> function3) {
        int i9;
        int mainAxisSizeWithSpacings;
        LazyGridMeasuredLine lazyGridMeasuredLine;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        List<LazyGridMeasuredItem> list2;
        LazyGridMeasuredItem[] items;
        LazyGridMeasuredItem lazyGridMeasuredItem;
        int i15;
        if (i3 < 0) {
            throw new IllegalArgumentException("negative beforeContentPadding".toString());
        }
        if (i4 < 0) {
            throw new IllegalArgumentException("negative afterContentPadding".toString());
        }
        if (i <= 0) {
            int i16 = Constraints.getMinWidth-impl(j);
            int i17 = Constraints.getMinHeight-impl(j);
            lazyLayoutItemAnimator.onMeasured(0, i16, i17, new ArrayList(), lazyGridMeasuredItemProvider.getKeyIndexMap(), lazyGridMeasuredItemProvider, z, false, i8, false, 0, 0, coroutineScope, graphicsContext);
            long jM1213getMinSizeToFitDisappearingItemsYbymL2g = lazyLayoutItemAnimator.m1213getMinSizeToFitDisappearingItemsYbymL2g();
            if (!IntSize.equals-impl0(jM1213getMinSizeToFitDisappearingItemsYbymL2g, IntSize.Companion.getZero-YbymL2g())) {
                i16 = ConstraintsKt.constrainWidth-K40F9xA(j, IntSize.getWidth-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g));
                i17 = ConstraintsKt.constrainHeight-K40F9xA(j, IntSize.getHeight-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g));
            }
            return new LazyGridMeasureResult(null, 0, false, 0.0f, (MeasureResult) function3.invoke(Integer.valueOf(i16), Integer.valueOf(i17), new Function1<Placeable.PlacementScope, Unit>() {
                public final void invoke(Placeable.PlacementScope placementScope) {
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }
            }), false, coroutineScope, density, i8, function1, CollectionsKt.emptyList(), -i3, i2 + i4, 0, z2, z ? Orientation.Vertical : Orientation.Horizontal, i4, i5);
        }
        int iRound = Math.round(f);
        int i18 = i7 - iRound;
        if (i6 == 0 && i18 < 0) {
            iRound += i18;
            i18 = 0;
        }
        List arrayDeque = new ArrayDeque();
        int i19 = -i3;
        int i20 = (i5 < 0 ? i5 : 0) + i19;
        int mainAxisSizeWithSpacings2 = i18 + i20;
        int i21 = i6;
        while (mainAxisSizeWithSpacings2 < 0 && i21 > 0) {
            i21--;
            LazyGridMeasuredLine andMeasure = lazyGridMeasuredLineProvider.getAndMeasure(i21);
            arrayDeque.add(0, andMeasure);
            mainAxisSizeWithSpacings2 += andMeasure.getMainAxisSizeWithSpacings();
        }
        if (mainAxisSizeWithSpacings2 < i20) {
            iRound += mainAxisSizeWithSpacings2;
            mainAxisSizeWithSpacings2 = i20;
        }
        int i22 = mainAxisSizeWithSpacings2 - i20;
        int i23 = i2 + i4;
        int i24 = i21;
        int iCoerceAtLeast = RangesKt.coerceAtLeast(i23, 0);
        int i25 = i24;
        int mainAxisSizeWithSpacings3 = i22;
        int mainAxisSizeWithSpacings4 = -i22;
        int i26 = 0;
        boolean z3 = false;
        while (i26 < arrayDeque.size()) {
            if (mainAxisSizeWithSpacings4 >= iCoerceAtLeast) {
                arrayDeque.remove(i26);
                z3 = true;
            } else {
                i25++;
                mainAxisSizeWithSpacings4 += ((LazyGridMeasuredLine) arrayDeque.get(i26)).getMainAxisSizeWithSpacings();
                i26++;
            }
        }
        int mainAxisSizeWithSpacings5 = mainAxisSizeWithSpacings4;
        int i27 = i25;
        int i28 = i24;
        while (i27 < i && (mainAxisSizeWithSpacings5 < iCoerceAtLeast || mainAxisSizeWithSpacings5 <= 0 || arrayDeque.isEmpty())) {
            int i29 = iCoerceAtLeast;
            LazyGridMeasuredLine andMeasure2 = lazyGridMeasuredLineProvider.getAndMeasure(i27);
            if (andMeasure2.isEmpty()) {
                break;
            }
            mainAxisSizeWithSpacings5 += andMeasure2.getMainAxisSizeWithSpacings();
            if (mainAxisSizeWithSpacings5 <= i20) {
                i15 = i20;
                if (((LazyGridMeasuredItem) ArraysKt.last(andMeasure2.getItems())).getIndex() != i - 1) {
                    mainAxisSizeWithSpacings3 -= andMeasure2.getMainAxisSizeWithSpacings();
                    i28 = i27 + 1;
                    z3 = true;
                }
                i27++;
                iCoerceAtLeast = i29;
                i20 = i15;
            } else {
                i15 = i20;
            }
            arrayDeque.add(andMeasure2);
            i28 = i28;
            i27++;
            iCoerceAtLeast = i29;
            i20 = i15;
        }
        int i30 = i28;
        if (mainAxisSizeWithSpacings5 < i2) {
            int i31 = i2 - mainAxisSizeWithSpacings5;
            int i32 = mainAxisSizeWithSpacings5 + i31;
            mainAxisSizeWithSpacings = mainAxisSizeWithSpacings3 - i31;
            int i33 = i30;
            while (mainAxisSizeWithSpacings < i3 && i33 > 0) {
                int i34 = i33 - 1;
                LazyGridMeasuredLine andMeasure3 = lazyGridMeasuredLineProvider.getAndMeasure(i34);
                arrayDeque.add(0, andMeasure3);
                mainAxisSizeWithSpacings += andMeasure3.getMainAxisSizeWithSpacings();
                i33 = i34;
            }
            iRound += i31;
            if (mainAxisSizeWithSpacings < 0) {
                iRound += mainAxisSizeWithSpacings;
                i9 = i32 + mainAxisSizeWithSpacings;
                mainAxisSizeWithSpacings = 0;
            } else {
                i9 = i32;
            }
        } else {
            i9 = mainAxisSizeWithSpacings5;
            mainAxisSizeWithSpacings = mainAxisSizeWithSpacings3;
        }
        float f2 = (MathKt.getSign(Math.round(f)) != MathKt.getSign(iRound) || Math.abs(Math.round(f)) < Math.abs(iRound)) ? f : iRound;
        if (mainAxisSizeWithSpacings < 0) {
            throw new IllegalArgumentException("negative initial offset".toString());
        }
        int i35 = -mainAxisSizeWithSpacings;
        LazyGridMeasuredLine lazyGridMeasuredLine2 = (LazyGridMeasuredLine) arrayDeque.first();
        LazyGridMeasuredItem lazyGridMeasuredItem2 = (LazyGridMeasuredItem) ArraysKt.firstOrNull(lazyGridMeasuredLine2.getItems());
        int index = lazyGridMeasuredItem2 != null ? lazyGridMeasuredItem2.getIndex() : 0;
        LazyGridMeasuredLine lazyGridMeasuredLine3 = (LazyGridMeasuredLine) arrayDeque.lastOrNull();
        int index2 = (lazyGridMeasuredLine3 == null || (items = lazyGridMeasuredLine3.getItems()) == null || (lazyGridMeasuredItem = (LazyGridMeasuredItem) ArraysKt.lastOrNull(items)) == null) ? 0 : lazyGridMeasuredItem.getIndex();
        int size = list.size();
        ArrayList arrayListEmptyList = null;
        int i36 = mainAxisSizeWithSpacings;
        List listEmptyList = null;
        int i37 = 0;
        while (i37 < size) {
            int i38 = size;
            int iIntValue = list.get(i37).intValue();
            if (iIntValue >= 0 && iIntValue < index) {
                int iSpanOf = lazyGridMeasuredLineProvider.spanOf(iIntValue);
                LazyGridMeasuredItem lazyGridMeasuredItemMo1153getAndMeasurehBUhpc = lazyGridMeasuredItemProvider.mo1153getAndMeasurehBUhpc(iIntValue, 0, iSpanOf, lazyGridMeasuredLineProvider.m1190childConstraintsJhjzzOo$foundation_release(0, iSpanOf));
                ArrayList arrayList = listEmptyList == null ? new ArrayList() : listEmptyList;
                arrayList.add(lazyGridMeasuredItemMo1153getAndMeasurehBUhpc);
                listEmptyList = arrayList;
            }
            i37++;
            size = i38;
            index = index;
            f2 = f2;
        }
        int i39 = index;
        float f3 = f2;
        if (listEmptyList == null) {
            listEmptyList = CollectionsKt.emptyList();
        }
        List list3 = listEmptyList;
        int size2 = list.size();
        for (int i40 = 0; i40 < size2; i40++) {
            int iIntValue2 = list.get(i40).intValue();
            if (index2 + 1 <= iIntValue2 && iIntValue2 < i) {
                int iSpanOf2 = lazyGridMeasuredLineProvider.spanOf(iIntValue2);
                LazyGridMeasuredItem lazyGridMeasuredItemMo1153getAndMeasurehBUhpc2 = lazyGridMeasuredItemProvider.mo1153getAndMeasurehBUhpc(iIntValue2, 0, iSpanOf2, lazyGridMeasuredLineProvider.m1190childConstraintsJhjzzOo$foundation_release(0, iSpanOf2));
                if (arrayListEmptyList == null) {
                    arrayListEmptyList = new ArrayList();
                }
                List list4 = arrayListEmptyList;
                list4.add(lazyGridMeasuredItemMo1153getAndMeasurehBUhpc2);
                arrayListEmptyList = list4;
            }
        }
        if (arrayListEmptyList == null) {
            arrayListEmptyList = CollectionsKt.emptyList();
        }
        if (i3 > 0 || i5 < 0) {
            int size3 = arrayDeque.size();
            LazyGridMeasuredLine lazyGridMeasuredLine4 = lazyGridMeasuredLine2;
            int i41 = 0;
            int i42 = i36;
            while (i41 < size3) {
                int mainAxisSizeWithSpacings6 = ((LazyGridMeasuredLine) arrayDeque.get(i41)).getMainAxisSizeWithSpacings();
                if (i42 == 0 || mainAxisSizeWithSpacings6 > i42 || i41 == CollectionsKt.getLastIndex(arrayDeque)) {
                    break;
                }
                i42 -= mainAxisSizeWithSpacings6;
                i41++;
                lazyGridMeasuredLine4 = (LazyGridMeasuredLine) arrayDeque.get(i41);
            }
            lazyGridMeasuredLine = lazyGridMeasuredLine4;
            i10 = i42;
        } else {
            i10 = i36;
            lazyGridMeasuredLine = lazyGridMeasuredLine2;
        }
        if (z) {
            i11 = Constraints.getMaxWidth-impl(j);
        } else {
            i11 = ConstraintsKt.constrainWidth-K40F9xA(j, i9);
        }
        int i43 = i11;
        if (z) {
            i12 = ConstraintsKt.constrainHeight-K40F9xA(j, i9);
        } else {
            i12 = Constraints.getMaxHeight-impl(j);
        }
        int i44 = i12;
        int i45 = i39;
        int i46 = i9;
        int i47 = index2;
        final List<LazyGridMeasuredItem> listCalculateItemsOffsets = calculateItemsOffsets(arrayDeque, list3, arrayListEmptyList, i43, i44, i9, i2, i35, z, vertical, horizontal, z2, density);
        lazyLayoutItemAnimator.onMeasured((int) f3, i43, i44, listCalculateItemsOffsets, lazyGridMeasuredItemProvider.getKeyIndexMap(), lazyGridMeasuredItemProvider, z, false, i8, false, i10, i46, coroutineScope, graphicsContext);
        long jM1213getMinSizeToFitDisappearingItemsYbymL2g2 = lazyLayoutItemAnimator.m1213getMinSizeToFitDisappearingItemsYbymL2g();
        if (IntSize.equals-impl0(jM1213getMinSizeToFitDisappearingItemsYbymL2g2, IntSize.Companion.getZero-YbymL2g())) {
            i13 = i44;
            i14 = i43;
        } else {
            int i48 = z ? i44 : i43;
            int i49 = ConstraintsKt.constrainWidth-K40F9xA(j, Math.max(i43, IntSize.getWidth-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g2)));
            i13 = ConstraintsKt.constrainHeight-K40F9xA(j, Math.max(i44, IntSize.getHeight-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g2)));
            int i50 = z ? i13 : i49;
            if (i50 != i48) {
                int size4 = listCalculateItemsOffsets.size();
                for (int i51 = 0; i51 < size4; i51++) {
                    listCalculateItemsOffsets.get(i51).updateMainAxisLayoutSize(i50);
                }
            }
            i14 = i49;
        }
        boolean z4 = i47 != i + (-1) || i46 > i2;
        MeasureResult measureResult = (MeasureResult) function3.invoke(Integer.valueOf(i14), Integer.valueOf(i13), new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                List<LazyGridMeasuredItem> list5 = listCalculateItemsOffsets;
                int size5 = list5.size();
                for (int i52 = 0; i52 < size5; i52++) {
                    list5.get(i52).place(placementScope);
                }
                ObservableScopeInvalidator.m1251attachToScopeimpl(mutableState);
            }
        });
        if (list3.isEmpty() && arrayListEmptyList.isEmpty()) {
            list2 = listCalculateItemsOffsets;
        } else {
            ArrayList arrayList2 = new ArrayList(listCalculateItemsOffsets.size());
            int size5 = listCalculateItemsOffsets.size();
            int i52 = 0;
            while (i52 < size5) {
                LazyGridMeasuredItem lazyGridMeasuredItem3 = listCalculateItemsOffsets.get(i52);
                int index3 = lazyGridMeasuredItem3.getIndex();
                int i53 = i45;
                if (i53 <= index3 && index3 <= i47) {
                    arrayList2.add(lazyGridMeasuredItem3);
                }
                i52++;
                i45 = i53;
            }
            list2 = arrayList2;
        }
        return new LazyGridMeasureResult(lazyGridMeasuredLine, i10, z4, f3, measureResult, z3, coroutineScope, density, i8, function1, list2, i19, i23, i, z2, z ? Orientation.Vertical : Orientation.Horizontal, i4, i5);
    }

    private static final List<LazyGridMeasuredItem> calculateItemsOffsets(List<LazyGridMeasuredLine> list, List<LazyGridMeasuredItem> list2, List<LazyGridMeasuredItem> list3, int i, int i2, int i3, int i4, int i5, boolean z, Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, boolean z2, Density density) {
        int i6 = z ? i2 : i;
        boolean z3 = i3 < Math.min(i6, i4);
        if (z3 && i5 != 0) {
            throw new IllegalStateException("non-zero firstLineScrollOffset".toString());
        }
        int size = list.size();
        int length = 0;
        for (int i7 = 0; i7 < size; i7++) {
            length += list.get(i7).getItems().length;
        }
        ArrayList arrayList = new ArrayList(length);
        if (z3) {
            if (!list2.isEmpty() || !list3.isEmpty()) {
                throw new IllegalArgumentException("no items".toString());
            }
            int size2 = list.size();
            int[] iArr = new int[size2];
            for (int i8 = 0; i8 < size2; i8++) {
                iArr[i8] = list.get(calculateItemsOffsets$reverseAware(i8, z2, size2)).getMainAxisSize();
            }
            int[] iArr2 = new int[size2];
            for (int i9 = 0; i9 < size2; i9++) {
                iArr2[i9] = 0;
            }
            if (z) {
                if (vertical == null) {
                    throw new IllegalArgumentException("null verticalArrangement".toString());
                }
                vertical.arrange(density, i6, iArr, iArr2);
            } else {
                if (horizontal == null) {
                    throw new IllegalArgumentException("null horizontalArrangement".toString());
                }
                horizontal.arrange(density, i6, iArr, LayoutDirection.Ltr, iArr2);
            }
            IntProgression indices = ArraysKt.getIndices(iArr2);
            if (z2) {
                indices = RangesKt.reversed(indices);
            }
            int first = indices.getFirst();
            int last = indices.getLast();
            int step = indices.getStep();
            if ((step > 0 && first <= last) || (step < 0 && last <= first)) {
                while (true) {
                    int mainAxisSize = iArr2[first];
                    LazyGridMeasuredLine lazyGridMeasuredLine = list.get(calculateItemsOffsets$reverseAware(first, z2, size2));
                    if (z2) {
                        mainAxisSize = (i6 - mainAxisSize) - lazyGridMeasuredLine.getMainAxisSize();
                    }
                    addAllFromArray(arrayList, lazyGridMeasuredLine.position(mainAxisSize, i, i2));
                    if (first == last) {
                        break;
                    }
                    first += step;
                }
            }
        } else {
            int size3 = list2.size() - 1;
            if (size3 >= 0) {
                int mainAxisSizeWithSpacings = i5;
                while (true) {
                    int i10 = size3 - 1;
                    LazyGridMeasuredItem lazyGridMeasuredItem = list2.get(size3);
                    mainAxisSizeWithSpacings -= lazyGridMeasuredItem.getMainAxisSizeWithSpacings();
                    lazyGridMeasuredItem.position(mainAxisSizeWithSpacings, 0, i, i2);
                    arrayList.add(lazyGridMeasuredItem);
                    if (i10 < 0) {
                        break;
                    }
                    size3 = i10;
                }
            }
            int size4 = list.size();
            int mainAxisSizeWithSpacings2 = i5;
            for (int i11 = 0; i11 < size4; i11++) {
                LazyGridMeasuredLine lazyGridMeasuredLine2 = list.get(i11);
                addAllFromArray(arrayList, lazyGridMeasuredLine2.position(mainAxisSizeWithSpacings2, i, i2));
                mainAxisSizeWithSpacings2 += lazyGridMeasuredLine2.getMainAxisSizeWithSpacings();
            }
            int size5 = list3.size();
            for (int i12 = 0; i12 < size5; i12++) {
                LazyGridMeasuredItem lazyGridMeasuredItem2 = list3.get(i12);
                lazyGridMeasuredItem2.position(mainAxisSizeWithSpacings2, 0, i, i2);
                arrayList.add(lazyGridMeasuredItem2);
                mainAxisSizeWithSpacings2 += lazyGridMeasuredItem2.getMainAxisSizeWithSpacings();
            }
        }
        return arrayList;
    }

    private static final <T> void addAllFromArray(List<T> list, T[] tArr) {
        for (T t : tArr) {
            list.add(t);
        }
    }

    private static final List<LazyGridMeasuredItem> calculateExtraItems(List<Integer> list, LazyGridMeasuredItemProvider lazyGridMeasuredItemProvider, LazyGridMeasuredLineProvider lazyGridMeasuredLineProvider, Function1<? super Integer, Boolean> function1) {
        int size = list.size();
        ArrayList arrayList = null;
        for (int i = 0; i < size; i++) {
            int iIntValue = list.get(i).intValue();
            if (((Boolean) function1.invoke(Integer.valueOf(iIntValue))).booleanValue()) {
                int iSpanOf = lazyGridMeasuredLineProvider.spanOf(iIntValue);
                LazyGridMeasuredItem lazyGridMeasuredItemMo1153getAndMeasurehBUhpc = lazyGridMeasuredItemProvider.mo1153getAndMeasurehBUhpc(iIntValue, 0, iSpanOf, lazyGridMeasuredLineProvider.m1190childConstraintsJhjzzOo$foundation_release(0, iSpanOf));
                if (arrayList == null) {
                    arrayList = new ArrayList();
                }
                arrayList.add(lazyGridMeasuredItemMo1153getAndMeasurehBUhpc);
            }
        }
        return arrayList == null ? CollectionsKt.emptyList() : arrayList;
    }
}
