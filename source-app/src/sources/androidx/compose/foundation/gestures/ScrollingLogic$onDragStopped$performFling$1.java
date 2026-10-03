package androidx.compose.foundation.gestures;

import androidx.compose.ui.unit.Velocity;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0001H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/ui/unit/Velocity;", "velocity"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollingLogic$onDragStopped$performFling$1", f = "Scrollable.kt", i = {0, 1, 1, 2, 2}, l = {745, 748, 751}, m = "invokeSuspend", n = {"velocity", "velocity", "available", "velocity", "velocityLeft"}, s = {"J$0", "J$0", "J$1", "J$0", "J$1"})
final class ScrollingLogic$onDragStopped$performFling$1 extends SuspendLambda implements Function2<Velocity, Continuation<? super Velocity>, Object> {
    long J$0;
    long J$1;
    int label;
    final ScrollingLogic this$0;

    ScrollingLogic$onDragStopped$performFling$1(ScrollingLogic scrollingLogic, Continuation<? super ScrollingLogic$onDragStopped$performFling$1> continuation) {
        super(2, continuation);
        this.this$0 = scrollingLogic;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> scrollingLogic$onDragStopped$performFling$1 = new ScrollingLogic$onDragStopped$performFling$1(this.this$0, continuation);
        scrollingLogic$onDragStopped$performFling$1.J$0 = ((Velocity) obj).unbox-impl();
        return scrollingLogic$onDragStopped$performFling$1;
    }

    public Object invoke(Object obj, Object obj2) {
        return m849invokesFctU(((Velocity) obj).unbox-impl(), (Continuation) obj2);
    }

    public final Object m849invokesFctU(long j, Continuation<? super Velocity> continuation) {
        return create(Velocity.box-impl(j), continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object objM5721dispatchPreFlingQWom1Mo;
        long j;
        long j2;
        Object objM842doFlingAnimationQWom1Mo;
        long j3;
        Object objM5719dispatchPostFlingRZ2iAVY;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            long j4 = this.J$0;
            this.J$0 = j4;
            this.label = 1;
            objM5721dispatchPreFlingQWom1Mo = this.this$0.nestedScrollDispatcher.m5721dispatchPreFlingQWom1Mo(j4, (Continuation) this);
            if (objM5721dispatchPreFlingQWom1Mo == coroutine_suspended) {
                return coroutine_suspended;
            }
            j = j4;
        } else {
            if (i == 1) {
                j = this.J$0;
                ResultKt.throwOnFailure(obj);
                objM5721dispatchPreFlingQWom1Mo = obj;
            } else if (i == 2) {
                long j5 = this.J$1;
                long j6 = this.J$0;
                ResultKt.throwOnFailure(obj);
                objM842doFlingAnimationQWom1Mo = obj;
                j = j6;
                j2 = j5;
                long j7 = ((Velocity) objM842doFlingAnimationQWom1Mo).unbox-impl();
                this.J$0 = j;
                this.J$1 = j7;
                this.label = 3;
                j3 = j7;
                objM5719dispatchPostFlingRZ2iAVY = this.this$0.nestedScrollDispatcher.m5719dispatchPostFlingRZ2iAVY(Velocity.minus-AH228Gc(j2, j7), j7, (Continuation) this);
                if (objM5719dispatchPostFlingRZ2iAVY == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                long j8 = this.J$1;
                long j9 = this.J$0;
                ResultKt.throwOnFailure(obj);
                j = j9;
                j3 = j8;
                objM5719dispatchPostFlingRZ2iAVY = obj;
            }
            return Velocity.box-impl(Velocity.minus-AH228Gc(j, Velocity.minus-AH228Gc(j3, ((Velocity) objM5719dispatchPostFlingRZ2iAVY).unbox-impl())));
        }
        j2 = Velocity.minus-AH228Gc(j, ((Velocity) objM5721dispatchPreFlingQWom1Mo).unbox-impl());
        this.J$0 = j;
        this.J$1 = j2;
        this.label = 2;
        objM842doFlingAnimationQWom1Mo = this.this$0.m842doFlingAnimationQWom1Mo(j2, (Continuation) this);
        if (objM842doFlingAnimationQWom1Mo == coroutine_suspended) {
            return coroutine_suspended;
        }
        long j10 = ((Velocity) objM842doFlingAnimationQWom1Mo).unbox-impl();
        this.J$0 = j;
        this.J$1 = j10;
        this.label = 3;
        j3 = j10;
        objM5719dispatchPostFlingRZ2iAVY = this.this$0.nestedScrollDispatcher.m5719dispatchPostFlingRZ2iAVY(Velocity.minus-AH228Gc(j2, j10), j10, (Continuation) this);
        if (objM5719dispatchPostFlingRZ2iAVY == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Velocity.box-impl(Velocity.minus-AH228Gc(j, Velocity.minus-AH228Gc(j3, ((Velocity) objM5719dispatchPostFlingRZ2iAVY).unbox-impl())));
    }
}
