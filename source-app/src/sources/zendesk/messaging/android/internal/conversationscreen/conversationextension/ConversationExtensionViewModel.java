package zendesk.messaging.android.internal.conversationscreen.conversationextension;

import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelKt;
import java.util.Collection;
import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.SharingStarted;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017J\b\u0010\u0018\u001a\u00020\u0015H\u0002J\u0010\u0010\u0019\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u001aH\u0002J\u0010\u0010\u001b\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u001cH\u0002J\f\u0010\u001d\u001a\u00020\u001e*\u00020\u0005H\u0002R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00050\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00050\r¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0017\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u000b0\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013¨\u0006\u001f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionViewModel;", "Landroidx/lifecycle/ViewModel;", "savedStateHandle", "Landroidx/lifecycle/SavedStateHandle;", "initialState", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;", "(Landroidx/lifecycle/SavedStateHandle;Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionState;)V", "_conversationExtensionState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "_eventsChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionEvent;", "conversationExtensionState", "Lkotlinx/coroutines/flow/StateFlow;", "getConversationExtensionState", "()Lkotlinx/coroutines/flow/StateFlow;", "eventsChannel", "Lkotlinx/coroutines/flow/Flow;", "getEventsChannel", "()Lkotlinx/coroutines/flow/Flow;", "process", "", "action", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction;", "processBack", "processLoad", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$Load;", "updateTheme", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionAction$RefreshTheme;", "shouldUpdateBackStack", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationExtensionViewModel extends ViewModel {
    private final MutableStateFlow<ConversationExtensionState> _conversationExtensionState;
    private final Channel<ConversationExtensionEvent> _eventsChannel;
    private final StateFlow<ConversationExtensionState> conversationExtensionState;
    private final Flow<ConversationExtensionEvent> eventsChannel;

    public ConversationExtensionViewModel(SavedStateHandle savedStateHandle, ConversationExtensionState conversationExtensionState, int i, DefaultConstructorMarker defaultConstructorMarker) {
        if ((i & 2) != 0) {
            List listEmptyList = CollectionsKt.emptyList();
            String str = (String) savedStateHandle.get(ConversationExtensionBottomSheetFragment.ARG_CONVERSATION_EXTENSION_URL);
            String str2 = str == null ? "" : str;
            String str3 = (String) savedStateHandle.get(ConversationExtensionBottomSheetFragment.ARG_CONVERSATION_EXTENSION_SIZE);
            conversationExtensionState = new ConversationExtensionState.Idle(listEmptyList, str2, str3 == null ? "" : str3, MessagingTheme.INSTANCE.getDEFAULT(), "");
        }
        this(savedStateHandle, conversationExtensionState);
    }

    public ConversationExtensionViewModel(SavedStateHandle savedStateHandle, ConversationExtensionState initialState) {
        Intrinsics.checkNotNullParameter(savedStateHandle, "savedStateHandle");
        Intrinsics.checkNotNullParameter(initialState, "initialState");
        MutableStateFlow<ConversationExtensionState> MutableStateFlow = StateFlowKt.MutableStateFlow(initialState);
        this._conversationExtensionState = MutableStateFlow;
        this.conversationExtensionState = FlowKt.stateIn(FlowKt.asStateFlow(MutableStateFlow), ViewModelKt.getViewModelScope(this), SharingStarted.Companion.WhileSubscribed$default(SharingStarted.INSTANCE, 0L, 0L, 3, null), MutableStateFlow.getValue());
        Channel<ConversationExtensionEvent> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._eventsChannel = channelChannel$default;
        this.eventsChannel = FlowKt.receiveAsFlow(channelChannel$default);
    }

    public final StateFlow<ConversationExtensionState> getConversationExtensionState() {
        return this.conversationExtensionState;
    }

    public final Flow<ConversationExtensionEvent> getEventsChannel() {
        return this.eventsChannel;
    }

    public final void process(ConversationExtensionAction action) {
        ConversationExtensionState value;
        ConversationExtensionState conversationExtensionState;
        ConversationExtensionState value2;
        ConversationExtensionState conversationExtensionState2;
        ConversationExtensionState value3;
        ConversationExtensionState conversationExtensionState3;
        String title;
        Intrinsics.checkNotNullParameter(action, "action");
        if (Intrinsics.areEqual(action, ConversationExtensionAction.Back.INSTANCE)) {
            processBack();
            return;
        }
        if (action instanceof ConversationExtensionAction.Load) {
            processLoad((ConversationExtensionAction.Load) action);
            return;
        }
        if (action instanceof ConversationExtensionAction.RefreshTheme) {
            updateTheme((ConversationExtensionAction.RefreshTheme) action);
            return;
        }
        if (Intrinsics.areEqual(action, ConversationExtensionAction.Reload.INSTANCE)) {
            process(new ConversationExtensionAction.Load(this.conversationExtensionState.getValue().getUrl()));
            return;
        }
        if (action instanceof ConversationExtensionAction.UpdateTitle) {
            MutableStateFlow<ConversationExtensionState> mutableStateFlow = this._conversationExtensionState;
            do {
                value3 = mutableStateFlow.getValue();
                conversationExtensionState3 = value3;
                title = ((ConversationExtensionAction.UpdateTitle) action).getTitle();
                if (title == null) {
                    title = "";
                }
            } while (!mutableStateFlow.compareAndSet(value3, ConversationExtensionState.sealedCopy$default(conversationExtensionState3, null, null, null, null, title, 15, null)));
            return;
        }
        if (Intrinsics.areEqual(action, ConversationExtensionAction.WebViewError.INSTANCE)) {
            MutableStateFlow<ConversationExtensionState> mutableStateFlow2 = this._conversationExtensionState;
            do {
                value2 = mutableStateFlow2.getValue();
                conversationExtensionState2 = value2;
            } while (!mutableStateFlow2.compareAndSet(value2, new ConversationExtensionState.Error(conversationExtensionState2.getBackStack(), conversationExtensionState2.getUrl(), conversationExtensionState2.getSize(), conversationExtensionState2.getMessagingTheme(), "")));
            return;
        }
        if (Intrinsics.areEqual(action, ConversationExtensionAction.Close.INSTANCE)) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13853(null), 3, null);
            return;
        }
        if (action instanceof ConversationExtensionAction.UpdateUrl) {
            process(new ConversationExtensionAction.Load(((ConversationExtensionAction.UpdateUrl) action).getUrl()));
            return;
        }
        if (Intrinsics.areEqual(action, ConversationExtensionAction.LoadingComplete.INSTANCE)) {
            MutableStateFlow<ConversationExtensionState> mutableStateFlow3 = this._conversationExtensionState;
            do {
                value = mutableStateFlow3.getValue();
                conversationExtensionState = value;
            } while (!mutableStateFlow3.compareAndSet(value, new ConversationExtensionState.Success(conversationExtensionState.getBackStack(), conversationExtensionState.getUrl(), conversationExtensionState.getSize(), conversationExtensionState.getMessagingTheme(), conversationExtensionState.getTitle())));
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionViewModel$process$3", m37f = "ConversationExtensionViewModel.kt", m38i = {}, m39l = {95}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13853 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13853(Continuation<? super C13853> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationExtensionViewModel.this.new C13853(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13853) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationExtensionViewModel.this._eventsChannel.send(ConversationExtensionEvent.Close.INSTANCE, this) == coroutine_suspended) {
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

    private final void processLoad(ConversationExtensionAction.Load action) {
        ConversationExtensionState value;
        ConversationExtensionState conversationExtensionState;
        List<String> backStack;
        MutableStateFlow<ConversationExtensionState> mutableStateFlow = this._conversationExtensionState;
        do {
            value = mutableStateFlow.getValue();
            conversationExtensionState = value;
            boolean zAreEqual = Intrinsics.areEqual(conversationExtensionState.getUrl(), action.getUrl());
            if (shouldUpdateBackStack(conversationExtensionState) && !zAreEqual) {
                backStack = CollectionsKt.plus((Collection<? extends String>) conversationExtensionState.getBackStack(), conversationExtensionState.getUrl());
            } else {
                backStack = conversationExtensionState.getBackStack();
            }
        } while (!mutableStateFlow.compareAndSet(value, new ConversationExtensionState.Loading(backStack, action.getUrl(), conversationExtensionState.getSize(), conversationExtensionState.getMessagingTheme(), conversationExtensionState.getTitle())));
    }

    private final void processBack() {
        ConversationExtensionState value;
        ConversationExtensionState conversationExtensionState;
        String str = (String) CollectionsKt.lastOrNull((List) this._conversationExtensionState.getValue().getBackStack());
        if (str == null) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13862(null), 3, null);
            return;
        }
        List listDropLast = CollectionsKt.dropLast(this._conversationExtensionState.getValue().getBackStack(), 1);
        MutableStateFlow<ConversationExtensionState> mutableStateFlow = this._conversationExtensionState;
        do {
            value = mutableStateFlow.getValue();
            conversationExtensionState = value;
        } while (!mutableStateFlow.compareAndSet(value, new ConversationExtensionState.Idle(listDropLast, str, conversationExtensionState.getSize(), conversationExtensionState.getMessagingTheme(), conversationExtensionState.getTitle())));
        process(new ConversationExtensionAction.Load(str));
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionViewModel$processBack$2", m37f = "ConversationExtensionViewModel.kt", m38i = {}, m39l = {150}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13862 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13862(Continuation<? super C13862> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationExtensionViewModel.this.new C13862(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13862) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationExtensionViewModel.this._eventsChannel.send(ConversationExtensionEvent.Close.INSTANCE, this) == coroutine_suspended) {
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

    private final boolean shouldUpdateBackStack(ConversationExtensionState conversationExtensionState) {
        return conversationExtensionState instanceof ConversationExtensionState.Success;
    }

    private final void updateTheme(ConversationExtensionAction.RefreshTheme action) {
        ConversationExtensionState value;
        if (Intrinsics.areEqual(action.getTheme(), this.conversationExtensionState.getValue().getMessagingTheme())) {
            return;
        }
        MutableStateFlow<ConversationExtensionState> mutableStateFlow = this._conversationExtensionState;
        do {
            value = mutableStateFlow.getValue();
        } while (!mutableStateFlow.compareAndSet(value, ConversationExtensionState.sealedCopy$default(value, null, null, null, action.getTheme(), null, 23, null)));
    }
}
