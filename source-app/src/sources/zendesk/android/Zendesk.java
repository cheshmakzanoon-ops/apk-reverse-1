package zendesk.android;

import android.content.Context;
import java.util.concurrent.CancellationException;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.encoding.Base64;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CompletableJob;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.JobKt__JobKt;
import kotlinx.coroutines.SupervisorKt;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;
import net.aihelp.data.track.data.TrackType;
import zendesk.android.events.ZendeskEventListener;
import zendesk.android.events.internal.ZendeskEventDispatcher;
import zendesk.android.internal.NotInitializedConversationKit;
import zendesk.android.internal.ZendeskFactory;
import zendesk.android.internal.frontendevents.pageviewevents.NotInitializedPageViewEvents;
import zendesk.android.internal.frontendevents.pageviewevents.PageViewEvents;
import zendesk.android.internal.p013di.DaggerZendeskComponent;
import zendesk.android.internal.p013di.ZendeskComponent;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.internal.p013di.ZendeskModule;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.MessagingFactory;
import zendesk.android.messaging.internal.NotInitializedMessaging;
import zendesk.android.pageviewevents.PageView;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.User;
import zendesk.logger.Logger;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u0000 %2\u00020\u0001:\u0001%B/\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u000e\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013J\"\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00170\u00152\u0006\u0010\u0018\u001a\u00020\u0019H\u0086@¢\u0006\u0002\u0010\u001aJ*\u0010\u0014\u001a\u00020\u00112\u0006\u0010\u0018\u001a\u00020\u00192\f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00160\u001c2\f\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00170\u001eJ\u001a\u0010\u001f\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00170\u0015H\u0086@¢\u0006\u0002\u0010 J\"\u0010\u001f\u001a\u00020\u00112\f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00110\u001c2\f\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00170\u001eJ\u000e\u0010!\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013J*\u0010\"\u001a\u00020\u00112\u0006\u0010#\u001a\u00020$2\f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00110\u001c2\f\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00170\u001eR\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\b\u000f¨\u0006&"}, m18d2 = {"Lzendesk/android/Zendesk;", "", "messaging", "Lzendesk/android/messaging/Messaging;", "scope", "Lkotlinx/coroutines/CoroutineScope;", "eventDispatcher", "Lzendesk/android/events/internal/ZendeskEventDispatcher;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "pageViewEvents", "Lzendesk/android/internal/frontendevents/pageviewevents/PageViewEvents;", "(Lzendesk/android/messaging/Messaging;Lkotlinx/coroutines/CoroutineScope;Lzendesk/android/events/internal/ZendeskEventDispatcher;Lzendesk/conversationkit/android/ConversationKit;Lzendesk/android/internal/frontendevents/pageviewevents/PageViewEvents;)V", "getMessaging", "()Lzendesk/android/messaging/Messaging;", "scope$1", "addEventListener", "", "listener", "Lzendesk/android/events/ZendeskEventListener;", "loginUser", "Lzendesk/android/ZendeskResult;", "Lzendesk/android/ZendeskUser;", "", "jwt", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "successCallback", "Lzendesk/android/SuccessCallback;", "failureCallback", "Lzendesk/android/FailureCallback;", "logoutUser", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeEventListener", "sendPageView", "pageView", "Lzendesk/android/pageviewevents/PageView;", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class Zendesk {

    public static final Companion INSTANCE = new Companion(null);
    public static final String LOG_TAG = "Zendesk";
    private static final Mutex initializeMutex;
    private static CoroutineScope scope;
    private static final CompletableJob supervisorJob;

    private static Zendesk f254zendesk;
    private final ConversationKit conversationKit;
    private final ZendeskEventDispatcher eventDispatcher;
    private final Messaging messaging;
    private final PageViewEvents pageViewEvents;

    private final CoroutineScope scope;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.Zendesk", m37f = "Zendesk.kt", m38i = {}, m39l = {103}, m40m = "loginUser", m41n = {}, m42s = {})
    static final class C09351 extends ContinuationImpl {
        int label;
        Object result;

        C09351(Continuation<? super C09351> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return Zendesk.this.loginUser(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.Zendesk", m37f = "Zendesk.kt", m38i = {}, m39l = {137}, m40m = "logoutUser", m41n = {}, m42s = {})
    static final class C09371 extends ContinuationImpl {
        int label;
        Object result;

        C09371(Continuation<? super C09371> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return Zendesk.this.logoutUser(this);
        }
    }

    public static final Zendesk getInstance() {
        return INSTANCE.getInstance();
    }

    @JvmStatic
    public static final void initialize(Context context, String str, SuccessCallback<Zendesk> successCallback, FailureCallback<Throwable> failureCallback) {
        INSTANCE.initialize(context, str, successCallback, failureCallback);
    }

    @JvmStatic
    public static final void initialize(Context context, String str, SuccessCallback<Zendesk> successCallback, FailureCallback<Throwable> failureCallback, MessagingFactory messagingFactory) {
        INSTANCE.initialize(context, str, successCallback, failureCallback, messagingFactory);
    }

    @JvmStatic
    public static final void invalidate() {
        INSTANCE.invalidate();
    }

    @Inject
    public Zendesk(Messaging messaging, CoroutineScope scope2, ZendeskEventDispatcher eventDispatcher, ConversationKit conversationKit, PageViewEvents pageViewEvents) {
        Intrinsics.checkNotNullParameter(messaging, "messaging");
        Intrinsics.checkNotNullParameter(scope2, "scope");
        Intrinsics.checkNotNullParameter(eventDispatcher, "eventDispatcher");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(pageViewEvents, "pageViewEvents");
        this.messaging = messaging;
        this.scope = scope2;
        this.eventDispatcher = eventDispatcher;
        this.conversationKit = conversationKit;
        this.pageViewEvents = pageViewEvents;
    }

    public final Messaging getMessaging() {
        return this.messaging;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.Zendesk$addEventListener$1", m37f = "Zendesk.kt", m38i = {}, m39l = {Base64.mimeLineLength}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09341 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ZendeskEventListener $listener;
        int label;

        C09341(ZendeskEventListener zendeskEventListener, Continuation<? super C09341> continuation) {
            super(2, continuation);
            this.$listener = zendeskEventListener;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return Zendesk.this.new C09341(this.$listener, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09341) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (Zendesk.this.eventDispatcher.addEventListener(this.$listener, this) == coroutine_suspended) {
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

    public final void addEventListener(ZendeskEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        BuildersKt__Builders_commonKt.launch$default(this.scope, null, null, new C09341(listener, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.Zendesk$removeEventListener$1", m37f = "Zendesk.kt", m38i = {}, m39l = {89}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09391 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ZendeskEventListener $listener;
        int label;

        C09391(ZendeskEventListener zendeskEventListener, Continuation<? super C09391> continuation) {
            super(2, continuation);
            this.$listener = zendeskEventListener;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return Zendesk.this.new C09391(this.$listener, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09391) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (Zendesk.this.eventDispatcher.removeEventListener(this.$listener, this) == coroutine_suspended) {
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

    public final void removeEventListener(ZendeskEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        BuildersKt__Builders_commonKt.launch$default(this.scope, null, null, new C09391(listener, null), 3, null);
    }

    public final Object loginUser(String str, Continuation continuation) throws Throwable {
        C09351 c09351;
        if (continuation instanceof C09351) {
            c09351 = (C09351) continuation;
            if ((c09351.label & Integer.MIN_VALUE) != 0) {
                c09351.label -= Integer.MIN_VALUE;
            } else {
                c09351 = new C09351(continuation);
            }
        } else {
            c09351 = new C09351(continuation);
        }
        Object objLoginUser = c09351.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09351.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objLoginUser);
            ConversationKit conversationKit = this.conversationKit;
            c09351.label = 1;
            objLoginUser = conversationKit.loginUser(str, c09351);
            if (objLoginUser == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objLoginUser);
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) objLoginUser;
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            return new ZendeskResult.Failure(((ConversationKitResult.Failure) conversationKitResult).getCause());
        }
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            return new ZendeskResult.Success(ZendeskUserKt.toZendeskUser((User) ((ConversationKitResult.Success) conversationKitResult).getValue()));
        }
        throw new NoWhenBranchMatchedException();
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.Zendesk$loginUser$2", m37f = "Zendesk.kt", m38i = {}, m39l = {122}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09362 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final FailureCallback<Throwable> $failureCallback;
        final String $jwt;
        final SuccessCallback<ZendeskUser> $successCallback;
        int label;

        C09362(String str, FailureCallback<Throwable> failureCallback, SuccessCallback<ZendeskUser> successCallback, Continuation<? super C09362> continuation) {
            super(2, continuation);
            this.$jwt = str;
            this.$failureCallback = failureCallback;
            this.$successCallback = successCallback;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return Zendesk.this.new C09362(this.$jwt, this.$failureCallback, this.$successCallback, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09362) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = Zendesk.this.loginUser(this.$jwt, this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            ZendeskResult zendeskResult = (ZendeskResult) obj;
            if (zendeskResult instanceof ZendeskResult.Failure) {
                this.$failureCallback.onFailure((Throwable) ((ZendeskResult.Failure) zendeskResult).getError());
            } else if (zendeskResult instanceof ZendeskResult.Success) {
                this.$successCallback.onSuccess((ZendeskUser) ((ZendeskResult.Success) zendeskResult).getValue());
            }
            return Unit.INSTANCE;
        }
    }

    public final void loginUser(String jwt, SuccessCallback<ZendeskUser> successCallback, FailureCallback<Throwable> failureCallback) {
        Intrinsics.checkNotNullParameter(jwt, "jwt");
        Intrinsics.checkNotNullParameter(successCallback, "successCallback");
        Intrinsics.checkNotNullParameter(failureCallback, "failureCallback");
        BuildersKt__Builders_commonKt.launch$default(this.scope, null, null, new C09362(jwt, failureCallback, successCallback, null), 3, null);
    }

    public final Object logoutUser(Continuation continuation) throws Throwable {
        C09371 c09371;
        if (continuation instanceof C09371) {
            c09371 = (C09371) continuation;
            if ((c09371.label & Integer.MIN_VALUE) != 0) {
                c09371.label -= Integer.MIN_VALUE;
            } else {
                c09371 = new C09371(continuation);
            }
        } else {
            c09371 = new C09371(continuation);
        }
        Object objLogoutUser = c09371.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09371.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objLogoutUser);
            ConversationKit conversationKit = this.conversationKit;
            c09371.label = 1;
            objLogoutUser = conversationKit.logoutUser(c09371);
            if (objLogoutUser == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objLogoutUser);
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) objLogoutUser;
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            return new ZendeskResult.Failure(((ConversationKitResult.Failure) conversationKitResult).getCause());
        }
        if (!(conversationKitResult instanceof ConversationKitResult.Success)) {
            throw new NoWhenBranchMatchedException();
        }
        ((ConversationKitResult.Success) conversationKitResult).getValue();
        return new ZendeskResult.Success(Unit.INSTANCE);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.Zendesk$logoutUser$2", m37f = "Zendesk.kt", m38i = {}, m39l = {TrackType.TRACK_FAQ_CLICK_CUSTOMER_SERVICE}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09382 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final FailureCallback<Throwable> $failureCallback;
        final SuccessCallback<Unit> $successCallback;
        int label;

        C09382(FailureCallback<Throwable> failureCallback, SuccessCallback<Unit> successCallback, Continuation<? super C09382> continuation) {
            super(2, continuation);
            this.$failureCallback = failureCallback;
            this.$successCallback = successCallback;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return Zendesk.this.new C09382(this.$failureCallback, this.$successCallback, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09382) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = Zendesk.this.logoutUser(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            ZendeskResult zendeskResult = (ZendeskResult) obj;
            if (zendeskResult instanceof ZendeskResult.Failure) {
                this.$failureCallback.onFailure((Throwable) ((ZendeskResult.Failure) zendeskResult).getError());
            } else if (zendeskResult instanceof ZendeskResult.Success) {
                SuccessCallback<Unit> successCallback = this.$successCallback;
                ((ZendeskResult.Success) zendeskResult).getValue();
                successCallback.onSuccess(Unit.INSTANCE);
            }
            return Unit.INSTANCE;
        }
    }

    public final void logoutUser(SuccessCallback<Unit> successCallback, FailureCallback<Throwable> failureCallback) {
        Intrinsics.checkNotNullParameter(successCallback, "successCallback");
        Intrinsics.checkNotNullParameter(failureCallback, "failureCallback");
        BuildersKt__Builders_commonKt.launch$default(this.scope, null, null, new C09382(failureCallback, successCallback, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.Zendesk$sendPageView$1", m37f = "Zendesk.kt", m38i = {}, m39l = {175}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09401 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final FailureCallback<Throwable> $failureCallback;
        final PageView $pageView;
        final SuccessCallback<Unit> $successCallback;
        int label;

        C09401(PageView pageView, FailureCallback<Throwable> failureCallback, SuccessCallback<Unit> successCallback, Continuation<? super C09401> continuation) {
            super(2, continuation);
            this.$pageView = pageView;
            this.$failureCallback = failureCallback;
            this.$successCallback = successCallback;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return Zendesk.this.new C09401(this.$pageView, this.$failureCallback, this.$successCallback, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09401) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = Zendesk.this.pageViewEvents.sendPageViewEvent(this.$pageView, this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            ZendeskResult zendeskResult = (ZendeskResult) obj;
            if (zendeskResult instanceof ZendeskResult.Failure) {
                this.$failureCallback.onFailure((Throwable) ((ZendeskResult.Failure) zendeskResult).getError());
            } else if (zendeskResult instanceof ZendeskResult.Success) {
                SuccessCallback<Unit> successCallback = this.$successCallback;
                ((ZendeskResult.Success) zendeskResult).getValue();
                successCallback.onSuccess(Unit.INSTANCE);
            }
            return Unit.INSTANCE;
        }
    }

    public final void sendPageView(PageView pageView, SuccessCallback<Unit> successCallback, FailureCallback<Throwable> failureCallback) {
        Intrinsics.checkNotNullParameter(pageView, "pageView");
        Intrinsics.checkNotNullParameter(successCallback, "successCallback");
        Intrinsics.checkNotNullParameter(failureCallback, "failureCallback");
        BuildersKt__Builders_commonKt.launch$default(this.scope, null, null, new C09401(pageView, failureCallback, successCallback, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J@\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00042\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\b0\u00172\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00192\n\b\u0002\u0010\u001b\u001a\u0004\u0018\u00010\u001cH\u0007J@\u0010\u0011\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u001a0\u001d2\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00042\n\b\u0002\u0010\u001b\u001a\u0004\u0018\u00010\u001c2\b\b\u0002\u0010\u001e\u001a\u00020\u001fH\u0086@¢\u0006\u0002\u0010 J\b\u0010!\u001a\u00020\u0012H\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0080T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0007\u001a\u00020\b8FX\u0087\u0004¢\u0006\f\u0012\u0004\b\t\u0010\u0002\u001a\u0004\b\n\u0010\u000bR\u000e\u0010\f\u001a\u00020\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0010\u001a\u0004\u0018\u00010\bX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\""}, m18d2 = {"Lzendesk/android/Zendesk$Companion;", "", "()V", "LOG_TAG", "", "initializeMutex", "Lkotlinx/coroutines/sync/Mutex;", "instance", "Lzendesk/android/Zendesk;", "getInstance$annotations", "getInstance", "()Lzendesk/android/Zendesk;", "scope", "Lkotlinx/coroutines/CoroutineScope;", "supervisorJob", "Lkotlinx/coroutines/CompletableJob;", "zendesk", "initialize", "", "context", "Landroid/content/Context;", "channelKey", "successCallback", "Lzendesk/android/SuccessCallback;", "failureCallback", "Lzendesk/android/FailureCallback;", "", "messagingFactory", "Lzendesk/android/messaging/MessagingFactory;", "Lzendesk/android/ZendeskResult;", "restoreSession", "", "(Landroid/content/Context;Ljava/lang/String;Lzendesk/android/messaging/MessagingFactory;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "invalidate", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        @JvmStatic
        public static void getInstance$annotations() {
        }

        @JvmStatic
        public final void initialize(Context context, String channelKey, SuccessCallback<Zendesk> successCallback, FailureCallback<Throwable> failureCallback) {
            Intrinsics.checkNotNullParameter(context, "context");
            Intrinsics.checkNotNullParameter(channelKey, "channelKey");
            Intrinsics.checkNotNullParameter(successCallback, "successCallback");
            Intrinsics.checkNotNullParameter(failureCallback, "failureCallback");
            initialize$default(this, context, channelKey, successCallback, failureCallback, (MessagingFactory) null, 16, (Object) null);
        }

        private Companion() {
        }

        public final Zendesk getInstance() {
            Zendesk zendesk2 = Zendesk.f254zendesk;
            return zendesk2 == null ? new Zendesk(NotInitializedMessaging.INSTANCE, Zendesk.scope, new ZendeskEventDispatcher(Dispatchers.getMain()), NotInitializedConversationKit.INSTANCE, NotInitializedPageViewEvents.INSTANCE) : zendesk2;
        }

        public static void initialize$default(Companion companion, Context context, String str, SuccessCallback successCallback, FailureCallback failureCallback, MessagingFactory messagingFactory, int i, Object obj) {
            if ((i & 16) != 0) {
                messagingFactory = null;
            }
            companion.initialize(context, str, (SuccessCallback<Zendesk>) successCallback, (FailureCallback<Throwable>) failureCallback, messagingFactory);
        }

        @JvmStatic
        public final void initialize(Context context, String channelKey, SuccessCallback<Zendesk> successCallback, FailureCallback<Throwable> failureCallback, MessagingFactory messagingFactory) {
            Intrinsics.checkNotNullParameter(context, "context");
            Intrinsics.checkNotNullParameter(channelKey, "channelKey");
            Intrinsics.checkNotNullParameter(successCallback, "successCallback");
            Intrinsics.checkNotNullParameter(failureCallback, "failureCallback");
            BuildersKt__Builders_commonKt.launch$default(Zendesk.scope, null, null, new Zendesk$Companion$initialize$1(context, channelKey, messagingFactory, failureCallback, successCallback, null), 3, null);
        }

        public static Object initialize$default(Companion companion, Context context, String str, MessagingFactory messagingFactory, boolean z, Continuation continuation, int i, Object obj) {
            if ((i & 4) != 0) {
                messagingFactory = null;
            }
            MessagingFactory messagingFactory2 = messagingFactory;
            if ((i & 8) != 0) {
                z = false;
            }
            return companion.initialize(context, str, messagingFactory2, z, continuation);
        }

        public final Object initialize(Context context, String str, MessagingFactory messagingFactory, boolean z, Continuation continuation) throws Throwable {
            Zendesk$Companion$initialize$2 zendesk$Companion$initialize$2;
            Mutex mutex;
            Mutex mutex2;
            ZendeskResult.Success success;
            ZendeskResult zendeskResult;
            if (continuation instanceof Zendesk$Companion$initialize$2) {
                zendesk$Companion$initialize$2 = (Zendesk$Companion$initialize$2) continuation;
                if ((zendesk$Companion$initialize$2.label & Integer.MIN_VALUE) != 0) {
                    zendesk$Companion$initialize$2.label -= Integer.MIN_VALUE;
                } else {
                    zendesk$Companion$initialize$2 = new Zendesk$Companion$initialize$2(this, continuation);
                }
            } else {
                zendesk$Companion$initialize$2 = new Zendesk$Companion$initialize$2(this, continuation);
            }
            Object obj = zendesk$Companion$initialize$2.result;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = zendesk$Companion$initialize$2.label;
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    mutex = Zendesk.initializeMutex;
                    zendesk$Companion$initialize$2.L$0 = context;
                    zendesk$Companion$initialize$2.L$1 = str;
                    zendesk$Companion$initialize$2.L$2 = messagingFactory;
                    zendesk$Companion$initialize$2.L$3 = mutex;
                    zendesk$Companion$initialize$2.Z$0 = z;
                    zendesk$Companion$initialize$2.label = 1;
                    if (mutex.lock(null, zendesk$Companion$initialize$2) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        if (i != 2) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        mutex2 = (Mutex) zendesk$Companion$initialize$2.L$0;
                        try {
                            ResultKt.throwOnFailure(obj);
                            zendeskResult = (ZendeskResult) obj;
                            if (zendeskResult instanceof ZendeskResult.Success) {
                                Companion companion = Zendesk.INSTANCE;
                                Zendesk.f254zendesk = (Zendesk) ((ZendeskResult.Success) zendeskResult).getValue();
                            }
                            mutex = mutex2;
                            success = zendeskResult;
                        } catch (Throwable th) {
                            th = th;
                            try {
                                mutex = mutex2;
                                success = new ZendeskResult.Failure(th);
                            } catch (Throwable th2) {
                                mutex = mutex2;
                                th = th2;
                                mutex.unlock(null);
                                throw th;
                            }
                        }
                        mutex.unlock(null);
                        return success;
                    }
                    z = zendesk$Companion$initialize$2.Z$0;
                    Mutex mutex3 = (Mutex) zendesk$Companion$initialize$2.L$3;
                    messagingFactory = (MessagingFactory) zendesk$Companion$initialize$2.L$2;
                    str = (String) zendesk$Companion$initialize$2.L$1;
                    Context context2 = (Context) zendesk$Companion$initialize$2.L$0;
                    ResultKt.throwOnFailure(obj);
                    mutex = mutex3;
                    context = context2;
                }
                Zendesk zendesk2 = Zendesk.f254zendesk;
                if (zendesk2 != null) {
                    Logger.m221i(Zendesk.LOG_TAG, "Zendesk.initialize was already called, returning early.", new Object[0]);
                    success = new ZendeskResult.Success(zendesk2);
                } else {
                    try {
                        ZendeskComponent zendeskComponentBuild = DaggerZendeskComponent.builder().zendeskModule(new ZendeskModule(context, Zendesk.scope, ZendeskCredentialsKt.getZendeskComponentConfig(ZendeskCredentials.INSTANCE.builder(str).build()))).build();
                        ZendeskFactory zendeskFactory = ZendeskFactory.INSTANCE;
                        Intrinsics.checkNotNull(zendeskComponentBuild);
                        zendesk$Companion$initialize$2.L$0 = mutex;
                        zendesk$Companion$initialize$2.L$1 = null;
                        zendesk$Companion$initialize$2.L$2 = null;
                        zendesk$Companion$initialize$2.L$3 = null;
                        zendesk$Companion$initialize$2.label = 2;
                        Object objCreate = zendeskFactory.create(zendeskComponentBuild, messagingFactory, z, zendesk$Companion$initialize$2);
                        if (objCreate == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        Mutex mutex4 = mutex;
                        obj = objCreate;
                        mutex2 = mutex4;
                        zendeskResult = (ZendeskResult) obj;
                        if (zendeskResult instanceof ZendeskResult.Success) {
                            Companion companion2 = Zendesk.INSTANCE;
                            Zendesk.f254zendesk = (Zendesk) ((ZendeskResult.Success) zendeskResult).getValue();
                        }
                        mutex = mutex2;
                        success = zendeskResult;
                    } catch (Throwable th3) {
                        th = th3;
                        mutex2 = mutex;
                        mutex = mutex2;
                        success = new ZendeskResult.Failure(th);
                    }
                }
                mutex.unlock(null);
                return success;
            } catch (Throwable th4) {
                th = th4;
                mutex.unlock(null);
                throw th;
            }
        }

        @JvmStatic
        public final void invalidate() {
            JobKt__JobKt.cancelChildren$default((Job) Zendesk.supervisorJob, (CancellationException) null, 1, (Object) null);
            Zendesk.f254zendesk = null;
        }
    }

    static {
        CompletableJob completableJobSupervisorJob$default = SupervisorKt.SupervisorJob$default((Job) null, 1, (Object) null);
        supervisorJob = completableJobSupervisorJob$default;
        scope = CoroutineScopeKt.CoroutineScope(Dispatchers.getMain().plus(completableJobSupervisorJob$default));
        initializeMutex = MutexKt.Mutex$default(false, 1, null);
    }
}
