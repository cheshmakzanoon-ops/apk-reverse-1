package androidx.compose.foundation.gestures;

import androidx.compose.p002ui.geometry.Offset;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.Draggable2DNode$onDragStarted$1", f = "Draggable2D.kt", i = {}, l = {427}, m = "invokeSuspend", n = {}, s = {})
final class Draggable2DNode$onDragStarted$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final long $startedPosition;
    private Object L$0;
    int label;
    final Draggable2DNode this$0;

    Draggable2DNode$onDragStarted$1(Draggable2DNode draggable2DNode, long j, Continuation<? super Draggable2DNode$onDragStarted$1> continuation) {
        super(2, continuation);
        this.this$0 = draggable2DNode;
        this.$startedPosition = j;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> draggable2DNode$onDragStarted$1 = new Draggable2DNode$onDragStarted$1(this.this$0, this.$startedPosition, continuation);
        draggable2DNode$onDragStarted$1.L$0 = obj;
        return draggable2DNode$onDragStarted$1;
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
            Function3 function3 = this.this$0.onDragStarted;
            Offset offsetM4335boximpl = Offset.m4335boximpl(this.$startedPosition);
            this.label = 1;
            if (function3.invoke(coroutineScope, offsetM4335boximpl, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
