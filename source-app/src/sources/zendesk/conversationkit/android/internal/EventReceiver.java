package zendesk.conversationkit.android.internal;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010 \n\u0000\b\u0002\u0018\u00002\u00020\u0001B\u001e\u0012\u0017\u0010\u0002\u001a\u0013\u0012\u0004\u0012\u00020\u0000\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\b\u0005¢\u0006\u0002\u0010\u0006J\u0014\u0010\n\u001a\u00020\u00042\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\t0\u000bJ/\u0010\n\u001a\u00020\u0004\"\u0004\b\u0000\u0010\f2\b\u0010\r\u001a\u0004\u0018\u0001H\f2\u0012\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u0002H\f\u0012\u0004\u0012\u00020\t0\u0003¢\u0006\u0002\u0010\u000eJ\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\t0\u0010R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/EventReceiver;", "", "block", "Lkotlin/Function1;", "", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function1;)V", "events", "", "Lzendesk/conversationkit/android/ConversationKitEvent;", "event", "Lkotlin/Function0;", "T", Bayeux.KEY_DATA, "(Ljava/lang/Object;Lkotlin/jvm/functions/Function1;)V", "toList", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
final class EventReceiver {
    private final List<ConversationKitEvent> events;

    public EventReceiver(Function1<? super EventReceiver, Unit> block) {
        Intrinsics.checkNotNullParameter(block, "block");
        this.events = new ArrayList();
        block.invoke(this);
    }

    public final void event(Function0<? extends ConversationKitEvent> block) {
        Intrinsics.checkNotNullParameter(block, "block");
        this.events.add(block.invoke());
    }

    public final <T> void event(T data, Function1<? super T, ? extends ConversationKitEvent> block) {
        Intrinsics.checkNotNullParameter(block, "block");
        List<ConversationKitEvent> list = this.events;
        if (data == null) {
            return;
        }
        list.add(block.invoke(data));
    }

    public final List<ConversationKitEvent> toList() {
        return CollectionsKt.toList(this.events);
    }
}
