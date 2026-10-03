package zendesk.messaging.android.internal.conversationscreen.conversationextension.p019di;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionViewModelFactory;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u001a\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\bH\u0007¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/conversationextension/di/ConversationExtensionModule;", "", "()V", "providesConversationExtensionViewModelFactory", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/ConversationExtensionViewModelFactory;", "savedStateRegistryOwner", "Landroidx/savedstate/SavedStateRegistryOwner;", "defaultArgs", "Landroid/os/Bundle;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class ConversationExtensionModule {
    @Provides
    public final ConversationExtensionViewModelFactory providesConversationExtensionViewModelFactory(SavedStateRegistryOwner savedStateRegistryOwner, Bundle defaultArgs) {
        Intrinsics.checkNotNullParameter(savedStateRegistryOwner, "savedStateRegistryOwner");
        return new ConversationExtensionViewModelFactory(savedStateRegistryOwner, defaultArgs);
    }
}
