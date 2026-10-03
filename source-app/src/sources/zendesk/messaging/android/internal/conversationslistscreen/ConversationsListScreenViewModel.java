package zendesk.messaging.android.internal.conversationslistscreen;

import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelKt;
import cz.msebera.android.httpclient.HttpStatus;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ExtensionsKt;
import kotlinx.collections.immutable.ImmutableList;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.User;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListStateHelperKt;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u0000\u009a\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 ;2\u00020\u0001:\u0001;B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\b\u0010\u001f\u001a\u00020 H\u0002J\u000e\u0010!\u001a\u00020 2\u0006\u0010\"\u001a\u00020#J\u0010\u0010$\u001a\u0004\u0018\u00010%H\u0082@¢\u0006\u0002\u0010&J\u0010\u0010'\u001a\u00020 2\u0006\u0010(\u001a\u00020)H\u0002J(\u0010*\u001a\u00020 2\u000e\b\u0002\u0010+\u001a\b\u0012\u0004\u0012\u00020-0,2\b\b\u0002\u0010.\u001a\u00020/H\u0082@¢\u0006\u0002\u00100J\u000e\u00101\u001a\u00020 H\u0082@¢\u0006\u0002\u0010&J\b\u00102\u001a\u00020 H\u0002J\b\u00103\u001a\u00020 H\u0014J\b\u00104\u001a\u00020 H\u0002J\u0015\u00105\u001a\u00020 2\u0006\u00106\u001a\u000207H\u0000¢\u0006\u0002\b8J\u0010\u00109\u001a\u00020 2\u0006\u0010(\u001a\u00020:H\u0002R\u0014\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000f0\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u000f0\u0014¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\u00120\u001a¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0010\u0010\u001d\u001a\u0004\u0018\u00010\u001eX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006<"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModel;", "Landroidx/lifecycle/ViewModel;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "savedStateHandle", "Landroidx/lifecycle/SavedStateHandle;", "repository", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationsListRepository;", "visibleScreenTracker", "Lzendesk/messaging/android/internal/VisibleScreenTracker;", "(Lzendesk/android/messaging/model/MessagingSettings;Lzendesk/conversationkit/android/ConversationKit;Landroidx/lifecycle/SavedStateHandle;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationsListRepository;Lzendesk/messaging/android/internal/VisibleScreenTracker;)V", "_conversationsListScreenStateFlow", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "_navigationChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents;", "conversationsListScreenStateFlow", "Lkotlinx/coroutines/flow/StateFlow;", "getConversationsListScreenStateFlow", "()Lkotlinx/coroutines/flow/StateFlow;", "eventListener", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "navigationChannel", "Lkotlinx/coroutines/flow/Flow;", "getNavigationChannel", "()Lkotlinx/coroutines/flow/Flow;", "refreshListStateJob", "Lkotlinx/coroutines/Job;", "createNewConversation", "", "dispatchAction", "conversationsListScreenActions", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "getCurrentUser", "Lzendesk/conversationkit/android/model/User;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handleConnectionStatusChanged", "event", "Lzendesk/conversationkit/android/ConversationKitEvent$ConnectionStatusChanged;", "hideLoadingIndicatorViewAndUpdateConversationsList", "conversations", "", "Lzendesk/conversationkit/android/model/Conversation;", "hasMore", "", "(Ljava/util/List;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "loadConversations", "loadMoreConversations", "onCleared", "refreshEntryPointState", "refreshTheme", "newTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "refreshTheme$zendesk_messaging_messaging_android", "updateStateFromConversationKitEvent", "Lzendesk/conversationkit/android/ConversationKitEvent;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListScreenViewModel extends ViewModel {
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "ConversationsListViewModel";
    private final MutableStateFlow<ConversationsListScreenState> _conversationsListScreenStateFlow;
    private final Channel<ConversationsListScreenNavigationEvents> _navigationChannel;
    private final ConversationKit conversationKit;
    private final StateFlow<ConversationsListScreenState> conversationsListScreenStateFlow;
    private final ConversationKitEventListener eventListener;
    private final Flow<ConversationsListScreenNavigationEvents> navigationChannel;
    private Job refreshListStateJob;
    private final ConversationsListRepository repository;
    private final SavedStateHandle savedStateHandle;
    private final VisibleScreenTracker visibleScreenTracker;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[ConversationsListState.values().length];
            try {
                iArr[ConversationsListState.FAILED_ENTRY_POINT.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ConversationsListState.FAILED_CONVERSATIONS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel", m37f = "ConversationsListScreenViewModel.kt", m38i = {}, m39l = {179}, m40m = "getCurrentUser", m41n = {}, m42s = {})
    static final class C14791 extends ContinuationImpl {
        int label;
        Object result;

        C14791(Continuation<? super C14791> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationsListScreenViewModel.this.getCurrentUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel", m37f = "ConversationsListScreenViewModel.kt", m38i = {0, 0, 0, 0, 0}, m39l = {216}, m40m = "hideLoadingIndicatorViewAndUpdateConversationsList", m41n = {"this", "conversations", "$this$update$iv", "prevValue$iv", "hasMore"}, m42s = {"L$0", "L$1", "L$2", "L$3", "Z$0"})
    static final class C14811 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        boolean Z$0;
        int label;
        Object result;

        C14811(Continuation<? super C14811> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationsListScreenViewModel.this.hideLoadingIndicatorViewAndUpdateConversationsList(null, false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel", m37f = "ConversationsListScreenViewModel.kt", m38i = {0, 1}, m39l = {189, 192, 196}, m40m = "loadConversations", m41n = {"this", "this"}, m42s = {"L$0", "L$0"})
    static final class C14821 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C14821(Continuation<? super C14821> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationsListScreenViewModel.this.loadConversations(this);
        }
    }

    public ConversationsListScreenViewModel(MessagingSettings messagingSettings, ConversationKit conversationKit, SavedStateHandle savedStateHandle, ConversationsListRepository repository, VisibleScreenTracker visibleScreenTracker) {
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(savedStateHandle, "savedStateHandle");
        Intrinsics.checkNotNullParameter(repository, "repository");
        Intrinsics.checkNotNullParameter(visibleScreenTracker, "visibleScreenTracker");
        this.conversationKit = conversationKit;
        this.savedStateHandle = savedStateHandle;
        this.repository = repository;
        this.visibleScreenTracker = visibleScreenTracker;
        Channel<ConversationsListScreenNavigationEvents> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._navigationChannel = channelChannel$default;
        this.navigationChannel = FlowKt.receiveAsFlow(channelChannel$default);
        MutableStateFlow<ConversationsListScreenState> MutableStateFlow = StateFlowKt.MutableStateFlow(new ConversationsListScreenState(null, messagingSettings.getTitle(), messagingSettings.getDescription(), messagingSettings.getLogoUrl(), messagingSettings.isMultiConversationsEnabled(), messagingSettings.getCanUserCreateMoreConversations(), null, null, false, null, ConversationsListState.LOADING, false, 0, null, null, 31681, null));
        this._conversationsListScreenStateFlow = MutableStateFlow;
        this.conversationsListScreenStateFlow = FlowKt.asStateFlow(MutableStateFlow);
        ConversationKitEventListener conversationKitEventListener = new ConversationKitEventListener() {
            @Override
            public final void onEvent(ConversationKitEvent conversationKitEvent) {
                ConversationsListScreenViewModel.eventListener$lambda$0(this.f$0, conversationKitEvent);
            }
        };
        this.eventListener = conversationKitEventListener;
        Logger.m217d(LOG_TAG, "Starting to observe a new conversationsListScreenState.", new Object[0]);
        refreshEntryPointState();
        conversationKit.addEventListener(conversationKitEventListener);
    }

    public final Flow<ConversationsListScreenNavigationEvents> getNavigationChannel() {
        return this.navigationChannel;
    }

    public final StateFlow<ConversationsListScreenState> getConversationsListScreenStateFlow() {
        return this.conversationsListScreenStateFlow;
    }

    public static final void eventListener$lambda$0(ConversationsListScreenViewModel this$0, ConversationKitEvent event) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(event, "event");
        if (event instanceof ConversationKitEvent.MessageReceived ? true : event instanceof ConversationKitEvent.MessageUpdated ? true : event instanceof ConversationKitEvent.ConnectionStatusChanged ? true : event instanceof ConversationKitEvent.ConversationAddedSuccess ? true : event instanceof ConversationKitEvent.ConversationRemovedSuccess ? true : event instanceof ConversationKitEvent.ActivityEventReceived) {
            this$0.updateStateFromConversationKitEvent(event);
            return;
        }
        Logger.m217d(LOG_TAG, event.getClass().getSimpleName() + " received.", new Object[0]);
    }

    private final void loadMoreConversations() {
        ConversationsListScreenState value;
        ConversationsListScreenState conversationsListScreenState;
        if (!this.conversationsListScreenStateFlow.getValue().getShouldLoadMore() || this.conversationsListScreenStateFlow.getValue().getLoadMoreStatus() == ConversationEntry.LoadMoreStatus.FAILED) {
            return;
        }
        MutableStateFlow<ConversationsListScreenState> mutableStateFlow = this._conversationsListScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
            conversationsListScreenState = value;
        } while (!mutableStateFlow.compareAndSet(value, conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : this.repository.addLoadMoreEntry$zendesk_messaging_messaging_android(conversationsListScreenState.getConversations(), ConversationEntry.LoadMoreStatus.LOADING, conversationsListScreenState.getMessagingTheme()), (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : ConversationEntry.LoadMoreStatus.LOADING, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null)));
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14832(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel$loadMoreConversations$2", m37f = "ConversationsListScreenViewModel.kt", m38i = {1, 1, 1}, m39l = {128, 134}, m40m = "invokeSuspend", m41n = {"result", "$this$update$iv", "prevValue$iv"}, m42s = {"L$0", "L$1", "L$3"})
    static final class C14832 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;

        C14832(Continuation<? super C14832> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationsListScreenViewModel.this.new C14832(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14832) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r24) throws java.lang.Throwable {
            throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel.C14832.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel$refreshEntryPointState$1", m37f = "ConversationsListScreenViewModel.kt", m38i = {}, m39l = {165}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14841 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14841(Continuation<? super C14841> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationsListScreenViewModel.this.new C14841(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14841) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (ConversationsListScreenViewModel.this.loadConversations(this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
            } catch (Exception e) {
                MutableStateFlow mutableStateFlow = ConversationsListScreenViewModel.this._conversationsListScreenStateFlow;
                do {
                    value = mutableStateFlow.getValue();
                } while (!mutableStateFlow.compareAndSet(value, ConversationsListStateHelperKt.errorState(e, (ConversationsListScreenState) value, ConversationsListState.FAILED_ENTRY_POINT)));
            }
            return Unit.INSTANCE;
        }
    }

    private final void refreshEntryPointState() {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14841(null), 3, null);
    }

    public final Object getCurrentUser(Continuation<? super User> continuation) throws Throwable {
        C14791 c14791;
        if (continuation instanceof C14791) {
            c14791 = (C14791) continuation;
            if ((c14791.label & Integer.MIN_VALUE) != 0) {
                c14791.label -= Integer.MIN_VALUE;
            } else {
                c14791 = new C14791(continuation);
            }
        } else {
            c14791 = new C14791(continuation);
        }
        Object currentUser = c14791.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14791.label;
        if (i == 0) {
            ResultKt.throwOnFailure(currentUser);
            ConversationKit conversationKit = this.conversationKit;
            c14791.label = 1;
            currentUser = conversationKit.getCurrentUser(c14791);
            if (currentUser == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(currentUser);
        }
        User user = (User) currentUser;
        if (user != null) {
            return user;
        }
        Logger.m221i(LOG_TAG, "No user created yet.", new Object[0]);
        return null;
    }

    public final Object loadConversations(Continuation<? super Unit> continuation) throws Throwable {
        C14821 c14821;
        ConversationsListScreenViewModel conversationsListScreenViewModel;
        ConversationsListScreenState value;
        Channel<ConversationsListScreenNavigationEvents> channel;
        ConversationsListScreenNavigationEvents.NotificationPermissions notificationPermissions;
        if (continuation instanceof C14821) {
            c14821 = (C14821) continuation;
            if ((c14821.label & Integer.MIN_VALUE) != 0) {
                c14821.label -= Integer.MIN_VALUE;
            } else {
                c14821 = new C14821(continuation);
            }
        } else {
            c14821 = new C14821(continuation);
        }
        Object objFetchConversations$zendesk_messaging_messaging_android$default = c14821.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14821.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objFetchConversations$zendesk_messaging_messaging_android$default);
            ConversationsListRepository conversationsListRepository = this.repository;
            c14821.L$0 = this;
            c14821.label = 1;
            objFetchConversations$zendesk_messaging_messaging_android$default = ConversationsListRepository.fetchConversations$zendesk_messaging_messaging_android$default(conversationsListRepository, 0, c14821, 1, null);
            if (objFetchConversations$zendesk_messaging_messaging_android$default == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationsListScreenViewModel = this;
        } else {
            if (i == 1) {
                conversationsListScreenViewModel = (ConversationsListScreenViewModel) c14821.L$0;
                ResultKt.throwOnFailure(objFetchConversations$zendesk_messaging_messaging_android$default);
            } else if (i == 2) {
                conversationsListScreenViewModel = (ConversationsListScreenViewModel) c14821.L$0;
                ResultKt.throwOnFailure(objFetchConversations$zendesk_messaging_messaging_android$default);
                channel = conversationsListScreenViewModel._navigationChannel;
                notificationPermissions = ConversationsListScreenNavigationEvents.NotificationPermissions.INSTANCE;
                c14821.L$0 = null;
                c14821.label = 3;
                if (channel.send(notificationPermissions, c14821) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objFetchConversations$zendesk_messaging_messaging_android$default);
            }
            return Unit.INSTANCE;
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) objFetchConversations$zendesk_messaging_messaging_android$default;
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            ConversationKitResult.Success success = (ConversationKitResult.Success) conversationKitResult;
            List<Conversation> conversations = ((ConversationsPagination) success.getValue()).getConversations();
            boolean hasMore = ((ConversationsPagination) success.getValue()).getHasMore();
            c14821.L$0 = conversationsListScreenViewModel;
            c14821.label = 2;
            if (conversationsListScreenViewModel.hideLoadingIndicatorViewAndUpdateConversationsList(conversations, hasMore, c14821) == coroutine_suspended) {
                return coroutine_suspended;
            }
            channel = conversationsListScreenViewModel._navigationChannel;
            notificationPermissions = ConversationsListScreenNavigationEvents.NotificationPermissions.INSTANCE;
            c14821.L$0 = null;
            c14821.label = 3;
            if (channel.send(notificationPermissions, c14821) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            MutableStateFlow<ConversationsListScreenState> mutableStateFlow = conversationsListScreenViewModel._conversationsListScreenStateFlow;
            do {
                value = mutableStateFlow.getValue();
            } while (!mutableStateFlow.compareAndSet(value, ConversationsListStateHelperKt.errorState(((ConversationKitResult.Failure) conversationKitResult).getCause(), value, ConversationsListState.FAILED_ENTRY_POINT)));
        }
        return Unit.INSTANCE;
    }

    public final java.lang.Object hideLoadingIndicatorViewAndUpdateConversationsList(java.util.List<zendesk.conversationkit.android.model.Conversation> r13, boolean r14, kotlin.coroutines.Continuation<? super kotlin.Unit> r15) {
        throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel.hideLoadingIndicatorViewAndUpdateConversationsList(java.util.List, boolean, kotlin.coroutines.Continuation):java.lang.Object");
    }

    static Object hideLoadingIndicatorViewAndUpdateConversationsList$default(ConversationsListScreenViewModel conversationsListScreenViewModel, List list, boolean z, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            list = CollectionsKt.emptyList();
        }
        if ((i & 2) != 0) {
            z = false;
        }
        return conversationsListScreenViewModel.hideLoadingIndicatorViewAndUpdateConversationsList(list, z, continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel$updateStateFromConversationKitEvent$1", m37f = "ConversationsListScreenViewModel.kt", m38i = {0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5}, m39l = {233, 245, 260, 277, 286, 298}, m40m = "invokeSuspend", m41n = {"conversationId", "message", "$this$update$iv", "prevValue$iv", "conversationId", "message", "conversationId", "message", "$this$update$iv", "prevValue$iv", "isNotAuthoredBySameUser", "$this$update$iv", "prevValue$iv", "$this$update$iv", "prevValue$iv", "conversationId", "$this$update$iv", "prevValue$iv"}, m42s = {"L$0", "L$1", "L$2", "L$4", "L$0", "L$1", "L$0", "L$1", "L$2", "L$4", "I$0", "L$0", "L$3", "L$0", "L$3", "L$0", "L$1", "L$3"})
    static final class C14851 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationKitEvent $event;
        int I$0;
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        final ConversationsListScreenViewModel this$0;

        C14851(ConversationKitEvent conversationKitEvent, ConversationsListScreenViewModel conversationsListScreenViewModel, Continuation<? super C14851> continuation) {
            super(2, continuation);
            this.$event = conversationKitEvent;
            this.this$0 = conversationsListScreenViewModel;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C14851(this.$event, this.this$0, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14851) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r36) throws java.lang.Throwable {
            throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel.C14851.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    private final void updateStateFromConversationKitEvent(ConversationKitEvent event) {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14851(event, this, null), 3, null);
    }

    public final void dispatchAction(ConversationsListScreenActions conversationsListScreenActions) {
        ConversationsListScreenState value;
        ConversationsListScreenState conversationsListScreenState;
        ConversationsListScreenState value2;
        ConversationsListScreenState conversationsListScreenState2;
        ConversationsListScreenState value3;
        ConversationsListScreenState conversationsListScreenState3;
        Intrinsics.checkNotNullParameter(conversationsListScreenActions, "conversationsListScreenActions");
        if (conversationsListScreenActions instanceof ConversationsListScreenActions.CreateConversation) {
            createNewConversation();
            return;
        }
        if (conversationsListScreenActions instanceof ConversationsListScreenActions.DismissCreateConversationError) {
            MutableStateFlow<ConversationsListScreenState> mutableStateFlow = this._conversationsListScreenStateFlow;
            do {
                value3 = mutableStateFlow.getValue();
                conversationsListScreenState3 = value3;
            } while (!mutableStateFlow.compareAndSet(value3, conversationsListScreenState3.copy((32639 & 1) != 0 ? conversationsListScreenState3.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState3.title : null, (32639 & 4) != 0 ? conversationsListScreenState3.description : null, (32639 & 8) != 0 ? conversationsListScreenState3.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState3.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState3.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState3.conversations : null, (32639 & 128) != 0 ? conversationsListScreenState3.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState3.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState3.createConversationState : CreateConversationState.IDLE, (32639 & 1024) != 0 ? conversationsListScreenState3.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState3.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState3.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState3.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState3.receivedMessageAuthor : null)));
            return;
        }
        if (conversationsListScreenActions instanceof ConversationsListScreenActions.LoadConversations) {
            loadMoreConversations();
            return;
        }
        if (conversationsListScreenActions instanceof ConversationsListScreenActions.Retry) {
            int i = WhenMappings.$EnumSwitchMapping$0[this.conversationsListScreenStateFlow.getValue().getConversationsListState().ordinal()];
            if (i == 1) {
                refreshEntryPointState();
                return;
            }
            if (i != 2) {
                return;
            }
            Job job = this.refreshListStateJob;
            if (job == null || (job != null && job.isCompleted())) {
                this.refreshListStateJob = BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14782(null), 3, null);
                return;
            }
            return;
        }
        if (conversationsListScreenActions instanceof ConversationsListScreenActions.ResetLoadMoreStatus) {
            MutableStateFlow<ConversationsListScreenState> mutableStateFlow2 = this._conversationsListScreenStateFlow;
            do {
                value2 = mutableStateFlow2.getValue();
                conversationsListScreenState2 = value2;
            } while (!mutableStateFlow2.compareAndSet(value2, conversationsListScreenState2.copy((32639 & 1) != 0 ? conversationsListScreenState2.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState2.title : null, (32639 & 4) != 0 ? conversationsListScreenState2.description : null, (32639 & 8) != 0 ? conversationsListScreenState2.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState2.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState2.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState2.conversations : null, (32639 & 128) != 0 ? conversationsListScreenState2.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState2.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState2.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState2.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState2.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState2.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState2.loadMoreStatus : ConversationEntry.LoadMoreStatus.NONE, (32639 & 16384) != 0 ? conversationsListScreenState2.receivedMessageAuthor : null)));
            return;
        }
        if (Intrinsics.areEqual(conversationsListScreenActions, ConversationsListScreenActions.ResetReceivedMessageAuthor.INSTANCE)) {
            MutableStateFlow<ConversationsListScreenState> mutableStateFlow3 = this._conversationsListScreenStateFlow;
            do {
                value = mutableStateFlow3.getValue();
                conversationsListScreenState = value;
            } while (!mutableStateFlow3.compareAndSet(value, conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : null, (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null)));
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel$dispatchAction$2", m37f = "ConversationsListScreenViewModel.kt", m38i = {0, 0}, m39l = {339}, m40m = "invokeSuspend", m41n = {"$this$update$iv", "prevValue$iv"}, m42s = {"L$0", "L$2"})
    static final class C14782 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C14782(Continuation<? super C14782> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationsListScreenViewModel.this.new C14782(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14782) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r8) {
            throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel.C14782.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public final void handleConnectionStatusChanged(ConversationKitEvent.ConnectionStatusChanged event) {
        ConversationsListScreenState value;
        MutableStateFlow<ConversationsListScreenState> mutableStateFlow = this._conversationsListScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
        } while (!mutableStateFlow.compareAndSet(value, ConversationsListStateHelperKt.connectionStatus(value, event.getConnectionStatus())));
        ConversationsListState conversationsListState = this.conversationsListScreenStateFlow.getValue().getConversationsListState();
        if (event.getConnectionStatus() != ConnectionStatus.CONNECTED_REALTIME || conversationsListState == ConversationsListState.LOADING || conversationsListState == ConversationsListState.FAILED_ENTRY_POINT) {
            return;
        }
        Job job = this.refreshListStateJob;
        if (job == null || (job != null && job.isCompleted())) {
            this.refreshListStateJob = BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14802(null), 3, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel$handleConnectionStatusChanged$2", m37f = "ConversationsListScreenViewModel.kt", m38i = {1, 1}, m39l = {398, 400}, m40m = "invokeSuspend", m41n = {"$this$update$iv", "prevValue$iv"}, m42s = {"L$0", "L$2"})
    static final class C14802 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;

        C14802(Continuation<? super C14802> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationsListScreenViewModel.this.new C14802(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14802) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r13) {
            throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel.C14802.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    private final void createNewConversation() {
        ConversationsListScreenState value;
        MutableStateFlow<ConversationsListScreenState> mutableStateFlow = this._conversationsListScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
        } while (!mutableStateFlow.compareAndSet(value, ConversationsListRepository.m283x91106a58(this.repository, false, true, value, 1, null)));
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14772(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModel$createNewConversation$2", m37f = "ConversationsListScreenViewModel.kt", m38i = {}, m39l = {HttpStatus.SC_METHOD_FAILURE, 430}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14772 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14772(Continuation<? super C14772> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationsListScreenViewModel.this.new C14772(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14772) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            Object value2;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = ConversationsListScreenViewModel.this.repository.createNewConversation$zendesk_messaging_messaging_android(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            ConversationKitResult conversationKitResult = (ConversationKitResult) obj;
            if (conversationKitResult instanceof ConversationKitResult.Success) {
                MutableStateFlow mutableStateFlow = ConversationsListScreenViewModel.this._conversationsListScreenStateFlow;
                ConversationsListScreenViewModel conversationsListScreenViewModel = ConversationsListScreenViewModel.this;
                do {
                    value2 = mutableStateFlow.getValue();
                } while (!mutableStateFlow.compareAndSet(value2, ConversationsListRepository.m283x91106a58(conversationsListScreenViewModel.repository, true, false, (ConversationsListScreenState) value2, 2, null)));
                String id = ((Conversation) ((ConversationKitResult.Success) conversationKitResult).getValue()).getId();
                this.label = 2;
                if (ConversationsListScreenViewModel.this._navigationChannel.send(new ConversationsListScreenNavigationEvents.ConversationScreen(id), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (conversationKitResult instanceof ConversationKitResult.Failure) {
                MutableStateFlow mutableStateFlow2 = ConversationsListScreenViewModel.this._conversationsListScreenStateFlow;
                ConversationsListScreenViewModel conversationsListScreenViewModel2 = ConversationsListScreenViewModel.this;
                do {
                    value = mutableStateFlow2.getValue();
                } while (!mutableStateFlow2.compareAndSet(value, ConversationsListRepository.m283x91106a58(conversationsListScreenViewModel2.repository, false, false, (ConversationsListScreenState) value, 2, null)));
            }
            return Unit.INSTANCE;
        }
    }

    public final void refreshTheme$zendesk_messaging_messaging_android(MessagingTheme newTheme) {
        ConversationEntry conversationEntryCopy$default;
        Intrinsics.checkNotNullParameter(newTheme, "newTheme");
        if (Intrinsics.areEqual(this.conversationsListScreenStateFlow.getValue().getMessagingTheme(), newTheme)) {
            return;
        }
        MutableStateFlow<ConversationsListScreenState> mutableStateFlow = this._conversationsListScreenStateFlow;
        while (true) {
            ConversationsListScreenState value = mutableStateFlow.getValue();
            ConversationsListScreenState conversationsListScreenState = value;
            int notifyColor = newTheme.getNotifyColor();
            int onBackgroundColor = newTheme.getOnBackgroundColor();
            ImmutableList<ConversationEntry> conversations = conversationsListScreenState.getConversations();
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(conversations, 10));
            for (ConversationEntry conversationEntry : conversations) {
                if (conversationEntry instanceof ConversationEntry.ConversationItem) {
                    ConversationEntry.ConversationItem conversationItem = (ConversationEntry.ConversationItem) conversationEntry;
                    conversationEntryCopy$default = conversationItem.copy((1017 & 1) != 0 ? conversationItem.id : null, (1017 & 2) != 0 ? conversationItem.dateTimeStamp : null, (1017 & 4) != 0 ? conversationItem.formattedDateTimeStampString : null, (1017 & 8) != 0 ? conversationItem.participantName : null, (1017 & 16) != 0 ? conversationItem.conversationTitle : null, (1017 & 32) != 0 ? conversationItem.avatarUrl : null, (1017 & 64) != 0 ? conversationItem.latestMessage : null, (1017 & 128) != 0 ? conversationItem.latestMessageOwner : null, (1017 & 256) != 0 ? conversationItem.unreadMessages : 0, (1017 & 512) != 0 ? conversationItem.accessibilityTitle : null, (1017 & 1024) != 0 ? conversationItem.unreadMessagesColor : notifyColor, (1017 & 2048) != 0 ? conversationItem.dateTimestampTextColor : onBackgroundColor, (1017 & 4096) != 0 ? conversationItem.lastMessageTextColor : onBackgroundColor, (1017 & 8192) != 0 ? conversationItem.conversationParticipantsTextColor : onBackgroundColor, (1017 & 16384) != 0 ? conversationItem.conversationTitleTextColor : onBackgroundColor);
                } else if (conversationEntry instanceof ConversationEntry.LoadMore) {
                    conversationEntryCopy$default = ConversationEntry.LoadMore.copy$default((ConversationEntry.LoadMore) conversationEntry, null, newTheme.getOnBackgroundColor(), newTheme.getPrimaryColor(), null, null, 25, null);
                } else {
                    throw new NoWhenBranchMatchedException();
                }
                arrayList.add(conversationEntryCopy$default);
            }
            MutableStateFlow<ConversationsListScreenState> mutableStateFlow2 = mutableStateFlow;
            if (mutableStateFlow2.compareAndSet(value, conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : newTheme, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : ExtensionsKt.toImmutableList(arrayList), (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null))) {
                return;
            } else {
                mutableStateFlow = mutableStateFlow2;
            }
        }
    }

    protected void onCleared() {
        super.onCleared();
        Logger.m217d(LOG_TAG, "Completing the observation of a conversationsListScreenState.", new Object[0]);
        this.conversationKit.removeEventListener(this.eventListener);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModel$Companion;", "", "()V", "LOG_TAG", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
