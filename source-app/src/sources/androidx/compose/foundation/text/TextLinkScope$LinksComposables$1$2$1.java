package androidx.compose.foundation.text;

import androidx.compose.foundation.interaction.MutableInteractionSource;
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
@DebugMetadata(c = "androidx.compose.foundation.text.TextLinkScope$LinksComposables$1$2$1", f = "TextLinkScope.kt", i = {}, l = {177}, m = "invokeSuspend", n = {}, s = {})
final class TextLinkScope$LinksComposables$1$2$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final MutableInteractionSource $interactionSource;
    final LinkStateInteractionSourceObserver $linkStateObserver;
    int label;

    TextLinkScope$LinksComposables$1$2$1(LinkStateInteractionSourceObserver linkStateInteractionSourceObserver, MutableInteractionSource mutableInteractionSource, Continuation<? super TextLinkScope$LinksComposables$1$2$1> continuation) {
        super(2, continuation);
        this.$linkStateObserver = linkStateInteractionSourceObserver;
        this.$interactionSource = mutableInteractionSource;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new TextLinkScope$LinksComposables$1$2$1(this.$linkStateObserver, this.$interactionSource, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            if (this.$linkStateObserver.collectInteractionsForLinks(this.$interactionSource, (Continuation) this) == coroutine_suspended) {
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
