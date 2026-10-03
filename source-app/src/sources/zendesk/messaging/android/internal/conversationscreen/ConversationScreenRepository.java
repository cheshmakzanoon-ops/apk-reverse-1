package zendesk.messaging.android.internal.conversationscreen;

import cz.msebera.android.httpclient.HttpStatus;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.TimeoutKt;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import net.aihelp.data.track.data.TrackType;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitError;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.internal.user.UserExtensionsKt;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationStatus;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.User;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorage;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingUIPersistence;
import zendesk.messaging.android.internal.conversationscreen.cache.StoredForm;
import zendesk.p026ui.android.conversation.form.DisplayedField;
import zendesk.p026ui.android.conversation.form.DisplayedForm;

@Metadata(m17d1 = {"\u0000\u009c\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0017\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\t\b\u0000\u0018\u0000 Z2\u00020\u0001:\u0001ZB!\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0001\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000e\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017J\u000e\u0010\u0018\u001a\u00020\u0019H\u0082@¢\u0006\u0002\u0010\u001aJ\u001e\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u001d0\u001c2\b\u0010\u001e\u001a\u0004\u0018\u00010\u001fH\u0086@¢\u0006\u0002\u0010 J\u0012\u0010!\u001a\u0004\u0018\u00010\"2\u0006\u0010#\u001a\u00020\u001dH\u0002J\u001e\u0010$\u001a\u00020\u00152\u0006\u0010%\u001a\u00020\"2\u0006\u0010&\u001a\u00020'H\u0086@¢\u0006\u0002\u0010(J\"\u0010)\u001a\u000e\u0012\u0004\u0012\u00020\"\u0012\u0004\u0012\u00020+0*2\u0006\u0010%\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010,J*\u0010-\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020'0.0\u001c2\u0006\u0010%\u001a\u00020\"2\u0006\u0010/\u001a\u000200H\u0086@¢\u0006\u0002\u00101J\u0016\u00102\u001a\u00020\u00192\u0006\u0010%\u001a\u00020\"H\u0082@¢\u0006\u0002\u0010,J\u0016\u00103\u001a\u00020\u00192\u0006\u0010%\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010,J\u000e\u00104\u001a\u00020\u001dH\u0082@¢\u0006\u0002\u0010\u001aJ\u0010\u00105\u001a\u0004\u0018\u00010\"H\u0086@¢\u0006\u0002\u0010\u001aJ\u0016\u00106\u001a\u00020\u00192\u0006\u0010#\u001a\u00020\u001dH\u0082@¢\u0006\u0002\u00107J\u0010\u00108\u001a\u0004\u0018\u00010\"H\u0082@¢\u0006\u0002\u0010\u001aJ\u001e\u00109\u001a\u00020\u00152\u0006\u0010%\u001a\u00020\"2\u0006\u0010:\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010;J\u000e\u0010<\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017J\u001e\u0010=\u001a\u00020\u00152\u0006\u0010%\u001a\u00020\"2\u0006\u0010>\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010;J(\u0010?\u001a\u00020\u00192\b\u0010%\u001a\u0004\u0018\u00010\"2\u0006\u0010@\u001a\u00020\u00132\u0006\u0010A\u001a\u00020\u0013H\u0086@¢\u0006\u0002\u0010BJ\u0016\u0010C\u001a\u00020\u00192\u0006\u0010%\u001a\u00020\"H\u0082@¢\u0006\u0002\u0010,J\u000e\u0010D\u001a\u00020\u0015H\u0086@¢\u0006\u0002\u0010\u001aJ\u0016\u0010E\u001a\u00020\"2\u0006\u0010%\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010,J\u001e\u0010F\u001a\u00020\u00152\u0006\u0010G\u001a\u00020H2\u0006\u0010%\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010IJ$\u0010J\u001a\b\u0012\u0004\u0012\u00020'0\u001c2\u0006\u0010&\u001a\u00020'2\u0006\u0010%\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010KJ$\u0010L\u001a\b\u0012\u0004\u0012\u00020\u00150\u001c2\u0006\u0010%\u001a\u00020\"2\u0006\u0010M\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010;J\u000e\u0010N\u001a\u00020\u0015H\u0082@¢\u0006\u0002\u0010\u001aJ\u001e\u0010O\u001a\u00020\u00152\u0006\u0010%\u001a\u00020\"2\u0006\u0010:\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010;J&\u0010P\u001a\u00020\u00152\u0006\u0010Q\u001a\u00020R2\u0006\u0010%\u001a\u00020\"2\u0006\u0010>\u001a\u00020\"H\u0086@¢\u0006\u0002\u0010SJ\u001f\u0010T\u001a\u00020\u00152\b\u0010U\u001a\u0004\u0018\u00010\u001f2\b\u0010V\u001a\u0004\u0018\u00010\u001f¢\u0006\u0002\u0010WJ\u000e\u0010X\u001a\u00020\u0015H\u0082@¢\u0006\u0002\u0010\u001aJ\u000e\u0010Y\u001a\u00020\u00152\u0006\u0010\u0012\u001a\u00020\u0013R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006["}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "messagingStorage", "Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingStorage;", "defaultDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "(Lzendesk/conversationkit/android/ConversationKit;Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingStorage;Lkotlinx/coroutines/CoroutineDispatcher;)V", "_eventsChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepositoryEvent;", "eventsChannel", "Lkotlinx/coroutines/flow/Flow;", "getEventsChannel", "()Lkotlinx/coroutines/flow/Flow;", "proactiveParams", "Lzendesk/messaging/android/internal/conversationscreen/ProactiveParams;", "userAccessHasBeenRevoked", "", "addEventListener", "", "listener", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "createConversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createUser", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/User;", "proactiveMessageId", "", "(Ljava/lang/Integer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "defaultConversationId", "", "user", "downloadAttachment", "conversationId", "message", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getLocalStoredForms", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getMessages", "", "beforeTimestamp", "", "(Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getProactiveMessageReferral", "getRemoteConversation", "getUser", "getUserAuthToken", "getUserDefaultConversation", "(Lzendesk/conversationkit/android/model/User;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "latestClosedConversationId", "persistComposerText", "composerText", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeEventListener", "removeStoredForm", "formId", "resolveConversation", "canUserCreateMoreConversations", "isMultiConvoEnabled", "(Ljava/lang/String;ZZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "resolveProactiveConversation", "resume", "retrieveInitialText", "sendActivityData", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "(Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendPostbackMessage", "actionId", "suspendUntilConnected", "updateComposerText", "updateLocalStoredForm", "field", "Lzendesk/ui/android/conversation/form/DisplayedField;", "(Lzendesk/ui/android/conversation/form/DisplayedField;Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateProactiveParams", "proactiveNotificationId", "hasSendReferralInfo", "(Ljava/lang/Integer;Ljava/lang/Integer;)V", "updateProactiveReferralLocalData", "updateUserAccessHasBeenRevoked", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationScreenRepository {
    private static final Companion Companion = new Companion(null);
    private static final long FAYE_CONNECTION_TIMEOUT = TimeUnit.MINUTES.toMillis(1);
    private static final String LOG_TAG = "ConversationScreenRepository";
    private final Channel<ConversationScreenRepositoryEvent> _eventsChannel;
    private final ConversationKit conversationKit;
    private final CoroutineDispatcher defaultDispatcher;
    private final Flow<ConversationScreenRepositoryEvent> eventsChannel;
    private final MessagingStorage messagingStorage;
    private final ProactiveParams proactiveParams;
    private boolean userAccessHasBeenRevoked;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {0, 1, 2}, m39l = {250, TrackType.TRACK_FORM_ACTION_CLICKED, 258}, m40m = "createConversation", m41n = {"this", "this", "result"}, m42s = {"L$0", "L$0", "L$0"})
    static final class C13051 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C13051(Continuation<? super C13051> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.createConversation(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {0}, m39l = {456}, m40m = "getLocalStoredForms", m41n = {"mapOfStoredForms"}, m42s = {"L$0"})
    static final class C13061 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C13061(Continuation<? super C13061> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.getLocalStoredForms(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {0, 1}, m39l = {348, 355}, m40m = "getProactiveMessageReferral", m41n = {"this", "result"}, m42s = {"L$0", "L$0"})
    static final class C13071 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C13071(Continuation<? super C13071> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.getProactiveMessageReferral(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {}, m39l = {366}, m40m = "getRemoteConversation", m41n = {}, m42s = {})
    static final class C13081 extends ContinuationImpl {
        int label;
        Object result;

        C13081(Continuation<? super C13081> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.getRemoteConversation(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {0, 1, 2}, m39l = {271, 279, 281, 288}, m40m = "getUser", m41n = {"this", "this", "result"}, m42s = {"L$0", "L$0", "L$0"})
    static final class C13091 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C13091(Continuation<? super C13091> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.getUser(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {}, m39l = {475}, m40m = "getUserAuthToken", m41n = {}, m42s = {})
    static final class C13101 extends ContinuationImpl {
        int label;
        Object result;

        C13101(Continuation<? super C13101> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.getUserAuthToken(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {}, m39l = {HttpStatus.SC_SEE_OTHER}, m40m = "latestClosedConversationId", m41n = {}, m42s = {})
    static final class C13121 extends ContinuationImpl {
        int label;
        Object result;

        C13121(Continuation<? super C13121> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.latestClosedConversationId(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {0, 0}, m39l = {393, 395}, m40m = "persistComposerText", m41n = {"this", "composerText"}, m42s = {"L$0", "L$1"})
    static final class C13131 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C13131(Continuation<? super C13131> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.persistComposerText(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {0, 0, 0, 0, 1, 1, 1, 1, 1}, m39l = {189, 190, 196, HttpStatus.SC_RESET_CONTENT, 210, 214}, m40m = "resolveConversation", m41n = {"this", "conversationId", "canUserCreateMoreConversations", "isMultiConvoEnabled", "this", "conversationId", "user", "canUserCreateMoreConversations", "isMultiConvoEnabled"}, m42s = {"L$0", "L$1", "Z$0", "Z$1", "L$0", "L$1", "L$2", "Z$0", "Z$1"})
    static final class C13151 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        boolean Z$0;
        boolean Z$1;
        int label;
        Object result;

        C13151(Continuation<? super C13151> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.resolveConversation(null, false, false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {}, m39l = {385}, m40m = "retrieveInitialText", m41n = {}, m42s = {})
    static final class C13161 extends ContinuationImpl {
        int label;
        Object result;

        C13161(Continuation<? super C13161> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.retrieveInitialText(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository", m37f = "ConversationScreenRepository.kt", m38i = {0, 0, 0}, m39l = {431, 445}, m40m = "updateLocalStoredForm", m41n = {"this", "field", "formId"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C13191 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C13191(Continuation<? super C13191> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenRepository.this.updateLocalStoredForm(null, null, null, this);
        }
    }

    @Inject
    public ConversationScreenRepository(ConversationKit conversationKit, MessagingStorage messagingStorage, @Named(CoroutineDispatchersModule.DEFAULT_DISPATCHER) CoroutineDispatcher defaultDispatcher) {
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(messagingStorage, "messagingStorage");
        Intrinsics.checkNotNullParameter(defaultDispatcher, "defaultDispatcher");
        this.conversationKit = conversationKit;
        this.messagingStorage = messagingStorage;
        this.defaultDispatcher = defaultDispatcher;
        Channel<ConversationScreenRepositoryEvent> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._eventsChannel = channelChannel$default;
        this.eventsChannel = FlowKt.receiveAsFlow(channelChannel$default);
        this.proactiveParams = new ProactiveParams(null, null, 3, null);
    }

    public final Flow<ConversationScreenRepositoryEvent> getEventsChannel() {
        return this.eventsChannel;
    }

    public final void updateProactiveParams(Integer proactiveNotificationId, Integer hasSendReferralInfo) {
        ProactiveParams proactiveParams = this.proactiveParams;
        proactiveParams.setProactiveNotificationId(proactiveNotificationId);
        proactiveParams.setHasSendReferralInfo(hasSendReferralInfo);
    }

    public final void updateUserAccessHasBeenRevoked(boolean userAccessHasBeenRevoked) {
        this.userAccessHasBeenRevoked = userAccessHasBeenRevoked;
    }

    public final Object sendMessage(Message message, String str, Continuation<? super ConversationKitResult<Message>> continuation) {
        return this.conversationKit.sendMessage(message, str, continuation);
    }

    public final Object sendPostbackMessage(String str, String str2, Continuation<? super ConversationKitResult<Unit>> continuation) {
        return this.conversationKit.sendPostbackMessage(str, str2, continuation);
    }

    public final Object sendActivityData(ActivityData activityData, String str, Continuation<? super Unit> continuation) {
        Object objSendActivityData = this.conversationKit.sendActivityData(activityData, str, continuation);
        return objSendActivityData == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSendActivityData : Unit.INSTANCE;
    }

    public final Object resume(Continuation<? super Unit> continuation) {
        Object objResume = this.conversationKit.resume(continuation);
        return objResume == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objResume : Unit.INSTANCE;
    }

    public final Object createUser(Integer num, Continuation<? super ConversationKitResult<User>> continuation) {
        return this.conversationKit.createUser(num, continuation);
    }

    public final void addEventListener(ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        this.conversationKit.addEventListener(listener);
    }

    public final void removeEventListener(ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        this.conversationKit.removeEventListener(listener);
    }

    public final Object getMessages(String str, double d, Continuation<? super ConversationKitResult<? extends List<Message>>> continuation) {
        return this.conversationKit.getMessages(str, d, continuation);
    }

    public final Object resolveConversation(String str, boolean z, boolean z2, Continuation<? super Conversation> continuation) throws Throwable {
        C13151 c13151;
        ConversationScreenRepository conversationScreenRepository;
        User user;
        Object objLatestClosedConversationId;
        String str2;
        boolean z3;
        User user2;
        String str3;
        if (continuation instanceof C13151) {
            c13151 = (C13151) continuation;
            if ((c13151.label & Integer.MIN_VALUE) != 0) {
                c13151.label -= Integer.MIN_VALUE;
            } else {
                c13151 = new C13151(continuation);
            }
        } else {
            c13151 = new C13151(continuation);
        }
        Object user3 = c13151.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        switch (c13151.label) {
            case 0:
                ResultKt.throwOnFailure(user3);
                c13151.L$0 = this;
                c13151.L$1 = str;
                c13151.Z$0 = z;
                c13151.Z$1 = z2;
                c13151.label = 1;
                user3 = getUser(c13151);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationScreenRepository = this;
                user = (User) user3;
                c13151.L$0 = conversationScreenRepository;
                c13151.L$1 = str;
                c13151.L$2 = user;
                c13151.Z$0 = z;
                c13151.Z$1 = z2;
                c13151.label = 2;
                objLatestClosedConversationId = conversationScreenRepository.latestClosedConversationId(c13151);
                if (objLatestClosedConversationId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str2 = str;
                z3 = z2;
                user2 = user;
                user3 = objLatestClosedConversationId;
                str3 = (String) user3;
                boolean z4 = (z3 || z) ? false : true;
                if (str2 != null) {
                    c13151.L$0 = null;
                    c13151.L$1 = null;
                    c13151.L$2 = null;
                    c13151.label = 3;
                    user3 = conversationScreenRepository.getRemoteConversation(str2, c13151);
                    if (user3 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return user3;
                }
                if ((z3 || z4) && str3 != null) {
                    c13151.L$0 = null;
                    c13151.L$1 = null;
                    c13151.L$2 = null;
                    c13151.label = 4;
                    user3 = conversationScreenRepository.resolveProactiveConversation(str3, c13151);
                    if (user3 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return user3;
                }
                if (!z && conversationScreenRepository.proactiveParams.getHasSendReferralInfo() != null) {
                    c13151.L$0 = null;
                    c13151.L$1 = null;
                    c13151.L$2 = null;
                    c13151.label = 5;
                    user3 = conversationScreenRepository.createConversation(c13151);
                    return user3 == coroutine_suspended ? coroutine_suspended : user3;
                }
                c13151.L$0 = null;
                c13151.L$1 = null;
                c13151.L$2 = null;
                c13151.label = 6;
                user3 = conversationScreenRepository.getUserDefaultConversation(user2, c13151);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user3;
            case 1:
                z2 = c13151.Z$1;
                z = c13151.Z$0;
                str = (String) c13151.L$1;
                ConversationScreenRepository conversationScreenRepository2 = (ConversationScreenRepository) c13151.L$0;
                ResultKt.throwOnFailure(user3);
                conversationScreenRepository = conversationScreenRepository2;
                user = (User) user3;
                c13151.L$0 = conversationScreenRepository;
                c13151.L$1 = str;
                c13151.L$2 = user;
                c13151.Z$0 = z;
                c13151.Z$1 = z2;
                c13151.label = 2;
                objLatestClosedConversationId = conversationScreenRepository.latestClosedConversationId(c13151);
                if (objLatestClosedConversationId == coroutine_suspended) {
                    return coroutine_suspended;
                }
                str2 = str;
                z3 = z2;
                user2 = user;
                user3 = objLatestClosedConversationId;
                str3 = (String) user3;
                if (z3) {
                }
                if (str2 != null) {
                    c13151.L$0 = null;
                    c13151.L$1 = null;
                    c13151.L$2 = null;
                    c13151.label = 3;
                    user3 = conversationScreenRepository.getRemoteConversation(str2, c13151);
                    if (user3 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return user3;
                }
                if (z3) {
                    c13151.L$0 = null;
                    c13151.L$1 = null;
                    c13151.L$2 = null;
                    c13151.label = 4;
                    user3 = conversationScreenRepository.resolveProactiveConversation(str3, c13151);
                    if (user3 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return user3;
                }
                c13151.L$0 = null;
                c13151.L$1 = null;
                c13151.L$2 = null;
                c13151.label = 4;
                user3 = conversationScreenRepository.resolveProactiveConversation(str3, c13151);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user3;
                if (!z) {
                    break;
                }
                c13151.L$0 = null;
                c13151.L$1 = null;
                c13151.L$2 = null;
                c13151.label = 6;
                user3 = conversationScreenRepository.getUserDefaultConversation(user2, c13151);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user3;
            case 2:
                z3 = c13151.Z$1;
                z = c13151.Z$0;
                user2 = (User) c13151.L$2;
                str2 = (String) c13151.L$1;
                conversationScreenRepository = (ConversationScreenRepository) c13151.L$0;
                ResultKt.throwOnFailure(user3);
                str3 = (String) user3;
                if (z3) {
                }
                if (str2 != null) {
                    c13151.L$0 = null;
                    c13151.L$1 = null;
                    c13151.L$2 = null;
                    c13151.label = 3;
                    user3 = conversationScreenRepository.getRemoteConversation(str2, c13151);
                    if (user3 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return user3;
                }
                if (z3) {
                    c13151.L$0 = null;
                    c13151.L$1 = null;
                    c13151.L$2 = null;
                    c13151.label = 4;
                    user3 = conversationScreenRepository.resolveProactiveConversation(str3, c13151);
                    if (user3 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return user3;
                }
                c13151.L$0 = null;
                c13151.L$1 = null;
                c13151.L$2 = null;
                c13151.label = 4;
                user3 = conversationScreenRepository.resolveProactiveConversation(str3, c13151);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user3;
                if (!z) {
                    break;
                }
                c13151.L$0 = null;
                c13151.L$1 = null;
                c13151.L$2 = null;
                c13151.label = 6;
                user3 = conversationScreenRepository.getUserDefaultConversation(user2, c13151);
                if (user3 == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return user3;
            case 3:
                ResultKt.throwOnFailure(user3);
                return user3;
            case 4:
                ResultKt.throwOnFailure(user3);
                return user3;
            case 5:
                ResultKt.throwOnFailure(user3);
            case 6:
                ResultKt.throwOnFailure(user3);
                return user3;
            default:
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object getUserDefaultConversation(User user, Continuation<? super Conversation> continuation) {
        String strDefaultConversationId = defaultConversationId(user);
        if (strDefaultConversationId != null) {
            return resolveProactiveConversation(strDefaultConversationId, continuation);
        }
        StringBuilder sb = new StringBuilder("No default conversation found creating a new conversation with proactive ");
        sb.append(this.proactiveParams.getProactiveNotificationId() != null);
        Logger.m221i(LOG_TAG, sb.toString(), new Object[0]);
        return createConversation(continuation);
    }

    private final String defaultConversationId(User user) {
        Object next;
        Iterator<T> it = user.getConversations().iterator();
        do {
            if (!it.hasNext()) {
                next = null;
                break;
            }
            next = it.next();
        } while (!((Conversation) next).isDefault());
        Conversation conversation = (Conversation) next;
        if (conversation != null) {
            return conversation.getId();
        }
        return null;
    }

    public final Object createConversation(Continuation<? super Conversation> continuation) throws Throwable {
        C13051 c13051;
        ConversationScreenRepository conversationScreenRepository;
        ConversationKitResult conversationKitResult;
        ConversationKitResult conversationKitResult2;
        if (continuation instanceof C13051) {
            c13051 = (C13051) continuation;
            if ((c13051.label & Integer.MIN_VALUE) != 0) {
                c13051.label -= Integer.MIN_VALUE;
            } else {
                c13051 = new C13051(continuation);
            }
        } else {
            c13051 = new C13051(continuation);
        }
        Object objCreateConversation = c13051.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13051.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objCreateConversation);
            c13051.L$0 = this;
            c13051.label = 1;
            if (suspendUntilConnected(c13051) == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenRepository = this;
        } else {
            if (i == 1) {
                conversationScreenRepository = (ConversationScreenRepository) c13051.L$0;
                ResultKt.throwOnFailure(objCreateConversation);
            } else if (i == 2) {
                conversationScreenRepository = (ConversationScreenRepository) c13051.L$0;
                ResultKt.throwOnFailure(objCreateConversation);
                conversationKitResult = (ConversationKitResult) objCreateConversation;
                if (!(conversationKitResult instanceof ConversationKitResult.Failure)) {
                    throw ((ConversationKitResult.Failure) conversationKitResult).getCause();
                }
                if (conversationKitResult instanceof ConversationKitResult.Success) {
                    throw new NoWhenBranchMatchedException();
                }
                c13051.L$0 = conversationKitResult;
                c13051.label = 3;
                if (conversationScreenRepository.updateProactiveReferralLocalData(c13051) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitResult2 = conversationKitResult;
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                conversationKitResult2 = (ConversationKitResult) c13051.L$0;
                ResultKt.throwOnFailure(objCreateConversation);
            }
            return (Conversation) ((ConversationKitResult.Success) conversationKitResult2).getValue();
        }
        ConversationKit conversationKit = conversationScreenRepository.conversationKit;
        Integer hasSendReferralInfo = conversationScreenRepository.proactiveParams.getHasSendReferralInfo();
        c13051.L$0 = conversationScreenRepository;
        c13051.label = 2;
        objCreateConversation = conversationKit.createConversation(hasSendReferralInfo, c13051);
        if (objCreateConversation == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversationKitResult = (ConversationKitResult) objCreateConversation;
        if (!(conversationKitResult instanceof ConversationKitResult.Failure)) {
            throw ((ConversationKitResult.Failure) conversationKitResult).getCause();
        }
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            throw new NoWhenBranchMatchedException();
        }
        c13051.L$0 = conversationKitResult;
        c13051.label = 3;
        if (conversationScreenRepository.updateProactiveReferralLocalData(c13051) == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversationKitResult2 = conversationKitResult;
        return (Conversation) ((ConversationKitResult.Success) conversationKitResult2).getValue();
    }

    public final Object getUser(Continuation<? super User> continuation) throws Throwable {
        C13091 c13091;
        ConversationScreenRepository conversationScreenRepository;
        ConversationKitResult conversationKitResult;
        ConversationKitResult.Failure failure;
        ConversationKitResult conversationKitResult2;
        User user;
        if (continuation instanceof C13091) {
            c13091 = (C13091) continuation;
            if ((c13091.label & Integer.MIN_VALUE) != 0) {
                c13091.label -= Integer.MIN_VALUE;
            } else {
                c13091 = new C13091(continuation);
            }
        } else {
            c13091 = new C13091(continuation);
        }
        Object currentUser = c13091.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13091.label;
        if (i == 0) {
            ResultKt.throwOnFailure(currentUser);
            ConversationKit conversationKit = this.conversationKit;
            c13091.L$0 = this;
            c13091.label = 1;
            currentUser = conversationKit.getCurrentUser(c13091);
            if (currentUser == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenRepository = this;
        } else {
            if (i != 1) {
                if (i != 2) {
                    if (i == 3) {
                        conversationKitResult2 = (ConversationKitResult) c13091.L$0;
                        ResultKt.throwOnFailure(currentUser);
                        return ((ConversationKitResult.Success) conversationKitResult2).getValue();
                    }
                    if (i != 4) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(currentUser);
                    user = (User) currentUser;
                    if (user != null) {
                        return user;
                    }
                    throw ConversationKitError.FailedToInitialize.INSTANCE;
                }
                conversationScreenRepository = (ConversationScreenRepository) c13091.L$0;
                ResultKt.throwOnFailure(currentUser);
                conversationKitResult = (ConversationKitResult) currentUser;
                if (conversationKitResult instanceof ConversationKitResult.Success) {
                    c13091.L$0 = conversationKitResult;
                    c13091.label = 3;
                    if (conversationScreenRepository.updateProactiveReferralLocalData(c13091) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationKitResult2 = conversationKitResult;
                    return ((ConversationKitResult.Success) conversationKitResult2).getValue();
                }
                if (conversationKitResult instanceof ConversationKitResult.Failure) {
                    throw new NoWhenBranchMatchedException();
                }
                failure = (ConversationKitResult.Failure) conversationKitResult;
                if (failure.getCause() instanceof ConversationKitError.UserAlreadyExists) {
                    ConversationKit conversationKit2 = conversationScreenRepository.conversationKit;
                    c13091.L$0 = null;
                    c13091.label = 4;
                    currentUser = conversationKit2.getCurrentUser(c13091);
                    if (currentUser == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    user = (User) currentUser;
                    if (user != null) {
                        return user;
                    }
                    throw ConversationKitError.FailedToInitialize.INSTANCE;
                }
                throw failure.getCause();
            }
            conversationScreenRepository = (ConversationScreenRepository) c13091.L$0;
            ResultKt.throwOnFailure(currentUser);
        }
        User user2 = (User) currentUser;
        if (user2 != null) {
            return user2;
        }
        if (conversationScreenRepository.userAccessHasBeenRevoked) {
            throw new IllegalStateException("User access has been revoked.");
        }
        Logger.m221i(LOG_TAG, "No user created yet, creating user to show the conversation.", new Object[0]);
        Integer hasSendReferralInfo = conversationScreenRepository.proactiveParams.getHasSendReferralInfo();
        c13091.L$0 = conversationScreenRepository;
        c13091.label = 2;
        currentUser = conversationScreenRepository.createUser(hasSendReferralInfo, c13091);
        if (currentUser == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversationKitResult = (ConversationKitResult) currentUser;
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            c13091.L$0 = conversationKitResult;
            c13091.label = 3;
            if (conversationScreenRepository.updateProactiveReferralLocalData(c13091) == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationKitResult2 = conversationKitResult;
            return ((ConversationKitResult.Success) conversationKitResult2).getValue();
        }
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            throw new NoWhenBranchMatchedException();
        }
        failure = (ConversationKitResult.Failure) conversationKitResult;
        if (failure.getCause() instanceof ConversationKitError.UserAlreadyExists) {
            ConversationKit conversationKit3 = conversationScreenRepository.conversationKit;
            c13091.L$0 = null;
            c13091.label = 4;
            currentUser = conversationKit3.getCurrentUser(c13091);
            if (currentUser == coroutine_suspended) {
                return coroutine_suspended;
            }
            user = (User) currentUser;
            if (user != null) {
                return user;
            }
            throw ConversationKitError.FailedToInitialize.INSTANCE;
        }
        throw failure.getCause();
    }

    public final Object latestClosedConversationId(Continuation<? super String> continuation) throws Throwable {
        C13121 c13121;
        if (continuation instanceof C13121) {
            c13121 = (C13121) continuation;
            if ((c13121.label & Integer.MIN_VALUE) != 0) {
                c13121.label -= Integer.MIN_VALUE;
            } else {
                c13121 = new C13121(continuation);
            }
        } else {
            c13121 = new C13121(continuation);
        }
        Object conversations = c13121.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13121.label;
        if (i == 0) {
            ResultKt.throwOnFailure(conversations);
            ConversationKit conversationKit = this.conversationKit;
            c13121.label = 1;
            conversations = conversationKit.getConversations(0, true, c13121);
            if (conversations == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(conversations);
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) conversations;
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            return null;
        }
        if (!(conversationKitResult instanceof ConversationKitResult.Success)) {
            throw new NoWhenBranchMatchedException();
        }
        List<Conversation> conversations2 = ((ConversationsPagination) ((ConversationKitResult.Success) conversationKitResult).getValue()).getConversations();
        ArrayList arrayList = new ArrayList();
        for (Object obj : conversations2) {
            if (((Conversation) obj).getStatus() == ConversationStatus.IDLE) {
                arrayList.add(obj);
            }
        }
        Conversation conversation = (Conversation) CollectionsKt.firstOrNull(CollectionsKt.sortedWith(arrayList, new Comparator() {
            @Override
            public final int compare(T t, T t2) {
                return ComparisonsKt.compareValues(((Conversation) t2).getLastUpdatedAt(), ((Conversation) t).getLastUpdatedAt());
            }
        }));
        if (conversation != null) {
            return conversation.getId();
        }
        return null;
    }

    public final Object resolveProactiveConversation(String str, Continuation<? super Conversation> continuation) {
        if (this.proactiveParams.getHasSendReferralInfo() != null) {
            Logger.m221i(LOG_TAG, "Fetching proactive message referral conversation", new Object[0]);
            return getProactiveMessageReferral(str, continuation);
        }
        Logger.m221i(LOG_TAG, "No proactive conversation, fetching the remote conversation.", new Object[0]);
        return getRemoteConversation(str, continuation);
    }

    public final Object getProactiveMessageReferral(String str, Continuation<? super Conversation> continuation) throws Throwable {
        C13071 c13071;
        ConversationScreenRepository conversationScreenRepository;
        ConversationKitResult conversationKitResult;
        if (continuation instanceof C13071) {
            c13071 = (C13071) continuation;
            if ((c13071.label & Integer.MIN_VALUE) != 0) {
                c13071.label -= Integer.MIN_VALUE;
            } else {
                c13071 = new C13071(continuation);
            }
        } else {
            c13071 = new C13071(continuation);
        }
        Object objProactiveMessageReferral = c13071.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13071.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objProactiveMessageReferral);
            ConversationKit conversationKit = this.conversationKit;
            Integer proactiveNotificationId = this.proactiveParams.getProactiveNotificationId();
            c13071.L$0 = this;
            c13071.label = 1;
            objProactiveMessageReferral = conversationKit.proactiveMessageReferral(proactiveNotificationId, str, c13071);
            if (objProactiveMessageReferral == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenRepository = this;
        } else {
            if (i == 1) {
                conversationScreenRepository = (ConversationScreenRepository) c13071.L$0;
                ResultKt.throwOnFailure(objProactiveMessageReferral);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                conversationKitResult = (ConversationKitResult) c13071.L$0;
                ResultKt.throwOnFailure(objProactiveMessageReferral);
            }
            return (Conversation) ((ConversationKitResult.Success) conversationKitResult).getValue();
        }
        ConversationKitResult conversationKitResult2 = (ConversationKitResult) objProactiveMessageReferral;
        if (conversationKitResult2 instanceof ConversationKitResult.Failure) {
            throw ((ConversationKitResult.Failure) conversationKitResult2).getCause();
        }
        if (!(conversationKitResult2 instanceof ConversationKitResult.Success)) {
            throw new NoWhenBranchMatchedException();
        }
        c13071.L$0 = conversationKitResult2;
        c13071.label = 2;
        if (conversationScreenRepository.updateProactiveReferralLocalData(c13071) == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversationKitResult = conversationKitResult2;
        return (Conversation) ((ConversationKitResult.Success) conversationKitResult).getValue();
    }

    public final Object getRemoteConversation(String str, Continuation<? super Conversation> continuation) throws Throwable {
        C13081 c13081;
        if (continuation instanceof C13081) {
            c13081 = (C13081) continuation;
            if ((c13081.label & Integer.MIN_VALUE) != 0) {
                c13081.label -= Integer.MIN_VALUE;
            } else {
                c13081 = new C13081(continuation);
            }
        } else {
            c13081 = new C13081(continuation);
        }
        Object conversation = c13081.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13081.label;
        if (i == 0) {
            ResultKt.throwOnFailure(conversation);
            ConversationKit conversationKit = this.conversationKit;
            c13081.label = 1;
            conversation = conversationKit.getConversation(str, c13081);
            if (conversation == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(conversation);
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) conversation;
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            return (Conversation) ((ConversationKitResult.Success) conversationKitResult).getValue();
        }
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            throw ((ConversationKitResult.Failure) conversationKitResult).getCause();
        }
        throw new NoWhenBranchMatchedException();
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository$updateProactiveReferralLocalData$2", m37f = "ConversationScreenRepository.kt", m38i = {}, m39l = {377}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13202 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13202(Continuation<? super C13202> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenRepository.this.new C13202(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13202) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenRepository.this._eventsChannel.send(ConversationScreenRepositoryEvent.UpdateProactiveReferralData.INSTANCE, this) == coroutine_suspended) {
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

    public final Object updateProactiveReferralLocalData(Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.defaultDispatcher, new C13202(null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    public final Object retrieveInitialText(String str, Continuation<? super String> continuation) throws Throwable {
        C13161 c13161;
        if (continuation instanceof C13161) {
            c13161 = (C13161) continuation;
            if ((c13161.label & Integer.MIN_VALUE) != 0) {
                c13161.label -= Integer.MIN_VALUE;
            } else {
                c13161 = new C13161(continuation);
            }
        } else {
            c13161 = new C13161(continuation);
        }
        Object messagingPersistence = c13161.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13161.label;
        if (i == 0) {
            ResultKt.throwOnFailure(messagingPersistence);
            MessagingStorage messagingStorage = this.messagingStorage;
            c13161.label = 1;
            messagingPersistence = messagingStorage.getMessagingPersistence(str, c13161);
            if (messagingPersistence == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(messagingPersistence);
        }
        return ((MessagingUIPersistence) messagingPersistence).getComposerText();
    }

    public final Object persistComposerText(String str, String str2, Continuation<? super Unit> continuation) throws Throwable {
        C13131 c13131;
        ConversationScreenRepository conversationScreenRepository;
        if (continuation instanceof C13131) {
            c13131 = (C13131) continuation;
            if ((c13131.label & Integer.MIN_VALUE) != 0) {
                c13131.label -= Integer.MIN_VALUE;
            } else {
                c13131 = new C13131(continuation);
            }
        } else {
            c13131 = new C13131(continuation);
        }
        Object messagingPersistence = c13131.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13131.label;
        if (i == 0) {
            ResultKt.throwOnFailure(messagingPersistence);
            MessagingStorage messagingStorage = this.messagingStorage;
            c13131.L$0 = this;
            c13131.L$1 = str2;
            c13131.label = 1;
            messagingPersistence = messagingStorage.getMessagingPersistence(str, c13131);
            if (messagingPersistence == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenRepository = this;
        } else {
            if (i == 1) {
                str2 = (String) c13131.L$1;
                conversationScreenRepository = (ConversationScreenRepository) c13131.L$0;
                ResultKt.throwOnFailure(messagingPersistence);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(messagingPersistence);
            }
            return Unit.INSTANCE;
        }
        MessagingUIPersistence messagingUIPersistenceCopy$default = MessagingUIPersistence.copy$default((MessagingUIPersistence) messagingPersistence, null, str2, null, 5, null);
        MessagingStorage messagingStorage2 = conversationScreenRepository.messagingStorage;
        c13131.L$0 = null;
        c13131.L$1 = null;
        c13131.label = 2;
        if (messagingStorage2.setMessagingPersistence(messagingUIPersistenceCopy$default, c13131) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object updateComposerText(String str, final String str2, Continuation<? super Unit> continuation) {
        Object objUpdateMessagingUIPersistence = this.messagingStorage.updateMessagingUIPersistence(str, new Function1<MessagingUIPersistence, MessagingUIPersistence>() {
            {
                super(1);
            }

            @Override
            public final MessagingUIPersistence invoke(MessagingUIPersistence messagingUIPersistence) {
                Intrinsics.checkNotNullParameter(messagingUIPersistence, "messagingUIPersistence");
                return MessagingUIPersistence.copy$default(messagingUIPersistence, null, str2, null, 5, null);
            }
        }, continuation);
        return objUpdateMessagingUIPersistence == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdateMessagingUIPersistence : Unit.INSTANCE;
    }

    public final Object removeStoredForm(String str, final String str2, Continuation<? super Unit> continuation) {
        Object objUpdateMessagingUIPersistence = this.messagingStorage.updateMessagingUIPersistence(str, new Function1<MessagingUIPersistence, MessagingUIPersistence>() {
            {
                super(1);
            }

            @Override
            public final MessagingUIPersistence invoke(MessagingUIPersistence messagingUIPersistence) {
                Intrinsics.checkNotNullParameter(messagingUIPersistence, "messagingUIPersistence");
                messagingUIPersistence.getForms().remove(str2);
                return MessagingUIPersistence.copy$default(messagingUIPersistence, null, null, messagingUIPersistence.getForms(), 3, null);
            }
        }, continuation);
        return objUpdateMessagingUIPersistence == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdateMessagingUIPersistence : Unit.INSTANCE;
    }

    public final Object updateLocalStoredForm(DisplayedField displayedField, String str, String str2, Continuation<? super Unit> continuation) throws Throwable {
        C13191 c13191;
        ConversationScreenRepository conversationScreenRepository;
        if (continuation instanceof C13191) {
            c13191 = (C13191) continuation;
            if ((c13191.label & Integer.MIN_VALUE) != 0) {
                c13191.label -= Integer.MIN_VALUE;
            } else {
                c13191 = new C13191(continuation);
            }
        } else {
            c13191 = new C13191(continuation);
        }
        Object messagingPersistence = c13191.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13191.label;
        int i2 = 2;
        if (i == 0) {
            ResultKt.throwOnFailure(messagingPersistence);
            MessagingStorage messagingStorage = this.messagingStorage;
            c13191.L$0 = this;
            c13191.L$1 = displayedField;
            c13191.L$2 = str2;
            c13191.label = 1;
            messagingPersistence = messagingStorage.getMessagingPersistence(str, c13191);
            if (messagingPersistence == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenRepository = this;
        } else {
            if (i == 1) {
                str2 = (String) c13191.L$2;
                displayedField = (DisplayedField) c13191.L$1;
                conversationScreenRepository = (ConversationScreenRepository) c13191.L$0;
                ResultKt.throwOnFailure(messagingPersistence);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(messagingPersistence);
            }
            return Unit.INSTANCE;
        }
        MessagingUIPersistence messagingUIPersistence = (MessagingUIPersistence) messagingPersistence;
        Map<String, StoredForm> forms = messagingUIPersistence.getForms();
        StoredForm storedForm = forms.get(str2);
        Map map = null;
        Object[] objArr = 0;
        if (storedForm != null) {
            storedForm.getFields().put(Boxing.boxInt(displayedField.getIndex()), displayedField.getValue());
        } else {
            storedForm = new StoredForm(str2, map, i2, (DefaultConstructorMarker) (objArr == true ? 1 : 0));
            storedForm.getFields().put(Boxing.boxInt(displayedField.getIndex()), displayedField.getValue());
        }
        forms.put(str2, storedForm);
        MessagingStorage messagingStorage2 = conversationScreenRepository.messagingStorage;
        MessagingUIPersistence messagingUIPersistenceCopy$default = MessagingUIPersistence.copy$default(messagingUIPersistence, null, null, forms, 3, null);
        c13191.L$0 = null;
        c13191.L$1 = null;
        c13191.L$2 = null;
        c13191.label = 2;
        if (messagingStorage2.setMessagingPersistence(messagingUIPersistenceCopy$default, c13191) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object getLocalStoredForms(String str, Continuation<? super Map<String, DisplayedForm>> continuation) throws Throwable {
        C13061 c13061;
        Map map;
        if (continuation instanceof C13061) {
            c13061 = (C13061) continuation;
            if ((c13061.label & Integer.MIN_VALUE) != 0) {
                c13061.label -= Integer.MIN_VALUE;
            } else {
                c13061 = new C13061(continuation);
            }
        } else {
            c13061 = new C13061(continuation);
        }
        Object obj = c13061.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13061.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            LinkedHashMap linkedHashMap = new LinkedHashMap();
            MessagingStorage messagingStorage = this.messagingStorage;
            c13061.L$0 = linkedHashMap;
            c13061.label = 1;
            Object messagingPersistence = messagingStorage.getMessagingPersistence(str, c13061);
            if (messagingPersistence == coroutine_suspended) {
                return coroutine_suspended;
            }
            obj = messagingPersistence;
            map = linkedHashMap;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            map = (Map) c13061.L$0;
            ResultKt.throwOnFailure(obj);
        }
        Iterator<Map.Entry<String, StoredForm>> it = ((MessagingUIPersistence) obj).getForms().entrySet().iterator();
        while (it.hasNext()) {
            StoredForm value = it.next().getValue();
            LinkedHashMap linkedHashMap2 = new LinkedHashMap();
            for (Map.Entry<Integer, String> entry : value.getFields().entrySet()) {
                int iIntValue = entry.getKey().intValue();
                linkedHashMap2.put(Boxing.boxInt(iIntValue), new DisplayedField(iIntValue, entry.getValue()));
            }
            map.put(value.getFormId(), new DisplayedForm(value.getFormId(), linkedHashMap2));
        }
        return map;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository$suspendUntilConnected$2", m37f = "ConversationScreenRepository.kt", m38i = {}, m39l = {469}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13172 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13172(Continuation<? super C13172> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenRepository.this.new C13172(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13172) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                if (ConversationScreenRepository.this.conversationKit.getConnectionStatusFlow().getValue() != ConnectionStatus.CONNECTED_REALTIME) {
                    this.label = 1;
                    if (FlowKt.first(ConversationScreenRepository.this.conversationKit.getConnectionStatusFlow(), new AnonymousClass1(null), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }

        @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "", "it", "Lzendesk/conversationkit/android/ConnectionStatus;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository$suspendUntilConnected$2$1", m37f = "ConversationScreenRepository.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<ConnectionStatus, Continuation<? super Boolean>, Object> {
            Object L$0;
            int label;

            AnonymousClass1(Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
            }

            @Override
            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                AnonymousClass1 anonymousClass1 = new AnonymousClass1(continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            @Override
            public final Object invoke(ConnectionStatus connectionStatus, Continuation<? super Boolean> continuation) {
                return ((AnonymousClass1) create(connectionStatus, continuation)).invokeSuspend(Unit.INSTANCE);
            }

            @Override
            public final Object invokeSuspend(Object obj) throws Throwable {
                IntrinsicsKt.getCOROUTINE_SUSPENDED();
                if (this.label != 0) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
                return Boxing.boxBoolean(((ConnectionStatus) this.L$0) == ConnectionStatus.CONNECTED_REALTIME);
            }
        }
    }

    public final Object suspendUntilConnected(Continuation<? super Unit> continuation) {
        Object objWithTimeout = TimeoutKt.withTimeout(FAYE_CONNECTION_TIMEOUT, new C13172(null), continuation);
        return objWithTimeout == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithTimeout : Unit.INSTANCE;
    }

    public final Object getUserAuthToken(Continuation<? super String> continuation) throws Throwable {
        C13101 c13101;
        if (continuation instanceof C13101) {
            c13101 = (C13101) continuation;
            if ((c13101.label & Integer.MIN_VALUE) != 0) {
                c13101.label -= Integer.MIN_VALUE;
            } else {
                c13101 = new C13101(continuation);
            }
        } else {
            c13101 = new C13101(continuation);
        }
        Object currentUser = c13101.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13101.label;
        if (i == 0) {
            ResultKt.throwOnFailure(currentUser);
            ConversationKit conversationKit = this.conversationKit;
            c13101.label = 1;
            currentUser = conversationKit.getCurrentUser(c13101);
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
            return UserExtensionsKt.getAuthorization(user);
        }
        return null;
    }

    public final Object downloadAttachment(String str, Message message, Continuation<? super Unit> continuation) {
        Object objDownloadAttachment = this.conversationKit.downloadAttachment(str, message, continuation);
        return objDownloadAttachment == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDownloadAttachment : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository$Companion;", "", "()V", "FAYE_CONNECTION_TIMEOUT", "", "LOG_TAG", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
