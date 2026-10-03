package zendesk.messaging.android.internal.messagingscreen;

import androidx.fragment.app.FragmentManager;
import dagger.internal.Factory;
import javax.inject.Provider;

public final class MessagingNavigator_Factory implements Factory<MessagingNavigator> {
    private final Provider<Integer> fragmentContainerProvider;
    private final Provider<FragmentManager> supportFragmentManagerProvider;

    public MessagingNavigator_Factory(Provider<FragmentManager> provider, Provider<Integer> provider2) {
        this.supportFragmentManagerProvider = provider;
        this.fragmentContainerProvider = provider2;
    }

    @Override
    public MessagingNavigator get() {
        return newInstance(this.supportFragmentManagerProvider.get(), this.fragmentContainerProvider.get().intValue());
    }

    public static MessagingNavigator_Factory create(Provider<FragmentManager> provider, Provider<Integer> provider2) {
        return new MessagingNavigator_Factory(provider, provider2);
    }

    public static MessagingNavigator newInstance(FragmentManager fragmentManager, int i) {
        return new MessagingNavigator(fragmentManager, i);
    }
}
