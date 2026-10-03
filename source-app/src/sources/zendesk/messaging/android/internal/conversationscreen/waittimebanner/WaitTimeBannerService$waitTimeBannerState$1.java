package zendesk.messaging.android.internal.conversationscreen.waittimebanner;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import zendesk.logger.Logger;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerType;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "", "it", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$waitTimeBannerState$1", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class WaitTimeBannerService$waitTimeBannerState$1 extends SuspendLambda implements Function2<WaitTimeBannerType, Continuation<? super Unit>, Object> {
    Object L$0;
    int label;
    final WaitTimeBannerService this$0;

    WaitTimeBannerService$waitTimeBannerState$1(WaitTimeBannerService waitTimeBannerService, Continuation<? super WaitTimeBannerService$waitTimeBannerState$1> continuation) {
        super(2, continuation);
        this.this$0 = waitTimeBannerService;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        WaitTimeBannerService$waitTimeBannerState$1 waitTimeBannerService$waitTimeBannerState$1 = new WaitTimeBannerService$waitTimeBannerState$1(this.this$0, continuation);
        waitTimeBannerService$waitTimeBannerState$1.L$0 = obj;
        return waitTimeBannerService$waitTimeBannerState$1;
    }

    @Override
    public final Object invoke(WaitTimeBannerType waitTimeBannerType, Continuation<? super Unit> continuation) {
        return ((WaitTimeBannerService$waitTimeBannerState$1) create(waitTimeBannerType, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        if (this.label != 0) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        Logger.m221i("WaitTimeBannerService", "Wait time banner state updated: " + ((WaitTimeBannerType) this.L$0), new Object[0]);
        this.this$0.retries = 0;
        this.this$0.checkPollingStatus();
        return Unit.INSTANCE;
    }
}
