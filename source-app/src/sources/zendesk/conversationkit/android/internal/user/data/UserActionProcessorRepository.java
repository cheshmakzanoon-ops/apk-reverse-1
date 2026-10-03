package zendesk.conversationkit.android.internal.user.data;

import cz.msebera.android.httpclient.HttpStatus;
import j$.time.LocalDateTime;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
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
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.encoding.Base64;
import kotlin.text.StringsKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.TimeoutKt;
import net.aihelp.common.API;
import net.aihelp.data.model.p005cs.ConversationMsg;
import net.aihelp.data.track.data.TrackType;
import net.aihelp.p007ui.webkit.AIHelpWebProgress;
import zendesk.conversationkit.android.internal.ConnectivityObserver;
import zendesk.conversationkit.android.internal.exception.CantCreateConversationException;
import zendesk.conversationkit.android.internal.exception.ConversationHasNoPreviousMessagesException;
import zendesk.conversationkit.android.internal.exception.ConversationNotFoundException;
import zendesk.conversationkit.android.internal.exception.MessageAlreadyInConversationException;
import zendesk.conversationkit.android.internal.exception.MessageContentIsBlankException;
import zendesk.conversationkit.android.internal.exception.MultiConvoDisabledException;
import zendesk.conversationkit.android.internal.exception.ProactiveMessageNotFoundException;
import zendesk.conversationkit.android.internal.exception.UserAlreadyLoggedInException;
import zendesk.conversationkit.android.internal.user.UserExtensionsKt;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.ActivityEvent;
import zendesk.conversationkit.android.model.AuthenticationType;
import zendesk.conversationkit.android.model.AuthorType;
import zendesk.conversationkit.android.model.Config;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationStatus;
import zendesk.conversationkit.android.model.ConversationType;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageList;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.VisitType;
import zendesk.conversationkit.android.model.WaitTimeDataResponse;

