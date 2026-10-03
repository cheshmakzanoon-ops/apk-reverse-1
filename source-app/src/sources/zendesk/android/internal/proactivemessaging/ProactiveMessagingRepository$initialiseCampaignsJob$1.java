package zendesk.android.internal.proactivemessaging;

import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import net.aihelp.data.model.p005cs.ConversationMsg;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository$initialiseCampaignsJob$1", m37f = "ProactiveMessagingRepository.kt", m38i = {}, m39l = {ConversationMsg.TYPE_TIMESTAMP, 42}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ProactiveMessagingRepository$initialiseCampaignsJob$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    Object L$0;
    int label;
    final ProactiveMessagingRepository this$0;

    ProactiveMessagingRepository$initialiseCampaignsJob$1(ProactiveMessagingRepository proactiveMessagingRepository, Continuation<? super ProactiveMessagingRepository$initialiseCampaignsJob$1> continuation) {
        super(2, continuation);
        this.this$0 = proactiveMessagingRepository;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ProactiveMessagingRepository$initialiseCampaignsJob$1(this.this$0, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((ProactiveMessagingRepository$initialiseCampaignsJob$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        ProactiveMessagingRepository proactiveMessagingRepository;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            proactiveMessagingRepository = this.this$0;
            this.L$0 = proactiveMessagingRepository;
            this.label = 1;
            obj = proactiveMessagingRepository.getLiveCampaigns(this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i == 1) {
                proactiveMessagingRepository = (ProactiveMessagingRepository) this.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        proactiveMessagingRepository.setCampaigns$zendesk_zendesk_android((List) obj);
        this.L$0 = null;
        this.label = 2;
        if (this.this$0.initializeFilterOutCampaigns(this) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }
}
