package androidx.compose.foundation.gestures;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollConnection;
import androidx.compose.ui.unit.Velocity;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;

@Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0002\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J#\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0010\u001a\u00020\u000eH\u0096@ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J*\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u000f\u001a\u00020\u00142\u0006\u0010\u0010\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0016H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018R\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0019"}, d2 = {"Landroidx/compose/foundation/gestures/ScrollableNestedScrollConnection;", "Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "scrollingLogic", "Landroidx/compose/foundation/gestures/ScrollingLogic;", "enabled", "", "(Landroidx/compose/foundation/gestures/ScrollingLogic;Z)V", "getEnabled", "()Z", "setEnabled", "(Z)V", "getScrollingLogic", "()Landroidx/compose/foundation/gestures/ScrollingLogic;", "onPostFling", "Landroidx/compose/ui/unit/Velocity;", "consumed", "available", "onPostFling-RZ2iAVY", "(JJLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPostScroll", "Landroidx/compose/ui/geometry/Offset;", "source", "Landroidx/compose/ui/input/nestedscroll/NestedScrollSource;", "onPostScroll-DzOQY0M", "(JJI)J", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class ScrollableNestedScrollConnection implements NestedScrollConnection {
    private boolean enabled;
    private final ScrollingLogic scrollingLogic;

    @Override
    public Object mo830onPreFlingQWom1Mo(long j, Continuation continuation) {
        return NestedScrollConnection.CC.m5714onPreFlingQWom1Mo$suspendImpl(this, j, continuation);
    }

    @Override
    public long mo831onPreScrollOzD1aCk(long j, int i) {
        return NestedScrollConnection.CC.m5708$default$onPreScrollOzD1aCk(this, j, i);
    }

    public ScrollableNestedScrollConnection(ScrollingLogic scrollingLogic, boolean z) {
        this.scrollingLogic = scrollingLogic;
        this.enabled = z;
    }

    public final ScrollingLogic getScrollingLogic() {
        return this.scrollingLogic;
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final void setEnabled(boolean z) {
        this.enabled = z;
    }

    @Override
    public long mo829onPostScrollDzOQY0M(long consumed, long available, int source) {
        if (this.enabled) {
            return this.scrollingLogic.m844performRawScrollMKHz9U(available);
        }
        return Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    @Override
    public Object mo828onPostFlingRZ2iAVY(long j, long j2, Continuation<? super Velocity> continuation) {
        ScrollableNestedScrollConnection$onPostFling$1 scrollableNestedScrollConnection$onPostFling$1;
        long j3;
        if (continuation instanceof ScrollableNestedScrollConnection$onPostFling$1) {
            scrollableNestedScrollConnection$onPostFling$1 = (ScrollableNestedScrollConnection$onPostFling$1) continuation;
            if ((scrollableNestedScrollConnection$onPostFling$1.label & Integer.MIN_VALUE) != 0) {
                scrollableNestedScrollConnection$onPostFling$1.label -= Integer.MIN_VALUE;
            } else {
                scrollableNestedScrollConnection$onPostFling$1 = new ScrollableNestedScrollConnection$onPostFling$1(this, continuation);
            }
        } else {
            scrollableNestedScrollConnection$onPostFling$1 = new ScrollableNestedScrollConnection$onPostFling$1(this, continuation);
        }
        Object objM842doFlingAnimationQWom1Mo = scrollableNestedScrollConnection$onPostFling$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = scrollableNestedScrollConnection$onPostFling$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objM842doFlingAnimationQWom1Mo);
            if (this.enabled) {
                ScrollingLogic scrollingLogic = this.scrollingLogic;
                scrollableNestedScrollConnection$onPostFling$1.J$0 = j2;
                scrollableNestedScrollConnection$onPostFling$1.label = 1;
                objM842doFlingAnimationQWom1Mo = scrollingLogic.m842doFlingAnimationQWom1Mo(j2, scrollableNestedScrollConnection$onPostFling$1);
                if (objM842doFlingAnimationQWom1Mo == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                j3 = Velocity.Companion.getZero-9UxMQ8M();
            }
            return Velocity.box-impl(j3);
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        j2 = scrollableNestedScrollConnection$onPostFling$1.J$0;
        ResultKt.throwOnFailure(objM842doFlingAnimationQWom1Mo);
        j3 = Velocity.minus-AH228Gc(j2, ((Velocity) objM842doFlingAnimationQWom1Mo).unbox-impl());
        return Velocity.box-impl(j3);
    }
}
