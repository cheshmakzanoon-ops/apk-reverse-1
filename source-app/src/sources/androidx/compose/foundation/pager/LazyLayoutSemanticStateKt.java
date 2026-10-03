package androidx.compose.foundation.pager;

import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.lazy.layout.LazyLayoutSemanticState;
import androidx.compose.p002ui.semantics.CollectionInfo;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\u001a\u0018\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0000¨\u0006\u0006"}, d2 = {"LazyLayoutSemanticState", "Landroidx/compose/foundation/lazy/layout/LazyLayoutSemanticState;", "state", "Landroidx/compose/foundation/pager/PagerState;", "isVertical", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyLayoutSemanticStateKt {
    public static final LazyLayoutSemanticState LazyLayoutSemanticState(final PagerState pagerState, final boolean z) {
        return new LazyLayoutSemanticState() {
            @Override
            public float getScrollOffset() {
                return PagerScrollPositionKt.currentAbsoluteScrollOffset(pagerState);
            }

            @Override
            public float getMaxScrollOffset() {
                return PagerStateKt.calculateNewMaxScrollOffset(pagerState.getLayoutInfo(), pagerState.getPageCount());
            }

            @Override
            public Object scrollToItem(int i, Continuation<? super Unit> continuation) {
                Object objScrollToPage$default = PagerState.scrollToPage$default(pagerState, i, 0.0f, continuation, 2, null);
                return objScrollToPage$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objScrollToPage$default : Unit.INSTANCE;
            }

            @Override
            public CollectionInfo collectionInfo() {
                if (z) {
                    return new CollectionInfo(pagerState.getPageCount(), 1);
                }
                return new CollectionInfo(1, pagerState.getPageCount());
            }

            @Override
            public int getViewport() {
                if (pagerState.getLayoutInfo().getOrientation() == Orientation.Vertical) {
                    return IntSize.getHeight-impl(pagerState.getLayoutInfo().mo1332getViewportSizeYbymL2g());
                }
                return IntSize.getWidth-impl(pagerState.getLayoutInfo().mo1332getViewportSizeYbymL2g());
            }

            @Override
            public int getContentPadding() {
                return pagerState.getLayoutInfo().getBeforeContentPadding() + pagerState.getLayoutInfo().getAfterContentPadding();
            }
        };
    }
}
