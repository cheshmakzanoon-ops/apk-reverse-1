package androidx.compose.p002ui.contentcapture;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.contentcapture.AndroidContentCaptureManager", f = "AndroidContentCaptureManager.android.kt", i = {0, 1}, l = {186, 196}, m = "boundsUpdatesEventLoop$ui_release", n = {"this", "this"}, s = {"L$0", "L$0"})
final class AndroidContentCaptureManager$boundsUpdatesEventLoop$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    int label;
    Object result;
    final AndroidContentCaptureManager this$0;

    AndroidContentCaptureManager$boundsUpdatesEventLoop$1(AndroidContentCaptureManager androidContentCaptureManager, Continuation<? super AndroidContentCaptureManager$boundsUpdatesEventLoop$1> continuation) {
        super(continuation);
        this.this$0 = androidContentCaptureManager;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.boundsUpdatesEventLoop$ui_release((Continuation) this);
    }
}
