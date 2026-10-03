package zendesk.android;

import android.content.Context;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.messaging.MessagingFactory;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.Zendesk$Companion$initialize$1", m37f = "Zendesk.kt", m38i = {}, m39l = {249}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class Zendesk$Companion$initialize$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final String $channelKey;
    final Context $context;
    final FailureCallback<Throwable> $failureCallback;
    final MessagingFactory $messagingFactory;
    final SuccessCallback<Zendesk> $successCallback;
    int label;

    Zendesk$Companion$initialize$1(Context context, String str, MessagingFactory messagingFactory, FailureCallback<Throwable> failureCallback, SuccessCallback<Zendesk> successCallback, Continuation<? super Zendesk$Companion$initialize$1> continuation) {
        super(2, continuation);
        this.$context = context;
        this.$channelKey = str;
        this.$messagingFactory = messagingFactory;
        this.$failureCallback = failureCallback;
        this.$successCallback = successCallback;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new Zendesk$Companion$initialize$1(this.$context, this.$channelKey, this.$messagingFactory, this.$failureCallback, this.$successCallback, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((Zendesk$Companion$initialize$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            obj = Zendesk.Companion.initialize$default(Zendesk.INSTANCE, this.$context, this.$channelKey, this.$messagingFactory, false, (Continuation) this, 8, (Object) null);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        ZendeskResult zendeskResult = (ZendeskResult) obj;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            this.$failureCallback.onFailure((Throwable) ((ZendeskResult.Failure) zendeskResult).getError());
        } else if (zendeskResult instanceof ZendeskResult.Success) {
            this.$successCallback.onSuccess((Zendesk) ((ZendeskResult.Success) zendeskResult).getValue());
        }
        return Unit.INSTANCE;
    }
}
