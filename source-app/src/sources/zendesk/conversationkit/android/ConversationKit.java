package zendesk.conversationkit.android;

import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlinx.coroutines.flow.StateFlow;
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

@Metadata(m17d1 = {"\u0000¦\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\f\bf\u0018\u00002\u00020\u0001J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH&J\u0016\u0010\u000b\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\rH¦@¢\u0006\u0002\u0010\u000eJ\u0016\u0010\u000f\u001a\u00020\b2\u0006\u0010\u0010\u001a\u00020\u0011H¦@¢\u0006\u0002\u0010\u0012J\b\u0010\u0013\u001a\u00020\u0014H&J \u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00170\u00162\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u0011H¦@¢\u0006\u0002\u0010\u0018J \u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00162\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u0011H¦@¢\u0006\u0002\u0010\u0018J\u0010\u0010\u001b\u001a\u00020\b2\u0006\u0010\u001c\u001a\u00020\u001dH&J\u001e\u0010\u001e\u001a\u00020\b2\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\"H¦@¢\u0006\u0002\u0010#J\u0010\u0010$\u001a\u0004\u0018\u00010 H¦@¢\u0006\u0002\u0010%J\b\u0010&\u001a\u00020'H&J\u001c\u0010(\u001a\b\u0012\u0004\u0012\u00020\u00170\u00162\u0006\u0010\u001f\u001a\u00020 H¦@¢\u0006\u0002\u0010)J(\u0010*\u001a\b\u0012\u0004\u0012\u00020+0\u00162\b\b\u0002\u0010,\u001a\u00020\u00112\b\b\u0002\u0010-\u001a\u00020.H¦@¢\u0006\u0002\u0010/J\u0010\u00100\u001a\u0004\u0018\u00010\u001aH¦@¢\u0006\u0002\u0010%J*\u00101\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\"020\u00162\u0006\u0010\u001f\u001a\u00020 2\u0006\u00103\u001a\u000204H¦@¢\u0006\u0002\u00105J\u001c\u00106\u001a\b\u0012\u0004\u0012\u00020\r0\u00162\u0006\u0010\u0010\u001a\u00020\u0011H¦@¢\u0006\u0002\u0010\u0012J\b\u00107\u001a\u000208H&J\u0014\u00109\u001a\b\u0012\u0004\u0012\u00020:0\u0016H¦@¢\u0006\u0002\u0010%J\u001c\u0010;\u001a\b\u0012\u0004\u0012\u00020<0\u00162\u0006\u0010\u001f\u001a\u00020 H¦@¢\u0006\u0002\u0010)J\u001c\u0010=\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00162\u0006\u0010>\u001a\u00020 H¦@¢\u0006\u0002\u0010)J\u0014\u0010?\u001a\b\u0012\u0004\u0012\u00020\b0\u0016H¦@¢\u0006\u0002\u0010%J\u000e\u0010@\u001a\u00020\bH¦@¢\u0006\u0002\u0010%J(\u0010A\u001a\b\u0012\u0004\u0012\u00020\u00170\u00162\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\u0006\u0010\u001f\u001a\u00020 H¦@¢\u0006\u0002\u0010BJ\u0010\u0010C\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH&J\u000e\u0010D\u001a\u00020\bH¦@¢\u0006\u0002\u0010%J\u001e\u0010E\u001a\u00020\b2\u0006\u0010F\u001a\u00020G2\u0006\u0010\u001f\u001a\u00020 H¦@¢\u0006\u0002\u0010HJ$\u0010I\u001a\b\u0012\u0004\u0012\u00020\"0\u00162\u0006\u0010!\u001a\u00020\"2\u0006\u0010\u001f\u001a\u00020 H¦@¢\u0006\u0002\u0010JJ$\u0010K\u001a\b\u0012\u0004\u0012\u00020\b0\u00162\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010L\u001a\u00020 H¦@¢\u0006\u0002\u0010MJ\u0016\u0010N\u001a\u00020\b2\u0006\u0010O\u001a\u00020:H¦@¢\u0006\u0002\u0010PJ\u0016\u0010Q\u001a\u00020\b2\u0006\u0010R\u001a\u00020 H¦@¢\u0006\u0002\u0010)R\u0018\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006¨\u0006S"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKit;", "", "connectionStatusFlow", "Lkotlinx/coroutines/flow/StateFlow;", "Lzendesk/conversationkit/android/ConnectionStatus;", "getConnectionStatusFlow", "()Lkotlinx/coroutines/flow/StateFlow;", "addEventListener", "", "listener", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "addProactiveMessage", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearProactiveMessage", "proactiveMessageId", "", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "conversationMetadataService", "Lzendesk/conversationkit/android/internal/metadata/ConversationMetadataService;", "createConversation", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "(Ljava/lang/Integer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createUser", "Lzendesk/conversationkit/android/model/User;", "dispatchEvent", "event", "Lzendesk/conversationkit/android/ConversationKitEvent;", "downloadAttachment", "conversationId", "", "message", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getClientId", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConfig", "Lzendesk/conversationkit/android/model/Config;", "getConversation", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversations", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "offset", "fromCache", "", "(IZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getCurrentUser", "getMessages", "", "beforeTimestamp", "", "(Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getProactiveMessage", "getSettings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "getVisitType", "Lzendesk/conversationkit/android/model/VisitType;", "getWaitTimeForConversation", "Lzendesk/conversationkit/android/model/WaitTimeData;", "loginUser", "jwt", "logoutUser", "pause", "proactiveMessageReferral", "(Ljava/lang/Integer;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeEventListener", "resume", "sendActivityData", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "(Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendPostbackMessage", "actionId", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setVisitType", "visitType", "(Lzendesk/conversationkit/android/model/VisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updatePushNotificationToken", "pushNotificationToken", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationKit {
    void addEventListener(ConversationKitEventListener listener);

    Object addProactiveMessage(ProactiveMessage proactiveMessage, Continuation<? super Unit> continuation);

    Object clearProactiveMessage(int i, Continuation<? super Unit> continuation);

    ConversationMetadataService conversationMetadataService();

    Object createConversation(Integer num, Continuation<? super ConversationKitResult<Conversation>> continuation);

    Object createUser(Integer num, Continuation<? super ConversationKitResult<User>> continuation);

    void dispatchEvent(ConversationKitEvent event);

    Object downloadAttachment(String str, Message message, Continuation<? super Unit> continuation);

    Object getClientId(Continuation<? super String> continuation);

    Config getConfig();

    StateFlow<ConnectionStatus> getConnectionStatusFlow();

    Object getConversation(String str, Continuation<? super ConversationKitResult<Conversation>> continuation);

    Object getConversations(int i, boolean z, Continuation<? super ConversationKitResult<ConversationsPagination>> continuation);

    Object getCurrentUser(Continuation<? super User> continuation);

    Object getMessages(String str, double d, Continuation<? super ConversationKitResult<? extends List<Message>>> continuation);

    Object getProactiveMessage(int i, Continuation<? super ConversationKitResult<ProactiveMessage>> continuation);

    ConversationKitSettings getSettings();

    Object getVisitType(Continuation<? super ConversationKitResult<? extends VisitType>> continuation);

    Object getWaitTimeForConversation(String str, Continuation<? super ConversationKitResult<WaitTimeData>> continuation);

    Object loginUser(String str, Continuation<? super ConversationKitResult<User>> continuation);

    Object logoutUser(Continuation<? super ConversationKitResult<Unit>> continuation);

    Object pause(Continuation<? super Unit> continuation);

    Object proactiveMessageReferral(Integer num, String str, Continuation<? super ConversationKitResult<Conversation>> continuation);

    void removeEventListener(ConversationKitEventListener listener);

    Object resume(Continuation<? super Unit> continuation);

    Object sendActivityData(ActivityData activityData, String str, Continuation<? super Unit> continuation);

    Object sendMessage(Message message, String str, Continuation<? super ConversationKitResult<Message>> continuation);

    Object sendPostbackMessage(String str, String str2, Continuation<? super ConversationKitResult<Unit>> continuation);

    Object setVisitType(VisitType visitType, Continuation<? super Unit> continuation);

    Object updatePushNotificationToken(String str, Continuation<? super Unit> continuation);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DefaultImpls {
        public static Object createUser$default(ConversationKit conversationKit, Integer num, Continuation continuation, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: createUser");
            }
            if ((i & 1) != 0) {
                num = null;
            }
            return conversationKit.createUser(num, continuation);
        }

        public static Object createConversation$default(ConversationKit conversationKit, Integer num, Continuation continuation, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: createConversation");
            }
            if ((i & 1) != 0) {
                num = null;
            }
            return conversationKit.createConversation(num, continuation);
        }

        public static Object proactiveMessageReferral$default(ConversationKit conversationKit, Integer num, String str, Continuation continuation, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: proactiveMessageReferral");
            }
            if ((i & 1) != 0) {
                num = null;
            }
            return conversationKit.proactiveMessageReferral(num, str, continuation);
        }

        public static Object getConversations$default(ConversationKit conversationKit, int i, boolean z, Continuation continuation, int i2, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: getConversations");
            }
            if ((i2 & 1) != 0) {
                i = 0;
            }
            if ((i2 & 2) != 0) {
                z = false;
            }
            return conversationKit.getConversations(i, z, continuation);
        }
    }
}
