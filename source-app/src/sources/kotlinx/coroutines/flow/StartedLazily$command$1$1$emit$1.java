package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import net.aihelp.data.track.data.TrackType;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.StartedLazily$command$1$1", m37f = "SharingStarted.kt", m38i = {}, m39l = {TrackType.TRACK_FAQ_SUBMIT_SUGGESTION}, m40m = "emit", m41n = {}, m42s = {})
final class StartedLazily$command$1$1$emit$1 extends ContinuationImpl {
    int label;
    Object result;
    final StartedLazily.C03621.AnonymousClass1<T> this$0;

    StartedLazily$command$1$1$emit$1(StartedLazily.C03621.AnonymousClass1<? super T> anonymousClass1, Continuation<? super StartedLazily$command$1$1$emit$1> continuation) {
        super(continuation);
        this.this$0 = anonymousClass1;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(0, this);
    }
}
