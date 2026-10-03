package zendesk.conversationkit.android;

import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.internal.ConversationKitStore;
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

@Metadata(m17d1 = {"\u0000´\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\f\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u0011H\u0016J\u0016\u0010\u0012\u001a\u00020\u000f2\u0006\u0010\u0013\u001a\u00020\u0014H\u0096@¢\u0006\u0002\u0010\u0015J\u0016\u0010\u0016\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u0018H\u0096@¢\u0006\u0002\u0010\u0019J\b\u0010\u0004\u001a\u00020\u0005H\u0016J\u001e\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u001c0\u001b2\b\u0010\u0017\u001a\u0004\u0018\u00010\u0018H\u0096@¢\u0006\u0002\u0010\u001dJ\u001e\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u001f0\u001b2\b\u0010\u0017\u001a\u0004\u0018\u00010\u0018H\u0096@¢\u0006\u0002\u0010\u001dJ\u0010\u0010 \u001a\u00020\u000f2\u0006\u0010!\u001a\u00020\"H\u0016J\u001e\u0010#\u001a\u00020\u000f2\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020'H\u0096@¢\u0006\u0002\u0010(J\u000e\u0010)\u001a\u00020%H\u0096@¢\u0006\u0002\u0010*J\b\u0010+\u001a\u00020,H\u0016J\u001c\u0010-\u001a\b\u0012\u0004\u0012\u00020\u001c0\u001b2\u0006\u0010$\u001a\u00020%H\u0096@¢\u0006\u0002\u0010.J$\u0010/\u001a\b\u0012\u0004\u0012\u0002000\u001b2\u0006\u00101\u001a\u00020\u00182\u0006\u00102\u001a\u000203H\u0096@¢\u0006\u0002\u00104J\u0010\u00105\u001a\u0004\u0018\u00010\u001fH\u0096@¢\u0006\u0002\u0010*J*\u00106\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020'070\u001b2\u0006\u0010$\u001a\u00020%2\u0006\u00108\u001a\u000209H\u0096@¢\u0006\u0002\u0010:J\u001c\u0010;\u001a\b\u0012\u0004\u0012\u00020\u00140\u001b2\u0006\u0010\u0017\u001a\u00020\u0018H\u0096@¢\u0006\u0002\u0010\u0019J\b\u0010<\u001a\u00020=H\u0016J\u0014\u0010>\u001a\b\u0012\u0004\u0012\u00020?0\u001bH\u0096@¢\u0006\u0002\u0010*J\u001c\u0010@\u001a\b\u0012\u0004\u0012\u00020A0\u001b2\u0006\u0010$\u001a\u00020%H\u0096@¢\u0006\u0002\u0010.J\u001c\u0010B\u001a\b\u0012\u0004\u0012\u00020\u001f0\u001b2\u0006\u0010C\u001a\u00020%H\u0096@¢\u0006\u0002\u0010.J\u0014\u0010D\u001a\b\u0012\u0004\u0012\u00020\u000f0\u001bH\u0096@¢\u0006\u0002\u0010*J\u000e\u0010E\u001a\u00020\u000fH\u0096@¢\u0006\u0002\u0010*J&\u0010F\u001a\b\u0012\u0004\u0012\u00020\u001c0\u001b2\b\u0010\u0017\u001a\u0004\u0018\u00010\u00182\u0006\u0010$\u001a\u00020%H\u0096@¢\u0006\u0002\u0010GJ\u0010\u0010H\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u0011H\u0016J\u000e\u0010I\u001a\u00020\u000fH\u0096@¢\u0006\u0002\u0010*J\u001e\u0010J\u001a\u00020\u000f2\u0006\u0010K\u001a\u00020L2\u0006\u0010$\u001a\u00020%H\u0096@¢\u0006\u0002\u0010MJ$\u0010N\u001a\b\u0012\u0004\u0012\u00020'0\u001b2\u0006\u0010&\u001a\u00020'2\u0006\u0010$\u001a\u00020%H\u0096@¢\u0006\u0002\u0010OJ$\u0010P\u001a\b\u0012\u0004\u0012\u00020\u000f0\u001b2\u0006\u0010$\u001a\u00020%2\u0006\u0010Q\u001a\u00020%H\u0096@¢\u0006\u0002\u0010RJ\u0016\u0010S\u001a\u00020\u000f2\u0006\u0010T\u001a\u00020?H\u0096@¢\u0006\u0002\u0010UJ\u0016\u0010V\u001a\u00020\u000f2\u0006\u0010W\u001a\u00020%H\u0096@¢\u0006\u0002\u0010.R\u001a\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006X"}, m18d2 = {"Lzendesk/conversationkit/android/DefaultConversationKit;", "Lzendesk/conversationkit/android/ConversationKit;", "conversationKitStore", "Lzendesk/conversationkit/android/internal/ConversationKitStore;", "conversationMetadataService", "Lzendesk/conversationkit/android/internal/metadata/ConversationMetadataService;", "(Lzendesk/conversationkit/android/internal/ConversationKitStore;Lzendesk/conversationkit/android/internal/metadata/ConversationMetadataService;)V", "connectionStatusFlow", "Lkotlinx/coroutines/flow/StateFlow;", "Lzendesk/conversationkit/android/ConnectionStatus;", "getConnectionStatusFlow", "()Lkotlinx/coroutines/flow/StateFlow;", "userCreationMutex", "Lkotlinx/coroutines/sync/Mutex;", "addEventListener", "", "listener", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "addProactiveMessage", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearProactiveMessage", "proactiveMessageId", "", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createConversation", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "(Ljava/lang/Integer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createUser", "Lzendesk/conversationkit/android/model/User;", "dispatchEvent", "event", "Lzendesk/conversationkit/android/ConversationKitEvent;", "downloadAttachment", "conversationId", "", "message", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getClientId", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConfig", "Lzendesk/conversationkit/android/model/Config;", "getConversation", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConversations", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "offset", "fromCache", "", "(IZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getCurrentUser", "getMessages", "", "beforeTimestamp", "", "(Ljava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getProactiveMessage", "getSettings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "getVisitType", "Lzendesk/conversationkit/android/model/VisitType;", "getWaitTimeForConversation", "Lzendesk/conversationkit/android/model/WaitTimeData;", "loginUser", "jwt", "logoutUser", "pause", "proactiveMessageReferral", "(Ljava/lang/Integer;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeEventListener", "resume", "sendActivityData", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "(Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendMessage", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendPostbackMessage", "actionId", "(Ljava/lang/String;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setVisitType", "visitType", "(Lzendesk/conversationkit/android/model/VisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updatePushNotificationToken", "pushNotificationToken", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultConversationKit implements ConversationKit {
    private final StateFlow<ConnectionStatus> connectionStatusFlow;
    private final ConversationKitStore conversationKitStore;
    private final ConversationMetadataService conversationMetadataService;
    private final Mutex userCreationMutex;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.DefaultConversationKit", m37f = "ConversationKit.kt", m38i = {0, 0, 0, 1}, m39l = {498, 370}, m40m = "createUser", m41n = {"this", "proactiveMessageId", "$this$withLock_u24default$iv", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$0"})
    static final class C09921 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09921(Continuation<? super C09921> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return DefaultConversationKit.this.createUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.DefaultConversationKit", m37f = "ConversationKit.kt", m38i = {0, 0, 0, 1}, m39l = {498, 373}, m40m = "loginUser", m41n = {"this", "jwt", "$this$withLock_u24default$iv", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$0"})
    static final class C09931 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09931(Continuation<? super C09931> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return DefaultConversationKit.this.loginUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.DefaultConversationKit", m37f = "ConversationKit.kt", m38i = {0, 0, 1}, m39l = {498, 382}, m40m = "logoutUser", m41n = {"this", "$this$withLock_u24default$iv", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$0"})
    static final class C09941 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C09941(Continuation<? super C09941> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return DefaultConversationKit.this.logoutUser(this);
        }
    }

    public DefaultConversationKit(ConversationKitStore conversationKitStore, ConversationMetadataService conversationMetadataService) {
        Intrinsics.checkNotNullParameter(conversationKitStore, "conversationKitStore");
        Intrinsics.checkNotNullParameter(conversationMetadataService, "conversationMetadataService");
        this.conversationKitStore = conversationKitStore;
        this.conversationMetadataService = conversationMetadataService;
        this.userCreationMutex = MutexKt.Mutex$default(false, 1, null);
        this.connectionStatusFlow = conversationKitStore.getConnectionStatusFlow();
    }

    @Override
    public StateFlow<ConnectionStatus> getConnectionStatusFlow() {
        return this.connectionStatusFlow;
    }

    @Override
    public void addEventListener(ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        this.conversationKitStore.addEventListener(listener);
    }

    @Override
    public void removeEventListener(ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        this.conversationKitStore.removeEventListener(listener);
    }

    @Override
    public void dispatchEvent(ConversationKitEvent event) {
        Intrinsics.checkNotNullParameter(event, "event");
        this.conversationKitStore.m204xb3d1d52d(CollectionsKt.listOf(event));
    }

    @Override
    public Object pause(Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(Action.PauseRealtimeConnection.INSTANCE, continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object resume(Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(Action.StartRealtimeConnection.INSTANCE, continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public ConversationKitSettings getSettings() {
        return this.conversationKitStore.getConversationKitSettings();
    }

    @Override
    public Config getConfig() {
        return this.conversationKitStore.getConfig();
    }

    @Override
    public Object createUser(Integer num, Continuation<? super ConversationKitResult<User>> continuation) throws Throwable {
        C09921 c09921;
        Mutex mutex;
        DefaultConversationKit defaultConversationKit;
        Throwable th;
        Mutex mutex2;
        if (continuation instanceof C09921) {
            c09921 = (C09921) continuation;
            if ((c09921.label & Integer.MIN_VALUE) != 0) {
                c09921.label -= Integer.MIN_VALUE;
            } else {
                c09921 = new C09921(continuation);
            }
        } else {
            c09921 = new C09921(continuation);
        }
        Object obj = c09921.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09921.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                mutex = this.userCreationMutex;
                c09921.L$0 = this;
                c09921.L$1 = num;
                c09921.L$2 = mutex;
                c09921.label = 1;
                if (mutex.lock(null, c09921) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                defaultConversationKit = this;
            } else {
                if (i != 1) {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    mutex2 = (Mutex) c09921.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        ConversationKitResult conversationKitResult = (ConversationKitResult) obj;
                        mutex2.unlock(null);
                        return conversationKitResult;
                    } catch (Throwable th2) {
                        th = th2;
                        mutex2.unlock(null);
                        throw th;
                    }
                }
                Mutex mutex3 = (Mutex) c09921.L$2;
                Integer num2 = (Integer) c09921.L$1;
                defaultConversationKit = (DefaultConversationKit) c09921.L$0;
                ResultKt.throwOnFailure(obj);
                mutex = mutex3;
                num = num2;
            }
            ConversationKitStore conversationKitStore = defaultConversationKit.conversationKitStore;
            Action.CreateUser createUser = new Action.CreateUser(num);
            c09921.L$0 = mutex;
            c09921.L$1 = null;
            c09921.L$2 = null;
            c09921.label = 2;
            Object objDispatch = conversationKitStore.dispatch(createUser, c09921);
            if (objDispatch == coroutine_suspended) {
                return coroutine_suspended;
            }
            Mutex mutex4 = mutex;
            obj = objDispatch;
            mutex2 = mutex4;
            ConversationKitResult conversationKitResult2 = (ConversationKitResult) obj;
            mutex2.unlock(null);
            return conversationKitResult2;
        } catch (Throwable th3) {
            Mutex mutex5 = mutex;
            th = th3;
            mutex2 = mutex5;
            mutex2.unlock(null);
            throw th;
        }
    }

    @Override
    public Object loginUser(String str, Continuation<? super ConversationKitResult<User>> continuation) throws Throwable {
        C09931 c09931;
        Mutex mutex;
        DefaultConversationKit defaultConversationKit;
        Throwable th;
        Mutex mutex2;
        if (continuation instanceof C09931) {
            c09931 = (C09931) continuation;
            if ((c09931.label & Integer.MIN_VALUE) != 0) {
                c09931.label -= Integer.MIN_VALUE;
            } else {
                c09931 = new C09931(continuation);
            }
        } else {
            c09931 = new C09931(continuation);
        }
        Object obj = c09931.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09931.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                mutex = this.userCreationMutex;
                c09931.L$0 = this;
                c09931.L$1 = str;
                c09931.L$2 = mutex;
                c09931.label = 1;
                if (mutex.lock(null, c09931) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                defaultConversationKit = this;
            } else {
                if (i != 1) {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    mutex2 = (Mutex) c09931.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        ConversationKitResult conversationKitResult = (ConversationKitResult) obj;
                        mutex2.unlock(null);
                        return conversationKitResult;
                    } catch (Throwable th2) {
                        th = th2;
                        mutex2.unlock(null);
                        throw th;
                    }
                }
                Mutex mutex3 = (Mutex) c09931.L$2;
                String str2 = (String) c09931.L$1;
                defaultConversationKit = (DefaultConversationKit) c09931.L$0;
                ResultKt.throwOnFailure(obj);
                mutex = mutex3;
                str = str2;
            }
            ConversationKitStore conversationKitStore = defaultConversationKit.conversationKitStore;
            Action.LoginUser loginUser = new Action.LoginUser(str);
            c09931.L$0 = mutex;
            c09931.L$1 = null;
            c09931.L$2 = null;
            c09931.label = 2;
            Object objDispatch = conversationKitStore.dispatch(loginUser, c09931);
            if (objDispatch == coroutine_suspended) {
                return coroutine_suspended;
            }
            Mutex mutex4 = mutex;
            obj = objDispatch;
            mutex2 = mutex4;
            ConversationKitResult conversationKitResult2 = (ConversationKitResult) obj;
            mutex2.unlock(null);
            return conversationKitResult2;
        } catch (Throwable th3) {
            Mutex mutex5 = mutex;
            th = th3;
            mutex2 = mutex5;
            mutex2.unlock(null);
            throw th;
        }
    }

    @Override
    public Object getCurrentUser(Continuation<? super User> continuation) {
        return this.conversationKitStore.getCurrentUser(continuation);
    }

    @Override
    public Object getClientId(Continuation<? super String> continuation) {
        return this.conversationKitStore.getAccessLevel().getClientId(continuation);
    }

    @Override
    public Object logoutUser(Continuation<? super ConversationKitResult<Unit>> continuation) throws Throwable {
        C09941 c09941;
        Mutex mutex;
        DefaultConversationKit defaultConversationKit;
        Mutex mutex2;
        Throwable th;
        if (continuation instanceof C09941) {
            c09941 = (C09941) continuation;
            if ((c09941.label & Integer.MIN_VALUE) != 0) {
                c09941.label -= Integer.MIN_VALUE;
            } else {
                c09941 = new C09941(continuation);
            }
        } else {
            c09941 = new C09941(continuation);
        }
        Object obj = c09941.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09941.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                mutex = this.userCreationMutex;
                c09941.L$0 = this;
                c09941.L$1 = mutex;
                c09941.label = 1;
                if (mutex.lock(null, c09941) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                defaultConversationKit = this;
            } else {
                if (i != 1) {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    mutex2 = (Mutex) c09941.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        ConversationKitResult conversationKitResult = (ConversationKitResult) obj;
                        mutex2.unlock(null);
                        return conversationKitResult;
                    } catch (Throwable th2) {
                        th = th2;
                        mutex2.unlock(null);
                        throw th;
                    }
                }
                Mutex mutex3 = (Mutex) c09941.L$1;
                defaultConversationKit = (DefaultConversationKit) c09941.L$0;
                ResultKt.throwOnFailure(obj);
                mutex = mutex3;
            }
            ConversationKitStore conversationKitStore = defaultConversationKit.conversationKitStore;
            Action.LogoutUser logoutUser = Action.LogoutUser.INSTANCE;
            c09941.L$0 = mutex;
            c09941.L$1 = null;
            c09941.label = 2;
            Object objDispatch = conversationKitStore.dispatch(logoutUser, c09941);
            if (objDispatch == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutex2 = mutex;
            obj = objDispatch;
            ConversationKitResult conversationKitResult2 = (ConversationKitResult) obj;
            mutex2.unlock(null);
            return conversationKitResult2;
        } catch (Throwable th3) {
            mutex2 = mutex;
            th = th3;
            mutex2.unlock(null);
            throw th;
        }
    }

    @Override
    public Object createConversation(Integer num, Continuation<? super ConversationKitResult<Conversation>> continuation) {
        return this.conversationKitStore.dispatch(new Action.CreateConversation(num), continuation);
    }

    @Override
    public Object getConversation(String str, Continuation<? super ConversationKitResult<Conversation>> continuation) {
        return this.conversationKitStore.dispatch(new Action.GetConversation(str), continuation);
    }

    @Override
    public Object sendMessage(Message message, String str, Continuation<? super ConversationKitResult<Message>> continuation) {
        return this.conversationKitStore.dispatch(new Action.PrepareMessage(message, str), continuation);
    }

    @Override
    public Object getMessages(String str, double d, Continuation<? super ConversationKitResult<? extends List<Message>>> continuation) {
        return this.conversationKitStore.dispatch(new Action.LoadMoreMessages(str, d), continuation);
    }

    @Override
    public Object updatePushNotificationToken(String str, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.PreparePushToken(str), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object sendActivityData(ActivityData activityData, String str, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.SendActivityData(activityData, str), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object getVisitType(Continuation<? super ConversationKitResult<? extends VisitType>> continuation) {
        return this.conversationKitStore.dispatch(Action.GetVisitType.INSTANCE, continuation);
    }

    @Override
    public Object setVisitType(VisitType visitType, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.SetVisitType(visitType), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object addProactiveMessage(ProactiveMessage proactiveMessage, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.AddProactiveMessage(proactiveMessage), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object getProactiveMessage(int i, Continuation<? super ConversationKitResult<ProactiveMessage>> continuation) {
        return this.conversationKitStore.dispatch(new Action.GetProactiveMessage(i), continuation);
    }

    @Override
    public Object clearProactiveMessage(int i, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.ClearProactiveMessage(i), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object proactiveMessageReferral(Integer num, String str, Continuation<? super ConversationKitResult<Conversation>> continuation) {
        return this.conversationKitStore.dispatch(new Action.ProactiveMessageReferral(str, num), continuation);
    }

    @Override
    public Object getConversations(int i, boolean z, Continuation<? super ConversationKitResult<ConversationsPagination>> continuation) {
        return this.conversationKitStore.dispatch(new Action.GetConversations(i, z), continuation);
    }

    @Override
    public ConversationMetadataService getConversationMetadataService() {
        return this.conversationMetadataService;
    }

    @Override
    public Object sendPostbackMessage(String str, String str2, Continuation<? super ConversationKitResult<Unit>> continuation) {
        return this.conversationKitStore.dispatch(new Action.SendPostbackAction(str, str2), continuation);
    }

    @Override
    public Object downloadAttachment(String str, Message message, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.DownloadAttachmentAction(str, message), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object getWaitTimeForConversation(String str, Continuation<? super ConversationKitResult<WaitTimeData>> continuation) {
        return this.conversationKitStore.dispatch(new Action.GetWaitTimeForConversation(str), continuation);
    }
}
