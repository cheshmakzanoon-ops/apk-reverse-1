package androidx.compose.foundation.lazy.staggeredgrid;

import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.lazy.layout.LazyLayoutSemanticState;
import androidx.compose.foundation.lazy.layout.LazyLayoutSemanticsKt;
import androidx.compose.p002ui.semantics.CollectionInfo;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;

@Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\u001a\u001d\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0001¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, d2 = {"rememberLazyStaggeredGridSemanticState", "Landroidx/compose/foundation/lazy/layout/LazyLayoutSemanticState;", "state", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;", "reverseScrolling", "", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;ZLandroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/lazy/layout/LazyLayoutSemanticState;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyStaggeredGridSemanticsKt {
    public static final LazyLayoutSemanticState rememberLazyStaggeredGridSemanticState(final LazyStaggeredGridState lazyStaggeredGridState, boolean z, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1629354903, "C(rememberLazyStaggeredGridSemanticState)P(1)33@1351L1223:LazyStaggeredGridSemantics.kt#fzvcnm");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1629354903, i, -1, "androidx.compose.foundation.lazy.staggeredgrid.rememberLazyStaggeredGridSemanticState (LazyStaggeredGridSemantics.kt:33)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 518757981, "CC(remember):LazyStaggeredGridSemantics.kt#9igjgp");
        boolean zChanged = ((((i & 112) ^ 48) > 32 && composer.changed(z)) || (i & 48) == 32) | composer.changed(lazyStaggeredGridState);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new LazyLayoutSemanticState() {
                @Override
                public float getScrollOffset() {
                    return LazyLayoutSemanticsKt.estimatedLazyScrollOffset(lazyStaggeredGridState.getFirstVisibleItemIndex(), lazyStaggeredGridState.getFirstVisibleItemScrollOffset());
                }

                @Override
                public float getMaxScrollOffset() {
                    return LazyLayoutSemanticsKt.estimatedLazyMaxScrollOffset(lazyStaggeredGridState.getFirstVisibleItemIndex(), lazyStaggeredGridState.getFirstVisibleItemScrollOffset(), lazyStaggeredGridState.getCanScrollForward());
                }

                @Override
                public Object scrollToItem(int i2, Continuation<? super Unit> continuation) {
                    Object objScrollToItem$default = LazyStaggeredGridState.scrollToItem$default(lazyStaggeredGridState, i2, 0, continuation, 2, null);
                    return objScrollToItem$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objScrollToItem$default : Unit.INSTANCE;
                }

                @Override
                public CollectionInfo collectionInfo() {
                    return new CollectionInfo(-1, -1);
                }

                @Override
                public int getViewport() {
                    if (lazyStaggeredGridState.getLayoutInfo().getOrientation() == Orientation.Vertical) {
                        return IntSize.getHeight-impl(lazyStaggeredGridState.getLayoutInfo().getViewportSize());
                    }
                    return IntSize.getWidth-impl(lazyStaggeredGridState.getLayoutInfo().getViewportSize());
                }

                @Override
                public int getContentPadding() {
                    return lazyStaggeredGridState.getLayoutInfo().getBeforeContentPadding() + lazyStaggeredGridState.getLayoutInfo().getAfterContentPadding();
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        C0741x9388a700 c0741x9388a700 = (C0741x9388a700) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return c0741x9388a700;
    }
}
