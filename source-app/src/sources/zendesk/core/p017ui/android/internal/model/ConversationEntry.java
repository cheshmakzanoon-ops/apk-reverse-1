package zendesk.core.p017ui.android.internal.model;

import j$.time.LocalDateTime;
import java.util.UUID;
import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.InternalZendeskUIApi;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000 \u000e2\u00020\u0001:\u0004\u000e\u000f\u0010\u0011B\u001d\b\u0004\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0004¢\u0006\u0004\b\u0006\u0010\u0007R\u001a\u0010\u0003\u001a\u00020\u00028\u0016X\u0096\u0004¢\u0006\f\n\u0004\b\u0003\u0010\b\u001a\u0004\b\t\u0010\nR\u001c\u0010\u0005\u001a\u0004\u0018\u00010\u00048\u0016X\u0096\u0004¢\u0006\f\n\u0004\b\u0005\u0010\u000b\u001a\u0004\b\f\u0010\r\u0082\u0001\u0002\u0012\u0013¨\u0006\u0014"}, m18d2 = {"Lzendesk/core/ui/android/internal/model/ConversationEntry;", "", "", "id", "j$/time/LocalDateTime", "dateTimeStamp", "<init>", "(Ljava/lang/String;Lj$/time/LocalDateTime;)V", "Ljava/lang/String;", "getId", "()Ljava/lang/String;", "Lj$/time/LocalDateTime;", "getDateTimeStamp", "()Lj$/time/LocalDateTime;", "Companion", "ConversationItem", "LoadMore", "LoadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@InternalZendeskUIApi
public abstract class ConversationEntry {
    private static final String LOAD_MORE_ID;
    private final LocalDateTime dateTimeStamp;
    private final String id;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "", "(Ljava/lang/String;I)V", "LOADING", "FAILED", "NONE", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public enum LoadMoreStatus {
        LOADING,
        FAILED,
        NONE;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static EnumEntries<LoadMoreStatus> getEntries() {
            return $ENTRIES;
        }
    }

