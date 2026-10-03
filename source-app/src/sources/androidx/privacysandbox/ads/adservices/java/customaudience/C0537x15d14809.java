package androidx.privacysandbox.ads.adservices.java.customaudience;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.privacysandbox.ads.adservices.customaudience.CustomAudienceManager;
import androidx.privacysandbox.ads.adservices.customaudience.JoinCustomAudienceRequest;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@DebugMetadata(c = "androidx.privacysandbox.ads.adservices.java.customaudience.CustomAudienceManagerFutures$Api33Ext4JavaImpl$joinCustomAudienceAsync$1", f = "CustomAudienceManagerFutures.kt", i = {}, l = {113}, m = "invokeSuspend", n = {}, s = {})
final class C0537x15d14809 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final JoinCustomAudienceRequest $request;
    int label;
    final CustomAudienceManagerFutures.Api33Ext4JavaImpl this$0;

    C0537x15d14809(CustomAudienceManagerFutures.Api33Ext4JavaImpl api33Ext4JavaImpl, JoinCustomAudienceRequest joinCustomAudienceRequest, Continuation<? super C0537x15d14809> continuation) {
        super(2, continuation);
        this.this$0 = api33Ext4JavaImpl;
        this.$request = joinCustomAudienceRequest;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new C0537x15d14809(this.this$0, this.$request, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            CustomAudienceManager customAudienceManager = this.this$0.mCustomAudienceManager;
            Intrinsics.checkNotNull(customAudienceManager);
            this.label = 1;
            if (customAudienceManager.joinCustomAudience(this.$request, (Continuation) this) == coroutine_suspended) {
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
