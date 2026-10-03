package com.google.firebase.sessions;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import com.google.firebase.sessions.settings.SessionsSettings;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.time.Duration;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B-\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u0006\u0010\u0014\u001a\u00020\u0015J\u0006\u0010\u0016\u001a\u00020\u0015J\b\u0010\u0017\u001a\u00020\u0015H\u0002R\u0014\u0010\r\u001a\u00020\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0019\u0010\u0011\u001a\u00020\u0012X\u0082\u000eø\u0001\u0000ø\u0001\u0001ø\u0001\u0002¢\u0006\u0004\n\u0002\u0010\u0013R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000f\n\u0002\b\u0019\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0018"}, d2 = {"Lcom/google/firebase/sessions/SessionInitiator;", "", "timeProvider", "Lcom/google/firebase/sessions/TimeProvider;", "backgroundDispatcher", "Lkotlin/coroutines/CoroutineContext;", "sessionInitiateListener", "Lcom/google/firebase/sessions/SessionInitiateListener;", "sessionsSettings", "Lcom/google/firebase/sessions/settings/SessionsSettings;", "sessionGenerator", "Lcom/google/firebase/sessions/SessionGenerator;", "(Lcom/google/firebase/sessions/TimeProvider;Lkotlin/coroutines/CoroutineContext;Lcom/google/firebase/sessions/SessionInitiateListener;Lcom/google/firebase/sessions/settings/SessionsSettings;Lcom/google/firebase/sessions/SessionGenerator;)V", "activityLifecycleCallbacks", "Landroid/app/Application$ActivityLifecycleCallbacks;", "getActivityLifecycleCallbacks$com_google_firebase_firebase_sessions", "()Landroid/app/Application$ActivityLifecycleCallbacks;", "backgroundTime", "Lkotlin/time/Duration;", "J", "appBackgrounded", "", "appForegrounded", "initiateSession", "com.google.firebase-firebase-sessions"}, k = 1, mv = {1, 7, 1}, xi = 48)
public final class SessionInitiator {
    private final Application.ActivityLifecycleCallbacks activityLifecycleCallbacks;
    private final CoroutineContext backgroundDispatcher;
    private long backgroundTime;
    private final SessionGenerator sessionGenerator;
    private final SessionInitiateListener sessionInitiateListener;
    private final SessionsSettings sessionsSettings;
    private final TimeProvider timeProvider;

    public SessionInitiator(TimeProvider timeProvider, CoroutineContext coroutineContext, SessionInitiateListener sessionInitiateListener, SessionsSettings sessionsSettings, SessionGenerator sessionGenerator) {
        Intrinsics.checkNotNullParameter(timeProvider, "timeProvider");
        Intrinsics.checkNotNullParameter(coroutineContext, "backgroundDispatcher");
        Intrinsics.checkNotNullParameter(sessionInitiateListener, "sessionInitiateListener");
        Intrinsics.checkNotNullParameter(sessionsSettings, "sessionsSettings");
        Intrinsics.checkNotNullParameter(sessionGenerator, "sessionGenerator");
        this.timeProvider = timeProvider;
        this.backgroundDispatcher = coroutineContext;
        this.sessionInitiateListener = sessionInitiateListener;
        this.sessionsSettings = sessionsSettings;
        this.sessionGenerator = sessionGenerator;
        this.backgroundTime = timeProvider.mo785elapsedRealtimeUwyO8pc();
        initiateSession();
        this.activityLifecycleCallbacks = new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                Intrinsics.checkNotNullParameter(activity, "activity");
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
                Intrinsics.checkNotNullParameter(activity, "activity");
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                Intrinsics.checkNotNullParameter(activity, "activity");
                Intrinsics.checkNotNullParameter(outState, "outState");
            }

            @Override
            public void onActivityStarted(Activity activity) {
                Intrinsics.checkNotNullParameter(activity, "activity");
            }

            @Override
            public void onActivityStopped(Activity activity) {
                Intrinsics.checkNotNullParameter(activity, "activity");
            }

            @Override
            public void onActivityResumed(Activity activity) {
                Intrinsics.checkNotNullParameter(activity, "activity");
                this.this$0.appForegrounded();
            }

            @Override
            public void onActivityPaused(Activity activity) {
                Intrinsics.checkNotNullParameter(activity, "activity");
                this.this$0.appBackgrounded();
            }
        };
    }

    public final void appBackgrounded() {
        this.backgroundTime = this.timeProvider.mo785elapsedRealtimeUwyO8pc();
    }

    public final void appForegrounded() {
        if (Duration.compareTo-LRDsOJo(Duration.minus-LRDsOJo(this.timeProvider.mo785elapsedRealtimeUwyO8pc(), this.backgroundTime), this.sessionsSettings.m788getSessionRestartTimeoutUwyO8pc()) > 0) {
            initiateSession();
        }
    }

    private final void initiateSession() {
        BuildersKt.launch$default(CoroutineScopeKt.CoroutineScope(this.backgroundDispatcher), (CoroutineContext) null, (CoroutineStart) null, new C09001(this.sessionGenerator.generateNewSession(), null), 3, (Object) null);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 7, 1}, xi = 48)
    @DebugMetadata(c = "com.google.firebase.sessions.SessionInitiator$initiateSession$1", f = "SessionInitiator.kt", i = {}, l = {63}, m = "invokeSuspend", n = {}, s = {})
    static final class C09001 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final SessionDetails $sessionDetails;
        int label;

        C09001(SessionDetails sessionDetails, Continuation<? super C09001> continuation) {
            super(2, continuation);
            this.$sessionDetails = sessionDetails;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return SessionInitiator.this.new C09001(this.$sessionDetails, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (SessionInitiator.this.sessionInitiateListener.onInitiateSession(this.$sessionDetails, (Continuation) this) == coroutine_suspended) {
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

    public final Application.ActivityLifecycleCallbacks getActivityLifecycleCallbacks() {
        return this.activityLifecycleCallbacks;
    }
}
