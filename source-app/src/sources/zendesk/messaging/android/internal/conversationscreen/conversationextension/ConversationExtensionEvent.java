package zendesk.messaging.android.internal.conversationscreen.conversationextension;

import cz.msebera.android.httpclient.protocol.HTTP;
import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0001\u0002\u0082\u0001\u0001\u0003¨\u0006\u0004"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionEvent;", "", HTTP.CONN_CLOSE, "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionEvent$Close;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationExtensionEvent {

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionEvent$Close;", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionEvent;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Close implements ConversationExtensionEvent {
        public static final Close INSTANCE = new Close();

        private Close() {
        }
    }
}
