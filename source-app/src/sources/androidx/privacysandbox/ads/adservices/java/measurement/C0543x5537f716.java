package androidx.privacysandbox.ads.adservices.java.measurement;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.privacysandbox.ads.adservices.measurement.WebSourceRegistrationRequest;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@DebugMetadata(c = "androidx.privacysandbox.ads.adservices.java.measurement.MeasurementManagerFutures$Api33Ext5JavaImpl$registerWebSourceAsync$1", f = "MeasurementManagerFutures.kt", i = {}, l = {151}, m = "invokeSuspend", n = {}, s = {})
final class C0543x5537f716 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final WebSourceRegistrationRequest $request;
    int label;
    final MeasurementManagerFutures.Api33Ext5JavaImpl this$0;

    C0543x5537f716(MeasurementManagerFutures.Api33Ext5JavaImpl api33Ext5JavaImpl, WebSourceRegistrationRequest webSourceRegistrationRequest, Continuation<? super C0543x5537f716> continuation) {
        super(2, continuation);
        this.this$0 = api33Ext5JavaImpl;
        this.$request = webSourceRegistrationRequest;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new C0543x5537f716(this.this$0, this.$request, continuation);
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
            if (this.this$0.mMeasurementManager.registerWebSource(this.$request, (Continuation) this) == coroutine_suspended) {
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
