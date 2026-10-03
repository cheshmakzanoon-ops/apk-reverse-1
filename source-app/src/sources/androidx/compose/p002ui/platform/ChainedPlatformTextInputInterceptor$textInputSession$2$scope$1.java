package androidx.compose.p002ui.platform;

import android.view.View;
import androidx.compose.p002ui.SessionMutex;
import java.util.concurrent.atomic.AtomicReference;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.functions.Function1;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000)\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0016\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\rH\u0096@¢\u0006\u0002\u0010\u000eR\u0012\u0010\u0002\u001a\u00020\u0003X\u0096\u0005¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R\u0012\u0010\u0006\u001a\u00020\u0007X\u0096\u0005¢\u0006\u0006\u001a\u0004\b\b\u0010\t¨\u0006\u000f"}, d2 = {"androidx/compose/ui/platform/ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1", "Landroidx/compose/ui/platform/PlatformTextInputSessionScope;", "coroutineContext", "Lkotlin/coroutines/CoroutineContext;", "getCoroutineContext", "()Lkotlin/coroutines/CoroutineContext;", "view", "Landroid/view/View;", "getView", "()Landroid/view/View;", "startInputMethod", "", "request", "Landroidx/compose/ui/platform/PlatformTextInputMethodRequest;", "(Landroidx/compose/ui/platform/PlatformTextInputMethodRequest;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1 implements PlatformTextInputSessionScope {
    private final PlatformTextInputSessionScope $$delegate_0;
    final AtomicReference<SessionMutex.Session<T>> $inputMethodMutex;
    final PlatformTextInputSessionScope $parentSession;
    final ChainedPlatformTextInputInterceptor this$0;

    public CoroutineContext getCoroutineContext() {
        return this.$$delegate_0.getCoroutineContext();
    }

    @Override
    public View getView() {
        return this.$$delegate_0.getView();
    }

    ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1(PlatformTextInputSessionScope platformTextInputSessionScope, AtomicReference<SessionMutex.Session<T>> atomicReference, ChainedPlatformTextInputInterceptor chainedPlatformTextInputInterceptor) {
        this.$parentSession = platformTextInputSessionScope;
        this.$inputMethodMutex = atomicReference;
        this.this$0 = chainedPlatformTextInputInterceptor;
        this.$$delegate_0 = platformTextInputSessionScope;
    }

    @Override
    public Object startInputMethod(PlatformTextInputMethodRequest platformTextInputMethodRequest, Continuation<?> continuation) throws KotlinNothingValueException {
        C1731x61f42b4d c1731x61f42b4d;
        if (continuation instanceof C1731x61f42b4d) {
            c1731x61f42b4d = (C1731x61f42b4d) continuation;
            if ((c1731x61f42b4d.label & Integer.MIN_VALUE) != 0) {
                c1731x61f42b4d.label -= Integer.MIN_VALUE;
            } else {
                c1731x61f42b4d = new C1731x61f42b4d(this, continuation);
            }
        } else {
            c1731x61f42b4d = new C1731x61f42b4d(this, continuation);
        }
        Object obj = c1731x61f42b4d.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c1731x61f42b4d.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            AtomicReference<SessionMutex.Session<T>> atomicReference = this.$inputMethodMutex;
            C1732x61f42b4e c1732x61f42b4e = new Function1<CoroutineScope, Unit>() {
                public final void invoke(CoroutineScope coroutineScope) {
                }

                public Object invoke(Object obj2) {
                    invoke((CoroutineScope) obj2);
                    return Unit.INSTANCE;
                }
            };
            C1733x61f42b4f c1733x61f42b4f = new C1733x61f42b4f(this.this$0, platformTextInputMethodRequest, this.$parentSession, null);
            c1731x61f42b4d.label = 1;
            if (SessionMutex.m4181withSessionCancellingPreviousimpl(atomicReference, c1732x61f42b4e, c1733x61f42b4f, c1731x61f42b4d) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        throw new KotlinNothingValueException();
    }
}
