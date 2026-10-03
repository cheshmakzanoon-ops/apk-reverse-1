package zendesk.messaging.android.internal.extension;

import androidx.fragment.app.Fragment;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.conversationscreen.ConversationFragment;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment;
import zendesk.messaging.android.internal.messagingscreen.MessagingFragmentScreen;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\u001a\u0014\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0000\u001a\f\u0010\u0005\u001a\u00020\u0004*\u00020\u0002H\u0000¨\u0006\u0006"}, m18d2 = {"getInstance", "Landroidx/fragment/app/Fragment;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "credentials", "", "getTagName", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingFragmentScreenKtxKt {
    public static final Fragment getInstance(MessagingFragmentScreen messagingFragmentScreen, String credentials) {
        Intrinsics.checkNotNullParameter(messagingFragmentScreen, "<this>");
        Intrinsics.checkNotNullParameter(credentials, "credentials");
        if (messagingFragmentScreen instanceof MessagingFragmentScreen.ConversationFragmentScreen) {
            MessagingFragmentScreen.ConversationFragmentScreen conversationFragmentScreen = (MessagingFragmentScreen.ConversationFragmentScreen) messagingFragmentScreen;
            return ConversationFragment.INSTANCE.newInstance(credentials, conversationFragmentScreen.getConversationId(), conversationFragmentScreen.getProactiveId());
        }
        return ConversationListFragment.INSTANCE.newInstance(credentials);
    }

    public static final String getTagName(MessagingFragmentScreen messagingFragmentScreen) {
        Intrinsics.checkNotNullParameter(messagingFragmentScreen, "<this>");
        if (messagingFragmentScreen instanceof MessagingFragmentScreen.ConversationFragmentScreen) {
            return "ConversationFragment";
        }
        return ConversationListFragment.NAME;
    }
}
