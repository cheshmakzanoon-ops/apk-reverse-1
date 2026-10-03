package androidx.compose.foundation.pager;

import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.foundation.gestures.BringIntoViewSpec;
import kotlin.Metadata;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\t\b\u0002\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0001¢\u0006\u0002\u0010\u0005J \u0010\u000f\u001a\u00020\f2\u0006\u0010\u0010\u001a\u00020\f2\u0006\u0010\u0011\u001a\u00020\f2\u0006\u0010\u0012\u001a\u00020\fH\u0016J\u0010\u0010\u0013\u001a\u00020\f2\u0006\u0010\u0014\u001a\u00020\fH\u0002R\u0011\u0010\u0004\u001a\u00020\u0001¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u001a\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u0015"}, d2 = {"Landroidx/compose/foundation/pager/PagerBringIntoViewSpec;", "Landroidx/compose/foundation/gestures/BringIntoViewSpec;", "pagerState", "Landroidx/compose/foundation/pager/PagerState;", "defaultBringIntoViewSpec", "(Landroidx/compose/foundation/pager/PagerState;Landroidx/compose/foundation/gestures/BringIntoViewSpec;)V", "getDefaultBringIntoViewSpec", "()Landroidx/compose/foundation/gestures/BringIntoViewSpec;", "getPagerState", "()Landroidx/compose/foundation/pager/PagerState;", "scrollAnimationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "", "getScrollAnimationSpec", "()Landroidx/compose/animation/core/AnimationSpec;", "calculateScrollDistance", "offset", "size", "containerSize", "overrideProposedOffsetMove", "proposedOffsetMove", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class PagerBringIntoViewSpec implements BringIntoViewSpec {
    private final BringIntoViewSpec defaultBringIntoViewSpec;
    private final PagerState pagerState;
    private final AnimationSpec<Float> scrollAnimationSpec;

    public PagerBringIntoViewSpec(PagerState pagerState, BringIntoViewSpec bringIntoViewSpec) {
        this.pagerState = pagerState;
        this.defaultBringIntoViewSpec = bringIntoViewSpec;
        this.scrollAnimationSpec = bringIntoViewSpec.getScrollAnimationSpec();
    }

    public final PagerState getPagerState() {
        return this.pagerState;
    }

    public final BringIntoViewSpec getDefaultBringIntoViewSpec() {
        return this.defaultBringIntoViewSpec;
    }

    @Override
    public AnimationSpec<Float> getScrollAnimationSpec() {
        return this.scrollAnimationSpec;
    }

    @Override
    public float calculateScrollDistance(float offset, float size, float containerSize) {
        float fCalculateScrollDistance = this.defaultBringIntoViewSpec.calculateScrollDistance(offset, size, containerSize);
        if (fCalculateScrollDistance != 0.0f) {
            return overrideProposedOffsetMove(fCalculateScrollDistance);
        }
        if (this.pagerState.getFirstVisiblePageOffset() == 0) {
            return 0.0f;
        }
        float firstVisiblePageOffset = this.pagerState.getFirstVisiblePageOffset() * (-1.0f);
        if (this.pagerState.getLastScrolledForward()) {
            firstVisiblePageOffset += this.pagerState.getPageSizeWithSpacing$foundation_release();
        }
        return RangesKt.coerceIn(firstVisiblePageOffset, -containerSize, containerSize);
    }

    private final float overrideProposedOffsetMove(float proposedOffsetMove) {
        float firstVisiblePageOffset = this.pagerState.getFirstVisiblePageOffset() * (-1);
        while (proposedOffsetMove > 0.0f && firstVisiblePageOffset < proposedOffsetMove) {
            firstVisiblePageOffset += this.pagerState.getPageSizeWithSpacing$foundation_release();
        }
        while (proposedOffsetMove < 0.0f && firstVisiblePageOffset > proposedOffsetMove) {
            firstVisiblePageOffset -= this.pagerState.getPageSizeWithSpacing$foundation_release();
        }
        return firstVisiblePageOffset;
    }
}
