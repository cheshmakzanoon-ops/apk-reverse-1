package zendesk.android.internal.frontendevents.pageviewevents;

import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.ZendeskResult;
import zendesk.android.internal.frontendevents.FrontendEventsRepository;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.internal.proactivemessaging.ProactiveMessagingManager;
import zendesk.android.pageviewevents.PageView;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u00002\u00020\u0001B!\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\"\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\f0\n2\u0006\u0010\r\u001a\u00020\u000eH\u0096@¢\u0006\u0002\u0010\u000fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/android/internal/frontendevents/pageviewevents/DefaultPageViewEvents;", "Lzendesk/android/internal/frontendevents/pageviewevents/PageViewEvents;", "frontendEventsRepository", "Lzendesk/android/internal/frontendevents/FrontendEventsRepository;", "ioDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "proactiveMessagingManager", "Lzendesk/android/internal/proactivemessaging/ProactiveMessagingManager;", "(Lzendesk/android/internal/frontendevents/FrontendEventsRepository;Lkotlinx/coroutines/CoroutineDispatcher;Lzendesk/android/internal/proactivemessaging/ProactiveMessagingManager;)V", "sendPageViewEvent", "Lzendesk/android/ZendeskResult;", "", "", "pageView", "Lzendesk/android/pageviewevents/PageView;", "(Lzendesk/android/pageviewevents/PageView;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultPageViewEvents implements PageViewEvents {
    private final FrontendEventsRepository frontendEventsRepository;
    private final CoroutineDispatcher ioDispatcher;
    private final ProactiveMessagingManager proactiveMessagingManager;

    @Inject
    public DefaultPageViewEvents(FrontendEventsRepository frontendEventsRepository, @Named(CoroutineDispatchersModule.IO_DISPATCHER) CoroutineDispatcher ioDispatcher, ProactiveMessagingManager proactiveMessagingManager) {
        Intrinsics.checkNotNullParameter(frontendEventsRepository, "frontendEventsRepository");
        Intrinsics.checkNotNullParameter(ioDispatcher, "ioDispatcher");
        Intrinsics.checkNotNullParameter(proactiveMessagingManager, "proactiveMessagingManager");
        this.frontendEventsRepository = frontendEventsRepository;
        this.ioDispatcher = ioDispatcher;
        this.proactiveMessagingManager = proactiveMessagingManager;
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0003\n\u0002\u0018\u0002\u0010\u0000\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001*\u00020\u0004H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/android/ZendeskResult;", "", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.frontendevents.pageviewevents.DefaultPageViewEvents$sendPageViewEvent$2", m37f = "DefaultPageViewEvents.kt", m38i = {1}, m39l = {23, 24}, m40m = "invokeSuspend", m41n = {"result"}, m42s = {"L$0"})
    static final class C09552 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ZendeskResult<? extends Unit, ? extends Throwable>>, Object> {
        final PageView $pageView;
        Object L$0;
        int label;

        C09552(PageView pageView, Continuation<? super C09552> continuation) {
            super(2, continuation);
            this.$pageView = pageView;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultPageViewEvents.this.new C09552(this.$pageView, continuation);
        }

        @Override
        public Object invoke(CoroutineScope coroutineScope, Continuation<? super ZendeskResult<? extends Unit, ? extends Throwable>> continuation) {
            return invoke2(coroutineScope, (Continuation<? super ZendeskResult<Unit, ? extends Throwable>>) continuation);
        }

        public final Object invoke2(CoroutineScope coroutineScope, Continuation<? super ZendeskResult<Unit, ? extends Throwable>> continuation) {
            return ((C09552) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = DefaultPageViewEvents.this.frontendEventsRepository.sendPageViewEvent(this.$pageView, this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ZendeskResult zendeskResult = (ZendeskResult) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    return zendeskResult;
                }
                ResultKt.throwOnFailure(obj);
            }
            ZendeskResult zendeskResult2 = (ZendeskResult) obj;
            this.L$0 = zendeskResult2;
            this.label = 2;
            return DefaultPageViewEvents.this.proactiveMessagingManager.evaluate$zendesk_zendesk_android(this.$pageView, this) == coroutine_suspended ? coroutine_suspended : zendeskResult2;
        }
    }

    @Override
    public Object sendPageViewEvent(PageView pageView, Continuation<? super ZendeskResult<Unit, ? extends Throwable>> continuation) {
        return BuildersKt.withContext(this.ioDispatcher, new C09552(pageView, null), continuation);
    }
}
