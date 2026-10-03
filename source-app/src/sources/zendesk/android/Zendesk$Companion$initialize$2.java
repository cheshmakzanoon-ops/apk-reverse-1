package zendesk.android;

import android.content.Context;
import cz.msebera.android.httpclient.HttpStatus;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import zendesk.android.messaging.MessagingFactory;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.Zendesk$Companion", m37f = "Zendesk.kt", m38i = {0, 0, 0, 0, 0, 1}, m39l = {336, HttpStatus.SC_MOVED_PERMANENTLY}, m40m = "initialize", m41n = {"context", "channelKey", "messagingFactory", "$this$withLock_u24default$iv", "restoreSession", "$this$withLock_u24default$iv"}, m42s = {"L$0", "L$1", "L$2", "L$3", "Z$0", "L$0"})
final class Zendesk$Companion$initialize$2 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    Object L$2;
    Object L$3;
    boolean Z$0;
    int label;
    Object result;
    final Zendesk.Companion this$0;

    Zendesk$Companion$initialize$2(Zendesk.Companion companion, Continuation<? super Zendesk$Companion$initialize$2> continuation) {
        super(continuation);
        this.this$0 = companion;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.initialize((Context) null, (String) null, (MessagingFactory) null, false, (Continuation) this);
    }
}
