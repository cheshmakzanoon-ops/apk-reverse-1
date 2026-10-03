package androidx.compose.material3;

import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.DecayAnimationSpec;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollConnection;
import androidx.compose.ui.unit.Velocity;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;

@Metadata(d1 = {"\u0000!\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J#\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u0003H\u0096@ø\u0001\u0000¢\u0006\u0004\b\u0006\u0010\u0007J*\u0010\b\u001a\u00020\t2\u0006\u0010\u0004\u001a\u00020\t2\u0006\u0010\u0005\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0016ø\u0001\u0000¢\u0006\u0004\b\f\u0010\rJ\"\u0010\u000e\u001a\u00020\t2\u0006\u0010\u0005\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0016ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0011"}, d2 = {"androidx/compose/material3/ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1", "Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "onPostFling", "Landroidx/compose/ui/unit/Velocity;", "consumed", "available", "onPostFling-RZ2iAVY", "(JJLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPostScroll", "Landroidx/compose/ui/geometry/Offset;", "source", "Landroidx/compose/ui/input/nestedscroll/NestedScrollSource;", "onPostScroll-DzOQY0M", "(JJI)J", "onPreScroll", "onPreScroll-OzD1aCk", "(JI)J", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1 implements NestedScrollConnection {
    final ExitUntilCollapsedScrollBehavior this$0;

    @Override
    public Object mo830onPreFlingQWom1Mo(long j, Continuation continuation) {
        return NestedScrollConnection.CC.m5714onPreFlingQWom1Mo$suspendImpl(this, j, continuation);
    }

    ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1(ExitUntilCollapsedScrollBehavior exitUntilCollapsedScrollBehavior) {
        this.this$0 = exitUntilCollapsedScrollBehavior;
    }

    @Override
    public long mo831onPreScrollOzD1aCk(long available, int source) {
        if (!((Boolean) this.this$0.getCanScroll().invoke()).booleanValue() || Offset.m4347getYimpl(available) > 0.0f) {
            return Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        float heightOffset = this.this$0.getState().getHeightOffset();
        this.this$0.getState().setHeightOffset(this.this$0.getState().getHeightOffset() + Offset.m4347getYimpl(available));
        if (heightOffset != this.this$0.getState().getHeightOffset()) {
            return Offset.m4340copydBAh8RU$default(available, 0.0f, 0.0f, 2, null);
        }
        return Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    @Override
    public long mo829onPostScrollDzOQY0M(long consumed, long available, int source) {
        if (!((Boolean) this.this$0.getCanScroll().invoke()).booleanValue()) {
            return Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        TopAppBarState state = this.this$0.getState();
        state.setContentOffset(state.getContentOffset() + Offset.m4347getYimpl(consumed));
        if (Offset.m4347getYimpl(available) < 0.0f || Offset.m4347getYimpl(consumed) < 0.0f) {
            float heightOffset = this.this$0.getState().getHeightOffset();
            this.this$0.getState().setHeightOffset(this.this$0.getState().getHeightOffset() + Offset.m4347getYimpl(consumed));
            return OffsetKt.Offset(0.0f, this.this$0.getState().getHeightOffset() - heightOffset);
        }
        if (Offset.m4347getYimpl(consumed) == 0.0f && Offset.m4347getYimpl(available) > 0.0f) {
            this.this$0.getState().setContentOffset(0.0f);
        }
        if (Offset.m4347getYimpl(available) > 0.0f) {
            float heightOffset2 = this.this$0.getState().getHeightOffset();
            this.this$0.getState().setHeightOffset(this.this$0.getState().getHeightOffset() + Offset.m4347getYimpl(available));
            return OffsetKt.Offset(0.0f, this.this$0.getState().getHeightOffset() - heightOffset2);
        }
        return Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    @Override
    public Object mo828onPostFlingRZ2iAVY(long j, long j2, Continuation<? super Velocity> continuation) {
        C1173x78ae0263 c1173x78ae0263;
        ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1 exitUntilCollapsedScrollBehavior$nestedScrollConnection$1;
        long j3;
        if (continuation instanceof C1173x78ae0263) {
            c1173x78ae0263 = (C1173x78ae0263) continuation;
            if ((c1173x78ae0263.label & Integer.MIN_VALUE) != 0) {
                c1173x78ae0263.label -= Integer.MIN_VALUE;
            } else {
                c1173x78ae0263 = new C1173x78ae0263(this, continuation);
            }
        } else {
            c1173x78ae0263 = new C1173x78ae0263(this, continuation);
        }
        Object objM5713onPostFlingRZ2iAVY$suspendImpl = c1173x78ae0263.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c1173x78ae0263.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objM5713onPostFlingRZ2iAVY$suspendImpl);
            c1173x78ae0263.L$0 = this;
            c1173x78ae0263.J$0 = j2;
            c1173x78ae0263.label = 1;
            objM5713onPostFlingRZ2iAVY$suspendImpl = NestedScrollConnection.CC.m5713onPostFlingRZ2iAVY$suspendImpl(this, j, j2, c1173x78ae0263);
            if (objM5713onPostFlingRZ2iAVY$suspendImpl == coroutine_suspended) {
                return coroutine_suspended;
            }
            exitUntilCollapsedScrollBehavior$nestedScrollConnection$1 = this;
        } else {
            if (i == 1) {
                j2 = c1173x78ae0263.J$0;
                exitUntilCollapsedScrollBehavior$nestedScrollConnection$1 = (ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1) c1173x78ae0263.L$0;
                ResultKt.throwOnFailure(objM5713onPostFlingRZ2iAVY$suspendImpl);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                j3 = c1173x78ae0263.J$0;
                ResultKt.throwOnFailure(objM5713onPostFlingRZ2iAVY$suspendImpl);
            }
            return Velocity.box-impl(Velocity.plus-AH228Gc(j3, ((Velocity) objM5713onPostFlingRZ2iAVY$suspendImpl).unbox-impl()));
        }
        long j4 = ((Velocity) objM5713onPostFlingRZ2iAVY$suspendImpl).unbox-impl();
        TopAppBarState state = exitUntilCollapsedScrollBehavior$nestedScrollConnection$1.this$0.getState();
        float f = Velocity.getY-impl(j2);
        DecayAnimationSpec<Float> flingAnimationSpec = exitUntilCollapsedScrollBehavior$nestedScrollConnection$1.this$0.getFlingAnimationSpec();
        AnimationSpec<Float> snapAnimationSpec = exitUntilCollapsedScrollBehavior$nestedScrollConnection$1.this$0.getSnapAnimationSpec();
        c1173x78ae0263.L$0 = null;
        c1173x78ae0263.J$0 = j4;
        c1173x78ae0263.label = 2;
        objM5713onPostFlingRZ2iAVY$suspendImpl = AppBarKt.settleAppBar(state, f, flingAnimationSpec, snapAnimationSpec, c1173x78ae0263);
        if (objM5713onPostFlingRZ2iAVY$suspendImpl == coroutine_suspended) {
            return coroutine_suspended;
        }
        j3 = j4;
        return Velocity.box-impl(Velocity.plus-AH228Gc(j3, ((Velocity) objM5713onPostFlingRZ2iAVY$suspendImpl).unbox-impl()));
    }
}
