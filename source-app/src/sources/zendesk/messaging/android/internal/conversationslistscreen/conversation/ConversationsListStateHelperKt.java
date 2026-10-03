package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ExtensionsKt;
import kotlinx.collections.immutable.ImmutableList;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenState;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListState;
import zendesk.messaging.android.internal.conversationslistscreen.CreateConversationState;

@Metadata(m17d1 = {"\u0000L\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0003\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\u001a\u0018\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0002\u001a\u00020\u0005H\u0000\u001a\u001e\u0010\u0006\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007H\u0000\u001aB\u0010\t\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000b2\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\f2\u0006\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0011\u001a\u00020\u0012H\u0000\u001a\"\u0010\u0013\u001a\u00020\u00032\b\u0010\u0014\u001a\u0004\u0018\u00010\u00152\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000bH\u0000\u001a\u0018\u0010\u0016\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000bH\u0000\u001a\u0018\u0010\u0017\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0018\u001a\u00020\u0019H\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u001a"}, m18d2 = {"LOG_TAG", "", "connectionStatus", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "conversationsListScreenState", "Lzendesk/conversationkit/android/ConnectionStatus;", "conversationsList", "Lkotlinx/collections/immutable/ImmutableList;", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "conversationsListWithListState", "conversationsListState", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListState;", "", "shouldLoadMore", "", "currentPaginationOffset", "", "loadMoreStatus", "Lzendesk/core/ui/android/internal/model/ConversationEntry$LoadMoreStatus;", "errorState", "cause", "", "listState", "updateCreateConversationState", "createConversationState", "Lzendesk/messaging/android/internal/conversationslistscreen/CreateConversationState;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListStateHelperKt {
    private static final String LOG_TAG = "ConversationsListStateHelper";

    public static final ConversationsListScreenState errorState(Throwable th, ConversationsListScreenState conversationsListScreenState, ConversationsListState conversationsListState) {
        Intrinsics.checkNotNullParameter(conversationsListScreenState, "conversationsListScreenState");
        Intrinsics.checkNotNullParameter(conversationsListState, "conversationsListState");
        ConversationsListScreenState conversationsListScreenStateListState = listState(conversationsListScreenState, conversationsListState);
        Logger.m218e(LOG_TAG, "errorState", th, new Object[0]);
        return conversationsListScreenStateListState;
    }

    public static final ConversationsListScreenState conversationsList(ConversationsListScreenState conversationsListScreenState, ImmutableList<? extends ConversationEntry> conversationsList) {
        Intrinsics.checkNotNullParameter(conversationsListScreenState, "conversationsListScreenState");
        Intrinsics.checkNotNullParameter(conversationsList, "conversationsList");
        ConversationsListScreenState conversationsListScreenStateCopy = conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : conversationsList, (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null);
        Logger.m217d(LOG_TAG, "conversationsList update", new Object[0]);
        return conversationsListScreenStateCopy;
    }

    public static ConversationsListScreenState conversationsListWithListState$default(ConversationsListScreenState conversationsListScreenState, ConversationsListState conversationsListState, List list, boolean z, int i, ConversationEntry.LoadMoreStatus loadMoreStatus, int i2, Object obj) {
        if ((i2 & 16) != 0) {
            i = 0;
        }
        int i3 = i;
        if ((i2 & 32) != 0) {
            loadMoreStatus = ConversationEntry.LoadMoreStatus.NONE;
        }
        return conversationsListWithListState(conversationsListScreenState, conversationsListState, list, z, i3, loadMoreStatus);
    }

    public static final ConversationsListScreenState conversationsListWithListState(ConversationsListScreenState conversationsListScreenState, ConversationsListState conversationsListState, List<? extends ConversationEntry> conversationsList, boolean z, int i, ConversationEntry.LoadMoreStatus loadMoreStatus) {
        Intrinsics.checkNotNullParameter(conversationsListScreenState, "conversationsListScreenState");
        Intrinsics.checkNotNullParameter(conversationsListState, "conversationsListState");
        Intrinsics.checkNotNullParameter(conversationsList, "conversationsList");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        ConversationsListScreenState conversationsListScreenStateCopy = conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : ExtensionsKt.toImmutableList(conversationsList), (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : conversationsListState, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : z, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : i, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : loadMoreStatus, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null);
        Logger.m217d(LOG_TAG, "conversationsList with listState: " + conversationsListState, new Object[0]);
        return conversationsListScreenStateCopy;
    }

    public static final ConversationsListScreenState listState(ConversationsListScreenState conversationsListScreenState, ConversationsListState conversationsListState) {
        Intrinsics.checkNotNullParameter(conversationsListScreenState, "conversationsListScreenState");
        Intrinsics.checkNotNullParameter(conversationsListState, "conversationsListState");
        ConversationsListScreenState conversationsListScreenStateCopy = conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : null, (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : conversationsListState, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null);
        Logger.m217d(LOG_TAG, "listState: " + conversationsListState, new Object[0]);
        return conversationsListScreenStateCopy;
    }

    public static final ConversationsListScreenState connectionStatus(ConversationsListScreenState conversationsListScreenState, ConnectionStatus connectionStatus) {
        Intrinsics.checkNotNullParameter(conversationsListScreenState, "conversationsListScreenState");
        Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
        ConversationsListScreenState conversationsListScreenStateCopy = conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : null, (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : connectionStatus, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : null, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null);
        Logger.m217d(LOG_TAG, "ConnectionStatusChanged received: " + connectionStatus, new Object[0]);
        return conversationsListScreenStateCopy;
    }

    public static final ConversationsListScreenState updateCreateConversationState(ConversationsListScreenState conversationsListScreenState, CreateConversationState createConversationState) {
        Intrinsics.checkNotNullParameter(conversationsListScreenState, "conversationsListScreenState");
        Intrinsics.checkNotNullParameter(createConversationState, "createConversationState");
        ConversationsListScreenState conversationsListScreenStateCopy = conversationsListScreenState.copy((32639 & 1) != 0 ? conversationsListScreenState.messagingTheme : null, (32639 & 2) != 0 ? conversationsListScreenState.title : null, (32639 & 4) != 0 ? conversationsListScreenState.description : null, (32639 & 8) != 0 ? conversationsListScreenState.logoUrl : null, (32639 & 16) != 0 ? conversationsListScreenState.isMultiConvoEnabled : false, (32639 & 32) != 0 ? conversationsListScreenState.canUserCreateMoreConversations : false, (32639 & 64) != 0 ? conversationsListScreenState.conversations : null, (32639 & 128) != 0 ? conversationsListScreenState.connectionStatus : null, (32639 & 256) != 0 ? conversationsListScreenState.showDeniedPermission : false, (32639 & 512) != 0 ? conversationsListScreenState.createConversationState : createConversationState, (32639 & 1024) != 0 ? conversationsListScreenState.conversationsListState : null, (32639 & 2048) != 0 ? conversationsListScreenState.shouldLoadMore : false, (32639 & 4096) != 0 ? conversationsListScreenState.currentPaginationOffset : 0, (32639 & 8192) != 0 ? conversationsListScreenState.loadMoreStatus : null, (32639 & 16384) != 0 ? conversationsListScreenState.receivedMessageAuthor : null);
        Logger.m217d(LOG_TAG, "Create New Conversation State: " + createConversationState, new Object[0]);
        return conversationsListScreenStateCopy;
    }
}
