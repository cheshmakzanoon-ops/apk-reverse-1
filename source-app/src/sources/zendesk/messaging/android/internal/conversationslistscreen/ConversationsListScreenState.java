package zendesk.messaging.android.internal.conversationslistscreen;

import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ExtensionsKt;
import kotlinx.collections.immutable.ImmutableList;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b.\b\u0080\b\u0018\u00002\u00020\u0001B¥\u0001\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0007\u001a\u00020\u0005\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t\u0012\u000e\b\u0002\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f\u0012\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f\u0012\b\b\u0002\u0010\u0010\u001a\u00020\t\u0012\b\b\u0002\u0010\u0011\u001a\u00020\u0012\u0012\b\b\u0002\u0010\u0013\u001a\u00020\u0014\u0012\b\b\u0002\u0010\u0015\u001a\u00020\t\u0012\b\b\u0002\u0010\u0016\u001a\u00020\u0017\u0012\b\b\u0002\u0010\u0018\u001a\u00020\u0019\u0012\n\b\u0002\u0010\u001a\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u001bJ\t\u00103\u001a\u00020\u0003HÆ\u0003J\t\u00104\u001a\u00020\u0012HÆ\u0003J\t\u00105\u001a\u00020\u0014HÆ\u0003J\t\u00106\u001a\u00020\tHÆ\u0003J\t\u00107\u001a\u00020\u0017HÆ\u0003J\t\u00108\u001a\u00020\u0019HÆ\u0003J\u000b\u00109\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010:\u001a\u00020\u0005HÆ\u0003J\t\u0010;\u001a\u00020\u0005HÆ\u0003J\t\u0010<\u001a\u00020\u0005HÆ\u0003J\t\u0010=\u001a\u00020\tHÆ\u0003J\t\u0010>\u001a\u00020\tHÆ\u0003J\u000f\u0010?\u001a\b\u0012\u0004\u0012\u00020\r0\fHÆ\u0003J\u000b\u0010@\u001a\u0004\u0018\u00010\u000fHÆ\u0003J\t\u0010A\u001a\u00020\tHÆ\u0003J©\u0001\u0010B\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\t2\u000e\b\u0002\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\t2\b\b\u0002\u0010\u0011\u001a\u00020\u00122\b\b\u0002\u0010\u0013\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\t2\b\b\u0002\u0010\u0016\u001a\u00020\u00172\b\b\u0002\u0010\u0018\u001a\u00020\u00192\n\b\u0002\u0010\u001a\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010C\u001a\u00020\t2\b\u0010D\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010E\u001a\u00020\u0017HÖ\u0001J\t\u0010F\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\n\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0013\u0010\u000e\u001a\u0004\u0018\u00010\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0017\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R\u0011\u0010\u0013\u001a\u00020\u0014¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010#R\u0011\u0010\u0011\u001a\u00020\u0012¢\u0006\b\n\u0000\u001a\u0004\b$\u0010%R\u0011\u0010\u0016\u001a\u00020\u0017¢\u0006\b\n\u0000\u001a\u0004\b&\u0010'R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b(\u0010)R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u001dR\u0011\u0010\u0018\u001a\u00020\u0019¢\u0006\b\n\u0000\u001a\u0004\b*\u0010+R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b,\u0010)R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b-\u0010.R\u0013\u0010\u001a\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b/\u0010)R\u0011\u0010\u0015\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b0\u0010\u001dR\u0011\u0010\u0010\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b1\u0010\u001dR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b2\u0010)¨\u0006G"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "title", "", "description", "logoUrl", "isMultiConvoEnabled", "", "canUserCreateMoreConversations", "conversations", "Lkotlinx/collections/immutable/ImmutableList;", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "showDeniedPermission", "createConversationState", "Lzendesk/messaging/android/internal/conversationslistscreen/CreateConversationState;", "conversationsListState", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListState;", "shouldLoadMore", "currentPaginationOffset", "", "loadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "receivedMessageAuthor", "(Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZLkotlinx/collections/immutable/ImmutableList;Lzendesk/conversationkit/android/ConnectionStatus;ZLzendesk/messaging/android/internal/conversationslistscreen/CreateConversationState;Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListState;ZILzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;Ljava/lang/String;)V", "getCanUserCreateMoreConversations", "()Z", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "getConversations", "()Lkotlinx/collections/immutable/ImmutableList;", "getConversationsListState", "()Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListState;", "getCreateConversationState", "()Lzendesk/messaging/android/internal/conversationslistscreen/CreateConversationState;", "getCurrentPaginationOffset", "()I", "getDescription", "()Ljava/lang/String;", "getLoadMoreStatus", "()Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "getLogoUrl", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getReceivedMessageAuthor", "getShouldLoadMore", "getShowDeniedPermission", "getTitle", "component1", "component10", "component11", "component12", "component13", "component14", "component15", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "other", "hashCode", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListScreenState {
    private final boolean canUserCreateMoreConversations;
    private final ConnectionStatus connectionStatus;
    private final ImmutableList<ConversationEntry> conversations;
    private final ConversationsListState conversationsListState;
    private final CreateConversationState createConversationState;
    private final int currentPaginationOffset;
    private final String description;
    private final boolean isMultiConvoEnabled;
    private final ConversationEntry.LoadMoreStatus loadMoreStatus;
    private final String logoUrl;
    private final MessagingTheme messagingTheme;
    private final String receivedMessageAuthor;
    private final boolean shouldLoadMore;
    private final boolean showDeniedPermission;
    private final String title;

    public ConversationsListScreenState() {
        this(null, null, null, null, false, false, null, null, false, null, null, false, 0, null, null, 32767, null);
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final CreateConversationState getCreateConversationState() {
        return this.createConversationState;
    }

    public final ConversationsListState getConversationsListState() {
        return this.conversationsListState;
    }

    public final boolean getShouldLoadMore() {
        return this.shouldLoadMore;
    }

    public final int getCurrentPaginationOffset() {
        return this.currentPaginationOffset;
    }

    public final ConversationEntry.LoadMoreStatus getLoadMoreStatus() {
        return this.loadMoreStatus;
    }

    public final String getReceivedMessageAuthor() {
        return this.receivedMessageAuthor;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getLogoUrl() {
        return this.logoUrl;
    }

    public final boolean getIsMultiConvoEnabled() {
        return this.isMultiConvoEnabled;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final ImmutableList<ConversationEntry> component7() {
        return this.conversations;
    }

    public final ConnectionStatus getConnectionStatus() {
        return this.connectionStatus;
    }

    public final boolean getShowDeniedPermission() {
        return this.showDeniedPermission;
    }

    public final ConversationsListScreenState copy(MessagingTheme messagingTheme, String title, String description, String logoUrl, boolean isMultiConvoEnabled, boolean canUserCreateMoreConversations, ImmutableList<? extends ConversationEntry> conversations, ConnectionStatus connectionStatus, boolean showDeniedPermission, CreateConversationState createConversationState, ConversationsListState conversationsListState, boolean shouldLoadMore, int currentPaginationOffset, ConversationEntry.LoadMoreStatus loadMoreStatus, String receivedMessageAuthor) {
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(description, "description");
        Intrinsics.checkNotNullParameter(logoUrl, "logoUrl");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(createConversationState, "createConversationState");
        Intrinsics.checkNotNullParameter(conversationsListState, "conversationsListState");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        return new ConversationsListScreenState(messagingTheme, title, description, logoUrl, isMultiConvoEnabled, canUserCreateMoreConversations, conversations, connectionStatus, showDeniedPermission, createConversationState, conversationsListState, shouldLoadMore, currentPaginationOffset, loadMoreStatus, receivedMessageAuthor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationsListScreenState)) {
            return false;
        }
        ConversationsListScreenState conversationsListScreenState = (ConversationsListScreenState) other;
        return Intrinsics.areEqual(this.messagingTheme, conversationsListScreenState.messagingTheme) && Intrinsics.areEqual(this.title, conversationsListScreenState.title) && Intrinsics.areEqual(this.description, conversationsListScreenState.description) && Intrinsics.areEqual(this.logoUrl, conversationsListScreenState.logoUrl) && this.isMultiConvoEnabled == conversationsListScreenState.isMultiConvoEnabled && this.canUserCreateMoreConversations == conversationsListScreenState.canUserCreateMoreConversations && Intrinsics.areEqual(this.conversations, conversationsListScreenState.conversations) && this.connectionStatus == conversationsListScreenState.connectionStatus && this.showDeniedPermission == conversationsListScreenState.showDeniedPermission && this.createConversationState == conversationsListScreenState.createConversationState && this.conversationsListState == conversationsListScreenState.conversationsListState && this.shouldLoadMore == conversationsListScreenState.shouldLoadMore && this.currentPaginationOffset == conversationsListScreenState.currentPaginationOffset && this.loadMoreStatus == conversationsListScreenState.loadMoreStatus && Intrinsics.areEqual(this.receivedMessageAuthor, conversationsListScreenState.receivedMessageAuthor);
    }

    public int hashCode() {
        int iHashCode = ((((((((((((this.messagingTheme.hashCode() * 31) + this.title.hashCode()) * 31) + this.description.hashCode()) * 31) + this.logoUrl.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isMultiConvoEnabled)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.canUserCreateMoreConversations)) * 31) + this.conversations.hashCode()) * 31;
        ConnectionStatus connectionStatus = this.connectionStatus;
        int iHashCode2 = (((((((((((((iHashCode + (connectionStatus == null ? 0 : connectionStatus.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showDeniedPermission)) * 31) + this.createConversationState.hashCode()) * 31) + this.conversationsListState.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldLoadMore)) * 31) + this.currentPaginationOffset) * 31) + this.loadMoreStatus.hashCode()) * 31;
        String str = this.receivedMessageAuthor;
        return iHashCode2 + (str != null ? str.hashCode() : 0);
    }

    public String toString() {
        return "ConversationsListScreenState(messagingTheme=" + this.messagingTheme + ", title=" + this.title + ", description=" + this.description + ", logoUrl=" + this.logoUrl + ", isMultiConvoEnabled=" + this.isMultiConvoEnabled + ", canUserCreateMoreConversations=" + this.canUserCreateMoreConversations + ", conversations=" + this.conversations + ", connectionStatus=" + this.connectionStatus + ", showDeniedPermission=" + this.showDeniedPermission + ", createConversationState=" + this.createConversationState + ", conversationsListState=" + this.conversationsListState + ", shouldLoadMore=" + this.shouldLoadMore + ", currentPaginationOffset=" + this.currentPaginationOffset + ", loadMoreStatus=" + this.loadMoreStatus + ", receivedMessageAuthor=" + this.receivedMessageAuthor + ')';
    }

    public ConversationsListScreenState(MessagingTheme messagingTheme, String title, String description, String logoUrl, boolean z, boolean z2, ImmutableList<? extends ConversationEntry> conversations, ConnectionStatus connectionStatus, boolean z3, CreateConversationState createConversationState, ConversationsListState conversationsListState, boolean z4, int i, ConversationEntry.LoadMoreStatus loadMoreStatus, String str) {
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(description, "description");
        Intrinsics.checkNotNullParameter(logoUrl, "logoUrl");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(createConversationState, "createConversationState");
        Intrinsics.checkNotNullParameter(conversationsListState, "conversationsListState");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        this.messagingTheme = messagingTheme;
        this.title = title;
        this.description = description;
        this.logoUrl = logoUrl;
        this.isMultiConvoEnabled = z;
        this.canUserCreateMoreConversations = z2;
        this.conversations = conversations;
        this.connectionStatus = connectionStatus;
        this.showDeniedPermission = z3;
        this.createConversationState = createConversationState;
        this.conversationsListState = conversationsListState;
        this.shouldLoadMore = z4;
        this.currentPaginationOffset = i;
        this.loadMoreStatus = loadMoreStatus;
        this.receivedMessageAuthor = str;
    }

    public ConversationsListScreenState(MessagingTheme messagingTheme, String str, String str2, String str3, boolean z, boolean z2, ImmutableList immutableList, ConnectionStatus connectionStatus, boolean z3, CreateConversationState createConversationState, ConversationsListState conversationsListState, boolean z4, int i, ConversationEntry.LoadMoreStatus loadMoreStatus, String str4, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this((i2 & 1) != 0 ? MessagingTheme.INSTANCE.getDEFAULT() : messagingTheme, (i2 & 2) != 0 ? "" : str, (i2 & 4) != 0 ? "" : str2, (i2 & 8) == 0 ? str3 : "", (i2 & 16) != 0 ? false : z, (i2 & 32) != 0 ? false : z2, (i2 & 64) != 0 ? ExtensionsKt.persistentListOf() : immutableList, (i2 & 128) != 0 ? null : connectionStatus, (i2 & 256) != 0 ? false : z3, (i2 & 512) != 0 ? CreateConversationState.IDLE : createConversationState, (i2 & 1024) != 0 ? ConversationsListState.IDLE : conversationsListState, (i2 & 2048) != 0 ? false : z4, (i2 & 4096) == 0 ? i : 0, (i2 & 8192) != 0 ? ConversationEntry.LoadMoreStatus.NONE : loadMoreStatus, (i2 & 16384) == 0 ? str4 : null);
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getLogoUrl() {
        return this.logoUrl;
    }

    public final boolean isMultiConvoEnabled() {
        return this.isMultiConvoEnabled;
    }

    public final boolean getCanUserCreateMoreConversations() {
        return this.canUserCreateMoreConversations;
    }

    public final ImmutableList<ConversationEntry> getConversations() {
        return this.conversations;
    }

    public final ConnectionStatus getConnectionStatus() {
        return this.connectionStatus;
    }

    public final boolean getShowDeniedPermission() {
        return this.showDeniedPermission;
    }

    public final CreateConversationState getCreateConversationState() {
        return this.createConversationState;
    }

    public final ConversationsListState getConversationsListState() {
        return this.conversationsListState;
    }

    public final boolean getShouldLoadMore() {
        return this.shouldLoadMore;
    }

    public final int getCurrentPaginationOffset() {
        return this.currentPaginationOffset;
    }

    public final ConversationEntry.LoadMoreStatus getLoadMoreStatus() {
        return this.loadMoreStatus;
    }

    public final String getReceivedMessageAuthor() {
        return this.receivedMessageAuthor;
    }
}
