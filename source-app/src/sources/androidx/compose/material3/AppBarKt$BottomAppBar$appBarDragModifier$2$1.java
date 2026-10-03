package androidx.compose.material3;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function3;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;", "velocity", ""}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.AppBarKt$BottomAppBar$appBarDragModifier$2$1", f = "AppBar.kt", i = {}, l = {877}, m = "invokeSuspend", n = {}, s = {})
final class AppBarKt$BottomAppBar$appBarDragModifier$2$1 extends SuspendLambda implements Function3<CoroutineScope, Float, Continuation<? super Unit>, Object> {
    final BottomAppBarScrollBehavior $scrollBehavior;
    float F$0;
    int label;

    AppBarKt$BottomAppBar$appBarDragModifier$2$1(BottomAppBarScrollBehavior bottomAppBarScrollBehavior, Continuation<? super AppBarKt$BottomAppBar$appBarDragModifier$2$1> continuation) {
        super(3, continuation);
        this.$scrollBehavior = bottomAppBarScrollBehavior;
    }

    public Object invoke(Object obj, Object obj2, Object obj3) {
        return invoke((CoroutineScope) obj, ((Number) obj2).floatValue(), (Continuation<? super Unit>) obj3);
    }

    public final Object invoke(CoroutineScope coroutineScope, float f, Continuation<? super Unit> continuation) {
        AppBarKt$BottomAppBar$appBarDragModifier$2$1 appBarKt$BottomAppBar$appBarDragModifier$2$1 = new AppBarKt$BottomAppBar$appBarDragModifier$2$1(this.$scrollBehavior, continuation);
        appBarKt$BottomAppBar$appBarDragModifier$2$1.F$0 = f;
        return appBarKt$BottomAppBar$appBarDragModifier$2$1.invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            float f = this.F$0;
            this.label = 1;
            if (AppBarKt.settleAppBarBottom(this.$scrollBehavior.getState(), f, this.$scrollBehavior.getFlingAnimationSpec(), this.$scrollBehavior.getSnapAnimationSpec(), (Continuation) this) == coroutine_suspended) {
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
