package androidx.compose.animation.core;

import java.util.concurrent.CancellationException;
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
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;

@Metadata(d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0001\u0018\u00002\u00020\u0001:\u0001\u001aB\u0005¢\u0006\u0002\u0010\u0002J<\u0010\t\u001a\u0002H\n\"\u0004\b\u0000\u0010\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\u001c\u0010\r\u001a\u0018\b\u0001\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\n0\u000f\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u000eH\u0086@¢\u0006\u0002\u0010\u0010JU\u0010\u0011\u001a\u0002H\n\"\u0004\b\u0000\u0010\u0012\"\u0004\b\u0001\u0010\n2\u0006\u0010\u0013\u001a\u0002H\u00122\b\b\u0002\u0010\u000b\u001a\u00020\f2'\u0010\r\u001a#\b\u0001\u0012\u0004\u0012\u0002H\u0012\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\n0\u000f\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0014¢\u0006\u0002\b\u0015H\u0086@¢\u0006\u0002\u0010\u0016J\u0010\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u0005H\u0002R\"\u0010\u0003\u001a\u0016\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0004j\n\u0012\u0006\u0012\u0004\u0018\u00010\u0005`\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001b"}, d2 = {"Landroidx/compose/animation/core/MutatorMutex;", "", "()V", "currentMutator", "Ljava/util/concurrent/atomic/AtomicReference;", "Landroidx/compose/animation/core/MutatorMutex$Mutator;", "Landroidx/compose/animation/core/AtomicReference;", "mutex", "Lkotlinx/coroutines/sync/Mutex;", "mutate", "R", "priority", "Landroidx/compose/animation/core/MutatePriority;", "block", "Lkotlin/Function1;", "Lkotlin/coroutines/Continuation;", "(Landroidx/compose/animation/core/MutatePriority;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "mutateWith", "T", "receiver", "Lkotlin/Function2;", "Lkotlin/ExtensionFunctionType;", "(Ljava/lang/Object;Landroidx/compose/animation/core/MutatePriority;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "tryMutateOrCancel", "", "mutator", "Mutator", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class MutatorMutex {
    public static final int $stable = 0;
    private final AtomicReference<Mutator> currentMutator = new AtomicReference<>(null);
    private final Mutex mutex = MutexKt.Mutex$default(false, 1, (Object) null);

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\b\u0002\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u0000J\u0006\u0010\u000e\u001a\u00020\u000fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0010"}, d2 = {"Landroidx/compose/animation/core/MutatorMutex$Mutator;", "", "priority", "Landroidx/compose/animation/core/MutatePriority;", "job", "Lkotlinx/coroutines/Job;", "(Landroidx/compose/animation/core/MutatePriority;Lkotlinx/coroutines/Job;)V", "getJob", "()Lkotlinx/coroutines/Job;", "getPriority", "()Landroidx/compose/animation/core/MutatePriority;", "canInterrupt", "", "other", "cancel", "", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class Mutator {
        private final Job job;
        private final MutatePriority priority;

        public Mutator(MutatePriority mutatePriority, Job job) {
            this.priority = mutatePriority;
            this.job = job;
        }

        public final Job getJob() {
            return this.job;
        }

        public final MutatePriority getPriority() {
            return this.priority;
        }

        public final boolean canInterrupt(Mutator other) {
            return this.priority.compareTo(other.priority) >= 0;
        }

        public final void cancel() {
            this.job.cancel(new MutationInterruptedException());
        }
    }

    public final void tryMutateOrCancel(Mutator mutator) {
        Mutator mutator2;
        do {
            mutator2 = this.currentMutator.get();
            if (mutator2 != null && !mutator.canInterrupt(mutator2)) {
                throw new CancellationException("Current mutation had a higher priority");
            }
        } while (!ComplexDouble$$ExternalSyntheticBackport0.m79m(this.currentMutator, mutator2, mutator));
        if (mutator2 != null) {
            mutator2.cancel();
        }
    }

    public static Object mutate$default(MutatorMutex mutatorMutex, MutatePriority mutatePriority, Function1 function1, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            mutatePriority = MutatePriority.Default;
        }
        return mutatorMutex.mutate(mutatePriority, function1, continuation);
    }

    @Metadata(d1 = {"\u0000\b\n\u0002\b\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u0002H\u0001\"\u0004\b\u0000\u0010\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "R", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.MutatorMutex$mutate$2", f = "InternalMutatorMutex.kt", i = {0, 0, 1, 1}, l = {178, 126}, m = "invokeSuspend", n = {"mutator", "$this$withLock_u24default$iv", "mutator", "$this$withLock_u24default$iv"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C03012<R> extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super R>, Object> {
        final Function1<Continuation<? super R>, Object> $block;
        final MutatePriority $priority;
        private Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        final MutatorMutex this$0;

        C03012(MutatePriority mutatePriority, MutatorMutex mutatorMutex, Function1<? super Continuation<? super R>, ? extends Object> function1, Continuation<? super C03012> continuation) {
            super(2, continuation);
            this.$priority = mutatePriority;
            this.this$0 = mutatorMutex;
            this.$block = function1;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c03012 = new C03012<>(this.$priority, this.this$0, this.$block, continuation);
            c03012.L$0 = obj;
            return c03012;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super R> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Mutex mutex;
            Function1<Continuation<? super R>, Object> function1;
            Mutator mutator;
            MutatorMutex mutatorMutex;
            Mutator mutator2;
            Throwable th;
            MutatorMutex mutatorMutex2;
            Mutex mutex2;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            ?? r1 = this.label;
            try {
                try {
                    if (r1 == 0) {
                        ResultKt.throwOnFailure(obj);
                        CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                        MutatePriority mutatePriority = this.$priority;
                        Job job = coroutineScope.getCoroutineContext().get(Job.Key);
                        Intrinsics.checkNotNull(job);
                        Mutator mutator3 = new Mutator(mutatePriority, job);
                        this.this$0.tryMutateOrCancel(mutator3);
                        mutex = this.this$0.mutex;
                        Function1<Continuation<? super R>, Object> function2 = this.$block;
                        MutatorMutex mutatorMutex3 = this.this$0;
                        this.L$0 = mutator3;
                        this.L$1 = mutex;
                        this.L$2 = function2;
                        this.L$3 = mutatorMutex3;
                        this.label = 1;
                        if (mutex.lock((Object) null, (Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        function1 = function2;
                        mutator = mutator3;
                        mutatorMutex = mutatorMutex3;
                    } else {
                        if (r1 != 1) {
                            if (r1 != 2) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            mutatorMutex2 = (MutatorMutex) this.L$2;
                            mutex2 = (Mutex) this.L$1;
                            mutator2 = (Mutator) this.L$0;
                            try {
                                ResultKt.throwOnFailure(obj);
                                ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                                mutex2.unlock((Object) null);
                                return obj;
                            } catch (Throwable th2) {
                                th = th2;
                                ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                                throw th;
                            }
                        }
                        mutatorMutex = (MutatorMutex) this.L$3;
                        function1 = (Function1) this.L$2;
                        Mutex mutex3 = (Mutex) this.L$1;
                        mutator = (Mutator) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        mutex = mutex3;
                    }
                    this.L$0 = mutator;
                    this.L$1 = mutex;
                    this.L$2 = mutatorMutex;
                    this.L$3 = null;
                    this.label = 2;
                    Object objInvoke = function1.invoke(this);
                    if (objInvoke == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    mutatorMutex2 = mutatorMutex;
                    mutex2 = mutex;
                    obj = objInvoke;
                    mutator2 = mutator;
                    ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                    mutex2.unlock((Object) null);
                    return obj;
                } catch (Throwable th3) {
                    mutator2 = mutator;
                    th = th3;
                    mutatorMutex2 = mutatorMutex;
                    ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                    throw th;
                }
            } catch (Throwable th4) {
                r1.unlock((Object) null);
                throw th4;
            }
        }
    }

    public final <R> Object mutate(MutatePriority mutatePriority, Function1<? super Continuation<? super R>, ? extends Object> function1, Continuation<? super R> continuation) {
        return CoroutineScopeKt.coroutineScope(new C03012(mutatePriority, this, function1, null), continuation);
    }

    public static Object mutateWith$default(MutatorMutex mutatorMutex, Object obj, MutatePriority mutatePriority, Function2 function2, Continuation continuation, int i, Object obj2) {
        if ((i & 2) != 0) {
            mutatePriority = MutatePriority.Default;
        }
        return mutatorMutex.mutateWith(obj, mutatePriority, function2, continuation);
    }

    @Metadata(d1 = {"\u0000\b\n\u0002\b\u0003\n\u0002\u0018\u0002\u0010\u0000\u001a\u0002H\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0001*\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "R", "T", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.MutatorMutex$mutateWith$2", f = "InternalMutatorMutex.kt", i = {0, 0, 1, 1}, l = {178, 165}, m = "invokeSuspend", n = {"mutator", "$this$withLock_u24default$iv", "mutator", "$this$withLock_u24default$iv"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C03022<R> extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super R>, Object> {
        final Function2<T, Continuation<? super R>, Object> $block;
        final MutatePriority $priority;
        final T $receiver;
        private Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        final MutatorMutex this$0;

        C03022(MutatePriority mutatePriority, MutatorMutex mutatorMutex, Function2<? super T, ? super Continuation<? super R>, ? extends Object> function2, T t, Continuation<? super C03022> continuation) {
            super(2, continuation);
            this.$priority = mutatePriority;
            this.this$0 = mutatorMutex;
            this.$block = function2;
            this.$receiver = t;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c03022 = new C03022<>(this.$priority, this.this$0, this.$block, this.$receiver, continuation);
            c03022.L$0 = obj;
            return c03022;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super R> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Mutex mutex;
            Function2 function2;
            Object obj2;
            Mutator mutator;
            MutatorMutex mutatorMutex;
            Mutator mutator2;
            Throwable th;
            MutatorMutex mutatorMutex2;
            Mutex mutex2;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            ?? r1 = this.label;
            try {
                try {
                    if (r1 == 0) {
                        ResultKt.throwOnFailure(obj);
                        CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                        MutatePriority mutatePriority = this.$priority;
                        Job job = coroutineScope.getCoroutineContext().get(Job.Key);
                        Intrinsics.checkNotNull(job);
                        Mutator mutator3 = new Mutator(mutatePriority, job);
                        this.this$0.tryMutateOrCancel(mutator3);
                        mutex = this.this$0.mutex;
                        function2 = this.$block;
                        Object obj3 = this.$receiver;
                        MutatorMutex mutatorMutex3 = this.this$0;
                        this.L$0 = mutator3;
                        this.L$1 = mutex;
                        this.L$2 = function2;
                        this.L$3 = obj3;
                        this.L$4 = mutatorMutex3;
                        this.label = 1;
                        if (mutex.lock((Object) null, (Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        obj2 = obj3;
                        mutator = mutator3;
                        mutatorMutex = mutatorMutex3;
                    } else {
                        if (r1 != 1) {
                            if (r1 != 2) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            mutatorMutex2 = (MutatorMutex) this.L$2;
                            mutex2 = (Mutex) this.L$1;
                            mutator2 = (Mutator) this.L$0;
                            try {
                                ResultKt.throwOnFailure(obj);
                                ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                                mutex2.unlock((Object) null);
                                return obj;
                            } catch (Throwable th2) {
                                th = th2;
                                ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                                throw th;
                            }
                        }
                        mutatorMutex = (MutatorMutex) this.L$4;
                        obj2 = this.L$3;
                        function2 = (Function2) this.L$2;
                        Mutex mutex3 = (Mutex) this.L$1;
                        mutator = (Mutator) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        mutex = mutex3;
                    }
                    this.L$0 = mutator;
                    this.L$1 = mutex;
                    this.L$2 = mutatorMutex;
                    this.L$3 = null;
                    this.L$4 = null;
                    this.label = 2;
                    Object objInvoke = function2.invoke(obj2, this);
                    if (objInvoke == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    mutatorMutex2 = mutatorMutex;
                    mutex2 = mutex;
                    obj = objInvoke;
                    mutator2 = mutator;
                    ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                    mutex2.unlock((Object) null);
                    return obj;
                } catch (Throwable th3) {
                    mutator2 = mutator;
                    th = th3;
                    mutatorMutex2 = mutatorMutex;
                    ComplexDouble$$ExternalSyntheticBackport0.m79m(mutatorMutex2.currentMutator, mutator2, null);
                    throw th;
                }
            } catch (Throwable th4) {
                r1.unlock((Object) null);
                throw th4;
            }
        }
    }

    public final <T, R> Object mutateWith(T t, MutatePriority mutatePriority, Function2<? super T, ? super Continuation<? super R>, ? extends Object> function2, Continuation<? super R> continuation) {
        return CoroutineScopeKt.coroutineScope(new C03022(mutatePriority, this, function2, t, null), continuation);
    }
}