    public ConversationEntry(String str, LocalDateTime localDateTime, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, localDateTime);
    }

    private ConversationEntry(String str, LocalDateTime localDateTime) {
        this.id = str;
        this.dateTimeStamp = localDateTime;
    }

    public ConversationEntry(String str, LocalDateTime localDateTime, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, (i & 2) != 0 ? null : localDateTime, null);
    }

    public String getId() {
        return this.id;
    }

    public LocalDateTime getDateTimeStamp() {
        return this.dateTimeStamp;
    }

    @Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\b\b\n\u0002\u0010\b\n\u0002\b\u001f\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0015\b\u0087\b\u0018\u00002\u00020\u0001B\u009f\u0001\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0004\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0002\u0012\b\b\u0002\u0010\u0007\u001a\u00020\u0002\u0012\b\b\u0002\u0010\b\u001a\u00020\u0002\u0012\b\b\u0002\u0010\t\u001a\u00020\u0002\u0012\b\b\u0002\u0010\n\u001a\u00020\u0002\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u0002\u0012\b\b\u0002\u0010\r\u001a\u00020\f\u0012\b\b\u0002\u0010\u000e\u001a\u00020\u0002\u0012\b\b\u0001\u0010\u000f\u001a\u00020\f\u0012\b\b\u0001\u0010\u0010\u001a\u00020\f\u0012\b\b\u0001\u0010\u0011\u001a\u00020\f\u0012\b\b\u0001\u0010\u0012\u001a\u00020\f\u0012\b\b\u0001\u0010\u0013\u001a\u00020\f¢\u0006\u0004\b\u0014\u0010\u0015J\u0010\u0010\u0016\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u0016\u0010\u0017J\u0012\u0010\u0018\u001a\u0004\u0018\u00010\u0004HÆ\u0003¢\u0006\u0004\b\u0018\u0010\u0019J\u0010\u0010\u001a\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u001a\u0010\u0017J\u0010\u0010\u001b\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u001b\u0010\u0017J\u0010\u0010\u001c\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u001c\u0010\u0017J\u0010\u0010\u001d\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u001d\u0010\u0017J\u0010\u0010\u001e\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u001e\u0010\u0017J\u0012\u0010\u001f\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b\u001f\u0010\u0017J\u0010\u0010 \u001a\u00020\fHÆ\u0003¢\u0006\u0004\b \u0010!J\u0010\u0010\"\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\"\u0010\u0017J\u0010\u0010#\u001a\u00020\fHÆ\u0003¢\u0006\u0004\b#\u0010!J\u0010\u0010$\u001a\u00020\fHÆ\u0003¢\u0006\u0004\b$\u0010!J\u0010\u0010%\u001a\u00020\fHÆ\u0003¢\u0006\u0004\b%\u0010!J\u0010\u0010&\u001a\u00020\fHÆ\u0003¢\u0006\u0004\b&\u0010!J\u0010\u0010'\u001a\u00020\fHÆ\u0003¢\u0006\u0004\b'\u0010!Jª\u0001\u0010(\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00022\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00022\b\b\u0002\u0010\u0007\u001a\u00020\u00022\b\b\u0002\u0010\b\u001a\u00020\u00022\b\b\u0002\u0010\t\u001a\u00020\u00022\b\b\u0002\u0010\n\u001a\u00020\u00022\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00022\b\b\u0002\u0010\r\u001a\u00020\f2\b\b\u0002\u0010\u000e\u001a\u00020\u00022\b\b\u0003\u0010\u000f\u001a\u00020\f2\b\b\u0003\u0010\u0010\u001a\u00020\f2\b\b\u0003\u0010\u0011\u001a\u00020\f2\b\b\u0003\u0010\u0012\u001a\u00020\f2\b\b\u0003\u0010\u0013\u001a\u00020\fHÆ\u0001¢\u0006\u0004\b(\u0010)J\u0010\u0010*\u001a\u00020\u0002HÖ\u0001¢\u0006\u0004\b*\u0010\u0017J\u0010\u0010+\u001a\u00020\fHÖ\u0001¢\u0006\u0004\b+\u0010!J\u001a\u0010/\u001a\u00020.2\b\u0010-\u001a\u0004\u0018\u00010,HÖ\u0003¢\u0006\u0004\b/\u00100R\u001a\u0010\u0003\u001a\u00020\u00028\u0016X\u0096\u0004¢\u0006\f\n\u0004\b\u0003\u00101\u001a\u0004\b2\u0010\u0017R\u001c\u0010\u0005\u001a\u0004\u0018\u00010\u00048\u0016X\u0096\u0004¢\u0006\f\n\u0004\b\u0005\u00103\u001a\u0004\b4\u0010\u0019R\u0017\u0010\u0006\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0006\u00101\u001a\u0004\b5\u0010\u0017R\u0017\u0010\u0007\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0007\u00101\u001a\u0004\b6\u0010\u0017R\u0017\u0010\b\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\b\u00101\u001a\u0004\b7\u0010\u0017R\u0017\u0010\t\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\t\u00101\u001a\u0004\b8\u0010\u0017R\u0017\u0010\n\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\n\u00101\u001a\u0004\b9\u0010\u0017R\u0019\u0010\u000b\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u000b\u00101\u001a\u0004\b:\u0010\u0017R\u0017\u0010\r\u001a\u00020\f8\u0006¢\u0006\f\n\u0004\b\r\u0010;\u001a\u0004\b<\u0010!R\u0017\u0010\u000e\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u000e\u00101\u001a\u0004\b=\u0010\u0017R\u0017\u0010\u000f\u001a\u00020\f8\u0006¢\u0006\f\n\u0004\b\u000f\u0010;\u001a\u0004\b>\u0010!R\u0017\u0010\u0010\u001a\u00020\f8\u0006¢\u0006\f\n\u0004\b\u0010\u0010;\u001a\u0004\b?\u0010!R\u0017\u0010\u0011\u001a\u00020\f8\u0006¢\u0006\f\n\u0004\b\u0011\u0010;\u001a\u0004\b@\u0010!R\u0017\u0010\u0012\u001a\u00020\f8\u0006¢\u0006\f\n\u0004\b\u0012\u0010;\u001a\u0004\bA\u0010!R\u0017\u0010\u0013\u001a\u00020\f8\u0006¢\u0006\f\n\u0004\b\u0013\u0010;\u001a\u0004\bB\u0010!¨\u0006C"}, m18d2 = {"Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "", "id", "j$/time/LocalDateTime", "dateTimeStamp", "formattedDateTimeStampString", "participantName", "conversationTitle", "avatarUrl", "latestMessage", "latestMessageOwner", "", "unreadMessages", "accessibilityTitle", "unreadMessagesColor", "dateTimestampTextColor", "lastMessageTextColor", "conversationParticipantsTextColor", "conversationTitleTextColor", "<init>", "(Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IIIII)V", "component1", "()Ljava/lang/String;", "component2", "()Lj$/time/LocalDateTime;", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "()I", "component10", "component11", "component12", "component13", "component14", "component15", "copy", "(Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IIIII)Lzendesk/core/ui/android/internal/model/ConversationEntry$ConversationItem;", "toString", "hashCode", "", "other", "", "equals", "(Ljava/lang/Object;)Z", "Ljava/lang/String;", "getId", "Lj$/time/LocalDateTime;", "getDateTimeStamp", "getFormattedDateTimeStampString", "getParticipantName", "getConversationTitle", "getAvatarUrl", "getLatestMessage", "getLatestMessageOwner", "I", "getUnreadMessages", "getAccessibilityTitle", "getUnreadMessagesColor", "getDateTimestampTextColor", "getLastMessageTextColor", "getConversationParticipantsTextColor", "getConversationTitleTextColor", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationItem extends ConversationEntry {
        public static final int $stable = 0;
        private final String accessibilityTitle;
        private final String avatarUrl;
        private final int conversationParticipantsTextColor;
        private final String conversationTitle;
        private final int conversationTitleTextColor;
        private final LocalDateTime dateTimeStamp;
        private final int dateTimestampTextColor;
        private final String formattedDateTimeStampString;
        private final String id;
        private final int lastMessageTextColor;
        private final String latestMessage;
        private final String latestMessageOwner;
        private final String participantName;
        private final int unreadMessages;
        private final int unreadMessagesColor;

        public final String getId() {
            return this.id;
        }

        public final String getAccessibilityTitle() {
            return this.accessibilityTitle;
        }

        public final int getUnreadMessagesColor() {
            return this.unreadMessagesColor;
        }

        public final int getDateTimestampTextColor() {
            return this.dateTimestampTextColor;
        }

        public final int getLastMessageTextColor() {
            return this.lastMessageTextColor;
        }

        public final int getConversationParticipantsTextColor() {
            return this.conversationParticipantsTextColor;
        }

        public final int getConversationTitleTextColor() {
            return this.conversationTitleTextColor;
        }

        public final LocalDateTime getDateTimeStamp() {
            return this.dateTimeStamp;
        }

        public final String getFormattedDateTimeStampString() {
            return this.formattedDateTimeStampString;
        }

        public final String getParticipantName() {
            return this.participantName;
        }

        public final String getConversationTitle() {
            return this.conversationTitle;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final String getLatestMessage() {
            return this.latestMessage;
        }

        public final String getLatestMessageOwner() {
            return this.latestMessageOwner;
        }

        public final int getUnreadMessages() {
            return this.unreadMessages;
        }

        public final ConversationItem copy(String id, LocalDateTime dateTimeStamp, String formattedDateTimeStampString, String participantName, String conversationTitle, String avatarUrl, String latestMessage, String latestMessageOwner, int unreadMessages, String accessibilityTitle, int unreadMessagesColor, int dateTimestampTextColor, int lastMessageTextColor, int conversationParticipantsTextColor, int conversationTitleTextColor) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(formattedDateTimeStampString, "formattedDateTimeStampString");
            Intrinsics.checkNotNullParameter(participantName, "participantName");
            Intrinsics.checkNotNullParameter(conversationTitle, "conversationTitle");
            Intrinsics.checkNotNullParameter(avatarUrl, "avatarUrl");
            Intrinsics.checkNotNullParameter(latestMessage, "latestMessage");
            Intrinsics.checkNotNullParameter(accessibilityTitle, "accessibilityTitle");
            return new ConversationItem(id, dateTimeStamp, formattedDateTimeStampString, participantName, conversationTitle, avatarUrl, latestMessage, latestMessageOwner, unreadMessages, accessibilityTitle, unreadMessagesColor, dateTimestampTextColor, lastMessageTextColor, conversationParticipantsTextColor, conversationTitleTextColor);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ConversationItem)) {
                return false;
            }
            ConversationItem conversationItem = (ConversationItem) other;
            return Intrinsics.areEqual(this.id, conversationItem.id) && Intrinsics.areEqual(this.dateTimeStamp, conversationItem.dateTimeStamp) && Intrinsics.areEqual(this.formattedDateTimeStampString, conversationItem.formattedDateTimeStampString) && Intrinsics.areEqual(this.participantName, conversationItem.participantName) && Intrinsics.areEqual(this.conversationTitle, conversationItem.conversationTitle) && Intrinsics.areEqual(this.avatarUrl, conversationItem.avatarUrl) && Intrinsics.areEqual(this.latestMessage, conversationItem.latestMessage) && Intrinsics.areEqual(this.latestMessageOwner, conversationItem.latestMessageOwner) && this.unreadMessages == conversationItem.unreadMessages && Intrinsics.areEqual(this.accessibilityTitle, conversationItem.accessibilityTitle) && this.unreadMessagesColor == conversationItem.unreadMessagesColor && this.dateTimestampTextColor == conversationItem.dateTimestampTextColor && this.lastMessageTextColor == conversationItem.lastMessageTextColor && this.conversationParticipantsTextColor == conversationItem.conversationParticipantsTextColor && this.conversationTitleTextColor == conversationItem.conversationTitleTextColor;
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            LocalDateTime localDateTime = this.dateTimeStamp;
            int iHashCode2 = (((((((((((iHashCode + (localDateTime == null ? 0 : localDateTime.hashCode())) * 31) + this.formattedDateTimeStampString.hashCode()) * 31) + this.participantName.hashCode()) * 31) + this.conversationTitle.hashCode()) * 31) + this.avatarUrl.hashCode()) * 31) + this.latestMessage.hashCode()) * 31;
            String str = this.latestMessageOwner;
            return ((((((((((((((iHashCode2 + (str != null ? str.hashCode() : 0)) * 31) + this.unreadMessages) * 31) + this.accessibilityTitle.hashCode()) * 31) + this.unreadMessagesColor) * 31) + this.dateTimestampTextColor) * 31) + this.lastMessageTextColor) * 31) + this.conversationParticipantsTextColor) * 31) + this.conversationTitleTextColor;
        }

        public String toString() {
            return "ConversationItem(id=" + this.id + ", dateTimeStamp=" + this.dateTimeStamp + ", formattedDateTimeStampString=" + this.formattedDateTimeStampString + ", participantName=" + this.participantName + ", conversationTitle=" + this.conversationTitle + ", avatarUrl=" + this.avatarUrl + ", latestMessage=" + this.latestMessage + ", latestMessageOwner=" + this.latestMessageOwner + ", unreadMessages=" + this.unreadMessages + ", accessibilityTitle=" + this.accessibilityTitle + ", unreadMessagesColor=" + this.unreadMessagesColor + ", dateTimestampTextColor=" + this.dateTimestampTextColor + ", lastMessageTextColor=" + this.lastMessageTextColor + ", conversationParticipantsTextColor=" + this.conversationParticipantsTextColor + ", conversationTitleTextColor=" + this.conversationTitleTextColor + ')';
        }

        public ConversationItem(String str, LocalDateTime localDateTime, String str2, String str3, String str4, String str5, String str6, String str7, int i, String str8, int i2, int i3, int i4, int i5, int i6, int i7, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i7 & 2) != 0 ? null : localDateTime, (i7 & 4) != 0 ? "" : str2, (i7 & 8) != 0 ? "" : str3, (i7 & 16) != 0 ? "" : str4, (i7 & 32) != 0 ? "" : str5, (i7 & 64) != 0 ? "" : str6, (i7 & 128) != 0 ? null : str7, (i7 & 256) != 0 ? 0 : i, (i7 & 512) != 0 ? "" : str8, i2, i3, i4, i5, i6);
        }

        @Override
        public String getId() {
            return this.id;
        }

        @Override
        public LocalDateTime getDateTimeStamp() {
            return this.dateTimeStamp;
        }

        public final String getFormattedDateTimeStampString() {
            return this.formattedDateTimeStampString;
        }

        public final String getParticipantName() {
            return this.participantName;
        }

        public final String getConversationTitle() {
            return this.conversationTitle;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final String getLatestMessage() {
            return this.latestMessage;
        }

        public final String getLatestMessageOwner() {
            return this.latestMessageOwner;
        }

        public final int getUnreadMessages() {
            return this.unreadMessages;
        }

        public final String getAccessibilityTitle() {
            return this.accessibilityTitle;
        }

        public final int getUnreadMessagesColor() {
            return this.unreadMessagesColor;
        }

        public final int getDateTimestampTextColor() {
            return this.dateTimestampTextColor;
        }

        public final int getLastMessageTextColor() {
            return this.lastMessageTextColor;
        }

        public final int getConversationParticipantsTextColor() {
            return this.conversationParticipantsTextColor;
        }

        public final int getConversationTitleTextColor() {
            return this.conversationTitleTextColor;
        }

        public ConversationItem(String id, LocalDateTime localDateTime, String formattedDateTimeStampString, String participantName, String conversationTitle, String avatarUrl, String latestMessage, String str, int i, String accessibilityTitle, int i2, int i3, int i4, int i5, int i6) {
            super(id, localDateTime, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(formattedDateTimeStampString, "formattedDateTimeStampString");
            Intrinsics.checkNotNullParameter(participantName, "participantName");
            Intrinsics.checkNotNullParameter(conversationTitle, "conversationTitle");
            Intrinsics.checkNotNullParameter(avatarUrl, "avatarUrl");
            Intrinsics.checkNotNullParameter(latestMessage, "latestMessage");
            Intrinsics.checkNotNullParameter(accessibilityTitle, "accessibilityTitle");
            this.id = id;
            this.dateTimeStamp = localDateTime;
            this.formattedDateTimeStampString = formattedDateTimeStampString;
            this.participantName = participantName;
            this.conversationTitle = conversationTitle;
            this.avatarUrl = avatarUrl;
            this.latestMessage = latestMessage;
            this.latestMessageOwner = str;
            this.unreadMessages = i;
            this.accessibilityTitle = accessibilityTitle;
            this.unreadMessagesColor = i2;
            this.dateTimestampTextColor = i3;
            this.lastMessageTextColor = i4;
            this.conversationParticipantsTextColor = i5;
            this.conversationTitleTextColor = i6;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001B3\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0001\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0003¢\u0006\u0002\u0010\nJ\t\u0010\u0013\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\t\u0010\u0017\u001a\u00020\u0003HÆ\u0003J;\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001cHÖ\u0003J\t\u0010\u001d\u001a\u00020\u0005HÖ\u0001J\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\fR\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000eR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012¨\u0006\u001f"}, m18d2 = {"Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMore;", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "id", "", "failedRetryTextColor", "", "progressBarColor", "status", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "retryText", "(Ljava/lang/String;IILzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;Ljava/lang/String;)V", "getFailedRetryTextColor", "()I", "getId", "()Ljava/lang/String;", "getProgressBarColor", "getRetryText", "getStatus", "()Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "", "hashCode", "toString", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadMore extends ConversationEntry {
        public static final int $stable = 0;
        private final int failedRetryTextColor;
        private final String id;
        private final int progressBarColor;
        private final String retryText;
        private final LoadMoreStatus status;

        public static LoadMore copy$default(LoadMore loadMore, String str, int i, int i2, LoadMoreStatus loadMoreStatus, String str2, int i3, Object obj) {
            if ((i3 & 1) != 0) {
                str = loadMore.id;
            }
            if ((i3 & 2) != 0) {
                i = loadMore.failedRetryTextColor;
            }
            int i4 = i;
            if ((i3 & 4) != 0) {
                i2 = loadMore.progressBarColor;
            }
            int i5 = i2;
            if ((i3 & 8) != 0) {
                loadMoreStatus = loadMore.status;
            }
            LoadMoreStatus loadMoreStatus2 = loadMoreStatus;
            if ((i3 & 16) != 0) {
                str2 = loadMore.retryText;
            }
            return loadMore.copy(str, i4, i5, loadMoreStatus2, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final int getFailedRetryTextColor() {
            return this.failedRetryTextColor;
        }

        public final int getProgressBarColor() {
            return this.progressBarColor;
        }

        public final LoadMoreStatus getStatus() {
            return this.status;
        }

        public final String getRetryText() {
            return this.retryText;
        }

        public final LoadMore copy(String id, int failedRetryTextColor, int progressBarColor, LoadMoreStatus status, String retryText) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(retryText, "retryText");
            return new LoadMore(id, failedRetryTextColor, progressBarColor, status, retryText);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LoadMore)) {
                return false;
            }
            LoadMore loadMore = (LoadMore) other;
            return Intrinsics.areEqual(this.id, loadMore.id) && this.failedRetryTextColor == loadMore.failedRetryTextColor && this.progressBarColor == loadMore.progressBarColor && this.status == loadMore.status && Intrinsics.areEqual(this.retryText, loadMore.retryText);
        }

        public int hashCode() {
            return (((((((this.id.hashCode() * 31) + this.failedRetryTextColor) * 31) + this.progressBarColor) * 31) + this.status.hashCode()) * 31) + this.retryText.hashCode();
        }

        public String toString() {
            return "LoadMore(id=" + this.id + ", failedRetryTextColor=" + this.failedRetryTextColor + ", progressBarColor=" + this.progressBarColor + ", status=" + this.status + ", retryText=" + this.retryText + ')';
        }

        public LoadMore(String str, int i, int i2, LoadMoreStatus loadMoreStatus, String str2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
            this((i3 & 1) != 0 ? ConversationEntry.INSTANCE.getLOAD_MORE_ID() : str, i, i2, loadMoreStatus, str2);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final int getFailedRetryTextColor() {
            return this.failedRetryTextColor;
        }

        public final int getProgressBarColor() {
            return this.progressBarColor;
        }

        public final LoadMoreStatus getStatus() {
            return this.status;
        }

        public final String getRetryText() {
            return this.retryText;
        }

        public LoadMore(String id, int i, int i2, LoadMoreStatus status, String retryText) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(retryText, "retryText");
            LocalDateTime localDateTime = null;
            super(id, localDateTime, 2, localDateTime);
            this.id = id;
            this.failedRetryTextColor = i;
            this.progressBarColor = i2;
            this.status = status;
            this.retryText = retryText;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/core/ui/android/internal/model/ConversationEntry$Companion;", "", "()V", "LOAD_MORE_ID", "", "getLOAD_MORE_ID", "()Ljava/lang/String;", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final String getLOAD_MORE_ID() {
            return ConversationEntry.LOAD_MORE_ID;
        }
    }

    static {
        String string = UUID.randomUUID().toString();
        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
        LOAD_MORE_ID = string;
    }
}
