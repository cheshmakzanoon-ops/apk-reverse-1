package zendesk.android.events.internal;

import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;
import javax.inject.Inject;
import javax.inject.Named;
import javax.inject.Singleton;
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
import zendesk.android.events.ZendeskEvent;
import zendesk.android.events.ZendeskEventListener;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;

@Singleton
@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010#\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0001\u0018\u00002\u00020\u0001B\u0011\b\u0001\u0012\b\b\u0001\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0016\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u0007H\u0086@¢\u0006\u0002\u0010\u000bJ\u0016\u0010\f\u001a\u00020\t2\u0006\u0010\r\u001a\u00020\u000eH\u0086@¢\u0006\u0002\u0010\u000fJ\u0016\u0010\u0010\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u0007H\u0086@¢\u0006\u0002\u0010\u000bR\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/events/internal/ZendeskEventDispatcher;", "", "mainDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "(Lkotlinx/coroutines/CoroutineDispatcher;)V", "listeners", "", "Lzendesk/android/events/ZendeskEventListener;", "addEventListener", "", "listener", "(Lzendesk/android/events/ZendeskEventListener;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "notifyEventListeners", "event", "Lzendesk/android/events/ZendeskEvent;", "(Lzendesk/android/events/ZendeskEvent;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeEventListener", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskEventDispatcher {
    private final Set<ZendeskEventListener> listeners;
    private final CoroutineDispatcher mainDispatcher;

    @Inject
    public ZendeskEventDispatcher(@Named(CoroutineDispatchersModule.MAIN_DISPATCHER) CoroutineDispatcher mainDispatcher) {
        Intrinsics.checkNotNullParameter(mainDispatcher, "mainDispatcher");
        this.mainDispatcher = mainDispatcher;
        this.listeners = new LinkedHashSet();
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.events.internal.ZendeskEventDispatcher$addEventListener$2", m37f = "ZendeskEventDispatcher.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09422 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ZendeskEventListener $listener;
        int label;

        C09422(ZendeskEventListener zendeskEventListener, Continuation<? super C09422> continuation) {
            super(2, continuation);
            this.$listener = zendeskEventListener;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ZendeskEventDispatcher.this.new C09422(this.$listener, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09422) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                ZendeskEventDispatcher.this.listeners.add(this.$listener);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object addEventListener(ZendeskEventListener zendeskEventListener, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.mainDispatcher, new C09422(zendeskEventListener, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.events.internal.ZendeskEventDispatcher$removeEventListener$2", m37f = "ZendeskEventDispatcher.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09442 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ZendeskEventListener $listener;
        int label;

        C09442(ZendeskEventListener zendeskEventListener, Continuation<? super C09442> continuation) {
            super(2, continuation);
            this.$listener = zendeskEventListener;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ZendeskEventDispatcher.this.new C09442(this.$listener, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09442) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                ZendeskEventDispatcher.this.listeners.remove(this.$listener);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object removeEventListener(ZendeskEventListener zendeskEventListener, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.mainDispatcher, new C09442(zendeskEventListener, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.events.internal.ZendeskEventDispatcher$notifyEventListeners$2", m37f = "ZendeskEventDispatcher.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09432 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ZendeskEvent $event;
        int label;

        C09432(ZendeskEvent zendeskEvent, Continuation<? super C09432> continuation) {
            super(2, continuation);
            this.$event = zendeskEvent;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ZendeskEventDispatcher.this.new C09432(this.$event, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09432) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                Set set = ZendeskEventDispatcher.this.listeners;
                ZendeskEvent zendeskEvent = this.$event;
                Iterator it = set.iterator();
                while (it.hasNext()) {
                    ((ZendeskEventListener) it.next()).onEvent(zendeskEvent);
                }
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object notifyEventListeners(ZendeskEvent zendeskEvent, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.mainDispatcher, new C09432(zendeskEvent, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }
}
