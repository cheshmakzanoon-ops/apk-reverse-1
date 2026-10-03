package zendesk.messaging.android.internal;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import net.aihelp.data.track.data.TrackType;
import zendesk.conversationkit.android.ConversationKitEvent;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$3$1$1", m37f = "DefaultMessaging.kt", m38i = {4}, m39l = {95, 99, 102, TrackType.TRACK_ENTRANCE_CLICK_FAQ, 109, 110, 136, 145, TrackType.TRACK_FAQ_MARKED_UNHELPFUL}, m40m = "emit", m41n = {"this"}, m42s = {"L$0"})
final class DefaultMessaging$3$1$1$emit$1 extends ContinuationImpl {
    Object L$0;
    int label;
    Object result;
    final DefaultMessaging.C12613.AnonymousClass1.C16671<T> this$0;

    DefaultMessaging$3$1$1$emit$1(DefaultMessaging.C12613.AnonymousClass1.C16671<? super T> c16671, Continuation<? super DefaultMessaging$3$1$1$emit$1> continuation) {
        super(continuation);
        this.this$0 = c16671;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit((ConversationKitEvent) null, (Continuation<? super Unit>) this);
    }
}
