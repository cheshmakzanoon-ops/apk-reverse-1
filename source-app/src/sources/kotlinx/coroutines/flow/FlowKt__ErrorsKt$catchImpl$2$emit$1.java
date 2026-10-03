package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import net.aihelp.data.track.data.TrackType;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ErrorsKt$catchImpl$2", m37f = "Errors.kt", m38i = {0}, m39l = {TrackType.TRACK_FAQ_SUBMIT_SUGGESTION}, m40m = "emit", m41n = {"this"}, m42s = {"L$0"})
final class FlowKt__ErrorsKt$catchImpl$2$emit$1 extends ContinuationImpl {
    Object L$0;
    int label;
    Object result;
    final FlowKt__ErrorsKt.C02942<T> this$0;

    FlowKt__ErrorsKt$catchImpl$2$emit$1(FlowKt__ErrorsKt.C02942<? super T> c02942, Continuation<? super FlowKt__ErrorsKt$catchImpl$2$emit$1> continuation) {
        super(continuation);
        this.this$0 = c02942;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, this);
    }
}
