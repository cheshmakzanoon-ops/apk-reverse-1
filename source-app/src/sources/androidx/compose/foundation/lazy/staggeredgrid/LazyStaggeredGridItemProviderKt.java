package androidx.compose.foundation.lazy.staggeredgrid;

import androidx.compose.foundation.lazy.layout.NearestRangeKeyIndexMap;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.PropertyReference0Impl;
import kotlin.reflect.KProperty0;

@Metadata(d1 = {"\u0000&\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a4\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00042\u0017\u0010\u0005\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006¢\u0006\u0002\b\tH\u0001¢\u0006\u0002\u0010\n¨\u0006\u000b"}, d2 = {"rememberStaggeredGridItemProviderLambda", "Lkotlin/Function0;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemProvider;", "state", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScope;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;I)Lkotlin/jvm/functions/Function0;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyStaggeredGridItemProviderKt {
    public static final Function0<LazyStaggeredGridItemProvider> rememberStaggeredGridItemProviderLambda(final LazyStaggeredGridState lazyStaggeredGridState, Function1<? super LazyStaggeredGridScope, Unit> function1, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 690901732, "C(rememberStaggeredGridItemProviderLambda)P(1)41@1727L29,42@1768L622:LazyStaggeredGridItemProvider.kt#fzvcnm");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(690901732, i, -1, "androidx.compose.foundation.lazy.staggeredgrid.rememberStaggeredGridItemProviderLambda (LazyStaggeredGridItemProvider.kt:40)");
        }
        final State stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(function1, composer, (i >> 3) & 14);
        ComposerKt.sourceInformationMarkerStart(composer, 1235237410, "CC(remember):LazyStaggeredGridItemProvider.kt#9igjgp");
        boolean zChanged = composer.changed(lazyStaggeredGridState);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            final State stateDerivedStateOf = SnapshotStateKt.derivedStateOf(SnapshotStateKt.referentialEqualityPolicy(), new Function0<LazyStaggeredGridIntervalContent>() {
                {
                    super(0);
                }

                public final LazyStaggeredGridIntervalContent m1280invoke() {
                    return new LazyStaggeredGridIntervalContent(stateRememberUpdatedState.getValue());
                }
            });
            final State stateDerivedStateOf2 = SnapshotStateKt.derivedStateOf(SnapshotStateKt.referentialEqualityPolicy(), new Function0<LazyStaggeredGridItemProviderImpl>() {
                {
                    super(0);
                }

                public final LazyStaggeredGridItemProviderImpl m1281invoke() {
                    LazyStaggeredGridIntervalContent value = stateDerivedStateOf.getValue();
                    return new LazyStaggeredGridItemProviderImpl(lazyStaggeredGridState, value, new NearestRangeKeyIndexMap(lazyStaggeredGridState.getNearestRange$foundation_release(), value));
                }
            });
            objRememberedValue = (KProperty0) new PropertyReference0Impl(stateDerivedStateOf2) {
                public Object get() {
                    return ((State) this.receiver).getValue();
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        Function0<LazyStaggeredGridItemProvider> function0 = (KProperty0) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return function0;
    }
}
