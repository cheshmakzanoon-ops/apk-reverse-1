package zendesk.messaging.android.internal.conversationscreen;

import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.DelayKt;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.FlowKt;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.VisibleScreenTracker;

@Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0000\u0018\u0000 \u001e2\u00020\u0001:\u0001\u001eB%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ\b\u0010\u0013\u001a\u00020\u0014H\u0002J\u0010\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0018H\u0002J\u000e\u0010\u0019\u001a\u00020\u00162\u0006\u0010\u001a\u001a\u00020\u001bJ\u000e\u0010\u001c\u001a\u00020\u00162\u0006\u0010\u001a\u001a\u00020\u001bJ\u000e\u0010\u001d\u001a\u00020\u00162\u0006\u0010\u001a\u001a\u00020\u001bR\u0014\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\r\u001a\b\u0012\u0004\u0012\u00020\f0\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationTypingEvents;", "", "processLifecycleEventObserver", "Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;", "lifecycleScope", "Lkotlinx/coroutines/CoroutineScope;", "visibleScreenTracker", "Lzendesk/messaging/android/internal/VisibleScreenTracker;", "coroutineScope", "(Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;Lkotlinx/coroutines/CoroutineScope;Lzendesk/messaging/android/internal/VisibleScreenTracker;Lkotlinx/coroutines/CoroutineScope;)V", "_typingEventChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationTypingEvent;", "typingEventChannel", "Lkotlinx/coroutines/flow/Flow;", "getTypingEventChannel", "()Lkotlinx/coroutines/flow/Flow;", "typingEventJob", "Lkotlinx/coroutines/Job;", "canSendTypingStop", "", "dispatchUserTypingEvent", "", "action", "Lzendesk/messaging/android/internal/conversationscreen/ConversationUserTypingAction;", "onSendMessage", "conversationId", "", "onTyping", "subscribeTypingEventsToLifecycle", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationTypingEvents {
    private static final String LOG_TAG = "ConversationTypingEvents";
    public static final long TIME_INTERVAL_IN_MILLIS = 10000;
    private final Channel<ConversationTypingEvent> _typingEventChannel;
    private final CoroutineScope coroutineScope;
    private final CoroutineScope lifecycleScope;
    private final ProcessLifecycleEventObserver processLifecycleEventObserver;
    private final Flow<ConversationTypingEvent> typingEventChannel;
    private Job typingEventJob;
    private final VisibleScreenTracker visibleScreenTracker;

    public ConversationTypingEvents(ProcessLifecycleEventObserver processLifecycleEventObserver, CoroutineScope lifecycleScope, VisibleScreenTracker visibleScreenTracker, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(processLifecycleEventObserver, "processLifecycleEventObserver");
        Intrinsics.checkNotNullParameter(lifecycleScope, "lifecycleScope");
        Intrinsics.checkNotNullParameter(visibleScreenTracker, "visibleScreenTracker");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        this.processLifecycleEventObserver = processLifecycleEventObserver;
        this.lifecycleScope = lifecycleScope;
        this.visibleScreenTracker = visibleScreenTracker;
        this.coroutineScope = coroutineScope;
        Channel<ConversationTypingEvent> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._typingEventChannel = channelChannel$default;
        this.typingEventChannel = FlowKt.receiveAsFlow(channelChannel$default);
    }

    public final Flow<ConversationTypingEvent> getTypingEventChannel() {
        return this.typingEventChannel;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationTypingEvents$subscribeTypingEventsToLifecycle$1", m37f = "ConversationTypingEvents.kt", m38i = {}, m39l = {46}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13651 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        int label;

        C13651(String str, Continuation<? super C13651> continuation) {
            super(2, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationTypingEvents.this.new C13651(this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13651) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<Boolean> flowIsInForeground = ConversationTypingEvents.this.processLifecycleEventObserver.isInForeground();
                final ConversationTypingEvents conversationTypingEvents = ConversationTypingEvents.this;
                final String str = this.$conversationId;
                this.label = 1;
                if (flowIsInForeground.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit(((Boolean) obj2).booleanValue(), (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(boolean z, Continuation<? super Unit> continuation) {
                        if (!z && conversationTypingEvents.canSendTypingStop()) {
                            conversationTypingEvents.dispatchUserTypingEvent(new ConversationUserTypingAction.TypingStop(str));
                        }
                        return Unit.INSTANCE;
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

    public final void subscribeTypingEventsToLifecycle(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        BuildersKt__Builders_commonKt.launch$default(this.lifecycleScope, null, null, new C13651(conversationId, null), 3, null);
        BuildersKt__Builders_commonKt.launch$default(this.lifecycleScope, null, null, new C13662(conversationId, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationTypingEvents$subscribeTypingEventsToLifecycle$2", m37f = "ConversationTypingEvents.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13662 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        int label;

        C13662(String str, Continuation<? super C13662> continuation) {
            super(2, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationTypingEvents.this.new C13662(this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13662) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                if (ConversationTypingEvents.this.visibleScreenTracker.getVisibleScreens$zendesk_messaging_messaging_android() == null && ConversationTypingEvents.this.canSendTypingStop()) {
                    ConversationTypingEvents.this.dispatchUserTypingEvent(new ConversationUserTypingAction.TypingStop(this.$conversationId));
                }
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final boolean canSendTypingStop() {
        Job job = this.typingEventJob;
        if (job != null) {
            return job != null ? job.isActive() : false;
        }
        return false;
    }

    public final void onTyping(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Job job = this.typingEventJob;
        if (job == null || (job != null && job.isCompleted())) {
            dispatchUserTypingEvent(new ConversationUserTypingAction.TypingStart(conversationId));
        } else {
            Job job2 = this.typingEventJob;
            if (job2 != null) {
                Job.DefaultImpls.cancel$default(job2, (CancellationException) null, 1, (Object) null);
            }
        }
        this.typingEventJob = BuildersKt__Builders_commonKt.launch$default(this.lifecycleScope, null, null, new C13641(conversationId, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationTypingEvents$onTyping$1", m37f = "ConversationTypingEvents.kt", m38i = {0}, m39l = {85}, m40m = "invokeSuspend", m41n = {"$this$launch"}, m42s = {"L$0"})
    static final class C13641 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        private Object L$0;
        int label;

        C13641(String str, Continuation<? super C13641> continuation) {
            super(2, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C13641 c13641 = ConversationTypingEvents.this.new C13641(this.$conversationId, continuation);
            c13641.L$0 = obj;
            return c13641;
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13641) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            CoroutineScope coroutineScope;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope2 = (CoroutineScope) this.L$0;
                this.L$0 = coroutineScope2;
                this.label = 1;
                if (DelayKt.delay(ConversationTypingEvents.TIME_INTERVAL_IN_MILLIS, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                coroutineScope = coroutineScope2;
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                coroutineScope = (CoroutineScope) this.L$0;
                ResultKt.throwOnFailure(obj);
            }
            if (CoroutineScopeKt.isActive(coroutineScope)) {
                ConversationTypingEvents.this.dispatchUserTypingEvent(new ConversationUserTypingAction.TypingStop(this.$conversationId));
            }
            return Unit.INSTANCE;
        }
    }

    public final void onSendMessage(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        if (canSendTypingStop()) {
            dispatchUserTypingEvent(new ConversationUserTypingAction.TypingStop(conversationId));
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationTypingEvents$dispatchUserTypingEvent$1", m37f = "ConversationTypingEvents.kt", m38i = {}, m39l = {112, 118}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13631 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationUserTypingAction $action;
        int label;
        final ConversationTypingEvents this$0;

        C13631(ConversationUserTypingAction conversationUserTypingAction, ConversationTypingEvents conversationTypingEvents, Continuation<? super C13631> continuation) {
            super(2, continuation);
            this.$action = conversationUserTypingAction;
            this.this$0 = conversationTypingEvents;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C13631(this.$action, this.this$0, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13631) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationUserTypingAction conversationUserTypingAction = this.$action;
                if (conversationUserTypingAction instanceof ConversationUserTypingAction.TypingStart) {
                    Logger.m221i(ConversationTypingEvents.LOG_TAG, "Sending typing start event", new Object[0]);
                    this.label = 1;
                    if (this.this$0._typingEventChannel.send(new ConversationTypingEvent.TypingStart(((ConversationUserTypingAction.TypingStart) this.$action).getConversationId()), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else if (conversationUserTypingAction instanceof ConversationUserTypingAction.TypingStop) {
                    Logger.m221i(ConversationTypingEvents.LOG_TAG, "Sending typing stop event", new Object[0]);
                    this.label = 2;
                    if (this.this$0._typingEventChannel.send(new ConversationTypingEvent.TypingStop(((ConversationUserTypingAction.TypingStop) this.$action).getConversationId()), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i != 1 && i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public final void dispatchUserTypingEvent(ConversationUserTypingAction action) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C13631(action, this, null), 3, null);
        Job job = this.typingEventJob;
        if (job != null) {
            Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
        }
    }
}
