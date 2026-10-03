package androidx.compose.material3;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.TimePickerKt", f = "TimePicker.kt", i = {0, 0, 1, 1}, l = {894, 897}, m = "onTap-rOwcSBo", n = {"$this$onTap_u2drOwcSBo", "autoSwitchToMinute", "$this$onTap_u2drOwcSBo", "autoSwitchToMinute"}, s = {"L$0", "Z$0", "L$0", "Z$0"})
final class TimePickerKt$onTap$1 extends ContinuationImpl {
    Object L$0;
    boolean Z$0;
    int label;
    Object result;

    TimePickerKt$onTap$1(Continuation<? super TimePickerKt$onTap$1> continuation) {
        super(continuation);
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return TimePickerKt.m3060onTaprOwcSBo(null, 0.0f, 0.0f, 0.0f, false, 0L, (Continuation) this);
    }
}
