package androidx.compose.foundation.gestures;

import androidx.appcompat.app.AppCompatDelegate;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.DragGestureDetectorKt", f = "DragGestureDetector.kt", i = {0, 0}, l = {AppCompatDelegate.FEATURE_SUPPORT_ACTION_BAR}, m = "drag-jO51t88", n = {"$this$drag_u2djO51t88", "onDrag"}, s = {"L$0", "L$1"})
final class DragGestureDetectorKt$drag$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    int label;
    Object result;

    DragGestureDetectorKt$drag$1(Continuation<? super DragGestureDetectorKt$drag$1> continuation) {
        super(continuation);
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return DragGestureDetectorKt.m733dragjO51t88(null, 0L, null, (Continuation) this);
    }
}
