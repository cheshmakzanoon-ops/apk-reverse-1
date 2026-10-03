package zendesk.messaging.android.internal.messagingscreen;

import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import zendesk.messaging.android.internal.MessagingEntryPointHandler;
import zendesk.messaging.android.push.internal.NotificationBuilder;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u001f\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\b\u0010\u0014\u001a\u00020\u0015H\u0002J!\u0010\u0016\u001a\u00020\u00172\b\u0010\u000b\u001a\u0004\u0018\u00010\f2\b\u0010\u0018\u001a\u0004\u0018\u00010\u0012H\u0002¢\u0006\u0002\u0010\u0019J\u000e\u0010\u001a\u001a\u00020\u00172\u0006\u0010\u001b\u001a\u00020\u001cJ\b\u0010\u001d\u001a\u00020\u0017H\u0002R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00050\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u000b\u001a\u0004\u0018\u00010\fX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00050\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0012\u0010\u0011\u001a\u0004\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0004\n\u0002\u0010\u0013¨\u0006\u001e"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenViewModel;", "Landroidx/lifecycle/ViewModel;", "messagingEntryPointHandler", "Lzendesk/messaging/android/internal/MessagingEntryPointHandler;", "initialState", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState;", "stateHandle", "Landroidx/lifecycle/SavedStateHandle;", "(Lzendesk/messaging/android/internal/MessagingEntryPointHandler;Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenState;Landroidx/lifecycle/SavedStateHandle;)V", "_messagingScreenState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "conversationId", "", "messagingScreenState", "Lkotlinx/coroutines/flow/StateFlow;", "getMessagingScreenState", "()Lkotlinx/coroutines/flow/StateFlow;", "proactiveNotificationId", "", "Ljava/lang/Integer;", "isPushNotification", "", "loadConversationScreen", "", "proactiveId", "(Ljava/lang/String;Ljava/lang/Integer;)V", "process", "action", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction;", "resolveEntryScreen", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingScreenViewModel extends ViewModel {
    private final MutableStateFlow<MessagingScreenState> _messagingScreenState;
    private String conversationId;
    private final MessagingEntryPointHandler messagingEntryPointHandler;
    private final StateFlow<MessagingScreenState> messagingScreenState;
    private Integer proactiveNotificationId;

    public MessagingScreenViewModel(MessagingEntryPointHandler messagingEntryPointHandler, MessagingScreenState.Idle idle, SavedStateHandle savedStateHandle, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(messagingEntryPointHandler, (i & 2) != 0 ? MessagingScreenState.Idle.INSTANCE : idle, savedStateHandle);
    }

    public MessagingScreenViewModel(MessagingEntryPointHandler messagingEntryPointHandler, MessagingScreenState initialState, SavedStateHandle stateHandle) {
        Intrinsics.checkNotNullParameter(messagingEntryPointHandler, "messagingEntryPointHandler");
        Intrinsics.checkNotNullParameter(initialState, "initialState");
        Intrinsics.checkNotNullParameter(stateHandle, "stateHandle");
        this.messagingEntryPointHandler = messagingEntryPointHandler;
        this.conversationId = (String) stateHandle.getLiveData(MessagingActivity.CONVERSATION_ID_KEY).getValue();
        this.proactiveNotificationId = (Integer) stateHandle.getLiveData(NotificationBuilder.PROACTIVE_NOTIFICATION_ID, -1).getValue();
        MutableStateFlow<MessagingScreenState> MutableStateFlow = StateFlowKt.MutableStateFlow(initialState);
        this._messagingScreenState = MutableStateFlow;
        this.messagingScreenState = FlowKt.asStateFlow(MutableStateFlow);
        if (isPushNotification()) {
            loadConversationScreen(this.conversationId, this.proactiveNotificationId);
        } else {
            resolveEntryScreen();
        }
    }

    public final StateFlow<MessagingScreenState> getMessagingScreenState() {
        return this.messagingScreenState;
    }

    public final void process(MessagingScreenAction action) {
        Intrinsics.checkNotNullParameter(action, "action");
        if (action instanceof MessagingScreenAction.ResolveScreen) {
            resolveEntryScreen();
        } else if (action instanceof MessagingScreenAction.LaunchConversationScreenFromNotification) {
            MessagingScreenAction.LaunchConversationScreenFromNotification launchConversationScreenFromNotification = (MessagingScreenAction.LaunchConversationScreenFromNotification) action;
            this.conversationId = launchConversationScreenFromNotification.getConversationId();
            loadConversationScreen(launchConversationScreenFromNotification.getConversationId(), this.proactiveNotificationId);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.messagingscreen.MessagingScreenViewModel$resolveEntryScreen$2", m37f = "MessagingScreenViewModel.kt", m38i = {}, m39l = {65}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C15192 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C15192(Continuation<? super C15192> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MessagingScreenViewModel.this.new C15192(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C15192) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            MessagingScreenState success;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = MessagingScreenViewModel.this.messagingEntryPointHandler.resolveEntryPoint(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            MessagingFragmentScreen messagingFragmentScreen = (MessagingFragmentScreen) obj;
            MutableStateFlow mutableStateFlow = MessagingScreenViewModel.this._messagingScreenState;
            do {
                value = mutableStateFlow.getValue();
                if (messagingFragmentScreen instanceof MessagingFragmentScreen.FailedResolvedFragmentScreen) {
                    success = new MessagingScreenState.Error(((MessagingFragmentScreen.FailedResolvedFragmentScreen) messagingFragmentScreen).getError());
                } else {
                    success = new MessagingScreenState.Success(false, messagingFragmentScreen, 1, null);
                }
            } while (!mutableStateFlow.compareAndSet(value, success));
            return Unit.INSTANCE;
        }
    }

    private final void resolveEntryScreen() {
        MutableStateFlow<MessagingScreenState> mutableStateFlow = this._messagingScreenState;
        while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), MessagingScreenState.Loading.INSTANCE)) {
        }
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C15192(null), 3, null);
    }

    private final void loadConversationScreen(String conversationId, Integer proactiveId) {
        MutableStateFlow<MessagingScreenState> mutableStateFlow = this._messagingScreenState;
        while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), MessagingScreenState.Loading.INSTANCE)) {
        }
        MutableStateFlow<MessagingScreenState> mutableStateFlow2 = this._messagingScreenState;
        do {
        } while (!mutableStateFlow2.compareAndSet(mutableStateFlow2.getValue(), new MessagingScreenState.Success(true, new MessagingFragmentScreen.ConversationFragmentScreen(conversationId, (proactiveId != null && proactiveId.intValue() == -1) ? null : proactiveId))));
    }

    private final boolean isPushNotification() {
        Integer num;
        return (this.conversationId == null && (num = this.proactiveNotificationId) != null && num.intValue() == -1) ? false : true;
    }
}
