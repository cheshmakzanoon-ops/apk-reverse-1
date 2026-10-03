package zendesk.messaging.android.internal.conversationslistscreen.p022di;

import androidx.appcompat.app.AppCompatActivity;
import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModelFactory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J(\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0007¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/di/ConversationsListScreenModule;", "", "()V", "providesConversationsListScreenViewModel", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModelFactory;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "activity", "Landroidx/appcompat/app/AppCompatActivity;", "repository", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationsListRepository;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class ConversationsListScreenModule {
    @Provides
    @ConversationListActivityScope
    public final ConversationsListScreenViewModelFactory providesConversationsListScreenViewModel(MessagingSettings messagingSettings, ConversationKit conversationKit, AppCompatActivity activity, ConversationsListRepository repository) {
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(activity, "activity");
        Intrinsics.checkNotNullParameter(repository, "repository");
        return new ConversationsListScreenViewModelFactory(messagingSettings, conversationKit, activity, null, repository, VisibleScreenTracker.INSTANCE, 8, null);
    }
}
