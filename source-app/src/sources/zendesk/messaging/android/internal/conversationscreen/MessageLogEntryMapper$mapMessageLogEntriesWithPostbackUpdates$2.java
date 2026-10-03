package zendesk.messaging.android.internal.conversationscreen;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.messaging.android.internal.model.MessageLogEntry;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageLogEntryUpdatedPostback;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.MessageLogEntryMapper$mapMessageLogEntriesWithPostbackUpdates$2", m37f = "MessageLogEntryMapper.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class MessageLogEntryMapper$mapMessageLogEntriesWithPostbackUpdates$2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super MessageLogEntryMapper.MessageLogEntryUpdatedPostback>, Object> {
    final String $actionId;
    final ConversationScreenPostbackStatus $conversationScreenPostbackStatus;
    final Map<String, ConversationScreenPostbackStatus> $mapOfPostbackStatuses;
    final List<MessageLogEntry> $messageLogEntryList;
    int label;
    final MessageLogEntryMapper this$0;

    MessageLogEntryMapper$mapMessageLogEntriesWithPostbackUpdates$2(Map<String, ConversationScreenPostbackStatus> map, String str, ConversationScreenPostbackStatus conversationScreenPostbackStatus, List<? extends MessageLogEntry> list, MessageLogEntryMapper messageLogEntryMapper, Continuation<? super MessageLogEntryMapper$mapMessageLogEntriesWithPostbackUpdates$2> continuation) {
        super(2, continuation);
        this.$mapOfPostbackStatuses = map;
        this.$actionId = str;
        this.$conversationScreenPostbackStatus = conversationScreenPostbackStatus;
        this.$messageLogEntryList = list;
        this.this$0 = messageLogEntryMapper;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new MessageLogEntryMapper$mapMessageLogEntriesWithPostbackUpdates$2(this.$mapOfPostbackStatuses, this.$actionId, this.$conversationScreenPostbackStatus, this.$messageLogEntryList, this.this$0, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super MessageLogEntryMapper.MessageLogEntryUpdatedPostback> continuation) {
        return ((MessageLogEntryMapper$mapMessageLogEntriesWithPostbackUpdates$2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        if (this.label != 0) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        Pair<Map<String, ConversationScreenPostbackStatus>, Boolean> pairUpdatePostbackStatus$zendesk_messaging_messaging_android = PostbackMessageStatusUseCase.INSTANCE.updatePostbackStatus$zendesk_messaging_messaging_android(this.$mapOfPostbackStatuses, this.$actionId, this.$conversationScreenPostbackStatus);
        Map<String, ConversationScreenPostbackStatus> first = pairUpdatePostbackStatus$zendesk_messaging_messaging_android.getFirst();
        boolean zBooleanValue = pairUpdatePostbackStatus$zendesk_messaging_messaging_android.getSecond().booleanValue();
        ArrayList arrayList = new ArrayList();
        List<MessageLogEntry> list = this.$messageLogEntryList;
        MessageLogEntryMapper messageLogEntryMapper = this.this$0;
        Map<String, ConversationScreenPostbackStatus> map = this.$mapOfPostbackStatuses;
        for (MessageLogEntry messageLogEntry : list) {
            if (messageLogEntry instanceof MessageLogEntry.MessageContainer) {
                MessageLogEntry.MessageContainer messageContainer = (MessageLogEntry.MessageContainer) messageLogEntry;
                MessageContent content = messageContainer.getMessage().getContent();
                if (content instanceof MessageContent.Text) {
                    MessageContent content2 = messageContainer.getMessage().getContent();
                    Intrinsics.checkNotNull(content2, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Text");
                    MessageContent.Text text = (MessageContent.Text) content2;
                    List<MessageAction> actions = text.getActions();
                    List<MessageAction> list2 = actions;
                    if (list2 != null && !list2.isEmpty()) {
                        ArrayList arrayList2 = new ArrayList();
                        messageLogEntryMapper.processMessageActions(actions, first, arrayList2);
                        Message message = messageContainer.getMessage();
                        arrayList.add(messageContainer.copy((767 & 1) != 0 ? messageContainer.id : null, (767 & 2) != 0 ? messageContainer.label : null, (767 & 4) != 0 ? messageContainer.avatarUrl : null, (767 & 8) != 0 ? messageContainer.direction : null, (767 & 16) != 0 ? messageContainer.position : null, (767 & 32) != 0 ? messageContainer.shape : null, (767 & 64) != 0 ? messageContainer.size : null, (767 & 128) != 0 ? messageContainer.status : null, (767 & 256) != 0 ? messageContainer.message : message.copy((2021 & 1) != 0 ? message.id : null, (2021 & 2) != 0 ? message.author : null, (2021 & 4) != 0 ? message.status : null, (2021 & 8) != 0 ? message.created : null, (2021 & 16) != 0 ? message.received : null, (2021 & 32) != 0 ? message.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message.content : MessageContent.Text.copy$default(text, null, arrayList2, 1, null), (2021 & 128) != 0 ? message.metadata : null, (2021 & 256) != 0 ? message.sourceId : null, (2021 & 512) != 0 ? message.localId : null, (2021 & 1024) != 0 ? message.payload : null), (767 & 512) != 0 ? messageContainer.receipt : null));
                    } else {
                        arrayList.add(messageLogEntry);
                    }
                } else if (content instanceof MessageContent.Image) {
                    MessageContent content3 = messageContainer.getMessage().getContent();
                    Intrinsics.checkNotNull(content3, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Image");
                    MessageContent.Image image = (MessageContent.Image) content3;
                    List<MessageAction> actions2 = image.getActions();
                    List<MessageAction> list3 = actions2;
                    if (list3 != null && !list3.isEmpty()) {
                        ArrayList arrayList3 = new ArrayList();
                        messageLogEntryMapper.processMessageActions(actions2, map, arrayList3);
                        Message message2 = messageContainer.getMessage();
                        arrayList.add(messageContainer.copy((767 & 1) != 0 ? messageContainer.id : null, (767 & 2) != 0 ? messageContainer.label : null, (767 & 4) != 0 ? messageContainer.avatarUrl : null, (767 & 8) != 0 ? messageContainer.direction : null, (767 & 16) != 0 ? messageContainer.position : null, (767 & 32) != 0 ? messageContainer.shape : null, (767 & 64) != 0 ? messageContainer.size : null, (767 & 128) != 0 ? messageContainer.status : null, (767 & 256) != 0 ? messageContainer.message : message2.copy((2021 & 1) != 0 ? message2.id : null, (2021 & 2) != 0 ? message2.author : null, (2021 & 4) != 0 ? message2.status : null, (2021 & 8) != 0 ? message2.created : null, (2021 & 16) != 0 ? message2.received : null, (2021 & 32) != 0 ? message2.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message2.content : image.copy((123 & 1) != 0 ? image.text : null, (123 & 2) != 0 ? image.mediaUrl : null, (123 & 4) != 0 ? image.localUri : null, (123 & 8) != 0 ? image.mediaType : null, (123 & 16) != 0 ? image.mediaSize : 0L, (123 & 32) != 0 ? image.actions : arrayList3, (123 & 64) != 0 ? image.attachmentId : null), (2021 & 128) != 0 ? message2.metadata : null, (2021 & 256) != 0 ? message2.sourceId : null, (2021 & 512) != 0 ? message2.localId : null, (2021 & 1024) != 0 ? message2.payload : null), (767 & 512) != 0 ? messageContainer.receipt : null));
                    } else {
                        arrayList.add(messageLogEntry);
                    }
                } else {
                    arrayList.add(messageLogEntry);
                }
            } else {
                arrayList.add(messageLogEntry);
            }
        }
        return new MessageLogEntryMapper.MessageLogEntryUpdatedPostback(arrayList, zBooleanValue, first);
    }
}
