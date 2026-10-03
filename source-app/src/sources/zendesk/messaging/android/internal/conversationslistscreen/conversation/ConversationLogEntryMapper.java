package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import android.content.Context;
import j$.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.ResultKt;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.model.Author;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageType;
import zendesk.conversationkit.android.model.Participant;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.ConversationTitleProvider;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIO;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListUIPersistenceItem;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000\u0082\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\b\u0007\n\u0002\u0010\b\n\u0002\b\u0019\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u000b\b\u0000\u0018\u0000 ]2\u00020\u0001:\u0001]B1\b\u0007\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\t\u001a\u00020\b\u0012\u0006\u0010\u000b\u001a\u00020\n¢\u0006\u0004\b\f\u0010\rJ\u001b\u0010\u0010\u001a\u0004\u0018\u00010\u000e2\b\u0010\u000f\u001a\u0004\u0018\u00010\u000eH\u0002¢\u0006\u0004\b\u0010\u0010\u0011J6\u0010\u0019\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00140\u00182\u0006\u0010\u0013\u001a\u00020\u00122\u0006\u0010\u0015\u001a\u00020\u00142\b\u0010\u0017\u001a\u0004\u0018\u00010\u0016H\u0082@¢\u0006\u0004\b\u0019\u0010\u001aJ\u001d\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u00160\u001d2\u0006\u0010\u001c\u001a\u00020\u001bH\u0002¢\u0006\u0004\b\u001e\u0010\u001fJ/\u0010!\u001a\u0004\u0018\u00010\u00162\f\u0010 \u001a\b\u0012\u0004\u0012\u00020\u00160\u001d2\u0006\u0010\u0013\u001a\u00020\u00122\u0006\u0010\u001c\u001a\u00020\u001bH\u0002¢\u0006\u0004\b!\u0010\"J\u0019\u0010#\u001a\u0004\u0018\u00010\u00162\u0006\u0010\u001c\u001a\u00020\u001bH\u0002¢\u0006\u0004\b#\u0010$J\u0017\u0010&\u001a\u00020%2\u0006\u0010\u001c\u001a\u00020\u001bH\u0002¢\u0006\u0004\b&\u0010'J\u0019\u0010)\u001a\u00020\u00142\b\u0010(\u001a\u0004\u0018\u00010\u000eH\u0002¢\u0006\u0004\b)\u0010*J\u0019\u0010,\u001a\u00020\u00142\b\u0010+\u001a\u0004\u0018\u00010\u0016H\u0002¢\u0006\u0004\b,\u0010-J)\u0010/\u001a\u00020\u00142\b\u0010+\u001a\u0004\u0018\u00010\u00162\u0006\u0010\u0013\u001a\u00020\u00122\u0006\u0010.\u001a\u00020\u0014H\u0002¢\u0006\u0004\b/\u00100J)\u00103\u001a\u00020\u00142\b\u00101\u001a\u0004\u0018\u00010\u00162\u0006\u0010\u0013\u001a\u00020\u00122\u0006\u00102\u001a\u00020\u0014H\u0002¢\u0006\u0004\b3\u00100J1\u00107\u001a\u00020\u00142\u0006\u00104\u001a\u00020\u00142\u0006\u0010\u0013\u001a\u00020\u00122\b\u00105\u001a\u0004\u0018\u00010\u00142\u0006\u00106\u001a\u00020\u0012H\u0002¢\u0006\u0004\b7\u00108J\u001f\u0010:\u001a\u00020\u00142\u0006\u00109\u001a\u00020\u00142\u0006\u00104\u001a\u00020\u0014H\u0002¢\u0006\u0004\b:\u0010;J!\u0010>\u001a\u00020\u00142\b\u0010<\u001a\u0004\u0018\u00010\u00142\u0006\u0010=\u001a\u00020\u0014H\u0002¢\u0006\u0004\b>\u0010;J\u0013\u0010@\u001a\u00020\u0014*\u00020?H\u0002¢\u0006\u0004\b@\u0010AJ \u0010G\u001a\u00020D2\u0006\u0010\u001c\u001a\u00020\u001b2\u0006\u0010C\u001a\u00020BH\u0080@¢\u0006\u0004\bE\u0010FJJ\u0010O\u001a\u00020D2\u0006\u0010\u001c\u001a\u00020\u001b2\u0006\u0010H\u001a\u00020D2\u0006\u0010+\u001a\u00020\u00162\b\u0010J\u001a\u0004\u0018\u00010I2\u0006\u0010K\u001a\u00020\u00122\u0006\u0010L\u001a\u00020%2\u0006\u0010C\u001a\u00020BH\u0080@¢\u0006\u0004\bM\u0010NJ\u001f\u0010R\u001a\u00020D2\u0006\u0010H\u001a\u00020D2\u0006\u0010C\u001a\u00020BH\u0000¢\u0006\u0004\bP\u0010QJ\u001f\u0010W\u001a\u00020D2\u0006\u0010T\u001a\u00020S2\u0006\u0010C\u001a\u00020BH\u0000¢\u0006\u0004\bU\u0010VR\u0014\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010XR\u0014\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010YR\u0014\u0010\u0007\u001a\u00020\u00068\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0007\u0010ZR\u0014\u0010\t\u001a\u00020\b8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\t\u0010[R\u0014\u0010\u000b\u001a\u00020\n8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u000b\u0010\\¨\u0006^"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogEntryMapper;", "", "Landroid/content/Context;", "context", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogTimestampFormatter;", "logTimestampFormatter", "Lzendesk/android/messaging/model/MessagingSettings;", "messagingSettings", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO;", "conversationsListLocalStorageIO", "Lzendesk/messaging/android/internal/ConversationTitleProvider;", "conversationTitleProvider", "<init>", "(Landroid/content/Context;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogTimestampFormatter;Lzendesk/android/messaging/model/MessagingSettings;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO;Lzendesk/messaging/android/internal/ConversationTitleProvider;)V", "j$/time/LocalDateTime", "timeStamp", "getDefaultDateTimestamp", "(Lj$/time/LocalDateTime;)Lj$/time/LocalDateTime;", "", "isMyself", "", "conversationId", "Lzendesk/conversationkit/android/model/Message;", "messageToShowBusinessInfo", "Lkotlin/Pair;", "getBusinessParticipantNameAndAvatar", "(ZLjava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lzendesk/conversationkit/android/model/Conversation;", "conversation", "", "getListOfMessagesFromBusinessOrderedByLatest", "(Lzendesk/conversationkit/android/model/Conversation;)Ljava/util/List;", "messagesNotMySelfToShow", "getLatestMessageToCollectBusinessInfo", "(Ljava/util/List;ZLzendesk/conversationkit/android/model/Conversation;)Lzendesk/conversationkit/android/model/Message;", "getLatestMessage", "(Lzendesk/conversationkit/android/model/Conversation;)Lzendesk/conversationkit/android/model/Message;", "", "getUnreadMessages", "(Lzendesk/conversationkit/android/model/Conversation;)I", "timestamp", "getDateTimestamp", "(Lj$/time/LocalDateTime;)Ljava/lang/String;", "message", "getMessageContent", "(Lzendesk/conversationkit/android/model/Message;)Ljava/lang/String;", "participantName", "formatMessageOwner", "(Lzendesk/conversationkit/android/model/Message;ZLjava/lang/String;)Ljava/lang/String;", "latestMessageToShow", "conversationTitle", "formatLatestMessageToShow", "content", "author", "shouldShowAuthor", "formatMessageContentWithAuthor", "(Ljava/lang/String;ZLjava/lang/String;Z)Ljava/lang/String;", "authorName", "formatBusinessMessage", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", "iconUrl", "fallbackIconUrl", "resolveIcon", "Lzendesk/conversationkit/android/model/MessageAction;", "getText", "(Lzendesk/conversationkit/android/model/MessageAction;)Ljava/lang/String;", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "messagingTheme", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "mapToConversationEntry$zendesk_messaging_messaging_android", "(Lzendesk/conversationkit/android/model/Conversation;Lzendesk/messaging/android/internal/model/MessagingTheme;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "mapToConversationEntry", "conversationEntry", "Lzendesk/conversationkit/android/model/Participant;", "myself", "shouldIncreaseCount", "conversationUnreadCurrentNumber", "updateConversationEntryWithNewMessage$zendesk_messaging_messaging_android", "(Lzendesk/conversationkit/android/model/Conversation;Lzendesk/core/ui/android/internal/model/ConversationEntry;Lzendesk/conversationkit/android/model/Message;Lzendesk/conversationkit/android/model/Participant;ZILzendesk/messaging/android/internal/model/MessagingTheme;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateConversationEntryWithNewMessage", "updateConversationEntryWithLatestTimeStamp$zendesk_messaging_messaging_android", "(Lzendesk/core/ui/android/internal/model/ConversationEntry;Lzendesk/messaging/android/internal/model/MessagingTheme;)Lzendesk/core/ui/android/internal/model/ConversationEntry;", "updateConversationEntryWithLatestTimeStamp", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "loadMoreStatus", "mapToLoadMoreEntry$zendesk_messaging_messaging_android", "(Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;Lzendesk/messaging/android/internal/model/MessagingTheme;)Lzendesk/core/ui/android/internal/model/ConversationEntry;", "mapToLoadMoreEntry", "Landroid/content/Context;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogTimestampFormatter;", "Lzendesk/android/messaging/model/MessagingSettings;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO;", "Lzendesk/messaging/android/internal/ConversationTitleProvider;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationLogEntryMapper {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String EMPTY = "";
    private final Context context;
    private final ConversationTitleProvider conversationTitleProvider;
    private final ConversationsListLocalStorageIO conversationsListLocalStorageIO;
    private final ConversationLogTimestampFormatter logTimestampFormatter;
    private final MessagingSettings messagingSettings;

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
                iArr[MessageType.IMAGE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[MessageType.CAROUSEL.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[MessageType.FORM.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogEntryMapper", m37f = "ConversationLogEntryMapper.kt", m38i = {0, 1, 1, 1}, m39l = {144, 159}, m40m = "getBusinessParticipantNameAndAvatar", m41n = {"this", "this", "participantName", "avatarUrl"}, m42s = {"L$0", "L$0", "L$1", "L$2"})
    static final class C14871 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C14871(Continuation<? super C14871> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationLogEntryMapper.this.getBusinessParticipantNameAndAvatar(false, null, null, this);
        }
    }

    private final String resolveIcon(String iconUrl, String fallbackIconUrl) {
        return iconUrl == null ? fallbackIconUrl : iconUrl;
    }

    @Inject
    public ConversationLogEntryMapper(Context context, ConversationLogTimestampFormatter logTimestampFormatter, MessagingSettings messagingSettings, ConversationsListLocalStorageIO conversationsListLocalStorageIO, ConversationTitleProvider conversationTitleProvider) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(logTimestampFormatter, "logTimestampFormatter");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(conversationsListLocalStorageIO, "conversationsListLocalStorageIO");
        Intrinsics.checkNotNullParameter(conversationTitleProvider, "conversationTitleProvider");
        this.context = context;
        this.logTimestampFormatter = logTimestampFormatter;
        this.messagingSettings = messagingSettings;
        this.conversationsListLocalStorageIO = conversationsListLocalStorageIO;
        this.conversationTitleProvider = conversationTitleProvider;
    }

    public final Object mapToConversationEntry$zendesk_messaging_messaging_android(Conversation conversation, MessagingTheme messagingTheme, Continuation<? super ConversationEntry> continuation) throws Throwable {
        ConversationLogEntryMapper$mapToConversationEntry$1 conversationLogEntryMapper$mapToConversationEntry$1;
        String id;
        Participant participant;
        int i;
        int i2;
        Message message;
        ConversationLogEntryMapper conversationLogEntryMapper;
        Conversation conversation2 = conversation;
        if (continuation instanceof ConversationLogEntryMapper$mapToConversationEntry$1) {
            conversationLogEntryMapper$mapToConversationEntry$1 = (ConversationLogEntryMapper$mapToConversationEntry$1) continuation;
            if ((conversationLogEntryMapper$mapToConversationEntry$1.label & Integer.MIN_VALUE) != 0) {
                conversationLogEntryMapper$mapToConversationEntry$1.label -= Integer.MIN_VALUE;
            } else {
                conversationLogEntryMapper$mapToConversationEntry$1 = new ConversationLogEntryMapper$mapToConversationEntry$1(this, continuation);
            }
        } else {
            conversationLogEntryMapper$mapToConversationEntry$1 = new ConversationLogEntryMapper$mapToConversationEntry$1(this, continuation);
        }
        Object obj = conversationLogEntryMapper$mapToConversationEntry$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i3 = conversationLogEntryMapper$mapToConversationEntry$1.label;
        if (i3 == 0) {
            ResultKt.throwOnFailure(obj);
            id = conversation.getId();
            Participant myself = conversation.getMyself();
            List<Message> listOfMessagesFromBusinessOrderedByLatest = getListOfMessagesFromBusinessOrderedByLatest(conversation);
            boolean zIsEmpty = listOfMessagesFromBusinessOrderedByLatest.isEmpty();
            Message latestMessageToCollectBusinessInfo = getLatestMessageToCollectBusinessInfo(listOfMessagesFromBusinessOrderedByLatest, zIsEmpty, conversation2);
            int notifyColor = messagingTheme.getNotifyColor();
            int onBackgroundColor = messagingTheme.getOnBackgroundColor();
            Message latestMessage = getLatestMessage(conversation);
            conversationLogEntryMapper$mapToConversationEntry$1.L$0 = this;
            conversationLogEntryMapper$mapToConversationEntry$1.L$1 = conversation2;
            conversationLogEntryMapper$mapToConversationEntry$1.L$2 = id;
            conversationLogEntryMapper$mapToConversationEntry$1.L$3 = myself;
            conversationLogEntryMapper$mapToConversationEntry$1.L$4 = latestMessage;
            conversationLogEntryMapper$mapToConversationEntry$1.I$0 = notifyColor;
            conversationLogEntryMapper$mapToConversationEntry$1.I$1 = onBackgroundColor;
            conversationLogEntryMapper$mapToConversationEntry$1.label = 1;
            Object businessParticipantNameAndAvatar = getBusinessParticipantNameAndAvatar(zIsEmpty, id, latestMessageToCollectBusinessInfo, conversationLogEntryMapper$mapToConversationEntry$1);
            if (businessParticipantNameAndAvatar == coroutine_suspended) {
                return coroutine_suspended;
            }
            participant = myself;
            obj = businessParticipantNameAndAvatar;
            i = notifyColor;
            i2 = onBackgroundColor;
            message = latestMessage;
            conversationLogEntryMapper = this;
        } else {
            if (i3 != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            int i4 = conversationLogEntryMapper$mapToConversationEntry$1.I$1;
            int i5 = conversationLogEntryMapper$mapToConversationEntry$1.I$0;
            message = (Message) conversationLogEntryMapper$mapToConversationEntry$1.L$4;
            participant = (Participant) conversationLogEntryMapper$mapToConversationEntry$1.L$3;
            id = (String) conversationLogEntryMapper$mapToConversationEntry$1.L$2;
            Conversation conversation3 = (Conversation) conversationLogEntryMapper$mapToConversationEntry$1.L$1;
            conversationLogEntryMapper = (ConversationLogEntryMapper) conversationLogEntryMapper$mapToConversationEntry$1.L$0;
            ResultKt.throwOnFailure(obj);
            i2 = i4;
            i = i5;
            conversation2 = conversation3;
        }
        Pair pair = (Pair) obj;
        String str = (String) pair.getSecond();
        LocalDateTime received = message != null ? message.getReceived() : null;
        String displayName = conversation2.getDisplayName();
        LocalDateTime createdAt = conversation2.getCreatedAt();
        String strResolveTitle = conversationLogEntryMapper.conversationTitleProvider.resolveTitle(displayName, createdAt, str);
        String dateTimestamp = conversationLogEntryMapper.getDateTimestamp(received);
        boolean zIsAuthoredBy = message != null ? message.isAuthoredBy(participant) : false;
        String latestMessageToShow = conversationLogEntryMapper.formatLatestMessageToShow(message, zIsAuthoredBy, strResolveTitle);
        String str2 = zIsAuthoredBy ? null : str;
        int unreadMessages = conversationLogEntryMapper.getUnreadMessages(conversation2);
        return new ConversationEntry.ConversationItem(id, conversationLogEntryMapper.getDefaultDateTimestamp(received), dateTimestamp, str, strResolveTitle, conversationLogEntryMapper.resolveIcon(conversation2.getIconUrl(), (String) pair.getFirst()), latestMessageToShow, str2, unreadMessages, conversationLogEntryMapper.conversationTitleProvider.resolveAccessibilityListTitle(displayName, str, createdAt, conversationLogEntryMapper.getMessageContent(message), conversationLogEntryMapper.formatMessageOwner(message, zIsAuthoredBy, str), received, unreadMessages), i, i2, i2, i2, i2);
    }

    private final LocalDateTime getDefaultDateTimestamp(LocalDateTime timeStamp) {
        return timeStamp == null ? LocalDateTime.now() : timeStamp;
    }

    public final Object getBusinessParticipantNameAndAvatar(boolean z, String str, Message message, Continuation<? super Pair<String, String>> continuation) throws Throwable {
        C14871 c14871;
        String str2;
        String displayName;
        ConversationLogEntryMapper conversationLogEntryMapper;
        String str3;
        Author author;
        String avatarUrl;
        Author author2;
        ConversationLogEntryMapper conversationLogEntryMapper2;
        ConversationsListUIPersistenceItem conversationsListUIPersistenceItem;
        String participantName;
        String title;
        String avatarUrl2;
        String logoUrl;
        String title2;
        String logoUrl2;
        if (continuation instanceof C14871) {
            c14871 = (C14871) continuation;
            if ((c14871.label & Integer.MIN_VALUE) != 0) {
                c14871.label -= Integer.MIN_VALUE;
            } else {
                c14871 = new C14871(continuation);
            }
        } else {
            c14871 = new C14871(continuation);
        }
        Object conversationsListPersistence = c14871.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14871.label;
        if (i == 0) {
            ResultKt.throwOnFailure(conversationsListPersistence);
            if (z) {
                ConversationsListLocalStorageIO conversationsListLocalStorageIO = this.conversationsListLocalStorageIO;
                c14871.L$0 = this;
                c14871.label = 1;
                conversationsListPersistence = conversationsListLocalStorageIO.getConversationsListPersistence(str, c14871);
                if (conversationsListPersistence == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationLogEntryMapper2 = this;
                conversationsListUIPersistenceItem = (ConversationsListUIPersistenceItem) conversationsListPersistence;
                if (conversationsListUIPersistenceItem == null) {
                    title = conversationLogEntryMapper2.messagingSettings.getTitle();
                    logoUrl = conversationLogEntryMapper2.messagingSettings.getLogoUrl();
                } else {
                    participantName = conversationsListUIPersistenceItem.getParticipantName();
                    if (participantName.length() == 0) {
                        participantName = conversationLogEntryMapper2.messagingSettings.getTitle();
                    }
                    title = participantName;
                    avatarUrl2 = conversationsListUIPersistenceItem.getAvatarUrl();
                    if (avatarUrl2.length() == 0) {
                        avatarUrl2 = conversationLogEntryMapper2.messagingSettings.getLogoUrl();
                    }
                    logoUrl = avatarUrl2;
                }
            } else {
                str2 = "";
                if (message == null || (author2 = message.getAuthor()) == null || (displayName = author2.getDisplayName()) == null) {
                    displayName = "";
                }
                if (message != null && (author = message.getAuthor()) != null && (avatarUrl = author.getAvatarUrl()) != null) {
                    str2 = avatarUrl;
                }
                if (displayName.length() <= 0 && str2.length() <= 0) {
                    conversationLogEntryMapper = this;
                } else {
                    ConversationsListLocalStorageIO conversationsListLocalStorageIO2 = this.conversationsListLocalStorageIO;
                    ConversationsListUIPersistenceItem conversationsListUIPersistenceItem2 = new ConversationsListUIPersistenceItem(str, displayName, str2);
                    c14871.L$0 = this;
                    c14871.L$1 = displayName;
                    c14871.L$2 = str2;
                    c14871.label = 2;
                    if (conversationsListLocalStorageIO2.setConversationsListPersistence(conversationsListUIPersistenceItem2, c14871) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    conversationLogEntryMapper = this;
                    str3 = displayName;
                    displayName = str3;
                }
                title2 = displayName;
                if (title2.length() == 0) {
                    title2 = conversationLogEntryMapper.messagingSettings.getTitle();
                }
                title = title2;
                logoUrl2 = str2;
                if (logoUrl2.length() == 0) {
                    logoUrl2 = conversationLogEntryMapper.messagingSettings.getLogoUrl();
                }
                logoUrl = logoUrl2;
            }
        } else if (i == 1) {
            conversationLogEntryMapper2 = (ConversationLogEntryMapper) c14871.L$0;
            ResultKt.throwOnFailure(conversationsListPersistence);
            conversationsListUIPersistenceItem = (ConversationsListUIPersistenceItem) conversationsListPersistence;
            if (conversationsListUIPersistenceItem == null) {
                title = conversationLogEntryMapper2.messagingSettings.getTitle();
                logoUrl = conversationLogEntryMapper2.messagingSettings.getLogoUrl();
            } else {
                participantName = conversationsListUIPersistenceItem.getParticipantName();
                if (participantName.length() == 0) {
                    participantName = conversationLogEntryMapper2.messagingSettings.getTitle();
                }
                title = participantName;
                avatarUrl2 = conversationsListUIPersistenceItem.getAvatarUrl();
                if (avatarUrl2.length() == 0) {
                    avatarUrl2 = conversationLogEntryMapper2.messagingSettings.getLogoUrl();
                }
                logoUrl = avatarUrl2;
            }
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            str2 = (String) c14871.L$2;
            str3 = (String) c14871.L$1;
            conversationLogEntryMapper = (ConversationLogEntryMapper) c14871.L$0;
            ResultKt.throwOnFailure(conversationsListPersistence);
            displayName = str3;
            title2 = displayName;
            if (title2.length() == 0) {
                title2 = conversationLogEntryMapper.messagingSettings.getTitle();
            }
            title = title2;
            logoUrl2 = str2;
            if (logoUrl2.length() == 0) {
                logoUrl2 = conversationLogEntryMapper.messagingSettings.getLogoUrl();
            }
            logoUrl = logoUrl2;
        }
        return new Pair(logoUrl, title);
    }

    private final List<Message> getListOfMessagesFromBusinessOrderedByLatest(Conversation conversation) {
        List<Message> messages = conversation.getMessages();
        ArrayList arrayList = new ArrayList();
        for (Object obj : messages) {
            if (!((Message) obj).isAuthoredBy(conversation.getMyself())) {
                arrayList.add(obj);
            }
        }
        return CollectionsKt.sortedWith(arrayList, new Comparator() {
            @Override
            public final int compare(T t, T t2) {
                return ComparisonsKt.compareValues(((Message) t).getTimestamp(), ((Message) t2).getTimestamp());
            }
        });
    }

    private final Message getLatestMessageToCollectBusinessInfo(List<Message> messagesNotMySelfToShow, boolean isMyself, Conversation conversation) {
        if (isMyself) {
            return getLatestMessage(conversation);
        }
        return (Message) CollectionsKt.last((List) messagesNotMySelfToShow);
    }

    private final Message getLatestMessage(Conversation conversation) {
        Object obj;
        Iterator<T> it = conversation.getMessages().iterator();
        if (it.hasNext()) {
            Object next = it.next();
            if (it.hasNext()) {
                Comparable timestamp = ((Message) next).getTimestamp();
                do {
                    Object next2 = it.next();
                    Comparable comparable = (Comparable) ((Message) next2).getTimestamp();
                    if (timestamp.compareTo(comparable) < 0) {
                        next = next2;
                        timestamp = comparable;
                    }
                } while (it.hasNext());
            }
            obj = next;
        } else {
            obj = null;
        }
        return (Message) obj;
    }

    private final int getUnreadMessages(Conversation conversation) {
        Participant myself = conversation.getMyself();
        if (myself != null) {
            return myself.getUnreadCount();
        }
        return 0;
    }

    private final String getDateTimestamp(LocalDateTime timestamp) {
        if (timestamp != null) {
            ConversationLogTimestampFormatter conversationLogTimestampFormatter = this.logTimestampFormatter;
            LocalDateTime localDateTimeNow = LocalDateTime.now();
            Intrinsics.checkNotNullExpressionValue(localDateTimeNow, "now(...)");
            return conversationLogTimestampFormatter.m280xff406d0b(timestamp, localDateTimeNow);
        }
        return "";
    }

    private final String getMessageContent(Message message) {
        String strJoinToString$default;
        String string;
        if (message == null) {
            String string2 = this.context.getString(C1256R.string.zma_conversation_list_item_description_no_messages);
            Intrinsics.checkNotNull(string2);
            return string2;
        }
        int i = WhenMappings.$EnumSwitchMapping$0[message.getContent().getMessageContentType().ordinal()];
        if (i != 1) {
            if (i == 2) {
                string = this.context.getString(C1256R.string.zma_conversation_list_item_description_file);
            } else if (i == 3) {
                string = this.context.getString(C1256R.string.zma_conversation_list_item_description_image);
            } else if (i == 4) {
                string = this.context.getString(C1256R.string.zma_conversation_list_item_description_carousel);
            } else if (i == 5) {
                string = this.context.getString(C1256R.string.zma_conversation_list_item_description_form);
            } else {
                string = this.context.getString(C1256R.string.zma_conversation_list_item_description_no_messages);
            }
            Intrinsics.checkNotNull(string);
            return string;
        }
        MessageContent content = message.getContent();
        Intrinsics.checkNotNull(content, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Text");
        String text = ((MessageContent.Text) content).getText();
        if (text.length() == 0) {
            MessageContent content2 = message.getContent();
            Intrinsics.checkNotNull(content2, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Text");
            List<MessageAction> actions = ((MessageContent.Text) content2).getActions();
            if (actions == null || (strJoinToString$default = CollectionsKt.joinToString$default(actions, null, null, null, 0, null, new Function1<MessageAction, CharSequence>() {
                {
                    super(1);
                }

                @Override
                public final CharSequence invoke(MessageAction it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    return this.this$0.getText(it);
                }
            }, 31, null)) == null) {
                strJoinToString$default = "";
            }
            text = strJoinToString$default;
        }
        return text;
    }

    private final String formatMessageOwner(Message message, boolean isMyself, String participantName) {
        Author author;
        String displayName;
        if (isMyself) {
            String string = this.context.getString(R.string.zuia_conversation_list_item_message_author_name_as_end_user_accessibility_label);
            Intrinsics.checkNotNull(string);
            return string;
        }
        if (message != null && (author = message.getAuthor()) != null && (displayName = author.getDisplayName()) != null) {
            return displayName;
        }
        String title = participantName;
        if (title.length() == 0) {
            title = this.messagingSettings.getTitle();
        }
        return title;
    }

    private final String formatLatestMessageToShow(Message latestMessageToShow, boolean isMyself, String conversationTitle) {
        Author author;
        String displayName = (latestMessageToShow == null || (author = latestMessageToShow.getAuthor()) == null) ? null : author.getDisplayName();
        boolean z = !Intrinsics.areEqual(conversationTitle, displayName);
        String messageContent = getMessageContent(latestMessageToShow);
        if (latestMessageToShow == null) {
            isMyself = false;
        }
        return formatMessageContentWithAuthor(messageContent, isMyself, displayName, z);
    }

    public final Object m279xc143eec5(Conversation conversation, ConversationEntry conversationEntry, Message message, Participant participant, boolean z, int i, MessagingTheme messagingTheme, Continuation<? super ConversationEntry> continuation) throws Throwable {
        C1489x2507a54e c1489x2507a54e;
        LocalDateTime received;
        Conversation conversation2;
        ConversationEntry conversationEntry2;
        int i2;
        Message message2;
        int i3;
        int i4;
        boolean z2;
        boolean z3;
        ConversationLogEntryMapper conversationLogEntryMapper;
        if (continuation instanceof C1489x2507a54e) {
            c1489x2507a54e = (C1489x2507a54e) continuation;
            if ((c1489x2507a54e.label & Integer.MIN_VALUE) != 0) {
                c1489x2507a54e.label -= Integer.MIN_VALUE;
            } else {
                c1489x2507a54e = new C1489x2507a54e(this, continuation);
            }
        } else {
            c1489x2507a54e = new C1489x2507a54e(this, continuation);
        }
        Object obj = c1489x2507a54e.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i5 = c1489x2507a54e.label;
        if (i5 == 0) {
            ResultKt.throwOnFailure(obj);
            int notifyColor = messagingTheme.getNotifyColor();
            int onBackgroundColor = messagingTheme.getOnBackgroundColor();
            boolean zIsAuthoredBy = message.isAuthoredBy(participant);
            received = message.getReceived();
            String id = conversationEntry.getId();
            c1489x2507a54e.L$0 = this;
            conversation2 = conversation;
            c1489x2507a54e.L$1 = conversation2;
            conversationEntry2 = conversationEntry;
            c1489x2507a54e.L$2 = conversationEntry2;
            c1489x2507a54e.L$3 = message;
            c1489x2507a54e.L$4 = received;
            c1489x2507a54e.Z$0 = z;
            i2 = i;
            c1489x2507a54e.I$0 = i2;
            c1489x2507a54e.I$1 = notifyColor;
            c1489x2507a54e.I$2 = onBackgroundColor;
            c1489x2507a54e.Z$1 = zIsAuthoredBy;
            c1489x2507a54e.label = 1;
            Object businessParticipantNameAndAvatar = getBusinessParticipantNameAndAvatar(zIsAuthoredBy, id, message, c1489x2507a54e);
            if (businessParticipantNameAndAvatar == coroutine_suspended) {
                return coroutine_suspended;
            }
            message2 = message;
            i3 = onBackgroundColor;
            obj = businessParticipantNameAndAvatar;
            i4 = notifyColor;
            z2 = zIsAuthoredBy;
            z3 = z;
            conversationLogEntryMapper = this;
        } else {
            if (i5 != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            z2 = c1489x2507a54e.Z$1;
            int i6 = c1489x2507a54e.I$2;
            int i7 = c1489x2507a54e.I$1;
            int i8 = c1489x2507a54e.I$0;
            z3 = c1489x2507a54e.Z$0;
            received = (LocalDateTime) c1489x2507a54e.L$4;
            message2 = (Message) c1489x2507a54e.L$3;
            ConversationEntry conversationEntry3 = (ConversationEntry) c1489x2507a54e.L$2;
            Conversation conversation3 = (Conversation) c1489x2507a54e.L$1;
            conversationLogEntryMapper = (ConversationLogEntryMapper) c1489x2507a54e.L$0;
            ResultKt.throwOnFailure(obj);
            i3 = i6;
            i4 = i7;
            i2 = i8;
            conversationEntry2 = conversationEntry3;
            conversation2 = conversation3;
        }
        Pair pair = (Pair) obj;
        String str = (String) pair.getSecond();
        Intrinsics.checkNotNull(conversationEntry2, "null cannot be cast to non-null type zendesk.core.ui.android.internal.model.ConversationEntry.ConversationItem");
        ConversationEntry.ConversationItem conversationItem = (ConversationEntry.ConversationItem) conversationEntry2;
        String strResolveTitle = conversationLogEntryMapper.conversationTitleProvider.resolveTitle(conversation2.getDisplayName(), conversation2.getCreatedAt(), str);
        String latestMessageToShow = conversationLogEntryMapper.formatLatestMessageToShow(message2, z2, strResolveTitle);
        String str2 = z2 ? null : str;
        if (z3) {
            i2++;
        }
        int i9 = i2;
        return conversationItem.copy((1017 & 1) != 0 ? conversationItem.id : null, (1017 & 2) != 0 ? conversationItem.dateTimeStamp : conversationLogEntryMapper.getDefaultDateTimestamp(received), (1017 & 4) != 0 ? conversationItem.formattedDateTimeStampString : conversationLogEntryMapper.getDateTimestamp(received), (1017 & 8) != 0 ? conversationItem.participantName : str, (1017 & 16) != 0 ? conversationItem.conversationTitle : strResolveTitle, (1017 & 32) != 0 ? conversationItem.avatarUrl : conversationLogEntryMapper.resolveIcon(conversation2.getIconUrl(), (String) pair.getFirst()), (1017 & 64) != 0 ? conversationItem.latestMessage : latestMessageToShow, (1017 & 128) != 0 ? conversationItem.latestMessageOwner : str2, (1017 & 256) != 0 ? conversationItem.unreadMessages : i9, (1017 & 512) != 0 ? conversationItem.accessibilityTitle : conversationLogEntryMapper.conversationTitleProvider.resolveAccessibilityListTitle(conversation2.getDisplayName(), str, conversation2.getCreatedAt(), conversationLogEntryMapper.getMessageContent(message2), conversationLogEntryMapper.formatMessageOwner(message2, z2, str), received, i9), (1017 & 1024) != 0 ? conversationItem.unreadMessagesColor : i4, (1017 & 2048) != 0 ? conversationItem.dateTimestampTextColor : i3, (1017 & 4096) != 0 ? conversationItem.lastMessageTextColor : i3, (1017 & 8192) != 0 ? conversationItem.conversationParticipantsTextColor : i3, (1017 & 16384) != 0 ? conversationItem.conversationTitleTextColor : i3);
    }

    public final ConversationEntry m278x1003e355(ConversationEntry conversationEntry, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(conversationEntry, "conversationEntry");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        int notifyColor = messagingTheme.getNotifyColor();
        int onBackgroundColor = messagingTheme.getOnBackgroundColor();
        LocalDateTime dateTimeStamp = conversationEntry.getDateTimeStamp();
        ConversationEntry.ConversationItem conversationItem = (ConversationEntry.ConversationItem) conversationEntry;
        return conversationItem.copy((1017 & 1) != 0 ? conversationItem.id : null, (1017 & 2) != 0 ? conversationItem.dateTimeStamp : getDefaultDateTimestamp(dateTimeStamp), (1017 & 4) != 0 ? conversationItem.formattedDateTimeStampString : getDateTimestamp(dateTimeStamp), (1017 & 8) != 0 ? conversationItem.participantName : null, (1017 & 16) != 0 ? conversationItem.conversationTitle : null, (1017 & 32) != 0 ? conversationItem.avatarUrl : null, (1017 & 64) != 0 ? conversationItem.latestMessage : null, (1017 & 128) != 0 ? conversationItem.latestMessageOwner : null, (1017 & 256) != 0 ? conversationItem.unreadMessages : 0, (1017 & 512) != 0 ? conversationItem.accessibilityTitle : null, (1017 & 1024) != 0 ? conversationItem.unreadMessagesColor : notifyColor, (1017 & 2048) != 0 ? conversationItem.dateTimestampTextColor : onBackgroundColor, (1017 & 4096) != 0 ? conversationItem.lastMessageTextColor : onBackgroundColor, (1017 & 8192) != 0 ? conversationItem.conversationParticipantsTextColor : onBackgroundColor, (1017 & 16384) != 0 ? conversationItem.conversationTitleTextColor : onBackgroundColor);
    }

    private final String formatMessageContentWithAuthor(String content, boolean isMyself, String author, boolean shouldShowAuthor) {
        if (!isMyself) {
            return (!shouldShowAuthor || author == null) ? content : formatBusinessMessage(author, content);
        }
        String string = this.context.getString(C1256R.string.zma_conversation_list_item_description_sender_you, content);
        Intrinsics.checkNotNull(string);
        return string;
    }

    private final String formatBusinessMessage(String authorName, String content) {
        if (authorName.length() <= 0) {
            return content;
        }
        return authorName + ": " + content;
    }

    public final ConversationEntry mapToLoadMoreEntry$zendesk_messaging_messaging_android(ConversationEntry.LoadMoreStatus loadMoreStatus, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        String load_more_id = ConversationEntry.INSTANCE.getLOAD_MORE_ID();
        String string = this.context.getString(C1256R.string.zuia_conversations_list_tap_to_retry_message_label);
        int onBackgroundColor = messagingTheme.getOnBackgroundColor();
        int primaryColor = messagingTheme.getPrimaryColor();
        Intrinsics.checkNotNull(string);
        return new ConversationEntry.LoadMore(load_more_id, onBackgroundColor, primaryColor, loadMoreStatus, string);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogEntryMapper$Companion;", "", "()V", "EMPTY", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }

    public final String getText(MessageAction messageAction) {
        if (messageAction instanceof MessageAction.Reply) {
            return ((MessageAction.Reply) messageAction).getText();
        }
        if (messageAction instanceof MessageAction.Buy) {
            return ((MessageAction.Buy) messageAction).getText();
        }
        if (messageAction instanceof MessageAction.Link) {
            return ((MessageAction.Link) messageAction).getText();
        }
        if (messageAction instanceof MessageAction.Postback) {
            return ((MessageAction.Postback) messageAction).getText();
        }
        if (messageAction instanceof MessageAction.LocationRequest) {
            return ((MessageAction.LocationRequest) messageAction).getText();
        }
        return messageAction instanceof MessageAction.WebView ? ((MessageAction.WebView) messageAction).getText() : "";
    }
}
