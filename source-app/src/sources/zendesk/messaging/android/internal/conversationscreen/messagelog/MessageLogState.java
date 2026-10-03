package zendesk.messaging.android.internal.conversationscreen.messagelog;

import cz.msebera.android.httpclient.HttpStatus;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.form.DisplayedForm;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b&\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0080\b\u0018\u00002\u00020\u0001:\u0001;Bu\b\u0000\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\b\u0012\b\b\u0002\u0010\u000b\u001a\u00020\u0006\u0012\b\b\u0002\u0010\f\u001a\u00020\u0006\u0012\b\b\u0002\u0010\r\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u000e\u001a\u00020\t\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u0010\u0012\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\u0012J\u0014\u0010!\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÀ\u0003¢\u0006\u0002\b\"J\u000e\u0010#\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b$J\u001a\u0010%\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bHÀ\u0003¢\u0006\u0002\b&J\u000e\u0010'\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b(J\u000e\u0010)\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b*J\u000e\u0010+\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b,J\u000e\u0010-\u001a\u00020\tHÀ\u0003¢\u0006\u0002\b.J\u000e\u0010/\u001a\u00020\u0010HÀ\u0003¢\u0006\u0002\b0J\u0010\u00101\u001a\u0004\u0018\u00010\tHÀ\u0003¢\u0006\u0002\b2Jw\u00103\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\b2\b\b\u0002\u0010\u000b\u001a\u00020\u00062\b\b\u0002\u0010\f\u001a\u00020\u00062\b\b\u0002\u0010\r\u001a\u00020\u00062\b\b\u0002\u0010\u000e\u001a\u00020\t2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\tHÆ\u0001J\u0013\u00104\u001a\u00020\u00062\b\u00105\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00106\u001a\u000207HÖ\u0001J\u0006\u00108\u001a\u000209J\t\u0010:\u001a\u00020\tHÖ\u0001R\u0016\u0010\u0011\u001a\u0004\u0018\u00010\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R \u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u000f\u001a\u00020\u0010X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0014\u0010\u000e\u001a\u00020\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0014R\u0014\u0010\u000b\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001dR\u0014\u0010\f\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u001dR\u0014\u0010\r\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u001d¨\u0006<"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;", "", "messageLogEntryList", "", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "shouldScrollToBottom", "", "mapOfDisplayedFields", "", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "shouldAnnounceMessage", "shouldSeeLatestViewVisible", "showPostbackErrorBanner", "postbackErrorText", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "authorizationToken", "(Ljava/util/List;ZLjava/util/Map;ZZZLjava/lang/String;Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;)V", "getAuthorizationToken$zendesk_messaging_messaging_android", "()Ljava/lang/String;", "getMapOfDisplayedFields$zendesk_messaging_messaging_android", "()Ljava/util/Map;", "getMessageLogEntryList$zendesk_messaging_messaging_android", "()Ljava/util/List;", "getMessagingTheme$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getPostbackErrorText$zendesk_messaging_messaging_android", "getShouldAnnounceMessage$zendesk_messaging_messaging_android", "()Z", "getShouldScrollToBottom$zendesk_messaging_messaging_android", "getShouldSeeLatestViewVisible$zendesk_messaging_messaging_android", "getShowPostbackErrorBanner$zendesk_messaging_messaging_android", "component1", "component1$zendesk_messaging_messaging_android", "component2", "component2$zendesk_messaging_messaging_android", "component3", "component3$zendesk_messaging_messaging_android", "component4", "component4$zendesk_messaging_messaging_android", "component5", "component5$zendesk_messaging_messaging_android", "component6", "component6$zendesk_messaging_messaging_android", "component7", "component7$zendesk_messaging_messaging_android", "component8", "component8$zendesk_messaging_messaging_android", "component9", "component9$zendesk_messaging_messaging_android", "copy", "equals", "other", "hashCode", "", "toBuilder", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState$Builder;", "toString", "Builder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageLogState {
    private final String authorizationToken;
    private final Map<String, DisplayedForm> mapOfDisplayedFields;
    private final List<MessageLogEntry> messageLogEntryList;
    private final MessagingTheme messagingTheme;
    private final String postbackErrorText;
    private final boolean shouldAnnounceMessage;
    private final boolean shouldScrollToBottom;
    private final boolean shouldSeeLatestViewVisible;
    private final boolean showPostbackErrorBanner;

    public MessageLogState() {
        this(null, false, null, false, false, false, null, null, null, 511, null);
    }

    public static MessageLogState copy$default(MessageLogState messageLogState, List list, boolean z, Map map, boolean z2, boolean z3, boolean z4, String str, MessagingTheme messagingTheme, String str2, int i, Object obj) {
        return messageLogState.copy((i & 1) != 0 ? messageLogState.messageLogEntryList : list, (i & 2) != 0 ? messageLogState.shouldScrollToBottom : z, (i & 4) != 0 ? messageLogState.mapOfDisplayedFields : map, (i & 8) != 0 ? messageLogState.shouldAnnounceMessage : z2, (i & 16) != 0 ? messageLogState.shouldSeeLatestViewVisible : z3, (i & 32) != 0 ? messageLogState.showPostbackErrorBanner : z4, (i & 64) != 0 ? messageLogState.postbackErrorText : str, (i & 128) != 0 ? messageLogState.messagingTheme : messagingTheme, (i & 256) != 0 ? messageLogState.authorizationToken : str2);
    }

    public final List<MessageLogEntry> component1$zendesk_messaging_messaging_android() {
        return this.messageLogEntryList;
    }

    public final boolean getShouldScrollToBottom() {
        return this.shouldScrollToBottom;
    }

    public final Map<String, DisplayedForm> component3$zendesk_messaging_messaging_android() {
        return this.mapOfDisplayedFields;
    }

    public final boolean getShouldAnnounceMessage() {
        return this.shouldAnnounceMessage;
    }

    public final boolean getShouldSeeLatestViewVisible() {
        return this.shouldSeeLatestViewVisible;
    }

    public final boolean getShowPostbackErrorBanner() {
        return this.showPostbackErrorBanner;
    }

    public final String getPostbackErrorText() {
        return this.postbackErrorText;
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final String getAuthorizationToken() {
        return this.authorizationToken;
    }

    public final MessageLogState copy(List<? extends MessageLogEntry> messageLogEntryList, boolean shouldScrollToBottom, Map<String, DisplayedForm> mapOfDisplayedFields, boolean shouldAnnounceMessage, boolean shouldSeeLatestViewVisible, boolean showPostbackErrorBanner, String postbackErrorText, MessagingTheme messagingTheme, String authorizationToken) {
        Intrinsics.checkNotNullParameter(messageLogEntryList, "messageLogEntryList");
        Intrinsics.checkNotNullParameter(mapOfDisplayedFields, "mapOfDisplayedFields");
        Intrinsics.checkNotNullParameter(postbackErrorText, "postbackErrorText");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        return new MessageLogState(messageLogEntryList, shouldScrollToBottom, mapOfDisplayedFields, shouldAnnounceMessage, shouldSeeLatestViewVisible, showPostbackErrorBanner, postbackErrorText, messagingTheme, authorizationToken);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessageLogState)) {
            return false;
        }
        MessageLogState messageLogState = (MessageLogState) other;
        return Intrinsics.areEqual(this.messageLogEntryList, messageLogState.messageLogEntryList) && this.shouldScrollToBottom == messageLogState.shouldScrollToBottom && Intrinsics.areEqual(this.mapOfDisplayedFields, messageLogState.mapOfDisplayedFields) && this.shouldAnnounceMessage == messageLogState.shouldAnnounceMessage && this.shouldSeeLatestViewVisible == messageLogState.shouldSeeLatestViewVisible && this.showPostbackErrorBanner == messageLogState.showPostbackErrorBanner && Intrinsics.areEqual(this.postbackErrorText, messageLogState.postbackErrorText) && Intrinsics.areEqual(this.messagingTheme, messageLogState.messagingTheme) && Intrinsics.areEqual(this.authorizationToken, messageLogState.authorizationToken);
    }

    public int hashCode() {
        int iHashCode = ((((((((((((((this.messageLogEntryList.hashCode() * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldScrollToBottom)) * 31) + this.mapOfDisplayedFields.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldAnnounceMessage)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldSeeLatestViewVisible)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showPostbackErrorBanner)) * 31) + this.postbackErrorText.hashCode()) * 31) + this.messagingTheme.hashCode()) * 31;
        String str = this.authorizationToken;
        return iHashCode + (str == null ? 0 : str.hashCode());
    }

    public String toString() {
        return "MessageLogState(messageLogEntryList=" + this.messageLogEntryList + ", shouldScrollToBottom=" + this.shouldScrollToBottom + ", mapOfDisplayedFields=" + this.mapOfDisplayedFields + ", shouldAnnounceMessage=" + this.shouldAnnounceMessage + ", shouldSeeLatestViewVisible=" + this.shouldSeeLatestViewVisible + ", showPostbackErrorBanner=" + this.showPostbackErrorBanner + ", postbackErrorText=" + this.postbackErrorText + ", messagingTheme=" + this.messagingTheme + ", authorizationToken=" + this.authorizationToken + ')';
    }

    public MessageLogState(List<? extends MessageLogEntry> messageLogEntryList, boolean z, Map<String, DisplayedForm> mapOfDisplayedFields, boolean z2, boolean z3, boolean z4, String postbackErrorText, MessagingTheme messagingTheme, String str) {
        Intrinsics.checkNotNullParameter(messageLogEntryList, "messageLogEntryList");
        Intrinsics.checkNotNullParameter(mapOfDisplayedFields, "mapOfDisplayedFields");
        Intrinsics.checkNotNullParameter(postbackErrorText, "postbackErrorText");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.messageLogEntryList = messageLogEntryList;
        this.shouldScrollToBottom = z;
        this.mapOfDisplayedFields = mapOfDisplayedFields;
        this.shouldAnnounceMessage = z2;
        this.shouldSeeLatestViewVisible = z3;
        this.showPostbackErrorBanner = z4;
        this.postbackErrorText = postbackErrorText;
        this.messagingTheme = messagingTheme;
        this.authorizationToken = str;
    }

    public MessageLogState(List list, boolean z, Map map, boolean z2, boolean z3, boolean z4, String str, MessagingTheme messagingTheme, String str2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? CollectionsKt.emptyList() : list, (i & 2) != 0 ? false : z, (i & 4) != 0 ? new LinkedHashMap() : map, (i & 8) != 0 ? false : z2, (i & 16) != 0 ? false : z3, (i & 32) == 0 ? z4 : false, (i & 64) != 0 ? "" : str, (i & 128) != 0 ? MessagingTheme.INSTANCE.getDEFAULT() : messagingTheme, (i & 256) != 0 ? null : str2);
    }

    public final List<MessageLogEntry> getMessageLogEntryList$zendesk_messaging_messaging_android() {
        return this.messageLogEntryList;
    }

    public final boolean getShouldScrollToBottom$zendesk_messaging_messaging_android() {
        return this.shouldScrollToBottom;
    }

    public final Map<String, DisplayedForm> getMapOfDisplayedFields$zendesk_messaging_messaging_android() {
        return this.mapOfDisplayedFields;
    }

    public final boolean getShouldAnnounceMessage$zendesk_messaging_messaging_android() {
        return this.shouldAnnounceMessage;
    }

    public final boolean m268xbd7bc74e() {
        return this.shouldSeeLatestViewVisible;
    }

    public final boolean getShowPostbackErrorBanner$zendesk_messaging_messaging_android() {
        return this.showPostbackErrorBanner;
    }

    public final String getPostbackErrorText$zendesk_messaging_messaging_android() {
        return this.postbackErrorText;
    }

    public final MessagingTheme getMessagingTheme$zendesk_messaging_messaging_android() {
        return this.messagingTheme;
    }

    public final String getAuthorizationToken$zendesk_messaging_messaging_android() {
        return this.authorizationToken;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010%\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u001a\u0010\u0007\u001a\u00020\u00002\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bJ\u0014\u0010\u000b\u001a\u00020\u00002\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\fJ\u000e\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u000e\u001a\u00020\u000fJ\u000e\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0010\u001a\u00020\u000fJ\u000e\u0010\u0011\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u000fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0012"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState$Builder;", "", "state", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;", "(Lzendesk/messaging/android/internal/conversationscreen/messagelog/MessageLogState;)V", "()V", "build", "mapOfDisplayedFields", "", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "messageLogEntryList", "", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "shouldAnnounceMessage", "", "shouldScrollToBottom", "shouldSeeLatestViewVisible", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private MessageLogState state;

        public Builder() {
            this.state = new MessageLogState(null, false, null, false, false, false, null, null, null, 511, null);
        }

        public Builder(MessageLogState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder messageLogEntryList(List<? extends MessageLogEntry> messageLogEntryList) {
            Intrinsics.checkNotNullParameter(messageLogEntryList, "messageLogEntryList");
            this.state = MessageLogState.copy$default(this.state, messageLogEntryList, false, null, false, false, false, null, null, null, 510, null);
            return this;
        }

        public final Builder mapOfDisplayedFields(Map<String, DisplayedForm> mapOfDisplayedFields) {
            Intrinsics.checkNotNullParameter(mapOfDisplayedFields, "mapOfDisplayedFields");
            this.state = MessageLogState.copy$default(this.state, null, false, mapOfDisplayedFields, false, false, false, null, null, null, HttpStatus.SC_INSUFFICIENT_STORAGE, null);
            return this;
        }

        public final Builder shouldScrollToBottom(boolean shouldScrollToBottom) {
            this.state = MessageLogState.copy$default(this.state, null, shouldScrollToBottom, null, false, false, false, null, null, null, 509, null);
            return this;
        }

        public final Builder shouldAnnounceMessage(boolean shouldAnnounceMessage) {
            this.state = MessageLogState.copy$default(this.state, null, false, null, shouldAnnounceMessage, false, false, null, null, null, HttpStatus.SC_SERVICE_UNAVAILABLE, null);
            return this;
        }

        public final Builder shouldSeeLatestViewVisible(boolean shouldSeeLatestViewVisible) {
            this.state = MessageLogState.copy$default(this.state, null, false, null, false, shouldSeeLatestViewVisible, false, null, null, null, 495, null);
            return this;
        }

        public final MessageLogState getState() {
            return this.state;
        }
    }
}