@Metadata(m17d1 = {"\u0000²\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0018\u0002\n\u0002\b\u0010\b\u0000\u0018\u0000 \u0085\u00012\u00020\u0001:\u0002\u0085\u0001B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u0016\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0010H\u0086@¢\u0006\u0002\u0010\u0011J\u000e\u0010\u0012\u001a\u00020\u000eH\u0086@¢\u0006\u0002\u0010\u0013J.\u0010\u0014\u001a\u00020\u00152\b\u0010\u000f\u001a\u0004\u0018\u00010\u00102\u0014\u0010\u0016\u001a\u0010\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0017H\u0086@¢\u0006\u0002\u0010\u0019J<\u0010\u001a\u001a\u00020\u00152\b\b\u0002\u0010\u001b\u001a\u00020\u001c2\n\b\u0002\u0010\u001d\u001a\u0004\u0018\u00010\u00182\u0016\b\u0002\u0010\u0016\u001a\u0010\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0017H\u0082@¢\u0006\u0002\u0010\u001eJ\u001e\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\u00182\u0006\u0010\"\u001a\u00020 H\u0086@¢\u0006\u0002\u0010#J\"\u0010$\u001a\u0002H%\"\u0004\b\u0000\u0010%2\f\u0010&\u001a\b\u0012\u0004\u0012\u0002H%0'H\u0082\b¢\u0006\u0002\u0010(J\u0016\u0010)\u001a\u00020\u00152\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u001e\u0010+\u001a\u00020,2\u0006\u0010-\u001a\u00020\u00102\u0006\u0010.\u001a\u00020/H\u0086@¢\u0006\u0002\u00100J\u001a\u00101\u001a\u0004\u0018\u00010\u00152\b\u0010!\u001a\u0004\u0018\u00010\u0018H\u0086@¢\u0006\u0002\u0010*J\u001a\u00102\u001a\u0004\u0018\u00010\u00182\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010H\u0082@¢\u0006\u0002\u00103J\u0016\u00104\u001a\u0002052\u0006\u0010\u000f\u001a\u00020\u0010H\u0086@¢\u0006\u0002\u0010\u0011J \u00106\u001a\u00020\u00152\b\u0010\u000f\u001a\u0004\u0018\u00010\u00102\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u00107J\u000e\u00108\u001a\u000209H\u0086@¢\u0006\u0002\u0010\u0013J\u000e\u0010:\u001a\u00020;H\u0086@¢\u0006\u0002\u0010\u0013J\u0016\u0010<\u001a\u00020=2\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u001e\u0010>\u001a\u00020?2\u0006\u0010!\u001a\u00020\u00182\u0006\u0010@\u001a\u00020AH\u0086@¢\u0006\u0002\u0010BJ\u0016\u0010C\u001a\u0002092\u0006\u0010D\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u000e\u0010E\u001a\u00020\u000eH\u0086@¢\u0006\u0002\u0010\u0013J\u0018\u0010F\u001a\u0004\u0018\u00010\u00152\u0006\u0010G\u001a\u00020HH\u0086@¢\u0006\u0002\u0010IJ\u0016\u0010J\u001a\u00020\u00152\u0006\u0010G\u001a\u00020HH\u0082@¢\u0006\u0002\u0010IJ\u001e\u0010K\u001a\u00020\u00152\u0006\u0010G\u001a\u00020H2\u0006\u0010!\u001a\u00020\u0018H\u0082@¢\u0006\u0002\u0010LJ\u0016\u0010M\u001a\u00020\u00152\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u000e\u0010N\u001a\u000209H\u0086@¢\u0006\u0002\u0010\u0013J\u0016\u0010O\u001a\u00020\u000e2\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u0016\u0010P\u001a\u00020\u00152\u0006\u0010Q\u001a\u00020\u0015H\u0082@¢\u0006\u0002\u0010RJ\u0016\u0010S\u001a\u00020\u000e2\u0006\u0010Q\u001a\u00020\u0015H\u0082@¢\u0006\u0002\u0010RJ,\u0010T\u001a\u00020\u000e2\u0006\u0010Q\u001a\u00020\u00152\u0014\u0010\u0016\u001a\u0010\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0017H\u0082@¢\u0006\u0002\u0010UJ\u0016\u0010V\u001a\u00020\u000e2\u0006\u0010W\u001a\u000209H\u0082@¢\u0006\u0002\u0010XJ\u0016\u0010Y\u001a\u00020\u000e2\u0006\u0010Z\u001a\u000209H\u0082@¢\u0006\u0002\u0010XJ\u001e\u0010[\u001a\u00020\u000e2\u0006\u0010\\\u001a\u00020]2\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010^J\u001e\u0010_\u001a\u00020 2\u0006\u0010\"\u001a\u00020 2\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010`J\u001e\u0010a\u001a\u00020 2\u0006\u0010\"\u001a\u00020 2\u0006\u0010!\u001a\u00020\u0018H\u0082@¢\u0006\u0002\u0010`J\u001e\u0010b\u001a\u00020\u000e2\u0006\u0010!\u001a\u00020\u00182\u0006\u0010c\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010dJ\u0016\u0010e\u001a\u00020\u000e2\u0006\u0010f\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u0016\u0010g\u001a\u00020\u000e2\u0006\u0010h\u001a\u000205H\u0086@¢\u0006\u0002\u0010iJ\u0016\u0010j\u001a\u00020\u000e2\u0006\u0010k\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u0016\u0010l\u001a\u00020\u000e2\u0006\u0010m\u001a\u00020;H\u0086@¢\u0006\u0002\u0010nJ\u000e\u0010o\u001a\u00020/H\u0086@¢\u0006\u0002\u0010\u0013J\u0016\u0010p\u001a\u00020\u000e2\u0006\u0010q\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u001e\u0010r\u001a\u00020\u00152\u0006\u0010!\u001a\u00020\u00182\u0006\u0010s\u001a\u00020 H\u0086@¢\u0006\u0002\u0010#J4\u0010t\u001a\u00020\u00152\u0006\u0010!\u001a\u00020\u00182\u0006\u0010u\u001a\u00020v2\u0014\u0010\u0016\u001a\u0010\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0017H\u0086@¢\u0006\u0002\u0010wJ,\u0010x\u001a\u00020\u000e2\u0006\u0010!\u001a\u00020\u00182\u0014\u0010\u0016\u001a\u0010\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0017H\u0086@¢\u0006\u0002\u0010yJ\u001e\u0010z\u001a\u00020\u00152\u0006\u0010!\u001a\u00020\u00182\u0006\u0010\"\u001a\u00020 H\u0086@¢\u0006\u0002\u0010#J&\u0010{\u001a\u00020\u00152\u0006\u0010|\u001a\u00020\u00182\u0006\u0010}\u001a\u00020\u00182\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010~J&\u0010\u007f\u001a\u00020\u00152\u0006\u0010|\u001a\u00020\u00182\u0006\u0010}\u001a\u00020\u00182\u0006\u0010!\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010~J\u0018\u0010\u0080\u0001\u001a\u00020\u000e2\u0007\u0010\u0081\u0001\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010*J\u0019\u0010\u0082\u0001\u001a\u00020\u000e2\u0007\u0010\u0083\u0001\u001a\u00020/H\u0086@¢\u0006\u0003\u0010\u0084\u0001R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0086\u0001"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRepository;", "", "userActionProcessorInMemoryDataSource", "Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorInMemoryDataSource;", "userActionProcessorLocalDataSource", "Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorLocalDataSource;", "userActionProcessorRemoteDataSource", "Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRemoteDataSource;", "config", "Lzendesk/conversationkit/android/model/Config;", "connectivityObserver", "Lzendesk/conversationkit/android/internal/ConnectivityObserver;", "(Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorInMemoryDataSource;Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorLocalDataSource;Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorRemoteDataSource;Lzendesk/conversationkit/android/model/Config;Lzendesk/conversationkit/android/internal/ConnectivityObserver;)V", "clearProactiveMessage", "", "proactiveMessageId", "", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearStorage", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createConversation", "Lzendesk/conversationkit/android/model/Conversation;", "metadata", "", "", "(Ljava/lang/Integer;Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createConversationFromNetwork", "conversationType", "Lzendesk/conversationkit/android/model/ConversationType;", "signedCampaignData", "(Lzendesk/conversationkit/android/model/ConversationType;Ljava/lang/String;Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createPendingMessage", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "message", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "executeWithUnknownHostExceptionRetry", "T", "call", "Lkotlin/Function0;", "(Lkotlin/jvm/functions/Function0;)Ljava/lang/Object;", "getConversationRemotely", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversations", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "offset", "fromCache", "", "(IZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getPersistedConversation", "getProactiveCampaignData", "(Ljava/lang/Integer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getProactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "getProactiveMessageConversation", "(Ljava/lang/Integer;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUser", "Lzendesk/conversationkit/android/model/User;", "getVisitType", "Lzendesk/conversationkit/android/model/VisitType;", "getWaitTimeForConversation", "Lzendesk/conversationkit/android/model/WaitTimeDataResponse;", "loadMoreMessages", "Lzendesk/conversationkit/android/model/MessageList;", "beforeTimestamp", "", "(Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", API.TOPIC_LOGIN, "jwt", API.TOPIC_LOGOUT, "processActivityEventReceived", "activityEvent", "Lzendesk/conversationkit/android/model/ActivityEvent;", "(Lzendesk/conversationkit/android/model/ActivityEvent;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "processConversationReadActivity", "processConversationRoutingActivity", "(Lzendesk/conversationkit/android/model/ActivityEvent;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "refreshConversation", "refreshUser", "removeConversationById", "saveConversation", "conversation", "(Lzendesk/conversationkit/android/model/Conversation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveConversationToLocalStorage", "saveConversationWithMetadata", "(Lzendesk/conversationkit/android/model/Conversation;Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveUser", "newUser", "(Lzendesk/conversationkit/android/model/User;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveUserToLocalStorage", "user", "sendActivityData", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "(Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessageRestRequest", "sendPostbackAction", "actionId", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setIntegrationId", "integrationId", "setProactiveMessage", "proactiveMessage", "(Lzendesk/conversationkit/android/model/ProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setPushToken", "pushToken", "setVisitType", "visitType", "(Lzendesk/conversationkit/android/model/VisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "shouldReAuthenticateUser", "updateAppUserLocale", "deviceLocale", "updateConversation", "newMessage", "updateConversationById", "status", "Lzendesk/conversationkit/android/model/ConversationStatus;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateConversationMetadata", "(Ljava/lang/String;Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateDownloadingAttachment", "updateDownloadingStatusFailed", "fileName", "messageId", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateDownloadingStatusSuccess", "updatePushToken", "pushNotificationToken", "updateReAuthenticateUser", "reAuthenticateUser", "(ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserActionProcessorRepository {
    private static final long REMOTE_CALL_RETRY_TIMEOUT = TimeUnit.MINUTES.toMillis(1);
    private final Config config;
    private final ConnectivityObserver connectivityObserver;
    private final UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
    private final UserActionProcessorLocalDataSource userActionProcessorLocalDataSource;
    private final UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;
        public static final int[] $EnumSwitchMapping$1;

        static {
            int[] iArr = new int[ActivityData.values().length];
            try {
                iArr[ActivityData.CONVERSATION_READ.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ActivityData.CONVERSATION_ROUTING_QUEUED.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ActivityData.CONVERSATION_ROUTING_ASSIGNED.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[ActivityData.CONVERSATION_ROUTING_CLEARED.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            $EnumSwitchMapping$0 = iArr;
            int[] iArr2 = new int[AuthorType.values().length];
            try {
                iArr2[AuthorType.USER.ordinal()] = 1;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr2[AuthorType.BUSINESS.ordinal()] = 2;
            } catch (NoSuchFieldError unused6) {
            }
            $EnumSwitchMapping$1 = iArr2;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 2}, m39l = {66, 77, Base64.mimeLineLength, 80}, m40m = "createConversation", m41n = {"this", "proactiveMessageId", "metadata", "this", "metadata", "this"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$0"})
    static final class C11881 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11881(Continuation<? super C11881> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.createConversation(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 0, 1, 2}, m39l = {108, 112, 113, 114, 107}, m40m = "createConversationFromNetwork", m41n = {"this", "conversationType", "signedCampaignData", "metadata", "this", "this"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$0", "L$0"})
    static final class C11891 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        int label;
        Object result;

        C11891(Continuation<? super C11891> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.createConversationFromNetwork(null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0}, m39l = {570, 571}, m40m = "createPendingMessage", m41n = {"this", "conversationId", "message"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C11901 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11901(Continuation<? super C11901> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.createPendingMessage(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 1, 1, 2}, m39l = {190, 191, 189, 194}, m40m = "getConversationRemotely", m41n = {"this", "conversationId", "this", "conversationId", "this"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$0"})
    static final class C11911 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11911(Continuation<? super C11911> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.getConversationRemotely(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 3, 3, 4, 4, 5}, m39l = {316, 319, 322, 329, 330, 328, 333}, m40m = "getConversations", m41n = {"this", "this", "offset", "this", "offset", "this"}, m42s = {"L$0", "L$0", "I$0", "L$0", "I$0", "L$0"})
    static final class C11921 extends ContinuationImpl {
        int I$0;
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11921(Continuation<? super C11921> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.getConversations(0, false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 1}, m39l = {HttpStatus.SC_MULTI_STATUS, 208, 209}, m40m = "getPersistedConversation", m41n = {"this", "conversationId", "this"}, m42s = {"L$0", "L$1", "L$0"})
    static final class C11931 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11931(Continuation<? super C11931> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.getPersistedConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {}, m39l = {128}, m40m = "getProactiveCampaignData", m41n = {}, m42s = {})
    static final class C11941 extends ContinuationImpl {
        int label;
        Object result;

        C11941(Continuation<? super C11941> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.getProactiveCampaignData(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {}, m39l = {904}, m40m = "getProactiveMessage", m41n = {}, m42s = {})
    static final class C11951 extends ContinuationImpl {
        int label;
        Object result;

        C11951(Continuation<? super C11951> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.getProactiveMessage(0, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 2, 3, 4, 5}, m39l = {169, 171, 172, 173, 174, 168, 176}, m40m = "getProactiveMessageConversation", m41n = {"this", "proactiveMessageId", "conversationId", "this", "this", "this", "this", "this"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$0", "L$0", "L$0", "L$0"})
    static final class C11961 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        int label;
        Object result;

        C11961(Continuation<? super C11961> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.getProactiveMessageConversation(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0}, m39l = {987, 986}, m40m = "getWaitTimeForConversation", m41n = {"conversationId"}, m42s = {"L$0"})
    static final class C11971 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11971(Continuation<? super C11971> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.getWaitTimeForConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6}, m39l = {528, 533, 532, 538, 543, 543, 544}, m40m = "loadMoreMessages", m41n = {"this", "conversationId", "beforeTimestamp", "this", "conversationId", "beforeTimestamp", "this", "conversationId", "this", "listOfLoadedMessages", "this", "listOfLoadedMessages", "updatedConversation", "this", "listOfLoadedMessages", "updatedConversation", "listOfLoadedMessages"}, m42s = {"L$0", "L$1", "D$0", "L$0", "L$1", "D$0", "L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0"})
    static final class C11981 extends ContinuationImpl {
        double D$0;
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11981(Continuation<? super C11981> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.loadMoreMessages(null, 0.0d, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 7, 8}, m39l = {HttpStatus.SC_UNPROCESSABLE_ENTITY, HttpStatus.SC_UNPROCESSABLE_ENTITY, 427, 428, 429, 430, 425, 432, 433}, m40m = API.TOPIC_LOGIN, m41n = {"this", "jwt", "this", "jwt", "this", "jwt", "this", "jwt", "this", "jwt", "this", "jwt", "this", "this", "user", "user"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$0", "L$1", "L$0", "L$0", "L$1", "L$0"})
    static final class C11991 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        int label;
        Object result;

        C11991(Continuation<? super C11991> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.login(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 1, 2}, m39l = {AIHelpWebProgress.MAX_DECELERATE_SPEED_DURATION, 454, 455, 456, 452}, m40m = API.TOPIC_LOGOUT, m41n = {"this", "this", "this"}, m42s = {"L$0", "L$0", "L$0"})
    static final class C12001 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C12001(Continuation<? super C12001> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.logout(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0}, m39l = {744, 746, 750}, m40m = "processActivityEventReceived", m41n = {"this", "activityEvent"}, m42s = {"L$0", "L$1"})
    static final class C12011 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C12011(Continuation<? super C12011> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.processActivityEventReceived(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 1, 2, 2, 3, 3, 4}, m39l = {773, 778, 783, 783, 784}, m40m = "processConversationReadActivity", m41n = {"this", "this", "this", "updatedConversation", "this", "updatedConversation", "updatedConversation"}, m42s = {"L$0", "L$0", "L$0", "L$1", "L$0", "L$1", "L$0"})
    static final class C12021 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12021(Continuation<? super C12021> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.processConversationReadActivity(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 1}, m39l = {804, 808}, m40m = "processConversationRoutingActivity", m41n = {"this", "updatedConversation"}, m42s = {"L$0", "L$0"})
    static final class C12031 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C12031(Continuation<? super C12031> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.processConversationRoutingActivity(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0}, m39l = {141, TrackType.TRACK_FAQ_CHECKED}, m40m = "refreshConversation", m41n = {"this"}, m42s = {"L$0"})
    static final class C12041 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C12041(Continuation<? super C12041> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.refreshConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 1, 2, 3}, m39l = {352, 353, 351, 355}, m40m = "refreshUser", m41n = {"this", "this", "this", "refreshedUser"}, m42s = {"L$0", "L$0", "L$0", "L$0"})
    static final class C12051 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12051(Continuation<? super C12051> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.refreshUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 1, 1, 1, 2, 2, 2, 3}, m39l = {90, ConversationMsg.TYPE_ADMIN_VIDEO, ConversationMsg.TYPE_ADMIN_VIDEO, 92}, m40m = "saveConversation", m41n = {"this", "conversation", "this", "conversation", "savedConversation", "this", "conversation", "savedConversation", "savedConversation"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0"})
    static final class C12061 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C12061(Continuation<? super C12061> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.saveConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0}, m39l = {293, 297}, m40m = "saveConversationWithMetadata", m41n = {"this", "conversation"}, m42s = {"L$0", "L$1"})
    static final class C12071 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C12071(Continuation<? super C12071> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.saveConversationWithMetadata(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0}, m39l = {370, 371}, m40m = "saveUser", m41n = {"this", "newUser"}, m42s = {"L$0", "L$1"})
    static final class C12081 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C12081(Continuation<? super C12081> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.saveUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 2, 2, 3}, m39l = {720, 722, 723, 724, 719}, m40m = "sendActivityData", m41n = {"this", "activityData", "conversationId", "this", "activityData", "this", "activityData", "activityData"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$0", "L$1", "L$0"})
    static final class C12091 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        int label;
        Object result;

        C12091(Continuation<? super C12091> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.sendActivityData(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7}, m39l = {599, 602, 605, 609, 614, 615, 615, 620}, m40m = "sendMessage", m41n = {"this", "message", "conversationId", "this", "message", "conversationId", "this", "message", "conversationId", "this", "message", "conversationId", "networkMessage", "this", "message", "conversationId", "networkMessage", "this", "message", "conversationId", "networkMessage", "this", "message", "conversationId", "networkMessage", "e"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$3", "L$0", "L$1", "L$2", "L$3", "L$0", "L$1", "L$2", "L$3", "L$0", "L$1", "L$2", "L$3", "L$0"})
    static final class C12101 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C12101(Continuation<? super C12101> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.sendMessage(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 5, 5, 5, 6, 7}, m39l = {650, 655, 656, 657, 649, 662, 667, 668, 669, 661}, m40m = "sendMessageRestRequest", m41n = {"this", "message", "conversationId", "this", "message", "conversationId", "this", "message", "conversationId", "message", "conversationId", "this", "message", "conversationId", "this", "this"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0", "L$1", "L$0", "L$1", "L$2", "L$0", "L$0"})
    static final class C12121 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        Object L$7;
        Object L$8;
        int label;
        Object result;

        C12121(Continuation<? super C12121> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.sendMessageRestRequest(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 2, 2, 3}, m39l = {839, 841, 842, 843, 838}, m40m = "sendPostbackAction", m41n = {"this", "conversationId", "actionId", "this", "actionId", "this", "actionId", "actionId"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$0", "L$1", "L$0"})
    static final class C12131 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        int label;
        Object result;

        C12131(Continuation<? super C12131> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.sendPostbackAction(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0}, m39l = {474, 473}, m40m = "updateAppUserLocale", m41n = {"deviceLocale"}, m42s = {"L$0"})
    static final class C12141 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C12141(Continuation<? super C12141> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.updateAppUserLocale(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 2, 2, 3, 3, 4}, m39l = {495, 497, HttpStatus.SC_NOT_IMPLEMENTED, HttpStatus.SC_NOT_IMPLEMENTED, HttpStatus.SC_BAD_GATEWAY}, m40m = "updateConversation", m41n = {"this", "conversationId", "newMessage", "this", "this", "updatedConversation", "this", "updatedConversation", "updatedConversation"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$0", "L$1", "L$0", "L$1", "L$0"})
    static final class C12151 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12151(Continuation<? super C12151> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.updateConversation(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 2}, m39l = {255, 260, 261}, m40m = "updateConversationById", m41n = {"this", "status", "metadata", "this", "conversation", "conversation"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$0"})
    static final class C12161 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12161(Continuation<? super C12161> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.updateConversationById(null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4}, m39l = {277, 278, 279, 282, 276, 284}, m40m = "updateConversationMetadata", m41n = {"this", "conversationId", "metadata", "this", "conversationId", "metadata", "this", "conversationId", "metadata", "this", "metadata", "this", "metadata"}, m42s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0", "L$1", "L$2", "L$0", "L$1", "L$0", "L$1"})
    static final class C12171 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        Object L$7;
        int label;
        Object result;

        C12171(Continuation<? super C12171> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.updateConversationMetadata(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 0}, m39l = {927, 928}, m40m = "updateDownloadingAttachment", m41n = {"this", "conversationId", "message"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C12181 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12181(Continuation<? super C12181> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.updateDownloadingAttachment(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository", m37f = "UserActionProcessorRepository.kt", m38i = {0, 0, 1}, m39l = {820, 821, 819}, m40m = "updatePushToken", m41n = {"this", "pushNotificationToken", "pushNotificationToken"}, m42s = {"L$0", "L$1", "L$0"})
    static final class C12191 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12191(Continuation<? super C12191> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorRepository.this.updatePushToken(null, this);
        }
    }

    public UserActionProcessorRepository(UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource, UserActionProcessorLocalDataSource userActionProcessorLocalDataSource, UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource, Config config, ConnectivityObserver connectivityObserver) {
        Intrinsics.checkNotNullParameter(userActionProcessorInMemoryDataSource, "userActionProcessorInMemoryDataSource");
        Intrinsics.checkNotNullParameter(userActionProcessorLocalDataSource, "userActionProcessorLocalDataSource");
        Intrinsics.checkNotNullParameter(userActionProcessorRemoteDataSource, "userActionProcessorRemoteDataSource");
        Intrinsics.checkNotNullParameter(config, "config");
        Intrinsics.checkNotNullParameter(connectivityObserver, "connectivityObserver");
        this.userActionProcessorInMemoryDataSource = userActionProcessorInMemoryDataSource;
        this.userActionProcessorLocalDataSource = userActionProcessorLocalDataSource;
        this.userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource;
        this.config = config;
        this.connectivityObserver = connectivityObserver;
    }

    public final Object createConversation(Integer num, Map<String, ? extends Object> map, Continuation<? super Conversation> continuation) {
        C11881 c11881;
        UserActionProcessorRepository userActionProcessorRepository;
        Map<String, ? extends Object> map2;
        UserActionProcessorRepository userActionProcessorRepository2;
        if (continuation instanceof C11881) {
            c11881 = (C11881) continuation;
            if ((c11881.label & Integer.MIN_VALUE) != 0) {
                c11881.label -= Integer.MIN_VALUE;
            } else {
                c11881 = new C11881(continuation);
            }
        } else {
            c11881 = new C11881(continuation);
        }
        Object user = c11881.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11881.label;
        if (i != 0) {
            if (i == 1) {
                map = (Map) c11881.L$2;
                num = (Integer) c11881.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11881.L$0;
                ResultKt.throwOnFailure(user);
            } else if (i == 2) {
                UserActionProcessorRepository userActionProcessorRepository3 = (UserActionProcessorRepository) c11881.L$2;
                Map<String, ? extends Object> map3 = (Map) c11881.L$1;
                UserActionProcessorRepository userActionProcessorRepository4 = (UserActionProcessorRepository) c11881.L$0;
                ResultKt.throwOnFailure(user);
                map2 = map3;
                userActionProcessorRepository = userActionProcessorRepository3;
                userActionProcessorRepository2 = userActionProcessorRepository4;
                c11881.L$0 = userActionProcessorRepository2;
                c11881.L$1 = null;
                c11881.L$2 = null;
                c11881.label = 3;
                user = createConversationFromNetwork$default(userActionProcessorRepository, null, (String) user, map2, c11881, 1, null);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                c11881.L$0 = null;
                c11881.label = 4;
                user = userActionProcessorRepository2.saveConversation((Conversation) user, c11881);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 3) {
                userActionProcessorRepository2 = (UserActionProcessorRepository) c11881.L$0;
                ResultKt.throwOnFailure(user);
                c11881.L$0 = null;
                c11881.label = 4;
                user = userActionProcessorRepository2.saveConversation((Conversation) user, c11881);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 4) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(user);
            }
            return user;
        }
        ResultKt.throwOnFailure(user);
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
        c11881.L$0 = this;
        c11881.L$1 = num;
        c11881.L$2 = map;
        c11881.label = 1;
        user = userActionProcessorInMemoryDataSource.getUser(c11881);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository = this;
        if (!((User) user).getConversations().isEmpty()) {
            boolean canUserCreateMoreConversations = userActionProcessorRepository.config.getIntegration().getCanUserCreateMoreConversations();
            if (!userActionProcessorRepository.config.getApp().isMultiConvoEnabled()) {
                throw new MultiConvoDisabledException();
            }
            if (!canUserCreateMoreConversations) {
                throw new CantCreateConversationException();
            }
        }
        c11881.L$0 = userActionProcessorRepository;
        c11881.L$1 = map;
        c11881.L$2 = userActionProcessorRepository;
        c11881.label = 2;
        user = userActionProcessorRepository.getProactiveCampaignData(num, c11881);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        map2 = map;
        userActionProcessorRepository2 = userActionProcessorRepository;
        c11881.L$0 = userActionProcessorRepository2;
        c11881.L$1 = null;
        c11881.L$2 = null;
        c11881.label = 3;
        user = createConversationFromNetwork$default(userActionProcessorRepository, null, (String) user, map2, c11881, 1, null);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        c11881.L$0 = null;
        c11881.label = 4;
        user = userActionProcessorRepository2.saveConversation((Conversation) user, c11881);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        return user;
    }

    public final Object saveConversation(Conversation conversation, Continuation<? super Conversation> continuation) throws Throwable {
        C12061 c12061;
        Object obj;
        Conversation conversation2;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRepository userActionProcessorRepository2;
        Conversation conversation3;
        Conversation conversation4;
        Conversation conversation5;
        UserActionProcessorRepository userActionProcessorRepository3;
        if (continuation instanceof C12061) {
            c12061 = (C12061) continuation;
            if ((c12061.label & Integer.MIN_VALUE) != 0) {
                c12061.label -= Integer.MIN_VALUE;
            } else {
                c12061 = new C12061(continuation);
            }
        } else {
            c12061 = new C12061(continuation);
        }
        Object obj2 = c12061.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12061.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj2);
            UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
            c12061.L$0 = this;
            c12061.L$1 = conversation;
            c12061.label = 1;
            Object objSaveConversation = userActionProcessorInMemoryDataSource.saveConversation(conversation, c12061);
            if (objSaveConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            obj = objSaveConversation;
            conversation2 = conversation;
            userActionProcessorRepository = this;
        } else {
            if (i == 1) {
                Conversation conversation6 = (Conversation) c12061.L$1;
                UserActionProcessorRepository userActionProcessorRepository4 = (UserActionProcessorRepository) c12061.L$0;
                ResultKt.throwOnFailure(obj2);
                conversation2 = conversation6;
                userActionProcessorRepository = userActionProcessorRepository4;
                obj = obj2;
            } else if (i == 2) {
                userActionProcessorRepository = (UserActionProcessorRepository) c12061.L$3;
                Conversation conversation7 = (Conversation) c12061.L$2;
                Conversation conversation8 = (Conversation) c12061.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12061.L$0;
                ResultKt.throwOnFailure(obj2);
                conversation4 = conversation7;
                conversation3 = conversation8;
                c12061.L$0 = userActionProcessorRepository2;
                c12061.L$1 = conversation3;
                c12061.L$2 = conversation4;
                c12061.L$3 = null;
                c12061.label = 3;
                if (userActionProcessorRepository.saveUserToLocalStorage((User) obj2, c12061) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation5 = conversation4;
                userActionProcessorRepository3 = userActionProcessorRepository2;
            } else {
                if (i != 3) {
                    if (i != 4) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    Conversation conversation9 = (Conversation) c12061.L$0;
                    ResultKt.throwOnFailure(obj2);
                    return conversation9;
                }
                conversation5 = (Conversation) c12061.L$2;
                conversation3 = (Conversation) c12061.L$1;
                userActionProcessorRepository3 = (UserActionProcessorRepository) c12061.L$0;
                ResultKt.throwOnFailure(obj2);
            }
            c12061.L$0 = conversation5;
            c12061.L$1 = null;
            c12061.L$2 = null;
            c12061.label = 4;
            if (userActionProcessorRepository3.saveConversationToLocalStorage(conversation3, c12061) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return conversation5;
        }
        Conversation conversation10 = (Conversation) obj;
        c12061.L$0 = userActionProcessorRepository;
        c12061.L$1 = conversation2;
        c12061.L$2 = conversation10;
        c12061.L$3 = userActionProcessorRepository;
        c12061.label = 2;
        Object user = userActionProcessorRepository.getUser(c12061);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository2 = userActionProcessorRepository;
        conversation3 = conversation2;
        obj2 = user;
        conversation4 = conversation10;
        c12061.L$0 = userActionProcessorRepository2;
        c12061.L$1 = conversation3;
        c12061.L$2 = conversation4;
        c12061.L$3 = null;
        c12061.label = 3;
        if (userActionProcessorRepository.saveUserToLocalStorage((User) obj2, c12061) == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversation5 = conversation4;
        userActionProcessorRepository3 = userActionProcessorRepository2;
        c12061.L$0 = conversation5;
        c12061.L$1 = null;
        c12061.L$2 = null;
        c12061.label = 4;
        if (userActionProcessorRepository3.saveConversationToLocalStorage(conversation3, c12061) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return conversation5;
    }

    public final Object createConversationFromNetwork(ConversationType conversationType, String str, Map<String, ? extends Object> map, Continuation<? super Conversation> continuation) throws Throwable {
        C11891 c11891;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        ConversationType conversationType2;
        String str2;
        Map<String, ? extends Object> map2;
        UserActionProcessorRepository userActionProcessorRepository;
        String str3;
        String str4;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        UserActionProcessorRepository userActionProcessorRepository2;
        ConversationType conversationType3;
        String str5;
        Object pushToken;
        String str6;
        Map<String, ? extends Object> map3;
        UserActionProcessorRepository userActionProcessorRepository3;
        String str7;
        Object user;
        String str8;
        ConversationType conversationType4;
        String str9;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        Map<String, ? extends Object> map4;
        String str10;
        if (continuation instanceof C11891) {
            c11891 = (C11891) continuation;
            if ((c11891.label & Integer.MIN_VALUE) != 0) {
                c11891.label -= Integer.MIN_VALUE;
            } else {
                c11891 = new C11891(continuation);
            }
        } else {
            c11891 = new C11891(continuation);
        }
        C11891 c11892 = c11891;
        Object user2 = c11892.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11892.label;
        if (i != 0) {
            if (i == 1) {
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c11892.L$4;
                Map<String, ? extends Object> map5 = (Map) c11892.L$3;
                String str11 = (String) c11892.L$2;
                ConversationType conversationType5 = (ConversationType) c11892.L$1;
                UserActionProcessorRepository userActionProcessorRepository4 = (UserActionProcessorRepository) c11892.L$0;
                ResultKt.throwOnFailure(user2);
                map2 = map5;
                userActionProcessorRepository = userActionProcessorRepository4;
                str2 = str11;
                conversationType2 = conversationType5;
            } else if (i == 2) {
                Map<String, ? extends Object> map6 = (Map) c11892.L$5;
                str4 = (String) c11892.L$4;
                conversationType3 = (ConversationType) c11892.L$3;
                str3 = (String) c11892.L$2;
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c11892.L$1;
                UserActionProcessorRepository userActionProcessorRepository5 = (UserActionProcessorRepository) c11892.L$0;
                ResultKt.throwOnFailure(user2);
                map2 = map6;
                userActionProcessorRepository2 = userActionProcessorRepository5;
                str5 = (String) user2;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11892.L$0 = userActionProcessorRepository2;
                c11892.L$1 = userActionProcessorRemoteDataSource2;
                c11892.L$2 = str3;
                c11892.L$3 = conversationType3;
                c11892.L$4 = str4;
                c11892.L$5 = map2;
                c11892.L$6 = str5;
                c11892.label = 3;
                pushToken = userActionProcessorLocalDataSource.getPushToken(c11892);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository6 = userActionProcessorRepository2;
                str6 = str5;
                user2 = pushToken;
                map3 = map2;
                userActionProcessorRepository3 = userActionProcessorRepository6;
                str7 = (String) user2;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository3.userActionProcessorInMemoryDataSource;
                c11892.L$0 = userActionProcessorRemoteDataSource2;
                c11892.L$1 = str3;
                c11892.L$2 = conversationType3;
                c11892.L$3 = str4;
                c11892.L$4 = map3;
                c11892.L$5 = str6;
                c11892.L$6 = str7;
                c11892.label = 4;
                user = userActionProcessorInMemoryDataSource.getUser(c11892);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource2;
                str8 = str7;
                user2 = user;
                conversationType4 = conversationType3;
                str9 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource4;
                String str12 = str4;
                map4 = map3;
                str10 = str12;
                String id = ((User) user2).getId();
                c11892.L$0 = null;
                c11892.L$1 = null;
                c11892.L$2 = null;
                c11892.L$3 = null;
                c11892.L$4 = null;
                c11892.L$5 = null;
                c11892.L$6 = null;
                c11892.label = 5;
                user2 = userActionProcessorRemoteDataSource3.createConversation(str3, conversationType4, str10, map4, str9, str8, id, c11892);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 3) {
                str6 = (String) c11892.L$6;
                map3 = (Map) c11892.L$5;
                str4 = (String) c11892.L$4;
                conversationType3 = (ConversationType) c11892.L$3;
                str3 = (String) c11892.L$2;
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c11892.L$1;
                userActionProcessorRepository3 = (UserActionProcessorRepository) c11892.L$0;
                ResultKt.throwOnFailure(user2);
                str7 = (String) user2;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = userActionProcessorRepository3.userActionProcessorInMemoryDataSource;
                c11892.L$0 = userActionProcessorRemoteDataSource2;
                c11892.L$1 = str3;
                c11892.L$2 = conversationType3;
                c11892.L$3 = str4;
                c11892.L$4 = map3;
                c11892.L$5 = str6;
                c11892.L$6 = str7;
                c11892.label = 4;
                user = userActionProcessorInMemoryDataSource2.getUser(c11892);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource2;
                str8 = str7;
                user2 = user;
                conversationType4 = conversationType3;
                str9 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource5;
                String str13 = str4;
                map4 = map3;
                str10 = str13;
                String id2 = ((User) user2).getId();
                c11892.L$0 = null;
                c11892.L$1 = null;
                c11892.L$2 = null;
                c11892.L$3 = null;
                c11892.L$4 = null;
                c11892.L$5 = null;
                c11892.L$6 = null;
                c11892.label = 5;
                user2 = userActionProcessorRemoteDataSource3.createConversation(str3, conversationType4, str10, map4, str9, str8, id2, c11892);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 4) {
                String str14 = (String) c11892.L$6;
                String str15 = (String) c11892.L$5;
                Map<String, ? extends Object> map7 = (Map) c11892.L$4;
                String str16 = (String) c11892.L$3;
                ConversationType conversationType6 = (ConversationType) c11892.L$2;
                str3 = (String) c11892.L$1;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6 = (UserActionProcessorRemoteDataSource) c11892.L$0;
                ResultKt.throwOnFailure(user2);
                str8 = str14;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource6;
                str9 = str15;
                conversationType4 = conversationType6;
                map4 = map7;
                str10 = str16;
                String id3 = ((User) user2).getId();
                c11892.L$0 = null;
                c11892.L$1 = null;
                c11892.L$2 = null;
                c11892.L$3 = null;
                c11892.L$4 = null;
                c11892.L$5 = null;
                c11892.L$6 = null;
                c11892.label = 5;
                user2 = userActionProcessorRemoteDataSource3.createConversation(str3, conversationType4, str10, map4, str9, str8, id3, c11892);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 5) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(user2);
            }
            return user2;
        }
        ResultKt.throwOnFailure(user2);
        userActionProcessorRemoteDataSource = this.userActionProcessorRemoteDataSource;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource3 = this.userActionProcessorInMemoryDataSource;
        c11892.L$0 = this;
        conversationType2 = conversationType;
        c11892.L$1 = conversationType2;
        str2 = str;
        c11892.L$2 = str2;
        map2 = map;
        c11892.L$3 = map2;
        c11892.L$4 = userActionProcessorRemoteDataSource;
        c11892.label = 1;
        user2 = userActionProcessorInMemoryDataSource3.getUser(c11892);
        if (user2 == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository = this;
        String authorization = UserExtensionsKt.getAuthorization((User) user2);
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c11892.L$0 = userActionProcessorRepository;
        c11892.L$1 = userActionProcessorRemoteDataSource;
        c11892.L$2 = authorization;
        c11892.L$3 = conversationType2;
        c11892.L$4 = str2;
        c11892.L$5 = map2;
        c11892.label = 2;
        Object clientId = userActionProcessorLocalDataSource2.getClientId(c11892);
        if (clientId == coroutine_suspended) {
            return coroutine_suspended;
        }
        ConversationType conversationType7 = conversationType2;
        str3 = authorization;
        user2 = clientId;
        str4 = str2;
        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
        userActionProcessorRepository2 = userActionProcessorRepository;
        conversationType3 = conversationType7;
        str5 = (String) user2;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
        c11892.L$0 = userActionProcessorRepository2;
        c11892.L$1 = userActionProcessorRemoteDataSource2;
        c11892.L$2 = str3;
        c11892.L$3 = conversationType3;
        c11892.L$4 = str4;
        c11892.L$5 = map2;
        c11892.L$6 = str5;
        c11892.label = 3;
        pushToken = userActionProcessorLocalDataSource3.getPushToken(c11892);
        if (pushToken == coroutine_suspended) {
            return coroutine_suspended;
        }
        UserActionProcessorRepository userActionProcessorRepository7 = userActionProcessorRepository2;
        str6 = str5;
        user2 = pushToken;
        map3 = map2;
        userActionProcessorRepository3 = userActionProcessorRepository7;
        str7 = (String) user2;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource4 = userActionProcessorRepository3.userActionProcessorInMemoryDataSource;
        c11892.L$0 = userActionProcessorRemoteDataSource2;
        c11892.L$1 = str3;
        c11892.L$2 = conversationType3;
        c11892.L$3 = str4;
        c11892.L$4 = map3;
        c11892.L$5 = str6;
        c11892.L$6 = str7;
        c11892.label = 4;
        user = userActionProcessorInMemoryDataSource4.getUser(c11892);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource7 = userActionProcessorRemoteDataSource2;
        str8 = str7;
        user2 = user;
        conversationType4 = conversationType3;
        str9 = str6;
        userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource7;
        String str17 = str4;
        map4 = map3;
        str10 = str17;
        String id4 = ((User) user2).getId();
        c11892.L$0 = null;
        c11892.L$1 = null;
        c11892.L$2 = null;
        c11892.L$3 = null;
        c11892.L$4 = null;
        c11892.L$5 = null;
        c11892.L$6 = null;
        c11892.label = 5;
        user2 = userActionProcessorRemoteDataSource3.createConversation(str3, conversationType4, str10, map4, str9, str8, id4, c11892);
        if (user2 == coroutine_suspended) {
            return coroutine_suspended;
        }
        return user2;
    }

    static Object createConversationFromNetwork$default(UserActionProcessorRepository userActionProcessorRepository, ConversationType conversationType, String str, Map map, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            conversationType = ConversationType.PERSONAL;
        }
        if ((i & 2) != 0) {
            str = null;
        }
        if ((i & 4) != 0) {
            map = null;
        }
        return userActionProcessorRepository.createConversationFromNetwork(conversationType, str, map, continuation);
    }

    public final Object getProactiveCampaignData(Integer num, Continuation<? super String> continuation) throws Throwable {
        C11941 c11941;
        if (continuation instanceof C11941) {
            c11941 = (C11941) continuation;
            if ((c11941.label & Integer.MIN_VALUE) != 0) {
                c11941.label -= Integer.MIN_VALUE;
            } else {
                c11941 = new C11941(continuation);
            }
        } else {
            c11941 = new C11941(continuation);
        }
        Object proactiveMessage = c11941.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11941.label;
        if (i == 0) {
            ResultKt.throwOnFailure(proactiveMessage);
            if (num == null) {
                return null;
            }
            int iIntValue = num.intValue();
            UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = this.userActionProcessorLocalDataSource;
            c11941.label = 1;
            proactiveMessage = userActionProcessorLocalDataSource.getProactiveMessage(iIntValue, c11941);
            if (proactiveMessage == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(proactiveMessage);
        }
        ProactiveMessage proactiveMessage2 = (ProactiveMessage) proactiveMessage;
        if (proactiveMessage2 != null) {
            return proactiveMessage2.getJwt();
        }
        return null;
    }

    public final Object refreshConversation(String str, Continuation<? super Conversation> continuation) {
        C12041 c12041;
        UserActionProcessorRepository userActionProcessorRepository;
        if (continuation instanceof C12041) {
            c12041 = (C12041) continuation;
            if ((c12041.label & Integer.MIN_VALUE) != 0) {
                c12041.label -= Integer.MIN_VALUE;
            } else {
                c12041 = new C12041(continuation);
            }
        } else {
            c12041 = new C12041(continuation);
        }
        Object objWithTimeout = c12041.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12041.label;
        if (i != 0) {
            if (i == 1) {
                userActionProcessorRepository = (UserActionProcessorRepository) c12041.L$0;
                ResultKt.throwOnFailure(objWithTimeout);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objWithTimeout);
            }
        }
        ResultKt.throwOnFailure(objWithTimeout);
        long j = REMOTE_CALL_RETRY_TIMEOUT;
        UserActionProcessorRepository$refreshConversation$conversation$1 userActionProcessorRepository$refreshConversation$conversation$1 = new UserActionProcessorRepository$refreshConversation$conversation$1(this, str, null);
        c12041.L$0 = this;
        c12041.label = 1;
        objWithTimeout = TimeoutKt.withTimeout(j, userActionProcessorRepository$refreshConversation$conversation$1, c12041);
        if (objWithTimeout == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository = this;
        c12041.L$0 = null;
        c12041.label = 2;
        objWithTimeout = userActionProcessorRepository.saveConversation((Conversation) objWithTimeout, c12041);
        return objWithTimeout == coroutine_suspended ? coroutine_suspended : objWithTimeout;
    }

    public final Object getProactiveMessageConversation(Integer num, String str, Continuation<? super Conversation> continuation) {
        C11961 c11961;
        Integer num2;
        String str2;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String authorization;
        Object proactiveCampaignData;
        String str3;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        String str4;
        String str5;
        Object user;
        UserActionProcessorRepository userActionProcessorRepository2;
        String str6;
        String str7;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        String str8;
        String id;
        String str9;
        Object pushToken;
        UserActionProcessorRepository userActionProcessorRepository3;
        String str10;
        String str11;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4;
        String str12;
        String str13;
        UserActionProcessorRepository userActionProcessorRepository4;
        if (continuation instanceof C11961) {
            c11961 = (C11961) continuation;
            if ((c11961.label & Integer.MIN_VALUE) != 0) {
                c11961.label -= Integer.MIN_VALUE;
            } else {
                c11961 = new C11961(continuation);
            }
        } else {
            c11961 = new C11961(continuation);
        }
        Object clientId = c11961.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c11961.label) {
            case 0:
                ResultKt.throwOnFailure(clientId);
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5 = this.userActionProcessorRemoteDataSource;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
                c11961.L$0 = this;
                num2 = num;
                c11961.L$1 = num2;
                str2 = str;
                c11961.L$2 = str2;
                c11961.L$3 = userActionProcessorRemoteDataSource5;
                c11961.label = 1;
                Object user2 = userActionProcessorInMemoryDataSource.getUser(c11961);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository = this;
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource5;
                clientId = user2;
                authorization = UserExtensionsKt.getAuthorization((User) clientId);
                c11961.L$0 = userActionProcessorRepository;
                c11961.L$1 = userActionProcessorRemoteDataSource;
                c11961.L$2 = authorization;
                c11961.L$3 = str2;
                c11961.label = 2;
                proactiveCampaignData = userActionProcessorRepository.getProactiveCampaignData(num2, c11961);
                if (proactiveCampaignData == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str3 = authorization;
                clientId = proactiveCampaignData;
                String str14 = str2;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                str4 = str14;
                str5 = (String) clientId;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                c11961.L$0 = userActionProcessorRepository;
                c11961.L$1 = userActionProcessorRemoteDataSource2;
                c11961.L$2 = str3;
                c11961.L$3 = str4;
                c11961.L$4 = str5;
                c11961.label = 3;
                user = userActionProcessorInMemoryDataSource2.getUser(c11961);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                str6 = str3;
                str7 = str5;
                clientId = user;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str8 = str4;
                id = ((User) clientId).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.label = 4;
                clientId = userActionProcessorLocalDataSource.getClientId(c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str9 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.L$6 = str9;
                c11961.label = 5;
                pushToken = userActionProcessorLocalDataSource2.getPushToken(c11961);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str10 = str9;
                clientId = pushToken;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6 = userActionProcessorRemoteDataSource3;
                str11 = id;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource6;
                String str15 = str6;
                str12 = str7;
                str13 = str15;
                c11961.L$0 = userActionProcessorRepository3;
                c11961.L$1 = null;
                c11961.L$2 = null;
                c11961.L$3 = null;
                c11961.L$4 = null;
                c11961.L$5 = null;
                c11961.L$6 = null;
                c11961.label = 6;
                clientId = userActionProcessorRemoteDataSource4.proactiveMessageReferral(str13, str8, str12, str11, str10, (String) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11961.L$0 = null;
                c11961.label = 7;
                clientId = userActionProcessorRepository4.saveConversation((Conversation) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return clientId;
            case 1:
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c11961.L$3;
                String str16 = (String) c11961.L$2;
                Integer num3 = (Integer) c11961.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11961.L$0;
                ResultKt.throwOnFailure(clientId);
                str2 = str16;
                num2 = num3;
                authorization = UserExtensionsKt.getAuthorization((User) clientId);
                c11961.L$0 = userActionProcessorRepository;
                c11961.L$1 = userActionProcessorRemoteDataSource;
                c11961.L$2 = authorization;
                c11961.L$3 = str2;
                c11961.label = 2;
                proactiveCampaignData = userActionProcessorRepository.getProactiveCampaignData(num2, c11961);
                if (proactiveCampaignData == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str3 = authorization;
                clientId = proactiveCampaignData;
                String str17 = str2;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                str4 = str17;
                str5 = (String) clientId;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource3 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                c11961.L$0 = userActionProcessorRepository;
                c11961.L$1 = userActionProcessorRemoteDataSource2;
                c11961.L$2 = str3;
                c11961.L$3 = str4;
                c11961.L$4 = str5;
                c11961.label = 3;
                user = userActionProcessorInMemoryDataSource3.getUser(c11961);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                str6 = str3;
                str7 = str5;
                clientId = user;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str8 = str4;
                id = ((User) clientId).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.label = 4;
                clientId = userActionProcessorLocalDataSource3.getClientId(c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str9 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource4 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.L$6 = str9;
                c11961.label = 5;
                pushToken = userActionProcessorLocalDataSource4.getPushToken(c11961);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str10 = str9;
                clientId = pushToken;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource7 = userActionProcessorRemoteDataSource3;
                str11 = id;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource7;
                String str18 = str6;
                str12 = str7;
                str13 = str18;
                c11961.L$0 = userActionProcessorRepository3;
                c11961.L$1 = null;
                c11961.L$2 = null;
                c11961.L$3 = null;
                c11961.L$4 = null;
                c11961.L$5 = null;
                c11961.L$6 = null;
                c11961.label = 6;
                clientId = userActionProcessorRemoteDataSource4.proactiveMessageReferral(str13, str8, str12, str11, str10, (String) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11961.L$0 = null;
                c11961.label = 7;
                clientId = userActionProcessorRepository4.saveConversation((Conversation) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return clientId;
            case 2:
                str4 = (String) c11961.L$3;
                str3 = (String) c11961.L$2;
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c11961.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11961.L$0;
                ResultKt.throwOnFailure(clientId);
                str5 = (String) clientId;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource4 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                c11961.L$0 = userActionProcessorRepository;
                c11961.L$1 = userActionProcessorRemoteDataSource2;
                c11961.L$2 = str3;
                c11961.L$3 = str4;
                c11961.L$4 = str5;
                c11961.label = 3;
                user = userActionProcessorInMemoryDataSource4.getUser(c11961);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                str6 = str3;
                str7 = str5;
                clientId = user;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str8 = str4;
                id = ((User) clientId).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource5 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.label = 4;
                clientId = userActionProcessorLocalDataSource5.getClientId(c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str9 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource6 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.L$6 = str9;
                c11961.label = 5;
                pushToken = userActionProcessorLocalDataSource6.getPushToken(c11961);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str10 = str9;
                clientId = pushToken;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource8 = userActionProcessorRemoteDataSource3;
                str11 = id;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource8;
                String str19 = str6;
                str12 = str7;
                str13 = str19;
                c11961.L$0 = userActionProcessorRepository3;
                c11961.L$1 = null;
                c11961.L$2 = null;
                c11961.L$3 = null;
                c11961.L$4 = null;
                c11961.L$5 = null;
                c11961.L$6 = null;
                c11961.label = 6;
                clientId = userActionProcessorRemoteDataSource4.proactiveMessageReferral(str13, str8, str12, str11, str10, (String) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11961.L$0 = null;
                c11961.label = 7;
                clientId = userActionProcessorRepository4.saveConversation((Conversation) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return clientId;
            case 3:
                String str20 = (String) c11961.L$4;
                String str21 = (String) c11961.L$3;
                String str22 = (String) c11961.L$2;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource9 = (UserActionProcessorRemoteDataSource) c11961.L$1;
                UserActionProcessorRepository userActionProcessorRepository5 = (UserActionProcessorRepository) c11961.L$0;
                ResultKt.throwOnFailure(clientId);
                userActionProcessorRepository2 = userActionProcessorRepository5;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource9;
                str6 = str22;
                str8 = str21;
                str7 = str20;
                id = ((User) clientId).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource7 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.label = 4;
                clientId = userActionProcessorLocalDataSource7.getClientId(c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str9 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource8 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.L$6 = str9;
                c11961.label = 5;
                pushToken = userActionProcessorLocalDataSource8.getPushToken(c11961);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str10 = str9;
                clientId = pushToken;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource10 = userActionProcessorRemoteDataSource3;
                str11 = id;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource10;
                String str110 = str6;
                str12 = str7;
                str13 = str110;
                c11961.L$0 = userActionProcessorRepository3;
                c11961.L$1 = null;
                c11961.L$2 = null;
                c11961.L$3 = null;
                c11961.L$4 = null;
                c11961.L$5 = null;
                c11961.L$6 = null;
                c11961.label = 6;
                clientId = userActionProcessorRemoteDataSource4.proactiveMessageReferral(str13, str8, str12, str11, str10, (String) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11961.L$0 = null;
                c11961.label = 7;
                clientId = userActionProcessorRepository4.saveConversation((Conversation) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return clientId;
            case 4:
                id = (String) c11961.L$5;
                str7 = (String) c11961.L$4;
                str8 = (String) c11961.L$3;
                str6 = (String) c11961.L$2;
                userActionProcessorRemoteDataSource3 = (UserActionProcessorRemoteDataSource) c11961.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c11961.L$0;
                ResultKt.throwOnFailure(clientId);
                str9 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource9 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11961.L$0 = userActionProcessorRepository2;
                c11961.L$1 = userActionProcessorRemoteDataSource3;
                c11961.L$2 = str6;
                c11961.L$3 = str8;
                c11961.L$4 = str7;
                c11961.L$5 = id;
                c11961.L$6 = str9;
                c11961.label = 5;
                pushToken = userActionProcessorLocalDataSource9.getPushToken(c11961);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str10 = str9;
                clientId = pushToken;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource11 = userActionProcessorRemoteDataSource3;
                str11 = id;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource11;
                String str111 = str6;
                str12 = str7;
                str13 = str111;
                c11961.L$0 = userActionProcessorRepository3;
                c11961.L$1 = null;
                c11961.L$2 = null;
                c11961.L$3 = null;
                c11961.L$4 = null;
                c11961.L$5 = null;
                c11961.L$6 = null;
                c11961.label = 6;
                clientId = userActionProcessorRemoteDataSource4.proactiveMessageReferral(str13, str8, str12, str11, str10, (String) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11961.L$0 = null;
                c11961.label = 7;
                clientId = userActionProcessorRepository4.saveConversation((Conversation) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return clientId;
            case 5:
                String str23 = (String) c11961.L$6;
                String str24 = (String) c11961.L$5;
                String str25 = (String) c11961.L$4;
                String str26 = (String) c11961.L$3;
                String str27 = (String) c11961.L$2;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource12 = (UserActionProcessorRemoteDataSource) c11961.L$1;
                UserActionProcessorRepository userActionProcessorRepository6 = (UserActionProcessorRepository) c11961.L$0;
                ResultKt.throwOnFailure(clientId);
                userActionProcessorRepository3 = userActionProcessorRepository6;
                str10 = str23;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource12;
                str11 = str24;
                str13 = str27;
                str12 = str25;
                str8 = str26;
                c11961.L$0 = userActionProcessorRepository3;
                c11961.L$1 = null;
                c11961.L$2 = null;
                c11961.L$3 = null;
                c11961.L$4 = null;
                c11961.L$5 = null;
                c11961.L$6 = null;
                c11961.label = 6;
                clientId = userActionProcessorRemoteDataSource4.proactiveMessageReferral(str13, str8, str12, str11, str10, (String) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11961.L$0 = null;
                c11961.label = 7;
                clientId = userActionProcessorRepository4.saveConversation((Conversation) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return clientId;
            case 6:
                userActionProcessorRepository4 = (UserActionProcessorRepository) c11961.L$0;
                ResultKt.throwOnFailure(clientId);
                c11961.L$0 = null;
                c11961.label = 7;
                clientId = userActionProcessorRepository4.saveConversation((Conversation) clientId, c11961);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return clientId;
            case 7:
                ResultKt.throwOnFailure(clientId);
                return clientId;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object getConversationRemotely(String str, Continuation<? super Conversation> continuation) {
        C11911 c11911;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String str2;
        String str3;
        UserActionProcessorRepository userActionProcessorRepository2;
        if (continuation instanceof C11911) {
            c11911 = (C11911) continuation;
            if ((c11911.label & Integer.MIN_VALUE) != 0) {
                c11911.label -= Integer.MIN_VALUE;
            } else {
                c11911 = new C11911(continuation);
            }
        } else {
            c11911 = new C11911(continuation);
        }
        Object conversation = c11911.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11911.label;
        if (i != 0) {
            if (i == 1) {
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c11911.L$2;
                String str4 = (String) c11911.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11911.L$0;
                ResultKt.throwOnFailure(conversation);
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource2;
                str = str4;
            } else if (i == 2) {
                str3 = (String) c11911.L$3;
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c11911.L$2;
                str2 = (String) c11911.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11911.L$0;
                ResultKt.throwOnFailure(conversation);
                String id = ((User) conversation).getId();
                c11911.L$0 = userActionProcessorRepository;
                c11911.L$1 = null;
                c11911.L$2 = null;
                c11911.L$3 = null;
                c11911.label = 3;
                conversation = userActionProcessorRemoteDataSource.getConversation(str3, str2, id, c11911);
                if (conversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                c11911.L$0 = null;
                c11911.label = 4;
                conversation = userActionProcessorRepository2.saveConversation((Conversation) conversation, c11911);
                if (conversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 3) {
                userActionProcessorRepository2 = (UserActionProcessorRepository) c11911.L$0;
                ResultKt.throwOnFailure(conversation);
                c11911.L$0 = null;
                c11911.label = 4;
                conversation = userActionProcessorRepository2.saveConversation((Conversation) conversation, c11911);
                if (conversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 4) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(conversation);
            }
            return conversation;
        }
        ResultKt.throwOnFailure(conversation);
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3 = this.userActionProcessorRemoteDataSource;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
        c11911.L$0 = this;
        c11911.L$1 = str;
        c11911.L$2 = userActionProcessorRemoteDataSource3;
        c11911.label = 1;
        Object user = userActionProcessorInMemoryDataSource.getUser(c11911);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository = this;
        userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource3;
        conversation = user;
        String authorization = UserExtensionsKt.getAuthorization((User) conversation);
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
        c11911.L$0 = userActionProcessorRepository;
        c11911.L$1 = str;
        c11911.L$2 = userActionProcessorRemoteDataSource;
        c11911.L$3 = authorization;
        c11911.label = 2;
        Object user2 = userActionProcessorInMemoryDataSource2.getUser(c11911);
        if (user2 == coroutine_suspended) {
            return coroutine_suspended;
        }
        str2 = str;
        str3 = authorization;
        conversation = user2;
        String id2 = ((User) conversation).getId();
        c11911.L$0 = userActionProcessorRepository;
        c11911.L$1 = null;
        c11911.L$2 = null;
        c11911.L$3 = null;
        c11911.label = 3;
        conversation = userActionProcessorRemoteDataSource.getConversation(str3, str2, id2, c11911);
        if (conversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository2 = userActionProcessorRepository;
        c11911.L$0 = null;
        c11911.label = 4;
        conversation = userActionProcessorRepository2.saveConversation((Conversation) conversation, c11911);
        if (conversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        return conversation;
    }

    public final Object getPersistedConversation(String str, Continuation<? super Conversation> continuation) {
        C11931 c11931;
        Object obj;
        String str2;
        UserActionProcessorRepository userActionProcessorRepository;
        Conversation conversation;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Conversation conversation2;
        if (continuation instanceof C11931) {
            c11931 = (C11931) continuation;
            if ((c11931.label & Integer.MIN_VALUE) != 0) {
                c11931.label -= Integer.MIN_VALUE;
            } else {
                c11931 = new C11931(continuation);
            }
        } else {
            c11931 = new C11931(continuation);
        }
        Object conversation3 = c11931.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11931.label;
        if (i != 0) {
            if (i == 1) {
                String str3 = (String) c11931.L$1;
                UserActionProcessorRepository userActionProcessorRepository2 = (UserActionProcessorRepository) c11931.L$0;
                ResultKt.throwOnFailure(conversation3);
                str2 = str3;
                userActionProcessorRepository = userActionProcessorRepository2;
                obj = conversation3;
            } else if (i == 2) {
                userActionProcessorRepository = (UserActionProcessorRepository) c11931.L$0;
                ResultKt.throwOnFailure(conversation3);
                conversation = (Conversation) conversation3;
                if (conversation != null) {
                    return null;
                }
                userActionProcessorInMemoryDataSource = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                c11931.L$0 = conversation;
                c11931.label = 3;
                if (userActionProcessorInMemoryDataSource.saveConversation(conversation, c11931) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation2 = conversation;
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                conversation2 = (Conversation) c11931.L$0;
                ResultKt.throwOnFailure(conversation3);
            }
            return conversation2;
        }
        ResultKt.throwOnFailure(conversation3);
        if (str == null) {
            return null;
        }
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = this.userActionProcessorInMemoryDataSource;
        c11931.L$0 = this;
        c11931.L$1 = str;
        c11931.label = 1;
        Object conversation4 = userActionProcessorInMemoryDataSource2.getConversation(str, c11931);
        if (conversation4 == coroutine_suspended) {
            return coroutine_suspended;
        }
        obj = conversation4;
        str2 = str;
        userActionProcessorRepository = this;
        Conversation conversation5 = (Conversation) obj;
        if (conversation5 != null) {
            return conversation5;
        }
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c11931.L$0 = userActionProcessorRepository;
        c11931.L$1 = null;
        c11931.label = 2;
        conversation3 = userActionProcessorLocalDataSource.getConversation(str2, c11931);
        if (conversation3 == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversation = (Conversation) conversation3;
        if (conversation != null) {
            return null;
        }
        userActionProcessorInMemoryDataSource = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
        c11931.L$0 = conversation;
        c11931.label = 3;
        if (userActionProcessorInMemoryDataSource.saveConversation(conversation, c11931) == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversation2 = conversation;
        return conversation2;
    }

    public final Object getUser(Continuation<? super User> continuation) {
        return this.userActionProcessorInMemoryDataSource.getUser(continuation);
    }

    public final Object removeConversationById(String str, Continuation<? super Unit> continuation) {
        Object objRemoveConversationById = this.userActionProcessorLocalDataSource.removeConversationById(str, continuation);
        return objRemoveConversationById == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objRemoveConversationById : Unit.INSTANCE;
    }

    public final Object updateConversationById(String str, ConversationStatus conversationStatus, Map<String, ? extends Object> map, Continuation<? super Conversation> continuation) {
        C12161 c12161;
        ConversationStatus conversationStatus2;
        Map<String, ? extends Object> map2;
        UserActionProcessorRepository userActionProcessorRepository;
        Conversation conversationCopy;
        UserActionProcessorRepository userActionProcessorRepository2;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource;
        if (continuation instanceof C12161) {
            c12161 = (C12161) continuation;
            if ((c12161.label & Integer.MIN_VALUE) != 0) {
                c12161.label -= Integer.MIN_VALUE;
            } else {
                c12161 = new C12161(continuation);
            }
        } else {
            c12161 = new C12161(continuation);
        }
        Object obj = c12161.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12161.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c12161.L$0 = this;
            c12161.L$1 = conversationStatus;
            c12161.L$2 = map;
            c12161.label = 1;
            Object persistedConversation = getPersistedConversation(str, c12161);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationStatus2 = conversationStatus;
            map2 = map;
            obj = persistedConversation;
            userActionProcessorRepository = this;
        } else {
            if (i == 1) {
                Map<String, ? extends Object> map3 = (Map) c12161.L$2;
                ConversationStatus conversationStatus3 = (ConversationStatus) c12161.L$1;
                UserActionProcessorRepository userActionProcessorRepository3 = (UserActionProcessorRepository) c12161.L$0;
                ResultKt.throwOnFailure(obj);
                map2 = map3;
                conversationStatus2 = conversationStatus3;
                userActionProcessorRepository = userActionProcessorRepository3;
            } else {
                if (i != 2) {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    Conversation conversation = (Conversation) c12161.L$0;
                    ResultKt.throwOnFailure(obj);
                    return conversation;
                }
                Conversation conversation2 = (Conversation) c12161.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12161.L$0;
                ResultKt.throwOnFailure(obj);
                conversationCopy = conversation2;
            }
            userActionProcessorLocalDataSource = userActionProcessorRepository2.userActionProcessorLocalDataSource;
            c12161.L$0 = conversationCopy;
            c12161.L$1 = null;
            c12161.label = 3;
            if (userActionProcessorLocalDataSource.saveConversation(conversationCopy, c12161) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return conversationCopy;
        }
        Conversation conversation3 = (Conversation) obj;
        if (conversation3 == null || (conversationCopy = conversation3.copy((129023 & 1) != 0 ? conversation3.id : null, (129023 & 2) != 0 ? conversation3.displayName : null, (129023 & 4) != 0 ? conversation3.description : null, (129023 & 8) != 0 ? conversation3.iconUrl : null, (129023 & 16) != 0 ? conversation3.type : null, (129023 & 32) != 0 ? conversation3.isDefault : false, (129023 & 64) != 0 ? conversation3.business : null, (129023 & 128) != 0 ? conversation3.businessLastRead : null, (129023 & 256) != 0 ? conversation3.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation3.myself : null, (129023 & 1024) != 0 ? conversation3.participants : null, (129023 & 2048) != 0 ? conversation3.messages : null, (129023 & 4096) != 0 ? conversation3.hasPrevious : false, (129023 & 8192) != 0 ? conversation3.status : conversationStatus2, (129023 & 16384) != 0 ? conversation3.metadata : map2, (129023 & 32768) != 0 ? conversation3.routingStatus : null, (129023 & 65536) != 0 ? conversation3.createdAt : null)) == null) {
            throw new ConversationNotFoundException();
        }
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
        c12161.L$0 = userActionProcessorRepository;
        c12161.L$1 = conversationCopy;
        c12161.L$2 = null;
        c12161.label = 2;
        if (userActionProcessorInMemoryDataSource.saveConversation(conversationCopy, c12161) == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository2 = userActionProcessorRepository;
        userActionProcessorLocalDataSource = userActionProcessorRepository2.userActionProcessorLocalDataSource;
        c12161.L$0 = conversationCopy;
        c12161.L$1 = null;
        c12161.label = 3;
        if (userActionProcessorLocalDataSource.saveConversation(conversationCopy, c12161) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return conversationCopy;
    }

    public final Object updateConversationMetadata(String str, Map<String, ? extends Object> map, Continuation<? super Unit> continuation) throws Throwable {
        C12171 c12171;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String str2;
        Map<String, ? extends Object> map2;
        UserActionProcessorRepository userActionProcessorRepository;
        String str3;
        Object pushToken;
        UserActionProcessorRepository userActionProcessorRepository2;
        Map<String, ? extends Object> map3;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        String str4;
        String str5;
        String str6;
        String authorization;
        Object user;
        Map<String, ? extends Object> map4;
        UserActionProcessorRepository userActionProcessorRepository3;
        String str7;
        Map<String, ? extends Object> map5;
        String str8;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        Map<String, ? extends Object> map6;
        UserActionProcessorRepository userActionProcessorRepository4;
        if (continuation instanceof C12171) {
            c12171 = (C12171) continuation;
            if ((c12171.label & Integer.MIN_VALUE) != 0) {
                c12171.label -= Integer.MIN_VALUE;
            } else {
                c12171 = new C12171(continuation);
            }
        } else {
            c12171 = new C12171(continuation);
        }
        Object clientId = c12171.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c12171.label) {
            case 0:
                ResultKt.throwOnFailure(clientId);
                userActionProcessorRemoteDataSource = this.userActionProcessorRemoteDataSource;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = this.userActionProcessorLocalDataSource;
                c12171.L$0 = this;
                str2 = str;
                c12171.L$1 = str2;
                map2 = map;
                c12171.L$2 = map2;
                c12171.L$3 = userActionProcessorRemoteDataSource;
                c12171.label = 1;
                clientId = userActionProcessorLocalDataSource.getClientId(c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository = this;
                str3 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12171.L$0 = userActionProcessorRepository;
                c12171.L$1 = str2;
                c12171.L$2 = map2;
                c12171.L$3 = userActionProcessorRemoteDataSource;
                c12171.L$4 = str3;
                c12171.label = 2;
                pushToken = userActionProcessorLocalDataSource2.getPushToken(c12171);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                map3 = map2;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                String str9 = str2;
                str4 = str3;
                clientId = pushToken;
                str5 = str9;
                str6 = (String) clientId;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c12171.L$0 = userActionProcessorRepository2;
                c12171.L$1 = str5;
                c12171.L$2 = map3;
                c12171.L$3 = userActionProcessorRemoteDataSource2;
                c12171.L$4 = str4;
                c12171.L$5 = str6;
                c12171.label = 3;
                clientId = userActionProcessorInMemoryDataSource.getUser(c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                authorization = UserExtensionsKt.getAuthorization((User) clientId);
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c12171.L$0 = userActionProcessorRepository2;
                c12171.L$1 = map3;
                c12171.L$2 = userActionProcessorRemoteDataSource2;
                c12171.L$3 = str4;
                c12171.L$4 = str6;
                c12171.L$5 = authorization;
                c12171.L$6 = str5;
                c12171.L$7 = map3;
                c12171.label = 4;
                user = userActionProcessorInMemoryDataSource2.getUser(c12171);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map4 = map3;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = authorization;
                map5 = map4;
                clientId = user;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource2;
                str8 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource4;
                String id = ((User) clientId).getId();
                c12171.L$0 = userActionProcessorRepository3;
                c12171.L$1 = map4;
                c12171.L$2 = null;
                c12171.L$3 = null;
                c12171.L$4 = null;
                c12171.L$5 = null;
                c12171.L$6 = null;
                c12171.L$7 = null;
                c12171.label = 5;
                clientId = userActionProcessorRemoteDataSource3.updateConversation(str4, str8, str7, str5, map5, id, c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map6 = map4;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c12171.L$0 = null;
                c12171.L$1 = null;
                c12171.label = 6;
                if (userActionProcessorRepository4.saveConversationWithMetadata((Conversation) clientId, map6, c12171) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 1:
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12171.L$3;
                Map<String, ? extends Object> map7 = (Map) c12171.L$2;
                String str10 = (String) c12171.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12171.L$0;
                ResultKt.throwOnFailure(clientId);
                map2 = map7;
                str2 = str10;
                str3 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12171.L$0 = userActionProcessorRepository;
                c12171.L$1 = str2;
                c12171.L$2 = map2;
                c12171.L$3 = userActionProcessorRemoteDataSource;
                c12171.L$4 = str3;
                c12171.label = 2;
                pushToken = userActionProcessorLocalDataSource3.getPushToken(c12171);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                map3 = map2;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                String str11 = str2;
                str4 = str3;
                clientId = pushToken;
                str5 = str11;
                str6 = (String) clientId;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource3 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c12171.L$0 = userActionProcessorRepository2;
                c12171.L$1 = str5;
                c12171.L$2 = map3;
                c12171.L$3 = userActionProcessorRemoteDataSource2;
                c12171.L$4 = str4;
                c12171.L$5 = str6;
                c12171.label = 3;
                clientId = userActionProcessorInMemoryDataSource3.getUser(c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                authorization = UserExtensionsKt.getAuthorization((User) clientId);
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource4 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c12171.L$0 = userActionProcessorRepository2;
                c12171.L$1 = map3;
                c12171.L$2 = userActionProcessorRemoteDataSource2;
                c12171.L$3 = str4;
                c12171.L$4 = str6;
                c12171.L$5 = authorization;
                c12171.L$6 = str5;
                c12171.L$7 = map3;
                c12171.label = 4;
                user = userActionProcessorInMemoryDataSource4.getUser(c12171);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map4 = map3;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = authorization;
                map5 = map4;
                clientId = user;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource2;
                str8 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource5;
                String id2 = ((User) clientId).getId();
                c12171.L$0 = userActionProcessorRepository3;
                c12171.L$1 = map4;
                c12171.L$2 = null;
                c12171.L$3 = null;
                c12171.L$4 = null;
                c12171.L$5 = null;
                c12171.L$6 = null;
                c12171.L$7 = null;
                c12171.label = 5;
                clientId = userActionProcessorRemoteDataSource3.updateConversation(str4, str8, str7, str5, map5, id2, c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map6 = map4;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c12171.L$0 = null;
                c12171.L$1 = null;
                c12171.label = 6;
                if (userActionProcessorRepository4.saveConversationWithMetadata((Conversation) clientId, map6, c12171) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 2:
                String str12 = (String) c12171.L$4;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6 = (UserActionProcessorRemoteDataSource) c12171.L$3;
                Map<String, ? extends Object> map8 = (Map) c12171.L$2;
                String str13 = (String) c12171.L$1;
                UserActionProcessorRepository userActionProcessorRepository5 = (UserActionProcessorRepository) c12171.L$0;
                ResultKt.throwOnFailure(clientId);
                userActionProcessorRepository2 = userActionProcessorRepository5;
                str5 = str13;
                map3 = map8;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource6;
                str4 = str12;
                str6 = (String) clientId;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource5 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c12171.L$0 = userActionProcessorRepository2;
                c12171.L$1 = str5;
                c12171.L$2 = map3;
                c12171.L$3 = userActionProcessorRemoteDataSource2;
                c12171.L$4 = str4;
                c12171.L$5 = str6;
                c12171.label = 3;
                clientId = userActionProcessorInMemoryDataSource5.getUser(c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                authorization = UserExtensionsKt.getAuthorization((User) clientId);
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource6 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c12171.L$0 = userActionProcessorRepository2;
                c12171.L$1 = map3;
                c12171.L$2 = userActionProcessorRemoteDataSource2;
                c12171.L$3 = str4;
                c12171.L$4 = str6;
                c12171.L$5 = authorization;
                c12171.L$6 = str5;
                c12171.L$7 = map3;
                c12171.label = 4;
                user = userActionProcessorInMemoryDataSource6.getUser(c12171);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map4 = map3;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = authorization;
                map5 = map4;
                clientId = user;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource7 = userActionProcessorRemoteDataSource2;
                str8 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource7;
                String id3 = ((User) clientId).getId();
                c12171.L$0 = userActionProcessorRepository3;
                c12171.L$1 = map4;
                c12171.L$2 = null;
                c12171.L$3 = null;
                c12171.L$4 = null;
                c12171.L$5 = null;
                c12171.L$6 = null;
                c12171.L$7 = null;
                c12171.label = 5;
                clientId = userActionProcessorRemoteDataSource3.updateConversation(str4, str8, str7, str5, map5, id3, c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map6 = map4;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c12171.L$0 = null;
                c12171.L$1 = null;
                c12171.label = 6;
                if (userActionProcessorRepository4.saveConversationWithMetadata((Conversation) clientId, map6, c12171) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 3:
                str6 = (String) c12171.L$5;
                str4 = (String) c12171.L$4;
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c12171.L$3;
                map3 = (Map) c12171.L$2;
                str5 = (String) c12171.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12171.L$0;
                ResultKt.throwOnFailure(clientId);
                authorization = UserExtensionsKt.getAuthorization((User) clientId);
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource7 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c12171.L$0 = userActionProcessorRepository2;
                c12171.L$1 = map3;
                c12171.L$2 = userActionProcessorRemoteDataSource2;
                c12171.L$3 = str4;
                c12171.L$4 = str6;
                c12171.L$5 = authorization;
                c12171.L$6 = str5;
                c12171.L$7 = map3;
                c12171.label = 4;
                user = userActionProcessorInMemoryDataSource7.getUser(c12171);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map4 = map3;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = authorization;
                map5 = map4;
                clientId = user;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource8 = userActionProcessorRemoteDataSource2;
                str8 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource8;
                String id4 = ((User) clientId).getId();
                c12171.L$0 = userActionProcessorRepository3;
                c12171.L$1 = map4;
                c12171.L$2 = null;
                c12171.L$3 = null;
                c12171.L$4 = null;
                c12171.L$5 = null;
                c12171.L$6 = null;
                c12171.L$7 = null;
                c12171.label = 5;
                clientId = userActionProcessorRemoteDataSource3.updateConversation(str4, str8, str7, str5, map5, id4, c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map6 = map4;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c12171.L$0 = null;
                c12171.L$1 = null;
                c12171.label = 6;
                if (userActionProcessorRepository4.saveConversationWithMetadata((Conversation) clientId, map6, c12171) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 4:
                Map<String, ? extends Object> map9 = (Map) c12171.L$7;
                String str14 = (String) c12171.L$6;
                String str15 = (String) c12171.L$5;
                String str16 = (String) c12171.L$4;
                String str17 = (String) c12171.L$3;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource9 = (UserActionProcessorRemoteDataSource) c12171.L$2;
                Map<String, ? extends Object> map10 = (Map) c12171.L$1;
                UserActionProcessorRepository userActionProcessorRepository6 = (UserActionProcessorRepository) c12171.L$0;
                ResultKt.throwOnFailure(clientId);
                map4 = map10;
                userActionProcessorRepository3 = userActionProcessorRepository6;
                map5 = map9;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource9;
                str5 = str14;
                str4 = str17;
                str7 = str15;
                str8 = str16;
                String id5 = ((User) clientId).getId();
                c12171.L$0 = userActionProcessorRepository3;
                c12171.L$1 = map4;
                c12171.L$2 = null;
                c12171.L$3 = null;
                c12171.L$4 = null;
                c12171.L$5 = null;
                c12171.L$6 = null;
                c12171.L$7 = null;
                c12171.label = 5;
                clientId = userActionProcessorRemoteDataSource3.updateConversation(str4, str8, str7, str5, map5, id5, c12171);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                map6 = map4;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c12171.L$0 = null;
                c12171.L$1 = null;
                c12171.label = 6;
                if (userActionProcessorRepository4.saveConversationWithMetadata((Conversation) clientId, map6, c12171) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 5:
                map6 = (Map) c12171.L$1;
                userActionProcessorRepository4 = (UserActionProcessorRepository) c12171.L$0;
                ResultKt.throwOnFailure(clientId);
                c12171.L$0 = null;
                c12171.L$1 = null;
                c12171.label = 6;
                if (userActionProcessorRepository4.saveConversationWithMetadata((Conversation) clientId, map6, c12171) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            case 6:
                ResultKt.throwOnFailure(clientId);
                return Unit.INSTANCE;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object saveConversationWithMetadata(Conversation conversation, Map<String, ? extends Object> map, Continuation<? super Unit> continuation) throws Throwable {
        C12071 c12071;
        UserActionProcessorRepository userActionProcessorRepository;
        if (continuation instanceof C12071) {
            c12071 = (C12071) continuation;
            if ((c12071.label & Integer.MIN_VALUE) != 0) {
                c12071.label -= Integer.MIN_VALUE;
            } else {
                c12071 = new C12071(continuation);
            }
        } else {
            c12071 = new C12071(continuation);
        }
        Object obj = c12071.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12071.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
            c12071.L$0 = this;
            c12071.L$1 = conversation;
            c12071.label = 1;
            if (userActionProcessorInMemoryDataSource.updateConversationMetadata(conversation, map, c12071) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
        } else {
            if (i == 1) {
                conversation = (Conversation) c12071.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12071.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c12071.L$0 = null;
        c12071.L$1 = null;
        c12071.label = 2;
        if (userActionProcessorLocalDataSource.saveConversation(conversation, c12071) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object getConversations(int i, boolean z, Continuation<? super ConversationsPagination> continuation) {
        C11921 c11921;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRepository userActionProcessorRepository2;
        String authorization;
        Object user;
        UserActionProcessorRepository userActionProcessorRepository3;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        List<Conversation> conversations;
        Object obj;
        if (continuation instanceof C11921) {
            c11921 = (C11921) continuation;
            if ((c11921.label & Integer.MIN_VALUE) != 0) {
                c11921.label -= Integer.MIN_VALUE;
            } else {
                c11921 = new C11921(continuation);
            }
        } else {
            c11921 = new C11921(continuation);
        }
        Object user2 = c11921.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c11921.label) {
            case 0:
                ResultKt.throwOnFailure(user2);
                if (z) {
                    UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = this.userActionProcessorInMemoryDataSource;
                    c11921.L$0 = this;
                    c11921.label = 1;
                    user2 = userActionProcessorInMemoryDataSource2.getConversations(c11921);
                    if (user2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    userActionProcessorRepository2 = this;
                    if (((List) user2).isEmpty()) {
                        c11921.L$0 = null;
                        c11921.label = 2;
                        user2 = userActionProcessorRepository2.getConversations(0, false, c11921);
                        if (user2 == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return user2;
                    }
                    UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource3 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                    c11921.L$0 = null;
                    c11921.label = 3;
                    user2 = userActionProcessorInMemoryDataSource3.getConversations(c11921);
                    if (user2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return new ConversationsPagination((List) user2, false);
                }
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2 = this.userActionProcessorRemoteDataSource;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource4 = this.userActionProcessorInMemoryDataSource;
                c11921.L$0 = this;
                c11921.L$1 = userActionProcessorRemoteDataSource2;
                c11921.I$0 = i;
                c11921.label = 4;
                user2 = userActionProcessorInMemoryDataSource4.getUser(c11921);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource2;
                userActionProcessorRepository = this;
                authorization = UserExtensionsKt.getAuthorization((User) user2);
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource5 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                c11921.L$0 = userActionProcessorRepository;
                c11921.L$1 = userActionProcessorRemoteDataSource;
                c11921.L$2 = authorization;
                c11921.I$0 = i;
                c11921.label = 5;
                user = userActionProcessorInMemoryDataSource5.getUser(c11921);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                String id = ((User) user).getId();
                c11921.L$0 = userActionProcessorRepository;
                c11921.L$1 = null;
                c11921.L$2 = null;
                c11921.label = 6;
                user2 = userActionProcessorRemoteDataSource.getConversations(authorization, id, i, c11921);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository;
                userActionProcessorInMemoryDataSource = userActionProcessorRepository3.userActionProcessorInMemoryDataSource;
                conversations = ((ConversationsPagination) user2).getConversations();
                c11921.L$0 = user2;
                c11921.label = 7;
                if (userActionProcessorInMemoryDataSource.saveConversations(conversations, c11921) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                return (ConversationsPagination) obj;
            case 1:
                userActionProcessorRepository2 = (UserActionProcessorRepository) c11921.L$0;
                ResultKt.throwOnFailure(user2);
                if (((List) user2).isEmpty()) {
                    c11921.L$0 = null;
                    c11921.label = 2;
                    user2 = userActionProcessorRepository2.getConversations(0, false, c11921);
                    if (user2 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return user2;
                }
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource6 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                c11921.L$0 = null;
                c11921.label = 3;
                user2 = userActionProcessorInMemoryDataSource6.getConversations(c11921);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return new ConversationsPagination((List) user2, false);
            case 2:
                ResultKt.throwOnFailure(user2);
                return user2;
            case 3:
                ResultKt.throwOnFailure(user2);
                return new ConversationsPagination((List) user2, false);
            case 4:
                i = c11921.I$0;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3 = (UserActionProcessorRemoteDataSource) c11921.L$1;
                UserActionProcessorRepository userActionProcessorRepository4 = (UserActionProcessorRepository) c11921.L$0;
                ResultKt.throwOnFailure(user2);
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource3;
                userActionProcessorRepository = userActionProcessorRepository4;
                authorization = UserExtensionsKt.getAuthorization((User) user2);
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource7 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
                c11921.L$0 = userActionProcessorRepository;
                c11921.L$1 = userActionProcessorRemoteDataSource;
                c11921.L$2 = authorization;
                c11921.I$0 = i;
                c11921.label = 5;
                user = userActionProcessorInMemoryDataSource7.getUser(c11921);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                String id2 = ((User) user).getId();
                c11921.L$0 = userActionProcessorRepository;
                c11921.L$1 = null;
                c11921.L$2 = null;
                c11921.label = 6;
                user2 = userActionProcessorRemoteDataSource.getConversations(authorization, id2, i, c11921);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository;
                userActionProcessorInMemoryDataSource = userActionProcessorRepository3.userActionProcessorInMemoryDataSource;
                conversations = ((ConversationsPagination) user2).getConversations();
                c11921.L$0 = user2;
                c11921.label = 7;
                if (userActionProcessorInMemoryDataSource.saveConversations(conversations, c11921) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                return (ConversationsPagination) obj;
            case 5:
                i = c11921.I$0;
                String str = (String) c11921.L$2;
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c11921.L$1;
                UserActionProcessorRepository userActionProcessorRepository5 = (UserActionProcessorRepository) c11921.L$0;
                ResultKt.throwOnFailure(user2);
                authorization = str;
                userActionProcessorRepository = userActionProcessorRepository5;
                user = user2;
                String id3 = ((User) user).getId();
                c11921.L$0 = userActionProcessorRepository;
                c11921.L$1 = null;
                c11921.L$2 = null;
                c11921.label = 6;
                user2 = userActionProcessorRemoteDataSource.getConversations(authorization, id3, i, c11921);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository;
                userActionProcessorInMemoryDataSource = userActionProcessorRepository3.userActionProcessorInMemoryDataSource;
                conversations = ((ConversationsPagination) user2).getConversations();
                c11921.L$0 = user2;
                c11921.label = 7;
                if (userActionProcessorInMemoryDataSource.saveConversations(conversations, c11921) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                return (ConversationsPagination) obj;
            case 6:
                userActionProcessorRepository3 = (UserActionProcessorRepository) c11921.L$0;
                ResultKt.throwOnFailure(user2);
                userActionProcessorInMemoryDataSource = userActionProcessorRepository3.userActionProcessorInMemoryDataSource;
                conversations = ((ConversationsPagination) user2).getConversations();
                c11921.L$0 = user2;
                c11921.label = 7;
                if (userActionProcessorInMemoryDataSource.saveConversations(conversations, c11921) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                return (ConversationsPagination) obj;
            case 7:
                obj = c11921.L$0;
                ResultKt.throwOnFailure(user2);
                return (ConversationsPagination) obj;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object refreshUser(Continuation<? super User> continuation) {
        C12051 c12051;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String str;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        UserActionProcessorRepository userActionProcessorRepository2;
        User user;
        if (continuation instanceof C12051) {
            c12051 = (C12051) continuation;
            if ((c12051.label & Integer.MIN_VALUE) != 0) {
                c12051.label -= Integer.MIN_VALUE;
            } else {
                c12051 = new C12051(continuation);
            }
        } else {
            c12051 = new C12051(continuation);
        }
        Object appUser = c12051.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12051.label;
        if (i != 0) {
            if (i == 1) {
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12051.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12051.L$0;
                ResultKt.throwOnFailure(appUser);
            } else if (i == 2) {
                str = (String) c12051.L$2;
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c12051.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12051.L$0;
                ResultKt.throwOnFailure(appUser);
                AuthenticationType authenticationType = ((User) appUser).getAuthenticationType();
                c12051.L$0 = userActionProcessorRepository;
                c12051.L$1 = null;
                c12051.L$2 = null;
                c12051.label = 3;
                appUser = userActionProcessorRemoteDataSource2.getAppUser(str, authenticationType, c12051);
                if (appUser == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
            } else {
                if (i != 3) {
                    if (i != 4) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    User user2 = (User) c12051.L$0;
                    ResultKt.throwOnFailure(appUser);
                    return user2;
                }
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12051.L$0;
                ResultKt.throwOnFailure(appUser);
            }
            user = (User) appUser;
            c12051.L$0 = user;
            c12051.label = 4;
            if (userActionProcessorRepository2.saveUser(user, c12051) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return user;
        }
        ResultKt.throwOnFailure(appUser);
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3 = this.userActionProcessorRemoteDataSource;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
        c12051.L$0 = this;
        c12051.L$1 = userActionProcessorRemoteDataSource3;
        c12051.label = 1;
        Object user3 = userActionProcessorInMemoryDataSource.getUser(c12051);
        if (user3 == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository = this;
        userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource3;
        appUser = user3;
        String authorization = UserExtensionsKt.getAuthorization((User) appUser);
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
        c12051.L$0 = userActionProcessorRepository;
        c12051.L$1 = userActionProcessorRemoteDataSource;
        c12051.L$2 = authorization;
        c12051.label = 2;
        Object user4 = userActionProcessorInMemoryDataSource2.getUser(c12051);
        if (user4 == coroutine_suspended) {
            return coroutine_suspended;
        }
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource;
        str = authorization;
        appUser = user4;
        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource4;
        AuthenticationType authenticationType2 = ((User) appUser).getAuthenticationType();
        c12051.L$0 = userActionProcessorRepository;
        c12051.L$1 = null;
        c12051.L$2 = null;
        c12051.label = 3;
        appUser = userActionProcessorRemoteDataSource2.getAppUser(str, authenticationType2, c12051);
        if (appUser == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository2 = userActionProcessorRepository;
        user = (User) appUser;
        c12051.L$0 = user;
        c12051.label = 4;
        if (userActionProcessorRepository2.saveUser(user, c12051) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return user;
    }

    public final Object saveUser(User user, Continuation<? super Unit> continuation) throws Throwable {
        C12081 c12081;
        UserActionProcessorRepository userActionProcessorRepository;
        if (continuation instanceof C12081) {
            c12081 = (C12081) continuation;
            if ((c12081.label & Integer.MIN_VALUE) != 0) {
                c12081.label -= Integer.MIN_VALUE;
            } else {
                c12081 = new C12081(continuation);
            }
        } else {
            c12081 = new C12081(continuation);
        }
        Object obj = c12081.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12081.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
            c12081.L$0 = this;
            c12081.L$1 = user;
            c12081.label = 1;
            if (userActionProcessorInMemoryDataSource.updateUser(user, c12081) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
        } else {
            if (i == 1) {
                user = (User) c12081.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12081.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        c12081.L$0 = null;
        c12081.L$1 = null;
        c12081.label = 2;
        if (userActionProcessorRepository.saveUserToLocalStorage(user, c12081) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object clearStorage(Continuation<? super Unit> continuation) {
        Object objClear = this.userActionProcessorLocalDataSource.clear(continuation);
        return objClear == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClear : Unit.INSTANCE;
    }

    public final Object shouldReAuthenticateUser(Continuation<? super Boolean> continuation) {
        return this.userActionProcessorInMemoryDataSource.shouldReAuthenticateUser(continuation);
    }

    public final Object updateReAuthenticateUser(boolean z, Continuation<? super Unit> continuation) {
        Object objUpdateReAuthenticateUser = this.userActionProcessorInMemoryDataSource.updateReAuthenticateUser(z, continuation);
        return objUpdateReAuthenticateUser == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdateReAuthenticateUser : Unit.INSTANCE;
    }

    public final Object login(String str, Continuation<? super User> continuation) {
        C11991 c11991;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        Object clientId;
        UserActionProcessorRepository userActionProcessorRepository2;
        String str2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        String str3;
        Object pushToken;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        String str4;
        String str5;
        String str6;
        Object user;
        UserActionProcessorRepository userActionProcessorRepository3;
        String str7;
        String str8;
        User user2;
        String id;
        Object user3;
        String str9;
        UserActionProcessorRepository userActionProcessorRepository4;
        String str10;
        String str11;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4;
        String str12;
        UserActionProcessorRepository userActionProcessorRepository5;
        User user4;
        User user5;
        if (continuation instanceof C11991) {
            c11991 = (C11991) continuation;
            if ((c11991.label & Integer.MIN_VALUE) != 0) {
                c11991.label -= Integer.MIN_VALUE;
            } else {
                c11991 = new C11991(continuation);
            }
        } else {
            c11991 = new C11991(continuation);
        }
        Object user6 = c11991.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c11991.label) {
            case 0:
                ResultKt.throwOnFailure(user6);
                c11991.L$0 = this;
                c11991.L$1 = str;
                c11991.label = 1;
                user6 = getUser(c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository = this;
                if (Intrinsics.areEqual(((User) user6).getJwt$zendesk_conversationkit_conversationkit_android(), str)) {
                    c11991.L$0 = userActionProcessorRepository;
                    c11991.L$1 = str;
                    c11991.label = 2;
                    user6 = userActionProcessorRepository.shouldReAuthenticateUser(c11991);
                    if (user6 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    if (!((Boolean) user6).booleanValue()) {
                        throw new UserAlreadyLoggedInException();
                    }
                }
                userActionProcessorRemoteDataSource = userActionProcessorRepository.userActionProcessorRemoteDataSource;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository;
                c11991.L$1 = str;
                c11991.L$2 = userActionProcessorRemoteDataSource;
                c11991.label = 3;
                clientId = userActionProcessorLocalDataSource.getClientId(c11991);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                str2 = str;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                user6 = clientId;
                str3 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str2;
                c11991.L$2 = userActionProcessorRemoteDataSource2;
                c11991.L$3 = str3;
                c11991.label = 4;
                pushToken = userActionProcessorLocalDataSource2.getPushToken(c11991);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str4 = str2;
                str5 = str3;
                user6 = pushToken;
                str6 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str4;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str6;
                c11991.label = 5;
                user = userActionProcessorLocalDataSource3.getUser(c11991);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = str4;
                str8 = str6;
                user6 = user;
                user2 = (User) user6;
                if (user2 != null) {
                    id = user2.getId();
                } else {
                    id = null;
                }
                c11991.L$0 = userActionProcessorRepository3;
                c11991.L$1 = str7;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str8;
                c11991.L$5 = id;
                c11991.label = 6;
                user3 = userActionProcessorRepository3.getUser(c11991);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository6 = userActionProcessorRepository3;
                str9 = str8;
                userActionProcessorRepository4 = userActionProcessorRepository6;
                str10 = id;
                user6 = user3;
                String str13 = str7;
                str11 = str5;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                str12 = str13;
                String sessionToken$zendesk_conversationkit_conversationkit_android = ((User) user6).getSessionToken$zendesk_conversationkit_conversationkit_android();
                c11991.L$0 = userActionProcessorRepository4;
                c11991.L$1 = null;
                c11991.L$2 = null;
                c11991.L$3 = null;
                c11991.L$4 = null;
                c11991.L$5 = null;
                c11991.label = 7;
                user6 = userActionProcessorRemoteDataSource4.login(str12, str11, str10, str9, sessionToken$zendesk_conversationkit_conversationkit_android, c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 1:
                str = (String) c11991.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                if (Intrinsics.areEqual(((User) user6).getJwt$zendesk_conversationkit_conversationkit_android(), str)) {
                    c11991.L$0 = userActionProcessorRepository;
                    c11991.L$1 = str;
                    c11991.label = 2;
                    user6 = userActionProcessorRepository.shouldReAuthenticateUser(c11991);
                    if (user6 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    if (!((Boolean) user6).booleanValue()) {
                        throw new UserAlreadyLoggedInException();
                    }
                }
                userActionProcessorRemoteDataSource = userActionProcessorRepository.userActionProcessorRemoteDataSource;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource4 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository;
                c11991.L$1 = str;
                c11991.L$2 = userActionProcessorRemoteDataSource;
                c11991.label = 3;
                clientId = userActionProcessorLocalDataSource4.getClientId(c11991);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                str2 = str;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                user6 = clientId;
                str3 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource5 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str2;
                c11991.L$2 = userActionProcessorRemoteDataSource2;
                c11991.L$3 = str3;
                c11991.label = 4;
                pushToken = userActionProcessorLocalDataSource5.getPushToken(c11991);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str4 = str2;
                str5 = str3;
                user6 = pushToken;
                str6 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource6 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str4;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str6;
                c11991.label = 5;
                user = userActionProcessorLocalDataSource6.getUser(c11991);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = str4;
                str8 = str6;
                user6 = user;
                user2 = (User) user6;
                if (user2 != null) {
                    id = user2.getId();
                } else {
                    id = null;
                }
                c11991.L$0 = userActionProcessorRepository3;
                c11991.L$1 = str7;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str8;
                c11991.L$5 = id;
                c11991.label = 6;
                user3 = userActionProcessorRepository3.getUser(c11991);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository7 = userActionProcessorRepository3;
                str9 = str8;
                userActionProcessorRepository4 = userActionProcessorRepository7;
                str10 = id;
                user6 = user3;
                String str14 = str7;
                str11 = str5;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                str12 = str14;
                String sessionToken$zendesk_conversationkit_conversationkit_android2 = ((User) user6).getSessionToken$zendesk_conversationkit_conversationkit_android();
                c11991.L$0 = userActionProcessorRepository4;
                c11991.L$1 = null;
                c11991.L$2 = null;
                c11991.L$3 = null;
                c11991.L$4 = null;
                c11991.L$5 = null;
                c11991.label = 7;
                user6 = userActionProcessorRemoteDataSource4.login(str12, str11, str10, str9, sessionToken$zendesk_conversationkit_conversationkit_android2, c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 2:
                str = (String) c11991.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                if (!((Boolean) user6).booleanValue()) {
                    throw new UserAlreadyLoggedInException();
                }
                userActionProcessorRemoteDataSource = userActionProcessorRepository.userActionProcessorRemoteDataSource;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource7 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository;
                c11991.L$1 = str;
                c11991.L$2 = userActionProcessorRemoteDataSource;
                c11991.label = 3;
                clientId = userActionProcessorLocalDataSource7.getClientId(c11991);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                str2 = str;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                user6 = clientId;
                str3 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource8 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str2;
                c11991.L$2 = userActionProcessorRemoteDataSource2;
                c11991.L$3 = str3;
                c11991.label = 4;
                pushToken = userActionProcessorLocalDataSource8.getPushToken(c11991);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str4 = str2;
                str5 = str3;
                user6 = pushToken;
                str6 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource9 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str4;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str6;
                c11991.label = 5;
                user = userActionProcessorLocalDataSource9.getUser(c11991);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = str4;
                str8 = str6;
                user6 = user;
                user2 = (User) user6;
                if (user2 != null) {
                    id = user2.getId();
                } else {
                    id = null;
                }
                c11991.L$0 = userActionProcessorRepository3;
                c11991.L$1 = str7;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str8;
                c11991.L$5 = id;
                c11991.label = 6;
                user3 = userActionProcessorRepository3.getUser(c11991);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository8 = userActionProcessorRepository3;
                str9 = str8;
                userActionProcessorRepository4 = userActionProcessorRepository8;
                str10 = id;
                user6 = user3;
                String str15 = str7;
                str11 = str5;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                str12 = str15;
                String sessionToken$zendesk_conversationkit_conversationkit_android3 = ((User) user6).getSessionToken$zendesk_conversationkit_conversationkit_android();
                c11991.L$0 = userActionProcessorRepository4;
                c11991.L$1 = null;
                c11991.L$2 = null;
                c11991.L$3 = null;
                c11991.L$4 = null;
                c11991.L$5 = null;
                c11991.label = 7;
                user6 = userActionProcessorRemoteDataSource4.login(str12, str11, str10, str9, sessionToken$zendesk_conversationkit_conversationkit_android3, c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 3:
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c11991.L$2;
                str2 = (String) c11991.L$1;
                UserActionProcessorRepository userActionProcessorRepository9 = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                userActionProcessorRepository2 = userActionProcessorRepository9;
                str3 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource10 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str2;
                c11991.L$2 = userActionProcessorRemoteDataSource2;
                c11991.L$3 = str3;
                c11991.label = 4;
                pushToken = userActionProcessorLocalDataSource10.getPushToken(c11991);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str4 = str2;
                str5 = str3;
                user6 = pushToken;
                str6 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource11 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str4;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str6;
                c11991.label = 5;
                user = userActionProcessorLocalDataSource11.getUser(c11991);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = str4;
                str8 = str6;
                user6 = user;
                user2 = (User) user6;
                if (user2 != null) {
                    id = user2.getId();
                } else {
                    id = null;
                }
                c11991.L$0 = userActionProcessorRepository3;
                c11991.L$1 = str7;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str8;
                c11991.L$5 = id;
                c11991.label = 6;
                user3 = userActionProcessorRepository3.getUser(c11991);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository10 = userActionProcessorRepository3;
                str9 = str8;
                userActionProcessorRepository4 = userActionProcessorRepository10;
                str10 = id;
                user6 = user3;
                String str16 = str7;
                str11 = str5;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                str12 = str16;
                String sessionToken$zendesk_conversationkit_conversationkit_android4 = ((User) user6).getSessionToken$zendesk_conversationkit_conversationkit_android();
                c11991.L$0 = userActionProcessorRepository4;
                c11991.L$1 = null;
                c11991.L$2 = null;
                c11991.L$3 = null;
                c11991.L$4 = null;
                c11991.L$5 = null;
                c11991.label = 7;
                user6 = userActionProcessorRemoteDataSource4.login(str12, str11, str10, str9, sessionToken$zendesk_conversationkit_conversationkit_android4, c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 4:
                String str17 = (String) c11991.L$3;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5 = (UserActionProcessorRemoteDataSource) c11991.L$2;
                String str18 = (String) c11991.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                str5 = str17;
                str4 = str18;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource5;
                str6 = (String) user6;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource12 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c11991.L$0 = userActionProcessorRepository2;
                c11991.L$1 = str4;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str6;
                c11991.label = 5;
                user = userActionProcessorLocalDataSource12.getUser(c11991);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                str7 = str4;
                str8 = str6;
                user6 = user;
                user2 = (User) user6;
                if (user2 != null) {
                    id = user2.getId();
                } else {
                    id = null;
                }
                c11991.L$0 = userActionProcessorRepository3;
                c11991.L$1 = str7;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str8;
                c11991.L$5 = id;
                c11991.label = 6;
                user3 = userActionProcessorRepository3.getUser(c11991);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository11 = userActionProcessorRepository3;
                str9 = str8;
                userActionProcessorRepository4 = userActionProcessorRepository11;
                str10 = id;
                user6 = user3;
                String str19 = str7;
                str11 = str5;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                str12 = str19;
                String sessionToken$zendesk_conversationkit_conversationkit_android5 = ((User) user6).getSessionToken$zendesk_conversationkit_conversationkit_android();
                c11991.L$0 = userActionProcessorRepository4;
                c11991.L$1 = null;
                c11991.L$2 = null;
                c11991.L$3 = null;
                c11991.L$4 = null;
                c11991.L$5 = null;
                c11991.label = 7;
                user6 = userActionProcessorRemoteDataSource4.login(str12, str11, str10, str9, sessionToken$zendesk_conversationkit_conversationkit_android5, c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 5:
                str8 = (String) c11991.L$4;
                str5 = (String) c11991.L$3;
                userActionProcessorRemoteDataSource3 = (UserActionProcessorRemoteDataSource) c11991.L$2;
                str7 = (String) c11991.L$1;
                UserActionProcessorRepository userActionProcessorRepository12 = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                userActionProcessorRepository3 = userActionProcessorRepository12;
                user2 = (User) user6;
                if (user2 != null) {
                    id = user2.getId();
                } else {
                    id = null;
                }
                c11991.L$0 = userActionProcessorRepository3;
                c11991.L$1 = str7;
                c11991.L$2 = userActionProcessorRemoteDataSource3;
                c11991.L$3 = str5;
                c11991.L$4 = str8;
                c11991.L$5 = id;
                c11991.label = 6;
                user3 = userActionProcessorRepository3.getUser(c11991);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRepository userActionProcessorRepository13 = userActionProcessorRepository3;
                str9 = str8;
                userActionProcessorRepository4 = userActionProcessorRepository13;
                str10 = id;
                user6 = user3;
                String str110 = str7;
                str11 = str5;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                str12 = str110;
                String sessionToken$zendesk_conversationkit_conversationkit_android6 = ((User) user6).getSessionToken$zendesk_conversationkit_conversationkit_android();
                c11991.L$0 = userActionProcessorRepository4;
                c11991.L$1 = null;
                c11991.L$2 = null;
                c11991.L$3 = null;
                c11991.L$4 = null;
                c11991.L$5 = null;
                c11991.label = 7;
                user6 = userActionProcessorRemoteDataSource4.login(str12, str11, str10, str9, sessionToken$zendesk_conversationkit_conversationkit_android6, c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 6:
                String str20 = (String) c11991.L$5;
                String str21 = (String) c11991.L$4;
                String str22 = (String) c11991.L$3;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6 = (UserActionProcessorRemoteDataSource) c11991.L$2;
                String str23 = (String) c11991.L$1;
                UserActionProcessorRepository userActionProcessorRepository14 = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                str10 = str20;
                userActionProcessorRepository4 = userActionProcessorRepository14;
                str9 = str21;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource6;
                str11 = str22;
                str12 = str23;
                String sessionToken$zendesk_conversationkit_conversationkit_android7 = ((User) user6).getSessionToken$zendesk_conversationkit_conversationkit_android();
                c11991.L$0 = userActionProcessorRepository4;
                c11991.L$1 = null;
                c11991.L$2 = null;
                c11991.L$3 = null;
                c11991.L$4 = null;
                c11991.L$5 = null;
                c11991.label = 7;
                user6 = userActionProcessorRemoteDataSource4.login(str12, str11, str10, str9, sessionToken$zendesk_conversationkit_conversationkit_android7, c11991);
                if (user6 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 7:
                userActionProcessorRepository4 = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                userActionProcessorRepository5 = userActionProcessorRepository4;
                user4 = (User) user6;
                c11991.L$0 = userActionProcessorRepository5;
                c11991.L$1 = user4;
                c11991.label = 8;
                if (userActionProcessorRepository5.saveUser(user4, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                user5 = user4;
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 8:
                user5 = (User) c11991.L$1;
                userActionProcessorRepository5 = (UserActionProcessorRepository) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                c11991.L$0 = user5;
                c11991.L$1 = null;
                c11991.label = 9;
                if (userActionProcessorRepository5.updateReAuthenticateUser(false, c11991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user5;
            case 9:
                User user7 = (User) c11991.L$0;
                ResultKt.throwOnFailure(user6);
                return user7;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object logout(Continuation<? super Unit> continuation) throws Throwable {
        C12001 c12001;
        UserActionProcessorRepository userActionProcessorRepository;
        String str;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        UserActionProcessorRepository userActionProcessorRepository2;
        String id;
        Object clientId;
        String str2;
        String str3;
        String str4;
        Object pushToken;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        String str5;
        String str6;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        if (continuation instanceof C12001) {
            c12001 = (C12001) continuation;
            if ((c12001.label & Integer.MIN_VALUE) != 0) {
                c12001.label -= Integer.MIN_VALUE;
            } else {
                c12001 = new C12001(continuation);
            }
        } else {
            c12001 = new C12001(continuation);
        }
        C12001 c12002 = c12001;
        Object user = c12002.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12002.label;
        if (i == 0) {
            ResultKt.throwOnFailure(user);
            c12002.L$0 = this;
            c12002.label = 1;
            user = getUser(c12002);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
        } else {
            if (i == 1) {
                userActionProcessorRepository = (UserActionProcessorRepository) c12002.L$0;
                ResultKt.throwOnFailure(user);
            } else if (i == 2) {
                str = (String) c12002.L$2;
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12002.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12002.L$0;
                ResultKt.throwOnFailure(user);
                id = ((User) user).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c12002.L$0 = userActionProcessorRepository2;
                c12002.L$1 = userActionProcessorRemoteDataSource;
                c12002.L$2 = str;
                c12002.L$3 = id;
                c12002.label = 3;
                clientId = userActionProcessorLocalDataSource.getClientId(c12002);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                String str7 = str;
                str2 = id;
                user = clientId;
                str3 = str7;
                str4 = (String) user;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c12002.L$0 = userActionProcessorRemoteDataSource;
                c12002.L$1 = str3;
                c12002.L$2 = str2;
                c12002.L$3 = str4;
                c12002.label = 4;
                pushToken = userActionProcessorLocalDataSource2.getPushToken(c12002);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                str5 = str4;
                user = pushToken;
                str6 = str2;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                c12002.L$0 = null;
                c12002.L$1 = null;
                c12002.L$2 = null;
                c12002.L$3 = null;
                c12002.label = 5;
                if (userActionProcessorRemoteDataSource3.logout(str3, str6, str5, (String) user, c12002) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 3) {
                str2 = (String) c12002.L$3;
                str3 = (String) c12002.L$2;
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12002.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12002.L$0;
                ResultKt.throwOnFailure(user);
                str4 = (String) user;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
                c12002.L$0 = userActionProcessorRemoteDataSource;
                c12002.L$1 = str3;
                c12002.L$2 = str2;
                c12002.L$3 = str4;
                c12002.label = 4;
                pushToken = userActionProcessorLocalDataSource3.getPushToken(c12002);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                str5 = str4;
                user = pushToken;
                str6 = str2;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                c12002.L$0 = null;
                c12002.L$1 = null;
                c12002.L$2 = null;
                c12002.L$3 = null;
                c12002.label = 5;
                if (userActionProcessorRemoteDataSource3.logout(str3, str6, str5, (String) user, c12002) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 4) {
                String str8 = (String) c12002.L$3;
                str6 = (String) c12002.L$2;
                str3 = (String) c12002.L$1;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4 = (UserActionProcessorRemoteDataSource) c12002.L$0;
                ResultKt.throwOnFailure(user);
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource4;
                str5 = str8;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                c12002.L$0 = null;
                c12002.L$1 = null;
                c12002.L$2 = null;
                c12002.L$3 = null;
                c12002.label = 5;
                if (userActionProcessorRemoteDataSource3.logout(str3, str6, str5, (String) user, c12002) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 5) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(user);
            }
            return Unit.INSTANCE;
        }
        AuthenticationType authenticationType = ((User) user).getAuthenticationType();
        if (!(authenticationType instanceof AuthenticationType.Jwt)) {
            return Unit.INSTANCE;
        }
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5 = userActionProcessorRepository.userActionProcessorRemoteDataSource;
        String value = ((AuthenticationType.Jwt) authenticationType).getValue();
        c12002.L$0 = userActionProcessorRepository;
        c12002.L$1 = userActionProcessorRemoteDataSource5;
        c12002.L$2 = value;
        c12002.label = 2;
        Object user2 = userActionProcessorRepository.getUser(c12002);
        if (user2 == coroutine_suspended) {
            return coroutine_suspended;
        }
        UserActionProcessorRepository userActionProcessorRepository3 = userActionProcessorRepository;
        str = value;
        user = user2;
        userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource5;
        userActionProcessorRepository2 = userActionProcessorRepository3;
        id = ((User) user).getId();
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource4 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
        c12002.L$0 = userActionProcessorRepository2;
        c12002.L$1 = userActionProcessorRemoteDataSource;
        c12002.L$2 = str;
        c12002.L$3 = id;
        c12002.label = 3;
        clientId = userActionProcessorLocalDataSource4.getClientId(c12002);
        if (clientId == coroutine_suspended) {
            return coroutine_suspended;
        }
        String str9 = str;
        str2 = id;
        user = clientId;
        str3 = str9;
        str4 = (String) user;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource5 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
        c12002.L$0 = userActionProcessorRemoteDataSource;
        c12002.L$1 = str3;
        c12002.L$2 = str2;
        c12002.L$3 = str4;
        c12002.label = 4;
        pushToken = userActionProcessorLocalDataSource5.getPushToken(c12002);
        if (pushToken == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
        str5 = str4;
        user = pushToken;
        str6 = str2;
        userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
        c12002.L$0 = null;
        c12002.L$1 = null;
        c12002.L$2 = null;
        c12002.L$3 = null;
        c12002.label = 5;
        if (userActionProcessorRemoteDataSource3.logout(str3, str6, str5, (String) user, c12002) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object updateAppUserLocale(String str, Continuation<? super Unit> continuation) throws Throwable {
        C12141 c12141;
        String str2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        if (continuation instanceof C12141) {
            c12141 = (C12141) continuation;
            if ((c12141.label & Integer.MIN_VALUE) != 0) {
                c12141.label -= Integer.MIN_VALUE;
            } else {
                c12141 = new C12141(continuation);
            }
        } else {
            c12141 = new C12141(continuation);
        }
        Object obj = c12141.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12141.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2 = this.userActionProcessorRemoteDataSource;
            c12141.L$0 = str;
            c12141.L$1 = userActionProcessorRemoteDataSource2;
            c12141.label = 1;
            Object user = getUser(c12141);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            str2 = str;
            userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource2;
            obj = user;
        } else {
            if (i == 1) {
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12141.L$1;
                str2 = (String) c12141.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        String authorization = UserExtensionsKt.getAuthorization((User) obj);
        c12141.L$0 = null;
        c12141.L$1 = null;
        c12141.label = 2;
        if (userActionProcessorRemoteDataSource.updateAppUserLocale(authorization, str2, c12141) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object updateConversation(String str, Message message, Continuation<? super Conversation> continuation) {
        C12151 c12151;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRepository userActionProcessorRepository2;
        Conversation conversation;
        Object user;
        Object obj;
        Conversation conversation2;
        UserActionProcessorRepository userActionProcessorRepository3;
        Conversation conversation3;
        if (continuation instanceof C12151) {
            c12151 = (C12151) continuation;
            if ((c12151.label & Integer.MIN_VALUE) != 0) {
                c12151.label -= Integer.MIN_VALUE;
            } else {
                c12151 = new C12151(continuation);
            }
        } else {
            c12151 = new C12151(continuation);
        }
        Object persistedConversation = c12151.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12151.label;
        if (i == 0) {
            ResultKt.throwOnFailure(persistedConversation);
            c12151.L$0 = this;
            c12151.L$1 = str;
            c12151.L$2 = message;
            c12151.label = 1;
            persistedConversation = getPersistedConversation(str, c12151);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
        } else {
            if (i == 1) {
                message = (Message) c12151.L$2;
                str = (String) c12151.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12151.L$0;
                ResultKt.throwOnFailure(persistedConversation);
            } else if (i == 2) {
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12151.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                conversation = (Conversation) persistedConversation;
                c12151.L$0 = userActionProcessorRepository2;
                c12151.L$1 = conversation;
                c12151.L$2 = userActionProcessorRepository2;
                c12151.label = 3;
                user = userActionProcessorRepository2.getUser(c12151);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user;
                conversation2 = conversation;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                c12151.L$0 = userActionProcessorRepository3;
                c12151.L$1 = conversation2;
                c12151.L$2 = null;
                c12151.label = 4;
                if (userActionProcessorRepository2.saveUserToLocalStorage((User) obj, c12151) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation3 = conversation2;
            } else if (i == 3) {
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12151.L$2;
                Conversation conversation4 = (Conversation) c12151.L$1;
                UserActionProcessorRepository userActionProcessorRepository4 = (UserActionProcessorRepository) c12151.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                conversation2 = conversation4;
                userActionProcessorRepository3 = userActionProcessorRepository4;
                obj = persistedConversation;
                c12151.L$0 = userActionProcessorRepository3;
                c12151.L$1 = conversation2;
                c12151.L$2 = null;
                c12151.label = 4;
                if (userActionProcessorRepository2.saveUserToLocalStorage((User) obj, c12151) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation3 = conversation2;
            } else {
                if (i != 4) {
                    if (i != 5) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    Conversation conversation5 = (Conversation) c12151.L$0;
                    ResultKt.throwOnFailure(persistedConversation);
                    return conversation5;
                }
                conversation3 = (Conversation) c12151.L$1;
                userActionProcessorRepository3 = (UserActionProcessorRepository) c12151.L$0;
                ResultKt.throwOnFailure(persistedConversation);
            }
            c12151.L$0 = conversation3;
            c12151.L$1 = null;
            c12151.label = 5;
            if (userActionProcessorRepository3.saveConversationToLocalStorage(conversation3, c12151) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return conversation3;
        }
        if (((Conversation) persistedConversation) == null) {
            throw new ConversationNotFoundException();
        }
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
        c12151.L$0 = userActionProcessorRepository;
        c12151.L$1 = null;
        c12151.L$2 = null;
        c12151.label = 2;
        persistedConversation = userActionProcessorInMemoryDataSource.addMessageToConversationAndCommit(str, message, c12151);
        if (persistedConversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository2 = userActionProcessorRepository;
        conversation = (Conversation) persistedConversation;
        c12151.L$0 = userActionProcessorRepository2;
        c12151.L$1 = conversation;
        c12151.L$2 = userActionProcessorRepository2;
        c12151.label = 3;
        user = userActionProcessorRepository2.getUser(c12151);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        obj = user;
        conversation2 = conversation;
        userActionProcessorRepository3 = userActionProcessorRepository2;
        c12151.L$0 = userActionProcessorRepository3;
        c12151.L$1 = conversation2;
        c12151.L$2 = null;
        c12151.label = 4;
        if (userActionProcessorRepository2.saveUserToLocalStorage((User) obj, c12151) == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversation3 = conversation2;
        c12151.L$0 = conversation3;
        c12151.L$1 = null;
        c12151.label = 5;
        if (userActionProcessorRepository3.saveConversationToLocalStorage(conversation3, c12151) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return conversation3;
    }

    public final Object loadMoreMessages(String str, double d, Continuation<? super MessageList> continuation) {
        C11981 c11981;
        UserActionProcessorRepository userActionProcessorRepository;
        Conversation conversation;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        Object user;
        double d2;
        UserActionProcessorRepository userActionProcessorRepository2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        MessageList messageList;
        Boolean hasPrevious;
        boolean zBooleanValue;
        Object objUpdateConversationMessages;
        MessageList messageList2;
        UserActionProcessorRepository userActionProcessorRepository3;
        Conversation conversation2;
        Object user2;
        Object obj;
        Conversation conversation3;
        MessageList messageList3;
        UserActionProcessorRepository userActionProcessorRepository4;
        Conversation conversation4;
        MessageList messageList4;
        if (continuation instanceof C11981) {
            c11981 = (C11981) continuation;
            if ((c11981.label & Integer.MIN_VALUE) != 0) {
                c11981.label -= Integer.MIN_VALUE;
            } else {
                c11981 = new C11981(continuation);
            }
        } else {
            c11981 = new C11981(continuation);
        }
        Object persistedConversation = c11981.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c11981.label) {
            case 0:
                ResultKt.throwOnFailure(persistedConversation);
                c11981.L$0 = this;
                c11981.L$1 = str;
                c11981.D$0 = d;
                c11981.label = 1;
                persistedConversation = getPersistedConversation(str, c11981);
                if (persistedConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository = this;
                conversation = (Conversation) persistedConversation;
                if (conversation != null) {
                    throw new ConversationNotFoundException();
                }
                if (conversation.getHasPrevious()) {
                    throw new ConversationHasNoPreviousMessagesException();
                }
                userActionProcessorRemoteDataSource = userActionProcessorRepository.userActionProcessorRemoteDataSource;
                c11981.L$0 = userActionProcessorRepository;
                c11981.L$1 = str;
                c11981.L$2 = userActionProcessorRemoteDataSource;
                c11981.D$0 = d;
                c11981.label = 2;
                user = userActionProcessorRepository.getUser(c11981);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                d2 = d;
                userActionProcessorRepository2 = userActionProcessorRepository;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                persistedConversation = user;
                String authorization = UserExtensionsKt.getAuthorization((User) persistedConversation);
                c11981.L$0 = userActionProcessorRepository2;
                c11981.L$1 = str;
                c11981.L$2 = null;
                c11981.label = 3;
                persistedConversation = userActionProcessorRemoteDataSource2.getMessages(authorization, str, d2, c11981);
                if (persistedConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageList = (MessageList) persistedConversation;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                List<Message> messages = messageList.getMessages();
                hasPrevious = messageList.getHasPrevious();
                if (hasPrevious != null) {
                    zBooleanValue = hasPrevious.booleanValue();
                } else {
                    zBooleanValue = false;
                }
                c11981.L$0 = userActionProcessorRepository2;
                c11981.L$1 = messageList;
                c11981.label = 4;
                objUpdateConversationMessages = userActionProcessorInMemoryDataSource.updateConversationMessages(str, messages, zBooleanValue, c11981);
                if (objUpdateConversationMessages == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageList2 = messageList;
                persistedConversation = objUpdateConversationMessages;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                conversation2 = (Conversation) persistedConversation;
                c11981.L$0 = userActionProcessorRepository3;
                c11981.L$1 = messageList2;
                c11981.L$2 = conversation2;
                c11981.L$3 = userActionProcessorRepository3;
                c11981.label = 5;
                user2 = userActionProcessorRepository3.getUser(c11981);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                conversation3 = conversation2;
                messageList3 = messageList2;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11981.L$0 = userActionProcessorRepository4;
                c11981.L$1 = messageList3;
                c11981.L$2 = conversation3;
                c11981.L$3 = null;
                c11981.label = 6;
                if (userActionProcessorRepository3.saveUserToLocalStorage((User) obj, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
                messageList4 = messageList3;
                c11981.L$0 = messageList4;
                c11981.L$1 = null;
                c11981.L$2 = null;
                c11981.label = 7;
                if (userActionProcessorRepository4.saveConversationToLocalStorage(conversation4, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return messageList4;
            case 1:
                d = c11981.D$0;
                str = (String) c11981.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11981.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                conversation = (Conversation) persistedConversation;
                if (conversation != null) {
                    throw new ConversationNotFoundException();
                }
                if (conversation.getHasPrevious()) {
                    throw new ConversationHasNoPreviousMessagesException();
                }
                userActionProcessorRemoteDataSource = userActionProcessorRepository.userActionProcessorRemoteDataSource;
                c11981.L$0 = userActionProcessorRepository;
                c11981.L$1 = str;
                c11981.L$2 = userActionProcessorRemoteDataSource;
                c11981.D$0 = d;
                c11981.label = 2;
                user = userActionProcessorRepository.getUser(c11981);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                d2 = d;
                userActionProcessorRepository2 = userActionProcessorRepository;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                persistedConversation = user;
                String authorization2 = UserExtensionsKt.getAuthorization((User) persistedConversation);
                c11981.L$0 = userActionProcessorRepository2;
                c11981.L$1 = str;
                c11981.L$2 = null;
                c11981.label = 3;
                persistedConversation = userActionProcessorRemoteDataSource2.getMessages(authorization2, str, d2, c11981);
                if (persistedConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageList = (MessageList) persistedConversation;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                List<Message> messages2 = messageList.getMessages();
                hasPrevious = messageList.getHasPrevious();
                if (hasPrevious != null) {
                    zBooleanValue = hasPrevious.booleanValue();
                } else {
                    zBooleanValue = false;
                }
                c11981.L$0 = userActionProcessorRepository2;
                c11981.L$1 = messageList;
                c11981.label = 4;
                objUpdateConversationMessages = userActionProcessorInMemoryDataSource2.updateConversationMessages(str, messages2, zBooleanValue, c11981);
                if (objUpdateConversationMessages == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageList2 = messageList;
                persistedConversation = objUpdateConversationMessages;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                conversation2 = (Conversation) persistedConversation;
                c11981.L$0 = userActionProcessorRepository3;
                c11981.L$1 = messageList2;
                c11981.L$2 = conversation2;
                c11981.L$3 = userActionProcessorRepository3;
                c11981.label = 5;
                user2 = userActionProcessorRepository3.getUser(c11981);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                conversation3 = conversation2;
                messageList3 = messageList2;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11981.L$0 = userActionProcessorRepository4;
                c11981.L$1 = messageList3;
                c11981.L$2 = conversation3;
                c11981.L$3 = null;
                c11981.label = 6;
                if (userActionProcessorRepository3.saveUserToLocalStorage((User) obj, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
                messageList4 = messageList3;
                c11981.L$0 = messageList4;
                c11981.L$1 = null;
                c11981.L$2 = null;
                c11981.label = 7;
                if (userActionProcessorRepository4.saveConversationToLocalStorage(conversation4, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return messageList4;
            case 2:
                double d3 = c11981.D$0;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3 = (UserActionProcessorRemoteDataSource) c11981.L$2;
                String str2 = (String) c11981.L$1;
                UserActionProcessorRepository userActionProcessorRepository5 = (UserActionProcessorRepository) c11981.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                d2 = d3;
                str = str2;
                userActionProcessorRepository2 = userActionProcessorRepository5;
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource3;
                String authorization3 = UserExtensionsKt.getAuthorization((User) persistedConversation);
                c11981.L$0 = userActionProcessorRepository2;
                c11981.L$1 = str;
                c11981.L$2 = null;
                c11981.label = 3;
                persistedConversation = userActionProcessorRemoteDataSource2.getMessages(authorization3, str, d2, c11981);
                if (persistedConversation == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageList = (MessageList) persistedConversation;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource3 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                List<Message> messages3 = messageList.getMessages();
                hasPrevious = messageList.getHasPrevious();
                if (hasPrevious != null) {
                    zBooleanValue = hasPrevious.booleanValue();
                } else {
                    zBooleanValue = false;
                }
                c11981.L$0 = userActionProcessorRepository2;
                c11981.L$1 = messageList;
                c11981.label = 4;
                objUpdateConversationMessages = userActionProcessorInMemoryDataSource3.updateConversationMessages(str, messages3, zBooleanValue, c11981);
                if (objUpdateConversationMessages == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageList2 = messageList;
                persistedConversation = objUpdateConversationMessages;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                conversation2 = (Conversation) persistedConversation;
                c11981.L$0 = userActionProcessorRepository3;
                c11981.L$1 = messageList2;
                c11981.L$2 = conversation2;
                c11981.L$3 = userActionProcessorRepository3;
                c11981.label = 5;
                user2 = userActionProcessorRepository3.getUser(c11981);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                conversation3 = conversation2;
                messageList3 = messageList2;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11981.L$0 = userActionProcessorRepository4;
                c11981.L$1 = messageList3;
                c11981.L$2 = conversation3;
                c11981.L$3 = null;
                c11981.label = 6;
                if (userActionProcessorRepository3.saveUserToLocalStorage((User) obj, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
                messageList4 = messageList3;
                c11981.L$0 = messageList4;
                c11981.L$1 = null;
                c11981.L$2 = null;
                c11981.label = 7;
                if (userActionProcessorRepository4.saveConversationToLocalStorage(conversation4, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return messageList4;
            case 3:
                str = (String) c11981.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c11981.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                messageList = (MessageList) persistedConversation;
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource4 = userActionProcessorRepository2.userActionProcessorInMemoryDataSource;
                List<Message> messages4 = messageList.getMessages();
                hasPrevious = messageList.getHasPrevious();
                if (hasPrevious != null) {
                    zBooleanValue = hasPrevious.booleanValue();
                } else {
                    zBooleanValue = false;
                }
                c11981.L$0 = userActionProcessorRepository2;
                c11981.L$1 = messageList;
                c11981.label = 4;
                objUpdateConversationMessages = userActionProcessorInMemoryDataSource4.updateConversationMessages(str, messages4, zBooleanValue, c11981);
                if (objUpdateConversationMessages == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageList2 = messageList;
                persistedConversation = objUpdateConversationMessages;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                conversation2 = (Conversation) persistedConversation;
                c11981.L$0 = userActionProcessorRepository3;
                c11981.L$1 = messageList2;
                c11981.L$2 = conversation2;
                c11981.L$3 = userActionProcessorRepository3;
                c11981.label = 5;
                user2 = userActionProcessorRepository3.getUser(c11981);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                conversation3 = conversation2;
                messageList3 = messageList2;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11981.L$0 = userActionProcessorRepository4;
                c11981.L$1 = messageList3;
                c11981.L$2 = conversation3;
                c11981.L$3 = null;
                c11981.label = 6;
                if (userActionProcessorRepository3.saveUserToLocalStorage((User) obj, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
                messageList4 = messageList3;
                c11981.L$0 = messageList4;
                c11981.L$1 = null;
                c11981.L$2 = null;
                c11981.label = 7;
                if (userActionProcessorRepository4.saveConversationToLocalStorage(conversation4, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return messageList4;
            case 4:
                MessageList messageList5 = (MessageList) c11981.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c11981.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                messageList2 = messageList5;
                userActionProcessorRepository3 = userActionProcessorRepository2;
                conversation2 = (Conversation) persistedConversation;
                c11981.L$0 = userActionProcessorRepository3;
                c11981.L$1 = messageList2;
                c11981.L$2 = conversation2;
                c11981.L$3 = userActionProcessorRepository3;
                c11981.label = 5;
                user2 = userActionProcessorRepository3.getUser(c11981);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj = user2;
                conversation3 = conversation2;
                messageList3 = messageList2;
                userActionProcessorRepository4 = userActionProcessorRepository3;
                c11981.L$0 = userActionProcessorRepository4;
                c11981.L$1 = messageList3;
                c11981.L$2 = conversation3;
                c11981.L$3 = null;
                c11981.label = 6;
                if (userActionProcessorRepository3.saveUserToLocalStorage((User) obj, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
                messageList4 = messageList3;
                c11981.L$0 = messageList4;
                c11981.L$1 = null;
                c11981.L$2 = null;
                c11981.label = 7;
                if (userActionProcessorRepository4.saveConversationToLocalStorage(conversation4, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return messageList4;
            case 5:
                userActionProcessorRepository3 = (UserActionProcessorRepository) c11981.L$3;
                conversation3 = (Conversation) c11981.L$2;
                MessageList messageList6 = (MessageList) c11981.L$1;
                UserActionProcessorRepository userActionProcessorRepository6 = (UserActionProcessorRepository) c11981.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                messageList3 = messageList6;
                userActionProcessorRepository4 = userActionProcessorRepository6;
                obj = persistedConversation;
                c11981.L$0 = userActionProcessorRepository4;
                c11981.L$1 = messageList3;
                c11981.L$2 = conversation3;
                c11981.L$3 = null;
                c11981.label = 6;
                if (userActionProcessorRepository3.saveUserToLocalStorage((User) obj, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
                messageList4 = messageList3;
                c11981.L$0 = messageList4;
                c11981.L$1 = null;
                c11981.L$2 = null;
                c11981.label = 7;
                if (userActionProcessorRepository4.saveConversationToLocalStorage(conversation4, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return messageList4;
            case 6:
                conversation4 = (Conversation) c11981.L$2;
                messageList4 = (MessageList) c11981.L$1;
                userActionProcessorRepository4 = (UserActionProcessorRepository) c11981.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                c11981.L$0 = messageList4;
                c11981.L$1 = null;
                c11981.L$2 = null;
                c11981.label = 7;
                if (userActionProcessorRepository4.saveConversationToLocalStorage(conversation4, c11981) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return messageList4;
            case 7:
                MessageList messageList7 = (MessageList) c11981.L$0;
                ResultKt.throwOnFailure(persistedConversation);
                return messageList7;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object createPendingMessage(String str, Message message, Continuation<? super Message> continuation) {
        C11901 c11901;
        UserActionProcessorRepository userActionProcessorRepository;
        if (continuation instanceof C11901) {
            c11901 = (C11901) continuation;
            if ((c11901.label & Integer.MIN_VALUE) != 0) {
                c11901.label -= Integer.MIN_VALUE;
            } else {
                c11901 = new C11901(continuation);
            }
        } else {
            c11901 = new C11901(continuation);
        }
        Object persistedConversation = c11901.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11901.label;
        if (i != 0) {
            if (i == 1) {
                message = (Message) c11901.L$2;
                str = (String) c11901.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c11901.L$0;
                ResultKt.throwOnFailure(persistedConversation);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(persistedConversation);
            }
        }
        ResultKt.throwOnFailure(persistedConversation);
        if ((message.getContent() instanceof MessageContent.Text) && StringsKt.isBlank(((MessageContent.Text) message.getContent()).getText())) {
            throw new MessageContentIsBlankException();
        }
        c11901.L$0 = this;
        c11901.L$1 = str;
        c11901.L$2 = message;
        c11901.label = 1;
        persistedConversation = getPersistedConversation(str, c11901);
        if (persistedConversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository = this;
        if (((Conversation) persistedConversation) == null) {
            throw new ConversationNotFoundException();
        }
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
        c11901.L$0 = null;
        c11901.L$1 = null;
        c11901.L$2 = null;
        c11901.label = 2;
        persistedConversation = userActionProcessorInMemoryDataSource.createPendingMessage(str, message, c11901);
        return persistedConversation == coroutine_suspended ? coroutine_suspended : persistedConversation;
    }

    public final Object sendMessage(Message message, String str, Continuation<? super Message> continuation) {
        C12101 c12101;
        Message message2;
        Message message3;
        ?? r8;
        ?? r15;
        Message messageCopy;
        String localId;
        Object obj;
        long j;
        C12112 c12112;
        Message message4;
        ?? r9;
        ?? r5;
        ?? r10;
        ?? r6;
        Message message5;
        Object objReplacePendingMessage;
        Message message6;
        ?? r11;
        ?? r7;
        Object objSaveConversationToLocalStorage;
        ?? r12;
        ?? r13;
        Message message7;
        ?? r14;
        Message message8;
        ?? r0;
        ?? r16;
        if (continuation instanceof C12101) {
            c12101 = (C12101) continuation;
            if ((c12101.label & Integer.MIN_VALUE) != 0) {
                c12101.label -= Integer.MIN_VALUE;
            } else {
                c12101 = new C12101(continuation);
            }
        } else {
            c12101 = new C12101(continuation);
        }
        Object objSendMessageRestRequest = c12101.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        ?? r17 = c12101.label;
        try {
            try {
                switch (r17) {
                    case 0:
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        c12101.L$0 = this;
                        message3 = message;
                        c12101.L$1 = message3;
                        c12101.L$2 = str;
                        c12101.label = 1;
                        Object persistedConversation = getPersistedConversation(str, c12101);
                        if (persistedConversation == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        r8 = this;
                        r17 = str;
                        obj = persistedConversation;
                        if (((Conversation) obj) != null) {
                            throw new ConversationNotFoundException();
                        }
                        try {
                            j = REMOTE_CALL_RETRY_TIMEOUT;
                            c12112 = new C12112(null);
                            c12101.L$0 = r8;
                            c12101.L$1 = message3;
                            c12101.L$2 = r17;
                            c12101.label = 2;
                            if (TimeoutKt.withTimeout(j, c12112, c12101) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            message4 = message3;
                            r5 = r17;
                            r9 = r8;
                            c12101.L$0 = r9;
                            c12101.L$1 = message4;
                            c12101.L$2 = r5;
                            c12101.label = 3;
                            objSendMessageRestRequest = r9.sendMessageRestRequest(message4, r5, c12101);
                            r6 = r5;
                            r10 = r9;
                            if (objSendMessageRestRequest == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            message5 = (Message) objSendMessageRestRequest;
                            ?? r1 = r10.userActionProcessorInMemoryDataSource;
                            String localId2 = message4.getLocalId();
                            c12101.L$0 = r10;
                            c12101.L$1 = message4;
                            c12101.L$2 = r6;
                            c12101.L$3 = message5;
                            c12101.label = 4;
                            objReplacePendingMessage = r1.replacePendingMessage(r6, message5, localId2, c12101);
                            if (objReplacePendingMessage == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            objSendMessageRestRequest = objReplacePendingMessage;
                            message6 = message5;
                            r7 = r6;
                            r11 = r10;
                            c12101.L$0 = r11;
                            c12101.L$1 = message4;
                            c12101.L$2 = r7;
                            c12101.L$3 = message6;
                            c12101.label = 5;
                            objSaveConversationToLocalStorage = r11.saveConversationToLocalStorage((Conversation) objSendMessageRestRequest, c12101);
                            r13 = r7;
                            r12 = r11;
                            if (objSaveConversationToLocalStorage == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = r12.userActionProcessorInMemoryDataSource;
                            c12101.L$0 = r12;
                            c12101.L$1 = message4;
                            c12101.L$2 = r13;
                            c12101.L$3 = message6;
                            c12101.L$4 = r12;
                            c12101.label = 6;
                            objSendMessageRestRequest = userActionProcessorInMemoryDataSource.getUser(c12101);
                            if (objSendMessageRestRequest == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            ?? r18 = r12;
                            message7 = message4;
                            r14 = r13;
                            message8 = message6;
                            r0 = r18;
                            r16 = r18;
                            c12101.L$0 = r16;
                            c12101.L$1 = message7;
                            c12101.L$2 = r14;
                            c12101.L$3 = message8;
                            c12101.L$4 = null;
                            c12101.label = 7;
                            if (r0.saveUserToLocalStorage((User) objSendMessageRestRequest, c12101) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return message8;
                        } catch (Throwable th) {
                            th = th;
                            r15 = r8.userActionProcessorInMemoryDataSource;
                            Message message9 = message3;
                            messageCopy = message9.copy((2021 & 1) != 0 ? message9.id : null, (2021 & 2) != 0 ? message9.author : null, (2021 & 4) != 0 ? message9.status : MessageStatus.INSTANCE.failed(th), (2021 & 8) != 0 ? message9.created : null, (2021 & 16) != 0 ? message9.received : null, (2021 & 32) != 0 ? message9.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message9.content : null, (2021 & 128) != 0 ? message9.metadata : null, (2021 & 256) != 0 ? message9.sourceId : null, (2021 & 512) != 0 ? message9.localId : null, (2021 & 1024) != 0 ? message9.payload : null);
                            localId = message3.getLocalId();
                            c12101.L$0 = th;
                            c12101.L$1 = null;
                            c12101.L$2 = null;
                            c12101.L$3 = null;
                            c12101.L$4 = null;
                            c12101.label = 8;
                            if (r15.replacePendingMessage(r17, messageCopy, localId, c12101) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            throw th;
                        }
                    case 1:
                        String str2 = (String) c12101.L$2;
                        Message message10 = (Message) c12101.L$1;
                        UserActionProcessorRepository userActionProcessorRepository = (UserActionProcessorRepository) c12101.L$0;
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        r8 = userActionProcessorRepository;
                        r17 = str2;
                        obj = objSendMessageRestRequest;
                        message3 = message10;
                        if (((Conversation) obj) != null) {
                            throw new ConversationNotFoundException();
                        }
                        j = REMOTE_CALL_RETRY_TIMEOUT;
                        c12112 = new C12112(null);
                        c12101.L$0 = r8;
                        c12101.L$1 = message3;
                        c12101.L$2 = r17;
                        c12101.label = 2;
                        if (TimeoutKt.withTimeout(j, c12112, c12101) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        message4 = message3;
                        r5 = r17;
                        r9 = r8;
                        c12101.L$0 = r9;
                        c12101.L$1 = message4;
                        c12101.L$2 = r5;
                        c12101.label = 3;
                        objSendMessageRestRequest = r9.sendMessageRestRequest(message4, r5, c12101);
                        r6 = r5;
                        r10 = r9;
                        if (objSendMessageRestRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        message5 = (Message) objSendMessageRestRequest;
                        ?? r2 = r10.userActionProcessorInMemoryDataSource;
                        String localId3 = message4.getLocalId();
                        c12101.L$0 = r10;
                        c12101.L$1 = message4;
                        c12101.L$2 = r6;
                        c12101.L$3 = message5;
                        c12101.label = 4;
                        objReplacePendingMessage = r2.replacePendingMessage(r6, message5, localId3, c12101);
                        if (objReplacePendingMessage == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        objSendMessageRestRequest = objReplacePendingMessage;
                        message6 = message5;
                        r7 = r6;
                        r11 = r10;
                        c12101.L$0 = r11;
                        c12101.L$1 = message4;
                        c12101.L$2 = r7;
                        c12101.L$3 = message6;
                        c12101.label = 5;
                        objSaveConversationToLocalStorage = r11.saveConversationToLocalStorage((Conversation) objSendMessageRestRequest, c12101);
                        r13 = r7;
                        r12 = r11;
                        if (objSaveConversationToLocalStorage == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = r12.userActionProcessorInMemoryDataSource;
                        c12101.L$0 = r12;
                        c12101.L$1 = message4;
                        c12101.L$2 = r13;
                        c12101.L$3 = message6;
                        c12101.L$4 = r12;
                        c12101.label = 6;
                        objSendMessageRestRequest = userActionProcessorInMemoryDataSource2.getUser(c12101);
                        if (objSendMessageRestRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r19 = r12;
                        message7 = message4;
                        r14 = r13;
                        message8 = message6;
                        r0 = r19;
                        r16 = r19;
                        c12101.L$0 = r16;
                        c12101.L$1 = message7;
                        c12101.L$2 = r14;
                        c12101.L$3 = message8;
                        c12101.L$4 = null;
                        c12101.label = 7;
                        if (r0.saveUserToLocalStorage((User) objSendMessageRestRequest, c12101) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return message8;
                    case 2:
                        String str3 = (String) c12101.L$2;
                        message4 = (Message) c12101.L$1;
                        UserActionProcessorRepository userActionProcessorRepository2 = (UserActionProcessorRepository) c12101.L$0;
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        r5 = str3;
                        r9 = userActionProcessorRepository2;
                        c12101.L$0 = r9;
                        c12101.L$1 = message4;
                        c12101.L$2 = r5;
                        c12101.label = 3;
                        objSendMessageRestRequest = r9.sendMessageRestRequest(message4, r5, c12101);
                        r6 = r5;
                        r10 = r9;
                        if (objSendMessageRestRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        message5 = (Message) objSendMessageRestRequest;
                        ?? r3 = r10.userActionProcessorInMemoryDataSource;
                        String localId4 = message4.getLocalId();
                        c12101.L$0 = r10;
                        c12101.L$1 = message4;
                        c12101.L$2 = r6;
                        c12101.L$3 = message5;
                        c12101.label = 4;
                        objReplacePendingMessage = r3.replacePendingMessage(r6, message5, localId4, c12101);
                        if (objReplacePendingMessage == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        objSendMessageRestRequest = objReplacePendingMessage;
                        message6 = message5;
                        r7 = r6;
                        r11 = r10;
                        c12101.L$0 = r11;
                        c12101.L$1 = message4;
                        c12101.L$2 = r7;
                        c12101.L$3 = message6;
                        c12101.label = 5;
                        objSaveConversationToLocalStorage = r11.saveConversationToLocalStorage((Conversation) objSendMessageRestRequest, c12101);
                        r13 = r7;
                        r12 = r11;
                        if (objSaveConversationToLocalStorage == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource3 = r12.userActionProcessorInMemoryDataSource;
                        c12101.L$0 = r12;
                        c12101.L$1 = message4;
                        c12101.L$2 = r13;
                        c12101.L$3 = message6;
                        c12101.L$4 = r12;
                        c12101.label = 6;
                        objSendMessageRestRequest = userActionProcessorInMemoryDataSource3.getUser(c12101);
                        if (objSendMessageRestRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r110 = r12;
                        message7 = message4;
                        r14 = r13;
                        message8 = message6;
                        r0 = r110;
                        r16 = r110;
                        c12101.L$0 = r16;
                        c12101.L$1 = message7;
                        c12101.L$2 = r14;
                        c12101.L$3 = message8;
                        c12101.L$4 = null;
                        c12101.label = 7;
                        if (r0.saveUserToLocalStorage((User) objSendMessageRestRequest, c12101) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return message8;
                    case 3:
                        String str4 = (String) c12101.L$2;
                        message4 = (Message) c12101.L$1;
                        UserActionProcessorRepository userActionProcessorRepository3 = (UserActionProcessorRepository) c12101.L$0;
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        r6 = str4;
                        r10 = userActionProcessorRepository3;
                        message5 = (Message) objSendMessageRestRequest;
                        ?? r4 = r10.userActionProcessorInMemoryDataSource;
                        String localId5 = message4.getLocalId();
                        c12101.L$0 = r10;
                        c12101.L$1 = message4;
                        c12101.L$2 = r6;
                        c12101.L$3 = message5;
                        c12101.label = 4;
                        objReplacePendingMessage = r4.replacePendingMessage(r6, message5, localId5, c12101);
                        if (objReplacePendingMessage == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        objSendMessageRestRequest = objReplacePendingMessage;
                        message6 = message5;
                        r7 = r6;
                        r11 = r10;
                        c12101.L$0 = r11;
                        c12101.L$1 = message4;
                        c12101.L$2 = r7;
                        c12101.L$3 = message6;
                        c12101.label = 5;
                        objSaveConversationToLocalStorage = r11.saveConversationToLocalStorage((Conversation) objSendMessageRestRequest, c12101);
                        r13 = r7;
                        r12 = r11;
                        if (objSaveConversationToLocalStorage == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource4 = r12.userActionProcessorInMemoryDataSource;
                        c12101.L$0 = r12;
                        c12101.L$1 = message4;
                        c12101.L$2 = r13;
                        c12101.L$3 = message6;
                        c12101.L$4 = r12;
                        c12101.label = 6;
                        objSendMessageRestRequest = userActionProcessorInMemoryDataSource4.getUser(c12101);
                        if (objSendMessageRestRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r111 = r12;
                        message7 = message4;
                        r14 = r13;
                        message8 = message6;
                        r0 = r111;
                        r16 = r111;
                        c12101.L$0 = r16;
                        c12101.L$1 = message7;
                        c12101.L$2 = r14;
                        c12101.L$3 = message8;
                        c12101.L$4 = null;
                        c12101.label = 7;
                        if (r0.saveUserToLocalStorage((User) objSendMessageRestRequest, c12101) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return message8;
                    case 4:
                        message6 = (Message) c12101.L$3;
                        String str5 = (String) c12101.L$2;
                        message4 = (Message) c12101.L$1;
                        UserActionProcessorRepository userActionProcessorRepository4 = (UserActionProcessorRepository) c12101.L$0;
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        r7 = str5;
                        r11 = userActionProcessorRepository4;
                        c12101.L$0 = r11;
                        c12101.L$1 = message4;
                        c12101.L$2 = r7;
                        c12101.L$3 = message6;
                        c12101.label = 5;
                        objSaveConversationToLocalStorage = r11.saveConversationToLocalStorage((Conversation) objSendMessageRestRequest, c12101);
                        r13 = r7;
                        r12 = r11;
                        if (objSaveConversationToLocalStorage == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource5 = r12.userActionProcessorInMemoryDataSource;
                        c12101.L$0 = r12;
                        c12101.L$1 = message4;
                        c12101.L$2 = r13;
                        c12101.L$3 = message6;
                        c12101.L$4 = r12;
                        c12101.label = 6;
                        objSendMessageRestRequest = userActionProcessorInMemoryDataSource5.getUser(c12101);
                        if (objSendMessageRestRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r112 = r12;
                        message7 = message4;
                        r14 = r13;
                        message8 = message6;
                        r0 = r112;
                        r16 = r112;
                        c12101.L$0 = r16;
                        c12101.L$1 = message7;
                        c12101.L$2 = r14;
                        c12101.L$3 = message8;
                        c12101.L$4 = null;
                        c12101.label = 7;
                        if (r0.saveUserToLocalStorage((User) objSendMessageRestRequest, c12101) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return message8;
                    case 5:
                        message6 = (Message) c12101.L$3;
                        String str6 = (String) c12101.L$2;
                        message4 = (Message) c12101.L$1;
                        UserActionProcessorRepository userActionProcessorRepository5 = (UserActionProcessorRepository) c12101.L$0;
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        r13 = str6;
                        r12 = userActionProcessorRepository5;
                        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource6 = r12.userActionProcessorInMemoryDataSource;
                        c12101.L$0 = r12;
                        c12101.L$1 = message4;
                        c12101.L$2 = r13;
                        c12101.L$3 = message6;
                        c12101.L$4 = r12;
                        c12101.label = 6;
                        objSendMessageRestRequest = userActionProcessorInMemoryDataSource6.getUser(c12101);
                        if (objSendMessageRestRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        ?? r113 = r12;
                        message7 = message4;
                        r14 = r13;
                        message8 = message6;
                        r0 = r113;
                        r16 = r113;
                        c12101.L$0 = r16;
                        c12101.L$1 = message7;
                        c12101.L$2 = r14;
                        c12101.L$3 = message8;
                        c12101.L$4 = null;
                        c12101.label = 7;
                        if (r0.saveUserToLocalStorage((User) objSendMessageRestRequest, c12101) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        return message8;
                    case 6:
                        UserActionProcessorRepository userActionProcessorRepository6 = (UserActionProcessorRepository) c12101.L$4;
                        message8 = (Message) c12101.L$3;
                        r14 = (String) c12101.L$2;
                        message7 = (Message) c12101.L$1;
                        r16 = (UserActionProcessorRepository) c12101.L$0;
                        try {
                            ResultKt.throwOnFailure(objSendMessageRestRequest);
                            r0 = userActionProcessorRepository6;
                            r14 = r14;
                            r16 = r16;
                            c12101.L$0 = r16;
                            c12101.L$1 = message7;
                            c12101.L$2 = r14;
                            c12101.L$3 = message8;
                            c12101.L$4 = null;
                            c12101.label = 7;
                            if (r0.saveUserToLocalStorage((User) objSendMessageRestRequest, c12101) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return message8;
                        } catch (Throwable th2) {
                            th = th2;
                            r17 = r14;
                            message3 = message7;
                            r8 = r16;
                            r15 = r8.userActionProcessorInMemoryDataSource;
                            Message message11 = message3;
                            messageCopy = message11.copy((2021 & 1) != 0 ? message11.id : null, (2021 & 2) != 0 ? message11.author : null, (2021 & 4) != 0 ? message11.status : MessageStatus.INSTANCE.failed(th), (2021 & 8) != 0 ? message11.created : null, (2021 & 16) != 0 ? message11.received : null, (2021 & 32) != 0 ? message11.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message11.content : null, (2021 & 128) != 0 ? message11.metadata : null, (2021 & 256) != 0 ? message11.sourceId : null, (2021 & 512) != 0 ? message11.localId : null, (2021 & 1024) != 0 ? message11.payload : null);
                            localId = message3.getLocalId();
                            c12101.L$0 = th;
                            c12101.L$1 = null;
                            c12101.L$2 = null;
                            c12101.L$3 = null;
                            c12101.L$4 = null;
                            c12101.label = 8;
                            if (r15.replacePendingMessage(r17, messageCopy, localId, c12101) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            throw th;
                        }
                    case 7:
                        Message message12 = (Message) c12101.L$3;
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        return message12;
                    case 8:
                        Throwable th3 = (Throwable) c12101.L$0;
                        ResultKt.throwOnFailure(objSendMessageRestRequest);
                        throw th3;
                    default:
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
            } catch (Throwable th4) {
                th = th4;
                message3 = message2;
            }
        } catch (MessageAlreadyInConversationException e) {
            throw e;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorRepository$sendMessage$2", m37f = "UserActionProcessorRepository.kt", m38i = {}, m39l = {603}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12112 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C12112(Continuation<? super C12112> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return UserActionProcessorRepository.this.new C12112(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12112) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (UserActionProcessorRepository.this.connectivityObserver.awaitConnection(this) == coroutine_suspended) {
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

    private final <T> T executeWithUnknownHostExceptionRetry(Function0<? extends T> call) {
        try {
            return call.invoke();
        } catch (UnknownHostException unused) {
            return call.invoke();
        }
    }

    public final Object sendMessageRestRequest(Message message, String str, Continuation<? super Message> continuation) throws Throwable {
        C12121 c12121;
        Object obj;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        Object user;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        Object user2;
        UserActionProcessorRepository userActionProcessorRepository2;
        String authorization;
        LocalDateTime created;
        String localId;
        MessageContent content;
        Object user3;
        UserActionProcessorRepository userActionProcessorRepository3;
        LocalDateTime localDateTime;
        String str2;
        String str3;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        Message message2;
        MessageContent messageContent;
        String str4;
        String id;
        MessageContent messageContent2;
        String str5;
        String str6;
        Object pushToken;
        Message message3;
        String str7;
        String str8;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4;
        LocalDateTime localDateTime2;
        String str9;
        Object objUploadFile;
        String authorization2;
        LocalDateTime created2;
        String localId2;
        Object user4;
        Message message4;
        UserActionProcessorRepository userActionProcessorRepository4;
        String str10;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5;
        String str11;
        String str12;
        LocalDateTime localDateTime3;
        String id2;
        Object clientId;
        UserActionProcessorRepository userActionProcessorRepository5;
        String str13;
        String str14;
        Object pushToken2;
        String str15;
        String str16;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6;
        Message message5;
        LocalDateTime localDateTime4;
        String str17;
        Object objSendMessage;
        Message message6 = message;
        String str18 = str;
        if (continuation instanceof C12121) {
            c12121 = (C12121) continuation;
            if ((c12121.label & Integer.MIN_VALUE) != 0) {
                c12121.label -= Integer.MIN_VALUE;
            } else {
                c12121 = new C12121(continuation);
            }
        } else {
            c12121 = new C12121(continuation);
        }
        Object clientId2 = c12121.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c12121.label) {
            case 0:
                ResultKt.throwOnFailure(clientId2);
                if (!(message.getContent() instanceof MessageContent.FileUpload)) {
                    obj = coroutine_suspended;
                    userActionProcessorRemoteDataSource = this.userActionProcessorRemoteDataSource;
                    c12121.L$0 = this;
                    c12121.L$1 = message6;
                    c12121.L$2 = str18;
                    c12121.L$3 = userActionProcessorRemoteDataSource;
                    c12121.label = 6;
                    user = getUser(c12121);
                    if (user == obj) {
                        return obj;
                    }
                    userActionProcessorRepository = this;
                    authorization2 = UserExtensionsKt.getAuthorization((User) user);
                    created2 = message6.getCreated();
                    localId2 = message6.getLocalId();
                    c12121.L$0 = userActionProcessorRepository;
                    c12121.L$1 = userActionProcessorRemoteDataSource;
                    c12121.L$2 = authorization2;
                    c12121.L$3 = str18;
                    c12121.L$4 = created2;
                    c12121.L$5 = localId2;
                    c12121.L$6 = message6;
                    c12121.label = 7;
                    user4 = userActionProcessorRepository.getUser(c12121);
                    if (user4 == obj) {
                        return obj;
                    }
                    String str19 = str18;
                    message4 = message6;
                    userActionProcessorRepository4 = userActionProcessorRepository;
                    str10 = str19;
                    userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource;
                    str11 = localId2;
                    str12 = authorization2;
                    localDateTime3 = created2;
                    id2 = ((User) user4).getId();
                    UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository4.userActionProcessorLocalDataSource;
                    c12121.L$0 = userActionProcessorRepository4;
                    c12121.L$1 = userActionProcessorRemoteDataSource5;
                    c12121.L$2 = str12;
                    c12121.L$3 = str10;
                    c12121.L$4 = localDateTime3;
                    c12121.L$5 = str11;
                    c12121.L$6 = message4;
                    c12121.L$7 = id2;
                    c12121.label = 8;
                    clientId = userActionProcessorLocalDataSource.getClientId(c12121);
                    if (clientId == obj) {
                        return obj;
                    }
                    userActionProcessorRepository5 = userActionProcessorRepository4;
                    str13 = id2;
                    str14 = (String) clientId;
                    UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository5.userActionProcessorLocalDataSource;
                    c12121.L$0 = userActionProcessorRemoteDataSource5;
                    c12121.L$1 = str12;
                    c12121.L$2 = str10;
                    c12121.L$3 = localDateTime3;
                    c12121.L$4 = str11;
                    c12121.L$5 = message4;
                    c12121.L$6 = str13;
                    c12121.L$7 = str14;
                    c12121.label = 9;
                    pushToken2 = userActionProcessorLocalDataSource2.getPushToken(c12121);
                    if (pushToken2 == obj) {
                        return obj;
                    }
                    Message message7 = message4;
                    str15 = str13;
                    str16 = str11;
                    userActionProcessorRemoteDataSource6 = userActionProcessorRemoteDataSource5;
                    message5 = message7;
                    String str20 = str10;
                    localDateTime4 = localDateTime3;
                    str17 = str20;
                    c12121.L$0 = null;
                    c12121.L$1 = null;
                    c12121.L$2 = null;
                    c12121.L$3 = null;
                    c12121.L$4 = null;
                    c12121.L$5 = null;
                    c12121.L$6 = null;
                    c12121.L$7 = null;
                    c12121.label = 10;
                    objSendMessage = userActionProcessorRemoteDataSource6.sendMessage(str12, str17, localDateTime4, str16, message5, str15, str14, (String) pushToken2, c12121);
                    if (objSendMessage == obj) {
                        return obj;
                    }
                    return objSendMessage;
                }
                userActionProcessorRemoteDataSource2 = this.userActionProcessorRemoteDataSource;
                c12121.L$0 = this;
                c12121.L$1 = message6;
                c12121.L$2 = str18;
                c12121.L$3 = userActionProcessorRemoteDataSource2;
                c12121.label = 1;
                user2 = getUser(c12121);
                if (user2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = this;
                authorization = UserExtensionsKt.getAuthorization((User) user2);
                created = message6.getCreated();
                localId = message6.getLocalId();
                content = message6.getContent();
                c12121.L$0 = userActionProcessorRepository2;
                c12121.L$1 = message6;
                c12121.L$2 = str18;
                c12121.L$3 = userActionProcessorRemoteDataSource2;
                c12121.L$4 = authorization;
                c12121.L$5 = created;
                c12121.L$6 = localId;
                c12121.L$7 = content;
                c12121.label = 2;
                user3 = userActionProcessorRepository2.getUser(c12121);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                localDateTime = created;
                str2 = authorization;
                str3 = localId;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                clientId2 = user3;
                message2 = message6;
                messageContent = content;
                str4 = str18;
                id = ((User) clientId2).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository3.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRepository3;
                c12121.L$1 = message2;
                c12121.L$2 = str4;
                c12121.L$3 = userActionProcessorRemoteDataSource3;
                c12121.L$4 = str2;
                c12121.L$5 = localDateTime;
                c12121.L$6 = str3;
                c12121.L$7 = messageContent;
                c12121.L$8 = id;
                c12121.label = 3;
                clientId2 = userActionProcessorLocalDataSource3.getClientId(c12121);
                if (clientId2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageContent2 = messageContent;
                str5 = id;
                str6 = (String) clientId2;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource4 = userActionProcessorRepository3.userActionProcessorLocalDataSource;
                c12121.L$0 = message2;
                c12121.L$1 = str4;
                c12121.L$2 = userActionProcessorRemoteDataSource3;
                c12121.L$3 = str2;
                c12121.L$4 = localDateTime;
                c12121.L$5 = str3;
                c12121.L$6 = messageContent2;
                c12121.L$7 = str5;
                c12121.L$8 = str6;
                c12121.label = 4;
                pushToken = userActionProcessorLocalDataSource4.getPushToken(c12121);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                message3 = message2;
                str7 = str6;
                clientId2 = pushToken;
                String str21 = str4;
                str8 = str3;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                localDateTime2 = localDateTime;
                str9 = str21;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.L$8 = null;
                c12121.label = 5;
                objUploadFile = userActionProcessorRemoteDataSource4.uploadFile(str2, str9, str5, localDateTime2, str8, str7, (String) clientId2, (MessageContent.FileUpload) messageContent2, message3, c12121);
                if (objUploadFile == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return objUploadFile;
            case 1:
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource7 = (UserActionProcessorRemoteDataSource) c12121.L$3;
                str18 = (String) c12121.L$2;
                Message message8 = (Message) c12121.L$1;
                userActionProcessorRepository2 = (UserActionProcessorRepository) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource7;
                message6 = message8;
                user2 = clientId2;
                authorization = UserExtensionsKt.getAuthorization((User) user2);
                created = message6.getCreated();
                localId = message6.getLocalId();
                content = message6.getContent();
                c12121.L$0 = userActionProcessorRepository2;
                c12121.L$1 = message6;
                c12121.L$2 = str18;
                c12121.L$3 = userActionProcessorRemoteDataSource2;
                c12121.L$4 = authorization;
                c12121.L$5 = created;
                c12121.L$6 = localId;
                c12121.L$7 = content;
                c12121.label = 2;
                user3 = userActionProcessorRepository2.getUser(c12121);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository3 = userActionProcessorRepository2;
                localDateTime = created;
                str2 = authorization;
                str3 = localId;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                clientId2 = user3;
                message2 = message6;
                messageContent = content;
                str4 = str18;
                id = ((User) clientId2).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource5 = userActionProcessorRepository3.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRepository3;
                c12121.L$1 = message2;
                c12121.L$2 = str4;
                c12121.L$3 = userActionProcessorRemoteDataSource3;
                c12121.L$4 = str2;
                c12121.L$5 = localDateTime;
                c12121.L$6 = str3;
                c12121.L$7 = messageContent;
                c12121.L$8 = id;
                c12121.label = 3;
                clientId2 = userActionProcessorLocalDataSource5.getClientId(c12121);
                if (clientId2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageContent2 = messageContent;
                str5 = id;
                str6 = (String) clientId2;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource6 = userActionProcessorRepository3.userActionProcessorLocalDataSource;
                c12121.L$0 = message2;
                c12121.L$1 = str4;
                c12121.L$2 = userActionProcessorRemoteDataSource3;
                c12121.L$3 = str2;
                c12121.L$4 = localDateTime;
                c12121.L$5 = str3;
                c12121.L$6 = messageContent2;
                c12121.L$7 = str5;
                c12121.L$8 = str6;
                c12121.label = 4;
                pushToken = userActionProcessorLocalDataSource6.getPushToken(c12121);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                message3 = message2;
                str7 = str6;
                clientId2 = pushToken;
                String str22 = str4;
                str8 = str3;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                localDateTime2 = localDateTime;
                str9 = str22;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.L$8 = null;
                c12121.label = 5;
                objUploadFile = userActionProcessorRemoteDataSource4.uploadFile(str2, str9, str5, localDateTime2, str8, str7, (String) clientId2, (MessageContent.FileUpload) messageContent2, message3, c12121);
                if (objUploadFile == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return objUploadFile;
            case 2:
                messageContent = (MessageContent) c12121.L$7;
                String str23 = (String) c12121.L$6;
                LocalDateTime localDateTime5 = (LocalDateTime) c12121.L$5;
                String str24 = (String) c12121.L$4;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource8 = (UserActionProcessorRemoteDataSource) c12121.L$3;
                String str25 = (String) c12121.L$2;
                Message message9 = (Message) c12121.L$1;
                UserActionProcessorRepository userActionProcessorRepository6 = (UserActionProcessorRepository) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                userActionProcessorRepository3 = userActionProcessorRepository6;
                message2 = message9;
                str4 = str25;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource8;
                str2 = str24;
                localDateTime = localDateTime5;
                str3 = str23;
                id = ((User) clientId2).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource7 = userActionProcessorRepository3.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRepository3;
                c12121.L$1 = message2;
                c12121.L$2 = str4;
                c12121.L$3 = userActionProcessorRemoteDataSource3;
                c12121.L$4 = str2;
                c12121.L$5 = localDateTime;
                c12121.L$6 = str3;
                c12121.L$7 = messageContent;
                c12121.L$8 = id;
                c12121.label = 3;
                clientId2 = userActionProcessorLocalDataSource7.getClientId(c12121);
                if (clientId2 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                messageContent2 = messageContent;
                str5 = id;
                str6 = (String) clientId2;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource8 = userActionProcessorRepository3.userActionProcessorLocalDataSource;
                c12121.L$0 = message2;
                c12121.L$1 = str4;
                c12121.L$2 = userActionProcessorRemoteDataSource3;
                c12121.L$3 = str2;
                c12121.L$4 = localDateTime;
                c12121.L$5 = str3;
                c12121.L$6 = messageContent2;
                c12121.L$7 = str5;
                c12121.L$8 = str6;
                c12121.label = 4;
                pushToken = userActionProcessorLocalDataSource8.getPushToken(c12121);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                message3 = message2;
                str7 = str6;
                clientId2 = pushToken;
                String str26 = str4;
                str8 = str3;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                localDateTime2 = localDateTime;
                str9 = str26;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.L$8 = null;
                c12121.label = 5;
                objUploadFile = userActionProcessorRemoteDataSource4.uploadFile(str2, str9, str5, localDateTime2, str8, str7, (String) clientId2, (MessageContent.FileUpload) messageContent2, message3, c12121);
                if (objUploadFile == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return objUploadFile;
            case 3:
                str5 = (String) c12121.L$8;
                messageContent2 = (MessageContent) c12121.L$7;
                str3 = (String) c12121.L$6;
                localDateTime = (LocalDateTime) c12121.L$5;
                str2 = (String) c12121.L$4;
                userActionProcessorRemoteDataSource3 = (UserActionProcessorRemoteDataSource) c12121.L$3;
                str4 = (String) c12121.L$2;
                message2 = (Message) c12121.L$1;
                userActionProcessorRepository3 = (UserActionProcessorRepository) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                str6 = (String) clientId2;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource9 = userActionProcessorRepository3.userActionProcessorLocalDataSource;
                c12121.L$0 = message2;
                c12121.L$1 = str4;
                c12121.L$2 = userActionProcessorRemoteDataSource3;
                c12121.L$3 = str2;
                c12121.L$4 = localDateTime;
                c12121.L$5 = str3;
                c12121.L$6 = messageContent2;
                c12121.L$7 = str5;
                c12121.L$8 = str6;
                c12121.label = 4;
                pushToken = userActionProcessorLocalDataSource9.getPushToken(c12121);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                message3 = message2;
                str7 = str6;
                clientId2 = pushToken;
                String str27 = str4;
                str8 = str3;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource3;
                localDateTime2 = localDateTime;
                str9 = str27;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.L$8 = null;
                c12121.label = 5;
                objUploadFile = userActionProcessorRemoteDataSource4.uploadFile(str2, str9, str5, localDateTime2, str8, str7, (String) clientId2, (MessageContent.FileUpload) messageContent2, message3, c12121);
                if (objUploadFile == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return objUploadFile;
            case 4:
                String str28 = (String) c12121.L$8;
                String str29 = (String) c12121.L$7;
                MessageContent messageContent3 = (MessageContent) c12121.L$6;
                String str30 = (String) c12121.L$5;
                LocalDateTime localDateTime6 = (LocalDateTime) c12121.L$4;
                String str31 = (String) c12121.L$3;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource9 = (UserActionProcessorRemoteDataSource) c12121.L$2;
                String str32 = (String) c12121.L$1;
                Message message10 = (Message) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                message3 = message10;
                str7 = str28;
                str5 = str29;
                messageContent2 = messageContent3;
                userActionProcessorRemoteDataSource4 = userActionProcessorRemoteDataSource9;
                str8 = str30;
                str9 = str32;
                localDateTime2 = localDateTime6;
                str2 = str31;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.L$8 = null;
                c12121.label = 5;
                objUploadFile = userActionProcessorRemoteDataSource4.uploadFile(str2, str9, str5, localDateTime2, str8, str7, (String) clientId2, (MessageContent.FileUpload) messageContent2, message3, c12121);
                if (objUploadFile == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return objUploadFile;
            case 5:
                ResultKt.throwOnFailure(clientId2);
                return clientId2;
            case 6:
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource10 = (UserActionProcessorRemoteDataSource) c12121.L$3;
                str18 = (String) c12121.L$2;
                Message message11 = (Message) c12121.L$1;
                UserActionProcessorRepository userActionProcessorRepository7 = (UserActionProcessorRepository) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                userActionProcessorRepository = userActionProcessorRepository7;
                user = clientId2;
                obj = coroutine_suspended;
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource10;
                message6 = message11;
                authorization2 = UserExtensionsKt.getAuthorization((User) user);
                created2 = message6.getCreated();
                localId2 = message6.getLocalId();
                c12121.L$0 = userActionProcessorRepository;
                c12121.L$1 = userActionProcessorRemoteDataSource;
                c12121.L$2 = authorization2;
                c12121.L$3 = str18;
                c12121.L$4 = created2;
                c12121.L$5 = localId2;
                c12121.L$6 = message6;
                c12121.label = 7;
                user4 = userActionProcessorRepository.getUser(c12121);
                if (user4 == obj) {
                    return obj;
                }
                String str110 = str18;
                message4 = message6;
                userActionProcessorRepository4 = userActionProcessorRepository;
                str10 = str110;
                userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource;
                str11 = localId2;
                str12 = authorization2;
                localDateTime3 = created2;
                id2 = ((User) user4).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource10 = userActionProcessorRepository4.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRepository4;
                c12121.L$1 = userActionProcessorRemoteDataSource5;
                c12121.L$2 = str12;
                c12121.L$3 = str10;
                c12121.L$4 = localDateTime3;
                c12121.L$5 = str11;
                c12121.L$6 = message4;
                c12121.L$7 = id2;
                c12121.label = 8;
                clientId = userActionProcessorLocalDataSource10.getClientId(c12121);
                if (clientId == obj) {
                    return obj;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                str13 = id2;
                str14 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource11 = userActionProcessorRepository5.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRemoteDataSource5;
                c12121.L$1 = str12;
                c12121.L$2 = str10;
                c12121.L$3 = localDateTime3;
                c12121.L$4 = str11;
                c12121.L$5 = message4;
                c12121.L$6 = str13;
                c12121.L$7 = str14;
                c12121.label = 9;
                pushToken2 = userActionProcessorLocalDataSource11.getPushToken(c12121);
                if (pushToken2 == obj) {
                    return obj;
                }
                Message message12 = message4;
                str15 = str13;
                str16 = str11;
                userActionProcessorRemoteDataSource6 = userActionProcessorRemoteDataSource5;
                message5 = message12;
                String str210 = str10;
                localDateTime4 = localDateTime3;
                str17 = str210;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.label = 10;
                objSendMessage = userActionProcessorRemoteDataSource6.sendMessage(str12, str17, localDateTime4, str16, message5, str15, str14, (String) pushToken2, c12121);
                if (objSendMessage == obj) {
                    return obj;
                }
                return objSendMessage;
            case 7:
                Message message13 = (Message) c12121.L$6;
                String str33 = (String) c12121.L$5;
                LocalDateTime localDateTime7 = (LocalDateTime) c12121.L$4;
                String str34 = (String) c12121.L$3;
                String str35 = (String) c12121.L$2;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource11 = (UserActionProcessorRemoteDataSource) c12121.L$1;
                UserActionProcessorRepository userActionProcessorRepository8 = (UserActionProcessorRepository) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                user4 = clientId2;
                obj = coroutine_suspended;
                message4 = message13;
                userActionProcessorRepository4 = userActionProcessorRepository8;
                userActionProcessorRemoteDataSource5 = userActionProcessorRemoteDataSource11;
                str12 = str35;
                str10 = str34;
                localDateTime3 = localDateTime7;
                str11 = str33;
                id2 = ((User) user4).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource12 = userActionProcessorRepository4.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRepository4;
                c12121.L$1 = userActionProcessorRemoteDataSource5;
                c12121.L$2 = str12;
                c12121.L$3 = str10;
                c12121.L$4 = localDateTime3;
                c12121.L$5 = str11;
                c12121.L$6 = message4;
                c12121.L$7 = id2;
                c12121.label = 8;
                clientId = userActionProcessorLocalDataSource12.getClientId(c12121);
                if (clientId == obj) {
                    return obj;
                }
                userActionProcessorRepository5 = userActionProcessorRepository4;
                str13 = id2;
                str14 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource13 = userActionProcessorRepository5.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRemoteDataSource5;
                c12121.L$1 = str12;
                c12121.L$2 = str10;
                c12121.L$3 = localDateTime3;
                c12121.L$4 = str11;
                c12121.L$5 = message4;
                c12121.L$6 = str13;
                c12121.L$7 = str14;
                c12121.label = 9;
                pushToken2 = userActionProcessorLocalDataSource13.getPushToken(c12121);
                if (pushToken2 == obj) {
                    return obj;
                }
                Message message14 = message4;
                str15 = str13;
                str16 = str11;
                userActionProcessorRemoteDataSource6 = userActionProcessorRemoteDataSource5;
                message5 = message14;
                String str211 = str10;
                localDateTime4 = localDateTime3;
                str17 = str211;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.label = 10;
                objSendMessage = userActionProcessorRemoteDataSource6.sendMessage(str12, str17, localDateTime4, str16, message5, str15, str14, (String) pushToken2, c12121);
                if (objSendMessage == obj) {
                    return obj;
                }
                return objSendMessage;
            case 8:
                str13 = (String) c12121.L$7;
                message4 = (Message) c12121.L$6;
                str11 = (String) c12121.L$5;
                localDateTime3 = (LocalDateTime) c12121.L$4;
                str10 = (String) c12121.L$3;
                str12 = (String) c12121.L$2;
                userActionProcessorRemoteDataSource5 = (UserActionProcessorRemoteDataSource) c12121.L$1;
                userActionProcessorRepository5 = (UserActionProcessorRepository) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                clientId = clientId2;
                obj = coroutine_suspended;
                str14 = (String) clientId;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource14 = userActionProcessorRepository5.userActionProcessorLocalDataSource;
                c12121.L$0 = userActionProcessorRemoteDataSource5;
                c12121.L$1 = str12;
                c12121.L$2 = str10;
                c12121.L$3 = localDateTime3;
                c12121.L$4 = str11;
                c12121.L$5 = message4;
                c12121.L$6 = str13;
                c12121.L$7 = str14;
                c12121.label = 9;
                pushToken2 = userActionProcessorLocalDataSource14.getPushToken(c12121);
                if (pushToken2 == obj) {
                    return obj;
                }
                Message message15 = message4;
                str15 = str13;
                str16 = str11;
                userActionProcessorRemoteDataSource6 = userActionProcessorRemoteDataSource5;
                message5 = message15;
                String str212 = str10;
                localDateTime4 = localDateTime3;
                str17 = str212;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.label = 10;
                objSendMessage = userActionProcessorRemoteDataSource6.sendMessage(str12, str17, localDateTime4, str16, message5, str15, str14, (String) pushToken2, c12121);
                if (objSendMessage == obj) {
                    return obj;
                }
                return objSendMessage;
            case 9:
                String str36 = (String) c12121.L$7;
                str15 = (String) c12121.L$6;
                Message message16 = (Message) c12121.L$5;
                String str37 = (String) c12121.L$4;
                localDateTime4 = (LocalDateTime) c12121.L$3;
                String str38 = (String) c12121.L$2;
                String str39 = (String) c12121.L$1;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource12 = (UserActionProcessorRemoteDataSource) c12121.L$0;
                ResultKt.throwOnFailure(clientId2);
                str14 = str36;
                str16 = str37;
                str17 = str38;
                str12 = str39;
                message5 = message16;
                userActionProcessorRemoteDataSource6 = userActionProcessorRemoteDataSource12;
                pushToken2 = clientId2;
                obj = coroutine_suspended;
                c12121.L$0 = null;
                c12121.L$1 = null;
                c12121.L$2 = null;
                c12121.L$3 = null;
                c12121.L$4 = null;
                c12121.L$5 = null;
                c12121.L$6 = null;
                c12121.L$7 = null;
                c12121.label = 10;
                objSendMessage = userActionProcessorRemoteDataSource6.sendMessage(str12, str17, localDateTime4, str16, message5, str15, str14, (String) pushToken2, c12121);
                if (objSendMessage == obj) {
                    return obj;
                }
                return objSendMessage;
            case 10:
                ResultKt.throwOnFailure(clientId2);
                return clientId2;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object saveConversationToLocalStorage(Conversation conversation, Continuation<? super Unit> continuation) {
        List<Message> messages = conversation.getMessages();
        ArrayList arrayList = new ArrayList();
        for (Object obj : messages) {
            if (((Message) obj).getStatus() instanceof MessageStatus.Sent) {
                arrayList.add(obj);
            }
        }
        Object objSaveConversation = this.userActionProcessorLocalDataSource.saveConversation(conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : arrayList, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null), continuation);
        return objSaveConversation == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSaveConversation : Unit.INSTANCE;
    }

    public final Object saveUserToLocalStorage(User user, Continuation<? super Unit> continuation) {
        List<Conversation> conversations = user.getConversations();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(conversations, 10));
        for (Conversation conversation : conversations) {
            List<Message> messages = conversation.getMessages();
            ArrayList arrayList2 = new ArrayList();
            for (Object obj : messages) {
                if (((Message) obj).getStatus() instanceof MessageStatus.Sent) {
                    arrayList2.add(obj);
                }
            }
            arrayList.add(conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : arrayList2, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
        }
        Object objUpdateUser = this.userActionProcessorLocalDataSource.updateUser(user.copy((8063 & 1) != 0 ? user.id : null, (8063 & 2) != 0 ? user.externalId : null, (8063 & 4) != 0 ? user.givenName : null, (8063 & 8) != 0 ? user.surname : null, (8063 & 16) != 0 ? user.email : null, (8063 & 32) != 0 ? user.locale : null, (8063 & 64) != 0 ? user.signedUpAt : null, (8063 & 128) != 0 ? user.conversations : arrayList, (8063 & 256) != 0 ? user.realtimeSettings : null, (8063 & 512) != 0 ? user.typingSettings : null, (8063 & 1024) != 0 ? user.sessionToken : null, (8063 & 2048) != 0 ? user.jwt : null, (8063 & 4096) != 0 ? user.hasMore : false), continuation);
        return objUpdateUser == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdateUser : Unit.INSTANCE;
    }

    public final Object sendActivityData(ActivityData activityData, String str, Continuation<? super Unit> continuation) throws Throwable {
        C12091 c12091;
        UserActionProcessorRepository userActionProcessorRepository;
        ActivityData activityData2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String str2;
        ActivityData activityData3;
        String id;
        Object clientId;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        String str3;
        String str4;
        Object pushToken;
        String str5;
        ActivityData activityData4;
        String str6;
        String str7;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        String type;
        if (continuation instanceof C12091) {
            c12091 = (C12091) continuation;
            if ((c12091.label & Integer.MIN_VALUE) != 0) {
                c12091.label -= Integer.MIN_VALUE;
            } else {
                c12091 = new C12091(continuation);
            }
        } else {
            c12091 = new C12091(continuation);
        }
        C12091 c12092 = c12091;
        Object obj = c12092.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12092.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4 = this.userActionProcessorRemoteDataSource;
            c12092.L$0 = this;
            c12092.L$1 = activityData;
            c12092.L$2 = str;
            c12092.L$3 = userActionProcessorRemoteDataSource4;
            c12092.label = 1;
            Object user = getUser(c12092);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
            activityData2 = activityData;
            userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource4;
            obj = user;
        } else {
            if (i == 1) {
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12092.L$3;
                str = (String) c12092.L$2;
                activityData2 = (ActivityData) c12092.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12092.L$0;
                ResultKt.throwOnFailure(obj);
            } else if (i == 2) {
                String str8 = (String) c12092.L$4;
                String str9 = (String) c12092.L$3;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5 = (UserActionProcessorRemoteDataSource) c12092.L$2;
                activityData3 = (ActivityData) c12092.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12092.L$0;
                ResultKt.throwOnFailure(obj);
                str = str8;
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource5;
                str2 = str9;
                id = ((User) obj).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12092.L$0 = userActionProcessorRepository;
                c12092.L$1 = activityData3;
                c12092.L$2 = userActionProcessorRemoteDataSource;
                c12092.L$3 = str2;
                c12092.L$4 = str;
                c12092.L$5 = id;
                c12092.label = 3;
                clientId = userActionProcessorLocalDataSource.getClientId(c12092);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                str3 = id;
                obj = clientId;
                str4 = (String) obj;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12092.L$0 = activityData3;
                c12092.L$1 = userActionProcessorRemoteDataSource2;
                c12092.L$2 = str2;
                c12092.L$3 = str;
                c12092.L$4 = str3;
                c12092.L$5 = str4;
                c12092.label = 4;
                pushToken = userActionProcessorLocalDataSource2.getPushToken(c12092);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6 = userActionProcessorRemoteDataSource2;
                str5 = str3;
                activityData4 = activityData3;
                str6 = str4;
                obj = pushToken;
                str7 = str2;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource6;
                type = activityData4.getType();
                c12092.L$0 = null;
                c12092.L$1 = null;
                c12092.L$2 = null;
                c12092.L$3 = null;
                c12092.L$4 = null;
                c12092.L$5 = null;
                c12092.label = 5;
                if (userActionProcessorRemoteDataSource3.sendActivityData(str7, str, str5, str6, (String) obj, type, c12092) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 3) {
                str3 = (String) c12092.L$5;
                str = (String) c12092.L$4;
                str2 = (String) c12092.L$3;
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c12092.L$2;
                activityData3 = (ActivityData) c12092.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12092.L$0;
                ResultKt.throwOnFailure(obj);
                str4 = (String) obj;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12092.L$0 = activityData3;
                c12092.L$1 = userActionProcessorRemoteDataSource2;
                c12092.L$2 = str2;
                c12092.L$3 = str;
                c12092.L$4 = str3;
                c12092.L$5 = str4;
                c12092.label = 4;
                pushToken = userActionProcessorLocalDataSource3.getPushToken(c12092);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource7 = userActionProcessorRemoteDataSource2;
                str5 = str3;
                activityData4 = activityData3;
                str6 = str4;
                obj = pushToken;
                str7 = str2;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource7;
                type = activityData4.getType();
                c12092.L$0 = null;
                c12092.L$1 = null;
                c12092.L$2 = null;
                c12092.L$3 = null;
                c12092.L$4 = null;
                c12092.L$5 = null;
                c12092.label = 5;
                if (userActionProcessorRemoteDataSource3.sendActivityData(str7, str, str5, str6, (String) obj, type, c12092) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 4) {
                String str10 = (String) c12092.L$5;
                String str11 = (String) c12092.L$4;
                String str12 = (String) c12092.L$3;
                str7 = (String) c12092.L$2;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource8 = (UserActionProcessorRemoteDataSource) c12092.L$1;
                ActivityData activityData5 = (ActivityData) c12092.L$0;
                ResultKt.throwOnFailure(obj);
                str6 = str10;
                activityData4 = activityData5;
                str5 = str11;
                str = str12;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource8;
                type = activityData4.getType();
                c12092.L$0 = null;
                c12092.L$1 = null;
                c12092.L$2 = null;
                c12092.L$3 = null;
                c12092.L$4 = null;
                c12092.L$5 = null;
                c12092.label = 5;
                if (userActionProcessorRemoteDataSource3.sendActivityData(str7, str, str5, str6, (String) obj, type, c12092) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 5) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        String authorization = UserExtensionsKt.getAuthorization((User) obj);
        c12092.L$0 = userActionProcessorRepository;
        c12092.L$1 = activityData2;
        c12092.L$2 = userActionProcessorRemoteDataSource;
        c12092.L$3 = authorization;
        c12092.L$4 = str;
        c12092.label = 2;
        Object user2 = userActionProcessorRepository.getUser(c12092);
        if (user2 == coroutine_suspended) {
            return coroutine_suspended;
        }
        ActivityData activityData6 = activityData2;
        str2 = authorization;
        obj = user2;
        activityData3 = activityData6;
        id = ((User) obj).getId();
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource4 = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c12092.L$0 = userActionProcessorRepository;
        c12092.L$1 = activityData3;
        c12092.L$2 = userActionProcessorRemoteDataSource;
        c12092.L$3 = str2;
        c12092.L$4 = str;
        c12092.L$5 = id;
        c12092.label = 3;
        clientId = userActionProcessorLocalDataSource4.getClientId(c12092);
        if (clientId == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
        str3 = id;
        obj = clientId;
        str4 = (String) obj;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource5 = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c12092.L$0 = activityData3;
        c12092.L$1 = userActionProcessorRemoteDataSource2;
        c12092.L$2 = str2;
        c12092.L$3 = str;
        c12092.L$4 = str3;
        c12092.L$5 = str4;
        c12092.label = 4;
        pushToken = userActionProcessorLocalDataSource5.getPushToken(c12092);
        if (pushToken == coroutine_suspended) {
            return coroutine_suspended;
        }
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource9 = userActionProcessorRemoteDataSource2;
        str5 = str3;
        activityData4 = activityData3;
        str6 = str4;
        obj = pushToken;
        str7 = str2;
        userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource9;
        type = activityData4.getType();
        c12092.L$0 = null;
        c12092.L$1 = null;
        c12092.L$2 = null;
        c12092.L$3 = null;
        c12092.L$4 = null;
        c12092.L$5 = null;
        c12092.label = 5;
        if (userActionProcessorRemoteDataSource3.sendActivityData(str7, str, str5, str6, (String) obj, type, c12092) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object processActivityEventReceived(ActivityEvent activityEvent, Continuation<? super Conversation> continuation) {
        C12011 c12011;
        UserActionProcessorRepository userActionProcessorRepository;
        if (continuation instanceof C12011) {
            c12011 = (C12011) continuation;
            if ((c12011.label & Integer.MIN_VALUE) != 0) {
                c12011.label -= Integer.MIN_VALUE;
            } else {
                c12011 = new C12011(continuation);
            }
        } else {
            c12011 = new C12011(continuation);
        }
        Object persistedConversation = c12011.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12011.label;
        if (i == 0) {
            ResultKt.throwOnFailure(persistedConversation);
            String conversationId = activityEvent.getConversationId();
            c12011.L$0 = this;
            c12011.L$1 = activityEvent;
            c12011.label = 1;
            persistedConversation = getPersistedConversation(conversationId, c12011);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
        } else {
            if (i != 1) {
                if (i == 2) {
                    ResultKt.throwOnFailure(persistedConversation);
                    return (Conversation) persistedConversation;
                }
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(persistedConversation);
                return (Conversation) persistedConversation;
            }
            activityEvent = (ActivityEvent) c12011.L$1;
            userActionProcessorRepository = (UserActionProcessorRepository) c12011.L$0;
            ResultKt.throwOnFailure(persistedConversation);
        }
        Conversation conversation = (Conversation) persistedConversation;
        ActivityData activityData = activityEvent.getActivityData();
        int i2 = activityData == null ? -1 : WhenMappings.$EnumSwitchMapping$0[activityData.ordinal()];
        if (i2 == 1) {
            c12011.L$0 = null;
            c12011.L$1 = null;
            c12011.label = 2;
            persistedConversation = userActionProcessorRepository.processConversationReadActivity(activityEvent, c12011);
            if (persistedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            return (Conversation) persistedConversation;
        }
        if (i2 != 2 && i2 != 3 && i2 != 4) {
            return conversation;
        }
        String conversationId2 = activityEvent.getConversationId();
        c12011.L$0 = null;
        c12011.L$1 = null;
        c12011.label = 3;
        persistedConversation = userActionProcessorRepository.processConversationRoutingActivity(activityEvent, conversationId2, c12011);
        if (persistedConversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        return (Conversation) persistedConversation;
    }

    public final Object processConversationReadActivity(ActivityEvent activityEvent, Continuation<? super Conversation> continuation) throws Throwable {
        C12021 c12021;
        UserActionProcessorRepository userActionProcessorRepository;
        Conversation conversation;
        Conversation conversation2;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource;
        Object user;
        UserActionProcessorRepository userActionProcessorRepository2;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2;
        Conversation conversation3;
        Conversation conversation4;
        if (continuation instanceof C12021) {
            c12021 = (C12021) continuation;
            if ((c12021.label & Integer.MIN_VALUE) != 0) {
                c12021.label -= Integer.MIN_VALUE;
            } else {
                c12021 = new C12021(continuation);
            }
        } else {
            c12021 = new C12021(continuation);
        }
        Object objUpdateConversationParticipants = c12021.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12021.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objUpdateConversationParticipants);
            if (activityEvent.getRole() == null) {
                throw new IllegalArgumentException("Unable to process conversation read activity the activity role is null".toString());
            }
            AuthorType role = activityEvent.getRole();
            int i2 = role == null ? -1 : WhenMappings.$EnumSwitchMapping$1[role.ordinal()];
            if (i2 == 1) {
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
                String conversationId = activityEvent.getConversationId();
                LocalDateTime lastRead = activityEvent.getLastRead();
                String userId = activityEvent.getUserId();
                c12021.L$0 = this;
                c12021.label = 1;
                objUpdateConversationParticipants = userActionProcessorInMemoryDataSource.updateConversationParticipants(conversationId, userId, lastRead, c12021);
                if (objUpdateConversationParticipants == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository = this;
                conversation = (Conversation) objUpdateConversationParticipants;
                conversation2 = conversation;
                userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12021.L$0 = userActionProcessorRepository;
                c12021.L$1 = conversation2;
                c12021.L$2 = userActionProcessorLocalDataSource;
                c12021.label = 3;
                user = userActionProcessorRepository.getUser(c12021);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                userActionProcessorLocalDataSource2 = userActionProcessorLocalDataSource;
                objUpdateConversationParticipants = user;
                conversation3 = conversation2;
                c12021.L$0 = userActionProcessorRepository2;
                c12021.L$1 = conversation3;
                c12021.L$2 = null;
                c12021.label = 4;
                if (userActionProcessorLocalDataSource2.updateUser((User) objUpdateConversationParticipants, c12021) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
            } else {
                if (i2 != 2) {
                    throw new NoWhenBranchMatchedException();
                }
                UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource2 = this.userActionProcessorInMemoryDataSource;
                String conversationId2 = activityEvent.getConversationId();
                LocalDateTime lastRead2 = activityEvent.getLastRead();
                c12021.L$0 = this;
                c12021.label = 2;
                objUpdateConversationParticipants = userActionProcessorInMemoryDataSource2.updateConversationBusinessLastRead(conversationId2, lastRead2, c12021);
                if (objUpdateConversationParticipants == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository = this;
                conversation = (Conversation) objUpdateConversationParticipants;
                conversation2 = conversation;
                userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12021.L$0 = userActionProcessorRepository;
                c12021.L$1 = conversation2;
                c12021.L$2 = userActionProcessorLocalDataSource;
                c12021.label = 3;
                user = userActionProcessorRepository.getUser(c12021);
                if (user == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRepository2 = userActionProcessorRepository;
                userActionProcessorLocalDataSource2 = userActionProcessorLocalDataSource;
                objUpdateConversationParticipants = user;
                conversation3 = conversation2;
                c12021.L$0 = userActionProcessorRepository2;
                c12021.L$1 = conversation3;
                c12021.L$2 = null;
                c12021.label = 4;
                if (userActionProcessorLocalDataSource2.updateUser((User) objUpdateConversationParticipants, c12021) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversation4 = conversation3;
            }
        } else if (i == 1) {
            userActionProcessorRepository = (UserActionProcessorRepository) c12021.L$0;
            ResultKt.throwOnFailure(objUpdateConversationParticipants);
            conversation = (Conversation) objUpdateConversationParticipants;
            conversation2 = conversation;
            userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
            c12021.L$0 = userActionProcessorRepository;
            c12021.L$1 = conversation2;
            c12021.L$2 = userActionProcessorLocalDataSource;
            c12021.label = 3;
            user = userActionProcessorRepository.getUser(c12021);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository2 = userActionProcessorRepository;
            userActionProcessorLocalDataSource2 = userActionProcessorLocalDataSource;
            objUpdateConversationParticipants = user;
            conversation3 = conversation2;
            c12021.L$0 = userActionProcessorRepository2;
            c12021.L$1 = conversation3;
            c12021.L$2 = null;
            c12021.label = 4;
            if (userActionProcessorLocalDataSource2.updateUser((User) objUpdateConversationParticipants, c12021) == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversation4 = conversation3;
        } else if (i == 2) {
            userActionProcessorRepository = (UserActionProcessorRepository) c12021.L$0;
            ResultKt.throwOnFailure(objUpdateConversationParticipants);
            conversation = (Conversation) objUpdateConversationParticipants;
            conversation2 = conversation;
            userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
            c12021.L$0 = userActionProcessorRepository;
            c12021.L$1 = conversation2;
            c12021.L$2 = userActionProcessorLocalDataSource;
            c12021.label = 3;
            user = userActionProcessorRepository.getUser(c12021);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository2 = userActionProcessorRepository;
            userActionProcessorLocalDataSource2 = userActionProcessorLocalDataSource;
            objUpdateConversationParticipants = user;
            conversation3 = conversation2;
            c12021.L$0 = userActionProcessorRepository2;
            c12021.L$1 = conversation3;
            c12021.L$2 = null;
            c12021.label = 4;
            if (userActionProcessorLocalDataSource2.updateUser((User) objUpdateConversationParticipants, c12021) == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversation4 = conversation3;
        } else if (i == 3) {
            userActionProcessorLocalDataSource2 = (UserActionProcessorLocalDataSource) c12021.L$2;
            Conversation conversation5 = (Conversation) c12021.L$1;
            UserActionProcessorRepository userActionProcessorRepository3 = (UserActionProcessorRepository) c12021.L$0;
            ResultKt.throwOnFailure(objUpdateConversationParticipants);
            conversation3 = conversation5;
            userActionProcessorRepository2 = userActionProcessorRepository3;
            c12021.L$0 = userActionProcessorRepository2;
            c12021.L$1 = conversation3;
            c12021.L$2 = null;
            c12021.label = 4;
            if (userActionProcessorLocalDataSource2.updateUser((User) objUpdateConversationParticipants, c12021) == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversation4 = conversation3;
        } else {
            if (i != 4) {
                if (i != 5) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                Conversation conversation6 = (Conversation) c12021.L$0;
                ResultKt.throwOnFailure(objUpdateConversationParticipants);
                return conversation6;
            }
            conversation4 = (Conversation) c12021.L$1;
            userActionProcessorRepository2 = (UserActionProcessorRepository) c12021.L$0;
            ResultKt.throwOnFailure(objUpdateConversationParticipants);
        }
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository2.userActionProcessorLocalDataSource;
        c12021.L$0 = conversation4;
        c12021.L$1 = null;
        c12021.label = 5;
        return userActionProcessorLocalDataSource3.saveConversation(conversation4, c12021) == coroutine_suspended ? coroutine_suspended : conversation4;
    }

    public final Object processConversationRoutingActivity(ActivityEvent activityEvent, String str, Continuation<? super Conversation> continuation) throws Throwable {
        C12031 c12031;
        UserActionProcessorRepository userActionProcessorRepository;
        if (continuation instanceof C12031) {
            c12031 = (C12031) continuation;
            if ((c12031.label & Integer.MIN_VALUE) != 0) {
                c12031.label -= Integer.MIN_VALUE;
            } else {
                c12031 = new C12031(continuation);
            }
        } else {
            c12031 = new C12031(continuation);
        }
        Object objUpdateConversationRoutingStatus = c12031.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12031.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objUpdateConversationRoutingStatus);
            UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
            c12031.L$0 = this;
            c12031.label = 1;
            objUpdateConversationRoutingStatus = userActionProcessorInMemoryDataSource.updateConversationRoutingStatus(activityEvent, str, c12031);
            if (objUpdateConversationRoutingStatus == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
        } else {
            if (i != 1) {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                Conversation conversation = (Conversation) c12031.L$0;
                ResultKt.throwOnFailure(objUpdateConversationRoutingStatus);
                return conversation;
            }
            userActionProcessorRepository = (UserActionProcessorRepository) c12031.L$0;
            ResultKt.throwOnFailure(objUpdateConversationRoutingStatus);
        }
        Conversation conversation2 = (Conversation) objUpdateConversationRoutingStatus;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c12031.L$0 = conversation2;
        c12031.label = 2;
        return userActionProcessorLocalDataSource.saveConversation(conversation2, c12031) == coroutine_suspended ? coroutine_suspended : conversation2;
    }

    public final Object updatePushToken(String str, Continuation<? super Unit> continuation) throws Throwable {
        C12191 c12191;
        UserActionProcessorRepository userActionProcessorRepository;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String str2;
        String str3;
        if (continuation instanceof C12191) {
            c12191 = (C12191) continuation;
            if ((c12191.label & Integer.MIN_VALUE) != 0) {
                c12191.label -= Integer.MIN_VALUE;
            } else {
                c12191 = new C12191(continuation);
            }
        } else {
            c12191 = new C12191(continuation);
        }
        Object obj = c12191.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12191.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2 = this.userActionProcessorRemoteDataSource;
            c12191.L$0 = this;
            c12191.L$1 = str;
            c12191.L$2 = userActionProcessorRemoteDataSource2;
            c12191.label = 1;
            Object user = getUser(c12191);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
            userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource2;
            obj = user;
        } else {
            if (i == 1) {
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3 = (UserActionProcessorRemoteDataSource) c12191.L$2;
                String str4 = (String) c12191.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12191.L$0;
                ResultKt.throwOnFailure(obj);
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource3;
                str = str4;
            } else if (i == 2) {
                str3 = (String) c12191.L$2;
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12191.L$1;
                str2 = (String) c12191.L$0;
                ResultKt.throwOnFailure(obj);
                c12191.L$0 = null;
                c12191.L$1 = null;
                c12191.L$2 = null;
                c12191.label = 3;
                if (userActionProcessorRemoteDataSource.updatePushToken(str3, (String) obj, str2, c12191) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        String authorization = UserExtensionsKt.getAuthorization((User) obj);
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c12191.L$0 = str;
        c12191.L$1 = userActionProcessorRemoteDataSource;
        c12191.L$2 = authorization;
        c12191.label = 2;
        Object clientId = userActionProcessorLocalDataSource.getClientId(c12191);
        if (clientId == coroutine_suspended) {
            return coroutine_suspended;
        }
        str2 = str;
        str3 = authorization;
        obj = clientId;
        c12191.L$0 = null;
        c12191.L$1 = null;
        c12191.L$2 = null;
        c12191.label = 3;
        if (userActionProcessorRemoteDataSource.updatePushToken(str3, (String) obj, str2, c12191) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object sendPostbackAction(String str, String str2, Continuation<? super Unit> continuation) throws Throwable {
        C12131 c12131;
        UserActionProcessorRepository userActionProcessorRepository;
        String str3;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        String str4;
        String str5;
        String str6;
        String id;
        Object clientId;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2;
        String str7;
        String str8;
        Object pushToken;
        String str9;
        String str10;
        String str11;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource3;
        String str12;
        if (continuation instanceof C12131) {
            c12131 = (C12131) continuation;
            if ((c12131.label & Integer.MIN_VALUE) != 0) {
                c12131.label -= Integer.MIN_VALUE;
            } else {
                c12131 = new C12131(continuation);
            }
        } else {
            c12131 = new C12131(continuation);
        }
        C12131 c12132 = c12131;
        Object obj = c12132.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12132.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource4 = this.userActionProcessorRemoteDataSource;
            c12132.L$0 = this;
            c12132.L$1 = str;
            c12132.L$2 = str2;
            c12132.L$3 = userActionProcessorRemoteDataSource4;
            c12132.label = 1;
            Object user = getUser(c12132);
            if (user == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorRepository = this;
            str3 = str;
            userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource4;
            obj = user;
        } else {
            if (i == 1) {
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c12132.L$3;
                str2 = (String) c12132.L$2;
                str3 = (String) c12132.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12132.L$0;
                ResultKt.throwOnFailure(obj);
            } else if (i == 2) {
                String str13 = (String) c12132.L$4;
                String str14 = (String) c12132.L$3;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource5 = (UserActionProcessorRemoteDataSource) c12132.L$2;
                str4 = (String) c12132.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12132.L$0;
                ResultKt.throwOnFailure(obj);
                str5 = str13;
                userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource5;
                str6 = str14;
                id = ((User) obj).getId();
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12132.L$0 = userActionProcessorRepository;
                c12132.L$1 = str4;
                c12132.L$2 = userActionProcessorRemoteDataSource;
                c12132.L$3 = str6;
                c12132.L$4 = str5;
                c12132.L$5 = id;
                c12132.label = 3;
                clientId = userActionProcessorLocalDataSource.getClientId(c12132);
                if (clientId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
                str7 = id;
                obj = clientId;
                str8 = (String) obj;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource2 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12132.L$0 = str4;
                c12132.L$1 = userActionProcessorRemoteDataSource2;
                c12132.L$2 = str6;
                c12132.L$3 = str5;
                c12132.L$4 = str7;
                c12132.L$5 = str8;
                c12132.label = 4;
                pushToken = userActionProcessorLocalDataSource2.getPushToken(c12132);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str9 = str4;
                str10 = str8;
                obj = pushToken;
                str11 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str12 = str7;
                c12132.L$0 = null;
                c12132.L$1 = null;
                c12132.L$2 = null;
                c12132.L$3 = null;
                c12132.L$4 = null;
                c12132.L$5 = null;
                c12132.label = 5;
                if (userActionProcessorRemoteDataSource3.sendPostbackAction(str11, str5, str12, str10, (String) obj, str9, c12132) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 3) {
                str7 = (String) c12132.L$5;
                str5 = (String) c12132.L$4;
                str6 = (String) c12132.L$3;
                userActionProcessorRemoteDataSource2 = (UserActionProcessorRemoteDataSource) c12132.L$2;
                str4 = (String) c12132.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12132.L$0;
                ResultKt.throwOnFailure(obj);
                str8 = (String) obj;
                UserActionProcessorLocalDataSource userActionProcessorLocalDataSource3 = userActionProcessorRepository.userActionProcessorLocalDataSource;
                c12132.L$0 = str4;
                c12132.L$1 = userActionProcessorRemoteDataSource2;
                c12132.L$2 = str6;
                c12132.L$3 = str5;
                c12132.L$4 = str7;
                c12132.L$5 = str8;
                c12132.label = 4;
                pushToken = userActionProcessorLocalDataSource3.getPushToken(c12132);
                if (pushToken == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str9 = str4;
                str10 = str8;
                obj = pushToken;
                str11 = str6;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
                str12 = str7;
                c12132.L$0 = null;
                c12132.L$1 = null;
                c12132.L$2 = null;
                c12132.L$3 = null;
                c12132.L$4 = null;
                c12132.L$5 = null;
                c12132.label = 5;
                if (userActionProcessorRemoteDataSource3.sendPostbackAction(str11, str5, str12, str10, (String) obj, str9, c12132) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 4) {
                String str15 = (String) c12132.L$5;
                String str16 = (String) c12132.L$4;
                String str17 = (String) c12132.L$3;
                str11 = (String) c12132.L$2;
                UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource6 = (UserActionProcessorRemoteDataSource) c12132.L$1;
                String str18 = (String) c12132.L$0;
                ResultKt.throwOnFailure(obj);
                str9 = str18;
                str10 = str15;
                str12 = str16;
                str5 = str17;
                userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource6;
                c12132.L$0 = null;
                c12132.L$1 = null;
                c12132.L$2 = null;
                c12132.L$3 = null;
                c12132.L$4 = null;
                c12132.L$5 = null;
                c12132.label = 5;
                if (userActionProcessorRemoteDataSource3.sendPostbackAction(str11, str5, str12, str10, (String) obj, str9, c12132) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 5) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        String authorization = UserExtensionsKt.getAuthorization((User) obj);
        c12132.L$0 = userActionProcessorRepository;
        c12132.L$1 = str2;
        c12132.L$2 = userActionProcessorRemoteDataSource;
        c12132.L$3 = authorization;
        c12132.L$4 = str3;
        c12132.label = 2;
        Object user2 = userActionProcessorRepository.getUser(c12132);
        if (user2 == coroutine_suspended) {
            return coroutine_suspended;
        }
        str4 = str2;
        str5 = str3;
        str6 = authorization;
        obj = user2;
        id = ((User) obj).getId();
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource4 = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c12132.L$0 = userActionProcessorRepository;
        c12132.L$1 = str4;
        c12132.L$2 = userActionProcessorRemoteDataSource;
        c12132.L$3 = str6;
        c12132.L$4 = str5;
        c12132.L$5 = id;
        c12132.label = 3;
        clientId = userActionProcessorLocalDataSource4.getClientId(c12132);
        if (clientId == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRemoteDataSource2 = userActionProcessorRemoteDataSource;
        str7 = id;
        obj = clientId;
        str8 = (String) obj;
        UserActionProcessorLocalDataSource userActionProcessorLocalDataSource5 = userActionProcessorRepository.userActionProcessorLocalDataSource;
        c12132.L$0 = str4;
        c12132.L$1 = userActionProcessorRemoteDataSource2;
        c12132.L$2 = str6;
        c12132.L$3 = str5;
        c12132.L$4 = str7;
        c12132.L$5 = str8;
        c12132.label = 4;
        pushToken = userActionProcessorLocalDataSource5.getPushToken(c12132);
        if (pushToken == coroutine_suspended) {
            return coroutine_suspended;
        }
        str9 = str4;
        str10 = str8;
        obj = pushToken;
        str11 = str6;
        userActionProcessorRemoteDataSource3 = userActionProcessorRemoteDataSource2;
        str12 = str7;
        c12132.L$0 = null;
        c12132.L$1 = null;
        c12132.L$2 = null;
        c12132.L$3 = null;
        c12132.L$4 = null;
        c12132.L$5 = null;
        c12132.label = 5;
        if (userActionProcessorRemoteDataSource3.sendPostbackAction(str11, str5, str12, str10, (String) obj, str9, c12132) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object setVisitType(VisitType visitType, Continuation<? super Unit> continuation) {
        Object visitType2 = this.userActionProcessorLocalDataSource.setVisitType(visitType, continuation);
        return visitType2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? visitType2 : Unit.INSTANCE;
    }

    public final Object getVisitType(Continuation<? super VisitType> continuation) {
        return this.userActionProcessorLocalDataSource.getVisitType(continuation);
    }

    public final Object setPushToken(String str, Continuation<? super Unit> continuation) {
        Object pushToken = this.userActionProcessorLocalDataSource.setPushToken(str, continuation);
        return pushToken == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? pushToken : Unit.INSTANCE;
    }

    public final Object setIntegrationId(String str, Continuation<? super Unit> continuation) {
        Object integrationId = this.userActionProcessorLocalDataSource.setIntegrationId(str, continuation);
        return integrationId == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? integrationId : Unit.INSTANCE;
    }

    public final Object setProactiveMessage(ProactiveMessage proactiveMessage, Continuation<? super Unit> continuation) {
        Object proactiveMessage2 = this.userActionProcessorLocalDataSource.setProactiveMessage(proactiveMessage, continuation);
        return proactiveMessage2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? proactiveMessage2 : Unit.INSTANCE;
    }

    public final Object getProactiveMessage(int i, Continuation<? super ProactiveMessage> continuation) {
        C11951 c11951;
        if (continuation instanceof C11951) {
            c11951 = (C11951) continuation;
            if ((c11951.label & Integer.MIN_VALUE) != 0) {
                c11951.label -= Integer.MIN_VALUE;
            } else {
                c11951 = new C11951(continuation);
            }
        } else {
            c11951 = new C11951(continuation);
        }
        Object proactiveMessage = c11951.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c11951.label;
        if (i2 == 0) {
            ResultKt.throwOnFailure(proactiveMessage);
            UserActionProcessorLocalDataSource userActionProcessorLocalDataSource = this.userActionProcessorLocalDataSource;
            c11951.label = 1;
            proactiveMessage = userActionProcessorLocalDataSource.getProactiveMessage(i, c11951);
            if (proactiveMessage == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i2 != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(proactiveMessage);
        }
        ProactiveMessage proactiveMessage2 = (ProactiveMessage) proactiveMessage;
        if (proactiveMessage2 != null) {
            return proactiveMessage2;
        }
        throw new ProactiveMessageNotFoundException();
    }

    public final Object clearProactiveMessage(int i, Continuation<? super Unit> continuation) {
        Object objClearProactiveMessage = this.userActionProcessorLocalDataSource.clearProactiveMessage(i, continuation);
        return objClearProactiveMessage == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClearProactiveMessage : Unit.INSTANCE;
    }

    public final Object updateDownloadingAttachment(String str, Message message, Continuation<? super Conversation> continuation) {
        C12181 c12181;
        UserActionProcessorRepository userActionProcessorRepository;
        if (continuation instanceof C12181) {
            c12181 = (C12181) continuation;
            if ((c12181.label & Integer.MIN_VALUE) != 0) {
                c12181.label -= Integer.MIN_VALUE;
            } else {
                c12181 = new C12181(continuation);
            }
        } else {
            c12181 = new C12181(continuation);
        }
        Object persistedConversation = c12181.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12181.label;
        if (i != 0) {
            if (i == 1) {
                message = (Message) c12181.L$2;
                str = (String) c12181.L$1;
                userActionProcessorRepository = (UserActionProcessorRepository) c12181.L$0;
                ResultKt.throwOnFailure(persistedConversation);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(persistedConversation);
            }
        }
        ResultKt.throwOnFailure(persistedConversation);
        c12181.L$0 = this;
        c12181.L$1 = str;
        c12181.L$2 = message;
        c12181.label = 1;
        persistedConversation = getPersistedConversation(str, c12181);
        if (persistedConversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        userActionProcessorRepository = this;
        if (((Conversation) persistedConversation) == null) {
            throw new ConversationNotFoundException();
        }
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = userActionProcessorRepository.userActionProcessorInMemoryDataSource;
        c12181.L$0 = null;
        c12181.L$1 = null;
        c12181.L$2 = null;
        c12181.label = 2;
        persistedConversation = userActionProcessorInMemoryDataSource.updateDownloadingAttachment(str, message, c12181);
        return persistedConversation == coroutine_suspended ? coroutine_suspended : persistedConversation;
    }

    public final Object updateDownloadingStatusSuccess(String str, String str2, String str3, Continuation<? super Conversation> continuation) {
        return this.userActionProcessorInMemoryDataSource.updateDownloadingStatus(str, new MessageStatus.Sent(null, 1, 0 == true ? 1 : 0), str2, str3, continuation);
    }

    public final Object updateDownloadingStatusFailed(String str, String str2, String str3, Continuation<? super Conversation> continuation) {
        return this.userActionProcessorInMemoryDataSource.updateDownloadingStatus(str, new MessageStatus.DownloadFailed(null, 1, 0 == true ? 1 : 0), str2, str3, continuation);
    }

    public final Object getWaitTimeForConversation(String str, Continuation<? super WaitTimeDataResponse> continuation) {
        C11971 c11971;
        String str2;
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource;
        if (continuation instanceof C11971) {
            c11971 = (C11971) continuation;
            if ((c11971.label & Integer.MIN_VALUE) != 0) {
                c11971.label -= Integer.MIN_VALUE;
            } else {
                c11971 = new C11971(continuation);
            }
        } else {
            c11971 = new C11971(continuation);
        }
        Object objFetchWaitTimeData = c11971.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11971.label;
        if (i != 0) {
            if (i == 1) {
                userActionProcessorRemoteDataSource = (UserActionProcessorRemoteDataSource) c11971.L$1;
                str2 = (String) c11971.L$0;
                ResultKt.throwOnFailure(objFetchWaitTimeData);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objFetchWaitTimeData);
            }
        }
        ResultKt.throwOnFailure(objFetchWaitTimeData);
        UserActionProcessorRemoteDataSource userActionProcessorRemoteDataSource2 = this.userActionProcessorRemoteDataSource;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource = this.userActionProcessorInMemoryDataSource;
        c11971.L$0 = str;
        c11971.L$1 = userActionProcessorRemoteDataSource2;
        c11971.label = 1;
        Object user = userActionProcessorInMemoryDataSource.getUser(c11971);
        if (user == coroutine_suspended) {
            return coroutine_suspended;
        }
        str2 = str;
        userActionProcessorRemoteDataSource = userActionProcessorRemoteDataSource2;
        objFetchWaitTimeData = user;
        String authorization = UserExtensionsKt.getAuthorization((User) objFetchWaitTimeData);
        c11971.L$0 = null;
        c11971.L$1 = null;
        c11971.label = 2;
        objFetchWaitTimeData = userActionProcessorRemoteDataSource.fetchWaitTimeData(authorization, str2, c11971);
        return objFetchWaitTimeData == coroutine_suspended ? coroutine_suspended : objFetchWaitTimeData;
    }
}
