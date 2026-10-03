package com.google.firebase.sessions;

import android.app.Application;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;
import com.google.android.datatransport.TransportFactory;
import com.google.firebase.FirebaseApp;
import com.google.firebase.inject.Provider;
import com.google.firebase.installations.FirebaseInstallationsApi;
import com.google.firebase.ktx.Firebase;
import com.google.firebase.ktx.FirebaseKt;
import com.google.firebase.sessions.api.FirebaseSessionsDependencies;
import com.google.firebase.sessions.api.SessionSubscriber;
import com.google.firebase.sessions.settings.SessionsSettings;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineDispatcher;

@Metadata(d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\u0018\u0000 #2\u00020\u0001:\u0001#B5\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\n¢\u0006\u0002\u0010\fJ\u0019\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cH\u0082@ø\u0001\u0000¢\u0006\u0002\u0010\u001dJ\u000e\u0010\u001e\u001a\u00020\u001a2\u0006\u0010\u001f\u001a\u00020 J\b\u0010!\u001a\u00020\"H\u0002R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0004\n\u0002\b\u0019¨\u0006$"}, d2 = {"Lcom/google/firebase/sessions/FirebaseSessions;", "", "firebaseApp", "Lcom/google/firebase/FirebaseApp;", "firebaseInstallations", "Lcom/google/firebase/installations/FirebaseInstallationsApi;", "backgroundDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "blockingDispatcher", "transportFactoryProvider", "Lcom/google/firebase/inject/Provider;", "Lcom/google/android/datatransport/TransportFactory;", "(Lcom/google/firebase/FirebaseApp;Lcom/google/firebase/installations/FirebaseInstallationsApi;Lkotlinx/coroutines/CoroutineDispatcher;Lkotlinx/coroutines/CoroutineDispatcher;Lcom/google/firebase/inject/Provider;)V", "applicationInfo", "Lcom/google/firebase/sessions/ApplicationInfo;", "eventGDTLogger", "Lcom/google/firebase/sessions/EventGDTLogger;", "sessionCoordinator", "Lcom/google/firebase/sessions/SessionCoordinator;", "sessionGenerator", "Lcom/google/firebase/sessions/SessionGenerator;", "sessionSettings", "Lcom/google/firebase/sessions/settings/SessionsSettings;", "timeProvider", "Lcom/google/firebase/sessions/TimeProvider;", "initiateSessionStart", "", "sessionDetails", "Lcom/google/firebase/sessions/SessionDetails;", "(Lcom/google/firebase/sessions/SessionDetails;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "register", "subscriber", "Lcom/google/firebase/sessions/api/SessionSubscriber;", "shouldCollectEvents", "", "Companion", "com.google.firebase-firebase-sessions"}, k = 1, mv = {1, 7, 1}, xi = 48)
public final class FirebaseSessions {

    public static final Companion INSTANCE = new Companion(null);
    private static final String TAG = "FirebaseSessions";
    private final ApplicationInfo applicationInfo;
    private final EventGDTLogger eventGDTLogger;
    private final FirebaseApp firebaseApp;
    private final SessionCoordinator sessionCoordinator;
    private final SessionGenerator sessionGenerator;
    private final SessionsSettings sessionSettings;
    private final TimeProvider timeProvider;

    @Metadata(k = 3, mv = {1, 7, 1}, xi = 48)
    @DebugMetadata(c = "com.google.firebase.sessions.FirebaseSessions", f = "FirebaseSessions.kt", i = {0, 0, 1, 1}, l = {106, 129, 141}, m = "initiateSessionStart", n = {"this", "sessionDetails", "this", "sessionDetails"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C08961 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C08961(Continuation<? super C08961> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FirebaseSessions.this.initiateSessionStart(null, (Continuation) this);
        }
    }

    public static final FirebaseSessions getInstance() {
        return INSTANCE.getInstance();
    }

    @JvmStatic
    public static final FirebaseSessions getInstance(FirebaseApp firebaseApp) {
        return INSTANCE.getInstance(firebaseApp);
    }

    public FirebaseSessions(FirebaseApp firebaseApp, FirebaseInstallationsApi firebaseInstallationsApi, CoroutineDispatcher coroutineDispatcher, CoroutineDispatcher coroutineDispatcher2, Provider<TransportFactory> provider) throws PackageManager.NameNotFoundException {
        Intrinsics.checkNotNullParameter(firebaseApp, "firebaseApp");
        Intrinsics.checkNotNullParameter(firebaseInstallationsApi, "firebaseInstallations");
        Intrinsics.checkNotNullParameter(coroutineDispatcher, "backgroundDispatcher");
        Intrinsics.checkNotNullParameter(coroutineDispatcher2, "blockingDispatcher");
        Intrinsics.checkNotNullParameter(provider, "transportFactoryProvider");
        this.firebaseApp = firebaseApp;
        ApplicationInfo applicationInfo = SessionEvents.INSTANCE.getApplicationInfo(firebaseApp);
        this.applicationInfo = applicationInfo;
        Context applicationContext = firebaseApp.getApplicationContext();
        Intrinsics.checkNotNullExpressionValue(applicationContext, "firebaseApp.applicationContext");
        CoroutineContext coroutineContext = (CoroutineContext) coroutineDispatcher;
        SessionsSettings sessionsSettings = new SessionsSettings(applicationContext, (CoroutineContext) coroutineDispatcher2, coroutineContext, firebaseInstallationsApi, applicationInfo);
        this.sessionSettings = sessionsSettings;
        Time time = new Time();
        this.timeProvider = time;
        EventGDTLogger eventGDTLogger = new EventGDTLogger(provider);
        this.eventGDTLogger = eventGDTLogger;
        this.sessionCoordinator = new SessionCoordinator(firebaseInstallationsApi, eventGDTLogger);
        SessionGenerator sessionGenerator = new SessionGenerator(shouldCollectEvents(), time, null, 4, null);
        this.sessionGenerator = sessionGenerator;
        SessionInitiator sessionInitiator = new SessionInitiator(time, coroutineContext, new SessionInitiateListener() {
            @Override
            public Object onInitiateSession(SessionDetails sessionDetails, Continuation<? super Unit> continuation) {
                Object objInitiateSessionStart = this.this$0.initiateSessionStart(sessionDetails, continuation);
                return objInitiateSessionStart == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objInitiateSessionStart : Unit.INSTANCE;
            }
        }, sessionsSettings, sessionGenerator);
        Context applicationContext2 = firebaseApp.getApplicationContext().getApplicationContext();
        if (applicationContext2 instanceof Application) {
            ((Application) applicationContext2).registerActivityLifecycleCallbacks(sessionInitiator.getActivityLifecycleCallbacks());
            return;
        }
        Log.e(TAG, "Failed to register lifecycle callbacks, unexpected context " + applicationContext2.getClass() + '.');
    }

    public final void register(SessionSubscriber subscriber) {
        Intrinsics.checkNotNullParameter(subscriber, "subscriber");
        FirebaseSessionsDependencies.INSTANCE.register$com_google_firebase_firebase_sessions(subscriber);
        Log.d(TAG, "Registering Sessions SDK subscriber with name: " + subscriber.getSessionSubscriberName() + ", data collection enabled: " + subscriber.isDataCollectionEnabled());
        if (this.sessionGenerator.getHasGenerateSession()) {
            subscriber.onSessionChanged(new SessionSubscriber.SessionDetails(this.sessionGenerator.getCurrentSession().getSessionId()));
        }
    }

    public final Object initiateSessionStart(SessionDetails sessionDetails, Continuation<? super Unit> continuation) {
        C08961 c08961;
        FirebaseSessions firebaseSessions;
        SessionCoordinator sessionCoordinator;
        SessionEvent sessionEventStartSession;
        if (continuation instanceof C08961) {
            c08961 = (C08961) continuation;
            if ((c08961.label & Integer.MIN_VALUE) != 0) {
                c08961.label -= Integer.MIN_VALUE;
            } else {
                c08961 = new C08961(continuation);
            }
        } else {
            c08961 = new C08961(continuation);
        }
        Object registeredSubscribers$com_google_firebase_firebase_sessions = c08961.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08961.label;
        if (i == 0) {
            ResultKt.throwOnFailure(registeredSubscribers$com_google_firebase_firebase_sessions);
            FirebaseSessionsDependencies firebaseSessionsDependencies = FirebaseSessionsDependencies.INSTANCE;
            c08961.L$0 = this;
            c08961.L$1 = sessionDetails;
            c08961.label = 1;
            registeredSubscribers$com_google_firebase_firebase_sessions = firebaseSessionsDependencies.getRegisteredSubscribers$com_google_firebase_firebase_sessions(c08961);
            if (registeredSubscribers$com_google_firebase_firebase_sessions == coroutine_suspended) {
                return coroutine_suspended;
            }
            firebaseSessions = this;
        } else {
            if (i == 1) {
                sessionDetails = (SessionDetails) c08961.L$1;
                firebaseSessions = (FirebaseSessions) c08961.L$0;
                ResultKt.throwOnFailure(registeredSubscribers$com_google_firebase_firebase_sessions);
            } else if (i == 2) {
                sessionDetails = (SessionDetails) c08961.L$1;
                firebaseSessions = (FirebaseSessions) c08961.L$0;
                ResultKt.throwOnFailure(registeredSubscribers$com_google_firebase_firebase_sessions);
                if (!firebaseSessions.sessionSettings.getSessionsEnabled()) {
                    Log.d(TAG, "Sessions SDK disabled. Events will not be sent.");
                    return Unit.INSTANCE;
                }
                if (!firebaseSessions.sessionGenerator.getCollectEvents()) {
                    Log.d(TAG, "Sessions SDK has dropped this session due to sampling.");
                    return Unit.INSTANCE;
                }
                sessionCoordinator = firebaseSessions.sessionCoordinator;
                sessionEventStartSession = SessionEvents.INSTANCE.startSession(firebaseSessions.firebaseApp, sessionDetails, firebaseSessions.sessionSettings);
                c08961.L$0 = null;
                c08961.L$1 = null;
                c08961.label = 3;
                if (sessionCoordinator.attemptLoggingSessionEvent(sessionEventStartSession, c08961) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(registeredSubscribers$com_google_firebase_firebase_sessions);
            }
            return Unit.INSTANCE;
        }
        Map map = (Map) registeredSubscribers$com_google_firebase_firebase_sessions;
        if (map.isEmpty()) {
            Log.d(TAG, "Sessions SDK did not have any dependent SDKs register as dependencies. Events will not be sent.");
            return Unit.INSTANCE;
        }
        Iterator it = map.values().iterator();
        while (it.hasNext()) {
            ((SessionSubscriber) it.next()).onSessionChanged(new SessionSubscriber.SessionDetails(sessionDetails.getSessionId()));
        }
        Collection collectionValues = map.values();
        if (!(collectionValues instanceof Collection) || !collectionValues.isEmpty()) {
            Iterator it2 = collectionValues.iterator();
            do {
                if (it2.hasNext()) {
                }
            } while (!((SessionSubscriber) it2.next()).isDataCollectionEnabled());
            Log.d(TAG, "Data Collection is enabled for at least one Subscriber");
            SessionsSettings sessionsSettings = firebaseSessions.sessionSettings;
            c08961.L$0 = firebaseSessions;
            c08961.L$1 = sessionDetails;
            c08961.label = 2;
            if (sessionsSettings.updateSettings(c08961) == coroutine_suspended) {
                return coroutine_suspended;
            }
            if (!firebaseSessions.sessionSettings.getSessionsEnabled()) {
                Log.d(TAG, "Sessions SDK disabled. Events will not be sent.");
                return Unit.INSTANCE;
            }
            if (!firebaseSessions.sessionGenerator.getCollectEvents()) {
                Log.d(TAG, "Sessions SDK has dropped this session due to sampling.");
                return Unit.INSTANCE;
            }
            sessionCoordinator = firebaseSessions.sessionCoordinator;
            sessionEventStartSession = SessionEvents.INSTANCE.startSession(firebaseSessions.firebaseApp, sessionDetails, firebaseSessions.sessionSettings);
            c08961.L$0 = null;
            c08961.L$1 = null;
            c08961.label = 3;
            if (sessionCoordinator.attemptLoggingSessionEvent(sessionEventStartSession, c08961) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
        Log.d(TAG, "Data Collection is disabled for all subscribers. Skipping this Session Event");
        return Unit.INSTANCE;
    }

    private final boolean shouldCollectEvents() {
        return Math.random() <= this.sessionSettings.getSamplingRate();
    }

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\b\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u000bH\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u001a\u0010\u0005\u001a\u00020\u00068FX\u0087\u0004¢\u0006\f\u0012\u0004\b\u0007\u0010\u0002\u001a\u0004\b\b\u0010\t¨\u0006\f"}, d2 = {"Lcom/google/firebase/sessions/FirebaseSessions$Companion;", "", "()V", "TAG", "", "instance", "Lcom/google/firebase/sessions/FirebaseSessions;", "getInstance$annotations", "getInstance", "()Lcom/google/firebase/sessions/FirebaseSessions;", "app", "Lcom/google/firebase/FirebaseApp;", "com.google.firebase-firebase-sessions"}, k = 1, mv = {1, 7, 1}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        @JvmStatic
        public static void getInstance$annotations() {
        }

        private Companion() {
        }

        public final FirebaseSessions getInstance() {
            return getInstance(FirebaseKt.getApp(Firebase.INSTANCE));
        }

        @JvmStatic
        public final FirebaseSessions getInstance(FirebaseApp app) {
            Intrinsics.checkNotNullParameter(app, "app");
            Object obj = app.get(FirebaseSessions.class);
            Intrinsics.checkNotNullExpressionValue(obj, "app.get(FirebaseSessions::class.java)");
            return (FirebaseSessions) obj;
        }
    }
}
