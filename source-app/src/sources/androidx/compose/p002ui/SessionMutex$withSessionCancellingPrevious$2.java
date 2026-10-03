package androidx.compose.p002ui;

import androidx.compose.animation.core.ComplexDouble$$ExternalSyntheticBackport0;
import java.util.concurrent.atomic.AtomicReference;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.JobKt;

@Metadata(d1 = {"\u0000\b\n\u0002\b\u0003\n\u0002\u0018\u0002\u0010\u0000\u001a\u0002H\u0001\"\u0004\b\u0000\u0010\u0001\"\u0004\b\u0001\u0010\u0002*\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "R", "T", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.SessionMutex$withSessionCancellingPrevious$2", f = "SessionMutex.kt", i = {0, 1}, l = {67, 69}, m = "invokeSuspend", n = {"newSession", "newSession"}, s = {"L$0", "L$0"})
final class SessionMutex$withSessionCancellingPrevious$2<R> extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super R>, Object> {
    final AtomicReference<SessionMutex.Session<T>> $arg0;
    final Function2<T, Continuation<? super R>, Object> $session;
    final Function1<CoroutineScope, T> $sessionInitializer;
    private Object L$0;
    int label;

    SessionMutex$withSessionCancellingPrevious$2(Function1<? super CoroutineScope, ? extends T> function1, AtomicReference<SessionMutex.Session<T>> atomicReference, Function2<? super T, ? super Continuation<? super R>, ? extends Object> function2, Continuation<? super SessionMutex$withSessionCancellingPrevious$2> continuation) {
        super(2, continuation);
        this.$sessionInitializer = function1;
        this.$arg0 = atomicReference;
        this.$session = function2;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> sessionMutex$withSessionCancellingPrevious$2 = new SessionMutex$withSessionCancellingPrevious$2<>(this.$sessionInitializer, this.$arg0, this.$session, continuation);
        sessionMutex$withSessionCancellingPrevious$2.L$0 = obj;
        return sessionMutex$withSessionCancellingPrevious$2;
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super R> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) throws Throwable {
        SessionMutex.Session session;
        Job job;
        SessionMutex.Session session2;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                session = new SessionMutex.Session(JobKt.getJob(coroutineScope.getCoroutineContext()), this.$sessionInitializer.invoke(coroutineScope));
                SessionMutex.Session session3 = (SessionMutex.Session) this.$arg0.getAndSet((SessionMutex.Session<T>) session);
                if (session3 != null && (job = session3.getJob()) != null) {
                    this.L$0 = session;
                    this.label = 1;
                    if (JobKt.cancelAndJoin(job, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i != 1) {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    session2 = (SessionMutex.Session) this.L$0;
                    try {
                        ResultKt.throwOnFailure(obj);
                        ComplexDouble$$ExternalSyntheticBackport0.m79m(this.$arg0, session2, null);
                        return obj;
                    } catch (Throwable th) {
                        th = th;
                        ComplexDouble$$ExternalSyntheticBackport0.m79m(this.$arg0, session2, null);
                        throw th;
                    }
                }
                session = (SessionMutex.Session) this.L$0;
                ResultKt.throwOnFailure(obj);
            }
            Function2<T, Continuation<? super R>, Object> function2 = this.$session;
            Object value = session.getValue();
            this.L$0 = session;
            this.label = 2;
            obj = function2.invoke(value, this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            session2 = session;
            ComplexDouble$$ExternalSyntheticBackport0.m79m(this.$arg0, session2, null);
            return obj;
        } catch (Throwable th2) {
            th = th2;
            session2 = session;
            ComplexDouble$$ExternalSyntheticBackport0.m79m(this.$arg0, session2, null);
            throw th;
        }
    }
}
