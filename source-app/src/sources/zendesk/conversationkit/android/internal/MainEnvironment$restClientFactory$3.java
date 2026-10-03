package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;

@Metadata(m17d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u000e\u0010\u0000\u001a\u00020\u0001H\u008a@"}, m18d2 = {"<anonymous>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.conversationkit.android.internal.MainEnvironment$restClientFactory$3", m37f = "Environment.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class MainEnvironment$restClientFactory$3 extends SuspendLambda implements Function1<Continuation<? super String>, Object> {
    int label;
    final MainEnvironment this$0;

    MainEnvironment$restClientFactory$3(MainEnvironment mainEnvironment, Continuation<? super MainEnvironment$restClientFactory$3> continuation) {
        super(1, continuation);
        this.this$0 = mainEnvironment;
    }

    @Override
    public final Continuation<Unit> create(Continuation<?> continuation) {
        return new MainEnvironment$restClientFactory$3(this.this$0, continuation);
    }

    @Override
    public final Object invoke(Continuation<? super String> continuation) {
        return ((MainEnvironment$restClientFactory$3) create(continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        if (this.label != 0) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        return this.this$0.getHostAppInfo().getAppName$zendesk_conversationkit_conversationkit_android() + '/' + this.this$0.getHostAppInfo().getAppVersion$zendesk_conversationkit_conversationkit_android() + " (" + this.this$0.getHostAppInfo().m207x1b9e53ed() + ' ' + this.this$0.getHostAppInfo().getDeviceModel$zendesk_conversationkit_conversationkit_android() + "; Android " + this.this$0.getHostAppInfo().m209xb0259b04() + ')';
    }
}
