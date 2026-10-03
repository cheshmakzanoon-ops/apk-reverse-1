package zendesk.android.internal;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.internal.p013di.ZendeskComponent;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "", "it", "Lzendesk/android/events/ZendeskEvent;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.internal.ZendeskFactory$initialiseNativeMessaging$messaging$1", m37f = "ZendeskFactory.kt", m38i = {}, m39l = {129}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ZendeskFactory$initialiseNativeMessaging$messaging$1 extends SuspendLambda implements Function2<ZendeskEvent, Continuation<? super Unit>, Object> {
    final ZendeskComponent $zendeskComponent;
    Object L$0;
    int label;

    ZendeskFactory$initialiseNativeMessaging$messaging$1(ZendeskComponent zendeskComponent, Continuation<? super ZendeskFactory$initialiseNativeMessaging$messaging$1> continuation) {
        super(2, continuation);
        this.$zendeskComponent = zendeskComponent;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        ZendeskFactory$initialiseNativeMessaging$messaging$1 zendeskFactory$initialiseNativeMessaging$messaging$1 = new ZendeskFactory$initialiseNativeMessaging$messaging$1(this.$zendeskComponent, continuation);
        zendeskFactory$initialiseNativeMessaging$messaging$1.L$0 = obj;
        return zendeskFactory$initialiseNativeMessaging$messaging$1;
    }

    @Override
    public final Object invoke(ZendeskEvent zendeskEvent, Continuation<? super Unit> continuation) {
        return ((ZendeskFactory$initialiseNativeMessaging$messaging$1) create(zendeskEvent, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ZendeskEvent zendeskEvent = (ZendeskEvent) this.L$0;
            this.label = 1;
            if (this.$zendeskComponent.zendeskEventDispatcher().notifyEventListeners(zendeskEvent, this) == coroutine_suspended) {
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
