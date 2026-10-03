package zendesk.messaging.android.internal.messagingscreen;

import android.os.Bundle;
import androidx.lifecycle.AbstractSavedStateViewModelFactory;
import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;
import androidx.savedstate.SavedStateRegistryOwner;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.messaging.android.internal.MessagingEntryPointHandler;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B!\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bJ5\u0010\t\u001a\u0002H\n\"\b\b\u0000\u0010\n*\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u0002H\n0\u000f2\u0006\u0010\u0010\u001a\u00020\u0011H\u0014¢\u0006\u0002\u0010\u0012R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenViewModelFactory;", "Landroidx/lifecycle/AbstractSavedStateViewModelFactory;", "messagingEntryPointHandler", "Lzendesk/messaging/android/internal/MessagingEntryPointHandler;", "owner", "Landroidx/savedstate/SavedStateRegistryOwner;", "defaultArgs", "Landroid/os/Bundle;", "(Lzendesk/messaging/android/internal/MessagingEntryPointHandler;Landroidx/savedstate/SavedStateRegistryOwner;Landroid/os/Bundle;)V", "create", "T", "Landroidx/lifecycle/ViewModel;", "key", "", "modelClass", "Ljava/lang/Class;", "handle", "Landroidx/lifecycle/SavedStateHandle;", "(Ljava/lang/String;Ljava/lang/Class;Landroidx/lifecycle/SavedStateHandle;)Landroidx/lifecycle/ViewModel;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingScreenViewModelFactory extends AbstractSavedStateViewModelFactory {
    private final MessagingEntryPointHandler messagingEntryPointHandler;

    public MessagingScreenViewModelFactory(MessagingEntryPointHandler messagingEntryPointHandler, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(messagingEntryPointHandler, savedStateRegistryOwner, (i & 4) != 0 ? null : bundle);
    }

    public MessagingScreenViewModelFactory(MessagingEntryPointHandler messagingEntryPointHandler, SavedStateRegistryOwner owner, Bundle bundle) {
        super(owner, bundle);
        Intrinsics.checkNotNullParameter(messagingEntryPointHandler, "messagingEntryPointHandler");
        Intrinsics.checkNotNullParameter(owner, "owner");
        this.messagingEntryPointHandler = messagingEntryPointHandler;
    }

    protected <T extends ViewModel> T create(String key, Class<T> modelClass, SavedStateHandle handle) {
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.checkNotNullParameter(modelClass, "modelClass");
        Intrinsics.checkNotNullParameter(handle, "handle");
        return new MessagingScreenViewModel(this.messagingEntryPointHandler, null, handle, 2, null);
    }
}
