package zendesk.messaging.android.internal.conversationscreen.messagelog;

import android.util.Log;
import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001H\n¢\u0006\u0002\b\u0002"}, m18d2 = {"<anonymous>", "", "run"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
final class MessageLogView$render$2$1$1$1 implements Runnable {
    final MessageLogView this$0;

    MessageLogView$render$2$1$1$1(MessageLogView messageLogView) {
        this.this$0 = messageLogView;
    }

    @Override
    public final void run() {
        this.this$0.hideSeeLatestView();
        try {
            MessageLogView messageLogView = this.this$0;
            messageLogView.showNewMessagesViewIfNeeded(messageLogView.rendering.getState().getMessageLogEntryList$zendesk_messaging_messaging_android());
        } catch (Exception e) {
            Log.d(MessageLogView.TAG, "NewMessageView error: " + e.getCause());
        }
    }
}
