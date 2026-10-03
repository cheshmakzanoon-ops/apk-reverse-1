package zendesk.messaging.android.internal.conversationslistscreen;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.AbstractSavedStateViewModelFactory;
import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;
import androidx.savedstate.SavedStateRegistryOwner;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository;

@Metadata(m17d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B9\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ5\u0010\u000f\u001a\u0002H\u0010\"\b\b\u0000\u0010\u0010*\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\f\u0010\u0014\u001a\b\u0012\u0004\u0012\u0002H\u00100\u00152\u0006\u0010\u0016\u001a\u00020\u0017H\u0014¢\u0006\u0002\u0010\u0018R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0019"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenViewModelFactory;", "Landroidx/lifecycle/AbstractSavedStateViewModelFactory;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "activity", "Landroidx/appcompat/app/AppCompatActivity;", "defaultArgs", "Landroid/os/Bundle;", "repository", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationsListRepository;", "visibleScreenTracker", "Lzendesk/messaging/android/internal/VisibleScreenTracker;", "(Lzendesk/android/messaging/model/MessagingSettings;Lzendesk/conversationkit/android/ConversationKit;Landroidx/appcompat/app/AppCompatActivity;Landroid/os/Bundle;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/ConversationsListRepository;Lzendesk/messaging/android/internal/VisibleScreenTracker;)V", "create", "T", "Landroidx/lifecycle/ViewModel;", "key", "", "modelClass", "Ljava/lang/Class;", "savedStateHandle", "Landroidx/lifecycle/SavedStateHandle;", "(Ljava/lang/String;Ljava/lang/Class;Landroidx/lifecycle/SavedStateHandle;)Landroidx/lifecycle/ViewModel;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListScreenViewModelFactory extends AbstractSavedStateViewModelFactory {
    private final ConversationKit conversationKit;
    private final MessagingSettings messagingSettings;
    private final ConversationsListRepository repository;
    private final VisibleScreenTracker visibleScreenTracker;

    public ConversationsListScreenViewModelFactory(MessagingSettings messagingSettings, ConversationKit conversationKit, AppCompatActivity appCompatActivity, Bundle bundle, ConversationsListRepository conversationsListRepository, VisibleScreenTracker visibleScreenTracker, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(messagingSettings, conversationKit, appCompatActivity, (i & 8) != 0 ? null : bundle, conversationsListRepository, visibleScreenTracker);
    }

    public ConversationsListScreenViewModelFactory(MessagingSettings messagingSettings, ConversationKit conversationKit, AppCompatActivity activity, Bundle bundle, ConversationsListRepository repository, VisibleScreenTracker visibleScreenTracker) {
        super((SavedStateRegistryOwner) activity, bundle);
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(activity, "activity");
        Intrinsics.checkNotNullParameter(repository, "repository");
        Intrinsics.checkNotNullParameter(visibleScreenTracker, "visibleScreenTracker");
        this.messagingSettings = messagingSettings;
        this.conversationKit = conversationKit;
        this.repository = repository;
        this.visibleScreenTracker = visibleScreenTracker;
    }

    protected <T extends ViewModel> T create(String key, Class<T> modelClass, SavedStateHandle savedStateHandle) {
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.checkNotNullParameter(modelClass, "modelClass");
        Intrinsics.checkNotNullParameter(savedStateHandle, "savedStateHandle");
        return new ConversationsListScreenViewModel(this.messagingSettings, this.conversationKit, savedStateHandle, this.repository, this.visibleScreenTracker);
    }
}
