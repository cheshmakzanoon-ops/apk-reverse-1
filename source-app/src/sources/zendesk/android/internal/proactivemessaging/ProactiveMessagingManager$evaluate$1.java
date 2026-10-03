package zendesk.android.internal.proactivemessaging;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.p002io.encoding.Base64;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingManager", m37f = "ProactiveMessagingManager.kt", m38i = {0, 0, 1, 1, 2, 2}, m39l = {Base64.mimeLineLength, 80, 98}, m40m = "evaluate$zendesk_zendesk_android", m41n = {"this", "event", "this", "event", "this", "event"}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$0", "L$1"})
final class ProactiveMessagingManager$evaluate$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    Object L$2;
    int label;
    Object result;
    final ProactiveMessagingManager this$0;

    ProactiveMessagingManager$evaluate$1(ProactiveMessagingManager proactiveMessagingManager, Continuation<? super ProactiveMessagingManager$evaluate$1> continuation) {
        super(continuation);
        this.this$0 = proactiveMessagingManager;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.evaluate$zendesk_zendesk_android(null, this);
    }
}
