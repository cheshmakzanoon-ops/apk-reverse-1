package androidx.compose.foundation.pager;

import androidx.compose.foundation.CheckScrollableContainerConstraintsKt;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.gestures.snapping.SnapPosition;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsStateKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutMeasureScope;
import androidx.compose.foundation.lazy.layout.ObservableScopeInvalidator;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.IntOffsetKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.MapsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a¡\u0001\u0010\u0000\u001a\u0019\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0001¢\u0006\u0002\b\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\u001a2\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001e2\f\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020\u00120\u0007H\u0001ø\u0001\u0000¢\u0006\u0004\b \u0010!\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\""}, d2 = {"rememberPagerMeasurePolicy", "Lkotlin/Function2;", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;", "Landroidx/compose/ui/unit/Constraints;", "Landroidx/compose/ui/layout/MeasureResult;", "Lkotlin/ExtensionFunctionType;", "itemProviderLambda", "Lkotlin/Function0;", "Landroidx/compose/foundation/pager/PagerLazyLayoutItemProvider;", "state", "Landroidx/compose/foundation/pager/PagerState;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "reverseLayout", "", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "beyondViewportPageCount", "", "pageSpacing", "Landroidx/compose/ui/unit/Dp;", "pageSize", "Landroidx/compose/foundation/pager/PageSize;", "horizontalAlignment", "Landroidx/compose/ui/Alignment$Horizontal;", "verticalAlignment", "Landroidx/compose/ui/Alignment$Vertical;", "snapPosition", "Landroidx/compose/foundation/gestures/snapping/SnapPosition;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "pageCount", "rememberPagerMeasurePolicy-8u0NR3k", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/foundation/pager/PagerState;Landroidx/compose/foundation/layout/PaddingValues;ZLandroidx/compose/foundation/gestures/Orientation;IFLandroidx/compose/foundation/pager/PageSize;Landroidx/compose/ui/Alignment$Horizontal;Landroidx/compose/ui/Alignment$Vertical;Landroidx/compose/foundation/gestures/snapping/SnapPosition;Lkotlinx/coroutines/CoroutineScope;Lkotlin/jvm/functions/Function0;Landroidx/compose/runtime/Composer;II)Lkotlin/jvm/functions/Function2;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class PagerMeasurePolicyKt {
    public static final Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> m1336rememberPagerMeasurePolicy8u0NR3k(final Function0<PagerLazyLayoutItemProvider> function0, final PagerState pagerState, final PaddingValues paddingValues, final boolean z, final Orientation orientation, final int i, final float f, final PageSize pageSize, final Alignment.Horizontal horizontal, final Alignment.Vertical vertical, final SnapPosition snapPosition, final CoroutineScope coroutineScope, final Function0<Integer> function1, Composer composer, int i2, int i3) {
        boolean z2;
        boolean z3;
        boolean z4;
        boolean z5;
        boolean z6;
        boolean z7;
        ComposerKt.sourceInformationMarkerStart(composer, 1391419623, "C(rememberPagerMeasurePolicy)P(4,11,1,9,5!1,8:c#ui.unit.Dp,7,3,12,10)56@2301L6278:PagerMeasurePolicy.kt#g6yjnt");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1391419623, i2, i3, "androidx.compose.foundation.pager.rememberPagerMeasurePolicy (PagerMeasurePolicy.kt:56)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 35232261, "CC(remember):PagerMeasurePolicy.kt#9igjgp");
        if (((i2 & 112) ^ 48) > 32 && composer.changed(pagerState)) {
            z2 = true;
        } else if ((i2 & 48) == 32) {
            z2 = true;
        } else {
            z2 = false;
        }
        boolean z8 = z2 | ((((i2 & 896) ^ 384) > 256 && composer.changed(paddingValues)) || (i2 & 384) == 256) | ((((i2 & 7168) ^ 3072) > 2048 && composer.changed(z)) || (i2 & 3072) == 2048) | ((((57344 & i2) ^ 24576) > 16384 && composer.changed(orientation)) || (i2 & 24576) == 16384) | ((((234881024 & i2) ^ 100663296) > 67108864 && composer.changed(horizontal)) || (i2 & 100663296) == 67108864) | ((((1879048192 & i2) ^ 805306368) > 536870912 && composer.changed(vertical)) || (i2 & 805306368) == 536870912);
        if (((3670016 & i2) ^ 1572864) > 1048576 && composer.changed(f)) {
            z3 = true;
        } else if ((1572864 & i2) == 1048576) {
            z3 = true;
        } else {
            z3 = false;
        }
        boolean z9 = z8 | z3;
        if (((29360128 & i2) ^ 12582912) > 8388608 && composer.changed(pageSize)) {
            z4 = true;
        } else if ((12582912 & i2) == 8388608) {
            z4 = true;
        } else {
            z4 = false;
        }
        boolean z10 = z9 | z4;
        if (((i3 & 14) ^ 6) > 4 && composer.changed(snapPosition)) {
            z5 = true;
        } else if ((i3 & 6) == 4) {
            z5 = true;
        } else {
            z5 = false;
        }
        boolean z11 = z10 | z5;
        if (((i3 & 896) ^ 384) > 256 && composer.changed(function1)) {
            z6 = true;
        } else if ((i3 & 384) == 256) {
            z6 = true;
        } else {
            z6 = false;
        }
        boolean z12 = z6 | z11;
        if (((458752 & i2) ^ 196608) > 131072 && composer.changed(i)) {
            z7 = true;
        } else if ((i2 & 196608) == 131072) {
            z7 = true;
        } else {
            z7 = false;
        }
        boolean zChanged = z12 | z7 | composer.changed(coroutineScope);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = (Function2) new Function2<LazyLayoutMeasureScope, Constraints, PagerMeasureResult>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return m1337invoke0kLqBqw((LazyLayoutMeasureScope) obj, ((Constraints) obj2).unbox-impl());
                }

                public final PagerMeasureResult m1337invoke0kLqBqw(final LazyLayoutMeasureScope lazyLayoutMeasureScope, final long j) {
                    int i4;
                    int i5;
                    int i6;
                    int i7;
                    long jIntOffset;
                    ObservableScopeInvalidator.m1251attachToScopeimpl(pagerState.m1338getMeasurementScopeInvalidatorzYiylxw$foundation_release());
                    boolean z13 = orientation == Orientation.Vertical;
                    CheckScrollableContainerConstraintsKt.m550checkScrollableContainerConstraintsK40F9xA(j, z13 ? Orientation.Vertical : Orientation.Horizontal);
                    if (z13) {
                        i4 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.mo986calculateLeftPaddingu2uoSUM(lazyLayoutMeasureScope.getLayoutDirection()));
                    } else {
                        i4 = lazyLayoutMeasureScope.roundToPx-0680j_4(PaddingKt.calculateStartPadding(paddingValues, lazyLayoutMeasureScope.getLayoutDirection()));
                    }
                    if (z13) {
                        i5 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.mo987calculateRightPaddingu2uoSUM(lazyLayoutMeasureScope.getLayoutDirection()));
                    } else {
                        i5 = lazyLayoutMeasureScope.roundToPx-0680j_4(PaddingKt.calculateEndPadding(paddingValues, lazyLayoutMeasureScope.getLayoutDirection()));
                    }
                    int i8 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.getTop());
                    int i9 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.getBottom());
                    final int i10 = i8 + i9;
                    final int i11 = i4 + i5;
                    int i12 = z13 ? i10 : i11;
                    if (z13 && !z) {
                        i6 = i8;
                    } else if (z13 && z) {
                        i6 = i9;
                    } else {
                        i6 = (z13 || z) ? i5 : i4;
                    }
                    int i13 = i12 - i6;
                    long j2 = ConstraintsKt.offset-NN6Ew-U(j, -i11, -i10);
                    LazyLayoutMeasureScope lazyLayoutMeasureScope2 = lazyLayoutMeasureScope;
                    pagerState.setDensity$foundation_release(lazyLayoutMeasureScope2);
                    int i14 = lazyLayoutMeasureScope.roundToPx-0680j_4(f);
                    if (z13) {
                        i7 = Constraints.getMaxHeight-impl(j) - i10;
                    } else {
                        i7 = Constraints.getMaxWidth-impl(j) - i11;
                    }
                    if (!z || i7 > 0) {
                        jIntOffset = IntOffsetKt.IntOffset(i4, i8);
                    } else {
                        if (!z13) {
                            i4 += i7;
                        }
                        if (z13) {
                            i8 += i7;
                        }
                        jIntOffset = IntOffsetKt.IntOffset(i4, i8);
                    }
                    long j3 = jIntOffset;
                    int iCoerceAtLeast = RangesKt.coerceAtLeast(pageSize.calculateMainAxisPageSize(lazyLayoutMeasureScope2, i7, i14), 0);
                    pagerState.m1342setPremeasureConstraintsBRTryo0$foundation_release(ConstraintsKt.Constraints$default(0, orientation == Orientation.Vertical ? Constraints.getMaxWidth-impl(j2) : iCoerceAtLeast, 0, orientation != Orientation.Vertical ? Constraints.getMaxHeight-impl(j2) : iCoerceAtLeast, 5, (Object) null));
                    PagerLazyLayoutItemProvider pagerLazyLayoutItemProvider = (PagerLazyLayoutItemProvider) function0.invoke();
                    Snapshot.Companion companion = Snapshot.INSTANCE;
                    PagerState pagerState2 = pagerState;
                    SnapPosition snapPosition2 = snapPosition;
                    Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
                    Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
                    Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
                    try {
                        int iMatchScrollPositionWithKey$foundation_release = pagerState2.matchScrollPositionWithKey$foundation_release(pagerLazyLayoutItemProvider, pagerState2.getCurrentPage());
                        int iCurrentPageOffset = PagerKt.currentPageOffset(snapPosition2, i7, iCoerceAtLeast, i14, i6, i13, pagerState2.getCurrentPage(), pagerState2.getCurrentPageOffsetFraction(), pagerState2.getPageCount());
                        Unit unit = Unit.INSTANCE;
                        companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                        int i15 = i7;
                        PagerMeasureResult pagerMeasureResultM1335measurePagerbmk8ZPk = PagerMeasureKt.m1335measurePagerbmk8ZPk(lazyLayoutMeasureScope, ((Number) function1.invoke()).intValue(), pagerLazyLayoutItemProvider, i15, i6, i13, i14, iMatchScrollPositionWithKey$foundation_release, iCurrentPageOffset, j2, orientation, vertical, horizontal, z, j3, iCoerceAtLeast, i, LazyLayoutBeyondBoundsStateKt.calculateLazyLayoutPinnedIndices(pagerLazyLayoutItemProvider, pagerState.getPinnedPages(), pagerState.getBeyondBoundsInfo()), snapPosition, pagerState.m1339getPlacementScopeInvalidatorzYiylxw$foundation_release(), coroutineScope, new Function3<Integer, Integer, Function1<? super Placeable.PlacementScope, ? extends Unit>, MeasureResult>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                return invoke(((Number) obj).intValue(), ((Number) obj2).intValue(), (Function1<? super Placeable.PlacementScope, Unit>) obj3);
                            }

                            public final MeasureResult invoke(int i16, int i17, Function1<? super Placeable.PlacementScope, Unit> function2) {
                                return lazyLayoutMeasureScope.layout(ConstraintsKt.constrainWidth-K40F9xA(j, i16 + i11), ConstraintsKt.constrainHeight-K40F9xA(j, i17 + i10), MapsKt.emptyMap(), function2);
                            }
                        });
                        PagerState.applyMeasureResult$foundation_release$default(pagerState, pagerMeasureResultM1335measurePagerbmk8ZPk, false, 2, null);
                        return pagerMeasureResultM1335measurePagerbmk8ZPk;
                    } catch (Throwable th) {
                        companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                        throw th;
                    }
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2 = (Function2) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return function2;
    }
}
