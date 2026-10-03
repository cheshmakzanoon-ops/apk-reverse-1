package zendesk.android.internal;

import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import zendesk.android.Zendesk;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.internal.metadata.ConversationMetadataService;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.Config;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.VisitType;
import zendesk.conversationkit.android.model.WaitTimeData;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000¨\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\f\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0016J\u0016\u0010\f\u001a\u00020\t2\u0006\u0010\r\u001a\u00020\u000eH\u0096@¢\u0006\u0002\u0010\u000fJ\u0016\u0010\u0010\u001a\u00020\t2\u0006\u0010\u0011\u001a\u00020\u0012H\u0096@¢\u0006\u0002\u0010\u0013J\b\u0010\u0014\u001a\u00020\u0015H\u0016J\u001e\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00180\u00172\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012H\u0096@¢\u0006\u0002\u0010\u0019J\u001e\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u001b0\u00172\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012H\u0096@¢\u0006\u0002\u0010\u0019J\u0010\u0010\u001c\u001a\u00020\t2\u0006\u0010\u001d\u001a\u00020\u001eH\u0016J\u001e\u0010\u001f\u001a\u00020\t2\u0006\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020#H\u0096@¢\u0006\u0002\u0010$J\u0010\u0010%\u001a\u0004\u0018\u00010!H\u0096@¢\u0006\u0002\u0010&J\b\u0010'\u001a\u00020(H\u0016J\u001c\u0010)\u001a\b\u0012\u0004\u0012\u00020\u00180\u00172\u0006\u0010 \u001a\u00020!H\u0096@¢\u0006\u0002\u0010*J$\u0010+\u001a\b\u0012\u0004\u0012\u00020,0\u00172\u0006\u0010-\u001a\u00020\u00122\u0006\u0010.\u001a\u00020/H\u0096@¢\u0006\u0002\u00100J\u0010\u00101\u001a\u0004\u0018\u00010\u001bH\u0096@¢\u0006\u0002\u0010&J*\u00102\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020#030\u00172\u0006\u0010 \u001a\u00020!2\u0006\u00104\u001a\u000205H\u0096@¢\u0006\u0002\u00106J\u001c\u00107\u001a\b\u0012\u0004\u0012\u00020\u000e0\u00172\u0006\u0010\u0011\u001a\u00020\u0012H\u0096@¢\u0006\u0002\u0010\u0013J\b\u00108\u001a\u000209H\u0016J\u0014\u0010:\u001a\b\u0012\u0004\u0012\u00020;0\u0017H\u0096@¢\u0006\u0002\u0010&J\u001c\u0010<\u001a\b\u0012\u0004\u0012\u00020=0\u00172\u0006\u0010 \u001a\u00020!H\u0096@¢\u0006\u0002\u0010*J\u001c\u0010>\u001a\b\u0012\u0004\u0012\u00020\u001b0\u00172\u0006\u0010?\u001a\u00020!H\u0096@¢\u0006\u0002\u0010*J\u0014\u0010@\u001a\b\u0012\u0004\u0012\u00020\t0\u0017H\u0096@¢\u0006\u0002\u0010&J\u000e\u0010A\u001a\u00020\tH\u0096@¢\u0006\u0002\u0010&J&\u0010B\u001a\b\u0012\u0004\u0012\u00020\u00180\u00172\b\u0010\u0011\u001a\u0004\u0018\u00010\u00122\u0006\u0010 \u001a\u00020!H\u0096@¢\u0006\u0002\u0010CJ\u0010\u0010D\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0016J\u000e\u0010E\u001a\u00020\tH\u0096@¢\u0006\u0002\u0010&J\u001e\u0010F\u001a\u00020\t2\u0006\u0010G\u001a\u00020H2\u0006\u0010 \u001a\u00020!H\u0096@¢\u0006\u0002\u0010IJ$\u0010J\u001a\b\u0012\u0004\u0012\u00020#0\u00172\u0006\u0010\"\u001a\u00020#2\u0006\u0010 \u001a\u00020!H\u0096@¢\u0006\u0002\u0010KJ$\u0010L\u001a\b\u0012\u0004\u0012\u00020\t0\u00172\u0006\u0010 \u001a\u00020!2\u0006\u0010M\u001a\u00020!H\u0096@¢\u0006\u0002\u0010NJ\u0016\u0010O\u001a\u00020\t2\u0006\u0010P\u001a\u00020;H\u0096@¢\u0006\u0002\u0010QJ\u0016\u0010R\u001a\u00020\t2\u0006\u0010S\u001a\u00020!H\u0096@¢\u0006\u0002\u0010*R\u001a\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00048VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006T"}, m18d2 = {"Lzendesk/android/internal/NotInitializedConversationKit;", "Lzendesk/conversationkit/android/ConversationKit;", "()V", "connectionStatusFlow", "Lkotlinx/coroutines/flow/StateFlow;", "Lzendesk/conversationkit/android/ConnectionStatus;", "getConnectionStatusFlow", "()Lkotlinx/coroutines/flow/StateFlow;", "addEventListener", "", "listener", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "addProactiveMessage", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearProactiveMessage", "proactiveMessageId", "", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "conversationMetadataService", "Lzendesk/conversationkit/android/internal/metadata/ConversationMetadataService;", "createConversation", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "(Ljava/lang/Integer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createUser", "Lzendesk/conversationkit/android/model/User;", "dispatchEvent", "event", "Lzendesk/conversationkit/android/ConversationKitEvent;", "downloadAttachment", "conversationId", "", "message", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getClientId", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConfig", "Lzendesk/conversationkit/android/model/Config;", "getConversation", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversations", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "offset", "fromCache", "", "(IZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getCurrentUser", "getMessages", "", "beforeTimestamp", "", "(Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getProactiveMessage", "getSettings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "getVisitType", "Lzendesk/conversationkit/android/model/VisitType;", "getWaitTimeForConversation", "Lzendesk/conversationkit/android/model/WaitTimeData;", "loginUser", "jwt", "logoutUser", "pause", "proactiveMessageReferral", "(Ljava/lang/Integer;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeEventListener", "resume", "sendActivityData", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "(Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendPostbackMessage", "actionId", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setVisitType", "visitType", "(Lzendesk/conversationkit/android/model/VisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updatePushNotificationToken", "pushNotificationToken", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class NotInitializedConversationKit implements ConversationKit {
    public static final NotInitializedConversationKit INSTANCE = new NotInitializedConversationKit();

    @Override
    public Object getCurrentUser(Continuation<? super User> continuation) {
        return null;
    }

    private NotInitializedConversationKit() {
    }

    @Override
    public StateFlow<ConnectionStatus> getConnectionStatusFlow() {
        return StateFlowKt.MutableStateFlow(ConnectionStatus.DISCONNECTED);
    }

    @Override
    public void addEventListener(ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
    }

    @Override
    public void removeEventListener(ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
    }

    @Override
    public Object pause(Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public Object resume(Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public ConversationKitSettings getSettings() throws ZendeskError.NotInitialized {
        throw ZendeskError.NotInitialized.INSTANCE;
    }

    @Override
    public Config getConfig() throws ZendeskError.NotInitialized {
        throw ZendeskError.NotInitialized.INSTANCE;
    }

    @Override
    public Object getClientId(Continuation<? super String> continuation) throws ZendeskError.NotInitialized {
        throw ZendeskError.NotInitialized.INSTANCE;
    }

    @Override
    public Object createUser(Integer num, Continuation<? super ConversationKitResult<User>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object loginUser(String str, Continuation<? super ConversationKitResult<User>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object logoutUser(Continuation<? super ConversationKitResult<Unit>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object createConversation(Integer num, Continuation<? super ConversationKitResult<Conversation>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object getConversation(String str, Continuation<? super ConversationKitResult<Conversation>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object sendMessage(Message message, String str, Continuation<? super ConversationKitResult<Message>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object getMessages(String str, double d, Continuation<? super ConversationKitResult<? extends List<Message>>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object updatePushNotificationToken(String str, Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public Object sendActivityData(ActivityData activityData, String str, Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public Object getVisitType(Continuation<? super ConversationKitResult<? extends VisitType>> continuation) {
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object setVisitType(VisitType visitType, Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public Object addProactiveMessage(ProactiveMessage proactiveMessage, Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public Object getProactiveMessage(int i, Continuation<? super ConversationKitResult<ProactiveMessage>> continuation) {
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object clearProactiveMessage(int i, Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public Object proactiveMessageReferral(Integer num, String str, Continuation<? super ConversationKitResult<Conversation>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public void dispatchEvent(ConversationKitEvent event) {
        Intrinsics.checkNotNullParameter(event, "event");
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
    }

    @Override
    public Object getConversations(int i, boolean z, Continuation<? super ConversationKitResult<ConversationsPagination>> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public ConversationMetadataService getConversationMetadataService() {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return NotInitializedConversationMetadataService.INSTANCE;
    }

    @Override
    public Object sendPostbackMessage(String str, String str2, Continuation<? super ConversationKitResult<Unit>> continuation) {
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }

    @Override
    public Object downloadAttachment(String str, Message message, Continuation<? super Unit> continuation) {
        Logger.m225w(Zendesk.LOG_TAG, ZendeskError.NotInitialized.INSTANCE.getMessage(), new Object[0]);
        return Unit.INSTANCE;
    }

    @Override
    public Object getWaitTimeForConversation(String str, Continuation<? super ConversationKitResult<WaitTimeData>> continuation) {
        return new ConversationKitResult.Failure(ZendeskError.NotInitialized.INSTANCE);
    }
}
