package androidx.compose.foundation.pager;

import androidx.compose.foundation.gestures.ScrollScope;
import androidx.compose.foundation.gestures.ScrollableState;
import androidx.compose.foundation.lazy.layout.LazyLayoutAnimateScrollScope;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u0010\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u0001¨\u0006\u0004"}, d2 = {"PagerLazyAnimateScrollScope", "Landroidx/compose/foundation/lazy/layout/LazyLayoutAnimateScrollScope;", "state", "Landroidx/compose/foundation/pager/PagerState;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class PagerLazyAnimateScrollScopeKt {
    public static final LazyLayoutAnimateScrollScope PagerLazyAnimateScrollScope(final PagerState pagerState) {
        return new LazyLayoutAnimateScrollScope() {
            @Override
            public int getFirstVisibleItemIndex() {
                return pagerState.getFirstVisiblePage();
            }

            @Override
            public int getFirstVisibleItemScrollOffset() {
                return pagerState.getFirstVisiblePageOffset();
            }

            @Override
            public int getLastVisibleItemIndex() {
                return ((PageInfo) CollectionsKt.last(pagerState.getLayoutInfo().getVisiblePagesInfo())).getIndex();
            }

            @Override
            public int getItemCount() {
                return pagerState.getPageCount();
            }

            @Override
            public void snapToItem(ScrollScope scrollScope, int i, int i2) {
                pagerState.snapToItem$foundation_release(i, i2 / pagerState.getPageSizeWithSpacing$foundation_release(), true);
            }

            @Override
            public float calculateDistanceTo(int targetIndex) {
                PageInfo pageInfo;
                List<PageInfo> visiblePagesInfo = pagerState.getLayoutInfo().getVisiblePagesInfo();
                int size = visiblePagesInfo.size();
                int i = 0;
                while (true) {
                    if (i >= size) {
                        pageInfo = null;
                        break;
                    }
                    pageInfo = visiblePagesInfo.get(i);
                    if (pageInfo.getIndex() == targetIndex) {
                        break;
                    }
                    i++;
                }
                PageInfo pageInfo2 = pageInfo;
                if (pageInfo2 == null) {
                    return ((targetIndex - pagerState.getCurrentPage()) * getVisibleItemsAverageSize()) - (pagerState.getCurrentPageOffsetFraction() * pagerState.getPageSizeWithSpacing$foundation_release());
                }
                return pageInfo2.getOffset();
            }

            @Override
            public Object scroll(Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
                Object objScroll$default = ScrollableState.CC.scroll$default(pagerState, null, function2, continuation, 1, null);
                return objScroll$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objScroll$default : Unit.INSTANCE;
            }

            private final int getVisibleItemsAverageSize() {
                return pagerState.getPageSize$foundation_release() + pagerState.getPageSpacing$foundation_release();
            }
        };
    }
}
