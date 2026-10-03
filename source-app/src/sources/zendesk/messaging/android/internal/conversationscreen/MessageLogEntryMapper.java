package zendesk.messaging.android.internal.conversationscreen;

import j$.time.LocalDateTime;
import j$.time.chrono.ChronoLocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineDispatcher;
import zendesk.conversationkit.android.internal.extension.PrivateAttachmentUtilKt;
import zendesk.conversationkit.android.model.Author;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageKt;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.conversationkit.android.model.MessageType;
import zendesk.conversationkit.android.model.Participant;
import zendesk.core.android.internal.DateKtxKt;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.core.p017ui.android.internal.model.MessageDirection;
import zendesk.core.p017ui.android.internal.model.MessagePosition;
import zendesk.core.p017ui.android.internal.model.MessageShape;
import zendesk.messaging.android.internal.model.LoadMoreStatus;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessageLogType;
import zendesk.messaging.android.internal.model.TypingUser;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

@Metadata(m17d1 = {"\u0000²\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010#\n\u0000\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010%\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0000\u0018\u0000 T2\u00020\u0001:\u0003TUVBK\b\u0007\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u000e\b\u0001\u0010\n\u001a\b\u0012\u0004\u0012\u00020\t0\b\u0012\u000e\b\u0001\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\b\u0012\b\b\u0001\u0010\u000e\u001a\u00020\r¢\u0006\u0004\b\u000f\u0010\u0010J]\u0010\u001e\u001a\u00020\u001d*\b\u0012\u0004\u0012\u00020\u00120\u00112\b\u0010\u0014\u001a\u0004\u0018\u00010\u00132\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u00122\u0006\u0010\u0016\u001a\u00020\u00122\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\t0\u00172\f\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00192\b\u0010\u001c\u001a\u0004\u0018\u00010\u000bH\u0002¢\u0006\u0004\b\u001e\u0010\u001fJ!\u0010#\u001a\u00020\"2\u0006\u0010 \u001a\u00020\u00122\b\u0010!\u001a\u0004\u0018\u00010\u0012H\u0002¢\u0006\u0004\b#\u0010$J!\u0010&\u001a\u00020\"2\u0006\u0010 \u001a\u00020\u00122\b\u0010%\u001a\u0004\u0018\u00010\u0012H\u0002¢\u0006\u0004\b&\u0010$J9\u0010(\u001a\u00020\u001d*\b\u0012\u0004\u0012\u00020\u001a0\u00192\u0006\u0010'\u001a\u00020\u00122\b\u0010!\u001a\u0004\u0018\u00010\u00122\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\t0\u0017H\u0002¢\u0006\u0004\b(\u0010)J\u001f\u0010-\u001a\u00020,2\u0006\u0010*\u001a\u00020\"2\u0006\u0010+\u001a\u00020\"H\u0002¢\u0006\u0004\b-\u0010.J/\u00101\u001a\u0002002\u0006\u0010 \u001a\u00020\u00122\u0006\u0010/\u001a\u00020,2\u0006\u0010*\u001a\u00020\"2\u0006\u0010+\u001a\u00020\"H\u0002¢\u0006\u0004\b1\u00102J?\u00109\u001a\u00020\u001d2\f\u00104\u001a\b\u0012\u0004\u0012\u0002030\u00112\u0012\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u000206052\f\u00108\u001a\b\u0012\u0004\u0012\u0002030\u0019H\u0002¢\u0006\u0004\b9\u0010:JC\u0010B\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00112\u0006\u0010<\u001a\u00020;2\b\u0010=\u001a\u0004\u0018\u00010\t2\b\b\u0002\u0010?\u001a\u00020>2\b\b\u0002\u0010A\u001a\u00020@2\b\u0010\u001c\u001a\u0004\u0018\u00010\u000b¢\u0006\u0004\bB\u0010CJF\u0010K\u001a\u00020H2\u0012\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u0002060D2\f\u0010E\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00112\u0006\u0010F\u001a\u0002062\n\b\u0002\u0010G\u001a\u0004\u0018\u00010\u000bH\u0080@¢\u0006\u0004\bI\u0010JR\u0014\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010LR\u0014\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010MR\u0014\u0010\u0007\u001a\u00020\u00068\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0007\u0010NR\u001a\u0010\n\u001a\b\u0012\u0004\u0012\u00020\t0\b8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\n\u0010OR\u001a\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\b8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\f\u0010OR\u0014\u0010\u000e\u001a\u00020\r8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u000e\u0010PR\u001a\u0010R\u001a\b\u0012\u0004\u0012\u00020Q0\u00118\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\bR\u0010S¨\u0006W"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper;", "", "Lzendesk/messaging/android/internal/conversationscreen/MessageContainerFactory;", "messageContainerFactory", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;", "labelProvider", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;", "timestampFormatter", "Lkotlin/Function0;", "j$/time/LocalDateTime", MessagingComponentKt.CURRENT_TIME_PROVIDER, "", MessagingComponentKt.ID_PROVIDER, "Lkotlinx/coroutines/CoroutineDispatcher;", "defaultDispatcher", "<init>", "(Lzendesk/messaging/android/internal/conversationscreen/MessageContainerFactory;Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;Lkotlinx/coroutines/CoroutineDispatcher;)V", "", "Lzendesk/conversationkit/android/model/Message;", "Lzendesk/conversationkit/android/model/Participant;", "currentUser", "lastReadMessage", "latestMessage", "", "addedDayDividers", "", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "destination", "authorizationToken", "", "mapIntoMessageLogEntry", "(Ljava/util/List;Lzendesk/conversationkit/android/model/Participant;Lzendesk/conversationkit/android/model/Message;Lzendesk/conversationkit/android/model/Message;Ljava/util/Set;Ljava/util/List;Ljava/lang/String;)V", "currentMessage", "previousMessage", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageNeighbour;", "compareWithPrevious", "(Lzendesk/conversationkit/android/model/Message;Lzendesk/conversationkit/android/model/Message;)Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageNeighbour;", "nextMessage", "compareWithNext", "message", "handleTimestampDivider", "(Ljava/util/List;Lzendesk/conversationkit/android/model/Message;Lzendesk/conversationkit/android/model/Message;Ljava/util/Set;)V", "previousNeighbour", "nextNeighbour", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "getPosition", "(Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageNeighbour;Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageNeighbour;)Lzendesk/core/ui/android/internal/model/MessagePosition;", "currentMessagePosition", "Lzendesk/core/ui/android/internal/model/MessageShape;", "getShape", "(Lzendesk/conversationkit/android/model/Message;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageNeighbour;Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageNeighbour;)Lzendesk/core/ui/android/internal/model/MessageShape;", "Lzendesk/conversationkit/android/model/MessageAction;", "messageActions", "", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenPostbackStatus;", "mapOfPostbackStatuses", "newMessageActions", "processMessageActions", "(Ljava/util/List;Ljava/util/Map;Ljava/util/List;)V", "Lzendesk/conversationkit/android/model/Conversation;", "conversation", "newMessageDividerDate", "Lzendesk/messaging/android/internal/model/TypingUser;", "typingUser", "Lzendesk/messaging/android/internal/model/LoadMoreStatus;", "loadMoreStatus", "map", "(Lzendesk/conversationkit/android/model/Conversation;Lj$/time/LocalDateTime;Lzendesk/messaging/android/internal/model/TypingUser;Lzendesk/messaging/android/internal/model/LoadMoreStatus;Ljava/lang/String;)Ljava/util/List;", "", "messageLogEntryList", "conversationScreenPostbackStatus", "actionId", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageLogEntryUpdatedPostback;", "mapMessageLogEntriesWithPostbackUpdates$zendesk_messaging_messaging_android", "(Ljava/util/Map;Ljava/util/List;Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenPostbackStatus;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "mapMessageLogEntriesWithPostbackUpdates", "Lzendesk/messaging/android/internal/conversationscreen/MessageContainerFactory;", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;", "Lkotlin/jvm/functions/Function0;", "Lkotlinx/coroutines/CoroutineDispatcher;", "Lzendesk/conversationkit/android/model/MessageType;", "allowedGroupingTypes", "Ljava/util/List;", "Companion", "MessageLogEntryUpdatedPostback", "MessageNeighbour", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogEntryMapper {
    private static final String MESSAGE_DIVIDER_ID_PREFIX = "CONSTANT_MESSAGE_DIVIDER_ID_";
    private static final String TYPING_INDICATOR_ID = "CONSTANT_TYPING_INDICATOR_ID";
    private final List<MessageType> allowedGroupingTypes;
    private final Function0<LocalDateTime> currentTimeProvider;
    private final CoroutineDispatcher defaultDispatcher;
    private final Function0<String> idProvider;
    private final MessageLogLabelProvider labelProvider;
    private final MessageContainerFactory messageContainerFactory;
    private final MessageLogTimestampFormatter timestampFormatter;

    @Inject
    public MessageLogEntryMapper(MessageContainerFactory messageContainerFactory, MessageLogLabelProvider labelProvider, MessageLogTimestampFormatter timestampFormatter, @Named(MessagingComponentKt.CURRENT_TIME_PROVIDER) Function0<LocalDateTime> currentTimeProvider, @Named(MessagingComponentKt.ID_PROVIDER) Function0<String> idProvider, @Named(CoroutineDispatchersModule.DEFAULT_DISPATCHER) CoroutineDispatcher defaultDispatcher) {
        Intrinsics.checkNotNullParameter(messageContainerFactory, "messageContainerFactory");
        Intrinsics.checkNotNullParameter(labelProvider, "labelProvider");
        Intrinsics.checkNotNullParameter(timestampFormatter, "timestampFormatter");
        Intrinsics.checkNotNullParameter(currentTimeProvider, "currentTimeProvider");
        Intrinsics.checkNotNullParameter(idProvider, "idProvider");
        Intrinsics.checkNotNullParameter(defaultDispatcher, "defaultDispatcher");
        this.messageContainerFactory = messageContainerFactory;
        this.labelProvider = labelProvider;
        this.timestampFormatter = timestampFormatter;
        this.currentTimeProvider = currentTimeProvider;
        this.idProvider = idProvider;
        this.defaultDispatcher = defaultDispatcher;
        this.allowedGroupingTypes = CollectionsKt.listOf((Object[]) new MessageType[]{MessageType.TEXT, MessageType.FILE, MessageType.IMAGE, MessageType.UNSUPPORTED});
    }

    public static List map$default(MessageLogEntryMapper messageLogEntryMapper, Conversation conversation, LocalDateTime localDateTime, TypingUser typingUser, LoadMoreStatus loadMoreStatus, String str, int i, Object obj) {
        if ((i & 4) != 0) {
            typingUser = TypingUser.None.INSTANCE;
        }
        TypingUser typingUser2 = typingUser;
        if ((i & 8) != 0) {
            loadMoreStatus = LoadMoreStatus.NONE;
        }
        return messageLogEntryMapper.map(conversation, localDateTime, typingUser2, loadMoreStatus, str);
    }

    public final List<MessageLogEntry> map(final Conversation conversation, LocalDateTime newMessageDividerDate, TypingUser typingUser, LoadMoreStatus loadMoreStatus, String authorizationToken) {
        Pair pair;
        String strInvoke;
        Intrinsics.checkNotNullParameter(conversation, "conversation");
        Intrinsics.checkNotNullParameter(typingUser, "typingUser");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        ArrayList arrayList = new ArrayList();
        List<Message> messages = conversation.getMessages();
        ArrayList arrayList2 = new ArrayList();
        Iterator<T> it = messages.iterator();
        while (it.hasNext()) {
            MessageContent content = ((Message) it.next()).getContent();
            MessageContent.FormResponse formResponse = content instanceof MessageContent.FormResponse ? (MessageContent.FormResponse) content : null;
            String quotedMessageId = formResponse != null ? formResponse.getQuotedMessageId() : null;
            if (quotedMessageId != null) {
                arrayList2.add(quotedMessageId);
            }
        }
        ArrayList arrayList3 = arrayList2;
        List<Message> messages2 = conversation.getMessages();
        ArrayList arrayList4 = new ArrayList();
        for (Object obj : messages2) {
            Message message = (Message) obj;
            if (message.getContent().getMessageContentType() != MessageType.FORM || !arrayList3.contains(message.getId())) {
                arrayList4.add(obj);
            }
        }
        ArrayList arrayList5 = arrayList4;
        ArrayList arrayList6 = new ArrayList(CollectionsKt.collectionSizeOrDefault(arrayList5, 10));
        Iterator it2 = arrayList5.iterator();
        while (it2.hasNext()) {
            arrayList6.add(MessageLogEntryMapperKt.overrideWithQuotedMessageDetails((Message) it2.next(), new Function1<String, Message>() {
                {
                    super(1);
                }

                @Override
                public final Message invoke(String quotedMessageId2) {
                    Object next;
                    Intrinsics.checkNotNullParameter(quotedMessageId2, "quotedMessageId");
                    Iterator<T> it3 = conversation.getMessages().iterator();
                    while (it3.hasNext()) {
                        next = it3.next();
                        if (Intrinsics.areEqual(((Message) next).getId(), quotedMessageId2)) {
                            return (Message) next;
                        }
                    }
                    next = null;
                    return (Message) next;
                }
            }));
        }
        List listSortedWith = CollectionsKt.sortedWith(arrayList6, new Comparator() {
            @Override
            public final int compare(T t, T t2) {
                return ComparisonsKt.compareValues(((Message) t).getTimestamp(), ((Message) t2).getTimestamp());
            }
        });
        if (!listSortedWith.isEmpty()) {
            if (loadMoreStatus != LoadMoreStatus.NONE) {
                arrayList.add(new MessageLogEntry.LoadMore(null, null, loadMoreStatus, 3, null));
            }
            LinkedHashSet linkedHashSet = new LinkedHashSet();
            if (newMessageDividerDate == null) {
                pair = new Pair(listSortedWith, CollectionsKt.emptyList());
            } else {
                ArrayList arrayList7 = new ArrayList();
                ArrayList arrayList8 = new ArrayList();
                for (Object obj2 : listSortedWith) {
                    if (((Message) obj2).getReceived().compareTo((ChronoLocalDateTime) newMessageDividerDate) < 0) {
                        arrayList7.add(obj2);
                    } else {
                        arrayList8.add(obj2);
                    }
                }
                pair = new Pair(arrayList7, arrayList8);
            }
            List list = (List) pair.component1();
            List<Message> list2 = (List) pair.component2();
            mapIntoMessageLogEntry$default(this, list, conversation.getMyself(), null, (Message) (list2.isEmpty() ? CollectionsKt.last(list) : CollectionsKt.last((List) list2)), linkedHashSet, arrayList, authorizationToken, 2, null);
            if (!list2.isEmpty()) {
                if (!((Message) CollectionsKt.first((List) list2)).isAuthoredBy(conversation.getMyself())) {
                    if (newMessageDividerDate == null || (strInvoke = newMessageDividerDate.toString()) == null) {
                        strInvoke = this.idProvider.invoke();
                    }
                    Intrinsics.checkNotNull(strInvoke);
                    arrayList.add(new MessageLogEntry.MessagesDivider(strInvoke, this.labelProvider.newMessages(), MessageLogType.NewMessagesDivider));
                }
                mapIntoMessageLogEntry(list2, conversation.getMyself(), (Message) CollectionsKt.lastOrNull(list), (Message) CollectionsKt.last((List) list2), linkedHashSet, arrayList, authorizationToken);
            }
            if (typingUser instanceof TypingUser.User) {
                arrayList.add(new MessageLogEntry.TypingIndicatorContainer(TYPING_INDICATOR_ID, ((TypingUser.User) typingUser).getAvatarUrl()));
            }
        }
        return arrayList;
    }

    static void mapIntoMessageLogEntry$default(MessageLogEntryMapper messageLogEntryMapper, List list, Participant participant, Message message, Message message2, Set set, List list2, String str, int i, Object obj) {
        messageLogEntryMapper.mapIntoMessageLogEntry(list, participant, (i & 2) != 0 ? null : message, message2, set, list2, str);
    }

    private final void mapIntoMessageLogEntry(List<Message> list, Participant participant, Message message, Message message2, Set<LocalDateTime> set, List<MessageLogEntry> list2, String str) {
        MessageDirection messageDirection;
        int i = 0;
        for (Object obj : list) {
            int i2 = i + 1;
            if (i < 0) {
                CollectionsKt.throwIndexOverflow();
            }
            Message message3 = (Message) obj;
            Message message4 = (Message) CollectionsKt.getOrNull(list, i - 1);
            MessageNeighbour messageNeighbourCompareWithPrevious = compareWithPrevious(message3, message4);
            MessageNeighbour messageNeighbourCompareWithNext = compareWithNext(message3, (Message) CollectionsKt.getOrNull(list, i2));
            if (message3.isAuthoredBy(participant)) {
                messageDirection = MessageDirection.OUTBOUND;
            } else {
                messageDirection = MessageDirection.INBOUND;
            }
            MessagePosition position = getPosition(messageNeighbourCompareWithPrevious, messageNeighbourCompareWithNext);
            MessageShape shape = getShape(message3, position, messageNeighbourCompareWithPrevious, messageNeighbourCompareWithNext);
            if (message4 == null) {
                message4 = message;
            }
            handleTimestampDivider(list2, message3, message4, set);
            list2.addAll(this.messageContainerFactory.createMessageContainer(message3, messageDirection, position, shape, Intrinsics.areEqual(message2, message3), PrivateAttachmentUtilKt.resolveAuthTokenForPrivateAttachment(str, MessageKt.isPrivateAttachment(message3.getContent()))));
            i = i2;
        }
    }

    private final MessageNeighbour compareWithPrevious(Message currentMessage, Message previousMessage) {
        String userId;
        boolean zAreEqual;
        Author author;
        MessageContent content;
        MessageType messageContentType = null;
        if (currentMessage.getStatus() instanceof MessageStatus.Pending) {
            String userId2 = currentMessage.getAuthor().getUserId();
            if (previousMessage != null || (author = previousMessage.getAuthor()) == null) {
                userId = null;
            } else {
                userId = author.getUserId();
            }
            zAreEqual = Intrinsics.areEqual(userId2, userId);
        } else {
            if ((previousMessage != null ? previousMessage.getStatus() : null) instanceof MessageStatus.Pending) {
                String userId3 = currentMessage.getAuthor().getUserId();
                if (previousMessage != null) {
                    userId = null;
                } else {
                    userId = null;
                }
                zAreEqual = Intrinsics.areEqual(userId3, userId);
            } else {
                zAreEqual = Intrinsics.areEqual(currentMessage.getAuthor(), previousMessage != null ? previousMessage.getAuthor() : null);
            }
        }
        boolean z = previousMessage != null && ((currentMessage.getStatus() instanceof MessageStatus.Pending) || (currentMessage.getStatus() instanceof MessageStatus.Sent)) && ((previousMessage.getStatus() instanceof MessageStatus.Pending) || (previousMessage.getStatus() instanceof MessageStatus.Sent));
        boolean z2 = previousMessage != null && DateKtxKt.toTimestamp$default(currentMessage.getReceived(), null, 1, null) - DateKtxKt.toTimestamp$default(previousMessage.getReceived(), null, 1, null) < TimeConstants.FIFTEEN_MINUTES_DIFFERENCE;
        List<MessageType> list = this.allowedGroupingTypes;
        if (previousMessage != null && (content = previousMessage.getContent()) != null) {
            messageContentType = content.getMessageContentType();
        }
        return new MessageNeighbour(zAreEqual, z, z2, CollectionsKt.contains(list, messageContentType));
    }

    private final MessageNeighbour compareWithNext(Message currentMessage, Message nextMessage) {
        String userId;
        boolean zAreEqual;
        Author author;
        MessageContent content;
        MessageType messageContentType = null;
        if (currentMessage.getStatus() instanceof MessageStatus.Pending) {
            String userId2 = currentMessage.getAuthor().getUserId();
            if (nextMessage != null || (author = nextMessage.getAuthor()) == null) {
                userId = null;
            } else {
                userId = author.getUserId();
            }
            zAreEqual = Intrinsics.areEqual(userId2, userId);
        } else {
            if ((nextMessage != null ? nextMessage.getStatus() : null) instanceof MessageStatus.Pending) {
                String userId3 = currentMessage.getAuthor().getUserId();
                if (nextMessage != null) {
                    userId = null;
                } else {
                    userId = null;
                }
                zAreEqual = Intrinsics.areEqual(userId3, userId);
            } else {
                zAreEqual = Intrinsics.areEqual(currentMessage.getAuthor(), nextMessage != null ? nextMessage.getAuthor() : null);
            }
        }
        boolean z = nextMessage != null && ((currentMessage.getStatus() instanceof MessageStatus.Pending) || (currentMessage.getStatus() instanceof MessageStatus.Sent)) && ((nextMessage.getStatus() instanceof MessageStatus.Pending) || (nextMessage.getStatus() instanceof MessageStatus.Sent));
        boolean z2 = nextMessage != null && DateKtxKt.toTimestamp$default(nextMessage.getReceived(), null, 1, null) - DateKtxKt.toTimestamp$default(currentMessage.getReceived(), null, 1, null) < TimeConstants.FIFTEEN_MINUTES_DIFFERENCE;
        List<MessageType> list = this.allowedGroupingTypes;
        if (nextMessage != null && (content = nextMessage.getContent()) != null) {
            messageContentType = content.getMessageContentType();
        }
        return new MessageNeighbour(zAreEqual, z, z2, CollectionsKt.contains(list, messageContentType));
    }

    private final void handleTimestampDivider(List<MessageLogEntry> list, Message message, Message message2, Set<LocalDateTime> set) {
        boolean z;
        MessageLogEntry.MessagesDivider messagesDivider;
        LocalDateTime received = message.getReceived();
        String str = MESSAGE_DIVIDER_ID_PREFIX + message.getId();
        LocalDateTime localDateTimeInvoke = this.currentTimeProvider.invoke();
        localDateTimeInvoke.getYear();
        boolean z2 = (localDateTimeInvoke.getYear() == received.getYear() && localDateTimeInvoke.getDayOfYear() == received.getDayOfYear()) ? false : true;
        Set<LocalDateTime> set2 = set;
        if (!(set2 instanceof Collection) || !set2.isEmpty()) {
            Iterator<T> it = set2.iterator();
            while (true) {
                if (!it.hasNext()) {
                    z = false;
                    break;
                }
                LocalDateTime localDateTime = (LocalDateTime) it.next();
                if (localDateTime.getYear() == received.getYear() && localDateTime.getDayOfYear() == received.getDayOfYear()) {
                    z = true;
                    break;
                }
            }
        } else {
            z = false;
            break;
        }
        boolean z3 = message2 == null || DateKtxKt.toTimestamp$default(message.getReceived(), null, 1, null) - DateKtxKt.toTimestamp$default(message2.getReceived(), null, 1, null) >= TimeConstants.FIFTEEN_MINUTES_DIFFERENCE;
        if (z2 && !z) {
            set.add(message.getReceived());
            messagesDivider = new MessageLogEntry.MessagesDivider(str, this.timestampFormatter.dayAndTime(message.getReceived()), MessageLogType.TimeStampDivider);
        } else if (z2 && z3) {
            messagesDivider = new MessageLogEntry.MessagesDivider(str, this.timestampFormatter.dayAndTime(message.getReceived()), MessageLogType.TimeStampDivider);
        } else if (!z3) {
            return;
        } else {
            messagesDivider = new MessageLogEntry.MessagesDivider(str, this.timestampFormatter.timeOnly(message.getReceived()), MessageLogType.TimeStampDivider);
        }
        list.add(messagesDivider);
    }

    private final MessagePosition getPosition(MessageNeighbour previousNeighbour, MessageNeighbour nextNeighbour) {
        if (!previousNeighbour.getAllowsPositionGrouping() && !nextNeighbour.getAllowsPositionGrouping()) {
            return MessagePosition.STANDALONE;
        }
        if (!previousNeighbour.getAllowsPositionGrouping() && nextNeighbour.getAllowsPositionGrouping()) {
            return MessagePosition.GROUP_TOP;
        }
        if (previousNeighbour.getAllowsPositionGrouping() && !nextNeighbour.getAllowsPositionGrouping()) {
            return MessagePosition.GROUP_BOTTOM;
        }
        return MessagePosition.GROUP_MIDDLE;
    }

    private final MessageShape getShape(Message currentMessage, MessagePosition currentMessagePosition, MessageNeighbour previousNeighbour, MessageNeighbour nextNeighbour) {
        boolean z = false;
        boolean z2 = currentMessagePosition == MessagePosition.STANDALONE || !this.allowedGroupingTypes.contains(currentMessage.getContent().getMessageContentType()) || (currentMessagePosition == MessagePosition.GROUP_TOP && !nextNeighbour.getAllowsShapeGrouping()) || (currentMessagePosition == MessagePosition.GROUP_BOTTOM && !previousNeighbour.getAllowsShapeGrouping());
        boolean z3 = (currentMessagePosition == MessagePosition.GROUP_TOP && nextNeighbour.getAllowsShapeGrouping()) || (currentMessagePosition == MessagePosition.GROUP_MIDDLE && !previousNeighbour.getAllowsShapeGrouping());
        if ((currentMessagePosition == MessagePosition.GROUP_BOTTOM && previousNeighbour.getAllowsShapeGrouping()) || (currentMessagePosition == MessagePosition.GROUP_MIDDLE && !nextNeighbour.getAllowsShapeGrouping())) {
            z = true;
        }
        if (z2) {
            return MessageShape.STANDALONE;
        }
        if (z3) {
            return MessageShape.GROUP_TOP;
        }
        if (z) {
            return MessageShape.GROUP_BOTTOM;
        }
        return MessageShape.GROUP_MIDDLE;
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0013\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0082\b\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0002\u0010\u0007J\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0012\u001a\u00020\u0003HÆ\u0003J1\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00032\b\u0010\u0015\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0016\u001a\u00020\u0017HÖ\u0001J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001R\u0011\u0010\b\u001a\u00020\u00038F¢\u0006\u0006\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\nR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\nR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\n¨\u0006\u001a"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageNeighbour;", "", "sameAuthor", "", "statusAllowGrouping", "dateAllowsGrouping", "allowsShapeGrouping", "(ZZZZ)V", "allowsPositionGrouping", "getAllowsPositionGrouping", "()Z", "getAllowsShapeGrouping", "getDateAllowsGrouping", "getSameAuthor", "getStatusAllowGrouping", "component1", "component2", "component3", "component4", "copy", "equals", "other", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class MessageNeighbour {
        private final boolean allowsShapeGrouping;
        private final boolean dateAllowsGrouping;
        private final boolean sameAuthor;
        private final boolean statusAllowGrouping;

        public static MessageNeighbour copy$default(MessageNeighbour messageNeighbour, boolean z, boolean z2, boolean z3, boolean z4, int i, Object obj) {
            if ((i & 1) != 0) {
                z = messageNeighbour.sameAuthor;
            }
            if ((i & 2) != 0) {
                z2 = messageNeighbour.statusAllowGrouping;
            }
            if ((i & 4) != 0) {
                z3 = messageNeighbour.dateAllowsGrouping;
            }
            if ((i & 8) != 0) {
                z4 = messageNeighbour.allowsShapeGrouping;
            }
            return messageNeighbour.copy(z, z2, z3, z4);
        }

        public final boolean getSameAuthor() {
            return this.sameAuthor;
        }

        public final boolean getStatusAllowGrouping() {
            return this.statusAllowGrouping;
        }

        public final boolean getDateAllowsGrouping() {
            return this.dateAllowsGrouping;
        }

        public final boolean getAllowsShapeGrouping() {
            return this.allowsShapeGrouping;
        }

        public final MessageNeighbour copy(boolean sameAuthor, boolean statusAllowGrouping, boolean dateAllowsGrouping, boolean allowsShapeGrouping) {
            return new MessageNeighbour(sameAuthor, statusAllowGrouping, dateAllowsGrouping, allowsShapeGrouping);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessageNeighbour)) {
                return false;
            }
            MessageNeighbour messageNeighbour = (MessageNeighbour) other;
            return this.sameAuthor == messageNeighbour.sameAuthor && this.statusAllowGrouping == messageNeighbour.statusAllowGrouping && this.dateAllowsGrouping == messageNeighbour.dateAllowsGrouping && this.allowsShapeGrouping == messageNeighbour.allowsShapeGrouping;
        }

        public int hashCode() {
            return (((((UByte$$ExternalSyntheticBackport0.m30m(this.sameAuthor) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.statusAllowGrouping)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.dateAllowsGrouping)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.allowsShapeGrouping);
        }

        public String toString() {
            return "MessageNeighbour(sameAuthor=" + this.sameAuthor + ", statusAllowGrouping=" + this.statusAllowGrouping + ", dateAllowsGrouping=" + this.dateAllowsGrouping + ", allowsShapeGrouping=" + this.allowsShapeGrouping + ')';
        }

        public MessageNeighbour(boolean z, boolean z2, boolean z3, boolean z4) {
            this.sameAuthor = z;
            this.statusAllowGrouping = z2;
            this.dateAllowsGrouping = z3;
            this.allowsShapeGrouping = z4;
        }

        public final boolean getSameAuthor() {
            return this.sameAuthor;
        }

        public final boolean getStatusAllowGrouping() {
            return this.statusAllowGrouping;
        }

        public final boolean getDateAllowsGrouping() {
            return this.dateAllowsGrouping;
        }

        public final boolean getAllowsShapeGrouping() {
            return this.allowsShapeGrouping;
        }

        public final boolean getAllowsPositionGrouping() {
            return this.sameAuthor && this.statusAllowGrouping && this.dateAllowsGrouping;
        }
    }

    public static Object m257xa685db5(MessageLogEntryMapper messageLogEntryMapper, Map map, List list, ConversationScreenPostbackStatus conversationScreenPostbackStatus, String str, Continuation continuation, int i, Object obj) {
        if ((i & 8) != 0) {
            str = null;
        }
        return messageLogEntryMapper.m258x110fd018(map, list, conversationScreenPostbackStatus, str, continuation);
    }

    public final Object m258x110fd018(Map<String, ConversationScreenPostbackStatus> map, List<? extends MessageLogEntry> list, ConversationScreenPostbackStatus conversationScreenPostbackStatus, String str, Continuation<? super MessageLogEntryUpdatedPostback> continuation) {
        return BuildersKt.withContext(this.defaultDispatcher, new MessageLogEntryMapper$mapMessageLogEntriesWithPostbackUpdates$2(map, str, conversationScreenPostbackStatus, list, this, null), continuation);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001B/\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\b¢\u0006\u0002\u0010\u000bJ\u000f\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0006HÆ\u0003J\u0015\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bHÆ\u0003J9\u0010\u0015\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bHÆ\u0001J\u0013\u0010\u0016\u001a\u00020\u00062\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J\t\u0010\u001a\u001a\u00020\tHÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u001d\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\b¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper$MessageLogEntryUpdatedPostback;", "", "messageLogEntryList", "", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "showBanner", "", "updatedPostbackStatuses", "", "", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenPostbackStatus;", "(Ljava/util/List;ZLjava/util/Map;)V", "getMessageLogEntryList", "()Ljava/util/List;", "getShowBanner", "()Z", "getUpdatedPostbackStatuses", "()Ljava/util/Map;", "component1", "component2", "component3", "copy", "equals", "other", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessageLogEntryUpdatedPostback {
        private final List<MessageLogEntry> messageLogEntryList;
        private final boolean showBanner;
        private final Map<String, ConversationScreenPostbackStatus> updatedPostbackStatuses;

        public static MessageLogEntryUpdatedPostback copy$default(MessageLogEntryUpdatedPostback messageLogEntryUpdatedPostback, List list, boolean z, Map map, int i, Object obj) {
            if ((i & 1) != 0) {
                list = messageLogEntryUpdatedPostback.messageLogEntryList;
            }
            if ((i & 2) != 0) {
                z = messageLogEntryUpdatedPostback.showBanner;
            }
            if ((i & 4) != 0) {
                map = messageLogEntryUpdatedPostback.updatedPostbackStatuses;
            }
            return messageLogEntryUpdatedPostback.copy(list, z, map);
        }

        public final List<MessageLogEntry> component1() {
            return this.messageLogEntryList;
        }

        public final boolean getShowBanner() {
            return this.showBanner;
        }

        public final Map<String, ConversationScreenPostbackStatus> component3() {
            return this.updatedPostbackStatuses;
        }

        public final MessageLogEntryUpdatedPostback copy(List<? extends MessageLogEntry> messageLogEntryList, boolean showBanner, Map<String, ConversationScreenPostbackStatus> updatedPostbackStatuses) {
            Intrinsics.checkNotNullParameter(messageLogEntryList, "messageLogEntryList");
            Intrinsics.checkNotNullParameter(updatedPostbackStatuses, "updatedPostbackStatuses");
            return new MessageLogEntryUpdatedPostback(messageLogEntryList, showBanner, updatedPostbackStatuses);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessageLogEntryUpdatedPostback)) {
                return false;
            }
            MessageLogEntryUpdatedPostback messageLogEntryUpdatedPostback = (MessageLogEntryUpdatedPostback) other;
            return Intrinsics.areEqual(this.messageLogEntryList, messageLogEntryUpdatedPostback.messageLogEntryList) && this.showBanner == messageLogEntryUpdatedPostback.showBanner && Intrinsics.areEqual(this.updatedPostbackStatuses, messageLogEntryUpdatedPostback.updatedPostbackStatuses);
        }

        public int hashCode() {
            return (((this.messageLogEntryList.hashCode() * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showBanner)) * 31) + this.updatedPostbackStatuses.hashCode();
        }

        public String toString() {
            return "MessageLogEntryUpdatedPostback(messageLogEntryList=" + this.messageLogEntryList + ", showBanner=" + this.showBanner + ", updatedPostbackStatuses=" + this.updatedPostbackStatuses + ')';
        }

        public MessageLogEntryUpdatedPostback(List<? extends MessageLogEntry> messageLogEntryList, boolean z, Map<String, ConversationScreenPostbackStatus> updatedPostbackStatuses) {
            Intrinsics.checkNotNullParameter(messageLogEntryList, "messageLogEntryList");
            Intrinsics.checkNotNullParameter(updatedPostbackStatuses, "updatedPostbackStatuses");
            this.messageLogEntryList = messageLogEntryList;
            this.showBanner = z;
            this.updatedPostbackStatuses = updatedPostbackStatuses;
        }

        public final List<MessageLogEntry> getMessageLogEntryList() {
            return this.messageLogEntryList;
        }

        public final boolean getShowBanner() {
            return this.showBanner;
        }

        public final Map<String, ConversationScreenPostbackStatus> getUpdatedPostbackStatuses() {
            return this.updatedPostbackStatuses;
        }
    }

    public final void processMessageActions(List<? extends MessageAction> messageActions, Map<String, ? extends ConversationScreenPostbackStatus> mapOfPostbackStatuses, List<MessageAction> newMessageActions) {
        for (MessageAction messageAction : messageActions) {
            if (messageAction instanceof MessageAction.Postback) {
                newMessageActions.add(MessageAction.Postback.copy$default((MessageAction.Postback) messageAction, null, null, null, null, mapOfPostbackStatuses.get(messageAction.getId()) != null && mapOfPostbackStatuses.get(messageAction.getId()) == ConversationScreenPostbackStatus.LOADING, 15, null));
            } else {
                newMessageActions.add(messageAction);
            }
        }
    }
}
