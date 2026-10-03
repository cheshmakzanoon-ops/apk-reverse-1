package androidx.compose.material3;

import android.window.BackEvent;
import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.material3.internal.PredictiveBack;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.ModalBottomSheetDialogLayout$Api34Impl$createBackCallback$1$onBackProgressed$1", f = "ModalBottomSheet.android.kt", i = {}, l = {410}, m = "invokeSuspend", n = {}, s = {})
final class C1242x20c62d1a extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final BackEvent $backEvent;
    final Animatable<Float, AnimationVector1D> $predictiveBackProgress;
    int label;

    C1242x20c62d1a(Animatable<Float, AnimationVector1D> animatable, BackEvent backEvent, Continuation<? super C1242x20c62d1a> continuation) {
        super(2, continuation);
        this.$predictiveBackProgress = animatable;
        this.$backEvent = backEvent;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new C1242x20c62d1a(this.$predictiveBackProgress, this.$backEvent, continuation);
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
            if (this.$predictiveBackProgress.snapTo(Boxing.boxFloat(PredictiveBack.INSTANCE.transform$material3_release(this.$backEvent.getProgress())), (Continuation) this) == coroutine_suspended) {
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
