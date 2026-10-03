package zendesk.messaging.android.internal.conversationslistscreen;

import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0006\u0002\u0003\u0004\u0005\u0006\u0007\u0082\u0001\u0006\b\t\n\u000b\f\r¨\u0006\u000e"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "", "CreateConversation", "DismissCreateConversationError", "LoadConversations", "ResetLoadMoreStatus", "ResetReceivedMessageAuthor", "Retry", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$CreateConversation;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$DismissCreateConversationError;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$LoadConversations;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$ResetLoadMoreStatus;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$ResetReceivedMessageAuthor;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$Retry;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationsListScreenActions {

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$LoadConversations;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadConversations implements ConversationsListScreenActions {
        public static final LoadConversations INSTANCE = new LoadConversations();

        private LoadConversations() {
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$CreateConversation;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CreateConversation implements ConversationsListScreenActions {
        public static final CreateConversation INSTANCE = new CreateConversation();

        private CreateConversation() {
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$DismissCreateConversationError;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DismissCreateConversationError implements ConversationsListScreenActions {
        public static final DismissCreateConversationError INSTANCE = new DismissCreateConversationError();

        private DismissCreateConversationError() {
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$Retry;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Retry implements ConversationsListScreenActions {
        public static final Retry INSTANCE = new Retry();

        private Retry() {
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$ResetLoadMoreStatus;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ResetLoadMoreStatus implements ConversationsListScreenActions {
        public static final ResetLoadMoreStatus INSTANCE = new ResetLoadMoreStatus();

        private ResetLoadMoreStatus() {
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions$ResetReceivedMessageAuthor;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenActions;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ResetReceivedMessageAuthor implements ConversationsListScreenActions {
        public static final ResetReceivedMessageAuthor INSTANCE = new ResetReceivedMessageAuthor();

        private ResetReceivedMessageAuthor() {
        }
    }
}
