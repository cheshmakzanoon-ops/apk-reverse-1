package zendesk.messaging.android.internal.conversationslistscreen.list;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001:\u0001 B)\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\u0014\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÀ\u0003¢\u0006\u0002\b\u0011J\u000e\u0010\u0012\u001a\u00020\u0006HÀ\u0003¢\u0006\u0002\b\u0013J\u000e\u0010\u0014\u001a\u00020\bHÀ\u0003¢\u0006\u0002\b\u0015J-\u0010\u0016\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0017\u001a\u00020\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001a\u001a\u00020\u001bHÖ\u0001J\u0006\u0010\u001c\u001a\u00020\u001dJ\t\u0010\u001e\u001a\u00020\u001fHÖ\u0001R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0014\u0010\u0007\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006!"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;", "", "conversations", "", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "loadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "(Ljava/util/List;Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "getConversations$zendesk_messaging_messaging_android", "()Ljava/util/List;", "getLoadMoreStatus$zendesk_messaging_messaging_android", "()Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "getMessagingTheme$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "component1", "component1$zendesk_messaging_messaging_android", "component2", "component2$zendesk_messaging_messaging_android", "component3", "component3$zendesk_messaging_messaging_android", "copy", "equals", "", "other", "hashCode", "", "toBuilder", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState$Builder;", "toString", "", "Builder", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListState {
    private final List<ConversationEntry> conversations;
    private final ConversationEntry.LoadMoreStatus loadMoreStatus;
    private final MessagingTheme messagingTheme;

    public ConversationsListState() {
        this(null, null, null, 7, null);
    }

    public static ConversationsListState copy$default(ConversationsListState conversationsListState, List list, ConversationEntry.LoadMoreStatus loadMoreStatus, MessagingTheme messagingTheme, int i, Object obj) {
        if ((i & 1) != 0) {
            list = conversationsListState.conversations;
        }
        if ((i & 2) != 0) {
            loadMoreStatus = conversationsListState.loadMoreStatus;
        }
        if ((i & 4) != 0) {
            messagingTheme = conversationsListState.messagingTheme;
        }
        return conversationsListState.copy(list, loadMoreStatus, messagingTheme);
    }

    public final List<ConversationEntry> component1$zendesk_messaging_messaging_android() {
        return this.conversations;
    }

    public final ConversationEntry.LoadMoreStatus getLoadMoreStatus() {
        return this.loadMoreStatus;
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final ConversationsListState copy(List<? extends ConversationEntry> conversations, ConversationEntry.LoadMoreStatus loadMoreStatus, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        return new ConversationsListState(conversations, loadMoreStatus, messagingTheme);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationsListState)) {
            return false;
        }
        ConversationsListState conversationsListState = (ConversationsListState) other;
        return Intrinsics.areEqual(this.conversations, conversationsListState.conversations) && this.loadMoreStatus == conversationsListState.loadMoreStatus && Intrinsics.areEqual(this.messagingTheme, conversationsListState.messagingTheme);
    }

    public int hashCode() {
        return (((this.conversations.hashCode() * 31) + this.loadMoreStatus.hashCode()) * 31) + this.messagingTheme.hashCode();
    }

    public String toString() {
        return "ConversationsListState(conversations=" + this.conversations + ", loadMoreStatus=" + this.loadMoreStatus + ", messagingTheme=" + this.messagingTheme + ')';
    }

    public ConversationsListState(List<? extends ConversationEntry> conversations, ConversationEntry.LoadMoreStatus loadMoreStatus, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        this.conversations = conversations;
        this.loadMoreStatus = loadMoreStatus;
        this.messagingTheme = messagingTheme;
    }

    public ConversationsListState(List list, ConversationEntry.LoadMoreStatus loadMoreStatus, MessagingTheme messagingTheme, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? CollectionsKt.emptyList() : list, (i & 2) != 0 ? ConversationEntry.LoadMoreStatus.NONE : loadMoreStatus, (i & 4) != 0 ? MessagingTheme.INSTANCE.getDEFAULT() : messagingTheme);
    }

    public final List<ConversationEntry> getConversations$zendesk_messaging_messaging_android() {
        return this.conversations;
    }

    public final ConversationEntry.LoadMoreStatus getLoadMoreStatus$zendesk_messaging_messaging_android() {
        return this.loadMoreStatus;
    }

    public final MessagingTheme getMessagingTheme$zendesk_messaging_messaging_android() {
        return this.messagingTheme;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u0014\u0010\u0007\u001a\u00020\u00002\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\tJ\u000e\u0010\u000b\u001a\u00020\u00002\u0006\u0010\u000b\u001a\u00020\fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState$Builder;", "", "state", "Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;", "(Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationsListState;)V", "()V", "build", "listConversations", "conversations", "", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "loadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        private ConversationsListState state;

        public Builder() {
            this.state = new ConversationsListState(null, null, null, 7, null);
        }

        public Builder(ConversationsListState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder listConversations(List<? extends ConversationEntry> conversations) {
            Intrinsics.checkNotNullParameter(conversations, "conversations");
            this.state = ConversationsListState.copy$default(this.state, conversations, null, null, 6, null);
            return this;
        }

        public final Builder loadMoreStatus(ConversationEntry.LoadMoreStatus loadMoreStatus) {
            Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
            this.state = ConversationsListState.copy$default(this.state, null, loadMoreStatus, null, 5, null);
            return this;
        }

        public final ConversationsListState getState() {
            return this.state;
        }
    }
}
