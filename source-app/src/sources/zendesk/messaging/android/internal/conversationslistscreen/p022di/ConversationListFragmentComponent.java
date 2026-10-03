package zendesk.messaging.android.internal.conversationslistscreen.p022di;

import androidx.appcompat.app.AppCompatActivity;
import dagger.BindsInstance;
import dagger.Subcomponent;
import kotlin.Metadata;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationListFragment;
import zendesk.messaging.android.internal.messagingscreen.p024di.MessagingNavigatorModule;

@ConversationListActivityScope
@Subcomponent(modules = {ConversationsListScreenModule.class, ConversationsListLocalStorageModule.class, MessagingNavigatorModule.class})
@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\ba\u0018\u00002\u00020\u0001:\u0001\u0006J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H&¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/di/ConversationListFragmentComponent;", "", "inject", "", "conversationsListFragment", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationListFragment;", "Factory", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationListFragmentComponent {

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J\u0012\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u0005H&¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/di/ConversationListFragmentComponent$Factory;", "", "create", "Lzendesk/messaging/android/internal/conversationslistscreen/di/ConversationListFragmentComponent;", "activity", "Landroidx/appcompat/app/AppCompatActivity;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Subcomponent.Factory
    public interface Factory {
        ConversationListFragmentComponent create(@BindsInstance AppCompatActivity activity);
    }

    void inject(ConversationListFragment conversationsListFragment);
}
