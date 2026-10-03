package zendesk.android.internal.frontendevents.analyticsevents;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.internal.extension.DateTimeExt;
import zendesk.android.internal.frontendevents.analyticsevents.model.ProactiveCampaignAnalyticsAction;
import zendesk.android.internal.frontendevents.analyticsevents.model.ProactiveCampaignAnalyticsDTO;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.internal.frontendevents.analyticsevents.ProactiveMessagingAnalyticsManager$subscribe$1$1", m37f = "ProactiveMessagingAnalyticsManager.kt", m38i = {}, m39l = {58}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ProactiveMessagingAnalyticsManager$subscribe$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final ProactiveCampaignAnalyticsAction $action;
    final String $campaignId;
    final int $campaignVersion;
    int label;
    final ProactiveMessagingAnalyticsManager this$0;

    ProactiveMessagingAnalyticsManager$subscribe$1$1(ProactiveMessagingAnalyticsManager proactiveMessagingAnalyticsManager, String str, ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction, int i, Continuation<? super ProactiveMessagingAnalyticsManager$subscribe$1$1> continuation) {
        super(2, continuation);
        this.this$0 = proactiveMessagingAnalyticsManager;
        this.$campaignId = str;
        this.$action = proactiveCampaignAnalyticsAction;
        this.$campaignVersion = i;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ProactiveMessagingAnalyticsManager$subscribe$1$1(this.this$0, this.$campaignId, this.$action, this.$campaignVersion, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((ProactiveMessagingAnalyticsManager$subscribe$1$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO = new ProactiveCampaignAnalyticsDTO(this.$campaignId, this.$action, DateTimeExt.INSTANCE.currentIso8601UtcTimestamp(), this.$campaignVersion, this.this$0.visitorId);
            this.label = 1;
            if (this.this$0.frontendEventsRepository.sendProactiveMessagingAnalyticsEvent(proactiveCampaignAnalyticsDTO, this) == coroutine_suspended) {
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
