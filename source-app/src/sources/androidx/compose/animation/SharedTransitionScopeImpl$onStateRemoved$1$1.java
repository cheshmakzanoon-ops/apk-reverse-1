package androidx.compose.animation;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.animation.SharedTransitionScopeImpl$onStateRemoved$1$1", f = "SharedTransitionScope.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
final class SharedTransitionScopeImpl$onStateRemoved$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final SharedElement $this_with;
    int label;

    SharedTransitionScopeImpl$onStateRemoved$1$1(SharedElement sharedElement, Continuation<? super SharedTransitionScopeImpl$onStateRemoved$1$1> continuation) {
        super(2, continuation);
        this.$this_with = sharedElement;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new SharedTransitionScopeImpl$onStateRemoved$1$1(this.$this_with, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        if (this.label != 0) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        if (this.$this_with.getStates().isEmpty()) {
            this.$this_with.getScope().sharedElements.remove(this.$this_with.getKey());
        }
        return Unit.INSTANCE;
    }
}
