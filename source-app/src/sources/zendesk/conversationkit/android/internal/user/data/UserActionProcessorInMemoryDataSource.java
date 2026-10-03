package zendesk.conversationkit.android.internal.user.data;

import j$.time.Duration;
import j$.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlin.text.StringsKt;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;
import zendesk.conversationkit.android.internal.exception.ConversationNotFoundException;
import zendesk.conversationkit.android.internal.exception.MessageAlreadyInConversationException;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.ActivityDataKt;
import zendesk.conversationkit.android.model.ActivityEvent;
import zendesk.conversationkit.android.model.Author;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationRoutingStatus;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageKt;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.conversationkit.android.model.Participant;
import zendesk.conversationkit.android.model.User;
import zendesk.core.android.internal.FileKtxKt;

@Metadata(m17d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010$\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0007\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u0004¢\u0006\u0004\b\b\u0010\tJ\u0017\u0010\u000b\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u0006H\u0002¢\u0006\u0004\b\u000b\u0010\fJ-\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\n\u001a\u00020\u00062\u0014\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0001\u0018\u00010\rH\u0002¢\u0006\u0004\b\u0010\u0010\u0011J-\u0010\u0012\u001a\u00020\u000f2\u0006\u0010\n\u001a\u00020\u00062\u0014\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0001\u0018\u00010\rH\u0002¢\u0006\u0004\b\u0012\u0010\u0011J\u0017\u0010\u0013\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u0006H\u0002¢\u0006\u0004\b\u0013\u0010\fJ\u0017\u0010\u0014\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u0006H\u0002¢\u0006\u0004\b\u0014\u0010\fJ\u0017\u0010\u0015\u001a\u00020\u00022\u0006\u0010\n\u001a\u00020\u0006H\u0002¢\u0006\u0004\b\u0015\u0010\u0016J\u001f\u0010\u0019\u001a\u00020\u00172\u0006\u0010\n\u001a\u00020\u00062\u0006\u0010\u0018\u001a\u00020\u0017H\u0002¢\u0006\u0004\b\u0019\u0010\u001aJ\u0010\u0010\u001b\u001a\u00020\u0002H\u0086@¢\u0006\u0004\b\u001b\u0010\u001cJ\u0018\u0010\u001e\u001a\u00020\u000f2\u0006\u0010\u001d\u001a\u00020\u0002H\u0086@¢\u0006\u0004\b\u001e\u0010\u001fJ\u001a\u0010!\u001a\u0004\u0018\u00010\u00062\u0006\u0010 \u001a\u00020\u0005H\u0086@¢\u0006\u0004\b!\u0010\"J\u0018\u0010#\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u0006H\u0086@¢\u0006\u0004\b#\u0010$J.\u0010%\u001a\u00020\u000f2\u0006\u0010\n\u001a\u00020\u00062\u0014\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0001\u0018\u00010\rH\u0086@¢\u0006\u0004\b%\u0010&J\u0010\u0010(\u001a\u00020'H\u0086@¢\u0006\u0004\b(\u0010\u001cJ\u0018\u0010*\u001a\u00020\u000f2\u0006\u0010)\u001a\u00020'H\u0086@¢\u0006\u0004\b*\u0010+J.\u00100\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00052\f\u0010.\u001a\b\u0012\u0004\u0012\u00020-0,2\u0006\u0010/\u001a\u00020'H\u0086@¢\u0006\u0004\b0\u00101J \u00103\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00052\u0006\u00102\u001a\u00020-H\u0086@¢\u0006\u0004\b3\u00104J \u00106\u001a\u00020-2\u0006\u0010 \u001a\u00020\u00052\u0006\u00105\u001a\u00020-H\u0086@¢\u0006\u0004\b6\u00104J(\u00109\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00052\u0006\u00107\u001a\u00020-2\u0006\u00108\u001a\u00020\u0005H\u0086@¢\u0006\u0004\b9\u0010:J\"\u0010<\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00052\b\u0010;\u001a\u0004\u0018\u00010\u0017H\u0086@¢\u0006\u0004\b<\u0010=J,\u0010?\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00052\b\u0010>\u001a\u0004\u0018\u00010\u00052\b\u0010;\u001a\u0004\u0018\u00010\u0017H\u0086@¢\u0006\u0004\b?\u0010@J\u0016\u0010A\u001a\b\u0012\u0004\u0012\u00020\u00060,H\u0086@¢\u0006\u0004\bA\u0010\u001cJ\u001e\u0010C\u001a\u00020\u000f2\f\u0010B\u001a\b\u0012\u0004\u0012\u00020\u00060,H\u0086@¢\u0006\u0004\bC\u0010DJ \u0010G\u001a\u00020\u00062\u0006\u0010F\u001a\u00020E2\u0006\u0010 \u001a\u00020\u0005H\u0086@¢\u0006\u0004\bG\u0010HJ \u0010I\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00052\u0006\u00105\u001a\u00020-H\u0086@¢\u0006\u0004\bI\u00104J0\u0010N\u001a\u00020\u00062\u0006\u0010J\u001a\u00020\u00052\u0006\u0010L\u001a\u00020K2\u0006\u0010M\u001a\u00020\u00052\u0006\u0010 \u001a\u00020\u0005H\u0086@¢\u0006\u0004\bN\u0010OR\u0016\u0010\u0003\u001a\u00020\u00028\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b\u0003\u0010PR \u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0007\u0010QR\u0016\u0010(\u001a\u00020'8\u0002@\u0002X\u0082\u000e¢\u0006\u0006\n\u0004\b(\u0010RR\u0014\u0010T\u001a\u00020S8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\bT\u0010U¨\u0006V"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/data/UserActionProcessorInMemoryDataSource;", "", "Lzendesk/conversationkit/android/model/User;", "user", "", "", "Lzendesk/conversationkit/android/model/Conversation;", "conversations", "<init>", "(Lzendesk/conversationkit/android/model/User;Ljava/util/Map;)V", "conversation", "saveConversationAsynchronously", "(Lzendesk/conversationkit/android/model/Conversation;)Lzendesk/conversationkit/android/model/Conversation;", "", "metadata", "", "updateUserConversationsMetadata", "(Lzendesk/conversationkit/android/model/Conversation;Ljava/util/Map;)V", "updateInMemoryConversationsMetadata", "sortAndCommitConversationToMemory", "updateInMemoryConversationAsynchronously", "updateUserConversationsAsynchronously", "(Lzendesk/conversationkit/android/model/Conversation;)Lzendesk/conversationkit/android/model/User;", "j$/time/LocalDateTime", "fallbackTime", "messageCreatedAtDateTime", "(Lzendesk/conversationkit/android/model/Conversation;Lj$/time/LocalDateTime;)Lj$/time/LocalDateTime;", "getUser", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "newUser", "updateUser", "(Lzendesk/conversationkit/android/model/User;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "conversationId", "getConversation", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveConversation", "(Lzendesk/conversationkit/android/model/Conversation;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateConversationMetadata", "(Lzendesk/conversationkit/android/model/Conversation;Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "", "shouldReAuthenticateUser", "reAuthenticateUser", "updateReAuthenticateUser", "(ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "", "Lzendesk/conversationkit/android/model/Message;", "newMessages", "hasPrevious", "updateConversationMessages", "(Ljava/lang/String;Ljava/util/List;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "newMessage", "addMessageToConversationAndCommit", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "message", "createPendingMessage", "networkMessage", "messageLocalId", "replacePendingMessage", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "lastRead", "updateConversationBusinessLastRead", "(Ljava/lang/String;Lj$/time/LocalDateTime;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "userId", "updateConversationParticipants", "(Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversations", "newConversations", "saveConversations", "(Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lzendesk/conversationkit/android/model/ActivityEvent;", "activityEvent", "updateConversationRoutingStatus", "(Lzendesk/conversationkit/android/model/ActivityEvent;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateDownloadingAttachment", "fileName", "Lzendesk/conversationkit/android/model/MessageStatus;", "downloadStatus", "messageId", "updateDownloadingStatus", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/MessageStatus;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lzendesk/conversationkit/android/model/User;", "Ljava/util/Map;", "Z", "Lkotlinx/coroutines/sync/Mutex;", "persistenceMutex", "Lkotlinx/coroutines/sync/Mutex;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserActionProcessorInMemoryDataSource {
    private final Map<String, Conversation> conversations;
    private final Mutex persistenceMutex;
    private boolean shouldReAuthenticateUser;
    private User user;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0}, m39l = {667}, m40m = "addMessageToConversationAndCommit", m41n = {"this", "conversationId", "newMessage", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C11571 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11571(Continuation<? super C11571> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.addMessageToConversationAndCommit(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0}, m39l = {667}, m40m = "createPendingMessage", m41n = {"this", "conversationId", "message", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C11581 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11581(Continuation<? super C11581> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.createPendingMessage(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {667}, m40m = "getConversation", m41n = {"this", "conversationId", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C11591 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11591(Continuation<? super C11591> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.getConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0}, m39l = {667}, m40m = "getConversations", m41n = {"this", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1"})
    static final class C11601 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11601(Continuation<? super C11601> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.getConversations(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0}, m39l = {667}, m40m = "getUser", m41n = {"this", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1"})
    static final class C11611 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11611(Continuation<? super C11611> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.getUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0, 0}, m39l = {667}, m40m = "replacePendingMessage", m41n = {"this", "conversationId", "networkMessage", "messageLocalId", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4"})
    static final class C11621 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C11621(Continuation<? super C11621> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.replacePendingMessage(null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {667}, m40m = "saveConversation", m41n = {"this", "conversation", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C11631 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11631(Continuation<? super C11631> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.saveConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {667}, m40m = "saveConversations", m41n = {"this", "newConversations", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C11641 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11641(Continuation<? super C11641> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.saveConversations(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0}, m39l = {667}, m40m = "shouldReAuthenticateUser", m41n = {"this", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1"})
    static final class C11651 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11651(Continuation<? super C11651> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.shouldReAuthenticateUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0}, m39l = {667}, m40m = "updateConversationBusinessLastRead", m41n = {"this", "conversationId", "lastRead", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C11671 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11671(Continuation<? super C11671> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateConversationBusinessLastRead(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0, 0}, m39l = {667}, m40m = "updateConversationMessages", m41n = {"this", "conversationId", "newMessages", "$this$withLock_u24default$iv", "hasPrevious"}, m42s = {"L$0", "L$1", "L$2", "L$3", "Z$0"})
    static final class C11681 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        boolean Z$0;
        int label;
        Object result;

        C11681(Continuation<? super C11681> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateConversationMessages(null, null, false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0}, m39l = {667}, m40m = "updateConversationMetadata", m41n = {"this", "conversation", "metadata", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C11691 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11691(Continuation<? super C11691> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateConversationMetadata(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0, 0}, m39l = {667}, m40m = "updateConversationParticipants", m41n = {"this", "conversationId", "userId", "lastRead", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4"})
    static final class C11701 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C11701(Continuation<? super C11701> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateConversationParticipants(null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0}, m39l = {667}, m40m = "updateConversationRoutingStatus", m41n = {"this", "activityEvent", "conversationId", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C11711 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11711(Continuation<? super C11711> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateConversationRoutingStatus(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0}, m39l = {667}, m40m = "updateDownloadingAttachment", m41n = {"this", "conversationId", "message", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C11721 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C11721(Continuation<? super C11721> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateDownloadingAttachment(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0, 0, 0, 0}, m39l = {667}, m40m = "updateDownloadingStatus", m41n = {"this", "fileName", "downloadStatus", "messageId", "conversationId", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4", "L$5"})
    static final class C11731 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        int label;
        Object result;

        C11731(Continuation<? super C11731> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateDownloadingStatus(null, null, null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {667}, m40m = "updateReAuthenticateUser", m41n = {"this", "$this$withLock_u24default$iv", "reAuthenticateUser"}, m42s = {"L$0", "L$1", "Z$0"})
    static final class C11741 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        boolean Z$0;
        int label;
        Object result;

        C11741(Continuation<? super C11741> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateReAuthenticateUser(false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.user.data.UserActionProcessorInMemoryDataSource", m37f = "UserActionProcessorInMemoryDataSource.kt", m38i = {0, 0, 0}, m39l = {667}, m40m = "updateUser", m41n = {"this", "newUser", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C11751 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C11751(Continuation<? super C11751> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return UserActionProcessorInMemoryDataSource.this.updateUser(null, this);
        }
    }

    public UserActionProcessorInMemoryDataSource(User user, Map<String, Conversation> conversations) {
        Intrinsics.checkNotNullParameter(user, "user");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        this.user = user;
        this.conversations = conversations;
        this.persistenceMutex = MutexKt.Mutex$default(false, 1, null);
    }

    public UserActionProcessorInMemoryDataSource(User user, HashMap map, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(user, (i & 2) != 0 ? new HashMap() : map);
    }

    public final Object getUser(Continuation<? super User> continuation) {
        C11611 c11611;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Mutex mutex;
        if (continuation instanceof C11611) {
            c11611 = (C11611) continuation;
            if ((c11611.label & Integer.MIN_VALUE) != 0) {
                c11611.label -= Integer.MIN_VALUE;
            } else {
                c11611 = new C11611(continuation);
            }
        } else {
            c11611 = new C11611(continuation);
        }
        Object obj = c11611.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11611.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11611.L$0 = this;
            c11611.L$1 = mutex2;
            c11611.label = 1;
            if (mutex2.lock(null, c11611) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
            mutex = mutex2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11611.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11611.L$0;
            ResultKt.throwOnFailure(obj);
        }
        try {
            return userActionProcessorInMemoryDataSource.user;
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object updateUser(User user, Continuation<? super Unit> continuation) throws Throwable {
        C11751 c11751;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        if (continuation instanceof C11751) {
            c11751 = (C11751) continuation;
            if ((c11751.label & Integer.MIN_VALUE) != 0) {
                c11751.label -= Integer.MIN_VALUE;
            } else {
                c11751 = new C11751(continuation);
            }
        } else {
            c11751 = new C11751(continuation);
        }
        Object obj = c11751.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11751.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c11751.L$0 = this;
            c11751.L$1 = user;
            c11751.L$2 = mutex;
            c11751.label = 1;
            if (mutex.lock(null, c11751) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Mutex mutex2 = (Mutex) c11751.L$2;
            User user2 = (User) c11751.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11751.L$0;
            ResultKt.throwOnFailure(obj);
            mutex = mutex2;
            user = user2;
        }
        try {
            userActionProcessorInMemoryDataSource.user = user;
            return Unit.INSTANCE;
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object getConversation(String str, Continuation<? super Conversation> continuation) throws Throwable {
        C11591 c11591;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        if (continuation instanceof C11591) {
            c11591 = (C11591) continuation;
            if ((c11591.label & Integer.MIN_VALUE) != 0) {
                c11591.label -= Integer.MIN_VALUE;
            } else {
                c11591 = new C11591(continuation);
            }
        } else {
            c11591 = new C11591(continuation);
        }
        Object obj = c11591.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11591.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c11591.L$0 = this;
            c11591.L$1 = str;
            c11591.L$2 = mutex;
            c11591.label = 1;
            if (mutex.lock(null, c11591) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Mutex mutex2 = (Mutex) c11591.L$2;
            String str2 = (String) c11591.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11591.L$0;
            ResultKt.throwOnFailure(obj);
            mutex = mutex2;
            str = str2;
        }
        try {
            return userActionProcessorInMemoryDataSource.conversations.get(str);
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object saveConversation(Conversation conversation, Continuation<? super Conversation> continuation) {
        C11631 c11631;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        if (continuation instanceof C11631) {
            c11631 = (C11631) continuation;
            if ((c11631.label & Integer.MIN_VALUE) != 0) {
                c11631.label -= Integer.MIN_VALUE;
            } else {
                c11631 = new C11631(continuation);
            }
        } else {
            c11631 = new C11631(continuation);
        }
        Object obj = c11631.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11631.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c11631.L$0 = this;
            c11631.L$1 = conversation;
            c11631.L$2 = mutex;
            c11631.label = 1;
            if (mutex.lock(null, c11631) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Mutex mutex2 = (Mutex) c11631.L$2;
            Conversation conversation2 = (Conversation) c11631.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11631.L$0;
            ResultKt.throwOnFailure(obj);
            mutex = mutex2;
            conversation = conversation2;
        }
        try {
            return userActionProcessorInMemoryDataSource.saveConversationAsynchronously(conversation);
        } finally {
            mutex.unlock(null);
        }
    }

    private final Conversation saveConversationAsynchronously(Conversation conversation) {
        updateUserConversationsAsynchronously(conversation);
        return updateInMemoryConversationAsynchronously(conversation);
    }

    public final Object updateConversationMetadata(Conversation conversation, Map<String, ? extends Object> map, Continuation<? super Unit> continuation) throws Throwable {
        C11691 c11691;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        if (continuation instanceof C11691) {
            c11691 = (C11691) continuation;
            if ((c11691.label & Integer.MIN_VALUE) != 0) {
                c11691.label -= Integer.MIN_VALUE;
            } else {
                c11691 = new C11691(continuation);
            }
        } else {
            c11691 = new C11691(continuation);
        }
        Object obj = c11691.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11691.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c11691.L$0 = this;
            c11691.L$1 = conversation;
            c11691.L$2 = map;
            c11691.L$3 = mutex;
            c11691.label = 1;
            if (mutex.lock(null, c11691) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            Mutex mutex2 = (Mutex) c11691.L$3;
            map = (Map) c11691.L$2;
            Conversation conversation2 = (Conversation) c11691.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11691.L$0;
            ResultKt.throwOnFailure(obj);
            mutex = mutex2;
            conversation = conversation2;
        }
        try {
            userActionProcessorInMemoryDataSource.updateUserConversationsMetadata(conversation, map);
            userActionProcessorInMemoryDataSource.updateInMemoryConversationsMetadata(conversation, map);
            return Unit.INSTANCE;
        } finally {
            mutex.unlock(null);
        }
    }

    private final void updateUserConversationsMetadata(Conversation conversation, Map<String, ? extends Object> metadata) {
        List<Conversation> conversations = this.user.getConversations();
        ArrayList arrayList = new ArrayList();
        for (Object obj : conversations) {
            if (!Intrinsics.areEqual(((Conversation) obj).getId(), conversation.getId())) {
                arrayList.add(obj);
            }
        }
        List listPlus = CollectionsKt.plus((Collection<? extends Conversation>) arrayList, conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : null, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : metadata, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
        User user = this.user;
        this.user = user.copy((8063 & 1) != 0 ? user.id : null, (8063 & 2) != 0 ? user.externalId : null, (8063 & 4) != 0 ? user.givenName : null, (8063 & 8) != 0 ? user.surname : null, (8063 & 16) != 0 ? user.email : null, (8063 & 32) != 0 ? user.locale : null, (8063 & 64) != 0 ? user.signedUpAt : null, (8063 & 128) != 0 ? user.conversations : listPlus, (8063 & 256) != 0 ? user.realtimeSettings : null, (8063 & 512) != 0 ? user.typingSettings : null, (8063 & 1024) != 0 ? user.sessionToken : null, (8063 & 2048) != 0 ? user.jwt : null, (8063 & 4096) != 0 ? user.hasMore : false);
    }

    private final void updateInMemoryConversationsMetadata(Conversation conversation, Map<String, ? extends Object> metadata) {
        this.conversations.put(conversation.getId(), conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : null, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : metadata, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
    }

    private final Conversation sortAndCommitConversationToMemory(Conversation conversation) {
        Conversation conversationCopy = conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.sortedWith(conversation.getMessages(), new Comparator() {
            @Override
            public final int compare(T t, T t2) {
                return ComparisonsKt.compareValues(((Message) t).getTimestamp(), ((Message) t2).getTimestamp());
            }
        }), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null);
        this.conversations.put(conversation.getId(), conversationCopy);
        return conversationCopy;
    }

    public final Object shouldReAuthenticateUser(Continuation<? super Boolean> continuation) throws Throwable {
        C11651 c11651;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Mutex mutex;
        if (continuation instanceof C11651) {
            c11651 = (C11651) continuation;
            if ((c11651.label & Integer.MIN_VALUE) != 0) {
                c11651.label -= Integer.MIN_VALUE;
            } else {
                c11651 = new C11651(continuation);
            }
        } else {
            c11651 = new C11651(continuation);
        }
        Object obj = c11651.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11651.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11651.L$0 = this;
            c11651.L$1 = mutex2;
            c11651.label = 1;
            if (mutex2.lock(null, c11651) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
            mutex = mutex2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11651.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11651.L$0;
            ResultKt.throwOnFailure(obj);
        }
        try {
            return Boxing.boxBoolean(userActionProcessorInMemoryDataSource.shouldReAuthenticateUser);
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object updateReAuthenticateUser(boolean z, Continuation<? super Unit> continuation) {
        C11741 c11741;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Mutex mutex;
        if (continuation instanceof C11741) {
            c11741 = (C11741) continuation;
            if ((c11741.label & Integer.MIN_VALUE) != 0) {
                c11741.label -= Integer.MIN_VALUE;
            } else {
                c11741 = new C11741(continuation);
            }
        } else {
            c11741 = new C11741(continuation);
        }
        Object obj = c11741.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11741.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11741.L$0 = this;
            c11741.L$1 = mutex2;
            c11741.Z$0 = z;
            c11741.label = 1;
            if (mutex2.lock(null, c11741) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
            mutex = mutex2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            z = c11741.Z$0;
            mutex = (Mutex) c11741.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11741.L$0;
            ResultKt.throwOnFailure(obj);
        }
        try {
            userActionProcessorInMemoryDataSource.shouldReAuthenticateUser = z;
            return Unit.INSTANCE;
        } finally {
            mutex.unlock(null);
        }
    }

    private final Conversation updateInMemoryConversationAsynchronously(Conversation conversation) {
        Object next;
        Conversation conversation2 = this.conversations.get(conversation.getId());
        List<Message> messages = conversation2 != null ? conversation2.getMessages() : null;
        if (messages == null) {
            messages = CollectionsKt.emptyList();
        }
        List<Message> list = messages;
        ArrayList arrayList = new ArrayList();
        for (Object obj : list) {
            Message message = (Message) obj;
            if ((message.getStatus() instanceof MessageStatus.Pending) || (message.getStatus() instanceof MessageStatus.Failed) || (message.getStatus() instanceof MessageStatus.Downloading) || (message.getStatus() instanceof MessageStatus.DownloadFailed)) {
                arrayList.add(obj);
            }
        }
        ArrayList arrayList2 = arrayList;
        ArrayList arrayList3 = new ArrayList();
        for (Object obj2 : list) {
            if (((Message) obj2).getStatus() instanceof MessageStatus.DownloadFailed) {
                arrayList3.add(obj2);
            }
        }
        ArrayList arrayList4 = arrayList3;
        List listPlus = CollectionsKt.plus((Collection) conversation.getMessages(), (Iterable) arrayList2);
        HashSet hashSet = new HashSet();
        ArrayList arrayList5 = new ArrayList();
        for (Object obj3 : listPlus) {
            if (hashSet.add(((Message) obj3).getId())) {
                arrayList5.add(obj3);
            }
        }
        ArrayList<Message> arrayList6 = arrayList5;
        ArrayList arrayList7 = new ArrayList(CollectionsKt.collectionSizeOrDefault(arrayList6, 10));
        for (Message messageCopy : arrayList6) {
            Iterator<T> it = list.iterator();
            do {
                if (!it.hasNext()) {
                    next = null;
                    break;
                }
                next = it.next();
            } while (!Intrinsics.areEqual(((Message) next).getId(), messageCopy.getId()));
            Message message2 = (Message) next;
            if (message2 != null) {
                if ((messageCopy.getContent() instanceof MessageContent.Image) && (message2.getContent() instanceof MessageContent.FileUpload)) {
                    String localId = message2.getLocalId();
                    MessageContent.Image image = (MessageContent.Image) messageCopy.getContent();
                    messageCopy = messageCopy.copy((2021 & 1) != 0 ? messageCopy.id : null, (2021 & 2) != 0 ? messageCopy.author : null, (2021 & 4) != 0 ? messageCopy.status : null, (2021 & 8) != 0 ? messageCopy.created : message2.getCreated(), (2021 & 16) != 0 ? messageCopy.received : null, (2021 & 32) != 0 ? messageCopy.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? messageCopy.content : image.copy((123 & 1) != 0 ? image.text : null, (123 & 2) != 0 ? image.mediaUrl : null, (123 & 4) != 0 ? image.localUri : ((MessageContent.FileUpload) message2.getContent()).getUri(), (123 & 8) != 0 ? image.mediaType : null, (123 & 16) != 0 ? image.mediaSize : 0L, (123 & 32) != 0 ? image.actions : null, (123 & 64) != 0 ? image.attachmentId : null), (2021 & 128) != 0 ? messageCopy.metadata : null, (2021 & 256) != 0 ? messageCopy.sourceId : null, (2021 & 512) != 0 ? messageCopy.localId : localId, (2021 & 1024) != 0 ? messageCopy.payload : null);
                } else {
                    messageCopy = messageCopy.copy((2021 & 1) != 0 ? messageCopy.id : null, (2021 & 2) != 0 ? messageCopy.author : null, (2021 & 4) != 0 ? messageCopy.status : null, (2021 & 8) != 0 ? messageCopy.created : message2.getCreated(), (2021 & 16) != 0 ? messageCopy.received : null, (2021 & 32) != 0 ? messageCopy.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? messageCopy.content : null, (2021 & 128) != 0 ? messageCopy.metadata : null, (2021 & 256) != 0 ? messageCopy.sourceId : null, (2021 & 512) != 0 ? messageCopy.localId : message2.getLocalId(), (2021 & 1024) != 0 ? messageCopy.payload : null);
                }
            }
            arrayList7.add(messageCopy);
        }
        ArrayList arrayList8 = arrayList7;
        ArrayList arrayList9 = new ArrayList();
        for (Object obj4 : arrayList8) {
            Message message3 = (Message) obj4;
            ArrayList arrayList10 = arrayList4;
            if (!(arrayList10 instanceof Collection) || !arrayList10.isEmpty()) {
                Iterator it2 = arrayList10.iterator();
                while (it2.hasNext()) {
                    if (Intrinsics.areEqual(((Message) it2.next()).getId(), message3.getId())) {
                        arrayList9.add(obj4);
                        break;
                    }
                }
            }
        }
        ArrayList<Message> arrayList11 = arrayList9;
        ArrayList arrayList12 = new ArrayList(CollectionsKt.collectionSizeOrDefault(arrayList11, 10));
        for (Message message4 : arrayList11) {
            arrayList12.add(message4.copy((2021 & 1) != 0 ? message4.id : null, (2021 & 2) != 0 ? message4.author : null, (2021 & 4) != 0 ? message4.status : new MessageStatus.DownloadFailed(null, 1, null), (2021 & 8) != 0 ? message4.created : null, (2021 & 16) != 0 ? message4.received : null, (2021 & 32) != 0 ? message4.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message4.content : null, (2021 & 128) != 0 ? message4.metadata : null, (2021 & 256) != 0 ? message4.sourceId : null, (2021 & 512) != 0 ? message4.localId : null, (2021 & 1024) != 0 ? message4.payload : null));
        }
        ArrayList arrayList13 = arrayList12;
        ArrayList arrayList14 = new ArrayList();
        for (Object obj5 : arrayList8) {
            Message message5 = (Message) obj5;
            ArrayList arrayList15 = arrayList13;
            if (!(arrayList15 instanceof Collection) || !arrayList15.isEmpty()) {
                Iterator it3 = arrayList15.iterator();
                do {
                    if (it3.hasNext()) {
                    }
                } while (!Intrinsics.areEqual(((Message) it3.next()).getId(), message5.getId()));
            }
            arrayList14.add(obj5);
        }
        return sortAndCommitConversationToMemory(conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.plus((Collection) arrayList14, (Iterable) arrayList13), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
    }

    private final User updateUserConversationsAsynchronously(Conversation conversation) {
        List<Conversation> conversations = this.user.getConversations();
        ArrayList arrayList = new ArrayList();
        for (Object obj : conversations) {
            if (!Intrinsics.areEqual(((Conversation) obj).getId(), conversation.getId())) {
                arrayList.add(obj);
            }
        }
        List listPlus = CollectionsKt.plus((Collection<? extends Conversation>) arrayList, conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.takeLast(conversation.getMessages(), 1), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
        User user = this.user;
        User userCopy = user.copy((8063 & 1) != 0 ? user.id : null, (8063 & 2) != 0 ? user.externalId : null, (8063 & 4) != 0 ? user.givenName : null, (8063 & 8) != 0 ? user.surname : null, (8063 & 16) != 0 ? user.email : null, (8063 & 32) != 0 ? user.locale : null, (8063 & 64) != 0 ? user.signedUpAt : null, (8063 & 128) != 0 ? user.conversations : listPlus, (8063 & 256) != 0 ? user.realtimeSettings : null, (8063 & 512) != 0 ? user.typingSettings : null, (8063 & 1024) != 0 ? user.sessionToken : null, (8063 & 2048) != 0 ? user.jwt : null, (8063 & 4096) != 0 ? user.hasMore : false);
        this.user = userCopy;
        return userCopy;
    }

    public final Object updateConversationMessages(String str, List<Message> list, boolean z, Continuation<? super Conversation> continuation) throws Throwable {
        C11681 c11681;
        Mutex mutex;
        String str2;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        List<Message> list2;
        boolean z2;
        if (continuation instanceof C11681) {
            c11681 = (C11681) continuation;
            if ((c11681.label & Integer.MIN_VALUE) != 0) {
                c11681.label -= Integer.MIN_VALUE;
            } else {
                c11681 = new C11681(continuation);
            }
        } else {
            c11681 = new C11681(continuation);
        }
        Object obj = c11681.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11681.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            mutex = this.persistenceMutex;
            c11681.L$0 = this;
            str2 = str;
            c11681.L$1 = str2;
            c11681.L$2 = list;
            c11681.L$3 = mutex;
            c11681.Z$0 = z;
            c11681.label = 1;
            if (mutex.lock(null, c11681) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
            list2 = list;
            z2 = z;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            boolean z3 = c11681.Z$0;
            mutex = (Mutex) c11681.L$3;
            list2 = (List) c11681.L$2;
            String str3 = (String) c11681.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11681.L$0;
            ResultKt.throwOnFailure(obj);
            z2 = z3;
            str2 = str3;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str2);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            List<Message> messages = conversation.getMessages();
            if (!(messages instanceof Collection) || !messages.isEmpty()) {
                for (Message message : messages) {
                    List<Message> list3 = list2;
                    if (!(list3 instanceof Collection) || !list3.isEmpty()) {
                        Iterator<T> it = list3.iterator();
                        while (it.hasNext()) {
                            if (Intrinsics.areEqual(message.getId(), ((Message) it.next()).getId())) {
                                throw new MessageAlreadyInConversationException();
                            }
                        }
                    }
                }
            }
            List<Message> list4 = list2;
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list4, 10));
            Iterator<T> it2 = list4.iterator();
            while (it2.hasNext()) {
                arrayList.add(MessageKt.enrichFormResponseFields((Message) it2.next(), conversation));
            }
            Conversation conversationCopy = conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.plus((Collection) conversation.getMessages(), (Iterable) arrayList), (129023 & 4096) != 0 ? conversation.hasPrevious : z2, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null);
            userActionProcessorInMemoryDataSource.updateUserConversationsAsynchronously(conversationCopy);
            Conversation conversationSortAndCommitConversationToMemory = userActionProcessorInMemoryDataSource.sortAndCommitConversationToMemory(conversationCopy);
            mutex.unlock(null);
            return conversationSortAndCommitConversationToMemory;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    public final Object addMessageToConversationAndCommit(String str, Message message, Continuation<? super Conversation> continuation) throws Throwable {
        C11571 c11571;
        String str2;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        ?? r0;
        Ref.ObjectRef objectRef;
        if (continuation instanceof C11571) {
            c11571 = (C11571) continuation;
            if ((c11571.label & Integer.MIN_VALUE) != 0) {
                c11571.label -= Integer.MIN_VALUE;
            } else {
                c11571 = new C11571(continuation);
            }
        } else {
            c11571 = new C11571(continuation);
        }
        Object obj = c11571.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11571.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11571.L$0 = this;
            str2 = str;
            c11571.L$1 = str2;
            c11571.L$2 = message;
            c11571.L$3 = mutex2;
            c11571.label = 1;
            if (mutex2.lock(null, c11571) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
            r0 = message;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11571.L$3;
            Message message2 = (Message) c11571.L$2;
            String str3 = (String) c11571.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11571.L$0;
            ResultKt.throwOnFailure(obj);
            r0 = message2;
            str2 = str3;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str2);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            Ref.ObjectRef objectRef2 = new Ref.ObjectRef();
            objectRef2.element = r0;
            Iterator<T> it = conversation.getMessages().iterator();
            while (it.hasNext()) {
                if (MessageKt.shouldLocalIdBeUpdated((Message) it.next(), r0)) {
                    Message message3 = r0;
                    objectRef = objectRef2;
                    objectRef.element = message3.copy((2021 & 1) != 0 ? message3.id : null, (2021 & 2) != 0 ? message3.author : null, (2021 & 4) != 0 ? message3.status : null, (2021 & 8) != 0 ? message3.created : null, (2021 & 16) != 0 ? message3.received : null, (2021 & 32) != 0 ? message3.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message3.content : null, (2021 & 128) != 0 ? message3.metadata : null, (2021 & 256) != 0 ? message3.sourceId : null, (2021 & 512) != 0 ? message3.localId : r0.getId(), (2021 & 1024) != 0 ? message3.payload : null);
                } else {
                    objectRef = objectRef2;
                }
                objectRef2 = objectRef;
            }
            Ref.ObjectRef objectRef3 = objectRef2;
            List<Message> messages = conversation.getMessages();
            if (!(messages instanceof Collection) || !messages.isEmpty()) {
                for (Message message4 : messages) {
                    if (MessageKt.remoteOrLocalIdsAreEqual(message4, (Message) objectRef3.element) && Intrinsics.areEqual(message4.getStatus(), new MessageStatus.Sent(null, 1, null))) {
                        throw new MessageAlreadyInConversationException();
                    }
                }
            }
            Message messageEnrichFormResponseFields = MessageKt.enrichFormResponseFields((Message) objectRef3.element, conversation);
            List<Message> messages2 = conversation.getMessages();
            ArrayList arrayList = new ArrayList();
            for (Object obj2 : messages2) {
                if (!Intrinsics.areEqual(((Message) obj2).getLocalId(), messageEnrichFormResponseFields.getLocalId())) {
                    arrayList.add(obj2);
                }
            }
            Conversation conversationCopy = conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.plus((Collection<? extends Message>) arrayList, messageEnrichFormResponseFields), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null);
            userActionProcessorInMemoryDataSource.updateUserConversationsAsynchronously(conversationCopy);
            Conversation conversationSortAndCommitConversationToMemory = userActionProcessorInMemoryDataSource.sortAndCommitConversationToMemory(conversationCopy);
            mutex.unlock(null);
            return conversationSortAndCommitConversationToMemory;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    public final Object createPendingMessage(String str, Message message, Continuation<? super Message> continuation) throws Throwable {
        C11581 c11581;
        String str2;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Message message2;
        if (continuation instanceof C11581) {
            c11581 = (C11581) continuation;
            if ((c11581.label & Integer.MIN_VALUE) != 0) {
                c11581.label -= Integer.MIN_VALUE;
            } else {
                c11581 = new C11581(continuation);
            }
        } else {
            c11581 = new C11581(continuation);
        }
        Object obj = c11581.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11581.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11581.L$0 = this;
            str2 = str;
            c11581.L$1 = str2;
            c11581.L$2 = message;
            c11581.L$3 = mutex2;
            c11581.label = 1;
            if (mutex2.lock(null, c11581) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
            message2 = message;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11581.L$3;
            Message message3 = (Message) c11581.L$2;
            String str3 = (String) c11581.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11581.L$0;
            ResultKt.throwOnFailure(obj);
            message2 = message3;
            str2 = str3;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str2);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            List<Message> messages = conversation.getMessages();
            if (!(messages instanceof Collection) || !messages.isEmpty()) {
                for (Message message4 : messages) {
                    if (MessageKt.remoteOrLocalIdsAreEqual(message4, message2) && ((message4.getStatus() instanceof MessageStatus.Pending) || (message4.getStatus() instanceof MessageStatus.Sent))) {
                        throw new MessageAlreadyInConversationException();
                    }
                }
            }
            LocalDateTime localDateTimeMessageCreatedAtDateTime = userActionProcessorInMemoryDataSource.messageCreatedAtDateTime(conversation, message2.getReceived());
            Author author = message2.getAuthor();
            String id = userActionProcessorInMemoryDataSource.user.getId();
            StringBuilder sb = new StringBuilder();
            String givenName = userActionProcessorInMemoryDataSource.user.getGivenName();
            String str4 = "";
            if (givenName == null) {
                givenName = "";
            }
            sb.append(givenName);
            sb.append(' ');
            String surname = userActionProcessorInMemoryDataSource.user.getSurname();
            if (surname != null) {
                str4 = surname;
            }
            sb.append(str4);
            Message message5 = message2;
            Message messageCopy = message5.copy((2021 & 1) != 0 ? message5.id : null, (2021 & 2) != 0 ? message5.author : Author.copy$default(author, id, null, null, StringsKt.trim((CharSequence) sb.toString()).toString(), null, 22, null), (2021 & 4) != 0 ? message5.status : new MessageStatus.Pending(null, 1, null), (2021 & 8) != 0 ? message5.created : localDateTimeMessageCreatedAtDateTime, (2021 & 16) != 0 ? message5.received : localDateTimeMessageCreatedAtDateTime, (2021 & 32) != 0 ? message5.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message5.content : null, (2021 & 128) != 0 ? message5.metadata : null, (2021 & 256) != 0 ? message5.sourceId : null, (2021 & 512) != 0 ? message5.localId : null, (2021 & 1024) != 0 ? message5.payload : null);
            List<Message> messages2 = conversation.getMessages();
            ArrayList arrayList = new ArrayList();
            for (Object obj2 : messages2) {
                if (!Intrinsics.areEqual(((Message) obj2).getLocalId(), message2.getLocalId())) {
                    arrayList.add(obj2);
                }
            }
            userActionProcessorInMemoryDataSource.sortAndCommitConversationToMemory(conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.plus((Collection<? extends Message>) arrayList, messageCopy), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
            mutex.unlock(null);
            return messageCopy;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    private final LocalDateTime messageCreatedAtDateTime(Conversation conversation, LocalDateTime fallbackTime) {
        Object obj;
        LocalDateTime received;
        Iterator<T> it = conversation.getMessages().iterator();
        if (it.hasNext()) {
            Object next = it.next();
            if (it.hasNext()) {
                Comparable received2 = ((Message) next).getReceived();
                do {
                    Object next2 = it.next();
                    Comparable comparable = (Comparable) ((Message) next2).getReceived();
                    if (received2.compareTo(comparable) < 0) {
                        next = next2;
                        received2 = comparable;
                    }
                } while (it.hasNext());
            }
            obj = next;
        } else {
            obj = null;
        }
        Message message = (Message) obj;
        if (message != null && (received = message.getReceived()) != null) {
            fallbackTime = received;
        }
        LocalDateTime localDateTimePlus = fallbackTime.plus(Duration.ofMillis(1L));
        Intrinsics.checkNotNullExpressionValue(localDateTimePlus, "plus(...)");
        return localDateTimePlus;
    }

    public final Object replacePendingMessage(String str, Message message, String str2, Continuation<? super Conversation> continuation) throws Throwable {
        C11621 c11621;
        String str3;
        String str4;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Message message2;
        if (continuation instanceof C11621) {
            c11621 = (C11621) continuation;
            if ((c11621.label & Integer.MIN_VALUE) != 0) {
                c11621.label -= Integer.MIN_VALUE;
            } else {
                c11621 = new C11621(continuation);
            }
        } else {
            c11621 = new C11621(continuation);
        }
        Object obj = c11621.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11621.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11621.L$0 = this;
            str3 = str;
            c11621.L$1 = str3;
            c11621.L$2 = message;
            str4 = str2;
            c11621.L$3 = str4;
            c11621.L$4 = mutex2;
            c11621.label = 1;
            if (mutex2.lock(null, c11621) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
            message2 = message;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11621.L$4;
            String str5 = (String) c11621.L$3;
            message2 = (Message) c11621.L$2;
            String str6 = (String) c11621.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11621.L$0;
            ResultKt.throwOnFailure(obj);
            str4 = str5;
            str3 = str6;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str3);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            List<Message> messages = conversation.getMessages();
            if (!(messages instanceof Collection) || !messages.isEmpty()) {
                for (Message message3 : messages) {
                    if (MessageKt.remoteOrLocalIdsAreEqual(message3, message2) && (message3.getStatus() instanceof MessageStatus.Sent)) {
                        throw new MessageAlreadyInConversationException();
                    }
                }
            }
            List<Message> messages2 = conversation.getMessages();
            ArrayList arrayList = new ArrayList();
            for (Object obj2 : messages2) {
                Message message4 = (Message) obj2;
                if (!Intrinsics.areEqual(message4.getLocalId(), str4) && !Intrinsics.areEqual(message4.getSourceId(), str4)) {
                    arrayList.add(obj2);
                }
            }
            Conversation conversationCopy = conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.plus((Collection<? extends Message>) arrayList, message2), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null);
            userActionProcessorInMemoryDataSource.updateUserConversationsAsynchronously(conversationCopy);
            Conversation conversationSortAndCommitConversationToMemory = userActionProcessorInMemoryDataSource.sortAndCommitConversationToMemory(conversationCopy);
            mutex.unlock(null);
            return conversationSortAndCommitConversationToMemory;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    public final Object updateConversationBusinessLastRead(String str, LocalDateTime localDateTime, Continuation<? super Conversation> continuation) {
        C11671 c11671;
        String str2;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        LocalDateTime localDateTime2;
        if (continuation instanceof C11671) {
            c11671 = (C11671) continuation;
            if ((c11671.label & Integer.MIN_VALUE) != 0) {
                c11671.label -= Integer.MIN_VALUE;
            } else {
                c11671 = new C11671(continuation);
            }
        } else {
            c11671 = new C11671(continuation);
        }
        Object obj = c11671.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11671.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11671.L$0 = this;
            str2 = str;
            c11671.L$1 = str2;
            c11671.L$2 = localDateTime;
            c11671.L$3 = mutex2;
            c11671.label = 1;
            if (mutex2.lock(null, c11671) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
            localDateTime2 = localDateTime;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11671.L$3;
            LocalDateTime localDateTime3 = (LocalDateTime) c11671.L$2;
            String str3 = (String) c11671.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11671.L$0;
            ResultKt.throwOnFailure(obj);
            localDateTime2 = localDateTime3;
            str2 = str3;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str2);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            Conversation conversationSaveConversationAsynchronously = userActionProcessorInMemoryDataSource.saveConversationAsynchronously(conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : localDateTime2, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : null, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
            mutex.unlock(null);
            return conversationSaveConversationAsynchronously;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    public final Object updateConversationParticipants(String str, String str2, LocalDateTime localDateTime, Continuation<? super Conversation> continuation) {
        C11701 c11701;
        String str3;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        String str4;
        LocalDateTime localDateTime2;
        Object next;
        if (continuation instanceof C11701) {
            c11701 = (C11701) continuation;
            if ((c11701.label & Integer.MIN_VALUE) != 0) {
                c11701.label -= Integer.MIN_VALUE;
            } else {
                c11701 = new C11701(continuation);
            }
        } else {
            c11701 = new C11701(continuation);
        }
        Object obj = c11701.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11701.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11701.L$0 = this;
            str3 = str;
            c11701.L$1 = str3;
            c11701.L$2 = str2;
            c11701.L$3 = localDateTime;
            c11701.L$4 = mutex2;
            c11701.label = 1;
            if (mutex2.lock(null, c11701) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
            str4 = str2;
            localDateTime2 = localDateTime;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11701.L$4;
            LocalDateTime localDateTime3 = (LocalDateTime) c11701.L$3;
            str4 = (String) c11701.L$2;
            String str5 = (String) c11701.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11701.L$0;
            ResultKt.throwOnFailure(obj);
            localDateTime2 = localDateTime3;
            str3 = str5;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str3);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            List<Participant> participants = conversation.getParticipants();
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(participants, 10));
            for (Participant participantCopy$default : participants) {
                if (Intrinsics.areEqual(participantCopy$default.getUserId(), str4)) {
                    participantCopy$default = Participant.copy$default(participantCopy$default, null, null, 0, localDateTime2, 3, null);
                }
                arrayList.add(participantCopy$default);
            }
            ArrayList arrayList2 = arrayList;
            Iterator<T> it = conversation.getParticipants().iterator();
            do {
                if (!it.hasNext()) {
                    next = null;
                    break;
                }
                next = it.next();
            } while (!Intrinsics.areEqual(((Participant) next).getUserId(), str4));
            Participant participant = (Participant) next;
            Conversation conversationSaveConversationAsynchronously = userActionProcessorInMemoryDataSource.saveConversationAsynchronously(conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : participant != null ? Participant.copy$default(participant, null, null, 0, localDateTime2, 3, null) : null, (129023 & 1024) != 0 ? conversation.participants : arrayList2, (129023 & 2048) != 0 ? conversation.messages : null, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
            mutex.unlock(null);
            return conversationSaveConversationAsynchronously;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    public final Object getConversations(Continuation<? super List<Conversation>> continuation) throws Throwable {
        C11601 c11601;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Mutex mutex;
        if (continuation instanceof C11601) {
            c11601 = (C11601) continuation;
            if ((c11601.label & Integer.MIN_VALUE) != 0) {
                c11601.label -= Integer.MIN_VALUE;
            } else {
                c11601 = new C11601(continuation);
            }
        } else {
            c11601 = new C11601(continuation);
        }
        Object obj = c11601.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11601.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11601.L$0 = this;
            c11601.L$1 = mutex2;
            c11601.label = 1;
            if (mutex2.lock(null, c11601) == coroutine_suspended) {
                return coroutine_suspended;
            }
            userActionProcessorInMemoryDataSource = this;
            mutex = mutex2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11601.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11601.L$0;
            ResultKt.throwOnFailure(obj);
        }
        try {
            return CollectionsKt.toList(userActionProcessorInMemoryDataSource.conversations.values());
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object saveConversations(List<Conversation> list, Continuation<? super Unit> continuation) throws Throwable {
        C11641 c11641;
        List<Conversation> list2;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        List<Message> messages;
        if (continuation instanceof C11641) {
            c11641 = (C11641) continuation;
            if ((c11641.label & Integer.MIN_VALUE) != 0) {
                c11641.label -= Integer.MIN_VALUE;
            } else {
                c11641 = new C11641(continuation);
            }
        } else {
            c11641 = new C11641(continuation);
        }
        Object obj = c11641.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11641.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11641.L$0 = this;
            list2 = list;
            c11641.L$1 = list2;
            c11641.L$2 = mutex2;
            c11641.label = 1;
            if (mutex2.lock(null, c11641) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11641.L$2;
            list2 = (List) c11641.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11641.L$0;
            ResultKt.throwOnFailure(obj);
        }
        try {
            for (Conversation conversation : list2) {
                Conversation conversation2 = userActionProcessorInMemoryDataSource.conversations.get(conversation.getId());
                if (conversation2 == null || (messages = conversation2.getMessages()) == null) {
                    messages = conversation.getMessages();
                }
                userActionProcessorInMemoryDataSource.conversations.put(conversation.getId(), conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : messages, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null));
            }
            return Unit.INSTANCE;
        } finally {
            mutex.unlock(null);
        }
    }

    public final Object updateConversationRoutingStatus(ActivityEvent activityEvent, String str, Continuation<? super Conversation> continuation) {
        C11711 c11711;
        ActivityEvent activityEvent2;
        String str2;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        ConversationRoutingStatus routingStatus;
        if (continuation instanceof C11711) {
            c11711 = (C11711) continuation;
            if ((c11711.label & Integer.MIN_VALUE) != 0) {
                c11711.label -= Integer.MIN_VALUE;
            } else {
                c11711 = new C11711(continuation);
            }
        } else {
            c11711 = new C11711(continuation);
        }
        Object obj = c11711.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11711.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11711.L$0 = this;
            activityEvent2 = activityEvent;
            c11711.L$1 = activityEvent2;
            str2 = str;
            c11711.L$2 = str2;
            c11711.L$3 = mutex2;
            c11711.label = 1;
            if (mutex2.lock(null, c11711) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11711.L$3;
            String str3 = (String) c11711.L$2;
            ActivityEvent activityEvent3 = (ActivityEvent) c11711.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11711.L$0;
            ResultKt.throwOnFailure(obj);
            str2 = str3;
            activityEvent2 = activityEvent3;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str2);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            ActivityData activityData = activityEvent2.getActivityData();
            if (activityData == null || (routingStatus = ActivityDataKt.toConversationRoutingStatus(activityData)) == null) {
                routingStatus = conversation.getRoutingStatus();
            }
            Conversation conversationSaveConversationAsynchronously = userActionProcessorInMemoryDataSource.saveConversationAsynchronously(conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : null, (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : routingStatus, (129023 & 65536) != 0 ? conversation.createdAt : null));
            mutex.unlock(null);
            return conversationSaveConversationAsynchronously;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    public final Object updateDownloadingAttachment(String str, Message message, Continuation<? super Conversation> continuation) throws Throwable {
        C11721 c11721;
        String str2;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        Message message2;
        if (continuation instanceof C11721) {
            c11721 = (C11721) continuation;
            if ((c11721.label & Integer.MIN_VALUE) != 0) {
                c11721.label -= Integer.MIN_VALUE;
            } else {
                c11721 = new C11721(continuation);
            }
        } else {
            c11721 = new C11721(continuation);
        }
        Object obj = c11721.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11721.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11721.L$0 = this;
            str2 = str;
            c11721.L$1 = str2;
            c11721.L$2 = message;
            c11721.L$3 = mutex2;
            c11721.label = 1;
            if (mutex2.lock(null, c11721) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
            message2 = message;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11721.L$3;
            Message message3 = (Message) c11721.L$2;
            String str3 = (String) c11721.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11721.L$0;
            ResultKt.throwOnFailure(obj);
            message2 = message3;
            str2 = str3;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str2);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            Message message4 = message2;
            Message messageCopy = message4.copy((2021 & 1) != 0 ? message4.id : null, (2021 & 2) != 0 ? message4.author : null, (2021 & 4) != 0 ? message4.status : new MessageStatus.Downloading(null, 1, null), (2021 & 8) != 0 ? message4.created : null, (2021 & 16) != 0 ? message4.received : null, (2021 & 32) != 0 ? message4.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message4.content : null, (2021 & 128) != 0 ? message4.metadata : null, (2021 & 256) != 0 ? message4.sourceId : null, (2021 & 512) != 0 ? message4.localId : null, (2021 & 1024) != 0 ? message4.payload : null);
            List<Message> messages = conversation.getMessages();
            ArrayList arrayList = new ArrayList();
            for (Object obj2 : messages) {
                if (!Intrinsics.areEqual(((Message) obj2).getLocalId(), message2.getLocalId())) {
                    arrayList.add(obj2);
                }
            }
            Conversation conversationCopy = conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.plus((Collection<? extends Message>) arrayList, messageCopy), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null);
            userActionProcessorInMemoryDataSource.sortAndCommitConversationToMemory(conversationCopy);
            mutex.unlock(null);
            return conversationCopy;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }

    public final Object updateDownloadingStatus(String str, MessageStatus messageStatus, String str2, String str3, Continuation<? super Conversation> continuation) throws Throwable {
        C11731 c11731;
        String str4;
        String str5;
        Mutex mutex;
        UserActionProcessorInMemoryDataSource userActionProcessorInMemoryDataSource;
        MessageStatus messageStatus2;
        String str6;
        Object next;
        Message messageCopy;
        if (continuation instanceof C11731) {
            c11731 = (C11731) continuation;
            if ((c11731.label & Integer.MIN_VALUE) != 0) {
                c11731.label -= Integer.MIN_VALUE;
            } else {
                c11731 = new C11731(continuation);
            }
        } else {
            c11731 = new C11731(continuation);
        }
        Object obj = c11731.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11731.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex2 = this.persistenceMutex;
            c11731.L$0 = this;
            str4 = str;
            c11731.L$1 = str4;
            c11731.L$2 = messageStatus;
            c11731.L$3 = str2;
            str5 = str3;
            c11731.L$4 = str5;
            c11731.L$5 = mutex2;
            c11731.label = 1;
            if (mutex2.lock(null, c11731) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex = mutex2;
            userActionProcessorInMemoryDataSource = this;
            messageStatus2 = messageStatus;
            str6 = str2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mutex = (Mutex) c11731.L$5;
            String str7 = (String) c11731.L$4;
            str6 = (String) c11731.L$3;
            MessageStatus messageStatus3 = (MessageStatus) c11731.L$2;
            String str8 = (String) c11731.L$1;
            userActionProcessorInMemoryDataSource = (UserActionProcessorInMemoryDataSource) c11731.L$0;
            ResultKt.throwOnFailure(obj);
            str5 = str7;
            messageStatus2 = messageStatus3;
            str4 = str8;
        }
        try {
            Conversation conversation = userActionProcessorInMemoryDataSource.conversations.get(str5);
            if (conversation == null) {
                throw new ConversationNotFoundException();
            }
            Iterator<T> it = conversation.getMessages().iterator();
            while (true) {
                if (!it.hasNext()) {
                    next = null;
                    break;
                }
                next = it.next();
                Message message = (Message) next;
                if ((message.getContent() instanceof MessageContent.File) && Intrinsics.areEqual(message.getId(), str6) && Intrinsics.areEqual(FileKtxKt.getFileName(((MessageContent.File) message.getContent()).getMediaUrl()), str4)) {
                    break;
                }
            }
            Message message2 = (Message) next;
            if (message2 == null || (messageCopy = message2.copy((2021 & 1) != 0 ? message2.id : null, (2021 & 2) != 0 ? message2.author : null, (2021 & 4) != 0 ? message2.status : messageStatus2, (2021 & 8) != 0 ? message2.created : null, (2021 & 16) != 0 ? message2.received : null, (2021 & 32) != 0 ? message2.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message2.content : null, (2021 & 128) != 0 ? message2.metadata : null, (2021 & 256) != 0 ? message2.sourceId : null, (2021 & 512) != 0 ? message2.localId : null, (2021 & 1024) != 0 ? message2.payload : null)) == null) {
                mutex.unlock(null);
                return conversation;
            }
            List<Message> messages = conversation.getMessages();
            ArrayList arrayList = new ArrayList();
            for (Object obj2 : messages) {
                if (!Intrinsics.areEqual(((Message) obj2).getLocalId(), messageCopy.getLocalId())) {
                    arrayList.add(obj2);
                }
            }
            Conversation conversationCopy = conversation.copy((129023 & 1) != 0 ? conversation.id : null, (129023 & 2) != 0 ? conversation.displayName : null, (129023 & 4) != 0 ? conversation.description : null, (129023 & 8) != 0 ? conversation.iconUrl : null, (129023 & 16) != 0 ? conversation.type : null, (129023 & 32) != 0 ? conversation.isDefault : false, (129023 & 64) != 0 ? conversation.business : null, (129023 & 128) != 0 ? conversation.businessLastRead : null, (129023 & 256) != 0 ? conversation.lastUpdatedAt : null, (129023 & 512) != 0 ? conversation.myself : null, (129023 & 1024) != 0 ? conversation.participants : null, (129023 & 2048) != 0 ? conversation.messages : CollectionsKt.plus((Collection<? extends Message>) arrayList, messageCopy), (129023 & 4096) != 0 ? conversation.hasPrevious : false, (129023 & 8192) != 0 ? conversation.status : null, (129023 & 16384) != 0 ? conversation.metadata : null, (129023 & 32768) != 0 ? conversation.routingStatus : null, (129023 & 65536) != 0 ? conversation.createdAt : null);
            userActionProcessorInMemoryDataSource.sortAndCommitConversationToMemory(conversationCopy);
            mutex.unlock(null);
            return conversationCopy;
        } catch (Throwable th) {
            mutex.unlock(null);
            throw th;
        }
    }
}
