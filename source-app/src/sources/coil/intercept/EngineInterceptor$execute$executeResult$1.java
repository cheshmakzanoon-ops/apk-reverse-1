package coil.intercept;

import androidx.constraintlayout.widget.ConstraintLayout;
import coil.ComponentRegistry;
import coil.EventListener;
import coil.fetch.FetchResult;
import coil.fetch.SourceResult;
import coil.request.ImageRequest;
import coil.request.Options;
import com.gamesafe.ano.AnoSdk;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lcoil/intercept/EngineInterceptor$ExecuteResult;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@DebugMetadata(c = "coil.intercept.EngineInterceptor$execute$executeResult$1", f = "EngineInterceptor.kt", i = {}, l = {AnoSdk.ENTRY_ID_EMAIL}, m = "invokeSuspend", n = {}, s = {})
final class EngineInterceptor$execute$executeResult$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super EngineInterceptor.ExecuteResult>, Object> {
    final Ref.ObjectRef<ComponentRegistry> $components;
    final EventListener $eventListener;
    final Ref.ObjectRef<FetchResult> $fetchResult;
    final Object $mappedData;
    final Ref.ObjectRef<Options> $options;
    final ImageRequest $request;
    int label;
    final EngineInterceptor this$0;

    EngineInterceptor$execute$executeResult$1(EngineInterceptor engineInterceptor, Ref.ObjectRef<FetchResult> objectRef, Ref.ObjectRef<ComponentRegistry> objectRef2, ImageRequest imageRequest, Object obj, Ref.ObjectRef<Options> objectRef3, EventListener eventListener, Continuation<? super EngineInterceptor$execute$executeResult$1> continuation) {
        super(2, continuation);
        this.this$0 = engineInterceptor;
        this.$fetchResult = objectRef;
        this.$components = objectRef2;
        this.$request = imageRequest;
        this.$mappedData = obj;
        this.$options = objectRef3;
        this.$eventListener = eventListener;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new EngineInterceptor$execute$executeResult$1(this.this$0, this.$fetchResult, this.$components, this.$request, this.$mappedData, this.$options, this.$eventListener, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super EngineInterceptor.ExecuteResult> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            obj = this.this$0.decode((SourceResult) this.$fetchResult.element, (ComponentRegistry) this.$components.element, this.$request, this.$mappedData, (Options) this.$options.element, this.$eventListener, (Continuation) this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return obj;
    }
}
