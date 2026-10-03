package androidx.compose.p002ui.platform;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.platform.ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1", f = "PlatformTextInputModifierNode.kt", i = {}, l = {239}, m = "startInputMethod", n = {}, s = {})
final class C1731x61f42b4d extends ContinuationImpl {
    int label;
    Object result;
    final ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1 this$0;

    C1731x61f42b4d(ChainedPlatformTextInputInterceptor$textInputSession$2$scope$1 chainedPlatformTextInputInterceptor$textInputSession$2$scope$1, Continuation<? super C1731x61f42b4d> continuation) {
        super(continuation);
        this.this$0 = chainedPlatformTextInputInterceptor$textInputSession$2$scope$1;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.startInputMethod(null, (Continuation) this);
    }
}
