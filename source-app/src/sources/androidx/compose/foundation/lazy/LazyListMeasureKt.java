package androidx.compose.foundation.lazy;

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
import kotlin.Unit;
import kotlin.collections.ArrayDeque;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.IntProgression;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u0096\u0001\n\u0000\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u008c\u0001\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00020\u00042\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\b2\u0006\u0010\n\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\b2\u0006\u0010\r\u001a\u00020\u000e2\b\u0010\u000f\u001a\u0004\u0018\u00010\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u00122\u0006\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u0015H\u0002\u001a\\\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00020\u00042\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\b2\u0006\u0010\u001b\u001a\u00020\b2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\b0\u00042\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u000e2\b\u0010 \u001a\u0004\u0018\u00010!H\u0002\u001a4\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00020\u00042\u0006\u0010#\u001a\u00020\b2\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001b\u001a\u00020\b2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\b0\u0004H\u0002\u001a£\u0002\u0010$\u001a\u00020%2\u0006\u0010\u001a\u001a\u00020\b2\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010&\u001a\u00020\b2\u0006\u0010'\u001a\u00020\b2\u0006\u0010(\u001a\u00020\b2\u0006\u0010)\u001a\u00020\b2\u0006\u0010*\u001a\u00020\b2\u0006\u0010+\u001a\u00020\b2\u0006\u0010,\u001a\u00020\u001e2\u0006\u0010-\u001a\u00020.2\u0006\u0010\r\u001a\u00020\u000e2\f\u0010/\u001a\b\u0012\u0004\u0012\u00020\b0\u00042\b\u0010\u000f\u001a\u0004\u0018\u00010\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u00122\u0006\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u00152\f\u00100\u001a\b\u0012\u0004\u0012\u00020\u0002012\u0006\u0010\u001b\u001a\u00020\b2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\b0\u00042\u0006\u00102\u001a\u00020\u000e2\u0006\u0010\u001f\u001a\u00020\u000e2\b\u00103\u001a\u0004\u0018\u00010!2\u0006\u00104\u001a\u0002052\u0006\u00106\u001a\u0002072\u0006\u00108\u001a\u0002092/\u0010:\u001a+\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\b\u0012\u0015\u0012\u0013\u0012\u0004\u0012\u00020=\u0012\u0004\u0012\u00020>0<¢\u0006\u0002\b?\u0012\u0004\u0012\u00020@0;H\u0000ø\u0001\u0000¢\u0006\u0004\bA\u0010B\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006C"}, d2 = {"calculateItemsOffsets", "", "Landroidx/compose/foundation/lazy/LazyListMeasuredItem;", "items", "", "extraItemsBefore", "extraItemsAfter", "layoutWidth", "", "layoutHeight", "finalMainAxisOffset", "maxOffset", "itemsScrollOffset", "isVertical", "", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "reverseLayout", "density", "Landroidx/compose/ui/unit/Density;", "createItemsAfterList", "visibleItems", "measuredItemProvider", "Landroidx/compose/foundation/lazy/LazyListMeasuredItemProvider;", "itemsCount", "beyondBoundsItemCount", "pinnedItems", "consumedScroll", "", "isLookingAhead", "lastPostLookaheadLayoutInfo", "Landroidx/compose/foundation/lazy/LazyListLayoutInfo;", "createItemsBeforeList", "currentFirstItemIndex", "measureLazyList", "Landroidx/compose/foundation/lazy/LazyListMeasureResult;", "mainAxisAvailableSize", "beforeContentPadding", "afterContentPadding", "spaceBetweenItems", "firstVisibleItemIndex", "firstVisibleItemScrollOffset", "scrollToBeConsumed", "constraints", "Landroidx/compose/ui/unit/Constraints;", "headerIndexes", "itemAnimator", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "hasLookaheadPassOccurred", "postLookaheadLayoutInfo", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "placementScopeInvalidator", "Landroidx/compose/foundation/lazy/layout/ObservableScopeInvalidator;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "layout", "Lkotlin/Function3;", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "", "Lkotlin/ExtensionFunctionType;", "Landroidx/compose/ui/layout/MeasureResult;", "measureLazyList-x0Ok8Vo", "(ILandroidx/compose/foundation/lazy/LazyListMeasuredItemProvider;IIIIIIFJZLjava/util/List;Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;ZLandroidx/compose/ui/unit/Density;Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;ILjava/util/List;ZZLandroidx/compose/foundation/lazy/LazyListLayoutInfo;Lkotlinx/coroutines/CoroutineScope;Landroidx/compose/runtime/MutableState;Landroidx/compose/ui/graphics/GraphicsContext;Lkotlin/jvm/functions/Function3;)Landroidx/compose/foundation/lazy/LazyListMeasureResult;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyListMeasureKt {
    private static final int calculateItemsOffsets$reverseAware(int i, boolean z, int i2) {
        return !z ? i : (i2 - i) - 1;
    }

    public static final LazyListMeasureResult m1146measureLazyListx0Ok8Vo(int i, LazyListMeasuredItemProvider lazyListMeasuredItemProvider, int i2, int i3, int i4, int i5, int i6, int i7, float f, long j, boolean z, List<Integer> list, Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, boolean z2, Density density, LazyLayoutItemAnimator<LazyListMeasuredItem> lazyLayoutItemAnimator, int i8, List<Integer> list2, boolean z3, boolean z4, LazyListLayoutInfo lazyListLayoutInfo, CoroutineScope coroutineScope, final MutableState<Unit> mutableState, GraphicsContext graphicsContext, Function3<? super Integer, ? super Integer, ? super Function1<? super Placeable.PlacementScope, Unit>, ? extends MeasureResult> function3) {
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        LazyListMeasuredItem lazyListMeasuredItem;
        int i19;
        final boolean z5;
        boolean z6;
        int size;
        int i20;
        List<LazyListMeasuredItem> list3;
        LazyListMeasuredItem lazyListMeasuredItem2;
        Orientation orientation;
        int i21;
        if (i3 < 0) {
            throw new IllegalArgumentException("invalid beforeContentPadding".toString());
        }
        if (i4 < 0) {
            throw new IllegalArgumentException("invalid afterContentPadding".toString());
        }
        if (i <= 0) {
            int i22 = Constraints.getMinWidth-impl(j);
            int i23 = Constraints.getMinHeight-impl(j);
            lazyLayoutItemAnimator.onMeasured(0, i22, i23, new ArrayList(), lazyListMeasuredItemProvider.getKeyIndexMap(), lazyListMeasuredItemProvider, z, z4, 1, z3, 0, 0, coroutineScope, graphicsContext);
            if (!z4) {
                long jM1213getMinSizeToFitDisappearingItemsYbymL2g = lazyLayoutItemAnimator.m1213getMinSizeToFitDisappearingItemsYbymL2g();
                if (!IntSize.equals-impl0(jM1213getMinSizeToFitDisappearingItemsYbymL2g, IntSize.Companion.getZero-YbymL2g())) {
                    i22 = ConstraintsKt.constrainWidth-K40F9xA(j, IntSize.getWidth-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g));
                    i23 = ConstraintsKt.constrainHeight-K40F9xA(j, IntSize.getHeight-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g));
                }
            }
            return new LazyListMeasureResult(null, 0, false, 0.0f, (MeasureResult) function3.invoke(Integer.valueOf(i22), Integer.valueOf(i23), new Function1<Placeable.PlacementScope, Unit>() {
                public final void invoke(Placeable.PlacementScope placementScope) {
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }
            }), 0.0f, false, coroutineScope, density, lazyListMeasuredItemProvider.getChildConstraints(), CollectionsKt.emptyList(), -i3, i2 + i4, 0, z2, z ? Orientation.Vertical : Orientation.Horizontal, i4, i5, null);
        }
        int i24 = i6;
        if (i24 >= i) {
            i24 = i - 1;
            i9 = 0;
        } else {
            i9 = i7;
        }
        int iRound = Math.round(f);
        int i25 = i9 - iRound;
        if (i24 != 0 || i25 >= 0) {
            i10 = iRound;
        } else {
            i10 = iRound + i25;
            i25 = 0;
        }
        List arrayDeque = new ArrayDeque();
        int i26 = -i3;
        int i27 = i26 + (i5 < 0 ? i5 : 0);
        int mainAxisSizeWithSpacings = i25 + i27;
        int iMax = 0;
        while (mainAxisSizeWithSpacings < 0 && i24 > 0) {
            int i28 = i24 - 1;
            LazyListMeasuredItem lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default = LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, i28, 0L, 2, null);
            arrayDeque.add(0, lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default);
            iMax = Math.max(iMax, lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default.getCrossAxisSize());
            mainAxisSizeWithSpacings += lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default.getMainAxisSizeWithSpacings();
            i24 = i28;
            i27 = i27;
            i26 = i26;
        }
        int i29 = mainAxisSizeWithSpacings;
        int i30 = iMax;
        int i31 = i26;
        int i32 = i27;
        if (i29 < i32) {
            i10 += i29;
            i11 = i32;
        } else {
            i11 = i29;
        }
        int i33 = i11 - i32;
        int i34 = i2 + i4;
        int iCoerceAtLeast = RangesKt.coerceAtLeast(i34, 0);
        int mainAxisSizeWithSpacings2 = -i33;
        int i35 = i24;
        int i36 = i35;
        int i37 = i30;
        int i38 = 0;
        boolean z7 = false;
        while (i38 < arrayDeque.size()) {
            if (mainAxisSizeWithSpacings2 >= iCoerceAtLeast) {
                arrayDeque.remove(i38);
                z7 = true;
            } else {
                i36++;
                mainAxisSizeWithSpacings2 += ((LazyListMeasuredItem) arrayDeque.get(i38)).getMainAxisSizeWithSpacings();
                i38++;
            }
        }
        int i39 = i36;
        boolean z8 = z7;
        int mainAxisSizeWithSpacings3 = i33;
        int mainAxisSizeWithSpacings4 = mainAxisSizeWithSpacings2;
        int i40 = i35;
        while (i39 < i && (mainAxisSizeWithSpacings4 < iCoerceAtLeast || mainAxisSizeWithSpacings4 <= 0 || arrayDeque.isEmpty())) {
            int i41 = iCoerceAtLeast;
            int i42 = i39;
            int i43 = i34;
            int i44 = i37;
            int i45 = i32;
            LazyListMeasuredItem lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default2 = LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, i39, 0L, 2, null);
            mainAxisSizeWithSpacings4 += lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default2.getMainAxisSizeWithSpacings();
            if (mainAxisSizeWithSpacings4 <= i45) {
                i21 = i42;
                if (i21 != i - 1) {
                    mainAxisSizeWithSpacings3 -= lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default2.getMainAxisSizeWithSpacings();
                    i40 = i21 + 1;
                    z8 = true;
                    i37 = i44;
                }
                i39 = i21 + 1;
                i32 = i45;
                iCoerceAtLeast = i41;
                i34 = i43;
            } else {
                i21 = i42;
            }
            int iMax2 = Math.max(i44, lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default2.getCrossAxisSize());
            arrayDeque.add(lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default2);
            i37 = iMax2;
            i39 = i21 + 1;
            i32 = i45;
            iCoerceAtLeast = i41;
            i34 = i43;
        }
        int i46 = i39;
        int i47 = i34;
        int i48 = mainAxisSizeWithSpacings4;
        int i49 = i37;
        if (i48 < i2) {
            int i50 = i2 - i48;
            i15 = i48 + i50;
            int i51 = i49;
            int mainAxisSizeWithSpacings5 = mainAxisSizeWithSpacings3 - i50;
            while (mainAxisSizeWithSpacings5 < i3 && i40 > 0) {
                int i52 = i40 - 1;
                LazyListMeasuredItem lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default3 = LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, i52, 0L, 2, null);
                arrayDeque.add(0, lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default3);
                int iMax3 = Math.max(i51, lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default3.getCrossAxisSize());
                mainAxisSizeWithSpacings5 += lazyListMeasuredItemM1152getAndMeasure0kLqBqw$default3.getMainAxisSizeWithSpacings();
                i51 = iMax3;
                i46 = i46;
                i40 = i52;
            }
            i12 = i40;
            int i53 = i51;
            int i54 = mainAxisSizeWithSpacings5;
            i13 = i46;
            i14 = 0;
            i17 = i50 + i10;
            if (i54 < 0) {
                i17 += i54;
                int i55 = i15 + i54;
                i16 = i53;
                i15 = i55;
                i18 = 0;
            } else {
                i18 = i54;
                i16 = i53;
            }
        } else {
            i12 = i40;
            i13 = i46;
            i14 = 0;
            i15 = i48;
            i16 = i49;
            i17 = i10;
            i18 = mainAxisSizeWithSpacings3;
        }
        float f2 = (MathKt.getSign(Math.round(f)) != MathKt.getSign(i17) || Math.abs(Math.round(f)) < Math.abs(i17)) ? f : i17;
        float f3 = f - f2;
        float f4 = 0.0f;
        if (z4 && i17 > i10 && f3 <= 0.0f) {
            f4 = (i17 - i10) + f3;
        }
        float f5 = f4;
        if (i18 < 0) {
            throw new IllegalArgumentException("negative currentFirstItemScrollOffset".toString());
        }
        int i56 = -i18;
        LazyListMeasuredItem lazyListMeasuredItem3 = (LazyListMeasuredItem) arrayDeque.first();
        if (i3 > 0 || i5 < 0) {
            int size2 = arrayDeque.size();
            int i57 = i14;
            while (true) {
                if (i57 < size2) {
                    int mainAxisSizeWithSpacings6 = ((LazyListMeasuredItem) arrayDeque.get(i57)).getMainAxisSizeWithSpacings();
                    if (i18 != 0 && mainAxisSizeWithSpacings6 <= i18) {
                        if (i57 == CollectionsKt.getLastIndex(arrayDeque)) {
                            break;
                        }
                        i18 -= mainAxisSizeWithSpacings6;
                        i57++;
                        lazyListMeasuredItem3 = (LazyListMeasuredItem) arrayDeque.get(i57);
                    }
                }
                break;
            }
            lazyListMeasuredItem = lazyListMeasuredItem3;
            i19 = i18;
        } else {
            i19 = i18;
            lazyListMeasuredItem = lazyListMeasuredItem3;
        }
        List<LazyListMeasuredItem> listCreateItemsBeforeList = createItemsBeforeList(i12, lazyListMeasuredItemProvider, i8, list2);
        int iMax4 = i16;
        int i58 = 0;
        for (int size3 = listCreateItemsBeforeList.size(); i58 < size3; size3 = size3) {
            iMax4 = Math.max(iMax4, listCreateItemsBeforeList.get(i58).getCrossAxisSize());
            i58++;
        }
        List list4 = arrayDeque;
        int i59 = iMax4;
        float f6 = f2;
        LazyListMeasuredItem lazyListMeasuredItem4 = lazyListMeasuredItem;
        int i60 = i15;
        List<LazyListMeasuredItem> listCreateItemsAfterList = createItemsAfterList(list4, lazyListMeasuredItemProvider, i, i8, list2, f6, z4, lazyListLayoutInfo);
        int size4 = listCreateItemsAfterList.size();
        int iMax5 = i59;
        for (int i61 = 0; i61 < size4; i61++) {
            iMax5 = Math.max(iMax5, listCreateItemsAfterList.get(i61).getCrossAxisSize());
        }
        boolean z9 = Intrinsics.areEqual(lazyListMeasuredItem4, arrayDeque.first()) && listCreateItemsBeforeList.isEmpty() && listCreateItemsAfterList.isEmpty();
        int i62 = ConstraintsKt.constrainWidth-K40F9xA(j, z ? iMax5 : i60);
        if (z) {
            iMax5 = i60;
        }
        int i63 = ConstraintsKt.constrainHeight-K40F9xA(j, iMax5);
        final List<LazyListMeasuredItem> listCalculateItemsOffsets = calculateItemsOffsets(list4, listCreateItemsBeforeList, listCreateItemsAfterList, i62, i63, i60, i2, i56, z, vertical, horizontal, z2, density);
        lazyLayoutItemAnimator.onMeasured((int) f6, i62, i63, listCalculateItemsOffsets, lazyListMeasuredItemProvider.getKeyIndexMap(), lazyListMeasuredItemProvider, z, z4, 1, z3, i19, i60, coroutineScope, graphicsContext);
        if (!z4) {
            long jM1213getMinSizeToFitDisappearingItemsYbymL2g2 = lazyLayoutItemAnimator.m1213getMinSizeToFitDisappearingItemsYbymL2g();
            if (!IntSize.equals-impl0(jM1213getMinSizeToFitDisappearingItemsYbymL2g2, IntSize.Companion.getZero-YbymL2g())) {
                int i64 = z ? i63 : i62;
                i62 = ConstraintsKt.constrainWidth-K40F9xA(j, Math.max(i62, IntSize.getWidth-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g2)));
                i63 = ConstraintsKt.constrainHeight-K40F9xA(j, Math.max(i63, IntSize.getHeight-impl(jM1213getMinSizeToFitDisappearingItemsYbymL2g2)));
                int i65 = z ? i63 : i62;
                if (i65 != i64) {
                    int size5 = listCalculateItemsOffsets.size();
                    for (int i66 = 0; i66 < size5; i66++) {
                        listCalculateItemsOffsets.get(i66).updateMainAxisLayoutSize(i65);
                    }
                }
            }
        }
        int i67 = i62;
        int i68 = i63;
        final LazyListMeasuredItem lazyListMeasuredItemFindOrComposeLazyListHeader = !list.isEmpty() ? LazyListHeadersKt.findOrComposeLazyListHeader(listCalculateItemsOffsets, lazyListMeasuredItemProvider, list, i3, i67, i68) : null;
        if (i13 >= i) {
            z5 = z4;
            if (i60 <= i2) {
                z6 = false;
            }
            MeasureResult measureResult = (MeasureResult) function3.invoke(Integer.valueOf(i67), Integer.valueOf(i68), new Function1<Placeable.PlacementScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(Placeable.PlacementScope placementScope) {
                    List<LazyListMeasuredItem> list5 = listCalculateItemsOffsets;
                    LazyListMeasuredItem lazyListMeasuredItem5 = lazyListMeasuredItemFindOrComposeLazyListHeader;
                    boolean z10 = z5;
                    int size6 = list5.size();
                    for (int i69 = 0; i69 < size6; i69++) {
                        LazyListMeasuredItem lazyListMeasuredItem6 = list5.get(i69);
                        if (lazyListMeasuredItem6 != lazyListMeasuredItem5) {
                            lazyListMeasuredItem6.place(placementScope, z10);
                        }
                    }
                    LazyListMeasuredItem lazyListMeasuredItem7 = lazyListMeasuredItemFindOrComposeLazyListHeader;
                    if (lazyListMeasuredItem7 != null) {
                        lazyListMeasuredItem7.place(placementScope, z5);
                    }
                    ObservableScopeInvalidator.m1251attachToScopeimpl(mutableState);
                }
            });
            if (z9) {
                list3 = listCalculateItemsOffsets;
            } else {
                ArrayList arrayList = new ArrayList(listCalculateItemsOffsets.size());
                size = listCalculateItemsOffsets.size();
                for (i20 = 0; i20 < size; i20++) {
                    LazyListMeasuredItem lazyListMeasuredItem5 = listCalculateItemsOffsets.get(i20);
                    lazyListMeasuredItem2 = lazyListMeasuredItem5;
                    if ((lazyListMeasuredItem2.getIndex() < ((LazyListMeasuredItem) arrayDeque.first()).getIndex() && lazyListMeasuredItem2.getIndex() <= ((LazyListMeasuredItem) arrayDeque.last()).getIndex()) || lazyListMeasuredItem2 == lazyListMeasuredItemFindOrComposeLazyListHeader) {
                        arrayList.add(lazyListMeasuredItem5);
                    }
                }
                list3 = arrayList;
            }
            if (z) {
                orientation = Orientation.Vertical;
            } else {
                orientation = Orientation.Horizontal;
            }
            return new LazyListMeasureResult(lazyListMeasuredItem4, i19, z6, f6, measureResult, f5, z8, coroutineScope, density, lazyListMeasuredItemProvider.getChildConstraints(), list3, i31, i47, i, z2, orientation, i4, i5, null);
        }
        z5 = z4;
        z6 = true;
        MeasureResult measureResult2 = (MeasureResult) function3.invoke(Integer.valueOf(i67), Integer.valueOf(i68), new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                List<LazyListMeasuredItem> list5 = listCalculateItemsOffsets;
                LazyListMeasuredItem lazyListMeasuredItem6 = lazyListMeasuredItemFindOrComposeLazyListHeader;
                boolean z10 = z5;
                int size6 = list5.size();
                for (int i69 = 0; i69 < size6; i69++) {
                    LazyListMeasuredItem lazyListMeasuredItem7 = list5.get(i69);
                    if (lazyListMeasuredItem7 != lazyListMeasuredItem6) {
                        lazyListMeasuredItem7.place(placementScope, z10);
                    }
                }
                LazyListMeasuredItem lazyListMeasuredItem8 = lazyListMeasuredItemFindOrComposeLazyListHeader;
                if (lazyListMeasuredItem8 != null) {
                    lazyListMeasuredItem8.place(placementScope, z5);
                }
                ObservableScopeInvalidator.m1251attachToScopeimpl(mutableState);
            }
        });
        if (z9) {
            list3 = listCalculateItemsOffsets;
        } else {
            ArrayList arrayList2 = new ArrayList(listCalculateItemsOffsets.size());
            size = listCalculateItemsOffsets.size();
            while (i20 < size) {
                LazyListMeasuredItem lazyListMeasuredItem6 = listCalculateItemsOffsets.get(i20);
                lazyListMeasuredItem2 = lazyListMeasuredItem6;
                if (lazyListMeasuredItem2.getIndex() < ((LazyListMeasuredItem) arrayDeque.first()).getIndex()) {
                }
            }
            list3 = arrayList2;
        }
        if (z) {
            orientation = Orientation.Vertical;
        } else {
            orientation = Orientation.Horizontal;
        }
        return new LazyListMeasureResult(lazyListMeasuredItem4, i19, z6, f6, measureResult2, f5, z8, coroutineScope, density, lazyListMeasuredItemProvider.getChildConstraints(), list3, i31, i47, i, z2, orientation, i4, i5, null);
    }

    private static final List<LazyListMeasuredItem> createItemsAfterList(List<LazyListMeasuredItem> list, LazyListMeasuredItemProvider lazyListMeasuredItemProvider, int i, int i2, List<Integer> list2, float f, boolean z, LazyListLayoutInfo lazyListLayoutInfo) {
        ArrayList arrayList;
        LazyListItemInfo lazyListItemInfo;
        LazyListMeasuredItem lazyListMeasuredItem;
        LazyListMeasuredItem lazyListMeasuredItem2;
        int mainAxisSizeWithSpacings;
        LazyListMeasuredItem lazyListMeasuredItem3;
        int index;
        int iMin;
        LazyListMeasuredItem lazyListMeasuredItem4;
        LazyListMeasuredItem lazyListMeasuredItem5;
        int i3 = i - 1;
        int iMin2 = Math.min(((LazyListMeasuredItem) CollectionsKt.last(list)).getIndex() + i2, i3);
        int index2 = ((LazyListMeasuredItem) CollectionsKt.last(list)).getIndex() + 1;
        if (index2 <= iMin2) {
            ArrayList arrayList2 = null;
            while (true) {
                if (arrayList2 == null) {
                    arrayList2 = new ArrayList();
                }
                arrayList = arrayList2;
                arrayList.add(LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, index2, 0L, 2, null));
                if (index2 == iMin2) {
                    break;
                }
                index2++;
                arrayList2 = arrayList;
            }
        } else {
            arrayList = null;
        }
        if (z && lazyListLayoutInfo != null && !lazyListLayoutInfo.getVisibleItemsInfo().isEmpty()) {
            List<LazyListItemInfo> visibleItemsInfo = lazyListLayoutInfo.getVisibleItemsInfo();
            int size = visibleItemsInfo.size();
            while (true) {
                size--;
                if (-1 >= size) {
                    lazyListItemInfo = null;
                    break;
                }
                if (visibleItemsInfo.get(size).getIndex() > iMin2 && (size == 0 || visibleItemsInfo.get(size - 1).getIndex() <= iMin2)) {
                    lazyListItemInfo = visibleItemsInfo.get(size);
                    break;
                }
            }
            LazyListItemInfo lazyListItemInfo2 = (LazyListItemInfo) CollectionsKt.last(lazyListLayoutInfo.getVisibleItemsInfo());
            if (lazyListItemInfo != null && (index = lazyListItemInfo.getIndex()) <= (iMin = Math.min(lazyListItemInfo2.getIndex(), i3))) {
                while (true) {
                    if (arrayList != null) {
                        int size2 = arrayList.size();
                        int i4 = 0;
                        while (true) {
                            if (i4 >= size2) {
                                lazyListMeasuredItem5 = null;
                                break;
                            }
                            lazyListMeasuredItem5 = arrayList.get(i4);
                            if (lazyListMeasuredItem5.getIndex() == index) {
                                break;
                            }
                            i4++;
                        }
                        lazyListMeasuredItem4 = lazyListMeasuredItem5;
                    } else {
                        lazyListMeasuredItem4 = null;
                    }
                    if (lazyListMeasuredItem4 == null) {
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                        }
                        arrayList.add(LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, index, 0L, 2, null));
                    }
                    if (index == iMin) {
                        break;
                    }
                    index++;
                }
            }
            float viewportEndOffset = ((lazyListLayoutInfo.getViewportEndOffset() - lazyListItemInfo2.getOffset()) - lazyListItemInfo2.getSize()) - f;
            if (viewportEndOffset > 0.0f) {
                int index3 = lazyListItemInfo2.getIndex() + 1;
                int i5 = 0;
                while (index3 < i && i5 < viewportEndOffset) {
                    if (index3 <= iMin2) {
                        int size3 = list.size();
                        int i6 = 0;
                        while (true) {
                            if (i6 >= size3) {
                                lazyListMeasuredItem3 = null;
                                break;
                            }
                            lazyListMeasuredItem3 = list.get(i6);
                            if (lazyListMeasuredItem3.getIndex() == index3) {
                                break;
                            }
                            i6++;
                        }
                        lazyListMeasuredItem = lazyListMeasuredItem3;
                    } else if (arrayList != null) {
                        int size4 = arrayList.size();
                        int i7 = 0;
                        while (true) {
                            if (i7 >= size4) {
                                lazyListMeasuredItem2 = null;
                                break;
                            }
                            lazyListMeasuredItem2 = arrayList.get(i7);
                            if (lazyListMeasuredItem2.getIndex() == index3) {
                                break;
                            }
                            i7++;
                        }
                        lazyListMeasuredItem = lazyListMeasuredItem2;
                    } else {
                        lazyListMeasuredItem = null;
                    }
                    if (lazyListMeasuredItem != null) {
                        index3++;
                        mainAxisSizeWithSpacings = lazyListMeasuredItem.getMainAxisSizeWithSpacings();
                    } else {
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                        }
                        arrayList.add(LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, index3, 0L, 2, null));
                        index3++;
                        mainAxisSizeWithSpacings = ((LazyListMeasuredItem) CollectionsKt.last(arrayList)).getMainAxisSizeWithSpacings();
                    }
                    i5 += mainAxisSizeWithSpacings;
                }
            }
        }
        if (arrayList != null && ((LazyListMeasuredItem) CollectionsKt.last(arrayList)).getIndex() > iMin2) {
            iMin2 = ((LazyListMeasuredItem) CollectionsKt.last(arrayList)).getIndex();
        }
        int size5 = list2.size();
        for (int i8 = 0; i8 < size5; i8++) {
            int iIntValue = list2.get(i8).intValue();
            if (iIntValue > iMin2) {
                if (arrayList == null) {
                    arrayList = new ArrayList();
                }
                arrayList.add(LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, iIntValue, 0L, 2, null));
            }
        }
        return arrayList == null ? CollectionsKt.emptyList() : arrayList;
    }

    private static final List<LazyListMeasuredItem> createItemsBeforeList(int i, LazyListMeasuredItemProvider lazyListMeasuredItemProvider, int i2, List<Integer> list) {
        int iMax = Math.max(0, i - i2);
        int i3 = i - 1;
        ArrayList arrayList = null;
        if (iMax <= i3) {
            while (true) {
                if (arrayList == null) {
                    arrayList = new ArrayList();
                }
                arrayList.add(LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, i3, 0L, 2, null));
                if (i3 == iMax) {
                    break;
                }
                i3--;
            }
        }
        int size = list.size() - 1;
        if (size >= 0) {
            while (true) {
                int i4 = size - 1;
                int iIntValue = list.get(size).intValue();
                if (iIntValue < iMax) {
                    if (arrayList == null) {
                        arrayList = new ArrayList();
                    }
                    arrayList.add(LazyListMeasuredItemProvider.m1152getAndMeasure0kLqBqw$default(lazyListMeasuredItemProvider, iIntValue, 0L, 2, null));
                }
                if (i4 < 0) {
                    break;
                }
                size = i4;
            }
        }
        return arrayList == null ? CollectionsKt.emptyList() : arrayList;
    }

    private static final List<LazyListMeasuredItem> calculateItemsOffsets(List<LazyListMeasuredItem> list, List<LazyListMeasuredItem> list2, List<LazyListMeasuredItem> list3, int i, int i2, int i3, int i4, int i5, boolean z, Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, boolean z2, Density density) {
        int i6 = z ? i2 : i;
        boolean z3 = i3 < Math.min(i6, i4);
        if (z3 && i5 != 0) {
            throw new IllegalStateException("non-zero itemsScrollOffset".toString());
        }
        ArrayList arrayList = new ArrayList(list.size() + list2.size() + list3.size());
        if (z3) {
            if (!list2.isEmpty() || !list3.isEmpty()) {
                throw new IllegalArgumentException("no extra items".toString());
            }
            int size = list.size();
            int[] iArr = new int[size];
            for (int i7 = 0; i7 < size; i7++) {
                iArr[i7] = list.get(calculateItemsOffsets$reverseAware(i7, z2, size)).getSize();
            }
            int[] iArr2 = new int[size];
            for (int i8 = 0; i8 < size; i8++) {
                iArr2[i8] = 0;
            }
            if (z) {
                if (vertical == null) {
                    throw new IllegalArgumentException("null verticalArrangement when isVertical == true".toString());
                }
                vertical.arrange(density, i6, iArr, iArr2);
            } else {
                if (horizontal == null) {
                    throw new IllegalArgumentException("null horizontalArrangement when isVertical == false".toString());
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
                    int size2 = iArr2[first];
                    LazyListMeasuredItem lazyListMeasuredItem = list.get(calculateItemsOffsets$reverseAware(first, z2, size));
                    if (z2) {
                        size2 = (i6 - size2) - lazyListMeasuredItem.getSize();
                    }
                    lazyListMeasuredItem.position(size2, i, i2);
                    arrayList.add(lazyListMeasuredItem);
                    if (first == last) {
                        break;
                    }
                    first += step;
                }
            }
        } else {
            int size3 = list2.size();
            int mainAxisSizeWithSpacings = i5;
            for (int i9 = 0; i9 < size3; i9++) {
                LazyListMeasuredItem lazyListMeasuredItem2 = list2.get(i9);
                mainAxisSizeWithSpacings -= lazyListMeasuredItem2.getMainAxisSizeWithSpacings();
                lazyListMeasuredItem2.position(mainAxisSizeWithSpacings, i, i2);
                arrayList.add(lazyListMeasuredItem2);
            }
            int size4 = list.size();
            int mainAxisSizeWithSpacings2 = i5;
            for (int i10 = 0; i10 < size4; i10++) {
                LazyListMeasuredItem lazyListMeasuredItem3 = list.get(i10);
                lazyListMeasuredItem3.position(mainAxisSizeWithSpacings2, i, i2);
                arrayList.add(lazyListMeasuredItem3);
                mainAxisSizeWithSpacings2 += lazyListMeasuredItem3.getMainAxisSizeWithSpacings();
            }
            int size5 = list3.size();
            for (int i11 = 0; i11 < size5; i11++) {
                LazyListMeasuredItem lazyListMeasuredItem4 = list3.get(i11);
                lazyListMeasuredItem4.position(mainAxisSizeWithSpacings2, i, i2);
                arrayList.add(lazyListMeasuredItem4);
                mainAxisSizeWithSpacings2 += lazyListMeasuredItem4.getMainAxisSizeWithSpacings();
            }
        }
        return arrayList;
    }
}
