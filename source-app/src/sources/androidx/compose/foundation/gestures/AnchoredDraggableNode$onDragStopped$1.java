package androidx.compose.foundation.gestures;

import androidx.compose.foundation.OverscrollEffect;
import androidx.compose.ui.unit.Velocity;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "T", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.AnchoredDraggableNode$onDragStopped$1", f = "AnchoredDraggable.kt", i = {}, l = {275, 277}, m = "invokeSuspend", n = {}, s = {})
final class AnchoredDraggableNode$onDragStopped$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final long $velocity;
    Object L$0;
    int label;
    final AnchoredDraggableNode<T> this$0;

    AnchoredDraggableNode$onDragStopped$1(AnchoredDraggableNode<T> anchoredDraggableNode, long j, Continuation<? super AnchoredDraggableNode$onDragStopped$1> continuation) {
        super(2, continuation);
        this.this$0 = anchoredDraggableNode;
        this.$velocity = j;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new AnchoredDraggableNode$onDragStopped$1(this.this$0, this.$velocity, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        AnchoredDraggableNode anchoredDraggableNode;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (((AnchoredDraggableNode) this.this$0).overscrollEffect != null) {
                OverscrollEffect overscrollEffect = ((AnchoredDraggableNode) this.this$0).overscrollEffect;
                Intrinsics.checkNotNull(overscrollEffect);
                this.label = 2;
                if (overscrollEffect.mo500applyToFlingBMRW4eQ(this.this$0.m687reverseIfNeededAH228Gc(this.$velocity), new C04311(this.this$0, null), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                AnchoredDraggableNode anchoredDraggableNode2 = this.this$0;
                AnchoredDraggableState anchoredDraggableState = anchoredDraggableNode2.state;
                AnchoredDraggableNode<T> anchoredDraggableNode3 = this.this$0;
                this.L$0 = anchoredDraggableNode2;
                this.label = 1;
                Object obj2 = anchoredDraggableState.settle(anchoredDraggableNode3.m689toFloatTH1AsA0(anchoredDraggableNode3.m687reverseIfNeededAH228Gc(this.$velocity)), (Continuation) this);
                if (obj2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                anchoredDraggableNode = anchoredDraggableNode2;
                obj = obj2;
                anchoredDraggableNode.m692toVelocityadjELrA(((Number) obj).floatValue());
            }
        } else if (i == 1) {
            anchoredDraggableNode = (AnchoredDraggableNode) this.L$0;
            ResultKt.throwOnFailure(obj);
            anchoredDraggableNode.m692toVelocityadjELrA(((Number) obj).floatValue());
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0001H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/ui/unit/Velocity;", "T", "availableVelocity"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.AnchoredDraggableNode$onDragStopped$1$1", f = "AnchoredDraggable.kt", i = {0}, l = {280}, m = "invokeSuspend", n = {"availableVelocity"}, s = {"J$0"})
    static final class C04311 extends SuspendLambda implements Function2<Velocity, Continuation<? super Velocity>, Object> {
        long J$0;
        Object L$0;
        int label;
        final AnchoredDraggableNode<T> this$0;

        C04311(AnchoredDraggableNode<T> anchoredDraggableNode, Continuation<? super C04311> continuation) {
            super(2, continuation);
            this.this$0 = anchoredDraggableNode;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04311 = new C04311(this.this$0, continuation);
            c04311.J$0 = ((Velocity) obj).unbox-impl();
            return c04311;
        }

        public Object invoke(Object obj, Object obj2) {
            return m696invokesFctU(((Velocity) obj).unbox-impl(), (Continuation) obj2);
        }

        public final Object m696invokesFctU(long j, Continuation<? super Velocity> continuation) {
            return create(Velocity.box-impl(j), continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            AnchoredDraggableNode anchoredDraggableNode;
            long j;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                long j2 = this.J$0;
                AnchoredDraggableNode anchoredDraggableNode2 = this.this$0;
                this.L$0 = anchoredDraggableNode2;
                this.J$0 = j2;
                this.label = 1;
                Object obj2 = anchoredDraggableNode2.state.settle(this.this$0.m689toFloatTH1AsA0(j2), (Continuation) this);
                if (obj2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                anchoredDraggableNode = anchoredDraggableNode2;
                obj = obj2;
                j = j2;
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                j = this.J$0;
                anchoredDraggableNode = (AnchoredDraggableNode) this.L$0;
                ResultKt.throwOnFailure(obj);
            }
            long jM692toVelocityadjELrA = anchoredDraggableNode.m692toVelocityadjELrA(((Number) obj).floatValue());
            float fRequireOffset = ((AnchoredDraggableNode) this.this$0).state.requireOffset();
            float fMinAnchor = ((AnchoredDraggableNode) this.this$0).state.getAnchors().minAnchor();
            if (fRequireOffset >= ((AnchoredDraggableNode) this.this$0).state.getAnchors().maxAnchor() || fRequireOffset <= fMinAnchor) {
                j = jM692toVelocityadjELrA;
            }
            return Velocity.box-impl(j);
        }
    }
}
