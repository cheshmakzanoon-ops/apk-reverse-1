package zendesk.messaging.android.internal.conversationscreen;

import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;

@Metadata(m17d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a1\u0010\u0000\u001a\u00020\u0001*\u00020\u00012#\u0010\u0002\u001a\u001f\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\u0005\u0012\b\b\u0006\u0012\u0004\b\b(\u0007\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0003H\u0002¨\u0006\b"}, m18d2 = {"overrideWithQuotedMessageDetails", "Lzendesk/conversationkit/android/model/Message;", "quotedMessageFinder", "Lkotlin/Function1;", "", "Lkotlin/ParameterName;", "name", "quotedMessageId", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogEntryMapperKt {
    public static final Message overrideWithQuotedMessageDetails(Message message, Function1<? super String, Message> function1) {
        Message messageInvoke;
        MessageContent content = message.getContent();
        if ((content instanceof MessageContent.FormResponse) && (messageInvoke = function1.invoke(((MessageContent.FormResponse) content).getQuotedMessageId())) != null) {
            return message.copy((2021 & 1) != 0 ? message.id : null, (2021 & 2) != 0 ? message.author : messageInvoke.getAuthor(), (2021 & 4) != 0 ? message.status : null, (2021 & 8) != 0 ? message.created : messageInvoke.getCreated(), (2021 & 16) != 0 ? message.received : messageInvoke.getReceived(), (2021 & 32) != 0 ? message.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message.content : null, (2021 & 128) != 0 ? message.metadata : null, (2021 & 256) != 0 ? message.sourceId : null, (2021 & 512) != 0 ? message.localId : null, (2021 & 1024) != 0 ? message.payload : null);
        }
        return message;
    }
}
