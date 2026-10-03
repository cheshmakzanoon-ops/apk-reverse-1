package zendesk.messaging.android.internal;

import android.content.Context;
import j$.time.LocalDateTime;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.android.internal.DateKtxKt;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogTimestampFormatter;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogTimestampFormatterKt;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u001c\b\u0000\u0018\u0000 -2\u00020\u0001:\u0001-B+\b\u0007\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\b\b\u0001\u0010\t\u001a\u00020\b¢\u0006\u0004\b\n\u0010\u000bJ9\u0010\u0014\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\f2\u0006\u0010\u000e\u001a\u00020\f2\u0006\u0010\u000f\u001a\u00020\f2\b\u0010\u0011\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u0013\u001a\u00020\u0012H\u0002¢\u0006\u0004\b\u0014\u0010\u0015J\u0017\u0010\u0017\u001a\u00020\f2\u0006\u0010\u0016\u001a\u00020\u0010H\u0002¢\u0006\u0004\b\u0017\u0010\u0018J)\u0010\u0017\u001a\u00020\f2\b\b\u0001\u0010\u0019\u001a\u00020\u00122\u0006\u0010\u0016\u001a\u00020\u00102\u0006\u0010\u001a\u001a\u00020\bH\u0002¢\u0006\u0004\b\u0017\u0010\u001bJ\u0019\u0010\u001c\u001a\u00020\f2\b\u0010\u0016\u001a\u0004\u0018\u00010\u0010H\u0002¢\u0006\u0004\b\u001c\u0010\u0018J\u0017\u0010\u001e\u001a\u00020\f2\u0006\u0010\u001d\u001a\u00020\u0012H\u0002¢\u0006\u0004\b\u001e\u0010\u001fJ)\u0010#\u001a\u00020\f2\b\u0010 \u001a\u0004\u0018\u00010\f2\b\u0010!\u001a\u0004\u0018\u00010\u00102\u0006\u0010\"\u001a\u00020\f¢\u0006\u0004\b#\u0010$JK\u0010&\u001a\u00020\f2\b\u0010 \u001a\u0004\u0018\u00010\f2\u0006\u0010%\u001a\u00020\f2\b\u0010!\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u000e\u001a\u00020\f2\u0006\u0010\u000f\u001a\u00020\f2\b\u0010\u0011\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u0013\u001a\u00020\u0012¢\u0006\u0004\b&\u0010'J)\u0010(\u001a\u00020\f2\b\u0010 \u001a\u0004\u0018\u00010\f2\b\u0010!\u001a\u0004\u0018\u00010\u00102\u0006\u0010\"\u001a\u00020\f¢\u0006\u0004\b(\u0010$R\u0014\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0003\u0010)R\u0014\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010*R\u0014\u0010\u0007\u001a\u00020\u00068\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0007\u0010+R\u0014\u0010\t\u001a\u00020\b8\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\t\u0010,¨\u0006."}, m18d2 = {"Lzendesk/messaging/android/internal/ConversationTitleProvider;", "", "Landroid/content/Context;", "context", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "localeProvider", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogTimestampFormatter;", "timestampFormatter", "", "is24HourFormat", "<init>", "(Landroid/content/Context;Lzendesk/core/ui/android/internal/local/LocaleProvider;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogTimestampFormatter;Z)V", "", "intro", "latestMessage", "latestMessageOwner", "j$/time/LocalDateTime", "latestMessageTimestamp", "", "unreadMessagesCount", "resolveAccessibilityNonDefaultListTitle", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;I)Ljava/lang/String;", "timestamp", "resolveDefaultTitle", "(Lj$/time/LocalDateTime;)Ljava/lang/String;", "stringRes", "isFullMonthFormat", "(ILj$/time/LocalDateTime;Z)Ljava/lang/String;", "resolveLatestMessageTimestamp", "count", "resolveUnreadMessagesCount", "(I)Ljava/lang/String;", "displayName", "createdAt", "fallbackTitle", "resolveTitle", "(Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;)Ljava/lang/String;", "participants", "resolveAccessibilityListTitle", "(Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;Lj$/time/LocalDateTime;I)Ljava/lang/String;", "resolveAccessibilityHeaderTitle", "Landroid/content/Context;", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationLogTimestampFormatter;", "Z", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationTitleProvider {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final int UNREAD_MESSAGES_NONE = 0;

    @Deprecated
    public static final int UNREAD_MESSAGES_SINGLE = 1;
    private final Context context;
    private final boolean is24HourFormat;
    private final LocaleProvider localeProvider;
    private final ConversationLogTimestampFormatter timestampFormatter;

    @Inject
    public ConversationTitleProvider(Context context, LocaleProvider localeProvider, ConversationLogTimestampFormatter timestampFormatter, @Named(ConversationLogTimestampFormatterKt.FORMAT_24H) boolean z) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        Intrinsics.checkNotNullParameter(timestampFormatter, "timestampFormatter");
        this.context = context;
        this.localeProvider = localeProvider;
        this.timestampFormatter = timestampFormatter;
        this.is24HourFormat = z;
    }

    public final String resolveTitle(String displayName, LocalDateTime createdAt, String fallbackTitle) {
        Intrinsics.checkNotNullParameter(fallbackTitle, "fallbackTitle");
        if (displayName != null) {
            return displayName;
        }
        String strResolveDefaultTitle = createdAt != null ? resolveDefaultTitle(createdAt) : null;
        return strResolveDefaultTitle == null ? fallbackTitle : strResolveDefaultTitle;
    }

    public final String resolveAccessibilityListTitle(String displayName, String participants, LocalDateTime createdAt, String latestMessage, String latestMessageOwner, LocalDateTime latestMessageTimestamp, int unreadMessagesCount) {
        Intrinsics.checkNotNullParameter(participants, "participants");
        Intrinsics.checkNotNullParameter(latestMessage, "latestMessage");
        Intrinsics.checkNotNullParameter(latestMessageOwner, "latestMessageOwner");
        if (displayName != null) {
            return resolveAccessibilityNonDefaultListTitle(displayName, latestMessage, latestMessageOwner, latestMessageTimestamp, unreadMessagesCount);
        }
        if (createdAt != null) {
            String string = this.context.getString(R.string.zuia_multiconvo_conversation_list_screen_item_default_title_accessibility_label, ConversationTitleProviderKt.resolveDate(createdAt, this.localeProvider.getLocale(), true), DateKtxKt.timeOnly(createdAt, this.localeProvider.getLocale(), this.is24HourFormat), latestMessageOwner + ", " + latestMessage, resolveLatestMessageTimestamp(latestMessageTimestamp), resolveUnreadMessagesCount(unreadMessagesCount));
            Intrinsics.checkNotNull(string);
            return string;
        }
        return resolveAccessibilityNonDefaultListTitle(participants, latestMessage, latestMessageOwner, latestMessageTimestamp, unreadMessagesCount);
    }

    private final String resolveAccessibilityNonDefaultListTitle(String intro, String latestMessage, String latestMessageOwner, LocalDateTime latestMessageTimestamp, int unreadMessagesCount) {
        String string = this.context.getString(R.string.zuia_conversation_list_item_content_accessibility_label, intro + ", ", latestMessageOwner, "\n" + latestMessage, resolveLatestMessageTimestamp(latestMessageTimestamp), resolveUnreadMessagesCount(unreadMessagesCount));
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    public final String resolveAccessibilityHeaderTitle(String displayName, LocalDateTime createdAt, String fallbackTitle) {
        Intrinsics.checkNotNullParameter(fallbackTitle, "fallbackTitle");
        if (displayName != null) {
            return displayName;
        }
        String strResolveDefaultTitle = createdAt != null ? resolveDefaultTitle(R.string.zuia_multiconvo_conversation_screen_header_default_title_accessibility_label, createdAt, true) : null;
        return strResolveDefaultTitle == null ? fallbackTitle : strResolveDefaultTitle;
    }

    private final String resolveDefaultTitle(LocalDateTime timestamp) {
        int i;
        if (timestamp.getYear() == LocalDateTime.now().getYear()) {
            i = C1256R.string.f202x291ab053;
        } else {
            i = C1256R.string.f203xad7ced9e;
        }
        return resolveDefaultTitle(i, timestamp, false);
    }

    private final String resolveDefaultTitle(int stringRes, LocalDateTime timestamp, boolean isFullMonthFormat) {
        String string = this.context.getString(stringRes, ConversationTitleProviderKt.resolveDate(timestamp, this.localeProvider.getLocale(), isFullMonthFormat), DateKtxKt.timeOnly(timestamp, this.localeProvider.getLocale(), this.is24HourFormat));
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        return string;
    }

    private final String resolveLatestMessageTimestamp(LocalDateTime timestamp) {
        if (timestamp != null) {
            ConversationLogTimestampFormatter conversationLogTimestampFormatter = this.timestampFormatter;
            LocalDateTime localDateTimeNow = LocalDateTime.now();
            Intrinsics.checkNotNullExpressionValue(localDateTimeNow, "now(...)");
            return conversationLogTimestampFormatter.m280xff406d0b(timestamp, localDateTimeNow);
        }
        return "";
    }

    private final String resolveUnreadMessagesCount(int count) {
        int i = R.string.zuia_conversation_list_item_one_unread_message_accessibility_label;
        int i2 = R.string.zuia_conversation_list_item_unread_messages_accessibility_label;
        if (count == 0) {
            return "";
        }
        if (count == 1) {
            String string = this.context.getString(i);
            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
            return string;
        }
        String string2 = this.context.getString(i2, Integer.valueOf(count));
        Intrinsics.checkNotNullExpressionValue(string2, "getString(...)");
        return string2;
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/ConversationTitleProvider$Companion;", "", "()V", "UNREAD_MESSAGES_NONE", "", "UNREAD_MESSAGES_SINGLE", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
