package zendesk.messaging.android.internal.conversationscreen;

import j$.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.conversationkit.android.model.MessageType;
import zendesk.core.android.internal.DateKtxKt;
import zendesk.core.p017ui.android.internal.model.MessageDirection;
import zendesk.core.p017ui.android.internal.model.MessagePosition;
import zendesk.core.p017ui.android.internal.model.MessageShape;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessageReceipt;
import zendesk.messaging.android.internal.model.MessageSize;
import zendesk.messaging.android.internal.model.MessageStatusIcon;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\b\u0000\u0018\u0000 )2\u00020\u0001:\u0001)B)\b\u0007\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u000e\b\u0003\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\u0004\b\t\u0010\nJ=\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u0013H\u0002¢\u0006\u0004\b\u0017\u0010\u0018J=\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u0013H\u0002¢\u0006\u0004\b\u0019\u0010\u0018J=\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u0013H\u0002¢\u0006\u0004\b\u001a\u0010\u0018J=\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u0013H\u0002¢\u0006\u0004\b\u001b\u0010\u0018JG\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u00132\b\u0010\u001d\u001a\u0004\u0018\u00010\u001cH\u0002¢\u0006\u0004\b\u001e\u0010\u001fJ=\u0010 \u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u0013H\u0002¢\u0006\u0004\b \u0010\u0018J=\u0010!\u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u0013H\u0002¢\u0006\u0004\b!\u0010\u0018J\u001f\u0010#\u001a\u00020\"2\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\rH\u0002¢\u0006\u0004\b#\u0010$JE\u0010%\u001a\b\u0012\u0004\u0012\u00020\u00160\u00152\u0006\u0010\f\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u00132\b\u0010\u001d\u001a\u0004\u0018\u00010\u001c¢\u0006\u0004\b%\u0010\u001fR\u0014\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010&R\u0014\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010'R\u001a\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00070\u00068\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\b\u0010(¨\u0006*"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageContainerFactory;", "", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;", "labelProvider", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;", "timestampFormatter", "Lkotlin/Function0;", "j$/time/LocalDateTime", MessagingComponentKt.CURRENT_TIME_PROVIDER, "<init>", "(Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;Lkotlin/jvm/functions/Function0;)V", "Lzendesk/conversationkit/android/model/Message;", "message", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "direction", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "position", "Lzendesk/core/ui/android/internal/model/MessageShape;", "shape", "", "isLatestMessage", "", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "createSingleMessageContainer", "(Lzendesk/conversationkit/android/model/Message;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;Z)Ljava/util/List;", "createUnsupportedMessageContainer", "createCarouselMessageContainer", "createTextMessageContainer", "", "authorizationToken", "createImageMessageContainer", "(Lzendesk/conversationkit/android/model/Message;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;ZLjava/lang/String;)Ljava/util/List;", "createFileMessageContainer", "createFormMessageContainer", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "getReceipt", "(Lzendesk/conversationkit/android/model/Message;Lzendesk/core/ui/android/internal/model/MessageDirection;)Lzendesk/messaging/android/internal/model/MessageReceipt;", "createMessageContainer", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogLabelProvider;", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogTimestampFormatter;", "Lkotlin/jvm/functions/Function0;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageContainerFactory {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final int MAXIMUM_FILE_SIZE_IN_MB = 50;
    private final Function0<LocalDateTime> currentTimeProvider;
    private final MessageLogLabelProvider labelProvider;
    private final MessageLogTimestampFormatter timestampFormatter;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[MessageType.values().length];
            try {
                iArr[MessageType.LIST.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[MessageType.LOCATION.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[MessageType.CAROUSEL.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[MessageType.UNSUPPORTED.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[MessageType.TEXT.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[MessageType.FILE.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[MessageType.FILE_UPLOAD.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                iArr[MessageType.FORM.ordinal()] = 8;
            } catch (NoSuchFieldError unused8) {
            }
            try {
                iArr[MessageType.FORM_RESPONSE.ordinal()] = 9;
            } catch (NoSuchFieldError unused9) {
            }
            try {
                iArr[MessageType.IMAGE.ordinal()] = 10;
            } catch (NoSuchFieldError unused10) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Inject
    public MessageContainerFactory(MessageLogLabelProvider labelProvider, MessageLogTimestampFormatter timestampFormatter, @Named(MessagingComponentKt.CURRENT_TIME_PROVIDER) Function0<LocalDateTime> currentTimeProvider) {
        Intrinsics.checkNotNullParameter(labelProvider, "labelProvider");
        Intrinsics.checkNotNullParameter(timestampFormatter, "timestampFormatter");
        Intrinsics.checkNotNullParameter(currentTimeProvider, "currentTimeProvider");
        this.labelProvider = labelProvider;
        this.timestampFormatter = timestampFormatter;
        this.currentTimeProvider = currentTimeProvider;
    }

    public MessageContainerFactory(MessageLogLabelProvider messageLogLabelProvider, MessageLogTimestampFormatter messageLogTimestampFormatter, C13711 c13711, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(messageLogLabelProvider, messageLogTimestampFormatter, (i & 4) != 0 ? new Function0<LocalDateTime>() {
            @Override
            public final LocalDateTime invoke() {
                LocalDateTime localDateTimeNow = LocalDateTime.now();
                Intrinsics.checkNotNullExpressionValue(localDateTimeNow, "now(...)");
                return localDateTimeNow;
            }
        } : c13711);
    }

    public final List<MessageLogEntry> createMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage, String authorizationToken) {
        Intrinsics.checkNotNullParameter(message, "message");
        Intrinsics.checkNotNullParameter(direction, "direction");
        Intrinsics.checkNotNullParameter(position, "position");
        Intrinsics.checkNotNullParameter(shape, "shape");
        switch (WhenMappings.$EnumSwitchMapping$0[message.getContent().getMessageContentType().ordinal()]) {
            case 1:
            case 2:
                return createSingleMessageContainer(message, direction, position, shape, isLatestMessage);
            case 3:
                return createCarouselMessageContainer(message, direction, position, shape, isLatestMessage);
            case 4:
                return createUnsupportedMessageContainer(message, direction, position, shape, isLatestMessage);
            case 5:
                return createTextMessageContainer(message, direction, position, shape, isLatestMessage);
            case 6:
            case 7:
                return createFileMessageContainer(message, direction, position, shape, isLatestMessage);
            case 8:
            case 9:
                return createFormMessageContainer(message, direction, position, shape, isLatestMessage);
            case 10:
                return createImageMessageContainer(message, direction, position, shape, isLatestMessage, authorizationToken);
            default:
                throw new NoWhenBranchMatchedException();
        }
    }

    private final List<MessageLogEntry> createSingleMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage) {
        String id;
        MessageContent content = message.getContent();
        MessageContent.FormResponse formResponse = content instanceof MessageContent.FormResponse ? (MessageContent.FormResponse) content : null;
        if (formResponse == null || (id = formResponse.getQuotedMessageId()) == null) {
            id = message.getId();
        }
        return CollectionsKt.listOf(new MessageLogEntry.MessageContainer(id, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_TOP) && direction == MessageDirection.INBOUND) ? message.getAuthor().getDisplayName() : null, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_BOTTOM) && direction == MessageDirection.INBOUND) ? message.getAuthor().getAvatarUrl() : null, direction, position, shape, MessageSize.NORMAL, message.getStatus(), message, (isLatestMessage || (message.getStatus() instanceof MessageStatus.Failed)) ? getReceipt(message, direction) : null));
    }

    private final List<MessageLogEntry> createUnsupportedMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage) {
        return CollectionsKt.listOf(new MessageLogEntry.TextMessageContainer(message.getId(), ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_TOP) && direction == MessageDirection.INBOUND) ? message.getAuthor().getDisplayName() : null, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_BOTTOM) && direction == MessageDirection.INBOUND) ? message.getAuthor().getAvatarUrl() : null, direction, position, shape, MessageSize.NORMAL, message.getStatus(), message, (isLatestMessage || (message.getStatus() instanceof MessageStatus.Failed)) ? getReceipt(message, direction) : null));
    }

    private final List<MessageLogEntry> createCarouselMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage) {
        return CollectionsKt.listOf(new MessageLogEntry.CarouselContainer(message.getId(), ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_TOP) && direction == MessageDirection.INBOUND) ? message.getAuthor().getDisplayName() : null, message.getAuthor().getAvatarUrl(), direction, position, shape, MessageSize.FULL_WIDTH, message.getStatus(), message, (isLatestMessage || (message.getStatus() instanceof MessageStatus.Failed)) ? getReceipt(message, direction) : null));
    }

    private final List<MessageLogEntry> createTextMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage) {
        List<MessageAction> actions;
        ArrayList arrayList = new ArrayList();
        ArrayList arrayList2 = null;
        arrayList.add(new MessageLogEntry.TextMessageContainer(message.getId(), ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_TOP) && direction == MessageDirection.INBOUND) ? message.getAuthor().getDisplayName() : null, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_BOTTOM) && direction == MessageDirection.INBOUND) ? message.getAuthor().getAvatarUrl() : null, direction, position, shape, null, message.getStatus(), message, (isLatestMessage || (message.getStatus() instanceof MessageStatus.Failed)) ? getReceipt(message, direction) : null, 64, null));
        if (isLatestMessage) {
            MessageContent content = message.getContent();
            MessageContent.Text text = content instanceof MessageContent.Text ? (MessageContent.Text) content : null;
            if (text != null && (actions = text.getActions()) != null) {
                ArrayList arrayList3 = new ArrayList();
                for (Object obj : actions) {
                    if (obj instanceof MessageAction.Reply) {
                        arrayList3.add(obj);
                    }
                }
                arrayList2 = arrayList3;
            }
            ArrayList arrayList4 = arrayList2;
            if (arrayList4 != null && !arrayList4.isEmpty()) {
                arrayList.add(new MessageLogEntry.QuickReply(message.getId(), arrayList2));
            }
        }
        return arrayList;
    }

    private final List<MessageLogEntry> createImageMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage, String authorizationToken) {
        return CollectionsKt.listOf(new MessageLogEntry.ImageMessageContainer(message.getId(), ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_TOP) && direction == MessageDirection.INBOUND) ? message.getAuthor().getDisplayName() : null, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_BOTTOM) && direction == MessageDirection.INBOUND) ? message.getAuthor().getAvatarUrl() : null, direction, position, shape, message.getStatus(), message, (isLatestMessage || (message.getStatus() instanceof MessageStatus.Failed)) ? getReceipt(message, direction) : null, authorizationToken));
    }

    private final List<MessageLogEntry> createFileMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage) {
        String id;
        MessageContent content = message.getContent();
        MessageContent.FormResponse formResponse = content instanceof MessageContent.FormResponse ? (MessageContent.FormResponse) content : null;
        if (formResponse == null || (id = formResponse.getQuotedMessageId()) == null) {
            id = message.getId();
        }
        return CollectionsKt.listOf(new MessageLogEntry.FileMessageContainer(id, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_TOP) && direction == MessageDirection.INBOUND) ? message.getAuthor().getDisplayName() : null, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_BOTTOM) && direction == MessageDirection.INBOUND) ? message.getAuthor().getAvatarUrl() : null, direction, position, shape, null, message.getStatus(), message, (isLatestMessage || (message.getStatus() instanceof MessageStatus.Failed) || (message.getStatus() instanceof MessageStatus.DownloadFailed) || (message.getStatus() instanceof MessageStatus.Downloading)) ? getReceipt(message, direction) : null, 64, null));
    }

    private final List<MessageLogEntry> createFormMessageContainer(Message message, MessageDirection direction, MessagePosition position, MessageShape shape, boolean isLatestMessage) {
        String id;
        MessageContent content = message.getContent();
        MessageContent.FormResponse formResponse = content instanceof MessageContent.FormResponse ? (MessageContent.FormResponse) content : null;
        if (formResponse == null || (id = formResponse.getQuotedMessageId()) == null) {
            id = message.getId();
        }
        return CollectionsKt.listOf(new MessageLogEntry.FormMessageContainer(id, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_TOP) && direction == MessageDirection.INBOUND) ? message.getAuthor().getDisplayName() : null, ((position == MessagePosition.STANDALONE || position == MessagePosition.GROUP_BOTTOM) && direction == MessageDirection.INBOUND) ? message.getAuthor().getAvatarUrl() : null, direction, position, shape, null, message.getStatus(), message, (isLatestMessage || (message.getStatus() instanceof MessageStatus.Failed)) ? getReceipt(message, direction) : null, 64, null));
    }

    private final MessageReceipt getReceipt(Message message, MessageDirection direction) {
        String strTimeOnly;
        MessageStatusIcon messageStatusIcon;
        LocalDateTime received = message.getReceived();
        MessageStatus status = message.getStatus();
        boolean z = DateKtxKt.toTimestamp$default(this.currentTimeProvider.invoke(), null, 1, null) - DateKtxKt.toTimestamp$default(received, null, 1, null) <= TimeConstants.ONE_MINUTE_DIFFERENCE;
        if (direction == MessageDirection.OUTBOUND) {
            if (status instanceof MessageStatus.Pending) {
                strTimeOnly = this.labelProvider.sending();
            } else if (status instanceof MessageStatus.Failed) {
                if (((MessageStatus.Failed) status).getFailure() == MessageStatus.Failure.CONTENT_TOO_LARGE) {
                    strTimeOnly = this.labelProvider.exceedsMaxFileSize(50);
                } else {
                    strTimeOnly = this.labelProvider.tapToRetry();
                }
            } else if (status instanceof MessageStatus.Downloading) {
                strTimeOnly = this.labelProvider.downloading();
            } else if (status instanceof MessageStatus.DownloadFailed) {
                strTimeOnly = this.labelProvider.downloadFailed();
            } else if (z) {
                strTimeOnly = this.labelProvider.sentJustNow();
            } else {
                strTimeOnly = this.labelProvider.sentAt(this.timestampFormatter.timeOnly(received));
            }
        } else if ((status instanceof MessageStatus.Failed) && (message.getContent().getMessageContentType() == MessageType.FORM || message.getContent().getMessageContentType() == MessageType.FORM_RESPONSE)) {
            strTimeOnly = this.labelProvider.formSubmissionFailed();
        } else if (status instanceof MessageStatus.Downloading) {
            strTimeOnly = this.labelProvider.downloading();
        } else if (status instanceof MessageStatus.DownloadFailed) {
            strTimeOnly = this.labelProvider.downloadFailed();
        } else if (z) {
            strTimeOnly = this.labelProvider.justNow();
        } else {
            strTimeOnly = this.timestampFormatter.timeOnly(received);
        }
        String str = strTimeOnly;
        if (status instanceof MessageStatus.Downloading) {
            messageStatusIcon = MessageStatusIcon.NO_ICON;
        } else if (status instanceof MessageStatus.Pending) {
            messageStatusIcon = MessageStatusIcon.TAIL_SENDING;
        } else if (status instanceof MessageStatus.Sent) {
            messageStatusIcon = MessageStatusIcon.TAIL_SENT;
        } else {
            if (status instanceof MessageStatus.Failed ? true : status instanceof MessageStatus.DownloadFailed) {
                messageStatusIcon = MessageStatusIcon.FAILED;
            } else {
                throw new NoWhenBranchMatchedException();
            }
        }
        return new MessageReceipt(str, messageStatusIcon, false, 4, null);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/MessageContainerFactory$Companion;", "", "()V", "MAXIMUM_FILE_SIZE_IN_MB", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
