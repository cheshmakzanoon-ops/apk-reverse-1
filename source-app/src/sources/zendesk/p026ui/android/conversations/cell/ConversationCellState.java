package zendesk.p026ui.android.conversations.cell;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b)\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001>B\u009d\u0001\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\b\b\u0002\u0010\t\u001a\u00020\u0003\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\u000e\b\u0002\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0010\u001a\u00020\u000b\u0012\b\b\u0003\u0010\u0011\u001a\u00020\u000b\u0012\b\b\u0003\u0010\u0012\u001a\u00020\u000b\u0012\b\b\u0003\u0010\u0013\u001a\u00020\u000b\u0012\b\b\u0003\u0010\u0014\u001a\u00020\u000b¢\u0006\u0002\u0010\u0015J\t\u0010(\u001a\u00020\u0003HÆ\u0003J\t\u0010)\u001a\u00020\u000bHÆ\u0003J\t\u0010*\u001a\u00020\u000bHÆ\u0003J\t\u0010+\u001a\u00020\u000bHÆ\u0003J\t\u0010,\u001a\u00020\u000bHÆ\u0003J\t\u0010-\u001a\u00020\u000bHÆ\u0003J\t\u0010.\u001a\u00020\u0003HÆ\u0003J\t\u0010/\u001a\u00020\u0003HÆ\u0003J\u000b\u00100\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u00101\u001a\u0004\u0018\u00010\bHÆ\u0003J\t\u00102\u001a\u00020\u0003HÆ\u0003J\t\u00103\u001a\u00020\u000bHÆ\u0003J\u000f\u00104\u001a\b\u0012\u0004\u0012\u00020\u000e0\rHÆ\u0003J\t\u00105\u001a\u00020\u0003HÆ\u0003J\u009f\u0001\u00106\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b2\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u000b2\u000e\b\u0002\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r2\b\b\u0002\u0010\u000f\u001a\u00020\u00032\b\b\u0003\u0010\u0010\u001a\u00020\u000b2\b\b\u0003\u0010\u0011\u001a\u00020\u000b2\b\b\u0003\u0010\u0012\u001a\u00020\u000b2\b\b\u0003\u0010\u0013\u001a\u00020\u000b2\b\b\u0003\u0010\u0014\u001a\u00020\u000bHÆ\u0001J\u0013\u00107\u001a\u0002082\b\u00109\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010:\u001a\u00020\u000bHÖ\u0001J\u0006\u0010;\u001a\u00020<J\t\u0010=\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u000f\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u0011\u0010\u0013\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0017R\u0011\u0010\u0014\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u001dR\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0017R\u0011\u0010\u0011\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u001dR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u0017R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u0017R\u0011\u0010\u0012\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u001dR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u0017R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u001dR\u0011\u0010\u0010\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b'\u0010\u001d¨\u0006?"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/ConversationCellState;", "", "participants", "", "conversationTitle", "lastMessage", "lastMessageOwner", "avatarImageState", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "dateTimeStamp", "unreadMessagesCount", "", "clickListener", "Lkotlin/Function0;", "", "accessibilityTitle", "unreadMessagesCountColor", "dateTimestampTextColor", "lastMessageTextColor", "conversationParticipantsTextColor", "conversationTitleTextColor", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/ui/android/conversation/avatar/AvatarImageState;Ljava/lang/String;ILkotlin/jvm/functions/Function0;Ljava/lang/String;IIIII)V", "getAccessibilityTitle", "()Ljava/lang/String;", "getAvatarImageState", "()Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "getClickListener", "()Lkotlin/jvm/functions/Function0;", "getConversationParticipantsTextColor", "()I", "getConversationTitle", "getConversationTitleTextColor", "getDateTimeStamp", "getDateTimestampTextColor", "getLastMessage", "getLastMessageOwner", "getLastMessageTextColor", "getParticipants", "getUnreadMessagesCount", "getUnreadMessagesCountColor", "component1", "component10", "component11", "component12", "component13", "component14", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversations/cell/ConversationCellState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationCellState {
    public static final int $stable = 8;
    private final String accessibilityTitle;
    private final AvatarImageState avatarImageState;
    private final Function0<Unit> clickListener;
    private final int conversationParticipantsTextColor;
    private final String conversationTitle;
    private final int conversationTitleTextColor;
    private final String dateTimeStamp;
    private final int dateTimestampTextColor;
    private final String lastMessage;
    private final String lastMessageOwner;
    private final int lastMessageTextColor;
    private final String participants;
    private final int unreadMessagesCount;
    private final int unreadMessagesCountColor;

    public ConversationCellState() {
        this(null, null, null, null, null, null, 0, null, null, 0, 0, 0, 0, 0, 16383, null);
    }

    public final String getParticipants() {
        return this.participants;
    }

    public final int getUnreadMessagesCountColor() {
        return this.unreadMessagesCountColor;
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

    public final String getConversationTitle() {
        return this.conversationTitle;
    }

    public final String getLastMessage() {
        return this.lastMessage;
    }

    public final String getLastMessageOwner() {
        return this.lastMessageOwner;
    }

    public final AvatarImageState getAvatarImageState() {
        return this.avatarImageState;
    }

    public final String getDateTimeStamp() {
        return this.dateTimeStamp;
    }

    public final int getUnreadMessagesCount() {
        return this.unreadMessagesCount;
    }

    public final Function0<Unit> component8() {
        return this.clickListener;
    }

    public final String getAccessibilityTitle() {
        return this.accessibilityTitle;
    }

    public final ConversationCellState copy(String participants, String conversationTitle, String lastMessage, String lastMessageOwner, AvatarImageState avatarImageState, String dateTimeStamp, int unreadMessagesCount, Function0<Unit> clickListener, String accessibilityTitle, int unreadMessagesCountColor, int dateTimestampTextColor, int lastMessageTextColor, int conversationParticipantsTextColor, int conversationTitleTextColor) {
        Intrinsics.checkNotNullParameter(participants, "participants");
        Intrinsics.checkNotNullParameter(conversationTitle, "conversationTitle");
        Intrinsics.checkNotNullParameter(lastMessage, "lastMessage");
        Intrinsics.checkNotNullParameter(dateTimeStamp, "dateTimeStamp");
        Intrinsics.checkNotNullParameter(clickListener, "clickListener");
        Intrinsics.checkNotNullParameter(accessibilityTitle, "accessibilityTitle");
        return new ConversationCellState(participants, conversationTitle, lastMessage, lastMessageOwner, avatarImageState, dateTimeStamp, unreadMessagesCount, clickListener, accessibilityTitle, unreadMessagesCountColor, dateTimestampTextColor, lastMessageTextColor, conversationParticipantsTextColor, conversationTitleTextColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationCellState)) {
            return false;
        }
        ConversationCellState conversationCellState = (ConversationCellState) other;
        return Intrinsics.areEqual(this.participants, conversationCellState.participants) && Intrinsics.areEqual(this.conversationTitle, conversationCellState.conversationTitle) && Intrinsics.areEqual(this.lastMessage, conversationCellState.lastMessage) && Intrinsics.areEqual(this.lastMessageOwner, conversationCellState.lastMessageOwner) && Intrinsics.areEqual(this.avatarImageState, conversationCellState.avatarImageState) && Intrinsics.areEqual(this.dateTimeStamp, conversationCellState.dateTimeStamp) && this.unreadMessagesCount == conversationCellState.unreadMessagesCount && Intrinsics.areEqual(this.clickListener, conversationCellState.clickListener) && Intrinsics.areEqual(this.accessibilityTitle, conversationCellState.accessibilityTitle) && this.unreadMessagesCountColor == conversationCellState.unreadMessagesCountColor && this.dateTimestampTextColor == conversationCellState.dateTimestampTextColor && this.lastMessageTextColor == conversationCellState.lastMessageTextColor && this.conversationParticipantsTextColor == conversationCellState.conversationParticipantsTextColor && this.conversationTitleTextColor == conversationCellState.conversationTitleTextColor;
    }

    public int hashCode() {
        int iHashCode = ((((this.participants.hashCode() * 31) + this.conversationTitle.hashCode()) * 31) + this.lastMessage.hashCode()) * 31;
        String str = this.lastMessageOwner;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        AvatarImageState avatarImageState = this.avatarImageState;
        return ((((((((((((((((((iHashCode2 + (avatarImageState != null ? avatarImageState.hashCode() : 0)) * 31) + this.dateTimeStamp.hashCode()) * 31) + this.unreadMessagesCount) * 31) + this.clickListener.hashCode()) * 31) + this.accessibilityTitle.hashCode()) * 31) + this.unreadMessagesCountColor) * 31) + this.dateTimestampTextColor) * 31) + this.lastMessageTextColor) * 31) + this.conversationParticipantsTextColor) * 31) + this.conversationTitleTextColor;
    }

    public String toString() {
        return "ConversationCellState(participants=" + this.participants + ", conversationTitle=" + this.conversationTitle + ", lastMessage=" + this.lastMessage + ", lastMessageOwner=" + this.lastMessageOwner + ", avatarImageState=" + this.avatarImageState + ", dateTimeStamp=" + this.dateTimeStamp + ", unreadMessagesCount=" + this.unreadMessagesCount + ", clickListener=" + this.clickListener + ", accessibilityTitle=" + this.accessibilityTitle + ", unreadMessagesCountColor=" + this.unreadMessagesCountColor + ", dateTimestampTextColor=" + this.dateTimestampTextColor + ", lastMessageTextColor=" + this.lastMessageTextColor + ", conversationParticipantsTextColor=" + this.conversationParticipantsTextColor + ", conversationTitleTextColor=" + this.conversationTitleTextColor + ')';
    }

    public ConversationCellState(String participants, String conversationTitle, String lastMessage, String str, AvatarImageState avatarImageState, String dateTimeStamp, int i, Function0<Unit> clickListener, String accessibilityTitle, int i2, int i3, int i4, int i5, int i6) {
        Intrinsics.checkNotNullParameter(participants, "participants");
        Intrinsics.checkNotNullParameter(conversationTitle, "conversationTitle");
        Intrinsics.checkNotNullParameter(lastMessage, "lastMessage");
        Intrinsics.checkNotNullParameter(dateTimeStamp, "dateTimeStamp");
        Intrinsics.checkNotNullParameter(clickListener, "clickListener");
        Intrinsics.checkNotNullParameter(accessibilityTitle, "accessibilityTitle");
        this.participants = participants;
        this.conversationTitle = conversationTitle;
        this.lastMessage = lastMessage;
        this.lastMessageOwner = str;
        this.avatarImageState = avatarImageState;
        this.dateTimeStamp = dateTimeStamp;
        this.unreadMessagesCount = i;
        this.clickListener = clickListener;
        this.accessibilityTitle = accessibilityTitle;
        this.unreadMessagesCountColor = i2;
        this.dateTimestampTextColor = i3;
        this.lastMessageTextColor = i4;
        this.conversationParticipantsTextColor = i5;
        this.conversationTitleTextColor = i6;
    }

    public ConversationCellState(String str, String str2, String str3, String str4, AvatarImageState avatarImageState, String str5, int i, Function0 function0, String str6, int i2, int i3, int i4, int i5, int i6, int i7, DefaultConstructorMarker defaultConstructorMarker) {
        this((i7 & 1) != 0 ? "" : str, (i7 & 2) != 0 ? "" : str2, (i7 & 4) != 0 ? "" : str3, (i7 & 8) != 0 ? null : str4, (i7 & 16) == 0 ? avatarImageState : null, (i7 & 32) != 0 ? "" : str5, (i7 & 64) != 0 ? 0 : i, (i7 & 128) != 0 ? new Function0<Unit>() {
            public final void invoke2() {
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }
        } : function0, (i7 & 256) == 0 ? str6 : "", (i7 & 512) != 0 ? 0 : i2, (i7 & 1024) != 0 ? 0 : i3, (i7 & 2048) != 0 ? 0 : i4, (i7 & 4096) != 0 ? 0 : i5, (i7 & 8192) == 0 ? i6 : 0);
    }

    public final String getParticipants() {
        return this.participants;
    }

    public final String getConversationTitle() {
        return this.conversationTitle;
    }

    public final String getLastMessage() {
        return this.lastMessage;
    }

    public final String getLastMessageOwner() {
        return this.lastMessageOwner;
    }

    public final AvatarImageState getAvatarImageState() {
        return this.avatarImageState;
    }

    public final String getDateTimeStamp() {
        return this.dateTimeStamp;
    }

    public final int getUnreadMessagesCount() {
        return this.unreadMessagesCount;
    }

    public final Function0<Unit> getClickListener() {
        return this.clickListener;
    }

    public final String getAccessibilityTitle() {
        return this.accessibilityTitle;
    }

    public final int getUnreadMessagesCountColor() {
        return this.unreadMessagesCountColor;
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

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u009c\u0001\u0010\u0007\u001a\u00020\u00002\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\t2\b\b\u0002\u0010\u000b\u001a\u00020\t2\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\t2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\t2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0003\u0010\u0012\u001a\u00020\u00112\b\b\u0003\u0010\u0013\u001a\u00020\u00112\b\b\u0003\u0010\u0014\u001a\u00020\u00112\b\b\u0003\u0010\u0015\u001a\u00020\u00112\b\b\u0003\u0010\u0016\u001a\u00020\u00112\u000e\b\u0002\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00190\u00182\b\b\u0002\u0010\u001a\u001a\u00020\tR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u001b"}, m18d2 = {"Lzendesk/ui/android/conversations/cell/ConversationCellState$Builder;", "", "state", "Lzendesk/ui/android/conversations/cell/ConversationCellState;", "(Lzendesk/ui/android/conversations/cell/ConversationCellState;)V", "()V", "build", "conversationCellState", "participants", "", "conversationTitle", "lastMessage", "lastMessageOwner", "avatarImageState", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "dateTimeStamp", "unreadMessagesCount", "", "unreadMessagesCountColor", "dateTimestampTextColor", "lastMessageTextColor", "conversationParticipantsTextColor", "conversationTitleTextColor", "clickListener", "Lkotlin/Function0;", "", "accessibilityTitle", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ConversationCellState state;

        public Builder() {
            this.state = new ConversationCellState(null, null, null, null, null, null, 0, null, null, 0, 0, 0, 0, 0, 16383, null);
        }

        public Builder(ConversationCellState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder conversationCellState(String participants, String conversationTitle, String lastMessage, String lastMessageOwner, AvatarImageState avatarImageState, String dateTimeStamp, int unreadMessagesCount, int unreadMessagesCountColor, int dateTimestampTextColor, int lastMessageTextColor, int conversationParticipantsTextColor, int conversationTitleTextColor, Function0<Unit> clickListener, String accessibilityTitle) {
            Intrinsics.checkNotNullParameter(participants, "participants");
            Intrinsics.checkNotNullParameter(conversationTitle, "conversationTitle");
            Intrinsics.checkNotNullParameter(lastMessage, "lastMessage");
            Intrinsics.checkNotNullParameter(dateTimeStamp, "dateTimeStamp");
            Intrinsics.checkNotNullParameter(clickListener, "clickListener");
            Intrinsics.checkNotNullParameter(accessibilityTitle, "accessibilityTitle");
            this.state = this.state.copy(participants, conversationTitle, lastMessage, lastMessageOwner, avatarImageState, dateTimeStamp, unreadMessagesCount, clickListener, accessibilityTitle, unreadMessagesCountColor, dateTimestampTextColor, lastMessageTextColor, conversationParticipantsTextColor, conversationTitleTextColor);
            return this;
        }

        public final ConversationCellState getState() {
            return this.state;
        }
    }
}
