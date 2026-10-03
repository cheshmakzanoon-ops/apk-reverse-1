package zendesk.android;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.channels.ProduceKt;
import kotlinx.coroutines.channels.ProducerScope;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.events.ZendeskEventListener;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00030\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/channels/ProducerScope;", "Lzendesk/android/events/ZendeskEvent;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.ZendeskExtensions$eventFlow$1", m37f = "ZendeskExtensions.kt", m38i = {}, m39l = {24}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ZendeskExtensions$eventFlow$1 extends SuspendLambda implements Function2<ProducerScope<? super ZendeskEvent>, Continuation<? super Unit>, Object> {
    final Zendesk $this_eventFlow;
    private Object L$0;
    int label;

    ZendeskExtensions$eventFlow$1(Zendesk zendesk2, Continuation<? super ZendeskExtensions$eventFlow$1> continuation) {
        super(2, continuation);
        this.$this_eventFlow = zendesk2;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        ZendeskExtensions$eventFlow$1 zendeskExtensions$eventFlow$1 = new ZendeskExtensions$eventFlow$1(this.$this_eventFlow, continuation);
        zendeskExtensions$eventFlow$1.L$0 = obj;
        return zendeskExtensions$eventFlow$1;
    }

    @Override
    public final Object invoke(ProducerScope<? super ZendeskEvent> producerScope, Continuation<? super Unit> continuation) {
        return ((ZendeskExtensions$eventFlow$1) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            final ProducerScope producerScope = (ProducerScope) this.L$0;
            final ZendeskEventListener zendeskEventListener = new ZendeskEventListener() {
                @Override
                public final void onEvent(ZendeskEvent zendeskEvent) {
                    producerScope.mo1809trySendJP2dKIU(zendeskEvent);
                }
            };
            this.$this_eventFlow.addEventListener(zendeskEventListener);
            final Zendesk zendesk2 = this.$this_eventFlow;
            this.label = 1;
            if (ProduceKt.awaitClose(producerScope, new Function0<Unit>() {
                {
                    super(0);
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    zendesk2.removeEventListener(zendeskEventListener);
                }
            }, this) == coroutine_suspended) {
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
