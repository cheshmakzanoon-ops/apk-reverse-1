package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
import j$.time.ZoneId;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import zendesk.conversationkit.android.internal.rest.model.MessageActionDto;
import zendesk.conversationkit.android.internal.rest.model.MessageDto;
import zendesk.conversationkit.android.internal.rest.model.MessageFieldDto;
import zendesk.conversationkit.android.internal.rest.model.MessageItemDto;
import zendesk.conversationkit.android.internal.rest.model.MessageListResponseDto;
import zendesk.conversationkit.android.internal.rest.model.MessageSourceDto;
import zendesk.conversationkit.android.internal.rest.model.SendMessageDto;
import zendesk.core.android.internal.DateKtxKt;
import zendesk.core.android.internal.NullabilityKtxKt;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\u001a)\u0010\u0006\u001a\u00020\u0005*\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00012\b\b\u0002\u0010\u0004\u001a\u00020\u0003H\u0000¢\u0006\u0004\b\u0006\u0010\u0007\u001a\u0013\u0010\t\u001a\u00020\b*\u00020\u0000H\u0000¢\u0006\u0004\b\t\u0010\n\u001a\u0011\u0010\f\u001a\u00020\u000b*\u00020\b¢\u0006\u0004\b\f\u0010\r\u001a\u0013\u0010\u000f\u001a\u00020\u000e*\u00020\u0005H\u0000¢\u0006\u0004\b\u000f\u0010\u0010\u001a\u001b\u0010\u0013\u001a\u00020\u0005*\u00020\u00052\u0006\u0010\u0012\u001a\u00020\u0011H\u0000¢\u0006\u0004\b\u0013\u0010\u0014\u001a\u001b\u0010\u0016\u001a\u00020\u000b*\u00020\u00052\u0006\u0010\u0015\u001a\u00020\u0005H\u0000¢\u0006\u0004\b\u0016\u0010\u0017\u001a\u001b\u0010\u0018\u001a\u00020\u000b*\u00020\u00052\u0006\u0010\u0015\u001a\u00020\u0005H\u0000¢\u0006\u0004\b\u0018\u0010\u0017\u001a\u0013\u0010\u001b\u001a\u00020\u001a*\u00020\u0019H\u0000¢\u0006\u0004\b\u001b\u0010\u001c\u001a\u0015\u0010\u001e\u001a\u0004\u0018\u00010\u001d*\u00020\bH\u0000¢\u0006\u0004\b\u001e\u0010\u001f\u001a\u001b\u0010\"\u001a\u0004\u0018\u00010\u001d*\b\u0012\u0004\u0012\u00020!0 H\u0000¢\u0006\u0004\b\"\u0010#¨\u0006$"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "j$/time/LocalDateTime", "created", "", "localId", "Lzendesk/conversationkit/android/model/Message;", "toMessage", "(Lzendesk/conversationkit/android/internal/rest/model/MessageDto;Lj$/time/LocalDateTime;Ljava/lang/String;)Lzendesk/conversationkit/android/model/Message;", "Lzendesk/conversationkit/android/model/MessageContent;", "toMessageContent", "(Lzendesk/conversationkit/android/internal/rest/model/MessageDto;)Lzendesk/conversationkit/android/model/MessageContent;", "", "isPrivateAttachment", "(Lzendesk/conversationkit/android/model/MessageContent;)Z", "Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto;", "toSendMessageDto", "(Lzendesk/conversationkit/android/model/Message;)Lzendesk/conversationkit/android/internal/rest/model/SendMessageDto;", "Lzendesk/conversationkit/android/model/Conversation;", "conversation", "enrichFormResponseFields", "(Lzendesk/conversationkit/android/model/Message;Lzendesk/conversationkit/android/model/Conversation;)Lzendesk/conversationkit/android/model/Message;", "message", "remoteOrLocalIdsAreEqual", "(Lzendesk/conversationkit/android/model/Message;Lzendesk/conversationkit/android/model/Message;)Z", "shouldLocalIdBeUpdated", "Lzendesk/conversationkit/android/internal/rest/model/MessageListResponseDto;", "Lzendesk/conversationkit/android/model/MessageList;", "toMessageList", "(Lzendesk/conversationkit/android/internal/rest/model/MessageListResponseDto;)Lzendesk/conversationkit/android/model/MessageList;", "Lzendesk/conversationkit/android/model/MessageAction$WebView;", "checkMessageIsAWebViewWithOpenOnReceive", "(Lzendesk/conversationkit/android/model/MessageContent;)Lzendesk/conversationkit/android/model/MessageAction$WebView;", "", "Lzendesk/conversationkit/android/model/MessageAction;", "findWebViewActionWithOpenOnReceive", "(Ljava/util/List;)Lzendesk/conversationkit/android/model/MessageAction$WebView;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageKt {

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[MessageType.values().length];
            try {
                iArr[MessageType.TEXT.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[MessageType.FILE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[MessageType.FORM.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[MessageType.FORM_RESPONSE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[MessageType.CAROUSEL.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[MessageType.IMAGE.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static Message toMessage$default(MessageDto messageDto, LocalDateTime localDateTime, String str, int i, Object obj) {
        MessageSourceDto source;
        if ((i & 1) != 0) {
            localDateTime = null;
        }
        if ((i & 2) != 0 && ((source = messageDto.getSource()) == null || (str = source.getSessionId()) == null)) {
            str = messageDto.getId();
        }
        return toMessage(messageDto, localDateTime, str);
    }

    public static final Message toMessage(MessageDto messageDto, LocalDateTime localDateTime, String localId) {
        String id;
        Intrinsics.checkNotNullParameter(messageDto, "<this>");
        Intrinsics.checkNotNullParameter(localId, "localId");
        String id2 = messageDto.getId();
        String authorId = messageDto.getAuthorId();
        AuthorType authorTypeFindByValue = AuthorType.INSTANCE.findByValue(messageDto.getRole());
        List<String> subroles = messageDto.getSubroles();
        if (subroles == null) {
            subroles = CollectionsKt.emptyList();
        }
        ArrayList arrayList = new ArrayList();
        Iterator<T> it = subroles.iterator();
        while (it.hasNext()) {
            AuthorSubtype authorSubtypeFindByValue = AuthorSubtype.INSTANCE.findByValue((String) it.next());
            if (authorSubtypeFindByValue != null) {
                arrayList.add(authorSubtypeFindByValue);
            }
        }
        ArrayList arrayList2 = arrayList;
        String name = messageDto.getName();
        Author author = new Author(authorId, authorTypeFindByValue, arrayList2, name == null ? "" : name, messageDto.getAvatarUrl());
        MessageStatus.Sent sent = new MessageStatus.Sent(null, 1, 0 == true ? 1 : 0);
        LocalDateTime localDateTime$default = DateKtxKt.toLocalDateTime$default(messageDto.getReceived(), (ZoneId) null, 1, (Object) null);
        double received = messageDto.getReceived();
        MessageContent messageContent = toMessageContent(messageDto);
        Map<String, Object> metadata = messageDto.getMetadata();
        MessageSourceDto source = messageDto.getSource();
        return new Message(id2, author, sent, localDateTime, localDateTime$default, received, messageContent, metadata, (source == null || (id = source.getId()) == null) ? "" : id, localId, messageDto.getPayload());
    }

    public static final MessageContent toMessageContent(MessageDto messageDto) {
        Intrinsics.checkNotNullParameter(messageDto, "<this>");
        switch (WhenMappings.$EnumSwitchMapping$0[MessageType.INSTANCE.findByValue(messageDto.getType()).ordinal()]) {
            case 1:
                String text = messageDto.getText();
                String str = text != null ? text : "";
                List<MessageActionDto> actions = messageDto.getActions();
                if (actions == null) {
                    actions = CollectionsKt.emptyList();
                }
                ArrayList arrayList = new ArrayList();
                Iterator<T> it = actions.iterator();
                while (it.hasNext()) {
                    MessageAction action = MessageActionKt.toAction((MessageActionDto) it.next());
                    if (action != null) {
                        arrayList.add(action);
                    }
                }
                return new MessageContent.Text(str, arrayList);
            case 2:
                String text2 = messageDto.getText();
                String str2 = text2 == null ? "" : text2;
                String altText = messageDto.getAltText();
                String str3 = altText == null ? "" : altText;
                String mediaUrl = messageDto.getMediaUrl();
                String str4 = mediaUrl == null ? "" : mediaUrl;
                String mediaType = messageDto.getMediaType();
                String str5 = mediaType == null ? "" : mediaType;
                Long mediaSize = messageDto.getMediaSize();
                return new MessageContent.File(str2, str3, str4, str5, mediaSize != null ? mediaSize.longValue() : 0L, messageDto.getAttachmentId());
            case 3:
                List<MessageFieldDto> fields = messageDto.getFields();
                if (fields == null) {
                    fields = CollectionsKt.emptyList();
                }
                ArrayList arrayList2 = new ArrayList();
                Iterator<T> it2 = fields.iterator();
                while (it2.hasNext()) {
                    Field field = FieldKt.toField((MessageFieldDto) it2.next());
                    if (field != null) {
                        arrayList2.add(field);
                    }
                }
                ArrayList arrayList3 = arrayList2;
                Boolean blockChatInput = messageDto.getBlockChatInput();
                return new MessageContent.Form(messageDto.getId(), arrayList3, blockChatInput != null ? blockChatInput.booleanValue() : false);
            case 4:
                List<MessageFieldDto> fields2 = messageDto.getFields();
                if (fields2 == null) {
                    fields2 = CollectionsKt.emptyList();
                }
                ArrayList arrayList4 = new ArrayList();
                Iterator<T> it3 = fields2.iterator();
                while (it3.hasNext()) {
                    Field field2 = FieldKt.toField((MessageFieldDto) it3.next());
                    if (field2 != null) {
                        arrayList4.add(field2);
                    }
                }
                ArrayList arrayList5 = arrayList4;
                String quotedMessageId = messageDto.getQuotedMessageId();
                return new MessageContent.FormResponse(quotedMessageId != null ? quotedMessageId : "", arrayList5);
            case 5:
                List<MessageItemDto> items = messageDto.getItems();
                if (items == null) {
                    items = CollectionsKt.emptyList();
                }
                List<MessageItemDto> list = items;
                ArrayList arrayList6 = new ArrayList(CollectionsKt.collectionSizeOrDefault(list, 10));
                Iterator<T> it4 = list.iterator();
                while (it4.hasNext()) {
                    arrayList6.add(MessageItemKt.toItem((MessageItemDto) it4.next()));
                }
                return new MessageContent.Carousel(arrayList6);
            case 6:
                String text3 = messageDto.getText();
                String str6 = text3 == null ? "" : text3;
                String mediaUrl2 = messageDto.getMediaUrl();
                String str7 = mediaUrl2 == null ? "" : mediaUrl2;
                String mediaType2 = messageDto.getMediaType();
                String str8 = mediaType2 == null ? "" : mediaType2;
                Long mediaSize2 = messageDto.getMediaSize();
                long jLongValue = mediaSize2 != null ? mediaSize2.longValue() : 0L;
                List<MessageActionDto> actions2 = messageDto.getActions();
                if (actions2 == null) {
                    actions2 = CollectionsKt.emptyList();
                }
                ArrayList arrayList7 = new ArrayList();
                Iterator<T> it5 = actions2.iterator();
                while (it5.hasNext()) {
                    MessageAction action2 = MessageActionKt.toAction((MessageActionDto) it5.next());
                    if (action2 != null) {
                        arrayList7.add(action2);
                    }
                }
                return new MessageContent.Image(str6, str7, null, str8, jLongValue, arrayList7, messageDto.getAttachmentId());
            default:
                String textFallback = messageDto.getTextFallback();
                List list2 = null;
                Object[] objArr = 0;
                Object[] objArr2 = 0;
                Object[] objArr3 = 0;
                if (textFallback == null || StringsKt.isBlank(textFallback)) {
                    return new MessageContent.Unsupported((String) (objArr2 == true ? 1 : 0), 1, (DefaultConstructorMarker) (objArr == true ? 1 : 0));
                }
                return new MessageContent.Text(messageDto.getTextFallback(), list2, 2, (DefaultConstructorMarker) (objArr3 == true ? 1 : 0));
        }
    }

    public static final boolean isPrivateAttachment(MessageContent messageContent) {
        Intrinsics.checkNotNullParameter(messageContent, "<this>");
        if (messageContent instanceof MessageContent.File) {
            return NullabilityKtxKt.isNotNullOrEmpty(((MessageContent.File) messageContent).getAttachmentId());
        }
        if (messageContent instanceof MessageContent.Image) {
            return NullabilityKtxKt.isNotNullOrEmpty(((MessageContent.Image) messageContent).getAttachmentId());
        }
        return false;
    }

    public static final SendMessageDto toSendMessageDto(Message message) throws IllegalArgumentException {
        Intrinsics.checkNotNullParameter(message, "<this>");
        MessageContent content = message.getContent();
        if (content instanceof MessageContent.Text) {
            return new SendMessageDto.Text(message.getAuthor().getType().getValue(), message.getMetadata(), message.getPayload(), ((MessageContent.Text) message.getContent()).getText());
        }
        if (content instanceof MessageContent.FormResponse) {
            String value = message.getAuthor().getType().getValue();
            Map<String, Object> metadata = message.getMetadata();
            String payload = message.getPayload();
            List<Field> fields = ((MessageContent.FormResponse) message.getContent()).getFields();
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(fields, 10));
            Iterator<T> it = fields.iterator();
            while (it.hasNext()) {
                arrayList.add(FieldKt.toSendFieldResponseDto((Field) it.next()));
            }
            return new SendMessageDto.FormResponse(value, metadata, payload, arrayList, ((MessageContent.FormResponse) message.getContent()).getQuotedMessageId());
        }
        throw new IllegalArgumentException("Message with the " + message.getContent().getMessageContentType() + " content type cannot be sent by this SDK");
    }

    public static final Message enrichFormResponseFields(Message message, Conversation conversation) {
        Object next;
        Object next2;
        Object next3;
        Object next4;
        Intrinsics.checkNotNullParameter(message, "<this>");
        Intrinsics.checkNotNullParameter(conversation, "conversation");
        if (!(message.getContent() instanceof MessageContent.FormResponse)) {
            return message;
        }
        Iterator<T> it = conversation.getMessages().iterator();
        do {
            if (!it.hasNext()) {
                next = null;
                break;
            }
            next = it.next();
        } while (!Intrinsics.areEqual(((Message) next).getId(), ((MessageContent.FormResponse) message.getContent()).getQuotedMessageId()));
        Message message2 = (Message) next;
        MessageContent content = message2 != null ? message2.getContent() : null;
        if (!(content instanceof MessageContent.Form)) {
            return message;
        }
        MessageContent.FormResponse formResponse = (MessageContent.FormResponse) message.getContent();
        List<Field> fields = ((MessageContent.FormResponse) message.getContent()).getFields();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(fields, 10));
        for (Field.Select selectCopy$default : fields) {
            if (!(selectCopy$default instanceof Field.Text)) {
                if (!(selectCopy$default instanceof Field.Email)) {
                    if (!(selectCopy$default instanceof Field.Select)) {
                        throw new NoWhenBranchMatchedException();
                    }
                    Iterator<T> it2 = ((MessageContent.Form) content).getFields().iterator();
                    do {
                        if (!it2.hasNext()) {
                            next2 = null;
                            break;
                        }
                        next2 = it2.next();
                    } while (!Intrinsics.areEqual(((Field) next2).getId(), selectCopy$default.getId()));
                    Field field = (Field) next2;
                    if (field instanceof Field.Select) {
                        Field.Select select = (Field.Select) field;
                        selectCopy$default = Field.Select.copy$default((Field.Select) selectCopy$default, null, null, null, select.getPlaceholder(), select.getOptions(), select.getSelectSize(), null, 71, null);
                    }
                } else {
                    Iterator<T> it3 = ((MessageContent.Form) content).getFields().iterator();
                    do {
                        if (!it3.hasNext()) {
                            next3 = null;
                            break;
                        }
                        next3 = it3.next();
                    } while (!Intrinsics.areEqual(((Field) next3).getId(), selectCopy$default.getId()));
                    Field field2 = (Field) next3;
                    if (field2 instanceof Field.Email) {
                        selectCopy$default = Field.Email.copy$default((Field.Email) selectCopy$default, null, null, null, ((Field.Email) field2).getPlaceholder(), null, 23, null);
                    }
                }
            } else {
                Iterator<T> it4 = ((MessageContent.Form) content).getFields().iterator();
                do {
                    if (!it4.hasNext()) {
                        next4 = null;
                        break;
                    }
                    next4 = it4.next();
                } while (!Intrinsics.areEqual(((Field) next4).getId(), selectCopy$default.getId()));
                Field field3 = (Field) next4;
                if (field3 instanceof Field.Text) {
                    Field.Text text = (Field.Text) field3;
                    selectCopy$default = Field.Text.copy$default((Field.Text) selectCopy$default, null, null, null, text.getPlaceholder(), text.getMinSize(), text.getMaxSize(), null, 71, null);
                }
            }
            arrayList.add(selectCopy$default);
        }
        return message.copy((2021 & 1) != 0 ? message.id : null, (2021 & 2) != 0 ? message.author : null, (2021 & 4) != 0 ? message.status : null, (2021 & 8) != 0 ? message.created : null, (2021 & 16) != 0 ? message.received : null, (2021 & 32) != 0 ? message.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message.content : MessageContent.FormResponse.copy$default(formResponse, null, arrayList, 1, null), (2021 & 128) != 0 ? message.metadata : null, (2021 & 256) != 0 ? message.sourceId : null, (2021 & 512) != 0 ? message.localId : null, (2021 & 1024) != 0 ? message.payload : null);
    }

    public static final boolean remoteOrLocalIdsAreEqual(Message message, Message message2) {
        Intrinsics.checkNotNullParameter(message, "<this>");
        Intrinsics.checkNotNullParameter(message2, "message");
        return Intrinsics.areEqual(message.getLocalId(), message2.getLocalId()) || Intrinsics.areEqual(message.getId(), message2.getId());
    }

    public static final boolean shouldLocalIdBeUpdated(Message message, Message message2) {
        Intrinsics.checkNotNullParameter(message, "<this>");
        Intrinsics.checkNotNullParameter(message2, "message");
        return (Intrinsics.areEqual(message.getId(), message.getLocalId()) || !Intrinsics.areEqual(message.getLocalId(), message2.getLocalId()) || Intrinsics.areEqual(message.getId(), message2.getId())) ? false : true;
    }

    public static final MessageList toMessageList(MessageListResponseDto messageListResponseDto) {
        Intrinsics.checkNotNullParameter(messageListResponseDto, "<this>");
        List<MessageDto> messages = messageListResponseDto.getMessages();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(messages, 10));
        Iterator<T> it = messages.iterator();
        while (it.hasNext()) {
            arrayList.add(toMessage$default((MessageDto) it.next(), null, null, 3, null));
        }
        return new MessageList(arrayList, messageListResponseDto.getHasPrevious(), messageListResponseDto.getHasNext());
    }

    public static final MessageAction.WebView checkMessageIsAWebViewWithOpenOnReceive(MessageContent messageContent) {
        MessageAction.WebView webViewFindWebViewActionWithOpenOnReceive;
        Intrinsics.checkNotNullParameter(messageContent, "<this>");
        MessageAction messageAction = null;
        if (messageContent instanceof MessageContent.Text) {
            List<MessageAction> actions = ((MessageContent.Text) messageContent).getActions();
            if (actions != null) {
                webViewFindWebViewActionWithOpenOnReceive = findWebViewActionWithOpenOnReceive(actions);
                messageAction = webViewFindWebViewActionWithOpenOnReceive;
            }
        } else if (messageContent instanceof MessageContent.Image) {
            List<MessageAction> actions2 = ((MessageContent.Image) messageContent).getActions();
            if (actions2 != null) {
                webViewFindWebViewActionWithOpenOnReceive = findWebViewActionWithOpenOnReceive(actions2);
                messageAction = webViewFindWebViewActionWithOpenOnReceive;
            }
        } else if (messageContent instanceof MessageContent.Carousel) {
            Iterator<T> it = ((MessageContent.Carousel) messageContent).getItems().iterator();
            while (it.hasNext()) {
                for (MessageAction messageAction2 : ((MessageItem) it.next()).getActions()) {
                    if ((messageAction2 instanceof MessageAction.WebView) && ((MessageAction.WebView) messageAction2).getOpenOnReceive()) {
                        messageAction = messageAction2;
                    }
                }
            }
        }
        return (MessageAction.WebView) messageAction;
    }

    public static final MessageAction.WebView findWebViewActionWithOpenOnReceive(List<? extends MessageAction> list) {
        Intrinsics.checkNotNullParameter(list, "<this>");
        for (MessageAction messageAction : list) {
            if (messageAction instanceof MessageAction.WebView) {
                MessageAction.WebView webView = (MessageAction.WebView) messageAction;
                if (webView.getOpenOnReceive()) {
                    return webView;
                }
            }
        }
        return null;
    }
}
