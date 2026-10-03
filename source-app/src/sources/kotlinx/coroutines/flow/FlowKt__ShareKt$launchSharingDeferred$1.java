package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.CompletableDeferred;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.JobKt;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ShareKt$launchSharingDeferred$1", m37f = "Share.kt", m38i = {}, m39l = {336}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class FlowKt__ShareKt$launchSharingDeferred$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final CompletableDeferred<StateFlow<T>> $result;
    final Flow<T> $upstream;
    private Object L$0;
    int label;

    FlowKt__ShareKt$launchSharingDeferred$1(Flow<? extends T> flow, CompletableDeferred<StateFlow<T>> completableDeferred, Continuation<? super FlowKt__ShareKt$launchSharingDeferred$1> continuation) {
        super(2, continuation);
        this.$upstream = flow;
        this.$result = completableDeferred;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        FlowKt__ShareKt$launchSharingDeferred$1 flowKt__ShareKt$launchSharingDeferred$1 = new FlowKt__ShareKt$launchSharingDeferred$1(this.$upstream, this.$result, continuation);
        flowKt__ShareKt$launchSharingDeferred$1.L$0 = obj;
        return flowKt__ShareKt$launchSharingDeferred$1;
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((FlowKt__ShareKt$launchSharingDeferred$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                final CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                final Ref.ObjectRef objectRef = new Ref.ObjectRef();
                Flow<T> flow = this.$upstream;
                final CompletableDeferred<StateFlow<T>> completableDeferred = this.$result;
                FlowCollector flowCollector = new FlowCollector() {
                    @Override
                    public final Object emit(T t, Continuation<? super Unit> continuation) {
                        MutableStateFlow<T> mutableStateFlow = objectRef.element;
                        if (mutableStateFlow != null) {
                            mutableStateFlow.setValue(t);
                        } else {
                            CoroutineScope coroutineScope2 = coroutineScope;
                            Ref.ObjectRef<MutableStateFlow<T>> objectRef2 = objectRef;
                            CompletableDeferred<StateFlow<T>> completableDeferred2 = completableDeferred;
                            T t2 = (T) StateFlowKt.MutableStateFlow(t);
                            completableDeferred2.complete(new ReadonlyStateFlow((StateFlow) t2, JobKt.getJob(coroutineScope2.getCoroutineContext())));
                            objectRef2.element = t2;
                        }
                        return Unit.INSTANCE;
                    }
                };
                this.label = 1;
                if (flow.collect((FlowCollector<? super T>) flowCollector, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        } catch (Throwable th) {
            this.$result.completeExceptionally(th);
            throw th;
        }
    }
}
