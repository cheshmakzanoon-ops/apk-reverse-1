package zendesk.messaging.android.internal.messagingscreen.p024di;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;

public final class MessagingNavigatorModule_ProvideFragmentManagerFactory implements Factory<FragmentManager> {
    private final Provider<AppCompatActivity> activityProvider;
    private final MessagingNavigatorModule module;

    public MessagingNavigatorModule_ProvideFragmentManagerFactory(MessagingNavigatorModule messagingNavigatorModule, Provider<AppCompatActivity> provider) {
        this.module = messagingNavigatorModule;
        this.activityProvider = provider;
    }

    @Override
    public FragmentManager get() {
        return provideFragmentManager(this.module, this.activityProvider.get());
    }

    public static MessagingNavigatorModule_ProvideFragmentManagerFactory create(MessagingNavigatorModule messagingNavigatorModule, Provider<AppCompatActivity> provider) {
        return new MessagingNavigatorModule_ProvideFragmentManagerFactory(messagingNavigatorModule, provider);
    }

    public static FragmentManager provideFragmentManager(MessagingNavigatorModule messagingNavigatorModule, AppCompatActivity appCompatActivity) {
        return (FragmentManager) Preconditions.checkNotNullFromProvides(messagingNavigatorModule.provideFragmentManager(appCompatActivity));
    }
}
