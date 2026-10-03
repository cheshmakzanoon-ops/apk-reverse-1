package coil.util;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.CancellableContinuation;
import kotlinx.coroutines.CancellableContinuationImpl;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\u001a\u0012\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0081@¢\u0006\u0002\u0010\u0003\u001a\u0014\u0010\u0004\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0006H\u0001¨\u0006\u0007"}, d2 = {"awaitStarted", "", "Landroidx/lifecycle/Lifecycle;", "(Landroidx/lifecycle/Lifecycle;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeAndAddObserver", "observer", "Landroidx/lifecycle/LifecycleObserver;", "coil-base_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Lifecycles {

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.util.-Lifecycles", f = "Lifecycles.kt", i = {0, 0}, l = {44}, m = "awaitStarted", n = {"$this$awaitStarted", "observer"}, s = {"L$0", "L$1"})
    static final class C08131 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C08131(Continuation<? super C08131> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return Lifecycles.awaitStarted(null, (Continuation) this);
        }
    }

    public static final Object awaitStarted(Lifecycle lifecycle, Continuation<? super Unit> continuation) throws Throwable {
        C08131 c08131;
        Lifecycle lifecycle2;
        Ref.ObjectRef objectRef;
        Throwable th;
        LifecycleObserver lifecycleObserver;
        LifecycleObserver lifecycleObserver2;
        if (continuation instanceof C08131) {
            c08131 = (C08131) continuation;
            if ((c08131.label & Integer.MIN_VALUE) != 0) {
                c08131.label -= Integer.MIN_VALUE;
            } else {
                c08131 = new C08131(continuation);
            }
        } else {
            c08131 = new C08131(continuation);
        }
        Object obj = c08131.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08131.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            objectRef = (Ref.ObjectRef) c08131.L$1;
            lifecycle2 = (Lifecycle) c08131.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                lifecycleObserver2 = (LifecycleObserver) objectRef.element;
                if (lifecycleObserver2 != null) {
                    lifecycle2.removeObserver(lifecycleObserver2);
                }
                return Unit.INSTANCE;
            } catch (Throwable th2) {
                th = th2;
                lifecycleObserver = (LifecycleObserver) objectRef.element;
                if (lifecycleObserver != null) {
                    lifecycle2.removeObserver(lifecycleObserver);
                }
                throw th;
            }
        }
        ResultKt.throwOnFailure(obj);
        if (lifecycle.getCurrentState().isAtLeast(Lifecycle.State.STARTED)) {
            return Unit.INSTANCE;
        }
        Ref.ObjectRef objectRef2 = new Ref.ObjectRef();
        try {
            c08131.L$0 = lifecycle;
            c08131.L$1 = objectRef2;
            c08131.label = 1;
            CancellableContinuation cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted((Continuation) c08131), 1);
            cancellableContinuationImpl.initCancellability();
            final CancellableContinuation cancellableContinuation = cancellableContinuationImpl;
            objectRef2.element = new DefaultLifecycleObserver() {
                @Override
                public void onCreate(LifecycleOwner lifecycleOwner) {
                    Intrinsics.checkNotNullParameter(lifecycleOwner, "owner");
                }

                @Override
                public void onDestroy(LifecycleOwner lifecycleOwner) {
                    Intrinsics.checkNotNullParameter(lifecycleOwner, "owner");
                }

                @Override
                public void onPause(LifecycleOwner lifecycleOwner) {
                    Intrinsics.checkNotNullParameter(lifecycleOwner, "owner");
                }

                @Override
                public void onResume(LifecycleOwner lifecycleOwner) {
                    Intrinsics.checkNotNullParameter(lifecycleOwner, "owner");
                }

                @Override
                public void onStop(LifecycleOwner lifecycleOwner) {
                    Intrinsics.checkNotNullParameter(lifecycleOwner, "owner");
                }

                @Override
                public void onStart(LifecycleOwner owner) {
                    Continuation continuation2 = cancellableContinuation;
                    Result.Companion companion = Result.Companion;
                    continuation2.resumeWith(Result.constructor-impl(Unit.INSTANCE));
                }
            };
            Object obj2 = objectRef2.element;
            Intrinsics.checkNotNull(obj2);
            lifecycle.addObserver((LifecycleObserver) obj2);
            Object result = cancellableContinuationImpl.getResult();
            if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
                DebugProbesKt.probeCoroutineSuspended((Continuation) c08131);
            }
            if (result == coroutine_suspended) {
                return coroutine_suspended;
            }
            lifecycle2 = lifecycle;
            objectRef = objectRef2;
            lifecycleObserver2 = (LifecycleObserver) objectRef.element;
            if (lifecycleObserver2 != null) {
                lifecycle2.removeObserver(lifecycleObserver2);
            }
            return Unit.INSTANCE;
        } catch (Throwable th3) {
            lifecycle2 = lifecycle;
            objectRef = objectRef2;
            th = th3;
            lifecycleObserver = (LifecycleObserver) objectRef.element;
            if (lifecycleObserver != null) {
                lifecycle2.removeObserver(lifecycleObserver);
            }
            throw th;
        }
    }

    public static final void removeAndAddObserver(Lifecycle lifecycle, LifecycleObserver lifecycleObserver) {
        lifecycle.removeObserver(lifecycleObserver);
        lifecycle.addObserver(lifecycleObserver);
    }
}
