package zendesk.messaging.android.internal.p023di;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.BindsInstance;
import dagger.Subcomponent;
import kotlin.Metadata;
import zendesk.messaging.android.internal.messagingscreen.MessagingActivity;
import zendesk.messaging.android.internal.messagingscreen.p024di.MessagingNavigatorModule;

@MessagingActivityScope
@Subcomponent(modules = {MessagingScreenModule.class, MessagingNavigatorModule.class})
@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\ba\u0018\u00002\u00020\u0001:\u0001\u0006J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H&¨\u0006\u0007"}, m18d2 = {"Lzendesk/messaging/android/internal/di/MessagingActivityComponent;", "", "inject", "", "messagingActivity", "Lzendesk/messaging/android/internal/messagingscreen/MessagingActivity;", "Factory", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface MessagingActivityComponent {
    void inject(MessagingActivity messagingActivity);

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J(\u0010\u0002\u001a\u00020\u00032\b\b\u0001\u0010\u0004\u001a\u00020\u00052\b\b\u0001\u0010\u0006\u001a\u00020\u00072\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\tH&¨\u0006\n"}, m18d2 = {"Lzendesk/messaging/android/internal/di/MessagingActivityComponent$Factory;", "", "create", "Lzendesk/messaging/android/internal/di/MessagingActivityComponent;", "activity", "Landroidx/appcompat/app/AppCompatActivity;", "savedStateRegistryOwner", "Landroidx/savedstate/SavedStateRegistryOwner;", "defaultArgs", "Landroid/os/Bundle;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Subcomponent.Factory
    public interface Factory {
        MessagingActivityComponent create(@BindsInstance AppCompatActivity activity, @BindsInstance SavedStateRegistryOwner savedStateRegistryOwner, @BindsInstance Bundle defaultArgs);

        @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class DefaultImpls {
            public static MessagingActivityComponent create$default(Factory factory, AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle, int i, Object obj) {
                if (obj != null) {
                    throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: create");
                }
                if ((i & 4) != 0) {
                    bundle = null;
                }
                return factory.create(appCompatActivity, savedStateRegistryOwner, bundle);
            }
        }
    }
}
